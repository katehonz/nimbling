## web-sys equivalent for nimbling: bindings to Web APIs (DOM, Events, Canvas, Fetch, etc).
## Mirrors Rust's web-sys crate.

import common
import runtime
import js_sys

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
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(document)};".}
  else:
    result = JsDocument(JsValue(idx: 0))

proc jsDocumentGetElementById*(doc: JsDocument, id: string): JsElement =
  when defined(wasm32):
    {.emit: """
    var el = heap[`doc`.idx].getElementById(`id`);
    `result` = {idx: addHeapObject(el)};
    """.}
  else:
    result = JsElement(JsValue(idx: 0))

proc jsDocumentCreateElement*(doc: JsDocument, tag: string): JsElement =
  when defined(wasm32):
    {.emit: """
    var el = heap[`doc`.idx].createElement(`tag`);
    `result` = {idx: addHeapObject(el)};
    """.}
  else:
    result = JsElement(JsValue(idx: 0))

proc jsDocumentCreateTextNode*(doc: JsDocument, text: string): JsNode =
  when defined(wasm32):
    {.emit: """
    var node = heap[`doc`.idx].createTextNode(`text`);
    `result` = {idx: addHeapObject(node)};
    """.}
  else:
    result = JsNode(JsValue(idx: 0))

proc jsDocumentBody*(doc: JsDocument): JsElement =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`doc`.idx].body)};".}
  else:
    result = JsElement(JsValue(idx: 0))

proc jsDocumentHead*(doc: JsDocument): JsElement =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`doc`.idx].head)};".}
  else:
    result = JsElement(JsValue(idx: 0))

# ─── Element ───

