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
| transforms.nim — externref/multivalue/catch/threads | 645 | ✅ |
| test_runner.nim — wasm test framework | 831 | ✅ |
| js_sys.nim — 192 procs, 20 types | 1429 | ✅ |
| wit.nim — WIT adapter system | 645 | ✅ |
| web_sys.nim — 112 procs, 27 types | 847 | ✅ |
| webidl.nim — WebIDL parser → Nim | 632 | ✅ |
| emscripten.nim — Emscripten + Memory64 + CLI flags | 521 | ✅ |
| **TOTAL** | **~9,200** | ✅ |

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

### 2.1 WIT Adapter System (3 days) — ✅ DONE
- [x] `AdapterInstruction` types (30 constructors)
- [x] Import adapter builder
- [x] Export adapter builder
- [x] WIT custom section encoder/decoder
- [x] Adapter-to-JS codegen
- [x] Program-to-adapters bridge

### 2.2 Externref Pass (2 days) — ✅ DONE
- [x] Externref table creation and management
- [x] `__externref_table_alloc`/`__externref_table_drop`
- [x] Element segment patching
- [x] HashMap-based instruction rewriting
- [x] Auto-detect `reference-types` Wasm feature

### 2.3 Multi-value Pass (1 day) — ✅ DONE
- [x] Transform return-pointer ABIs into multi-value Wasm returns
- [x] Replace stack loads/stores with actual return values
- [x] Auto-detect `multivalue` feature

### 2.4 Threads Support (2 days) — ✅ DONE
- [x] Thread preparation pass
- [x] Shared memory/atomics handling
- [x] `stack_pointer_shim_injected` for threads
- [x] Thread destroy intrinsics
- [x] Thread-aware heap (shared vs thread-local)

### 2.5 Catch Handler Generation (1 day) — ✅ DONE
- [x] Wasm catch wrapper imports for `catch` attribute
- [x] JS-to-Wasm exception translation
- [x] `js_tag`/`wrapped_js_tag` markers

### 2.6 Test Framework (3 days) — ✅ DONE
**Why**: `wasm-bindgen-test` equivalent — run Nim tests in browser/Node/Deno.

- [x] `wasmBindgenTest` macro
- [x] Custom test section (`__nimbling_test_unstable`)
- [x] Test runner CLI (`nimbling-test-runner`)
- [x] Browser execution (headless Chrome)
- [x] Node.js execution
- [x] Deno execution
- [x] Console integration (`console_log`, `console_error`)
- [ ] Worker test modes (Dedicated, Shared, Service) (deferred)

---

## Tier 3 — Ecosystem

### 3.1 `js-sys` Equivalent (7 days) — ✅ DONE (192 procs, 20 types)
**Why**: Bindings to ~100 JavaScript built-in APIs.

- [x] `Array` — 20 procs (push, pop, slice, map, forEach, filter, reduce, find...)
- [x] `Object` — 11 procs (keys, values, entries, assign, get, set, has, delete, freeze, seal)
- [x] `Promise` — 8 procs (resolve, reject, all, race, then, catch, finally)
- [x] `Date` — 14 procs (now, getTime, toISOString, getFullYear/Month/Date...)
- [x] `RegExp` — 6 procs (test, exec, toString, source, flags)
- [x] `Math` — 24 procs (sqrt, random, sin, cos, floor, ceil, abs, pow, exp, log...)
- [x] `Map` — 11 procs (set, get, has, delete, size, clear, keys, values, entries)
- [x] `Set` — 8 procs (add, has, delete, size, clear, values)
- [x] `WeakMap`/`WeakSet` — 9 procs
- [x] `Error`/`TypeError`/`RangeError` — 6 procs
- [x] `JSON` — 3 procs (parse, stringify, stringifyPretty)
- [x] `Reflect` — 7 procs (get, set, has, deleteProperty, ownKeys, apply, construct)
- [x] `Symbol` — 4 procs (for, keyFor, iterator, toStringTag)
- [x] `TypedArray` family (8 types: Uint8/Int8/Uint16/Int16/Uint32/Int32/Float32/Float64)
- [x] `ArrayBuffer`/`DataView` — 15 procs
- [x] `Console` — 9 procs (log, warn, error, info, debug, time, timeEnd, assert)
- [x] `Fetch` — 2 procs
- [x] `Timers` — 4 procs (setTimeout, clearTimeout, setInterval, clearInterval)
- [x] `URI` — 4 procs (encode/decode URI and Component)
- [x] `Number` — 5 procs (isFinite, isNaN, isInteger, parseFloat, parseInt)
- [ ] `Intl` — DateTimeFormat, NumberFormat (deferred)
- [ ] `Temporal` (future) (deferred)

