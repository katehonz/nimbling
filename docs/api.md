# API Reference

## Core Types

### `JsValue`

A handle to a JavaScript object stored in the JS heap.

```nim
type
  JsValue* = object
    idx*: uint32
```

- Automatically calls `__nbg_object_drop_ref` on destruction (when `wasm32`)
- Copy uses explicit `=copy` hook (clones heap reference on `wasm32`, shallow copy otherwise)
- Use `JsValue.fromIdx(idx)` to create from a raw heap index

### `Closure[T]`

A handle to a JavaScript closure (function wrapper).

```nim
type
  Closure*[T] = object
    idx*: uint32
```

---

## The `{.wasmBindgen.}` Pragma

The main entry point. Annotate a proc to export it to JavaScript:

```nim
import nimbling

proc greet(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"

proc add(a, b: int32): int32 {.wasmBindgen.} =
  result = a + b
```

### What It Generates

For each annotated proc, the macro generates (inside `when defined(wasm32)`):

1. **`__nbg_shim_<name>`** — An `{.exportc, cdecl.}` wrapper that handles ABI conversion:
   - `string` args: receives `(ptr: uint32, len: uint32)`, constructs Nim string
   - `string` returns: allocates boxed string struct `{data_ptr, data_len}` via `nbgMalloc`
   - Numeric types (`int32`, `float64`, `bool`): direct passthrough

2. **`__nbg_describe_<name>`** — A descriptor function that emits type IDs for the CLI interpreter:
   - Calls `__nbg_describe(TY_*)` for each argument and the return type

### Supported Types

| Nim Type | Type ID | ABI |
|----------|---------|-----|
| `int8` | `TY_I8` (0) | i32 |
| `uint8`, `byte` | `TY_U8` (1) | i32 |
| `int16` | `TY_I16` (2) | i32 |
| `uint16` | `TY_U16` (3) | i32 |
| `int32`, `cint` | `TY_I32` (4) | i32 |
| `uint32`, `cuint` | `TY_U32` (5) | i32 |
| `int64` | `TY_I64` (6) | i64 |
| `uint64` | `TY_U64` (7) | i64 |
| `float32` | `TY_F32` (12) | f32 |
| `float64` | `TY_F64` (13) | f64 |
| `bool` | `TY_BOOLEAN` (14) | i32 |
| `string` | `TY_STRING` (18) | (ptr, len) |
| `JsValue` | `TY_EXTERNREF` (24) | i32 (heap idx) |

### Attributes

| Attribute | Description |
|-----------|-------------|
| `jsName` | Rename the JS export |
| `getter` / `setter` | Property accessors on the JS side |
| `constructor` | Mark as JS constructor |
| `catch` | Wrap in try/catch, emit JS exception |
| `variadic` | Variable argument list |
| `structural` | Structural property access |
| `start` | Auto-call at module init |
| `private` | Hide from JS exports |
| `inspectable` | Add `toString` to JS class |
| `skipTypescript` | Skip .d.ts generation |

---

## `wasmBindgenType` & `wasmBindgenFinalize`

### `wasmBindgenType`

Annotate a Nim object or enum for JS exposure:

```nim
type
  Point* {.wasmBindgenType.} = object
    x*, y*: float64

  Color* {.wasmBindgenType.} = enum
    Red, Green, Blue
```

### `wasmBindgenFinalize`

Must be called once after all annotations. Embeds the `Program` metadata as a custom wasm section:

```nim
wasmBindgenFinalize()
```

---

## `webidlBind` Macro — Compile-Time WebIDL Generator

Parses WebIDL definitions at compile time and generates Nim types + `{.emit.}` proc wrappers:

```nim
import nimbling/runtime, nimbling/macroimpl_webidl

webidlBind("""
  interface Node {
    readonly attribute unsigned short nodeType;
    attribute DOMString? nodeName;
    Node appendChild(Node newChild);
    static Document createDocument();
  };
  interface Document {
    Element getElementById(DOMString id);
    Element createElement(DOMString tag);
  };
  dictionary ScrollOptions {
    required ScrollBehavior behavior;
    boolean optional;
  };
  enum ScrollBehavior { "auto", "instant", "smooth" };
  namespace console {
    void log(any data);
  };
""")
```

### Generated Output

For each WebIDL construct, the macro generates:

**Interfaces** → `type X = distinct JsValue` + methods:
```nim
type Node = distinct JsValue

proc nodeType*(self: Node): uint32 =
  when defined(wasm32):
    {.emit: "`result` = heap[`self`.idx].nodeType;".}
  else:
    result = 0

proc appendChild*(self: Node, newChild: Node): Node =
  when defined(wasm32):
    {.emit: """
    var ret = heap[`self`.idx].appendChild(heap[`newChild`.idx]);
    `result` = {idx: addHeapObject(ret)};
    """.}
  else:
    result = Node(JsValue(idx: 0))
```

