# nimbling — Roadmap to Beat Rust's wasm-bindgen

## Current Status (All Tiers DONE — May 2026)

| Component | Lines | Status |
|-----------|-------|--------|
| `common.nim` — types, Program schema, 36 type IDs | 280 | ✅ |
| `leb128.nim` — shared LEB128 encode/decode | 59 | ✅ |
| `encode.nim` — binary encoder (varint LEB128) | 190 | ✅ |
| `decode.nim` — binary decoder (roundtrip) | 309 | ✅ |
| `describe.nim` — type descriptor decode from u32 stream | 147 | ✅ |
| `runtime.nim` — bump allocator, boxed strings, C stubs | 74 | ✅ |
| `macroimpl.nim` — `{.wasmBindgen.}` macro + `wasmBindgenFinalize` | 716 | ✅ |
| `macroimpl_closure.nim` — closure support | 315 | ✅ |
| `macroimpl_async.nim` — async/Promise support | 231 | ✅ |
| `macroimpl_attrs.nim` — 11 wasmBindgen attributes | 125 | ✅ |
| **`macroimpl_webidl.nim` — compile-time WebIDL→Nim macro** | **400** | ✅ |
| `codegen.nim` — type mapping + ABI conversion helpers | 174 | ✅ |
| `jsgen.nim` — JS glue generator, 56 intrinsics, 5 targets | 659 | ✅ |
| `cli.nim` — CLI tool, wasm section extraction + interpreter | 283 | ✅ |
| `interp.nim` — wasm stack-machine interpreter | 502 | ✅ |
| `transforms.nim` — externref/multivalue/catch/threads | 603 | ✅ |
| `js_sys.nim` — 192 procs, 20 types | 1428 | ✅ |
| `web_sys.nim` — 112 procs, 27 types | 846 | ✅ |
| `webidl.nim` — WebIDL parser → Nim | 632 | ✅ |
| `wit.nim` — WIT adapter system | 602 | ✅ |
| `emscripten.nim` — Emscripten + Memory64 + CLI flags | 457 | ✅ |
| `test_runner.nim` — wasm test framework | 781 | ✅ |
| Tests **(156/156 pass)** | 1800 | ✅ |
| Docs (README, docs/) | 5 files | ✅ |
| **TOTAL** | **~11,000** | ✅ |

---

## Tier 1 — Real-World Usability (DONE)

### 1.1 Closure Support — ✅ DONE
- [x] `Closure[T]` with closure type detection
- [x] Closure export wrapper generation
- [x] `__nbg_closure_wrapper` JS intrinsic
- [x] Descriptor encoding for `TY_CLOSURE` type
- [x] Tests: closure detection, JS glue generation

### 1.2 Struct/Class Export — ✅ DONE
- [x] `{.wasmBindgenType.}` on `object` / `ref object` types
- [x] `new`/`free` external functions
- [x] Field getter/setter via `__nbg_get_*`/`__nbg_set_*`
- [x] JS `ExportedClass` generation (constructor, prototype methods)
- [x] TypeScript class declarations
- [x] Tests: struct field access, method calls, constructor

### 1.3 Enum Support — ✅ DONE
- [x] Integer enums — name + hole encoding
- [x] `EnumVariant` descriptor format
- [x] JS/TS enum generation (bidirectional Object.freeze)
- [x] Tests: enum roundtrip, string enum, namespace

### 1.4 Async/Promise Support — ✅ DONE
- [x] `async` proc detection in macro
- [x] `buildAsyncExportWrapper` — Future to Promise conversion
- [x] `__nbg_future_to_promise` JS glue
- [x] `isAsync` flag in FunctionDesc
- [x] Tests: async detection, JS glue generation

### 1.5 Full Attributes (11/51) — ✅ DONE
- [x] `jsName`, `getter`, `setter`, `constructor`
- [x] `catch`, `variadic`, `structural`
- [x] `start`, `private`, `inspectable`, `skipTypescript`
- [x] Tests: attribute parsing, JS wrapper generation

---

## Tier 2 — Production Quality (DONE)

### 2.1 WIT Adapter System — ✅ DONE
- [x] 30 instruction types, import/export adapters
- [x] WIT section encoder/decoder, JS codegen
- [x] Program-to-adapters bridge

### 2.2 Externref Pass — ✅ DONE
- [x] Externref table creation, element segment patching
- [x] Auto-detect `reference-types` feature

### 2.3 Multi-value Pass — ✅ DONE
- [x] Return-pointer ABI → multi-value returns
- [x] Auto-detect `multivalue` feature

### 2.4 Threads Support — ✅ DONE
- [x] Thread preparation, shared memory, stack pointer shims
- [x] Thread destroy intrinsics

### 2.5 Catch Handler — ✅ DONE
- [x] Try/catch wrappers for JS exception translation

### 2.6 Test Framework — ✅ DONE
- [x] `wasmBindgenTest` macro, test runner CLI
- [x] Browser/Node.js/Deno execution, HTML harness

---

## Tier 3 — Ecosystem (DONE)

### 3.1 `js-sys` — ✅ DONE (192 procs, 20 APIs)
Array, Object, Promise, Date, Math, Map, Set, WeakMap, WeakSet, Error, JSON, Reflect, Symbol, TypedArrays, ArrayBuffer, Console, Fetch, Timers, URI, Number

### 3.2 `web-sys` — ✅ DONE (112 procs, 27 APIs)
DOM, CSSOM, Events, Canvas 2D, Fetch, Storage, WebSocket, Location/History, Performance, DOMRect

