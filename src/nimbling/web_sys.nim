## web-sys equivalent for nimbling: bindings to Web APIs (DOM, Events, Canvas, Fetch, etc).
## Mirrors Rust's web-sys crate.

import runtime
import js_sys

when defined(emscripten):
  {.emit: "#include <emscripten.h>".}

# ─── DOM Types ───

type
  JsElement* = distinct JsValue
  JsDocument* = distinct JsValue
  JsNode* = distinct JsValue
  JsWindow* = distinct JsValue
  JsHTMLElement* = distinct JsValue
  JsHTMLCanvasElement* = distinct JsValue
  JsHTMLInputElement* = distinct JsValue
  JsHTMLImageElement* = distinct JsValue
  JsDocumentFragment* = distinct JsValue
  JsNodeList* = distinct JsValue
  JsCSSStyleDeclaration* = distinct JsValue
  JsDOMTokenList* = distinct JsValue
  JsDOMRect* = distinct JsValue
  JsLocation* = distinct JsValue
  JsHistory* = distinct JsValue
  JsPerformance* = distinct JsValue
  JsEvent* = distinct JsValue
  JsMouseEvent* = distinct JsValue
  JsKeyboardEvent* = distinct JsValue
  JsCanvasRenderingContext2D* = distinct JsValue
  JsImageBitmap* = distinct JsValue
  JsStorage* = distinct JsValue
  JsWebSocket* = distinct JsValue
  JsResponse* = distinct JsValue
  JsRequest* = distinct JsValue
  JsHeaders* = distinct JsValue

# ─── Document ───

proc jsGetDocument*(): JsDocument =
  when defined(emscripten):
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(document); });".}
    result = JsDocument(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(document)};".}
  else:
    result = JsDocument(JsValue(idx: 0))
proc jsDocumentGetElementById*(doc: JsDocument, id: string): JsElement =
  when defined(emscripten):
    var docIdx = cast[JsValue](doc).idx
    var idPtr = id.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getElementById(UTF8ToString($1))); }, `docIdx`, `idPtr`);".}
    result = JsElement(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var el = heap[`doc`.idx].getElementById(`id`);
    `result` = {idx: addHeapObject(el)};
    """.}
  else:
    result = JsElement(JsValue(idx: 0))
proc jsDocumentCreateElement*(doc: JsDocument, tag: string): JsElement =
  when defined(emscripten):
    var docIdx = cast[JsValue](doc).idx
    var tagPtr = tag.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createElement(UTF8ToString($1))); }, `docIdx`, `tagPtr`);".}
    result = JsElement(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var el = heap[`doc`.idx].createElement(`tag`);
    `result` = {idx: addHeapObject(el)};
    """.}
  else:
    result = JsElement(JsValue(idx: 0))
proc jsDocumentCreateTextNode*(doc: JsDocument, text: string): JsNode =
  when defined(emscripten):
    var docIdx = cast[JsValue](doc).idx
    var textPtr = text.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createTextNode(UTF8ToString($1))); }, `docIdx`, `textPtr`);".}
    result = JsNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var node = heap[`doc`.idx].createTextNode(`text`);
    `result` = {idx: addHeapObject(node)};
    """.}
  else:
    result = JsNode(JsValue(idx: 0))
proc jsDocumentBody*(doc: JsDocument): JsElement =
  when defined(emscripten):
    var docIdx = cast[JsValue](doc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].body); });", `docIdx`.}
    result = JsElement(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`doc`.idx].body)};".}
  else:
    result = JsElement(JsValue(idx: 0))
proc jsDocumentHead*(doc: JsDocument): JsElement =
  when defined(emscripten):
    var docIdx = cast[JsValue](doc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].head); });", `docIdx`.}
    result = JsElement(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`doc`.idx].head)};".}
  else:
    result = JsElement(JsValue(idx: 0))
# ─── Element ───

proc jsElementGetAttribute*(el: JsElement, name: string): string =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var namePtr = name.cstring
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return (heap[$0].getAttribute(UTF8ToString($1)) || '').length; }, `elIdx`, `namePtr`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].getAttribute(UTF8ToString($1)) || ''; var p = $2; for (var i = 0; i < $3; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `elIdx`, `namePtr`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`el`.idx].getAttribute(`name`) || "";
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsElementSetAttribute*(el: JsElement, name: string, value: string) =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var nameVal = name
    var valuePtr = value.cstring
    {.emit: "EM_ASM({heap[$0].setAttribute($1, UTF8ToString($2));}, `elIdx`, `nameVal`, `valuePtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`el`.idx].setAttribute(`name`, `value`);".}
  else:
    discard
proc jsElementRemoveAttribute*(el: JsElement, name: string) =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var namePtr = name.cstring
    {.emit: "EM_ASM({heap[$0].removeAttribute(UTF8ToString($1));}, `elIdx`, `namePtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`el`.idx].removeAttribute(`name`);".}
  else:
    discard
proc jsElementClassList*(el: JsElement): JsDOMTokenList =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].classList); });", `elIdx`.}
    result = JsDOMTokenList(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`el`.idx].classList)};".}
  else:
    result = JsDOMTokenList(JsValue(idx: 0))
proc jsElementInnerHTML*(el: JsElement): string =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].innerHTML.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].innerHTML; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`el`.idx].innerHTML;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsElementSetInnerHTML*(el: JsElement, html: string) =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var htmlPtr = html.cstring
    {.emit: "EM_ASM({ heap[$0].innerHTML = UTF8ToString($1); }, `elIdx`, `htmlPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`el`.idx].innerHTML = `html`;".}
  else:
    discard
proc jsElementInnerText*(el: JsElement): string =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].innerText.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].innerText; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`el`.idx].innerText;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsElementSetInnerText*(el: JsElement, text: string) =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var textPtr = text.cstring
    {.emit: "EM_ASM({ heap[$0].innerText = UTF8ToString($1); }, `elIdx`, `textPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`el`.idx].innerText = `text`;".}
  else:
    discard
proc jsElementAppendChild*(parent: JsElement, child: JsNode): JsNode =
  when defined(emscripten):
    var parentIdx = cast[JsValue](parent).idx
    var childIdx = cast[JsValue](child).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].appendChild(heap[$1])); });", `parentIdx`, `childIdx`.}
    result = JsNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`parent`.idx].appendChild(heap[`child`.idx]))};".}
  else:
    result = JsNode(JsValue(idx: 0))
proc jsElementRemoveChild*(parent: JsElement, child: JsNode): JsNode =
  when defined(emscripten):
    var parentIdx = cast[JsValue](parent).idx
    var childIdx = cast[JsValue](child).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].removeChild(heap[$1])); });", `parentIdx`, `childIdx`.}
    result = JsNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`parent`.idx].removeChild(heap[`child`.idx]))};".}
  else:
    result = JsNode(JsValue(idx: 0))
proc jsElementQuerySelector*(el: JsElement, selector: string): JsElement =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var selectorPtr = selector.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].querySelector(UTF8ToString($1))); }, `elIdx`, `selectorPtr`);".}
    result = JsElement(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var found = heap[`el`.idx].querySelector(`selector`);
    `result` = {idx: addHeapObject(found)};
    """.}
  else:
    result = JsElement(JsValue(idx: 0))
proc jsElementQuerySelectorAll*(el: JsElement, selector: string): JsNodeList =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var selectorPtr = selector.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].querySelectorAll(UTF8ToString($1))); }, `elIdx`, `selectorPtr`);".}
    result = JsNodeList(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var list = heap[`el`.idx].querySelectorAll(`selector`);
    `result` = {idx: addHeapObject(list)};
    """.}
  else:
    result = JsNodeList(JsValue(idx: 0))
proc jsElementStyle*(el: JsElement): JsCSSStyleDeclaration =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].style); });", `elIdx`.}
    result = JsCSSStyleDeclaration(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`el`.idx].style)};".}
  else:
    result = JsCSSStyleDeclaration(JsValue(idx: 0))
proc jsElementGetBoundingClientRect*(el: JsElement): JsDOMRect =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getBoundingClientRect()); });", `elIdx`.}
    result = JsDOMRect(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`el`.idx].getBoundingClientRect())};".}
  else:
    result = JsDOMRect(JsValue(idx: 0))
# ─── NodeList ───

proc jsNodeListLen*(list: JsNodeList): int =
  when defined(emscripten):
    var listIdx = cast[JsValue](list).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].length; });", `listIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`list`.idx].length;".}
  else:
    result = 0
proc jsNodeListItem*(list: JsNodeList, idx: int): JsNode =
  when defined(emscripten):
    var listIdx = cast[JsValue](list).idx
    var idxVal = idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0][$1]); });", `listIdx`, `idxVal`.}
    result = JsNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`list`.idx][`idx`])};".}
  else:
    result = JsNode(JsValue(idx: 0))
# ─── Events ───

proc jsEventTarget*(e: JsEvent): JsElement =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].target); });", `eIdx`.}
    result = JsElement(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`e`.idx].target)};".}
  else:
    result = JsElement(JsValue(idx: 0))
proc jsEventPreventDefault*(e: JsEvent) =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    {.emit: "EM_ASM({ heap[$0].preventDefault(); }, `eIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`e`.idx].preventDefault();".}
  else:
    discard
proc jsEventStopPropagation*(e: JsEvent) =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    {.emit: "EM_ASM({ heap[$0].stopPropagation(); }, `eIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`e`.idx].stopPropagation();".}
  else:
    discard
proc jsEventStopImmediatePropagation*(e: JsEvent) =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    {.emit: "EM_ASM({ heap[$0].stopImmediatePropagation(); }, `eIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`e`.idx].stopImmediatePropagation();".}
  else:
    discard
proc jsMouseEventClientX*(e: JsMouseEvent): int =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].clientX; });", `eIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`e`.idx].clientX;".}
  else:
    result = 0
proc jsMouseEventClientY*(e: JsMouseEvent): int =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].clientY; });", `eIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`e`.idx].clientY;".}
  else:
    result = 0
proc jsMouseEventButton*(e: JsMouseEvent): int =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].button; });", `eIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`e`.idx].button;".}
  else:
    result = 0
proc jsKeyboardEventKey*(e: JsKeyboardEvent): string =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].key.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].key; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`e`.idx].key;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsKeyboardEventCode*(e: JsKeyboardEvent): string =
  when defined(emscripten):
    var eIdx = cast[JsValue](e).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].code.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].code; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`e`.idx].code;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsElementAddEventListener*(el: JsElement, event: string, handler: JsValue) =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var eventVal = event
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({heap[$0].addEventListener($1, heap[$2]);}, `elIdx`, `eventVal`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`el`.idx].addEventListener(`event`, heap[`handler`.idx]);".}
  else:
    discard
proc jsElementRemoveEventListener*(el: JsElement, event: string, handler: JsValue) =
  when defined(emscripten):
    var elIdx = cast[JsValue](el).idx
    var eventVal = event
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({heap[$0].removeEventListener($1, heap[$2]);}, `elIdx`, `eventVal`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`el`.idx].removeEventListener(`event`, heap[`handler`.idx]);".}
  else:
    discard
proc jsWindowAddEventListener*(win: JsWindow, event: string, handler: JsValue) =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var eventVal = event
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({heap[$0].addEventListener($1, heap[$2]);}, `winIdx`, `eventVal`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`win`.idx].addEventListener(`event`, heap[`handler`.idx]);".}
  else:
    discard
# ─── Window ───

proc jsGetWindow*(): JsWindow =
  when defined(emscripten):
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(window); });".}
    result = JsWindow(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(window)};".}
  else:
    result = JsWindow(JsValue(idx: 0))
proc jsWindowInnerWidth*(win: JsWindow): int =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].innerWidth; });", `winIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`win`.idx].innerWidth;".}
  else:
    result = 0
proc jsWindowInnerHeight*(win: JsWindow): int =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].innerHeight; });", `winIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`win`.idx].innerHeight;".}
  else:
    result = 0
proc jsWindowLocation*(win: JsWindow): JsLocation =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].location); });", `winIdx`.}
    result = JsLocation(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].location)};".}
  else:
    result = JsLocation(JsValue(idx: 0))
proc jsWindowHistory*(win: JsWindow): JsHistory =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].history); });", `winIdx`.}
    result = JsHistory(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].history)};".}
  else:
    result = JsHistory(JsValue(idx: 0))
proc jsWindowLocalStorage*(win: JsWindow): JsStorage =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].localStorage); });", `winIdx`.}
    result = JsStorage(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].localStorage)};".}
  else:
    result = JsStorage(JsValue(idx: 0))
proc jsWindowSessionStorage*(win: JsWindow): JsStorage =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].sessionStorage); });", `winIdx`.}
    result = JsStorage(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].sessionStorage)};".}
  else:
    result = JsStorage(JsValue(idx: 0))
proc jsWindowFetch*(win: JsWindow, url: string): JsPromise =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var urlPtr = url.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ var u = UTF8ToString($1); return addHeapObject(heap[$0].fetch(u)); }, `{obj}Idx`, `{arg}Ptr`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var u = `url`;
    `result` = {idx: addHeapObject(heap[`win`.idx].fetch(u))};
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsWindowRequestAnimationFrame*(win: JsWindow, callback: JsValue): int =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var callbackIdx = cast[JsValue](callback).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].requestAnimationFrame(heap[$1]); });", `winIdx`, `callbackIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`win`.idx].requestAnimationFrame(heap[`callback`.idx]);".}
  else:
    result = 0
proc jsWindowCancelAnimationFrame*(win: JsWindow, id: int) =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var idVal = id
    {.emit: "EM_ASM({heap[$0].cancelAnimationFrame($1);}, `winIdx`, `idVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`win`.idx].cancelAnimationFrame(`id`);".}
  else:
    discard
proc jsWindowPerformance*(win: JsWindow): JsPerformance =
  when defined(emscripten):
    var winIdx = cast[JsValue](win).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].performance); });", `winIdx`.}
    result = JsPerformance(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].performance)};".}
  else:
    result = JsPerformance(JsValue(idx: 0))
# ─── Canvas ───

proc jsHTMLCanvasElementGetContext*(canvas: JsHTMLCanvasElement, contextType: string): JsCanvasRenderingContext2D =
  when defined(emscripten):
    var canvasIdx = cast[JsValue](canvas).idx
    var contextTypePtr = contextType.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getContext(UTF8ToString($1))); }, `canvasIdx`, `contextTypePtr`);".}
    result = JsCanvasRenderingContext2D(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var ctx = heap[`canvas`.idx].getContext(`contextType`);
    `result` = {idx: addHeapObject(ctx)};
    """.}
  else:
    result = JsCanvasRenderingContext2D(JsValue(idx: 0))
proc jsCanvasCtxFillRect*(ctx: JsCanvasRenderingContext2D, x, y, w, h: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    var wVal = w
    var hVal = h
    {.emit: "EM_ASM({heap[$0].fillRect($1, $2, $3, $4);}, `ctxIdx`, `xVal`, `yVal`, `wVal`, `hVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].fillRect(`x`, `y`, `w`, `h`);".}
  else:
    discard
proc jsCanvasCtxClearRect*(ctx: JsCanvasRenderingContext2D, x, y, w, h: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    var wVal = w
    var hVal = h
    {.emit: "EM_ASM({heap[$0].clearRect($1, $2, $3, $4);}, `ctxIdx`, `xVal`, `yVal`, `wVal`, `hVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].clearRect(`x`, `y`, `w`, `h`);".}
  else:
    discard
proc jsCanvasCtxStrokeRect*(ctx: JsCanvasRenderingContext2D, x, y, w, h: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    var wVal = w
    var hVal = h
    {.emit: "EM_ASM({heap[$0].strokeRect($1, $2, $3, $4);}, `ctxIdx`, `xVal`, `yVal`, `wVal`, `hVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].strokeRect(`x`, `y`, `w`, `h`);".}
  else:
    discard
proc jsCanvasCtxFillText*(ctx: JsCanvasRenderingContext2D, text: string, x, y: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var textVal = text
    var xVal = x
    var yVal = y
    {.emit: "EM_ASM({heap[$0].fillText($1, $2, $3);}, `ctxIdx`, `textVal`, `xVal`, `yVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].fillText(`text`, `x`, `y`);".}
  else:
    discard
proc jsCanvasCtxStrokeText*(ctx: JsCanvasRenderingContext2D, text: string, x, y: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var textVal = text
    var xVal = x
    var yVal = y
    {.emit: "EM_ASM({heap[$0].strokeText($1, $2, $3);}, `ctxIdx`, `textVal`, `xVal`, `yVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].strokeText(`text`, `x`, `y`);".}
  else:
    discard
proc jsCanvasCtxBeginPath*(ctx: JsCanvasRenderingContext2D) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].beginPath(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].beginPath();".}
  else:
    discard
proc jsCanvasCtxClosePath*(ctx: JsCanvasRenderingContext2D) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].closePath(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].closePath();".}
  else:
    discard
proc jsCanvasCtxMoveTo*(ctx: JsCanvasRenderingContext2D, x, y: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    {.emit: "EM_ASM({heap[$0].moveTo($1, $2);}, `ctxIdx`, `xVal`, `yVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].moveTo(`x`, `y`);".}
  else:
    discard
proc jsCanvasCtxLineTo*(ctx: JsCanvasRenderingContext2D, x, y: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    {.emit: "EM_ASM({heap[$0].lineTo($1, $2);}, `ctxIdx`, `xVal`, `yVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].lineTo(`x`, `y`);".}
  else:
    discard
proc jsCanvasCtxArc*(ctx: JsCanvasRenderingContext2D, x, y, r, startAngle, endAngle: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    var rVal = r
    var startAngleVal = startAngle
    var endAngleVal = endAngle
    {.emit: "EM_ASM({heap[$0].arc($1, $2, $3, $4, $5);}, `ctxIdx`, `xVal`, `yVal`, `rVal`, `startAngleVal`, `endAngleVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].arc(`x`, `y`, `r`, `startAngle`, `endAngle`);".}
  else:
    discard
proc jsCanvasCtxFill*(ctx: JsCanvasRenderingContext2D) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].fill(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].fill();".}
  else:
    discard
proc jsCanvasCtxStroke*(ctx: JsCanvasRenderingContext2D) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].stroke(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].stroke();".}
  else:
    discard
proc jsCanvasCtxSetFillStyle*(ctx: JsCanvasRenderingContext2D, color: string) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var colorPtr = color.cstring
    {.emit: "EM_ASM({ heap[$0].fillStyle = UTF8ToString($1); }, `ctxIdx`, `colorPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].fillStyle = `color`;".}
  else:
    discard
proc jsCanvasCtxSetStrokeStyle*(ctx: JsCanvasRenderingContext2D, color: string) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var colorPtr = color.cstring
    {.emit: "EM_ASM({ heap[$0].strokeStyle = UTF8ToString($1); }, `ctxIdx`, `colorPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].strokeStyle = `color`;".}
  else:
    discard
proc jsCanvasCtxSetLineWidth*(ctx: JsCanvasRenderingContext2D, width: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var widthVal = width
    {.emit: "EM_ASM({ heap[$0].lineWidth = $1; }, `ctxIdx`, `widthVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].lineWidth = `width`;".}
  else:
    discard
proc jsCanvasCtxSetFont*(ctx: JsCanvasRenderingContext2D, font: string) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var fontPtr = font.cstring
    {.emit: "EM_ASM({ heap[$0].font = UTF8ToString($1); }, `ctxIdx`, `fontPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].font = `font`;".}
  else:
    discard
proc jsCanvasCtxDrawImage*(ctx: JsCanvasRenderingContext2D, img: JsImageBitmap, x, y: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var imgIdx = cast[JsValue](img).idx
    var xVal = x
    var yVal = y
    {.emit: "EM_ASM({heap[$0].drawImage(heap[$1], $2, $3);}, `ctxIdx`, `imgIdx`, `xVal`, `yVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].drawImage(heap[`img`.idx], `x`, `y`);".}
  else:
    discard
proc jsCanvasCtxSave*(ctx: JsCanvasRenderingContext2D) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].save(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].save();".}
  else:
    discard
proc jsCanvasCtxRestore*(ctx: JsCanvasRenderingContext2D) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].restore(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].restore();".}
  else:
    discard
proc jsCanvasCtxTranslate*(ctx: JsCanvasRenderingContext2D, x, y: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    {.emit: "EM_ASM({heap[$0].translate($1, $2);}, `ctxIdx`, `xVal`, `yVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].translate(`x`, `y`);".}
  else:
    discard
proc jsCanvasCtxRotate*(ctx: JsCanvasRenderingContext2D, angle: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var angleVal = angle
    {.emit: "EM_ASM({heap[$0].rotate($1);}, `ctxIdx`, `angleVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].rotate(`angle`);".}
  else:
    discard
proc jsCanvasCtxScale*(ctx: JsCanvasRenderingContext2D, x, y: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    {.emit: "EM_ASM({heap[$0].scale($1, $2);}, `ctxIdx`, `xVal`, `yVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].scale(`x`, `y`);".}
  else:
    discard
# ─── Storage ───

proc jsStorageGetItem*(storage: JsStorage, key: string): string =
  when defined(emscripten):
    var storageIdx = cast[JsValue](storage).idx
    var keyPtr = key.cstring
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return (heap[$0].getItem(UTF8ToString($1)) || '').length; }, `storageIdx`, `keyPtr`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].getItem(UTF8ToString($1)) || ''; var p = $2; for (var i = 0; i < $3; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `storageIdx`, `keyPtr`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`storage`.idx].getItem(`key`) || "";
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsStorageSetItem*(storage: JsStorage, key: string, value: string) =
  when defined(emscripten):
    var storageIdx = cast[JsValue](storage).idx
    var keyVal = key
    var valuePtr = value.cstring
    {.emit: "EM_ASM({heap[$0].setItem($1, UTF8ToString($2));}, `storageIdx`, `keyVal`, `valuePtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`storage`.idx].setItem(`key`, `value`);".}
  else:
    discard
proc jsStorageRemoveItem*(storage: JsStorage, key: string) =
  when defined(emscripten):
    var storageIdx = cast[JsValue](storage).idx
    var keyPtr = key.cstring
    {.emit: "EM_ASM({heap[$0].removeItem(UTF8ToString($1));}, `storageIdx`, `keyPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`storage`.idx].removeItem(`key`);".}
  else:
    discard
proc jsStorageClear*(storage: JsStorage) =
  when defined(emscripten):
    var storageIdx = cast[JsValue](storage).idx
    {.emit: "EM_ASM({ heap[$0].clear(); }, `storageIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`storage`.idx].clear();".}
  else:
    discard
proc jsStorageKey*(storage: JsStorage, idx: int): string =
  when defined(emscripten):
    var storageIdx = cast[JsValue](storage).idx
    var idxVal = idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return (heap[$0].key($1) || '').length; }, `storageIdx`, `idxVal`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].key($1) || ''; var p = $2; for (var i = 0; i < $3; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `storageIdx`, `idxVal`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`storage`.idx].key(`idx`) || "";
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsStorageLen*(storage: JsStorage): int =
  when defined(emscripten):
    var storageIdx = cast[JsValue](storage).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].length; });", `storageIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`storage`.idx].length;".}
  else:
    result = 0
