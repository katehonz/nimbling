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

# Must be called once per module after all wasmBindgen procs
wasmBindgenFinalize()
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
| `js-sys` bindings (526 procs, 42 types, 30+ APIs) | `js_sys.nim` | Done |
| `web-sys` bindings (~472 procs, 27 APIs, hand-written) | `web_sys.nim` | Done |
| `web-sys` generated (4,734 procs, ~2,870 types, 644 WebIDL files, ~500+ APIs) | `web_sys_generated.nim` | Done |
| Test framework (browser/Node/Deno) | `test_runner.nim` | Done |
| Emscripten / Memory64 support | `emscripten.nim` | Done |
| Unit tests (372 tests, all passing) | `tests/all.nim` | Done |

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

### Known Limitations

| Area | Status | Notes |
|------|--------|-------|
| End-to-end pipeline | ✅ Stable | Compiles to C for `wasm32`; full `C → WASM → CLI → JS` verified with wasi-sdk / emscripten |
| `web_sys_generated.nim` | ✅ Done | 4,734 procs with real `{.emit.}` blocks from 644 WebIDL files (1.1 MB), covering ~500+ Web APIs |
| `wasmBindgenFinalize()` | By design | Must be called once per module to embed the custom wasm section |
| Emscripten CLI flags | ✅ Stable | All core targets and flags wired to CLI |

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
| `nimble test` | Run unit tests (372 tests) |
| `nimble buildCli` | Build CLI binary (release mode) |
| `nimble wasm` | Build hello example for wasm (requires wasi-sdk) |

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
│       ├── js_sys.nim           # js-sys: 228 procs, 20 JS APIs
│       ├── web_sys.nim          # web-sys: ~472 procs, 27 Web APIs (hand-written)
│       ├── web_sys_generated.nim # web-sys: 4,734 procs, ~500+ APIs (auto-generated)
│       ├── webidl.nim           # WebIDL parser → Nim codegen
│       ├── wit.nim              # WIT adapter system
│       └── emscripten.nim       # Emscripten + Memory64 support
├── tests/
│   └── all.nim                  # Unit test suite (333 tests)
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
| web-sys | Yes (~100 Web APIs) | Done (~500+ Web APIs, 4,734 procs, 644 WebIDL files) |
| Test runner | Yes (browser/Node/Deno) | Done |
| WebIDL macro | No | **Yes** — compile-time `webidlBind` |
| js-sys | ~1,438 procs | 526 procs (42 types, 30+ APIs) |

## Real-World Examples

The [NimLeptos](https://github.com/katehonz/brenan/tree/main/nimleptos) framework uses `nimbling` for WebAssembly/JS interop in production-like applications. See the [`nimleptos/examples`](https://github.com/katehonz/brenan/tree/main/nimleptos/examples) directory for:

### Featured: `wasm_counter`

The [`wasm_counter`](https://github.com/katehonz/brenan/tree/main/nimleptos/examples/wasm_counter) example is the most complete end-to-end demo. It shows:

- **Reactive signals** (`createSignal`, `createMemo`, `createEffect`) running in WASM
- **Emscripten build** with `build.sh` — compiles Nim → C → wasm via `emcc`
- **EM_ASM DOM helpers** — direct DOM manipulation from Nim through Emscripten macros
- **JS ↔ WASM interop** — exported procs (`increment`, `decrement`, `render`) called from HTML via `Module.ccall`
- **Polished HTML demo** (`index.html`) with CSS animations and reactive hot-state

```bash
cd nimleptos/examples/wasm_counter
./build.sh        # Requires Emscripten SDK
firefox index.html
```

### Other Examples

| Example | Description |
|---------|-------------|
| [`counter`](https://github.com/katehonz/brenan/tree/main/nimleptos/examples/counter) | Minimal counter example |
| [`blog`](https://github.com/katehonz/brenan/tree/main/nimleptos/examples/blog) | Fullstack blog with Nim backend + wasm frontend |
| [`todo_app.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/todo_app.nim) | Todo app server |
| [`wasm_reactive.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/wasm_reactive.nim) + [`wasm_reactive.html`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/wasm_reactive.html) | Reactive wasm DOM updates |
| [`conditional_client.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/conditional_client.nim) + [`conditional_client.html`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/conditional_client.html) | Conditional rendering example |
| [`hybrid_client.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/hybrid_client.nim) + [`hybrid_client.html`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/hybrid_client.html) | Hybrid server + client rendering |
| [`server_app.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/server_app.nim) | Full server application |

## License

MIT

---

Built with Nim and AI assistance
