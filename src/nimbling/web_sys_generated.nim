## Auto-generated WebIDL bindings for nimbling.
import nimbling

type
  AbortController* {.wasmBindgen.} = object
    signal*: AbortSignal

proc abort*(self: AbortController; reason: JsObject): void {.wasmBindgen.}

type
  AbstractRange* {.wasmBindgen.} = object
    startContainer*: Node
    startOffset*: uint32
    endContainer*: Node
    endOffset*: uint32
    collapsed*: bool


type
  AnalyserOptions* {.wasmBindgen.} = object
    fftSize*: uint32
    maxDecibels*: float64
    minDecibels*: float64
    smoothingTimeConstant*: float64

type
  AnalyserNode* {.wasmBindgen.} = object
    fftSize*: uint32
    frequencyBinCount*: uint32
    minDecibels*: float64
    maxDecibels*: float64
    smoothingTimeConstant*: float64

proc getFloatFrequencyData*(self: AnalyserNode; array: seq[float32]): void {.wasmBindgen.}
proc getByteFrequencyData*(self: AnalyserNode; array: seq[uint8]): void {.wasmBindgen.}
proc getFloatTimeDomainData*(self: AnalyserNode; array: seq[float32]): void {.wasmBindgen.}
proc getByteTimeDomainData*(self: AnalyserNode; array: seq[uint8]): void {.wasmBindgen.}

type
  AnimationPlayState* {.wasmBindgen.} = enum
    Idle
    Running
    Paused
    Finished

type
  Animation* {.wasmBindgen.} = object
    id*: cstring
    playbackRate*: float64
    playState*: AnimationPlayState
    pending*: bool
    ready*: JsObject
    finished*: JsObject
    onfinish*: EventHandler
    oncancel*: EventHandler

proc cancel*(self: Animation): void {.wasmBindgen.}
proc finish*(self: Animation): void {.wasmBindgen.}
proc play*(self: Animation): void {.wasmBindgen.}
proc pause*(self: Animation): void {.wasmBindgen.}
proc updatePlaybackRate*(self: Animation; playbackRate: float64): void {.wasmBindgen.}
proc reverse*(self: Animation): void {.wasmBindgen.}

type
  FillMode* {.wasmBindgen.} = enum
    None
    Forwards
    Backwards
    Both
    Auto

type
  PlaybackDirection* {.wasmBindgen.} = enum
    Normal
    Reverse
    Alternate
    Alternate_reverse

type
  EffectTiming* {.wasmBindgen.} = object
    delay*: float64
    endDelay*: float64
    fill*: FillMode
    iterationStart*: float64
    iterations*: float64
    duration*: JsObject
    direction*: PlaybackDirection
    easing*: cstring

type
  OptionalEffectTiming* {.wasmBindgen.} = object
    delay*: float64
    endDelay*: float64
    fill*: FillMode
    iterationStart*: float64
    iterations*: float64
    duration*: JsObject
    direction*: PlaybackDirection
    easing*: cstring

type
  ComputedEffectTiming* {.wasmBindgen.} = object
    endTime*: float64
    activeDuration*: float64

type
  AnimationEffect* {.wasmBindgen.} = object

proc getTiming*(self: AnimationEffect): EffectTiming {.wasmBindgen.}
proc getComputedTiming*(self: AnimationEffect): ComputedEffectTiming {.wasmBindgen.}
proc updateTiming*(self: AnimationEffect; timing: OptionalEffectTiming): void {.wasmBindgen.}

type
  AnimationEvent* {.wasmBindgen.} = object
    animationName*: cstring
    elapsedTime*: float32
    pseudoElement*: cstring


type
  AnimationEventInit* {.wasmBindgen.} = object
    animationName*: cstring
    elapsedTime*: float32
    pseudoElement*: cstring

type
  FrameRequestCallback* = proc

type
  AnimationPlaybackEvent* {.wasmBindgen.} = object


type
  AnimationPlaybackEventInit* {.wasmBindgen.} = object

type
  AnimationTimeline* {.wasmBindgen.} = object


type
  Attr* {.wasmBindgen.} = object
    localName*: cstring
    value*: cstring
    name*: cstring
    specified*: bool


type
  AudioBufferOptions* {.wasmBindgen.} = object
    numberOfChannels*: uint32
    length*: uint32
    sampleRate*: float32

type
  AudioBuffer* {.wasmBindgen.} = object
    sampleRate*: float32
    length*: uint32
    duration*: float64
    numberOfChannels*: uint32

proc getChannelData*(self: AudioBuffer; channel: uint32): seq[float32] {.wasmBindgen.}
proc copyFromChannel*(self: AudioBuffer; destination: seq[float32]; channelNumber: int32; startInChannel: uint32): void {.wasmBindgen.}
proc copyToChannel*(self: AudioBuffer; source: seq[float32]; channelNumber: int32; startInChannel: uint32): void {.wasmBindgen.}

type
  AudioBufferSourceNode* {.wasmBindgen.} = object
    playbackRate*: AudioParam
    detune*: AudioParam
    loop*: bool
    loopStart*: float64
    loopEnd*: float64
    onended*: EventHandler

proc start*(self: AudioBufferSourceNode; whenVal: float64; offset: float64; duration: float64): void {.wasmBindgen.}
proc stop*(self: AudioBufferSourceNode; whenVal: float64): void {.wasmBindgen.}

type
  AudioBufferSourceOptions* {.wasmBindgen.} = object
    detune*: float32
    loop*: bool
    loopEnd*: float64
    loopStart*: float64
    playbackRate*: float32

type
  AudioContextLatencyCategory* {.wasmBindgen.} = enum
    Balanced
    Interactive
    Playback

type
  AudioContextOptions* {.wasmBindgen.} = object
    latencyHint*: JsObject
    sampleRate*: float32

type
  AudioContext* {.wasmBindgen.} = object

proc suspend*(self: AudioContext): JsObject {.wasmBindgen.}
proc close*(self: AudioContext): JsObject {.wasmBindgen.}
proc createMediaElementSource*(self: AudioContext; mediaElement: HTMLMediaElement): MediaElementAudioSourceNode {.wasmBindgen.}
proc createMediaStreamSource*(self: AudioContext; mediaStream: MediaStream): MediaStreamAudioSourceNode {.wasmBindgen.}
proc createMediaStreamDestination*(self: AudioContext): MediaStreamAudioDestinationNode {.wasmBindgen.}

type
  AudioDestinationNode* {.wasmBindgen.} = object
    maxChannelCount*: uint32


type
  AudioListener* {.wasmBindgen.} = object
    dopplerFactor*: float64
    speedOfSound*: float64

proc setPosition*(self: AudioListener; x: float64; y: float64; z: float64): void {.wasmBindgen.}
proc setOrientation*(self: AudioListener; x: float64; y: float64; z: float64; xUp: float64; yUp: float64; zUp: float64): void {.wasmBindgen.}
proc setVelocity*(self: AudioListener; x: float64; y: float64; z: float64): void {.wasmBindgen.}

type
  ChannelCountMode* {.wasmBindgen.} = enum
    Max
    Clamped_max
    Explicit

type
  ChannelInterpretation* {.wasmBindgen.} = enum
    Speakers
    Discrete

type
  AudioNodeOptions* {.wasmBindgen.} = object
    channelCount*: uint32
    channelCountMode*: ChannelCountMode
    channelInterpretation*: ChannelInterpretation

type
  AudioNode* {.wasmBindgen.} = object
    context*: BaseAudioContext
    numberOfInputs*: uint32
    numberOfOutputs*: uint32
    channelCount*: uint32
    channelCountMode*: ChannelCountMode
    channelInterpretation*: ChannelInterpretation

proc connect*(self: AudioNode; destination: AudioNode; output: uint32; input: uint32): AudioNode {.wasmBindgen.}
proc connect*(self: AudioNode; destination: AudioParam; output: uint32): void {.wasmBindgen.}
proc disconnect*(self: AudioNode): void {.wasmBindgen.}
proc disconnect*(self: AudioNode; output: uint32): void {.wasmBindgen.}
proc disconnect*(self: AudioNode; destination: AudioNode): void {.wasmBindgen.}
proc disconnect*(self: AudioNode; destination: AudioNode; output: uint32): void {.wasmBindgen.}
proc disconnect*(self: AudioNode; destination: AudioNode; output: uint32; input: uint32): void {.wasmBindgen.}
proc disconnect*(self: AudioNode; destination: AudioParam): void {.wasmBindgen.}
proc disconnect*(self: AudioNode; destination: AudioParam; output: uint32): void {.wasmBindgen.}

type
  AudioParam* {.wasmBindgen.} = object
    value*: float32
    defaultValue*: float32
    minValue*: float32
    maxValue*: float32

proc setValueAtTime*(self: AudioParam; value: float32; startTime: float64): AudioParam {.wasmBindgen.}
proc linearRampToValueAtTime*(self: AudioParam; value: float32; endTime: float64): AudioParam {.wasmBindgen.}
proc exponentialRampToValueAtTime*(self: AudioParam; value: float32; endTime: float64): AudioParam {.wasmBindgen.}
proc setTargetAtTime*(self: AudioParam; target: float32; startTime: float64; timeConstant: float64): AudioParam {.wasmBindgen.}
proc setValueCurveAtTime*(self: AudioParam; values: seq[float32]; startTime: float64; duration: float64): AudioParam {.wasmBindgen.}
proc cancelScheduledValues*(self: AudioParam; startTime: float64): AudioParam {.wasmBindgen.}

type
  AudioParamMap* {.wasmBindgen.} = object


type
  AudioProcessingEvent* {.wasmBindgen.} = object
    playbackTime*: float64
    inputBuffer*: AudioBuffer
    outputBuffer*: AudioBuffer


type
  AudioScheduledSourceNode* {.wasmBindgen.} = object


type
  AudioStreamTrack* {.wasmBindgen.} = object


type
  AudioTrack* {.wasmBindgen.} = object
    id*: cstring
    kind*: cstring
    label*: cstring
    language*: cstring
    enabled*: bool


type
  AudioTrackList* {.wasmBindgen.} = object
    length*: uint32
    onchange*: EventHandler
    onaddtrack*: EventHandler
    onremovetrack*: EventHandler

proc getTrackById*(self: AudioTrackList; id: cstring): Option[AudioTrack] {.wasmBindgen.}

type
  AudioWorklet* {.wasmBindgen.} = object


type
  AudioWorkletGlobalScope* {.wasmBindgen.} = object
    long*: uint32
    currentTime*: float64
    sampleRate*: float32

proc registerProcessor*(self: AudioWorkletGlobalScope; name: cstring; processorCtor: VoidFunction): void {.wasmBindgen.}

type
  AudioWorkletNodeOptions* {.wasmBindgen.} = object
    numberOfInputs*: uint32
    numberOfOutputs*: uint32
    outputChannelCount*: JsObject
    parameterData*: JsObject

type
  AudioWorkletNode* {.wasmBindgen.} = object
    parameters*: AudioParamMap
    port*: MessagePort
    onprocessorerror*: EventHandler


type
  AudioWorkletProcessor* {.wasmBindgen.} = object
    port*: MessagePort


type
  AutocompleteInfo* {.wasmBindgen.} = object
    section*: cstring
    addressType*: cstring
    contactType*: cstring
    fieldName*: cstring

type
  BarProp* {.wasmBindgen.} = object
    visible*: bool


type
  DecodeSuccessCallback* = proc

type
  DecodeErrorCallback* = proc

type
  AudioContextState* {.wasmBindgen.} = enum
    Suspended
    Running
    Closed

type
  BaseAudioContext* {.wasmBindgen.} = object


type
  CompositeOperation* {.wasmBindgen.} = enum
    Replace
    Add
    Accumulate

type
  BasePropertyIndexedKeyframe* {.wasmBindgen.} = object
    offset*: JsObject
    easing*: JsObject
    composite*: JsObject

type
  BaseKeyframe* {.wasmBindgen.} = object
    easing*: cstring
    simulateComputeValuesFailure*: bool

type
  BaseComputedKeyframe* {.wasmBindgen.} = object
    computedOffset*: float64

type
  BasicCardType* {.wasmBindgen.} = enum
    Credit
    Debit
    Prepaid

type
  BasicCardRequest* {.wasmBindgen.} = object
    supportedNetworks*: JsObject
    supportedTypes*: JsObject

type
  BasicCardResponse* {.wasmBindgen.} = object
    cardholderName*: cstring
    cardNumber*: cstring
    expiryMonth*: cstring
    expiryYear*: cstring
    cardSecurityCode*: cstring

type
  BatteryManager* {.wasmBindgen.} = object
    charging*: bool
    chargingTime*: float64
    dischargingTime*: float64
    level*: float64
    onchargingchange*: EventHandler
    onchargingtimechange*: EventHandler
    ondischargingtimechange*: EventHandler
    onlevelchange*: EventHandler


type
  BeforeUnloadEvent* {.wasmBindgen.} = object
    returnValue*: cstring


type
  BiquadFilterType* {.wasmBindgen.} = enum
    Lowpass
    Highpass
    Bandpass
    Lowshelf
    Highshelf
    Peaking
    Notch
    Allpass

type
  BiquadFilterOptions* {.wasmBindgen.} = object
    typeVal*: BiquadFilterType
    q*: float32
    detune*: float32
    frequency*: float32
    gain*: float32

type
  BiquadFilterNode* {.wasmBindgen.} = object
    typeVal*: BiquadFilterType
    frequency*: AudioParam
    detune*: AudioParam
    q*: AudioParam
    gain*: AudioParam

proc getFrequencyResponse*(self: BiquadFilterNode; frequencyHz: seq[float32]; magResponse: seq[float32]; phaseResponse: seq[float32]): void {.wasmBindgen.}

type
  BlobEvent* {.wasmBindgen.} = object


type
  BlobEventInit* {.wasmBindgen.} = object

type
  BroadcastChannel* {.wasmBindgen.} = object
    name*: cstring
    onmessage*: EventHandler
    onmessageerror*: EventHandler

proc postMessage*(self: BroadcastChannel; message: JsObject): void {.wasmBindgen.}
proc close*(self: BroadcastChannel): void {.wasmBindgen.}

type
  BrowserElementNextPaintEventCallback* = proc

type
  BrowserFindCaseSensitivity* {.wasmBindgen.} = enum
    Case_sensitive
    Case_insensitive

type
  BrowserFindDirection* {.wasmBindgen.} = enum
    Forward
    Backward

type
  BrowserElementDownloadOptions* {.wasmBindgen.} = object

type
  BrowserElementExecuteScriptOptions* {.wasmBindgen.} = object

type
  OpenWindowEventDetail* {.wasmBindgen.} = object
    url*: cstring
    name*: cstring
    features*: cstring

type
  DOMWindowResizeEventDetail* {.wasmBindgen.} = object
    width*: int32
    height*: int32

type
  BrowserFeedWriter* {.wasmBindgen.} = object

proc writeContent*(self: BrowserFeedWriter): void {.wasmBindgen.}
proc close*(self: BrowserFeedWriter): void {.wasmBindgen.}

type
  CDATASection* {.wasmBindgen.} = object


proc CSSVal*() {.wasmBindgen.}
proc supports*(property: cstring; value: cstring): bool {.wasmBindgen.}
proc supports*(conditionText: cstring): bool {.wasmBindgen.}

proc CSSVal*() {.wasmBindgen.}
proc escape*(ident: cstring): cstring {.wasmBindgen.}

type
  CSSAnimation* {.wasmBindgen.} = object
    animationName*: cstring


type
  CSSConditionRule* {.wasmBindgen.} = object
    conditionText*: cstring


type
  CSSCounterStyleRule* {.wasmBindgen.} = object
    name*: cstring
    system*: cstring
    symbols*: cstring
    additiveSymbols*: cstring
    negative*: cstring
    prefix*: cstring
    suffix*: cstring
    range*: cstring
    pad*: cstring
    speakAs*: cstring
    fallback*: cstring


type
  CSSFontFaceRule* {.wasmBindgen.} = object
    style*: CSSStyleDeclaration


type
  CSSFontFeatureValuesRule* {.wasmBindgen.} = object
    fontFamily*: cstring


type
  CSSGroupingRule* {.wasmBindgen.} = object
    cssRules*: CSSRuleList

proc insertRule*(self: CSSGroupingRule; rule: cstring; index: uint32): uint32 {.wasmBindgen.}
proc deleteRule*(self: CSSGroupingRule; index: uint32): void {.wasmBindgen.}

type
  CSSImportRule* {.wasmBindgen.} = object
    href*: cstring


type
  CSSKeyframeRule* {.wasmBindgen.} = object
    keyText*: cstring
    style*: CSSStyleDeclaration


type
  CSSKeyframesRule* {.wasmBindgen.} = object
    name*: cstring
    cssRules*: CSSRuleList

proc appendRule*(self: CSSKeyframesRule; rule: cstring): void {.wasmBindgen.}
proc deleteRule*(self: CSSKeyframesRule; select: cstring): void {.wasmBindgen.}
proc findRule*(self: CSSKeyframesRule; select: cstring): Option[CSSKeyframeRule] {.wasmBindgen.}

type
  CSSMediaRule* {.wasmBindgen.} = object
    media*: MediaList


type
  CSSNamespaceRule* {.wasmBindgen.} = object
    namespaceURI*: cstring
    prefix*: cstring


type
  CSSPageRule* {.wasmBindgen.} = object
    style*: CSSStyleDeclaration


type
  CSSPseudoElement* {.wasmBindgen.} = object
    typeVal*: cstring
    parentElement*: Element


type
  CSSRule* {.wasmBindgen.} = object
    sTYLE_RULE*: uint16
    cHARSET_RULE*: uint16
    iMPORT_RULE*: uint16
    mEDIA_RULE*: uint16
    fONT_FACE_RULE*: uint16
    pAGE_RULE*: uint16
    nAMESPACE_RULE*: uint16
    typeVal*: uint16
    cssText*: cstring


type
  CSSRuleList* {.wasmBindgen.} = object
    length*: uint32
    cSSRule*: getter

proc item*(self: CSSRuleList; index: uint32): Option[] {.wasmBindgen.}

type
  CSSStyleRule* {.wasmBindgen.} = object
    selectorText*: cstring
    style*: CSSStyleDeclaration


type
  CSSStyleSheetParsingMode* {.wasmBindgen.} = enum
    Author
    User
    Agent

type
  CSSStyleSheet* {.wasmBindgen.} = object
    cssRules*: CSSRuleList
    parsingMode*: CSSStyleSheetParsingMode

proc insertRule*(self: CSSStyleSheet; rule: cstring; index: uint32): uint32 {.wasmBindgen.}
proc deleteRule*(self: CSSStyleSheet; index: uint32): void {.wasmBindgen.}
proc replace*(self: CSSStyleSheet; text: cstring): JsObject {.wasmBindgen.}
proc replaceSync*(self: CSSStyleSheet; text: cstring): void {.wasmBindgen.}

type
  CSSSupportsRule* {.wasmBindgen.} = object


type
  CSSTransition* {.wasmBindgen.} = object
    transitionProperty*: cstring


type
  Cache* {.wasmBindgen.} = object

proc match*(self: Cache; request: RequestInfo; options: CacheQueryOptions): JsObject {.wasmBindgen.}
proc matchAll*(self: Cache; request: RequestInfo; options: CacheQueryOptions): JsObject {.wasmBindgen.}
proc add*(self: Cache; request: RequestInfo): JsObject {.wasmBindgen.}
proc addAll*(self: Cache; requests: JsObject): JsObject {.wasmBindgen.}
proc put*(self: Cache; request: RequestInfo; response: Response): JsObject {.wasmBindgen.}
proc delete*(self: Cache; request: RequestInfo; options: CacheQueryOptions): JsObject {.wasmBindgen.}
proc keys*(self: Cache; request: RequestInfo; options: CacheQueryOptions): JsObject {.wasmBindgen.}

type
  CacheQueryOptions* {.wasmBindgen.} = object
    ignoreSearch*: bool
    ignoreMethod*: bool
    ignoreVary*: bool
    cacheName*: cstring

type
  CacheBatchOperation* {.wasmBindgen.} = object
    typeVal*: cstring
    request*: Request
    response*: Response
    options*: CacheQueryOptions

type
  CacheStorage* {.wasmBindgen.} = object

proc match*(self: CacheStorage; request: RequestInfo; options: CacheQueryOptions): JsObject {.wasmBindgen.}
proc has*(self: CacheStorage; cacheName: cstring): JsObject {.wasmBindgen.}
proc open*(self: CacheStorage; cacheName: cstring): JsObject {.wasmBindgen.}
proc delete*(self: CacheStorage; cacheName: cstring): JsObject {.wasmBindgen.}
proc keys*(self: CacheStorage): JsObject {.wasmBindgen.}

type
  CacheStorageNamespace* {.wasmBindgen.} = enum
    Content
    Chrome

type
  CanvasCaptureMediaStream* {.wasmBindgen.} = object
    canvas*: HTMLCanvasElement

proc requestFrame*(self: CanvasCaptureMediaStream): void {.wasmBindgen.}

type
  CanvasCaptureMediaStreamTrack* {.wasmBindgen.} = object
    canvas*: HTMLCanvasElement

proc requestFrame*(self: CanvasCaptureMediaStreamTrack): void {.wasmBindgen.}

type
  CanvasWindingRule* {.wasmBindgen.} = enum
    Nonzero
    Evenodd

type
  ContextAttributes2D* {.wasmBindgen.} = object
    willReadFrequently*: bool
    alpha*: bool

type
  HitRegionOptions* {.wasmBindgen.} = object
    id*: cstring

type
  HTMLOrSVGImageElement* = JsObject

type
  CanvasImageSource* = JsObject

type
  CanvasRenderingContext2D* {.wasmBindgen.} = object
    dRAWWINDOW_DRAW_CARET*: uint32
    dRAWWINDOW_DO_NOT_FLUSH*: uint32
    dRAWWINDOW_DRAW_VIEW*: uint32
    dRAWWINDOW_USE_WIDGET_LAYERS*: uint32
    dRAWWINDOW_ASYNC_DECODE_IMAGES*: uint32

proc drawWindow*(self: CanvasRenderingContext2D; window: Window; x: float64; y: float64; w: float64; h: float64; bgColor: cstring; flags: uint32): void {.wasmBindgen.}
proc demote*(self: CanvasRenderingContext2D): void {.wasmBindgen.}

type
  CanvasGradient* {.wasmBindgen.} = object

proc addColorStop*(self: CanvasGradient; offset: float32; color: cstring): void {.wasmBindgen.}

type
  CanvasPattern* {.wasmBindgen.} = object

proc setTransform*(self: CanvasPattern; matrix: SVGMatrix): void {.wasmBindgen.}

type
  TextMetrics* {.wasmBindgen.} = object
    width*: float64
    actualBoundingBoxLeft*: float64
    actualBoundingBoxRight*: float64
    fontBoundingBoxAscent*: float64
    fontBoundingBoxDescent*: float64
    actualBoundingBoxAscent*: float64
    actualBoundingBoxDescent*: float64


type
  Path2D* {.wasmBindgen.} = object

proc addPath*(self: Path2D; path: Path2D; transformation: SVGMatrix): void {.wasmBindgen.}

type
  CaretPosition* {.wasmBindgen.} = object
    offset*: uint32


type
  CaretChangedReason* {.wasmBindgen.} = enum
    Visibilitychange
    Updateposition
    Longpressonemptycontent
    Taponcaret
    Presscaret
    Releasecaret
    Scroll

type
  CaretStateChangedEventInit* {.wasmBindgen.} = object
    collapsed*: bool
    reason*: CaretChangedReason
    caretVisible*: bool
    caretVisuallyVisible*: bool
    selectionVisible*: bool
    selectionEditable*: bool
    selectedTextContent*: cstring

type
  CaretStateChangedEvent* {.wasmBindgen.} = object
    collapsed*: bool
    reason*: CaretChangedReason
    caretVisible*: bool
    caretVisuallyVisible*: bool
    selectionVisible*: bool
    selectionEditable*: bool
    selectedTextContent*: cstring


type
  ChannelMergerOptions* {.wasmBindgen.} = object
    numberOfInputs*: uint32

type
  ChannelMergerNode* {.wasmBindgen.} = object


type
  ChannelSplitterOptions* {.wasmBindgen.} = object
    numberOfOutputs*: uint32

type
  ChannelSplitterNode* {.wasmBindgen.} = object


type
  CharacterData* {.wasmBindgen.} = object
    data*: cstring
    length*: uint32

proc substringData*(self: CharacterData; offset: uint32; count: uint32): cstring {.wasmBindgen.}
proc appendData*(self: CharacterData; data: cstring): void {.wasmBindgen.}
proc insertData*(self: CharacterData; offset: uint32; data: cstring): void {.wasmBindgen.}
proc deleteData*(self: CharacterData; offset: uint32; count: uint32): void {.wasmBindgen.}
proc replaceData*(self: CharacterData; offset: uint32; count: uint32; data: cstring): void {.wasmBindgen.}

type
  CheckerboardReason* {.wasmBindgen.} = enum
    Severe
    Recent

type
  CheckerboardReport* {.wasmBindgen.} = object
    severity*: uint32
    timestamp*: DOMTimeStamp
    log*: cstring
    reason*: CheckerboardReason

type
  CheckerboardReportService* {.wasmBindgen.} = object

proc getReports*(self: CheckerboardReportService): JsObject {.wasmBindgen.}
proc isRecordingEnabled*(self: CheckerboardReportService): bool {.wasmBindgen.}
proc setRecordingEnabled*(self: CheckerboardReportService; aEnabled: bool): void {.wasmBindgen.}
proc flushActiveReports*(self: CheckerboardReportService): void {.wasmBindgen.}

type
  Client* {.wasmBindgen.} = object
    url*: cstring
    frameType*: FrameType
    typeVal*: ClientType
    id*: cstring

proc postMessage*(self: Client; message: JsObject; transfer: JsObject): void {.wasmBindgen.}

type
  WindowClient* {.wasmBindgen.} = object
    visibilityState*: VisibilityState
    focused*: bool

proc focus*(self: WindowClient): JsObject {.wasmBindgen.}
proc navigate*(self: WindowClient; url: cstring): JsObject {.wasmBindgen.}

type
  FrameType* {.wasmBindgen.} = enum
    Auxiliary
    Top_level
    Nested
    None

type
  Clients* {.wasmBindgen.} = object

proc get*(self: Clients; id: cstring): JsObject {.wasmBindgen.}
proc matchAll*(self: Clients; options: ClientQueryOptions): JsObject {.wasmBindgen.}
proc openWindow*(self: Clients; url: cstring): JsObject {.wasmBindgen.}
proc claim*(self: Clients): JsObject {.wasmBindgen.}

type
  ClientQueryOptions* {.wasmBindgen.} = object
    includeUncontrolled*: bool
    typeVal*: ClientType

type
  ClientType* {.wasmBindgen.} = enum
    Window
    Worker
    Sharedworker
    Serviceworker
    All

type
  ClipboardEventInit* {.wasmBindgen.} = object

type
  ClipboardEvent* {.wasmBindgen.} = object


type
  ClipboardItemData* = JsObject

type
  ClipboardItem* {.wasmBindgen.} = object
    presentationStyle*: PresentationStyle
    types*: JsObject

proc getType*(self: ClipboardItem; typeVal: cstring): JsObject {.wasmBindgen.}
proc supports*(self: typedesc[ClipboardItem]; typeVal: cstring): bool {.wasmBindgen.}

type
  PresentationStyle* {.wasmBindgen.} = enum
    Unspecified
    Inline
    Attachment

type
  ClipboardItemOptions* {.wasmBindgen.} = object
    presentationStyle*: PresentationStyle

type
  ClipboardItems* = JsObject

type
  Clipboard* {.wasmBindgen.} = object

proc read*(self: Clipboard; formats: ClipboardUnsanitizedFormats): JsObject {.wasmBindgen.}
proc readText*(self: Clipboard): JsObject {.wasmBindgen.}
proc write*(self: Clipboard; data: ClipboardItems): JsObject {.wasmBindgen.}
proc writeText*(self: Clipboard; data: cstring): JsObject {.wasmBindgen.}

type
  CloseEvent* {.wasmBindgen.} = object
    wasClean*: bool
    code*: uint16
    reason*: cstring


type
  CloseEventInit* {.wasmBindgen.} = object
    wasClean*: bool
    code*: uint16
    reason*: cstring

type
  CommandEvent* {.wasmBindgen.} = object
    command*: cstring


type
  CommandEventInit* {.wasmBindgen.} = object
    command*: cstring

type
  Comment* {.wasmBindgen.} = object


type
  CompositionEvent* {.wasmBindgen.} = object
    locale*: cstring
    ranges*: JsObject


type
  CompositionEventInit* {.wasmBindgen.} = object
    data*: cstring

type
  ConstantSourceOptions* {.wasmBindgen.} = object
    offset*: float32

type
  ConstantSourceNode* {.wasmBindgen.} = object
    offset*: AudioParam


type
  ConvolverOptions* {.wasmBindgen.} = object
    disableNormalization*: bool

type
  ConvolverNode* {.wasmBindgen.} = object
    normalize*: bool


type
  CookieStore* {.wasmBindgen.} = object
    onchange*: EventHandler

proc get*(self: CookieStore; name: cstring): JsObject {.wasmBindgen.}
proc get*(self: CookieStore; options: CookieStoreGetOptions): JsObject {.wasmBindgen.}
proc getAll*(self: CookieStore; name: cstring): JsObject {.wasmBindgen.}
proc getAll*(self: CookieStore; options: CookieStoreGetOptions): JsObject {.wasmBindgen.}
proc set*(self: CookieStore; name: cstring; value: cstring): JsObject {.wasmBindgen.}
proc set*(self: CookieStore; options: CookieInit): JsObject {.wasmBindgen.}
proc delete*(self: CookieStore; name: cstring): JsObject {.wasmBindgen.}
proc delete*(self: CookieStore; options: CookieStoreDeleteOptions): JsObject {.wasmBindgen.}

type
  CookieStoreGetOptions* {.wasmBindgen.} = object
    name*: cstring
    url*: cstring

type
  CookieSameSite* {.wasmBindgen.} = enum
    Strict
    Lax
    None

type
  CookieInit* {.wasmBindgen.} = object
    name*: cstring
    value*: cstring
    path*: cstring
    sameSite*: CookieSameSite
    partitioned*: bool

type
  CookieStoreDeleteOptions* {.wasmBindgen.} = object
    name*: cstring
    path*: cstring
    partitioned*: bool

type
  CookieListItem* {.wasmBindgen.} = object
    name*: cstring
    value*: cstring

type
  CookieList* = JsObject

type
  CookieStoreManager* {.wasmBindgen.} = object

proc subscribe*(self: CookieStoreManager; subscriptions: JsObject): JsObject {.wasmBindgen.}
proc getSubscriptions*(self: CookieStoreManager): JsObject {.wasmBindgen.}
proc unsubscribe*(self: CookieStoreManager; subscriptions: JsObject): JsObject {.wasmBindgen.}

type
  CookieChangeEvent* {.wasmBindgen.} = object
    changed*: JsObject
    deleted*: JsObject


type
  CookieChangeEventInit* {.wasmBindgen.} = object
    changed*: CookieList
    deleted*: CookieList

type
  ExtendableCookieChangeEvent* {.wasmBindgen.} = object
    changed*: JsObject
    deleted*: JsObject


type
  ExtendableCookieChangeEventInit* {.wasmBindgen.} = object
    changed*: CookieList
    deleted*: CookieList

type
  Coordinates* {.wasmBindgen.} = object
    latitude*: float64
    longitude*: float64
    accuracy*: float64


type
  CreateOfferRequest* {.wasmBindgen.} = object
    long*: uint32
    long*: uint32
    callID*: cstring
    isSecure*: bool


type
  Credential* {.wasmBindgen.} = object
    id*: cstring
    typeVal*: cstring


type
  CredentialsContainer* {.wasmBindgen.} = object

proc get*(self: CredentialsContainer; options: CredentialRequestOptions): JsObject {.wasmBindgen.}
proc create*(self: CredentialsContainer; options: CredentialCreationOptions): JsObject {.wasmBindgen.}
proc store*(self: CredentialsContainer; credential: Credential): JsObject {.wasmBindgen.}
proc preventSilentAccess*(self: CredentialsContainer): JsObject {.wasmBindgen.}

type
  CredentialRequestOptions* {.wasmBindgen.} = object
    signal*: AbortSignal

type
  CredentialCreationOptions* {.wasmBindgen.} = object
    signal*: AbortSignal

type
  Crypto* {.wasmBindgen.} = object
    subtle*: SubtleCrypto

proc getRandomValues*(self: Crypto; array: JsObject): JsObject {.wasmBindgen.}
proc randomUUID*(self: Crypto): cstring {.wasmBindgen.}

type
  CustomElementRegistry* {.wasmBindgen.} = object

proc define*(self: CustomElementRegistry; name: cstring; functionConstructor: Function; options: ElementDefinitionOptions): void {.wasmBindgen.}
proc setElementCreationCallback*(self: CustomElementRegistry; name: cstring; callback: CustomElementCreationCallback): void {.wasmBindgen.}
proc get*(self: CustomElementRegistry; name: cstring): JsObject {.wasmBindgen.}
proc whenDefined*(self: CustomElementRegistry; name: cstring): JsObject {.wasmBindgen.}
proc upgrade*(self: CustomElementRegistry; root: Node): void {.wasmBindgen.}

type
  ElementDefinitionOptions* {.wasmBindgen.} = object
    extends*: cstring

type
  CustomElementCreationCallback* = proc

type
  CustomEvent* {.wasmBindgen.} = object
    detail*: JsObject

proc initCustomEvent*(self: CustomEvent; typeVal: cstring; canBubble: bool; cancelable: bool; detail: JsObject): void {.wasmBindgen.}

type
  CustomEventInit* {.wasmBindgen.} = object
    detail*: JsObject

type
  DOMError* {.wasmBindgen.} = object
    name*: cstring
    message*: cstring


type
  DOMHighResTimeStamp* = JsObject

type
  DOMImplementation* {.wasmBindgen.} = object

proc hasFeature*(self: DOMImplementation): bool {.wasmBindgen.}
proc createDocumentType*(self: DOMImplementation; qualifiedName: cstring; publicId: cstring; systemId: cstring): DocumentType {.wasmBindgen.}
proc createDocument*(self: DOMImplementation; namespace: Option[cstring]; qualifiedName: cstring; doctype: Option[DocumentType]): Document {.wasmBindgen.}
proc createHTMLDocument*(self: DOMImplementation; title: cstring): Document {.wasmBindgen.}

type
  DOMMatrixReadOnly* {.wasmBindgen.} = object
    a*: float64
    b*: float64
    c*: float64
    d*: float64
    e*: float64
    f*: float64
    m11*: float64
    m12*: float64
    m13*: float64
    m14*: float64
    m21*: float64
    m22*: float64
    m23*: float64
    m24*: float64
    m31*: float64
    m32*: float64
    m33*: float64
    m34*: float64
    m41*: float64
    m42*: float64
    m43*: float64
    m44*: float64
    is2D*: bool
    isIdentity*: bool

