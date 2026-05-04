## js-sys equivalent for nimbling: bindings to JavaScript built-in APIs.
## Mirrors Rust's js-sys crate.

import runtime

# ─── Array ───

type JsArray* = distinct JsValue

proc newJsArray*(): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Array())};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayLen*(arr: JsArray): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsArrayPush*(arr: JsArray, val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].push(heap[`val`.idx]);".}
  else:
    discard

proc jsArrayGet*(arr: JsArray, idx: int): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx][`idx`])};".}
  else:
    result = JsValue(idx: 0)

proc jsArraySet*(arr: JsArray, idx: int, val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = heap[`val`.idx];".}
  else:
    discard

proc jsArraySlice*(arr: JsArray, start: int = 0, stop: int = -1): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArraySplice*(arr: JsArray, start: int, deleteCount: int): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].splice(`start`, `deleteCount`))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayConcat*(arr: JsArray, other: JsArray): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].concat(heap[`other`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayIncludes*(arr: JsArray, val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].includes(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsArrayJoin*(arr: JsArray, sep: string = ","): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var arr = heap[`arr`.idx];
    var sep = `sep`;
    var joined = arr.join(sep);
    var len = joined.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = joined.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsArrayReverse*(arr: JsArray): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].reverse())};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArraySort*(arr: JsArray): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].sort())};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayIndexOf*(arr: JsArray, val: JsValue, fromIndex: int = 0): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].indexOf(heap[`val`.idx], `fromIndex`);".}
  else:
    result = -1

proc jsArrayForEach*(arr: JsArray, callback: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].forEach(heap[`callback`.idx]);".}
  else:
    discard

