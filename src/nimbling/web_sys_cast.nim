## JsCast bindings for web_sys DOM types
## Provides jsClassName templates and upcast converters.

import runtime
import jscast
import web_sys

# ─── JS class name registry ───
# Override jsClassName per type so dynInto can do instanceof checks.

template jsClassName*(T: typedesc[JsElement]): string = "Element"
template jsClassName*(T: typedesc[JsDocument]): string = "Document"
template jsClassName*(T: typedesc[JsNode]): string = "Node"
template jsClassName*(T: typedesc[JsWindow]): string = "Window"
template jsClassName*(T: typedesc[JsHTMLElement]): string = "HTMLElement"
template jsClassName*(T: typedesc[JsHTMLCanvasElement]): string = "HTMLCanvasElement"
template jsClassName*(T: typedesc[JsHTMLInputElement]): string = "HTMLInputElement"
template jsClassName*(T: typedesc[JsHTMLImageElement]): string = "HTMLImageElement"
template jsClassName*(T: typedesc[JsDocumentFragment]): string = "DocumentFragment"
template jsClassName*(T: typedesc[JsNodeList]): string = "NodeList"
template jsClassName*(T: typedesc[JsCSSStyleDeclaration]): string = "CSSStyleDeclaration"
template jsClassName*(T: typedesc[JsDOMTokenList]): string = "DOMTokenList"
template jsClassName*(T: typedesc[JsDOMRect]): string = "DOMRect"
template jsClassName*(T: typedesc[JsLocation]): string = "Location"
template jsClassName*(T: typedesc[JsHistory]): string = "History"
template jsClassName*(T: typedesc[JsPerformance]): string = "Performance"
template jsClassName*(T: typedesc[JsEvent]): string = "Event"
template jsClassName*(T: typedesc[JsMouseEvent]): string = "MouseEvent"
template jsClassName*(T: typedesc[JsKeyboardEvent]): string = "KeyboardEvent"
template jsClassName*(T: typedesc[JsCanvasRenderingContext2D]): string = "CanvasRenderingContext2D"
template jsClassName*(T: typedesc[JsImageBitmap]): string = "ImageBitmap"
template jsClassName*(T: typedesc[JsStorage]): string = "Storage"
template jsClassName*(T: typedesc[JsWebSocket]): string = "WebSocket"
template jsClassName*(T: typedesc[JsResponse]): string = "Response"
template jsClassName*(T: typedesc[JsRequest]): string = "Request"
template jsClassName*(T: typedesc[JsHeaders]): string = "Headers"

# Web Audio
template jsClassName*(T: typedesc[JsAudioContext]): string = "AudioContext"
template jsClassName*(T: typedesc[JsAudioDestinationNode]): string = "AudioDestinationNode"
template jsClassName*(T: typedesc[JsAudioBuffer]): string = "AudioBuffer"
template jsClassName*(T: typedesc[JsAudioBufferSourceNode]): string = "AudioBufferSourceNode"
template jsClassName*(T: typedesc[JsOscillatorNode]): string = "OscillatorNode"
template jsClassName*(T: typedesc[JsGainNode]): string = "GainNode"
template jsClassName*(T: typedesc[JsBiquadFilterNode]): string = "BiquadFilterNode"
template jsClassName*(T: typedesc[JsAnalyserNode]): string = "AnalyserNode"
template jsClassName*(T: typedesc[JsDelayNode]): string = "DelayNode"
template jsClassName*(T: typedesc[JsChannelMergerNode]): string = "ChannelMergerNode"
template jsClassName*(T: typedesc[JsChannelSplitterNode]): string = "ChannelSplitterNode"
template jsClassName*(T: typedesc[JsMediaStreamAudioSourceNode]): string = "MediaStreamAudioSourceNode"

# ─── Universal converter to JsValue ───
# This enables any distinct JsValue to be passed where raw JsValue is expected.
converter toJsValue*[T](val: T): JsValue = JsValue(val)

# ─── DOM upcast converters ───
# These chain automatically: JsHTMLCanvasElement → JsHTMLElement → JsElement → JsNode → JsValue

converter toJsNode*(val: JsElement): JsNode = JsNode(JsValue(val))
converter toJsNode*(val: JsDocument): JsNode = JsNode(JsValue(val))
converter toJsNode*(val: JsDocumentFragment): JsNode = JsNode(JsValue(val))
converter toJsElement*(val: JsHTMLElement): JsElement = JsElement(JsValue(val))
converter toJsHTMLElement*(val: JsHTMLCanvasElement): JsHTMLElement = JsHTMLElement(JsValue(val))
converter toJsHTMLElement*(val: JsHTMLInputElement): JsHTMLElement = JsHTMLElement(JsValue(val))
converter toJsHTMLElement*(val: JsHTMLImageElement): JsHTMLElement = JsHTMLElement(JsValue(val))
converter toJsEvent*(val: JsMouseEvent): JsEvent = JsEvent(JsValue(val))
converter toJsEvent*(val: JsKeyboardEvent): JsEvent = JsEvent(JsValue(val))