proc translate*(self: DOMMatrixReadOnly; tx: float64; ty: float64; tz: float64): DOMMatrix {.wasmBindgen.}
proc scale*(self: DOMMatrixReadOnly; scale: float64; originX: float64; originY: float64): DOMMatrix {.wasmBindgen.}
proc scale3d*(self: DOMMatrixReadOnly; scale: float64; originX: float64; originY: float64; originZ: float64): DOMMatrix {.wasmBindgen.}
proc scaleNonUniform*(self: DOMMatrixReadOnly; scaleX: float64; scaleY: float64; scaleZ: float64; originX: float64; originY: float64; originZ: float64): DOMMatrix {.wasmBindgen.}
proc rotate*(self: DOMMatrixReadOnly; angle: float64; originX: float64; originY: float64): DOMMatrix {.wasmBindgen.}
proc rotateFromVector*(self: DOMMatrixReadOnly; x: float64; y: float64): DOMMatrix {.wasmBindgen.}
proc rotateAxisAngle*(self: DOMMatrixReadOnly; x: float64; y: float64; z: float64; angle: float64): DOMMatrix {.wasmBindgen.}
proc skewX*(self: DOMMatrixReadOnly; sx: float64): DOMMatrix {.wasmBindgen.}
proc skewY*(self: DOMMatrixReadOnly; sy: float64): DOMMatrix {.wasmBindgen.}
proc multiply*(self: DOMMatrixReadOnly; other: DOMMatrix): DOMMatrix {.wasmBindgen.}
proc flipX*(self: DOMMatrixReadOnly): DOMMatrix {.wasmBindgen.}
proc flipY*(self: DOMMatrixReadOnly): DOMMatrix {.wasmBindgen.}
proc inverse*(self: DOMMatrixReadOnly): DOMMatrix {.wasmBindgen.}
proc transformPoint*(self: DOMMatrixReadOnly; point: DOMPointInit): DOMPoint {.wasmBindgen.}
proc toFloat32Array*(self: DOMMatrixReadOnly): seq[float32] {.wasmBindgen.}
proc toFloat64Array*(self: DOMMatrixReadOnly): seq[float64] {.wasmBindgen.}
proc toJSON*(self: DOMMatrixReadOnly): JsObject {.wasmBindgen.}

type
  DOMMatrix* {.wasmBindgen.} = object
    attribute*: inherit
    a*: float64
    attribute*: inherit
    b*: float64
    attribute*: inherit
    c*: float64
    attribute*: inherit
    d*: float64
    attribute*: inherit
    e*: float64
    attribute*: inherit
    f*: float64
    attribute*: inherit
    m11*: float64
    attribute*: inherit
    m12*: float64
    attribute*: inherit
    m13*: float64
    attribute*: inherit
    m14*: float64
    attribute*: inherit
    m21*: float64
    attribute*: inherit
    m22*: float64
    attribute*: inherit
    m23*: float64
    attribute*: inherit
    m24*: float64
    attribute*: inherit
    m31*: float64
    attribute*: inherit
    m32*: float64
    attribute*: inherit
    m33*: float64
    attribute*: inherit
    m34*: float64
    attribute*: inherit
    m41*: float64
    attribute*: inherit
    m42*: float64
    attribute*: inherit
    m43*: float64
    attribute*: inherit
    m44*: float64

proc multiplySelf*(self: DOMMatrix; other: DOMMatrix): DOMMatrix {.wasmBindgen.}
proc preMultiplySelf*(self: DOMMatrix; other: DOMMatrix): DOMMatrix {.wasmBindgen.}
proc translateSelf*(self: DOMMatrix; tx: float64; ty: float64; tz: float64): DOMMatrix {.wasmBindgen.}
proc scaleSelf*(self: DOMMatrix; scale: float64; originX: float64; originY: float64): DOMMatrix {.wasmBindgen.}
proc scale3dSelf*(self: DOMMatrix; scale: float64; originX: float64; originY: float64; originZ: float64): DOMMatrix {.wasmBindgen.}
proc scaleNonUniformSelf*(self: DOMMatrix; scaleX: float64; scaleY: float64; scaleZ: float64; originX: float64; originY: float64; originZ: float64): DOMMatrix {.wasmBindgen.}
proc rotateSelf*(self: DOMMatrix; angle: float64; originX: float64; originY: float64): DOMMatrix {.wasmBindgen.}
proc rotateFromVectorSelf*(self: DOMMatrix; x: float64; y: float64): DOMMatrix {.wasmBindgen.}
proc rotateAxisAngleSelf*(self: DOMMatrix; x: float64; y: float64; z: float64; angle: float64): DOMMatrix {.wasmBindgen.}
proc skewXSelf*(self: DOMMatrix; sx: float64): DOMMatrix {.wasmBindgen.}
proc skewYSelf*(self: DOMMatrix; sy: float64): DOMMatrix {.wasmBindgen.}
proc invertSelf*(self: DOMMatrix): DOMMatrix {.wasmBindgen.}
proc setMatrixValue*(self: DOMMatrix; transformList: cstring): DOMMatrix {.wasmBindgen.}

type
  DOMMatrix2DInit* {.wasmBindgen.} = object
    a*: float64
    b*: float64
    c*: float64
    d*: float64
    e*: float64
    f*: float64
    m11*: float64
    m12*: float64
    m21*: float64
    m22*: float64
    m41*: float64
    m42*: float64

type
  DOMMatrixInit* {.wasmBindgen.} = object
    m13*: float64
    m14*: float64
    m23*: float64
    m24*: float64
    m31*: float64
    m32*: float64
    m33*: float64
    m34*: float64
    m43*: float64
    m44*: float64
    is2D*: bool

type
  SupportedType* {.wasmBindgen.} = enum
    Text_html
    Text_xml
    Application_xml
    Application_xhtml_xml
    Image_svg_xml

type
  DOMParser* {.wasmBindgen.} = object

proc parseFromString*(self: DOMParser; str: cstring; typeVal: SupportedType): Document {.wasmBindgen.}
proc forceEnableXULXBL*(self: DOMParser): void {.wasmBindgen.}

type
  DOMPointReadOnly* {.wasmBindgen.} = object
    x*: float64
    y*: float64
    z*: float64
    w*: float64

proc fromPoint*(self: typedesc[DOMPointReadOnly]; other: DOMPointInit): DOMPointReadOnly {.wasmBindgen.}
proc matrixTransform*(self: DOMPointReadOnly; matrix: DOMMatrixInit): DOMPoint {.wasmBindgen.}
proc toJSON*(self: DOMPointReadOnly): JsObject {.wasmBindgen.}

type
  DOMPoint* {.wasmBindgen.} = object
    attribute*: inherit
    x*: float64
    attribute*: inherit
    y*: float64
    attribute*: inherit
    z*: float64
    attribute*: inherit
    w*: float64

proc fromPoint*(self: typedesc[DOMPoint]; other: DOMPointInit): DOMPoint {.wasmBindgen.}

type
  DOMPointInit* {.wasmBindgen.} = object
    x*: float64
    y*: float64
    z*: float64
    w*: float64

type
  DOMQuad* {.wasmBindgen.} = object
    p1*: DOMPoint
    p2*: DOMPoint
    p3*: DOMPoint
    p4*: DOMPoint
    bounds*: DOMRectReadOnly

proc getBounds*(self: DOMQuad): DOMRectReadOnly {.wasmBindgen.}
proc toJSON*(self: DOMQuad): DOMQuadJSON {.wasmBindgen.}

type
  DOMQuadJSON* {.wasmBindgen.} = object
    p1*: DOMPoint
    p2*: DOMPoint
    p3*: DOMPoint
    p4*: DOMPoint

type
  DOMQuadInit* {.wasmBindgen.} = object
    p1*: DOMPointInit
    p2*: DOMPointInit
    p3*: DOMPointInit
    p4*: DOMPointInit

type
  DOMRect* {.wasmBindgen.} = object
    attribute*: inherit
    x*: float64
    attribute*: inherit
    y*: float64
    attribute*: inherit
    width*: float64
    attribute*: inherit
    height*: float64


type
  DOMRectReadOnly* {.wasmBindgen.} = object
    x*: float64
    y*: float64
    width*: float64
    height*: float64
    top*: float64
    right*: float64
    bottom*: float64
    left*: float64

proc toJSON*(self: DOMRectReadOnly): JsObject {.wasmBindgen.}

type
  DOMRectInit* {.wasmBindgen.} = object
    x*: float64
    y*: float64
    width*: float64
    height*: float64

type
  DOMRectList* {.wasmBindgen.} = object
    length*: uint32
    dOMRect*: getter

proc item*(self: DOMRectList; index: uint32): Option[] {.wasmBindgen.}

type
  DOMStringList* {.wasmBindgen.} = object
    length*: uint32
    dOMString*: getter

proc item*(self: DOMStringList; index: uint32): Option[] {.wasmBindgen.}
proc contains*(self: DOMStringList; string: cstring): bool {.wasmBindgen.}

type
  DOMStringMap* {.wasmBindgen.} = object


type
  DataTransfer* {.wasmBindgen.} = object
    dropEffect*: cstring
    effectAllowed*: cstring
    items*: DataTransferItemList
    types*: JsObject

proc setDragImage*(self: DataTransfer; image: Element; x: int32; y: int32): void {.wasmBindgen.}
proc getData*(self: DataTransfer; format: cstring): cstring {.wasmBindgen.}
proc setData*(self: DataTransfer; format: cstring; data: cstring): void {.wasmBindgen.}
proc clearData*(self: DataTransfer; format: cstring): void {.wasmBindgen.}

type
  DataTransferItem* {.wasmBindgen.} = object
    kind*: cstring
    typeVal*: cstring

proc getAsString*(self: DataTransferItem; _callback: Option[FunctionStringCallback]): void {.wasmBindgen.}
proc getAsFile*(self: DataTransferItem): Option[File] {.wasmBindgen.}

type
  FunctionStringCallback* = proc

type
  DataTransferItemList* {.wasmBindgen.} = object
    length*: uint32

proc add*(self: DataTransferItemList; data: cstring; typeVal: cstring): Option[DataTransferItem] {.wasmBindgen.}
proc add*(self: DataTransferItemList; data: File): Option[DataTransferItem] {.wasmBindgen.}
proc remove*(self: DataTransferItemList; index: uint32): void {.wasmBindgen.}
proc clear*(self: DataTransferItemList): void {.wasmBindgen.}

type
  DecoderDoctorNotificationType* {.wasmBindgen.} = enum
    Cannot_play
    Platform_decoder_not_found
    Can_play_but_some_missing_decoders
    Cannot_initialize_pulseaudio
    Unsupported_libavcodec
    Decode_error
    Decode_warning

type
  DecoderDoctorNotification* {.wasmBindgen.} = object
    typeVal*: DecoderDoctorNotificationType
    isSolved*: bool
    decoderDoctorReportId*: cstring
    formats*: cstring
    decodeIssue*: cstring
    docURL*: cstring
    resourceURL*: cstring

type
  DedicatedWorkerGlobalScope* {.wasmBindgen.} = object
    name*: cstring
    onmessage*: EventHandler
    onmessageerror*: EventHandler

proc postMessage*(self: DedicatedWorkerGlobalScope; message: JsObject; transfer: JsObject): void {.wasmBindgen.}
proc close*(self: DedicatedWorkerGlobalScope): void {.wasmBindgen.}

type
  DelayOptions* {.wasmBindgen.} = object
    maxDelayTime*: float64
    delayTime*: float64

type
  DelayNode* {.wasmBindgen.} = object
    delayTime*: AudioParam


type
  DeviceLightEvent* {.wasmBindgen.} = object
    value*: float64


type
  DeviceLightEventInit* {.wasmBindgen.} = object
    value*: float64

type
  DeviceAcceleration* {.wasmBindgen.} = object


type
  DeviceRotationRate* {.wasmBindgen.} = object


type
  DeviceMotionEvent* {.wasmBindgen.} = object


type
  DeviceAccelerationInit* {.wasmBindgen.} = object

type
  DeviceRotationRateInit* {.wasmBindgen.} = object

type
  DeviceMotionEventInit* {.wasmBindgen.} = object
    acceleration*: DeviceAccelerationInit
    accelerationIncludingGravity*: DeviceAccelerationInit
    rotationRate*: DeviceRotationRateInit

type
  DeviceOrientationEvent* {.wasmBindgen.} = object
    absolute*: bool

proc initDeviceOrientationEvent*(self: DeviceOrientationEvent; typeVal: cstring; canBubble: bool; cancelable: bool; alpha: Option[float64]; beta: Option[float64]; gamma: Option[float64]; absolute: bool): void {.wasmBindgen.}

type
  DeviceOrientationEventInit* {.wasmBindgen.} = object
    absolute*: bool

type
  DeviceProximityEvent* {.wasmBindgen.} = object
    value*: float64
    min*: float64
    max*: float64


type
  DeviceProximityEventInit* {.wasmBindgen.} = object
    value*: float64
    min*: float64
    max*: float64

type
  Directory* {.wasmBindgen.} = object
    name*: cstring


type
  DocumentFragment* {.wasmBindgen.} = object

proc getElementById*(self: DocumentFragment; elementId: cstring): Option[Element] {.wasmBindgen.}

type
  DocumentTimelineOptions* {.wasmBindgen.} = object
    originTime*: DOMHighResTimeStamp

type
  DocumentTimeline* {.wasmBindgen.} = object


type
  DocumentType* {.wasmBindgen.} = object
    name*: cstring
    publicId*: cstring
    systemId*: cstring


type
  DragEvent* {.wasmBindgen.} = object

proc initDragEvent*(self: DragEvent; typeVal: cstring; canBubble: bool; cancelable: bool; aView: Option[Window]; aDetail: int32; aScreenX: int32; aScreenY: int32; aClientX: int32; aClientY: int32; aCtrlKey: bool; aAltKey: bool; aShiftKey: bool; aMetaKey: bool; aButton: uint16; aRelatedTarget: Option[EventTarget]; aDataTransfer: Option[DataTransfer]): void {.wasmBindgen.}

type
  DragEventInit* {.wasmBindgen.} = object

type
  DynamicsCompressorOptions* {.wasmBindgen.} = object
    attack*: float32
    knee*: float32
    ratio*: float32
    release*: float32
    threshold*: float32

type
  DynamicsCompressorNode* {.wasmBindgen.} = object
    threshold*: AudioParam
    knee*: AudioParam
    ratio*: AudioParam
    reduction*: float32
    attack*: AudioParam
    release*: AudioParam


type
  ErrorEvent* {.wasmBindgen.} = object
    message*: cstring
    filename*: cstring
    lineno*: uint32
    colno*: uint32
    error*: JsObject


type
  ErrorEventInit* {.wasmBindgen.} = object
    message*: cstring
    filename*: cstring
    lineno*: uint32
    colno*: uint32
    error*: JsObject

type
  Event* {.wasmBindgen.} = object
    typeVal*: cstring
    nONE*: uint16
    cAPTURING_PHASE*: uint16
    aT_TARGET*: uint16
    bUBBLING_PHASE*: uint16
    eventPhase*: uint16
    bubbles*: bool
    cancelable*: bool
    defaultPrevented*: bool
    defaultPreventedByChrome*: bool
    defaultPreventedByContent*: bool
    composed*: bool
    isTrusted*: bool
    timeStamp*: DOMHighResTimeStamp
    cancelBubble*: bool

proc composedPath*(self: Event): JsObject {.wasmBindgen.}
proc stopPropagation*(self: Event): void {.wasmBindgen.}
proc stopImmediatePropagation*(self: Event): void {.wasmBindgen.}
proc preventDefault*(self: Event): void {.wasmBindgen.}
proc initEvent*(self: Event; typeVal: cstring; bubbles: bool; cancelable: bool): void {.wasmBindgen.}

type
  EventInit* {.wasmBindgen.} = object
    bubbles*: bool
    cancelable*: bool
    composed*: bool

type
  interface* = proc

type
  EventSource* {.wasmBindgen.} = object
    url*: cstring
    withCredentials*: bool
    cONNECTING*: uint16
    oPEN*: uint16
    cLOSED*: uint16
    readyState*: uint16
    onopen*: EventHandler
    onmessage*: EventHandler
    onerror*: EventHandler

proc close*(self: EventSource): void {.wasmBindgen.}

type
  EventSourceInit* {.wasmBindgen.} = object
    withCredentials*: bool

type
  ExtendableEvent* {.wasmBindgen.} = object

proc waitUntil*(self: ExtendableEvent; p: JsObject): void {.wasmBindgen.}

type
  ExtendableEventInit* {.wasmBindgen.} = object

type
  ExtendableMessageEvent* {.wasmBindgen.} = object
    data*: JsObject
    origin*: cstring
    lastEventId*: cstring
    ports*: JsObject


type
  ExtendableMessageEventInit* {.wasmBindgen.} = object
    data*: JsObject
    origin*: cstring
    lastEventId*: cstring
    ports*: JsObject

type
  External* {.wasmBindgen.} = object

proc addSearchProvider*(self: External; aDescriptionURL: cstring): void {.wasmBindgen.}
proc isSearchProviderInstalled*(self: External; aSearchURL: cstring): uint32 {.wasmBindgen.}

type
  FakePluginTagInit* {.wasmBindgen.} = object
    handlerURI*: cstring
    mimeEntries*: JsObject
    niceName*: cstring
    fullPath*: cstring
    name*: cstring
    description*: cstring
    fileName*: cstring
    version*: cstring
    sandboxScript*: cstring

type
  FakePluginMimeEntry* {.wasmBindgen.} = object
    typeVal*: cstring
    description*: cstring
    extension*: cstring

type
  JSON* = JsObject

type
  BodyInit* = JsObject

type
  FetchReadableStreamReadDataDone* {.wasmBindgen.} = object
    done*: bool

type
  FetchReadableStreamReadDataArray* {.wasmBindgen.} = object

type
  FetchEvent* {.wasmBindgen.} = object
    request*: Request
    isReload*: bool

proc respondWith*(self: FetchEvent; r: JsObject): void {.wasmBindgen.}

type
  FetchEventInit* {.wasmBindgen.} = object
    request*: Request
    isReload*: bool

type
  interface* = proc

type
  FetchState* {.wasmBindgen.} = enum
    Requesting
    Responding
    Aborted
    Errored
    Complete

type
  FetchObserver* {.wasmBindgen.} = object
    state*: FetchState
    onstatechange*: EventHandler
    onrequestprogress*: EventHandler
    onresponseprogress*: EventHandler


type
  File* {.wasmBindgen.} = object
    name*: cstring
    lastModified*: int64


type
  FilePropertyBag* {.wasmBindgen.} = object
    typeVal*: cstring
    lastModified*: int64

type
  ChromeFilePropertyBag* {.wasmBindgen.} = object
    name*: cstring
    existenceCheck*: bool

type
  FileList* {.wasmBindgen.} = object
    file*: getter
    length*: uint32

proc item*(self: FileList; index: uint32): Option[] {.wasmBindgen.}

type
  FileReader* {.wasmBindgen.} = object
    eMPTY*: uint16
    lOADING*: uint16
    dONE*: uint16
    readyState*: uint16
    result*: JsObject
    onloadstart*: EventHandler
    onprogress*: EventHandler
    onload*: EventHandler
    onabort*: EventHandler
    onerror*: EventHandler
    onloadend*: EventHandler

proc readAsArrayBuffer*(self: FileReader; blob: Blob): void {.wasmBindgen.}
proc readAsBinaryString*(self: FileReader; filedata: Blob): void {.wasmBindgen.}
proc readAsText*(self: FileReader; blob: Blob; label: cstring): void {.wasmBindgen.}
proc readAsDataURL*(self: FileReader; blob: Blob): void {.wasmBindgen.}
proc abort*(self: FileReader): void {.wasmBindgen.}

type
  FileReaderSync* {.wasmBindgen.} = object

proc readAsArrayBuffer*(self: FileReaderSync; blob: Blob): JsObject {.wasmBindgen.}
proc readAsBinaryString*(self: FileReaderSync; blob: Blob): cstring {.wasmBindgen.}
proc readAsText*(self: FileReaderSync; blob: Blob; encoding: cstring): cstring {.wasmBindgen.}
proc readAsDataURL*(self: FileReaderSync; blob: Blob): cstring {.wasmBindgen.}

type
  FileSystemDirectoryEntry* {.wasmBindgen.} = object

proc createReader*(self: FileSystemDirectoryEntry): FileSystemDirectoryReader {.wasmBindgen.}
proc getFile*(self: FileSystemDirectoryEntry; path: Option[cstring]; options: FileSystemFlags; successCallback: FileSystemEntryCallback; errorCallback: ErrorCallback): void {.wasmBindgen.}
proc getDirectory*(self: FileSystemDirectoryEntry; path: Option[cstring]; options: FileSystemFlags; successCallback: FileSystemEntryCallback; errorCallback: ErrorCallback): void {.wasmBindgen.}

type
  FileSystemEntry* {.wasmBindgen.} = object
    isFile*: bool
    isDirectory*: bool
    name*: cstring
    fullPath*: cstring
    filesystem*: FileSystem

proc getParent*(self: FileSystemEntry; successCallback: FileSystemEntryCallback; errorCallback: ErrorCallback): void {.wasmBindgen.}

type
  FocusEvent* {.wasmBindgen.} = object


type
  FocusEventInit* {.wasmBindgen.} = object

type
  FocusOptions* {.wasmBindgen.} = object
    preventScroll*: bool
    focusVisible*: bool

type
  BinaryData* = JsObject

type
  FontFaceDescriptors* {.wasmBindgen.} = object
    style*: cstring
    weight*: cstring
    stretch*: cstring
    unicodeRange*: cstring
    variant*: cstring
    featureSettings*: cstring
    variationSettings*: cstring
    display*: cstring

type
  FontFaceLoadStatus* {.wasmBindgen.} = enum
    Unloaded
    Loading
    Loaded
    Error

type
  FontFace* {.wasmBindgen.} = object
    family*: cstring
    style*: cstring
    weight*: cstring
    stretch*: cstring
    unicodeRange*: cstring
    variant*: cstring
    featureSettings*: cstring
    variationSettings*: cstring
    display*: cstring
    status*: FontFaceLoadStatus
    loaded*: JsObject

proc load*(self: FontFace): JsObject {.wasmBindgen.}

type
  FontFaceSetIteratorResult* {.wasmBindgen.} = object
    value*: JsObject
    done*: bool

type
  FontFaceSetIterator* {.wasmBindgen.} = object

proc next*(self: FontFaceSetIterator): FontFaceSetIteratorResult {.wasmBindgen.}

type
  FontFaceSetForEachCallback* = proc

type
  FontFaceSetLoadStatus* {.wasmBindgen.} = enum
    Loading
    Loaded

type
  FontFaceSet* {.wasmBindgen.} = object
    size*: uint32
    onloading*: EventHandler
    onloadingdone*: EventHandler
    onloadingerror*: EventHandler
    ready*: JsObject
    status*: FontFaceSetLoadStatus

proc add*(self: FontFaceSet; font: FontFace): void {.wasmBindgen.}
proc has*(self: FontFaceSet; font: FontFace): bool {.wasmBindgen.}
proc delete*(self: FontFaceSet; font: FontFace): bool {.wasmBindgen.}
proc clear*(self: FontFaceSet): void {.wasmBindgen.}
proc entries*(self: FontFaceSet): FontFaceSetIterator {.wasmBindgen.}
proc values*(self: FontFaceSet): FontFaceSetIterator {.wasmBindgen.}
proc forEach*(self: FontFaceSet; cb: FontFaceSetForEachCallback; thisArg: JsObject): void {.wasmBindgen.}
proc load*(self: FontFaceSet; font: cstring; text: cstring): JsObject {.wasmBindgen.}
proc check*(self: FontFaceSet; font: cstring; text: cstring): bool {.wasmBindgen.}

type
  FontFaceSetLoadEventInit* {.wasmBindgen.} = object
    fontfaces*: JsObject

type
  FontFaceSetLoadEvent* {.wasmBindgen.} = object
    fontfaces*: JsObject


type
  FormDataEntryValue* = JsObject

type
  FormData* {.wasmBindgen.} = object

proc append*(self: FormData; name: cstring; value: Blob; filename: cstring): void {.wasmBindgen.}
proc append*(self: FormData; name: cstring; value: cstring): void {.wasmBindgen.}
proc delete*(self: FormData; name: cstring): void {.wasmBindgen.}
proc get*(self: FormData; name: cstring): Option[FormDataEntryValue] {.wasmBindgen.}
proc getAll*(self: FormData; name: cstring): JsObject {.wasmBindgen.}
proc has*(self: FormData; name: cstring): bool {.wasmBindgen.}
proc set*(self: FormData; name: cstring; value: Blob; filename: cstring): void {.wasmBindgen.}
proc set*(self: FormData; name: cstring; value: cstring): void {.wasmBindgen.}

type
  Function* = proc

type
  FuzzingFunctions* {.wasmBindgen.} = object

proc garbageCollect*(self: typedesc[FuzzingFunctions]): void {.wasmBindgen.}
proc cycleCollect*(self: typedesc[FuzzingFunctions]): void {.wasmBindgen.}
proc enableAccessibility*(self: typedesc[FuzzingFunctions]): void {.wasmBindgen.}

type
  GainOptions* {.wasmBindgen.} = object
    gain*: float32

type
  GainNode* {.wasmBindgen.} = object
    gain*: AudioParam


type
  Gamepad* {.wasmBindgen.} = object
    id*: cstring
    index*: uint32
    connected*: bool
    timestamp*: DOMHighResTimeStamp
    mapping*: GamepadMappingType
    axes*: JsObject
    buttons*: JsObject
    displayId*: uint32


type
  GamepadButton* {.wasmBindgen.} = object
    pressed*: bool
    touched*: bool
    value*: float64


type
  GamepadMappingType* {.wasmBindgen.} = enum
    Standard

type
  GamepadHapticActuator* {.wasmBindgen.} = object
    typeVal*: GamepadHapticActuatorType


type
  GamepadHapticActuatorType* {.wasmBindgen.} = enum
    Vibration

type
  GamepadEvent* {.wasmBindgen.} = object


type
  GamepadEventInit* {.wasmBindgen.} = object

type
  GamepadHand* {.wasmBindgen.} = enum
    Left
    Right

type
  GamepadPose* {.wasmBindgen.} = object
    hasOrientation*: bool
    hasPosition*: bool


type
  PositionOptions* {.wasmBindgen.} = object
    enableHighAccuracy*: bool
    timeout*: uint32
    maximumAge*: uint32

type
  Geolocation* {.wasmBindgen.} = object

proc getCurrentPosition*(self: Geolocation; successCallback: PositionCallback; errorCallback: Option[PositionErrorCallback]; options: PositionOptions): void {.wasmBindgen.}
proc watchPosition*(self: Geolocation; successCallback: PositionCallback; errorCallback: Option[PositionErrorCallback]; options: PositionOptions): int32 {.wasmBindgen.}
proc clearWatch*(self: Geolocation; watchId: int32): void {.wasmBindgen.}

type
  PositionCallback* = proc

type
  PositionErrorCallback* = proc

type
  CSSBoxType* {.wasmBindgen.} = enum
    Margin
    Border
    Padding
    Content

type
  BoxQuadOptions* {.wasmBindgen.} = object
    box*: CSSBoxType
    relativeTo*: GeometryNode

type
  ConvertCoordinateOptions* {.wasmBindgen.} = object
    fromBox*: CSSBoxType
    toBox*: CSSBoxType

type
  GeometryNode* = JsObject

type
  GetUserMediaRequest* {.wasmBindgen.} = object
    long*: uint32
    long*: uint32
    callID*: cstring
    rawID*: cstring
    mediaSource*: cstring
    isSecure*: bool
    isHandlingUserInput*: bool

proc getConstraints*(self: GetUserMediaRequest): MediaStreamConstraints {.wasmBindgen.}

type
  GroupedHistoryEvent* {.wasmBindgen.} = object


type
  GroupedHistoryEventInit* {.wasmBindgen.} = object

type
  HTMLAllCollection* {.wasmBindgen.} = object
    length*: uint32
    node*: getter
    index*: JsObject
    name*: JsObject

proc item*(self: HTMLAllCollection; index: uint32): Option[Node] {.wasmBindgen.}
proc item*(self: HTMLAllCollection; name: cstring): Option[] {.wasmBindgen.}
proc namedItem*(self: HTMLAllCollection; name: cstring): Option[] {.wasmBindgen.}

type
  HTMLAnchorElement* {.wasmBindgen.} = object
    target*: cstring
    download*: cstring
    ping*: cstring
    rel*: cstring
    referrerPolicy*: cstring
    relList*: DOMTokenList
    hreflang*: cstring
    typeVal*: cstring
    text*: cstring


type
  HTMLAnchorElement* {.wasmBindgen.} = object
    coords*: cstring
    charset*: cstring
    name*: cstring
    rev*: cstring
    shape*: cstring


type
  HTMLAreaElement* {.wasmBindgen.} = object
    alt*: cstring
    coords*: cstring
    shape*: cstring
    target*: cstring
    download*: cstring
    ping*: cstring
    rel*: cstring
    referrerPolicy*: cstring
    relList*: DOMTokenList


type
  HTMLAreaElement* {.wasmBindgen.} = object
    noHref*: bool


type
  HTMLAudioElement* {.wasmBindgen.} = object


type
  HTMLBRElement* {.wasmBindgen.} = object


type
  HTMLBaseElement* {.wasmBindgen.} = object
    href*: cstring
    target*: cstring


type
  HTMLBodyElement* {.wasmBindgen.} = object


type
  HTMLButtonElement* {.wasmBindgen.} = object
    autofocus*: bool
    disabled*: bool
    formAction*: cstring
    formEnctype*: cstring
    formMethod*: cstring
    formNoValidate*: bool
    formTarget*: cstring
    name*: cstring
    typeVal*: cstring
    value*: cstring
    willValidate*: bool
    validity*: ValidityState
    validationMessage*: cstring
    labels*: NodeList

proc checkValidity*(self: HTMLButtonElement): bool {.wasmBindgen.}
proc reportValidity*(self: HTMLButtonElement): bool {.wasmBindgen.}
proc setCustomValidity*(self: HTMLButtonElement; error: cstring): void {.wasmBindgen.}

type
  HTMLCanvasElement* {.wasmBindgen.} = object
    width*: uint32
    height*: uint32

proc getContext*(self: HTMLCanvasElement; contextId: cstring; contextOptions: JsObject): Option[nsISupports] {.wasmBindgen.}
proc toDataURL*(self: HTMLCanvasElement; typeVal: cstring; encoderOptions: JsObject): cstring {.wasmBindgen.}
proc toBlob*(self: HTMLCanvasElement; _callback: BlobCallback; typeVal: cstring; encoderOptions: JsObject): void {.wasmBindgen.}

type
  BlobCallback* = proc

type
  HTMLCollection* {.wasmBindgen.} = object
    length*: uint32
    element*: getter
    element*: getter

proc item*(self: HTMLCollection; index: uint32): Option[] {.wasmBindgen.}
proc namedItem*(self: HTMLCollection; name: cstring): Option[] {.wasmBindgen.}

type
  HTMLDListElement* {.wasmBindgen.} = object


type
  HTMLDataElement* {.wasmBindgen.} = object
    value*: cstring


type
  HTMLDataListElement* {.wasmBindgen.} = object
    options*: HTMLCollection


type
  HTMLDetailsElement* {.wasmBindgen.} = object
    open*: bool


type
  HTMLDialogElement* {.wasmBindgen.} = object
    open*: bool
    returnValue*: cstring

proc show*(self: HTMLDialogElement): void {.wasmBindgen.}
proc showModal*(self: HTMLDialogElement): void {.wasmBindgen.}
proc close*(self: HTMLDialogElement; returnValue: cstring): void {.wasmBindgen.}

type
  HTMLDirectoryElement* {.wasmBindgen.} = object
    compact*: bool


type
  HTMLDivElement* {.wasmBindgen.} = object


type
  HTMLElement* {.wasmBindgen.} = object
    title*: cstring
    scrollHeight*: int32
    scrollTop*: int32
    lang*: cstring
    dir*: cstring
    innerText*: cstring
    hidden*: bool
    inert*: bool
    accessKey*: cstring
    accessKeyLabel*: cstring
    draggable*: bool
    contentEditable*: cstring
    isContentEditable*: bool
    spellcheck*: bool

proc click*(self: HTMLElement): void {.wasmBindgen.}
proc focus*(self: HTMLElement; options: FocusOptions): void {.wasmBindgen.}
proc blur*(self: HTMLElement): void {.wasmBindgen.}
proc showPopover*(self: HTMLElement; options: ShowPopoverOptions): void {.wasmBindgen.}
proc hidePopover*(self: HTMLElement): void {.wasmBindgen.}
proc togglePopover*(self: HTMLElement; force: bool): bool {.wasmBindgen.}

type
  HTMLEmbedElement* {.wasmBindgen.} = object
    src*: cstring
    typeVal*: cstring
    width*: cstring
    height*: cstring


type
  HTMLFieldSetElement* {.wasmBindgen.} = object
    disabled*: bool
    name*: cstring
    typeVal*: cstring
    elements*: HTMLCollection
    willValidate*: bool
    validity*: ValidityState
    validationMessage*: cstring

proc checkValidity*(self: HTMLFieldSetElement): bool {.wasmBindgen.}
proc reportValidity*(self: HTMLFieldSetElement): bool {.wasmBindgen.}
proc setCustomValidity*(self: HTMLFieldSetElement; error: cstring): void {.wasmBindgen.}

type
  HTMLFontElement* {.wasmBindgen.} = object
    color*: cstring
    face*: cstring
    size*: cstring


type
  HTMLFormControlsCollection* {.wasmBindgen.} = object

proc namedItem*(self: HTMLFormControlsCollection; name: cstring): Option[] {.wasmBindgen.}

type
  HTMLFormElement* {.wasmBindgen.} = object
    acceptCharset*: cstring
    action*: cstring
    autocomplete*: cstring
    enctype*: cstring
    encoding*: cstring
    methodVal*: cstring
    name*: cstring
    noValidate*: bool
    target*: cstring
    elements*: HTMLCollection
    length*: int32

proc submit*(self: HTMLFormElement): void {.wasmBindgen.}
proc requestSubmit*(self: HTMLFormElement; submitter: Option[HTMLElement]): void {.wasmBindgen.}
proc reset*(self: HTMLFormElement): void {.wasmBindgen.}
proc checkValidity*(self: HTMLFormElement): bool {.wasmBindgen.}
proc reportValidity*(self: HTMLFormElement): bool {.wasmBindgen.}

type
  HTMLFrameElement* {.wasmBindgen.} = object
    name*: cstring
    scrolling*: cstring
    src*: cstring
    frameBorder*: cstring
    longDesc*: cstring
    noResize*: bool
    marginHeight*: cstring
    marginWidth*: cstring


type
  HTMLFrameSetElement* {.wasmBindgen.} = object
    cols*: cstring
    rows*: cstring


type
  HTMLHRElement* {.wasmBindgen.} = object


type
  HTMLHeadElement* {.wasmBindgen.} = object


type
  HTMLHeadingElement* {.wasmBindgen.} = object


type
  HTMLHtmlElement* {.wasmBindgen.} = object


type
  HTMLIFrameElement* {.wasmBindgen.} = object
    src*: cstring
    srcdoc*: cstring
    name*: cstring
    sandbox*: DOMTokenList
    allowFullscreen*: bool
    allowPaymentRequest*: bool
    width*: cstring
    height*: cstring
    referrerPolicy*: cstring


type
  HTMLImageElement* {.wasmBindgen.} = object
    alt*: cstring
    src*: cstring
    srcset*: cstring
    useMap*: cstring
    referrerPolicy*: cstring
    isMap*: bool
    width*: uint32
    height*: uint32
    decoding*: cstring
    naturalWidth*: uint32
    naturalHeight*: uint32
    complete*: bool

proc decode*(self: HTMLImageElement): JsObject {.wasmBindgen.}

type
  SelectionMode* {.wasmBindgen.} = enum
    Select
    Start
    EndVal
    Preserve

type
  HTMLInputElement* {.wasmBindgen.} = object
    accept*: cstring
    alt*: cstring
    autocomplete*: cstring
    autofocus*: bool
    defaultChecked*: bool
    checked*: bool
    disabled*: bool
    formAction*: cstring
    formEnctype*: cstring
    formMethod*: cstring
    formNoValidate*: bool
    formTarget*: cstring
    height*: uint32
    indeterminate*: bool
    inputMode*: cstring
    max*: cstring
    maxLength*: int32
    min*: cstring
    minLength*: int32
    multiple*: bool
    name*: cstring
    pattern*: cstring
    placeholder*: cstring
    readOnly*: bool
    required*: bool
    size*: uint32
    src*: cstring
    step*: cstring
    typeVal*: cstring
    defaultValue*: cstring
    value*: cstring
    valueAsNumber*: float64
    width*: uint32
    willValidate*: bool
    validity*: ValidityState
    validationMessage*: cstring