# ─── WebSocket ───

proc newJsWebSocket*(url: string): JsWebSocket =
  when defined(emscripten):
    var idx: uint32
    var urlPtr = url.cstring
    {.emit: "`idx` = EM_ASM_INT({ var u = UTF8ToString($0); return addHeapObject(new WebSocket(u)); }, `{arg}Ptr`);".}
    result = JsWebSocket(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var u = `url`;
    `result` = {idx: addHeapObject(new WebSocket(u))};
    """.}
  else:
    result = JsWebSocket(JsValue(idx: 0))
proc jsWebSocketSend*(ws: JsWebSocket, data: string) =
  when defined(emscripten):
    var wsIdx = cast[JsValue](ws).idx
    var dataPtr = data.cstring
    {.emit: "EM_ASM({heap[$0].send(UTF8ToString($1));}, `wsIdx`, `dataPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`ws`.idx].send(`data`);".}
  else:
    discard
proc jsWebSocketClose*(ws: JsWebSocket, code: int = 1000, reason: string = "") =
  when defined(emscripten):
    var wsIdx = cast[JsValue](ws).idx
    var codeVal = code
    var reasonPtr = reason.cstring
    {.emit: "EM_ASM({ var r = UTF8ToString($2); if (r == '') { heap[$0].close($1); } else { heap[$0].close($1, r); } }, `{obj}Idx`, `codeVal`, `{arg}Ptr`);".}
  elif defined(wasm32):
    {.emit: """
    var r = `reason`;
    if (r == "") {
      heap[`ws`.idx].close(`code`);
    } else {
      heap[`ws`.idx].close(`code`, r);
    }
    """.}
  else:
    discard
proc jsWebSocketReadyState*(ws: JsWebSocket): int =
  when defined(emscripten):
    var wsIdx = cast[JsValue](ws).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].readyState; });", `wsIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`ws`.idx].readyState;".}
  else:
    result = 0
proc jsWebSocketOnOpen*(ws: JsWebSocket, handler: JsValue) =
  when defined(emscripten):
    var wsIdx = cast[JsValue](ws).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onopen = heap[$1]; }, `wsIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ws`.idx].onopen = heap[`handler`.idx];".}
  else:
    discard
proc jsWebSocketOnMessage*(ws: JsWebSocket, handler: JsValue) =
  when defined(emscripten):
    var wsIdx = cast[JsValue](ws).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onmessage = heap[$1]; }, `wsIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ws`.idx].onmessage = heap[`handler`.idx];".}
  else:
    discard
proc jsWebSocketOnError*(ws: JsWebSocket, handler: JsValue) =
  when defined(emscripten):
    var wsIdx = cast[JsValue](ws).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onerror = heap[$1]; }, `wsIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ws`.idx].onerror = heap[`handler`.idx];".}
  else:
    discard
proc jsWebSocketOnClose*(ws: JsWebSocket, handler: JsValue) =
  when defined(emscripten):
    var wsIdx = cast[JsValue](ws).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onclose = heap[$1]; }, `wsIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ws`.idx].onclose = heap[`handler`.idx];".}
  else:
    discard
# ─── Fetch API ───

proc newJsRequest*(url: string, init: JsValue = JsValue(idx: 0)): JsRequest =
  when defined(emscripten):
    var idx: uint32
    var initIdx = cast[JsValue](init).idx
    {.emit: "`idx` = EM_ASM_INT({ var u = UTF8ToString($0); var i = $1; if (i == 0) { return addHeapObject(new Request(u)); } else { return addHeapObject(new Request(u, heap[i])); } }, `{url_arg}Ptr`, `{init_arg}Idx`);".}
    result = JsRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var u = `url`;
    var i = `init`;
    if (i == 0) {
      `result` = {idx: addHeapObject(new Request(u))};
    } else {
      `result` = {idx: addHeapObject(new Request(u, heap[i]))};
    }
    """.}
  else:
    result = JsRequest(JsValue(idx: 0))
proc jsResponseOk*(resp: JsResponse): bool =
  when defined(emscripten):
    var respIdx = cast[JsValue](resp).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].ok ? 1 : 0; });", `respIdx`.}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`resp`.idx].ok ? 1 : 0;".}
  else:
    result = false
proc jsResponseStatus*(resp: JsResponse): int =
  when defined(emscripten):
    var respIdx = cast[JsValue](resp).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].status; });", `respIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`resp`.idx].status;".}
  else:
    result = 0
proc jsResponseStatusText*(resp: JsResponse): string =
  when defined(emscripten):
    var respIdx = cast[JsValue](resp).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].statusText.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].statusText; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`resp`.idx].statusText;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsResponseHeaders*(resp: JsResponse): JsHeaders =
  when defined(emscripten):
    var respIdx = cast[JsValue](resp).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].headers); });", `respIdx`.}
    result = JsHeaders(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].headers)};".}
  else:
    result = JsHeaders(JsValue(idx: 0))
proc jsResponseText*(resp: JsResponse): JsPromise =
  when defined(emscripten):
    var respIdx = cast[JsValue](resp).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].text()); });", `respIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].text())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsResponseJson*(resp: JsResponse): JsPromise =
  when defined(emscripten):
    var respIdx = cast[JsValue](resp).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].json()); });", `respIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].json())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsResponseArrayBuffer*(resp: JsResponse): JsPromise =
  when defined(emscripten):
    var respIdx = cast[JsValue](resp).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].arrayBuffer()); });", `respIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].arrayBuffer())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsResponseBlob*(resp: JsResponse): JsPromise =
  when defined(emscripten):
    var respIdx = cast[JsValue](resp).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].blob()); });", `respIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].blob())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
# ─── Location ───

proc jsLocationHref*(loc: JsLocation): string =
  when defined(emscripten):
    var locIdx = cast[JsValue](loc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].href.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].href; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`loc`.idx].href;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsLocationSetHref*(loc: JsLocation, url: string) =
  when defined(emscripten):
    var locIdx = cast[JsValue](loc).idx
    var urlPtr = url.cstring
    {.emit: "EM_ASM({ heap[$0].href = UTF8ToString($1); }, `locIdx`, `urlPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`loc`.idx].href = `url`;".}
  else:
    discard
proc jsLocationPathname*(loc: JsLocation): string =
  when defined(emscripten):
    var locIdx = cast[JsValue](loc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].pathname.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].pathname; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`loc`.idx].pathname;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsLocationSearch*(loc: JsLocation): string =
  when defined(emscripten):
    var locIdx = cast[JsValue](loc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].search.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].search; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`loc`.idx].search;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsLocationHash*(loc: JsLocation): string =
  when defined(emscripten):
    var locIdx = cast[JsValue](loc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].hash.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].hash; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`loc`.idx].hash;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsLocationAssign*(loc: JsLocation, url: string) =
  when defined(emscripten):
    var locIdx = cast[JsValue](loc).idx
    var urlPtr = url.cstring
    {.emit: "EM_ASM({heap[$0].assign(UTF8ToString($1));}, `locIdx`, `urlPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`loc`.idx].assign(`url`);".}
  else:
    discard
proc jsLocationReplace*(loc: JsLocation, url: string) =
  when defined(emscripten):
    var locIdx = cast[JsValue](loc).idx
    var urlPtr = url.cstring
    {.emit: "EM_ASM({heap[$0].replace(UTF8ToString($1));}, `locIdx`, `urlPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`loc`.idx].replace(`url`);".}
  else:
    discard
proc jsLocationReload*(loc: JsLocation) =
  when defined(emscripten):
    var locIdx = cast[JsValue](loc).idx
    {.emit: "EM_ASM({ heap[$0].reload(); }, `locIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`loc`.idx].reload();".}
  else:
    discard
# ─── History ───

proc jsHistoryPushState*(hist: JsHistory, state: JsValue, title: string, url: string) =
  when defined(emscripten):
    var histIdx = cast[JsValue](hist).idx
    var stateIdx = cast[JsValue](state).idx
    var titleVal = title
    var urlPtr = url.cstring
    {.emit: "EM_ASM({heap[$0].pushState(heap[$1], $2, UTF8ToString($3));}, `histIdx`, `stateIdx`, `titleVal`, `urlPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`hist`.idx].pushState(heap[`state`.idx], `title`, `url`);".}
  else:
    discard
proc jsHistoryReplaceState*(hist: JsHistory, state: JsValue, title: string, url: string) =
  when defined(emscripten):
    var histIdx = cast[JsValue](hist).idx
    var stateIdx = cast[JsValue](state).idx
    var titleVal = title
    var urlPtr = url.cstring
    {.emit: "EM_ASM({heap[$0].replaceState(heap[$1], $2, UTF8ToString($3));}, `histIdx`, `stateIdx`, `titleVal`, `urlPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`hist`.idx].replaceState(heap[`state`.idx], `title`, `url`);".}
  else:
    discard
proc jsHistoryBack*(hist: JsHistory) =
  when defined(emscripten):
    var histIdx = cast[JsValue](hist).idx
    {.emit: "EM_ASM({ heap[$0].back(); }, `histIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`hist`.idx].back();".}
  else:
    discard
proc jsHistoryForward*(hist: JsHistory) =
  when defined(emscripten):
    var histIdx = cast[JsValue](hist).idx
    {.emit: "EM_ASM({ heap[$0].forward(); }, `histIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`hist`.idx].forward();".}
  else:
    discard
# ─── Performance ───

proc jsPerformanceNow*(perf: JsPerformance): float64 =
  when defined(emscripten):
    var perfIdx = cast[JsValue](perf).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].now(); });", `perfIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`perf`.idx].now();".}
  else:
    result = 0.0
# ─── DOMRect ───

proc jsDOMRectX*(rect: JsDOMRect): float64 =
  when defined(emscripten):
    var rectIdx = cast[JsValue](rect).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].x; });", `rectIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`rect`.idx].x;".}
  else:
    result = 0.0
proc jsDOMRectY*(rect: JsDOMRect): float64 =
  when defined(emscripten):
    var rectIdx = cast[JsValue](rect).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].y; });", `rectIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`rect`.idx].y;".}
  else:
    result = 0.0
proc jsDOMRectWidth*(rect: JsDOMRect): float64 =
  when defined(emscripten):
    var rectIdx = cast[JsValue](rect).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].width; });", `rectIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`rect`.idx].width;".}
  else:
    result = 0.0
proc jsDOMRectHeight*(rect: JsDOMRect): float64 =
  when defined(emscripten):
    var rectIdx = cast[JsValue](rect).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].height; });", `rectIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`rect`.idx].height;".}
  else:
    result = 0.0
# ─── DOMTokenList ───

proc jsDOMTokenListAdd*(list: JsDOMTokenList, token: string) =
  when defined(emscripten):
    var listIdx = cast[JsValue](list).idx
    var tokenPtr = token.cstring
    {.emit: "EM_ASM({heap[$0].add(UTF8ToString($1));}, `listIdx`, `tokenPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`list`.idx].add(`token`);".}
  else:
    discard
proc jsDOMTokenListRemove*(list: JsDOMTokenList, token: string) =
  when defined(emscripten):
    var listIdx = cast[JsValue](list).idx
    var tokenPtr = token.cstring
    {.emit: "EM_ASM({heap[$0].remove(UTF8ToString($1));}, `listIdx`, `tokenPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`list`.idx].remove(`token`);".}
  else:
    discard
proc jsDOMTokenListToggle*(list: JsDOMTokenList, token: string): bool =
  when defined(emscripten):
    var listIdx = cast[JsValue](list).idx
    var tokenPtr = token.cstring
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].toggle(UTF8ToString($1)) ? 1 : 0; }, `listIdx`, `tokenPtr`);".}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`list`.idx].toggle(`token`) ? 1 : 0;".}
  else:
    result = false
proc jsDOMTokenListContains*(list: JsDOMTokenList, token: string): bool =
  when defined(emscripten):
    var listIdx = cast[JsValue](list).idx
    var tokenPtr = token.cstring
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].contains(UTF8ToString($1)) ? 1 : 0; }, `listIdx`, `tokenPtr`);".}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`list`.idx].contains(`token`) ? 1 : 0;".}
  else:
    result = false
# ─── Web Audio API ───

type
  JsAudioContext* = distinct JsValue
  JsAudioDestinationNode* = distinct JsValue
  JsAudioBuffer* = distinct JsValue
  JsAudioBufferSourceNode* = distinct JsValue
  JsOscillatorNode* = distinct JsValue
  JsGainNode* = distinct JsValue
  JsBiquadFilterNode* = distinct JsValue
  JsAnalyserNode* = distinct JsValue
  JsDelayNode* = distinct JsValue
  JsChannelMergerNode* = distinct JsValue
  JsChannelSplitterNode* = distinct JsValue
  JsMediaStreamAudioSourceNode* = distinct JsValue
  JsMediaElementAudioSourceNode* = distinct JsValue
  JsAudioListener* = distinct JsValue
  JsAudioParam* = distinct JsValue

# ─── AudioContext ───

proc jsNewAudioContext*(): JsAudioContext =
  when defined(emscripten):
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new AudioContext()); });".}
    result = JsAudioContext(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new AudioContext())};".}
  else:
    result = JsAudioContext(JsValue(idx: 0))
proc jsAudioContextDestination*(ctx: JsAudioContext): JsAudioDestinationNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].destination); });", `ctxIdx`.}
    result = JsAudioDestinationNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].destination)};".}
  else:
    result = JsAudioDestinationNode(JsValue(idx: 0))
proc jsAudioContextListener*(ctx: JsAudioContext): JsAudioListener =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].listener); });", `ctxIdx`.}
    result = JsAudioListener(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].listener)};".}
  else:
    result = JsAudioListener(JsValue(idx: 0))
proc jsAudioContextSampleRate*(ctx: JsAudioContext): float64 =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].sampleRate; });", `ctxIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`ctx`.idx].sampleRate;".}
  else:
    result = 0.0
proc jsAudioContextCurrentTime*(ctx: JsAudioContext): float64 =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].currentTime; });", `ctxIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`ctx`.idx].currentTime;".}
  else:
    result = 0.0
proc jsAudioContextState*(ctx: JsAudioContext): string =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].state.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].state; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`ctx`.idx].state;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsAudioContextResume*(ctx: JsAudioContext) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].resume(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].resume();".}
  else:
    discard
proc jsAudioContextSuspend*(ctx: JsAudioContext) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].suspend(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].suspend();".}
  else:
    discard
proc jsAudioContextClose*(ctx: JsAudioContext) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].close(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].close();".}
  else:
    discard
proc jsAudioContextCreateOscillator*(ctx: JsAudioContext): JsOscillatorNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createOscillator()); });", `ctxIdx`.}
    result = JsOscillatorNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createOscillator())};".}
  else:
    result = JsOscillatorNode(JsValue(idx: 0))
proc jsAudioContextCreateGain*(ctx: JsAudioContext): JsGainNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createGain()); });", `ctxIdx`.}
    result = JsGainNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createGain())};".}
  else:
    result = JsGainNode(JsValue(idx: 0))
proc jsAudioContextCreateBiquadFilter*(ctx: JsAudioContext): JsBiquadFilterNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createBiquadFilter()); });", `ctxIdx`.}
    result = JsBiquadFilterNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createBiquadFilter())};".}
  else:
    result = JsBiquadFilterNode(JsValue(idx: 0))
proc jsAudioContextCreateAnalyser*(ctx: JsAudioContext): JsAnalyserNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createAnalyser()); });", `ctxIdx`.}
    result = JsAnalyserNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createAnalyser())};".}
  else:
    result = JsAnalyserNode(JsValue(idx: 0))
proc jsAudioContextCreateDelay*(ctx: JsAudioContext, maxDelay: float64 = 1.0): JsDelayNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var maxDelayVal = maxDelay
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createDelay($1)); }, `ctxIdx`, `maxDelayVal`);".}
    result = JsDelayNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createDelay(`maxDelay`))};".}
  else:
    result = JsDelayNode(JsValue(idx: 0))
