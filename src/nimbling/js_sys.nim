## js-sys equivalent for nimbling: bindings to JavaScript built-in APIs.
## Mirrors Rust's js-sys crate.

import runtime

# ─── Array ───

type JsArray* = distinct JsValue

proc newJsArray*(): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Array())};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayLen*(arr: JsArray): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsArrayPush*(arr: JsArray, val: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`arr`.idx].push(heap[`val`.idx]);".}
  else:
    discard

proc jsArrayGet*(arr: JsArray, idx: int): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx][`idx`])};".}
  else:
    result = JsValue(idx: 0)

proc jsArraySet*(arr: JsArray, idx: int, val: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`arr`.idx][`idx`] = heap[`val`.idx];".}
  else:
    discard

proc jsArraySlice*(arr: JsArray, start: int = 0, stop: int = -1): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArraySplice*(arr: JsArray, start: int, deleteCount: int): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].splice(`start`, `deleteCount`))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayConcat*(arr: JsArray, other: JsArray): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].concat(heap[`other`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayIncludes*(arr: JsArray, val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`arr`.idx].includes(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsArrayJoin*(arr: JsArray, sep: string = ","): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].reverse())};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArraySort*(arr: JsArray): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].sort())};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayIndexOf*(arr: JsArray, val: JsValue, fromIndex: int = 0): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`arr`.idx].indexOf(heap[`val`.idx], `fromIndex`);".}
  else:
    result = -1

proc jsArrayForEach*(arr: JsArray, callback: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`arr`.idx].forEach(heap[`callback`.idx]);".}
  else:
    discard