**Namespaces** → standalone procs:
```nim
proc log*(data: JsValue) =
  when defined(wasm32):
    {.emit: "console.log(heap[`data`.idx]);".}
  else:
    discard
```

**Dictionaries** → type + getter/setter pairs. **Enums** → type aliases.

### WebIDL → Nim Type Mapping

| WebIDL Type | Nim Type |
|-------------|----------|
| `boolean` | `bool` |
| `byte`, `octet` | `uint8` |
| `short` | `int16` |
| `unsigned short` | `uint16` |
| `long`, `int` | `int32` |
| `unsigned long` | `uint32` |
| `long long` | `int64` |
| `unsigned long long` | `uint64` |
| `float`, `unrestricted float` | `float32` |
| `double`, `unrestricted double` | `float64` |
| `DOMString`, `USVString`, `ByteString` | `string` |
| `void` | (no return) |
| Other identifiers | as-is (assumed DOM type, e.g. `Element`, `Node`) |

---

## Runtime Functions

These are wasm exports provided by `runtime.nim` (only available under `defined(wasm32)`):

### Memory Allocation

```nim
proc nbgMalloc*(size: uint32, align: uint32): ptr UncheckedArray[byte]
  ## Allocate `size` bytes with `align` alignment.
  ## Uses a bump allocator over a 1MB static heap.

proc nbgFree*(p: pointer, size: uint32, align: uint32)
  ## Free memory (no-op for bump allocator).
```

### Boxed String Helpers

```nim
proc nbgBoxedStrPtr*(handle: uint32): uint32
proc nbgBoxedStrLen*(handle: uint32): uint32
proc nbgBoxedStrFree*(handle: uint32)
```

Boxed string memory layout:
```
[handle] -> [data_ptr: u32][data_len: u32]
               |
               +-> [string bytes...]
```

---

## CLI Tool

### Usage

```bash
nimbling <input.wasm> [options]
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `--out-dir, -o <dir>` | Output directory | `pkg` |
| `--target, -t <target>` | Target platform | `bundler` |
| `--debug, -d` | Enable debug output | off |
| `--no-typescript` | Skip .d.ts generation | off |

### Targets

| Target | Description |
|--------|-------------|
| `bundler` | ES module with imports from wasm (webpack/vite compatible) |
| `web` | Native ES modules for direct browser use |
| `no-modules` | Classic script, no module system |
| `nodejs` | Node.js CommonJS |
| `deno` | Deno module |

### Output Files

```
pkg/
+-- {name}.js          # JavaScript glue module
+-- {name}_bg.wasm     # Wasm module (copied)
+-- {name}.d.ts        # TypeScript declarations
```

---

## JavaScript Glue API

The generated `{name}.js` module exports:

### `init(input)`

Async function to initialize the wasm module.

```javascript
import init, { greet } from './hello.js';

await init(fetch('./hello_bg.wasm'));
console.log(greet("World")); // "Hello, World!"
```

### Exported Functions

Each `{.wasmBindgen.}` annotated proc becomes a JS function:

```javascript
// For string functions:
export function greet(arg0) {
  const [ptr0, len0] = passStringToWasm(arg0);
  const ret = wasm.__nbg_shim_greet(ptr0, len0);
  const rptr = wasm.__nbg_boxed_str_ptr(ret);
  const rlen = wasm.__nbg_boxed_str_len(ret);
  const realRet = getStringFromWasm(rptr, rlen);
  wasm.__nbg_boxed_str_free(ret);
  wasm.__nbg_free(ptr0, len0, 1);
  return realRet;
}

// For numeric functions:
export function add(arg0, arg1) {
  return wasm.__nbg_shim_add(arg0, arg1);
}
```

---

## Program Schema

The `Program` object (defined in `common.nim`) represents the full metadata:

```nim
type
  Program* = object
    exports*: seq[Export]
    enums*: seq[NimEnum]
    imports*: seq[Import]
    structs*: seq[NimStruct]
    typescriptCustomSections*: seq[LitOrExpr]
    localModules*: seq[LocalModule]
    inlineJs*: seq[string]
    uniqueCrateIdentifier*: string
    packageJson*: Option[string]
    linkedModules*: seq[LinkedModule]
```

This is serialized to binary (varint LEB128) and embedded as a custom wasm section named `__nimbling_unstable`.