proc jsAudioContextCreateChannelMerger*(ctx: JsAudioContext, count: int = 6): JsChannelMergerNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var countVal = count
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createChannelMerger($1)); }, `ctxIdx`, `countVal`);".}
    result = JsChannelMergerNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createChannelMerger(`count`))};".}
  else:
    result = JsChannelMergerNode(JsValue(idx: 0))
proc jsAudioContextCreateChannelSplitter*(ctx: JsAudioContext, count: int = 6): JsChannelSplitterNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var countVal = count
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createChannelSplitter($1)); }, `ctxIdx`, `countVal`);".}
    result = JsChannelSplitterNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createChannelSplitter(`count`))};".}
  else:
    result = JsChannelSplitterNode(JsValue(idx: 0))
proc jsAudioContextCreateBuffer*(ctx: JsAudioContext, channels: int, length: int, sampleRate: float64): JsAudioBuffer =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var channelsVal = channels
    var lengthVal = length
    var sampleRateVal = sampleRate
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createBuffer($1, $2, $3)); }, `ctxIdx`, `channelsVal`, `lengthVal`, `sampleRateVal`);".}
    result = JsAudioBuffer(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createBuffer(`channels`, `length`, `sampleRate`))};".}
  else:
    result = JsAudioBuffer(JsValue(idx: 0))
proc jsAudioContextCreateBufferSource*(ctx: JsAudioContext): JsAudioBufferSourceNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createBufferSource()); });", `ctxIdx`.}
    result = JsAudioBufferSourceNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createBufferSource())};".}
  else:
    result = JsAudioBufferSourceNode(JsValue(idx: 0))
proc jsAudioContextCreateMediaStreamSource*(ctx: JsAudioContext, stream: JsValue): JsMediaStreamAudioSourceNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var streamIdx = cast[JsValue](stream).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createMediaStreamSource(heap[$1])); });", `ctxIdx`, `streamIdx`.}
    result = JsMediaStreamAudioSourceNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createMediaStreamSource(heap[`stream`.idx]))};".}
  else:
    result = JsMediaStreamAudioSourceNode(JsValue(idx: 0))
proc jsAudioContextCreateMediaElementSource*(ctx: JsAudioContext, element: JsValue): JsMediaElementAudioSourceNode =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var elementIdx = cast[JsValue](element).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createMediaElementSource(heap[$1])); });", `ctxIdx`, `elementIdx`.}
    result = JsMediaElementAudioSourceNode(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createMediaElementSource(heap[`element`.idx]))};".}
  else:
    result = JsMediaElementAudioSourceNode(JsValue(idx: 0))
# ─── AudioNode (shared connect/disconnect) ───

proc jsAudioNodeConnect*(source: JsValue, destination: JsValue) =
  when defined(emscripten):
    var sourceIdx = cast[JsValue](source).idx
    var destinationIdx = cast[JsValue](destination).idx
    {.emit: "EM_ASM({heap[$0].connect(heap[$1]);}, `sourceIdx`, `destinationIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`source`.idx].connect(heap[`destination`.idx]);".}
  else:
    discard
proc jsAudioNodeDisconnect*(source: JsValue) =
  when defined(emscripten):
    var sourceIdx = cast[JsValue](source).idx
    {.emit: "EM_ASM({ heap[$0].disconnect(); }, `sourceIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`source`.idx].disconnect();".}
  else:
    discard
# ─── OscillatorNode ───

proc jsOscillatorType*(osc: JsOscillatorNode): string =
  when defined(emscripten):
    var oscIdx = cast[JsValue](osc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].type.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].type; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`osc`.idx].type;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc `jsOscillatorType=`*(osc: JsOscillatorNode, t: string) =
  when defined(emscripten):
    var oscIdx = cast[JsValue](osc).idx
    var tPtr = t.cstring
    {.emit: "EM_ASM({ heap[$0].type = UTF8ToString($1); }, `oscIdx`, `tPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`osc`.idx].type = `t`;".}
  else:
    discard
proc jsOscillatorFrequency*(osc: JsOscillatorNode): JsAudioParam =
  when defined(emscripten):
    var oscIdx = cast[JsValue](osc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].frequency); });", `oscIdx`.}
    result = JsAudioParam(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`osc`.idx].frequency)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))
proc jsOscillatorDetune*(osc: JsOscillatorNode): JsAudioParam =
  when defined(emscripten):
    var oscIdx = cast[JsValue](osc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].detune); });", `oscIdx`.}
    result = JsAudioParam(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`osc`.idx].detune)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))
proc jsOscillatorStart*(osc: JsOscillatorNode, startTime: float64 = 0.0) =
  when defined(emscripten):
    var oscIdx = cast[JsValue](osc).idx
    var startTimeVal = startTime
    {.emit: "EM_ASM({heap[$0].start($1);}, `oscIdx`, `startTimeVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`osc`.idx].start(`startTime`);".}
  else:
    discard
proc jsOscillatorStop*(osc: JsOscillatorNode, stopTime: float64 = 0.0) =
  when defined(emscripten):
    var oscIdx = cast[JsValue](osc).idx
    var stopTimeVal = stopTime
    {.emit: "EM_ASM({heap[$0].stop($1);}, `oscIdx`, `stopTimeVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`osc`.idx].stop(`stopTime`);".}
  else:
    discard
# ─── GainNode ───

proc jsGainNodeGain*(node: JsGainNode): JsAudioParam =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].gain); });", `nodeIdx`.}
    result = JsAudioParam(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].gain)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))
# ─── AudioParam ───

proc jsAudioParamValue*(param: JsAudioParam): float64 =
  when defined(emscripten):
    var paramIdx = cast[JsValue](param).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].value; });", `paramIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`param`.idx].value;".}
  else:
    result = 0.0
proc `jsAudioParamValue=`*(param: JsAudioParam, val: float64) =
  when defined(emscripten):
    var paramIdx = cast[JsValue](param).idx
    var valVal = val
    {.emit: "EM_ASM({ heap[$0].value = $1; }, `paramIdx`, `valVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`param`.idx].value = `val`;".}
  else:
    discard
proc jsAudioParamSetValueAtTime*(param: JsAudioParam, value: float64, time: float64) =
  when defined(emscripten):
    var paramIdx = cast[JsValue](param).idx
    var valueVal = value
    var timeVal = time
    {.emit: "EM_ASM({heap[$0].setValueAtTime($1, $2);}, `paramIdx`, `valueVal`, `timeVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`param`.idx].setValueAtTime(`value`, `time`);".}
  else:
    discard
proc jsAudioParamLinearRampToValueAtTime*(param: JsAudioParam, value: float64, time: float64) =
  when defined(emscripten):
    var paramIdx = cast[JsValue](param).idx
    var valueVal = value
    var timeVal = time
    {.emit: "EM_ASM({heap[$0].linearRampToValueAtTime($1, $2);}, `paramIdx`, `valueVal`, `timeVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`param`.idx].linearRampToValueAtTime(`value`, `time`);".}
  else:
    discard
proc jsAudioParamExponentialRampToValueAtTime*(param: JsAudioParam, value: float64, time: float64) =
  when defined(emscripten):
    var paramIdx = cast[JsValue](param).idx
    var valueVal = value
    var timeVal = time
    {.emit: "EM_ASM({heap[$0].exponentialRampToValueAtTime($1, $2);}, `paramIdx`, `valueVal`, `timeVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`param`.idx].exponentialRampToValueAtTime(`value`, `time`);".}
  else:
    discard
proc jsAudioParamSetTargetAtTime*(param: JsAudioParam, target: float64, time: float64, tau: float64) =
  when defined(emscripten):
    var paramIdx = cast[JsValue](param).idx
    var targetVal = target
    var timeVal = time
    var tauVal = tau
    {.emit: "EM_ASM({heap[$0].setTargetAtTime($1, $2, $3);}, `paramIdx`, `targetVal`, `timeVal`, `tauVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`param`.idx].setTargetAtTime(`target`, `time`, `tau`);".}
  else:
    discard
proc jsAudioParamCancelScheduledValues*(param: JsAudioParam, time: float64) =
  when defined(emscripten):
    var paramIdx = cast[JsValue](param).idx
    var timeVal = time
    {.emit: "EM_ASM({heap[$0].cancelScheduledValues($1);}, `paramIdx`, `timeVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`param`.idx].cancelScheduledValues(`time`);".}
  else:
    discard
# ─── BiquadFilterNode ───

proc jsBiquadFilterType*(node: JsBiquadFilterNode): string =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].type.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].type; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`node`.idx].type;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc `jsBiquadFilterType=`*(node: JsBiquadFilterNode, t: string) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var tPtr = t.cstring
    {.emit: "EM_ASM({ heap[$0].type = UTF8ToString($1); }, `nodeIdx`, `tPtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].type = `t`;".}
  else:
    discard
proc jsBiquadFilterFrequency*(node: JsBiquadFilterNode): JsAudioParam =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].frequency); });", `nodeIdx`.}
    result = JsAudioParam(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].frequency)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))
proc jsBiquadFilterQ*(node: JsBiquadFilterNode): JsAudioParam =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].Q); });", `nodeIdx`.}
    result = JsAudioParam(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].Q)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))
proc jsBiquadFilterGain*(node: JsBiquadFilterNode): JsAudioParam =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].gain); });", `nodeIdx`.}
    result = JsAudioParam(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].gain)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))
proc jsBiquadFilterGetFrequencyResponse*(node: JsBiquadFilterNode, freqArray: JsValue, magArray: JsValue, phaseArray: JsValue) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var freqArrayIdx = cast[JsValue](freqArray).idx
    var magArrayIdx = cast[JsValue](magArray).idx
    var phaseArrayIdx = cast[JsValue](phaseArray).idx
    {.emit: "EM_ASM({heap[$0].getFrequencyResponse(heap[$1], heap[$2], heap[$3]);}, `nodeIdx`, `freqArrayIdx`, `magArrayIdx`, `phaseArrayIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].getFrequencyResponse(heap[`freqArray`.idx], heap[`magArray`.idx], heap[`phaseArray`.idx]);".}
  else:
    discard
# ─── AnalyserNode ───

proc jsAnalyserFftSize*(node: JsAnalyserNode): int =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].fftSize; });", `nodeIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].fftSize;".}
  else:
    result = 0
proc `jsAnalyserFftSize=`*(node: JsAnalyserNode, size: int) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var sizeVal = size
    {.emit: "EM_ASM({ heap[$0].fftSize = $1; }, `nodeIdx`, `sizeVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].fftSize = `size`;".}
  else:
    discard
proc jsAnalyserFrequencyBinCount*(node: JsAnalyserNode): int =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].frequencyBinCount; });", `nodeIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].frequencyBinCount;".}
  else:
    result = 0
proc jsAnalyserGetFloatFrequencyData*(node: JsAnalyserNode, array: JsValue) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var arrayIdx = cast[JsValue](array).idx
    {.emit: "EM_ASM({heap[$0].getFloatFrequencyData(heap[$1]);}, `nodeIdx`, `arrayIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].getFloatFrequencyData(heap[`array`.idx]);".}
  else:
    discard
proc jsAnalyserGetByteFrequencyData*(node: JsAnalyserNode, array: JsValue) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var arrayIdx = cast[JsValue](array).idx
    {.emit: "EM_ASM({heap[$0].getByteFrequencyData(heap[$1]);}, `nodeIdx`, `arrayIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].getByteFrequencyData(heap[`array`.idx]);".}
  else:
    discard
proc jsAnalyserGetFloatTimeDomainData*(node: JsAnalyserNode, array: JsValue) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var arrayIdx = cast[JsValue](array).idx
    {.emit: "EM_ASM({heap[$0].getFloatTimeDomainData(heap[$1]);}, `nodeIdx`, `arrayIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].getFloatTimeDomainData(heap[`array`.idx]);".}
  else:
    discard
proc jsAnalyserGetByteTimeDomainData*(node: JsAnalyserNode, array: JsValue) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var arrayIdx = cast[JsValue](array).idx
    {.emit: "EM_ASM({heap[$0].getByteTimeDomainData(heap[$1]);}, `nodeIdx`, `arrayIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].getByteTimeDomainData(heap[`array`.idx]);".}
  else:
    discard
proc jsAnalyserMinDecibels*(node: JsAnalyserNode): float64 =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].minDecibels; });", `nodeIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].minDecibels;".}
  else:
    result = 0.0
proc `jsAnalyserMinDecibels=`*(node: JsAnalyserNode, val: float64) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var valVal = val
    {.emit: "EM_ASM({ heap[$0].minDecibels = $1; }, `nodeIdx`, `valVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].minDecibels = `val`;".}
  else:
    discard
proc jsAnalyserMaxDecibels*(node: JsAnalyserNode): float64 =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].maxDecibels; });", `nodeIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].maxDecibels;".}
  else:
    result = 0.0
proc `jsAnalyserMaxDecibels=`*(node: JsAnalyserNode, val: float64) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var valVal = val
    {.emit: "EM_ASM({ heap[$0].maxDecibels = $1; }, `nodeIdx`, `valVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].maxDecibels = `val`;".}
  else:
    discard
proc jsAnalyserSmoothingTimeConstant*(node: JsAnalyserNode): float64 =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].smoothingTimeConstant; });", `nodeIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].smoothingTimeConstant;".}
  else:
    result = 0.0
proc `jsAnalyserSmoothingTimeConstant=`*(node: JsAnalyserNode, val: float64) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var valVal = val
    {.emit: "EM_ASM({ heap[$0].smoothingTimeConstant = $1; }, `nodeIdx`, `valVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].smoothingTimeConstant = `val`;".}
  else:
    discard
# ─── DelayNode ───

proc jsDelayNodeDelay*(node: JsDelayNode): JsAudioParam =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].delayTime); });", `nodeIdx`.}
    result = JsAudioParam(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].delayTime)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))
# ─── AudioBuffer ───

proc jsAudioBufferDuration*(buf: JsAudioBuffer): float64 =
  when defined(emscripten):
    var bufIdx = cast[JsValue](buf).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].duration; });", `bufIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].duration;".}
  else:
    result = 0.0
proc jsAudioBufferLength*(buf: JsAudioBuffer): int =
  when defined(emscripten):
    var bufIdx = cast[JsValue](buf).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].length; });", `bufIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].length;".}
  else:
    result = 0
proc jsAudioBufferSampleRate*(buf: JsAudioBuffer): float64 =
  when defined(emscripten):
    var bufIdx = cast[JsValue](buf).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].sampleRate; });", `bufIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].sampleRate;".}
  else:
    result = 0.0
proc jsAudioBufferNumberOfChannels*(buf: JsAudioBuffer): int =
  when defined(emscripten):
    var bufIdx = cast[JsValue](buf).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].numberOfChannels; });", `bufIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].numberOfChannels;".}
  else:
    result = 0
proc jsAudioBufferGetChannelData*(buf: JsAudioBuffer, channel: int): JsValue =
  when defined(emscripten):
    var bufIdx = cast[JsValue](buf).idx
    var channelVal = channel
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getChannelData($1)); }, `bufIdx`, `channelVal`);".}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`buf`.idx].getChannelData(`channel`))};".}
  else:
    result = JsValue(idx: 0)
# ─── AudioBufferSourceNode ───

proc `jsAudioBufferSourceBuffer=`*(node: JsAudioBufferSourceNode, buf: JsAudioBuffer) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var bufIdx = cast[JsValue](buf).idx
    {.emit: "EM_ASM({ heap[$0].buffer = heap[$1]; }, `nodeIdx`, `bufIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].buffer = heap[`buf`.idx];".}
  else:
    discard
proc jsAudioBufferSourceLoop*(node: JsAudioBufferSourceNode): bool =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].loop ? 1 : 0; });", `nodeIdx`.}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].loop ? 1 : 0;".}
  else:
    result = false
proc `jsAudioBufferSourceLoop=`*(node: JsAudioBufferSourceNode, val: bool) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var valVal = val
    {.emit: "EM_ASM({ heap[$0].loop = $1; }, `nodeIdx`, `valVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].loop = `val`;".}
  else:
    discard
proc jsAudioBufferSourceStart*(node: JsAudioBufferSourceNode, startTime: float64 = 0.0, offset: float64 = 0.0, duration: float64 = 0.0) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var durationVal = duration
    var offsetVal = offset
    var startTimeVal = startTime
    {.emit: "EM_ASM({ if ($1 > 0) { heap[$0].start($1, $2, $3); } else { heap[$0].start($1, $2, $3); } }, `nodeIdx`, `durationVal`, `offsetVal`, `startTimeVal`);".}
  elif defined(wasm32):
    {.emit: """
    if (`duration` > 0) {
      heap[`node`.idx].start(`startTime`, `offset`, `duration`);
    } else {
      heap[`node`.idx].start(`startTime`, `offset`);
    }
    """.}
  else:
    discard
proc jsAudioBufferSourceStop*(node: JsAudioBufferSourceNode, stopTime: float64 = 0.0) =
  when defined(emscripten):
    var nodeIdx = cast[JsValue](node).idx
    var stopTimeVal = stopTime
    {.emit: "EM_ASM({heap[$0].stop($1);}, `nodeIdx`, `stopTimeVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`node`.idx].stop(`stopTime`);".}
  else:
    discard
# ─── AudioListener ───

proc jsAudioListenerSetPosition*(listener: JsAudioListener, x, y, z: float64) =
  when defined(emscripten):
    var listenerIdx = cast[JsValue](listener).idx
    var xVal = x
    var yVal = y
    var zVal = z
    {.emit: "EM_ASM({heap[$0].setPosition($1, $2, $3);}, `listenerIdx`, `xVal`, `yVal`, `zVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`listener`.idx].setPosition(`x`, `y`, `z`);".}
  else:
    discard
proc jsAudioListenerSetOrientation*(listener: JsAudioListener, fx, fy, fz, ux, uy, uz: float64) =
  when defined(emscripten):
    var listenerIdx = cast[JsValue](listener).idx
    var fxVal = fx
    var fyVal = fy
    var fzVal = fz
    var uxVal = ux
    var uyVal = uy
    var uzVal = uz
    {.emit: "EM_ASM({heap[$0].setOrientation($1, $2, $3, $4, $5, $6);}, `listenerIdx`, `fxVal`, `fyVal`, `fzVal`, `uxVal`, `uyVal`, `uzVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`listener`.idx].setOrientation(`fx`, `fy`, `fz`, `ux`, `uy`, `uz`);".}
  else:
    discard
# ─── Web Crypto API ───

type
  JsCrypto* = distinct JsValue
  JsSubtleCrypto* = distinct JsValue
  JsCryptoKey* = distinct JsValue
  JsCryptoKeyPair* = distinct JsValue

proc jsGetCrypto*(): JsCrypto =
  when defined(emscripten):
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(crypto); });".}
    result = JsCrypto(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(crypto)};".}
  else:
    result = JsCrypto(JsValue(idx: 0))
proc jsCryptoSubtle*(c: JsCrypto): JsSubtleCrypto =
  when defined(emscripten):
    var cIdx = cast[JsValue](c).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].subtle); });", `cIdx`.}
    result = JsSubtleCrypto(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`c`.idx].subtle)};".}
  else:
    result = JsSubtleCrypto(JsValue(idx: 0))
proc jsCryptoGetRandomValues*(c: JsCrypto, buffer: JsValue): JsValue =
  when defined(emscripten):
    var cIdx = cast[JsValue](c).idx
    var bufferIdx = cast[JsValue](buffer).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getRandomValues(heap[$1])); });", `cIdx`, `bufferIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`c`.idx].getRandomValues(heap[`buffer`.idx]))};".}
  else:
    result = JsValue(idx: 0)
