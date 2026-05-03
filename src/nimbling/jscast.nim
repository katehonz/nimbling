import std/options
import runtime

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

proc hasType*[T: distinct JsValue](val: JsValue, className: string): bool =
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

proc uncheckedInto*[T: distinct JsValue](val: JsValue): T {.inline.} =
  T(val)

proc uncheckedRef*[T: distinct JsValue](val: JsValue): T {.inline.} =
  T(val)

proc upcastRef*[T: distinct JsValue](val: JsValue): T {.inline.} =
  T(val)

proc dynInto*[T: distinct JsValue](val: JsValue, className: string): Option[T] =
  var ok: bool
  when defined(wasm32):
    {.emit: """
    var cn = `className`;
    var ctor = globalThis[cn];
    `ok` = (typeof ctor === 'function' && heap[`val`.idx] instanceof ctor) ? 1 : 0;
    """.}
  else:
    ok = false
  if ok:
    result = some(T(val))
  else:
    result = none(T)

proc dynRef*[T: distinct JsValue](val: JsValue, className: string): Option[T] =
  var ok: bool
  when defined(wasm32):
    {.emit: """
    var cn = `className`;
    var ctor = globalThis[cn];
    `ok` = (typeof ctor === 'function' && heap[`val`.idx] instanceof ctor) ? 1 : 0;
    """.}
  else:
    ok = false
  if ok:
    result = some(T(val))
  else:
    result = none(T)

proc isInstanceOfName*(val: JsValue, className: string): bool =
  when defined(wasm32):
    {.emit: """
    var cn = `className`;
    var obj = heap[`val`.idx];
    var parts = cn.split('.');
    var cur = globalThis;
    for (var i = 0; i < parts.length; i++) {
      cur = cur[parts[i]];
      if (cur === undefined || cur === null) {
        `result` = 0;
        return;
      }
    }
    `result` = obj instanceof cur ? 1 : 0;
    """.}
  else:
    result = false

proc hasTypeName*(val: JsValue, className: string): bool =
  when defined(wasm32):
    {.emit: """
    var cn = `className`;
    var obj = heap[`val`.idx];
    var parts = cn.split('.');
    var cur = globalThis;
    for (var i = 0; i < parts.length; i++) {
      cur = cur[parts[i]];
      if (typeof cur === 'undefined' || cur === null) {
        `result` = 0;
        return;
      }
    }
    `result` = obj instanceof cur ? 1 : 0;
    """.}
  else:
    result = false

proc jsCastConstructorCheck*(val: JsValue, constructor: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`val`.idx] instanceof heap[`constructor`.idx] ? 1 : 0;".}
  else:
    result = false

proc jsCastTypeName*(val: JsValue): string =
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

proc jsCastTypeOf*(val: JsValue): string =
  when defined(wasm32):
    {.emit: """
    var s = typeof heap[`val`.idx];
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc dynIntoByCtor*[T: distinct JsValue](val: JsValue, constructor: JsValue): Option[T] =
  var ok: bool
  when defined(wasm32):
    {.emit: "`ok` = heap[`val`.idx] instanceof heap[`constructor`.idx] ? 1 : 0;".}
  else:
    ok = false
  if ok:
    result = some(T(val))
  else:
    result = none(T)