proc jsElementGetAttribute*(el: JsElement, name: string): string =
  when defined(wasm32):
    {.emit: """
    var s = heap[`el`.idx].getAttribute(`name`) || '';
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsElementSetAttribute*(el: JsElement, name: string, value: string) =
  when defined(wasm32):
    {.emit: "heap[`el`.idx].setAttribute(`name`, `value`);".}
  else:
    discard

proc jsElementRemoveAttribute*(el: JsElement, name: string) =
  when defined(wasm32):
    {.emit: "heap[`el`.idx].removeAttribute(`name`);".}
  else:
    discard

proc jsElementClassList*(el: JsElement): JsDOMTokenList =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`el`.idx].classList)};".}
  else:
    result = JsDOMTokenList(JsValue(idx: 0))

proc jsElementInnerHTML*(el: JsElement): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`el`.idx].innerHTML = `html`;".}
  else:
    discard

proc jsElementInnerText*(el: JsElement): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`el`.idx].innerText = `text`;".}
  else:
    discard

proc jsElementAppendChild*(parent: JsElement, child: JsNode): JsNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`parent`.idx].appendChild(heap[`child`.idx]))};".}
  else:
    result = JsNode(JsValue(idx: 0))

proc jsElementRemoveChild*(parent: JsElement, child: JsNode): JsNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`parent`.idx].removeChild(heap[`child`.idx]))};".}
  else:
    result = JsNode(JsValue(idx: 0))

proc jsElementQuerySelector*(el: JsElement, selector: string): JsElement =
  when defined(wasm32):
    {.emit: """
    var found = heap[`el`.idx].querySelector(`selector`);
    `result` = {idx: addHeapObject(found)};
    """.}
  else:
    result = JsElement(JsValue(idx: 0))

proc jsElementQuerySelectorAll*(el: JsElement, selector: string): JsNodeList =
  when defined(wasm32):
    {.emit: """
    var list = heap[`el`.idx].querySelectorAll(`selector`);
    `result` = {idx: addHeapObject(list)};
    """.}
  else:
    result = JsNodeList(JsValue(idx: 0))

proc jsElementStyle*(el: JsElement): JsCSSStyleDeclaration =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`el`.idx].style)};".}
  else:
    result = JsCSSStyleDeclaration(JsValue(idx: 0))

proc jsElementGetBoundingClientRect*(el: JsElement): JsDOMRect =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`el`.idx].getBoundingClientRect())};".}
  else:
    result = JsDOMRect(JsValue(idx: 0))

# ─── NodeList ───

proc jsNodeListLen*(list: JsNodeList): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`list`.idx].length;".}
  else:
    result = 0

proc jsNodeListItem*(list: JsNodeList, idx: int): JsNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`list`.idx][`idx`])};".}
  else:
    result = JsNode(JsValue(idx: 0))

# ─── Events ───

proc jsEventTarget*(e: JsEvent): JsElement =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`e`.idx].target)};".}
  else:
    result = JsElement(JsValue(idx: 0))

proc jsEventPreventDefault*(e: JsEvent) =
  when defined(wasm32):
    {.emit: "heap[`e`.idx].preventDefault();".}
  else:
    discard

proc jsEventStopPropagation*(e: JsEvent) =
  when defined(wasm32):
    {.emit: "heap[`e`.idx].stopPropagation();".}
  else:
    discard

proc jsEventStopImmediatePropagation*(e: JsEvent) =
  when defined(wasm32):
    {.emit: "heap[`e`.idx].stopImmediatePropagation();".}
  else:
    discard

proc jsMouseEventClientX*(e: JsMouseEvent): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`e`.idx].clientX;".}
  else:
    result = 0

proc jsMouseEventClientY*(e: JsMouseEvent): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`e`.idx].clientY;".}
  else:
    result = 0

proc jsMouseEventButton*(e: JsMouseEvent): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`e`.idx].button;".}
  else:
    result = 0

proc jsKeyboardEventKey*(e: JsKeyboardEvent): string =
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`el`.idx].addEventListener(`event`, heap[`handler`.idx]);".}
  else:
    discard

proc jsElementRemoveEventListener*(el: JsElement, event: string, handler: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`el`.idx].removeEventListener(`event`, heap[`handler`.idx]);".}
  else:
    discard

proc jsWindowAddEventListener*(win: JsWindow, event: string, handler: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`win`.idx].addEventListener(`event`, heap[`handler`.idx]);".}
  else:
    discard

# ─── Window ───

proc jsGetWindow*(): JsWindow =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(window)};".}
  else:
    result = JsWindow(JsValue(idx: 0))

proc jsWindowInnerWidth*(win: JsWindow): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`win`.idx].innerWidth;".}
  else:
    result = 0

proc jsWindowInnerHeight*(win: JsWindow): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`win`.idx].innerHeight;".}
  else:
    result = 0

proc jsWindowLocation*(win: JsWindow): JsLocation =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].location)};".}
  else:
    result = JsLocation(JsValue(idx: 0))

proc jsWindowHistory*(win: JsWindow): JsHistory =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].history)};".}
  else:
    result = JsHistory(JsValue(idx: 0))

proc jsWindowLocalStorage*(win: JsWindow): JsStorage =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].localStorage)};".}
  else:
    result = JsStorage(JsValue(idx: 0))

proc jsWindowSessionStorage*(win: JsWindow): JsStorage =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].sessionStorage)};".}
  else:
    result = JsStorage(JsValue(idx: 0))

proc jsWindowFetch*(win: JsWindow, url: string): JsPromise =
  when defined(wasm32):
    {.emit: """
    var u = `url`;
    `result` = {idx: addHeapObject(heap[`win`.idx].fetch(u))};
    """.}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsWindowRequestAnimationFrame*(win: JsWindow, callback: JsValue): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`win`.idx].requestAnimationFrame(heap[`callback`.idx]);".}
  else:
    result = 0

proc jsWindowCancelAnimationFrame*(win: JsWindow, id: int) =
  when defined(wasm32):
    {.emit: "heap[`win`.idx].cancelAnimationFrame(`id`);".}
  else:
    discard

proc jsWindowPerformance*(win: JsWindow): JsPerformance =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`win`.idx].performance)};".}
  else:
    result = JsPerformance(JsValue(idx: 0))

# ─── Canvas ───

proc jsHTMLCanvasElementGetContext*(canvas: JsHTMLCanvasElement, contextType: string): JsCanvasRenderingContext2D =
  when defined(wasm32):
    {.emit: """
    var ctx = heap[`canvas`.idx].getContext(`contextType`);
    `result` = {idx: addHeapObject(ctx)};
    """.}
  else:
    result = JsCanvasRenderingContext2D(JsValue(idx: 0))

proc jsCanvasCtxFillRect*(ctx: JsCanvasRenderingContext2D, x, y, w, h: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].fillRect(`x`, `y`, `w`, `h`);".}
  else:
    discard

proc jsCanvasCtxClearRect*(ctx: JsCanvasRenderingContext2D, x, y, w, h: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].clearRect(`x`, `y`, `w`, `h`);".}
  else:
    discard

proc jsCanvasCtxStrokeRect*(ctx: JsCanvasRenderingContext2D, x, y, w, h: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].strokeRect(`x`, `y`, `w`, `h`);".}
  else:
    discard

proc jsCanvasCtxFillText*(ctx: JsCanvasRenderingContext2D, text: string, x, y: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].fillText(`text`, `x`, `y`);".}
  else:
    discard

proc jsCanvasCtxStrokeText*(ctx: JsCanvasRenderingContext2D, text: string, x, y: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].strokeText(`text`, `x`, `y`);".}
  else:
    discard

proc jsCanvasCtxBeginPath*(ctx: JsCanvasRenderingContext2D) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].beginPath();".}
  else:
    discard

proc jsCanvasCtxClosePath*(ctx: JsCanvasRenderingContext2D) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].closePath();".}
  else:
    discard

proc jsCanvasCtxMoveTo*(ctx: JsCanvasRenderingContext2D, x, y: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].moveTo(`x`, `y`);".}
  else:
    discard

proc jsCanvasCtxLineTo*(ctx: JsCanvasRenderingContext2D, x, y: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].lineTo(`x`, `y`);".}
  else:
    discard

proc jsCanvasCtxArc*(ctx: JsCanvasRenderingContext2D, x, y, r, startAngle, endAngle: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].arc(`x`, `y`, `r`, `startAngle`, `endAngle`);".}
  else:
    discard

proc jsCanvasCtxFill*(ctx: JsCanvasRenderingContext2D) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].fill();".}
  else:
    discard

proc jsCanvasCtxStroke*(ctx: JsCanvasRenderingContext2D) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].stroke();".}
  else:
    discard

proc jsCanvasCtxSetFillStyle*(ctx: JsCanvasRenderingContext2D, color: string) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].fillStyle = `color`;".}
  else:
    discard

proc jsCanvasCtxSetStrokeStyle*(ctx: JsCanvasRenderingContext2D, color: string) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].strokeStyle = `color`;".}
  else:
    discard

proc jsCanvasCtxSetLineWidth*(ctx: JsCanvasRenderingContext2D, width: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].lineWidth = `width`;".}
  else:
    discard

proc jsCanvasCtxSetFont*(ctx: JsCanvasRenderingContext2D, font: string) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].font = `font`;".}
  else:
    discard

proc jsCanvasCtxDrawImage*(ctx: JsCanvasRenderingContext2D, img: JsImageBitmap, x, y: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].drawImage(heap[`img`.idx], `x`, `y`);".}
  else:
    discard

proc jsCanvasCtxSave*(ctx: JsCanvasRenderingContext2D) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].save();".}
  else:
    discard

proc jsCanvasCtxRestore*(ctx: JsCanvasRenderingContext2D) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].restore();".}
  else:
    discard

proc jsCanvasCtxTranslate*(ctx: JsCanvasRenderingContext2D, x, y: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].translate(`x`, `y`);".}
  else:
    discard

proc jsCanvasCtxRotate*(ctx: JsCanvasRenderingContext2D, angle: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].rotate(`angle`);".}
  else:
    discard

proc jsCanvasCtxScale*(ctx: JsCanvasRenderingContext2D, x, y: float64) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].scale(`x`, `y`);".}
  else:
    discard

# ─── Storage ───

proc jsStorageGetItem*(storage: JsStorage, key: string): string =
  when defined(wasm32):
    {.emit: """
    var s = heap[`storage`.idx].getItem(`key`) || '';
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStorageSetItem*(storage: JsStorage, key: string, value: string) =
  when defined(wasm32):
    {.emit: "heap[`storage`.idx].setItem(`key`, `value`);".}
  else:
    discard

proc jsStorageRemoveItem*(storage: JsStorage, key: string) =
  when defined(wasm32):
    {.emit: "heap[`storage`.idx].removeItem(`key`);".}
  else:
    discard

proc jsStorageClear*(storage: JsStorage) =
  when defined(wasm32):
    {.emit: "heap[`storage`.idx].clear();".}
  else:
    discard

proc jsStorageKey*(storage: JsStorage, idx: int): string =
  when defined(wasm32):
    {.emit: """
    var s = heap[`storage`.idx].key(`idx`) || '';
    var len = s.length;
    var ptr = __nbg_malloc(len, 1);
    for (var i = 0; i < len; i++) ptr[i] = s.charCodeAt(i);
    `result` = {Field0: ptr, Field1: len};
    """.}
  else:
    result = ""

proc jsStorageLen*(storage: JsStorage): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`storage`.idx].length;".}
  else:
    result = 0