proc checkValidity*(self: HTMLInputElement): bool {.wasmBindgen.}
proc reportValidity*(self: HTMLInputElement): bool {.wasmBindgen.}
proc setCustomValidity*(self: HTMLInputElement; error: cstring): void {.wasmBindgen.}
proc select*(self: HTMLInputElement): void {.wasmBindgen.}
proc setRangeText*(self: HTMLInputElement; replacement: cstring): void {.wasmBindgen.}
proc setRangeText*(self: HTMLInputElement; replacement: cstring; start: uint32; endVal: uint32; selectionMode: SelectionMode): void {.wasmBindgen.}
proc setSelectionRange*(self: HTMLInputElement; start: uint32; endVal: uint32; direction: cstring): void {.wasmBindgen.}
proc showPicker*(self: HTMLInputElement): void {.wasmBindgen.}

type
  HTMLInputElement* {.wasmBindgen.} = object
    webkitEntries*: JsObject
    webkitdirectory*: bool


type
  DateTimeValue* {.wasmBindgen.} = object
    hour*: int32
    minute*: int32
    year*: int32
    month*: int32
    day*: int32

type
  HTMLLIElement* {.wasmBindgen.} = object
    value*: int32


type
  HTMLLabelElement* {.wasmBindgen.} = object
    htmlFor*: cstring


type
  HTMLLegendElement* {.wasmBindgen.} = object


type
  HTMLLinkElement* {.wasmBindgen.} = object
    disabled*: bool
    href*: cstring
    rel*: cstring
    relList*: DOMTokenList
    media*: cstring
    hreflang*: cstring
    typeVal*: cstring
    referrerPolicy*: cstring
    sizes*: DOMTokenList


type
  HTMLLinkElement* {.wasmBindgen.} = object
    charset*: cstring
    rev*: cstring
    target*: cstring


type
  HTMLMapElement* {.wasmBindgen.} = object
    name*: cstring
    areas*: HTMLCollection


type
  HTMLMediaElement* {.wasmBindgen.} = object
    src*: cstring
    currentSrc*: cstring
    nETWORK_EMPTY*: uint16
    nETWORK_IDLE*: uint16
    nETWORK_LOADING*: uint16
    nETWORK_NO_SOURCE*: uint16
    networkState*: uint16
    preload*: cstring
    buffered*: TimeRanges
    hAVE_NOTHING*: uint16
    hAVE_METADATA*: uint16
    hAVE_CURRENT_DATA*: uint16
    hAVE_FUTURE_DATA*: uint16
    hAVE_ENOUGH_DATA*: uint16
    readyState*: uint16
    seeking*: bool
    currentTime*: float64
    duration*: float64
    isEncrypted*: bool
    paused*: bool
    defaultPlaybackRate*: float64
    playbackRate*: float64
    played*: TimeRanges
    seekable*: TimeRanges
    ended*: bool
    autoplay*: bool
    loop*: bool
    controls*: bool
    volume*: float64
    muted*: bool
    defaultMuted*: bool
    audioTracks*: AudioTrackList
    videoTracks*: VideoTrackList

proc load*(self: HTMLMediaElement): void {.wasmBindgen.}
proc canPlayType*(self: HTMLMediaElement; typeVal: cstring): cstring {.wasmBindgen.}
proc fastSeek*(self: HTMLMediaElement; time: float64): void {.wasmBindgen.}
proc play*(self: HTMLMediaElement): JsObject {.wasmBindgen.}
proc pause*(self: HTMLMediaElement): void {.wasmBindgen.}
proc addTextTrack*(self: HTMLMediaElement; kind: TextTrackKind; label: cstring; language: cstring): TextTrack {.wasmBindgen.}

type
  HTMLMenuElement* {.wasmBindgen.} = object


type
  HTMLMenuItemElement* {.wasmBindgen.} = object
    typeVal*: cstring
    label*: cstring
    icon*: cstring
    disabled*: bool
    checked*: bool
    radiogroup*: cstring
    defaultChecked*: bool


type
  HTMLMetaElement* {.wasmBindgen.} = object
    name*: cstring
    httpEquiv*: cstring
    content*: cstring


type
  HTMLMeterElement* {.wasmBindgen.} = object
    value*: float64
    min*: float64
    max*: float64
    low*: float64
    high*: float64
    optimum*: float64
    labels*: NodeList


type
  HTMLModElement* {.wasmBindgen.} = object
    cite*: cstring
    dateTime*: cstring


type
  HTMLOListElement* {.wasmBindgen.} = object
    reversed*: bool
    start*: int32
    typeVal*: cstring


type
  HTMLObjectElement* {.wasmBindgen.} = object
    data*: cstring
    typeVal*: cstring
    typeMustMatch*: bool
    name*: cstring
    useMap*: cstring
    width*: cstring
    height*: cstring
    willValidate*: bool
    validity*: ValidityState
    validationMessage*: cstring

proc checkValidity*(self: HTMLObjectElement): bool {.wasmBindgen.}
proc reportValidity*(self: HTMLObjectElement): bool {.wasmBindgen.}
proc setCustomValidity*(self: HTMLObjectElement; error: cstring): void {.wasmBindgen.}

type
  HTMLOptGroupElement* {.wasmBindgen.} = object
    disabled*: bool
    label*: cstring


type
  HTMLOptionElement* {.wasmBindgen.} = object
    disabled*: bool
    label*: cstring
    defaultSelected*: bool
    selected*: bool
    value*: cstring
    text*: cstring
    index*: int32


type
  HTMLOutputElement* {.wasmBindgen.} = object
    htmlFor*: DOMTokenList
    name*: cstring
    typeVal*: cstring
    defaultValue*: cstring
    value*: cstring
    willValidate*: bool
    validity*: ValidityState
    validationMessage*: cstring
    labels*: NodeList

proc checkValidity*(self: HTMLOutputElement): bool {.wasmBindgen.}
proc reportValidity*(self: HTMLOutputElement): bool {.wasmBindgen.}
proc setCustomValidity*(self: HTMLOutputElement; error: cstring): void {.wasmBindgen.}

type
  HTMLParagraphElement* {.wasmBindgen.} = object


type
  HTMLParamElement* {.wasmBindgen.} = object
    name*: cstring
    value*: cstring


type
  HTMLPictureElement* {.wasmBindgen.} = object


type
  HTMLPreElement* {.wasmBindgen.} = object


type
  HTMLProgressElement* {.wasmBindgen.} = object
    value*: float64
    max*: float64
    position*: float64
    labels*: NodeList


type
  HTMLQuoteElement* {.wasmBindgen.} = object
    cite*: cstring


type
  HTMLScriptElement* {.wasmBindgen.} = object
    src*: cstring
    typeVal*: cstring
    noModule*: bool
    charset*: cstring
    async*: bool
    deferVal*: bool
    text*: cstring


type
  HTMLSlotElement* {.wasmBindgen.} = object
    name*: cstring

proc assignedNodes*(self: HTMLSlotElement; options: AssignedNodesOptions): JsObject {.wasmBindgen.}

type
  AssignedNodesOptions* {.wasmBindgen.} = object
    flatten*: bool

type
  HTMLSourceElement* {.wasmBindgen.} = object
    src*: cstring
    typeVal*: cstring


type
  HTMLSpanElement* {.wasmBindgen.} = object


type
  HTMLStyleElement* {.wasmBindgen.} = object
    disabled*: bool
    media*: cstring
    typeVal*: cstring


type
  HTMLTableCaptionElement* {.wasmBindgen.} = object


type
  HTMLTableCellElement* {.wasmBindgen.} = object
    colSpan*: uint32
    rowSpan*: uint32
    headers*: cstring
    cellIndex*: int32
    abbr*: cstring
    scope*: cstring


type
  HTMLTableColElement* {.wasmBindgen.} = object
    span*: uint32


type
  HTMLTableElement* {.wasmBindgen.} = object
    tBodies*: HTMLCollection
    rows*: HTMLCollection

proc createCaption*(self: HTMLTableElement): HTMLElement {.wasmBindgen.}
proc deleteCaption*(self: HTMLTableElement): void {.wasmBindgen.}
proc createTHead*(self: HTMLTableElement): HTMLElement {.wasmBindgen.}
proc deleteTHead*(self: HTMLTableElement): void {.wasmBindgen.}
proc createTFoot*(self: HTMLTableElement): HTMLElement {.wasmBindgen.}
proc deleteTFoot*(self: HTMLTableElement): void {.wasmBindgen.}
proc createTBody*(self: HTMLTableElement): HTMLElement {.wasmBindgen.}
proc insertRow*(self: HTMLTableElement; index: int32): HTMLElement {.wasmBindgen.}
proc deleteRow*(self: HTMLTableElement; index: int32): void {.wasmBindgen.}

type
  HTMLTableRowElement* {.wasmBindgen.} = object
    rowIndex*: int32
    sectionRowIndex*: int32
    cells*: HTMLCollection

proc insertCell*(self: HTMLTableRowElement; index: int32): HTMLElement {.wasmBindgen.}
proc deleteCell*(self: HTMLTableRowElement; index: int32): void {.wasmBindgen.}

type
  HTMLTableSectionElement* {.wasmBindgen.} = object
    rows*: HTMLCollection

proc insertRow*(self: HTMLTableSectionElement; index: int32): HTMLElement {.wasmBindgen.}
proc deleteRow*(self: HTMLTableSectionElement; index: int32): void {.wasmBindgen.}

type
  HTMLTemplateElement* {.wasmBindgen.} = object
    content*: DocumentFragment


type
  HTMLTextAreaElement* {.wasmBindgen.} = object
    autocomplete*: cstring
    autofocus*: bool
    cols*: uint32
    disabled*: bool
    maxLength*: int32
    minLength*: int32
    name*: cstring
    placeholder*: cstring
    readOnly*: bool
    required*: bool
    rows*: uint32
    wrap*: cstring
    typeVal*: cstring
    defaultValue*: cstring
    value*: cstring
    textLength*: uint32
    willValidate*: bool
    validity*: ValidityState
    validationMessage*: cstring
    labels*: NodeList

proc checkValidity*(self: HTMLTextAreaElement): bool {.wasmBindgen.}
proc reportValidity*(self: HTMLTextAreaElement): bool {.wasmBindgen.}
proc setCustomValidity*(self: HTMLTextAreaElement; error: cstring): void {.wasmBindgen.}
proc select*(self: HTMLTextAreaElement): void {.wasmBindgen.}
proc setRangeText*(self: HTMLTextAreaElement; replacement: cstring): void {.wasmBindgen.}
proc setRangeText*(self: HTMLTextAreaElement; replacement: cstring; start: uint32; endVal: uint32; mode: cstring): void {.wasmBindgen.}
proc setSelectionRange*(self: HTMLTextAreaElement; start: uint32; endVal: uint32; direction: cstring): void {.wasmBindgen.}

type
  HTMLTimeElement* {.wasmBindgen.} = object
    dateTime*: cstring


type
  HTMLTitleElement* {.wasmBindgen.} = object
    text*: cstring


type
  HTMLTrackElement* {.wasmBindgen.} = object
    kind*: cstring
    src*: cstring
    srclang*: cstring
    label*: cstring
    default*: bool
    nONE*: uint16
    lOADING*: uint16
    lOADED*: uint16
    eRROR*: uint16
    readyState*: uint16


type
  HTMLUListElement* {.wasmBindgen.} = object


type
  HTMLVideoElement* {.wasmBindgen.} = object
    width*: uint32
    height*: uint32
    videoWidth*: uint32
    videoHeight*: uint32
    poster*: cstring


type
  HashChangeEvent* {.wasmBindgen.} = object
    oldURL*: cstring
    newURL*: cstring

proc initHashChangeEvent*(self: HashChangeEvent; typeArg: cstring; canBubbleArg: bool; cancelableArg: bool; oldURLArg: cstring; newURLArg: cstring): void {.wasmBindgen.}

type
  HashChangeEventInit* {.wasmBindgen.} = object
    oldURL*: cstring
    newURL*: cstring

type
  HeadersInit* = JsObject

type
  HeadersGuardEnum* {.wasmBindgen.} = enum
    None
    Request
    Request_no_cors
    Response
    Immutable

type
  Headers* {.wasmBindgen.} = object
    guard*: HeadersGuardEnum

proc append*(self: Headers; name: cstring; value: cstring): void {.wasmBindgen.}
proc delete*(self: Headers; name: cstring): void {.wasmBindgen.}
proc get*(self: Headers; name: cstring): Option[cstring] {.wasmBindgen.}
proc has*(self: Headers; name: cstring): bool {.wasmBindgen.}
proc set*(self: Headers; name: cstring; value: cstring): void {.wasmBindgen.}

type
  HiddenPluginEvent* {.wasmBindgen.} = object


type
  HiddenPluginEventInit* {.wasmBindgen.} = object

type
  ScrollRestoration* {.wasmBindgen.} = enum
    Auto
    Manual

type
  History* {.wasmBindgen.} = object
    length*: uint32
    scrollRestoration*: ScrollRestoration
    state*: JsObject

proc go*(self: History; delta: int32): void {.wasmBindgen.}
proc back*(self: History): void {.wasmBindgen.}
proc forward*(self: History): void {.wasmBindgen.}
proc pushState*(self: History; data: JsObject; title: cstring; url: Option[cstring]): void {.wasmBindgen.}
proc replaceState*(self: History; data: JsObject; title: cstring; url: Option[cstring]): void {.wasmBindgen.}

type
  IIRFilterOptions* {.wasmBindgen.} = object
    feedforward*: JsObject
    feedback*: JsObject

type
  IIRFilterNode* {.wasmBindgen.} = object

proc getFrequencyResponse*(self: IIRFilterNode; frequencyHz: seq[float32]; magResponse: seq[float32]; phaseResponse: seq[float32]): void {.wasmBindgen.}

type
  IdleDeadline* {.wasmBindgen.} = object
    didTimeout*: bool

proc timeRemaining*(self: IdleDeadline): DOMHighResTimeStamp {.wasmBindgen.}

type
  ImageBitmapSource* = JsObject

type
  ImageBitmap* {.wasmBindgen.} = object
    width*: uint32
    height*: uint32


type
  ImageOrientation* {.wasmBindgen.} = enum
    From_image
    FlipY

type
  PremultiplyAlpha* {.wasmBindgen.} = enum
    None
    Premultiply
    Default

type
  ColorSpaceConversion* {.wasmBindgen.} = enum
    None
    Default

type
  ResizeQuality* {.wasmBindgen.} = enum
    Pixelated
    Low
    Medium
    High

type
  ImageBitmapOptions* {.wasmBindgen.} = object
    imageOrientation*: ImageOrientation
    premultiplyAlpha*: PremultiplyAlpha
    colorSpaceConversion*: ColorSpaceConversion
    resizeWidth*: uint32
    resizeHeight*: uint32
    resizeQuality*: ResizeQuality

type
  ImageBitmapRenderingContext* {.wasmBindgen.} = object

proc transferFromImageBitmap*(self: ImageBitmapRenderingContext; bitmap: ImageBitmap): void {.wasmBindgen.}
proc transferImageBitmap*(self: ImageBitmapRenderingContext; bitmap: ImageBitmap): void {.wasmBindgen.}

type
  ImageCaptureErrorEvent* {.wasmBindgen.} = object


type
  ImageCaptureErrorEventInit* {.wasmBindgen.} = object

type
  ImageCaptureError* {.wasmBindgen.} = object
    fRAME_GRAB_ERROR*: uint16
    sETTINGS_ERROR*: uint16
    pHOTO_ERROR*: uint16
    eRROR_UNKNOWN*: uint16
    code*: uint16
    message*: cstring


type
  ImageData* {.wasmBindgen.} = object
    width*: uint32
    height*: uint32
    data*: Uint8ClampedArray


type
  ImageDocument* {.wasmBindgen.} = object
    imageIsOverflowing*: bool
    imageIsResized*: bool

proc shrinkToFit*(self: ImageDocument): void {.wasmBindgen.}
proc restoreImage*(self: ImageDocument): void {.wasmBindgen.}
proc restoreImageTo*(self: ImageDocument; x: int32; y: int32): void {.wasmBindgen.}
proc toggleImageSize*(self: ImageDocument): void {.wasmBindgen.}

type
  InputEvent* {.wasmBindgen.} = object
    isComposing*: bool
    inputType*: cstring


type
  InputEventInit* {.wasmBindgen.} = object
    isComposing*: bool
    inputType*: cstring

type
  InputEventInit* {.wasmBindgen.} = object
    targetRanges*: JsObject

type
  IntersectionObserverEntry* {.wasmBindgen.} = object
    time*: DOMHighResTimeStamp
    boundingClientRect*: DOMRectReadOnly
    intersectionRect*: DOMRectReadOnly
    isIntersecting*: bool
    intersectionRatio*: float64
    target*: Element


type
  IntersectionObserver* {.wasmBindgen.} = object
    rootMargin*: cstring
    thresholds*: JsObject
    intersectionCallback*: IntersectionCallback

proc observe*(self: IntersectionObserver; target: Element): void {.wasmBindgen.}
proc unobserve*(self: IntersectionObserver; target: Element): void {.wasmBindgen.}
proc disconnect*(self: IntersectionObserver): void {.wasmBindgen.}
proc takeRecords*(self: IntersectionObserver): JsObject {.wasmBindgen.}

type
  IntersectionCallback* = proc

type
  IntersectionObserverEntryInit* {.wasmBindgen.} = object
    time*: DOMHighResTimeStamp
    rootBounds*: DOMRectInit
    boundingClientRect*: DOMRectInit
    intersectionRect*: DOMRectInit
    target*: Element

type
  IntersectionObserverInit* {.wasmBindgen.} = object
    rootMargin*: cstring
    threshold*: JsObject

type
  DisplayNameOptions* {.wasmBindgen.} = object
    style*: cstring
    keys*: JsObject

type
  DisplayNameResult* {.wasmBindgen.} = object
    locale*: cstring
    style*: cstring
    values*: JsObject

type
  LocaleInfo* {.wasmBindgen.} = object
    locale*: cstring
    direction*: cstring

type
  IntlUtils* {.wasmBindgen.} = object

proc getDisplayNames*(self: IntlUtils; locales: JsObject; options: DisplayNameOptions): DisplayNameResult {.wasmBindgen.}
proc getLocaleInfo*(self: IntlUtils; locales: JsObject): LocaleInfo {.wasmBindgen.}

type
  IterableKeyOrValueResult* {.wasmBindgen.} = object
    value*: JsObject
    done*: bool

type
  IterableKeyAndValueResult* {.wasmBindgen.} = object
    value*: JsObject
    done*: bool

type
  KeyAlgorithm* {.wasmBindgen.} = object
    name*: cstring

type
  AesKeyAlgorithm* {.wasmBindgen.} = object
    length*: uint16

type
  EcKeyAlgorithm* {.wasmBindgen.} = object
    namedCurve*: cstring

type
  HmacKeyAlgorithm* {.wasmBindgen.} = object
    hash*: KeyAlgorithm
    length*: uint32

type
  KeyEvent* {.wasmBindgen.} = object
    dOM_VK_CANCEL*: uint32
    dOM_VK_HELP*: uint32
    dOM_VK_BACK_SPACE*: uint32
    dOM_VK_TAB*: uint32
    dOM_VK_CLEAR*: uint32
    dOM_VK_RETURN*: uint32
    dOM_VK_SHIFT*: uint32
    dOM_VK_CONTROL*: uint32
    dOM_VK_ALT*: uint32
    dOM_VK_PAUSE*: uint32
    dOM_VK_CAPS_LOCK*: uint32
    dOM_VK_KANA*: uint32
    dOM_VK_HANGUL*: uint32
    dOM_VK_EISU*: uint32
    dOM_VK_JUNJA*: uint32
    dOM_VK_FINAL*: uint32
    dOM_VK_HANJA*: uint32
    dOM_VK_KANJI*: uint32
    dOM_VK_ESCAPE*: uint32
    dOM_VK_CONVERT*: uint32
    dOM_VK_NONCONVERT*: uint32
    dOM_VK_ACCEPT*: uint32
    dOM_VK_MODECHANGE*: uint32
    dOM_VK_SPACE*: uint32
    dOM_VK_PAGE_UP*: uint32
    dOM_VK_PAGE_DOWN*: uint32
    dOM_VK_END*: uint32
    dOM_VK_HOME*: uint32
    dOM_VK_LEFT*: uint32
    dOM_VK_UP*: uint32
    dOM_VK_RIGHT*: uint32
    dOM_VK_DOWN*: uint32
    dOM_VK_SELECT*: uint32
    dOM_VK_PRINT*: uint32
    dOM_VK_EXECUTE*: uint32
    dOM_VK_PRINTSCREEN*: uint32
    dOM_VK_INSERT*: uint32
    dOM_VK_DELETE*: uint32
    dOM_VK_0*: uint32
    dOM_VK_1*: uint32
    dOM_VK_2*: uint32
    dOM_VK_3*: uint32
    dOM_VK_4*: uint32
    dOM_VK_5*: uint32
    dOM_VK_6*: uint32
    dOM_VK_7*: uint32
    dOM_VK_8*: uint32
    dOM_VK_9*: uint32
    dOM_VK_COLON*: uint32
    dOM_VK_SEMICOLON*: uint32
    dOM_VK_LESS_THAN*: uint32
    dOM_VK_EQUALS*: uint32
    dOM_VK_GREATER_THAN*: uint32
    dOM_VK_QUESTION_MARK*: uint32
    dOM_VK_AT*: uint32
    dOM_VK_A*: uint32
    dOM_VK_B*: uint32
    dOM_VK_C*: uint32
    dOM_VK_D*: uint32
    dOM_VK_E*: uint32
    dOM_VK_F*: uint32
    dOM_VK_G*: uint32
    dOM_VK_H*: uint32
    dOM_VK_I*: uint32
    dOM_VK_J*: uint32
    dOM_VK_K*: uint32
    dOM_VK_L*: uint32
    dOM_VK_M*: uint32
    dOM_VK_N*: uint32
    dOM_VK_O*: uint32
    dOM_VK_P*: uint32
    dOM_VK_Q*: uint32
    dOM_VK_R*: uint32
    dOM_VK_S*: uint32
    dOM_VK_T*: uint32
    dOM_VK_U*: uint32
    dOM_VK_V*: uint32
    dOM_VK_W*: uint32
    dOM_VK_X*: uint32
    dOM_VK_Y*: uint32
    dOM_VK_Z*: uint32
    dOM_VK_WIN*: uint32
    dOM_VK_CONTEXT_MENU*: uint32
    dOM_VK_SLEEP*: uint32
    dOM_VK_NUMPAD0*: uint32
    dOM_VK_NUMPAD1*: uint32
    dOM_VK_NUMPAD2*: uint32
    dOM_VK_NUMPAD3*: uint32
    dOM_VK_NUMPAD4*: uint32
    dOM_VK_NUMPAD5*: uint32
    dOM_VK_NUMPAD6*: uint32
    dOM_VK_NUMPAD7*: uint32
    dOM_VK_NUMPAD8*: uint32
    dOM_VK_NUMPAD9*: uint32
    dOM_VK_MULTIPLY*: uint32
    dOM_VK_ADD*: uint32
    dOM_VK_SEPARATOR*: uint32
    dOM_VK_SUBTRACT*: uint32
    dOM_VK_DECIMAL*: uint32
    dOM_VK_DIVIDE*: uint32
    dOM_VK_F1*: uint32
    dOM_VK_F2*: uint32
    dOM_VK_F3*: uint32
    dOM_VK_F4*: uint32
    dOM_VK_F5*: uint32
    dOM_VK_F6*: uint32
    dOM_VK_F7*: uint32
    dOM_VK_F8*: uint32
    dOM_VK_F9*: uint32
    dOM_VK_F10*: uint32
    dOM_VK_F11*: uint32
    dOM_VK_F12*: uint32
    dOM_VK_F13*: uint32
    dOM_VK_F14*: uint32
    dOM_VK_F15*: uint32
    dOM_VK_F16*: uint32
    dOM_VK_F17*: uint32
    dOM_VK_F18*: uint32
    dOM_VK_F19*: uint32
    dOM_VK_F20*: uint32
    dOM_VK_F21*: uint32
    dOM_VK_F22*: uint32
    dOM_VK_F23*: uint32
    dOM_VK_F24*: uint32
    dOM_VK_NUM_LOCK*: uint32
    dOM_VK_SCROLL_LOCK*: uint32
    dOM_VK_WIN_OEM_FJ_JISHO*: uint32
    dOM_VK_WIN_OEM_FJ_MASSHOU*: uint32
    dOM_VK_WIN_OEM_FJ_TOUROKU*: uint32
    dOM_VK_WIN_OEM_FJ_LOYA*: uint32
    dOM_VK_WIN_OEM_FJ_ROYA*: uint32
    dOM_VK_CIRCUMFLEX*: uint32
    dOM_VK_EXCLAMATION*: uint32
    dOM_VK_DOUBLE_QUOTE*: uint32
    dOM_VK_HASH*: uint32
    dOM_VK_DOLLAR*: uint32
    dOM_VK_PERCENT*: uint32
    dOM_VK_AMPERSAND*: uint32
    dOM_VK_UNDERSCORE*: uint32
    dOM_VK_OPEN_PAREN*: uint32
    dOM_VK_CLOSE_PAREN*: uint32
    dOM_VK_ASTERISK*: uint32
    dOM_VK_PLUS*: uint32
    dOM_VK_PIPE*: uint32
    dOM_VK_HYPHEN_MINUS*: uint32
    dOM_VK_OPEN_CURLY_BRACKET*: uint32
    dOM_VK_CLOSE_CURLY_BRACKET*: uint32
    dOM_VK_TILDE*: uint32
    dOM_VK_VOLUME_MUTE*: uint32
    dOM_VK_VOLUME_DOWN*: uint32
    dOM_VK_VOLUME_UP*: uint32
    dOM_VK_COMMA*: uint32
    dOM_VK_PERIOD*: uint32
    dOM_VK_SLASH*: uint32
    dOM_VK_BACK_QUOTE*: uint32
    dOM_VK_OPEN_BRACKET*: uint32
    dOM_VK_BACK_SLASH*: uint32
    dOM_VK_CLOSE_BRACKET*: uint32
    dOM_VK_QUOTE*: uint32
    dOM_VK_META*: uint32
    dOM_VK_ALTGR*: uint32
    dOM_VK_WIN_ICO_HELP*: uint32
    dOM_VK_WIN_ICO_00*: uint32
    dOM_VK_PROCESSKEY*: uint32
    dOM_VK_WIN_ICO_CLEAR*: uint32
    dOM_VK_WIN_OEM_RESET*: uint32
    dOM_VK_WIN_OEM_JUMP*: uint32
    dOM_VK_WIN_OEM_PA1*: uint32
    dOM_VK_WIN_OEM_PA2*: uint32
    dOM_VK_WIN_OEM_PA3*: uint32
    dOM_VK_WIN_OEM_WSCTRL*: uint32
    dOM_VK_WIN_OEM_CUSEL*: uint32
    dOM_VK_WIN_OEM_ATTN*: uint32
    dOM_VK_WIN_OEM_FINISH*: uint32
    dOM_VK_WIN_OEM_COPY*: uint32
    dOM_VK_WIN_OEM_AUTO*: uint32
    dOM_VK_WIN_OEM_ENLW*: uint32
    dOM_VK_WIN_OEM_BACKTAB*: uint32
    dOM_VK_ATTN*: uint32
    dOM_VK_CRSEL*: uint32
    dOM_VK_EXSEL*: uint32
    dOM_VK_EREOF*: uint32
    dOM_VK_PLAY*: uint32
    dOM_VK_ZOOM*: uint32
    dOM_VK_PA1*: uint32
    dOM_VK_WIN_OEM_CLEAR*: uint32

proc initKeyEvent*(self: KeyEvent; typeVal: cstring; canBubble: bool; cancelable: bool; view: Option[Window]; ctrlKey: bool; altKey: bool; shiftKey: bool; metaKey: bool; keyCode: uint32; charCode: uint32): void {.wasmBindgen.}

type
  KeyIdsInitData* {.wasmBindgen.} = object
    kids*: JsObject

type
  KeyboardEvent* {.wasmBindgen.} = object
    charCode*: uint32
    keyCode*: uint32
    altKey*: bool
    ctrlKey*: bool
    shiftKey*: bool
    metaKey*: bool
    dOM_KEY_LOCATION_STANDARD*: uint32
    dOM_KEY_LOCATION_LEFT*: uint32
    dOM_KEY_LOCATION_RIGHT*: uint32
    dOM_KEY_LOCATION_NUMPAD*: uint32
    location*: uint32
    repeat*: bool
    isComposing*: bool
    key*: cstring
    code*: cstring
    initDict*: KeyboardEventInit

proc getModifierState*(self: KeyboardEvent; key: cstring): bool {.wasmBindgen.}
proc initKeyboardEvent*(self: KeyboardEvent; typeArg: cstring; bubblesArg: bool; cancelableArg: bool; viewArg: Option[Window]; keyArg: cstring; locationArg: uint32; ctrlKey: bool; altKey: bool; shiftKey: bool; metaKey: bool): void {.wasmBindgen.}

type
  KeyboardEventInit* {.wasmBindgen.} = object
    key*: cstring
    code*: cstring
    location*: uint32
    repeat*: bool
    isComposing*: bool
    charCode*: uint32
    keyCode*: uint32
    which*: uint32

type
  UnrestrictedDoubleOrKeyframeAnimationOptions* = JsObject

type
  IterationCompositeOperation* {.wasmBindgen.} = enum
    Replace
    Accumulate

type
  KeyframeEffectOptions* {.wasmBindgen.} = object
    iterationComposite*: IterationCompositeOperation
    composite*: CompositeOperation

type
  KeyframeEffect* {.wasmBindgen.} = object
    iterationComposite*: IterationCompositeOperation
    composite*: CompositeOperation

proc getKeyframes*(self: KeyframeEffect): JsObject {.wasmBindgen.}
proc setKeyframes*(self: KeyframeEffect; keyframes: Option[JsObject]): void {.wasmBindgen.}

type
  AnimationPropertyValueDetails* {.wasmBindgen.} = object
    offset*: float64
    value*: cstring
    easing*: cstring
    composite*: CompositeOperation

type
  AnimationPropertyDetails* {.wasmBindgen.} = object
    property*: cstring
    runningOnCompositor*: bool
    warning*: cstring
    values*: JsObject

type
  L10nElement* {.wasmBindgen.} = object
    namespaceURI*: cstring
    localName*: cstring
    l10nId*: cstring

type
  AttributeNameValue* {.wasmBindgen.} = object
    name*: cstring
    value*: cstring

type
  L10nValue* {.wasmBindgen.} = object

type
  L10nCallback* = proc

type
  ListBoxObject* {.wasmBindgen.} = object

proc getRowCount*(self: ListBoxObject): int32 {.wasmBindgen.}
proc getRowHeight*(self: ListBoxObject): int32 {.wasmBindgen.}
proc getNumberOfVisibleRows*(self: ListBoxObject): int32 {.wasmBindgen.}
proc getIndexOfFirstVisibleRow*(self: ListBoxObject): int32 {.wasmBindgen.}
proc ensureIndexIsVisible*(self: ListBoxObject; rowIndex: int32): void {.wasmBindgen.}
proc scrollToIndex*(self: ListBoxObject; rowIndex: int32): void {.wasmBindgen.}
proc scrollByLines*(self: ListBoxObject; numLines: int32): void {.wasmBindgen.}
proc getItemAtIndex*(self: ListBoxObject; index: int32): Option[Element] {.wasmBindgen.}
proc getIndexOfItem*(self: ListBoxObject; item: Element): int32 {.wasmBindgen.}

type
  LocalMediaStream* {.wasmBindgen.} = object

proc stop*(self: LocalMediaStream): void {.wasmBindgen.}

type
  Location* {.wasmBindgen.} = object
    href*: cstring
    origin*: cstring
    protocol*: cstring
    host*: cstring
    hostname*: cstring
    port*: cstring
    pathname*: cstring
    search*: cstring
    hash*: cstring

proc assign*(self: Location; url: cstring): void {.wasmBindgen.}
proc replace*(self: Location; url: cstring): void {.wasmBindgen.}
proc reload*(self: Location; forceget: bool): void {.wasmBindgen.}

type
  MIDIAccess* {.wasmBindgen.} = object
    inputs*: MIDIInputMap
    outputs*: MIDIOutputMap
    onstatechange*: EventHandler
    sysexEnabled*: bool


type
  MIDIConnectionEvent* {.wasmBindgen.} = object


type
  MIDIConnectionEventInit* {.wasmBindgen.} = object

type
  MIDIInput* {.wasmBindgen.} = object
    onmidimessage*: EventHandler


type
  MIDIInputMap* {.wasmBindgen.} = object


type
  MIDIMessageEvent* {.wasmBindgen.} = object


type
  MIDIMessageEventInit* {.wasmBindgen.} = object

type
  MIDIOptions* {.wasmBindgen.} = object
    sysex*: bool
    software*: bool

type
  MIDIOutput* {.wasmBindgen.} = object

proc send*(self: MIDIOutput; data: JsObject; timestamp: DOMHighResTimeStamp): void {.wasmBindgen.}
proc clear*(self: MIDIOutput): void {.wasmBindgen.}

type
  MIDIOutputMap* {.wasmBindgen.} = object


type
  MIDIPortType* {.wasmBindgen.} = enum
    Input
    Output

type
  MIDIPortDeviceState* {.wasmBindgen.} = enum
    Disconnected
    Connected

type
  MIDIPortConnectionState* {.wasmBindgen.} = enum
    Open
    Closed
    Pending

type
  MIDIPort* {.wasmBindgen.} = object
    id*: cstring
    typeVal*: MIDIPortType
    state*: MIDIPortDeviceState
    connection*: MIDIPortConnectionState
    onstatechange*: EventHandler

proc open*(self: MIDIPort): JsObject {.wasmBindgen.}
proc close*(self: MIDIPort): JsObject {.wasmBindgen.}

type
  MathMLElement* {.wasmBindgen.} = object


type
  MediaConfiguration* {.wasmBindgen.} = object
    video*: VideoConfiguration
    audio*: AudioConfiguration

type
  MediaDecodingConfiguration* {.wasmBindgen.} = object
    typeVal*: MediaDecodingType

type
  MediaEncodingConfiguration* {.wasmBindgen.} = object
    typeVal*: MediaEncodingType

type
  MediaDecodingType* {.wasmBindgen.} = enum
    File
    Media_source

type
  MediaEncodingType* {.wasmBindgen.} = enum
    Record
    Transmission

type
  VideoConfiguration* {.wasmBindgen.} = object
    contentType*: cstring
    width*: uint32
    height*: uint32
    long*: uint32
    framerate*: cstring

type
  AudioConfiguration* {.wasmBindgen.} = object
    contentType*: cstring
    channels*: cstring
    long*: uint32
    samplerate*: uint32

type
  MediaCapabilitiesInfo* {.wasmBindgen.} = object
    supported*: bool
    smooth*: bool
    powerEfficient*: bool


type
  MediaCapabilities* {.wasmBindgen.} = object

proc decodingInfo*(self: MediaCapabilities; configuration: MediaDecodingConfiguration): JsObject {.wasmBindgen.}
proc encodingInfo*(self: MediaCapabilities; configuration: MediaEncodingConfiguration): JsObject {.wasmBindgen.}

type
  MediaDeviceKind* {.wasmBindgen.} = enum
    Audioinput
    Audiooutput
    Videoinput

type
  MediaDeviceInfo* {.wasmBindgen.} = object
    deviceId*: cstring
    kind*: MediaDeviceKind
    label*: cstring
    groupId*: cstring

proc toJSON*(self: MediaDeviceInfo): JsObject {.wasmBindgen.}

type
  MediaDevices* {.wasmBindgen.} = object
    ondevicechange*: EventHandler

proc getSupportedConstraints*(self: MediaDevices): MediaTrackSupportedConstraints {.wasmBindgen.}
proc enumerateDevices*(self: MediaDevices): JsObject {.wasmBindgen.}
proc getUserMedia*(self: MediaDevices; constraints: MediaStreamConstraints): JsObject {.wasmBindgen.}
proc getDisplayMedia*(self: MediaDevices; constraints: DisplayMediaStreamConstraints): JsObject {.wasmBindgen.}

