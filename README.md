# nimbling

**Nim to WebAssembly / JavaScript bindings — like `wasm-bindgen` for Nim**

`nimbling` is a two-phase build-time and post-processing library that enables Nim code to call JavaScript functions and JavaScript code to call Nim functions through WebAssembly. It automatically generates JS glue code, TypeScript declarations, and manages the conversion of complex types (strings, objects, closures) between the two environments.

> **[README на български](README_BG.md)**

## Why?

Nim had an old/experimental WASM backend that held the ecosystem back. The modern Nim compiler (>= 2.0) with a C backend can generate WASM via clang/emscripten, but there is **no library for high-level JS interop**. `nimbling` fills this gap.

Inspired by [wasm-bindgen](https://github.com/rustwasm/wasm-bindgen) (Rust) — the architecture is adapted 1:1 for Nim.

## How It Works

### Phase 1 — Compile-time (Nim Macro)

```nim
import nimbling

proc greet(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"
```

The `wasmBindgen` macro at compile time:
1. **Parse** — analyzes the Nim AST of annotated procs
2. **Codegen** — generates `{.exportc.}` wrapper functions (converts ptr/len to/from Nim types)
3. **Describe** — generates `__nbg_describe_*` functions describing the types
4. **Encode** — serializes the Program descriptor to binary (varint LEB128)
5. **Embed** — embeds the data as a custom section `__nimbling_unstable` in the `.wasm` file

### Phase 2 — Post-processing (CLI Tool)

```bash
nimbling target.wasm --out-dir pkg/ --target bundler
```

The CLI reads the `.wasm`, extracts the custom section, decodes the Program descriptor, and generates:
- `{name}.js` — JavaScript glue module (heap management, import/export shims)
- `{name}_bg.wasm` — transformed Wasm module
- `{name}.d.ts` — TypeScript declarations

### JS Object Heap

Since Wasm works only with numbers, JS objects are passed through a shared heap array:

```
JS object -> addHeapObject(obj) -> idx: u32 -> Nim: JsValue(idx: u32)
```

- **Stack** — temporary/borrowed references (push/pop for each function call)
- **Slab** — owned objects with dynamic lifetime (reference counting)

## Status — v0.1.0 (Schema v0.2.0)

### Working (compiles and tested on Nim 2.2.10)

| Component | File | Status |
|-----------|------|--------|
| Type ID constants (36 types) | `common.nim` | Done |
| Program schema (all AST types) | `common.nim` | Done |
| Binary encode (varint LEB128) | `encode.nim` | Done |
| Binary decode (full roundtrip) | `decode.nim` | Done |
| LEB128 utilities (shared) | `leb128.nim` | Done |
| Type descriptor system | `describe.nim` | Done |
| `{.wasmBindgen.}` pragma macro | `macroimpl.nim` | Done |
| Closure support | `macroimpl_closure.nim` | Done |
| Async/Promise support | `macroimpl_async.nim` | Done |
| 11 wasmBindgen attributes | `macroimpl_attrs.nim` | Done |
| Type mapping & codegen helpers | `codegen.nim` | Done |
| JS glue generator (5 targets) | `jsgen.nim` | Done |
| JsValue + Runtime (heap, allocator) | `runtime.nim` | Done |
| CLI tool (wasm section extractor) | `cli.nim` | Done |
| Wasm stack-machine interpreter | `interp.nim` | Done |
| Wasm binary transforms (externref, multivalue, catch, threads) | `transforms.nim` | Done |
| WIT adapter system (30 instruction types) | `wit.nim` | Done |
| WebIDL parser → Nim codegen | `webidl.nim` | Done |
| **WebIDL compile-time macro** | **`macroimpl_webidl.nim`** | **Done** |
| `js-sys` bindings (192 procs, 20 APIs) | `js_sys.nim` | Done |
| `web-sys` bindings (112 procs, 27 APIs) | `web_sys.nim` | Done |
| Test framework (browser/Node/Deno) | `test_runner.nim` | Done |
| Emscripten / Memory64 support | `emscripten.nim` | Done |
| Unit tests (134 tests, all passing) | `tests/all.nim` | Done |

### `webidlBind` — Compile-Time WebIDL Macro

Generate Nim bindings directly from WebIDL at compile time:

```nim
import nimbling/runtime, nimbling/macroimpl_webidl

webidlBind("""
  interface Node {
    readonly attribute unsigned short nodeType;
    Node appendChild(Node newChild);
    static Document createDocument();
  };
  interface Document {
    Element getElementById(DOMString id);
  };
""")

# Now use: var n = Node(JsValue(idx: 0)); echo nodeType(n)
```

Generates `type Node = distinct JsValue`, attribute getters/setters, method calls — all with `{.emit.}` blocks following the same pattern as `web_sys.nim`.

## Quick Start

```bash
# Clone
git clone https://github.com/katehonz/nimbling.git
cd nimbling

# Run tests
nimble test

# Build CLI
nimble buildCli

# Use the CLI
./src/nimbling/cli input.wasm --out-dir pkg/ --target bundler
```

### Nimble Tasks

| Command | Description |
|---------|-------------|
| `nimble test` | Run unit tests (134 tests) |
| `nimble buildCli` | Build CLI binary (release mode) |
| `nimble wasm` | Build hello example for wasm |

## Project Structure

```
nimbling/
├── README.md                    # This file
├── README_BG.md                 # Bulgarian README
├── DESIGN.md                    # Architecture documentation (Bulgarian)
├── ROADMAP.md                   # Full roadmap with all tiers
├── LICENSE                      # MIT License
├── nimbling.nimble              # Nimble package manifest
├── docs/
│   ├── architecture.md          # Architecture deep-dive
│   ├── api.md                   # API reference
│   └── contributing.md          # Contribution guide
├── src/
│   ├── nimbling.nim             # Library entry point
│   └── nimbling/
│       ├── common.nim           # Shared types, constants, Program schema
│       ├── leb128.nim           # LEB128 encode/decode utilities
│       ├── encode.nim           # Binary encoder (varint LEB128)
│       ├── decode.nim           # Binary decoder
│       ├── describe.nim         # Type descriptor system
│       ├── runtime.nim          # JsValue, Closure, memory management
│       ├── macroimpl.nim        # {.wasmBindgen.} pragma macro
│       ├── macroimpl_closure.nim # Closure support
│       ├── macroimpl_async.nim  # Async/Promise support
│       ├── macroimpl_attrs.nim  # 11 wasmBindgen attributes
│       ├── macroimpl_webidl.nim # Compile-time WebIDL → Nim macro
│       ├── codegen.nim          # Type mapping & codegen helpers
│       ├── cli.nim              # CLI tool
│       ├── jsgen.nim            # JavaScript glue generator
│       ├── interp.nim           # Wasm stack-machine interpreter
│       ├── transforms.nim       # Wasm binary transforms
│       ├── js_sys.nim           # js-sys: 192 procs, 20 JS APIs
│       ├── web_sys.nim          # web-sys: 112 procs, 27 Web APIs
│       ├── webidl.nim           # WebIDL parser → Nim codegen
│       ├── wit.nim              # WIT adapter system
│       └── emscripten.nim       # Emscripten + Memory64 support
├── tests/
│   └── all.nim                  # Unit test suite (134 tests)
├── examples/
│   └── hello/                   # Hello World example
│       ├── hello.nim
│       ├── hello.nimble
│       └── panicoverride.nim
└── OLD/                         # Reference: wasm-bindgen (Rust) source
```

## Type Conversions

| Nim Type | Wasm ABI | JS Glue Conversion |
|----------|----------|-------------------|
| `int32`, `cint` | i32 | direct |
| `float64` | f64 | direct |
| `bool` | i32 (0/1) | direct |
| `string` | (ptr: i32, len: i32) | TextEncoder / TextDecoder |
| `JsValue` (borrowed) | idx: i32 | addBorrowedObject / stack pop |
| `JsValue` (owned) | idx: i32 | addHeapObject / dropObject |
| `seq[T]` | (ptr: i32, len: i32) | TypedArray |
| `Option[T]` | (tag: i32, val) | null check |
| `Closure[T]` | idx: i32 | addHeapObject + function wrapper |

## Comparison with wasm-bindgen

| Feature | wasm-bindgen (Rust) | nimbling (Nim) |
|---------|---------------------|----------------|
| Macro system | proc-macro (`#[wasm_bindgen]`) | Nim pragma macro (`{.wasmBindgen.}`) |
| Custom section | `__wasm_bindgen_unstable` | `__nimbling_unstable` |
| Type descriptors | `__wbindgen_describe_*` | `__nbg_describe_*` |
| JS function prefix | `__wbg_` | `__nbg_` |
| JS heap | `addHeapObject`/`dropObject` | identical |
| Schema version | `0.2.119` | `0.2.0` |
| CLI | `wasm-bindgen` (Rust binary) | `nimbling` (Nim binary) |
| web-sys | Yes (~100 Web APIs) | Done (27 Web APIs, expandable via WebIDL) |
| Test runner | Yes (browser/Node/Deno) | Done |
| WebIDL macro | No | **Yes** — compile-time `webidlBind` |
| js-sys | ~250 procs | 192 procs (20 APIs) |

## License

MIT

---

Built with Nim and AI assistance