# ─── WebSocket ───

proc newJsWebSocket*(url: string): JsWebSocket =
  when defined(wasm32):
    {.emit: """
    var u = `url`;
    `result` = {idx: addHeapObject(new WebSocket(u))};
    """.}
  else:
    result = JsWebSocket(JsValue(idx: 0))

proc jsWebSocketSend*(ws: JsWebSocket, data: string) =
  when defined(wasm32):
    {.emit: "heap[`ws`.idx].send(`data`);".}
  else:
    discard

proc jsWebSocketClose*(ws: JsWebSocket, code: int = 1000, reason: string = "") =
  when defined(wasm32):
    {.emit: """
    var r = `reason`;
    if (r === '') {
      heap[`ws`.idx].close(`code`);
    } else {
      heap[`ws`.idx].close(`code`, r);
    }
    """.}
  else:
    discard

proc jsWebSocketReadyState*(ws: JsWebSocket): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`ws`.idx].readyState;".}
  else:
    result = 0

proc jsWebSocketOnOpen*(ws: JsWebSocket, handler: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`ws`.idx].onopen = heap[`handler`.idx];".}
  else:
    discard

proc jsWebSocketOnMessage*(ws: JsWebSocket, handler: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`ws`.idx].onmessage = heap[`handler`.idx];".}
  else:
    discard

