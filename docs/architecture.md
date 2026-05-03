# Architecture

nimbling is a Nim library for WebAssembly <-> JavaScript interop, inspired by [wasm-bindgen](https://github.com/rustwasm/wasm-bindgen) (Rust).

---

## Motivation

**Problem**: Nim had an old/experimental wasm backend that is no longer maintained and holds the ecosystem back. Modern Nim (>= 2.0) with a C backend can generate WASM via clang or emscripten, but there is no high-level library for JS interop — no way to call JS functions from Nim or export Nim functions to JS with rich types (strings, objects, arrays).

**Solution**: `nimbling` is a two-phase system (compile-time macro + post-processing CLI) that:

1. Allows Nim code to call JavaScript functions and vice versa — via `{.wasmBindgen.}` pragma
2. Automatically generates JavaScript glue code and TypeScript declarations
3. Supports rich types (strings, arrays, objects, closures) not just numbers
4. Manages JS objects through a shared heap — stack for temporary references, slab for owned objects
5. Uses a custom section in the .wasm file to pass metadata between the macro and the CLI

---

## Two-Phase Architecture

### Phase 1: Compile-time (Nim Macro)

When the user writes:

```nim
import nimbling

proc greet(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"
```

The `wasmBindgen` macro (executed during Nim compilation) does the following:

#### 1. Parse
- Walks the Nim AST of annotated procs, types, and enums
- Extracts function signatures, parameter types, return types
- Builds an internal `Program` tree model (defined in `common.nim`)

#### 2. Codegen — Export Wrappers
For each exported proc, generates a wrapper with `{.exportc.}`:

```nim
# User code:
proc greet(name: string): string {.wasmBindgen.} = ...

# Generated wrapper:
proc __nbg_shim_greet(name_ptr: uint32, name_len: uint32): uint32 {.exportc, cdecl.} =
  # 1. Convert ptr/len -> Nim string
  var name = newString(name_len.int)
  if name_len > 0:
    copyMem(addr name[0], cast[pointer](name_ptr), name_len.int)
  # 2. Call the real function
  let ret = greet(name)
  # 3. Convert Nim string -> boxed ptr
  let dataLen = uint32(ret.len)
  var dataPtr: uint32 = 0
  if dataLen > 0:
    dataPtr = cast[uint32](nbgMalloc(dataLen, 1))
    copyMem(cast[pointer](dataPtr), unsafeAddr ret[0], int(dataLen))
  let boxPtr = cast[uint32](nbgMalloc(8, 4))
  cast[ptr uint32](cast[pointer](boxPtr))[] = dataPtr
  cast[ptr uint32](cast[pointer](cast[uint](boxPtr) + 4))[] = dataLen
  return boxPtr
```

#### 3. Describe — Type Descriptors
Generates `__nbg_describe_*` functions that describe the type signature:

```nim
proc __nbg_describe_greet() {.exportc, cdecl.} =
  __nbg_describe(TY_STRING)   # first argument: string
  __nbg_describe(TY_STRING)   # result: string
```

These functions are executed by the CLI via a stack-machine interpreter to recover exact types.

#### 4. Encode — Serialization
Serializes the entire `Program` descriptor (exports, imports, enums, structs, inline JS, linked modules) to binary format using varint (LEB128) encoding.

#### 5. Embed — Custom Section
Embeds the serialized data as a custom section `__nimbling_unstable` in the .wasm file via `{.emit.}` directives or linker sections.

### Phase 2: Post-processing (CLI Tool)

```bash
nimbling target.wasm --out-dir pkg/ --target bundler
```

#### Pipeline

```
.wasm file
  |
  +-> Parse wasm binary --> Extract custom sections
  |
  +-> Extract "__nimbling_unstable" section
  |
  +-> Decode Program (varint -> Nim objects)
  |
  +-> Execute __nbg_describe_* functions (stack-machine interpreter)
  |     +-> Recover exact type descriptors for each import/export
  |
  +-> Generate JS glue code:
  |     +-> Heap management (addHeapObject, dropObject, passStringToWasm)
  |     +-> Import shims (JS -> Wasm calling convention)
  |     +-> Export shims (Wasm -> JS calling convention)
  |     +-> Module init (instantiate + start)
  |
  +-> Emit files:
        +-> {name}.js          -- JavaScript glue module
        +-> {name}_bg.wasm     -- transformed Wasm module
        +-> {name}.d.ts        -- TypeScript declarations
        +-> snippets/          -- inline JS fragments
```

---

## JS Object Heap — How It Works

Wasm modules work only with numbers (i32, i64, f32, f64). To pass JS objects (functions, objects, arrays) a shared heap array is used in the generated JS code:

```
                    +-------------------+
 JS Object ------>  | heap[132..N]      |  slab (owned objects)
                    | heap[0..127]      |  stack (temporary references)
                    +-------------------+
                            |
                     idx: u32 (index)
                            |
                    +-------+--------+
                    | Nim: JsValue   |
                    |   idx: uint32  |
                    +----------------+
```

- **Stack** (left side of array, grows downward): Temporary/borrowed references for a single function call. Push on entry, pop on exit.
- **Slab** (right side, free list): Owned objects with arbitrary lifetime. `addHeapObject` allocates a slot, `dropObject` frees it. Implemented via `heap_next` pointer and intrusive free list.

### Nim side: JsValue

```nim
type
  JsValue* = object
    idx*: uint32

proc `=destroy`*(v: var JsValue) =
  when defined(wasm32):
    # Signals to JS that the object is no longer needed
    {.emit: "__nbg_object_drop_ref(`v`.idx);".}
```

---

## Custom Section Binary Format

Uses varint (LEB128) encoding for compactness:

```
custom_section {
  name_len:    varuint32
  name:        "__nimbling_unstable"
  payload: {
    schema_version:       varint32_string
    exports:              vec<Export>
    enums:                vec<NimEnum>
    imports:              vec<Import>
    structs:              vec<NimStruct>
    typescript_sections:  vec<LitOrExpr>
    local_modules:        vec<LocalModule>
    inline_js:            vec<string>
    unique_crate_id:      string
    package_json:         option<string>
    linked_modules:       vec<LinkedModule>
  }
}
```

Each primitive type is encoded as:
- `bool` -> 1 byte (0 or 1)
- `u32/int` -> varint (1-5 bytes LEB128)
- `string` -> varint(len) + bytes
- `seq<T>` -> varint(len) + elements
- `Option<T>` -> 1 byte (0 = none, 1 = some) + optional element

---

## Type Conversions

| Nim Type | Wasm ABI | JS Glue Conversion |
|----------|----------|-------------------|
| `cint`, `int32` | i32 | direct |
| `float64` | f64 | direct |
| `bool` | i32 (0/1) | direct |
| `string` | (ptr: i32, len: i32) | TextEncoder / TextDecoder |
| `JsValue` (borrowed) | idx: i32 | addBorrowedObject / stack pop |
| `JsValue` (owned) | idx: i32 | addHeapObject / dropObject |
| `seq[T]` | (ptr: i32, len: i32) | TypedArray |
| `Option[T]` | (tag: i32, val) | null check |
| `Closure[T]` | idx: i32 | addHeapObject + function wrapper |
| `ref object` | idx: i32 | addHeapObject / JS proxy |

---

## Module Structure

```
src/
+-- nimbling.nim                 # Main module — re-exports public API
+-- nimbling/
    +-- common.nim               # Constants, Program schema, helper functions
    |   - Type ID definitions (36 constants: TY_I8..TY_RAW_POINTER)
    |   - Program AST: Export, Import, FunctionDesc, NimEnum, NimStruct...
    |   - Name mangling: newFunction(), structFieldGet(), qualifiedName()
    |   - SchemaVersion = "0.1.0"
    |
    +-- runtime.nim              # JsValue, Closure, nbgMalloc/nbgFree
    |   - JsValue = object(idx: uint32) with `=destroy` hook
    |   - Bump allocator (1MB static heap) for wasm32
    |   - Boxed string helpers (__nbg_boxed_str_ptr/len/free)
    |
    +-- macroimpl.nim            # {.wasmBindgen.} pragma macro
    |   - AST parsing of annotated procs
    |   - Export wrapper generation (ptr/len ABI conversion)
    |   - Descriptor function generation
    |
    +-- codegen.nim              # Type mapping & code generation helpers
    |   - nimTypeToTyId() — maps Nim types to TY_* constants
    |   - parseFormalParams() — handles multi-name param defs
    |   - classifyArgType() — string/number/boolean/jsvalue
    |
    +-- encode.nim               # Binary encode of Program (varint LEB128)
    |   - Encoder object with putByte() and varint32()
    |   - encode() overloads for all Program types
    |
    +-- decode.nim               # Binary decode of Program
    |   - Decoder object with readByte() and readVarint32()
    |   - decodeProgram() — full roundtrip
    |
    +-- describe.nim             # Type descriptor system
    |   - Descriptor object (kind + inner/funcDesc/nameStr fields)
    |   - FunctionDescriptor, ClosureDescriptor types
    |   - decode() from u32 stream (output of stack-machine interpreter)
    |
    +-- cli.nim                  # CLI tool — reads .wasm, generates JS
    |   - CLI argument parsing (--out-dir, --target, --debug...)
    |   - extractCustomSection() — binary wasm parsing
    |   - Integration with jsgen.nim for output generation
    |
    +-- jsgen.nim                # JavaScript glue code generator
        - JsGen object with indent/dedent/addLine
        - generateHelpers() — heap, string, memory utilities
        - generateImportShim() — JS shim for imported functions
        - generateExportShim() — JS wrapper for exported functions
        - Target support: bundler, web, no-modules, nodejs, deno
```

---

## Nimble Tasks

| Command | Description |
|---------|-------------|
| `nimble test` | Run 20 unit tests |
| `nimble buildCli` | Build CLI binary (release, ~200KB) |
| `nimble wasm` | Build hello example for wasm target |

---

## Comparison with wasm-bindgen

| Feature | wasm-bindgen (Rust) | nimbling (Nim) |
|---------|---------------------|----------------|
| Macro system | proc-macro (`#[wasm_bindgen]`) | Nim pragma macro (`{.wasmBindgen.}`) |
| Custom section | `__wasm_bindgen_unstable` | `__nimbling_unstable` |
| Type descriptors | `__wbindgen_describe_*` | `__nbg_describe_*` |
| JS function prefix | `__wbg_` | `__nbg_` |
| JS heap | `addHeapObject`/`dropObject` | identical |
| Schema version | `0.2.119` | `0.1.0` |
| CLI | `wasm-bindgen` (Rust binary) | `nimbling` (Nim binary) |
| web-sys | Yes (~100 Web APIs) | Planned |
| Test runner | Yes (browser/Node/Deno) | Planned |
