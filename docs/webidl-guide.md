# WebIDL Guide

Using `webidlBind` to generate Nim bindings from WebIDL definitions at compile time.

---

## Overview

WebIDL (Web Interface Definition Language) is a specification language for describing Web APIs. nimbling includes a `webidlBind` macro that parses WebIDL at compile time and generates Nim types and proc bindings.

This is similar to how `web-sys` works in Rust's wasm-bindgen ecosystem, but integrated directly into Nim's compile-time macro system.

---

## Basic Usage

```nim
import nimbling/runtime, nimbling/macroimpl_webidl

webidlBind("""
  interface Node {
    readonly attribute unsigned short nodeType;
    Node appendChild(Node newChild);
  };
""")
```

The macro generates:

```nim
type Node* = distinct JsValue

proc nodeType*(self: Node): uint16 =
  when defined(wasm32):
    {.emit: "`result` = heap[`self`.idx].nodeType;".}
  else:
    result = 0

proc appendChild*(self: Node, newChild: Node): Node =
  when defined(wasm32):
    {.emit: """
    var ret = heap[`self`.idx].appendChild(heap[`newChild`.idx]);
    `result` = {idx: addHeapObject(ret)};
    """.}
  else:
    result = Node(JsValue(idx: 0))
```

---

## Supported WebIDL Constructs

### Interfaces

Basic interface with attributes and methods:

```webidl
interface Element {
  attribute DOMString? id;
  attribute DOMString className;
  readonly attribute DOMString tagName;

  Element? getElementById(DOMString id);
  Element appendChild(Element newChild);
  void removeChild(Element child);
};
```

Generated:
```nim
type Element* = distinct JsValue

proc id*(self: Element): string =
  when defined(wasm32):
    {.emit: "`result` = heap[`self`.idx].id ?? null;".}
  else: discard

proc `id=`*(self: Element, value: string) =
  when defined(wasm32):
    {.emit: "heap[`self`.idx].id = `value`;".}
  else: discard

# ... and so on
```

### Readonly Attributes

```webidl
interface Document {
  readonly attribute Element? body;
  readonly attribute DOMString title;
  readonly attribute unsigned long width;
  readonly attribute unsigned long height;
};
```

Generated attributes only have getters, no setters.

### Static Methods

```webidl
interface Document {
  static Document createDocument();
  static Document parseHTML(DOMString html);
};
```

Generated as:
```nim
proc createDocument*(): Document =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Document.createHTMLDocument())};".}
  else:
    result = Document(JsValue(idx: 0))
```

### Dictionaries

```webidl
dictionary EventInit {
  boolean bubbles = false;
  boolean cancelable = false;
  boolean composed = false;
};

dictionary AddEventListenerOptions {
  boolean passive = false;
  boolean once = false;
  boolean capture = false;
};
```

Generated as Nim objects with default values:
```nim
type
  EventInit* = object
    bubbles*: bool
    cancelable*: bool
    composed*: bool

  AddEventListenerOptions* = object
    passive*: bool
    once*: bool
    capture*: bool
```

### Enums

```webidl
enum ScrollBehavior { "auto", "instant", "smooth" };
enum VisibilityState { "hidden", "visible" };
enum DocumentReadyState { "loading", "interactive", "complete" };
```

Generated as Nim enums:
```nim
type
  ScrollBehavior* = enum
    ScrollBehavior_auto
    ScrollBehavior_instant
    ScrollBehavior_smooth

  VisibilityState* = enum
    VisibilityState_hidden
    VisibilityState_visible

  DocumentReadyState* = enum
    DocumentReadyState_loading
    DocumentReadyState_interactive
    DocumentReadyState_complete
```

### Namespaces

```webidl
namespace console {
  void log(any... data);
  void warn(any... data);
  void error(any... data);
};
```

Generated as standalone procs:
```nim
proc log*(data: JsValue) =
  when defined(wasm32):
    {.emit: "console.log(...heap[`data`.idx]);".}
  else: discard

proc warn*(data: JsValue) =
  when defined(wasm32):
    {.emit: "console.warn(...heap[`data`.idx]);".}
  else: discard
```

### Callback Interfaces

```webidl
callback interface EventListener {
  void handleEvent(Event event);
};
```

Generated as a proc type:
```nim
type EventListener* = proc(event: Event)

proc handleEvent*(listener: EventListener, event: Event) =
  when defined(wasm32):
    {.emit: "heap[`listener`.idx](heap[`event`.idx]);".}
  else: discard
```

### Partial Interfaces

```webidl
interface Document {
  attribute DOMString? title;
};

partial interface Document {
  void exitFullscreen();
};
```

Both are merged into a single interface definition.

### Includes

```webidl
interface Node : EventTarget {
  attribute DOMString? nodeName;
};

interface Document : Node {
  // inherits from Node
};
```

The macro handles inheritance through includes.

### Getters and Setters

```webidl
interface DOMStringMap {
  getter DOMString (DOMString name);
  setter void (DOMString name, DOMString value);
};
```

### Indexing

```webidl
interface HTMLCollection {
  getter Element? item(unsigned long index);
  readonly attribute unsigned long length;
};
```

---

## Type Mapping

### WebIDL to Nim Types