proc jsCryptoRandomUUID*(c: JsCrypto): string =
  when defined(emscripten):
    var cIdx = cast[JsValue](c).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return (heap[$0].randomUUID || '').length; }, `cIdx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].randomUUID || ''; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `cIdx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`c`.idx].randomUUID();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsCryptoSecureRandomUUID*(): string =
  when defined(emscripten):
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return crypto.randomUUID().length; });".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = crypto.randomUUID(); var p = $0; for (var i = 0; i < $1; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = crypto.randomUUID();
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsSubtleCryptoEncrypt*(subtle: JsSubtleCrypto, algorithm: JsValue, key: JsCryptoKey, data: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var keyIdx = cast[JsValue](key).idx
    var dataIdx = cast[JsValue](data).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].encrypt(heap[$1], heap[$2], heap[$3])); }, `subtleIdx`, `algorithmIdx`, `keyIdx`, `dataIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].encrypt(heap[`algorithm`.idx], heap[`key`.idx], heap[`data`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoDecrypt*(subtle: JsSubtleCrypto, algorithm: JsValue, key: JsCryptoKey, data: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var keyIdx = cast[JsValue](key).idx
    var dataIdx = cast[JsValue](data).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].decrypt(heap[$1], heap[$2], heap[$3])); }, `subtleIdx`, `algorithmIdx`, `keyIdx`, `dataIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].decrypt(heap[`algorithm`.idx], heap[`key`.idx], heap[`data`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoSign*(subtle: JsSubtleCrypto, algorithm: JsValue, key: JsCryptoKey, data: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var keyIdx = cast[JsValue](key).idx
    var dataIdx = cast[JsValue](data).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].sign(heap[$1], heap[$2], heap[$3])); }, `subtleIdx`, `algorithmIdx`, `keyIdx`, `dataIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].sign(heap[`algorithm`.idx], heap[`key`.idx], heap[`data`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoVerify*(subtle: JsSubtleCrypto, algorithm: JsValue, key: JsCryptoKey, signature: JsValue, data: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var keyIdx = cast[JsValue](key).idx
    var signatureIdx = cast[JsValue](signature).idx
    var dataIdx = cast[JsValue](data).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].verify(heap[$1], heap[$2], heap[$3], heap[$4])); }, `subtleIdx`, `algorithmIdx`, `keyIdx`, `signatureIdx`, `dataIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].verify(heap[`algorithm`.idx], heap[`key`.idx], heap[`signature`.idx], heap[`data`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoDigest*(subtle: JsSubtleCrypto, algorithm: JsValue, data: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var dataIdx = cast[JsValue](data).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].digest(heap[$1], heap[$2])); }, `subtleIdx`, `algorithmIdx`, `dataIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].digest(heap[`algorithm`.idx], heap[`data`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoGenerateKey*(subtle: JsSubtleCrypto, algorithm: JsValue, extractable: bool, keyUsages: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var extractableVal = extractable
    var keyUsagesIdx = cast[JsValue](keyUsages).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].generateKey(heap[$1], $2, heap[$3])); }, `subtleIdx`, `algorithmIdx`, `extractableVal`, `keyUsagesIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].generateKey(heap[`algorithm`.idx], `extractable`, heap[`keyUsages`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoDeriveKey*(subtle: JsSubtleCrypto, algorithm: JsValue, baseKey: JsCryptoKey, derivedKeyAlgorithm: JsValue, extractable: bool, keyUsages: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var baseKeyIdx = cast[JsValue](baseKey).idx
    var derivedKeyAlgorithmIdx = cast[JsValue](derivedKeyAlgorithm).idx
    var extractableVal = extractable
    var keyUsagesIdx = cast[JsValue](keyUsages).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].deriveKey(heap[$1], heap[$2], heap[$3], $4, heap[$5])); }, `subtleIdx`, `algorithmIdx`, `baseKeyIdx`, `derivedKeyAlgorithmIdx`, `extractableVal`, `keyUsagesIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].deriveKey(heap[`algorithm`.idx], heap[`baseKey`.idx], heap[`derivedKeyAlgorithm`.idx], `extractable`, heap[`keyUsages`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoDeriveBits*(subtle: JsSubtleCrypto, algorithm: JsValue, baseKey: JsCryptoKey, length: int): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var baseKeyIdx = cast[JsValue](baseKey).idx
    var lengthVal = length
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].deriveBits(heap[$1], heap[$2], $3)); }, `subtleIdx`, `algorithmIdx`, `baseKeyIdx`, `lengthVal`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].deriveBits(heap[`algorithm`.idx], heap[`baseKey`.idx], `length`))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoImportKey*(subtle: JsSubtleCrypto, format: string, keyData: JsValue, algorithm: JsValue, extractable: bool, keyUsages: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var formatVal = format
    var keyDataIdx = cast[JsValue](keyData).idx
    var algorithmIdx = cast[JsValue](algorithm).idx
    var extractableVal = extractable
    var keyUsagesIdx = cast[JsValue](keyUsages).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].importKey($1, heap[$2], heap[$3], $4, heap[$5])); }, `subtleIdx`, `formatVal`, `keyDataIdx`, `algorithmIdx`, `extractableVal`, `keyUsagesIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].importKey(`format`, heap[`keyData`.idx], heap[`algorithm`.idx], `extractable`, heap[`keyUsages`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoExportKey*(subtle: JsSubtleCrypto, format: string, key: JsCryptoKey): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var formatVal = format
    var keyIdx = cast[JsValue](key).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].exportKey($1, heap[$2])); }, `subtleIdx`, `formatVal`, `keyIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].exportKey(`format`, heap[`key`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoWrapKey*(subtle: JsSubtleCrypto, format: string, key: JsCryptoKey, wrappingKey: JsCryptoKey, wrapAlgorithm: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var formatVal = format
    var keyIdx = cast[JsValue](key).idx
    var wrappingKeyIdx = cast[JsValue](wrappingKey).idx
    var wrapAlgorithmIdx = cast[JsValue](wrapAlgorithm).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].wrapKey($1, heap[$2], heap[$3], heap[$4])); }, `subtleIdx`, `formatVal`, `keyIdx`, `wrappingKeyIdx`, `wrapAlgorithmIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].wrapKey(`format`, heap[`key`.idx], heap[`wrappingKey`.idx], heap[`wrapAlgorithm`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsSubtleCryptoUnwrapKey*(subtle: JsSubtleCrypto, format: string, wrappedKey: JsValue, wrappingKey: JsCryptoKey, unwrapAlgorithm: JsValue, keyAlgorithm: JsValue, extractable: bool, keyUsages: JsValue): JsPromise =
  when defined(emscripten):
    var subtleIdx = cast[JsValue](subtle).idx
    var formatVal = format
    var wrappedKeyIdx = cast[JsValue](wrappedKey).idx
    var wrappingKeyIdx = cast[JsValue](wrappingKey).idx
    var unwrapAlgorithmIdx = cast[JsValue](unwrapAlgorithm).idx
    var keyAlgorithmIdx = cast[JsValue](keyAlgorithm).idx
    var extractableVal = extractable
    var keyUsagesIdx = cast[JsValue](keyUsages).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].unwrapKey($1, heap[$2], heap[$3], heap[$4], heap[$5], $6, heap[$7])); }, `subtleIdx`, `formatVal`, `wrappedKeyIdx`, `wrappingKeyIdx`, `unwrapAlgorithmIdx`, `keyAlgorithmIdx`, `extractableVal`, `keyUsagesIdx`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`subtle`.idx].unwrapKey(`format`, heap[`wrappedKey`.idx], heap[`wrappingKey`.idx], heap[`unwrapAlgorithm`.idx], heap[`keyAlgorithm`.idx], `extractable`, heap[`keyUsages`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsCryptoKeyType*(key: JsCryptoKey): string =
  when defined(emscripten):
    var keyIdx = cast[JsValue](key).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].type.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].type; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`key`.idx].type;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsCryptoKeyExtractable*(key: JsCryptoKey): bool =
  when defined(emscripten):
    var keyIdx = cast[JsValue](key).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].extractable ? 1 : 0; });", `keyIdx`.}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`key`.idx].extractable ? 1 : 0;".}
  else:
    result = false
proc jsCryptoKeyUsages*(key: JsCryptoKey): JsValue =
  when defined(emscripten):
    var keyIdx = cast[JsValue](key).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].usages); });", `keyIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`key`.idx].usages)};".}
  else:
    result = JsValue(idx: 0)
proc jsCryptoKeyAlgorithm*(key: JsCryptoKey): JsValue =
  when defined(emscripten):
    var keyIdx = cast[JsValue](key).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].algorithm); });", `keyIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`key`.idx].algorithm)};".}
  else:
    result = JsValue(idx: 0)
proc jsCryptoKeyPairPrivateKey*(pair: JsCryptoKeyPair): JsCryptoKey =
  when defined(emscripten):
    var pairIdx = cast[JsValue](pair).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].privateKey); });", `pairIdx`.}
    result = JsCryptoKey(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pair`.idx].privateKey)};".}
  else:
    result = JsCryptoKey(JsValue(idx: 0))
proc jsCryptoKeyPairPublicKey*(pair: JsCryptoKeyPair): JsCryptoKey =
  when defined(emscripten):
    var pairIdx = cast[JsValue](pair).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].publicKey); });", `pairIdx`.}
    result = JsCryptoKey(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pair`.idx].publicKey)};".}
  else:
    result = JsCryptoKey(JsValue(idx: 0))
proc jsNewJsArrayBuffer*(size: int): JsValue =
  when defined(emscripten):
    var idx: uint32
    var sizeVal = size
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new ArrayBuffer($0)); }, `sizeVal`);".}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new ArrayBuffer(`size`))};".}
  else:
    result = JsValue(idx: 0)
proc jsNewJsUint8Array*(size: int): JsValue =
  when defined(emscripten):
    var idx: uint32
    var sizeVal = size
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new Uint8Array($0)); }, `sizeVal`);".}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Uint8Array(`size`))};".}
  else:
    result = JsValue(idx: 0)
proc jsNewJsUint8ArrayFromBuffer*(buffer: JsValue): JsValue =
  when defined(emscripten):
    var idx: uint32
    var bufferIdx = cast[JsValue](buffer).idx
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new Uint8Array(heap[$0])); }, `bufferIdx`);".}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Uint8Array(heap[`buffer`.idx]))};".}
  else:
    result = JsValue(idx: 0)
proc jsUint8ArrayLen*(arr: JsValue): int =
  when defined(emscripten):
    var arrIdx = cast[JsValue](arr).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].length; });", `arrIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`arr`.idx].length;".}
  else:
    result = 0
proc jsUint8ArraySet*(dest: JsValue, src: JsValue) =
  when defined(emscripten):
    var destIdx = cast[JsValue](dest).idx
    var srcIdx = cast[JsValue](src).idx
    {.emit: "EM_ASM({heap[$0].set(heap[$1]);}, `destIdx`, `srcIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`dest`.idx].set(heap[`src`.idx]);".}
  else:
    discard
proc jsUint8ArraySetFromArray*(dest: JsValue, arr: JsValue) =
  when defined(emscripten):
    var destIdx = cast[JsValue](dest).idx
    var arrIdx = cast[JsValue](arr).idx
    {.emit: "EM_ASM({heap[$0].set(heap[$1]);}, `destIdx`, `arrIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`dest`.idx].set(heap[`arr`.idx]);".}
  else:
    discard
proc jsUint8ArraySubarray*(arr: JsValue, start: int, finish: int): JsValue =
  when defined(emscripten):
    var arrIdx = cast[JsValue](arr).idx
    var startVal = start
    var finishVal = finish
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].subarray($1, $2)); }, `arrIdx`, `startVal`, `finishVal`);".}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`arr`.idx].subarray(`start`, `finish`))};".}
  else:
    result = JsValue(idx: 0)
proc jsArrayBufferByteLength*(buf: JsValue): int =
  when defined(emscripten):
    var bufIdx = cast[JsValue](buf).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].byteLength; });", `bufIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].byteLength;".}
  else:
    result = 0
proc jsJsValueToUint8Array*(val: JsValue): JsValue =
  when defined(emscripten):
    var idx: uint32
    var valIdx = cast[JsValue](val).idx
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new Uint8Array(heap[$0])); }, `valIdx`);".}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Uint8Array(heap[`val`.idx]))};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmAesCbc*(iv: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"AES-CBC\", iv: heap[`iv`.idx])};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmAesGcm*(iv: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"AES-GCM\", iv: heap[`iv`.idx])};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmHmacSha256*(key: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"HMAC\", hash: {name: \"SHA-256\"}, key: heap[`key`.idx])};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmHmacSha384*(key: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"HMAC\", hash: {name: \"SHA-384\"}, key: heap[`key`.idx])};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmHmacSha512*(key: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"HMAC\", hash: {name: \"SHA-512\"}, key: heap[`key`.idx])};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmSha256*(): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"SHA-256\"})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmSha384*(): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"SHA-384\"})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmSha512*(): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"SHA-512\"})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmEcdsa*(namedCurve: string): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"ECDSA\", namedCurve: `namedCurve`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmEcdh*(namedCurve: string): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"ECDH\", namedCurve: `namedCurve`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmRsaOaep*(modulusLength: int, publicExponent: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"RSA-OAEP\", modulusLength: `modulusLength`, publicExponent: heap[`publicExponent`.idx])};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmRsaPss*(saltLength: int): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"RSA-PSS\", saltLength: `saltLength`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmPbkdf2*(salt: JsValue, iterations: int, hash: string): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"PBKDF2\", salt: heap[`salt`.idx], iterations: `iterations`, hash: `hash`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmHkdf*(salt: JsValue, hash: string, info: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"HKDF\", salt: heap[`salt`.idx], hash: `hash`, info: heap[`info`.idx]})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmAesGcmWithIv*(iv: JsValue, tagLength: int): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"AES-GCM\", iv: heap[`iv`.idx], tagLength: `tagLength`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateAlgorithmAesCtr*(counter: JsValue, length: int): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({name: \"AES-CTR\", counter: heap[`counter`.idx], length: `length`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateKeyUsage*(usages: varargs[string]): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(@[`usages`]);".}
  else:
    result = JsValue(idx: 0)
proc jsCreateEmptyKeyUsage*(): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject([])};".}
  else:
    result = JsValue(idx: 0)
# ─── IndexedDB API ───

type
  JsIDBFactory* = distinct JsValue
  JsIDBDatabase* = distinct JsValue
  JsIDBObjectStore* = distinct JsValue
  JsIDBTransaction* = distinct JsValue
  JsIDBIndex* = distinct JsValue
  JsIDBCursor* = distinct JsValue
  JsIDBRequest* = distinct JsValue
  JsIDBCursorWithValue* = distinct JsValue
  JsIDBOpenDBRequest* = distinct JsValue

proc jsGetIDBFactory*(): JsIDBFactory =
  when defined(emscripten):
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(indexedDB); });".}
    result = JsIDBFactory(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(indexedDB)};".}
  else:
    result = JsIDBFactory(JsValue(idx: 0))
proc jsIDBFactoryOpen*(factory: JsIDBFactory, name: string, version: int): JsIDBOpenDBRequest =
  when defined(emscripten):
    var factoryIdx = cast[JsValue](factory).idx
    var nameVal = name
    var versionVal = version
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].open($1, $2)); }, `factoryIdx`, `nameVal`, `versionVal`);".}
    result = JsIDBOpenDBRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`factory`.idx].open(`name`, `version`))};".}
  else:
    result = JsIDBOpenDBRequest(JsValue(idx: 0))
proc jsIDBFactoryDeleteDatabase*(factory: JsIDBFactory, name: string): JsIDBRequest =
  when defined(emscripten):
    var factoryIdx = cast[JsValue](factory).idx
    var namePtr = name.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].deleteDatabase(UTF8ToString($1))); }, `factoryIdx`, `namePtr`);".}
    result = JsIDBRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`factory`.idx].deleteDatabase(`name`))};".}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBFactoryClose*(factory: JsIDBFactory) =
  when defined(emscripten):
    var factoryIdx = cast[JsValue](factory).idx
    {.emit: "EM_ASM({ heap[$0].close(); }, `factoryIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`factory`.idx].close();".}
  else:
    discard
proc jsIDBDatabaseClose*(db: JsIDBDatabase) =
  when defined(emscripten):
    var dbIdx = cast[JsValue](db).idx
    {.emit: "EM_ASM({ heap[$0].close(); }, `dbIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`db`.idx].close();".}
  else:
    discard
proc jsIDBDatabaseName*(db: JsIDBDatabase): string =
  when defined(emscripten):
    var dbIdx = cast[JsValue](db).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].name.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].name; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`db`.idx].name;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsIDBDatabaseVersion*(db: JsIDBDatabase): int =
  when defined(emscripten):
    var dbIdx = cast[JsValue](db).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].version; });", `dbIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`db`.idx].version;".}
  else:
    result = 0
