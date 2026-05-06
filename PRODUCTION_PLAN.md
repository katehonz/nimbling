# Nimbling Production Plan v1.0

## Контекст

`wasm-bindgen` (Rust) е в залез — `rustwasm` организацията се разпада, `wasm-pack` е архивиран, документация изчезва, Rust 1.96 чупи съществуващи WASM билдове. Това е исторически прозорец за Nimbling да стане **де-факто стандарт за WASM/JS interop извън Rust екосистемата**.

## Стратегически цели

1. **v0.2.0** — Foundation (работещ CI, integration тестове, реален allocator)
2. **v0.3.0** — Developer Experience (npm пакет, tree-shaking, bundler plugin)
3. **v0.4.0** — Performance (benchmarks, wasm-opt, binary size оптимизации)
4. **v1.0.0** — Component Model & WASI Preview 3 (уникално предимство пред конкуренцията)

---

## Фаза 1: Foundation — v0.2.0

### 1.1 CI/CD Pipeline
- GitHub Actions workflow: `nimble test` на всеки PR/push
- Workflow за билд на CLI на Linux/macOS/Windows
- Nim версии: 2.0.x, 2.2.x (matrix)

### 1.2 End-to-End Integration Test
- Скрипт, който:
  1. Компилира `examples/hello/hello.nim` до WASM (чрез clang/emcc)
  2. Пуска `nimbling` CLI върху резултата
  3. Зарежда генерирания JS модул в Node.js
  4. Верифицира, че `greet("World")` връща `"Hello, World!"`
- Headless browser вариант (Playwright) за по-късно

### 1.3 Slab Allocator с memory.grow
- Замяна на статичния 1MB bump allocator в `runtime.nim`
- Slab allocator с free/realloc
- Поддръжка за `memory.grow` при изчерпване
- Премахване на memory leak-овете от string allocations

### 1.4 CLI Flags Wiring
- Свързване на `parseCliFlags()` от `emscripten.nim` в `cli.nim`
- `--keep-debug`, `--remove-name-section`, `--encode-into`, и др. да имат ефект

### 1.5 Nimble Registry Публикуване
- `nimble publish` след като CI е стабилен
- Semantic versioning (вече сме 0.1.0, следва 0.2.0)

---

## Фаза 2: Developer Experience — v0.3.0

### 2.1 npm / npx Distribution
- `package.json` с binary wrapper около CLI-то
- `npm install -g nimbling` или `npx nimbling input.wasm`
- JS разработчиците не трябва да инсталират Nim

### 2.2 Modular web_sys
- Разделяне на `web_sys_generated.nim` на подмодули по Web API:
  - `nimbling/web_sys/dom`
  - `nimbling/web_sys/canvas`
  - `nimbling/web_sys/fetch`
  - и т.н.
- Потребителят импортира само каквото му трябва

### 2.3 Vite/Webpack Plugin
- Един JS plugin, който:
  - Наблюдава `.nim` файлове
  - Пуска `nim c ...` + `nimbling ...` при промяна
  - Експортира готов JS модул за бъндлъра

### 2.4 Source Maps & Debug Info
- CLI да запазва DWARF/name sections при `--keep-debug`
- Генериране на `.wasm.map` при нужда

### 2.5 Overloaded WebIDL Methods
- Коректно разрешаване на overload-ове (addEventListener, и т.н.)
- Генериране на различни emit блокове за всеки overload

---

## Фаза 3: Performance & Scale — v0.4.0

### 3.1 Benchmark Suite
- Binary size comparison: Nimbling vs wasm-bindgen (еднакви програми)
- Compile time measurement
- JS↔WASM boundary call overhead
- CI job, който проваля build ако regression >5%

### 3.2 wasm-opt Integration
- Автоматично пускане на Binaryen `wasm-opt` при `--release`
- Флагове: `-O2`, `--strip-debug`, `--dce`

### 3.3 Externref & Multivalue Transforms
- Довършване на `transforms.nim` — реално rewrite на heap accessors
- Поддръжка за WebAssembly externref (по-бърз от i32 индекси)
- Multivalue returns без pointer indirection

### 3.4 ScopedClosure Support
- Пълна имплементация на `ScopedClosure` (stack-borrowed closures)
- Еквивалент на wasm-bindgen `ImmediateClosure`

---

## Фаза 4: Бъдещето — v1.0.0

### 4.1 WIT Generator
- `wit.nim` вече има 30 инструкции — трябва генератор
- Консумация на `.wit` файлове → Nim bindings
- Генериране на `.wit` от `{.wasmBindgen.}` procs

### 4.2 WASI Preview 3 Async
- Native async I/O в WASM (февруари 2026 спецификация)
- Интеграция с Nim's `asyncdispatch`/`chronos`
- `async/await` през WASM границата

### 4.3 JSPI (JavaScript Promise Integration)
- Chrome 137+ / Firefox 139+ поддръжка
- Stack switching за async JS calls
- Nim async proc може да `await` JS Promise директно

### 4.4 Nim Component Model Toolchain
- Директно производство на `.wasm` component файлове
- Без нужда от `wasm-tools` външно
- Nim става първият non-Rust език с пълна Component Model поддръжка

---

## Паралелизация (за множество агенти)

| Агент | Задача | Файлове |
|-------|--------|---------|
| A | CI/CD + Integration Test | `.github/workflows/`, `examples/hello/`, `tests/e2e/` |
| B | Slab Allocator | `src/nimbling/runtime.nim` |
| C | CLI Flags Wiring | `src/nimbling/cli.nim`, `src/nimbling/emscripten.nim` |
| D | npm Package | `package.json`, `js-wrapper/`, release scripts |
| E | Modular web_sys | `src/nimbling/web_sys/`, codegen scripts |

---

## Критерии за готовност на v0.2.0

- [ ] CI минава зелено на всеки PR
- [ ] Integration тестът се пуска автоматично
- [ ] Hello example работи end-to-end в Node.js
- [ ] Allocator не тече памет
- [ ] `nimble install nimbling` инсталира работещ пакет
