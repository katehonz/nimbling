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

## Status — v0.1.0

### Working (compiles and tested on Nim 2.2.10)

| Component | File | Status |
|-----------|------|--------|
| Type ID constants (36 types) | `common.nim` | Done |
| Program schema (all AST types) | `common.nim` | Done |
| Binary encode (varint LEB128) | `encode.nim` | Done |
| Binary decode (full roundtrip) | `decode.nim` | Done |
| Type descriptor system | `describe.nim` | Done |
| `{.wasmBindgen.}` pragma macro | `macroimpl.nim` | Done |
| Type mapping & codegen helpers | `codegen.nim` | Done |
| JS glue generator (bundler/web/node/deno) | `jsgen.nim` | Done |
| JsValue + Runtime (heap, allocator, boxed strings) | `runtime.nim` | Done |
| CLI tool (wasm section extractor) | `cli.nim` | Done |
| Unit tests (20 tests, all passing) | `tests/all.nim` | Done |

### Roadmap

| Task | Priority | Description |
|------|----------|-------------|
| Stack-machine interpreter | High | CLI executes `__nbg_describe_*` from .wasm for type recovery |
| `seq[T]` / `Option[T]` support | Medium | TypedArray conversion, null check |
| Closure support | Medium | JS callbacks -> Nim, Nim closures -> JS |
| Struct import/export | Low | `{.wasmBindgen.}` on Nim objects -> JS classes |
| Enum import/export | Low | Nim enums <-> JS string/number enums |
| `web-sys` equivalent | Low | Auto-generated Web API bindings from WebIDL |
| Test framework | Low | `wasm-bindgen-test` equivalent for browser/node |

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
| `nimble test` | Run unit tests (20 tests) |
| `nimble buildCli` | Build CLI binary (release mode) |
| `nimble wasm` | Build hello example for wasm |

## Project Structure

```
nimbling/
├── README.md                    # This file
├── README_BG.md                 # Bulgarian README
├── DESIGN.md                    # Architecture documentation (Bulgarian)
├── LICENSE                      # MIT License
├── nimbling.nimble              # Nimble package manifest
├── docs/
│   ├── architecture.md          # Architecture deep-dive
│   ├── api.md                   # API reference
│   └── contributing.md          # Contribution guide
├── src/
│   ├── nimbling.nim             # Library entry point
│   └── nimbling/
│       ├── common.nim           # Shared types & constants
│       ├── runtime.nim          # JsValue, memory management
│       ├── macroimpl.nim        # {.wasmBindgen.} macro
│       ├── codegen.nim          # Type mapping & codegen helpers
│       ├── encode.nim           # Binary encoder (varint LEB128)
│       ├── decode.nim           # Binary decoder
│       ├── describe.nim         # Type descriptors
│       ├── cli.nim              # CLI tool
│       └── jsgen.nim            # JavaScript glue generator
├── tests/
│   └── all.nim                  # Unit test suite
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
| Schema version | `0.2.119` | `0.1.0` |
| CLI | `wasm-bindgen` (Rust binary) | `nimbling` (Nim binary) |
| web-sys | Yes (~100 Web APIs) | Planned |
| Test runner | Yes (browser/Node/Deno) | Planned |

## License

MIT

---

Built with Nim and AI assistance