proc jsArrayMap*(arr: JsArray, callback: JsValue): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].map(heap[`callback`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayFilter*(arr: JsArray, callback: JsValue): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].filter(heap[`callback`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayReduce*(arr: JsArray, callback: JsValue, initialValue: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].reduce(heap[`callback`.idx], heap[`initialValue`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsArrayFind*(arr: JsArray, callback: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].find(heap[`callback`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsArraySome*(arr: JsArray, callback: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].some(heap[`callback`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsArrayEvery*(arr: JsArray, callback: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].every(heap[`callback`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── Object ───

type JsObject* = distinct JsValue

proc newJsObject*(): JsObject =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Object())};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectKeys*(obj: JsObject): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.keys(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsObjectValues*(obj: JsObject): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.values(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsObjectEntries*(obj: JsObject): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.entries(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsObjectAssign*(target: JsObject, source: JsObject): JsObject =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.assign(heap[`target`.idx], heap[`source`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectGet*(obj: JsObject, prop: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var key = `prop`;
    `result` = {idx: addHeapObject(heap[`obj`.idx][key])};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsObjectSet*(obj: JsObject, prop: string, val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`obj`.idx][`prop`] = heap[`val`.idx];".}
  else:
    discard

proc jsObjectHas*(obj: JsObject, prop: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`obj`.idx].hasOwnProperty(`prop`) ? 1 : 0;".}
  else:
    result = false

proc jsObjectDelete*(obj: JsObject, prop: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = __nbg_delete_prop(`obj`.idx, `prop`);".}
  else:
    result = false

proc jsObjectFreeze*(obj: JsObject): JsObject =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.freeze(heap[`obj`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectSeal*(obj: JsObject): JsObject =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.seal(heap[`obj`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

# ─── Promise ───

type JsPromise* = distinct JsValue

proc newJsPromise*(executor: proc(resolve, reject: JsValue)): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    `result` = {idx: addHeapObject(new Promise(function(resolve, reject) {
      var resolveObj = {idx: addHeapObject(resolve)};
      var rejectObj = {idx: addHeapObject(reject)};
      // Call the Nim closure — it expects two JsValue args
      var fn = heap[`executor`.idx];
      fn(resolveObj, rejectObj);
    }))};
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseResolve*(val: JsValue): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Promise.resolve(heap[`val`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseReject*(val: JsValue): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Promise.reject(heap[`val`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseAll*(promises: JsArray): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Promise.all(heap[`promises`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseRace*(promises: JsArray): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Promise.race(heap[`promises`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseThen*(promise: JsPromise, onFulfilled: JsValue): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`promise`.idx].then(heap[`onFulfilled`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseCatch*(promise: JsPromise, onRejected: JsValue): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`promise`.idx].catch(heap[`onRejected`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseFinally*(promise: JsPromise, onFinally: JsValue): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`promise`.idx].finally(heap[`onFinally`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

# ─── JsFuture — Promise bridge for async/await ───

proc jsFutureToPromise*(future: JsFuture): JsPromise {.inline.} =
  ## Convert a JsFuture to a JsPromise.
  JsPromise(JsValue(future))

proc jsPromiseToFuture*(promise: JsPromise): JsFuture {.inline.} =
  ## Convert a JsPromise to a JsFuture.
  JsFuture(JsValue(promise))

proc jsFutureResolved*(value: JsValue): JsFuture =
  ## Create a JsFuture that is already resolved with `value`.
  jsPromiseToFuture(jsPromiseResolve(value))

proc jsFutureRejected*(reason: JsValue): JsFuture =
  ## Create a JsFuture that is already rejected with `reason`.
  jsPromiseToFuture(jsPromiseReject(reason))

proc jsFutureThen*(future: JsFuture, onFulfilled: JsValue): JsFuture =
  ## Add a fulfillment callback. Returns a new JsFuture for chaining.
  jsPromiseToFuture(jsPromiseThen(jsFutureToPromise(future), onFulfilled))

proc jsFutureCatch*(future: JsFuture, onRejected: JsValue): JsFuture =
  ## Add a rejection callback. Returns a new JsFuture for chaining.
  jsPromiseToFuture(jsPromiseCatch(jsFutureToPromise(future), onRejected))

proc jsFutureFinally*(future: JsFuture, onFinally: JsValue): JsFuture =
  ## Add a finally callback. Returns a new JsFuture for chaining.
  jsPromiseToFuture(jsPromiseFinally(jsFutureToPromise(future), onFinally))

proc jsFutureAll*(futures: seq[JsFuture]): JsFuture =
  ## Wait for all futures to resolve.
  let arr = newJsArray()
  for f in futures:
    jsArrayPush(arr, JsValue(f))
  jsPromiseToFuture(jsPromiseAll(arr))

proc jsFutureRace*(futures: seq[JsFuture]): JsFuture =
  ## Wait for the first future to resolve/reject.
  let arr = newJsArray()
  for f in futures:
    jsArrayPush(arr, JsValue(f))
  jsPromiseToFuture(jsPromiseRace(arr))

# ─── Date ───

type JsDate* = distinct JsValue

proc newJsDate*(): JsDate =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Date())};".}
  else:
    result = JsDate(JsValue(idx: 0))

proc newJsDateFromMs*(ms: float64): JsDate =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Date(`ms`))};".}
  else:
    result = JsDate(JsValue(idx: 0))

proc newJsDateFromString*(dateStr: string): JsDate =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = `dateStr`;
    `result` = {idx: addHeapObject(new Date(s))};
    """.}
  else:
    result = JsDate(JsValue(idx: 0))

proc jsDateNow*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Date.now();".}
  else:
    result = 0.0

proc jsDateGetTime*(date: JsDate): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getTime();".}
  else:
    result = 0.0

proc jsDateToISOString*(date: JsDate): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var iso = heap[`date`.idx].toISOString();
    var len = iso.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = iso.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsDateToLocaleString*(date: JsDate): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`date`.idx].toLocaleString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsDateGetFullYear*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getFullYear();".}
  else:
    result = 0

proc jsDateGetMonth*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getMonth();".}
  else:
    result = 0

proc jsDateGetDate*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getDate();".}
  else:
    result = 0

proc jsDateGetHours*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getHours();".}
  else:
    result = 0

proc jsDateGetMinutes*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getMinutes();".}
  else:
    result = 0

proc jsDateGetSeconds*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getSeconds();".}
  else:
    result = 0

proc jsDateValueOf*(date: JsDate): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].valueOf();".}
  else:
    result = 0.0

# ─── RegExp ───

type JsRegExp* = distinct JsValue

proc newJsRegExp*(pattern: string, flags: string = ""): JsRegExp =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var p = `pattern`;
    var f = `flags`;
    `result` = {idx: addHeapObject(new RegExp(p, f))};
    """.}
  else:
    result = JsRegExp(JsValue(idx: 0))

proc jsRegExpTest*(re: JsRegExp, str: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = `str`;
    `result` = heap[`re`.idx].test(s) ? 1 : 0;
    """.}
  else:
    result = false

proc jsRegExpExec*(re: JsRegExp, str: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = `str`;
    `result` = {idx: addHeapObject(heap[`re`.idx].exec(s))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsRegExpToString*(re: JsRegExp): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`re`.idx].toString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsRegExpSource*(re: JsRegExp): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`re`.idx].source;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsRegExpFlags*(re: JsRegExp): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`re`.idx].flags;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── Math ───

proc jsMathSqrt*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.sqrt(`x`);".}
  else:
    result = 0.0

proc jsMathRandom*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.random();".}
  else:
    result = 0.0

proc jsMathSin*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.sin(`x`);".}
  else:
    result = 0.0

proc jsMathCos*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.cos(`x`);".}
  else:
    result = 0.0

proc jsMathTan*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.tan(`x`);".}
  else:
    result = 0.0

proc jsMathAsin*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.asin(`x`);".}
  else:
    result = 0.0

proc jsMathAcos*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.acos(`x`);".}
  else:
    result = 0.0

proc jsMathAtan*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.atan(`x`);".}
  else:
    result = 0.0

proc jsMathAtan2*(y: float64, x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.atan2(`y`, `x`);".}
  else:
    result = 0.0

proc jsMathFloor*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.floor(`x`);".}
  else:
    result = 0.0

proc jsMathCeil*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.ceil(`x`);".}
  else:
    result = 0.0

proc jsMathRound*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.round(`x`);".}
  else:
    result = 0.0

proc jsMathTrunc*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.trunc(`x`);".}
  else:
    result = 0.0

proc jsMathAbs*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.abs(`x`);".}
  else:
    result = 0.0

proc jsMathSign*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.sign(`x`);".}
  else:
    result = 0.0

proc jsMathPow*(base: float64, exp: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.pow(`base`, `exp`);".}
  else:
    result = 0.0

proc jsMathExp*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.exp(`x`);".}
  else:
    result = 0.0

proc jsMathLog*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.log(`x`);".}
  else:
    result = 0.0

proc jsMathLog2*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.log2(`x`);".}
  else:
    result = 0.0

proc jsMathLog10*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.log10(`x`);".}
  else:
    result = 0.0

proc jsMathMax*(a: float64, b: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.max(`a`, `b`);".}
  else:
    result = 0.0

proc jsMathMin*(a: float64, b: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.min(`a`, `b`);".}
  else:
    result = 0.0

proc jsMathClamp*(x: float64, lo: float64, hi: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.min(Math.max(`x`, `lo`), `hi`);".}
  else:
    result = 0.0

proc jsMathHypot*(a: float64, b: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.hypot(`a`, `b`);".}
  else:
    result = 0.0

# ─── JSON ───

proc jsJsonParse*(str: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = `str`;
    `result` = {idx: addHeapObject(JSON.parse(s))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsJsonStringify*(val: JsValue): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = JSON.stringify(heap[`val`.idx]);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsJsonStringifyPretty*(val: JsValue, indent: int = 2): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = JSON.stringify(heap[`val`.idx], null, `indent`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── Map ───

type JsMap* = distinct JsValue

proc newJsMap*(): JsMap =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Map())};".}
  else:
    result = JsMap(JsValue(idx: 0))

proc jsMapSet*(map: JsMap, key: JsValue, val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`map`.idx].set(heap[`key`.idx], heap[`val`.idx]);".}
  else:
    discard

proc jsMapGet*(map: JsMap, key: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`map`.idx].get(heap[`key`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsMapHas*(map: JsMap, key: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`map`.idx].has(heap[`key`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsMapDelete*(map: JsMap, key: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`map`.idx].delete(heap[`key`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsMapSize*(map: JsMap): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`map`.idx].size;".}
  else:
    result = 0

proc jsMapClear*(map: JsMap) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`map`.idx].clear();".}
  else:
    discard

proc jsMapKeys*(map: JsMap): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`map`.idx].keys())};".}
  else:
    result = JsValue(idx: 0)

proc jsMapValues*(map: JsMap): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`map`.idx].values())};".}
  else:
    result = JsValue(idx: 0)

proc jsMapEntries*(map: JsMap): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`map`.idx].entries())};".}
  else:
    result = JsValue(idx: 0)

proc jsMapForEach*(map: JsMap, callback: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`map`.idx].forEach(heap[`callback`.idx]);".}
  else:
    discard

# ─── Set ───

type JsSet* = distinct JsValue

proc newJsSet*(): JsSet =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Set())};".}
  else:
    result = JsSet(JsValue(idx: 0))

proc jsSetAdd*(s: JsSet, val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`s`.idx].add(heap[`val`.idx]);".}
  else:
    discard

proc jsSetHas*(s: JsSet, val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`s`.idx].has(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsSetDelete*(s: JsSet, val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`s`.idx].delete(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsSetSize*(s: JsSet): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`s`.idx].size;".}
  else:
    result = 0

proc jsSetClear*(s: JsSet) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`s`.idx].clear();".}
  else:
    discard

proc jsSetValues*(s: JsSet): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`s`.idx].values())};".}
  else:
    result = JsValue(idx: 0)

proc jsSetForEach*(s: JsSet, callback: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`s`.idx].forEach(heap[`callback`.idx]);".}
  else:
    discard

# ─── WeakMap ───

type JsWeakMap* = distinct JsValue

proc newJsWeakMap*(): JsWeakMap =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new WeakMap())};".}
  else:
    result = JsWeakMap(JsValue(idx: 0))

proc jsWeakMapSet*(wm: JsWeakMap, key: JsValue, val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`wm`.idx].set(heap[`key`.idx], heap[`val`.idx]);".}
  else:
    discard

proc jsWeakMapGet*(wm: JsWeakMap, key: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`wm`.idx].get(heap[`key`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsWeakMapHas*(wm: JsWeakMap, key: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`wm`.idx].has(heap[`key`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsWeakMapDelete*(wm: JsWeakMap, key: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`wm`.idx].delete(heap[`key`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── WeakSet ───

type JsWeakSet* = distinct JsValue

proc newJsWeakSet*(): JsWeakSet =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new WeakSet())};".}
  else:
    result = JsWeakSet(JsValue(idx: 0))

proc jsWeakSetAdd*(ws: JsWeakSet, val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`ws`.idx].add(heap[`val`.idx]);".}
  else:
    discard

proc jsWeakSetHas*(ws: JsWeakSet, val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`ws`.idx].has(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsWeakSetDelete*(ws: JsWeakSet, val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`ws`.idx].delete(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── Error ───

type JsError* = distinct JsValue

proc newJsError*(msg: string): JsError =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var m = `msg`;
    `result` = {idx: addHeapObject(new Error(m))};
    """.}
  else:
    result = JsError(JsValue(idx: 0))

proc jsErrorMessage*(err: JsError): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`err`.idx].message;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsErrorStack*(err: JsError): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`err`.idx].stack || "";
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsErrorName*(err: JsError): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`err`.idx].name;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc newJsTypeError*(msg: string): JsError =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var m = `msg`;
    `result` = {idx: addHeapObject(new TypeError(m))};
    """.}
  else:
    result = JsError(JsValue(idx: 0))

proc newJsRangeError*(msg: string): JsError =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var m = `msg`;
    `result` = {idx: addHeapObject(new RangeError(m))};
    """.}
  else:
    result = JsError(JsValue(idx: 0))

# ─── Reflect ───

proc jsReflectGet*(obj: JsValue, prop: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Reflect.get(heap[`obj`.idx], `prop`))};".}
  else:
    result = JsValue(idx: 0)

proc jsReflectSet*(obj: JsValue, prop: string, val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Reflect.set(heap[`obj`.idx], `prop`, heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsReflectHas*(obj: JsValue, prop: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Reflect.has(heap[`obj`.idx], `prop`) ? 1 : 0;".}
  else:
    result = false

proc jsReflectDeleteProperty*(obj: JsValue, prop: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Reflect.deleteProperty(heap[`obj`.idx], `prop`) ? 1 : 0;".}
  else:
    result = false

proc jsReflectOwnKeys*(obj: JsValue): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Reflect.ownKeys(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsReflectApply*(funcObj: JsValue, thisArg: JsValue, args: JsArray): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Reflect.apply(heap[`funcObj`.idx], heap[`thisArg`.idx], heap[`args`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsReflectConstruct*(funcObj: JsValue, args: JsArray): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Reflect.construct(heap[`funcObj`.idx], heap[`args`.idx]))};".}
  else:
    result = JsValue(idx: 0)

# ─── Symbol ───

proc jsSymbolFor*(key: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var k = `key`;
    `result` = {idx: addHeapObject(Symbol.for(k))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsSymbolKeyFor*(sym: JsValue): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = Symbol.keyFor(heap[`sym`.idx]);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsSymbolIterator*(): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Symbol.iterator)};".}
  else:
    result = JsValue(idx: 0)

proc jsSymbolToStringTag*(): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Symbol.toStringTag)};".}
  else:
    result = JsValue(idx: 0)

# ─── TypedArrays ───

type JsUint8Array* = distinct JsValue

proc newJsUint8Array*(len: int): JsUint8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Uint8Array(`len`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArrayFromBuffer*(buf: pointer, len: int): JsUint8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var src = new Uint8Array(wasmExports.memory.buffer, `buf`, `len`);
    var copy = new Uint8Array(`len`);
    copy.set(src);
    `result` = {idx: addHeapObject(copy)};
    """.}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArrayLen*(arr: JsUint8Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsUint8ArrayGet*(arr: JsUint8Array, idx: int): uint8 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0'u8

proc jsUint8ArraySet*(arr: JsUint8Array, idx: int, val: uint8) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsUint8ArraySlice*(arr: JsUint8Array, start: int = 0, stop: int = -1): JsUint8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArraySubarray*(arr: JsUint8Array, start: int, stop: int): JsUint8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArrayFill*(arr: JsUint8Array, val: uint8, start: int = 0, stop: int = -1): JsUint8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArraySetFromSlice*(arr: JsUint8Array, offset: int, src: JsUint8Array) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

type JsInt8Array* = distinct JsValue

proc newJsInt8Array*(len: int): JsInt8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Int8Array(`len`))};".}
  else:
    result = JsInt8Array(JsValue(idx: 0))

type JsUint16Array* = distinct JsValue

proc newJsUint16Array*(len: int): JsUint16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Uint16Array(`len`))};".}
  else:
    result = JsUint16Array(JsValue(idx: 0))

type JsInt16Array* = distinct JsValue

proc newJsInt16Array*(len: int): JsInt16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Int16Array(`len`))};".}
  else:
    result = JsInt16Array(JsValue(idx: 0))

type JsUint32Array* = distinct JsValue

proc newJsUint32Array*(len: int): JsUint32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Uint32Array(`len`))};".}
  else:
    result = JsUint32Array(JsValue(idx: 0))

type JsInt32Array* = distinct JsValue

proc newJsInt32Array*(len: int): JsInt32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Int32Array(`len`))};".}
  else:
    result = JsInt32Array(JsValue(idx: 0))

type JsFloat32Array* = distinct JsValue

proc newJsFloat32Array*(len: int): JsFloat32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Float32Array(`len`))};".}
  else:
    result = JsFloat32Array(JsValue(idx: 0))

type JsFloat64Array* = distinct JsValue

proc newJsFloat64Array*(len: int): JsFloat64Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Float64Array(`len`))};".}
  else:
    result = JsFloat64Array(JsValue(idx: 0))

# ─── ArrayBuffer ───

type JsArrayBuffer* = distinct JsValue

proc newJsArrayBuffer*(len: int): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new ArrayBuffer(`len`))};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsArrayBufferByteLength*(buf: JsArrayBuffer): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`buf`.idx].byteLength;".}
  else:
    result = 0

proc jsArrayBufferSlice*(buf: JsArrayBuffer, start: int, stop: int): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`buf`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsArrayBufferIsView*(val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = ArrayBuffer.isView(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── DataView ───

type JsDataView* = distinct JsValue

proc newJsDataView*(buf: JsArrayBuffer, offset: int = 0, len: int = -1): JsDataView =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    if (`len` < 0) {
      `result` = {idx: addHeapObject(new DataView(heap[`buf`.idx], `offset`))};
    } else {
      `result` = {idx: addHeapObject(new DataView(heap[`buf`.idx], `offset`, `len`))};
    }
    """.}
  else:
    result = JsDataView(JsValue(idx: 0))

proc jsDataViewGetUint8*(dv: JsDataView, offset: int): uint8 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getUint8(`offset`);".}
  else:
    result = 0'u8

proc jsDataViewSetUint8*(dv: JsDataView, offset: int, val: uint8) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setUint8(`offset`, `val`);".}
  else:
    discard

proc jsDataViewGetInt32*(dv: JsDataView, offset: int, littleEndian: bool = true): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getInt32(`offset`, `littleEndian`);".}
  else:
    result = 0'i32

proc jsDataViewSetInt32*(dv: JsDataView, offset: int, val: int32, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setInt32(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetUint32*(dv: JsDataView, offset: int, littleEndian: bool = true): uint32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getUint32(`offset`, `littleEndian`);".}
  else:
    result = 0'u32

proc jsDataViewSetUint32*(dv: JsDataView, offset: int, val: uint32, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setUint32(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetFloat32*(dv: JsDataView, offset: int, littleEndian: bool = true): float32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getFloat32(`offset`, `littleEndian`);".}
  else:
    result = 0'f32

proc jsDataViewSetFloat32*(dv: JsDataView, offset: int, val: float32, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setFloat32(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetFloat64*(dv: JsDataView, offset: int, littleEndian: bool = true): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getFloat64(`offset`, `littleEndian`);".}
  else:
    result = 0.0

proc jsDataViewSetFloat64*(dv: JsDataView, offset: int, val: float64, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setFloat64(`offset`, `val`, `littleEndian`);".}
  else:
    discard

# ─── Console ───

proc jsConsoleLog*(val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.log(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleLogStr*(msg: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var m = `msg`;
    console.log(m);
    """.}
  else:
    discard

proc jsConsoleWarn*(val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.warn(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleError*(val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.error(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleInfo*(val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.info(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleDebug*(val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.debug(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleTime*(label: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.time(`label`);".}
  else:
    discard

proc jsConsoleTimeEnd*(label: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.timeEnd(`label`);".}
  else:
    discard

proc jsConsoleAssert*(condition: bool, msg: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.assert(`condition`, `msg`);".}
  else:
    discard

# ─── Global / eval ───

proc jsGlobalThis*(): JsObject =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(globalThis)};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsEval*(code: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var c = `code`;
    `result` = {idx: addHeapObject(eval(c))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsTypeOf*(val: JsValue): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = __nbg_typeof(`val`.idx);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsInstanceOf*(val: JsValue, constructor: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = __nbg_instanceof(`val`.idx, `constructor`.idx);".}
  else:
    result = false

# ─── Number ───

proc jsNumberIsFinite*(val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Number.isFinite(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsNumberIsNaN*(val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Number.isNaN(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsNumberIsInteger*(val: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Number.isInteger(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsNumberParseFloat*(str: string): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = `str`;
    `result` = parseFloat(s);
    """.}
  else:
    result = 0.0

proc jsNumberParseInt*(str: string, radix: int = 10): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = `str`;
    `result` = parseInt(s, `radix`);
    """.}
  else:
    result = 0

# ─── String ───

proc jsStringFromCharCode*(code: int): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = String.fromCharCode(`code`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringFromCodePoint*(codePoint: int): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = String.fromCodePoint(`codePoint`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── encodeURIComponent / decodeURIComponent ───

proc jsEncodeUriComponent*(str: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = encodeURIComponent(`str`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsDecodeUriComponent*(str: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = decodeURIComponent(`str`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsEncodeUri*(str: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = encodeURI(`str`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsDecodeUri*(str: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = decodeURI(`str`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── setTimeout / setInterval / clearTimeout / clearInterval ───

proc jsSetTimeout*(callback: JsValue, ms: int): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = setTimeout(heap[`callback`.idx], `ms`);".}
  else:
    result = 0

proc jsClearTimeout*(id: int) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "clearTimeout(`id`);".}
  else:
    discard

proc jsSetInterval*(callback: JsValue, ms: int): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = setInterval(heap[`callback`.idx], `ms`);".}
  else:
    result = 0

proc jsClearInterval*(id: int) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "clearInterval(`id`);".}
  else:
    discard

# ─── fetch (minimal) ───

proc jsFetch*(url: string): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var u = `url`;
    `result` = {idx: addHeapObject(fetch(u))};
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsFetchWithInit*(url: string, init: JsValue): JsPromise =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var u = `url`;
    `result` = {idx: addHeapObject(fetch(u, heap[`init`.idx]))};
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))

# ─── Intl API ───

type
  JsIntlDateTimeFormat* = distinct JsValue
  JsIntlNumberFormat* = distinct JsValue
  JsIntlPluralRules* = distinct JsValue
  JsIntlCollator* = distinct JsValue

proc jsNewIntlDateTimeFormat*(locale: string, options: JsValue = JsValue(idx: 0)): JsIntlDateTimeFormat =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var l = `locale`;
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(new Intl.DateTimeFormat(l))};
    } else {
      `result` = {idx: addHeapObject(new Intl.DateTimeFormat(l, heap[o]))};
    }
    """.}
  else:
    result = JsIntlDateTimeFormat(JsValue(idx: 0))

proc jsIntlDateTimeFormatFormat*(fmt: JsIntlDateTimeFormat, date: JsValue): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`fmt`.idx].format(heap[`date`.idx]);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsIntlDateTimeFormatFormatRange*(fmt: JsIntlDateTimeFormat, startDate: JsValue, endDate: JsValue): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`fmt`.idx].formatRange(heap[`startDate`.idx], heap[`endDate`.idx]);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsIntlDateTimeFormatResolvedOptions*(fmt: JsIntlDateTimeFormat): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fmt`.idx].resolvedOptions())};".}
  else:
    result = JsValue(idx: 0)

proc jsNewIntlNumberFormat*(locale: string, options: JsValue = JsValue(idx: 0)): JsIntlNumberFormat =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var l = `locale`;
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(new Intl.NumberFormat(l))};
    } else {
      `result` = {idx: addHeapObject(new Intl.NumberFormat(l, heap[o]))};
    }
    """.}
  else:
    result = JsIntlNumberFormat(JsValue(idx: 0))

proc jsIntlNumberFormatFormat*(fmt: JsIntlNumberFormat, number: JsValue): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`fmt`.idx].format(heap[`number`.idx]);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsIntlNumberFormatFormatToParts*(fmt: JsIntlNumberFormat, number: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fmt`.idx].formatToParts(heap[`number`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsIntlNumberFormatResolvedOptions*(fmt: JsIntlNumberFormat): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fmt`.idx].resolvedOptions())};".}
  else:
    result = JsValue(idx: 0)

proc jsNewIntlPluralRules*(locale: string, options: JsValue = JsValue(idx: 0)): JsIntlPluralRules =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var l = `locale`;
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(new Intl.PluralRules(l))};
    } else {
      `result` = {idx: addHeapObject(new Intl.PluralRules(l, heap[o]))};
    }
    """.}
  else:
    result = JsIntlPluralRules(JsValue(idx: 0))

proc jsIntlPluralRulesSelect*(rules: JsIntlPluralRules, number: int): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`rules`.idx].select(`number`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsNewIntlCollator*(locale: string, options: JsValue = JsValue(idx: 0)): JsIntlCollator =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var l = `locale`;
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(new Intl.Collator(l))};
    } else {
      `result` = {idx: addHeapObject(new Intl.Collator(l, heap[o]))};
    }
    """.}
  else:
    result = JsIntlCollator(JsValue(idx: 0))

proc jsIntlCollatorCompare*(collator: JsIntlCollator, str1: string, str2: string): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`collator`.idx].compare(`str1`, `str2`);".}
  else:
    result = 0

proc jsIntlCollatorResolvedOptions*(collator: JsIntlCollator): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`collator`.idx].resolvedOptions())};".}
  else:
    result = JsValue(idx: 0)

proc jsCreateDateTimeFormatOptions*(year: string, month: string, day: string, hour: string = "", minute: string = "", second: string = "", timeZone: string = ""): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var o = {year: `year`, month: `month`, day: `day`};
    if (`hour` != "") o.hour = `hour`;
    if (`minute` != "") o.minute = `minute`;
    if (`second` != "") o.second = `second`;
    if (`timeZone` != "") o.timeZone = `timeZone`;
    `result` = {idx: addHeapObject(o)};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsCreateNumberFormatOptions*(style: string, minimumFractionDigits: int = 0, maximumFractionDigits: int = 0, useGrouping: bool = true): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject({style: `style`, minimumFractionDigits: `minimumFractionDigits`, maximumFractionDigits: `maximumFractionDigits`, useGrouping: `useGrouping`})};".}
  else:
    result = JsValue(idx: 0)

# ─── WeakRef ───

type JsWeakRef* = distinct JsValue

proc newJsWeakRef*(target: JsValue): JsWeakRef =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new WeakRef(heap[`target`.idx]))};".}
  else:
    result = JsWeakRef(JsValue(idx: 0))

proc deref*(weak: JsWeakRef): JsValue {.inline.} =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`weak`.idx].deref())};".}
  else:
    result = JsValue(idx: 0)

# ─── FinalizationRegistry ───

type JsFinalizationRegistry* = distinct JsValue

proc newJsFinalizationRegistry*(callback: JsValue): JsFinalizationRegistry =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new FinalizationRegistry(heap[`callback`.idx]))};".}
  else:
    result = JsFinalizationRegistry(JsValue(idx: 0))

proc register*(reg: JsFinalizationRegistry, target: JsValue, unregisterToken: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`reg`.idx].register(heap[`target`.idx], heap[`unregisterToken`.idx]);".}
  else:
    discard

proc unregister*(reg: JsFinalizationRegistry, unregisterToken: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`reg`.idx].unregister(heap[`unregisterToken`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── SharedArrayBuffer ───

type JsSharedArrayBuffer* = distinct JsValue

proc newJsSharedArrayBuffer*(byteLength: int32): JsSharedArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new SharedArrayBuffer(`byteLength`))};".}
  else:
    result = JsSharedArrayBuffer(JsValue(idx: 0))

proc jsSharedArrayBufferByteLength*(buf: JsSharedArrayBuffer): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`buf`.idx].byteLength;".}
  else:
    result = 0'i32

proc jsSharedArrayBufferSlice*(buf: JsSharedArrayBuffer, begin: int32, endVal: int32): JsSharedArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`buf`.idx].slice(`begin`, `endVal`))};".}
  else:
    result = JsSharedArrayBuffer(JsValue(idx: 0))

# ─── DataView (int8) ───

proc jsDataViewGetInt8*(dv: JsDataView, byteOffset: int32): int8 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getInt8(`byteOffset`);".}
  else:
    result = 0'i8

proc jsDataViewSetInt8*(dv: JsDataView, byteOffset: int32, value: int8) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setInt8(`byteOffset`, `value`);".}
  else:
    discard

# ─── Proxy ───

type JsProxy* = distinct JsValue

proc newJsProxy*(target: JsValue, handler: JsValue): JsProxy =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Proxy(heap[`target`.idx], heap[`handler`.idx]))};".}
  else:
    result = JsProxy(JsValue(idx: 0))

proc jsProxyRevocable*(target: JsValue, handler: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Proxy.revocable(heap[`target`.idx], heap[`handler`.idx]))};".}
  else:
    result = JsValue(idx: 0)

# ─── BigInt ───

type JsBigInt* = distinct JsValue

proc newJsBigInt*(value: int64): JsBigInt =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(BigInt(`value`))};".}
  else:
    result = JsBigInt(JsValue(idx: 0))

proc newJsBigIntFromString*(value: string): JsBigInt =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var s = `value`; `result` = {idx: addHeapObject(BigInt(s))};".}
  else:
    result = JsBigInt(JsValue(idx: 0))

proc jsBigIntToString*(bi: JsBigInt): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`bi`.idx].toString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsBigIntAsIntN*(bits: int64, bi: JsBigInt): JsBigInt =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(BigInt.asIntN(`bits`, heap[`bi`.idx]))};".}
  else:
    result = JsBigInt(JsValue(idx: 0))

proc jsBigIntAsUintN*(bits: int64, bi: JsBigInt): JsBigInt =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(BigInt.asUintN(`bits`, heap[`bi`.idx]))};".}
  else:
    result = JsBigInt(JsValue(idx: 0))

proc jsBigIntValueOf*(bi: JsBigInt): int64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Number(heap[`bi`.idx]);".}
  else:
    result = 0

# ─── Boolean (typed) ───

type JsBoolean* = distinct JsValue

proc newJsBoolean*(value: bool): JsBoolean =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Boolean(`value`))};".}
  else:
    result = JsBoolean(JsValue(idx: 0))

proc jsBooleanValueOf*(b: JsBoolean): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`b`.idx].valueOf() ? 1 : 0;".}
  else:
    result = false

# ─── Number (typed) ───

type JsNumber* = distinct JsValue

proc newJsNumber*(value: float64): JsNumber =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Number(`value`))};".}
  else:
    result = JsNumber(JsValue(idx: 0))

proc jsNumberValueOf*(n: JsNumber): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`n`.idx].valueOf();".}
  else:
    result = 0.0

# ─── Symbol (typed) ───

type JsSymbol* = distinct JsValue

proc newJsSymbol*(description: string = ""): JsSymbol =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var d = `description`; if (d == \"\") { `result` = {idx: addHeapObject(Symbol())}; } else { `result` = {idx: addHeapObject(Symbol(d))}; }".}
  else:
    result = JsSymbol(JsValue(idx: 0))

proc jsSymbolToString*(sym: JsSymbol): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`sym`.idx].toString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── Function (typed) ───

type JsFunction* = distinct JsValue

proc newJsFunction*(body: string): JsFunction =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var b = `body`; `result` = {idx: addHeapObject(new Function(b))};".}
  else:
    result = JsFunction(JsValue(idx: 0))

proc newJsFunctionWithArgs*(args: seq[string], body: string): JsFunction =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var b = `body`;
    var args = [];
    for (var i = 0; i < `args`.length; i++) args.push(`args`[i]);
    `result` = {idx: addHeapObject(new Function(...args, b))};
    """.}
  else:
    result = JsFunction(JsValue(idx: 0))

proc jsFunctionCall*(fn: JsFunction, thisObj: JsValue, args: JsArray): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fn`.idx].call(heap[`thisObj`.idx], ...heap[`args`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsFunctionApply*(fn: JsFunction, thisObj: JsValue, args: JsArray): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fn`.idx].apply(heap[`thisObj`.idx], heap[`args`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsFunctionBind*(fn: JsFunction, thisObj: JsValue): JsFunction =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fn`.idx].bind(heap[`thisObj`.idx]))};".}
  else:
    result = JsFunction(JsValue(idx: 0))

# ─── Error Hierarchy ───

proc newJsSyntaxError*(msg: string): JsError =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var m = `msg`; `result` = {idx: addHeapObject(new SyntaxError(m))};".}
  else:
    result = JsError(JsValue(idx: 0))

proc newJsReferenceError*(msg: string): JsError =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var m = `msg`; `result` = {idx: addHeapObject(new ReferenceError(m))};".}
  else:
    result = JsError(JsValue(idx: 0))

proc newJsURIError*(msg: string): JsError =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var m = `msg`; `result` = {idx: addHeapObject(new URIError(m))};".}
  else:
    result = JsError(JsValue(idx: 0))

proc newJsEvalError*(msg: string): JsError =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var m = `msg`; `result` = {idx: addHeapObject(new EvalError(m))};".}
  else:
    result = JsError(JsValue(idx: 0))

proc newJsAggregateError*(errors: JsArray, msg: string): JsError =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var m = `msg`; `result` = {idx: addHeapObject(new AggregateError(heap[`errors`.idx], m))};".}
  else:
    result = JsError(JsValue(idx: 0))

# ─── Array Methods (additional) ───

proc jsArrayAt*(arr: JsArray, idx: int): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].at(`idx`))};".}
  else:
    result = JsValue(idx: 0)

proc jsArrayCopyWithin*(arr: JsArray, target: int, start: int, endVal: int = -1): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].copyWithin(`target`, `start`, `endVal`))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayFill*(arr: JsArray, value: JsValue, start: int = 0, stop: int = -1): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(heap[`value`.idx], `start`, `stop`))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayFindIndex*(arr: JsArray, callback: JsValue): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].findIndex(heap[`callback`.idx]);".}
  else:
    result = -1

proc jsArrayFindLast*(arr: JsArray, callback: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].findLast(heap[`callback`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsArrayFindLastIndex*(arr: JsArray, callback: JsValue): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].findLastIndex(heap[`callback`.idx]);".}
  else:
    result = -1

proc jsArrayFlat*(arr: JsArray, depth: int = 1): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].flat(`depth`))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayFlatMap*(arr: JsArray, callback: JsValue): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].flatMap(heap[`callback`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayFrom*(obj: JsValue): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Array.from(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayFromWithMap*(obj: JsValue, mapFn: JsValue): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Array.from(heap[`obj`.idx], heap[`mapFn`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayKeys*(arr: JsArray): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].keys())};".}
  else:
    result = JsValue(idx: 0)

proc jsArrayEntries*(arr: JsArray): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].entries())};".}
  else:
    result = JsValue(idx: 0)

proc jsArrayValues*(arr: JsArray): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].values())};".}
  else:
    result = JsValue(idx: 0)

proc jsArrayOf*(vals: JsArray): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Array.of(...heap[`vals`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayReduceRight*(arr: JsArray, callback: JsValue, initialValue: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].reduceRight(heap[`callback`.idx], heap[`initialValue`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsArrayToLocaleString*(arr: JsArray): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`arr`.idx].toLocaleString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsArrayToReversed*(arr: JsArray): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].toReversed())};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayToSorted*(arr: JsArray, compareFn: JsValue): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].toSorted(heap[`compareFn`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayToSpliced*(arr: JsArray, start: int, deleteCount: int, items: JsArray): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].toSpliced(`start`, `deleteCount`, ...heap[`items`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayUnshift*(arr: JsArray, val: JsValue): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].unshift(heap[`val`.idx]);".}
  else:
    result = 0

proc jsArrayWithVal*(arr: JsArray, idx: int, value: JsValue): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].with(`idx`, heap[`value`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

# ─── DataView (full type set) ───

proc jsDataViewGetInt16*(dv: JsDataView, offset: int, littleEndian: bool = true): int16 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getInt16(`offset`, `littleEndian`);".}
  else:
    result = 0'i16

proc jsDataViewSetInt16*(dv: JsDataView, offset: int, val: int16, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setInt16(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetUint16*(dv: JsDataView, offset: int, littleEndian: bool = true): uint16 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getUint16(`offset`, `littleEndian`);".}
  else:
    result = 0'u16

proc jsDataViewSetUint16*(dv: JsDataView, offset: int, val: uint16, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setUint16(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetFloat16*(dv: JsDataView, offset: int, littleEndian: bool = true): float32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].getFloat16(`offset`, `littleEndian`);".}
  else:
    result = 0'f32

proc jsDataViewSetFloat16*(dv: JsDataView, offset: int, val: float32, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setFloat16(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetBigInt64*(dv: JsDataView, offset: int, littleEndian: bool = true): JsBigInt =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`dv`.idx].getBigInt64(`offset`, `littleEndian`))};".}
  else:
    result = JsBigInt(JsValue(idx: 0))

proc jsDataViewSetBigInt64*(dv: JsDataView, offset: int, val: JsBigInt, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setBigInt64(`offset`, heap[`val`.idx], `littleEndian`);".}
  else:
    discard

proc jsDataViewGetBigUint64*(dv: JsDataView, offset: int, littleEndian: bool = true): JsBigInt =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`dv`.idx].getBigUint64(`offset`, `littleEndian`))};".}
  else:
    result = JsBigInt(JsValue(idx: 0))

proc jsDataViewSetBigUint64*(dv: JsDataView, offset: int, val: JsBigInt, littleEndian: bool = true) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`dv`.idx].setBigUint64(`offset`, heap[`val`.idx], `littleEndian`);".}
  else:
    discard

proc jsDataViewBuffer*(dv: JsDataView): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`dv`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsDataViewByteLength*(dv: JsDataView): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].byteLength;".}
  else:
    result = 0

proc jsDataViewByteOffset*(dv: JsDataView): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`dv`.idx].byteOffset;".}
  else:
    result = 0

# ─── More Math ───

proc jsMathCbrt*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.cbrt(`x`);".}
  else:
    result = 0.0

proc jsMathCosh*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.cosh(`x`);".}
  else:
    result = 0.0

proc jsMathSinh*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.sinh(`x`);".}
  else:
    result = 0.0

proc jsMathTanh*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.tanh(`x`);".}
  else:
    result = 0.0

proc jsMathAcosh*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.acosh(`x`);".}
  else:
    result = 0.0

proc jsMathAsinh*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.asinh(`x`);".}
  else:
    result = 0.0

proc jsMathAtanh*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.atanh(`x`);".}
  else:
    result = 0.0

proc jsMathLog1p*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.log1p(`x`);".}
  else:
    result = 0.0

proc jsMathExpm1*(x: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.expm1(`x`);".}
  else:
    result = 0.0

proc jsMathFround*(x: float64): float32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.fround(`x`);".}
  else:
    result = 0'f32

proc jsMathImul*(a: int32, b: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.imul(`a`, `b`);".}
  else:
    result = 0'i32

proc jsMathClz32*(x: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.clz32(`x`);".}
  else:
    result = 0'i32

proc jsMathPi*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.PI;".}
  else:
    result = 3.141592653589793

# ─── Intl APIs (additional) ───

type JsIntlLocale* = distinct JsValue

proc jsNewIntlLocale*(tag: string): JsIntlLocale =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var t = `tag`; `result` = {idx: addHeapObject(new Intl.Locale(t))};".}
  else:
    result = JsIntlLocale(JsValue(idx: 0))

type JsIntlListFormat* = distinct JsValue

proc jsNewIntlListFormat*(locale: string, options: JsValue = JsValue(idx: 0)): JsIntlListFormat =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var l = `locale`; var o = `options`; if (o == 0) { `result` = {idx: addHeapObject(new Intl.ListFormat(l))}; } else { `result` = {idx: addHeapObject(new Intl.ListFormat(l, heap[o]))}; }".}
  else:
    result = JsIntlListFormat(JsValue(idx: 0))

proc jsIntlListFormatFormat*(fmt: JsIntlListFormat, items: JsArray): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`fmt`.idx].format(heap[`items`.idx]);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

type JsIntlDisplayNames* = distinct JsValue

proc jsNewIntlDisplayNames*(locale: string, options: JsValue): JsIntlDisplayNames =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var l = `locale`; `result` = {idx: addHeapObject(new Intl.DisplayNames(l, heap[`options`.idx]))};".}
  else:
    result = JsIntlDisplayNames(JsValue(idx: 0))

proc jsIntlDisplayNamesOf*(dn: JsIntlDisplayNames, code: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`dn`.idx].of(`code`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

type JsIntlRelativeTimeFormat* = distinct JsValue

proc jsNewIntlRelativeTimeFormat*(locale: string, options: JsValue = JsValue(idx: 0)): JsIntlRelativeTimeFormat =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var l = `locale`; var o = `options`; if (o == 0) { `result` = {idx: addHeapObject(new Intl.RelativeTimeFormat(l))}; } else { `result` = {idx: addHeapObject(new Intl.RelativeTimeFormat(l, heap[o]))}; }".}
  else:
    result = JsIntlRelativeTimeFormat(JsValue(idx: 0))

proc jsIntlRelativeTimeFormatFormat*(fmt: JsIntlRelativeTimeFormat, value: float64, unit: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`fmt`.idx].format(`value`, `unit`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

type JsIntlSegmenter* = distinct JsValue

proc jsNewIntlSegmenter*(locale: string, options: JsValue = JsValue(idx: 0)): JsIntlSegmenter =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var l = `locale`; var o = `options`; if (o == 0) { `result` = {idx: addHeapObject(new Intl.Segmenter(l))}; } else { `result` = {idx: addHeapObject(new Intl.Segmenter(l, heap[o]))}; }".}
  else:
    result = JsIntlSegmenter(JsValue(idx: 0))

proc jsIntlSegmenterSegment*(sgr: JsIntlSegmenter, text: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var t = `text`; `result` = {idx: addHeapObject(heap[`sgr`.idx].segment(t))};".}
  else:
    result = JsValue(idx: 0)

type JsIntlDurationFormat* = distinct JsValue

proc jsNewIntlDurationFormat*(locale: string, options: JsValue = JsValue(idx: 0)): JsIntlDurationFormat =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var l = `locale`; var o = `options`; if (o == 0) { `result` = {idx: addHeapObject(new Intl.DurationFormat(l))}; } else { `result` = {idx: addHeapObject(new Intl.DurationFormat(l, heap[o]))}; }".}
  else:
    result = JsIntlDurationFormat(JsValue(idx: 0))

proc jsIntlDurationFormatFormat*(fmt: JsIntlDurationFormat, duration: JsValue): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`fmt`.idx].format(heap[`duration`.idx]);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── Temporal API ───

type JsTemporalInstant* = distinct JsValue
type JsTemporalPlainDateTime* = distinct JsValue
type JsTemporalDuration* = distinct JsValue

proc jsTemporalNowInstant*(): JsTemporalInstant =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Temporal.Now.instant())};".}
  else:
    result = JsTemporalInstant(JsValue(idx: 0))

proc jsTemporalNowPlainDateTimeISO*(timeZone: string = "UTC"): JsTemporalPlainDateTime =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var tz = `timeZone`; `result` = {idx: addHeapObject(Temporal.Now.plainDateTimeISO(tz))};".}
  else:
    result = JsTemporalPlainDateTime(JsValue(idx: 0))

proc jsTemporalInstantToString*(inst: JsTemporalInstant): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`inst`.idx].toString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsTemporalDurationFrom*(options: JsValue): JsTemporalDuration =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Temporal.Duration.from(heap[`options`.idx]))};".}
  else:
    result = JsTemporalDuration(JsValue(idx: 0))

# ─── serde bridge: Nim types ↔ JsValue via JSON ───

proc toJsValue*(val: string): JsValue =
  ## Convert a Nim string to a JsValue by wrapping in JSON.stringify-safe way.
  when defined(wasm32) and not defined(emscripten):
    {.emit: "var s = `val`; `result` = {idx: addHeapObject(s)};".}
  else:
    result = JsValue(idx: 0)

proc toJsValue*(val: int64): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(`val`)};".}
  else:
    result = JsValue(idx: 0)

proc toJsValue*(val: float64): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(`val`)};".}
  else:
    result = JsValue(idx: 0)

proc toJsValue*(val: bool): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(`val` ? 1 : 0)};".}
  else:
    result = JsValue(idx: 0)

proc fromJsValueString*(js: JsValue): string =
  ## Extract a string from a JsValue containing a JS string.
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`js`.idx].toString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc fromJsValueInt*(js: JsValue): int64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Number(heap[`js`.idx]);".}
  else:
    result = 0

proc fromJsValueFloat*(js: JsValue): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Number(heap[`js`.idx]);".}
  else:
    result = 0.0

proc fromJsValueBool*(js: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`js`.idx] ? 1 : 0;".}
  else:
    result = false

proc jsObjectCreate*(prototype: JsValue): JsObject =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.create(heap[`prototype`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectGetPrototypeOf*(obj: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.getPrototypeOf(heap[`obj`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsObjectDefineProperty*(obj: JsObject, prop: string, desc: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "Object.defineProperty(heap[`obj`.idx], `prop`, heap[`desc`.idx]);".}
  else:
    discard

proc jsGlobalThisValue*(): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(globalThis)};".}
  else:
    result = JsValue(idx: 0)

# ─── TypedArray constructors from buffer ───

proc newJsUint8ArrayFromBuffer*(buffer: JsArrayBuffer, byteOffset: int = 0, length: int = -1): JsUint8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Uint8Array(heap[`buffer`.idx], `byteOffset`, `length`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc newJsFloat64ArrayFromBuffer*(buffer: JsArrayBuffer, byteOffset: int = 0, length: int = -1): JsFloat64Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Float64Array(heap[`buffer`.idx], `byteOffset`, `length`))};".}
  else:
    result = JsFloat64Array(JsValue(idx: 0))

proc jsUint8ArrayBuffer*(arr: JsUint8Array): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

# ─── requestAnimationFrame ───

proc jsRequestAnimationFrame*(callback: JsValue): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = requestAnimationFrame(heap[`callback`.idx]);".}
  else:
    result = 0

proc jsCancelAnimationFrame*(id: int) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "cancelAnimationFrame(`id`);".}
  else:
    discard

# ─── Atomics ───

proc jsAtomicsAdd*(typedArray: JsInt32Array, index: int, value: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.add(heap[`typedArray`.idx], `index`, `value`);".}
  else:
    result = 0'i32

proc jsAtomicsAnd*(typedArray: JsInt32Array, index: int, value: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.and(heap[`typedArray`.idx], `index`, `value`);".}
  else:
    result = 0'i32

proc jsAtomicsCompareExchange*(typedArray: JsInt32Array, index: int, expectedValue: int32, replacementValue: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.compareExchange(heap[`typedArray`.idx], `index`, `expectedValue`, `replacementValue`);".}
  else:
    result = 0'i32

proc jsAtomicsExchange*(typedArray: JsInt32Array, index: int, value: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.exchange(heap[`typedArray`.idx], `index`, `value`);".}
  else:
    result = 0'i32

proc jsAtomicsLoad*(typedArray: JsInt32Array, index: int): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.load(heap[`typedArray`.idx], `index`);".}
  else:
    result = 0'i32

proc jsAtomicsOr*(typedArray: JsInt32Array, index: int, value: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.or(heap[`typedArray`.idx], `index`, `value`);".}
  else:
    result = 0'i32

proc jsAtomicsStore*(typedArray: JsInt32Array, index: int, value: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.store(heap[`typedArray`.idx], `index`, `value`);".}
  else:
    result = 0'i32

proc jsAtomicsSub*(typedArray: JsInt32Array, index: int, value: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.sub(heap[`typedArray`.idx], `index`, `value`);".}
  else:
    result = 0'i32

proc jsAtomicsXor*(typedArray: JsInt32Array, index: int, value: int32): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.xor(heap[`typedArray`.idx], `index`, `value`);".}
  else:
    result = 0'i32

proc jsAtomicsWait*(typedArray: JsInt32Array, index: int, value: int32, timeout: int = -1): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = Atomics.wait(heap[`typedArray`.idx], `index`, `value`, `timeout`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsAtomicsNotify*(typedArray: JsInt32Array, index: int, count: int = -1): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.notify(heap[`typedArray`.idx], `index`, `count`);".}
  else:
    result = 0'i32

proc jsAtomicsIsLockFree*(size: int): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Atomics.isLockFree(`size`) ? 1 : 0;".}
  else:
    result = false

# ─── TypedArray expansions ───

# --- Int8Array ---

proc jsInt8ArrayLen*(arr: JsInt8Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsInt8ArrayGet*(arr: JsInt8Array, idx: int): int8 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0'i8

proc jsInt8ArraySet*(arr: JsInt8Array, idx: int, val: int8) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsInt8ArraySlice*(arr: JsInt8Array, start: int = 0, stop: int = -1): JsInt8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsInt8Array(JsValue(idx: 0))

proc jsInt8ArraySubarray*(arr: JsInt8Array, start: int, stop: int): JsInt8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsInt8Array(JsValue(idx: 0))

proc jsInt8ArrayFill*(arr: JsInt8Array, val: int8, start: int = 0, stop: int = -1): JsInt8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsInt8Array(JsValue(idx: 0))

proc jsInt8ArraySetFromSlice*(arr: JsInt8Array, offset: int, src: JsInt8Array) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

# --- Uint16Array ---

proc jsUint16ArrayLen*(arr: JsUint16Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsUint16ArrayGet*(arr: JsUint16Array, idx: int): uint16 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0'u16

proc jsUint16ArraySet*(arr: JsUint16Array, idx: int, val: uint16) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsUint16ArraySlice*(arr: JsUint16Array, start: int = 0, stop: int = -1): JsUint16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsUint16Array(JsValue(idx: 0))

proc jsUint16ArraySubarray*(arr: JsUint16Array, start: int, stop: int): JsUint16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsUint16Array(JsValue(idx: 0))

proc jsUint16ArrayFill*(arr: JsUint16Array, val: uint16, start: int = 0, stop: int = -1): JsUint16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsUint16Array(JsValue(idx: 0))

proc jsUint16ArraySetFromSlice*(arr: JsUint16Array, offset: int, src: JsUint16Array) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

# --- Int16Array ---

proc jsInt16ArrayLen*(arr: JsInt16Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsInt16ArrayGet*(arr: JsInt16Array, idx: int): int16 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0'i16

proc jsInt16ArraySet*(arr: JsInt16Array, idx: int, val: int16) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsInt16ArraySlice*(arr: JsInt16Array, start: int = 0, stop: int = -1): JsInt16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsInt16Array(JsValue(idx: 0))

proc jsInt16ArraySubarray*(arr: JsInt16Array, start: int, stop: int): JsInt16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsInt16Array(JsValue(idx: 0))

proc jsInt16ArrayFill*(arr: JsInt16Array, val: int16, start: int = 0, stop: int = -1): JsInt16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsInt16Array(JsValue(idx: 0))

proc jsInt16ArraySetFromSlice*(arr: JsInt16Array, offset: int, src: JsInt16Array) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

# --- Uint32Array ---

proc jsUint32ArrayLen*(arr: JsUint32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsUint32ArrayGet*(arr: JsUint32Array, idx: int): uint32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0'u32

proc jsUint32ArraySet*(arr: JsUint32Array, idx: int, val: uint32) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsUint32ArraySlice*(arr: JsUint32Array, start: int = 0, stop: int = -1): JsUint32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsUint32Array(JsValue(idx: 0))

proc jsUint32ArraySubarray*(arr: JsUint32Array, start: int, stop: int): JsUint32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsUint32Array(JsValue(idx: 0))

proc jsUint32ArrayFill*(arr: JsUint32Array, val: uint32, start: int = 0, stop: int = -1): JsUint32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsUint32Array(JsValue(idx: 0))

proc jsUint32ArraySetFromSlice*(arr: JsUint32Array, offset: int, src: JsUint32Array) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

# --- Int32Array ---

proc jsInt32ArrayLen*(arr: JsInt32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsInt32ArrayGet*(arr: JsInt32Array, idx: int): int32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0'i32

proc jsInt32ArraySet*(arr: JsInt32Array, idx: int, val: int32) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsInt32ArraySlice*(arr: JsInt32Array, start: int = 0, stop: int = -1): JsInt32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsInt32Array(JsValue(idx: 0))

proc jsInt32ArraySubarray*(arr: JsInt32Array, start: int, stop: int): JsInt32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsInt32Array(JsValue(idx: 0))

proc jsInt32ArrayFill*(arr: JsInt32Array, val: int32, start: int = 0, stop: int = -1): JsInt32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsInt32Array(JsValue(idx: 0))

proc jsInt32ArraySetFromSlice*(arr: JsInt32Array, offset: int, src: JsInt32Array) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

# --- Float32Array ---

proc jsFloat32ArrayLen*(arr: JsFloat32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsFloat32ArrayGet*(arr: JsFloat32Array, idx: int): float32 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0'f32

proc jsFloat32ArraySet*(arr: JsFloat32Array, idx: int, val: float32) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsFloat32ArraySlice*(arr: JsFloat32Array, start: int = 0, stop: int = -1): JsFloat32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsFloat32Array(JsValue(idx: 0))

proc jsFloat32ArraySubarray*(arr: JsFloat32Array, start: int, stop: int): JsFloat32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsFloat32Array(JsValue(idx: 0))

proc jsFloat32ArrayFill*(arr: JsFloat32Array, val: float32, start: int = 0, stop: int = -1): JsFloat32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsFloat32Array(JsValue(idx: 0))

proc jsFloat32ArraySetFromSlice*(arr: JsFloat32Array, offset: int, src: JsFloat32Array) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

# --- Float64Array ---

proc jsFloat64ArrayLen*(arr: JsFloat64Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsFloat64ArrayGet*(arr: JsFloat64Array, idx: int): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0.0

proc jsFloat64ArraySet*(arr: JsFloat64Array, idx: int, val: float64) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsFloat64ArraySlice*(arr: JsFloat64Array, start: int = 0, stop: int = -1): JsFloat64Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsFloat64Array(JsValue(idx: 0))

proc jsFloat64ArraySubarray*(arr: JsFloat64Array, start: int, stop: int): JsFloat64Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsFloat64Array(JsValue(idx: 0))

proc jsFloat64ArrayFill*(arr: JsFloat64Array, val: float64, start: int = 0, stop: int = -1): JsFloat64Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsFloat64Array(JsValue(idx: 0))

proc jsFloat64ArraySetFromSlice*(arr: JsFloat64Array, offset: int, src: JsFloat64Array) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

# ─── More Date methods ───

proc jsDateGetDay*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getDay();".}
  else:
    result = 0

proc jsDateGetUTCDay*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getUTCDay();".}
  else:
    result = 0

proc jsDateGetUTCFullYear*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getUTCFullYear();".}
  else:
    result = 0

proc jsDateGetUTCMonth*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getUTCMonth();".}
  else:
    result = 0

proc jsDateGetUTCDate*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getUTCDate();".}
  else:
    result = 0

proc jsDateGetUTCHours*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getUTCHours();".}
  else:
    result = 0

proc jsDateGetUTCMinutes*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getUTCMinutes();".}
  else:
    result = 0

proc jsDateGetUTCSeconds*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getUTCSeconds();".}
  else:
    result = 0

proc jsDateGetMilliseconds*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getMilliseconds();".}
  else:
    result = 0

proc jsDateGetUTCMilliseconds*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getUTCMilliseconds();".}
  else:
    result = 0

proc jsDateGetTimezoneOffset*(date: JsDate): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].getTimezoneOffset();".}
  else:
    result = 0

proc jsDateToDateString*(date: JsDate): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`date`.idx].toDateString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsDateToTimeString*(date: JsDate): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`date`.idx].toTimeString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsDateToUTCString*(date: JsDate): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`date`.idx].toUTCString();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsDateSetFullYear*(date: JsDate, year: int): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].setFullYear(`year`);".}
  else:
    result = 0.0

proc jsDateSetMonth*(date: JsDate, month: int): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].setMonth(`month`);".}
  else:
    result = 0.0

proc jsDateSetDate*(date: JsDate, day: int): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].setDate(`day`);".}
  else:
    result = 0.0

proc jsDateSetHours*(date: JsDate, hours: int): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].setHours(`hours`);".}
  else:
    result = 0.0

proc jsDateSetMinutes*(date: JsDate, minutes: int): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].setMinutes(`minutes`);".}
  else:
    result = 0.0

proc jsDateSetSeconds*(date: JsDate, seconds: int): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].setSeconds(`seconds`);".}
  else:
    result = 0.0

# ─── More String methods ───

proc jsStringConcat*(s1: string, s2: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s1`;
    var b = `s2`;
    var s = a.concat(b);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringIncludes*(s: string, search: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var b = `search`;
    `result` = a.includes(b) ? 1 : 0;
    """.}
  else:
    result = false

proc jsStringStartsWith*(s: string, prefix: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var b = `prefix`;
    `result` = a.startsWith(b) ? 1 : 0;
    """.}
  else:
    result = false

proc jsStringEndsWith*(s: string, suffix: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var b = `suffix`;
    `result` = a.endsWith(b) ? 1 : 0;
    """.}
  else:
    result = false

proc jsStringIndexOf*(s: string, search: string): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var b = `search`;
    `result` = a.indexOf(b);
    """.}
  else:
    result = -1

proc jsStringLastIndexOf*(s: string, search: string): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var b = `search`;
    `result` = a.lastIndexOf(b);
    """.}
  else:
    result = -1

proc jsStringSlice*(s: string, start: int, stop: int): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var sliced = a.slice(`start`, `stop`);
    var len = sliced.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = sliced.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringSubstring*(s: string, start: int, stop: int): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var sub = a.substring(`start`, `stop`);
    var len = sub.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = sub.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringToUpperCase*(s: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var upper = a.toUpperCase();
    var len = upper.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = upper.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringToLowerCase*(s: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var lower = a.toLowerCase();
    var len = lower.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = lower.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringTrim*(s: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var trimmed = a.trim();
    var len = trimmed.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = trimmed.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringTrimStart*(s: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var trimmed = a.trimStart();
    var len = trimmed.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = trimmed.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringTrimEnd*(s: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var trimmed = a.trimEnd();
    var len = trimmed.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = trimmed.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringRepeat*(s: string, count: int): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var repeated = a.repeat(`count`);
    var len = repeated.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = repeated.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringReplace*(s: string, pattern: string, replacement: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var p = `pattern`;
    var r = `replacement`;
    var replaced = a.replace(p, r);
    var len = replaced.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = replaced.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringReplaceAll*(s: string, pattern: string, replacement: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var p = `pattern`;
    var r = `replacement`;
    var replaced = a.replaceAll(p, r);
    var len = replaced.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = replaced.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringSplit*(s: string, separator: string): JsArray =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var sep = `separator`;
    `result` = {idx: addHeapObject(a.split(sep))};
    """.}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsStringPadStart*(s: string, targetLength: int, padString: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var p = `padString`;
    var padded = a.padStart(`targetLength`, p);
    var len = padded.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = padded.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringPadEnd*(s: string, targetLength: int, padString: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var p = `padString`;
    var padded = a.padEnd(`targetLength`, p);
    var len = padded.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = padded.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringCharAt*(s: string, index: int): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    var ch = a.charAt(`index`);
    var len = ch.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = ch.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStringCharCodeAt*(s: string, index: int): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var a = `s`;
    `result` = a.charCodeAt(`index`);
    """.}
  else:
    result = 0

# ─── More Object methods ───

proc jsObjectIs*(val1: JsValue, val2: JsValue): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Object.is(heap[`val1`.idx], heap[`val2`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsObjectFromEntries*(entries: JsArray): JsObject =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.fromEntries(heap[`entries`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectPreventExtensions*(obj: JsObject): JsObject =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(Object.preventExtensions(heap[`obj`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectIsExtensible*(obj: JsObject): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Object.isExtensible(heap[`obj`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsObjectIsSealed*(obj: JsObject): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Object.isSealed(heap[`obj`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsObjectIsFrozen*(obj: JsObject): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Object.isFrozen(heap[`obj`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── More Console methods ───

proc jsConsoleTable*(val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.table(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleCount*(label: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.count(`label`);".}
  else:
    discard

proc jsConsoleCountReset*(label: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.countReset(`label`);".}
  else:
    discard

proc jsConsoleGroup*(label: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.group(`label`);".}
  else:
    discard

proc jsConsoleGroupEnd*() =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.groupEnd();".}
  else:
    discard

proc jsConsoleDir*(val: JsValue) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.dir(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleClear*() =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.clear();".}
  else:
    discard

# ─── Date parsing/formatting ───

proc jsDateParse*(str: string): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = `str`;
    `result` = Date.parse(s);
    """.}
  else:
    result = 0.0

proc jsDateUTC*(year: int, month: int, day: int, hours: int, minutes: int, seconds: int, ms: int): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Date.UTC(`year`, `month`, `day`, `hours`, `minutes`, `seconds`, `ms`);".}
  else:
    result = 0.0

proc jsDateToJSON*(date: JsDate): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`date`.idx].toJSON();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsDateSetTime*(date: JsDate, time: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`date`.idx].setTime(`time`);".}
  else:
    result = 0.0

proc newJsDateFromYearMonthDay*(year: int, month: int, day: int): JsDate =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Date(`year`, `month`, `day`))};".}
  else:
    result = JsDate(JsValue(idx: 0))

# ─── JSON reviver ───

proc jsJsonParseWithReviver*(str: string, reviver: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = `str`;
    `result` = {idx: addHeapObject(JSON.parse(s, heap[`reviver`.idx]))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsJsonStringifyWithReplacer*(val: JsValue, replacer: JsValue, space: int): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = JSON.stringify(heap[`val`.idx], heap[`replacer`.idx], `space`);
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── Intl - resolved options for all remaining Intl types ───

proc jsIntlListFormatResolvedOptions*(fmt: JsIntlListFormat): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fmt`.idx].resolvedOptions())};".}
  else:
    result = JsValue(idx: 0)

proc jsIntlRelativeTimeFormatResolvedOptions*(fmt: JsIntlRelativeTimeFormat): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fmt`.idx].resolvedOptions())};".}
  else:
    result = JsValue(idx: 0)

proc jsIntlSegmenterResolvedOptions*(sgr: JsIntlSegmenter): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`sgr`.idx].resolvedOptions())};".}
  else:
    result = JsValue(idx: 0)

proc jsIntlDurationFormatResolvedOptions*(fmt: JsIntlDurationFormat): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fmt`.idx].resolvedOptions())};".}
  else:
    result = JsValue(idx: 0)

proc jsIntlDisplayNamesResolvedOptions*(dn: JsIntlDisplayNames): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`dn`.idx].resolvedOptions())};".}
  else:
    result = JsValue(idx: 0)

# ─── Intl - formatToParts for DateTimeFormat ───

proc jsIntlDateTimeFormatFormatToParts*(fmt: JsIntlDateTimeFormat, date: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fmt`.idx].formatToParts(heap[`date`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsIntlRelativeTimeFormatFormatToParts*(fmt: JsIntlRelativeTimeFormat, value: float64, unit: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`fmt`.idx].formatToParts(`value`, `unit`))};".}
  else:
    result = JsValue(idx: 0)

# ─── Performance API ───

type JsPerformance* = distinct JsValue

proc jsPerformanceNow*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = performance.now();".}
  else:
    result = 0.0

proc jsPerformanceMark*(name: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "performance.mark(`name`);".}
  else:
    discard

proc jsPerformanceMeasure*(name: string, startMark: string, endMark: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "performance.measure(`name`, `startMark`, `endMark`);".}
  else:
    discard

proc jsPerformanceGetEntriesByName*(name: string): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(performance.getEntriesByName(`name`))};".}
  else:
    result = JsValue(idx: 0)

proc jsPerformanceClearMarks*() =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "performance.clearMarks();".}
  else:
    discard

# ─── Navigator ───

type JsNavigator* = distinct JsValue

proc jsNavigatorGet*(): JsNavigator =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(navigator)};".}
  else:
    result = JsNavigator(JsValue(idx: 0))

proc jsNavigatorUserAgent*(nav: JsNavigator): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`nav`.idx].userAgent;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsNavigatorLanguage*(nav: JsNavigator): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`nav`.idx].language;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

# ─── Location (browser) ───

type JsLocation* = distinct JsValue

proc jsLocationGet*(): JsLocation =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(window.location)};".}
  else:
    result = JsLocation(JsValue(idx: 0))

proc jsLocationHref*(loc: JsLocation): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`loc`.idx].href;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsLocationHostname*(loc: JsLocation): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`loc`.idx].hostname;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsLocationPathname*(loc: JsLocation): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`loc`.idx].pathname;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsLocationReload*(loc: JsLocation) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`loc`.idx].reload();".}
  else:
    discard

# ─── More Math ───

proc jsMathE*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.E;".}
  else:
    result = 2.718281828459045

proc jsMathLN2*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.LN2;".}
  else:
    result = 0.6931471805599453

proc jsMathLN10*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.LN10;".}
  else:
    result = 2.302585092994046

proc jsMathLog2E*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.LOG2E;".}
  else:
    result = 1.4426950408889634

proc jsMathLog10E*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.LOG10E;".}
  else:
    result = 0.4342944819032518

proc jsMathSQRT1_2*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.SQRT1_2;".}
  else:
    result = 0.7071067811865476

proc jsMathSQRT2*(): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.SQRT2;".}
  else:
    result = 1.4142135623730951

proc jsMathRandomRange*(min: float64, max: float64): float64 =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = Math.random() * (`max` - `min`) + `min`;".}
  else:
    result = 0.0

# ─── TypedArray buffer/byteOffset/byteLength ───

# --- Int8Array ---
proc jsInt8ArrayBuffer*(arr: JsInt8Array): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsInt8ArrayByteOffset*(arr: JsInt8Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteOffset;".}
  else:
    result = 0

proc jsInt8ArrayByteLength*(arr: JsInt8Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteLength;".}
  else:
    result = 0

# --- Uint16Array ---
proc jsUint16ArrayBuffer*(arr: JsUint16Array): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsUint16ArrayByteOffset*(arr: JsUint16Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteOffset;".}
  else:
    result = 0

proc jsUint16ArrayByteLength*(arr: JsUint16Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteLength;".}
  else:
    result = 0

# --- Int16Array ---
proc jsInt16ArrayBuffer*(arr: JsInt16Array): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsInt16ArrayByteOffset*(arr: JsInt16Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteOffset;".}
  else:
    result = 0

proc jsInt16ArrayByteLength*(arr: JsInt16Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteLength;".}
  else:
    result = 0

# --- Uint32Array ---
proc jsUint32ArrayBuffer*(arr: JsUint32Array): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsUint32ArrayByteOffset*(arr: JsUint32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteOffset;".}
  else:
    result = 0

proc jsUint32ArrayByteLength*(arr: JsUint32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteLength;".}
  else:
    result = 0

# --- Int32Array ---
proc jsInt32ArrayBuffer*(arr: JsInt32Array): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsInt32ArrayByteOffset*(arr: JsInt32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteOffset;".}
  else:
    result = 0

proc jsInt32ArrayByteLength*(arr: JsInt32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteLength;".}
  else:
    result = 0

# --- Float32Array ---
proc jsFloat32ArrayBuffer*(arr: JsFloat32Array): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsFloat32ArrayByteOffset*(arr: JsFloat32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteOffset;".}
  else:
    result = 0

proc jsFloat32ArrayByteLength*(arr: JsFloat32Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteLength;".}
  else:
    result = 0

# --- Float64Array ---
proc jsFloat64ArrayBuffer*(arr: JsFloat64Array): JsArrayBuffer =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].buffer)};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsFloat64ArrayByteOffset*(arr: JsFloat64Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteOffset;".}
  else:
    result = 0

proc jsFloat64ArrayByteLength*(arr: JsFloat64Array): int =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = heap[`arr`.idx].byteLength;".}
  else:
    result = 0

# ─── Iterator / Generator types ───

type
  JsIterator* = distinct JsValue
  JsAsyncIterator* = distinct JsValue
  JsGenerator* = distinct JsValue

proc jsIteratorNext*(iter: JsIterator): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`iter`.idx].next())};".}
  else:
    result = JsValue(idx: 0)

proc jsIteratorNextVal*(iter: JsIterator, value: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`iter`.idx].next(heap[`value`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsGeneratorNext*(gen: JsGenerator): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`gen`.idx].next())};".}
  else:
    result = JsValue(idx: 0)

proc jsGeneratorNextVal*(gen: JsGenerator, value: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`gen`.idx].next(heap[`value`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsGeneratorReturn*(gen: JsGenerator, value: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`gen`.idx].return(heap[`value`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsGeneratorThrow*(gen: JsGenerator, error: JsValue): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(heap[`gen`.idx].throw(heap[`error`.idx]))};".}
  else:
    result = JsValue(idx: 0)

# ─── TypedArray constructors from buffer ───

proc newJsUint16ArrayFromBuffer*(buffer: JsArrayBuffer, byteOffset: int = 0, length: int = -1): JsUint16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Uint16Array(heap[`buffer`.idx], `byteOffset`, `length`))};".}
  else:
    result = JsUint16Array(JsValue(idx: 0))

proc newJsInt16ArrayFromBuffer*(buffer: JsArrayBuffer, byteOffset: int = 0, length: int = -1): JsInt16Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Int16Array(heap[`buffer`.idx], `byteOffset`, `length`))};".}
  else:
    result = JsInt16Array(JsValue(idx: 0))

proc newJsUint32ArrayFromBuffer*(buffer: JsArrayBuffer, byteOffset: int = 0, length: int = -1): JsUint32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Uint32Array(heap[`buffer`.idx], `byteOffset`, `length`))};".}
  else:
    result = JsUint32Array(JsValue(idx: 0))

proc newJsInt32ArrayFromBuffer*(buffer: JsArrayBuffer, byteOffset: int = 0, length: int = -1): JsInt32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Int32Array(heap[`buffer`.idx], `byteOffset`, `length`))};".}
  else:
    result = JsInt32Array(JsValue(idx: 0))

proc newJsFloat32ArrayFromBuffer*(buffer: JsArrayBuffer, byteOffset: int = 0, length: int = -1): JsFloat32Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Float32Array(heap[`buffer`.idx], `byteOffset`, `length`))};".}
  else:
    result = JsFloat32Array(JsValue(idx: 0))

proc newJsInt8ArrayFromBuffer*(buffer: JsArrayBuffer, byteOffset: int = 0, length: int = -1): JsInt8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Int8Array(heap[`buffer`.idx], `byteOffset`, `length`))};".}
  else:
    result = JsInt8Array(JsValue(idx: 0))

proc newJsUint8ArrayFromByteLength*(length: int): JsUint8Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Uint8Array(`length`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc newJsFloat64ArrayFromByteLength*(length: int): JsFloat64Array =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(new Float64Array(`length`))};".}
  else:
    result = JsFloat64Array(JsValue(idx: 0))

# ─── Window / global shortcuts ───

proc jsWindowAlert*(msg: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "alert(`msg`);".}
  else:
    discard

proc jsWindowConfirm*(msg: string): bool =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = confirm(`msg`) ? 1 : 0;".}
  else:
    result = false

proc jsWindowPrompt*(msg: string, defaultVal: string = ""): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = prompt(`msg`, `defaultVal`);
    if (s == null) s = "";
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsWindowOpen*(url: string, target: string = "_blank", features: string = ""): JsValue =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(window.open(`url`, `target`, `features`))};".}
  else:
    result = JsValue(idx: 0)

proc jsWindowClose*() =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "window.close();".}
  else:
    discard

# ─── More Console ───

proc jsConsoleTrace*(msg: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.trace(`msg`);".}
  else:
    discard

proc jsConsoleProfile*(label: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.profile(`label`);".}
  else:
    discard

proc jsConsoleProfileEnd*(label: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "console.profileEnd(`label`);".}
  else:
    discard

# ─── Storage ───

type JsStorage* = distinct JsValue

proc jsLocalStorageGet*(): JsStorage =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(localStorage)};".}
  else:
    result = JsStorage(JsValue(idx: 0))

proc jsSessionStorageGet*(): JsStorage =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "`result` = {idx: addHeapObject(sessionStorage)};".}
  else:
    result = JsStorage(JsValue(idx: 0))

proc jsStorageGetItem*(storage: JsStorage, key: string): string =
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var s = heap[`storage`.idx].getItem(`key`);
    if (s == null) s = "";
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStorageSetItem*(storage: JsStorage, key: string, value: string) =
  when defined(wasm32) and not defined(emscripten):
    {.emit: "heap[`storage`.idx].setItem(`key`, `value`);".}
  else:
    discard