### 3.2 `web-sys` Equivalent (10+ days) — ✅ DONE (112 procs, 27 types)
**Why**: Bindings to Web APIs — DOM, Canvas, Fetch.

- [x] DOM — `Node`, `Element`, `Document`, `Event`, `Window` (6 procs)
- [x] CSSOM — `CSSStyleDeclaration`, `DOMTokenList` (14 procs)
- [x] Events — `MouseEvent`, `KeyboardEvent` (12 procs)
- [x] Canvas 2D — `fillRect`, `drawImage`, `arc`, `translate`, `rotate` (23 procs)
- [x] Fetch API — `fetch`, `Request`, `Response`, `Headers` (9 procs)
- [x] Storage — `localStorage`, `sessionStorage` (6 procs)
- [x] WebSocket — connect, send, receive (8 procs)
- [x] Location/History — `href`, `pushState`, `back` (18 procs)
- [x] Performance — `now()` (1 proc)
- [x] DOMRect — `x`, `y`, `width`, `height` (4 procs)
- [ ] Web Audio API (deferred)
- [ ] Web Crypto API (deferred)
- [ ] IndexedDB (deferred)
- [ ] Service Workers (deferred)
- [ ] WebRTC (deferred)
- [ ] Web Workers (deferred)
- [ ] Geolocation (deferred)
- [ ] WebGL (deferred)
- [ ] WebGPU (deferred)

### 3.3 WebIDL Generator (5 days) — ✅ DONE (632 lines)
**Why**: Auto-generate Nim bindings from WebIDL specification files.

- [x] WebIDL parser (interfaces, partial interfaces, mixins, dictionaries, enums)
- [x] First-pass analysis: collect types, resolve dependencies
- [x] Traverse: walk WebIDL tree
- [x] Generator: output Nim `{.wasmBindgen.}` annotated types
- [x] `webidlToNim` one-step entry point
- [ ] Overloaded method resolution (deferred)
- [ ] Stringifier/iterable handling (deferred)

### 3.4 Emscripten Support (2 days) — ✅ DONE
- [x] Emscripten target in CLI (target: `emscripten`)
- [x] `addToLibrary` format output
- [x] Special marker section detection
- [x] Emscripten JS library file generation

### 3.5 String Interning (1 day) — ✅ DONE
- [x] Thread-local `intern()`/`unintern()` cache
- [x] `InternCache` with lookup and count
- [x] Avoid O(n) copy+encode per string sent to JS
- [x] Feature flag: `--define:nbgStringIntern`

### 3.6 Memory64 Support (1 day) — ✅ DONE
- [x] Pointer coercion (`>>> 0` on wasm32, passthrough on wasm64)
- [x] Type coercion in JS glue output
- [x] Memory layout for 64-bit pointers
- [x] `generateMemory64Coercion` helper

### 3.7 Additional CLI Flags (1 day) — ✅ DONE
- [x] `--demangle` — demangle Nim function names
- [x] `--keep-debug` — preserve debug sections
- [x] `--remove-name-section` — strip name section
- [x] `--remove-producers-section` — strip producers section
- [x] `--omit-imports` — skip unused imports
- [x] `--emit-start` — emit start function
- [x] `--browser` — bundler target with browser-only mode
- [x] `--no-modules-global` — override global name for no-modules target
- [x] `--split-linked-modules` — output linked modules as separate files

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
