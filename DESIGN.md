# nimbling — Архитектура и Пътна Карта

Nim библиотека за WebAssembly ↔ JavaScript interop, вдъхновена от [wasm-bindgen](https://github.com/rustwasm/wasm-bindgen) (Rust).

---

## Философия и Мотивация

**Проблемът**: Nim имаше стар/експериментален wasm backend който вече не се поддържа и дърпа екосистемата назад. Модерният Nim (≥ 2.0) с C backend може да генерира WASM чрез clang или emscripten, но липсва high-level библиотека за JS interop — няма начин да се викат JS функции от Nim или да се експортват Nim функции към JS с богати типове (стрингове, обекти, масиви).

**Решението**: `nimbling` е двуфазова система (compile-time macro + post-processing CLI) която:

1. Позволява на Nim код да извиква JavaScript функции и обратно — с `{.wasmBindgen.}` pragma
2. Автоматично генерира JavaScript glue код и TypeScript декларации
3. Поддържа богати типове (strings, arrays, objects, closures) а не само числа
4. Управлява JS обекти през shared heap — stack за временни референции, slab за owned обекти
5. Използва custom section в .wasm файла за предаване на метаданни между macro-то и CLI-то

---

## Двуфазова Архитектура

### Фаза 1: Compile-time (Nim Macro)

Когато потребителят напише:

```nim
import nimbling

{.wasmBindgen.}
proc greet(name: string): string =
  result = "Hello, " & name & "!"
```

Макросът `wasmBindgen` (който се изпълнява по време на Nim компилацията) прави следното:

#### 1. Parse
- Обхожда Nim AST-а на annotate-натите proc-ове, типове, и enums
- Извлича сигнатури на функции, типове на параметри, return types
- Строи вътрешен `ast::Program` дървовиден модел (дефиниран в `common.nim`)

#### 2. Codegen — Export Wrappers
За всеки export-нат proc генерира wrapper с `{.exportc.}`:

```nim
# Потребителски код:
{.wasmBindgen.}
proc greet(name: string): string = ...

# Генериран wrapper:
proc __nbg_shim_greet_0(name_ptr: ptr UncheckedArray[byte],
                         name_len: cuint): pointer {.exportc, cdecl.} =
  # 1. Конвертира ptr/len → Nim string
  let nameStr = fromWasmString(name_ptr, name_len)
  # 2. Извиква реалната функция
  let ret = greet(nameStr)
  # 3. Конвертира Nim string → boxed ptr
  return boxWasmString(ret)
```

#### 3. Codegen — Import Shims
За всеки JS import генерира Nim wrapper който вика JS shim:

```nim
# Потребителски код:
{.wasmBindgen: "./math".}
proc jsAdd(a, b: int32): int32 {.importc.}

# Генериран shim:
proc __nbg_f_jsAdd(a: int32, b: int32): int32 {.importc, cdecl.}
```

#### 4. Describe — Типови Дескриптори
Генерира `__nbg_describe_*` функции които описват типовата сигнатура:

```nim
proc __nbg_describe_greet() {.exportc, cdecl.} =
  __nbg_describe(TY_STRING)   # първи аргумент: string
  __nbg_describe(TY_STRING)   # резултат: string
```

Тези функции се изпълняват от CLI-то чрез stack-machine interpreter за да възстанови точните типове.

#### 5. Encode — Сериализация
Сериализира целият `Program` descriptor (exports, imports, enums, structs, inline JS, linked modules) в binary формат използвайки varint (LEB128) encoding.

#### 6. Embed — Custom Section
Вгражда сериализираните данни като custom section `__nimbling_unstable` в .wasm файла чрез `{.emit.}` директиви или linker секции.

### Фаза 2: Post-processing (CLI Tool)

```bash
nimbling target.wasm --out-dir pkg/ --target bundler
```

#### Pipeline

```
.wasm файл
  │
  ├─► Parse wasm binary ──► Извлича custom секции
  │
  ├─► Extract "__nimbling_unstable" секция
  │
  ├─► Decode Program (varint → Nim обекти)
  │
  ├─► Execute __nbg_describe_* функции (stack-machine интерпретатор)
  │     └─► Възстановява точни типови дескриптори за всеки import/export
  │
  ├─► Генерира JS glue код:
  │     ├─► Heap management (addHeapObject, dropObject, passStringToWasm)
  │     ├─► Import shims (JS → Wasm calling convention)
  │     ├─► Export shims (Wasm → JS calling convention)
  │     └─► Module init (instantiate + start)
  │
  └─► Emit файлове:
        ├─► {name}.js          — JavaScript glue модул
        ├─► {name}_bg.wasm     — трансформиран Wasm модул
        ├─► {name}.d.ts        — TypeScript декларации
        └─► snippets/          — inline JS фрагменти
```

### JavaScript Glue Код (генериран от `jsgen.nim`)

```javascript
// {name}.js (bundler target)
import * as wasm from './{name}_bg.js';

// === JS Object Heap ===
const heap = new Array(128).fill(undefined);
heap.push(undefined, null, true, false);
let heap_next = 132;

function addHeapObject(obj) { /* slab allocator */ }
function dropObject(idx) { /* slab free */ }
function addBorrowedObject(obj) { /* stack push */ }

// === String Conversion ===
function passStringToWasm(arg) { /* TextEncoder → ptr, len */ }
function getStringFromWasm(ptr, len) { /* TextDecoder ← ptr, len */ }

// === Export Shims ===
export function greet(arg0) {
  const [ptr0, len0] = passStringToWasm(arg0);
  try {
    const ret = wasm.greet(ptr0, len0);
    const ptr = wasm.__nbg_boxed_str_ptr(ret);
    const len = wasm.__nbg_boxed_str_len(ret);
    const realRet = getStringFromWasm(ptr, len);
    wasm.__nbg_boxed_str_free(ret);
    return realRet;
  } finally {
    wasm.__nbg_free(ptr0, len0, 1);
  }
}

// === Import Shims ===
export function __nbg_f_jsAdd(a, b) {
  return jsAdd(a, b);  // вика оригиналната JS функция
}

// === Module Init ===
export default async function init(input) {
  const imports = {};
  const result = await WebAssembly.instantiate(input, imports);
  wasm = result.instance.exports;
  return wasm;
}
```

---

## JS Object Heap — Как Работи

Wasm модулите работят само с числа (i32, i64, f32, f64). За да се предават JS обекти (functions, objects, arrays) се използва shared heap масив в generated JS кода:

```
                    ┌─────────────────┐
 JS Object ──────►  │ heap[132..N]    │  slab (owned обекти)
                    │ heap[0..127]    │  stack (временни референции)
                    └─────────────────┘
                            │
                     idx: u32 (индекс)
                            │
                    ┌───────▼────────┐
                    │ Nim: JsValue   │
                    │   idx: uint32  │
                    └────────────────┘
```

- **Stack** (лява страна на масива, расте надолу): Временни/borrowed референции за единичен function call. Push при влизане, pop при излизане.
- **Slab** (дясна страна, свободен списък): Owned обекти с произволен lifetime. `addHeapObject` алокира слот, `dropObject` го освобождава. Имплементирано чрез `heap_next` указател и intrusive free list.

### Nim страна: JsValue

```nim
type
  JsValue* = object
    idx*: uint32

proc `=destroy`*(v: var JsValue) =
  when defined(wasm32):
    # Сигнализира на JS че обектът вече не е нужен
    __nbg_object_drop_ref(v.idx)
```

---

## Custom Section Binary Format

Използва се varint (LEB128) encoding за компактност:

```
custom_section {
  name_len:    varuint32
  name:        "__nimbling_unstable"
  payload: {
    schema_version:       varint32_string
    exports:              vec<Export>
    enums:                vec<NimEnum>
    imports:              vec<Import>
    structs:              vec<NimStruct>
    typescript_sections:  vec<LitOrExpr>
    local_modules:        vec<LocalModule>
    inline_js:            vec<string>
    unique_crate_id:      string
    package_json:         option<string>
    linked_modules:       vec<LinkedModule>
  }
}
```

Всеки примитивен тип се енкодира като:
- `bool` → 1 byte (0 или 1)
- `u32/int` → varint (1-5 bytes LEB128)
- `string` → varint(len) + bytes
- `seq<T>` → varint(len) + елементи
- `Option<T>` → 1 byte (0 = none, 1 = some) + optional елемент

---

## Типови Конверсии

| Nim тип | Wasm ABI | JS glue конверсия |
|---------|----------|-------------------|
| `cint`, `int32` | i32 | директно |
| `float64` | f64 | директно |
| `bool` | i32 (0/1) | директно |
| `string` | (ptr: i32, len: i32) | TextEncoder / TextDecoder |
| `JsValue` (borrowed) | idx: i32 | addBorrowedObject / stack pop |
| `JsValue` (owned) | idx: i32 | addHeapObject / dropObject |
| `seq[T]` | (ptr: i32, len: i32) | TypedArray |
| `Option[T]` | (tag: i32, val) | null check |
| `Closure[T]` | idx: i32 | addHeapObject + function wrapper |
| `ref object` | idx: i32 | addHeapObject / JS proxy |

---

## Модулна Структура

```
src/
├── nimbling.nim                 # Главен модул — re-export на публичното API
└── nimbling/
    ├── common.nim               # Константи, Program schema, helper функции
    │   • Type ID definition (36 константи: TY_I8..TY_RAW_POINTER)
    │   • Program AST: Export, Import, FunctionDesc, NimEnum, NimStruct...
    │   • Name mangling: newFunction(), structFieldGet(), qualifiedName()
    │   • SchemaVersion = "0.1.0"
    │
    ├── runtime.nim              # JsValue, Closure, nbgMalloc/nbgFree
    │   • JsValue = object(idx: uint32) с `=destroy` хук
    │   • Импорт декларации за runtime функции
    │
    ├── macroimpl.nim            # {.wasmBindgen.} pragma macro
    │   • wasmBindgen макрос (скелет)
    │   • Планиран: AST traversal → parse → codegen → encode → embed
    │
    ├── codegen.nim              # Генериране на Nim wrapper код
    │   • generateExportWrapper() — създава {.exportc.} wrapper с ABI конверсия
    │   • generateImportWrapper() — създава import declaration
    │   • generateDescribeFn() — създава __nbg_describe_* функция
    │   • JS helper шаблони (passStringToWasm, getStringFromWasm)
    │
    ├── encode.nim               # Binary encode на Program (varint LEB128)
    │   • Encoder обект с putByte() и varint32()
    │   • encode() overloads за всички Program типове
    │
    ├── decode.nim               # Binary decode на Program
    │   • Decoder обект с readByte() и readVarint32()
    │   • decodeProgram() — пълен roundtrip
    │   • Всички decode* procs за типовете от Program schema
    │
    ├── describe.nim             # Type descriptor система
    │   • Descriptor обект (kind + inner/funcDesc/nameStr полета)
    │   • FunctionDescriptor, ClosureDescriptor типове
    │   • decode() от u32 stream (output на stack-machine interpreter)
    │
    ├── cli.nim                  # CLI tool — чете .wasm, генерира JS
    │   • Парсване на CLI аргументи (--out-dir, --target, --debug...)
    │   • extractCustomSection() — binary wasm парсване
    │   • Интеграция с jsgen.nim за генериране на изход
    │
    └── jsgen.nim                # JavaScript glue код генератор
        • JsGen обект с indent/dedent/addLine
        • generateHelpers() — heap, string, memory утилити
        • generateImportShim() — JS shim за импортирани функции
        • generateExportShim() — JS wrapper за експортнати функции
        • Target support: bundler, web, no-modules, nodejs, deno
```

---

## Текущ Статус и Какво Остава

### ✅ Имплементирано и Тествано

| # | Компонент | Файл | Редове | Статус |
|---|-----------|------|--------|--------|
| 1 | Type ID константи (36 типа) | `common.nim` | 10-35 | ✅ Компилира, тествано |
| 2 | Program schema (Export, Import, FunctionDesc...) | `common.nim` | 60-270 | ✅ Компилира, тествано |
| 3 | Name mangling (newFunction, structFieldGet...) | `common.nim` | 230-270 | ✅ Компилира, тествано |
| 4 | JS identifier validation | `common.nim` | 200-220 | ✅ Компилира, тествано |
| 5 | Binary encode (varint LEB128, all Program types) | `encode.nim` | 195 | ✅ Компилира, тествано |
| 6 | Binary decode (пълен roundtrip) | `decode.nim` | 307 | ✅ Компилира, тествано |
| 7 | Type Descriptor decode (15+ типа от u32 stream) | `describe.nim` | 144 | ✅ Компилира, тествано |
| 8 | JsValue + heap runtime | `runtime.nim` | 46 | ✅ Компилира |
| 9 | CLI tool (arg parsing, wasm section extraction) | `cli.nim` | 211 | ✅ Компилира, 222KB binary |
| 10 | JS glue generator (helpers, import/export shims, init) | `jsgen.nim` | 298 | ✅ Компилира |
| 11 | Unit тестове (encode/decode/describe roundtrip) | `tests/all.nim` | 152 | ✅ 11/11 pass |
| 12 | Nimble package manifest | `nimbling.nimble` | 23 | ✅ |
| 13 | DESIGN.md (тази документация) | `DESIGN.md` | — | ✅ |

### 🔴 Критичен — Без Това Няма Работеща Библиотека

#### 1. Nim Macro Имплементация (`macroimpl.nim`, ~3-5 дни работа)

Текущо `macroimpl.nim` съдържа само skeleton и коментари. Трябва:

```nim
macro wasmBindgen*(body: untyped): untyped =
  # 1. Walk AST за {.wasmBindgen.} анотации
  # 2. За всеки proc → parse сигнатура, създай Export/Import entry
  # 3. Генерирай Nim wrapper код:
  #    - За exports: {.exportc.} функция с ptr/len конверсия
  #    - За imports: {.importc.} декларация
  # 4. Генерирай __nbg_describe_* функции
  # 5. Енкодирай Program → бинарен формат
  # 6. Embed-ни данните като custom section (чрез {.emit.} или linker)
  result = body  # + generated wrappers
```

**Ключови предизвикателства**:
- Nim macros работят с untyped AST — трябва ръчно type inference
- Генериране на `.exportc.` функции с правилни calling conventions
- Embed-ване на binary данни в .wasm custom section през C backend
- Интеграция с `encode.nim` и `describe.nim`

#### 2. Stack-Machine Interpreter за Descriptor Функции (`cli.nim`, ~2-3 дни)

CLI-то трябва да execute-ва `__nbg_describe_*` функциите от .wasm модула:

```
__nbg_describe_greet() извиква:
  __nbg_describe(TY_STRING)   → stream: [TY_STRING]
  __nbg_describe(TY_STRING)   → stream: [TY_STRING, TY_STRING]
```

Интерпретаторът трябва:
- Да зареди .wasm модула (използвайки wasm runtime или WASI)
- Да извика всички `__nbg_describe_*` функции
- Да събере output-а (последователност от u32)
- Да decode-не дескрипторите чрез `describe.nim`

**Опции за имплементация**:
- А: Вграден Wasm interpreter (като wasm-bindgen) — най-гъвкаво, но сложно
- Б: Използване на WasmEdge/Wasmtime/WAMR като външен runtime
- В: Node.js script който зарежда .wasm и връща descriptor output

### 🟡 Важен — За Production Readiness

#### 3. Пълна Типова Поддръжка (`codegen.nim`)

Разширяване на `codegen.nim` да генерира wrapper-и за:
- `seq[T]` → TypedArray конверсия
- `Option[T]` → null check
- `Result[T, E]` → try/catch
- `ref object` → JS proxy/class
- `enum` → JS string/number
- `Closure[T]` → JS function wrapper

#### 4. Nim → Wasm Компилационен Pipeline

Документиране и автоматизиране на:
- `nim c --cc:clang --os:standalone --gc:orc` за wasm32 target
- Emscripten път: `nim c -d:emscripten`
- Linker флагове за custom sections
- CI/CD за automated wasm builds

### 🟢 Желан — За Пълна Екосистема

#### 5. Struct Import/Export
`{.wasmBindgen.}` върху Nim обекти → JS класове с getter/setter/method

#### 6. Enum Support
Nim енуми ↔ JS string/number енуми с автоматична конверсия

#### 7. web-sys Еквивалент
Auto-generated Web API bindings (DOM, WebGL, Fetch, WebSocket...) от WebIDL

#### 8. Test Framework
`wasm-bindgen-test` еквивалент — пуска тестове в browser/Node.js/Deno

#### 9. WASI Поддръжка
Beyond JavaScript — системен WASM interop за server-side

---

## Nimble Задачи

| Команда | Описание |
|---------|----------|
| `nimble test` | Пуска 11-те unit теста |
| `nimble buildCli` | Build-ва CLI binary (release, ~222KB) |
| `nimble wasm` | Build-ва hello примера за wasm target |

---

## Сравнение с wasm-bindgen

| Feature | wasm-bindgen (Rust) | nimbling (Nim) |
|---------|---------------------|-----------------|
| Macro система | proc-macro (`#[wasm_bindgen]`) | Nim pragma macro (`{.wasmBindgen.}`) |
| Custom section | `__wasm_bindgen_unstable` | `__nimbling_unstable` |
| Type descriptors | `__wbindgen_describe_*` | `__nbg_describe_*` |
| JS функции префикс | `__wbg_` | `__nbg_` |
| JS heap | `addHeapObject`/`dropObject` | идентично |
| Schema version | `0.2.119` | `0.1.0` |
| CLI | `wasm-bindgen` (Rust binary) | `nimbling` (Nim binary) |
| web-sys | ✅ (~100 Web API-та) | 🔜 планиран |
| Test runner | ✅ (browser/Node/Deno) | 🔜 планиран |

---

## Насоки за Принос

### Код Стил
- Nim 2.0+ (използваме ORC/ARC memory management)
- `import std/options` за Option[T], `export options` в common.nim
- Всички публични символи завършват с `*`
- Type IDs от `common.nim` използват `TY_` префикс

### Добавяне на Нов Тип в Program Схемата

1. Дефинирай типа в `common.nim` (в type секцията)
2. Добави `encode()` overload в `encode.nim`
3. Добави `decode*()` proc в `decode.nim`
4. Обнови `decodeProgram()` да чете новото поле
5. Напиши тест за roundtrip в `tests/all.nim`
6. Увеличи `SchemaVersion`

### Debug съвети

```bash
# Компилирай с debug изход
nim c -d:debug --path:src src/nimbling/cli.nim

# Пускане на конкретен тест
nim c -r --path:src -d:debug tests/all.nim

# Проверка на генериран JS
./src/nimbling/cli test.wasm --out-dir /tmp/out --target bundler
cat /tmp/out/*.js
```

---

*Проектът е в ранен стадий (v0.1.0). Core инфраструктурата (encode/decode, type descriptors, CLI, JS generator) е готова и тествана. Следващата голяма стъпка е Nim macro имплементацията.*
