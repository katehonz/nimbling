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
| `js_sys.nim` — 210 procs, 24 types | 1633 | ✅ |
| `web_sys.nim` — 481 procs, 68 types | 3539 | ✅ |
| `webidl.nim` — WebIDL parser → Nim | 632 | ✅ |
| `wit.nim` — WIT adapter system | 602 | ✅ |
| `emscripten.nim` — Emscripten + Memory64 + CLI flags | 457 | ✅ |
| `test_runner.nim` — wasm test framework | 781 | ✅ |
| Tests **(333/333 pass)** | 2704 | ✅ |
| Docs (README, docs/) | 5 files | ✅ |
| **TOTAL** | **~11,000** | ✅ |

### Next — Tier 4: Parity, Tier 5: Beat wasm-bindgen

| Priority | Task | Status |
|----------|------|--------|
| P0 | Threads transform — real wasm binary patching | ✅ |
| P0 | Catch/exception transform — real wasm binary patching | ✅ |
| P1 | **web-sys: batch-convert 697 WebIDL → Nim** | ✅ 612/647 (94.7%) |
| P2 | JsCast / Upcast type system | ✅ |
| P3 | Missing js-sys APIs (WeakRef, SharedArrayBuffer, DataView, RegExp, Proxy) | ✅ |
| P4 | CLI targets + flags | ✅ |

### 5.1 web-sys from 701 WebIDL Files — **612/647 (94.7%) DONE**
- [x] WebIDL parser (`webidl.nim` — interfaces, partials, mixins, dictionaries, enums, namespaces)
- [x] Compile-time `webidlBind` macro generates `{.emit.}` proc wrappers
- [x] Batch-convert all 697 `.webidl` files from `OLD/crates/web-sys/webidls/enabled/` — 612 successful, 35 with edge case failures (skipped)
- [x] Generate `web_sys_generated.nim` — 9,420 lines, 1,449 type definitions + proc bindings
- [x] Parser handles: extended attributes (`[Pure]`, `[Throws]`), `interface mixin`, `or` union types, `sequence<T>`, parenthesized unions, `#` preprocessor directives
- [ ] Fix remaining 35 edge cases in parser (EventTarget, Document, WebGLRenderingContext, etc.)
- [ ] Fix generated code compilation issues (cross-references, callback type stubs, forward references)
- [ ] Tests: verify compilation of generated bindings for top 50 Web APIs
- [ ] Target: 1700+ types, covering 700+ Web APIs (vs current 68 types, 27 APIs)

### 5.2 Additional Nim-Native Extensions (Beyond wasm-bindgen)
- [x] `webidlBind` compile-time macro — no external codegen step needed
- [ ] Overloaded WebIDL method resolution
- [ ] Stringifier/iterable WebIDL handling
- [ ] `typescript_type` custom TS type annotation attribute
- [ ] String enums with bidirectional JS mapping
- [ ] `getter`/`setter`/`constructor`/`js_class` attributes on structs (Phase 2)

---

### Current vs wasm-bindgen Metrics

| Metric | wasm-bindgen | nimbling | Gap |
|--------|-------------|----------|-----|
| web-sys types | ~1,700 | 68 | **−1,632** |
| web-sys procs | ~12,000 | 472 | **−11,528** |
| js-sys procs | ~1,438 | 216 | **−1,222** |
| WebIDL files | 697 | 0 (hand-written) | **−697** |
| Threads transform | Full implementation | Stubs only | **P0** |
| Catch transform | Full implementation | Stubs only | **P0** |
| CLI targets | 7 | 5 | −2 |
| Intrinsics | 43 | ~50 | +7 |
| Test framework modes | 7 | 6 | −1 |
| JsCast trait | Yes | No | **P2** |
| ScopedClosure | Yes | No | Deferred |

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
nimble test          # Must pass (158/158)

# Build
nimble buildCli      # CLI tool
nimble wasm          # Hello example → wasm32

# Pick a task from Deferred section above
# Send PR against main branch
```

**Every PR must**: pass `nimble test`, include tests for new features, update docs if changing public API.