proc jsIDBDatabaseObjectStoreNames*(db: JsIDBDatabase): JsValue =
  when defined(emscripten):
    var dbIdx = cast[JsValue](db).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].objectStoreNames); });", `dbIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`db`.idx].objectStoreNames)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBDatabaseCreateObjectStore*(db: JsIDBDatabase, name: string, options: JsValue = JsValue(idx: 0)): JsIDBObjectStore =
  when defined(emscripten):
    result = JsIDBObjectStore(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(heap[`db`.idx].createObjectStore(`name`))};
    } else {
      `result` = {idx: addHeapObject(heap[`db`.idx].createObjectStore(`name`, heap[o]))};
    }
    """.}
  else:
    result = JsIDBObjectStore(JsValue(idx: 0))
proc jsIDBDatabaseDeleteObjectStore*(db: JsIDBDatabase, name: string) =
  when defined(emscripten):
    var dbIdx = cast[JsValue](db).idx
    var namePtr = name.cstring
    {.emit: "EM_ASM({heap[$0].deleteObjectStore(UTF8ToString($1));}, `dbIdx`, `namePtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`db`.idx].deleteObjectStore(`name`);".}
  else:
    discard
proc jsIDBDatabaseTransaction*(db: JsIDBDatabase, storeNames: JsValue, mode: string = "readonly"): JsIDBTransaction =
  when defined(emscripten):
    var dbIdx = cast[JsValue](db).idx
    var storeNamesIdx = cast[JsValue](storeNames).idx
    var modePtr = mode.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].transaction(heap[$1], UTF8ToString($2))); }, `dbIdx`, `storeNamesIdx`, `modePtr`);".}
    result = JsIDBTransaction(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`db`.idx].transaction(heap[`storeNames`.idx], `mode`))};".}
  else:
    result = JsIDBTransaction(JsValue(idx: 0))
proc jsIDBObjectStoreName*(store: JsIDBObjectStore): string =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].name.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].name; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`store`.idx].name;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsIDBObjectStoreKeyPath*(store: JsIDBObjectStore): JsValue =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].keyPath); });", `storeIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`store`.idx].keyPath)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBObjectStoreIndexNames*(store: JsIDBObjectStore): JsValue =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].indexNames); });", `storeIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`store`.idx].indexNames)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBObjectStoreAutoIncrement*(store: JsIDBObjectStore): bool =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].autoIncrement ? 1 : 0; });", `storeIdx`.}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`store`.idx].autoIncrement ? 1 : 0;".}
  else:
    result = false
proc jsIDBObjectStoreAdd*(store: JsIDBObjectStore, value: JsValue, key: JsValue = JsValue(idx: 0)): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var k = `key`;
    if (k == 0) {
      `result` = {idx: addHeapObject(heap[`store`.idx].add(heap[`value`.idx]))};
    } else {
      `result` = {idx: addHeapObject(heap[`store`.idx].add(heap[`value`.idx], heap[k]))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBObjectStorePut*(store: JsIDBObjectStore, value: JsValue, key: JsValue = JsValue(idx: 0)): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var k = `key`;
    if (k == 0) {
      `result` = {idx: addHeapObject(heap[`store`.idx].put(heap[`value`.idx]))};
    } else {
      `result` = {idx: addHeapObject(heap[`store`.idx].put(heap[`value`.idx], heap[k]))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBObjectStoreGet*(store: JsIDBObjectStore, key: JsValue): JsIDBRequest =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var keyIdx = cast[JsValue](key).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].get(heap[$1])); });", `storeIdx`, `keyIdx`.}
    result = JsIDBRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`store`.idx].get(heap[`key`.idx]))};".}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBObjectStoreGetAll*(store: JsIDBObjectStore, query: JsValue = JsValue(idx: 0)): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var q = `query`;
    if (q == 0) {
      `result` = {idx: addHeapObject(heap[`store`.idx].getAll())};
    } else {
      `result` = {idx: addHeapObject(heap[`store`.idx].getAll(heap[q]))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBObjectStoreGetAllKeys*(store: JsIDBObjectStore, query: JsValue = JsValue(idx: 0)): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var q = `query`;
    if (q == 0) {
      `result` = {idx: addHeapObject(heap[`store`.idx].getAllKeys())};
    } else {
      `result` = {idx: addHeapObject(heap[`store`.idx].getAllKeys(heap[q]))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBObjectStoreDelete*(store: JsIDBObjectStore, key: JsValue): JsIDBRequest =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var keyIdx = cast[JsValue](key).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].delete(heap[$1])); });", `storeIdx`, `keyIdx`.}
    result = JsIDBRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`store`.idx].delete(heap[`key`.idx]))};".}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBObjectStoreClear*(store: JsIDBObjectStore): JsIDBRequest =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].clear()); });", `storeIdx`.}
    result = JsIDBRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`store`.idx].clear())};".}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBObjectStoreCount*(store: JsIDBObjectStore, key: JsValue = JsValue(idx: 0)): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var k = `key`;
    if (k == 0) {
      `result` = {idx: addHeapObject(heap[`store`.idx].count())};
    } else {
      `result` = {idx: addHeapObject(heap[`store`.idx].count(heap[k]))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBObjectStoreCreateIndex*(store: JsIDBObjectStore, name: string, keyPath: JsValue, options: JsValue = JsValue(idx: 0)): JsIDBIndex =
  when defined(emscripten):
    result = JsIDBIndex(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(heap[`store`.idx].createIndex(`name`, heap[`keyPath`.idx]))};
    } else {
      `result` = {idx: addHeapObject(heap[`store`.idx].createIndex(`name`, heap[`keyPath`.idx], heap[o]))};
    }
    """.}
  else:
    result = JsIDBIndex(JsValue(idx: 0))
proc jsIDBObjectStoreDeleteIndex*(store: JsIDBObjectStore, name: string) =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var namePtr = name.cstring
    {.emit: "EM_ASM({heap[$0].deleteIndex(UTF8ToString($1));}, `storeIdx`, `namePtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`store`.idx].deleteIndex(`name`);".}
  else:
    discard
proc jsIDBObjectStoreIndex*(store: JsIDBObjectStore, name: string): JsIDBIndex =
  when defined(emscripten):
    var storeIdx = cast[JsValue](store).idx
    var namePtr = name.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].index(UTF8ToString($1))); }, `storeIdx`, `namePtr`);".}
    result = JsIDBIndex(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`store`.idx].index(`name`))};".}
  else:
    result = JsIDBIndex(JsValue(idx: 0))
proc jsIDBObjectStoreOpenCursor*(store: JsIDBObjectStore, query: JsValue = JsValue(idx: 0), direction: string = "next"): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var q = `query`;
    if (q == 0) {
      `result` = {idx: addHeapObject(heap[`store`.idx].openCursor())};
    } else {
      `result` = {idx: addHeapObject(heap[`store`.idx].openCursor(heap[q], `direction`))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBTransactionMode*(tx: JsIDBTransaction): string =
  when defined(emscripten):
    var txIdx = cast[JsValue](tx).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].mode.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].mode; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`tx`.idx].mode;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsIDBTransactionDb*(tx: JsIDBTransaction): JsIDBDatabase =
  when defined(emscripten):
    var txIdx = cast[JsValue](tx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].db); });", `txIdx`.}
    result = JsIDBDatabase(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`tx`.idx].db)};".}
  else:
    result = JsIDBDatabase(JsValue(idx: 0))
proc jsIDBTransactionObjectStoreNames*(tx: JsIDBTransaction): JsValue =
  when defined(emscripten):
    var txIdx = cast[JsValue](tx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].objectStoreNames); });", `txIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`tx`.idx].objectStoreNames)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBTransactionAbort*(tx: JsIDBTransaction) =
  when defined(emscripten):
    var txIdx = cast[JsValue](tx).idx
    {.emit: "EM_ASM({ heap[$0].abort(); }, `txIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`tx`.idx].abort();".}
  else:
    discard
proc jsIDBTransactionCommit*(tx: JsIDBTransaction) =
  when defined(emscripten):
    var txIdx = cast[JsValue](tx).idx
    {.emit: "EM_ASM({ heap[$0].commit(); }, `txIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`tx`.idx].commit();".}
  else:
    discard
proc jsIDBIndexName*(idx: JsIDBIndex): string =
  when defined(emscripten):
    var idxIdx = cast[JsValue](idx).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].name.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].name; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`idx`.idx].name;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsIDBIndexKeyPath*(idx: JsIDBIndex): JsValue =
  when defined(emscripten):
    var idxIdx = cast[JsValue](idx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].keyPath); });", `idxIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`idx`.idx].keyPath)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBIndexMultiEntry*(idx: JsIDBIndex): bool =
  when defined(emscripten):
    var idxIdx = cast[JsValue](idx).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].multiEntry ? 1 : 0; });", `idxIdx`.}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`idx`.idx].multiEntry ? 1 : 0;".}
  else:
    result = false
proc jsIDBIndexUnique*(idx: JsIDBIndex): bool =
  when defined(emscripten):
    var idxIdx = cast[JsValue](idx).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].unique ? 1 : 0; });", `idxIdx`.}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`idx`.idx].unique ? 1 : 0;".}
  else:
    result = false
proc jsIDBIndexGet*(idx: JsIDBIndex, key: JsValue): JsIDBRequest =
  when defined(emscripten):
    var idxIdx = cast[JsValue](idx).idx
    var keyIdx = cast[JsValue](key).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].get(heap[$1])); });", `idxIdx`, `keyIdx`.}
    result = JsIDBRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`idx`.idx].get(heap[`key`.idx]))};".}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBIndexGetAll*(idx: JsIDBIndex, key: JsValue = JsValue(idx: 0)): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var k = `key`;
    if (k == 0) {
      `result` = {idx: addHeapObject(heap[`idx`.idx].getAll())};
    } else {
      `result` = {idx: addHeapObject(heap[`idx`.idx].getAll(heap[k]))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBIndexGetAllKeys*(idx: JsIDBIndex, key: JsValue = JsValue(idx: 0)): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var k = `key`;
    if (k == 0) {
      `result` = {idx: addHeapObject(heap[`idx`.idx].getAllKeys())};
    } else {
      `result` = {idx: addHeapObject(heap[`idx`.idx].getAllKeys(heap[k]))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBIndexOpenCursor*(idx: JsIDBIndex, key: JsValue = JsValue(idx: 0), direction: string = "next"): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var k = `key`;
    if (k == 0) {
      `result` = {idx: addHeapObject(heap[`idx`.idx].openCursor())};
    } else {
      `result` = {idx: addHeapObject(heap[`idx`.idx].openCursor(heap[k], `direction`))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBIndexCount*(idx: JsIDBIndex, key: JsValue = JsValue(idx: 0)): JsIDBRequest =
  when defined(emscripten):
    result = JsIDBRequest(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var k = `key`;
    if (k == 0) {
      `result` = {idx: addHeapObject(heap[`idx`.idx].count())};
    } else {
      `result` = {idx: addHeapObject(heap[`idx`.idx].count(heap[k]))};
    }
    """.}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBCursorSource*(cursor: JsIDBCursor): JsValue =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].source); });", `cursorIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`cursor`.idx].source)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBCursorDirection*(cursor: JsIDBCursor): string =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].direction.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].direction; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`cursor`.idx].direction;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsIDBCursorKey*(cursor: JsIDBCursor): JsValue =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].key); });", `cursorIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`cursor`.idx].key)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBCursorPrimaryKey*(cursor: JsIDBCursor): JsValue =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].primaryKey); });", `cursorIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`cursor`.idx].primaryKey)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBCursorValue*(cursor: JsIDBCursor): JsValue =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].value); });", `cursorIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`cursor`.idx].value)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBCursorContinue*(cursor: JsIDBCursor, key: JsValue = JsValue(idx: 0)) =
  when defined(emscripten):
    discard
  elif defined(wasm32):
    {.emit: """
    var k = `key`;
    if (k == 0) {
      heap[`cursor`.idx].continue();
    } else {
      heap[`cursor`.idx].continue(heap[k]);
    }
    """.}
  else:
    discard
proc jsIDBCursorContinuePrimaryKey*(cursor: JsIDBCursor, key: JsValue, primaryKey: JsValue) =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var keyIdx = cast[JsValue](key).idx
    var primaryKeyIdx = cast[JsValue](primaryKey).idx
    {.emit: "EM_ASM({heap[$0].continuePrimaryKey(heap[$1], heap[$2]);}, `cursorIdx`, `keyIdx`, `primaryKeyIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`cursor`.idx].continuePrimaryKey(heap[`key`.idx], heap[`primaryKey`.idx]);".}
  else:
    discard
proc jsIDBCursorAdvance*(cursor: JsIDBCursor, count: int) =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var countVal = count
    {.emit: "EM_ASM({heap[$0].advance($1);}, `cursorIdx`, `countVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`cursor`.idx].advance(`count`);".}
  else:
    discard
proc jsIDBCursorDelete*(cursor: JsIDBCursor): JsIDBRequest =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].delete()); });", `cursorIdx`.}
    result = JsIDBRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`cursor`.idx].delete())};".}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBCursorUpdate*(cursor: JsIDBCursor, value: JsValue): JsIDBRequest =
  when defined(emscripten):
    var cursorIdx = cast[JsValue](cursor).idx
    var valueIdx = cast[JsValue](value).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].update(heap[$1])); });", `cursorIdx`, `valueIdx`.}
    result = JsIDBRequest(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`cursor`.idx].update(heap[`value`.idx]))};".}
  else:
    result = JsIDBRequest(JsValue(idx: 0))
proc jsIDBRequestResult*(req: JsIDBRequest): JsValue =
  when defined(emscripten):
    var reqIdx = cast[JsValue](req).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].result); });", `reqIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`req`.idx].result)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBRequestError*(req: JsIDBRequest): JsValue =
  when defined(emscripten):
    var reqIdx = cast[JsValue](req).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].error); });", `reqIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`req`.idx].error)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBRequestSource*(req: JsIDBRequest): JsValue =
  when defined(emscripten):
    var reqIdx = cast[JsValue](req).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].source); });", `reqIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`req`.idx].source)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBRequestTransaction*(req: JsIDBRequest): JsValue =
  when defined(emscripten):
    var reqIdx = cast[JsValue](req).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].transaction); });", `reqIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`req`.idx].transaction)};".}
  else:
    result = JsValue(idx: 0)
proc jsIDBRequestReadyState*(req: JsIDBRequest): string =
  when defined(emscripten):
    var reqIdx = cast[JsValue](req).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].readyState.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].readyState; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`req`.idx].readyState;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsIDBOpenDBRequestOnBlocked*(req: JsIDBOpenDBRequest, handler: JsValue) =
  when defined(emscripten):
    var reqIdx = cast[JsValue](req).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onblocked = heap[$1]; }, `reqIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`req`.idx].onblocked = heap[`handler`.idx];".}
  else:
    discard
proc jsIDBOpenDBRequestOnUpgradeNeeded*(req: JsIDBOpenDBRequest, handler: JsValue) =
  when defined(emscripten):
    var reqIdx = cast[JsValue](req).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onupgradeneeded = heap[$1]; }, `reqIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`req`.idx].onupgradeneeded = heap[`handler`.idx];".}
  else:
    discard
proc jsCreateIDBKeyRangeLowerBound*(lower: JsValue, open: bool): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(IDBKeyRange.lowerBound(heap[`lower`.idx], `open`))};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateIDBKeyRangeUpperBound*(upper: JsValue, open: bool): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(IDBKeyRange.upperBound(heap[`upper`.idx], `open`))};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateIDBKeyRangeBound*(lower: JsValue, upper: JsValue, lowerOpen: bool, upperOpen: bool): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(IDBKeyRange.bound(heap[`lower`.idx], heap[`upper`.idx], `lowerOpen`, `upperOpen`))};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateIDBKeyRangeOnly*(value: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(IDBKeyRange.only(heap[`value`.idx]))};".}
  else:
    result = JsValue(idx: 0)
# ─── Geolocation API ───

type
  JsGeolocation* = distinct JsValue
  JsGeolocationPosition* = distinct JsValue
  JsGeolocationCoordinates* = distinct JsValue
  JsGeolocationPositionError* = distinct JsValue

proc jsNavigatorGeolocation*(): JsGeolocation =
  when defined(emscripten):
    result = JsGeolocation(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(navigator.geolocation)};".}
  else:
    result = JsGeolocation(JsValue(idx: 0))
proc jsGeolocationGetCurrentPosition*(geo: JsGeolocation, successCallback: JsValue, errorCallback: JsValue = JsValue(idx: 0), options: JsValue = JsValue(idx: 0)) =
  when defined(emscripten):
    discard
  elif defined(wasm32):
    {.emit: """
    var ec = `errorCallback`;
    var opts = `options`;
    if (ec == 0 && opts == 0) {
      heap[`geo`.idx].getCurrentPosition(heap[`successCallback`.idx]);
    } else if (ec == 0) {
      heap[`geo`.idx].getCurrentPosition(heap[`successCallback`.idx], undefined, heap[opts]);
    } else if (opts == 0) {
      heap[`geo`.idx].getCurrentPosition(heap[`successCallback`.idx], heap[ec]);
    } else {
      heap[`geo`.idx].getCurrentPosition(heap[`successCallback`.idx], heap[ec], heap[opts]);
    }
    """.}
  else:
    discard
proc jsGeolocationWatchPosition*(geo: JsGeolocation, successCallback: JsValue, errorCallback: JsValue = JsValue(idx: 0), options: JsValue = JsValue(idx: 0)): int =
  when defined(emscripten):
    result = 0
  elif defined(wasm32):
    {.emit: """
    var ec = `errorCallback`;
    var opts = `options`;
    if (ec == 0 && opts == 0) {
      `result` = heap[`geo`.idx].watchPosition(heap[`successCallback`.idx]);
    } else if (ec == 0) {
      `result` = heap[`geo`.idx].watchPosition(heap[`successCallback`.idx], undefined, heap[opts]);
    } else if (opts == 0) {
      `result` = heap[`geo`.idx].watchPosition(heap[`successCallback`.idx], heap[ec]);
    } else {
      `result` = heap[`geo`.idx].watchPosition(heap[`successCallback`.idx], heap[ec], heap[opts]);
    }
    """.}
  else:
    result = 0
proc jsGeolocationClearWatch*(geo: JsGeolocation, watchId: int) =
  when defined(emscripten):
    var geoIdx = cast[JsValue](geo).idx
    var watchIdVal = watchId
    {.emit: "EM_ASM({heap[$0].clearWatch($1);}, `geoIdx`, `watchIdVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`geo`.idx].clearWatch(`watchId`);".}
  else:
    discard
proc jsGeolocationPositionCoords*(position: JsGeolocationPosition): JsGeolocationCoordinates =
  when defined(emscripten):
    var positionIdx = cast[JsValue](position).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].coords); });", `positionIdx`.}
    result = JsGeolocationCoordinates(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`position`.idx].coords)};".}
  else:
    result = JsGeolocationCoordinates(JsValue(idx: 0))
proc jsGeolocationPositionTimestamp*(position: JsGeolocationPosition): int =
  when defined(emscripten):
    var positionIdx = cast[JsValue](position).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].timestamp; });", `positionIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`position`.idx].timestamp;".}
  else:
    result = 0
proc jsGeolocationCoordinatesLatitude*(coords: JsGeolocationCoordinates): float64 =
  when defined(emscripten):
    var coordsIdx = cast[JsValue](coords).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].latitude; });", `coordsIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`coords`.idx].latitude;".}
  else:
    result = 0.0
proc jsGeolocationCoordinatesLongitude*(coords: JsGeolocationCoordinates): float64 =
  when defined(emscripten):
    var coordsIdx = cast[JsValue](coords).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].longitude; });", `coordsIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`coords`.idx].longitude;".}
  else:
    result = 0.0
proc jsGeolocationCoordinatesAltitude*(coords: JsGeolocationCoordinates): float64 =
  when defined(emscripten):
    var coordsIdx = cast[JsValue](coords).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].altitude; });", `coordsIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`coords`.idx].altitude;".}
  else:
    result = 0.0
proc jsGeolocationCoordinatesAccuracy*(coords: JsGeolocationCoordinates): float64 =
  when defined(emscripten):
    var coordsIdx = cast[JsValue](coords).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].accuracy; });", `coordsIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`coords`.idx].accuracy;".}
  else:
    result = 0.0
proc jsGeolocationCoordinatesAltitudeAccuracy*(coords: JsGeolocationCoordinates): float64 =
  when defined(emscripten):
    var coordsIdx = cast[JsValue](coords).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].altitudeAccuracy; });", `coordsIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`coords`.idx].altitudeAccuracy;".}
  else:
    result = 0.0
proc jsGeolocationCoordinatesHeading*(coords: JsGeolocationCoordinates): float64 =
  when defined(emscripten):
    var coordsIdx = cast[JsValue](coords).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].heading; });", `coordsIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`coords`.idx].heading;".}
  else:
    result = 0.0
proc jsGeolocationCoordinatesSpeed*(coords: JsGeolocationCoordinates): float64 =
  when defined(emscripten):
    var coordsIdx = cast[JsValue](coords).idx
    var val: float64
    {.emit: "`val` = EM_ASM_DOUBLE({ return heap[$0].speed; });", `coordsIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`coords`.idx].speed;".}
  else:
    result = 0.0
proc jsGeolocationPositionErrorCode*(error: JsGeolocationPositionError): int =
  when defined(emscripten):
    var errorIdx = cast[JsValue](error).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].code; });", `errorIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`error`.idx].code;".}
  else:
    result = 0
proc jsGeolocationPositionErrorMessage*(error: JsGeolocationPositionError): string =
  when defined(emscripten):
    var errorIdx = cast[JsValue](error).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].message.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].message; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`error`.idx].message;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsCreatePositionOptions*(enableHighAccuracy: bool, timeout: int, maximumAge: int): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({enableHighAccuracy: `enableHighAccuracy`, timeout: `timeout`, maximumAge: `maximumAge`})};".}
  else:
    result = JsValue(idx: 0)
# ─── Service Workers API ───

type
  JsServiceWorkerContainer* = distinct JsValue
  JsServiceWorkerRegistration* = distinct JsValue
  JsServiceWorker* = distinct JsValue
  JsServiceWorkerScope* = distinct JsValue
  JsServiceWorkerState* = distinct JsValue
  JsServiceWorkerMessageEvent* = distinct JsValue
  JsNavigationPreloadManager* = distinct JsValue

proc jsNavigatorServiceWorker*(): JsServiceWorkerContainer =
  when defined(emscripten):
    result = JsServiceWorkerContainer(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(navigator.serviceWorker)};".}
  else:
    result = JsServiceWorkerContainer(JsValue(idx: 0))
proc jsServiceWorkerContainerRegister*(container: JsServiceWorkerContainer, url: string, scope: JsValue = JsValue(idx: 0)): JsPromise =
  when defined(emscripten):
    result = JsPromise(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var s = `scope`;
    if (s == 0) {
      `result` = {idx: addHeapObject(heap[`container`.idx].register(`url`))};
    } else {
      `result` = {idx: addHeapObject(heap[`container`.idx].register(`url`, heap[s]))};
    }
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsServiceWorkerContainerReady*(container: JsServiceWorkerContainer): JsPromise =
  when defined(emscripten):
    var containerIdx = cast[JsValue](container).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].ready); });", `containerIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`container`.idx].ready)};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsServiceWorkerContainerGetRegistration*(container: JsServiceWorkerContainer, url: string): JsPromise =
  when defined(emscripten):
    var containerIdx = cast[JsValue](container).idx
    var urlPtr = url.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getRegistration(UTF8ToString($1))); }, `containerIdx`, `urlPtr`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`container`.idx].getRegistration(`url`))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsServiceWorkerContainerGetRegistrations*(container: JsServiceWorkerContainer): JsPromise =
  when defined(emscripten):
    var containerIdx = cast[JsValue](container).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getRegistrations()); });", `containerIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`container`.idx].getRegistrations())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsServiceWorkerRegistrationActive*(reg: JsServiceWorkerRegistration): JsServiceWorker =
  when defined(emscripten):
    var regIdx = cast[JsValue](reg).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].active); });", `regIdx`.}
    result = JsServiceWorker(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`reg`.idx].active)};".}
  else:
    result = JsServiceWorker(JsValue(idx: 0))
proc jsServiceWorkerRegistrationInstalling*(reg: JsServiceWorkerRegistration): JsServiceWorker =
  when defined(emscripten):
    var regIdx = cast[JsValue](reg).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].installing); });", `regIdx`.}
    result = JsServiceWorker(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`reg`.idx].installing)};".}
  else:
    result = JsServiceWorker(JsValue(idx: 0))
proc jsServiceWorkerRegistrationWaiting*(reg: JsServiceWorkerRegistration): JsServiceWorker =
  when defined(emscripten):
    var regIdx = cast[JsValue](reg).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].waiting); });", `regIdx`.}
    result = JsServiceWorker(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`reg`.idx].waiting)};".}
  else:
    result = JsServiceWorker(JsValue(idx: 0))
proc jsServiceWorkerRegistrationScope*(reg: JsServiceWorkerRegistration): string =
  when defined(emscripten):
    var regIdx = cast[JsValue](reg).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].scope.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].scope; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`reg`.idx].scope;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsServiceWorkerRegistrationUpdate*(reg: JsServiceWorkerRegistration): JsPromise =
  when defined(emscripten):
    var regIdx = cast[JsValue](reg).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].update()); });", `regIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`reg`.idx].update())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsServiceWorkerRegistrationUnregister*(reg: JsServiceWorkerRegistration): JsPromise =
  when defined(emscripten):
    var regIdx = cast[JsValue](reg).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].unregister()); });", `regIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`reg`.idx].unregister())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsServiceWorkerRegistrationNavigationPreload*(reg: JsServiceWorkerRegistration): JsNavigationPreloadManager =
  when defined(emscripten):
    var regIdx = cast[JsValue](reg).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].navigationPreload); });", `regIdx`.}
    result = JsNavigationPreloadManager(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`reg`.idx].navigationPreload)};".}
  else:
    result = JsNavigationPreloadManager(JsValue(idx: 0))
proc jsServiceWorkerState*(worker: JsServiceWorker): string =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].state.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].state; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`worker`.idx].state;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsServiceWorkerScriptURL*(worker: JsServiceWorker): string =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].scriptURL.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].scriptURL; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`worker`.idx].scriptURL;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsServiceWorkerPostMessage*(worker: JsServiceWorker, message: JsValue, transfer: JsValue = JsValue(idx: 0)) =
  when defined(emscripten):
    discard
  elif defined(wasm32):
    {.emit: """
    var t = `transfer`;
    if (t == 0) {
      heap[`worker`.idx].postMessage(heap[`message`.idx]);
    } else {
      heap[`worker`.idx].postMessage(heap[`message`.idx], heap[t]);
    }
    """.}
  else:
    discard
proc jsServiceWorkerTerminate*(worker: JsServiceWorker) =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    {.emit: "EM_ASM({ heap[$0].terminate(); }, `workerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`worker`.idx].terminate();".}
  else:
    discard
proc jsNavigationPreloadManagerEnable*(manager: JsNavigationPreloadManager): JsPromise =
  when defined(emscripten):
    var managerIdx = cast[JsValue](manager).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].enable()); });", `managerIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`manager`.idx].enable())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsNavigationPreloadManagerDisable*(manager: JsNavigationPreloadManager): JsPromise =
  when defined(emscripten):
    var managerIdx = cast[JsValue](manager).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].disable()); });", `managerIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`manager`.idx].disable())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsNavigationPreloadManagerSetHeaderValue*(manager: JsNavigationPreloadManager, value: string): JsPromise =
  when defined(emscripten):
    var managerIdx = cast[JsValue](manager).idx
    var valuePtr = value.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].setHeaderValue(UTF8ToString($1))); }, `managerIdx`, `valuePtr`);".}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`manager`.idx].setHeaderValue(`value`))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsNavigationPreloadManagerGetState*(manager: JsNavigationPreloadManager): JsPromise =
  when defined(emscripten):
    var managerIdx = cast[JsValue](manager).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getState()); });", `managerIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`manager`.idx].getState())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
# ─── Web Workers API ───

type
  JsWorker* = distinct JsValue
  JsWorkerOptions* = distinct JsValue
  JsWorkerType* = distinct JsValue
  JsDedicatedWorkerGlobalScope* = distinct JsValue
  JsSharedWorker* = distinct JsValue
  JsSharedWorkerGlobalScope* = distinct JsValue
  JsMessageEvent* = distinct JsValue
  JsMessagePort* = distinct JsValue

proc jsNewWorker*(url: string, options: JsValue = JsValue(idx: 0)): JsWorker =
  when defined(emscripten):
    result = JsWorker(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(new Worker(`url`))};
    } else {
      `result` = {idx: addHeapObject(new Worker(`url`, heap[o]))};
    }
    """.}
  else:
    result = JsWorker(JsValue(idx: 0))
proc jsWorkerPostMessage*(worker: JsWorker, message: JsValue, transfer: JsValue = JsValue(idx: 0)) =
  when defined(emscripten):
    discard
  elif defined(wasm32):
    {.emit: """
    var t = `transfer`;
    if (t == 0) {
      heap[`worker`.idx].postMessage(heap[`message`.idx]);
    } else {
      heap[`worker`.idx].postMessage(heap[`message`.idx], heap[t]);
    }
    """.}
  else:
    discard
proc jsWorkerTerminate*(worker: JsWorker) =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    {.emit: "EM_ASM({ heap[$0].terminate(); }, `workerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`worker`.idx].terminate();".}
  else:
    discard
proc jsWorkerAddEventListener*(worker: JsWorker, eventType: string, handler: JsValue) =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    var eventTypeVal = eventType
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({heap[$0].addEventListener($1, heap[$2]);}, `workerIdx`, `eventTypeVal`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`worker`.idx].addEventListener(`eventType`, heap[`handler`.idx]);".}
  else:
    discard
proc jsWorkerRemoveEventListener*(worker: JsWorker, eventType: string, handler: JsValue) =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    var eventTypeVal = eventType
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({heap[$0].removeEventListener($1, heap[$2]);}, `workerIdx`, `eventTypeVal`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`worker`.idx].removeEventListener(`eventType`, heap[`handler`.idx]);".}
  else:
    discard
proc jsWorkerDispatchEvent*(worker: JsWorker, event: JsValue): bool =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    var eventIdx = cast[JsValue](event).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].dispatchEvent(heap[$1]) ? 1 : 0; }, `workerIdx`, `eventIdx`);".}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`worker`.idx].dispatchEvent(heap[`event`.idx]) ? 1 : 0;".}
  else:
    result = false
proc jsWorkerOnMessage*(worker: JsWorker, handler: JsValue) =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onmessage = heap[$1]; }, `workerIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`worker`.idx].onmessage = heap[`handler`.idx];".}
  else:
    discard
proc jsWorkerOnMessageError*(worker: JsWorker, handler: JsValue) =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onmessageerror = heap[$1]; }, `workerIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`worker`.idx].onmessageerror = heap[`handler`.idx];".}
  else:
    discard