proc jsWebSocketOnError*(ws: JsWebSocket, handler: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`ws`.idx].onerror = heap[`handler`.idx];".}
  else:
    discard

proc jsWebSocketOnClose*(ws: JsWebSocket, handler: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`ws`.idx].onclose = heap[`handler`.idx];".}
  else:
    discard

# ─── Fetch API ───

proc newJsRequest*(url: string, init: JsValue = JsValue(idx: 0)): JsRequest =
  when defined(wasm32):
    {.emit: """
    var u = `url`;
    var i = `init`;
    if (i === 0) {
      `result` = {idx: addHeapObject(new Request(u))};
    } else {
      `result` = {idx: addHeapObject(new Request(u, heap[i]))};
    }
    """.}
  else:
    result = JsRequest(JsValue(idx: 0))

proc jsResponseOk*(resp: JsResponse): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`resp`.idx].ok ? 1 : 0;".}
  else:
    result = false

proc jsResponseStatus*(resp: JsResponse): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`resp`.idx].status;".}
  else:
    result = 0

proc jsResponseStatusText*(resp: JsResponse): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].headers)};".}
  else:
    result = JsHeaders(JsValue(idx: 0))

proc jsResponseText*(resp: JsResponse): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].text())};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsResponseJson*(resp: JsResponse): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].json())};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsResponseArrayBuffer*(resp: JsResponse): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].arrayBuffer())};".}
  else:
    result = JsPromise(JsValue(idx: 0))

proc jsResponseBlob*(resp: JsResponse): JsPromise =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`resp`.idx].blob())};".}
  else:
    result = JsPromise(JsValue(idx: 0))

# ─── Location ───

proc jsLocationHref*(loc: JsLocation): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`loc`.idx].href = `url`;".}
  else:
    discard

proc jsLocationPathname*(loc: JsLocation): string =
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`loc`.idx].assign(`url`);".}
  else:
    discard

proc jsLocationReplace*(loc: JsLocation, url: string) =
  when defined(wasm32):
    {.emit: "heap[`loc`.idx].replace(`url`);".}
  else:
    discard

proc jsLocationReload*(loc: JsLocation) =
  when defined(wasm32):
    {.emit: "heap[`loc`.idx].reload();".}
  else:
    discard

# ─── History ───

proc jsHistoryPushState*(hist: JsHistory, state: JsValue, title: string, url: string) =
  when defined(wasm32):
    {.emit: "heap[`hist`.idx].pushState(heap[`state`.idx], `title`, `url`);".}
  else:
    discard

proc jsHistoryReplaceState*(hist: JsHistory, state: JsValue, title: string, url: string) =
  when defined(wasm32):
    {.emit: "heap[`hist`.idx].replaceState(heap[`state`.idx], `title`, `url`);".}
  else:
    discard

proc jsHistoryBack*(hist: JsHistory) =
  when defined(wasm32):
    {.emit: "heap[`hist`.idx].back();".}
  else:
    discard

proc jsHistoryForward*(hist: JsHistory) =
  when defined(wasm32):
    {.emit: "heap[`hist`.idx].forward();".}
  else:
    discard

# ─── Performance ───

proc jsPerformanceNow*(perf: JsPerformance): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`perf`.idx].now();".}
  else:
    result = 0.0

# ─── DOMRect ───

proc jsDOMRectX*(rect: JsDOMRect): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`rect`.idx].x;".}
  else:
    result = 0.0

proc jsDOMRectY*(rect: JsDOMRect): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`rect`.idx].y;".}
  else:
    result = 0.0

proc jsDOMRectWidth*(rect: JsDOMRect): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`rect`.idx].width;".}
  else:
    result = 0.0

proc jsDOMRectHeight*(rect: JsDOMRect): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`rect`.idx].height;".}
  else:
    result = 0.0

# ─── DOMTokenList ───

proc jsDOMTokenListAdd*(list: JsDOMTokenList, token: string) =
  when defined(wasm32):
    {.emit: "heap[`list`.idx].add(`token`);".}
  else:
    discard

proc jsDOMTokenListRemove*(list: JsDOMTokenList, token: string) =
  when defined(wasm32):
    {.emit: "heap[`list`.idx].remove(`token`);".}
  else:
    discard

proc jsDOMTokenListToggle*(list: JsDOMTokenList, token: string): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`list`.idx].toggle(`token`) ? 1 : 0;".}
  else:
    result = false

proc jsDOMTokenListContains*(list: JsDOMTokenList, token: string): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`list`.idx].contains(`token`) ? 1 : 0;".}
  else:
    result = false