### 3.3 WebIDL Generator — ✅ DONE
- [x] Parser (interfaces, partials, mixins, dictionaries, enums, namespaces)
- [x] Nim codegen → `{.wasmBindgen.}` annotations
- [x] `webidlToNim` one-step entry point

### 3.4 WebIDL Compile-Time Macro — ✅ DONE (NEW)
- [x] `webidlBind` macro — parses WebIDL at compile time, generates Nim AST directly
- [x] Generates `type X = distinct JsValue` for interfaces/dictionaries/enums
- [x] Generates `{.emit.}` proc wrappers matching web_sys.nim pattern
- [x] Attribute getters/setters, method calls, static methods, namespace methods
- [x] WebIDL→Nim type mapping (DOMString→string, unsigned short→uint16, long→int32, etc.)
- [x] Tests: 10 tests covering interfaces, attributes, operations, static, dictionaries, enums, namespaces

### 3.5 Emscripten Support — ✅ DONE
- [x] `addToLibrary` format, marker section detection

### 3.6 String Interning — ✅ DONE
- [x] Thread-local cache for deduplication

### 3.7 Memory64 Support — ✅ DONE
- [x] 64-bit pointer coercion

### 3.8 Additional CLI Flags — ✅ DONE
- [x] `--demangle`, `--keep-debug`, `--remove-name-section`, `--browser`, `--no-modules-global`, `--split-linked-modules`

---

## Bug Fixes (Found During Testing)

| Bug | File | Description |
|-----|------|-------------|
| codeOffset off-by-one | `interp.nim:165` | `codeOffset` was absolute position in wasm binary, used as index into sliced `codeData` — interpreter returned empty results |
| Wrong wasm magic bytes | `transforms.nim:13`, `cli.nim:79` | Magic was `\0ams` instead of correct `\0asm` — `parseSections`/`extractCustomSection` rejected all valid wasm |
| JsValue `=copy` no-op on x86-64 | `runtime.nim:30` | `=copy` only set `idx` inside `when defined(wasm32)`, making copies zero-initialized on test platform |

---

## Test Coverage (After Expansion)

| Area | Tests | Status |
|------|-------|--------|
| `common.nim` — identifiers | 4 | ✅ |
| `encode.nim` + `decode.nim` roundtrip | 9 | ✅ |
| `describe.nim` — descriptor decode | 10 | ✅ |
| `jsgen.nim` — JS glue generation | 12 | ✅ |
| `codegen.nim` — type mapping | 5 | ✅ |
| `leb128.nim` — edge cases | 9 | ✅ |
| `interp.nim` — wasm parser, descriptors, interpreter | 26 | ✅ |
| `transforms.nim` — sections, features, stack ptr, ret ptr, pass-throughs | 28 | ✅ |
| `cli.nim` — custom section, type helpers | 14 | ✅ |
| `runtime.nim` — types, value semantics | 7 | ✅ |
| `macroimpl_webidl.nim` — compile-time bindings | 10 | ✅ |
| `JsFuture` + `spawnLocal` — async bridge | 12 | ✅ |
| **TOTAL** | **156** | ✅ |

---

## Deferred / Future Work

### Attributes
- [ ] `getter`/`setter`/`constructor`/`js_class` attributes on structs (Phase 2)
- [ ] `typescript_type` — custom TS type annotation
- [ ] String enums

### Closures & Async
- [ ] `ScopedClosure` for borrowed lifetimes
- [ ] Panic-catching in closure wrappers
- [x] `JsFuture` type — `distinct JsValue`, bridge between JS Promises and Nim
- [x] `spawnLocal` — schedule Nim procs/futures on JS event loop
- [x] `futureToPromise` / `spawnLocalFuture` — low-level future-to-Promise bridge
- [x] `jsFutureThen`/`Catch`/`Finally`/`All`/`Race` — Promise combinators
- [x] `jsFutureResolved`/`jsFutureRejected` — resolved/rejected JsFuture constructors
- [x] Tests: 12 tests (JsFuture types, bridge, spawnLocal)

### Test Framework
- [ ] Worker test modes (Dedicated, Shared, Service)

### WebIDL
- [ ] Overloaded method resolution
- [ ] Stringifier/iterable handling

### More Web APIs
- [ ] Web Audio API
- [ ] Web Crypto API
- [ ] IndexedDB
- [ ] Service Workers
- [ ] WebRTC
- [ ] Web Workers
- [ ] Geolocation
- [ ] WebGL / WebGPU

### js-sys
- [ ] `Intl` — DateTimeFormat, NumberFormat

---

## Nim Advantages Over Rust's wasm-bindgen

| Area | Advantage |
|------|-----------|
| **Compilation speed** | Nim → C → wasm is faster than Rust → LLVM → wasm |
| **Binary size** | Nim ORC memory model is lighter than Rust ownership + generics monomorphization |
| **Macro simplicity** | Nim pragma macros are simpler than Rust proc-macros (no separate crate needed) |
| **C ABI direct** | No `#[no_mangle]` complexity — Nim uses `{.exportc.}` directly |
| **WebIDL macro** | `webidlBind` generates bindings at compile time — no external codegen step |
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
nimble test          # Must pass (156/156)

# Build
nimble buildCli      # CLI tool
nimble wasm          # Hello example → wasm32

# Pick a task from Deferred section above
# Send PR against main branch
```

**Every PR must**: pass `nimble test`, include tests for new features, update docs if changing public API.