proc jsCreateWorkerOptions*(typ: string, credentials: string = "same-origin"): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({type: `typ`, credentials: `credentials`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateWorkerTypeClassic*(url: string): JsWorker =
  when defined(emscripten):
    var idx: uint32
    var urlPtr = url.cstring
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new Worker(UTF8ToString($0))); }, `urlPtr`);".}
    result = JsWorker(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Worker(`url`, {type: \"classic\"}))};".}
  else:
    result = JsWorker(JsValue(idx: 0))
proc jsCreateWorkerTypeModule*(url: string): JsWorker =
  when defined(emscripten):
    var idx: uint32
    var urlPtr = url.cstring
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new Worker(UTF8ToString($0))); }, `urlPtr`);".}
    result = JsWorker(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new Worker(`url`, {type: \"module\"}))};".}
  else:
    result = JsWorker(JsValue(idx: 0))
proc jsNewSharedWorker*(url: string, name: string = "", options: JsValue = JsValue(idx: 0)): JsSharedWorker =
  when defined(emscripten):
    result = JsSharedWorker(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var n = `name`;
    var o = `options`;
    if (n == "" && o == 0) {
      `result` = {idx: addHeapObject(new SharedWorker(`url`))};
    } else if (o == 0) {
      `result` = {idx: addHeapObject(new SharedWorker(`url`, n))};
    } else {
      `result` = {idx: addHeapObject(new SharedWorker(`url`, n, heap[o]))};
    }
    """.}
  else:
    result = JsSharedWorker(JsValue(idx: 0))
proc jsSharedWorkerPort*(worker: JsSharedWorker): JsMessagePort =
  when defined(emscripten):
    var workerIdx = cast[JsValue](worker).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].port); });", `workerIdx`.}
    result = JsMessagePort(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`worker`.idx].port)};".}
  else:
    result = JsMessagePort(JsValue(idx: 0))
proc jsMessagePortPostMessage*(port: JsMessagePort, message: JsValue, transfer: JsValue = JsValue(idx: 0)) =
  when defined(emscripten):
    discard
  elif defined(wasm32):
    {.emit: """
    var t = `transfer`;
    if (t == 0) {
      heap[`port`.idx].postMessage(heap[`message`.idx]);
    } else {
      heap[`port`.idx].postMessage(heap[`message`.idx], heap[t]);
    }
    """.}
  else:
    discard
proc jsMessagePortStart*(port: JsMessagePort) =
  when defined(emscripten):
    var portIdx = cast[JsValue](port).idx
    {.emit: "EM_ASM({ heap[$0].start(); }, `portIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`port`.idx].start();".}
  else:
    discard
proc jsMessagePortClose*(port: JsMessagePort) =
  when defined(emscripten):
    var portIdx = cast[JsValue](port).idx
    {.emit: "EM_ASM({ heap[$0].close(); }, `portIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`port`.idx].close();".}
  else:
    discard
proc jsMessagePortOnMessage*(port: JsMessagePort, handler: JsValue) =
  when defined(emscripten):
    var portIdx = cast[JsValue](port).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onmessage = heap[$1]; }, `portIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`port`.idx].onmessage = heap[`handler`.idx];".}
  else:
    discard
proc jsMessageEventData*(event: JsMessageEvent): JsValue =
  when defined(emscripten):
    var eventIdx = cast[JsValue](event).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].data); });", `eventIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`event`.idx].data)};".}
  else:
    result = JsValue(idx: 0)
proc jsMessageEventLastEventId*(event: JsMessageEvent): string =
  when defined(emscripten):
    var eventIdx = cast[JsValue](event).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].lastEventId.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].lastEventId; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`event`.idx].lastEventId;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsMessageEventOrigin*(event: JsMessageEvent): string =
  when defined(emscripten):
    var eventIdx = cast[JsValue](event).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].origin.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].origin; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`event`.idx].origin;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsMessageEventSource*(event: JsMessageEvent): JsValue =
  when defined(emscripten):
    var eventIdx = cast[JsValue](event).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].source); });", `eventIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`event`.idx].source)};".}
  else:
    result = JsValue(idx: 0)
proc jsMessageEventPorts*(event: JsMessageEvent): JsValue =
  when defined(emscripten):
    var eventIdx = cast[JsValue](event).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].ports); });", `eventIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`event`.idx].ports)};".}
  else:
    result = JsValue(idx: 0)
# ─── WebRTC API ───

type
  JsRTCPeerConnection* = distinct JsValue
  JsRTCSessionDescription* = distinct JsValue
  JsRTCIceCandidate* = distinct JsValue
  JsRTCIceServer* = distinct JsValue
  JsRTCConfiguration* = distinct JsValue
  JsRTCDataChannel* = distinct JsValue
  JsRTCDataChannelEvent* = distinct JsValue
  JsRTCPeerConnectionIceEvent* = distinct JsValue
  JsRTCRtpSender* = distinct JsValue
  JsRTCRtpReceiver* = distinct JsValue
  JsRTCRtpTransceiver* = distinct JsValue
  JsRTCStatsReport* = distinct JsValue
  JsRTCStats* = distinct JsValue

proc jsNewRTCPeerConnection*(config: JsValue = JsValue(idx: 0)): JsRTCPeerConnection =
  when defined(emscripten):
    result = JsRTCPeerConnection(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var c = `config`;
    if (c == 0) {
      `result` = {idx: addHeapObject(new RTCPeerConnection())};
    } else {
      `result` = {idx: addHeapObject(new RTCPeerConnection(heap[c]))};
    }
    """.}
  else:
    result = JsRTCPeerConnection(JsValue(idx: 0))
proc jsRTCPeerConnectionCreateOffer*(pc: JsRTCPeerConnection): JsPromise =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createOffer()); });", `pcIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].createOffer())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsRTCPeerConnectionCreateAnswer*(pc: JsRTCPeerConnection): JsPromise =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createAnswer()); });", `pcIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].createAnswer())};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsRTCPeerConnectionSetLocalDescription*(pc: JsRTCPeerConnection, desc: JsValue): JsPromise =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var descIdx = cast[JsValue](desc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].setLocalDescription(heap[$1])); });", `pcIdx`, `descIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].setLocalDescription(heap[`desc`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsRTCPeerConnectionSetRemoteDescription*(pc: JsRTCPeerConnection, desc: JsValue): JsPromise =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var descIdx = cast[JsValue](desc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].setRemoteDescription(heap[$1])); });", `pcIdx`, `descIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].setRemoteDescription(heap[`desc`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsRTCPeerConnectionLocalDescription*(pc: JsRTCPeerConnection): JsRTCSessionDescription =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].localDescription); });", `pcIdx`.}
    result = JsRTCSessionDescription(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].localDescription)};".}
  else:
    result = JsRTCSessionDescription(JsValue(idx: 0))
proc jsRTCPeerConnectionRemoteDescription*(pc: JsRTCPeerConnection): JsRTCSessionDescription =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].remoteDescription); });", `pcIdx`.}
    result = JsRTCSessionDescription(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].remoteDescription)};".}
  else:
    result = JsRTCSessionDescription(JsValue(idx: 0))
