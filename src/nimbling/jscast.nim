## JsCast / Upcast type system for nimbling
## Mirrors Rust wasm-bindgen's JsCast trait.
##
## Design:
## - Every `distinct JsValue` type can be cast.
## - `jsClassName(T)` returns the JS constructor name for instanceof checks.
## - `uncheckedInto` is zero-cost (distinct cast).
## - `dynInto` does runtime `instanceof` check via JS.
## - `upcast` converters chain automatically in Nim.

import std/options
import runtime

# ─── Class name registry ───
# Override `jsClassName` per type with a template overload, e.g.:
#   template jsClassName*(T: typedesc[JsElement]): string = "Element"

template jsClassName*(T: typedesc[JsValue]): string = "Object"

# ─── Runtime instanceof checks ───

proc isInstanceOf*(val: JsValue, className: string): bool =
  when defined(wasm32):
    {.emit: """
    var cn = `className`;
    var ctor = globalThis[cn];
    if (typeof ctor === 'function') {
      `result` = heap[`val`.idx] instanceof ctor ? 1 : 0;
    } else {
      `result` = 0;
    }
    """.}
  else:
    result = false

proc isInstanceOfByName*(val: JsValue, dottedName: string): bool =
  ## Dotted name like "WebGL.RenderingContext".
  when defined(wasm32):
    {.emit: """
    var parts = `dottedName`.split('.');
    var cur = globalThis;
    for (var i = 0; i < parts.length; i++) {
      cur = cur[parts[i]];
      if (cur === undefined || cur === null) {
        `result` = 0;
        return;
      }
    }
    `result` = heap[`val`.idx] instanceof cur ? 1 : 0;
    """.}
  else:
    result = false

proc jsTypeName*(val: JsValue): string =
  when defined(wasm32):
    {.emit: """
    var obj = heap[`val`.idx];
    var s;
    if (obj === null) {
      s = 'null';
    } else if (obj === undefined) {
      s = 'undefined';
    } else if (typeof obj.constructor === 'function' && obj.constructor.name) {
      s = obj.constructor.name;
    } else {
      s = typeof obj;
    }
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── Zero-cost casts ───

proc uncheckedInto*[T](val: JsValue): T {.inline.} =
  ## Zero-cost cast from raw `JsValue` to any `distinct JsValue` type.
  ## Usage: `let el = uncheckedInto[JsElement](raw)`
  T(val)

proc uncheckedFrom*[T](val: T): JsValue {.inline.} =
  ## Zero-cost cast from `distinct JsValue` back to raw `JsValue`.
  JsValue(val)

proc uncheckedTo*(val: JsValue, target: typedesc[JsValue]): JsValue {.inline.} =
  ## Identity cast for JsValue (method-call syntax).
  val

proc uncheckedTo*[T](val: JsValue, target: typedesc[T]): T {.inline.} =
  ## Zero-cost cast from raw `JsValue` to a distinct type (method-call syntax).
  ## Usage: `let el = raw.uncheckedTo(JsElement)`
  T(val)

proc uncheckedTo*[D, B](val: D, target: typedesc[B]): B {.inline.} =
  ## Zero-cost cast from one `distinct JsValue` to another (method-call syntax).
  ## Usage: `let node = el.uncheckedTo(JsNode)`
  B(JsValue(val))

# ─── Checked casts ───

proc dynInto*[T](val: JsValue): Option[T] =
  ## Checked cast using `jsClassName(T)`. Returns `none` if `instanceof` fails.
  ## Usage: `let opt = dynInto[JsElement](raw)`
  when compiles(jsClassName(T)):
    if isInstanceOf(val, jsClassName(T)):
      result = some(T(val))
    else:
      result = none(T)
  else:
    result = none(T)

proc dynTo*[T](val: JsValue, target: typedesc[T]): Option[T] =
  ## Checked cast from raw JsValue to a distinct type (method-call syntax).
  ## Usage: `let opt = raw.dynTo(JsElement)`
  when compiles(jsClassName(T)):
    if isInstanceOf(val, jsClassName(T)):
      result = some(T(val))
    else:
      result = none(T)
  else:
    result = none(T)

proc dynTo*[D, T](val: D, target: typedesc[T]): Option[T] =
  ## Checked cast from one distinct type to another (method-call syntax).
  when compiles(jsClassName(T)):
    if isInstanceOf(JsValue(val), jsClassName(T)):
      result = some(T(JsValue(val)))
    else:
      result = none(T)
  else:
    result = none(T)

# ─── Upcast ───

proc upcastTo*[T](val: JsValue, target: typedesc[T]): T {.inline.} =
  ## Upcast from raw JsValue to a base distinct type.
  T(val)

proc upcastTo*[D, B](val: D, target: typedesc[B]): B {.inline.} =
  ## Upcast from derived to base (method-call syntax).
  ## Usage: `let el = canvas.upcastTo(JsElement)`
  B(JsValue(val))

proc upcastToJsValue*[T](val: T): JsValue {.inline.} =
  ## Upcast any distinct JsValue to raw JsValue.
  JsValue(val)

# ─── Method-call syntax helpers ───

proc isInstanceOf*[T](val: T, className: string): bool =
  isInstanceOf(JsValue(val), className)

proc jsTypeName*[T](val: T): string =
  jsTypeName(JsValue(val))
