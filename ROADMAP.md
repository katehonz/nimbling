# nimbling — Roadmap to Beat Rust's wasm-bindgen

## Current Status (Tier 0 — Done)

| Component | Lines | Status |
|-----------|-------|--------|
| `common.nim` — types, Program schema, 36 type IDs | 275 | ✅ |
| `encode.nim` — binary encoder (varint LEB128) | 194 | ✅ |
| `decode.nim` — binary decoder (roundtrip) | 313 | ✅ |
| `describe.nim` — type descriptor decode from u32 stream | 130 | ✅ |
| `runtime.nim` — bump allocator, boxed strings, C stubs | 73 | ✅ |
| `macroimpl.nim` — `{.wasmBindgen.}` macro + `wasmBindgenFinalize` | 300 | ✅ |
| `codegen.nim` — type mapping + ABI conversion helpers | 130 | ✅ |
| `jsgen.nim` — JS glue generator, 56 intrinsics, 5 targets | 600 | ✅ |
| `cli.nim` — CLI tool, wasm section extraction + interpreter | 230 | ✅ |
| `interp.nim` — wasm stack-machine interpreter | 460 | ✅ |
| `nimbling.nim` — library entry point | 40 | ✅ |
| Tests (26/26 pass) | ~440 | ✅ |
| Docs (README, README_BG, docs/) | 3 files | ✅ |
| Docs (ROADMAP.md) | this file | ✅ |
| macroimpl_closure.nim — closure support | 315 | ✅ |
| macroimpl_async.nim — async/Promise support | 231 | ✅ |
| macroimpl_attrs.nim — 11 wasmBindgen attributes | 125 | ✅ |
| **TOTAL** | **~3,400** | ✅ |

---

## Tier 1 — Real-World Usability

### 1.1 Closure Support (3 days) — ✅ DONE
**Why**: JS callbacks → Nim and Nim closures → JS. Core interop feature.

- [x] `Closure[T]` with closure type detection
- [x] Closure export wrapper generation (cast uint32 to Closure[T])
- [x] `__nbg_closure_wrapper` JS intrinsic
- [x] Descriptor encoding for `TY_CLOSURE` type
- [ ] Panic-catching in closure wrappers (deferred)
- [ ] `ScopedClosure` for borrowed lifetimes (deferred)
- [x] Tests: closure detection, JS glue generation

### 1.2 Struct/Class Export (4 days) — ✅ DONE
**Why**: Expose Nim objects as JS classes with methods, getters, setters.

