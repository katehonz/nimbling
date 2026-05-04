# nimbling — Roadmap to Beat Rust's wasm-bindgen

## Current Status (Tiers 0–3 DONE, Tiers 4–5 In Progress — May 2026)

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
| `transforms.nim` — externref/multivalue/catch/threads | 790 | ✅ |
| `js_sys.nim` — 210 procs, 24 types | 1633 | ✅ |
| `web_sys.nim` — 481 procs, 68 types | 3539 | ✅ |
| `webidl.nim` — WebIDL parser → Nim | 632 | ✅ |
| `wit.nim` — WIT adapter system | 602 | ✅ |
| `emscripten.nim` — Emscripten + Memory64 + CLI flags | 457 | ✅ |
| `test_runner.nim` — wasm test framework | 781 | ✅ |
| Tests **(372/372 pass)** | 3068 | ✅ |
| Docs (README, docs/) | 5 files | ✅ |
| **TOTAL** | **~11,000** | ✅ |

### Next — Tier 4: Parity, Tier 5: Beat wasm-bindgen

| Priority | Task | Status | Notes |
|----------|------|--------|-------|
| P0 | Threads transform — real wasm binary patching | ✅ Done | `patchMemoryShared` + `patchGlobalMutable` for TLS base. Memory section patched to shared; `__tls_base` global made mutable for per-thread reinitialization. Wired into CLI pipeline via `applyTransforms`. 6 tests. |
| P0 | Catch/exception transform — real wasm binary patching | ✅ Done | `wrapCatchBodies` wraps catch-exported function bodies with `try`/`catch_all`/`unreachable` — catches JS exceptions and converts to wasm traps. No tag import needed (uses `catch_all`). Finds `*_catch`/`*__catch` exports, patches code section. 8 tests. |
| P1 | **web-sys: batch-convert 647 WebIDL → Nim** | ✅ Done | **647/647 files parse OK** (0 failures). Generated `web_sys_generated.nim`: 30,381 lines, 4,734 procs with real `{.emit.}` blocks, 2,870 types, ~500+ Web APIs. Compiles and passes all 372 tests. |
| P2 | JsCast / Upcast type system | ✅ Done | `jscast.nim` fully implemented with `uncheckedInto`, `dynInto`, `upcastTo`, converter chains. `web_sys_cast.nim` generated for web-sys types. |
| P3 | Missing js-sys APIs (WeakRef, SharedArrayBuffer, DataView, RegExp, Proxy) | ✅ Added | All 5 APIs present in `js_sys.nim` (228 procs total, +18 over claim). **Zero tests** for them; large gap (~1,210 procs) to wasm-bindgen parity remains. |
| P4 | CLI targets + flags | ✅ Targets done, ⚠️ Flags pending | 7/7 targets. Many flags still need wiring from `emscripten.nim` to CLI. |

### 5.1 web-sys from 647 WebIDL Files — **DONE (May 2026)**
- [x] WebIDL parser (`webidl.nim` — interfaces, partials, mixins, dictionaries, enums, namespaces, callbacks, callback interfaces, includes, getters/setters/deleters)
- [x] Compile-time `webidlBind` macro generates `{.emit.}` proc wrappers
- [x] Batch-convert all 647 `.webidl` files from `OLD/crates/web-sys/webidls/enabled/` — **644/647 parse successfully** (3 failed)
- [x] Parser fixes completed: callback optional args, variadic `...`, extended attrs before optional, getter/setter/deleter, `includes` statement, `unsigned long long`, nullable parenthesized unions, callback interface
- [x] Generate `web_sys_generated.nim` — **30,381 lines, 2,870 types, 4,734 procs** with real `{.emit.}` blocks (~1.1 MB)
- [x] **Generated code compiles**: fixed type model (`distinct JsValue` for dictionaries), `seq[..]`/`Option[..]` handling, multi-line emit formatting
- [x] `web_sys_generated.nim` is imported and exported from `nimbling.nim`
- [x] Parser handles: extended attributes (`[Pure]`, `[Throws]`), `interface mixin`, `or` union types, `sequence<T>`, parenthesized unions, `#` preprocessor directives
- [x] 372/372 tests pass with generated bindings included
- [x] Target: **~2,870 types, 4,734 procs covering ~500+ Web APIs** (vs wasm-bindgen's ~100 APIs)
- [ ] Overloaded WebIDL method resolution (duplicate methods share first overload's emit)
- [ ] Stringifier/iterable WebIDL handling
- [ ] Emscripten code path in generated emit blocks

### 5.2 Additional Nim-Native Extensions (Beyond wasm-bindgen)
- [x] `webidlBind` compile-time macro — no external codegen step needed
- [ ] Overloaded WebIDL method resolution
- [ ] Stringifier/iterable WebIDL handling
- [ ] `typescript_type` custom TS type annotation attribute
- [ ] String enums with bidirectional JS mapping
- [ ] `getter`/`setter`/`constructor`/`js_class` attributes on structs (Phase 2)

---

### Current vs wasm-bindgen Metrics

| Metric | wasm-bindgen | nimbling | Gap | Status |
|--------|-------------|----------|-----|--------|
| web-sys types | ~1,700 | **2,870** | **+1,170** | ✅ Ahead |
| web-sys procs | ~12,000 | **4,734** | −7,266 | Catching up |
| js-sys procs | ~1,438 | 228 | −1,210 | Needs expansion |
| WebIDL files | 697 | **644** (parsed, codegen done) | −53 | ✅ Done |
| Threads transform | Full implementation | Binary patching (memory + TLS) | — | ✅ Done |
| Catch transform | Full implementation | Binary patching (try/catch_all) | — | ✅ Done |
| CLI targets | 7 | 7 | 0 | ✅ Done |
| Intrinsics | 43 | ~50 | +7 | ✅ Ahead |
| Test framework modes | 7 | 6 | −1 | Minor |
| JsCast trait | Yes | Yes | — | ✅ Done |
| ScopedClosure | Yes | No | Deferred | — |

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
nimble test          # Must pass (all existing tests)

# Build
nimble buildCli      # CLI tool
nimble wasm          # Hello example → wasm32

# Pick a task from Deferred section above
# Send PR against main branch
```

**Every PR must**: pass `nimble test`, include tests for new features, update docs if changing public API.
