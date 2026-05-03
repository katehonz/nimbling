## web-sys equivalent for nimbling: bindings to Web APIs (DOM, Events, Canvas, Fetch, etc).
## Mirrors Rust's web-sys crate.

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
    var s = heap[`el`.idx].getAttribute(`name`) || "";
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
    var s = heap[`storage`.idx].getItem(`key`) || "";
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
    var s = heap[`storage`.idx].key(`idx`) || "";
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
    if (r == "") {
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
    if (i == 0) {
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
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(new AudioContext())};".}
  else:
    result = JsAudioContext(JsValue(idx: 0))

proc jsAudioContextDestination*(ctx: JsAudioContext): JsAudioDestinationNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].destination)};".}
  else:
    result = JsAudioDestinationNode(JsValue(idx: 0))

proc jsAudioContextListener*(ctx: JsAudioContext): JsAudioListener =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].listener)};".}
  else:
    result = JsAudioListener(JsValue(idx: 0))

proc jsAudioContextSampleRate*(ctx: JsAudioContext): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`ctx`.idx].sampleRate;".}
  else:
    result = 0.0

proc jsAudioContextCurrentTime*(ctx: JsAudioContext): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`ctx`.idx].currentTime;".}
  else:
    result = 0.0

proc jsAudioContextState*(ctx: JsAudioContext): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].resume();".}
  else:
    discard

proc jsAudioContextSuspend*(ctx: JsAudioContext) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].suspend();".}
  else:
    discard

proc jsAudioContextClose*(ctx: JsAudioContext) =
  when defined(wasm32):
    {.emit: "heap[`ctx`.idx].close();".}
  else:
    discard

proc jsAudioContextCreateOscillator*(ctx: JsAudioContext): JsOscillatorNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createOscillator())};".}
  else:
    result = JsOscillatorNode(JsValue(idx: 0))

proc jsAudioContextCreateGain*(ctx: JsAudioContext): JsGainNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createGain())};".}
  else:
    result = JsGainNode(JsValue(idx: 0))

proc jsAudioContextCreateBiquadFilter*(ctx: JsAudioContext): JsBiquadFilterNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createBiquadFilter())};".}
  else:
    result = JsBiquadFilterNode(JsValue(idx: 0))

proc jsAudioContextCreateAnalyser*(ctx: JsAudioContext): JsAnalyserNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createAnalyser())};".}
  else:
    result = JsAnalyserNode(JsValue(idx: 0))

proc jsAudioContextCreateDelay*(ctx: JsAudioContext, maxDelay: float64 = 1.0): JsDelayNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createDelay(`maxDelay`))};".}
  else:
    result = JsDelayNode(JsValue(idx: 0))

proc jsAudioContextCreateChannelMerger*(ctx: JsAudioContext, count: int = 6): JsChannelMergerNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createChannelMerger(`count`))};".}
  else:
    result = JsChannelMergerNode(JsValue(idx: 0))

proc jsAudioContextCreateChannelSplitter*(ctx: JsAudioContext, count: int = 6): JsChannelSplitterNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createChannelSplitter(`count`))};".}
  else:
    result = JsChannelSplitterNode(JsValue(idx: 0))

proc jsAudioContextCreateBuffer*(ctx: JsAudioContext, channels: int, length: int, sampleRate: float64): JsAudioBuffer =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createBuffer(`channels`, `length`, `sampleRate`))};".}
  else:
    result = JsAudioBuffer(JsValue(idx: 0))

proc jsAudioContextCreateBufferSource*(ctx: JsAudioContext): JsAudioBufferSourceNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createBufferSource())};".}
  else:
    result = JsAudioBufferSourceNode(JsValue(idx: 0))

proc jsAudioContextCreateMediaStreamSource*(ctx: JsAudioContext, stream: JsValue): JsMediaStreamAudioSourceNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createMediaStreamSource(heap[`stream`.idx]))};".}
  else:
    result = JsMediaStreamAudioSourceNode(JsValue(idx: 0))

proc jsAudioContextCreateMediaElementSource*(ctx: JsAudioContext, element: JsValue): JsMediaElementAudioSourceNode =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`ctx`.idx].createMediaElementSource(heap[`element`.idx]))};".}
  else:
    result = JsMediaElementAudioSourceNode(JsValue(idx: 0))