type
  MediaElementAudioSourceOptions* {.wasmBindgen.} = object
    mediaElement*: HTMLMediaElement

type
  MediaElementAudioSourceNode* {.wasmBindgen.} = object


type
  MediaEncryptedEvent* {.wasmBindgen.} = object
    initDataType*: cstring


type
  MediaKeyNeededEventInit* {.wasmBindgen.} = object
    initDataType*: cstring

type
  MediaError* {.wasmBindgen.} = object
    mEDIA_ERR_ABORTED*: uint16
    mEDIA_ERR_NETWORK*: uint16
    mEDIA_ERR_DECODE*: uint16
    mEDIA_ERR_SRC_NOT_SUPPORTED*: uint16
    code*: uint16
    message*: cstring


type
  MediaKeyError* {.wasmBindgen.} = object
    systemCode*: uint32


type
  MediaKeyMessageType* {.wasmBindgen.} = enum
    License_request
    License_renewal
    License_release
    Individualization_request

type
  MediaKeyMessageEvent* {.wasmBindgen.} = object
    messageType*: MediaKeyMessageType
    message*: JsObject


type
  MediaKeyMessageEventInit* {.wasmBindgen.} = object
    messageType*: MediaKeyMessageType
    message*: JsObject

type
  MediaKeySession* {.wasmBindgen.} = object
    sessionId*: cstring
    expiration*: float64
    closed*: JsObject
    keyStatuses*: MediaKeyStatusMap
    onkeystatuseschange*: EventHandler
    onmessage*: EventHandler

proc generateRequest*(self: MediaKeySession; initDataType: cstring; initData: BufferSource): JsObject {.wasmBindgen.}
proc load*(self: MediaKeySession; sessionId: cstring): JsObject {.wasmBindgen.}
proc update*(self: MediaKeySession; response: BufferSource): JsObject {.wasmBindgen.}
proc close*(self: MediaKeySession): JsObject {.wasmBindgen.}
proc remove*(self: MediaKeySession): JsObject {.wasmBindgen.}

type
  MediaKeyStatus* {.wasmBindgen.} = enum
    Usable
    Expired
    Released
    Output_restricted
    Output_downscaled
    Status_pending
    Internal_error

type
  MediaKeyStatusMap* {.wasmBindgen.} = object
    size*: uint32

proc has*(self: MediaKeyStatusMap; keyId: BufferSource): bool {.wasmBindgen.}
proc get*(self: MediaKeyStatusMap; keyId: BufferSource): JsObject {.wasmBindgen.}

type
  MediaKeysRequirement* {.wasmBindgen.} = enum
    Required
    Optional
    Not_allowed

type
  MediaKeySystemMediaCapability* {.wasmBindgen.} = object
    contentType*: cstring
    robustness*: cstring

type
  MediaKeySystemConfiguration* {.wasmBindgen.} = object
    label*: cstring
    initDataTypes*: JsObject
    audioCapabilities*: JsObject
    videoCapabilities*: JsObject
    distinctiveIdentifier*: MediaKeysRequirement
    persistentState*: MediaKeysRequirement
    sessionTypes*: JsObject

type
  MediaKeySystemAccess* {.wasmBindgen.} = object
    keySystem*: cstring

proc getConfiguration*(self: MediaKeySystemAccess): MediaKeySystemConfiguration {.wasmBindgen.}
proc createMediaKeys*(self: MediaKeySystemAccess): JsObject {.wasmBindgen.}

type
  MediaKeySessionType* {.wasmBindgen.} = enum
    Temporary
    Persistent_license

type
  MediaKeysPolicy* {.wasmBindgen.} = object
    minHdcpVersion*: cstring

type
  MediaKeys* {.wasmBindgen.} = object
    keySystem*: cstring

proc createSession*(self: MediaKeys; sessionType: MediaKeySessionType): MediaKeySession {.wasmBindgen.}
proc setServerCertificate*(self: MediaKeys; serverCertificate: BufferSource): JsObject {.wasmBindgen.}
proc getStatusForPolicy*(self: MediaKeys; policy: MediaKeysPolicy): JsObject {.wasmBindgen.}

type
  MediaKeySystemStatus* {.wasmBindgen.} = enum
    Available
    Api_disabled
    Cdm_disabled
    Cdm_not_supported
    Cdm_not_installed
    Cdm_created

type
  RequestMediaKeySystemAccessNotification* {.wasmBindgen.} = object
    keySystem*: cstring
    status*: MediaKeySystemStatus

type
  MediaList* {.wasmBindgen.} = object
    mediaText*: cstring
    length*: uint32
    dOMString*: getter

proc item*(self: MediaList; index: uint32): Option[] {.wasmBindgen.}
proc deleteMedium*(self: MediaList; oldMedium: cstring): void {.wasmBindgen.}
proc appendMedium*(self: MediaList; newMedium: cstring): void {.wasmBindgen.}

type
  MediaQueryList* {.wasmBindgen.} = object
    media*: cstring
    matches*: bool
    onchange*: EventHandler

proc addListener*(self: MediaQueryList; listener: Option[EventListener]): void {.wasmBindgen.}
proc removeListener*(self: MediaQueryList; listener: Option[EventListener]): void {.wasmBindgen.}

type
  MediaQueryListEvent* {.wasmBindgen.} = object
    media*: cstring
    matches*: bool


type
  MediaQueryListEventInit* {.wasmBindgen.} = object
    media*: cstring
    matches*: bool

type
  BitrateMode* {.wasmBindgen.} = enum
    Constant
    Variable

type
  RecordingState* {.wasmBindgen.} = enum
    Inactive
    Recording
    Paused

type
  MediaRecorder* {.wasmBindgen.} = object
    stream*: MediaStream
    state*: RecordingState
    mimeType*: cstring
    ondataavailable*: EventHandler
    onerror*: EventHandler
    onpause*: EventHandler
    onresume*: EventHandler
    onstart*: EventHandler
    onstop*: EventHandler
    videoBitsPerSecond*: uint32
    audioBitsPerSecond*: uint32
    audioBitrateMode*: BitrateMode

proc start*(self: MediaRecorder; timeSlice: int32): void {.wasmBindgen.}
proc stop*(self: MediaRecorder): void {.wasmBindgen.}
proc pause*(self: MediaRecorder): void {.wasmBindgen.}
proc resume*(self: MediaRecorder): void {.wasmBindgen.}
proc requestData*(self: MediaRecorder): void {.wasmBindgen.}
proc isTypeSupported*(self: typedesc[MediaRecorder]; typeVal: cstring): bool {.wasmBindgen.}

type
  MediaRecorderOptions* {.wasmBindgen.} = object
    mimeType*: cstring
    audioBitsPerSecond*: uint32
    videoBitsPerSecond*: uint32
    bitsPerSecond*: uint32
    audioBitrateMode*: BitrateMode
    videoKeyFrameIntervalDuration*: DOMHighResTimeStamp
    videoKeyFrameIntervalCount*: uint32

type
  MediaRecorderErrorEventInit* {.wasmBindgen.} = object
    error*: DOMException

type
  MediaRecorderErrorEvent* {.wasmBindgen.} = object
    error*: DOMException


type
  MediaSourceReadyState* {.wasmBindgen.} = enum
    Closed
    Open
    Ended

type
  MediaSourceEndOfStreamError* {.wasmBindgen.} = enum
    Network
    Decode

type
  MediaSource* {.wasmBindgen.} = object
    sourceBuffers*: SourceBufferList
    activeSourceBuffers*: SourceBufferList
    readyState*: MediaSourceReadyState
    duration*: float64
    onsourceopen*: EventHandler
    onsourceended*: EventHandler
    onsourceclose*: EventHandler

proc addSourceBuffer*(self: MediaSource; typeVal: cstring): SourceBuffer {.wasmBindgen.}
proc removeSourceBuffer*(self: MediaSource; sourceBuffer: SourceBuffer): void {.wasmBindgen.}
proc endOfStream*(self: MediaSource; error: MediaSourceEndOfStreamError): void {.wasmBindgen.}
proc setLiveSeekableRange*(self: MediaSource; start: float64; endVal: float64): void {.wasmBindgen.}
proc clearLiveSeekableRange*(self: MediaSource): void {.wasmBindgen.}
proc isTypeSupported*(self: typedesc[MediaSource]; typeVal: cstring): bool {.wasmBindgen.}

type
  MediaStreamConstraints* {.wasmBindgen.} = object
    audio*: JsObject
    video*: JsObject
    picture*: bool
    fake*: bool

type
  DisplayMediaStreamConstraints* {.wasmBindgen.} = object
    video*: JsObject
    audio*: JsObject

type
  MediaStream* {.wasmBindgen.} = object
    id*: cstring
    active*: bool
    onaddtrack*: EventHandler
    onremovetrack*: EventHandler
    currentTime*: float64

proc getAudioTracks*(self: MediaStream): JsObject {.wasmBindgen.}
proc getVideoTracks*(self: MediaStream): JsObject {.wasmBindgen.}
proc getTracks*(self: MediaStream): JsObject {.wasmBindgen.}
proc getTrackById*(self: MediaStream; trackId: cstring): Option[MediaStreamTrack] {.wasmBindgen.}
proc addTrack*(self: MediaStream; track: MediaStreamTrack): void {.wasmBindgen.}
proc removeTrack*(self: MediaStream; track: MediaStreamTrack): void {.wasmBindgen.}
proc clone*(self: MediaStream): MediaStream {.wasmBindgen.}
proc countUnderlyingStreams*(self: typedesc[MediaStream]): JsObject {.wasmBindgen.}
proc assignId*(self: MediaStream; id: cstring): void {.wasmBindgen.}

type
  MediaStreamAudioDestinationNode* {.wasmBindgen.} = object
    stream*: MediaStream


type
  MediaStreamAudioSourceOptions* {.wasmBindgen.} = object
    mediaStream*: MediaStream

type
  MediaStreamAudioSourceNode* {.wasmBindgen.} = object


type
  MediaStreamError* {.wasmBindgen.} = object
    name*: cstring


type
  MediaStreamEventInit* {.wasmBindgen.} = object

type
  MediaStreamEvent* {.wasmBindgen.} = object


type
  VideoFacingModeEnum* {.wasmBindgen.} = enum
    User
    Environment
    Left
    Right

type
  MediaSourceEnum* {.wasmBindgen.} = enum
    Camera
    Screen
    Application
    Window
    Browser
    Microphone
    AudioCapture
    Other

type
  ConstrainLong* = JsObject

type
  ConstrainDouble* = JsObject

type
  ConstrainBoolean* = JsObject

type
  ConstrainDOMString* = JsObject

type
  MediaTrackConstraintSet* {.wasmBindgen.} = object
    width*: ConstrainLong
    height*: ConstrainLong
    frameRate*: ConstrainDouble
    facingMode*: ConstrainDOMString
    mediaSource*: cstring
    browserWindow*: int64
    scrollWithPage*: bool
    deviceId*: ConstrainDOMString
    viewportOffsetX*: ConstrainLong
    viewportOffsetY*: ConstrainLong
    viewportWidth*: ConstrainLong
    viewportHeight*: ConstrainLong
    echoCancellation*: ConstrainBoolean
    noiseSuppression*: ConstrainBoolean
    autoGainControl*: ConstrainBoolean
    channelCount*: ConstrainLong

type
  MediaTrackConstraints* {.wasmBindgen.} = object
    advanced*: JsObject

type
  MediaStreamTrackState* {.wasmBindgen.} = enum
    Live
    Ended

type
  MediaStreamTrack* {.wasmBindgen.} = object
    kind*: cstring
    id*: cstring
    label*: cstring
    enabled*: bool
    muted*: bool
    onmute*: EventHandler
    onunmute*: EventHandler
    readyState*: MediaStreamTrackState
    onended*: EventHandler

proc clone*(self: MediaStreamTrack): MediaStreamTrack {.wasmBindgen.}
proc stop*(self: MediaStreamTrack): void {.wasmBindgen.}
proc getConstraints*(self: MediaStreamTrack): MediaTrackConstraints {.wasmBindgen.}
proc getSettings*(self: MediaStreamTrack): MediaTrackSettings {.wasmBindgen.}
proc applyConstraints*(self: MediaStreamTrack; constraints: MediaTrackConstraints): JsObject {.wasmBindgen.}
proc mutedChanged*(self: MediaStreamTrack; muted: bool): void {.wasmBindgen.}

type
  MediaStreamTrackEventInit* {.wasmBindgen.} = object
    track*: MediaStreamTrack

type
  MediaStreamTrackEvent* {.wasmBindgen.} = object
    track*: MediaStreamTrack


type
  ConstrainLongRange* {.wasmBindgen.} = object
    min*: int32
    max*: int32
    exact*: int32
    ideal*: int32

type
  ConstrainDoubleRange* {.wasmBindgen.} = object
    min*: float64
    max*: float64
    exact*: float64
    ideal*: float64

type
  ConstrainBooleanParameters* {.wasmBindgen.} = object
    exact*: bool
    ideal*: bool

type
  ConstrainDOMStringParameters* {.wasmBindgen.} = object
    exact*: JsObject
    ideal*: JsObject

type
  MediaTrackSettings* {.wasmBindgen.} = object
    width*: int32
    height*: int32
    frameRate*: float64
    facingMode*: cstring
    deviceId*: cstring
    echoCancellation*: bool
    noiseSuppression*: bool
    autoGainControl*: bool
    channelCount*: int32

type
  MediaTrackSupportedConstraints* {.wasmBindgen.} = object
    width*: bool
    height*: bool
    aspectRatio*: bool
    frameRate*: bool
    facingMode*: bool
    volume*: bool
    sampleRate*: bool
    sampleSize*: bool
    echoCancellation*: bool
    noiseSuppression*: bool
    autoGainControl*: bool
    latency*: bool
    channelCount*: bool
    deviceId*: bool
    groupId*: bool

type
  MessageChannel* {.wasmBindgen.} = object
    port1*: MessagePort
    port2*: MessagePort


type
  MessageEvent* {.wasmBindgen.} = object
    data*: JsObject
    origin*: cstring
    lastEventId*: cstring
    ports*: JsObject

proc initMessageEvent*(self: MessageEvent; typeVal: cstring; bubbles: bool; cancelable: bool; data: JsObject; origin: cstring; lastEventId: cstring; source: Option[MessageEventSource]; ports: JsObject): void {.wasmBindgen.}

type
  MessageEventInit* {.wasmBindgen.} = object
    data*: JsObject
    origin*: cstring
    lastEventId*: cstring
    ports*: JsObject

type
  MessageEventSource* = JsObject

type
  MessagePort* {.wasmBindgen.} = object
    onmessage*: EventHandler
    onmessageerror*: EventHandler

proc postMessage*(self: MessagePort; message: JsObject; transferable: JsObject): void {.wasmBindgen.}
proc start*(self: MessagePort): void {.wasmBindgen.}
proc close*(self: MessagePort): void {.wasmBindgen.}

type
  MimeType* {.wasmBindgen.} = object
    description*: cstring
    suffixes*: cstring
    typeVal*: cstring


type
  MimeTypeArray* {.wasmBindgen.} = object
    length*: uint32
    mimeType*: getter
    mimeType*: getter

proc item*(self: MimeTypeArray; index: uint32): Option[] {.wasmBindgen.}
proc namedItem*(self: MimeTypeArray; name: cstring): Option[] {.wasmBindgen.}

type
  MouseEvent* {.wasmBindgen.} = object
    screenX*: int32
    screenY*: int32
    clientX*: int32
    clientY*: int32
    x*: int32
    y*: int32
    offsetX*: int32
    offsetY*: int32
    pageX*: int32
    pageY*: int32
    ctrlKey*: bool
    shiftKey*: bool
    altKey*: bool
    metaKey*: bool
    button*: int16
    buttons*: uint16
    movementX*: int32
    movementY*: int32

proc initMouseEvent*(self: MouseEvent; typeArg: cstring; canBubbleArg: bool; cancelableArg: bool; viewArg: Option[Window]; detailArg: int32; screenXArg: int32; screenYArg: int32; clientXArg: int32; clientYArg: int32; ctrlKeyArg: bool; altKeyArg: bool; shiftKeyArg: bool; metaKeyArg: bool; buttonArg: int16; relatedTargetArg: Option[EventTarget]): void {.wasmBindgen.}
proc getModifierState*(self: MouseEvent; keyArg: cstring): bool {.wasmBindgen.}

type
  MouseEventInit* {.wasmBindgen.} = object
    screenX*: int32
    screenY*: int32
    clientX*: int32
    clientY*: int32
    button*: int16
    buttons*: uint16
    movementX*: int32
    movementY*: int32

type
  MouseScrollEvent* {.wasmBindgen.} = object
    hORIZONTAL_AXIS*: int32
    vERTICAL_AXIS*: int32
    axis*: int32

proc initMouseScrollEvent*(self: MouseScrollEvent; typeVal: cstring; canBubble: bool; cancelable: bool; view: Option[Window]; detail: int32; screenX: int32; screenY: int32; clientX: int32; clientY: int32; ctrlKey: bool; altKey: bool; shiftKey: bool; metaKey: bool; button: int16; relatedTarget: Option[EventTarget]; axis: int32): void {.wasmBindgen.}

type
  MutationEvent* {.wasmBindgen.} = object
    mODIFICATION*: uint16
    aDDITION*: uint16
    rEMOVAL*: uint16
    sMIL*: uint16
    prevValue*: cstring
    newValue*: cstring
    attrName*: cstring
    attrChange*: uint16

proc initMutationEvent*(self: MutationEvent; typeVal: cstring; canBubble: bool; cancelable: bool; relatedNode: Option[Node]; prevValue: cstring; newValue: cstring; attrName: cstring; attrChange: uint16): void {.wasmBindgen.}

type
  MutationRecord* {.wasmBindgen.} = object
    typeVal*: cstring
    addedNodes*: NodeList
    removedNodes*: NodeList
    addedAnimations*: JsObject
    changedAnimations*: JsObject
    removedAnimations*: JsObject


type
  MutationObserver* {.wasmBindgen.} = object
    mutationCallback*: MutationCallback
    mergeAttributeRecords*: bool

proc observe*(self: MutationObserver; target: Node; options: MutationObserverInit): void {.wasmBindgen.}
proc disconnect*(self: MutationObserver): void {.wasmBindgen.}
proc takeRecords*(self: MutationObserver): JsObject {.wasmBindgen.}
proc getObservingInfo*(self: MutationObserver): JsObject {.wasmBindgen.}

type
  MutationCallback* = proc

type
  MutationObserverInit* {.wasmBindgen.} = object
    childList*: bool
    attributes*: bool
    characterData*: bool
    subtree*: bool
    attributeOldValue*: bool
    characterDataOldValue*: bool
    nativeAnonymousChildList*: bool
    animations*: bool
    attributeFilter*: JsObject

type
  MutationObservingInfo* {.wasmBindgen.} = object

type
  NamedNodeMap* {.wasmBindgen.} = object
    attr*: getter
    attr*: getter
    length*: uint32

proc getNamedItem*(self: NamedNodeMap; name: cstring): Option[] {.wasmBindgen.}
proc setNamedItem*(self: NamedNodeMap; arg: Attr): Option[Attr] {.wasmBindgen.}
proc removeNamedItem*(self: NamedNodeMap; name: cstring): Attr {.wasmBindgen.}
proc item*(self: NamedNodeMap; index: uint32): Option[] {.wasmBindgen.}
proc getNamedItemNS*(self: NamedNodeMap; namespaceURI: Option[cstring]; localName: cstring): Option[Attr] {.wasmBindgen.}
proc setNamedItemNS*(self: NamedNodeMap; arg: Attr): Option[Attr] {.wasmBindgen.}
proc removeNamedItemNS*(self: NamedNodeMap; namespaceURI: Option[cstring]; localName: cstring): Attr {.wasmBindgen.}

type
  NativeOSFileReadOptions* {.wasmBindgen.} = object
    long*: uint32

type
  NativeOSFileWriteAtomicOptions* {.wasmBindgen.} = object
    long*: uint32
    noOverwrite*: bool
    flush*: bool

type
  SocketElement* {.wasmBindgen.} = object
    host*: cstring
    port*: uint32
    active*: bool
    tcp*: bool
    sent*: float64
    received*: float64

type
  SocketsDict* {.wasmBindgen.} = object
    sockets*: JsObject
    sent*: float64
    received*: float64

type
  HttpConnInfo* {.wasmBindgen.} = object
    rtt*: uint32
    ttl*: uint32
    protocolVersion*: cstring

type
  HalfOpenInfoDict* {.wasmBindgen.} = object
    speculative*: bool

type
  HttpConnectionElement* {.wasmBindgen.} = object
    host*: cstring
    port*: uint32
    spdy*: bool
    ssl*: bool
    active*: JsObject
    idle*: JsObject
    halfOpens*: JsObject

type
  HttpConnDict* {.wasmBindgen.} = object
    connections*: JsObject

type
  WebSocketElement* {.wasmBindgen.} = object
    hostport*: cstring
    msgsent*: uint32
    msgreceived*: uint32
    sentsize*: float64
    receivedsize*: float64
    encrypted*: bool

type
  WebSocketDict* {.wasmBindgen.} = object
    websockets*: JsObject

type
  DnsCacheEntry* {.wasmBindgen.} = object
    hostname*: cstring
    hostaddr*: JsObject
    family*: cstring
    expiration*: float64
    trr*: bool

type
  DNSCacheDict* {.wasmBindgen.} = object
    entries*: JsObject

type
  DNSLookupDict* {.wasmBindgen.} = object
    address*: JsObject
    error*: cstring
    answer*: bool

type
  ConnStatusDict* {.wasmBindgen.} = object
    status*: cstring

type
  RcwnPerfStats* {.wasmBindgen.} = object
    avgShort*: uint32
    avgLong*: uint32
    stddevLong*: uint32

type
  RcwnStatus* {.wasmBindgen.} = object
    totalNetworkRequests*: uint32
    rcwnCacheWonCount*: uint32
    rcwnNetWonCount*: uint32
    cacheSlowCount*: uint32
    cacheNotSlowCount*: uint32
    perfStats*: JsObject

type
  ConnectionType* {.wasmBindgen.} = enum
    Cellular
    Bluetooth
    Ethernet
    Wifi
    Other
    None
    Unknown

type
  NetworkInformation* {.wasmBindgen.} = object
    typeVal*: ConnectionType
    ontypechange*: EventHandler


type
  NetworkCommandOptions* {.wasmBindgen.} = object
    id*: int32
    cmd*: cstring
    ifname*: cstring
    ip*: cstring
    prefixLength*: uint32
    domain*: cstring
    dnses*: JsObject
    gateway*: cstring
    gateways*: JsObject
    mode*: cstring
    report*: bool
    enabled*: bool
    wifictrlinterfacename*: cstring
    internalIfname*: cstring
    externalIfname*: cstring
    enable*: bool
    ssid*: cstring
    security*: cstring
    key*: cstring
    prefix*: cstring
    link*: cstring
    interfaceList*: JsObject
    wifiStartIp*: cstring
    wifiEndIp*: cstring
    usbStartIp*: cstring
    usbEndIp*: cstring
    dns1*: cstring
    dns2*: cstring
    threshold*: int64
    startIp*: cstring
    endIp*: cstring
    serverIp*: cstring
    maskLength*: cstring
    preInternalIfname*: cstring
    preExternalIfname*: cstring
    curInternalIfname*: cstring
    curExternalIfname*: cstring
    ipaddr*: int32
    mask*: int32
    gateway_long*: int32
    dns1_long*: int32
    dns2_long*: int32
    mtu*: int32

type
  NetworkResultOptions* {.wasmBindgen.} = object
    id*: int32
    ret*: bool
    broadcast*: bool
    topic*: cstring
    reason*: cstring
    resultCode*: int32
    resultReason*: cstring
    error*: bool
    enable*: bool
    result*: bool
    success*: bool
    curExternalIfname*: cstring
    curInternalIfname*: cstring
    reply*: cstring
    route*: cstring
    ipaddr_str*: cstring
    gateway_str*: cstring
    dns1_str*: cstring
    dns2_str*: cstring
    mask_str*: cstring
    server_str*: cstring
    vendor_str*: cstring
    lease*: int32
    prefixLength*: int32
    mask*: int32
    ipaddr*: int32
    gateway*: int32
    dns1*: int32
    dns2*: int32
    server*: int32
    netId*: cstring
    interfaceList*: JsObject
    flag*: cstring
    macAddr*: cstring
    ipAddr*: cstring

type
  Node* {.wasmBindgen.} = object
    eLEMENT_NODE*: uint16
    aTTRIBUTE_NODE*: uint16
    tEXT_NODE*: uint16
    cDATA_SECTION_NODE*: uint16
    eNTITY_REFERENCE_NODE*: uint16
    eNTITY_NODE*: uint16
    pROCESSING_INSTRUCTION_NODE*: uint16
    cOMMENT_NODE*: uint16
    dOCUMENT_NODE*: uint16
    dOCUMENT_TYPE_NODE*: uint16
    dOCUMENT_FRAGMENT_NODE*: uint16
    nOTATION_NODE*: uint16
    nodeType*: uint16
    nodeName*: cstring
    isConnected*: bool
    childNodes*: NodeList
    dOCUMENT_POSITION_DISCONNECTED*: uint16
    dOCUMENT_POSITION_PRECEDING*: uint16
    dOCUMENT_POSITION_FOLLOWING*: uint16
    dOCUMENT_POSITION_CONTAINS*: uint16
    dOCUMENT_POSITION_CONTAINED_BY*: uint16
    dOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC*: uint16

proc getRootNode*(self: Node; options: GetRootNodeOptions): Node {.wasmBindgen.}
proc hasChildNodes*(self: Node): bool {.wasmBindgen.}
proc insertBefore*(self: Node; node: Node; child: Option[Node]): Node {.wasmBindgen.}
proc appendChild*(self: Node; node: Node): Node {.wasmBindgen.}
proc replaceChild*(self: Node; node: Node; child: Node): Node {.wasmBindgen.}
proc removeChild*(self: Node; child: Node): Node {.wasmBindgen.}
proc normalize*(self: Node): void {.wasmBindgen.}
proc cloneNode*(self: Node; deep: bool): Node {.wasmBindgen.}
proc isSameNode*(self: Node; node: Option[Node]): bool {.wasmBindgen.}
proc isEqualNode*(self: Node; node: Option[Node]): bool {.wasmBindgen.}
proc compareDocumentPosition*(self: Node; other: Node): uint16 {.wasmBindgen.}
proc contains*(self: Node; other: Option[Node]): bool {.wasmBindgen.}
proc lookupPrefix*(self: Node; namespace: Option[cstring]): Option[cstring] {.wasmBindgen.}
proc lookupNamespaceURI*(self: Node; prefix: Option[cstring]): Option[cstring] {.wasmBindgen.}
proc isDefaultNamespace*(self: Node; namespace: Option[cstring]): bool {.wasmBindgen.}

type
  GetRootNodeOptions* {.wasmBindgen.} = object
    composed*: bool

type
  interface* = proc

type
  NodeIterator* {.wasmBindgen.} = object
    root*: Node
    pointerBeforeReferenceNode*: bool
    whatToShow*: uint32

proc nextNode*(self: NodeIterator): Option[Node] {.wasmBindgen.}
proc previousNode*(self: NodeIterator): Option[Node] {.wasmBindgen.}
proc detach*(self: NodeIterator): void {.wasmBindgen.}

type
  NodeList* {.wasmBindgen.} = object
    node*: getter
    length*: uint32

proc item*(self: NodeList; index: uint32): Option[] {.wasmBindgen.}

type
  Notification* {.wasmBindgen.} = object
    permission*: NotificationPermission
    maxActions*: uint32
    onclick*: EventHandler
    onshow*: EventHandler
    onerror*: EventHandler
    onclose*: EventHandler
    title*: cstring
    dir*: NotificationDirection
    image*: cstring
    badge*: cstring
    vibrate*: JsObject
    long*: uint32
    renotify*: bool
    requireInteraction*: bool
    data*: JsObject
    actions*: JsObject

proc requestPermission*(self: typedesc[Notification]; permissionCallback: NotificationPermissionCallback): JsObject {.wasmBindgen.}
proc close*(self: Notification): void {.wasmBindgen.}

type
  NotificationOptions* {.wasmBindgen.} = object
    dir*: NotificationDirection
    lang*: cstring
    body*: cstring
    tag*: cstring
    image*: cstring
    icon*: cstring
    badge*: cstring
    vibrate*: VibratePattern
    long*: uint32
    renotify*: bool
    requireInteraction*: bool
    data*: JsObject
    actions*: JsObject

type
  NotificationPermission* {.wasmBindgen.} = enum
    Default
    Denied
    Granted

type
  NotificationDirection* {.wasmBindgen.} = enum
    Auto
    Ltr
    Rtl

type
  NotificationAction* {.wasmBindgen.} = object
    action*: cstring
    title*: cstring
    icon*: cstring

type
  NotificationPermissionCallback* = proc

type
  NotificationEvent* {.wasmBindgen.} = object
    notification*: Notification


type
  NotificationEventInit* {.wasmBindgen.} = object
    notification*: Notification

type
  NotifyPaintEvent* {.wasmBindgen.} = object
    clientRects*: DOMRectList
    boundingClientRect*: DOMRect
    paintRequests*: PaintRequestList
    long*: uint32
    paintTimeStamp*: DOMHighResTimeStamp


type
  OVR_multiview2* {.wasmBindgen.} = object
    fRAMEBUFFER_ATTACHMENT_TEXTURE_NUM_VIEWS_OVR*: GLenum
    fRAMEBUFFER_ATTACHMENT_TEXTURE_BASE_VIEW_INDEX_OVR*: GLenum
    mAX_VIEWS_OVR*: GLenum
    fRAMEBUFFER_INCOMPLETE_VIEW_TARGETS_OVR*: GLenum

proc framebufferTextureMultiviewOVR*(self: OVR_multiview2; target: GLenum; attachment: GLenum; texture: Option[WebGLTexture]; level: GLint; baseViewIndex: GLint; numViews: GLsizei): void {.wasmBindgen.}

type
  OfflineAudioCompletionEventInit* {.wasmBindgen.} = object
    renderedBuffer*: AudioBuffer

type
  OfflineAudioCompletionEvent* {.wasmBindgen.} = object
    renderedBuffer*: AudioBuffer


type
  OfflineAudioContextOptions* {.wasmBindgen.} = object
    numberOfChannels*: uint32
    length*: uint32
    sampleRate*: float32

type
  OfflineAudioContext* {.wasmBindgen.} = object
    length*: uint32
    oncomplete*: EventHandler

proc startRendering*(self: OfflineAudioContext): JsObject {.wasmBindgen.}

type
  OfflineResourceList* {.wasmBindgen.} = object
    uNCACHED*: uint16
    iDLE*: uint16
    cHECKING*: uint16
    dOWNLOADING*: uint16
    uPDATEREADY*: uint16
    oBSOLETE*: uint16
    status*: uint16
    onchecking*: EventHandler
    onerror*: EventHandler
    onnoupdate*: EventHandler
    ondownloading*: EventHandler
    onprogress*: EventHandler
    onupdateready*: EventHandler
    oncached*: EventHandler
    onobsolete*: EventHandler

proc update*(self: OfflineResourceList): void {.wasmBindgen.}
proc swapCache*(self: OfflineResourceList): void {.wasmBindgen.}

type
  ImageEncodeOptions* {.wasmBindgen.} = object
    typeVal*: cstring
    quality*: float64

type
  OffscreenCanvas* {.wasmBindgen.} = object
    width*: uint32
    height*: uint32

proc getContext*(self: OffscreenCanvas; contextId: cstring; contextOptions: JsObject): Option[nsISupports] {.wasmBindgen.}
proc transferToImageBitmap*(self: OffscreenCanvas): ImageBitmap {.wasmBindgen.}
proc convertToBlob*(self: OffscreenCanvas; options: ImageEncodeOptions): JsObject {.wasmBindgen.}

type
  OffscreenCanvasRenderingContext2D* {.wasmBindgen.} = object
    canvas*: OffscreenCanvas


type
  OscillatorType* {.wasmBindgen.} = enum
    Sine
    Square
    Sawtooth
    Triangle
    Custom

type
  OscillatorOptions* {.wasmBindgen.} = object
    typeVal*: OscillatorType
    frequency*: float32
    detune*: float32
    periodicWave*: PeriodicWave

type
  OscillatorNode* {.wasmBindgen.} = object
    typeVal*: OscillatorType
    frequency*: AudioParam
    detune*: AudioParam

proc setPeriodicWave*(self: OscillatorNode; periodicWave: PeriodicWave): void {.wasmBindgen.}

type
  PageTransitionEvent* {.wasmBindgen.} = object
    persisted*: bool
    inFrameSwap*: bool


type
  PageTransitionEventInit* {.wasmBindgen.} = object
    persisted*: bool
    inFrameSwap*: bool

type
  PaintRequest* {.wasmBindgen.} = object
    clientRect*: DOMRect
    reason*: cstring


type
  PaintRequestList* {.wasmBindgen.} = object
    length*: uint32
    paintRequest*: getter

proc item*(self: PaintRequestList; index: uint32): Option[] {.wasmBindgen.}

type
  PaintWorkletGlobalScope* {.wasmBindgen.} = object

proc registerPaint*(self: PaintWorkletGlobalScope; name: cstring; paintCtor: VoidFunction): void {.wasmBindgen.}

type
  PanningModelType* {.wasmBindgen.} = enum
    Equalpower
    HRTF

type
  DistanceModelType* {.wasmBindgen.} = enum
    Linear
    Inverse
    Exponential

type
  PannerOptions* {.wasmBindgen.} = object
    panningModel*: PanningModelType
    distanceModel*: DistanceModelType
    positionX*: float32
    positionY*: float32
    positionZ*: float32
    orientationX*: float32
    orientationY*: float32
    orientationZ*: float32
    refDistance*: float64
    maxDistance*: float64
    rolloffFactor*: float64
    coneInnerAngle*: float64
    coneOuterAngle*: float64
    coneOuterGain*: float64

type
  PannerNode* {.wasmBindgen.} = object
    panningModel*: PanningModelType
    positionX*: AudioParam
    positionY*: AudioParam
    positionZ*: AudioParam
    orientationX*: AudioParam
    orientationY*: AudioParam
    orientationZ*: AudioParam
    distanceModel*: DistanceModelType
    refDistance*: float64
    maxDistance*: float64
    rolloffFactor*: float64
    coneInnerAngle*: float64
    coneOuterAngle*: float64
    coneOuterGain*: float64

proc setPosition*(self: PannerNode; x: float64; y: float64; z: float64): void {.wasmBindgen.}
proc setOrientation*(self: PannerNode; x: float64; y: float64; z: float64): void {.wasmBindgen.}
proc setVelocity*(self: PannerNode; x: float64; y: float64; z: float64): void {.wasmBindgen.}

type
  PaymentAddress* {.wasmBindgen.} = object
    country*: cstring
    addressLine*: JsObject
    region*: cstring
    city*: cstring
    dependentLocality*: cstring
    postalCode*: cstring
    sortingCode*: cstring
    languageCode*: cstring
    organization*: cstring
    recipient*: cstring
    phone*: cstring

proc toJSON*(self: PaymentAddress): JsObject {.wasmBindgen.}

type
  PaymentMethodChangeEvent* {.wasmBindgen.} = object
    methodName*: cstring


type
  PaymentMethodChangeEventInit* {.wasmBindgen.} = object
    methodName*: cstring

type
  PaymentRequestUpdateEvent* {.wasmBindgen.} = object

proc updateWith*(self: PaymentRequestUpdateEvent; detailsPromise: JsObject): void {.wasmBindgen.}

type
  PaymentRequestUpdateEventInit* {.wasmBindgen.} = object

type
  PaymentComplete* {.wasmBindgen.} = enum
    Success
    Fail
    Unknown

type
  PaymentResponse* {.wasmBindgen.} = object
    requestId*: cstring
    methodName*: cstring
    details*: JsObject

proc toJSON*(self: PaymentResponse): JsObject {.wasmBindgen.}
proc complete*(self: PaymentResponse; result: PaymentComplete): JsObject {.wasmBindgen.}