proc jsArrayMap*(arr: JsArray, callback: JsValue): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].map(heap[`callback`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayFilter*(arr: JsArray, callback: JsValue): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].filter(heap[`callback`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsArrayReduce*(arr: JsArray, callback: JsValue, initialValue: JsValue): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].reduce(heap[`callback`.idx], heap[`initialValue`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsArrayFind*(arr: JsArray, callback: JsValue): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].find(heap[`callback`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsArraySome*(arr: JsArray, callback: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`arr`.idx].some(heap[`callback`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsArrayEvery*(arr: JsArray, callback: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`arr`.idx].every(heap[`callback`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── Object ───

type JsObject* = distinct JsValue

proc newJsObject*(): JsObject =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Object())};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectKeys*(obj: JsObject): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Object.keys(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsObjectValues*(obj: JsObject): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Object.values(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsObjectEntries*(obj: JsObject): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Object.entries(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsObjectAssign*(target: JsObject, source: JsObject): JsObject =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Object.assign(heap[`target`.idx], heap[`source`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectGet*(obj: JsObject, prop: string): JsValue =
  when defined(wasm32):
    {.emit: """
    var key = `prop`;
    `result` = {idx: addHeapObject(heap[`obj`.idx][key])};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsObjectSet*(obj: JsObject, prop: string, val: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`obj`.idx][`prop`] = heap[`val`.idx];".}
  else:
    discard

proc jsObjectHas*(obj: JsObject, prop: string): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`obj`.idx].hasOwnProperty(`prop`) ? 1 : 0;".}
  else:
    result = false

proc jsObjectDelete*(obj: JsObject, prop: string): bool =
  when defined(wasm32):
    {.emit: "`result` = delete heap[`obj`.idx][`prop`] ? 1 : 0;".}
  else:
    result = false

proc jsObjectFreeze*(obj: JsObject): JsObject =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Object.freeze(heap[`obj`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsObjectSeal*(obj: JsObject): JsObject =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Object.seal(heap[`obj`.idx]))};".}
  else:
    result = JsObject(JsValue(idx: 0))

# ─── Promise ───

type JsPromise* = distinct JsValue

proc newJsPromise*(executor: proc(resolve, reject: JsValue)): JsPromise =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Promise.resolve(heap[`val`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseReject*(val: JsValue): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Promise.reject(heap[`val`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseAll*(promises: JsArray): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Promise.all(heap[`promises`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseRace*(promises: JsArray): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Promise.race(heap[`promises`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseThen*(promise: JsPromise, onFulfilled: JsValue): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`promise`.idx].then(heap[`onFulfilled`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseCatch*(promise: JsPromise, onRejected: JsValue): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`promise`.idx].catch(heap[`onRejected`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsPromiseFinally*(promise: JsPromise, onFinally: JsValue): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`promise`.idx].finally(heap[`onFinally`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))

# ─── Date ───

type JsDate* = distinct JsValue

proc newJsDate*(): JsDate =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Date())};".}
  else:
    result = JsDate(JsValue(idx: 0))

proc newJsDateFromMs*(ms: float64): JsDate =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Date(`ms`))};".}
  else:
    result = JsDate(JsValue(idx: 0))

proc newJsDateFromString*(dateStr: string): JsDate =
  when defined(wasm32):
    {.emit: """
    var s = `dateStr`;
    `result` = {idx: addHeapObject(new Date(s))};
    """.}
  else:
    result = JsDate(JsValue(idx: 0))

proc jsDateNow*(): float64 =
  when defined(wasm32):
    {.emit: "`result` = Date.now();".}
  else:
    result = 0.0

proc jsDateGetTime*(date: JsDate): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`date`.idx].getTime();".}
  else:
    result = 0.0

proc jsDateToISOString*(date: JsDate): string =
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = heap[`date`.idx].getFullYear();".}
  else:
    result = 0

proc jsDateGetMonth*(date: JsDate): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`date`.idx].getMonth();".}
  else:
    result = 0

proc jsDateGetDate*(date: JsDate): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`date`.idx].getDate();".}
  else:
    result = 0

proc jsDateGetHours*(date: JsDate): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`date`.idx].getHours();".}
  else:
    result = 0

proc jsDateGetMinutes*(date: JsDate): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`date`.idx].getMinutes();".}
  else:
    result = 0

proc jsDateGetSeconds*(date: JsDate): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`date`.idx].getSeconds();".}
  else:
    result = 0

proc jsDateValueOf*(date: JsDate): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`date`.idx].valueOf();".}
  else:
    result = 0.0

# ─── RegExp ───

type JsRegExp* = distinct JsValue

proc newJsRegExp*(pattern: string, flags: string = ""): JsRegExp =
  when defined(wasm32):
    {.emit: """
    var p = `pattern`;
    var f = `flags`;
    `result` = {idx: addHeapObject(new RegExp(p, f))};
    """.}
  else:
    result = JsRegExp(JsValue(idx: 0))

proc jsRegExpTest*(re: JsRegExp, str: string): bool =
  when defined(wasm32):
    {.emit: """
    var s = `str`;
    `result` = heap[`re`.idx].test(s) ? 1 : 0;
    """.}
  else:
    result = false

proc jsRegExpExec*(re: JsRegExp, str: string): JsValue =
  when defined(wasm32):
    {.emit: """
    var s = `str`;
    `result` = {idx: addHeapObject(heap[`re`.idx].exec(s))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsRegExpToString*(re: JsRegExp): string =
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = Math.sqrt(`x`);".}
  else:
    result = 0.0

proc jsMathRandom*(): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.random();".}
  else:
    result = 0.0

proc jsMathSin*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.sin(`x`);".}
  else:
    result = 0.0

proc jsMathCos*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.cos(`x`);".}
  else:
    result = 0.0

proc jsMathTan*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.tan(`x`);".}
  else:
    result = 0.0

proc jsMathAsin*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.asin(`x`);".}
  else:
    result = 0.0

proc jsMathAcos*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.acos(`x`);".}
  else:
    result = 0.0

proc jsMathAtan*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.atan(`x`);".}
  else:
    result = 0.0

proc jsMathAtan2*(y: float64, x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.atan2(`y`, `x`);".}
  else:
    result = 0.0

proc jsMathFloor*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.floor(`x`);".}
  else:
    result = 0.0

proc jsMathCeil*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.ceil(`x`);".}
  else:
    result = 0.0

proc jsMathRound*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.round(`x`);".}
  else:
    result = 0.0

proc jsMathTrunc*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.trunc(`x`);".}
  else:
    result = 0.0

proc jsMathAbs*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.abs(`x`);".}
  else:
    result = 0.0

proc jsMathSign*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.sign(`x`);".}
  else:
    result = 0.0

proc jsMathPow*(base: float64, exp: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.pow(`base`, `exp`);".}
  else:
    result = 0.0

proc jsMathExp*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.exp(`x`);".}
  else:
    result = 0.0

proc jsMathLog*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.log(`x`);".}
  else:
    result = 0.0

proc jsMathLog2*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.log2(`x`);".}
  else:
    result = 0.0

proc jsMathLog10*(x: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.log10(`x`);".}
  else:
    result = 0.0

proc jsMathMax*(a: float64, b: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.max(`a`, `b`);".}
  else:
    result = 0.0

proc jsMathMin*(a: float64, b: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.min(`a`, `b`);".}
  else:
    result = 0.0

proc jsMathClamp*(x: float64, lo: float64, hi: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.min(Math.max(`x`, `lo`), `hi`);".}
  else:
    result = 0.0

proc jsMathHypot*(a: float64, b: float64): float64 =
  when defined(wasm32):
    {.emit: "`result` = Math.hypot(`a`, `b`);".}
  else:
    result = 0.0

# ─── JSON ───

proc jsJsonParse*(str: string): JsValue =
  when defined(wasm32):
    {.emit: """
    var s = `str`;
    `result` = {idx: addHeapObject(JSON.parse(s))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsJsonStringify*(val: JsValue): string =
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Map())};".}
  else:
    result = JsMap(JsValue(idx: 0))

proc jsMapSet*(map: JsMap, key: JsValue, val: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`map`.idx].set(heap[`key`.idx], heap[`val`.idx]);".}
  else:
    discard

proc jsMapGet*(map: JsMap, key: JsValue): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`map`.idx].get(heap[`key`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsMapHas*(map: JsMap, key: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`map`.idx].has(heap[`key`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsMapDelete*(map: JsMap, key: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`map`.idx].delete(heap[`key`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsMapSize*(map: JsMap): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`map`.idx].size;".}
  else:
    result = 0

proc jsMapClear*(map: JsMap) =
  when defined(wasm32):
    {.emit: "heap[`map`.idx].clear();".}
  else:
    discard

proc jsMapKeys*(map: JsMap): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`map`.idx].keys())};".}
  else:
    result = JsValue(idx: 0)

proc jsMapValues*(map: JsMap): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`map`.idx].values())};".}
  else:
    result = JsValue(idx: 0)

proc jsMapEntries*(map: JsMap): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`map`.idx].entries())};".}
  else:
    result = JsValue(idx: 0)

proc jsMapForEach*(map: JsMap, callback: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`map`.idx].forEach(heap[`callback`.idx]);".}
  else:
    discard

# ─── Set ───

type JsSet* = distinct JsValue

proc newJsSet*(): JsSet =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Set())};".}
  else:
    result = JsSet(JsValue(idx: 0))

proc jsSetAdd*(s: JsSet, val: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`s`.idx].add(heap[`val`.idx]);".}
  else:
    discard

proc jsSetHas*(s: JsSet, val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`s`.idx].has(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsSetDelete*(s: JsSet, val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`s`.idx].delete(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsSetSize*(s: JsSet): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`s`.idx].size;".}
  else:
    result = 0

proc jsSetClear*(s: JsSet) =
  when defined(wasm32):
    {.emit: "heap[`s`.idx].clear();".}
  else:
    discard

proc jsSetValues*(s: JsSet): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`s`.idx].values())};".}
  else:
    result = JsValue(idx: 0)

proc jsSetForEach*(s: JsSet, callback: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`s`.idx].forEach(heap[`callback`.idx]);".}
  else:
    discard

# ─── WeakMap ───

type JsWeakMap* = distinct JsValue

proc newJsWeakMap*(): JsWeakMap =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new WeakMap())};".}
  else:
    result = JsWeakMap(JsValue(idx: 0))

proc jsWeakMapSet*(wm: JsWeakMap, key: JsValue, val: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`wm`.idx].set(heap[`key`.idx], heap[`val`.idx]);".}
  else:
    discard

proc jsWeakMapGet*(wm: JsWeakMap, key: JsValue): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`wm`.idx].get(heap[`key`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsWeakMapHas*(wm: JsWeakMap, key: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`wm`.idx].has(heap[`key`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsWeakMapDelete*(wm: JsWeakMap, key: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`wm`.idx].delete(heap[`key`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── WeakSet ───

type JsWeakSet* = distinct JsValue

proc newJsWeakSet*(): JsWeakSet =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new WeakSet())};".}
  else:
    result = JsWeakSet(JsValue(idx: 0))

proc jsWeakSetAdd*(ws: JsWeakSet, val: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`ws`.idx].add(heap[`val`.idx]);".}
  else:
    discard

proc jsWeakSetHas*(ws: JsWeakSet, val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`ws`.idx].has(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsWeakSetDelete*(ws: JsWeakSet, val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`ws`.idx].delete(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── Error ───

type JsError* = distinct JsValue

proc newJsError*(msg: string): JsError =
  when defined(wasm32):
    {.emit: """
    var m = `msg`;
    `result` = {idx: addHeapObject(new Error(m))};
    """.}
  else:
    result = JsError(JsValue(idx: 0))

proc jsErrorMessage*(err: JsError): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: """
    var s = heap[`err`.idx].stack || '';
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsErrorName*(err: JsError): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: """
    var m = `msg`;
    `result` = {idx: addHeapObject(new TypeError(m))};
    """.}
  else:
    result = JsError(JsValue(idx: 0))

proc newJsRangeError*(msg: string): JsError =
  when defined(wasm32):
    {.emit: """
    var m = `msg`;
    `result` = {idx: addHeapObject(new RangeError(m))};
    """.}
  else:
    result = JsError(JsValue(idx: 0))

# ─── Reflect ───

proc jsReflectGet*(obj: JsValue, prop: string): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Reflect.get(heap[`obj`.idx], `prop`))};".}
  else:
    result = JsValue(idx: 0)

proc jsReflectSet*(obj: JsValue, prop: string, val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = Reflect.set(heap[`obj`.idx], `prop`, heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsReflectHas*(obj: JsValue, prop: string): bool =
  when defined(wasm32):
    {.emit: "`result` = Reflect.has(heap[`obj`.idx], `prop`) ? 1 : 0;".}
  else:
    result = false

proc jsReflectDeleteProperty*(obj: JsValue, prop: string): bool =
  when defined(wasm32):
    {.emit: "`result` = Reflect.deleteProperty(heap[`obj`.idx], `prop`) ? 1 : 0;".}
  else:
    result = false

proc jsReflectOwnKeys*(obj: JsValue): JsArray =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Reflect.ownKeys(heap[`obj`.idx]))};".}
  else:
    result = JsArray(JsValue(idx: 0))

proc jsReflectApply*(funcObj: JsValue, thisArg: JsValue, args: JsArray): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Reflect.apply(heap[`funcObj`.idx], heap[`thisArg`.idx], heap[`args`.idx]))};".}
  else:
    result = JsValue(idx: 0)

proc jsReflectConstruct*(funcObj: JsValue, args: JsArray): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Reflect.construct(heap[`funcObj`.idx], heap[`args`.idx]))};".}
  else:
    result = JsValue(idx: 0)

# ─── Symbol ───

proc jsSymbolFor*(key: string): JsValue =
  when defined(wasm32):
    {.emit: """
    var k = `key`;
    `result` = {idx: addHeapObject(Symbol.for(k))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsSymbolKeyFor*(sym: JsValue): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Symbol.iterator)};".}
  else:
    result = JsValue(idx: 0)

proc jsSymbolToStringTag*(): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(Symbol.toStringTag)};".}
  else:
    result = JsValue(idx: 0)

# ─── TypedArrays ───

type JsUint8Array* = distinct JsValue

proc newJsUint8Array*(len: int): JsUint8Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Uint8Array(`len`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArrayFromBuffer*(buf: pointer, len: int): JsUint8Array =
  when defined(wasm32):
    {.emit: """
    var src = new Uint8Array(wasmExports.memory.buffer, `buf`, `len`);
    var copy = new Uint8Array(`len`);
    copy.set(src);
    `result` = {idx: addHeapObject(copy)};
    """.}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArrayLen*(arr: JsUint8Array): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0

proc jsUint8ArrayGet*(arr: JsUint8Array, idx: int): uint8 =
  when defined(wasm32):
    {.emit: "`result` = heap[`arr`.idx][`idx`];".}
  else:
    result = 0'u8

proc jsUint8ArraySet*(arr: JsUint8Array, idx: int, val: uint8) =
  when defined(wasm32):
    {.emit: "heap[`arr`.idx][`idx`] = `val`;".}
  else:
    discard

proc jsUint8ArraySlice*(arr: JsUint8Array, start: int = 0, stop: int = -1): JsUint8Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArraySubarray*(arr: JsUint8Array, start: int, stop: int): JsUint8Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `stop`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArrayFill*(arr: JsUint8Array, val: uint8, start: int = 0, stop: int = -1): JsUint8Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].fill(`val`, `start`, `stop`))};".}
  else:
    result = JsUint8Array(JsValue(idx: 0))

proc jsUint8ArraySetFromSlice*(arr: JsUint8Array, offset: int, src: JsUint8Array) =
  when defined(wasm32):
    {.emit: "heap[`arr`.idx].set(heap[`src`.idx], `offset`);".}
  else:
    discard

type JsInt8Array* = distinct JsValue

proc newJsInt8Array*(len: int): JsInt8Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Int8Array(`len`))};".}
  else:
    result = JsInt8Array(JsValue(idx: 0))

type JsUint16Array* = distinct JsValue

proc newJsUint16Array*(len: int): JsUint16Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Uint16Array(`len`))};".}
  else:
    result = JsUint16Array(JsValue(idx: 0))

type JsInt16Array* = distinct JsValue

proc newJsInt16Array*(len: int): JsInt16Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Int16Array(`len`))};".}
  else:
    result = JsInt16Array(JsValue(idx: 0))

type JsUint32Array* = distinct JsValue

proc newJsUint32Array*(len: int): JsUint32Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Uint32Array(`len`))};".}
  else:
    result = JsUint32Array(JsValue(idx: 0))

type JsInt32Array* = distinct JsValue

proc newJsInt32Array*(len: int): JsInt32Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Int32Array(`len`))};".}
  else:
    result = JsInt32Array(JsValue(idx: 0))

type JsFloat32Array* = distinct JsValue

proc newJsFloat32Array*(len: int): JsFloat32Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Float32Array(`len`))};".}
  else:
    result = JsFloat32Array(JsValue(idx: 0))

type JsFloat64Array* = distinct JsValue

proc newJsFloat64Array*(len: int): JsFloat64Array =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Float64Array(`len`))};".}
  else:
    result = JsFloat64Array(JsValue(idx: 0))

# ─── ArrayBuffer ───

type JsArrayBuffer* = distinct JsValue

proc newJsArrayBuffer*(len: int): JsArrayBuffer =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new ArrayBuffer(`len`))};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsArrayBufferByteLength*(buf: JsArrayBuffer): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].byteLength;".}
  else:
    result = 0

proc jsArrayBufferSlice*(buf: JsArrayBuffer, start: int, stop: int): JsArrayBuffer =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`buf`.idx].slice(`start`, `stop`))};".}
  else:
    result = JsArrayBuffer(JsValue(idx: 0))

proc jsArrayBufferIsView*(val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = ArrayBuffer.isView(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

# ─── DataView ───

type JsDataView* = distinct JsValue

proc newJsDataView*(buf: JsArrayBuffer, offset: int = 0, len: int = -1): JsDataView =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = heap[`dv`.idx].getUint8(`offset`);".}
  else:
    result = 0'u8

proc jsDataViewSetUint8*(dv: JsDataView, offset: int, val: uint8) =
  when defined(wasm32):
    {.emit: "heap[`dv`.idx].setUint8(`offset`, `val`);".}
  else:
    discard

proc jsDataViewGetInt32*(dv: JsDataView, offset: int, littleEndian: bool = true): int32 =
  when defined(wasm32):
    {.emit: "`result` = heap[`dv`.idx].getInt32(`offset`, `littleEndian`);".}
  else:
    result = 0'i32

proc jsDataViewSetInt32*(dv: JsDataView, offset: int, val: int32, littleEndian: bool = true) =
  when defined(wasm32):
    {.emit: "heap[`dv`.idx].setInt32(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetUint32*(dv: JsDataView, offset: int, littleEndian: bool = true): uint32 =
  when defined(wasm32):
    {.emit: "`result` = heap[`dv`.idx].getUint32(`offset`, `littleEndian`);".}
  else:
    result = 0'u32

proc jsDataViewSetUint32*(dv: JsDataView, offset: int, val: uint32, littleEndian: bool = true) =
  when defined(wasm32):
    {.emit: "heap[`dv`.idx].setUint32(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetFloat32*(dv: JsDataView, offset: int, littleEndian: bool = true): float32 =
  when defined(wasm32):
    {.emit: "`result` = heap[`dv`.idx].getFloat32(`offset`, `littleEndian`);".}
  else:
    result = 0'f32

proc jsDataViewSetFloat32*(dv: JsDataView, offset: int, val: float32, littleEndian: bool = true) =
  when defined(wasm32):
    {.emit: "heap[`dv`.idx].setFloat32(`offset`, `val`, `littleEndian`);".}
  else:
    discard

proc jsDataViewGetFloat64*(dv: JsDataView, offset: int, littleEndian: bool = true): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`dv`.idx].getFloat64(`offset`, `littleEndian`);".}
  else:
    result = 0.0

proc jsDataViewSetFloat64*(dv: JsDataView, offset: int, val: float64, littleEndian: bool = true) =
  when defined(wasm32):
    {.emit: "heap[`dv`.idx].setFloat64(`offset`, `val`, `littleEndian`);".}
  else:
    discard

# ─── Console ───

proc jsConsoleLog*(val: JsValue) =
  when defined(wasm32):
    {.emit: "console.log(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleLogStr*(msg: string) =
  when defined(wasm32):
    {.emit: """
    var m = `msg`;
    console.log(m);
    """.}
  else:
    discard

proc jsConsoleWarn*(val: JsValue) =
  when defined(wasm32):
    {.emit: "console.warn(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleError*(val: JsValue) =
  when defined(wasm32):
    {.emit: "console.error(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleInfo*(val: JsValue) =
  when defined(wasm32):
    {.emit: "console.info(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleDebug*(val: JsValue) =
  when defined(wasm32):
    {.emit: "console.debug(heap[`val`.idx]);".}
  else:
    discard

proc jsConsoleTime*(label: string) =
  when defined(wasm32):
    {.emit: "console.time(`label`);".}
  else:
    discard

proc jsConsoleTimeEnd*(label: string) =
  when defined(wasm32):
    {.emit: "console.timeEnd(`label`);".}
  else:
    discard

proc jsConsoleAssert*(condition: bool, msg: string) =
  when defined(wasm32):
    {.emit: "console.assert(`condition`, `msg`);".}
  else:
    discard

# ─── Global / eval ───

proc jsGlobalThis*(): JsObject =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(globalThis)};".}
  else:
    result = JsObject(JsValue(idx: 0))

proc jsEval*(code: string): JsValue =
  when defined(wasm32):
    {.emit: """
    var c = `code`;
    `result` = {idx: addHeapObject(eval(c))};
    """.}
  else:
    result = JsValue(idx: 0)

proc jsTypeOf*(val: JsValue): string =
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

proc jsInstanceOf*(val: JsValue, constructor: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`val`.idx] instanceof heap[`constructor`.idx] ? 1 : 0;".}
  else:
    result = false

# ─── Number ───

proc jsNumberIsFinite*(val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = Number.isFinite(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsNumberIsNaN*(val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = Number.isNaN(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsNumberIsInteger*(val: JsValue): bool =
  when defined(wasm32):
    {.emit: "`result` = Number.isInteger(heap[`val`.idx]) ? 1 : 0;".}
  else:
    result = false

proc jsNumberParseFloat*(str: string): float64 =
  when defined(wasm32):
    {.emit: """
    var s = `str`;
    `result` = parseFloat(s);
    """.}
  else:
    result = 0.0

proc jsNumberParseInt*(str: string, radix: int = 10): int =
  when defined(wasm32):
    {.emit: """
    var s = `str`;
    `result` = parseInt(s, `radix`);
    """.}
  else:
    result = 0

# ─── String ───

proc jsStringFromCharCode*(code: int): string =
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = setTimeout(heap[`callback`.idx], `ms`);".}
  else:
    result = 0

proc jsClearTimeout*(id: int) =
  when defined(wasm32):
    {.emit: "clearTimeout(`id`);".}
  else:
    discard

proc jsSetInterval*(callback: JsValue, ms: int): int =
  when defined(wasm32):
    {.emit: "`result` = setInterval(heap[`callback`.idx], `ms`);".}
  else:
    result = 0

proc jsClearInterval*(id: int) =
  when defined(wasm32):
    {.emit: "clearInterval(`id`);".}
  else:
    discard

# ─── fetch (minimal) ───

proc jsFetch*(url: string): JsPromise =
  when defined(wasm32):
    {.emit: """
    var u = `url`;
    `result` = {idx: addHeapObject(fetch(u))};
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsFetchWithInit*(url: string, init: JsValue): JsPromise =
  when defined(wasm32):
    {.emit: """
    var u = `url`;
    `result` = {idx: addHeapObject(fetch(u, heap[`init`.idx]))};
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))
