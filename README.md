# nimbling

**Nim to WebAssembly / JavaScript bindings — като `wasm-bindgen` за Nim**

`nimbling` е двуфазова build-time и post-processing библиотека която позволява на Nim код да вика JavaScript функции и на JavaScript код да вика Nim функции през WebAssembly. Автоматично генерира JS glue код, TypeScript декларации, и управлява конверсията на сложни типове (strings, objects, closures) между двете среди.

## Защо?

Nim имаше стар/експериментален WASM backend който дърпа екосистемата назад. Съвременният Nim компилатор (≥ 2.0) с C backend може да генерира WASM чрез clang/emscripten, но **няма библиотека за high-level JS interop**. `nimbling` запълва тази дупка.

Вдъхновен от [wasm-bindgen](https://github.com/rustwasm/wasm-bindgen) (Rust) — архитектурата е 1:1 адаптирана за Nim.

## Как работи

### Фаза 1 — Compile-time (Nim Macro)

```nim
import nimbling

{.wasmBindgen.}
proc greet(name: string): string =
  result = "Hello, " & name & "!"
```

Макросът `wasmBindgen` по време на компилация:
1. **Parse** — анализира Nim AST-а
2. **Codegen** — генерира `{.exportc.}` wrapper функции (конвертират ptr/len ↔ Nim типове)
3. **Describe** — генерира `__nbg_describe_*` функции описващи типовете
4. **Encode** — сериализира Program descriptor в binary (varint LEB128)
5. **Embed** — вгражда данните като custom section `__nimbling_unstable` в `.wasm` файла

### Фаза 2 — Post-processing (CLI Tool)

```bash
nimbling target.wasm --out-dir pkg/ --target bundler
```

CLI-то чете `.wasm`, extract-ва custom section-а, decode-ва Program descriptor-а, и генерира:
- `{name}.js` — JavaScript glue модул (heap management, import/export shims)
- `{name}_bg.wasm` — трансформиран Wasm модул
- `{name}.d.ts` — TypeScript декларации

### JS Object Heap

Понеже Wasm работи само с числа, JS обекти се предават през shared heap масив:

```
JS object → addHeapObject(obj) → idx: u32 → Nim: JsValue(idx: u32)
```

- **Stack** — временни/borrowed референции (push/pop за всеки function call)
- **Slab** — owned обекти с динамичен lifetime (reference counting)

## Статус — v0.1.0

### ✅ Работи (компилира и тествано под Nim 2.2.10)

| Компонент | Файл | Статус |
|-----------|------|--------|
| Type ID константи (36 типа) | `common.nim` | ✅ |
| Program schema (всички AST типове) | `common.nim` | ✅ |
| Binary encode (varint LEB128) | `encode.nim` | ✅ |
| Binary decode (пълен roundtrip) | `decode.nim` | ✅ |
| Type descriptor system | `describe.nim` | ✅ |
| CLI tool (wasm section extractor) | `cli.nim` | ✅ |
| JS glue генератор (bundler/web/node/deno) | `jsgen.nim` | ✅ |
| JsValue + Runtime (heap функции) | `runtime.nim` | ✅ |
| Unit тестове (11 теста, всички минават) | `tests/all.nim` | ✅ |
| CLI binary (release build, 222KB) | `src/nimbling/cli` | ✅ |

### 🚧 Остава да се довърши

| Задача | Приоритет | Описание |
|--------|-----------|----------|
| **Nim macro имплементация** | 🔴 Критичен | `macroimpl.nim` има skeleton — трябва реален AST traversal който parse-ва `{.wasmBindgen.}` annotated procs, генерира wrapper код, descriptor функции, и embed-ва custom section |
| **Stack-machine interpreter** | 🔴 Критичен | CLI-то трябва да execute-ва `__nbg_describe_*` функциите от .wasm файла за да извлече точните типови дескриптори. Бе� нужен simple stack-machine |
| **Пълна типова поддръжка** | 🟡 Важен | `seq[T]`, `Option[T]`, enums, structs, closures — codegen за конверсия на всички поддържани типове |
| **Emscripten integration** | 🟡 Важен | Nim → C → emscripten → wasm pipeline. Тестване с реална компилация |
| **Стрингова конверсия** | 🟡 Важен | Имплементация на `passStringToWasm` / `getStringFromWasm` в generated Nim wrappers |
| **Closure поддръжка** | 🟢 Желан | JS callbacks → Nim, Nim closures → JS |
| **Struct import/export** | 🟢 Желан | `{.wasmBindgen.}` върху Nim обекти → JS класове |
| **Enum import/export** | 🟢 Желан | Nim енуми → JS string/number енуми |
| **`web-sys` еквивалент** | 🟢 Желан | Auto-generated Web API bindings от WebIDL |
| **Test framework** | 🟢 Желан | `wasm-bindgen-test` еквивалент за browser/node |
| **WASI поддръжка** | 🔵 Бъдеще | Beyond JS — системен WASM interop |

### Архитектурна карта

```
src/
├── nimbling.nim                 # Главен модул, re-export
└── nimbling/
    ├── common.nim               # Константи, типове, schema
    ├── runtime.nim              # JsValue, heap функции
    ├── macroimpl.nim            # {.wasmBindgen.} макрос ⬅️ нуждае се от имплементация
    ├── codegen.nim              # Nim wrapper генератор ⬅️ нуждае се от имплементация
    ├── encode.nim               # Binary encode на Program ✅
    ├── decode.nim               # Binary decode на Program ✅
    ├── describe.nim             # Type descriptor система ✅
    ├── cli.nim                  # CLI tool ✅
    └── jsgen.nim                # JavaScript генератор ✅
```

## Quick Start

```bash
# Клонирай
git clone https://github.com/nimbling/nimbling
cd nimbling

# Пусни тестовете
nimble test

# Build CLI
nimble buildCli

# Ползвай CLI-то
./src/nimbling/cli input.wasm --out-dir pkg/ --target bundler
```

## Nimble задачи

| Команда | Описание |
|---------|----------|
| `nimble test` | Пуска unit тестовете (11 теста) |
| `nimble buildCli` | Build-ва CLI binary (release mode) |
| `nimble wasm` | Build-ва hello примера за wasm |

## Структура на проекта

```
nimbling/
├── README.md                    # Този файл
├── DESIGN.md                    # Архитектурна документация (на български)
├── nimbling.nimble              # Nimble package manifest
├── src/
│   ├── nimbling.nim             # Library entry point
│   └── nimbling/                # Implementation modules
│       ├── common.nim           # Shared types & constants
│       ├── runtime.nim          # JsValue, memory management
│       ├── macroimpl.nim        # Macro implementation
│       ├── codegen.nim          # Code generation
│       ├── encode.nim           # Binary encoder
│       ├── decode.nim           # Binary decoder
│       ├── describe.nim         # Type descriptors
│       ├── cli.nim              # CLI tool
│       └── jsgen.nim            # JavaScript generator
├── tests/
│   └── all.nim                  # Unit test suite
├── examples/
│   └── hello/                   # Hello World example
│       ├── hello.nim
│       └── hello.nimble
└── OLD/                         # Reference: wasm-bindgen (Rust) source
```

## Лиценз

MIT

---

*"смятам да се направя на смел и герой"* — построено с 4 AI модела и чист Nim