- [x] `{.wasmBindgenType.}` on `object` / `ref object` types
- [ ] `IntoWasmAbi`/`FromWasmAbi` trait generation (deferred — Nim doesn't need traits)
- [x] `new`/`free` external functions
- [x] Field getter/setter via `__nbg_get_*`/`__nbg_set_*`
- [x] JS `ExportedClass` generation (constructor, prototype methods)
- [x] TypeScript class declarations
- [ ] `getter`/`setter`/`constructor`/`js_class` attributes (Phase 2)
- [x] Tests: struct field access, method calls, constructor

### 1.3 Enum Support (2 days) — ✅ DONE
**Why**: Nim enums ↔ JS string/number enums.

- [x] Integer enums — name + hole encoding
- [ ] String enums — name + variant list + invalid/hole encoding (Phase 2)
- [x] `EnumVariant` descriptor format
- [x] JS/TS enum generation (bidirectional Object.freeze)
- [ ] `#[wasm_bindgen(js_namespace = "...")]` attribute (Phase 2)
- [x] Tests: enum roundtrip, string enum, namespace

### 1.4 Async/Promise Support (2 days) — ✅ DONE
**Why**: JS Promises ↔ Nim async.

- [x] `async` proc detection in macro
- [x] `buildAsyncExportWrapper` — Future to Promise conversion
- [x] `__nbg_future_to_promise` JS glue
- [x] `isAsync` flag in FunctionDesc
- [ ] `JsFuture` type (Promise → Nim async) (deferred)
- [ ] `spawn_local` for start functions (deferred)
- [x] Tests: async detection, JS glue generation

### 1.5 Full `[wasmBindgen(...)]` Attributes (3 days) — ✅ DONE
**Why**: 51 attributes wasm-bindgen has, nimbling has 11.

- [x] `jsName` — rename JS export
- [x] `getter`/`setter` — property accessors
- [x] `constructor` — JS constructor
- [x] `catch` — wrap in try/catch, return Result
- [x] `variadic` — variable argument list
- [x] `structural` — structural property access
- [x] `start` — auto-call at module init
- [x] `private`/`hide` — skip export
- [x] `inspectable` — add `toString` to JS class
- [x] `skipTypescript` — no .d.ts generation
- [ ] `typescript_type` — custom TS type annotation (deferred)
- [ ] `js_class` — JS class name override (deferred)
- [x] Tests: attribute parsing, JS wrapper generation

---

## Tier 2 — Production Quality

### 2.1 WIT Adapter System (3 days)
**Why**: wasm-bindgen's secret sauce — generates precise import/export maps from adapter instructions.

- [ ] `AdapterInstruction` types (LoadRetptr, StoreRetptr, CallImport, CallExport)
- [ ] `wit/incoming` — JS→Wasm argument marshalling
- [ ] `wit/outgoing` — Wasm→JS return value marshalling
- [ ] Insert WIT custom section in wasm binary
- [ ] Use adapter instructions in JS codegen (instead of Program descriptor alone)
- [ ] Tests: adapter roundtrip, complex function signatures

### 2.2 Externref Pass (2 days)
**Why**: Reference types for zero-cost JS object passing (no heap array).

- [ ] Externref table creation and management
- [ ] `__externref_table_alloc`/`__externref_table_drop`
- [ ] Element segment patching
- [ ] HashMap-based instruction rewriting
- [ ] Auto-detect `reference-types` Wasm feature
- [ ] Tests: externref table operations

### 2.3 Multi-value Pass (1 day)
- [ ] Transform return-pointer ABIs into multi-value Wasm returns
- [ ] Replace stack loads/stores with actual return values
- [ ] Auto-detect `multivalue` feature

### 2.4 Threads Support (2 days)
- [ ] Thread preparation pass
- [ ] Shared memory/atomics handling
- [ ] `stack_pointer_shim_injected` for threads
- [ ] Thread destroy intrinsics
- [ ] Thread-aware heap (shared vs thread-local)

### 2.5 Catch Handler Generation (1 day)
- [ ] Wasm catch wrapper imports for `catch` attribute
- [ ] JS-to-Wasm exception translation
- [ ] `js_tag`/`wrapped_js_tag` markers

### 2.6 Test Framework (3 days)
**Why**: `wasm-bindgen-test` equivalent — run Nim tests in browser/Node/Deno.

- [ ] `wasmBindgenTest` macro
- [ ] Custom test section (`__nimbling_test_unstable`)
- [ ] Test runner CLI (`nimbling-test-runner`)
- [ ] Browser execution (headless Chrome)
- [ ] Node.js execution
- [ ] Deno execution
- [ ] Worker test modes (Dedicated, Shared, Service)
- [ ] Console integration (`console_log`, `console_error`)

---

## Tier 3 — Ecosystem

### 3.1 `js-sys` Equivalent (7 days)
**Why**: Bindings to ~100 JavaScript built-in APIs.

- [ ] `Array` — push, pop, slice, map, forEach
- [ ] `Object` — keys, values, entries, assign
- [ ] `Function` — call, apply, bind
- [ ] `Date` — now, getTime, toISOString
- [ ] `RegExp` — test, exec
- [ ] `Math` — sqrt, random, sin, cos
- [ ] `Map`/`Set`/`WeakMap`/`WeakSet`
- [ ] `Promise` — resolve, reject, all, race
- [ ] `Error`/`TypeError`/`RangeError`
- [ ] `JSON` — parse, stringify
- [ ] `Symbol` — for, keyFor
- [ ] `Reflect` — get, set, apply
- [ ] `TypedArray` family (Int8Array, Uint8Array, etc.)
- [ ] `Atomics` — add, sub, and, or, xor
- [ ] `BigInt`
- [ ] `Intl` — DateTimeFormat, NumberFormat
- [ ] `Temporal` (future)

### 3.2 `web-sys` Equivalent (10+ days)
**Why**: Bindings to ~100 Web APIs — DOM, Canvas, WebGL, Fetch.

- [ ] DOM — `Node`, `Element`, `Document`, `Event`, `Window`
- [ ] CSSOM — `CSSStyleDeclaration`, `StyleSheet`
- [ ] Events — `MouseEvent`, `KeyboardEvent`, `FocusEvent`
- [ ] Canvas 2D / WebGL
- [ ] Fetch API — `fetch`, `Request`, `Response`, `Headers`
- [ ] Console — `log`, `warn`, `error`, `debug`
- [ ] WebSocket — connect, send, receive
- [ ] Web Audio API
- [ ] Web Crypto API
- [ ] IndexedDB
- [ ] Service Workers
- [ ] Web Storage — `localStorage`, `sessionStorage`
- [ ] WebRTC
- [ ] Web Workers
- [ ] Geolocation
- [ ] WebGPU

### 3.3 WebIDL Generator (5 days)
**Why**: Auto-generate Nim bindings from WebIDL specification files.

- [ ] WebIDL parser (interfaces, partial interfaces, mixins, dictionaries, enums)
- [ ] First-pass analysis: collect types, resolve dependencies
- [ ] Traverse: walk WebIDL tree
- [ ] Generator: output Nim `{.wasmBindgen.}` annotated types
- [ ] Overloaded method resolution (by argument count)
- [ ] Stringifier/iterable handling
- [ ] Dictionary → Nim object conversion

### 3.4 Emscripten Support (2 days)
- [ ] Emscripten target in CLI (target: `emscripten`)
- [ ] `addToLibrary` format output
- [ ] Special marker section detection
- [ ] Emscripten JS library file generation

### 3.5 String Interning (1 day)
- [ ] Thread-local `intern()`/`unintern()` cache
- [ ] `CachedString` descriptor support
- [ ] Avoid O(n) copy+encode per string sent to JS
- [ ] Feature flag: `--define:nbgStringIntern`

### 3.6 Memory64 Support (1 day)
- [ ] Pointer coercion (`>>> 0` on wasm32, passthrough on wasm64)
- [ ] Type coercion in JS glue output
- [ ] Memory layout for 64-bit pointers

### 3.7 Additional CLI Flags (1 day)
- [ ] `--demangle` — demangle Nim function names
- [ ] `--keep-debug` — preserve debug sections
- [ ] `--remove-name-section` — strip name section
- [ ] `--remove-producers-section` — strip producers section
- [ ] `--omit-imports` — skip unused imports
- [ ] `--emit-start` — emit start function
- [ ] `--browser` — bundler target with browser-only mode
- [ ] `--no-modules-global` — override global name for no-modules target
- [ ] `--split-linked-modules` — output linked modules as separate files

---

## Test Coverage Gaps (Need Tests For)

| Area | Missing | Priority |
|------|---------|----------|
| `macroimpl.nim` | 0 tests | 🔴 |
| `codegen.nim` | 0 tests | 🔴 |
| `cli.nim` | 0 tests | 🔴 |
| `runtime.nim` | 0 tests | 🔴 |
| `interp.nim` | 0 tests | 🔴 |
| Encode/decode: enums | no roundtrip | 🟡 |
| Encode/decode: structs | no roundtrip | 🟡 |
| Encode/decode: linked modules | no roundtrip | 🟡 |
| Encode/decode: local modules | no roundtrip | 🟡 |
| Encode/decode: inline JS | no roundtrip | 🟡 |
| Encode/decode: TypeScript sections | no roundtrip | 🟡 |
| Encode/decode: `ikStatic`/`ikString`/`ikType`/`ikEnum` | no roundtrip | 🟡 |
| Describe: `CLOSURE`, `RUST_STRUCT`, `NAMED_EXTERNREF`, `STRING_ENUM` | no tests | 🟡 |
| jsgen: `jsNoModules`/`jsDeno` targets | no tests | 🟡 |
| jsgen: `ikStatic`/`ikString`/`ikType`/`ikEnum` shims | no tests | 🟡 |

---

## Nim Advantages Over Rust's wasm-bindgen

| Area | Advantage |
|------|-----------|
| **Compilation speed** | Nim → C → wasm is faster than Rust → LLVM → wasm |
| **Binary size** | Nim ORC memory model is lighter than Rust ownership + generics monomorphization |
| **Macro simplicity** | Nim pragma macros are simpler than Rust proc-macros (no separate crate needed) |
| **C ABI direct** | No `#[no_mangle]` complexity — Nim uses `{.exportc.}` directly |
| **No trait system** | No complex trait resolution in the interpreter — Nim types are concrete |
| **Single binary CLI** | One Nim binary vs Rust's multi-crate approach |
| **String handling** | Nim's `string` type maps naturally to C strings (no `OsString`/`CString` conversion) |
| **GC integration** | ORC handles memory — no `Rc`/`Arc` manual management |

---

## How to Contribute

```bash
# Clone
git clone https://github.com/katehonz/nimbling.git
cd nimbling

# Run tests
nimble test          # Must pass (26/26)

# Build
nimble buildCli      # CLI tool
nimble wasm          # Hello example → wasm32

# Pick a task from Tier 1 above
# Send PR against main branch
```

**Every PR must**: pass `nimble test`, include tests for new features, update docs if changing public API.
