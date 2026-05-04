# Examples Guide

Practical code examples demonstrating nimbling features.

---

## Hello World

The simplest possible example:

```nim
import nimbling

proc greet(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"

wasmBindgenFinalize()
```

Build and run:

```bash
nim c --cc:clang --os:standalone --mm:orc -d:wasm32 -d:release examples/hello/hello.nim
nimbling hello.wasm --out-dir pkg/ --target bundler
```

---

## Basic Types

### Numbers

```nim
import nimbling

proc addInts*(a, b: int32): int32 {.wasmBindgen.} =
  result = a + b

proc multiplyFloats*(a, b: float64): float64 {.wasmBindgen.} =
  result = a * b

proc toggle*(flag: bool): bool {.wasmBindgen.} =
  result = not flag

proc getPi*(): float64 {.wasmBindgen.} =
  result = 3.14159265359

wasmBindgenFinalize()
```

### Strings

```nim
import nimbling

proc greet*(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"

proc toUpperCase*(s: string): string {.wasmBindgen.} =
  result = s.toUpperAscii()

proc concat*(a, b: string): string {.wasmBindgen.} =
  result = a & b

proc length*(s: string): int32 {.wasmBindgen.} =
  result = s.len.int32

wasmBindgenFinalize()
```

---

## JavaScript Interop

### Importing JS Functions

```nim
import nimbling

# Import from global scope
{.wasmBindgen: "Math".}
proc jsRandom*(): float64 {.importc: "random".}

# Import from a namespace
{.wasmBindgen: "document".}
proc jsGetElementById*(id: string): JsValue {.importc: "getElementById".}

{.wasmBindgen: "console".}
proc jsLog*(msg: string) {.importc: "log".}

# Call from Nim
when isMainModule:
  echo jsRandom()        # Native: 0.0 (stub)
  echo jsLog("Hello")    # Native: prints "Hello"
```

### Using JsValue

```nim
import nimbling

{.wasmBindgen: "document".}
proc getBody*(): JsValue {.importc: "body".}

proc setBodyText*(text: string) {.wasmBindgen.} =
  let body = getBody()
  # body.innerText = text  # via web_sys
  discard

wasmBindgenFinalize()
```

---

## Structs and Classes

### Defining Exported Structs

```nim
import nimbling

type
  Point* {.wasmBindgenType.} = object
    x*, y*: float64

  Color* {.wasmBindgenType.} = enum
    Red
    Green
    Blue

proc createPoint*(x, y: float64): Point {.wasmBindgen.} =
  result = Point(x: x, y: y)

proc distance*(p1, p2: Point): float64 {.wasmBindgen.} =
  let dx = p2.x - p1.x
  let dy = p2.y - p1.y
  result = sqrt(dx * dx + dy * dy)

proc getColorName*(c: Color): string {.wasmBindgen.} =
  case c
  of Red: result = "red"
  of Green: result = "green"
  of Blue: result = "blue"

wasmBindgenFinalize()
```

---

## Callbacks and Closures

### Passing Nim Functions to JS

```nim
import nimbling

type
  Callback* = proc(a: int32): int32
  TwoArgCallback* = proc(a, b: int32): int32

proc applyCallback*(value: int32, fn: Callback): int32 {.wasmBindgen.} =
  result = fn(value)

proc applyTwoCallbacks*(a, b: int32, fn1, fn2: TwoArgCallback): int32 {.wasmBindgen.} =
  result = fn1(a, b) + fn2(a, b)

wasmBindgenFinalize()
```

### Registering JS Callbacks

```nim
import nimbling

type
  EventHandler* = proc(event: JsValue)

proc setClickHandler*(element: JsValue, handler: EventHandler) {.wasmBindgen.} =
  discard  # element.onclick = handler

proc setInterval*(callback: proc(), ms: int32) {.wasmBindgen.} =
  discard  # setInterval(callback, ms)

wasmBindgenFinalize()
```

---

## Arrays and Sequences

### Passing Sequences

```nim
import nimbling

proc sumArray*(arr: seq[int32]): int32 {.wasmBindgen.} =
  result = 0
  for v in arr:
    result += v

proc reverseArray*(arr: seq[string]): seq[string] {.wasmBindgen.} =
  result = arr
  for i in 0 ..< result.len div 2:
    swap(result[i], result[result.len - 1 - i])

proc mapArray*(arr: seq[int32], fn: proc(x: int32): int32): seq[int32] {.wasmBindgen.} =
  result = newSeq[int32](arr.len)
  for i in 0 ..< arr.len:
    result[i] = fn(arr[i])

wasmBindgenFinalize()
```

---

## Async and Promises

### Returning Promises