type
  PCImplSignalingState* {.wasmBindgen.} = enum
    SignalingInvalid
    SignalingStable
    SignalingHaveLocalOffer
    SignalingHaveRemoteOffer
    SignalingHaveLocalPranswer
    SignalingHaveRemotePranswer
    SignalingClosed

type
  PCImplIceConnectionState* {.wasmBindgen.} = enum
    New
    Checking
    Connected
    Completed
    Failed
    Disconnected
    Closed

type
  PCImplIceGatheringState* {.wasmBindgen.} = enum
    New
    Gathering
    Complete

type
  PCObserverStateType* {.wasmBindgen.} = enum
    None
    IceConnectionState
    IceGatheringState
    SignalingState

type
  PerformanceEntryList* = JsObject

type
  Performance* {.wasmBindgen.} = object
    timeOrigin*: DOMHighResTimeStamp

proc now*(self: Performance): DOMHighResTimeStamp {.wasmBindgen.}

type
  PerformanceEntry* {.wasmBindgen.} = object
    name*: cstring
    entryType*: cstring
    startTime*: DOMHighResTimeStamp
    duration*: DOMHighResTimeStamp

proc toJSON*(self: PerformanceEntry): JsObject {.wasmBindgen.}

type
  PerformanceEntryEventInit* {.wasmBindgen.} = object
    name*: cstring
    entryType*: cstring
    startTime*: DOMHighResTimeStamp
    duration*: DOMHighResTimeStamp
    epoch*: float64
    origin*: cstring

type
  PerformanceEntryEvent* {.wasmBindgen.} = object
    name*: cstring
    entryType*: cstring
    startTime*: DOMHighResTimeStamp
    duration*: DOMHighResTimeStamp
    epoch*: float64
    origin*: cstring


type
  PerformanceMark* {.wasmBindgen.} = object


type
  PerformanceMeasure* {.wasmBindgen.} = object


type
  PerformanceNavigation* {.wasmBindgen.} = object
    tYPE_NAVIGATE*: uint16
    tYPE_RELOAD*: uint16
    tYPE_BACK_FORWARD*: uint16
    tYPE_RESERVED*: uint16
    typeVal*: uint16
    redirectCount*: uint16

proc toJSON*(self: PerformanceNavigation): JsObject {.wasmBindgen.}

type
  NavigationType* {.wasmBindgen.} = enum
    Navigate
    Reload
    Back_forward
    Prerender

type
  PerformanceNavigationTiming* {.wasmBindgen.} = object
    unloadEventStart*: DOMHighResTimeStamp
    unloadEventEnd*: DOMHighResTimeStamp
    domInteractive*: DOMHighResTimeStamp
    domContentLoadedEventStart*: DOMHighResTimeStamp
    domContentLoadedEventEnd*: DOMHighResTimeStamp
    domComplete*: DOMHighResTimeStamp
    loadEventStart*: DOMHighResTimeStamp
    loadEventEnd*: DOMHighResTimeStamp
    typeVal*: NavigationType
    redirectCount*: uint16

proc toJSON*(self: PerformanceNavigationTiming): JsObject {.wasmBindgen.}

type
  PerformanceObserverInit* {.wasmBindgen.} = object
    entryTypes*: JsObject
    buffered*: bool

type
  PerformanceObserverCallback* = proc

type
  PerformanceObserver* {.wasmBindgen.} = object

proc observe*(self: PerformanceObserver; options: PerformanceObserverInit): void {.wasmBindgen.}
proc disconnect*(self: PerformanceObserver): void {.wasmBindgen.}
proc takeRecords*(self: PerformanceObserver): PerformanceEntryList {.wasmBindgen.}

type
  PerformanceEntryFilterOptions* {.wasmBindgen.} = object
    name*: cstring
    entryType*: cstring
    initiatorType*: cstring

type
  PerformanceObserverEntryList* {.wasmBindgen.} = object

proc getEntries*(self: PerformanceObserverEntryList; filter: PerformanceEntryFilterOptions): PerformanceEntryList {.wasmBindgen.}
proc getEntriesByType*(self: PerformanceObserverEntryList; entryType: cstring): PerformanceEntryList {.wasmBindgen.}
proc getEntriesByName*(self: PerformanceObserverEntryList; name: cstring; entryType: cstring): PerformanceEntryList {.wasmBindgen.}

type
  PerformanceResourceTiming* {.wasmBindgen.} = object
    initiatorType*: cstring
    nextHopProtocol*: cstring
    workerStart*: DOMHighResTimeStamp
    redirectStart*: DOMHighResTimeStamp
    redirectEnd*: DOMHighResTimeStamp
    fetchStart*: DOMHighResTimeStamp
    domainLookupStart*: DOMHighResTimeStamp
    domainLookupEnd*: DOMHighResTimeStamp
    connectStart*: DOMHighResTimeStamp
    connectEnd*: DOMHighResTimeStamp
    secureConnectionStart*: DOMHighResTimeStamp
    requestStart*: DOMHighResTimeStamp
    responseStart*: DOMHighResTimeStamp
    responseEnd*: DOMHighResTimeStamp
    long*: uint32
    long*: uint32
    long*: uint32
    serverTiming*: JsObject

proc toJSON*(self: PerformanceResourceTiming): JsObject {.wasmBindgen.}

type
  PerformanceServerTiming* {.wasmBindgen.} = object
    name*: cstring
    duration*: DOMHighResTimeStamp
    description*: cstring

proc toJSON*(self: PerformanceServerTiming): JsObject {.wasmBindgen.}

type
  PerformanceTiming* {.wasmBindgen.} = object
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32
    long*: uint32

proc toJSON*(self: PerformanceTiming): JsObject {.wasmBindgen.}

type
  PeriodicWaveConstraints* {.wasmBindgen.} = object
    disableNormalization*: bool

type
  PeriodicWaveOptions* {.wasmBindgen.} = object
    real*: JsObject
    imag*: JsObject

type
  PeriodicWave* {.wasmBindgen.} = object


type
  PermissionState* {.wasmBindgen.} = enum
    Granted
    Denied
    Prompt

type
  PermissionStatus* {.wasmBindgen.} = object
    state*: PermissionState
    onchange*: EventHandler


type
  PermissionName* {.wasmBindgen.} = enum
    Geolocation
    Notifications
    Push
    Persistent_storage

type
  PermissionDescriptor* {.wasmBindgen.} = object
    name*: PermissionName

type
  Permissions* {.wasmBindgen.} = object

proc query*(self: Permissions; permission: JsObject): JsObject {.wasmBindgen.}
proc revoke*(self: Permissions; permission: JsObject): JsObject {.wasmBindgen.}

type
  Plugin* {.wasmBindgen.} = object
    description*: cstring
    filename*: cstring
    version*: cstring
    name*: cstring
    length*: uint32
    mimeType*: getter
    mimeType*: getter

proc item*(self: Plugin; index: uint32): Option[] {.wasmBindgen.}
proc namedItem*(self: Plugin; name: cstring): Option[] {.wasmBindgen.}

type
  PluginArray* {.wasmBindgen.} = object
    length*: uint32
    plugin*: getter
    plugin*: getter

proc item*(self: PluginArray; index: uint32): Option[] {.wasmBindgen.}
proc namedItem*(self: PluginArray; name: cstring): Option[] {.wasmBindgen.}
proc refresh*(self: PluginArray; reloadDocuments: bool): void {.wasmBindgen.}

type
  PluginCrashedEvent* {.wasmBindgen.} = object
    pluginID*: uint32
    pluginDumpID*: cstring
    pluginName*: cstring
    submittedCrashReport*: bool
    gmpPlugin*: bool


type
  PluginCrashedEventInit* {.wasmBindgen.} = object
    pluginID*: uint32
    pluginDumpID*: cstring
    pluginName*: cstring
    submittedCrashReport*: bool
    gmpPlugin*: bool

type
  PointerEvent* {.wasmBindgen.} = object
    pointerId*: int32
    width*: int32
    height*: int32
    pressure*: float32
    tangentialPressure*: float32
    tiltX*: int32
    tiltY*: int32
    twist*: int32
    pointerType*: cstring
    isPrimary*: bool

proc getCoalescedEvents*(self: PointerEvent): JsObject {.wasmBindgen.}

type
  PointerEventInit* {.wasmBindgen.} = object
    pointerId*: int32
    width*: int32
    height*: int32
    pressure*: float32
    tangentialPressure*: float32
    tiltX*: int32
    tiltY*: int32
    twist*: int32
    pointerType*: cstring
    isPrimary*: bool
    coalescedEvents*: JsObject

type
  PopStateEvent* {.wasmBindgen.} = object
    state*: JsObject


type
  PopStateEventInit* {.wasmBindgen.} = object
    state*: JsObject

type
  PopupBlockedEvent* {.wasmBindgen.} = object


type
  PopupBlockedEventInit* {.wasmBindgen.} = object
    popupWindowName*: cstring
    popupWindowFeatures*: cstring

type
  Position* {.wasmBindgen.} = object
    coords*: Coordinates
    timestamp*: DOMTimeStamp


type
  PositionError* {.wasmBindgen.} = object
    pERMISSION_DENIED*: uint16
    pOSITION_UNAVAILABLE*: uint16
    tIMEOUT*: uint16
    code*: uint16
    message*: cstring


type
  Presentation* {.wasmBindgen.} = object


type
  PresentationAvailability* {.wasmBindgen.} = object
    value*: bool
    onchange*: EventHandler


type
  PresentationConnectionState* {.wasmBindgen.} = enum
    Connecting
    Connected
    Closed
    Terminated

type
  PresentationConnectionBinaryType* {.wasmBindgen.} = enum
    Blob
    Arraybuffer

type
  PresentationConnection* {.wasmBindgen.} = object
    id*: cstring
    url*: cstring
    state*: PresentationConnectionState
    onconnect*: EventHandler
    onclose*: EventHandler
    onterminate*: EventHandler
    binaryType*: PresentationConnectionBinaryType
    onmessage*: EventHandler

proc send*(self: PresentationConnection; data: cstring): void {.wasmBindgen.}
proc send*(self: PresentationConnection; data: Blob): void {.wasmBindgen.}
proc send*(self: PresentationConnection; data: JsObject): void {.wasmBindgen.}
proc send*(self: PresentationConnection; data: JsObject): void {.wasmBindgen.}
proc close*(self: PresentationConnection): void {.wasmBindgen.}
proc terminate*(self: PresentationConnection): void {.wasmBindgen.}

type
  PresentationConnectionAvailableEvent* {.wasmBindgen.} = object
    connection*: PresentationConnection


type
  PresentationConnectionAvailableEventInit* {.wasmBindgen.} = object
    connection*: PresentationConnection

type
  PresentationConnectionClosedReason* {.wasmBindgen.} = enum
    Error
    Closed
    Wentaway

type
  PresentationConnectionCloseEvent* {.wasmBindgen.} = object
    reason*: PresentationConnectionClosedReason
    message*: cstring


type
  PresentationConnectionCloseEventInit* {.wasmBindgen.} = object
    reason*: PresentationConnectionClosedReason
    message*: cstring

type
  PresentationConnectionList* {.wasmBindgen.} = object
    connections*: JsObject
    onconnectionavailable*: EventHandler


type
  PresentationReceiver* {.wasmBindgen.} = object
    connectionList*: JsObject


type
  PresentationRequest* {.wasmBindgen.} = object
    onconnectionavailable*: EventHandler

proc start*(self: PresentationRequest): JsObject {.wasmBindgen.}
proc reconnect*(self: PresentationRequest; presentationId: cstring): JsObject {.wasmBindgen.}
proc getAvailability*(self: PresentationRequest): JsObject {.wasmBindgen.}
proc startWithDevice*(self: PresentationRequest; deviceId: cstring): JsObject {.wasmBindgen.}

type
  ProcessingInstruction* {.wasmBindgen.} = object
    target*: cstring


type
  ProfileTimelineStackFrame* {.wasmBindgen.} = object
    line*: int32
    column*: int32
    source*: cstring
    functionDisplayName*: cstring
    asyncCause*: cstring

type
  ProfileTimelineLayerRect* {.wasmBindgen.} = object
    x*: int32
    y*: int32
    width*: int32
    height*: int32

type
  ProfileTimelineMessagePortOperationType* {.wasmBindgen.} = enum
    SerializeData
    DeserializeData

type
  ProfileTimelineWorkerOperationType* {.wasmBindgen.} = enum
    SerializeDataOffMainThread
    SerializeDataOnMainThread
    DeserializeDataOffMainThread
    DeserializeDataOnMainThread

type
  ProfileTimelineMarker* {.wasmBindgen.} = object
    name*: cstring
    start*: DOMHighResTimeStamp
    endVal*: DOMHighResTimeStamp
    processType*: uint16
    isOffMainThread*: bool
    causeName*: cstring
    typeVal*: cstring
    eventPhase*: uint16
    long*: uint32
    rectangles*: JsObject
    isAnimationOnly*: bool
    messagePortOperation*: ProfileTimelineMessagePortOperationType
    workerOperation*: ProfileTimelineWorkerOperationType

type
  ProgressEvent* {.wasmBindgen.} = object
    lengthComputable*: bool
    long*: uint32
    long*: uint32


type
  ProgressEventInit* {.wasmBindgen.} = object
    lengthComputable*: bool
    long*: uint32
    long*: uint32

type
  PromiseJobCallback* = proc

type
  AnyCallback* = proc

type
  PromiseNativeHandler* {.wasmBindgen.} = object


type
  PromiseRejectionEvent* {.wasmBindgen.} = object
    promise*: JsObject
    reason*: JsObject


type
  PromiseRejectionEventInit* {.wasmBindgen.} = object
    promise*: JsObject
    reason*: JsObject

type
  PushEvent* {.wasmBindgen.} = object


type
  PushMessageDataInit* = JsObject

type
  PushEventInit* {.wasmBindgen.} = object
    data*: PushMessageDataInit

type
  PushSubscriptionOptionsInit* {.wasmBindgen.} = object
    userVisibleOnly*: bool

type
  PushManagerImpl* {.wasmBindgen.} = object

proc subscribe*(self: PushManagerImpl; options: PushSubscriptionOptionsInit): JsObject {.wasmBindgen.}
proc getSubscription*(self: PushManagerImpl): JsObject {.wasmBindgen.}
proc permissionState*(self: PushManagerImpl; options: PushSubscriptionOptionsInit): JsObject {.wasmBindgen.}

type
  PushManager* {.wasmBindgen.} = object

proc subscribe*(self: PushManager; options: PushSubscriptionOptionsInit): JsObject {.wasmBindgen.}
proc getSubscription*(self: PushManager): JsObject {.wasmBindgen.}
proc permissionState*(self: PushManager; options: PushSubscriptionOptionsInit): JsObject {.wasmBindgen.}

type
  PushPermissionState* {.wasmBindgen.} = enum
    Granted
    Denied
    Prompt

type
  PushMessageData* {.wasmBindgen.} = object

proc arrayBuffer*(self: PushMessageData): JsObject {.wasmBindgen.}
proc blob*(self: PushMessageData): Blob {.wasmBindgen.}
proc json*(self: PushMessageData): JsObject {.wasmBindgen.}
proc text*(self: PushMessageData): cstring {.wasmBindgen.}

type
  PushEncryptionKeyName* {.wasmBindgen.} = enum
    P256dh
    Auth

type
  PushSubscriptionKeys* {.wasmBindgen.} = object
    p256dh*: cstring
    auth*: cstring

type
  PushSubscriptionJSON* {.wasmBindgen.} = object
    endpoint*: cstring
    keys*: PushSubscriptionKeys

type
  PushSubscriptionInit* {.wasmBindgen.} = object
    endpoint*: cstring
    scope*: cstring

type
  PushSubscription* {.wasmBindgen.} = object
    endpoint*: cstring
    options*: PushSubscriptionOptions

proc getKey*(self: PushSubscription; name: PushEncryptionKeyName): Option[JsObject] {.wasmBindgen.}
proc unsubscribe*(self: PushSubscription): JsObject {.wasmBindgen.}
proc toJSON*(self: PushSubscription): PushSubscriptionJSON {.wasmBindgen.}

type
  PushSubscriptionOptions* {.wasmBindgen.} = object


type
  RTCCertificateExpiration* {.wasmBindgen.} = object
    expires*: DOMTimeStamp

type
  RTCCertificate* {.wasmBindgen.} = object
    expires*: DOMTimeStamp


type
  RTCIceCredentialType* {.wasmBindgen.} = enum
    Password
    Token

type
  RTCIceServer* {.wasmBindgen.} = object
    urls*: JsObject
    url*: cstring
    username*: cstring
    credential*: cstring
    credentialType*: RTCIceCredentialType

type
  RTCIceTransportPolicy* {.wasmBindgen.} = enum
    Relay
    All

type
  RTCBundlePolicy* {.wasmBindgen.} = enum
    Balanced
    Max_compat
    Max_bundle

type
  RTCConfiguration* {.wasmBindgen.} = object
    iceServers*: JsObject
    iceTransportPolicy*: RTCIceTransportPolicy
    bundlePolicy*: RTCBundlePolicy
    certificates*: JsObject

type
  RTCDTMFSender* {.wasmBindgen.} = object
    ontonechange*: EventHandler
    toneBuffer*: cstring

proc insertDTMF*(self: RTCDTMFSender; tones: cstring; duration: uint32; interToneGap: uint32): void {.wasmBindgen.}

type
  RTCDTMFToneChangeEvent* {.wasmBindgen.} = object
    tone*: cstring


type
  RTCDTMFToneChangeEventInit* {.wasmBindgen.} = object
    tone*: cstring

type
  RTCDataChannelState* {.wasmBindgen.} = enum
    Connecting
    Open
    Closing
    Closed

type
  RTCDataChannelType* {.wasmBindgen.} = enum
    Arraybuffer
    Blob

type
  RTCDataChannel* {.wasmBindgen.} = object
    label*: cstring
    reliable*: bool
    readyState*: RTCDataChannelState
    bufferedAmount*: uint32
    bufferedAmountLowThreshold*: uint32
    onopen*: EventHandler
    onerror*: EventHandler
    onclose*: EventHandler
    onmessage*: EventHandler
    onbufferedamountlow*: EventHandler
    binaryType*: RTCDataChannelType

proc close*(self: RTCDataChannel): void {.wasmBindgen.}
proc send*(self: RTCDataChannel; data: cstring): void {.wasmBindgen.}
proc send*(self: RTCDataChannel; data: Blob): void {.wasmBindgen.}
proc send*(self: RTCDataChannel; data: JsObject): void {.wasmBindgen.}
proc send*(self: RTCDataChannel; data: JsObject): void {.wasmBindgen.}

type
  RTCDataChannelEventInit* {.wasmBindgen.} = object
    channel*: RTCDataChannel

type
  RTCDataChannelEvent* {.wasmBindgen.} = object
    channel*: RTCDataChannel


type
  RTCIceCandidateInit* {.wasmBindgen.} = object
    candidate*: cstring

type
  RTCIceCandidate* {.wasmBindgen.} = object
    candidate*: cstring

proc toJSON*(self: RTCIceCandidate): JsObject {.wasmBindgen.}

type
  RTCIdentityAssertion* {.wasmBindgen.} = object
    idp*: cstring
    name*: cstring

type
  RTCIdentityProviderRegistrar* {.wasmBindgen.} = object
    hasIdp*: bool

proc register*(self: RTCIdentityProviderRegistrar; idp: RTCIdentityProvider): void {.wasmBindgen.}
proc generateAssertion*(self: RTCIdentityProviderRegistrar; contents: cstring; origin: cstring; options: RTCIdentityProviderOptions): JsObject {.wasmBindgen.}
proc validateAssertion*(self: RTCIdentityProviderRegistrar; assertion: cstring; origin: cstring): JsObject {.wasmBindgen.}

type
  RTCIdentityProvider* {.wasmBindgen.} = object
    generateAssertion*: GenerateAssertionCallback
    validateAssertion*: ValidateAssertionCallback

type
  GenerateAssertionCallback* = proc

type
  ValidateAssertionCallback* = proc

type
  RTCIdentityAssertionResult* {.wasmBindgen.} = object
    idp*: RTCIdentityProviderDetails
    assertion*: cstring

type
  RTCIdentityProviderDetails* {.wasmBindgen.} = object
    domain*: cstring
    protocol*: cstring

type
  RTCIdentityValidationResult* {.wasmBindgen.} = object
    identity*: cstring
    contents*: cstring

type
  RTCIdentityProviderOptions* {.wasmBindgen.} = object
    protocol*: cstring
    usernameHint*: cstring
    peerIdentity*: cstring

type
  RTCPeerConnectionIceErrorEvent* {.wasmBindgen.} = object
    url*: cstring
    errorCode*: uint16
    errorText*: cstring


type
  RTCPeerConnectionIceEventInit* {.wasmBindgen.} = object

type
  RTCPeerConnectionIceEvent* {.wasmBindgen.} = object


type
  RTCRtpReceiver* {.wasmBindgen.} = object
    track*: MediaStreamTrack

proc getCapabilities*(self: typedesc[RTCRtpReceiver]; kind: cstring): Option[RTCRtpCapabilities] {.wasmBindgen.}
proc getStats*(self: RTCRtpReceiver): JsObject {.wasmBindgen.}
proc getContributingSources*(self: RTCRtpReceiver): JsObject {.wasmBindgen.}
proc getSynchronizationSources*(self: RTCRtpReceiver): JsObject {.wasmBindgen.}
proc setStreamIds*(self: RTCRtpReceiver; streamIds: JsObject): void {.wasmBindgen.}
proc setRemoteSendBit*(self: RTCRtpReceiver; sendBit: bool): void {.wasmBindgen.}
proc processTrackAdditionsAndRemovals*(self: RTCRtpReceiver; transceiver: RTCRtpTransceiver; postProcessing: JsObject): void {.wasmBindgen.}

type
  RTCPriorityType* {.wasmBindgen.} = enum
    Very_low
    Low
    Medium
    High

type
  RTCDegradationPreference* {.wasmBindgen.} = enum
    Maintain_framerate
    Maintain_resolution
    Balanced

type
  RTCRtxParameters* {.wasmBindgen.} = object
    ssrc*: uint32

type
  RTCFecParameters* {.wasmBindgen.} = object
    ssrc*: uint32

type
  RTCRtpEncodingParameters* {.wasmBindgen.} = object
    ssrc*: uint32
    rtx*: RTCRtxParameters
    fec*: RTCFecParameters
    active*: bool
    priority*: RTCPriorityType
    maxBitrate*: uint32
    degradationPreference*: RTCDegradationPreference
    rid*: cstring
    scaleResolutionDownBy*: float32

type
  RTCRtpHeaderExtensionParameters* {.wasmBindgen.} = object
    uri*: cstring
    id*: uint16
    encrypted*: bool

type
  RTCRtcpParameters* {.wasmBindgen.} = object
    cname*: cstring
    reducedSize*: bool

type
  RTCRtpCodecParameters* {.wasmBindgen.} = object
    payloadType*: uint16
    mimeType*: cstring
    clockRate*: uint32
    channels*: uint16
    sdpFmtpLine*: cstring

type
  RTCRtpParameters* {.wasmBindgen.} = object
    encodings*: JsObject
    headerExtensions*: JsObject
    rtcp*: RTCRtcpParameters
    codecs*: JsObject

type
  RTCRtpCodecCapability* {.wasmBindgen.} = object
    mimeType*: cstring
    clockRate*: uint32
    channels*: uint16
    sdpFmtpLine*: cstring

type
  RTCRtpHeaderExtensionCapability* {.wasmBindgen.} = object
    uri*: cstring

type
  RTCRtpCapabilities* {.wasmBindgen.} = object
    codecs*: JsObject
    headerExtensions*: JsObject

type
  RTCRtpSender* {.wasmBindgen.} = object

proc setParameters*(self: RTCRtpSender; parameters: RTCRtpParameters): JsObject {.wasmBindgen.}
proc getParameters*(self: RTCRtpSender): RTCRtpParameters {.wasmBindgen.}
proc replaceTrack*(self: RTCRtpSender; withTrack: Option[MediaStreamTrack]): JsObject {.wasmBindgen.}
proc getStats*(self: RTCRtpSender): JsObject {.wasmBindgen.}
proc getCapabilities*(self: typedesc[RTCRtpSender]; kind: cstring): Option[RTCRtpCapabilities] {.wasmBindgen.}
proc getStreams*(self: RTCRtpSender): JsObject {.wasmBindgen.}
proc setStreams*(self: RTCRtpSender; streams: JsObject): void {.wasmBindgen.}
proc setTrack*(self: RTCRtpSender; track: Option[MediaStreamTrack]): void {.wasmBindgen.}
proc checkWasCreatedByPc*(self: RTCRtpSender; pc: RTCPeerConnection): void {.wasmBindgen.}

type
  RTCRtpContributingSource* {.wasmBindgen.} = object
    timestamp*: DOMHighResTimeStamp
    source*: uint32
    audioLevel*: float64

type
  RTCRtpSynchronizationSource* {.wasmBindgen.} = object

type
  RTCRtpSourceEntryType* {.wasmBindgen.} = enum
    Contributing
    Synchronization

type
  RTCRtpSourceEntry* {.wasmBindgen.} = object
    sourceType*: RTCRtpSourceEntryType

type
  RTCRtpTransceiverDirection* {.wasmBindgen.} = enum
    Sendrecv
    Sendonly
    Recvonly
    Inactive
    Stopped

type
  RTCRtpTransceiverInit* {.wasmBindgen.} = object
    direction*: RTCRtpTransceiverDirection
    streams*: JsObject
    sendEncodings*: JsObject

type
  RTCRtpTransceiver* {.wasmBindgen.} = object
    sender*: RTCRtpSender
    receiver*: RTCRtpReceiver
    stopped*: bool
    direction*: RTCRtpTransceiverDirection
    addTrackMagic*: bool
    shouldRemove*: bool

proc stop*(self: RTCRtpTransceiver): void {.wasmBindgen.}
proc setCodecPreferences*(self: RTCRtpTransceiver; codecs: JsObject): void {.wasmBindgen.}
proc setRemoteTrackId*(self: RTCRtpTransceiver; trackId: cstring): void {.wasmBindgen.}
proc remoteTrackIdIs*(self: RTCRtpTransceiver; trackId: cstring): bool {.wasmBindgen.}
proc getRemoteTrackId*(self: RTCRtpTransceiver): cstring {.wasmBindgen.}
proc setAddTrackMagic*(self: RTCRtpTransceiver): void {.wasmBindgen.}
proc setCurrentDirection*(self: RTCRtpTransceiver; direction: RTCRtpTransceiverDirection): void {.wasmBindgen.}
proc setDirectionInternal*(self: RTCRtpTransceiver; direction: RTCRtpTransceiverDirection): void {.wasmBindgen.}
proc setMid*(self: RTCRtpTransceiver; mid: cstring): void {.wasmBindgen.}
proc unsetMid*(self: RTCRtpTransceiver): void {.wasmBindgen.}
proc setStopped*(self: RTCRtpTransceiver): void {.wasmBindgen.}
proc getKind*(self: RTCRtpTransceiver): cstring {.wasmBindgen.}
proc hasBeenUsedToSend*(self: RTCRtpTransceiver): bool {.wasmBindgen.}
proc sync*(self: RTCRtpTransceiver): void {.wasmBindgen.}
proc insertDTMF*(self: RTCRtpTransceiver; tones: cstring; duration: uint32; interToneGap: uint32): void {.wasmBindgen.}

type
  RTCSdpType* {.wasmBindgen.} = enum
    Offer
    Pranswer
    Answer
    Rollback

type
  RTCSessionDescriptionInit* {.wasmBindgen.} = object
    typeVal*: RTCSdpType
    sdp*: cstring

type
  RTCSessionDescription* {.wasmBindgen.} = object
    typeVal*: RTCSdpType
    sdp*: cstring

proc toJSON*(self: RTCSessionDescription): JsObject {.wasmBindgen.}

type
  RTCStatsType* {.wasmBindgen.} = enum
    Inbound_rtp
    Outbound_rtp
    Csrc
    Session
    Track
    Transport
    Candidate_pair
    Local_candidate
    Remote_candidate

type
  RTCStats* {.wasmBindgen.} = object
    timestamp*: DOMHighResTimeStamp
    typeVal*: RTCStatsType
    id*: cstring

type
  RTCRTPStreamStats* {.wasmBindgen.} = object
    ssrc*: cstring
    mediaType*: cstring
    remoteId*: cstring
    isRemote*: bool
    mediaTrackId*: cstring
    transportId*: cstring
    codecId*: cstring
    bitrateMean*: float64
    bitrateStdDev*: float64
    framerateMean*: float64
    framerateStdDev*: float64
    firCount*: uint32
    pliCount*: uint32
    nackCount*: uint32

type
  RTCInboundRTPStreamStats* {.wasmBindgen.} = object
    packetsReceived*: uint32
    long*: uint32
    jitter*: float64
    packetsLost*: uint32
    roundTripTime*: int32
    discardedPackets*: uint32
    framesDecoded*: uint32

type
  RTCOutboundRTPStreamStats* {.wasmBindgen.} = object
    packetsSent*: uint32
    long*: uint32
    targetBitrate*: float64
    droppedFrames*: uint32
    framesEncoded*: uint32

type
  RTCMediaStreamTrackStats* {.wasmBindgen.} = object
    trackIdentifier*: cstring
    remoteSource*: bool
    ssrcIds*: JsObject
    frameWidth*: uint32
    frameHeight*: uint32
    framesPerSecond*: float64
    framesSent*: uint32
    framesReceived*: uint32
    framesDecoded*: uint32
    framesDropped*: uint32
    framesCorrupted*: uint32
    audioLevel*: float64
    echoReturnLoss*: float64
    echoReturnLossEnhancement*: float64

type
  RTCMediaStreamStats* {.wasmBindgen.} = object
    streamIdentifier*: cstring
    trackIds*: JsObject

type
  RTCRTPContributingSourceStats* {.wasmBindgen.} = object
    contributorSsrc*: uint32
    inboundRtpStreamId*: cstring

type
  RTCTransportStats* {.wasmBindgen.} = object
    bytesSent*: uint32
    bytesReceived*: uint32

type
  RTCIceComponentStats* {.wasmBindgen.} = object
    transportId*: cstring
    component*: int32
    bytesSent*: uint32
    bytesReceived*: uint32
    activeConnection*: bool

type
  RTCStatsIceCandidatePairState* {.wasmBindgen.} = enum
    Frozen
    Waiting
    Inprogress
    Failed
    Succeeded
    Cancelled

type
  RTCIceCandidatePairStats* {.wasmBindgen.} = object
    transportId*: cstring
    localCandidateId*: cstring
    remoteCandidateId*: cstring
    state*: RTCStatsIceCandidatePairState
    long*: uint32
    nominated*: bool
    writable*: bool
    readable*: bool
    long*: uint32
    long*: uint32
    lastPacketSentTimestamp*: DOMHighResTimeStamp
    lastPacketReceivedTimestamp*: DOMHighResTimeStamp
    selected*: bool
    componentId*: uint32

type
  RTCStatsIceCandidateType* {.wasmBindgen.} = enum
    Host
    Serverreflexive
    Peerreflexive
    Relayed

type
  RTCIceCandidateStats* {.wasmBindgen.} = object
    componentId*: cstring
    candidateId*: cstring
    ipAddress*: cstring
    transport*: cstring
    portNumber*: int32
    candidateType*: RTCStatsIceCandidateType

type
  RTCCodecStats* {.wasmBindgen.} = object
    payloadType*: uint32
    codec*: cstring
    clockRate*: uint32
    channels*: uint32
    parameters*: cstring

type
  RTCStatsReportInternal* {.wasmBindgen.} = object
    pcid*: cstring
    inboundRTPStreamStats*: JsObject
    outboundRTPStreamStats*: JsObject
    rtpContributingSourceStats*: JsObject
    mediaStreamTrackStats*: JsObject
    mediaStreamStats*: JsObject
    transportStats*: JsObject
    iceComponentStats*: JsObject
    iceCandidatePairStats*: JsObject
    iceCandidateStats*: JsObject
    codecStats*: JsObject
    localSdp*: cstring
    remoteSdp*: cstring
    timestamp*: DOMHighResTimeStamp
    iceRestarts*: uint32
    iceRollbacks*: uint32
    offerer*: bool
    closed*: bool
    trickledIceCandidateStats*: JsObject
    rawLocalCandidates*: JsObject
    rawRemoteCandidates*: JsObject

type
  RTCStatsReport* {.wasmBindgen.} = object


type
  RTCTrackEventInit* {.wasmBindgen.} = object
    receiver*: RTCRtpReceiver
    track*: MediaStreamTrack
    streams*: JsObject
    transceiver*: RTCRtpTransceiver

type
  RTCTrackEvent* {.wasmBindgen.} = object
    receiver*: RTCRtpReceiver
    track*: MediaStreamTrack
    streams*: JsObject
    transceiver*: RTCRtpTransceiver


type
  RadioNodeList* {.wasmBindgen.} = object
    value*: cstring


type
  Range* {.wasmBindgen.} = object
    startContainer*: Node
    startOffset*: uint32
    endContainer*: Node
    endOffset*: uint32
    collapsed*: bool
    commonAncestorContainer*: Node
    sTART_TO_START*: uint16
    sTART_TO_END*: uint16
    eND_TO_END*: uint16
    eND_TO_START*: uint16

proc setStart*(self: Range; refNode: Node; offset: uint32): void {.wasmBindgen.}
proc setEnd*(self: Range; refNode: Node; offset: uint32): void {.wasmBindgen.}
proc setStartBefore*(self: Range; refNode: Node): void {.wasmBindgen.}
proc setStartAfter*(self: Range; refNode: Node): void {.wasmBindgen.}
proc setEndBefore*(self: Range; refNode: Node): void {.wasmBindgen.}
proc setEndAfter*(self: Range; refNode: Node): void {.wasmBindgen.}
proc collapse*(self: Range; toStart: bool): void {.wasmBindgen.}
proc selectNode*(self: Range; refNode: Node): void {.wasmBindgen.}
proc selectNodeContents*(self: Range; refNode: Node): void {.wasmBindgen.}
proc compareBoundaryPoints*(self: Range; how: uint16; sourceRange: Range): int16 {.wasmBindgen.}
proc deleteContents*(self: Range): void {.wasmBindgen.}
proc extractContents*(self: Range): DocumentFragment {.wasmBindgen.}
proc cloneContents*(self: Range): DocumentFragment {.wasmBindgen.}
proc insertNode*(self: Range; node: Node): void {.wasmBindgen.}
proc surroundContents*(self: Range; newParent: Node): void {.wasmBindgen.}
proc cloneRange*(self: Range): Range {.wasmBindgen.}
proc detach*(self: Range): void {.wasmBindgen.}
proc isPointInRange*(self: Range; node: Node; offset: uint32): bool {.wasmBindgen.}
proc comparePoint*(self: Range; node: Node; offset: uint32): int16 {.wasmBindgen.}
proc intersectsNode*(self: Range; node: Node): bool {.wasmBindgen.}

type
  ClientRectsAndTexts* {.wasmBindgen.} = object
    rectList*: DOMRectList
    textList*: JsObject

type
  RequestInfo* = JsObject

type
  nsContentPolicyType* = JsObject

type
  Request* {.wasmBindgen.} = object
    methodVal*: cstring
    url*: cstring
    headers*: Headers
    destination*: RequestDestination
    referrer*: cstring
    referrerPolicy*: ReferrerPolicy
    mode*: RequestMode
    credentials*: RequestCredentials
    cache*: RequestCache
    redirect*: RequestRedirect
    integrity*: cstring
    signal*: AbortSignal

proc clone*(self: Request): Request {.wasmBindgen.}
proc overrideContentPolicyType*(self: Request; context: nsContentPolicyType): void {.wasmBindgen.}

type
  RequestDestination* {.wasmBindgen.} = enum
    Audio
    Audioworklet
    Document
    Embed
    Font
    Image
    Manifest
    ObjectVal
    Paintworklet
    Report
    Script
    Sharedworker
    Style
    Track
    Video
    Worker
    Xslt

