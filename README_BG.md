# nimbling

**Nim to WebAssembly / JavaScript bindings — като `wasm-bindgen` за Nim**

`nimbling` е двуфазова build-time и post-processing библиотека която позволява на Nim код да вика JavaScript функции и на JavaScript код да вика Nim функции през WebAssembly. Автоматично генерира JS glue код, TypeScript декларации, и управлява конверсията на сложни типове (strings, objects, closures) между двете среди.

> **[English README](README.md)**

## Защо?

Nim имаше стар/експериментален WASM backend който дърпа екосистемата назад. Съвременният Nim компилатор (≥ 2.0) с C backend може да генерира WASM чрез clang/emscripten, но **няма библиотека за high-level JS interop**. `nimbling` запълва тази дупка.

Вдъхновен от [wasm-bindgen](https://github.com/rustwasm/wasm-bindgen) (Rust) — архитектурата е 1:1 адаптирана за Nim.

## Как работи

### Фаза 1 — Compile-time (Nim Macro)

```nim
import nimbling

proc greet(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"

wasmBindgenFinalize()
```

Макросът `wasmBindgen` по време на компилация:
1. **Parse** — анализира Nim AST-а
2. **Codegen** — генерира `{.exportc.}` wrapper функции
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

## Статус — v0.1.0 (Schema v0.2.0)

### Работи (компилира и тествано под Nim 2.2.10)

| Компонент | Файл | Статус |
|-----------|------|--------|
| Type ID константи (36 типа) | `common.nim` | ✅ |
| Program schema (всички AST типове) | `common.nim` | ✅ |
| Binary encode (varint LEB128) | `encode.nim` | ✅ |
| Binary decode (пълен roundtrip) | `decode.nim` | ✅ |
| LEB128 utilities | `leb128.nim` | ✅ |
| Type descriptor system | `describe.nim` | ✅ |
| `{.wasmBindgen.}` pragma макрос | `macroimpl.nim` | ✅ |
| Closure поддръжка | `macroimpl_closure.nim` | ✅ |
| Async/Promise поддръжка | `macroimpl_async.nim` | ✅ |
| 11 wasmBindgen атрибута | `macroimpl_attrs.nim` | ✅ |
| Type mapping & codegen helpers | `codegen.nim` | ✅ |
| JS glue генератор (5 targets) | `jsgen.nim` | ✅ |
| JsValue + Runtime (heap, allocator) | `runtime.nim` | ✅ |
| CLI tool (wasm section extractor) | `cli.nim` | ✅ |
| Wasm stack-machine interpreter | `interp.nim` | ✅ |
| Wasm binary transforms (externref, multivalue, catch, threads) | `transforms.nim` | ✅ |
| WIT adapter system (30 instruction types) | `wit.nim` | ✅ |
| WebIDL parser → Nim codegen | `webidl.nim` | ✅ |
| **WebIDL compile-time macro** | **`macroimpl_webidl.nim`** | ✅ |
| `js-sys` bindings (526 procs, 42 types, 40+ APIs) | `js_sys.nim` | ✅ |
| `web-sys` bindings (~472 procs, 27 APIs, ръчно) | `web_sys.nim` | ✅ |
| `web-sys` generated (4,734 procs, ~2,870 типа, 644 WebIDL файла, ~500+ APIs) | `web_sys_generated.nim` | ✅ |
| Test framework (browser/Node/Deno) | `test_runner.nim` | ✅ |
| Emscripten / Memory64 поддръжка | `emscripten.nim` | ✅ |
| Unit тестове (372 теста, всички минават) | `tests/all.nim` | ✅ |

### `webidlBind` — Compile-Time WebIDL Macro

Генерира Nim bindings директно от WebIDL по време на компилация:

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
```

Генерира `type Node = distinct JsValue`, attribute getters/setters, method calls — всички с `{.emit.}` блокове по същия pattern като `web_sys.nim`.

### Известни ограничения

| Област | Статус | Бележки |
|--------|--------|---------|
| End-to-end pipeline | ✅ Stable | Компилира до C за `wasm32`; пълният `C → WASM → CLI → JS` е верифициран с wasi-sdk / emscripten |
| `web_sys_generated.nim` | ✅ Готов | 4,734 procs с реални `{.emit.}` блокове от 644 WebIDL файла (1.1 MB), покриващи ~500+ Web API |
| `wasmBindgenFinalize()` | By design | Трябва да се извика веднъж на модул за да embed-не custom wasm section-а |
| Emscripten CLI флагове | ✅ Stable | Всички основни targets и флагове са свързани към CLI-то |

## Quick Start

```bash
# Клонирай
git clone https://github.com/katehonz/nimbling.git
cd nimbling

# Пусни тестовете
nimble test

# Build CLI
nimble buildCli

# Ползвай CLI-то
./src/nimbling/cli input.wasm --out-dir pkg/ --target bundler
```

### Nimble задачи

| Команда | Описание |
|---------|----------|
| `nimble test` | Пуска unit тестовете (372 теста) |
| `nimble buildCli` | Build-ва CLI binary (release mode) |
| `nimble wasm` | Build-ва hello примера за wasm (изисква wasi-sdk) |

## Структура на проекта

```
nimbling/
├── README.md                    # English README
├── README_BG.md                 # Този файл
├── DESIGN.md                    # Архитектурна документация (на български)
├── ROADMAP.md                   # Пълен roadmap с всички нива
├── LICENSE                      # MIT License
├── nimbling.nimble              # Nimble package manifest
├── docs/
│   ├── architecture.md          # Архитектура в детайли
│   ├── api.md                   # API референция
│   └── contributing.md          # Гайд за контрибутори
├── src/
│   ├── nimbling.nim             # Library entry point
│   └── nimbling/
│       ├── common.nim           # Споделени типове, константи, Program schema
│       ├── leb128.nim           # LEB128 encode/decode utilities
│       ├── encode.nim           # Binary encoder (varint LEB128)
│       ├── decode.nim           # Binary decoder
│       ├── describe.nim         # Type descriptor система
│       ├── runtime.nim          # JsValue, Closure, memory management
│       ├── macroimpl.nim        # {.wasmBindgen.} pragma макрос
│       ├── macroimpl_closure.nim # Closure поддръжка
│       ├── macroimpl_async.nim  # Async/Promise поддръжка
│       ├── macroimpl_attrs.nim  # 11 wasmBindgen атрибута
│       ├── macroimpl_webidl.nim # Compile-time WebIDL → Nim макрос
│       ├── codegen.nim          # Type mapping & codegen helpers
│       ├── cli.nim              # CLI tool
│       ├── jsgen.nim            # JavaScript glue генератор
│       ├── interp.nim           # Wasm stack-machine interpreter
│       ├── transforms.nim       # Wasm binary transforms
│       ├── js_sys.nim           # js-sys: 526 procs, 42 types, 40+ APIs
│       ├── web_sys.nim          # web-sys: ~472 procs, 27 Web APIs (ръчно)
│       ├── web_sys_generated.nim # web-sys: 4,734 procs, ~500+ APIs (автоматично генериран)
│       ├── webidl.nim           # WebIDL parser → Nim codegen
│       ├── wit.nim              # WIT adapter система
│       └── emscripten.nim       # Emscripten + Memory64 поддръжка
├── tests/
│   └── all.nim                  # Unit test suite (372 теста)
├── examples/
│   └── hello/                   # Hello World пример
└── OLD/                         # Референция: wasm-bindgen (Rust) source
```

## Типови конверсии

| Nim тип | Wasm ABI | JS Glue конверсия |
|----------|----------|-------------------|
| `int32`, `cint` | i32 | директно |
| `float64` | f64 | директно |
| `bool` | i32 (0/1) | директно |
| `string` | (ptr: i32, len: i32) | TextEncoder / TextDecoder |
| `JsValue` (borrowed) | idx: i32 | addBorrowedObject / stack pop |
| `JsValue` (owned) | idx: i32 | addHeapObject / dropObject |
| `seq[T]` | (ptr: i32, len: i32) | TypedArray |
| `Option[T]` | (tag: i32, val) | null check |
| `Closure[T]` | idx: i32 | addHeapObject + function wrapper |

## Сравнение с wasm-bindgen

| Feature | wasm-bindgen (Rust) | nimbling (Nim) |
|---------|---------------------|----------------|
| Macro system | proc-macro (`#[wasm_bindgen]`) | Nim pragma macro (`{.wasmBindgen.}`) |
| Custom section | `__wasm_bindgen_unstable` | `__nimbling_unstable` |
| Type descriptors | `__wbindgen_describe_*` | `__nbg_describe_*` |
| JS function prefix | `__wbg_` | `__nbg_` |
| JS heap | `addHeapObject`/`dropObject` | идентично |
| Schema version | `0.2.119` | `0.2.0` |
| CLI | `wasm-bindgen` (Rust binary) | `nimbling` (Nim binary) |
| web-sys | Да (~100 Web API) | Готово (~500+ Web API, 4,734 procs, 644 WebIDL файла) |
| Test runner | Да (browser/Node/Deno) | Готово |
| WebIDL macro | Не | **Да** — compile-time `webidlBind` |
| js-sys | ~1,438 procs | 526 procs (42 types, 40+ APIs) |

## Реални примери (Real-World Examples)

Фреймуъркът [NimLeptos](https://github.com/katehonz/brenan/tree/main/nimleptos) използва `nimbling` за WebAssembly/JS interop в приложения близки до production. Виж директорията [`nimleptos/examples`](https://github.com/katehonz/brenan/tree/main/nimleptos/examples):

### На фокус: `wasm_counter`

Примерът [`wasm_counter`](https://github.com/katehonz/brenan/tree/main/nimleptos/examples/wasm_counter) е най-пълният end-to-end demo. Показва:

- **Reactive signals** (`createSignal`, `createMemo`, `createEffect`) в WASM
- **Emscripten build** с `build.sh` — компилира Nim → C → wasm през `emcc`
- **EM_ASM DOM helpers** — директна DOM манипулация от Nim чрез Emscripten макроси
- **JS ↔ WASM interop** — експортнати proc-ове (`increment`, `decrement`, `render`), викани от HTML през `Module.ccall`
- **Стилна HTML демо страница** (`index.html`) с CSS анимации и reactive hot-state

```bash
cd nimleptos/examples/wasm_counter
./build.sh        # Изисква Emscripten SDK
firefox index.html
```

### Други примери

| Пример | Описание |
|---------|-------------|
| [`counter`](https://github.com/katehonz/brenan/tree/main/nimleptos/examples/counter) | Минимален counter пример |
| [`blog`](https://github.com/katehonz/brenan/tree/main/nimleptos/examples/blog) | Fullstack blog с Nim backend + wasm frontend |
| [`todo_app.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/todo_app.nim) | Todo app сървър |
| [`wasm_reactive.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/wasm_reactive.nim) + [`wasm_reactive.html`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/wasm_reactive.html) | Реактивни wasm DOM updates |
| [`conditional_client.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/conditional_client.nim) + [`conditional_client.html`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/conditional_client.html) | Conditional rendering пример |
| [`hybrid_client.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/hybrid_client.nim) + [`hybrid_client.html`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/hybrid_client.html) | Хибридно server + client рендиране |
| [`server_app.nim`](https://github.com/katehonz/brenan/blob/main/nimleptos/examples/server_app.nim) | Пълноценно сървърно приложение |

## Лиценз

MIT