| WebIDL Type | Nim Type |
|-------------|----------|
| `boolean` | `bool` |
| `byte` | `int8` |
| `octet` | `uint8` |
| `short` | `int16` |
| `unsigned short` | `uint16` |
| `long` | `int32` |
| `unsigned long` | `uint32` |
| `long long` | `int64` |
| `unsigned long long` | `uint64` |
| `float` | `float32` |
| `unrestricted float` | `float32` |
| `double` | `float64` |
| `unrestricted double` | `float64` |
| `DOMString` | `string` |
| `USVString` | `string` |
| `ByteString` | `seq[byte]` |
| `void` | (no return) |
| `any` | `JsValue` |
| `object` | `JsValue` |
| `ArrayBuffer` | `JsValue` |
| `BufferSource` | `JsValue` |

### Nullable Types

```webidl
interface Foo {
  attribute DOMString? nullable;
  DOMString? getName();
};
```

Nullable types are represented as Option[T] or handled with null checks.

### Union Types

```webidl
interface EventTarget {
  void addEventListener(DOMString type, EventListener? callback);
  void addEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
};
```

Union types are mapped to JsValue with runtime type checking.

---

## Extended Attributes

The parser handles common WebIDL extended attributes:

| Attribute | Description |
|-----------|-------------|
| `[Pure]` | Function has no side effects |
| `[Throws]` | Function may throw |
| `[NewObject]` | Returns a new object |
| `[CheckThis]` | Verify 'this' is correct type |
| `[Clsamp]` | Clamp value to byte range |

---

## Using web_sys Bindings

nimbling includes pre-generated bindings for common Web APIs:

### Window and Document

```nim
import nimble/web_sys

let win = window()
let doc = win.document()

# Query elements
let canvas = doc.getElementById("myCanvas")
let button = doc.querySelector(".btn")
let divs = doc.querySelectorAll("div")

# Create elements
let p = doc.createElement("p")
p.textContent = "Hello"
doc.body.appendChild(p)
```

### DOM Manipulation

```nim
import nimble/web_sys

# Set attributes
div.setAttribute("class", "container")
div.setAttribute("id", "main")

# Get attributes
let className = div.getAttribute("class")

# Style
div.style.color = "red"
div.style.fontSize = "16px"

# Classes
div.classList.add("active")
div.classList.remove("hidden")
if div.classList.contains("active"):
  div.classList.toggle("highlight")
```

### Events

```nim
import nimble/web_sys

proc myHandler(event: Event) =
  echo "Clicked!"

button.addEventListener("click", myHandler)

# With options
button.addEventListener("click", handler,
  AddEventListenerOptions(passive: false, capture: false))

# Remove listener
button.removeEventListener("click", myHandler)
```

### Canvas 2D

```nim
import nimble/web_sys

let canvas = doc.getElementById("canvas")
let ctx = canvas.getContext("2d")

# Drawing
ctx.fillStyle = "#ff0000"
ctx.fillRect(0, 0, 100, 100)

ctx.fillStyle = "#0000ff"
ctx.beginPath()
ctx.arc(50, 50, 25, 0, 2 * 3.14159)
ctx.fill()

# Text
ctx.font = "16px Arial"
ctx.fillText("Hello", 10, 50)
```

### Fetch API

```nim
import nimble/web_sys

proc onLoad(data: JsValue) =
  echo "Loaded"

proc onError(err: JsValue) =
  echo "Error"

# fetch() returns a Promise - use with callbacks
let req = fetch("/api/data")
# Note: For full Promise support, use async/await via emscripten
```

### Console

```nim
import nimble/web_sys

console.log("Message")
console.log("Value: ", 42)
console.warn("Warning")
console.error("Error: ", "something failed")
console.info("Info: ", true)
console.debug("Debug info")
```

---

## Complete Example

```nim
import nimble/web_sys

proc main() =
  let doc = window().document()

  # Create a simple UI
  let container = doc.createElement("div")
  container.setAttribute("id", "app")
  container.style.textAlign = "center"
  container.style.marginTop = "50px"

  let heading = doc.createElement("h1")
  heading.textContent = "Nim + WebAssembly"
  container.appendChild(heading)

  let button = doc.createElement("button")
  button.textContent = "Click me"
  button.style.padding = "10px 20px"
  button.style.fontSize = "16px"

  var clickCount = 0
  proc onClick(e: Event) =
    clickCount += 1
    echo "Clicked ", clickCount, " times"

  button.addEventListener("click", onClick)
  container.appendChild(button)

  discard doc.body.appendChild(container)

# Run
main()
```

---

## Limitations

- Overloaded methods not yet supported — first overload wins
- Stringifier attributes not yet handled
- Iterable/iterator interfaces not yet supported
- Some complex union types may not parse correctly
- `any` type maps to `JsValue` without type checking

---

## Batch Conversion

To generate bindings from all WebIDL files in the specification:

```bash
# Parse all WebIDL files
nim c --path:src -r tools/batch_webidl.nim

# This generates web_sys_generated.nim with 1,449 types
```

See [ROADMAP.md](../ROADMAP.md) for the status of WebIDL codegen.

---

## See Also

- [API Reference](api.md) — `webidlBind` and web_sys API
- [Architecture](architecture.md) — How webidlBind works
- [Examples](examples.md) — WebIDL usage examples
- [Troubleshooting](troubleshooting.md) — Common WebIDL issues