# ─── AudioNode (shared connect/disconnect) ───

proc jsAudioNodeConnect*(source: JsValue, destination: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`source`.idx].connect(heap[`destination`.idx]);".}
  else:
    discard

proc jsAudioNodeDisconnect*(source: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`source`.idx].disconnect();".}
  else:
    discard

# ─── OscillatorNode ───

proc jsOscillatorType*(osc: JsOscillatorNode): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`osc`.idx].type = `t`;".}
  else:
    discard

proc jsOscillatorFrequency*(osc: JsOscillatorNode): JsAudioParam =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`osc`.idx].frequency)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))

proc jsOscillatorDetune*(osc: JsOscillatorNode): JsAudioParam =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`osc`.idx].detune)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))

proc jsOscillatorStart*(osc: JsOscillatorNode, startTime: float64 = 0.0) =
  when defined(wasm32):
    {.emit: "heap[`osc`.idx].start(`startTime`);".}
  else:
    discard

proc jsOscillatorStop*(osc: JsOscillatorNode, stopTime: float64 = 0.0) =
  when defined(wasm32):
    {.emit: "heap[`osc`.idx].stop(`stopTime`);".}
  else:
    discard

# ─── GainNode ───

proc jsGainNodeGain*(node: JsGainNode): JsAudioParam =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].gain)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))

# ─── AudioParam ───

proc jsAudioParamValue*(param: JsAudioParam): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`param`.idx].value;".}
  else:
    result = 0.0

proc `jsAudioParamValue=`*(param: JsAudioParam, val: float64) =
  when defined(wasm32):
    {.emit: "heap[`param`.idx].value = `val`;".}
  else:
    discard

proc jsAudioParamSetValueAtTime*(param: JsAudioParam, value: float64, time: float64) =
  when defined(wasm32):
    {.emit: "heap[`param`.idx].setValueAtTime(`value`, `time`);".}
  else:
    discard

proc jsAudioParamLinearRampToValueAtTime*(param: JsAudioParam, value: float64, time: float64) =
  when defined(wasm32):
    {.emit: "heap[`param`.idx].linearRampToValueAtTime(`value`, `time`);".}
  else:
    discard

proc jsAudioParamExponentialRampToValueAtTime*(param: JsAudioParam, value: float64, time: float64) =
  when defined(wasm32):
    {.emit: "heap[`param`.idx].exponentialRampToValueAtTime(`value`, `time`);".}
  else:
    discard

proc jsAudioParamSetTargetAtTime*(param: JsAudioParam, target: float64, time: float64, tau: float64) =
  when defined(wasm32):
    {.emit: "heap[`param`.idx].setTargetAtTime(`target`, `time`, `tau`);".}
  else:
    discard

proc jsAudioParamCancelScheduledValues*(param: JsAudioParam, time: float64) =
  when defined(wasm32):
    {.emit: "heap[`param`.idx].cancelScheduledValues(`time`);".}
  else:
    discard

# ─── BiquadFilterNode ───

proc jsBiquadFilterType*(node: JsBiquadFilterNode): string =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`node`.idx].type = `t`;".}
  else:
    discard

proc jsBiquadFilterFrequency*(node: JsBiquadFilterNode): JsAudioParam =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].frequency)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))

proc jsBiquadFilterQ*(node: JsBiquadFilterNode): JsAudioParam =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].Q)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))

proc jsBiquadFilterGain*(node: JsBiquadFilterNode): JsAudioParam =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].gain)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))

proc jsBiquadFilterGetFrequencyResponse*(node: JsBiquadFilterNode, freqArray: JsValue, magArray: JsValue, phaseArray: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].getFrequencyResponse(heap[`freqArray`.idx], heap[`magArray`.idx], heap[`phaseArray`.idx]);".}
  else:
    discard

# ─── AnalyserNode ───

proc jsAnalyserFftSize*(node: JsAnalyserNode): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].fftSize;".}
  else:
    result = 0

proc `jsAnalyserFftSize=`*(node: JsAnalyserNode, size: int) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].fftSize = `size`;".}
  else:
    discard

proc jsAnalyserFrequencyBinCount*(node: JsAnalyserNode): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].frequencyBinCount;".}
  else:
    result = 0

proc jsAnalyserGetFloatFrequencyData*(node: JsAnalyserNode, array: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].getFloatFrequencyData(heap[`array`.idx]);".}
  else:
    discard