type
  RequestMode* {.wasmBindgen.} = enum
    Same_origin
    No_cors
    Cors
    Navigate

type
  RequestCredentials* {.wasmBindgen.} = enum
    Omit
    Same_origin
    IncludeVal

type
  RequestCache* {.wasmBindgen.} = enum
    Default
    No_store
    Reload
    No_cache
    Force_cache
    Only_if_cached

type
  RequestRedirect* {.wasmBindgen.} = enum
    Follow
    Error
    Manual

type
  ReferrerPolicy* {.wasmBindgen.} = enum
    No_referrer
    No_referrer_when_downgrade
    Origin
    Origin_when_cross_origin
    Unsafe_url
    Same_origin
    Strict_origin
    Strict_origin_when_cross_origin

type
  ResizeObserverBoxOptions* {.wasmBindgen.} = enum
    Border_box
    Content_box
    Device_pixel_content_box

type
  ResizeObserverOptions* {.wasmBindgen.} = object
    box*: ResizeObserverBoxOptions

type
  ResizeObserver* {.wasmBindgen.} = object

proc observe*(self: ResizeObserver; target: Element; options: ResizeObserverOptions): void {.wasmBindgen.}
proc unobserve*(self: ResizeObserver; target: Element): void {.wasmBindgen.}
proc disconnect*(self: ResizeObserver): void {.wasmBindgen.}

type
  ResizeObserverCallback* = proc

type
  ResizeObserverEntry* {.wasmBindgen.} = object
    target*: Element
    contentRect*: DOMRectReadOnly
    borderBoxSize*: JsObject
    contentBoxSize*: JsObject
    devicePixelContentBoxSize*: JsObject


type
  ResizeObserverSize* {.wasmBindgen.} = object
    inlineSize*: float64
    blockSize*: float64


type
  Response* {.wasmBindgen.} = object
    typeVal*: ResponseType
    url*: cstring
    redirected*: bool
    status*: uint16
    ok*: bool
    statusText*: cstring
    headers*: Headers

proc error*(self: typedesc[Response]): Response {.wasmBindgen.}
proc redirect*(self: typedesc[Response]; url: cstring; status: uint16): Response {.wasmBindgen.}
proc clone*(self: Response): Response {.wasmBindgen.}
proc cloneUnfiltered*(self: Response): Response {.wasmBindgen.}

type
  ResponseType* {.wasmBindgen.} = enum
    Basic
    Cors
    Default
    Error
    Opaque
    Opaqueredirect

type
  SVGAElement* {.wasmBindgen.} = object
    target*: SVGAnimatedString
    download*: cstring
    ping*: cstring
    rel*: cstring
    referrerPolicy*: cstring
    relList*: DOMTokenList
    hreflang*: cstring
    typeVal*: cstring
    text*: cstring


type
  SVGAngle* {.wasmBindgen.} = object
    sVG_ANGLETYPE_UNKNOWN*: uint16
    sVG_ANGLETYPE_UNSPECIFIED*: uint16
    sVG_ANGLETYPE_DEG*: uint16
    sVG_ANGLETYPE_RAD*: uint16
    sVG_ANGLETYPE_GRAD*: uint16
    unitType*: uint16
    value*: float32
    valueInSpecifiedUnits*: float32
    valueAsString*: cstring

proc newValueSpecifiedUnits*(self: SVGAngle; unitType: uint16; valueInSpecifiedUnits: float32): void {.wasmBindgen.}
proc convertToSpecifiedUnits*(self: SVGAngle; unitType: uint16): void {.wasmBindgen.}

type
  SVGAnimateElement* {.wasmBindgen.} = object


type
  SVGAnimateMotionElement* {.wasmBindgen.} = object


type
  SVGAnimateTransformElement* {.wasmBindgen.} = object


type
  SVGAnimatedAngle* {.wasmBindgen.} = object
    baseVal*: SVGAngle
    animVal*: SVGAngle


type
  SVGAnimatedBoolean* {.wasmBindgen.} = object
    baseVal*: bool
    animVal*: bool


type
  SVGAnimatedEnumeration* {.wasmBindgen.} = object
    baseVal*: uint16
    animVal*: uint16


type
  SVGAnimatedInteger* {.wasmBindgen.} = object
    baseVal*: int32
    animVal*: int32


type
  SVGAnimatedLength* {.wasmBindgen.} = object
    baseVal*: SVGLength
    animVal*: SVGLength


type
  SVGAnimatedLengthList* {.wasmBindgen.} = object
    baseVal*: SVGLengthList
    animVal*: SVGLengthList


type
  SVGAnimatedNumber* {.wasmBindgen.} = object
    baseVal*: float32
    animVal*: float32


type
  SVGAnimatedNumberList* {.wasmBindgen.} = object
    baseVal*: SVGNumberList
    animVal*: SVGNumberList


type
  SVGAnimatedPreserveAspectRatio* {.wasmBindgen.} = object
    baseVal*: SVGPreserveAspectRatio
    animVal*: SVGPreserveAspectRatio


type
  SVGAnimatedRect* {.wasmBindgen.} = object


type
  SVGAnimatedString* {.wasmBindgen.} = object
    baseVal*: cstring
    animVal*: cstring


type
  SVGAnimatedTransformList* {.wasmBindgen.} = object
    baseVal*: SVGTransformList
    animVal*: SVGTransformList


type
  SVGAnimationElement* {.wasmBindgen.} = object

proc getStartTime*(self: SVGAnimationElement): float32 {.wasmBindgen.}
proc getCurrentTime*(self: SVGAnimationElement): float32 {.wasmBindgen.}
proc getSimpleDuration*(self: SVGAnimationElement): float32 {.wasmBindgen.}
proc beginElement*(self: SVGAnimationElement): void {.wasmBindgen.}
proc beginElementAt*(self: SVGAnimationElement; offset: float32): void {.wasmBindgen.}
proc endElement*(self: SVGAnimationElement): void {.wasmBindgen.}
proc endElementAt*(self: SVGAnimationElement; offset: float32): void {.wasmBindgen.}

type
  SVGCircleElement* {.wasmBindgen.} = object
    cx*: SVGAnimatedLength
    cy*: SVGAnimatedLength
    r*: SVGAnimatedLength


type
  SVGClipPathElement* {.wasmBindgen.} = object
    clipPathUnits*: SVGAnimatedEnumeration
    transform*: SVGAnimatedTransformList


type
  SVGComponentTransferFunctionElement* {.wasmBindgen.} = object
    sVG_FECOMPONENTTRANSFER_TYPE_UNKNOWN*: uint16
    sVG_FECOMPONENTTRANSFER_TYPE_IDENTITY*: uint16
    sVG_FECOMPONENTTRANSFER_TYPE_TABLE*: uint16
    sVG_FECOMPONENTTRANSFER_TYPE_DISCRETE*: uint16
    sVG_FECOMPONENTTRANSFER_TYPE_LINEAR*: uint16
    sVG_FECOMPONENTTRANSFER_TYPE_GAMMA*: uint16
    typeVal*: SVGAnimatedEnumeration
    tableValues*: SVGAnimatedNumberList
    slope*: SVGAnimatedNumber
    intercept*: SVGAnimatedNumber
    amplitude*: SVGAnimatedNumber
    exponent*: SVGAnimatedNumber
    offset*: SVGAnimatedNumber


type
  SVGDefsElement* {.wasmBindgen.} = object


type
  SVGDescElement* {.wasmBindgen.} = object


type
  SVGElement* {.wasmBindgen.} = object
    id*: cstring
    className*: SVGAnimatedString


type
  SVGEllipseElement* {.wasmBindgen.} = object
    cx*: SVGAnimatedLength
    cy*: SVGAnimatedLength
    rx*: SVGAnimatedLength
    ry*: SVGAnimatedLength


type
  SVGFEBlendElement* {.wasmBindgen.} = object
    sVG_FEBLEND_MODE_UNKNOWN*: uint16
    sVG_FEBLEND_MODE_NORMAL*: uint16
    sVG_FEBLEND_MODE_MULTIPLY*: uint16
    sVG_FEBLEND_MODE_SCREEN*: uint16
    sVG_FEBLEND_MODE_DARKEN*: uint16
    sVG_FEBLEND_MODE_LIGHTEN*: uint16
    sVG_FEBLEND_MODE_OVERLAY*: uint16
    sVG_FEBLEND_MODE_COLOR_DODGE*: uint16
    sVG_FEBLEND_MODE_COLOR_BURN*: uint16
    sVG_FEBLEND_MODE_HARD_LIGHT*: uint16
    sVG_FEBLEND_MODE_SOFT_LIGHT*: uint16
    sVG_FEBLEND_MODE_DIFFERENCE*: uint16
    sVG_FEBLEND_MODE_EXCLUSION*: uint16
    sVG_FEBLEND_MODE_HUE*: uint16
    sVG_FEBLEND_MODE_SATURATION*: uint16
    sVG_FEBLEND_MODE_COLOR*: uint16
    sVG_FEBLEND_MODE_LUMINOSITY*: uint16
    in1*: SVGAnimatedString
    in2*: SVGAnimatedString
    mode*: SVGAnimatedEnumeration


type
  SVGFEColorMatrixElement* {.wasmBindgen.} = object
    sVG_FECOLORMATRIX_TYPE_UNKNOWN*: uint16
    sVG_FECOLORMATRIX_TYPE_MATRIX*: uint16
    sVG_FECOLORMATRIX_TYPE_SATURATE*: uint16
    sVG_FECOLORMATRIX_TYPE_HUEROTATE*: uint16
    sVG_FECOLORMATRIX_TYPE_LUMINANCETOALPHA*: uint16
    in1*: SVGAnimatedString
    typeVal*: SVGAnimatedEnumeration
    values*: SVGAnimatedNumberList


type
  SVGFEComponentTransferElement* {.wasmBindgen.} = object
    in1*: SVGAnimatedString


type
  SVGFECompositeElement* {.wasmBindgen.} = object
    sVG_FECOMPOSITE_OPERATOR_UNKNOWN*: uint16
    sVG_FECOMPOSITE_OPERATOR_OVER*: uint16
    sVG_FECOMPOSITE_OPERATOR_IN*: uint16
    sVG_FECOMPOSITE_OPERATOR_OUT*: uint16
    sVG_FECOMPOSITE_OPERATOR_ATOP*: uint16
    sVG_FECOMPOSITE_OPERATOR_XOR*: uint16
    sVG_FECOMPOSITE_OPERATOR_ARITHMETIC*: uint16
    in1*: SVGAnimatedString
    in2*: SVGAnimatedString
    operator*: SVGAnimatedEnumeration
    k1*: SVGAnimatedNumber
    k2*: SVGAnimatedNumber
    k3*: SVGAnimatedNumber
    k4*: SVGAnimatedNumber


type
  SVGFEConvolveMatrixElement* {.wasmBindgen.} = object
    sVG_EDGEMODE_UNKNOWN*: uint16
    sVG_EDGEMODE_DUPLICATE*: uint16
    sVG_EDGEMODE_WRAP*: uint16
    sVG_EDGEMODE_NONE*: uint16
    in1*: SVGAnimatedString
    orderX*: SVGAnimatedInteger
    orderY*: SVGAnimatedInteger
    kernelMatrix*: SVGAnimatedNumberList
    divisor*: SVGAnimatedNumber
    bias*: SVGAnimatedNumber
    targetX*: SVGAnimatedInteger
    targetY*: SVGAnimatedInteger
    edgeMode*: SVGAnimatedEnumeration
    kernelUnitLengthX*: SVGAnimatedNumber
    kernelUnitLengthY*: SVGAnimatedNumber
    preserveAlpha*: SVGAnimatedBoolean


type
  SVGFEDiffuseLightingElement* {.wasmBindgen.} = object
    in1*: SVGAnimatedString
    surfaceScale*: SVGAnimatedNumber
    diffuseConstant*: SVGAnimatedNumber
    kernelUnitLengthX*: SVGAnimatedNumber
    kernelUnitLengthY*: SVGAnimatedNumber


type
  SVGFEDisplacementMapElement* {.wasmBindgen.} = object
    sVG_CHANNEL_UNKNOWN*: uint16
    sVG_CHANNEL_R*: uint16
    sVG_CHANNEL_G*: uint16
    sVG_CHANNEL_B*: uint16
    sVG_CHANNEL_A*: uint16
    in1*: SVGAnimatedString
    in2*: SVGAnimatedString
    scale*: SVGAnimatedNumber
    xChannelSelector*: SVGAnimatedEnumeration
    yChannelSelector*: SVGAnimatedEnumeration


type
  SVGFEDistantLightElement* {.wasmBindgen.} = object
    azimuth*: SVGAnimatedNumber
    elevation*: SVGAnimatedNumber


type
  SVGFEDropShadowElement* {.wasmBindgen.} = object
    in1*: SVGAnimatedString
    dx*: SVGAnimatedNumber
    dy*: SVGAnimatedNumber
    stdDeviationX*: SVGAnimatedNumber
    stdDeviationY*: SVGAnimatedNumber

proc setStdDeviation*(self: SVGFEDropShadowElement; stdDeviationX: float32; stdDeviationY: float32): void {.wasmBindgen.}

type
  SVGFEFloodElement* {.wasmBindgen.} = object


type
  SVGFEFuncAElement* {.wasmBindgen.} = object


type
  SVGFEFuncBElement* {.wasmBindgen.} = object


type
  SVGFEFuncGElement* {.wasmBindgen.} = object


type
  SVGFEFuncRElement* {.wasmBindgen.} = object


type
  SVGFEGaussianBlurElement* {.wasmBindgen.} = object
    in1*: SVGAnimatedString
    stdDeviationX*: SVGAnimatedNumber
    stdDeviationY*: SVGAnimatedNumber

proc setStdDeviation*(self: SVGFEGaussianBlurElement; stdDeviationX: float32; stdDeviationY: float32): void {.wasmBindgen.}

type
  SVGFEImageElement* {.wasmBindgen.} = object
    preserveAspectRatio*: SVGAnimatedPreserveAspectRatio


type
  SVGFEMergeElement* {.wasmBindgen.} = object


type
  SVGFEMergeNodeElement* {.wasmBindgen.} = object
    in1*: SVGAnimatedString


type
  SVGFEMorphologyElement* {.wasmBindgen.} = object
    sVG_MORPHOLOGY_OPERATOR_UNKNOWN*: uint16
    sVG_MORPHOLOGY_OPERATOR_ERODE*: uint16
    sVG_MORPHOLOGY_OPERATOR_DILATE*: uint16
    in1*: SVGAnimatedString
    operator*: SVGAnimatedEnumeration
    radiusX*: SVGAnimatedNumber
    radiusY*: SVGAnimatedNumber


type
  SVGFEOffsetElement* {.wasmBindgen.} = object
    in1*: SVGAnimatedString
    dx*: SVGAnimatedNumber
    dy*: SVGAnimatedNumber


type
  SVGFEPointLightElement* {.wasmBindgen.} = object
    x*: SVGAnimatedNumber
    y*: SVGAnimatedNumber
    z*: SVGAnimatedNumber


type
  SVGFESpecularLightingElement* {.wasmBindgen.} = object
    in1*: SVGAnimatedString
    surfaceScale*: SVGAnimatedNumber
    specularConstant*: SVGAnimatedNumber
    specularExponent*: SVGAnimatedNumber
    kernelUnitLengthX*: SVGAnimatedNumber
    kernelUnitLengthY*: SVGAnimatedNumber


type
  SVGFESpotLightElement* {.wasmBindgen.} = object
    x*: SVGAnimatedNumber
    y*: SVGAnimatedNumber
    z*: SVGAnimatedNumber
    pointsAtX*: SVGAnimatedNumber
    pointsAtY*: SVGAnimatedNumber
    pointsAtZ*: SVGAnimatedNumber
    specularExponent*: SVGAnimatedNumber
    limitingConeAngle*: SVGAnimatedNumber


type
  SVGFETileElement* {.wasmBindgen.} = object
    in1*: SVGAnimatedString


type
  SVGFETurbulenceElement* {.wasmBindgen.} = object
    sVG_TURBULENCE_TYPE_UNKNOWN*: uint16
    sVG_TURBULENCE_TYPE_FRACTALNOISE*: uint16
    sVG_TURBULENCE_TYPE_TURBULENCE*: uint16
    sVG_STITCHTYPE_UNKNOWN*: uint16
    sVG_STITCHTYPE_STITCH*: uint16
    sVG_STITCHTYPE_NOSTITCH*: uint16
    baseFrequencyX*: SVGAnimatedNumber
    baseFrequencyY*: SVGAnimatedNumber
    numOctaves*: SVGAnimatedInteger
    seed*: SVGAnimatedNumber
    stitchTiles*: SVGAnimatedEnumeration
    typeVal*: SVGAnimatedEnumeration


type
  SVGFilterElement* {.wasmBindgen.} = object
    filterUnits*: SVGAnimatedEnumeration
    primitiveUnits*: SVGAnimatedEnumeration
    x*: SVGAnimatedLength
    y*: SVGAnimatedLength
    width*: SVGAnimatedLength
    height*: SVGAnimatedLength


type
  SVGForeignObjectElement* {.wasmBindgen.} = object
    x*: SVGAnimatedLength
    y*: SVGAnimatedLength
    width*: SVGAnimatedLength
    height*: SVGAnimatedLength


type
  SVGGElement* {.wasmBindgen.} = object


type
  SVGGeometryElement* {.wasmBindgen.} = object
    pathLength*: SVGAnimatedNumber

proc getTotalLength*(self: SVGGeometryElement): float32 {.wasmBindgen.}
proc getPointAtLength*(self: SVGGeometryElement; distance: float32): SVGPoint {.wasmBindgen.}
proc isPointInFill*(self: SVGGeometryElement; point: DOMPointInit): bool {.wasmBindgen.}
proc isPointInStroke*(self: SVGGeometryElement; point: DOMPointInit): bool {.wasmBindgen.}

type
  SVGGradientElement* {.wasmBindgen.} = object
    sVG_SPREADMETHOD_UNKNOWN*: uint16
    sVG_SPREADMETHOD_PAD*: uint16
    sVG_SPREADMETHOD_REFLECT*: uint16
    sVG_SPREADMETHOD_REPEAT*: uint16
    gradientUnits*: SVGAnimatedEnumeration
    gradientTransform*: SVGAnimatedTransformList
    spreadMethod*: SVGAnimatedEnumeration


type
  SVGBoundingBoxOptions* {.wasmBindgen.} = object
    fill*: bool
    stroke*: bool
    markers*: bool
    clipped*: bool

type
  SVGGraphicsElement* {.wasmBindgen.} = object
    transform*: SVGAnimatedTransformList

proc getBBox*(self: SVGGraphicsElement; aOptions: SVGBoundingBoxOptions): SVGRect {.wasmBindgen.}
proc getCTM*(self: SVGGraphicsElement): Option[SVGMatrix] {.wasmBindgen.}
proc getScreenCTM*(self: SVGGraphicsElement): Option[SVGMatrix] {.wasmBindgen.}
proc getTransformToElement*(self: SVGGraphicsElement; element: SVGGraphicsElement): SVGMatrix {.wasmBindgen.}

type
  SVGImageElement* {.wasmBindgen.} = object
    x*: SVGAnimatedLength
    y*: SVGAnimatedLength
    width*: SVGAnimatedLength
    height*: SVGAnimatedLength
    preserveAspectRatio*: SVGAnimatedPreserveAspectRatio


type
  SVGLength* {.wasmBindgen.} = object
    sVG_LENGTHTYPE_UNKNOWN*: uint16
    sVG_LENGTHTYPE_NUMBER*: uint16
    sVG_LENGTHTYPE_PERCENTAGE*: uint16
    sVG_LENGTHTYPE_EMS*: uint16
    sVG_LENGTHTYPE_EXS*: uint16
    sVG_LENGTHTYPE_PX*: uint16
    sVG_LENGTHTYPE_CM*: uint16
    sVG_LENGTHTYPE_MM*: uint16
    sVG_LENGTHTYPE_IN*: uint16
    sVG_LENGTHTYPE_PT*: uint16
    sVG_LENGTHTYPE_PC*: uint16
    unitType*: uint16
    value*: float32
    valueInSpecifiedUnits*: float32
    valueAsString*: cstring

proc newValueSpecifiedUnits*(self: SVGLength; unitType: uint16; valueInSpecifiedUnits: float32): void {.wasmBindgen.}
proc convertToSpecifiedUnits*(self: SVGLength; unitType: uint16): void {.wasmBindgen.}

type
  SVGLengthList* {.wasmBindgen.} = object
    numberOfItems*: uint32
    sVGLength*: getter
    index*: JsObject

proc clear*(self: SVGLengthList): void {.wasmBindgen.}
proc initialize*(self: SVGLengthList; newItem: SVGLength): SVGLength {.wasmBindgen.}
proc insertItemBefore*(self: SVGLengthList; newItem: SVGLength; index: uint32): SVGLength {.wasmBindgen.}
proc replaceItem*(self: SVGLengthList; newItem: SVGLength; index: uint32): SVGLength {.wasmBindgen.}
proc removeItem*(self: SVGLengthList; index: uint32): SVGLength {.wasmBindgen.}
proc appendItem*(self: SVGLengthList; newItem: SVGLength): SVGLength {.wasmBindgen.}

type
  SVGLineElement* {.wasmBindgen.} = object
    x1*: SVGAnimatedLength
    y1*: SVGAnimatedLength
    x2*: SVGAnimatedLength
    y2*: SVGAnimatedLength


type
  SVGLinearGradientElement* {.wasmBindgen.} = object
    x1*: SVGAnimatedLength
    y1*: SVGAnimatedLength
    x2*: SVGAnimatedLength
    y2*: SVGAnimatedLength


type
  SVGMPathElement* {.wasmBindgen.} = object


type
  SVGMarkerElement* {.wasmBindgen.} = object
    sVG_MARKERUNITS_UNKNOWN*: uint16
    sVG_MARKERUNITS_USERSPACEONUSE*: uint16
    sVG_MARKERUNITS_STROKEWIDTH*: uint16
    sVG_MARKER_ORIENT_UNKNOWN*: uint16
    sVG_MARKER_ORIENT_AUTO*: uint16
    sVG_MARKER_ORIENT_ANGLE*: uint16
    refX*: SVGAnimatedLength
    refY*: SVGAnimatedLength
    markerUnits*: SVGAnimatedEnumeration
    markerWidth*: SVGAnimatedLength
    markerHeight*: SVGAnimatedLength
    orientType*: SVGAnimatedEnumeration
    orientAngle*: SVGAnimatedAngle

proc setOrientToAuto*(self: SVGMarkerElement): void {.wasmBindgen.}
proc setOrientToAngle*(self: SVGMarkerElement; angle: SVGAngle): void {.wasmBindgen.}

type
  SVGMaskElement* {.wasmBindgen.} = object
    sVG_MASKTYPE_LUMINANCE*: uint16
    sVG_MASKTYPE_ALPHA*: uint16
    maskUnits*: SVGAnimatedEnumeration
    maskContentUnits*: SVGAnimatedEnumeration
    x*: SVGAnimatedLength
    y*: SVGAnimatedLength
    width*: SVGAnimatedLength
    height*: SVGAnimatedLength


type
  SVGMatrix* {.wasmBindgen.} = object
    a*: float32
    b*: float32
    c*: float32
    d*: float32
    e*: float32
    f*: float32

proc multiply*(self: SVGMatrix; secondMatrix: SVGMatrix): SVGMatrix {.wasmBindgen.}
proc inverse*(self: SVGMatrix): SVGMatrix {.wasmBindgen.}
proc translate*(self: SVGMatrix; x: float32; y: float32): SVGMatrix {.wasmBindgen.}
proc scale*(self: SVGMatrix; scaleFactor: float32): SVGMatrix {.wasmBindgen.}
proc scaleNonUniform*(self: SVGMatrix; scaleFactorX: float32; scaleFactorY: float32): SVGMatrix {.wasmBindgen.}
proc rotate*(self: SVGMatrix; angle: float32): SVGMatrix {.wasmBindgen.}
proc rotateFromVector*(self: SVGMatrix; x: float32; y: float32): SVGMatrix {.wasmBindgen.}
proc flipX*(self: SVGMatrix): SVGMatrix {.wasmBindgen.}
proc flipY*(self: SVGMatrix): SVGMatrix {.wasmBindgen.}
proc skewX*(self: SVGMatrix; angle: float32): SVGMatrix {.wasmBindgen.}
proc skewY*(self: SVGMatrix; angle: float32): SVGMatrix {.wasmBindgen.}

type
  SVGMetadataElement* {.wasmBindgen.} = object


type
  SVGNumber* {.wasmBindgen.} = object
    value*: float32


type
  SVGNumberList* {.wasmBindgen.} = object
    numberOfItems*: uint32
    sVGNumber*: getter
    index*: JsObject

proc clear*(self: SVGNumberList): void {.wasmBindgen.}
proc initialize*(self: SVGNumberList; newItem: SVGNumber): SVGNumber {.wasmBindgen.}
proc insertItemBefore*(self: SVGNumberList; newItem: SVGNumber; index: uint32): SVGNumber {.wasmBindgen.}
proc replaceItem*(self: SVGNumberList; newItem: SVGNumber; index: uint32): SVGNumber {.wasmBindgen.}
proc removeItem*(self: SVGNumberList; index: uint32): SVGNumber {.wasmBindgen.}
proc appendItem*(self: SVGNumberList; newItem: SVGNumber): SVGNumber {.wasmBindgen.}

type
  SVGPathElement* {.wasmBindgen.} = object

proc getPathSegAtLength*(self: SVGPathElement; distance: float32): uint32 {.wasmBindgen.}

type
  SVGPathSeg* {.wasmBindgen.} = object
    pATHSEG_UNKNOWN*: uint16
    pATHSEG_CLOSEPATH*: uint16
    pATHSEG_MOVETO_ABS*: uint16
    pATHSEG_MOVETO_REL*: uint16
    pATHSEG_LINETO_ABS*: uint16
    pATHSEG_LINETO_REL*: uint16
    pATHSEG_CURVETO_CUBIC_ABS*: uint16
    pATHSEG_CURVETO_CUBIC_REL*: uint16
    pATHSEG_CURVETO_QUADRATIC_ABS*: uint16
    pATHSEG_CURVETO_QUADRATIC_REL*: uint16
    pATHSEG_ARC_ABS*: uint16
    pATHSEG_ARC_REL*: uint16
    pATHSEG_LINETO_HORIZONTAL_ABS*: uint16
    pATHSEG_LINETO_HORIZONTAL_REL*: uint16
    pATHSEG_LINETO_VERTICAL_ABS*: uint16
    pATHSEG_LINETO_VERTICAL_REL*: uint16
    pATHSEG_CURVETO_CUBIC_SMOOTH_ABS*: uint16
    pATHSEG_CURVETO_CUBIC_SMOOTH_REL*: uint16
    pATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS*: uint16
    pATHSEG_CURVETO_QUADRATIC_SMOOTH_REL*: uint16
    pathSegType*: uint16
    pathSegTypeAsLetter*: cstring


type
  SVGPathSegClosePath* {.wasmBindgen.} = object


type
  SVGPathSegMovetoAbs* {.wasmBindgen.} = object
    x*: float32
    y*: float32


type
  SVGPathSegMovetoRel* {.wasmBindgen.} = object
    x*: float32
    y*: float32


type
  SVGPathSegLinetoAbs* {.wasmBindgen.} = object
    x*: float32
    y*: float32


type
  SVGPathSegLinetoRel* {.wasmBindgen.} = object
    x*: float32
    y*: float32


type
  SVGPathSegCurvetoCubicAbs* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    x1*: float32
    y1*: float32
    x2*: float32
    y2*: float32


type
  SVGPathSegCurvetoCubicRel* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    x1*: float32
    y1*: float32
    x2*: float32
    y2*: float32


type
  SVGPathSegCurvetoQuadraticAbs* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    x1*: float32
    y1*: float32


type
  SVGPathSegCurvetoQuadraticRel* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    x1*: float32
    y1*: float32


type
  SVGPathSegArcAbs* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    r1*: float32
    r2*: float32
    angle*: float32
    largeArcFlag*: bool
    sweepFlag*: bool


type
  SVGPathSegArcRel* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    r1*: float32
    r2*: float32
    angle*: float32
    largeArcFlag*: bool
    sweepFlag*: bool


type
  SVGPathSegLinetoHorizontalAbs* {.wasmBindgen.} = object
    x*: float32


type
  SVGPathSegLinetoHorizontalRel* {.wasmBindgen.} = object
    x*: float32


type
  SVGPathSegLinetoVerticalAbs* {.wasmBindgen.} = object
    y*: float32


type
  SVGPathSegLinetoVerticalRel* {.wasmBindgen.} = object
    y*: float32


type
  SVGPathSegCurvetoCubicSmoothAbs* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    x2*: float32
    y2*: float32


type
  SVGPathSegCurvetoCubicSmoothRel* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    x2*: float32
    y2*: float32


type
  SVGPathSegCurvetoQuadraticSmoothAbs* {.wasmBindgen.} = object
    x*: float32
    y*: float32


type
  SVGPathSegCurvetoQuadraticSmoothRel* {.wasmBindgen.} = object
    x*: float32
    y*: float32


type
  SVGPathSegList* {.wasmBindgen.} = object
    numberOfItems*: uint32
    sVGPathSeg*: getter
    index*: JsObject


type
  SVGPatternElement* {.wasmBindgen.} = object
    patternUnits*: SVGAnimatedEnumeration
    patternContentUnits*: SVGAnimatedEnumeration
    patternTransform*: SVGAnimatedTransformList
    x*: SVGAnimatedLength
    y*: SVGAnimatedLength
    width*: SVGAnimatedLength
    height*: SVGAnimatedLength


type
  SVGPoint* {.wasmBindgen.} = object
    x*: float32
    y*: float32

proc matrixTransform*(self: SVGPoint; matrix: SVGMatrix): SVGPoint {.wasmBindgen.}

type
  SVGPointList* {.wasmBindgen.} = object
    numberOfItems*: uint32
    sVGPoint*: getter
    index*: JsObject

proc clear*(self: SVGPointList): void {.wasmBindgen.}
proc initialize*(self: SVGPointList; newItem: SVGPoint): SVGPoint {.wasmBindgen.}
proc insertItemBefore*(self: SVGPointList; newItem: SVGPoint; index: uint32): SVGPoint {.wasmBindgen.}
proc replaceItem*(self: SVGPointList; newItem: SVGPoint; index: uint32): SVGPoint {.wasmBindgen.}
proc removeItem*(self: SVGPointList; index: uint32): SVGPoint {.wasmBindgen.}
proc appendItem*(self: SVGPointList; newItem: SVGPoint): SVGPoint {.wasmBindgen.}

type
  SVGPolygonElement* {.wasmBindgen.} = object


type
  SVGPolylineElement* {.wasmBindgen.} = object


type
  SVGPreserveAspectRatio* {.wasmBindgen.} = object
    sVG_PRESERVEASPECTRATIO_UNKNOWN*: uint16
    sVG_PRESERVEASPECTRATIO_NONE*: uint16
    sVG_PRESERVEASPECTRATIO_XMINYMIN*: uint16
    sVG_PRESERVEASPECTRATIO_XMIDYMIN*: uint16
    sVG_PRESERVEASPECTRATIO_XMAXYMIN*: uint16
    sVG_PRESERVEASPECTRATIO_XMINYMID*: uint16
    sVG_PRESERVEASPECTRATIO_XMIDYMID*: uint16
    sVG_PRESERVEASPECTRATIO_XMAXYMID*: uint16
    sVG_PRESERVEASPECTRATIO_XMINYMAX*: uint16
    sVG_PRESERVEASPECTRATIO_XMIDYMAX*: uint16
    sVG_PRESERVEASPECTRATIO_XMAXYMAX*: uint16
    sVG_MEETORSLICE_UNKNOWN*: uint16
    sVG_MEETORSLICE_MEET*: uint16
    sVG_MEETORSLICE_SLICE*: uint16
    align*: uint16
    meetOrSlice*: uint16


type
  SVGRadialGradientElement* {.wasmBindgen.} = object
    cx*: SVGAnimatedLength
    cy*: SVGAnimatedLength
    r*: SVGAnimatedLength
    fx*: SVGAnimatedLength
    fy*: SVGAnimatedLength
    fr*: SVGAnimatedLength


type
  SVGRect* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    width*: float32
    height*: float32


type
  SVGRectElement* {.wasmBindgen.} = object
    x*: SVGAnimatedLength
    y*: SVGAnimatedLength
    width*: SVGAnimatedLength
    height*: SVGAnimatedLength
    rx*: SVGAnimatedLength
    ry*: SVGAnimatedLength


type
  SVGSVGElement* {.wasmBindgen.} = object
    x*: SVGAnimatedLength
    y*: SVGAnimatedLength
    width*: SVGAnimatedLength
    height*: SVGAnimatedLength
    useCurrentView*: bool
    currentScale*: float32
    currentTranslate*: SVGPoint

proc suspendRedraw*(self: SVGSVGElement; maxWaitMilliseconds: uint32): uint32 {.wasmBindgen.}
proc unsuspendRedraw*(self: SVGSVGElement; suspendHandleID: uint32): void {.wasmBindgen.}
proc unsuspendRedrawAll*(self: SVGSVGElement): void {.wasmBindgen.}
proc forceRedraw*(self: SVGSVGElement): void {.wasmBindgen.}
proc pauseAnimations*(self: SVGSVGElement): void {.wasmBindgen.}
proc unpauseAnimations*(self: SVGSVGElement): void {.wasmBindgen.}
proc animationsPaused*(self: SVGSVGElement): bool {.wasmBindgen.}
proc getCurrentTime*(self: SVGSVGElement): float32 {.wasmBindgen.}
proc setCurrentTime*(self: SVGSVGElement; seconds: float32): void {.wasmBindgen.}
proc deselectAll*(self: SVGSVGElement): void {.wasmBindgen.}
proc createSVGNumber*(self: SVGSVGElement): SVGNumber {.wasmBindgen.}
proc createSVGLength*(self: SVGSVGElement): SVGLength {.wasmBindgen.}
proc createSVGAngle*(self: SVGSVGElement): SVGAngle {.wasmBindgen.}
proc createSVGPoint*(self: SVGSVGElement): SVGPoint {.wasmBindgen.}
proc createSVGMatrix*(self: SVGSVGElement): SVGMatrix {.wasmBindgen.}
proc createSVGRect*(self: SVGSVGElement): SVGRect {.wasmBindgen.}
proc createSVGTransform*(self: SVGSVGElement): SVGTransform {.wasmBindgen.}
proc createSVGTransformFromMatrix*(self: SVGSVGElement; matrix: SVGMatrix): SVGTransform {.wasmBindgen.}
proc getElementById*(self: SVGSVGElement; elementId: cstring): Option[Element] {.wasmBindgen.}

type
  SVGScriptElement* {.wasmBindgen.} = object
    typeVal*: cstring


type
  SVGSetElement* {.wasmBindgen.} = object


type
  SVGStopElement* {.wasmBindgen.} = object
    offset*: SVGAnimatedNumber


type
  SVGStringList* {.wasmBindgen.} = object
    length*: uint32
    numberOfItems*: uint32

proc clear*(self: SVGStringList): void {.wasmBindgen.}
proc initialize*(self: SVGStringList; newItem: cstring): cstring {.wasmBindgen.}
proc getItem*(self: SVGStringList; index: uint32): cstring {.wasmBindgen.}
proc insertItemBefore*(self: SVGStringList; newItem: cstring; index: uint32): cstring {.wasmBindgen.}
proc replaceItem*(self: SVGStringList; newItem: cstring; index: uint32): cstring {.wasmBindgen.}
proc removeItem*(self: SVGStringList; index: uint32): cstring {.wasmBindgen.}
proc appendItem*(self: SVGStringList; newItem: cstring): cstring {.wasmBindgen.}

type
  SVGStyleElement* {.wasmBindgen.} = object
    xmlspace*: cstring
    typeVal*: cstring
    media*: cstring
    title*: cstring


type
  SVGSwitchElement* {.wasmBindgen.} = object