```nim
import nimbling

proc fetchData*(): JsValue {.wasmBindgen.} =
  # Returns a Promise (JsValue)
  discard

proc delay*(ms: int32): JsValue {.wasmBindgen.} =
  # Returns a Promise that resolves after ms milliseconds
  discard

wasmBindgenFinalize()
```

---

## Error Handling

### Using Result Type

```nim
import nimbling

type
  MyError* = object
    code*: int32
    message*: string

proc divideSafe*(a, b: int32): int32 {.wasmBindgen.} =
  if b == 0:
    result = -1  # Or use exceptions
  else:
    result = a div b

proc parseNumber*(s: string): int32 {.wasmBindgen.} =
  try:
    result = parseInt(s)
  except:
    result = 0

wasmBindgenFinalize()
```

---

## Using WebIDL Bindings

### Basic Web APIs

```nim
import nimbling/web_sys

# Window
let win = window()
let doc = win.document()

# Create elements
let div = doc.createElement("div")
div.setAttribute("id", "myDiv")
div.textContent = "Hello from Nim!"

# Query selector
let element = doc.querySelector("#myDiv")

# Console
console.log("Info message")
console.warn("Warning message")
console.error("Error message")
```

### Canvas and Graphics

```nim
import nimbling/web_sys

proc setupCanvas*(canvasId: string): JsValue =
  let doc = window().document()
  let canvas = doc.getElementById(canvasId)
  let ctx = canvas.getContext("2d")

  # Draw something
  ctx.fillStyle = "red"
  ctx.fillRect(0, 0, 100, 100)

  result = ctx

wasmBindgenFinalize()
```

---

## Complete Example: Counter

```nim
import nimbling

var counter*: int32 = 0

proc increment*() {.wasmBindgen.} =
  counter += 1

proc decrement*() {.wasmBindgen.} =
  counter -= 1

proc getCount*(): int32 {.wasmBindgen.} =
  result = counter

proc reset*() {.wasmBindgen.} =
  counter = 0

wasmBindgenFinalize()
```

JavaScript usage:

```javascript
import init, { increment, decrement, getCount, reset } from './counter.js';

await init();

console.log(getCount());  // 0
increment();
increment();
console.log(getCount());  // 2
decrement();
console.log(getCount());  // 1
reset();
console.log(getCount());  // 0
```

---

## Example: String Utilities

```nim
import nimbling

proc trim*(s: string): string {.wasmBindgen.} =
  result = s.strip()

proc split*(s, delimiter: string): seq[string] {.wasmBindgen.} =
  result = s.split(delimiter)

proc join*(parts: seq[string], separator: string): string {.wasmBindgen.} =
  result = parts.join(separator)

proc contains*(s, substr: string): bool {.wasmBindgen.} =
  result = s.contains(substr)

proc replace*(s, old, new: string): string {.wasmBindgen.} =
  result = s.replace(old, new)

proc startsWith*(s, prefix: string): bool {.wasmBindgen.} =
  result = s.startsWith(prefix)

proc endsWith*(s, suffix: string): bool {.wasmBindgen.} =
  result = s.endsWith(suffix)

wasmBindgenFinalize()
```

---

## Example: Math Operations

```nim
import nimbling

proc abs*(x: int32): int32 {.wasmBindgen.} =
  result = if x < 0: -x else: x

proc absF*(x: float64): float64 {.wasmBindgen.} =
  result = if x < 0.0: -x else: x

proc min*(a, b: int32): int32 {.wasmBindgen.} =
  result = if a < b: a else: b

proc max*(a, b: int32): int32 {.wasmBindgen.} =
  result = if a > b: a else: b

proc clamp*(value, minVal, maxVal: int32): int32 {.wasmBindgen.} =
  result = if value < minVal: minVal
           elif value > maxVal: maxVal
           else: value

proc lerp*(a, b: float64, t: float64): float64 {.wasmBindgen.} =
  result = a + (b - a) * t

proc mapRange*(value, inMin, inMax, outMin, outMax: float64): float64 {.wasmBindgen.} =
  result = outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin)

wasmBindgenFinalize()
```

---

## Emscripten-Specific Features

```nim
import nimbling/emscripten

# EM_ASM inline JavaScript
proc alert*(msg: string) =
  EM_ASM:
    alert UTF8ToString($0, $1)

# Set a DOM element's text
proc setElementText*(id, text: string) =
  EM_ASM:
    document.getElementById(UTF8ToString($0)).textContent = UTF8ToString($2, $3)

# Module.ccall usage
proc ccallAdd(a, b: int32): int32 =
  result = -1
  EM_ASM:
    Module.ccall('add', 'number', ['number', 'number'], [$0, $1])
```

---

## Next Steps

- [Getting Started](getting-started.md) — Set up your first project
- [API Reference](api.md) — Full API documentation
- [WebIDL Guide](webidl-guide.md) — Using web_sys bindings
- [Troubleshooting](troubleshooting.md) — Common issues