proc jsAnalyserGetByteFrequencyData*(node: JsAnalyserNode, array: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].getByteFrequencyData(heap[`array`.idx]);".}
  else:
    discard

proc jsAnalyserGetFloatTimeDomainData*(node: JsAnalyserNode, array: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].getFloatTimeDomainData(heap[`array`.idx]);".}
  else:
    discard

proc jsAnalyserGetByteTimeDomainData*(node: JsAnalyserNode, array: JsValue) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].getByteTimeDomainData(heap[`array`.idx]);".}
  else:
    discard

proc jsAnalyserMinDecibels*(node: JsAnalyserNode): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].minDecibels;".}
  else:
    result = 0.0

proc `jsAnalyserMinDecibels=`*(node: JsAnalyserNode, val: float64) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].minDecibels = `val`;".}
  else:
    discard

proc jsAnalyserMaxDecibels*(node: JsAnalyserNode): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].maxDecibels;".}
  else:
    result = 0.0

proc `jsAnalyserMaxDecibels=`*(node: JsAnalyserNode, val: float64) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].maxDecibels = `val`;".}
  else:
    discard

proc jsAnalyserSmoothingTimeConstant*(node: JsAnalyserNode): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].smoothingTimeConstant;".}
  else:
    result = 0.0

proc `jsAnalyserSmoothingTimeConstant=`*(node: JsAnalyserNode, val: float64) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].smoothingTimeConstant = `val`;".}
  else:
    discard

# ─── DelayNode ───

proc jsDelayNodeDelay*(node: JsDelayNode): JsAudioParam =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`node`.idx].delayTime)};".}
  else:
    result = JsAudioParam(JsValue(idx: 0))

# ─── AudioBuffer ───

proc jsAudioBufferDuration*(buf: JsAudioBuffer): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].duration;".}
  else:
    result = 0.0

proc jsAudioBufferLength*(buf: JsAudioBuffer): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].length;".}
  else:
    result = 0

proc jsAudioBufferSampleRate*(buf: JsAudioBuffer): float64 =
  when defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].sampleRate;".}
  else:
    result = 0.0

proc jsAudioBufferNumberOfChannels*(buf: JsAudioBuffer): int =
  when defined(wasm32):
    {.emit: "`result` = heap[`buf`.idx].numberOfChannels;".}
  else:
    result = 0

proc jsAudioBufferGetChannelData*(buf: JsAudioBuffer, channel: int): JsValue =
  when defined(wasm32):
    {.emit: "`result` = {idx: addHeapObject(heap[`buf`.idx].getChannelData(`channel`))};".}
  else:
    result = JsValue(idx: 0)

# ─── AudioBufferSourceNode ───

proc `jsAudioBufferSourceBuffer=`*(node: JsAudioBufferSourceNode, buf: JsAudioBuffer) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].buffer = heap[`buf`.idx];".}
  else:
    discard

proc jsAudioBufferSourceLoop*(node: JsAudioBufferSourceNode): bool =
  when defined(wasm32):
    {.emit: "`result` = heap[`node`.idx].loop ? 1 : 0;".}
  else:
    result = false

proc `jsAudioBufferSourceLoop=`*(node: JsAudioBufferSourceNode, val: bool) =
  when defined(wasm32):
    {.emit: "heap[`node`.idx].loop = `val`;".}
  else:
    discard

proc jsAudioBufferSourceStart*(node: JsAudioBufferSourceNode, startTime: float64 = 0.0, offset: float64 = 0.0, duration: float64 = 0.0) =
  when defined(wasm32):
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
  when defined(wasm32):
    {.emit: "heap[`node`.idx].stop(`stopTime`);".}
  else:
    discard

# ─── AudioListener ───

proc jsAudioListenerSetPosition*(listener: JsAudioListener, x, y, z: float64) =
  when defined(wasm32):
    {.emit: "heap[`listener`.idx].setPosition(`x`, `y`, `z`);".}
  else:
    discard

proc jsAudioListenerSetOrientation*(listener: JsAudioListener, fx, fy, fz, ux, uy, uz: float64) =
  when defined(wasm32):
    {.emit: "heap[`listener`.idx].setOrientation(`fx`, `fy`, `fz`, `ux`, `uy`, `uz`);".}
  else:
    discard