proc jsRTCPeerConnectionPendingLocalDescription*(pc: JsRTCPeerConnection): JsValue =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].pendingLocalDescription); });", `pcIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].pendingLocalDescription)};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCPeerConnectionCurrentLocalDescription*(pc: JsRTCPeerConnection): JsValue =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].currentLocalDescription); });", `pcIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].currentLocalDescription)};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCPeerConnectionCurrentRemoteDescription*(pc: JsRTCPeerConnection): JsValue =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].currentRemoteDescription); });", `pcIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].currentRemoteDescription)};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCPeerConnectionSignalingState*(pc: JsRTCPeerConnection): string =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].signalingState.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].signalingState; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`pc`.idx].signalingState;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCPeerConnectionIceConnectionState*(pc: JsRTCPeerConnection): string =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].iceConnectionState.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].iceConnectionState; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`pc`.idx].iceConnectionState;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCPeerConnectionIceGatheringState*(pc: JsRTCPeerConnection): string =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].iceGatheringState.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].iceGatheringState; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`pc`.idx].iceGatheringState;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCPeerConnectionAddIceCandidate*(pc: JsRTCPeerConnection, candidate: JsValue): JsPromise =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var candidateIdx = cast[JsValue](candidate).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].addIceCandidate(heap[$1])); });", `pcIdx`, `candidateIdx`.}
    result = JsPromise(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].addIceCandidate(heap[`candidate`.idx]))};".}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsRTCPeerConnectionCreateDataChannel*(pc: JsRTCPeerConnection, label: string, options: JsValue = JsValue(idx: 0)): JsRTCDataChannel =
  when defined(emscripten):
    result = JsRTCDataChannel(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(heap[`pc`.idx].createDataChannel(`label`))};
    } else {
      `result` = {idx: addHeapObject(heap[`pc`.idx].createDataChannel(`label`, heap[o]))};
    }
    """.}
  else:
    result = JsRTCDataChannel(JsValue(idx: 0))
proc jsRTCPeerConnectionGetTransceivers*(pc: JsRTCPeerConnection): JsValue =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getTransceivers()); });", `pcIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].getTransceivers())};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCPeerConnectionGetSenders*(pc: JsRTCPeerConnection): JsValue =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getSenders()); });", `pcIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].getSenders())};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCPeerConnectionGetReceivers*(pc: JsRTCPeerConnection): JsValue =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getReceivers()); });", `pcIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`pc`.idx].getReceivers())};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCPeerConnectionClose*(pc: JsRTCPeerConnection) =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    {.emit: "EM_ASM({ heap[$0].close(); }, `pcIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`pc`.idx].close();".}
  else:
    discard
proc jsRTCPeerConnectionAddEventListener*(pc: JsRTCPeerConnection, eventType: string, handler: JsValue) =
  when defined(emscripten):
    var pcIdx = cast[JsValue](pc).idx
    var eventTypeVal = eventType
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({heap[$0].addEventListener($1, heap[$2]);}, `pcIdx`, `eventTypeVal`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`pc`.idx].addEventListener(`eventType`, heap[`handler`.idx]);".}
  else:
    discard
proc jsRTCSessionDescriptionType*(desc: JsRTCSessionDescription): string =
  when defined(emscripten):
    var descIdx = cast[JsValue](desc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].type.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].type; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`desc`.idx].type;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCSessionDescriptionSdp*(desc: JsRTCSessionDescription): string =
  when defined(emscripten):
    var descIdx = cast[JsValue](desc).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].sdp.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].sdp; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`desc`.idx].sdp;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsNewRTCSessionDescription*(descType: string, sdp: string): JsRTCSessionDescription =
  when defined(emscripten):
    var idx: uint32
    var descTypeVal = descType
    var sdpPtr = sdp.cstring
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new RTCSessionDescription($0, UTF8ToString($1))); }, `descTypeVal`, `sdpPtr`);".}
    result = JsRTCSessionDescription(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new RTCSessionDescription({type: `descType`, sdp: `sdp`}))};".}
  else:
    result = JsRTCSessionDescription(JsValue(idx: 0))
proc jsRTCIceCandidateCandidate*(cand: JsRTCIceCandidate): string =
  when defined(emscripten):
    var candIdx = cast[JsValue](cand).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].candidate.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].candidate; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`cand`.idx].candidate;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCIceCandidateSdpMid*(cand: JsRTCIceCandidate): string =
  when defined(emscripten):
    var candIdx = cast[JsValue](cand).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].sdpMid.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].sdpMid; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`cand`.idx].sdpMid;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCIceCandidateSdpMLineIndex*(cand: JsRTCIceCandidate): int =
  when defined(emscripten):
    var candIdx = cast[JsValue](cand).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].sdpMLineIndex; });", `candIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`cand`.idx].sdpMLineIndex;".}
  else:
    result = 0
proc jsNewRTCIceCandidate*(candidate: string, sdpMid: string = "", sdpMLineIndex: int = 0): JsRTCIceCandidate =
  when defined(emscripten):
    var idx: uint32
    var candidateVal = candidate
    var sdpMidPtr = sdpMid.cstring
    var sdpMLineIndexVal = sdpMLineIndex
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(new RTCIceCandidate($0, UTF8ToString($1), $2)); }, `candidateVal`, `sdpMidPtr`, `sdpMLineIndexVal`);".}
    result = JsRTCIceCandidate(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new RTCIceCandidate({candidate: `candidate`, sdpMid: `sdpMid`, sdpMLineIndex: `sdpMLineIndex`}))};".}
  else:
    result = JsRTCIceCandidate(JsValue(idx: 0))
proc jsRTCDataChannelLabel*(channel: JsRTCDataChannel): string =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].label.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].label; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`channel`.idx].label;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCDataChannelOrdered*(channel: JsRTCDataChannel): bool =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].ordered ? 1 : 0; });", `channelIdx`.}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`channel`.idx].ordered ? 1 : 0;".}
  else:
    result = false
proc jsRTCDataChannelMaxPacketLifeTime*(channel: JsRTCDataChannel): int =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].maxPacketLifeTime; });", `channelIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`channel`.idx].maxPacketLifeTime;".}
  else:
    result = 0
proc jsRTCDataChannelMaxRetransmits*(channel: JsRTCDataChannel): int =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].maxRetransmits; });", `channelIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`channel`.idx].maxRetransmits;".}
  else:
    result = 0
proc jsRTCDataChannelProtocol*(channel: JsRTCDataChannel): string =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].protocol.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].protocol; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`channel`.idx].protocol;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCDataChannelNegotiated*(channel: JsRTCDataChannel): bool =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].negotiated ? 1 : 0; });", `channelIdx`.}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`channel`.idx].negotiated ? 1 : 0;".}
  else:
    result = false
proc jsRTCDataChannelReadyState*(channel: JsRTCDataChannel): string =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].readyState.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].readyState; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`channel`.idx].readyState;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCDataChannelBufferedAmount*(channel: JsRTCDataChannel): int =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].bufferedAmount; });", `channelIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`channel`.idx].bufferedAmount;".}
  else:
    result = 0
proc jsRTCDataChannelSend*(channel: JsRTCDataChannel, data: JsValue): bool =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var dataIdx = cast[JsValue](data).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].send(heap[$1]) ? 1 : 0; }, `channelIdx`, `dataIdx`);".}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`channel`.idx].send(heap[`data`.idx]) ? 1 : 0;".}
  else:
    result = false
proc jsRTCDataChannelClose*(channel: JsRTCDataChannel) =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    {.emit: "EM_ASM({ heap[$0].close(); }, `channelIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`channel`.idx].close();".}
  else:
    discard
proc jsRTCDataChannelAddEventListener*(channel: JsRTCDataChannel, eventType: string, handler: JsValue) =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var eventTypeVal = eventType
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({heap[$0].addEventListener($1, heap[$2]);}, `channelIdx`, `eventTypeVal`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`channel`.idx].addEventListener(`eventType`, heap[`handler`.idx]);".}
  else:
    discard
proc jsRTCDataChannelOnOpen*(channel: JsRTCDataChannel, handler: JsValue) =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onopen = heap[$1]; }, `channelIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`channel`.idx].onopen = heap[`handler`.idx];".}
  else:
    discard
proc jsRTCDataChannelOnClose*(channel: JsRTCDataChannel, handler: JsValue) =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onclose = heap[$1]; }, `channelIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`channel`.idx].onclose = heap[`handler`.idx];".}
  else:
    discard
proc jsRTCDataChannelOnMessage*(channel: JsRTCDataChannel, handler: JsValue) =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onmessage = heap[$1]; }, `channelIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`channel`.idx].onmessage = heap[`handler`.idx];".}
  else:
    discard
proc jsRTCDataChannelOnError*(channel: JsRTCDataChannel, handler: JsValue) =
  when defined(emscripten):
    var channelIdx = cast[JsValue](channel).idx
    var handlerIdx = cast[JsValue](handler).idx
    {.emit: "EM_ASM({ heap[$0].onerror = heap[$1]; }, `channelIdx`, `handlerIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`channel`.idx].onerror = heap[`handler`.idx];".}
  else:
    discard
proc jsCreateRTCSessionDescriptionInit*(typ: string, sdp: string): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({type: `typ`, sdp: `sdp`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateRTCIceCandidateInit*(candidate: string, sdpMid: string = "", sdpMLineIndex: int = 0): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({candidate: `candidate`, sdpMid: `sdpMid`, sdpMLineIndex: `sdpMLineIndex`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateRTCDataChannelInit*(ordered: bool, maxPacketLifeTime: int = 0, maxRetransmits: int = 0, protocol: string = "", negotiated: bool = false): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({ordered: `ordered`, maxPacketLifeTime: `maxPacketLifeTime`, maxRetransmits: `maxRetransmits`, protocol: `protocol`, negotiated: `negotiated`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateRTCIceServer*(urls: string, username: string = "", credential: string = ""): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({urls: `urls`, username: `username`, credential: `credential`})};".}
  else:
    result = JsValue(idx: 0)
proc jsCreateRTCConfiguration*(iceServers: JsValue): JsValue =
  when defined(emscripten):
    result = JsValue(idx: 0)
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject({iceServers: heap[`iceServers`.idx]})};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCRtpSenderTrack*(sender: JsRTCRtpSender): JsValue =
  when defined(emscripten):
    var senderIdx = cast[JsValue](sender).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].track); });", `senderIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`sender`.idx].track)};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCRtpReceiverTrack*(receiver: JsRTCRtpReceiver): JsValue =
  when defined(emscripten):
    var receiverIdx = cast[JsValue](receiver).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].track); });", `receiverIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`receiver`.idx].track)};".}
  else:
    result = JsValue(idx: 0)
proc jsRTCRtpTransceiverMid*(transceiver: JsRTCRtpTransceiver): string =
  when defined(emscripten):
    var transceiverIdx = cast[JsValue](transceiver).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].mid.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].mid; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`transceiver`.idx].mid;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsRTCRtpTransceiverStop*(transceiver: JsRTCRtpTransceiver) =
  when defined(emscripten):
    var transceiverIdx = cast[JsValue](transceiver).idx
    {.emit: "EM_ASM({ heap[$0].stop(); }, `transceiverIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`transceiver`.idx].stop();".}
  else:
    discard
# ─── WebGL / WebGPU API ───

type
  JsWebGLRenderingContext* = distinct JsValue
  JsWebGLBuffer* = distinct JsValue
  JsWebGLFramebuffer* = distinct JsValue
  JsWebGLProgram* = distinct JsValue
  JsWebGLShader* = distinct JsValue
  JsWebGLTexture* = distinct JsValue
  JsWebGLUniformLocation* = distinct JsValue
  JsWebGLRenderbuffer* = distinct JsValue
  JsWebGLVertexArrayObject* = distinct JsValue
  JsWebGL2RenderingContext* = distinct JsValue
  JsGPUCanvasContext* = distinct JsValue
  JsGPUDevice* = distinct JsValue
  JsGPUSwapChain* = distinct JsValue
  JsGPUTexture* = distinct JsValue
  JsGPUCommandBuffer* = distinct JsValue
  JsGPUCommandEncoder* = distinct JsValue
  JsGPURenderPassEncoder* = distinct JsValue

proc jsHTMLCanvasElementGetContextWebGL*(canvas: JsHTMLCanvasElement, contextType: string = "webgl"): JsWebGLRenderingContext =
  when defined(emscripten):
    var canvasIdx = cast[JsValue](canvas).idx
    var contextTypePtr = contextType.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getContext(UTF8ToString($1))); }, `canvasIdx`, `contextTypePtr`);".}
    result = JsWebGLRenderingContext(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var ctx = heap[`canvas`.idx].getContext(`contextType`);
    `result` = {idx: addHeapObject(ctx)};
    """.}
  else:
    result = JsWebGLRenderingContext(JsValue(idx: 0))