type
  SVGSymbolElement* {.wasmBindgen.} = object


type
  SVGTSpanElement* {.wasmBindgen.} = object


type
  SVGTextContentElement* {.wasmBindgen.} = object
    lENGTHADJUST_UNKNOWN*: uint16
    lENGTHADJUST_SPACING*: uint16
    lENGTHADJUST_SPACINGANDGLYPHS*: uint16
    textLength*: SVGAnimatedLength
    lengthAdjust*: SVGAnimatedEnumeration

proc getNumberOfChars*(self: SVGTextContentElement): int32 {.wasmBindgen.}
proc getComputedTextLength*(self: SVGTextContentElement): float32 {.wasmBindgen.}
proc getSubStringLength*(self: SVGTextContentElement; charnum: uint32; nchars: uint32): float32 {.wasmBindgen.}
proc getStartPositionOfChar*(self: SVGTextContentElement; charnum: uint32): SVGPoint {.wasmBindgen.}
proc getEndPositionOfChar*(self: SVGTextContentElement; charnum: uint32): SVGPoint {.wasmBindgen.}
proc getExtentOfChar*(self: SVGTextContentElement; charnum: uint32): SVGRect {.wasmBindgen.}
proc getRotationOfChar*(self: SVGTextContentElement; charnum: uint32): float32 {.wasmBindgen.}
proc getCharNumAtPosition*(self: SVGTextContentElement; point: SVGPoint): int32 {.wasmBindgen.}
proc selectSubString*(self: SVGTextContentElement; charnum: uint32; nchars: uint32): void {.wasmBindgen.}

type
  SVGTextElement* {.wasmBindgen.} = object


type
  SVGTextPathElement* {.wasmBindgen.} = object
    tEXTPATH_METHODTYPE_UNKNOWN*: uint16
    tEXTPATH_METHODTYPE_ALIGN*: uint16
    tEXTPATH_METHODTYPE_STRETCH*: uint16
    tEXTPATH_SPACINGTYPE_UNKNOWN*: uint16
    tEXTPATH_SPACINGTYPE_AUTO*: uint16
    tEXTPATH_SPACINGTYPE_EXACT*: uint16
    startOffset*: SVGAnimatedLength
    methodVal*: SVGAnimatedEnumeration
    spacing*: SVGAnimatedEnumeration


type
  SVGTextPositioningElement* {.wasmBindgen.} = object
    x*: SVGAnimatedLengthList
    y*: SVGAnimatedLengthList
    dx*: SVGAnimatedLengthList
    dy*: SVGAnimatedLengthList
    rotate*: SVGAnimatedNumberList


type
  SVGTitleElement* {.wasmBindgen.} = object


type
  SVGTransform* {.wasmBindgen.} = object
    sVG_TRANSFORM_UNKNOWN*: uint16
    sVG_TRANSFORM_MATRIX*: uint16
    sVG_TRANSFORM_TRANSLATE*: uint16
    sVG_TRANSFORM_SCALE*: uint16
    sVG_TRANSFORM_ROTATE*: uint16
    sVG_TRANSFORM_SKEWX*: uint16
    sVG_TRANSFORM_SKEWY*: uint16
    typeVal*: uint16
    matrix*: SVGMatrix
    angle*: float32

proc setMatrix*(self: SVGTransform; matrix: SVGMatrix): void {.wasmBindgen.}
proc setTranslate*(self: SVGTransform; tx: float32; ty: float32): void {.wasmBindgen.}
proc setScale*(self: SVGTransform; sx: float32; sy: float32): void {.wasmBindgen.}
proc setRotate*(self: SVGTransform; angle: float32; cx: float32; cy: float32): void {.wasmBindgen.}
proc setSkewX*(self: SVGTransform; angle: float32): void {.wasmBindgen.}
proc setSkewY*(self: SVGTransform; angle: float32): void {.wasmBindgen.}

type
  SVGTransformList* {.wasmBindgen.} = object
    numberOfItems*: uint32
    sVGTransform*: getter
    index*: JsObject

proc clear*(self: SVGTransformList): void {.wasmBindgen.}
proc initialize*(self: SVGTransformList; newItem: SVGTransform): SVGTransform {.wasmBindgen.}
proc insertItemBefore*(self: SVGTransformList; newItem: SVGTransform; index: uint32): SVGTransform {.wasmBindgen.}
proc replaceItem*(self: SVGTransformList; newItem: SVGTransform; index: uint32): SVGTransform {.wasmBindgen.}
proc removeItem*(self: SVGTransformList; index: uint32): SVGTransform {.wasmBindgen.}
proc appendItem*(self: SVGTransformList; newItem: SVGTransform): SVGTransform {.wasmBindgen.}
proc createSVGTransformFromMatrix*(self: SVGTransformList; matrix: SVGMatrix): SVGTransform {.wasmBindgen.}
proc consolidate*(self: SVGTransformList): Option[SVGTransform] {.wasmBindgen.}

type
  SVGUnitTypes* {.wasmBindgen.} = object
    sVG_UNIT_TYPE_UNKNOWN*: uint16
    sVG_UNIT_TYPE_USERSPACEONUSE*: uint16
    sVG_UNIT_TYPE_OBJECTBOUNDINGBOX*: uint16


type
  SVGUseElement* {.wasmBindgen.} = object
    x*: SVGAnimatedLength
    y*: SVGAnimatedLength
    width*: SVGAnimatedLength
    height*: SVGAnimatedLength


type
  SVGViewElement* {.wasmBindgen.} = object


type
  SVGZoomAndPan* {.wasmBindgen.} = object


type
  Screen* {.wasmBindgen.} = object
    availWidth*: int32
    availHeight*: int32
    width*: int32
    height*: int32
    colorDepth*: int32
    pixelDepth*: int32
    top*: int32
    left*: int32
    availTop*: int32
    availLeft*: int32


type
  ScreenColorGamut* {.wasmBindgen.} = enum
    Srgb
    P3
    Rec2020

type
  ScreenLuminance* {.wasmBindgen.} = object
    min*: float64
    max*: float64
    maxAverage*: float64


type
  OrientationType* {.wasmBindgen.} = enum
    Portrait_primary
    Portrait_secondary
    Landscape_primary
    Landscape_secondary

type
  OrientationLockType* {.wasmBindgen.} = enum
    Any
    Natural
    Landscape
    Portrait
    Portrait_primary
    Portrait_secondary
    Landscape_primary
    Landscape_secondary

type
  ScreenOrientation* {.wasmBindgen.} = object
    typeVal*: OrientationType
    angle*: uint16
    onchange*: EventHandler

proc lock*(self: ScreenOrientation; orientation: OrientationLockType): JsObject {.wasmBindgen.}
proc unlock*(self: ScreenOrientation): void {.wasmBindgen.}

type
  ScriptProcessorNode* {.wasmBindgen.} = object
    onaudioprocess*: EventHandler
    bufferSize*: int32


type
  ScrollAreaEvent* {.wasmBindgen.} = object
    x*: float32
    y*: float32
    width*: float32
    height*: float32

proc initScrollAreaEvent*(self: ScrollAreaEvent; typeVal: cstring; canBubble: bool; cancelable: bool; view: Option[Window]; detail: int32; x: float32; y: float32; width: float32; height: float32): void {.wasmBindgen.}

type
  ScrollBoxObject* {.wasmBindgen.} = object
    positionX*: int32
    positionY*: int32
    scrolledWidth*: int32
    scrolledHeight*: int32

proc scrollTo*(self: ScrollBoxObject; x: int32; y: int32): void {.wasmBindgen.}
proc scrollBy*(self: ScrollBoxObject; dx: int32; dy: int32): void {.wasmBindgen.}
proc scrollByIndex*(self: ScrollBoxObject; dindexes: int32): void {.wasmBindgen.}
proc scrollToElement*(self: ScrollBoxObject; child: Element): void {.wasmBindgen.}
proc ensureElementIsVisible*(self: ScrollBoxObject; child: Element): void {.wasmBindgen.}

type
  ScrollState* {.wasmBindgen.} = enum
    Started
    Stopped

type
  ScrollViewChangeEventInit* {.wasmBindgen.} = object
    state*: ScrollState

type
  ScrollViewChangeEvent* {.wasmBindgen.} = object
    state*: ScrollState


type
  SecurityPolicyViolationEventDisposition* {.wasmBindgen.} = enum
    Enforce
    Report

type
  SecurityPolicyViolationEvent* {.wasmBindgen.} = object
    documentURI*: cstring
    referrer*: cstring
    blockedURI*: cstring
    violatedDirective*: cstring
    effectiveDirective*: cstring
    originalPolicy*: cstring
    sourceFile*: cstring
    sample*: cstring
    disposition*: SecurityPolicyViolationEventDisposition
    statusCode*: uint16
    lineNumber*: int32
    columnNumber*: int32


type
  SecurityPolicyViolationEventInit* {.wasmBindgen.} = object
    documentURI*: cstring
    referrer*: cstring
    blockedURI*: cstring
    violatedDirective*: cstring
    effectiveDirective*: cstring
    originalPolicy*: cstring
    sourceFile*: cstring
    sample*: cstring
    disposition*: SecurityPolicyViolationEventDisposition
    statusCode*: uint16
    lineNumber*: int32
    columnNumber*: int32

type
  Selection* {.wasmBindgen.} = object
    anchorOffset*: uint32
    focusOffset*: uint32
    isCollapsed*: bool
    rangeCount*: uint32
    typeVal*: cstring

proc getRangeAt*(self: Selection; index: uint32): Range {.wasmBindgen.}
proc addRange*(self: Selection; range: Range): void {.wasmBindgen.}
proc removeRange*(self: Selection; range: Range): void {.wasmBindgen.}
proc removeAllRanges*(self: Selection): void {.wasmBindgen.}
proc empty*(self: Selection): void {.wasmBindgen.}
proc collapse*(self: Selection; node: Option[Node]; offset: uint32): void {.wasmBindgen.}
proc setPosition*(self: Selection; node: Option[Node]; offset: uint32): void {.wasmBindgen.}
proc collapseToStart*(self: Selection): void {.wasmBindgen.}
proc collapseToEnd*(self: Selection): void {.wasmBindgen.}
proc extend*(self: Selection; node: Node; offset: uint32): void {.wasmBindgen.}
proc setBaseAndExtent*(self: Selection; anchorNode: Node; anchorOffset: uint32; focusNode: Node; focusOffset: uint32): void {.wasmBindgen.}
proc selectAllChildren*(self: Selection; node: Node): void {.wasmBindgen.}
proc deleteFromDocument*(self: Selection): void {.wasmBindgen.}
proc containsNode*(self: Selection; node: Node; allowPartialContainment: bool): bool {.wasmBindgen.}

type
  ServiceWorker* {.wasmBindgen.} = object
    scriptURL*: cstring
    state*: ServiceWorkerState
    onstatechange*: EventHandler

proc postMessage*(self: ServiceWorker; message: JsObject; transferable: JsObject): void {.wasmBindgen.}

type
  ServiceWorkerContainer* {.wasmBindgen.} = object
    ready*: JsObject
    oncontrollerchange*: EventHandler
    onerror*: EventHandler
    onmessage*: EventHandler

proc register*(self: ServiceWorkerContainer; scriptURL: cstring; options: RegistrationOptions): JsObject {.wasmBindgen.}
proc getRegistration*(self: ServiceWorkerContainer; documentURL: cstring): JsObject {.wasmBindgen.}
proc getRegistrations*(self: ServiceWorkerContainer): JsObject {.wasmBindgen.}

type
  RegistrationOptions* {.wasmBindgen.} = object
    scope*: cstring
    typeVal*: cstring
    updateViaCache*: ServiceWorkerUpdateViaCache

type
  ServiceWorkerGlobalScope* {.wasmBindgen.} = object
    clients*: Clients
    registration*: ServiceWorkerRegistration
    oninstall*: EventHandler
    onactivate*: EventHandler
    onfetch*: EventHandler
    onmessage*: EventHandler

proc skipWaiting*(self: ServiceWorkerGlobalScope): JsObject {.wasmBindgen.}

type
  ServiceWorkerRegistration* {.wasmBindgen.} = object
    scope*: cstring
    updateViaCache*: ServiceWorkerUpdateViaCache
    onupdatefound*: EventHandler

proc update*(self: ServiceWorkerRegistration): JsObject {.wasmBindgen.}
proc unregister*(self: ServiceWorkerRegistration): JsObject {.wasmBindgen.}

type
  ServiceWorkerUpdateViaCache* {.wasmBindgen.} = enum
    Imports
    All
    None

type
  ShadowRootMode* {.wasmBindgen.} = enum
    Open
    Closed

type
  ShadowRoot* {.wasmBindgen.} = object
    mode*: ShadowRootMode
    host*: Element
    innerHTML*: cstring

proc getElementById*(self: ShadowRoot; elementId: cstring): Option[Element] {.wasmBindgen.}
proc getElementsByTagName*(self: ShadowRoot; localName: cstring): HTMLCollection {.wasmBindgen.}
proc getElementsByTagNameNS*(self: ShadowRoot; namespace: Option[cstring]; localName: cstring): HTMLCollection {.wasmBindgen.}
proc getElementsByClassName*(self: ShadowRoot; classNames: cstring): HTMLCollection {.wasmBindgen.}

type
  ShareData* {.wasmBindgen.} = object
    files*: JsObject
    title*: cstring
    text*: cstring
    url*: cstring

type
  SharedWorker* {.wasmBindgen.} = object
    port*: MessagePort


type
  SharedWorkerGlobalScope* {.wasmBindgen.} = object
    name*: cstring
    onconnect*: EventHandler

proc close*(self: SharedWorkerGlobalScope): void {.wasmBindgen.}

type
  ShowPopoverOptions* {.wasmBindgen.} = object
    source*: HTMLElement

type
  SocketReadyState* {.wasmBindgen.} = enum
    Opening
    Open
    Closing
    Closed
    Halfclosed

type
  SourceBufferAppendMode* {.wasmBindgen.} = enum
    Segments
    Sequence

type
  SourceBuffer* {.wasmBindgen.} = object
    mode*: SourceBufferAppendMode
    updating*: bool
    buffered*: TimeRanges
    timestampOffset*: float64
    audioTracks*: AudioTrackList
    videoTracks*: VideoTrackList
    textTracks*: TextTrackList
    appendWindowStart*: float64
    appendWindowEnd*: float64
    onupdatestart*: EventHandler
    onupdate*: EventHandler
    onupdateend*: EventHandler
    onerror*: EventHandler
    onabort*: EventHandler

proc appendBuffer*(self: SourceBuffer; data: JsObject): void {.wasmBindgen.}
proc appendBuffer*(self: SourceBuffer; data: JsObject): void {.wasmBindgen.}
proc appendBufferAsync*(self: SourceBuffer; data: JsObject): JsObject {.wasmBindgen.}
proc appendBufferAsync*(self: SourceBuffer; data: JsObject): JsObject {.wasmBindgen.}
proc abort*(self: SourceBuffer): void {.wasmBindgen.}
proc remove*(self: SourceBuffer; start: float64; endVal: float64): void {.wasmBindgen.}
proc removeAsync*(self: SourceBuffer; start: float64; endVal: float64): JsObject {.wasmBindgen.}
proc changeType*(self: SourceBuffer; typeVal: cstring): void {.wasmBindgen.}

type
  SourceBufferList* {.wasmBindgen.} = object
    length*: uint32
    onaddsourcebuffer*: EventHandler
    onremovesourcebuffer*: EventHandler


type
  SpeechGrammar* {.wasmBindgen.} = object
    src*: cstring
    weight*: float32


type
  SpeechGrammarList* {.wasmBindgen.} = object
    length*: uint32
    speechGrammar*: getter
    index*: JsObject

proc addFromURI*(self: SpeechGrammarList; src: cstring; weight: float32): void {.wasmBindgen.}
proc addFromString*(self: SpeechGrammarList; string: cstring; weight: float32): void {.wasmBindgen.}

type
  SpeechRecognition* {.wasmBindgen.} = object
    grammars*: SpeechGrammarList
    lang*: cstring
    continuous*: bool
    interimResults*: bool
    maxAlternatives*: uint32
    serviceURI*: cstring
    onaudiostart*: EventHandler
    onsoundstart*: EventHandler
    onspeechstart*: EventHandler
    onspeechend*: EventHandler
    onsoundend*: EventHandler
    onaudioend*: EventHandler
    onresult*: EventHandler
    onnomatch*: EventHandler
    onerror*: EventHandler
    onstart*: EventHandler
    onend*: EventHandler

proc start*(self: SpeechRecognition; stream: MediaStream): void {.wasmBindgen.}
proc stop*(self: SpeechRecognition): void {.wasmBindgen.}
proc abort*(self: SpeechRecognition): void {.wasmBindgen.}

type
  SpeechRecognitionAlternative* {.wasmBindgen.} = object
    transcript*: cstring
    confidence*: float32


type
  SpeechRecognitionErrorCode* {.wasmBindgen.} = enum
    No_speech
    Aborted
    Audio_capture
    Network
    Not_allowed
    Service_not_allowed
    Bad_grammar
    Language_not_supported

type
  SpeechRecognitionError* {.wasmBindgen.} = object
    error*: SpeechRecognitionErrorCode


type
  SpeechRecognitionErrorInit* {.wasmBindgen.} = object
    error*: SpeechRecognitionErrorCode
    message*: cstring

type
  SpeechRecognitionEvent* {.wasmBindgen.} = object
    resultIndex*: uint32
    interpretation*: JsObject


type
  SpeechRecognitionEventInit* {.wasmBindgen.} = object
    resultIndex*: uint32
    interpretation*: JsObject

type
  SpeechRecognitionResult* {.wasmBindgen.} = object
    length*: uint32
    speechRecognitionAlternative*: getter
    index*: JsObject
    isFinal*: bool


type
  SpeechRecognitionResultList* {.wasmBindgen.} = object
    length*: uint32
    speechRecognitionResult*: getter
    index*: JsObject


type
  SpeechSynthesis* {.wasmBindgen.} = object
    pending*: bool
    speaking*: bool
    paused*: bool
    onvoiceschanged*: EventHandler

proc speak*(self: SpeechSynthesis; utterance: SpeechSynthesisUtterance): void {.wasmBindgen.}
proc cancel*(self: SpeechSynthesis): void {.wasmBindgen.}
proc pause*(self: SpeechSynthesis): void {.wasmBindgen.}
proc resume*(self: SpeechSynthesis): void {.wasmBindgen.}
proc getVoices*(self: SpeechSynthesis): JsObject {.wasmBindgen.}
proc forceEnd*(self: SpeechSynthesis): void {.wasmBindgen.}

type
  SpeechSynthesisErrorCode* {.wasmBindgen.} = enum
    Canceled
    Interrupted
    Audio_busy
    Audio_hardware
    Network
    Synthesis_unavailable
    Synthesis_failed
    Language_unavailable
    Voice_unavailable
    Text_too_long
    Invalid_argument

type
  SpeechSynthesisErrorEvent* {.wasmBindgen.} = object
    error*: SpeechSynthesisErrorCode


type
  SpeechSynthesisErrorEventInit* {.wasmBindgen.} = object
    error*: SpeechSynthesisErrorCode

type
  SpeechSynthesisEvent* {.wasmBindgen.} = object
    utterance*: SpeechSynthesisUtterance
    charIndex*: uint32
    elapsedTime*: float32


type
  SpeechSynthesisEventInit* {.wasmBindgen.} = object
    utterance*: SpeechSynthesisUtterance
    charIndex*: uint32
    elapsedTime*: float32
    name*: cstring

type
  SpeechSynthesisUtterance* {.wasmBindgen.} = object
    text*: cstring
    lang*: cstring
    volume*: float32
    rate*: float32
    pitch*: float32
    onstart*: EventHandler
    onend*: EventHandler
    onerror*: EventHandler
    onpause*: EventHandler
    onresume*: EventHandler
    onmark*: EventHandler
    onboundary*: EventHandler
    chosenVoiceURI*: cstring


type
  SpeechSynthesisVoice* {.wasmBindgen.} = object
    voiceURI*: cstring
    name*: cstring
    lang*: cstring
    localService*: bool
    default*: bool


type
  StaticRangeInit* {.wasmBindgen.} = object
    startContainer*: Node
    startOffset*: uint32
    endContainer*: Node
    endOffset*: uint32

type
  StaticRange* {.wasmBindgen.} = object


type
  StereoPannerOptions* {.wasmBindgen.} = object
    pan*: float32

type
  StereoPannerNode* {.wasmBindgen.} = object
    pan*: AudioParam


type
  Storage* {.wasmBindgen.} = object
    length*: uint32
    dOMString*: getter
    undefined*: setter
    key*: JsObject
    undefined*: deleter
    key*: JsObject
    isSessionOnly*: bool

proc key*(self: Storage; index: uint32): Option[cstring] {.wasmBindgen.}
proc getItem*(self: Storage; key: cstring): Option[] {.wasmBindgen.}
proc clear*(self: Storage): void {.wasmBindgen.}

type
  StorageEvent* {.wasmBindgen.} = object

proc initStorageEvent*(self: StorageEvent; typeVal: cstring; canBubble: bool; cancelable: bool; key: Option[cstring]; oldValue: Option[cstring]; newValue: Option[cstring]; url: Option[cstring]; storageArea: Option[Storage]): void {.wasmBindgen.}

type
  StorageEventInit* {.wasmBindgen.} = object
    url*: cstring

type
  StorageManager* {.wasmBindgen.} = object

proc persisted*(self: StorageManager): JsObject {.wasmBindgen.}
proc persist*(self: StorageManager): JsObject {.wasmBindgen.}
proc estimate*(self: StorageManager): JsObject {.wasmBindgen.}

type
  StorageEstimate* {.wasmBindgen.} = object
    long*: uint32
    long*: uint32

type
  StorageType* {.wasmBindgen.} = enum
    Persistent
    Temporary
    Default

type
  StyleRuleChangeEvent* {.wasmBindgen.} = object


type
  StyleRuleChangeEventInit* {.wasmBindgen.} = object

type
  StyleSheet* {.wasmBindgen.} = object
    typeVal*: cstring
    media*: MediaList
    disabled*: bool
    sourceMapURL*: cstring
    sourceURL*: cstring


type
  StyleSheetApplicableStateChangeEvent* {.wasmBindgen.} = object
    applicable*: bool


type
  StyleSheetApplicableStateChangeEventInit* {.wasmBindgen.} = object
    applicable*: bool

type
  StyleSheetChangeEvent* {.wasmBindgen.} = object
    documentSheet*: bool


type
  StyleSheetChangeEventInit* {.wasmBindgen.} = object
    documentSheet*: bool

type
  StyleSheetList* {.wasmBindgen.} = object
    length*: uint32
    styleSheet*: getter

proc item*(self: StyleSheetList; index: uint32): Option[] {.wasmBindgen.}

type
  SubmitEvent* {.wasmBindgen.} = object


type
  SubmitEventInit* {.wasmBindgen.} = object

type
  KeyType* = JsObject

type
  KeyUsage* = JsObject

type
  NamedCurve* = JsObject

type
  BigInteger* = JsObject

type
  Algorithm* {.wasmBindgen.} = object
    name*: cstring

type
  AesCbcParams* {.wasmBindgen.} = object
    iv*: BufferSource

type
  AesCtrParams* {.wasmBindgen.} = object
    counter*: BufferSource
    octet*: required

type
  AesGcmParams* {.wasmBindgen.} = object
    iv*: BufferSource
    additionalData*: BufferSource
    tagLength*: uint8

type
  HmacImportParams* {.wasmBindgen.} = object
    hash*: AlgorithmIdentifier

type
  Pbkdf2Params* {.wasmBindgen.} = object
    salt*: BufferSource
    unsigned*: required
    iterations*: int32
    hash*: AlgorithmIdentifier

type
  RsaHashedImportParams* {.wasmBindgen.} = object
    hash*: AlgorithmIdentifier

type
  AesKeyGenParams* {.wasmBindgen.} = object
    unsigned*: required
    length*: int16

type
  HmacKeyGenParams* {.wasmBindgen.} = object
    hash*: AlgorithmIdentifier
    length*: uint32

type
  RsaOaepParams* {.wasmBindgen.} = object
    label*: BufferSource

type
  RsaPssParams* {.wasmBindgen.} = object
    unsigned*: required
    saltLength*: int32

type
  EcKeyGenParams* {.wasmBindgen.} = object
    namedCurve*: NamedCurve

type
  AesDerivedKeyParams* {.wasmBindgen.} = object
    unsigned*: required
    length*: int32

type
  HmacDerivedKeyParams* {.wasmBindgen.} = object
    length*: uint32

type
  EcdhKeyDeriveParams* {.wasmBindgen.} = object
    public*: CryptoKey

type
  DhKeyDeriveParams* {.wasmBindgen.} = object
    public*: CryptoKey

type
  EcdsaParams* {.wasmBindgen.} = object
    hash*: AlgorithmIdentifier

type
  EcKeyImportParams* {.wasmBindgen.} = object
    namedCurve*: NamedCurve

type
  HkdfParams* {.wasmBindgen.} = object
    hash*: AlgorithmIdentifier
    salt*: BufferSource
    info*: BufferSource

type
  RsaOtherPrimesInfo* {.wasmBindgen.} = object
    r*: cstring
    d*: cstring
    t*: cstring

type
  JsonWebKey* {.wasmBindgen.} = object
    kty*: cstring
    use*: cstring
    key_ops*: JsObject
    alg*: cstring
    ext*: bool
    crv*: cstring
    x*: cstring
    y*: cstring
    d*: cstring
    n*: cstring
    e*: cstring
    p*: cstring
    q*: cstring
    dp*: cstring
    dq*: cstring
    qi*: cstring
    oth*: JsObject
    k*: cstring

type
  CryptoKey* {.wasmBindgen.} = object
    typeVal*: KeyType
    extractable*: bool
    algorithm*: JsObject
    usages*: JsObject


type
  CryptoKeyPair* {.wasmBindgen.} = object
    publicKey*: CryptoKey
    privateKey*: CryptoKey

type
  KeyFormat* = JsObject

type
  AlgorithmIdentifier* = JsObject

type
  SubtleCrypto* {.wasmBindgen.} = object

proc encrypt*(self: SubtleCrypto; algorithm: AlgorithmIdentifier; key: CryptoKey; data: BufferSource): JsObject {.wasmBindgen.}
proc decrypt*(self: SubtleCrypto; algorithm: AlgorithmIdentifier; key: CryptoKey; data: BufferSource): JsObject {.wasmBindgen.}
proc sign*(self: SubtleCrypto; algorithm: AlgorithmIdentifier; key: CryptoKey; data: BufferSource): JsObject {.wasmBindgen.}
proc verify*(self: SubtleCrypto; algorithm: AlgorithmIdentifier; key: CryptoKey; signature: BufferSource; data: BufferSource): JsObject {.wasmBindgen.}
proc digest*(self: SubtleCrypto; algorithm: AlgorithmIdentifier; data: BufferSource): JsObject {.wasmBindgen.}
proc generateKey*(self: SubtleCrypto; algorithm: AlgorithmIdentifier; extractable: bool; keyUsages: JsObject): JsObject {.wasmBindgen.}
proc deriveKey*(self: SubtleCrypto; algorithm: AlgorithmIdentifier; baseKey: CryptoKey; derivedKeyType: AlgorithmIdentifier; extractable: bool; keyUsages: JsObject): JsObject {.wasmBindgen.}
proc deriveBits*(self: SubtleCrypto; algorithm: AlgorithmIdentifier; baseKey: CryptoKey; length: uint32): JsObject {.wasmBindgen.}
proc importKey*(self: SubtleCrypto; format: KeyFormat; keyData: JsObject; algorithm: AlgorithmIdentifier; extractable: bool; keyUsages: JsObject): JsObject {.wasmBindgen.}
proc exportKey*(self: SubtleCrypto; format: KeyFormat; key: CryptoKey): JsObject {.wasmBindgen.}
proc wrapKey*(self: SubtleCrypto; format: KeyFormat; key: CryptoKey; wrappingKey: CryptoKey; wrapAlgorithm: AlgorithmIdentifier): JsObject {.wasmBindgen.}
proc unwrapKey*(self: SubtleCrypto; format: KeyFormat; wrappedKey: BufferSource; unwrappingKey: CryptoKey; unwrapAlgorithm: AlgorithmIdentifier; unwrappedKeyAlgorithm: AlgorithmIdentifier; extractable: bool; keyUsages: JsObject): JsObject {.wasmBindgen.}

type
  ServerSocketOptions* {.wasmBindgen.} = object
    binaryType*: TCPSocketBinaryType

type
  TCPServerSocket* {.wasmBindgen.} = object
    localPort*: uint16
    onconnect*: EventHandler
    onerror*: EventHandler

proc close*(self: TCPServerSocket): void {.wasmBindgen.}

type
  TCPServerSocketEvent* {.wasmBindgen.} = object
    socket*: TCPSocket


type
  TCPServerSocketEventInit* {.wasmBindgen.} = object

type
  TCPSocketBinaryType* {.wasmBindgen.} = enum
    Arraybuffer
    String

type
  SocketOptions* {.wasmBindgen.} = object
    useSecureTransport*: bool
    binaryType*: TCPSocketBinaryType

type
  TCPReadyState* {.wasmBindgen.} = enum
    Connecting
    Open
    Closing
    Closed

type
  TCPSocket* {.wasmBindgen.} = object
    host*: cstring
    port*: uint16
    ssl*: bool
    long*: uint32
    readyState*: TCPReadyState
    binaryType*: TCPSocketBinaryType
    onopen*: EventHandler
    ondrain*: EventHandler
    ondata*: EventHandler
    onerror*: EventHandler
    onclose*: EventHandler

proc upgradeToSecure*(self: TCPSocket): void {.wasmBindgen.}
proc suspend*(self: TCPSocket): void {.wasmBindgen.}
proc resume*(self: TCPSocket): void {.wasmBindgen.}
proc close*(self: TCPSocket): void {.wasmBindgen.}
proc closeImmediately*(self: TCPSocket): void {.wasmBindgen.}
proc send*(self: TCPSocket; data: cstring): bool {.wasmBindgen.}
proc send*(self: TCPSocket; data: JsObject; byteOffset: uint32; byteLength: uint32): bool {.wasmBindgen.}

type
  TCPSocketErrorEvent* {.wasmBindgen.} = object
    name*: cstring
    message*: cstring


type
  TCPSocketErrorEventInit* {.wasmBindgen.} = object
    name*: cstring
    message*: cstring

type
  TCPSocketEvent* {.wasmBindgen.} = object
    data*: JsObject


type
  TCPSocketEventInit* {.wasmBindgen.} = object
    data*: JsObject

type
  Text* {.wasmBindgen.} = object
    wholeText*: cstring

proc splitText*(self: Text; offset: uint32): Text {.wasmBindgen.}

type
  TextClause* {.wasmBindgen.} = object
    startOffset*: int32
    endOffset*: int32
    isCaret*: bool
    isTargetClause*: bool


type
  TextDecoder* {.wasmBindgen.} = object
    encoding*: cstring
    fatal*: bool

proc decode*(self: TextDecoder; input: BufferSource; options: TextDecodeOptions): cstring {.wasmBindgen.}

type
  TextDecoderOptions* {.wasmBindgen.} = object
    fatal*: bool

type
  TextDecodeOptions* {.wasmBindgen.} = object
    stream*: bool

type
  TextEncoder* {.wasmBindgen.} = object
    encoding*: cstring

proc encode*(self: TextEncoder; input: cstring): seq[uint8] {.wasmBindgen.}

type
  TextTrackKind* {.wasmBindgen.} = enum
    Subtitles
    Captions
    Descriptions
    Chapters
    Metadata

type
  TextTrackMode* {.wasmBindgen.} = enum
    Disabled
    Hidden
    Showing

type
  TextTrack* {.wasmBindgen.} = object
    kind*: TextTrackKind
    label*: cstring
    language*: cstring
    id*: cstring
    inBandMetadataTrackDispatchType*: cstring
    mode*: TextTrackMode
    oncuechange*: EventHandler

proc addCue*(self: TextTrack; cue: VTTCue): void {.wasmBindgen.}
proc removeCue*(self: TextTrack; cue: VTTCue): void {.wasmBindgen.}

type
  TextTrackCue* {.wasmBindgen.} = object
    id*: cstring
    startTime*: float64
    endTime*: float64
    pauseOnExit*: bool
    onenter*: EventHandler
    onexit*: EventHandler


type
  TextTrackCueList* {.wasmBindgen.} = object
    length*: uint32

proc getCueById*(self: TextTrackCueList; id: cstring): Option[VTTCue] {.wasmBindgen.}

type
  TextTrackList* {.wasmBindgen.} = object
    length*: uint32
    onchange*: EventHandler
    onaddtrack*: EventHandler
    onremovetrack*: EventHandler

proc getTrackById*(self: TextTrackList; id: cstring): Option[TextTrack] {.wasmBindgen.}

type
  TimeEvent* {.wasmBindgen.} = object
    detail*: int32

proc initTimeEvent*(self: TimeEvent; aType: cstring; aView: Option[Window]; aDetail: int32): void {.wasmBindgen.}

type
  TimeRanges* {.wasmBindgen.} = object
    length*: uint32

proc start*(self: TimeRanges; index: uint32): float64 {.wasmBindgen.}
proc endVal*(self: TimeRanges; index: uint32): float64 {.wasmBindgen.}

type
  ToggleEvent* {.wasmBindgen.} = object
    oldState*: cstring
    newState*: cstring


type
  ToggleEventInit* {.wasmBindgen.} = object
    oldState*: cstring
    newState*: cstring

type
  TouchInit* {.wasmBindgen.} = object
    identifier*: int32
    target*: EventTarget
    clientX*: int32
    clientY*: int32
    screenX*: int32
    screenY*: int32
    pageX*: int32
    pageY*: int32
    radiusX*: float32
    radiusY*: float32
    rotationAngle*: float32
    force*: float32

type
  Touch* {.wasmBindgen.} = object
    identifier*: int32
    screenX*: int32
    screenY*: int32
    clientX*: int32
    clientY*: int32
    pageX*: int32
    pageY*: int32
    radiusX*: int32
    radiusY*: int32
    rotationAngle*: float32
    force*: float32


type
  TouchEventInit* {.wasmBindgen.} = object
    touches*: JsObject
    targetTouches*: JsObject
    changedTouches*: JsObject

type
  TouchEvent* {.wasmBindgen.} = object
    touches*: TouchList
    targetTouches*: TouchList
    changedTouches*: TouchList
    altKey*: bool
    metaKey*: bool
    ctrlKey*: bool
    shiftKey*: bool

proc initTouchEvent*(self: TouchEvent; typeVal: cstring; canBubble: bool; cancelable: bool; view: Option[Window]; detail: int32; ctrlKey: bool; altKey: bool; shiftKey: bool; metaKey: bool; touches: Option[TouchList]; targetTouches: Option[TouchList]; changedTouches: Option[TouchList]): void {.wasmBindgen.}

type
  TouchList* {.wasmBindgen.} = object
    length*: uint32
    touch*: getter

proc item*(self: TouchList; index: uint32): Option[] {.wasmBindgen.}

type
  TrackEvent* {.wasmBindgen.} = object


type
  TrackEventInit* {.wasmBindgen.} = object

type
  TransitionEvent* {.wasmBindgen.} = object
    propertyName*: cstring
    elapsedTime*: float32
    pseudoElement*: cstring


type
  TransitionEventInit* {.wasmBindgen.} = object
    propertyName*: cstring
    elapsedTime*: float32
    pseudoElement*: cstring

type
  TreeCellInfo* {.wasmBindgen.} = object
    row*: int32
    childElt*: cstring

type
  TreeBoxObject* {.wasmBindgen.} = object
    focused*: bool
    rowHeight*: int32
    rowWidth*: int32
    horizontalPosition*: int32
    selectionRegion*: nsIScriptableRegion