proc jsHTMLCanvasElementGetContextWebGL2*(canvas: JsHTMLCanvasElement): JsWebGL2RenderingContext =
  when defined(emscripten):
    var canvasIdx = cast[JsValue](canvas).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getContext()); }, `canvasIdx`);".}
    result = JsWebGL2RenderingContext(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var ctx = heap[`canvas`.idx].getContext("webgl2");
    `result` = {idx: addHeapObject(ctx)};
    """.}
  else:
    result = JsWebGL2RenderingContext(JsValue(idx: 0))
proc jsHTMLCanvasElementGetContextGPU*(canvas: JsHTMLCanvasElement): JsGPUCanvasContext =
  when defined(emscripten):
    var canvasIdx = cast[JsValue](canvas).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getContext()); }, `canvasIdx`);".}
    result = JsGPUCanvasContext(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: """
    var ctx = heap[`canvas`.idx].getContext("gpu");
    `result` = {idx: addHeapObject(ctx)};
    """.}
  else:
    result = JsGPUCanvasContext(JsValue(idx: 0))
proc jsWebGLClearColor*(ctx: JsWebGLRenderingContext, r, g, b, a: float64) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var rVal = r
    var gVal = g
    var bVal = b
    var aVal = a
    {.emit: "EM_ASM({heap[$0].clearColor($1, $2, $3, $4);}, `ctxIdx`, `rVal`, `gVal`, `bVal`, `aVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].clearColor(`r`, `g`, `b`, `a`);".}
  else:
    discard
proc jsWebGLClear*(ctx: JsWebGLRenderingContext, mask: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var maskVal = mask
    {.emit: "EM_ASM({heap[$0].clear($1);}, `ctxIdx`, `maskVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].clear(`mask`);".}
  else:
    discard
proc jsWebGLViewport*(ctx: JsWebGLRenderingContext, x, y, w, h: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var xVal = x
    var yVal = y
    var wVal = w
    var hVal = h
    {.emit: "EM_ASM({heap[$0].viewport($1, $2, $3, $4);}, `ctxIdx`, `xVal`, `yVal`, `wVal`, `hVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].viewport(`x`, `y`, `w`, `h`);".}
  else:
    discard
proc jsWebGLCreateShader*(ctx: JsWebGLRenderingContext, typ: int): JsWebGLShader =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var typVal = typ
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createShader($1)); }, `ctxIdx`, `typVal`);".}
    result = JsWebGLShader(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createShader(`typ`))};".}
  else:
    result = JsWebGLShader(JsValue(idx: 0))
proc jsWebGLShaderSource*(shader: JsWebGLShader, source: string) =
  when defined(emscripten):
    var shaderIdx = cast[JsValue](shader).idx
    var sourcePtr = source.cstring
    {.emit: "EM_ASM({heap[$0].shaderSource(UTF8ToString($1));}, `shaderIdx`, `sourcePtr`);".}
  elif defined(wasm32):
    {.emit: "heap[`shader`.idx].shaderSource(`source`);".}
  else:
    discard
proc jsWebGLCompileShader*(shader: JsWebGLShader): bool =
  when defined(emscripten):
    var shaderIdx = cast[JsValue](shader).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].compileShader() ? 1 : 0; }, `shaderIdx`);".}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`shader`.idx].compileShader() ? 1 : 0;".}
  else:
    result = false
proc jsWebGLGetShaderParameter*(shader: JsWebGLShader, pname: int): int =
  when defined(emscripten):
    result = 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`shader`.idx].getShaderParameter(`pname`);".}
  else:
    result = 0
proc jsWebGLGetShaderInfoLog*(shader: JsWebGLShader): string =
  when defined(emscripten):
    var shaderIdx = cast[JsValue](shader).idx
    var shaderIdx = cast[JsValue](shader).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return (heap[$0].getShaderInfoLog(heap[$1]) || '').length; }, `shaderIdx`, `shaderIdx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].getShaderInfoLog(heap[$1]) || ''; var p = $2; for (var i = 0; i < $3; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `shaderIdx`, `shaderIdx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`shader`.idx].getShaderInfoLog(`shader`) || "";
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsWebGLDeleteShader*(shader: JsWebGLShader) =
  when defined(emscripten):
    var shaderIdx = cast[JsValue](shader).idx
    var shaderIdx = cast[JsValue](shader).idx
    {.emit: "EM_ASM({heap[$0].deleteShader(heap[$1]);}, `shaderIdx`, `shaderIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`shader`.idx].deleteShader(heap[`shader`.idx]);".}
  else:
    discard
proc jsWebGLCreateProgram*(ctx: JsWebGLRenderingContext): JsWebGLProgram =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createProgram()); });", `ctxIdx`.}
    result = JsWebGLProgram(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createProgram())};".}
  else:
    result = JsWebGLProgram(JsValue(idx: 0))
proc jsWebGLAttachShader*(program: JsWebGLProgram, shader: JsWebGLShader) =
  when defined(emscripten):
    var programIdx = cast[JsValue](program).idx
    var shaderIdx = cast[JsValue](shader).idx
    {.emit: "EM_ASM({heap[$0].attachShader(heap[$1]);}, `programIdx`, `shaderIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`program`.idx].attachShader(heap[`shader`.idx]);".}
  else:
    discard
proc jsWebGLLinkProgram*(program: JsWebGLProgram): bool =
  when defined(emscripten):
    var programIdx = cast[JsValue](program).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].linkProgram() ? 1 : 0; }, `programIdx`);".}
    result = val != 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`program`.idx].linkProgram() ? 1 : 0;".}
  else:
    result = false
proc jsWebGLGetProgramParameter*(program: JsWebGLProgram, pname: int): int =
  when defined(emscripten):
    result = 0
  elif defined(wasm32):
    {.emit: "`result` = heap[`program`.idx].getProgramParameter(`pname`);".}
  else:
    result = 0
proc jsWebGLGetProgramInfoLog*(program: JsWebGLProgram): string =
  when defined(emscripten):
    var programIdx = cast[JsValue](program).idx
    var programIdx = cast[JsValue](program).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return (heap[$0].getProgramInfoLog(heap[$1]) || '').length; }, `programIdx`, `programIdx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].getProgramInfoLog(heap[$1]) || ''; var p = $2; for (var i = 0; i < $3; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `programIdx`, `programIdx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`program`.idx].getProgramInfoLog(`program`) || "";
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsWebGLDeleteProgram*(program: JsWebGLProgram) =
  when defined(emscripten):
    var programIdx = cast[JsValue](program).idx
    var programIdx = cast[JsValue](program).idx
    {.emit: "EM_ASM({heap[$0].deleteProgram(heap[$1]);}, `programIdx`, `programIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`program`.idx].deleteProgram(heap[`program`.idx]);".}
  else:
    discard
proc jsWebGLUseProgram*(program: JsWebGLProgram) =
  when defined(emscripten):
    var programIdx = cast[JsValue](program).idx
    var programIdx = cast[JsValue](program).idx
    {.emit: "EM_ASM({heap[$0].useProgram(heap[$1]);}, `programIdx`, `programIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`program`.idx].useProgram(heap[`program`.idx]);".}
  else:
    discard
proc jsWebGLCreateBuffer*(ctx: JsWebGLRenderingContext): JsWebGLBuffer =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createBuffer()); });", `ctxIdx`.}
    result = JsWebGLBuffer(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createBuffer())};".}
  else:
    result = JsWebGLBuffer(JsValue(idx: 0))
proc jsWebGLBindBuffer*(ctx: JsWebGLRenderingContext, target: int, buffer: JsWebGLBuffer) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var targetVal = target
    var bufferIdx = cast[JsValue](buffer).idx
    {.emit: "EM_ASM({heap[$0].bindBuffer($1, heap[$2]);}, `ctxIdx`, `targetVal`, `bufferIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].bindBuffer(`target`, heap[`buffer`.idx]);".}
  else:
    discard
proc jsWebGLBufferData*(ctx: JsWebGLRenderingContext, target: int, data: JsValue, usage: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var targetVal = target
    var dataIdx = cast[JsValue](data).idx
    var usageVal = usage
    {.emit: "EM_ASM({heap[$0].bufferData($1, heap[$2], $3);}, `ctxIdx`, `targetVal`, `dataIdx`, `usageVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].bufferData(`target`, heap[`data`.idx], `usage`);".}
  else:
    discard
proc jsWebGLDeleteBuffer*(buffer: JsWebGLBuffer) =
  when defined(emscripten):
    var bufferIdx = cast[JsValue](buffer).idx
    var bufferIdx = cast[JsValue](buffer).idx
    {.emit: "EM_ASM({heap[$0].deleteBuffer(heap[$1]);}, `bufferIdx`, `bufferIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`buffer`.idx].deleteBuffer(heap[`buffer`.idx]);".}
  else:
    discard
proc jsWebGLCreateTexture*(ctx: JsWebGLRenderingContext): JsWebGLTexture =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createTexture()); });", `ctxIdx`.}
    result = JsWebGLTexture(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createTexture())};".}
  else:
    result = JsWebGLTexture(JsValue(idx: 0))
proc jsWebGLBindTexture*(ctx: JsWebGLRenderingContext, target: int, texture: JsWebGLTexture) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var targetVal = target
    var textureIdx = cast[JsValue](texture).idx
    {.emit: "EM_ASM({heap[$0].bindTexture($1, heap[$2]);}, `ctxIdx`, `targetVal`, `textureIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].bindTexture(`target`, heap[`texture`.idx]);".}
  else:
    discard
proc jsWebGLTexImage2D*(ctx: JsWebGLRenderingContext, target: int, level: int, internalformat: int, format: int, typ: int, pixels: JsValue) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var targetVal = target
    var levelVal = level
    var internalformatVal = internalformat
    var formatVal = format
    var typVal = typ
    var pixelsIdx = cast[JsValue](pixels).idx
    {.emit: "EM_ASM({heap[$0].texImage2D($1, $2, $3, $4, $5, heap[$6]);}, `ctxIdx`, `targetVal`, `levelVal`, `internalformatVal`, `formatVal`, `typVal`, `pixelsIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].texImage2D(`target`, `level`, `internalformat`, `format`, `typ`, heap[`pixels`.idx]);".}
  else:
    discard
proc jsWebGLDeleteTexture*(texture: JsWebGLTexture) =
  when defined(emscripten):
    var textureIdx = cast[JsValue](texture).idx
    var textureIdx = cast[JsValue](texture).idx
    {.emit: "EM_ASM({heap[$0].deleteTexture(heap[$1]);}, `textureIdx`, `textureIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`texture`.idx].deleteTexture(heap[`texture`.idx]);".}
  else:
    discard
proc jsWebGLCreateFramebuffer*(ctx: JsWebGLRenderingContext): JsWebGLFramebuffer =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createFramebuffer()); });", `ctxIdx`.}
    result = JsWebGLFramebuffer(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createFramebuffer())};".}
  else:
    result = JsWebGLFramebuffer(JsValue(idx: 0))
proc jsWebGLBindFramebuffer*(ctx: JsWebGLRenderingContext, target: int, framebuffer: JsWebGLFramebuffer) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var targetVal = target
    var framebufferIdx = cast[JsValue](framebuffer).idx
    {.emit: "EM_ASM({heap[$0].bindFramebuffer($1, heap[$2]);}, `ctxIdx`, `targetVal`, `framebufferIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].bindFramebuffer(`target`, heap[`framebuffer`.idx]);".}
  else:
    discard
proc jsWebGLFramebufferTexture2D*(ctx: JsWebGLRenderingContext, target: int, attachment: int, texTarget: int, texture: JsWebGLTexture, level: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var targetVal = target
    var attachmentVal = attachment
    var texTargetVal = texTarget
    var textureIdx = cast[JsValue](texture).idx
    var levelVal = level
    {.emit: "EM_ASM({heap[$0].framebufferTexture2D($1, $2, $3, heap[$4], $5);}, `ctxIdx`, `targetVal`, `attachmentVal`, `texTargetVal`, `textureIdx`, `levelVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].framebufferTexture2D(`target`, `attachment`, `texTarget`, heap[`texture`.idx], `level`);".}
  else:
    discard
proc jsWebGLDeleteFramebuffer*(framebuffer: JsWebGLFramebuffer) =
  when defined(emscripten):
    var framebufferIdx = cast[JsValue](framebuffer).idx
    var framebufferIdx = cast[JsValue](framebuffer).idx
    {.emit: "EM_ASM({heap[$0].deleteFramebuffer(heap[$1]);}, `framebufferIdx`, `framebufferIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`framebuffer`.idx].deleteFramebuffer(heap[`framebuffer`.idx]);".}
  else:
    discard
proc jsWebGLGetAttribLocation*(program: JsWebGLProgram, name: string): int =
  when defined(emscripten):
    result = -1
  elif defined(wasm32):
    {.emit: "`result` = heap[`program`.idx].getAttribLocation(`name`);".}
  else:
    result = -1
proc jsWebGLGetUniformLocation*(program: JsWebGLProgram, name: string): JsWebGLUniformLocation =
  when defined(emscripten):
    var programIdx = cast[JsValue](program).idx
    var namePtr = name.cstring
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getUniformLocation(UTF8ToString($1))); }, `programIdx`, `namePtr`);".}
    result = JsWebGLUniformLocation(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`program`.idx].getUniformLocation(`name`))};".}
  else:
    result = JsWebGLUniformLocation(JsValue(idx: 0))
proc jsWebGLUniform1f*(location: JsWebGLUniformLocation, v0: float64) =
  when defined(emscripten):
    var locationIdx = cast[JsValue](location).idx
    var v0Val = v0
    {.emit: "EM_ASM({heap[$0].uniform1f($1);}, `locationIdx`, `v0Val`);".}
  elif defined(wasm32):
    {.emit: "heap[`location`.idx].uniform1f(`v0`);".}
  else:
    discard
proc jsWebGLUniform1i*(location: JsWebGLUniformLocation, v0: int) =
  when defined(emscripten):
    var locationIdx = cast[JsValue](location).idx
    var v0Val = v0
    {.emit: "EM_ASM({heap[$0].uniform1i($1);}, `locationIdx`, `v0Val`);".}
  elif defined(wasm32):
    {.emit: "heap[`location`.idx].uniform1i(`v0`);".}
  else:
    discard
proc jsWebGLUniform2f*(location: JsWebGLUniformLocation, v0, v1: float64) =
  when defined(emscripten):
    var locationIdx = cast[JsValue](location).idx
    var v0Val = v0
    var v1Val = v1
    {.emit: "EM_ASM({heap[$0].uniform2f($1, $2);}, `locationIdx`, `v0Val`, `v1Val`);".}
  elif defined(wasm32):
    {.emit: "heap[`location`.idx].uniform2f(`v0`, `v1`);".}
  else:
    discard
proc jsWebGLUniform3f*(location: JsWebGLUniformLocation, v0, v1, v2: float64) =
  when defined(emscripten):
    var locationIdx = cast[JsValue](location).idx
    var v0Val = v0
    var v1Val = v1
    var v2Val = v2
    {.emit: "EM_ASM({heap[$0].uniform3f($1, $2, $3);}, `locationIdx`, `v0Val`, `v1Val`, `v2Val`);".}
  elif defined(wasm32):
    {.emit: "heap[`location`.idx].uniform3f(`v0`, `v1`, `v2`);".}
  else:
    discard
proc jsWebGLUniform4f*(location: JsWebGLUniformLocation, v0, v1, v2, v3: float64) =
  when defined(emscripten):
    var locationIdx = cast[JsValue](location).idx
    var v0Val = v0
    var v1Val = v1
    var v2Val = v2
    var v3Val = v3
    {.emit: "EM_ASM({heap[$0].uniform4f($1, $2, $3, $4);}, `locationIdx`, `v0Val`, `v1Val`, `v2Val`, `v3Val`);".}
  elif defined(wasm32):
    {.emit: "heap[`location`.idx].uniform4f(`v0`, `v1`, `v2`, `v3`);".}
  else:
    discard
proc jsWebGLUniformMatrix4fv*(location: JsWebGLUniformLocation, transpose: bool, value: JsValue) =
  when defined(emscripten):
    var locationIdx = cast[JsValue](location).idx
    var transposeVal = transpose
    var valueIdx = cast[JsValue](value).idx
    {.emit: "EM_ASM({heap[$0].uniformMatrix4fv($1, heap[$2]);}, `locationIdx`, `transposeVal`, `valueIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`location`.idx].uniformMatrix4fv(`transpose`, heap[`value`.idx]);".}
  else:
    discard
proc jsWebGLDrawArrays*(ctx: JsWebGLRenderingContext, mode: int, first: int, count: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var modeVal = mode
    var firstVal = first
    var countVal = count
    {.emit: "EM_ASM({heap[$0].drawArrays($1, $2, $3);}, `ctxIdx`, `modeVal`, `firstVal`, `countVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].drawArrays(`mode`, `first`, `count`);".}
  else:
    discard
proc jsWebGLDrawElements*(ctx: JsWebGLRenderingContext, mode: int, count: int, typ: int, offset: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var modeVal = mode
    var countVal = count
    var typVal = typ
    var offsetVal = offset
    {.emit: "EM_ASM({heap[$0].drawElements($1, $2, $3, $4);}, `ctxIdx`, `modeVal`, `countVal`, `typVal`, `offsetVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].drawElements(`mode`, `count`, `typ`, `offset`);".}
  else:
    discard
proc jsWebGLEnableVertexAttribArray*(ctx: JsWebGLRenderingContext, index: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var indexVal = index
    {.emit: "EM_ASM({heap[$0].enableVertexAttribArray($1);}, `ctxIdx`, `indexVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].enableVertexAttribArray(`index`);".}
  else:
    discard
proc jsWebGLDisableVertexAttribArray*(ctx: JsWebGLRenderingContext, index: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var indexVal = index
    {.emit: "EM_ASM({heap[$0].disableVertexAttribArray($1);}, `ctxIdx`, `indexVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].disableVertexAttribArray(`index`);".}
  else:
    discard
proc jsWebGLVertexAttribPointer*(ctx: JsWebGLRenderingContext, index: int, size: int, typ: int, normalized: bool, stride: int, offset: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var indexVal = index
    var sizeVal = size
    var typVal = typ
    var normalizedVal = normalized
    var strideVal = stride
    var offsetVal = offset
    {.emit: "EM_ASM({heap[$0].vertexAttribPointer($1, $2, $3, $4, $5, $6);}, `ctxIdx`, `indexVal`, `sizeVal`, `typVal`, `normalizedVal`, `strideVal`, `offsetVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].vertexAttribPointer(`index`, `size`, `typ`, `normalized`, `stride`, `offset`);".}
  else:
    discard
proc jsWebGLEnable*(ctx: JsWebGLRenderingContext, cap: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var capVal = cap
    {.emit: "EM_ASM({heap[$0].enable($1);}, `ctxIdx`, `capVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].enable(`cap`);".}
  else:
    discard
proc jsWebGLDisable*(ctx: JsWebGLRenderingContext, cap: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var capVal = cap
    {.emit: "EM_ASM({heap[$0].disable($1);}, `ctxIdx`, `capVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].disable(`cap`);".}
  else:
    discard
proc jsWebGLGetError*(ctx: JsWebGLRenderingContext): int =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].getError(); });", `ctxIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`ctx`.idx].getError();".}
  else:
    result = 0
proc jsWebGLFinish*(ctx: JsWebGLRenderingContext) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].finish(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].finish();".}
  else:
    discard
proc jsWebGLFlush*(ctx: JsWebGLRenderingContext) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    {.emit: "EM_ASM({ heap[$0].flush(); }, `ctxIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].flush();".}
  else:
    discard
proc jsWebGLPixelStorei*(ctx: JsWebGLRenderingContext, pname: int, param: int) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var pnameVal = pname
    var paramVal = param
    {.emit: "EM_ASM({heap[$0].pixelStorei($1, $2);}, `ctxIdx`, `pnameVal`, `paramVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].pixelStorei(`pname`, `param`);".}
  else:
    discard
proc jsWebGLGenBuffers*(ctx: JsWebGLRenderingContext, count: int): JsValue =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createBuffer()); });", `ctxIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createBuffer())};".}
  else:
    result = JsValue(idx: 0)
proc jsWebGLGenTextures*(ctx: JsWebGLRenderingContext, count: int): JsValue =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createTexture()); });", `ctxIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createTexture())};".}
  else:
    result = JsValue(idx: 0)
proc jsWebGLCreateVertexArray*(ctx: JsWebGL2RenderingContext): JsWebGLVertexArrayObject =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createVertexArray()); });", `ctxIdx`.}
    result = JsWebGLVertexArrayObject(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createVertexArray())};".}
  else:
    result = JsWebGLVertexArrayObject(JsValue(idx: 0))
proc jsWebGLBindVertexArray*(ctx: JsWebGL2RenderingContext, vao: JsWebGLVertexArrayObject) =
  when defined(emscripten):
    var ctxIdx = cast[JsValue](ctx).idx
    var vaoIdx = cast[JsValue](vao).idx
    {.emit: "EM_ASM({heap[$0].bindVertexArray(heap[$1]);}, `ctxIdx`, `vaoIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`ctx`.idx].bindVertexArray(heap[`vao`.idx]);".}
  else:
    discard
proc jsWebGLDeleteVertexArray*(vao: JsWebGLVertexArrayObject) =
  when defined(emscripten):
    var vaoIdx = cast[JsValue](vao).idx
    var vaoIdx = cast[JsValue](vao).idx
    {.emit: "EM_ASM({heap[$0].deleteVertexArray(heap[$1]);}, `vaoIdx`, `vaoIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`vao`.idx].deleteVertexArray(heap[`vao`.idx]);".}
  else:
    discard
proc jsGPURequestAdapter*(options: JsValue = JsValue(idx: 0)): JsPromise =
  when defined(emscripten):
    result = JsPromise(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var o = `options`;
    if (o == 0) {
      `result` = {idx: addHeapObject(navigator.gpu.requestAdapter())};
    } else {
      `result` = {idx: addHeapObject(navigator.gpu.requestAdapter(heap[o]))};
    }
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsGPUAdapterRequestDevice*(adapter: JsValue, descriptor: JsValue = JsValue(idx: 0)): JsPromise =
  when defined(emscripten):
    result = JsPromise(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var d = `descriptor`;
    if (d == 0) {
      `result` = {idx: addHeapObject(heap[`adapter`.idx].requestDevice())};
    } else {
      `result` = {idx: addHeapObject(heap[`adapter`.idx].requestDevice(heap[d]))};
    }
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))
proc jsGPUDeviceCreateSwapChain*(device: JsGPUDevice, canvas: JsGPUCanvasContext): JsGPUSwapChain =
  when defined(emscripten):
    var deviceIdx = cast[JsValue](device).idx
    var canvasIdx = cast[JsValue](canvas).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createSwapChain(heap[$1])); });", `deviceIdx`, `canvasIdx`.}
    result = JsGPUSwapChain(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`device`.idx].createSwapChain(heap[`canvas`.idx]))};".}
  else:
    result = JsGPUSwapChain(JsValue(idx: 0))
proc jsGPUSwapChainGetCurrentTexture*(swapChain: JsGPUSwapChain): JsGPUTexture =
  when defined(emscripten):
    var swapChainIdx = cast[JsValue](swapChain).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].getCurrentTexture()); });", `swapChainIdx`.}
    result = JsGPUTexture(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`swapChain`.idx].getCurrentTexture())};".}
  else:
    result = JsGPUTexture(JsValue(idx: 0))
proc jsGPUCommandEncoderFinish*(encoder: JsGPUCommandEncoder): JsGPUCommandBuffer =
  when defined(emscripten):
    var encoderIdx = cast[JsValue](encoder).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].finish()); });", `encoderIdx`.}
    result = JsGPUCommandBuffer(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`encoder`.idx].finish())};".}
  else:
    result = JsGPUCommandBuffer(JsValue(idx: 0))
proc jsGPUCommandBufferLabel*(buffer: JsGPUCommandBuffer): string =
  when defined(emscripten):
    var bufferIdx = cast[JsValue](buffer).idx
    var dataLen: int
    {.emit: "`dataLen` = EM_ASM_INT({ return heap[$0].label.length; }, `{obj}Idx`);".}
    result = newString(dataLen)
    if dataLen > 0:
      var resAddr = cast[uint32](addr result[0])
      {.emit: "EM_ASM({var s = heap[$0].label; var p = $1; for (var i = 0; i < $2; i++) HEAPU8[p + i] = s.charCodeAt(i);}, `{obj}Idx`, `resAddr`, `dataLen`);".}
  elif defined(wasm32):
    {.emit: """
    var s = heap[`buffer`.idx].label;
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""
proc jsGPUTextureWidth*(texture: JsGPUTexture): int =
  when defined(emscripten):
    var textureIdx = cast[JsValue](texture).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].width; });", `textureIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`texture`.idx].width;".}
  else:
    result = 0
proc jsGPUTextureHeight*(texture: JsGPUTexture): int =
  when defined(emscripten):
    var textureIdx = cast[JsValue](texture).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].height; });", `textureIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`texture`.idx].height;".}
  else:
    result = 0
proc jsGPUTextureDepth*(texture: JsGPUTexture): int =
  when defined(emscripten):
    var textureIdx = cast[JsValue](texture).idx
    var val: int
    {.emit: "`val` = EM_ASM_INT({ return heap[$0].depth; });", `textureIdx`.}
    result = val
  elif defined(wasm32):
    {.emit: "`result` = heap[`texture`.idx].depth;".}
  else:
    result = 0
proc jsGPURenderPassEncoderDraw*(encoder: JsGPURenderPassEncoder, vertexCount: int, instanceCount: int = 1, firstVertex: int = 0, firstInstance: int = 0) =
  when defined(emscripten):
    var encoderIdx = cast[JsValue](encoder).idx
    var vertexCountVal = vertexCount
    var instanceCountVal = instanceCount
    var firstVertexVal = firstVertex
    var firstInstanceVal = firstInstance
    {.emit: "EM_ASM({heap[$0].draw($1, $2, $3, $4);}, `encoderIdx`, `vertexCountVal`, `instanceCountVal`, `firstVertexVal`, `firstInstanceVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`encoder`.idx].draw(`vertexCount`, `instanceCount`, `firstVertex`, `firstInstance`);".}
  else:
    discard
proc jsGPURenderPassEncoderDrawIndexed*(encoder: JsGPURenderPassEncoder, indexCount: int, instanceCount: int = 1, firstIndex: int = 0, baseVertex: int = 0, firstInstance: int = 0) =
  when defined(emscripten):
    var encoderIdx = cast[JsValue](encoder).idx
    var indexCountVal = indexCount
    var instanceCountVal = instanceCount
    var firstIndexVal = firstIndex
    var baseVertexVal = baseVertex
    var firstInstanceVal = firstInstance
    {.emit: "EM_ASM({heap[$0].drawIndexed($1, $2, $3, $4, $5);}, `encoderIdx`, `indexCountVal`, `instanceCountVal`, `firstIndexVal`, `baseVertexVal`, `firstInstanceVal`);".}
  elif defined(wasm32):
    {.emit: "heap[`encoder`.idx].drawIndexed(`indexCount`, `instanceCount`, `firstIndex`, `baseVertex`, `firstInstance`);".}
  else:
    discard
proc jsGPUQueueSubmit*(queue: JsValue, commandBuffers: JsValue) =
  when defined(emscripten):
    var queueIdx = cast[JsValue](queue).idx
    var commandBuffersIdx = cast[JsValue](commandBuffers).idx
    {.emit: "EM_ASM({heap[$0].submit(heap[$1]);}, `queueIdx`, `commandBuffersIdx`);".}
  elif defined(wasm32):
    {.emit: "heap[`queue`.idx].submit(heap[`commandBuffers`.idx]);".}
  else:
    discard
proc jsGPUDeviceCreateCommandEncoder*(device: JsGPUDevice, descriptor: JsValue = JsValue(idx: 0)): JsGPUCommandEncoder =
  when defined(emscripten):
    result = JsGPUCommandEncoder(JsValue(idx: 0))
  elif defined(wasm32):
    {.emit: """
    var d = `descriptor`;
    if (d == 0) {
      `result` = {idx: addHeapObject(heap[`device`.idx].createCommandEncoder())};
    } else {
      `result` = {idx: addHeapObject(heap[`device`.idx].createCommandEncoder(heap[d]))};
    }
    """.}
  else:
    result = JsGPUCommandEncoder(JsValue(idx: 0))
proc jsGPUDeviceCreateRenderPipeline*(device: JsGPUDevice, descriptor: JsValue): JsValue =
  when defined(emscripten):
    var deviceIdx = cast[JsValue](device).idx
    var descriptorIdx = cast[JsValue](descriptor).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createRenderPipeline(heap[$1])); });", `deviceIdx`, `descriptorIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`device`.idx].createRenderPipeline(heap[`descriptor`.idx]))};".}
  else:
    result = JsValue(idx: 0)
proc jsGPUDeviceCreateBuffer*(device: JsGPUDevice, descriptor: JsValue): JsValue =
  when defined(emscripten):
    var deviceIdx = cast[JsValue](device).idx
    var descriptorIdx = cast[JsValue](descriptor).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].createBuffer(heap[$1])); });", `deviceIdx`, `descriptorIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`device`.idx].createBuffer(heap[`descriptor`.idx]))};".}
  else:
    result = JsValue(idx: 0)
proc jsGPUDeviceQueue*(device: JsGPUDevice): JsValue =
  when defined(emscripten):
    var deviceIdx = cast[JsValue](device).idx
    var idx: uint32
    {.emit: "`idx` = EM_ASM_INT({ return addHeapObject(heap[$0].queue); });", `deviceIdx`.}
    result = JsValue(JsValue(idx: idx))
  elif defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`device`.idx].queue)};".}
  else:
    result = JsValue(idx: 0)