proc getFirstVisibleRow*(self: TreeBoxObject): int32 {.wasmBindgen.}
proc getLastVisibleRow*(self: TreeBoxObject): int32 {.wasmBindgen.}
proc getPageLength*(self: TreeBoxObject): int32 {.wasmBindgen.}
proc ensureRowIsVisible*(self: TreeBoxObject; index: int32): void {.wasmBindgen.}
proc ensureCellIsVisible*(self: TreeBoxObject; row: int32; col: Option[TreeColumn]): void {.wasmBindgen.}
proc scrollToRow*(self: TreeBoxObject; index: int32): void {.wasmBindgen.}
proc scrollByLines*(self: TreeBoxObject; numLines: int32): void {.wasmBindgen.}
proc scrollByPages*(self: TreeBoxObject; numPages: int32): void {.wasmBindgen.}
proc invalidate*(self: TreeBoxObject): void {.wasmBindgen.}
proc invalidateColumn*(self: TreeBoxObject; col: Option[TreeColumn]): void {.wasmBindgen.}
proc invalidateRow*(self: TreeBoxObject; index: int32): void {.wasmBindgen.}
proc invalidateCell*(self: TreeBoxObject; row: int32; col: Option[TreeColumn]): void {.wasmBindgen.}
proc invalidateRange*(self: TreeBoxObject; startIndex: int32; endIndex: int32): void {.wasmBindgen.}
proc getRowAt*(self: TreeBoxObject; x: int32; y: int32): int32 {.wasmBindgen.}
proc getCellAt*(self: TreeBoxObject; x: int32; y: int32): TreeCellInfo {.wasmBindgen.}
proc getCellAt*(self: TreeBoxObject; x: int32; y: int32; row: JsObject; column: JsObject; childElt: JsObject): void {.wasmBindgen.}
proc getCoordsForCellItem*(self: TreeBoxObject; row: int32; col: TreeColumn; element: cstring): Option[DOMRect] {.wasmBindgen.}
proc getCoordsForCellItem*(self: TreeBoxObject; row: int32; col: TreeColumn; element: cstring; x: JsObject; y: JsObject; width: JsObject; height: JsObject): void {.wasmBindgen.}
proc isCellCropped*(self: TreeBoxObject; row: int32; col: Option[TreeColumn]): bool {.wasmBindgen.}
proc rowCountChanged*(self: TreeBoxObject; index: int32; count: int32): void {.wasmBindgen.}
proc beginUpdateBatch*(self: TreeBoxObject): void {.wasmBindgen.}
proc endUpdateBatch*(self: TreeBoxObject): void {.wasmBindgen.}
proc clearStyleAndImageCaches*(self: TreeBoxObject): void {.wasmBindgen.}
proc removeImageCacheEntry*(self: TreeBoxObject; row: int32; col: TreeColumn): void {.wasmBindgen.}

type
  TreeView* {.wasmBindgen.} = object
    rowCount*: int32
    dROP_BEFORE*: int16
    dROP_ON*: int16
    dROP_AFTER*: int16

proc getRowProperties*(self: TreeView; row: int32): cstring {.wasmBindgen.}
proc getCellProperties*(self: TreeView; row: int32; column: TreeColumn): cstring {.wasmBindgen.}
proc getColumnProperties*(self: TreeView; column: TreeColumn): cstring {.wasmBindgen.}
proc isContainer*(self: TreeView; row: int32): bool {.wasmBindgen.}
proc isContainerOpen*(self: TreeView; row: int32): bool {.wasmBindgen.}
proc isContainerEmpty*(self: TreeView; row: int32): bool {.wasmBindgen.}
proc isSeparator*(self: TreeView; row: int32): bool {.wasmBindgen.}
proc isSorted*(self: TreeView): bool {.wasmBindgen.}
proc canDrop*(self: TreeView; row: int32; orientation: int32; dataTransfer: Option[DataTransfer]): bool {.wasmBindgen.}
proc drop*(self: TreeView; row: int32; orientation: int32; dataTransfer: Option[DataTransfer]): void {.wasmBindgen.}
proc getParentIndex*(self: TreeView; row: int32): int32 {.wasmBindgen.}
proc hasNextSibling*(self: TreeView; row: int32; afterIndex: int32): bool {.wasmBindgen.}
proc getLevel*(self: TreeView; row: int32): int32 {.wasmBindgen.}
proc getImageSrc*(self: TreeView; row: int32; column: TreeColumn): cstring {.wasmBindgen.}
proc getCellValue*(self: TreeView; row: int32; column: TreeColumn): cstring {.wasmBindgen.}
proc getCellText*(self: TreeView; row: int32; column: TreeColumn): cstring {.wasmBindgen.}
proc setTree*(self: TreeView; tree: Option[TreeBoxObject]): void {.wasmBindgen.}
proc toggleOpenState*(self: TreeView; row: int32): void {.wasmBindgen.}
proc cycleHeader*(self: TreeView; column: TreeColumn): void {.wasmBindgen.}
proc selectionChanged*(self: TreeView): void {.wasmBindgen.}
proc cycleCell*(self: TreeView; row: int32; column: TreeColumn): void {.wasmBindgen.}
proc isEditable*(self: TreeView; row: int32; column: TreeColumn): bool {.wasmBindgen.}
proc isSelectable*(self: TreeView; row: int32; column: TreeColumn): bool {.wasmBindgen.}
proc setCellValue*(self: TreeView; row: int32; column: TreeColumn; value: cstring): void {.wasmBindgen.}
proc setCellText*(self: TreeView; row: int32; column: TreeColumn; value: cstring): void {.wasmBindgen.}
proc performAction*(self: TreeView; action: cstring): void {.wasmBindgen.}
proc performActionOnRow*(self: TreeView; action: cstring; row: int32): void {.wasmBindgen.}
proc performActionOnCell*(self: TreeView; action: cstring; row: int32; column: TreeColumn): void {.wasmBindgen.}

type
  TreeWalker* {.wasmBindgen.} = object
    root*: Node
    whatToShow*: uint32
    currentNode*: Node

proc parentNode*(self: TreeWalker): Option[Node] {.wasmBindgen.}
proc firstChild*(self: TreeWalker): Option[Node] {.wasmBindgen.}
proc lastChild*(self: TreeWalker): Option[Node] {.wasmBindgen.}
proc previousSibling*(self: TreeWalker): Option[Node] {.wasmBindgen.}
proc nextSibling*(self: TreeWalker): Option[Node] {.wasmBindgen.}
proc previousNode*(self: TreeWalker): Option[Node] {.wasmBindgen.}
proc nextNode*(self: TreeWalker): Option[Node] {.wasmBindgen.}

type
  ErrorCode* = JsObject

type
  Transports* = JsObject

type
  Transport* {.wasmBindgen.} = enum
    Bt
    Ble
    Nfc
    Usb

type
  U2FClientData* {.wasmBindgen.} = object
    typ*: cstring
    challenge*: cstring
    origin*: cstring

type
  RegisterRequest* {.wasmBindgen.} = object
    version*: cstring
    challenge*: cstring

type
  RegisterResponse* {.wasmBindgen.} = object
    version*: cstring
    registrationData*: cstring
    clientData*: cstring

type
  RegisteredKey* {.wasmBindgen.} = object
    version*: cstring
    keyHandle*: cstring

type
  SignResponse* {.wasmBindgen.} = object
    keyHandle*: cstring
    signatureData*: cstring
    clientData*: cstring

type
  U2FRegisterCallback* = proc

type
  U2FSignCallback* = proc

type
  U2F* {.wasmBindgen.} = object
    oK*: uint16
    oTHER_ERROR*: uint16
    bAD_REQUEST*: uint16
    cONFIGURATION_UNSUPPORTED*: uint16
    dEVICE_INELIGIBLE*: uint16
    tIMEOUT*: uint16

proc register*(self: U2F; appId: cstring; registerRequests: JsObject; registeredKeys: JsObject; callback: U2FRegisterCallback; opt_timeoutSeconds: Option[int32]): void {.wasmBindgen.}
proc sign*(self: U2F; appId: cstring; challenge: cstring; registeredKeys: JsObject; callback: U2FSignCallback; opt_timeoutSeconds: Option[int32]): void {.wasmBindgen.}

type
  UDPMessageEvent* {.wasmBindgen.} = object
    remoteAddress*: cstring
    remotePort*: uint16
    data*: JsObject


type
  UDPMessageEventInit* {.wasmBindgen.} = object
    remoteAddress*: cstring
    remotePort*: uint16
    data*: JsObject

type
  UIEvent* {.wasmBindgen.} = object
    detail*: int32

proc initUIEvent*(self: UIEvent; aType: cstring; aCanBubble: bool; aCancelable: bool; aView: Option[Window]; aDetail: int32): void {.wasmBindgen.}

type
  UIEventInit* {.wasmBindgen.} = object
    detail*: int32

type
  EventModifierInit* {.wasmBindgen.} = object
    ctrlKey*: bool
    shiftKey*: bool
    altKey*: bool
    metaKey*: bool
    modifierAltGraph*: bool
    modifierCapsLock*: bool
    modifierFn*: bool
    modifierFnLock*: bool
    modifierNumLock*: bool
    modifierOS*: bool
    modifierScrollLock*: bool
    modifierSymbol*: bool
    modifierSymbolLock*: bool

type
  URL* {.wasmBindgen.} = object
    href*: cstring
    origin*: cstring
    protocol*: cstring
    username*: cstring
    password*: cstring
    host*: cstring
    hostname*: cstring
    port*: cstring
    pathname*: cstring
    search*: cstring
    searchParams*: URLSearchParams
    hash*: cstring

proc toJSON*(self: URL): cstring {.wasmBindgen.}

type
  URLSearchParams* {.wasmBindgen.} = object

proc append*(self: URLSearchParams; name: cstring; value: cstring): void {.wasmBindgen.}
proc delete*(self: URLSearchParams; name: cstring): void {.wasmBindgen.}
proc get*(self: URLSearchParams; name: cstring): Option[cstring] {.wasmBindgen.}
proc getAll*(self: URLSearchParams; name: cstring): JsObject {.wasmBindgen.}
proc has*(self: URLSearchParams; name: cstring): bool {.wasmBindgen.}
proc set*(self: URLSearchParams; name: cstring; value: cstring): void {.wasmBindgen.}
proc sort*(self: URLSearchParams): void {.wasmBindgen.}

type
  UserActivation* {.wasmBindgen.} = object
    hasBeenActive*: bool
    isActive*: bool


type
  UserProximityEvent* {.wasmBindgen.} = object
    near*: bool


type
  UserProximityEventInit* {.wasmBindgen.} = object
    near*: bool

type
  VREye* {.wasmBindgen.} = enum
    Left
    Right

type
  VRFieldOfView* {.wasmBindgen.} = object
    upDegrees*: float64
    rightDegrees*: float64
    downDegrees*: float64
    leftDegrees*: float64


type
  VRSource* = JsObject

type
  VRLayer* {.wasmBindgen.} = object
    leftBounds*: JsObject
    rightBounds*: JsObject

type
  VRDisplayCapabilities* {.wasmBindgen.} = object
    hasPosition*: bool
    hasOrientation*: bool
    hasExternalDisplay*: bool
    canPresent*: bool
    maxLayers*: uint32


type
  VRStageParameters* {.wasmBindgen.} = object
    sizeX*: float32
    sizeZ*: float32


type
  VRPose* {.wasmBindgen.} = object


type
  VRFrameData* {.wasmBindgen.} = object
    timestamp*: DOMHighResTimeStamp
    pose*: VRPose


type
  VRSubmitFrameResult* {.wasmBindgen.} = object
    frameNum*: uint32


type
  VREyeParameters* {.wasmBindgen.} = object
    fieldOfView*: VRFieldOfView
    renderWidth*: uint32
    renderHeight*: uint32


type
  VRDisplay* {.wasmBindgen.} = object
    presentingGroups*: uint32
    groupMask*: uint32
    isConnected*: bool
    isPresenting*: bool
    capabilities*: VRDisplayCapabilities
    displayId*: uint32
    displayName*: cstring
    depthNear*: float64
    depthFar*: float64

proc getEyeParameters*(self: VRDisplay; whichEye: VREye): VREyeParameters {.wasmBindgen.}
proc getFrameData*(self: VRDisplay; frameData: VRFrameData): bool {.wasmBindgen.}
proc getPose*(self: VRDisplay): VRPose {.wasmBindgen.}
proc getSubmitFrameResult*(self: VRDisplay; result: VRSubmitFrameResult): bool {.wasmBindgen.}
proc resetPose*(self: VRDisplay): void {.wasmBindgen.}
proc requestAnimationFrame*(self: VRDisplay; callback: FrameRequestCallback): int32 {.wasmBindgen.}
proc cancelAnimationFrame*(self: VRDisplay; handle: int32): void {.wasmBindgen.}
proc requestPresent*(self: VRDisplay; layers: JsObject): JsObject {.wasmBindgen.}
proc exitPresent*(self: VRDisplay): JsObject {.wasmBindgen.}
proc getLayers*(self: VRDisplay): JsObject {.wasmBindgen.}
proc submitFrame*(self: VRDisplay): void {.wasmBindgen.}

type
  VRMockDisplay* {.wasmBindgen.} = object

proc setEyeResolution*(self: VRMockDisplay; aRenderWidth: uint32; aRenderHeight: uint32): void {.wasmBindgen.}
proc setEyeParameter*(self: VRMockDisplay; eye: VREye; offsetX: float64; offsetY: float64; offsetZ: float64; upDegree: float64; rightDegree: float64; downDegree: float64; leftDegree: float64): void {.wasmBindgen.}
proc setPose*(self: VRMockDisplay; position: Option[seq[float32]]; linearVelocity: Option[seq[float32]]; linearAcceleration: Option[seq[float32]]; orientation: Option[seq[float32]]; angularVelocity: Option[seq[float32]]; angularAcceleration: Option[seq[float32]]): void {.wasmBindgen.}
proc setMountState*(self: VRMockDisplay; isMounted: bool): void {.wasmBindgen.}
proc update*(self: VRMockDisplay): void {.wasmBindgen.}

type
  VRMockController* {.wasmBindgen.} = object

proc newButtonEvent*(self: VRMockController; button: uint32; pressed: bool): void {.wasmBindgen.}
proc newAxisMoveEvent*(self: VRMockController; axis: uint32; value: float64): void {.wasmBindgen.}
proc newPoseMove*(self: VRMockController; position: Option[seq[float32]]; linearVelocity: Option[seq[float32]]; linearAcceleration: Option[seq[float32]]; orientation: Option[seq[float32]]; angularVelocity: Option[seq[float32]]; angularAcceleration: Option[seq[float32]]): void {.wasmBindgen.}

type
  VRServiceTest* {.wasmBindgen.} = object

proc attachVRDisplay*(self: VRServiceTest; id: cstring): JsObject {.wasmBindgen.}
proc attachVRController*(self: VRServiceTest; id: cstring): JsObject {.wasmBindgen.}

type
  AutoKeyword* {.wasmBindgen.} = enum
    Auto

type
  LineAlignSetting* {.wasmBindgen.} = enum
    Start
    Center
    EndVal

type
  PositionAlignSetting* {.wasmBindgen.} = enum
    Line_left
    Center
    Line_right
    Auto

type
  AlignSetting* {.wasmBindgen.} = enum
    Start
    Center
    EndVal
    Left
    Right

type
  DirectionSetting* {.wasmBindgen.} = enum
    Rl
    Lr

type
  VTTCue* {.wasmBindgen.} = object
    vertical*: DirectionSetting
    snapToLines*: bool
    line*: JsObject
    lineAlign*: LineAlignSetting
    position*: JsObject
    positionAlign*: PositionAlignSetting
    size*: float64
    align*: AlignSetting
    text*: cstring

proc getCueAsHTML*(self: VTTCue): DocumentFragment {.wasmBindgen.}

type
  ScrollSetting* {.wasmBindgen.} = enum
    Up

type
  VTTRegion* {.wasmBindgen.} = object
    id*: cstring
    width*: float64
    lines*: int32
    regionAnchorX*: float64
    regionAnchorY*: float64
    viewportAnchorX*: float64
    viewportAnchorY*: float64
    scroll*: ScrollSetting


type
  ValidityState* {.wasmBindgen.} = object
    valueMissing*: bool
    typeMismatch*: bool
    patternMismatch*: bool
    tooLong*: bool
    tooShort*: bool
    rangeUnderflow*: bool
    rangeOverflow*: bool
    stepMismatch*: bool
    badInput*: bool
    customError*: bool
    valid*: bool


type
  VibratePattern* = JsObject

type
  AlphaOption* {.wasmBindgen.} = enum
    Keep
    DiscardVal

type
  VideoFrame* {.wasmBindgen.} = object
    codedWidth*: uint32
    codedHeight*: uint32
    displayWidth*: uint32
    displayHeight*: uint32
    long*: uint32
    timestamp*: int64
    colorSpace*: VideoColorSpace

proc allocationSize*(self: VideoFrame; options: VideoFrameCopyToOptions): uint32 {.wasmBindgen.}
proc copyTo*(self: VideoFrame; destination: AllowSharedBufferSource; options: VideoFrameCopyToOptions): JsObject {.wasmBindgen.}
proc clone*(self: VideoFrame): VideoFrame {.wasmBindgen.}
proc close*(self: VideoFrame): void {.wasmBindgen.}

type
  VideoFrameInit* {.wasmBindgen.} = object
    long*: uint32
    timestamp*: int64
    alpha*: AlphaOption
    visibleRect*: DOMRectInit
    displayWidth*: uint32
    displayHeight*: uint32

type
  VideoFrameBufferInit* {.wasmBindgen.} = object
    format*: VideoPixelFormat
    codedWidth*: uint32
    codedHeight*: uint32
    timestamp*: int64
    long*: uint32
    layout*: JsObject
    visibleRect*: DOMRectInit
    displayWidth*: uint32
    displayHeight*: uint32
    colorSpace*: VideoColorSpaceInit

type
  VideoFrameCopyToOptions* {.wasmBindgen.} = object
    rect*: DOMRectInit
    layout*: JsObject
    format*: VideoPixelFormat
    colorSpace*: PredefinedColorSpace

type
  PlaneLayout* {.wasmBindgen.} = object
    unsigned*: required
    offset*: int32
    unsigned*: required
    stride*: int32

type
  VideoPixelFormat* {.wasmBindgen.} = enum
    I420
    I420P10
    I420P12
    I420A
    I420AP10
    I420AP12
    I422
    I422P10
    I422P12
    I422A
    I422AP10
    I422AP12
    I444
    I444P10
    I444P12
    I444A
    I444AP10
    I444AP12
    NV12
    RGBA
    RGBX
    BGRA
    BGRX

type
  VideoColorSpace* {.wasmBindgen.} = object

proc toJSON*(self: VideoColorSpace): VideoColorSpaceInit {.wasmBindgen.}

type
  VideoColorSpaceInit* {.wasmBindgen.} = object

type
  VideoColorPrimaries* {.wasmBindgen.} = enum
    Bt709
    Bt470bg
    Smpte170m
    Bt2020
    Smpte432

type
  VideoTransferCharacteristics* {.wasmBindgen.} = enum
    Bt709
    Smpte170m
    Iec61966_2_1
    Linear
    Pq
    Hlg

type
  VideoMatrixCoefficients* {.wasmBindgen.} = enum
    Rgb
    Bt709
    Bt470bg
    Smpte170m
    Bt2020_ncl

type
  VideoPlaybackQuality* {.wasmBindgen.} = object
    creationTime*: DOMHighResTimeStamp
    totalVideoFrames*: uint32
    droppedVideoFrames*: uint32
    corruptedVideoFrames*: uint32


type
  VideoStreamTrack* {.wasmBindgen.} = object


type
  VideoTrack* {.wasmBindgen.} = object
    id*: cstring
    kind*: cstring
    label*: cstring
    language*: cstring
    selected*: bool


type
  VideoTrackList* {.wasmBindgen.} = object
    length*: uint32
    selectedIndex*: int32
    onchange*: EventHandler
    onaddtrack*: EventHandler
    onremovetrack*: EventHandler

proc getTrackById*(self: VideoTrackList; id: cstring): Option[VideoTrack] {.wasmBindgen.}

type
  VisualViewport* {.wasmBindgen.} = object
    offsetLeft*: float64
    offsetTop*: float64
    pageLeft*: float64
    pageTop*: float64
    width*: float64
    height*: float64
    scale*: float64
    onresize*: EventHandler
    onscroll*: EventHandler
    onscrollend*: EventHandler


type
  OverSampleType* {.wasmBindgen.} = enum
    None
    2x
    4x

type
  WaveShaperOptions* {.wasmBindgen.} = object
    curve*: JsObject
    oversample*: OverSampleType

type
  WaveShaperNode* {.wasmBindgen.} = object
    oversample*: OverSampleType


type
  PublicKeyCredential* {.wasmBindgen.} = object
    rawId*: JsObject
    response*: AuthenticatorResponse

proc getClientExtensionResults*(self: PublicKeyCredential): AuthenticationExtensionsClientOutputs {.wasmBindgen.}

type
  CredentialCreationOptions* {.wasmBindgen.} = object
    publicKey*: PublicKeyCredentialCreationOptions

type
  CredentialRequestOptions* {.wasmBindgen.} = object
    publicKey*: PublicKeyCredentialRequestOptions

type
  AuthenticatorResponse* {.wasmBindgen.} = object
    clientDataJSON*: JsObject


type
  AuthenticatorAttestationResponse* {.wasmBindgen.} = object
    attestationObject*: JsObject

proc getTransports*(self: AuthenticatorAttestationResponse): JsObject {.wasmBindgen.}
proc getAuthenticatorData*(self: AuthenticatorAttestationResponse): JsObject {.wasmBindgen.}
proc getPublicKey*(self: AuthenticatorAttestationResponse): Option[JsObject] {.wasmBindgen.}
proc getPublicKeyAlgorithm*(self: AuthenticatorAttestationResponse): COSEAlgorithmIdentifier {.wasmBindgen.}

type
  AuthenticatorAssertionResponse* {.wasmBindgen.} = object
    authenticatorData*: JsObject
    signature*: JsObject


type
  PublicKeyCredentialParameters* {.wasmBindgen.} = object
    typeVal*: PublicKeyCredentialType
    alg*: COSEAlgorithmIdentifier

type
  PublicKeyCredentialCreationOptions* {.wasmBindgen.} = object
    rp*: PublicKeyCredentialRpEntity
    user*: PublicKeyCredentialUserEntity
    challenge*: BufferSource
    pubKeyCredParams*: JsObject
    timeout*: uint32
    excludeCredentials*: JsObject
    authenticatorSelection*: AuthenticatorSelectionCriteria
    attestation*: AttestationConveyancePreference
    extensions*: AuthenticationExtensionsClientInputs

type
  PublicKeyCredentialEntity* {.wasmBindgen.} = object
    name*: cstring
    icon*: cstring

type
  PublicKeyCredentialRpEntity* {.wasmBindgen.} = object
    id*: cstring

type
  PublicKeyCredentialUserEntity* {.wasmBindgen.} = object
    id*: BufferSource
    displayName*: cstring

type
  AuthenticatorSelectionCriteria* {.wasmBindgen.} = object
    authenticatorAttachment*: AuthenticatorAttachment
    residentKey*: cstring
    requireResidentKey*: bool
    userVerification*: UserVerificationRequirement

type
  AuthenticatorAttachment* {.wasmBindgen.} = enum
    Platform
    Cross_platform

type
  ResidentKeyRequirement* {.wasmBindgen.} = enum
    Discouraged
    Preferred
    Required

type
  AttestationConveyancePreference* {.wasmBindgen.} = enum
    None
    Indirect
    Direct
    Enterprise

type
  PublicKeyCredentialRequestOptions* {.wasmBindgen.} = object
    challenge*: BufferSource
    timeout*: uint32
    rpId*: cstring
    allowCredentials*: JsObject
    userVerification*: UserVerificationRequirement
    extensions*: AuthenticationExtensionsClientInputs

type
  AuthenticationExtensionsClientInputs* {.wasmBindgen.} = object

type
  AuthenticationExtensionsClientOutputs* {.wasmBindgen.} = object

type
  CollectedClientData* {.wasmBindgen.} = object
    typeVal*: cstring
    challenge*: cstring
    origin*: cstring
    dOMString*: required
    tokenBindingId*: cstring
    clientExtensions*: AuthenticationExtensionsClientInputs
    authenticatorExtensions*: AuthenticationExtensionsAuthenticatorInputs
    crossOrigin*: bool
    tokenBinding*: TokenBinding

type
  TokenBinding* {.wasmBindgen.} = object
    status*: cstring
    id*: cstring

type
  TokenBindingStatus* {.wasmBindgen.} = enum
    Present
    Supported

type
  PublicKeyCredentialType* {.wasmBindgen.} = enum
    Public_key

type
  PublicKeyCredentialDescriptor* {.wasmBindgen.} = object
    typeVal*: PublicKeyCredentialType
    id*: BufferSource
    transports*: JsObject

type
  AuthenticatorTransport* {.wasmBindgen.} = enum
    Usb
    Nfc
    Ble
    Internal

type
  COSEAlgorithmIdentifier* = JsObject

type
  UserVerificationRequirement* {.wasmBindgen.} = enum
    Required
    Preferred
    Discouraged

type
  AuthenticationExtensionsClientInputs* {.wasmBindgen.} = object
    appid*: cstring

type
  AuthenticationExtensionsClientOutputs* {.wasmBindgen.} = object
    appid*: bool

type
  AuthenticationExtensionsClientInputs* {.wasmBindgen.} = object
    appidExclude*: cstring

type
  AuthenticationExtensionsClientOutputs* {.wasmBindgen.} = object
    appidExclude*: bool

type
  AuthenticationExtensionsClientInputs* {.wasmBindgen.} = object
    uvm*: bool

type
  UvmEntry* = JsObject

type
  UvmEntries* = JsObject

type
  AuthenticationExtensionsClientOutputs* {.wasmBindgen.} = object
    uvm*: UvmEntries

type
  AuthenticationExtensionsClientInputs* {.wasmBindgen.} = object
    credProps*: bool

type
  CredentialPropertiesOutput* {.wasmBindgen.} = object
    rk*: bool

type
  AuthenticationExtensionsClientOutputs* {.wasmBindgen.} = object
    credProps*: CredentialPropertiesOutput

type
  AuthenticationExtensionsClientInputs* {.wasmBindgen.} = object
    largeBlob*: AuthenticationExtensionsLargeBlobInputs

type
  LargeBlobSupport* {.wasmBindgen.} = enum
    Required
    Preferred

type
  AuthenticationExtensionsLargeBlobInputs* {.wasmBindgen.} = object
    support*: cstring
    read*: bool
    write*: BufferSource

type
  AuthenticationExtensionsClientOutputs* {.wasmBindgen.} = object
    largeBlob*: AuthenticationExtensionsLargeBlobOutputs

type
  AuthenticationExtensionsLargeBlobOutputs* {.wasmBindgen.} = object
    supported*: bool
    blob*: JsObject
    written*: bool

type
  LifecycleConnectedCallback* = proc

type
  LifecycleDisconnectedCallback* = proc

type
  LifecycleAdoptedCallback* = proc

type
  LifecycleAttributeChangedCallback* = proc

type
  LifecycleCallbacks* {.wasmBindgen.} = object
    connectedCallback*: LifecycleConnectedCallback
    disconnectedCallback*: LifecycleDisconnectedCallback
    adoptedCallback*: LifecycleAdoptedCallback
    attributeChangedCallback*: LifecycleAttributeChangedCallback

type
  WebGLContextEvent* {.wasmBindgen.} = object
    statusMessage*: cstring


type
  WebGLContextEventInit* {.wasmBindgen.} = object
    statusMessage*: cstring

type
  WEBGL_multi_draw* {.wasmBindgen.} = object

proc multiDrawArraysWEBGL*(self: WEBGL_multi_draw; mode: GLenum; firstsList: JsObject; firstsOffset: GLuint; countsList: JsObject; countsOffset: GLuint; drawcount: GLsizei): void {.wasmBindgen.}
proc multiDrawElementsWEBGL*(self: WEBGL_multi_draw; mode: GLenum; countsList: JsObject; countsOffset: GLuint; typeVal: GLenum; offsetsList: JsObject; offsetsOffset: GLuint; drawcount: GLsizei): void {.wasmBindgen.}
proc multiDrawArraysInstancedWEBGL*(self: WEBGL_multi_draw; mode: GLenum; firstsList: JsObject; firstsOffset: GLuint; countsList: JsObject; countsOffset: GLuint; instanceCountsList: JsObject; instanceCountsOffset: GLuint; drawcount: GLsizei): void {.wasmBindgen.}
proc multiDrawElementsInstancedWEBGL*(self: WEBGL_multi_draw; mode: GLenum; countsList: JsObject; countsOffset: GLuint; typeVal: GLenum; offsetsList: JsObject; offsetsOffset: GLuint; instanceCountsList: JsObject; instanceCountsOffset: GLuint; drawcount: GLsizei): void {.wasmBindgen.}

type
  WebKitCSSMatrix* {.wasmBindgen.} = object

proc setMatrixValue*(self: WebKitCSSMatrix; transformList: cstring): WebKitCSSMatrix {.wasmBindgen.}
proc multiply*(self: WebKitCSSMatrix; other: WebKitCSSMatrix): WebKitCSSMatrix {.wasmBindgen.}
proc inverse*(self: WebKitCSSMatrix): WebKitCSSMatrix {.wasmBindgen.}
proc translate*(self: WebKitCSSMatrix; tx: float64; ty: float64; tz: float64): WebKitCSSMatrix {.wasmBindgen.}
proc scale*(self: WebKitCSSMatrix; scaleX: float64; scaleY: float64; scaleZ: float64): WebKitCSSMatrix {.wasmBindgen.}
proc rotate*(self: WebKitCSSMatrix; rotX: float64; rotY: float64; rotZ: float64): WebKitCSSMatrix {.wasmBindgen.}
proc rotateAxisAngle*(self: WebKitCSSMatrix; x: float64; y: float64; z: float64; angle: float64): WebKitCSSMatrix {.wasmBindgen.}
proc skewX*(self: WebKitCSSMatrix; sx: float64): WebKitCSSMatrix {.wasmBindgen.}
proc skewY*(self: WebKitCSSMatrix; sy: float64): WebKitCSSMatrix {.wasmBindgen.}

type
  WheelEvent* {.wasmBindgen.} = object
    dOM_DELTA_PIXEL*: uint32
    dOM_DELTA_LINE*: uint32
    dOM_DELTA_PAGE*: uint32
    deltaX*: float64
    deltaY*: float64
    deltaZ*: float64
    deltaMode*: uint32


type
  WheelEventInit* {.wasmBindgen.} = object
    deltaX*: float64
    deltaY*: float64
    deltaZ*: float64
    deltaMode*: uint32

type
  WidevineCDMManifest* {.wasmBindgen.} = object
    name*: cstring
    description*: cstring
    version*: cstring
    x*: cstring
    x*: cstring
    x*: cstring
    x*: cstring

type
  Worker* {.wasmBindgen.} = object
    onmessage*: EventHandler
    onmessageerror*: EventHandler

proc terminate*(self: Worker): void {.wasmBindgen.}
proc postMessage*(self: Worker; message: JsObject; transfer: JsObject): void {.wasmBindgen.}

type
  WorkerType* {.wasmBindgen.} = enum
    Classic
    Module

type
  ChromeWorker* {.wasmBindgen.} = object


type
  WorkerDebuggerGlobalScope* {.wasmBindgen.} = object
    global*: JsObject
    onmessage*: EventHandler

proc createSandbox*(self: WorkerDebuggerGlobalScope; name: cstring; prototype: JsObject): JsObject {.wasmBindgen.}
proc loadSubScript*(self: WorkerDebuggerGlobalScope; url: cstring; sandbox: JsObject): void {.wasmBindgen.}
proc enterEventLoop*(self: WorkerDebuggerGlobalScope): void {.wasmBindgen.}
proc leaveEventLoop*(self: WorkerDebuggerGlobalScope): void {.wasmBindgen.}
proc postMessage*(self: WorkerDebuggerGlobalScope; message: cstring): void {.wasmBindgen.}
proc setImmediate*(self: WorkerDebuggerGlobalScope; handler: Function): void {.wasmBindgen.}
proc reportError*(self: WorkerDebuggerGlobalScope; message: cstring): void {.wasmBindgen.}
proc retrieveConsoleEvents*(self: WorkerDebuggerGlobalScope): JsObject {.wasmBindgen.}
proc setConsoleEventHandler*(self: WorkerDebuggerGlobalScope; handler: Option[AnyCallback]): void {.wasmBindgen.}

type
  WorkerLocation* {.wasmBindgen.} = object
    href*: cstring
    origin*: cstring
    protocol*: cstring
    host*: cstring
    hostname*: cstring
    port*: cstring
    pathname*: cstring
    search*: cstring
    hash*: cstring


type
  WorkerNavigator* {.wasmBindgen.} = object


type
  Worklet* {.wasmBindgen.} = object

proc addModule*(self: Worklet; moduleURL: cstring; options: WorkletOptions): JsObject {.wasmBindgen.}

type
  WorkletOptions* {.wasmBindgen.} = object
    credentials*: RequestCredentials

type
  WorkletGlobalScope* {.wasmBindgen.} = object


type
  XMLDocument* {.wasmBindgen.} = object


type
  XMLHttpRequestEventTarget* {.wasmBindgen.} = object
    onloadstart*: EventHandler
    onprogress*: EventHandler
    onabort*: EventHandler
    onerror*: EventHandler
    onload*: EventHandler
    ontimeout*: EventHandler
    onloadend*: EventHandler


type
  XMLHttpRequestUpload* {.wasmBindgen.} = object


type
  XMLSerializer* {.wasmBindgen.} = object

proc serializeToString*(self: XMLSerializer; root: Node): cstring {.wasmBindgen.}

type
  XPathExpression* {.wasmBindgen.} = object

proc evaluate*(self: XPathExpression; contextNode: Node; typeVal: uint16; result: Option[JsObject]): XPathResult {.wasmBindgen.}
proc evaluateWithContext*(self: XPathExpression; contextNode: Node; contextPosition: uint32; contextSize: uint32; typeVal: uint16; result: Option[JsObject]): XPathResult {.wasmBindgen.}

type
  interface* = proc

type
  XPathResult* {.wasmBindgen.} = object
    aNY_TYPE*: uint16
    nUMBER_TYPE*: uint16
    sTRING_TYPE*: uint16
    bOOLEAN_TYPE*: uint16
    uNORDERED_NODE_ITERATOR_TYPE*: uint16
    oRDERED_NODE_ITERATOR_TYPE*: uint16
    uNORDERED_NODE_SNAPSHOT_TYPE*: uint16
    oRDERED_NODE_SNAPSHOT_TYPE*: uint16
    aNY_UNORDERED_NODE_TYPE*: uint16
    fIRST_ORDERED_NODE_TYPE*: uint16
    resultType*: uint16
    numberValue*: float64
    stringValue*: cstring
    booleanValue*: bool
    invalidIteratorState*: bool
    snapshotLength*: uint32

proc iterateNext*(self: XPathResult): Option[Node] {.wasmBindgen.}
proc snapshotItem*(self: XPathResult; index: uint32): Option[Node] {.wasmBindgen.}

type
  XSLTProcessor* {.wasmBindgen.} = object
    dISABLE_ALL_LOADS*: uint32
    flags*: uint32

proc importStylesheet*(self: XSLTProcessor; style: Node): void {.wasmBindgen.}
proc transformToFragment*(self: XSLTProcessor; source: Node; output: Document): DocumentFragment {.wasmBindgen.}
proc transformToDocument*(self: XSLTProcessor; source: Node): Document {.wasmBindgen.}
proc setParameter*(self: XSLTProcessor; namespaceURI: cstring; localName: cstring; value: JsObject): void {.wasmBindgen.}
proc getParameter*(self: XSLTProcessor; namespaceURI: cstring; localName: cstring): Option[nsIVariant] {.wasmBindgen.}
proc removeParameter*(self: XSLTProcessor; namespaceURI: cstring; localName: cstring): void {.wasmBindgen.}
proc clearParameters*(self: XSLTProcessor): void {.wasmBindgen.}
proc reset*(self: XSLTProcessor): void {.wasmBindgen.}

type
  nsISupports* = JsObject

