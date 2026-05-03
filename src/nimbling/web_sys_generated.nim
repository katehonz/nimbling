## Auto-generated WebIDL bindings for nimbling.
import nimbling/runtime
import nimbling/js_sys
import std/options

type
  AbortController* = distinct JsValue
  AbortSignal* = distinct JsValue
  AbstractRange* = distinct JsValue

  AnalyserOptions* = object
    fftSize*: uint32
    maxDecibels*: float64
    minDecibels*: float64
    smoothingTimeConstant*: float64
  AnalyserNode* = distinct JsValue
  AnimationPlayState* = enum
    AnimationPlayStateIdle
    AnimationPlayStateRunning
    AnimationPlayStatePaused
    AnimationPlayStateFinished
  Animation* = distinct JsValue
  FillMode* = enum
    FillModeNone
    FillModeForwards
    FillModeBackwards
    FillModeBoth
    FillModeAuto
  PlaybackDirection* = enum
    PlaybackDirectionNormal
    PlaybackDirectionReverse
    PlaybackDirectionAlternate
    PlaybackDirectionAlternate_reverse

  EffectTiming* = object
    delay*: float64
    endDelay*: float64
    fill*: JsObject
    iterationStart*: float64
    iterations*: float64
    duration*: JsObject
    direction*: JsObject
    easing*: cstring

  OptionalEffectTiming* = object
    delay*: float64
    endDelay*: float64
    fill*: JsObject
    iterationStart*: float64
    iterations*: float64
    duration*: JsObject
    direction*: JsObject
    easing*: cstring

  ComputedEffectTiming* = object
    endTime*: float64
    activeDuration*: float64
  AnimationEffect* = distinct JsValue
  AnimationEvent* = distinct JsValue

  AnimationEventInit* = object
    animationName*: cstring
    elapsedTime*: float32
    pseudoElement*: cstring
  FrameRequestCallback* = proc
  AnimationPlaybackEvent* = distinct JsValue

  AnimationPlaybackEventInit* = object
  AnimationTimeline* = distinct JsValue
  Attr* = distinct JsValue

  AudioBufferOptions* = object
    numberOfChannels*: uint32
    length*: uint32
    sampleRate*: float32
  AudioBuffer* = distinct JsValue
  AudioBufferSourceNode* = distinct JsValue

  AudioBufferSourceOptions* = object
    detune*: float32
    loop*: bool
    loopEnd*: float64
    loopStart*: float64
    playbackRate*: float32
  AudioContextLatencyCategory* = enum
    AudioContextLatencyCategoryBalanced
    AudioContextLatencyCategoryInteractive
    AudioContextLatencyCategoryPlayback

  AudioContextOptions* = object
    latencyHint*: JsObject
    sampleRate*: float32
  AudioContext* = distinct JsValue
  AudioDestinationNode* = distinct JsValue
  AudioListener* = distinct JsValue
  ChannelCountMode* = enum
    ChannelCountModeMax
    ChannelCountModeClamped_max
    ChannelCountModeExplicit
  ChannelInterpretation* = enum
    ChannelInterpretationSpeakers
    ChannelInterpretationDiscrete

  AudioNodeOptions* = object
    channelCount*: uint32
    channelCountMode*: JsObject
    channelInterpretation*: JsObject
  AudioNode* = distinct JsValue
  AudioParam* = distinct JsValue
  AudioParamMap* = distinct JsValue
  AudioProcessingEvent* = distinct JsValue
  AudioScheduledSourceNode* = distinct JsValue
  AudioStreamTrack* = distinct JsValue
  AudioTrack* = distinct JsValue
  AudioTrackList* = distinct JsValue
  AudioWorklet* = distinct JsValue
  AudioWorkletGlobalScope* = distinct JsValue

  AudioWorkletNodeOptions* = object
    numberOfInputs*: uint32
    numberOfOutputs*: uint32
    outputChannelCount*: JsObject
    parameterData*: JsObject
  AudioWorkletNode* = distinct JsValue
  AudioWorkletProcessor* = distinct JsValue

  AutocompleteInfo* = object
    section*: cstring
    addressType*: cstring
    contactType*: cstring
    fieldName*: cstring
  BarProp* = distinct JsValue
  DecodeSuccessCallback* = proc
  DecodeErrorCallback* = proc
  AudioContextState* = enum
    AudioContextStateSuspended
    AudioContextStateRunning
    AudioContextStateClosed
  BaseAudioContext* = distinct JsValue
  CompositeOperation* = enum
    CompositeOperationReplace
    CompositeOperationAdd
    CompositeOperationAccumulate

  BasePropertyIndexedKeyframe* = object
    offset*: JsObject
    easing*: JsObject
    composite*: JsObject

  BaseKeyframe* = object
    easing*: cstring
    simulateComputeValuesFailure*: bool

  BaseComputedKeyframe* = object
    computedOffset*: float64
  BasicCardType* = enum
    BasicCardTypeCredit
    BasicCardTypeDebit
    BasicCardTypePrepaid

  BasicCardRequest* = object
    supportedNetworks*: JsObject
    supportedTypes*: JsObject

  BasicCardResponse* = object
    cardholderName*: cstring
    cardNumber*: cstring
    expiryMonth*: cstring
    expiryYear*: cstring
    cardSecurityCode*: cstring
  BatteryManager* = distinct JsValue
  BeforeUnloadEvent* = distinct JsValue
  BiquadFilterType* = enum
    BiquadFilterTypeLowpass
    BiquadFilterTypeHighpass
    BiquadFilterTypeBandpass
    BiquadFilterTypeLowshelf
    BiquadFilterTypeHighshelf
    BiquadFilterTypePeaking
    BiquadFilterTypeNotch
    BiquadFilterTypeAllpass

  BiquadFilterOptions* = object
    typeVal*: JsObject
    q*: float32
    detune*: float32
    frequency*: float32
    gain*: float32
  BiquadFilterNode* = distinct JsValue
  BlobPart* = JsObject
  Blob* = distinct JsValue
  EndingTypes* = enum
    EndingTypesTransparent
    EndingTypesNative

  BlobPropertyBag* = object
    typeVal*: cstring
    endings*: JsObject
  BlobEvent* = distinct JsValue

  BlobEventInit* = object
  BroadcastChannel* = distinct JsValue
  BrowserElementNextPaintEventCallback* = proc
  BrowserFindCaseSensitivity* = enum
    BrowserFindCaseSensitivityCase_sensitive
    BrowserFindCaseSensitivityCase_insensitive
  BrowserFindDirection* = enum
    BrowserFindDirectionForward
    BrowserFindDirectionBackward

  BrowserElementDownloadOptions* = object

  BrowserElementExecuteScriptOptions* = object

  OpenWindowEventDetail* = object
    url*: cstring
    name*: cstring
    features*: cstring

  DOMWindowResizeEventDetail* = object
    width*: int32
    height*: int32
  BrowserFeedWriter* = distinct JsValue
  CDATASection* = distinct JsValue
  CSSAnimation* = distinct JsValue
  CSSConditionRule* = distinct JsValue
  CSSCounterStyleRule* = distinct JsValue
  CSSFontFaceRule* = distinct JsValue
  CSSFontFeatureValuesRule* = distinct JsValue
  CSSGroupingRule* = distinct JsValue
  CSSImportRule* = distinct JsValue
  CSSKeyframeRule* = distinct JsValue
  CSSKeyframesRule* = distinct JsValue
  CSSMediaRule* = distinct JsValue
  CSSNamespaceRule* = distinct JsValue
  CSSPageRule* = distinct JsValue
  CSSPseudoElement* = distinct JsValue
  CSSRule* = distinct JsValue
  CSSRuleList* = distinct JsValue
  CSSStyleDeclaration* = distinct JsValue
  CSSStyleRule* = distinct JsValue
  CSSStyleSheetParsingMode* = enum
    CSSStyleSheetParsingModeAuthor
    CSSStyleSheetParsingModeUser
    CSSStyleSheetParsingModeAgent
  CSSStyleSheet* = distinct JsValue
  CSSSupportsRule* = distinct JsValue
  CSSTransition* = distinct JsValue
  Cache* = distinct JsValue

  CacheQueryOptions* = object
    ignoreSearch*: bool
    ignoreMethod*: bool
    ignoreVary*: bool
    cacheName*: cstring

  CacheBatchOperation* = object
    typeVal*: cstring
    request*: JsObject
    response*: JsObject
    options*: JsObject
  CacheStorage* = distinct JsValue
  CacheStorageNamespace* = enum
    CacheStorageNamespaceContent
    CacheStorageNamespaceChrome
  CanvasCaptureMediaStream* = distinct JsValue
  CanvasCaptureMediaStreamTrack* = distinct JsValue
  CanvasWindingRule* = enum
    CanvasWindingRuleNonzero
    CanvasWindingRuleEvenodd

  ContextAttributes2D* = object
    willReadFrequently*: bool
    alpha*: bool

  HitRegionOptions* = object
    id*: cstring
  HTMLOrSVGImageElement* = JsObject
  CanvasImageSource* = JsObject
  CanvasRenderingContext2D* = distinct JsValue
  CanvasGradient* = distinct JsValue
  CanvasPattern* = distinct JsValue
  TextMetrics* = distinct JsValue
  Path2D* = distinct JsValue
  CaretPosition* = distinct JsValue
  CaretChangedReason* = enum
    CaretChangedReasonVisibilitychange
    CaretChangedReasonUpdateposition
    CaretChangedReasonLongpressonemptycontent
    CaretChangedReasonTaponcaret
    CaretChangedReasonPresscaret
    CaretChangedReasonReleasecaret
    CaretChangedReasonScroll

  CaretStateChangedEventInit* = object
    collapsed*: bool
    reason*: JsObject
    caretVisible*: bool
    caretVisuallyVisible*: bool
    selectionVisible*: bool
    selectionEditable*: bool
    selectedTextContent*: cstring
  CaretStateChangedEvent* = distinct JsValue

  ChannelMergerOptions* = object
    numberOfInputs*: uint32
  ChannelMergerNode* = distinct JsValue

  ChannelSplitterOptions* = object
    numberOfOutputs*: uint32
  ChannelSplitterNode* = distinct JsValue
  CharacterData* = distinct JsValue
  CheckerboardReason* = enum
    CheckerboardReasonSevere
    CheckerboardReasonRecent

  CheckerboardReport* = object
    severity*: uint32
    timestamp*: uint64
    log*: cstring
    reason*: JsObject
  CheckerboardReportService* = distinct JsValue
  Client* = distinct JsValue
  WindowClient* = distinct JsValue
  FrameType* = enum
    FrameTypeAuxiliary
    FrameTypeTop_level
    FrameTypeNested
    FrameTypeNone
  Clients* = distinct JsValue

  ClientQueryOptions* = object
    includeUncontrolled*: bool
    typeVal*: JsObject
  ClientType* = enum
    ClientTypeWindow
    ClientTypeWorker
    ClientTypeSharedworker
    ClientTypeServiceworker
    ClientTypeAll

  ClipboardEventInit* = object
  ClipboardEvent* = distinct JsValue
  ClipboardItemData* = JsObject
  ClipboardItem* = distinct JsValue
  PresentationStyle* = enum
    PresentationStyleUnspecified
    PresentationStyleInline
    PresentationStyleAttachment

  ClipboardItemOptions* = object
    presentationStyle*: JsObject
  ClipboardItems* = JsObject
  Clipboard* = distinct JsValue
  CloseEvent* = distinct JsValue

  CloseEventInit* = object
    wasClean*: bool
    code*: uint16
    reason*: cstring
  CommandEvent* = distinct JsValue

  CommandEventInit* = object
    command*: cstring
  Comment* = distinct JsValue
  CompositionEvent* = distinct JsValue

  CompositionEventInit* = object
    data*: cstring

  ConsoleEvent* = object
    iD*: JsObject
    innerID*: JsObject
    consoleID*: cstring
    addonId*: cstring
    level*: cstring
    filename*: cstring
    lineNumber*: uint32
    columnNumber*: uint32
    functionName*: cstring
    timeStamp*: float64
    arguments*: JsObject
    styles*: JsObject
    private*: bool
    groupName*: cstring
    timer*: JsObject
    counter*: JsObject
    prefix*: cstring

  ConsoleProfileEvent* = object
    action*: cstring
    arguments*: JsObject

  ConsoleStackEntry* = object
    filename*: cstring
    lineNumber*: uint32
    columnNumber*: uint32
    functionName*: cstring

  ConsoleTimerStart* = object
    name*: cstring

  ConsoleTimerLogOrEnd* = object
    name*: cstring
    duration*: float64

  ConsoleTimerError* = object
    error*: cstring
    name*: cstring

  ConsoleCounter* = object
    label*: cstring
    count*: uint32

  ConsoleCounterError* = object
    label*: cstring
    error*: cstring
  ConsoleInstance* = distinct JsValue
  ConsoleInstanceDumpCallback* = proc
  ConsoleLogLevel* = enum
    ConsoleLogLevelAll
    ConsoleLogLevelDebug
    ConsoleLogLevelLog
    ConsoleLogLevelInfo
    ConsoleLogLevelClear
    ConsoleLogLevelTrace
    ConsoleLogLevelTimeLog
    ConsoleLogLevelTimeEnd
    ConsoleLogLevelTime
    ConsoleLogLevelGroup
    ConsoleLogLevelGroupEnd
    ConsoleLogLevelProfile
    ConsoleLogLevelProfileEnd
    ConsoleLogLevelDir
    ConsoleLogLevelDirxml
    ConsoleLogLevelWarn
    ConsoleLogLevelError
    ConsoleLogLevelOff

  ConsoleInstanceOptions* = object
    dump*: JsObject
    prefix*: cstring
    innerID*: cstring
    consoleID*: cstring
    maxLogLevel*: JsObject
    maxLogLevelPref*: cstring
  ConsoleLevel* = enum
    ConsoleLevelLog
    ConsoleLevelWarning
    ConsoleLevelError

  ConstantSourceOptions* = object
    offset*: float32
  ConstantSourceNode* = distinct JsValue

  ConvolverOptions* = object
    disableNormalization*: bool
  ConvolverNode* = distinct JsValue
  CookieStore* = distinct JsValue

  CookieStoreGetOptions* = object
    name*: cstring
    url*: cstring
  CookieSameSite* = enum
    CookieSameSiteStrict
    CookieSameSiteLax
    CookieSameSiteNone

  CookieInit* = object
    name*: cstring
    value*: cstring
    path*: cstring
    sameSite*: JsObject
    partitioned*: bool

  CookieStoreDeleteOptions* = object
    name*: cstring
    path*: cstring
    partitioned*: bool

  CookieListItem* = object
    name*: cstring
    value*: cstring
  CookieList* = JsObject
  CookieStoreManager* = distinct JsValue
  CookieChangeEvent* = distinct JsValue

  CookieChangeEventInit* = object
    changed*: JsObject
    deleted*: JsObject
  ExtendableCookieChangeEvent* = distinct JsValue

  ExtendableCookieChangeEventInit* = object
    changed*: JsObject
    deleted*: JsObject
  Coordinates* = distinct JsValue
  CreateOfferRequest* = distinct JsValue
  Credential* = distinct JsValue
  CredentialsContainer* = distinct JsValue

  CredentialRequestOptions* = object
    signal*: JsObject

  CredentialCreationOptions* = object
    signal*: JsObject
  Crypto* = distinct JsValue
  CustomElementRegistry* = distinct JsValue

  ElementDefinitionOptions* = object
    extends*: cstring
  CustomElementCreationCallback* = proc
  CustomEvent* = distinct JsValue

  CustomEventInit* = object
    detail*: JsObject
  DOMError* = distinct JsValue
  Exception* = distinct JsValue
  DOMException* = distinct JsValue
  DOMHighResTimeStamp* = JsObject
  DOMImplementation* = distinct JsValue
  DOMMatrixReadOnly* = distinct JsValue
  DOMMatrix* = distinct JsValue

  DOMMatrix2DInit* = object
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

  DOMMatrixInit* = object
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
  SupportedType* = enum
    SupportedTypeText_html
    SupportedTypeText_xml
    SupportedTypeApplication_xml
    SupportedTypeApplication_xhtml_xml
    SupportedTypeImage_svg_xml
  DOMParser* = distinct JsValue
  DOMPointReadOnly* = distinct JsValue
  DOMPoint* = distinct JsValue

  DOMPointInit* = object
    x*: float64
    y*: float64
    z*: float64
    w*: float64
  DOMQuad* = distinct JsValue

  DOMQuadJSON* = object
    p1*: JsObject
    p2*: JsObject
    p3*: JsObject
    p4*: JsObject

  DOMQuadInit* = object
    p1*: JsObject
    p2*: JsObject
    p3*: JsObject
    p4*: JsObject
  DOMRect* = distinct JsValue
  DOMRectReadOnly* = distinct JsValue

  DOMRectInit* = object
    x*: float64
    y*: float64
    width*: float64
    height*: float64
  DOMRectList* = distinct JsValue
  DOMRequestReadyState* = enum
    DOMRequestReadyStatePending
    DOMRequestReadyStateDone
  DOMRequest* = distinct JsValue
  DOMStringList* = distinct JsValue
  DOMStringMap* = distinct JsValue
  DOMTokenList* = distinct JsValue
  DataTransfer* = distinct JsValue
  DataTransferItem* = distinct JsValue
  FunctionStringCallback* = proc
  DataTransferItemList* = distinct JsValue
  DecoderDoctorNotificationType* = enum
    DecoderDoctorNotificationTypeCannot_play
    DecoderDoctorNotificationTypePlatform_decoder_not_found
    DecoderDoctorNotificationTypeCan_play_but_some_missing_decoders
    DecoderDoctorNotificationTypeCannot_initialize_pulseaudio
    DecoderDoctorNotificationTypeUnsupported_libavcodec
    DecoderDoctorNotificationTypeDecode_error
    DecoderDoctorNotificationTypeDecode_warning

  DecoderDoctorNotification* = object
    typeVal*: JsObject
    isSolved*: bool
    decoderDoctorReportId*: cstring
    formats*: cstring
    decodeIssue*: cstring
    docURL*: cstring
    resourceURL*: cstring
  DedicatedWorkerGlobalScope* = distinct JsValue

  DelayOptions* = object
    maxDelayTime*: float64
    delayTime*: float64
  DelayNode* = distinct JsValue
  DeviceLightEvent* = distinct JsValue

  DeviceLightEventInit* = object
    value*: float64
  DeviceAcceleration* = distinct JsValue
  DeviceRotationRate* = distinct JsValue
  DeviceMotionEvent* = distinct JsValue

  DeviceAccelerationInit* = object

  DeviceRotationRateInit* = object

  DeviceMotionEventInit* = object
    acceleration*: JsObject
    accelerationIncludingGravity*: JsObject
    rotationRate*: JsObject
  DeviceOrientationEvent* = distinct JsValue

  DeviceOrientationEventInit* = object
    absolute*: bool
  DeviceProximityEvent* = distinct JsValue

  DeviceProximityEventInit* = object
    value*: float64
    min*: float64
    max*: float64
  Directory* = distinct JsValue
  VisibilityState* = enum
    VisibilityStateHidden
    VisibilityStateVisible

  ElementCreationOptions* = object
    isVal*: cstring
    pseudo*: cstring
  Document* = distinct JsValue

  BlockParsingOptions* = object
    blockScriptCreated*: bool
  FlashClassification* = enum
    FlashClassificationUnclassified
    FlashClassificationUnknown
    FlashClassificationAllowed
    FlashClassificationDenied
  DocumentFragment* = distinct JsValue

  DocumentTimelineOptions* = object
    originTime*: JsObject
  DocumentTimeline* = distinct JsValue
  DocumentType* = distinct JsValue
  DragEvent* = distinct JsValue

  DragEventInit* = object

  DynamicsCompressorOptions* = object
    attack*: float32
    knee*: float32
    ratio*: float32
    release*: float32
    threshold*: float32
  DynamicsCompressorNode* = distinct JsValue
  Element* = distinct JsValue
  ScrollLogicalPosition* = enum
    ScrollLogicalPositionStart
    ScrollLogicalPositionCenter
    ScrollLogicalPositionEndVal
    ScrollLogicalPositionNearest

  ScrollIntoViewOptions* = object
    blockVal*: JsObject
    inline*: JsObject
    container*: JsObject
  ScrollIntoViewContainer* = enum
    ScrollIntoViewContainerAll
    ScrollIntoViewContainerNearest

  ShadowRootInit* = object
    mode*: JsObject
  ErrorEvent* = distinct JsValue

  ErrorEventInit* = object
    message*: cstring
    filename*: cstring
    lineno*: uint32
    colno*: uint32
    error*: JsObject
  Event* = distinct JsValue

  EventInit* = object
    bubbles*: bool
    cancelable*: bool
    composed*: bool
  EventHandlerNonNull* = proc
  EventHandler* = JsObject
  OnBeforeUnloadEventHandlerNonNull* = proc
  OnBeforeUnloadEventHandler* = JsObject
  OnErrorEventHandlerNonNull* = proc
  OnErrorEventHandler* = JsObject
  EventListener* = proc
  EventSource* = distinct JsValue

  EventSourceInit* = object
    withCredentials*: bool

  EventListenerOptions* = object
    capture*: bool

  AddEventListenerOptions* = object
    passive*: bool
    once*: bool
    signal*: JsObject
  EventTarget* = distinct JsValue
  ExtendableEvent* = distinct JsValue

  ExtendableEventInit* = object
  ExtendableMessageEvent* = distinct JsValue

  ExtendableMessageEventInit* = object
    data*: JsObject
    origin*: cstring
    lastEventId*: cstring
    ports*: JsObject
  External* = distinct JsValue

  FakePluginTagInit* = object
    handlerURI*: cstring
    mimeEntries*: JsObject
    niceName*: cstring
    fullPath*: cstring
    name*: cstring
    description*: cstring
    fileName*: cstring
    version*: cstring
    sandboxScript*: cstring

  FakePluginMimeEntry* = object
    typeVal*: cstring
    description*: cstring
    extension*: cstring
  JSON* = JsObject
  BodyInit* = JsObject

  FetchReadableStreamReadDataDone* = object
    done*: bool

  FetchReadableStreamReadDataArray* = object
  FetchEvent* = distinct JsValue

  FetchEventInit* = object
    request*: JsObject
    isReload*: bool
  ObserverCallback* = proc
  FetchState* = enum
    FetchStateRequesting
    FetchStateResponding
    FetchStateAborted
    FetchStateErrored
    FetchStateComplete
  FetchObserver* = distinct JsValue
  File* = distinct JsValue

  FilePropertyBag* = object
    typeVal*: cstring
    lastModified*: int64

  ChromeFilePropertyBag* = object
    name*: cstring
    existenceCheck*: bool
  FileList* = distinct JsValue
  FileReader* = distinct JsValue
  FileReaderSync* = distinct JsValue

  FileSystemFlags* = object
    create*: bool
    exclusive*: bool
  FileSystemEntryCallback* = proc
  VoidCallback* = proc
  ErrorCallback* = proc
  FileSystem* = distinct JsValue
  FileSystemDirectoryEntry* = distinct JsValue
  FileSystemEntriesCallback* = proc
  FileSystemDirectoryReader* = distinct JsValue
  FileSystemEntry* = distinct JsValue
  FileCallback* = proc
  FileSystemFileEntry* = distinct JsValue
  FileSystemHandleKind* = enum
    FileSystemHandleKindFile
    FileSystemHandleKindDirectory
  FileSystemHandle* = distinct JsValue

  FileSystemCreateWritableOptions* = object
    keepExistingData*: bool
  FileSystemFileHandle* = distinct JsValue

  FileSystemGetFileOptions* = object
    create*: bool

  FileSystemGetDirectoryOptions* = object
    create*: bool

  FileSystemRemoveOptions* = object
    recursive*: bool
  FileSystemDirectoryHandle* = distinct JsValue
  WriteCommandType* = enum
    WriteCommandTypeWrite
    WriteCommandTypeSeek
    WriteCommandTypeTruncate

  WriteParams* = object
    typeVal*: JsObject
  FileSystemWriteChunkType* = JsObject
  FileSystemWritableFileStream* = distinct JsValue

  FileSystemReadWriteOptions* = object
    at*: uint64
  FileSystemSyncAccessHandle* = distinct JsValue
  FocusEvent* = distinct JsValue

  FocusEventInit* = object

  FocusOptions* = object
    preventScroll*: bool
    focusVisible*: bool
  BinaryData* = JsObject

  FontFaceDescriptors* = object
    style*: cstring
    weight*: cstring
    stretch*: cstring
    unicodeRange*: cstring
    variant*: cstring
    featureSettings*: cstring
    variationSettings*: cstring
    display*: cstring
  FontFaceLoadStatus* = enum
    FontFaceLoadStatusUnloaded
    FontFaceLoadStatusLoading
    FontFaceLoadStatusLoaded
    FontFaceLoadStatusError
  FontFace* = distinct JsValue

  FontFaceSetIteratorResult* = object
    value*: JsObject
    done*: bool
  FontFaceSetIterator* = distinct JsValue
  FontFaceSetForEachCallback* = proc
  FontFaceSetLoadStatus* = enum
    FontFaceSetLoadStatusLoading
    FontFaceSetLoadStatusLoaded
  FontFaceSet* = distinct JsValue

  FontFaceSetLoadEventInit* = object
    fontfaces*: JsObject
  FontFaceSetLoadEvent* = distinct JsValue
  FormDataEntryValue* = JsObject
  FormData* = distinct JsValue
  Function* = proc
  VoidFunction* = proc
  FuzzingFunctions* = distinct JsValue

  GainOptions* = object
    gain*: float32
  GainNode* = distinct JsValue
  Gamepad* = distinct JsValue
  GamepadButton* = distinct JsValue
  GamepadMappingType* = enum
    GamepadMappingTypeStandard
  GamepadHapticActuator* = distinct JsValue
  GamepadHapticActuatorType* = enum
    GamepadHapticActuatorTypeVibration
  GamepadEvent* = distinct JsValue

  GamepadEventInit* = object
  GamepadHand* = enum
    GamepadHandLeft
    GamepadHandRight
  GamepadPose* = distinct JsValue

  PositionOptions* = object
    enableHighAccuracy*: bool
    timeout*: uint32
    maximumAge*: uint32
  Geolocation* = distinct JsValue
  PositionCallback* = proc
  PositionErrorCallback* = proc
  CSSBoxType* = enum
    CSSBoxTypeMargin
    CSSBoxTypeBorder
    CSSBoxTypePadding
    CSSBoxTypeContent

  BoxQuadOptions* = object
    box*: JsObject
    relativeTo*: JsObject

  ConvertCoordinateOptions* = object
    fromBox*: JsObject
    toBox*: JsObject
  GeometryNode* = JsObject
  GetUserMediaRequest* = distinct JsValue
  GroupedHistoryEvent* = distinct JsValue

  GroupedHistoryEventInit* = object
  HTMLAllCollection* = distinct JsValue
  HTMLAnchorElement* = distinct JsValue
  HTMLAreaElement* = distinct JsValue
  HTMLAudioElement* = distinct JsValue
  HTMLBRElement* = distinct JsValue
  HTMLBaseElement* = distinct JsValue
  HTMLBodyElement* = distinct JsValue
  HTMLButtonElement* = distinct JsValue
  HTMLCanvasElement* = distinct JsValue
  BlobCallback* = proc
  HTMLCollection* = distinct JsValue
  HTMLDListElement* = distinct JsValue
  HTMLDataElement* = distinct JsValue
  HTMLDataListElement* = distinct JsValue
  HTMLDetailsElement* = distinct JsValue
  HTMLDialogElement* = distinct JsValue
  HTMLDirectoryElement* = distinct JsValue
  HTMLDivElement* = distinct JsValue
  HTMLDocument* = distinct JsValue
  HTMLElement* = distinct JsValue
  HTMLUnknownElement* = distinct JsValue
  HTMLEmbedElement* = distinct JsValue
  HTMLFieldSetElement* = distinct JsValue
  HTMLFontElement* = distinct JsValue
  HTMLFormControlsCollection* = distinct JsValue
  HTMLFormElement* = distinct JsValue
  HTMLFrameElement* = distinct JsValue
  HTMLFrameSetElement* = distinct JsValue
  HTMLHRElement* = distinct JsValue
  HTMLHeadElement* = distinct JsValue
  HTMLHeadingElement* = distinct JsValue
  HTMLHtmlElement* = distinct JsValue
  HTMLIFrameElement* = distinct JsValue
  HTMLImageElement* = distinct JsValue
  SelectionMode* = enum
    SelectionModeSelect
    SelectionModeStart
    SelectionModeEndVal
    SelectionModePreserve
  HTMLInputElement* = distinct JsValue

  DateTimeValue* = object
    hour*: int32
    minute*: int32
    year*: int32
    month*: int32
    day*: int32
  HTMLLIElement* = distinct JsValue
  HTMLLabelElement* = distinct JsValue
  HTMLLegendElement* = distinct JsValue
  HTMLLinkElement* = distinct JsValue
  HTMLMapElement* = distinct JsValue
  HTMLMediaElement* = distinct JsValue
  HTMLMenuElement* = distinct JsValue
  HTMLMenuItemElement* = distinct JsValue
  HTMLMetaElement* = distinct JsValue
  HTMLMeterElement* = distinct JsValue
  HTMLModElement* = distinct JsValue
  HTMLOListElement* = distinct JsValue
  HTMLObjectElement* = distinct JsValue
  HTMLOptGroupElement* = distinct JsValue
  HTMLOptionElement* = distinct JsValue
  HTMLOptionsCollection* = distinct JsValue
  HTMLOutputElement* = distinct JsValue
  HTMLParagraphElement* = distinct JsValue
  HTMLParamElement* = distinct JsValue
  HTMLPictureElement* = distinct JsValue
  HTMLPreElement* = distinct JsValue
  HTMLProgressElement* = distinct JsValue
  HTMLQuoteElement* = distinct JsValue
  HTMLScriptElement* = distinct JsValue
  HTMLSelectElement* = distinct JsValue
  HTMLSlotElement* = distinct JsValue

  AssignedNodesOptions* = object
    flatten*: bool
  HTMLSourceElement* = distinct JsValue
  HTMLSpanElement* = distinct JsValue
  HTMLStyleElement* = distinct JsValue
  HTMLTableCaptionElement* = distinct JsValue
  HTMLTableCellElement* = distinct JsValue
  HTMLTableColElement* = distinct JsValue
  HTMLTableElement* = distinct JsValue
  HTMLTableRowElement* = distinct JsValue
  HTMLTableSectionElement* = distinct JsValue
  HTMLTemplateElement* = distinct JsValue
  HTMLTextAreaElement* = distinct JsValue
  HTMLTimeElement* = distinct JsValue
  HTMLTitleElement* = distinct JsValue
  HTMLTrackElement* = distinct JsValue
  HTMLUListElement* = distinct JsValue
  HTMLVideoElement* = distinct JsValue
  HashChangeEvent* = distinct JsValue

  HashChangeEventInit* = object
    oldURL*: cstring
    newURL*: cstring
  HeadersInit* = JsObject
  HeadersGuardEnum* = enum
    HeadersGuardEnumNone
    HeadersGuardEnumRequest
    HeadersGuardEnumRequest_no_cors
    HeadersGuardEnumResponse
    HeadersGuardEnumImmutable
  Headers* = distinct JsValue
  HiddenPluginEvent* = distinct JsValue

  HiddenPluginEventInit* = object
  ScrollRestoration* = enum
    ScrollRestorationAuto
    ScrollRestorationManual
  History* = distinct JsValue
  IDBRequest* = distinct JsValue
  IDBRequestReadyState* = enum
    IDBRequestReadyStatePending
    IDBRequestReadyStateDone
  IDBOpenDBRequest* = distinct JsValue
  IDBVersionChangeEvent* = distinct JsValue

  IDBVersionChangeEventInit* = object
    oldVersion*: uint64
  IDBFactory* = distinct JsValue
  IDBDatabase* = distinct JsValue

  IDBObjectStoreParameters* = object
    autoIncrement*: bool
  IDBObjectStore* = distinct JsValue

  IDBIndexParameters* = object
    unique*: bool
    multiEntry*: bool
  IDBIndex* = distinct JsValue
  IDBKeyRange* = distinct JsValue
  IDBCursor* = distinct JsValue
  IDBCursorDirection* = enum
    IDBCursorDirectionNext
    IDBCursorDirectionNextunique
    IDBCursorDirectionPrev
    IDBCursorDirectionPrevunique
  IDBCursorWithValue* = distinct JsValue
  IDBTransaction* = distinct JsValue
  IDBTransactionMode* = enum
    IDBTransactionModeReadonly
    IDBTransactionModeReadwrite
    IDBTransactionModeVersionchange
    IDBTransactionModeReadwriteflush
    IDBTransactionModeCleanup

  IDBOpenDBOptions* = object
    version*: uint64
    storage*: JsObject

  IDBFileMetadataParameters* = object
    size*: bool
    lastModified*: bool
  IDBFileHandle* = distinct JsValue
  IDBFileRequest* = distinct JsValue
  IDBLocaleAwareKeyRange* = distinct JsValue
  IDBMutableFile* = distinct JsValue

  IIRFilterOptions* = object
    feedforward*: JsObject
    feedback*: JsObject
  IIRFilterNode* = distinct JsValue
  IdleDeadline* = distinct JsValue
  ImageBitmapSource* = JsObject
  ImageBitmap* = distinct JsValue
  ImageOrientation* = enum
    ImageOrientationFrom_image
    ImageOrientationFlipY
  PremultiplyAlpha* = enum
    PremultiplyAlphaNone
    PremultiplyAlphaPremultiply
    PremultiplyAlphaDefault
  ColorSpaceConversion* = enum
    ColorSpaceConversionNone
    ColorSpaceConversionDefault
  ResizeQuality* = enum
    ResizeQualityPixelated
    ResizeQualityLow
    ResizeQualityMedium
    ResizeQualityHigh

  ImageBitmapOptions* = object
    imageOrientation*: JsObject
    premultiplyAlpha*: JsObject
    colorSpaceConversion*: JsObject
    resizeWidth*: uint32
    resizeHeight*: uint32
    resizeQuality*: JsObject
  ImageBitmapRenderingContext* = distinct JsValue
  ImageCaptureErrorEvent* = distinct JsValue

  ImageCaptureErrorEventInit* = object
  ImageCaptureError* = distinct JsValue
  ImageData* = distinct JsValue
  ImageDocument* = distinct JsValue
  InputEvent* = distinct JsValue

  InputEventInit* = object
    isComposing*: bool
    inputType*: cstring
  IntersectionObserverEntry* = distinct JsValue
  IntersectionObserver* = distinct JsValue
  IntersectionCallback* = proc

  IntersectionObserverEntryInit* = object
    time*: JsObject
    rootBounds*: JsObject
    boundingClientRect*: JsObject
    intersectionRect*: JsObject
    target*: JsObject

  IntersectionObserverInit* = object
    rootMargin*: cstring
    threshold*: JsObject

  DisplayNameOptions* = object
    style*: cstring
    keys*: JsObject

  DisplayNameResult* = object
    locale*: cstring
    style*: cstring
    values*: JsObject

  LocaleInfo* = object
    locale*: cstring
    direction*: cstring
  IntlUtils* = distinct JsValue

  IterableKeyOrValueResult* = object
    value*: JsObject
    done*: bool

  IterableKeyAndValueResult* = object
    value*: JsObject
    done*: bool

  KeyAlgorithm* = object
    name*: cstring

  AesKeyAlgorithm* = object
    length*: uint16

  EcKeyAlgorithm* = object
    namedCurve*: cstring

  HmacKeyAlgorithm* = object
    hash*: JsObject
    length*: uint32
  KeyEvent* = distinct JsValue

  KeyIdsInitData* = object
    kids*: JsObject
  KeyboardEvent* = distinct JsValue

  KeyboardEventInit* = object
    key*: cstring
    code*: cstring
    location*: uint32
    repeat*: bool
    isComposing*: bool
    charCode*: uint32
    keyCode*: uint32
    which*: uint32
  UnrestrictedDoubleOrKeyframeAnimationOptions* = JsObject
  IterationCompositeOperation* = enum
    IterationCompositeOperationReplace
    IterationCompositeOperationAccumulate

  KeyframeEffectOptions* = object
    iterationComposite*: JsObject
    composite*: JsObject
  KeyframeEffect* = distinct JsValue

  AnimationPropertyValueDetails* = object
    offset*: float64
    value*: cstring
    easing*: cstring
    composite*: JsObject

  AnimationPropertyDetails* = object
    property*: cstring
    runningOnCompositor*: bool
    warning*: cstring
    values*: JsObject

  L10nElement* = object
    namespaceURI*: cstring
    localName*: cstring
    l10nId*: cstring

  AttributeNameValue* = object
    name*: cstring
    value*: cstring

  L10nValue* = object
  L10nCallback* = proc
  ListBoxObject* = distinct JsValue
  LocalMediaStream* = distinct JsValue
  Location* = distinct JsValue
  MIDIAccess* = distinct JsValue
  MIDIConnectionEvent* = distinct JsValue

  MIDIConnectionEventInit* = object
  MIDIInput* = distinct JsValue
  MIDIInputMap* = distinct JsValue
  MIDIMessageEvent* = distinct JsValue

  MIDIMessageEventInit* = object

  MIDIOptions* = object
    sysex*: bool
    software*: bool
  MIDIOutput* = distinct JsValue
  MIDIOutputMap* = distinct JsValue
  MIDIPortType* = enum
    MIDIPortTypeInput
    MIDIPortTypeOutput
  MIDIPortDeviceState* = enum
    MIDIPortDeviceStateDisconnected
    MIDIPortDeviceStateConnected
  MIDIPortConnectionState* = enum
    MIDIPortConnectionStateOpen
    MIDIPortConnectionStateClosed
    MIDIPortConnectionStatePending
  MIDIPort* = distinct JsValue
  MathMLElement* = distinct JsValue

  MediaConfiguration* = object
    video*: JsObject
    audio*: JsObject

  MediaDecodingConfiguration* = object
    typeVal*: JsObject

  MediaEncodingConfiguration* = object
    typeVal*: JsObject
  MediaDecodingType* = enum
    MediaDecodingTypeFile
    MediaDecodingTypeMedia_source
  MediaEncodingType* = enum
    MediaEncodingTypeRecord
    MediaEncodingTypeTransmission

  VideoConfiguration* = object
    contentType*: cstring
    width*: uint32
    height*: uint32
    bitrate*: uint64
    framerate*: cstring

  AudioConfiguration* = object
    contentType*: cstring
    channels*: cstring
    bitrate*: uint64
    samplerate*: uint32
  MediaCapabilitiesInfo* = distinct JsValue
  MediaCapabilities* = distinct JsValue
  MediaDeviceKind* = enum
    MediaDeviceKindAudioinput
    MediaDeviceKindAudiooutput
    MediaDeviceKindVideoinput
  MediaDeviceInfo* = distinct JsValue
  MediaDevices* = distinct JsValue

  MediaElementAudioSourceOptions* = object
    mediaElement*: JsObject
  MediaElementAudioSourceNode* = distinct JsValue
  MediaEncryptedEvent* = distinct JsValue

  MediaKeyNeededEventInit* = object
    initDataType*: cstring
  MediaError* = distinct JsValue
  MediaKeyError* = distinct JsValue
  MediaKeyMessageType* = enum
    MediaKeyMessageTypeLicense_request
    MediaKeyMessageTypeLicense_renewal
    MediaKeyMessageTypeLicense_release
    MediaKeyMessageTypeIndividualization_request
  MediaKeyMessageEvent* = distinct JsValue

  MediaKeyMessageEventInit* = object
    messageType*: JsObject
    message*: JsObject
  MediaKeySession* = distinct JsValue
  MediaKeyStatus* = enum
    MediaKeyStatusUsable
    MediaKeyStatusExpired
    MediaKeyStatusReleased
    MediaKeyStatusOutput_restricted
    MediaKeyStatusOutput_downscaled
    MediaKeyStatusStatus_pending
    MediaKeyStatusInternal_error
  MediaKeyStatusMap* = distinct JsValue
  MediaKeysRequirement* = enum
    MediaKeysRequirementRequired
    MediaKeysRequirementOptional
    MediaKeysRequirementNot_allowed

  MediaKeySystemMediaCapability* = object
    contentType*: cstring
    robustness*: cstring

  MediaKeySystemConfiguration* = object
    label*: cstring
    initDataTypes*: JsObject
    audioCapabilities*: JsObject
    videoCapabilities*: JsObject
    distinctiveIdentifier*: JsObject
    persistentState*: JsObject
    sessionTypes*: JsObject
  MediaKeySystemAccess* = distinct JsValue
  MediaKeySessionType* = enum
    MediaKeySessionTypeTemporary
    MediaKeySessionTypePersistent_license

  MediaKeysPolicy* = object
    minHdcpVersion*: cstring
  MediaKeys* = distinct JsValue
  MediaKeySystemStatus* = enum
    MediaKeySystemStatusAvailable
    MediaKeySystemStatusApi_disabled
    MediaKeySystemStatusCdm_disabled
    MediaKeySystemStatusCdm_not_supported
    MediaKeySystemStatusCdm_not_installed
    MediaKeySystemStatusCdm_created

  RequestMediaKeySystemAccessNotification* = object
    keySystem*: cstring
    status*: JsObject
  MediaList* = distinct JsValue
  MediaQueryList* = distinct JsValue
  MediaQueryListEvent* = distinct JsValue

  MediaQueryListEventInit* = object
    media*: cstring
    matches*: bool
  BitrateMode* = enum
    BitrateModeConstant
    BitrateModeVariable
  RecordingState* = enum
    RecordingStateInactive
    RecordingStateRecording
    RecordingStatePaused
  MediaRecorder* = distinct JsValue

  MediaRecorderOptions* = object
    mimeType*: cstring
    audioBitsPerSecond*: uint32
    videoBitsPerSecond*: uint32
    bitsPerSecond*: uint32
    audioBitrateMode*: JsObject
    videoKeyFrameIntervalDuration*: JsObject
    videoKeyFrameIntervalCount*: uint32

  MediaRecorderErrorEventInit* = object
    error*: JsObject
  MediaRecorderErrorEvent* = distinct JsValue
  MediaSourceReadyState* = enum
    MediaSourceReadyStateClosed
    MediaSourceReadyStateOpen
    MediaSourceReadyStateEnded
  MediaSourceEndOfStreamError* = enum
    MediaSourceEndOfStreamErrorNetwork
    MediaSourceEndOfStreamErrorDecode
  MediaSource* = distinct JsValue

  MediaStreamConstraints* = object
    audio*: JsObject
    video*: JsObject
    picture*: bool
    fake*: bool

  DisplayMediaStreamConstraints* = object
    video*: JsObject
    audio*: JsObject
  MediaStream* = distinct JsValue
  MediaStreamAudioDestinationNode* = distinct JsValue

  MediaStreamAudioSourceOptions* = object
    mediaStream*: JsObject
  MediaStreamAudioSourceNode* = distinct JsValue
  MediaStreamError* = distinct JsValue

  MediaStreamEventInit* = object
  MediaStreamEvent* = distinct JsValue
  VideoFacingModeEnum* = enum
    VideoFacingModeEnumUser
    VideoFacingModeEnumEnvironment
    VideoFacingModeEnumLeft
    VideoFacingModeEnumRight
  MediaSourceEnum* = enum
    MediaSourceEnumCamera
    MediaSourceEnumScreen
    MediaSourceEnumApplication
    MediaSourceEnumWindow
    MediaSourceEnumBrowser
    MediaSourceEnumMicrophone
    MediaSourceEnumAudioCapture
    MediaSourceEnumOther
  ConstrainLong* = JsObject
  ConstrainDouble* = JsObject
  ConstrainBoolean* = JsObject
  ConstrainDOMString* = JsObject

  MediaTrackConstraintSet* = object
    width*: JsObject
    height*: JsObject
    frameRate*: JsObject
    facingMode*: JsObject
    mediaSource*: cstring
    browserWindow*: int64
    scrollWithPage*: bool
    deviceId*: JsObject
    viewportOffsetX*: JsObject
    viewportOffsetY*: JsObject
    viewportWidth*: JsObject
    viewportHeight*: JsObject
    echoCancellation*: JsObject
    noiseSuppression*: JsObject
    autoGainControl*: JsObject
    channelCount*: JsObject

  MediaTrackConstraints* = object
    advanced*: JsObject
  MediaStreamTrackState* = enum
    MediaStreamTrackStateLive
    MediaStreamTrackStateEnded
  MediaStreamTrack* = distinct JsValue

  MediaStreamTrackEventInit* = object
    track*: JsObject
  MediaStreamTrackEvent* = distinct JsValue

  ConstrainLongRange* = object
    min*: int32
    max*: int32
    exact*: int32
    ideal*: int32

  ConstrainDoubleRange* = object
    min*: float64
    max*: float64
    exact*: float64
    ideal*: float64

  ConstrainBooleanParameters* = object
    exact*: bool
    ideal*: bool

  ConstrainDOMStringParameters* = object
    exact*: JsObject
    ideal*: JsObject

  MediaTrackSettings* = object
    width*: int32
    height*: int32
    frameRate*: float64
    facingMode*: cstring
    deviceId*: cstring
    echoCancellation*: bool
    noiseSuppression*: bool
    autoGainControl*: bool
    channelCount*: int32

  MediaTrackSupportedConstraints* = object
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
  MessageChannel* = distinct JsValue
  MessageEvent* = distinct JsValue

  MessageEventInit* = object
    data*: JsObject
    origin*: cstring
    lastEventId*: cstring
    ports*: JsObject
  MessageEventSource* = JsObject
  MessagePort* = distinct JsValue
  MimeType* = distinct JsValue
  MimeTypeArray* = distinct JsValue
  MouseEvent* = distinct JsValue

  MouseEventInit* = object
    screenX*: int32
    screenY*: int32
    clientX*: int32
    clientY*: int32
    button*: int16
    buttons*: uint16
    movementX*: int32
    movementY*: int32
  MouseScrollEvent* = distinct JsValue
  MutationEvent* = distinct JsValue
  MutationRecord* = distinct JsValue
  MutationObserver* = distinct JsValue
  MutationCallback* = proc

  MutationObserverInit* = object
    childList*: bool
    attributes*: bool
    characterData*: bool
    subtree*: bool
    attributeOldValue*: bool
    characterDataOldValue*: bool
    nativeAnonymousChildList*: bool
    animations*: bool
    attributeFilter*: JsObject

  MutationObservingInfo* = object
  NamedNodeMap* = distinct JsValue

  NativeOSFileReadOptions* = object

  NativeOSFileWriteAtomicOptions* = object
    noOverwrite*: bool
    flush*: bool
  Navigator* = distinct JsValue
  NavigatorUserMediaSuccessCallback* = proc
  NavigatorUserMediaErrorCallback* = proc
  NavigatorAutomationInformation* = distinct JsValue

  SocketElement* = object
    host*: cstring
    port*: uint32
    active*: bool
    tcp*: bool
    sent*: float64
    received*: float64

  SocketsDict* = object
    sockets*: JsObject
    sent*: float64
    received*: float64

  HttpConnInfo* = object
    rtt*: uint32
    ttl*: uint32
    protocolVersion*: cstring

  HalfOpenInfoDict* = object
    speculative*: bool

  HttpConnectionElement* = object
    host*: cstring
    port*: uint32
    spdy*: bool
    ssl*: bool
    active*: JsObject
    idle*: JsObject
    halfOpens*: JsObject

  HttpConnDict* = object
    connections*: JsObject

  WebSocketElement* = object
    hostport*: cstring
    msgsent*: uint32
    msgreceived*: uint32
    sentsize*: float64
    receivedsize*: float64
    encrypted*: bool

  WebSocketDict* = object
    websockets*: JsObject

  DnsCacheEntry* = object
    hostname*: cstring
    hostaddr*: JsObject
    family*: cstring
    expiration*: float64
    trr*: bool

  DNSCacheDict* = object
    entries*: JsObject

  DNSLookupDict* = object
    address*: JsObject
    error*: cstring
    answer*: bool

  ConnStatusDict* = object
    status*: cstring

  RcwnPerfStats* = object
    avgShort*: uint32
    avgLong*: uint32
    stddevLong*: uint32

  RcwnStatus* = object
    totalNetworkRequests*: uint32
    rcwnCacheWonCount*: uint32
    rcwnNetWonCount*: uint32
    cacheSlowCount*: uint32
    cacheNotSlowCount*: uint32
    perfStats*: JsObject
  ConnectionType* = enum
    ConnectionTypeCellular
    ConnectionTypeBluetooth
    ConnectionTypeEthernet
    ConnectionTypeWifi
    ConnectionTypeOther
    ConnectionTypeNone
    ConnectionTypeUnknown
  NetworkInformation* = distinct JsValue

  NetworkCommandOptions* = object
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

  NetworkResultOptions* = object
    id*: int32
    ret*: bool
    broadcast*: bool
    topic*: cstring
    reason*: cstring
    resultCode*: int32
    resultReason*: cstring
    error*: bool
    enable*: bool
    resultVal*: bool
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
    ipAddr2*: cstring
  Node* = distinct JsValue

  GetRootNodeOptions* = object
    composed*: bool
  NodeFilter* = proc
  NodeIterator* = distinct JsValue
  NodeList* = distinct JsValue
  Notification* = distinct JsValue

  NotificationOptions* = object
    dir*: JsObject
    lang*: cstring
    body*: cstring
    tag*: cstring
    image*: cstring
    icon*: cstring
    badge*: cstring
    vibrate*: JsObject
    timestamp*: uint64
    renotify*: bool
    requireInteraction*: bool
    data*: JsObject
    actions*: JsObject
  NotificationPermission* = enum
    NotificationPermissionDefault
    NotificationPermissionDenied
    NotificationPermissionGranted
  NotificationDirection* = enum
    NotificationDirectionAuto
    NotificationDirectionLtr
    NotificationDirectionRtl

  NotificationAction* = object
    action*: cstring
    title*: cstring
    icon*: cstring
  NotificationPermissionCallback* = proc
  NotificationEvent* = distinct JsValue

  NotificationEventInit* = object
    notification*: JsObject
  NotifyPaintEvent* = distinct JsValue
  OVR_multiview2* = distinct JsValue

  OfflineAudioCompletionEventInit* = object
    renderedBuffer*: JsObject
  OfflineAudioCompletionEvent* = distinct JsValue

  OfflineAudioContextOptions* = object
    numberOfChannels*: uint32
    length*: uint32
    sampleRate*: float32
  OfflineAudioContext* = distinct JsValue
  OfflineResourceList* = distinct JsValue

  ImageEncodeOptions* = object
    typeVal*: cstring
    quality*: float64
  OffscreenCanvas* = distinct JsValue
  OffscreenCanvasRenderingContext2D* = distinct JsValue
  OscillatorType* = enum
    OscillatorTypeSine
    OscillatorTypeSquare
    OscillatorTypeSawtooth
    OscillatorTypeTriangle
    OscillatorTypeCustom

  OscillatorOptions* = object
    typeVal*: JsObject
    frequency*: float32
    detune*: float32
    periodicWave*: JsObject
  OscillatorNode* = distinct JsValue
  PageTransitionEvent* = distinct JsValue

  PageTransitionEventInit* = object
    persisted*: bool
    inFrameSwap*: bool
  PaintRequest* = distinct JsValue
  PaintRequestList* = distinct JsValue
  PaintWorkletGlobalScope* = distinct JsValue
  PanningModelType* = enum
    PanningModelTypeEqualpower
    PanningModelTypeHRTF
  DistanceModelType* = enum
    DistanceModelTypeLinear
    DistanceModelTypeInverse
    DistanceModelTypeExponential

  PannerOptions* = object
    panningModel*: JsObject
    distanceModel*: JsObject
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
  PannerNode* = distinct JsValue
  PaymentAddress* = distinct JsValue
  PaymentMethodChangeEvent* = distinct JsValue

  PaymentMethodChangeEventInit* = object
    methodName*: cstring
  PaymentRequestUpdateEvent* = distinct JsValue

  PaymentRequestUpdateEventInit* = object
  PaymentComplete* = enum
    PaymentCompleteSuccess
    PaymentCompleteFail
    PaymentCompleteUnknown
  PaymentResponse* = distinct JsValue
  PCImplSignalingState* = enum
    PCImplSignalingStateSignalingInvalid
    PCImplSignalingStateSignalingStable
    PCImplSignalingStateSignalingHaveLocalOffer
    PCImplSignalingStateSignalingHaveRemoteOffer
    PCImplSignalingStateSignalingHaveLocalPranswer
    PCImplSignalingStateSignalingHaveRemotePranswer
    PCImplSignalingStateSignalingClosed
  PCImplIceConnectionState* = enum
    PCImplIceConnectionStateNew
    PCImplIceConnectionStateChecking
    PCImplIceConnectionStateConnected
    PCImplIceConnectionStateCompleted
    PCImplIceConnectionStateFailed
    PCImplIceConnectionStateDisconnected
    PCImplIceConnectionStateClosed
  PCImplIceGatheringState* = enum
    PCImplIceGatheringStateNew
    PCImplIceGatheringStateGathering
    PCImplIceGatheringStateComplete
  PCObserverStateType* = enum
    PCObserverStateTypeNone
    PCObserverStateTypeIceConnectionState
    PCObserverStateTypeIceGatheringState
    PCObserverStateTypeSignalingState
  PerformanceEntryList* = JsObject
  Performance* = distinct JsValue
  PerformanceEntry* = distinct JsValue

  PerformanceEntryEventInit* = object
    name*: cstring
    entryType*: cstring
    startTime*: JsObject
    duration*: JsObject
    epoch*: float64
    origin*: cstring
  PerformanceEntryEvent* = distinct JsValue
  PerformanceMark* = distinct JsValue
  PerformanceMeasure* = distinct JsValue
  PerformanceNavigation* = distinct JsValue
  NavigationType* = enum
    NavigationTypeNavigate
    NavigationTypeReload
    NavigationTypeBack_forward
    NavigationTypePrerender
  PerformanceNavigationTiming* = distinct JsValue

  PerformanceObserverInit* = object
    entryTypes*: JsObject
    buffered*: bool
  PerformanceObserverCallback* = proc
  PerformanceObserver* = distinct JsValue

  PerformanceEntryFilterOptions* = object
    name*: cstring
    entryType*: cstring
    initiatorType*: cstring
  PerformanceObserverEntryList* = distinct JsValue
  PerformanceResourceTiming* = distinct JsValue
  PerformanceServerTiming* = distinct JsValue
  PerformanceTiming* = distinct JsValue

  PeriodicWaveConstraints* = object
    disableNormalization*: bool

  PeriodicWaveOptions* = object
    real*: JsObject
    imag*: JsObject
  PeriodicWave* = distinct JsValue
  PermissionState* = enum
    PermissionStateGranted
    PermissionStateDenied
    PermissionStatePrompt
  PermissionStatus* = distinct JsValue
  PermissionName* = enum
    PermissionNameGeolocation
    PermissionNameNotifications
    PermissionNamePush
    PermissionNamePersistent_storage

  PermissionDescriptor* = object
    name*: JsObject
  Permissions* = distinct JsValue
  Plugin* = distinct JsValue
  PluginArray* = distinct JsValue
  PluginCrashedEvent* = distinct JsValue

  PluginCrashedEventInit* = object
    pluginID*: uint32
    pluginDumpID*: cstring
    pluginName*: cstring
    submittedCrashReport*: bool
    gmpPlugin*: bool
  PointerEvent* = distinct JsValue

  PointerEventInit* = object
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
  PopStateEvent* = distinct JsValue

  PopStateEventInit* = object
    state*: JsObject
  PopupBlockedEvent* = distinct JsValue

  PopupBlockedEventInit* = object
    popupWindowName*: cstring
    popupWindowFeatures*: cstring
  Position* = distinct JsValue
  PositionError* = distinct JsValue
  Presentation* = distinct JsValue
  PresentationAvailability* = distinct JsValue
  PresentationConnectionState* = enum
    PresentationConnectionStateConnecting
    PresentationConnectionStateConnected
    PresentationConnectionStateClosed
    PresentationConnectionStateTerminated
  PresentationConnectionBinaryType* = enum
    PresentationConnectionBinaryTypeBlob
    PresentationConnectionBinaryTypeArraybuffer
  PresentationConnection* = distinct JsValue
  PresentationConnectionAvailableEvent* = distinct JsValue

  PresentationConnectionAvailableEventInit* = object
    connection*: JsObject
  PresentationConnectionClosedReason* = enum
    PresentationConnectionClosedReasonError
    PresentationConnectionClosedReasonClosed
    PresentationConnectionClosedReasonWentaway
  PresentationConnectionCloseEvent* = distinct JsValue

  PresentationConnectionCloseEventInit* = object
    reason*: JsObject
    message*: cstring
  PresentationConnectionList* = distinct JsValue
  PresentationReceiver* = distinct JsValue
  PresentationRequest* = distinct JsValue
  ProcessingInstruction* = distinct JsValue

  ProfileTimelineStackFrame* = object
    line*: int32
    column*: int32
    source*: cstring
    functionDisplayName*: cstring
    asyncCause*: cstring

  ProfileTimelineLayerRect* = object
    x*: int32
    y*: int32
    width*: int32
    height*: int32
  ProfileTimelineMessagePortOperationType* = enum
    ProfileTimelineMessagePortOperationTypeSerializeData
    ProfileTimelineMessagePortOperationTypeDeserializeData
  ProfileTimelineWorkerOperationType* = enum
    ProfileTimelineWorkerOperationTypeSerializeDataOffMainThread
    ProfileTimelineWorkerOperationTypeSerializeDataOnMainThread
    ProfileTimelineWorkerOperationTypeDeserializeDataOffMainThread
    ProfileTimelineWorkerOperationTypeDeserializeDataOnMainThread

  ProfileTimelineMarker* = object
    name*: cstring
    start*: JsObject
    endVal*: JsObject
    processType*: uint16
    isOffMainThread*: bool
    causeName*: cstring
    typeVal*: cstring
    eventPhase*: uint16
    unixTime*: uint64
    rectangles*: JsObject
    isAnimationOnly*: bool
    messagePortOperation*: JsObject
    workerOperation*: JsObject
  ProgressEvent* = distinct JsValue

  ProgressEventInit* = object
    lengthComputable*: bool
    loaded*: uint64
    total*: uint64
  PromiseJobCallback* = proc
  AnyCallback* = proc
  PromiseNativeHandler* = distinct JsValue
  PromiseRejectionEvent* = distinct JsValue

  PromiseRejectionEventInit* = object
    promise*: JsObject
    reason*: JsObject
  PushEvent* = distinct JsValue
  PushMessageDataInit* = JsObject

  PushEventInit* = object
    data*: JsObject

  PushSubscriptionOptionsInit* = object
    userVisibleOnly*: bool
  PushManagerImpl* = distinct JsValue
  PushManager* = distinct JsValue
  PushPermissionState* = enum
    PushPermissionStateGranted
    PushPermissionStateDenied
    PushPermissionStatePrompt
  PushMessageData* = distinct JsValue
  PushEncryptionKeyName* = enum
    PushEncryptionKeyNameP256dh
    PushEncryptionKeyNameAuth

  PushSubscriptionKeys* = object
    p256dh*: cstring
    auth*: cstring

  PushSubscriptionJSON* = object
    endpoint*: cstring
    keys*: JsObject

  PushSubscriptionInit* = object
    endpoint*: cstring
    scope*: cstring
  PushSubscription* = distinct JsValue
  PushSubscriptionOptions* = distinct JsValue

  RTCCertificateExpiration* = object
    expires*: uint64
  RTCCertificate* = distinct JsValue
  RTCIceCredentialType* = enum
    RTCIceCredentialTypePassword
    RTCIceCredentialTypeToken

  RTCIceServer* = object
    urls*: JsObject
    url*: cstring
    username*: cstring
    credential*: cstring
    credentialType*: JsObject
  RTCIceTransportPolicy* = enum
    RTCIceTransportPolicyRelay
    RTCIceTransportPolicyAll
  RTCBundlePolicy* = enum
    RTCBundlePolicyBalanced
    RTCBundlePolicyMax_compat
    RTCBundlePolicyMax_bundle

  RTCConfiguration* = object
    iceServers*: JsObject
    iceTransportPolicy*: JsObject
    bundlePolicy*: JsObject
    certificates*: JsObject
  RTCDTMFSender* = distinct JsValue
  RTCDTMFToneChangeEvent* = distinct JsValue

  RTCDTMFToneChangeEventInit* = object
    tone*: cstring
  RTCDataChannelState* = enum
    RTCDataChannelStateConnecting
    RTCDataChannelStateOpen
    RTCDataChannelStateClosing
    RTCDataChannelStateClosed
  RTCDataChannelType* = enum
    RTCDataChannelTypeArraybuffer
    RTCDataChannelTypeBlob
  RTCDataChannel* = distinct JsValue

  RTCDataChannelEventInit* = object
    channel*: JsObject
  RTCDataChannelEvent* = distinct JsValue

  RTCIceCandidateInit* = object
    candidate*: cstring
  RTCIceCandidate* = distinct JsValue

  RTCIdentityAssertion* = object
    idp*: cstring
    name*: cstring
  RTCIdentityProviderRegistrar* = distinct JsValue

  RTCIdentityProvider* = object
    generateAssertion*: JsObject
    validateAssertion*: JsObject
  GenerateAssertionCallback* = proc
  ValidateAssertionCallback* = proc

  RTCIdentityAssertionResult* = object
    idp*: JsObject
    assertion*: cstring

  RTCIdentityProviderDetails* = object
    domain*: cstring
    protocol*: cstring

  RTCIdentityValidationResult* = object
    identity*: cstring
    contents*: cstring

  RTCIdentityProviderOptions* = object
    protocol*: cstring
    usernameHint*: cstring
    peerIdentity*: cstring
  RTCSessionDescriptionCallback* = proc
  RTCPeerConnectionErrorCallback* = proc
  RTCStatsCallback* = proc
  RTCSignalingState* = enum
    RTCSignalingStateStable
    RTCSignalingStateHave_local_offer
    RTCSignalingStateHave_remote_offer
    RTCSignalingStateHave_local_pranswer
    RTCSignalingStateHave_remote_pranswer
    RTCSignalingStateClosed
  RTCIceGatheringState* = enum
    RTCIceGatheringStateNew
    RTCIceGatheringStateGathering
    RTCIceGatheringStateComplete
  RTCIceConnectionState* = enum
    RTCIceConnectionStateNew
    RTCIceConnectionStateChecking
    RTCIceConnectionStateConnected
    RTCIceConnectionStateCompleted
    RTCIceConnectionStateFailed
    RTCIceConnectionStateDisconnected
    RTCIceConnectionStateClosed
  RTCPeerConnectionState* = enum
    RTCPeerConnectionStateClosed
    RTCPeerConnectionStateFailed
    RTCPeerConnectionStateDisconnected
    RTCPeerConnectionStateNew
    RTCPeerConnectionStateConnecting
    RTCPeerConnectionStateConnected

  RTCDataChannelInit* = object
    ordered*: bool
    maxPacketLifeTime*: uint16
    maxRetransmits*: uint16
    protocol*: cstring
    negotiated*: bool
    id*: uint16
    maxRetransmitTime*: uint16

  RTCOfferAnswerOptions* = object

  RTCAnswerOptions* = object

  RTCOfferOptions* = object
    offerToReceiveVideo*: bool
    offerToReceiveAudio*: bool
    iceRestart*: bool
  RTCPeerConnection* = distinct JsValue
  RTCPeerConnectionIceErrorEvent* = distinct JsValue

  RTCPeerConnectionIceEventInit* = object
  RTCPeerConnectionIceEvent* = distinct JsValue
  RTCRtpReceiver* = distinct JsValue
  RTCPriorityType* = enum
    RTCPriorityTypeVery_low
    RTCPriorityTypeLow
    RTCPriorityTypeMedium
    RTCPriorityTypeHigh
  RTCDegradationPreference* = enum
    RTCDegradationPreferenceMaintain_framerate
    RTCDegradationPreferenceMaintain_resolution
    RTCDegradationPreferenceBalanced

  RTCRtxParameters* = object
    ssrc*: uint32

  RTCFecParameters* = object
    ssrc*: uint32

  RTCRtpEncodingParameters* = object
    ssrc*: uint32
    rtx*: JsObject
    fec*: JsObject
    active*: bool
    priority*: JsObject
    maxBitrate*: uint32
    degradationPreference*: JsObject
    rid*: cstring
    scaleResolutionDownBy*: float32

  RTCRtpHeaderExtensionParameters* = object
    uri*: cstring
    id*: uint16
    encrypted*: bool

  RTCRtcpParameters* = object
    cname*: cstring
    reducedSize*: bool

  RTCRtpCodecParameters* = object
    payloadType*: uint16
    mimeType*: cstring
    clockRate*: uint32
    channels*: uint16
    sdpFmtpLine*: cstring

  RTCRtpParameters* = object
    encodings*: JsObject
    headerExtensions*: JsObject
    rtcp*: JsObject
    codecs*: JsObject

  RTCRtpCodecCapability* = object
    mimeType*: cstring
    clockRate*: uint32
    channels*: uint16
    sdpFmtpLine*: cstring

  RTCRtpHeaderExtensionCapability* = object
    uri*: cstring

  RTCRtpCapabilities* = object
    codecs*: JsObject
    headerExtensions*: JsObject
  RTCRtpSender* = distinct JsValue

  RTCRtpContributingSource* = object
    timestamp*: JsObject
    source*: uint32
    audioLevel*: float64

  RTCRtpSynchronizationSource* = object
  RTCRtpSourceEntryType* = enum
    RTCRtpSourceEntryTypeContributing
    RTCRtpSourceEntryTypeSynchronization

  RTCRtpSourceEntry* = object
    sourceType*: JsObject
  RTCRtpTransceiverDirection* = enum
    RTCRtpTransceiverDirectionSendrecv
    RTCRtpTransceiverDirectionSendonly
    RTCRtpTransceiverDirectionRecvonly
    RTCRtpTransceiverDirectionInactive
    RTCRtpTransceiverDirectionStopped

  RTCRtpTransceiverInit* = object
    direction*: JsObject
    streams*: JsObject
    sendEncodings*: JsObject
  RTCRtpTransceiver* = distinct JsValue
  RTCSdpType* = enum
    RTCSdpTypeOffer
    RTCSdpTypePranswer
    RTCSdpTypeAnswer
    RTCSdpTypeRollback

  RTCSessionDescriptionInit* = object
    typeVal*: JsObject
    sdp*: cstring
  RTCSessionDescription* = distinct JsValue
  RTCStatsType* = enum
    RTCStatsTypeInbound_rtp
    RTCStatsTypeOutbound_rtp
    RTCStatsTypeCsrc
    RTCStatsTypeSession
    RTCStatsTypeTrack
    RTCStatsTypeTransport
    RTCStatsTypeCandidate_pair
    RTCStatsTypeLocal_candidate
    RTCStatsTypeRemote_candidate

  RTCStats* = object
    timestamp*: JsObject
    typeVal*: JsObject
    id*: cstring

  RTCRTPStreamStats* = object
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

  RTCInboundRTPStreamStats* = object
    packetsReceived*: uint32
    bytesReceived*: uint64
    jitter*: float64
    packetsLost*: uint32
    roundTripTime*: int32
    discardedPackets*: uint32
    framesDecoded*: uint32

  RTCOutboundRTPStreamStats* = object
    packetsSent*: uint32
    bytesSent*: uint64
    targetBitrate*: float64
    droppedFrames*: uint32
    framesEncoded*: uint32

  RTCMediaStreamTrackStats* = object
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

  RTCMediaStreamStats* = object
    streamIdentifier*: cstring
    trackIds*: JsObject

  RTCRTPContributingSourceStats* = object
    contributorSsrc*: uint32
    inboundRtpStreamId*: cstring

  RTCTransportStats* = object
    bytesSent*: uint32
    bytesReceived*: uint32

  RTCIceComponentStats* = object
    transportId*: cstring
    component*: int32
    bytesSent*: uint32
    bytesReceived*: uint32
    activeConnection*: bool
  RTCStatsIceCandidatePairState* = enum
    RTCStatsIceCandidatePairStateFrozen
    RTCStatsIceCandidatePairStateWaiting
    RTCStatsIceCandidatePairStateInprogress
    RTCStatsIceCandidatePairStateFailed
    RTCStatsIceCandidatePairStateSucceeded
    RTCStatsIceCandidatePairStateCancelled

  RTCIceCandidatePairStats* = object
    transportId*: cstring
    localCandidateId*: cstring
    remoteCandidateId*: cstring
    state*: JsObject
    priority*: uint64
    nominated*: bool
    writable*: bool
    readable*: bool
    bytesSent*: uint64
    bytesReceived*: uint64
    lastPacketSentTimestamp*: JsObject
    lastPacketReceivedTimestamp*: JsObject
    selected*: bool
    componentId*: uint32
  RTCStatsIceCandidateType* = enum
    RTCStatsIceCandidateTypeHost
    RTCStatsIceCandidateTypeServerreflexive
    RTCStatsIceCandidateTypePeerreflexive
    RTCStatsIceCandidateTypeRelayed

  RTCIceCandidateStats* = object
    componentId*: cstring
    candidateId*: cstring
    ipAddress*: cstring
    transport*: cstring
    portNumber*: int32
    candidateType*: JsObject

  RTCCodecStats* = object
    payloadType*: uint32
    codec*: cstring
    clockRate*: uint32
    channels*: uint32
    parameters*: cstring

  RTCStatsReportInternal* = object
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
    timestamp*: JsObject
    iceRestarts*: uint32
    iceRollbacks*: uint32
    offerer*: bool
    closed*: bool
    trickledIceCandidateStats*: JsObject
    rawLocalCandidates*: JsObject
    rawRemoteCandidates*: JsObject
  RTCStatsReport* = distinct JsValue

  RTCTrackEventInit* = object
    receiver*: JsObject
    track*: JsObject
    streams*: JsObject
    transceiver*: JsObject
  RTCTrackEvent* = distinct JsValue
  RadioNodeList* = distinct JsValue
  Range* = distinct JsValue

  ClientRectsAndTexts* = object
    rectList*: JsObject
    textList*: JsObject
  RequestInfo* = JsObject
  nsContentPolicyType* = JsObject
  Request* = distinct JsValue

  RequestInit* = object
    methodVal*: cstring
    headers*: JsObject
    referrer*: cstring
    referrerPolicy*: JsObject
    mode*: JsObject
    credentials*: JsObject
    cache*: JsObject
    redirect*: JsObject
    integrity*: cstring
    observe*: JsObject
  RequestDestination* = enum
    RequestDestinationAudio
    RequestDestinationAudioworklet
    RequestDestinationDocument
    RequestDestinationEmbed
    RequestDestinationFont
    RequestDestinationImage
    RequestDestinationManifest
    RequestDestinationObjectVal
    RequestDestinationPaintworklet
    RequestDestinationReport
    RequestDestinationScript
    RequestDestinationSharedworker
    RequestDestinationStyle
    RequestDestinationTrack
    RequestDestinationVideo
    RequestDestinationWorker
    RequestDestinationXslt
  RequestMode* = enum
    RequestModeSame_origin
    RequestModeNo_cors
    RequestModeCors
    RequestModeNavigate
  RequestCredentials* = enum
    RequestCredentialsOmit
    RequestCredentialsSame_origin
    RequestCredentialsIncludeVal
  RequestCache* = enum
    RequestCacheDefault
    RequestCacheNo_store
    RequestCacheReload
    RequestCacheNo_cache
    RequestCacheForce_cache
    RequestCacheOnly_if_cached
  RequestRedirect* = enum
    RequestRedirectFollow
    RequestRedirectError
    RequestRedirectManual
  ReferrerPolicy* = enum
    ReferrerPolicyNo_referrer
    ReferrerPolicyNo_referrer_when_downgrade
    ReferrerPolicyOrigin
    ReferrerPolicyOrigin_when_cross_origin
    ReferrerPolicyUnsafe_url
    ReferrerPolicySame_origin
    ReferrerPolicyStrict_origin
    ReferrerPolicyStrict_origin_when_cross_origin
  ResizeObserverBoxOptions* = enum
    ResizeObserverBoxOptionsBorder_box
    ResizeObserverBoxOptionsContent_box
    ResizeObserverBoxOptionsDevice_pixel_content_box

  ResizeObserverOptions* = object
    box*: JsObject
  ResizeObserver* = distinct JsValue
  ResizeObserverCallback* = proc
  ResizeObserverEntry* = distinct JsValue
  ResizeObserverSize* = distinct JsValue
  Response* = distinct JsValue

  ResponseInit* = object
    status*: uint16
    statusText*: cstring
    headers*: JsObject
  ResponseType* = enum
    ResponseTypeBasic
    ResponseTypeCors
    ResponseTypeDefault
    ResponseTypeError
    ResponseTypeOpaque
    ResponseTypeOpaqueredirect
  SVGAElement* = distinct JsValue
  SVGAngle* = distinct JsValue
  SVGAnimateElement* = distinct JsValue
  SVGAnimateMotionElement* = distinct JsValue
  SVGAnimateTransformElement* = distinct JsValue
  SVGAnimatedAngle* = distinct JsValue
  SVGAnimatedBoolean* = distinct JsValue
  SVGAnimatedEnumeration* = distinct JsValue
  SVGAnimatedInteger* = distinct JsValue
  SVGAnimatedLength* = distinct JsValue
  SVGAnimatedLengthList* = distinct JsValue
  SVGAnimatedNumber* = distinct JsValue
  SVGAnimatedNumberList* = distinct JsValue
  SVGAnimatedPreserveAspectRatio* = distinct JsValue
  SVGAnimatedRect* = distinct JsValue
  SVGAnimatedString* = distinct JsValue
  SVGAnimatedTransformList* = distinct JsValue
  SVGAnimationElement* = distinct JsValue
  SVGCircleElement* = distinct JsValue
  SVGClipPathElement* = distinct JsValue
  SVGComponentTransferFunctionElement* = distinct JsValue
  SVGDefsElement* = distinct JsValue
  SVGDescElement* = distinct JsValue
  SVGElement* = distinct JsValue
  SVGEllipseElement* = distinct JsValue
  SVGFEBlendElement* = distinct JsValue
  SVGFEColorMatrixElement* = distinct JsValue
  SVGFEComponentTransferElement* = distinct JsValue
  SVGFECompositeElement* = distinct JsValue
  SVGFEConvolveMatrixElement* = distinct JsValue
  SVGFEDiffuseLightingElement* = distinct JsValue
  SVGFEDisplacementMapElement* = distinct JsValue
  SVGFEDistantLightElement* = distinct JsValue
  SVGFEDropShadowElement* = distinct JsValue
  SVGFEFloodElement* = distinct JsValue
  SVGFEFuncAElement* = distinct JsValue
  SVGFEFuncBElement* = distinct JsValue
  SVGFEFuncGElement* = distinct JsValue
  SVGFEFuncRElement* = distinct JsValue
  SVGFEGaussianBlurElement* = distinct JsValue
  SVGFEImageElement* = distinct JsValue
  SVGFEMergeElement* = distinct JsValue
  SVGFEMergeNodeElement* = distinct JsValue
  SVGFEMorphologyElement* = distinct JsValue
  SVGFEOffsetElement* = distinct JsValue
  SVGFEPointLightElement* = distinct JsValue
  SVGFESpecularLightingElement* = distinct JsValue
  SVGFESpotLightElement* = distinct JsValue
  SVGFETileElement* = distinct JsValue
  SVGFETurbulenceElement* = distinct JsValue
  SVGFilterElement* = distinct JsValue
  SVGForeignObjectElement* = distinct JsValue
  SVGGElement* = distinct JsValue
  SVGGeometryElement* = distinct JsValue
  SVGGradientElement* = distinct JsValue

  SVGBoundingBoxOptions* = object
    fill*: bool
    stroke*: bool
    markers*: bool
    clipped*: bool
  SVGGraphicsElement* = distinct JsValue
  SVGImageElement* = distinct JsValue
  SVGLength* = distinct JsValue
  SVGLengthList* = distinct JsValue
  SVGLineElement* = distinct JsValue
  SVGLinearGradientElement* = distinct JsValue
  SVGMPathElement* = distinct JsValue
  SVGMarkerElement* = distinct JsValue
  SVGMaskElement* = distinct JsValue
  SVGMatrix* = distinct JsValue
  SVGMetadataElement* = distinct JsValue
  SVGNumber* = distinct JsValue
  SVGNumberList* = distinct JsValue
  SVGPathElement* = distinct JsValue
  SVGPathSeg* = distinct JsValue
  SVGPathSegClosePath* = distinct JsValue
  SVGPathSegMovetoAbs* = distinct JsValue
  SVGPathSegMovetoRel* = distinct JsValue
  SVGPathSegLinetoAbs* = distinct JsValue
  SVGPathSegLinetoRel* = distinct JsValue
  SVGPathSegCurvetoCubicAbs* = distinct JsValue
  SVGPathSegCurvetoCubicRel* = distinct JsValue
  SVGPathSegCurvetoQuadraticAbs* = distinct JsValue
  SVGPathSegCurvetoQuadraticRel* = distinct JsValue
  SVGPathSegArcAbs* = distinct JsValue
  SVGPathSegArcRel* = distinct JsValue
  SVGPathSegLinetoHorizontalAbs* = distinct JsValue
  SVGPathSegLinetoHorizontalRel* = distinct JsValue
  SVGPathSegLinetoVerticalAbs* = distinct JsValue
  SVGPathSegLinetoVerticalRel* = distinct JsValue
  SVGPathSegCurvetoCubicSmoothAbs* = distinct JsValue
  SVGPathSegCurvetoCubicSmoothRel* = distinct JsValue
  SVGPathSegCurvetoQuadraticSmoothAbs* = distinct JsValue
  SVGPathSegCurvetoQuadraticSmoothRel* = distinct JsValue
  SVGPathSegList* = distinct JsValue
  SVGPatternElement* = distinct JsValue
  SVGPoint* = distinct JsValue
  SVGPointList* = distinct JsValue
  SVGPolygonElement* = distinct JsValue
  SVGPolylineElement* = distinct JsValue
  SVGPreserveAspectRatio* = distinct JsValue
  SVGRadialGradientElement* = distinct JsValue
  SVGRect* = distinct JsValue
  SVGRectElement* = distinct JsValue
  SVGSVGElement* = distinct JsValue
  SVGScriptElement* = distinct JsValue
  SVGSetElement* = distinct JsValue
  SVGStopElement* = distinct JsValue
  SVGStringList* = distinct JsValue
  SVGStyleElement* = distinct JsValue
  SVGSwitchElement* = distinct JsValue
  SVGSymbolElement* = distinct JsValue
  SVGTSpanElement* = distinct JsValue
  SVGTextContentElement* = distinct JsValue
  SVGTextElement* = distinct JsValue
  SVGTextPathElement* = distinct JsValue
  SVGTextPositioningElement* = distinct JsValue
  SVGTitleElement* = distinct JsValue
  SVGTransform* = distinct JsValue
  SVGTransformList* = distinct JsValue
  SVGUnitTypes* = distinct JsValue
  SVGUseElement* = distinct JsValue
  SVGViewElement* = distinct JsValue
  SVGZoomAndPan* = distinct JsValue
  Screen* = distinct JsValue
  ScreenColorGamut* = enum
    ScreenColorGamutSrgb
    ScreenColorGamutP3
    ScreenColorGamutRec2020
  ScreenLuminance* = distinct JsValue
  OrientationType* = enum
    OrientationTypePortrait_primary
    OrientationTypePortrait_secondary
    OrientationTypeLandscape_primary
    OrientationTypeLandscape_secondary
  OrientationLockType* = enum
    OrientationLockTypeAny
    OrientationLockTypeNatural
    OrientationLockTypeLandscape
    OrientationLockTypePortrait
    OrientationLockTypePortrait_primary
    OrientationLockTypePortrait_secondary
    OrientationLockTypeLandscape_primary
    OrientationLockTypeLandscape_secondary
  ScreenOrientation* = distinct JsValue
  ScriptProcessorNode* = distinct JsValue
  ScrollAreaEvent* = distinct JsValue
  ScrollBoxObject* = distinct JsValue
  ScrollState* = enum
    ScrollStateStarted
    ScrollStateStopped

  ScrollViewChangeEventInit* = object
    state*: JsObject
  ScrollViewChangeEvent* = distinct JsValue
  SecurityPolicyViolationEventDisposition* = enum
    SecurityPolicyViolationEventDispositionEnforce
    SecurityPolicyViolationEventDispositionReport
  SecurityPolicyViolationEvent* = distinct JsValue

  SecurityPolicyViolationEventInit* = object
    documentURI*: cstring
    referrer*: cstring
    blockedURI*: cstring
    violatedDirective*: cstring
    effectiveDirective*: cstring
    originalPolicy*: cstring
    sourceFile*: cstring
    sample*: cstring
    disposition*: JsObject
    statusCode*: uint16
    lineNumber*: int32
    columnNumber*: int32
  Selection* = distinct JsValue
  ServiceWorker* = distinct JsValue
  ServiceWorkerState* = enum
    ServiceWorkerStateParsed
    ServiceWorkerStateInstalling
    ServiceWorkerStateInstalled
    ServiceWorkerStateActivating
    ServiceWorkerStateActivated
    ServiceWorkerStateRedundant
  ServiceWorkerContainer* = distinct JsValue

  RegistrationOptions* = object
    scope*: cstring
    typeVal*: cstring
    updateViaCache*: JsObject
  ServiceWorkerGlobalScope* = distinct JsValue
  ServiceWorkerRegistration* = distinct JsValue
  ServiceWorkerUpdateViaCache* = enum
    ServiceWorkerUpdateViaCacheImports
    ServiceWorkerUpdateViaCacheAll
    ServiceWorkerUpdateViaCacheNone
  ShadowRootMode* = enum
    ShadowRootModeOpen
    ShadowRootModeClosed
  ShadowRoot* = distinct JsValue

  ShareData* = object
    files*: JsObject
    title*: cstring
    text*: cstring
    url*: cstring
  SharedWorker* = distinct JsValue
  SharedWorkerGlobalScope* = distinct JsValue

  ShowPopoverOptions* = object
    source*: JsObject
  SocketReadyState* = enum
    SocketReadyStateOpening
    SocketReadyStateOpen
    SocketReadyStateClosing
    SocketReadyStateClosed
    SocketReadyStateHalfclosed
  SourceBufferAppendMode* = enum
    SourceBufferAppendModeSegments
    SourceBufferAppendModeSequence
  SourceBuffer* = distinct JsValue
  SourceBufferList* = distinct JsValue
  SpeechGrammar* = distinct JsValue
  SpeechGrammarList* = distinct JsValue
  SpeechRecognition* = distinct JsValue
  SpeechRecognitionAlternative* = distinct JsValue
  SpeechRecognitionErrorCode* = enum
    SpeechRecognitionErrorCodeNo_speech
    SpeechRecognitionErrorCodeAborted
    SpeechRecognitionErrorCodeAudio_capture
    SpeechRecognitionErrorCodeNetwork
    SpeechRecognitionErrorCodeNot_allowed
    SpeechRecognitionErrorCodeService_not_allowed
    SpeechRecognitionErrorCodeBad_grammar
    SpeechRecognitionErrorCodeLanguage_not_supported
  SpeechRecognitionError* = distinct JsValue

  SpeechRecognitionErrorInit* = object
    error*: JsObject
    message*: cstring
  SpeechRecognitionEvent* = distinct JsValue

  SpeechRecognitionEventInit* = object
    resultIndex*: uint32
    interpretation*: JsObject
  SpeechRecognitionResult* = distinct JsValue
  SpeechRecognitionResultList* = distinct JsValue
  SpeechSynthesis* = distinct JsValue
  SpeechSynthesisErrorCode* = enum
    SpeechSynthesisErrorCodeCanceled
    SpeechSynthesisErrorCodeInterrupted
    SpeechSynthesisErrorCodeAudio_busy
    SpeechSynthesisErrorCodeAudio_hardware
    SpeechSynthesisErrorCodeNetwork
    SpeechSynthesisErrorCodeSynthesis_unavailable
    SpeechSynthesisErrorCodeSynthesis_failed
    SpeechSynthesisErrorCodeLanguage_unavailable
    SpeechSynthesisErrorCodeVoice_unavailable
    SpeechSynthesisErrorCodeText_too_long
    SpeechSynthesisErrorCodeInvalid_argument
  SpeechSynthesisErrorEvent* = distinct JsValue

  SpeechSynthesisErrorEventInit* = object
    error*: JsObject
  SpeechSynthesisEvent* = distinct JsValue

  SpeechSynthesisEventInit* = object
    utterance*: JsObject
    charIndex*: uint32
    elapsedTime*: float32
    name*: cstring
  SpeechSynthesisUtterance* = distinct JsValue
  SpeechSynthesisVoice* = distinct JsValue

  StaticRangeInit* = object
    startContainer*: JsObject
    startOffset*: uint32
    endContainer*: JsObject
    endOffset*: uint32
  StaticRange* = distinct JsValue

  StereoPannerOptions* = object
    pan*: float32
  StereoPannerNode* = distinct JsValue
  Storage* = distinct JsValue
  StorageEvent* = distinct JsValue

  StorageEventInit* = object
    url*: cstring
  StorageManager* = distinct JsValue

  StorageEstimate* = object
    usage*: uint64
    quota*: uint64
  StorageType* = enum
    StorageTypePersistent
    StorageTypeTemporary
    StorageTypeDefault
  ReadableStream* = distinct JsValue
  ReadableStreamReader* = JsObject
  ReadableStreamReaderMode* = enum
    ReadableStreamReaderModeByob

  ReadableStreamGetReaderOptions* = object
    mode*: JsObject

  ReadableStreamIteratorOptions* = object
    preventCancel*: bool

  ReadableWritablePair* = object
    readable*: JsObject
    writable*: JsObject

  StreamPipeOptions* = object
    preventClose*: bool
    preventAbort*: bool
    preventCancel*: bool
    signal*: JsObject

  UnderlyingSource* = object
    start*: JsObject
    pull*: JsObject
    cancel*: JsObject
    typeVal*: JsObject
    autoAllocateChunkSize*: uint64
  ReadableStreamController* = JsObject
  UnderlyingSourceStartCallback* = proc
  UnderlyingSourcePullCallback* = proc
  UnderlyingSourceCancelCallback* = proc
  ReadableStreamType* = enum
    ReadableStreamTypeBytes
  ReadableStreamDefaultReader* = distinct JsValue

  ReadableStreamReadResult* = object
    value*: JsObject
    done*: bool
  ReadableStreamBYOBReader* = distinct JsValue
  ReadableStreamDefaultController* = distinct JsValue
  ReadableByteStreamController* = distinct JsValue
  ReadableStreamBYOBRequest* = distinct JsValue
  WritableStream* = distinct JsValue

  UnderlyingSink* = object
    start*: JsObject
    write*: JsObject
    close*: JsObject
    abort*: JsObject
    typeVal*: JsObject
  UnderlyingSinkStartCallback* = proc
  UnderlyingSinkWriteCallback* = proc
  UnderlyingSinkCloseCallback* = proc
  UnderlyingSinkAbortCallback* = proc
  WritableStreamDefaultWriter* = distinct JsValue
  WritableStreamDefaultController* = distinct JsValue
  TransformStream* = distinct JsValue

  Transformer* = object
    start*: JsObject
    transform*: JsObject
    flush*: JsObject
    readableType*: JsObject
    writableType*: JsObject
  TransformerStartCallback* = proc
  TransformerFlushCallback* = proc
  TransformerTransformCallback* = proc
  TransformStreamDefaultController* = distinct JsValue

  QueuingStrategy* = object
    highWaterMark*: float64
    size*: JsObject
  QueuingStrategySize* = proc

  QueuingStrategyInit* = object
    highWaterMark*: float64
  ByteLengthQueuingStrategy* = distinct JsValue
  CountQueuingStrategy* = distinct JsValue
  StyleRuleChangeEvent* = distinct JsValue

  StyleRuleChangeEventInit* = object
  StyleSheet* = distinct JsValue
  StyleSheetApplicableStateChangeEvent* = distinct JsValue

  StyleSheetApplicableStateChangeEventInit* = object
    applicable*: bool
  StyleSheetChangeEvent* = distinct JsValue

  StyleSheetChangeEventInit* = object
    documentSheet*: bool
  StyleSheetList* = distinct JsValue
  SubmitEvent* = distinct JsValue

  SubmitEventInit* = object
  KeyType* = JsObject
  KeyUsage* = JsObject
  NamedCurve* = JsObject
  BigInteger* = JsObject

  Algorithm* = object
    name*: cstring

  AesCbcParams* = object
    iv*: JsObject

  AesCtrParams* = object
    counter*: JsObject
    length*: uint8

  AesGcmParams* = object
    iv*: JsObject
    additionalData*: JsObject
    tagLength*: uint8

  HmacImportParams* = object
    hash*: JsObject

  Pbkdf2Params* = object
    salt*: JsObject
    iterations*: uint32
    hash*: JsObject

  RsaHashedImportParams* = object
    hash*: JsObject

  AesKeyGenParams* = object
    length*: uint16

  HmacKeyGenParams* = object
    hash*: JsObject
    length*: uint32

  RsaOaepParams* = object
    label*: JsObject

  RsaPssParams* = object
    saltLength*: uint32

  EcKeyGenParams* = object
    namedCurve*: JsObject

  AesDerivedKeyParams* = object
    length*: uint32

  HmacDerivedKeyParams* = object
    length*: uint32

  EcdhKeyDeriveParams* = object
    public*: JsObject

  DhKeyDeriveParams* = object
    public*: JsObject

  EcdsaParams* = object
    hash*: JsObject

  EcKeyImportParams* = object
    namedCurve*: JsObject

  HkdfParams* = object
    hash*: JsObject
    salt*: JsObject
    info*: JsObject

  RsaOtherPrimesInfo* = object
    r*: cstring
    d*: cstring
    t*: cstring

  JsonWebKey* = object
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
  CryptoKey* = distinct JsValue

  CryptoKeyPair* = object
    publicKey*: JsObject
    privateKey*: JsObject
  KeyFormat* = JsObject
  AlgorithmIdentifier* = JsObject
  SubtleCrypto* = distinct JsValue

  ServerSocketOptions* = object
    binaryType*: JsObject
  TCPServerSocket* = distinct JsValue
  TCPServerSocketEvent* = distinct JsValue

  TCPServerSocketEventInit* = object
  TCPSocketBinaryType* = enum
    TCPSocketBinaryTypeArraybuffer
    TCPSocketBinaryTypeString

  SocketOptions* = object
    useSecureTransport*: bool
    binaryType*: JsObject
  TCPReadyState* = enum
    TCPReadyStateConnecting
    TCPReadyStateOpen
    TCPReadyStateClosing
    TCPReadyStateClosed
  TCPSocket* = distinct JsValue
  TCPSocketErrorEvent* = distinct JsValue

  TCPSocketErrorEventInit* = object
    name*: cstring
    message*: cstring
  TCPSocketEvent* = distinct JsValue

  TCPSocketEventInit* = object
    data*: JsObject
  Text* = distinct JsValue
  TextClause* = distinct JsValue
  TextDecoder* = distinct JsValue

  TextDecoderOptions* = object
    fatal*: bool

  TextDecodeOptions* = object
    stream*: bool
  TextEncoder* = distinct JsValue
  TextTrackKind* = enum
    TextTrackKindSubtitles
    TextTrackKindCaptions
    TextTrackKindDescriptions
    TextTrackKindChapters
    TextTrackKindMetadata
  TextTrackMode* = enum
    TextTrackModeDisabled
    TextTrackModeHidden
    TextTrackModeShowing
  TextTrack* = distinct JsValue
  TextTrackCue* = distinct JsValue
  TextTrackCueList* = distinct JsValue
  TextTrackList* = distinct JsValue
  TimeEvent* = distinct JsValue
  TimeRanges* = distinct JsValue
  ToggleEvent* = distinct JsValue

  ToggleEventInit* = object
    oldState*: cstring
    newState*: cstring

  TouchInit* = object
    identifier*: int32
    target*: JsObject
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
  Touch* = distinct JsValue

  TouchEventInit* = object
    touches*: JsObject
    targetTouches*: JsObject
    changedTouches*: JsObject
  TouchEvent* = distinct JsValue
  TouchList* = distinct JsValue
  TrackEvent* = distinct JsValue

  TrackEventInit* = object
  TransitionEvent* = distinct JsValue

  TransitionEventInit* = object
    propertyName*: cstring
    elapsedTime*: float32
    pseudoElement*: cstring

  TreeCellInfo* = object
    row*: int32
    childElt*: cstring
  TreeBoxObject* = distinct JsValue
  TreeView* = distinct JsValue
  TreeWalker* = distinct JsValue
  ErrorCode* = JsObject
  Transports* = JsObject
  Transport* = enum
    TransportBt
    TransportBle
    TransportNfc
    TransportUsb

  U2FClientData* = object
    typ*: cstring
    challenge*: cstring
    origin*: cstring

  RegisterRequest* = object
    version*: cstring
    challenge*: cstring

  RegisterResponse* = object
    version*: cstring
    registrationData*: cstring
    clientData*: cstring

  RegisteredKey* = object
    version*: cstring
    keyHandle*: cstring

  SignResponse* = object
    keyHandle*: cstring
    signatureData*: cstring
    clientData*: cstring
  U2FRegisterCallback* = proc
  U2FSignCallback* = proc
  U2F* = distinct JsValue
  UDPMessageEvent* = distinct JsValue

  UDPMessageEventInit* = object
    remoteAddress*: cstring
    remotePort*: uint16
    data*: JsObject

  UDPOptions* = object
    localAddress*: cstring
    localPort*: uint16
    remoteAddress*: cstring
    remotePort*: uint16
    addressReuse*: bool
    loopback*: bool
  UDPSocket* = distinct JsValue
  UIEvent* = distinct JsValue

  UIEventInit* = object
    detail*: int32

  EventModifierInit* = object
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
  URL* = distinct JsValue
  URLSearchParams* = distinct JsValue
  UserActivation* = distinct JsValue
  UserProximityEvent* = distinct JsValue

  UserProximityEventInit* = object
    near*: bool
  VREye* = enum
    VREyeLeft
    VREyeRight
  VRFieldOfView* = distinct JsValue
  VRSource* = JsObject

  VRLayer* = object
    leftBounds*: JsObject
    rightBounds*: JsObject
  VRDisplayCapabilities* = distinct JsValue
  VRStageParameters* = distinct JsValue
  VRPose* = distinct JsValue
  VRFrameData* = distinct JsValue
  VRSubmitFrameResult* = distinct JsValue
  VREyeParameters* = distinct JsValue
  VRDisplay* = distinct JsValue
  VRMockDisplay* = distinct JsValue
  VRMockController* = distinct JsValue
  VRServiceTest* = distinct JsValue
  AutoKeyword* = enum
    AutoKeywordAuto
  LineAlignSetting* = enum
    LineAlignSettingStart
    LineAlignSettingCenter
    LineAlignSettingEndVal
  PositionAlignSetting* = enum
    PositionAlignSettingLine_left
    PositionAlignSettingCenter
    PositionAlignSettingLine_right
    PositionAlignSettingAuto
  AlignSetting* = enum
    AlignSettingStart
    AlignSettingCenter
    AlignSettingEndVal
    AlignSettingLeft
    AlignSettingRight
  DirectionSetting* = enum
    DirectionSettingRl
    DirectionSettingLr
  VTTCue* = distinct JsValue
  ScrollSetting* = enum
    ScrollSettingUp
  VTTRegion* = distinct JsValue
  ValidityState* = distinct JsValue
  VibratePattern* = JsObject
  AlphaOption* = enum
    AlphaOptionKeep
    AlphaOptionDiscardVal
  VideoFrame* = distinct JsValue

  VideoFrameInit* = object
    duration*: uint64
    timestamp*: int64
    alpha*: JsObject
    visibleRect*: JsObject
    displayWidth*: uint32
    displayHeight*: uint32

  VideoFrameBufferInit* = object
    format*: JsObject
    codedWidth*: uint32
    codedHeight*: uint32
    timestamp*: int64
    duration*: uint64
    layout*: JsObject
    visibleRect*: JsObject
    displayWidth*: uint32
    displayHeight*: uint32
    colorSpace*: JsObject

  VideoFrameCopyToOptions* = object
    rect*: JsObject
    layout*: JsObject
    format*: JsObject
    colorSpace*: JsObject

  PlaneLayout* = object
    offset*: uint32
    stride*: uint32
  VideoPixelFormat* = enum
    VideoPixelFormatI420
    VideoPixelFormatI420P10
    VideoPixelFormatI420P12
    VideoPixelFormatI420A
    VideoPixelFormatI420AP10
    VideoPixelFormatI420AP12
    VideoPixelFormatI422
    VideoPixelFormatI422P10
    VideoPixelFormatI422P12
    VideoPixelFormatI422A
    VideoPixelFormatI422AP10
    VideoPixelFormatI422AP12
    VideoPixelFormatI444
    VideoPixelFormatI444P10
    VideoPixelFormatI444P12
    VideoPixelFormatI444A
    VideoPixelFormatI444AP10
    VideoPixelFormatI444AP12
    VideoPixelFormatNV12
    VideoPixelFormatRGBA
    VideoPixelFormatRGBX
    VideoPixelFormatBGRA
    VideoPixelFormatBGRX
  VideoColorSpace* = distinct JsValue

  VideoColorSpaceInit* = object
  VideoColorPrimaries* = enum
    VideoColorPrimariesBt709
    VideoColorPrimariesBt470bg
    VideoColorPrimariesSmpte170m
    VideoColorPrimariesBt2020
    VideoColorPrimariesSmpte432
  VideoTransferCharacteristics* = enum
    VideoTransferCharacteristicsBt709
    VideoTransferCharacteristicsSmpte170m
    VideoTransferCharacteristicsIec61966_2_1
    VideoTransferCharacteristicsLinear
    VideoTransferCharacteristicsPq
    VideoTransferCharacteristicsHlg
  VideoMatrixCoefficients* = enum
    VideoMatrixCoefficientsRgb
    VideoMatrixCoefficientsBt709
    VideoMatrixCoefficientsBt470bg
    VideoMatrixCoefficientsSmpte170m
    VideoMatrixCoefficientsBt2020_ncl
  VideoPlaybackQuality* = distinct JsValue
  VideoStreamTrack* = distinct JsValue
  VideoTrack* = distinct JsValue
  VideoTrackList* = distinct JsValue
  VisualViewport* = distinct JsValue
  OverSampleType* = enum
    OverSampleTypeNone
    OverSampleTypeN2x
    OverSampleTypeN4x

  WaveShaperOptions* = object
    curve*: JsObject
    oversample*: JsObject
  WaveShaperNode* = distinct JsValue
  PublicKeyCredential* = distinct JsValue
  AuthenticatorResponse* = distinct JsValue
  AuthenticatorAttestationResponse* = distinct JsValue
  AuthenticatorAssertionResponse* = distinct JsValue

  PublicKeyCredentialParameters* = object
    typeVal*: JsObject
    alg*: JsObject

  PublicKeyCredentialCreationOptions* = object
    rp*: JsObject
    user*: JsObject
    challenge*: JsObject
    pubKeyCredParams*: JsObject
    timeout*: uint32
    excludeCredentials*: JsObject
    authenticatorSelection*: JsObject
    attestation*: JsObject
    extensions*: JsObject

  PublicKeyCredentialEntity* = object
    name*: cstring
    icon*: cstring

  PublicKeyCredentialRpEntity* = object
    id*: cstring

  PublicKeyCredentialUserEntity* = object
    id*: JsObject
    displayName*: cstring

  AuthenticatorSelectionCriteria* = object
    authenticatorAttachment*: JsObject
    residentKey*: cstring
    requireResidentKey*: bool
    userVerification*: JsObject
  AuthenticatorAttachment* = enum
    AuthenticatorAttachmentPlatform
    AuthenticatorAttachmentCross_platform
  ResidentKeyRequirement* = enum
    ResidentKeyRequirementDiscouraged
    ResidentKeyRequirementPreferred
    ResidentKeyRequirementRequired
  AttestationConveyancePreference* = enum
    AttestationConveyancePreferenceNone
    AttestationConveyancePreferenceIndirect
    AttestationConveyancePreferenceDirect
    AttestationConveyancePreferenceEnterprise

  PublicKeyCredentialRequestOptions* = object
    challenge*: JsObject
    timeout*: uint32
    rpId*: cstring
    allowCredentials*: JsObject
    userVerification*: JsObject
    extensions*: JsObject

  AuthenticationExtensionsClientInputs* = object

  AuthenticationExtensionsClientOutputs* = object

  CollectedClientData* = object
    typeVal*: cstring
    challenge*: cstring
    origin*: cstring
    hashAlgorithm*: cstring
    tokenBindingId*: cstring
    clientExtensions*: JsObject
    authenticatorExtensions*: JsObject
    crossOrigin*: bool
    tokenBinding*: JsObject

  TokenBinding* = object
    status*: cstring
    id*: cstring
  TokenBindingStatus* = enum
    TokenBindingStatusPresent
    TokenBindingStatusSupported
  PublicKeyCredentialType* = enum
    PublicKeyCredentialTypePublic_key

  PublicKeyCredentialDescriptor* = object
    typeVal*: JsObject
    id*: JsObject
    transports*: JsObject
  AuthenticatorTransport* = enum
    AuthenticatorTransportUsb
    AuthenticatorTransportNfc
    AuthenticatorTransportBle
    AuthenticatorTransportInternal
  COSEAlgorithmIdentifier* = JsObject
  UserVerificationRequirement* = enum
    UserVerificationRequirementRequired
    UserVerificationRequirementPreferred
    UserVerificationRequirementDiscouraged
  UvmEntry* = JsObject
  UvmEntries* = JsObject

  CredentialPropertiesOutput* = object
    rk*: bool
  LargeBlobSupport* = enum
    LargeBlobSupportRequired
    LargeBlobSupportPreferred

  AuthenticationExtensionsLargeBlobInputs* = object
    support*: cstring
    read*: bool
    write*: JsObject

  AuthenticationExtensionsLargeBlobOutputs* = object
    supported*: bool
    blob*: JsObject
    written*: bool
  LifecycleConnectedCallback* = proc
  LifecycleDisconnectedCallback* = proc
  LifecycleAdoptedCallback* = proc
  LifecycleAttributeChangedCallback* = proc

  LifecycleCallbacks* = object
    connectedCallback*: JsObject
    disconnectedCallback*: JsObject
    adoptedCallback*: JsObject
    attributeChangedCallback*: JsObject
  GLint64* = JsObject
  GLuint64* = JsObject
  WebGLSampler* = distinct JsValue
  WebGLSync* = distinct JsValue
  WebGLTransformFeedback* = distinct JsValue
  Uint32List* = JsObject
  WebGL2RenderingContext* = distinct JsValue
  EXT_color_buffer_float* = distinct JsValue
  EXT_texture_norm16* = distinct JsValue
  WebGLContextEvent* = distinct JsValue

  WebGLContextEventInit* = object
    statusMessage*: cstring
  WEBGL_multi_draw* = distinct JsValue
  GLenum* = JsObject
  GLboolean* = JsObject
  GLbitfield* = JsObject
  GLbyte* = JsObject
  GLshort* = JsObject
  GLint* = JsObject
  GLsizei* = JsObject
  GLintptr* = JsObject
  GLsizeiptr* = JsObject
  GLubyte* = JsObject
  GLushort* = JsObject
  GLuint* = JsObject
  GLfloat* = JsObject
  GLclampf* = JsObject
  GLuint64EXT* = JsObject
  WebGLPowerPreference* = enum
    WebGLPowerPreferenceDefault
    WebGLPowerPreferenceLow_power
    WebGLPowerPreferenceHigh_performance

  WebGLContextAttributes* = object
    alpha*: JsObject
    depth*: JsObject
    stencil*: JsObject
    antialias*: JsObject
    premultipliedAlpha*: JsObject
    preserveDrawingBuffer*: JsObject
    failIfMajorPerformanceCaveat*: JsObject
    powerPreference*: JsObject
  WebGLBuffer* = distinct JsValue
  WebGLFramebuffer* = distinct JsValue
  WebGLProgram* = distinct JsValue
  WebGLRenderbuffer* = distinct JsValue
  WebGLShader* = distinct JsValue
  WebGLTexture* = distinct JsValue
  WebGLUniformLocation* = distinct JsValue
  WebGLVertexArrayObject* = distinct JsValue
  WebGLActiveInfo* = distinct JsValue
  WebGLShaderPrecisionFormat* = distinct JsValue
  Float32List* = JsObject
  Int32List* = JsObject
  WebGLRenderingContext* = distinct JsValue
  WEBGL_compressed_texture_s3tc* = distinct JsValue
  WEBGL_compressed_texture_s3tc_srgb* = distinct JsValue
  WEBGL_compressed_texture_astc* = distinct JsValue
  WEBGL_compressed_texture_atc* = distinct JsValue
  WEBGL_compressed_texture_etc* = distinct JsValue
  WEBGL_compressed_texture_etc1* = distinct JsValue
  WEBGL_compressed_texture_pvrtc* = distinct JsValue
  WEBGL_debug_renderer_info* = distinct JsValue
  WEBGL_debug_shaders* = distinct JsValue
  WEBGL_depth_texture* = distinct JsValue
  OES_element_index_uint* = distinct JsValue
  EXT_frag_depth* = distinct JsValue
  WEBGL_lose_context* = distinct JsValue
  EXT_texture_filter_anisotropic* = distinct JsValue
  EXT_sRGB* = distinct JsValue
  OES_standard_derivatives* = distinct JsValue
  OES_texture_float* = distinct JsValue
  WEBGL_draw_buffers* = distinct JsValue
  OES_texture_float_linear* = distinct JsValue
  EXT_shader_texture_lod* = distinct JsValue
  OES_texture_half_float* = distinct JsValue
  OES_texture_half_float_linear* = distinct JsValue
  WEBGL_color_buffer_float* = distinct JsValue
  EXT_color_buffer_half_float* = distinct JsValue
  OES_vertex_array_object* = distinct JsValue
  ANGLE_instanced_arrays* = distinct JsValue
  EXT_blend_minmax* = distinct JsValue
  WebGLQuery* = distinct JsValue
  EXT_disjoint_timer_query* = distinct JsValue
  MOZ_debug* = distinct JsValue
  WebKitCSSMatrix* = distinct JsValue
  BinaryType* = enum
    BinaryTypeBlob
    BinaryTypeArraybuffer
  WebSocket* = distinct JsValue
  WheelEvent* = distinct JsValue

  WheelEventInit* = object
    deltaX*: float64
    deltaY*: float64
    deltaZ*: float64
    deltaMode*: uint32

  WidevineCDMManifest* = object
    name*: cstring
    description*: cstring
    version*: cstring
    x*: cstring
    cdm*: JsObject
    module*: JsObject
    versions*: JsObject
    x2*: cstring
    cdm2*: JsObject
    interfaceVal*: JsObject
    versions2*: JsObject
    x3*: cstring
    cdm3*: JsObject
    host*: JsObject
    versions3*: JsObject
    x4*: cstring
    cdm4*: JsObject
    codecs*: JsObject
  Window* = distinct JsValue
  ScrollBehavior* = enum
    ScrollBehaviorAuto
    ScrollBehaviorInstant
    ScrollBehaviorSmooth

  ScrollOptions* = object
    behavior*: JsObject

  ScrollToOptions* = object
    left*: float64
    top*: float64
  PromiseDocumentFlushedCallback* = proc

  IdleRequestOptions* = object
    timeout*: uint32
  IdleRequestCallback* = proc
  Worker* = distinct JsValue

  WorkerOptions* = object
    typeVal*: JsObject
    credentials*: JsObject
    name*: cstring
  WorkerType* = enum
    WorkerTypeClassic
    WorkerTypeModule
  ChromeWorker* = distinct JsValue
  WorkerDebuggerGlobalScope* = distinct JsValue
  WorkerGlobalScope* = distinct JsValue
  WorkerLocation* = distinct JsValue
  WorkerNavigator* = distinct JsValue
  Worklet* = distinct JsValue

  WorkletOptions* = object
    credentials*: JsObject
  WorkletGlobalScope* = distinct JsValue
  XMLDocument* = distinct JsValue
  XMLHttpRequestResponseType* = enum
    XMLHttpRequestResponseTypeArraybuffer
    XMLHttpRequestResponseTypeBlob
    XMLHttpRequestResponseTypeDocument
    XMLHttpRequestResponseTypeJson
    XMLHttpRequestResponseTypeText
  XMLHttpRequest* = distinct JsValue
  XMLHttpRequestEventTarget* = distinct JsValue
  XMLHttpRequestUpload* = distinct JsValue
  XMLSerializer* = distinct JsValue
  XPathExpression* = distinct JsValue
  XPathNSResolver* = proc
  XPathResult* = distinct JsValue
  XSLTProcessor* = distinct JsValue
  nsISupports* = JsObject

proc jsAbortControllerSignal*(self: AbortController): JsObject =
  discard
proc jsAbort*(self: AbortController; reason: JsObject): void =
  discard

proc jsAbortSignalAborted*(self: AbortSignal): bool =
  discard
proc jsAbortSignalReason*(self: AbortSignal): JsObject =
  discard
proc jsAbortSignalOnabort*(self: AbortSignal): JsObject =
  discard
proc jsAbort*(self: typedesc[AbortSignal]; reason: JsObject): JsObject =
  discard
proc jsTimeout*(self: typedesc[AbortSignal]; milliseconds: uint64): JsObject =
  discard
proc jsAny*(self: typedesc[AbortSignal]; signals: JsObject): JsObject =
  discard
proc jsThrowIfAborted*(self: AbortSignal): void =
  discard

proc jsAbstractRangeStartContainer*(self: AbstractRange): JsObject =
  discard
proc jsAbstractRangeStartOffset*(self: AbstractRange): uint32 =
  discard
proc jsAbstractRangeEndContainer*(self: AbstractRange): JsObject =
  discard
proc jsAbstractRangeEndOffset*(self: AbstractRange): uint32 =
  discard
proc jsAbstractRangeCollapsed*(self: AbstractRange): bool =
  discard

proc jsAnalyserNodeFftSize*(self: AnalyserNode): uint32 =
  discard
proc jsAnalyserNodeFrequencyBinCount*(self: AnalyserNode): uint32 =
  discard
proc jsAnalyserNodeMinDecibels*(self: AnalyserNode): float64 =
  discard
proc jsAnalyserNodeMaxDecibels*(self: AnalyserNode): float64 =
  discard
proc jsAnalyserNodeSmoothingTimeConstant*(self: AnalyserNode): float64 =
  discard
proc jsGetFloatFrequencyData*(self: AnalyserNode; array: seq[float32]): void =
  discard
proc jsGetByteFrequencyData*(self: AnalyserNode; array: seq[uint8]): void =
  discard
proc jsGetFloatTimeDomainData*(self: AnalyserNode; array: seq[float32]): void =
  discard
proc jsGetByteTimeDomainData*(self: AnalyserNode; array: seq[uint8]): void =
  discard

proc jsAnimationId*(self: Animation): cstring =
  discard
proc jsAnimationPlaybackRate*(self: Animation): float64 =
  discard
proc jsAnimationPlayState*(self: Animation): JsObject =
  discard
proc jsAnimationPending*(self: Animation): bool =
  discard
proc jsAnimationReady*(self: Animation): JsObject =
  discard
proc jsAnimationFinished*(self: Animation): JsObject =
  discard
proc jsAnimationOnfinish*(self: Animation): JsObject =
  discard
proc jsAnimationOncancel*(self: Animation): JsObject =
  discard
proc jsCancel*(self: Animation): void =
  discard
proc jsFinish*(self: Animation): void =
  discard
proc jsPlay*(self: Animation): void =
  discard
proc jsPause*(self: Animation): void =
  discard
proc jsUpdatePlaybackRate*(self: Animation; playbackRate: float64): void =
  discard
proc jsReverse*(self: Animation): void =
  discard

proc jsGetTiming*(self: AnimationEffect): JsObject =
  discard
proc jsGetComputedTiming*(self: AnimationEffect): JsObject =
  discard
proc jsUpdateTiming*(self: AnimationEffect; timing: JsObject): void =
  discard

proc jsAnimationEventAnimationName*(self: AnimationEvent): cstring =
  discard
proc jsAnimationEventElapsedTime*(self: AnimationEvent): float32 =
  discard
proc jsAnimationEventPseudoElement*(self: AnimationEvent): cstring =
  discard



proc jsAttrLocalName*(self: Attr): cstring =
  discard
proc jsAttrValue*(self: Attr): cstring =
  discard
proc jsAttrName*(self: Attr): cstring =
  discard
proc jsAttrSpecified*(self: Attr): bool =
  discard

proc jsAudioBufferSampleRate*(self: AudioBuffer): float32 =
  discard
proc jsAudioBufferLength*(self: AudioBuffer): uint32 =
  discard
proc jsAudioBufferDuration*(self: AudioBuffer): float64 =
  discard
proc jsAudioBufferNumberOfChannels*(self: AudioBuffer): uint32 =
  discard
proc jsGetChannelData*(self: AudioBuffer; channel: uint32): seq[float32] =
  discard
proc jsCopyFromChannel*(self: AudioBuffer; destination: seq[float32]; channelNumber: int32; startInChannel: uint32): void =
  discard
proc jsCopyToChannel*(self: AudioBuffer; source: seq[float32]; channelNumber: int32; startInChannel: uint32): void =
  discard

proc jsAudioBufferSourceNodePlaybackRate*(self: AudioBufferSourceNode): JsObject =
  discard
proc jsAudioBufferSourceNodeDetune*(self: AudioBufferSourceNode): JsObject =
  discard
proc jsAudioBufferSourceNodeLoop*(self: AudioBufferSourceNode): bool =
  discard
proc jsAudioBufferSourceNodeLoopStart*(self: AudioBufferSourceNode): float64 =
  discard
proc jsAudioBufferSourceNodeLoopEnd*(self: AudioBufferSourceNode): float64 =
  discard
proc jsAudioBufferSourceNodeOnended*(self: AudioBufferSourceNode): JsObject =
  discard
proc jsStart*(self: AudioBufferSourceNode; whenVal: float64; offset: float64; duration: float64): void =
  discard
proc jsStop*(self: AudioBufferSourceNode; whenVal: float64): void =
  discard

proc jsSuspend*(self: AudioContext): JsObject =
  discard
proc jsClose*(self: AudioContext): JsObject =
  discard
proc jsCreateMediaElementSource*(self: AudioContext; mediaElement: JsObject): JsObject =
  discard
proc jsCreateMediaStreamSource*(self: AudioContext; mediaStream: JsObject): JsObject =
  discard
proc jsCreateMediaStreamDestination*(self: AudioContext): JsObject =
  discard

proc jsAudioDestinationNodeMaxChannelCount*(self: AudioDestinationNode): uint32 =
  discard

proc jsAudioListenerDopplerFactor*(self: AudioListener): float64 =
  discard
proc jsAudioListenerSpeedOfSound*(self: AudioListener): float64 =
  discard
proc jsSetPosition*(self: AudioListener; x: float64; y: float64; z: float64): void =
  discard
proc jsSetOrientation*(self: AudioListener; x: float64; y: float64; z: float64; xUp: float64; yUp: float64; zUp: float64): void =
  discard
proc jsSetVelocity*(self: AudioListener; x: float64; y: float64; z: float64): void =
  discard

proc jsAudioNodeContext*(self: AudioNode): JsObject =
  discard
proc jsAudioNodeNumberOfInputs*(self: AudioNode): uint32 =
  discard
proc jsAudioNodeNumberOfOutputs*(self: AudioNode): uint32 =
  discard
proc jsAudioNodeChannelCount*(self: AudioNode): uint32 =
  discard
proc jsAudioNodeChannelCountMode*(self: AudioNode): JsObject =
  discard
proc jsAudioNodeChannelInterpretation*(self: AudioNode): JsObject =
  discard
proc jsConnect*(self: AudioNode; destination: JsObject; output: uint32; input: uint32): JsObject =
  discard
proc jsConnect*(self: AudioNode; destination: JsObject; output: uint32): void =
  discard
proc jsDisconnect*(self: AudioNode): void =
  discard
proc jsDisconnect*(self: AudioNode; output: uint32): void =
  discard
proc jsDisconnect*(self: AudioNode; destination: JsObject): void =
  discard
proc jsDisconnect*(self: AudioNode; destination: JsObject; output: uint32): void =
  discard
proc jsDisconnect*(self: AudioNode; destination: JsObject; output: uint32; input: uint32): void =
  discard

proc jsAudioParamValue*(self: AudioParam): float32 =
  discard
proc jsAudioParamDefaultValue*(self: AudioParam): float32 =
  discard
proc jsAudioParamMinValue*(self: AudioParam): float32 =
  discard
proc jsAudioParamMaxValue*(self: AudioParam): float32 =
  discard
proc jsSetValueAtTime*(self: AudioParam; value: float32; startTime: float64): JsObject =
  discard
proc jsLinearRampToValueAtTime*(self: AudioParam; value: float32; endTime: float64): JsObject =
  discard
proc jsExponentialRampToValueAtTime*(self: AudioParam; value: float32; endTime: float64): JsObject =
  discard
proc jsSetTargetAtTime*(self: AudioParam; target: float32; startTime: float64; timeConstant: float64): JsObject =
  discard
proc jsSetValueCurveAtTime*(self: AudioParam; values: seq[float32]; startTime: float64; duration: float64): JsObject =
  discard
proc jsCancelScheduledValues*(self: AudioParam; startTime: float64): JsObject =
  discard


proc jsAudioProcessingEventPlaybackTime*(self: AudioProcessingEvent): float64 =
  discard
proc jsAudioProcessingEventInputBuffer*(self: AudioProcessingEvent): JsObject =
  discard
proc jsAudioProcessingEventOutputBuffer*(self: AudioProcessingEvent): JsObject =
  discard



proc jsAudioTrackId*(self: AudioTrack): cstring =
  discard
proc jsAudioTrackKind*(self: AudioTrack): cstring =
  discard
proc jsAudioTrackLabel*(self: AudioTrack): cstring =
  discard
proc jsAudioTrackLanguage*(self: AudioTrack): cstring =
  discard
proc jsAudioTrackEnabled*(self: AudioTrack): bool =
  discard

proc jsAudioTrackListLength*(self: AudioTrackList): uint32 =
  discard
proc jsAudioTrackListOnchange*(self: AudioTrackList): JsObject =
  discard
proc jsAudioTrackListOnaddtrack*(self: AudioTrackList): JsObject =
  discard
proc jsAudioTrackListOnremovetrack*(self: AudioTrackList): JsObject =
  discard
proc jsGetTrackById*(self: AudioTrackList; id: cstring): Option[JsObject] =
  discard


proc jsAudioWorkletGlobalScopeCurrentFrame*(self: AudioWorkletGlobalScope): uint64 =
  discard
proc jsAudioWorkletGlobalScopeCurrentTime*(self: AudioWorkletGlobalScope): float64 =
  discard
proc jsAudioWorkletGlobalScopeSampleRate*(self: AudioWorkletGlobalScope): float32 =
  discard
proc jsRegisterProcessor*(self: AudioWorkletGlobalScope; name: cstring; processorCtor: JsObject): void =
  discard

proc jsAudioWorkletNodeParameters*(self: AudioWorkletNode): JsObject =
  discard
proc jsAudioWorkletNodePort*(self: AudioWorkletNode): JsObject =
  discard
proc jsAudioWorkletNodeOnprocessorerror*(self: AudioWorkletNode): JsObject =
  discard

proc jsAudioWorkletProcessorPort*(self: AudioWorkletProcessor): JsObject =
  discard

proc jsBarPropVisible*(self: BarProp): bool =
  discard


proc jsBatteryManagerCharging*(self: BatteryManager): bool =
  discard
proc jsBatteryManagerChargingTime*(self: BatteryManager): float64 =
  discard
proc jsBatteryManagerDischargingTime*(self: BatteryManager): float64 =
  discard
proc jsBatteryManagerLevel*(self: BatteryManager): float64 =
  discard
proc jsBatteryManagerOnchargingchange*(self: BatteryManager): JsObject =
  discard
proc jsBatteryManagerOnchargingtimechange*(self: BatteryManager): JsObject =
  discard
proc jsBatteryManagerOndischargingtimechange*(self: BatteryManager): JsObject =
  discard
proc jsBatteryManagerOnlevelchange*(self: BatteryManager): JsObject =
  discard

proc jsBeforeUnloadEventReturnValue*(self: BeforeUnloadEvent): cstring =
  discard

proc jsBiquadFilterNodeTypeVal*(self: BiquadFilterNode): JsObject =
  discard
proc jsBiquadFilterNodeFrequency*(self: BiquadFilterNode): JsObject =
  discard
proc jsBiquadFilterNodeDetune*(self: BiquadFilterNode): JsObject =
  discard
proc jsBiquadFilterNodeQ*(self: BiquadFilterNode): JsObject =
  discard
proc jsBiquadFilterNodeGain*(self: BiquadFilterNode): JsObject =
  discard
proc jsGetFrequencyResponse*(self: BiquadFilterNode; frequencyHz: seq[float32]; magResponse: seq[float32]; phaseResponse: seq[float32]): void =
  discard

proc jsBlobSize*(self: Blob): uint64 =
  discard
proc jsBlobTypeVal*(self: Blob): cstring =
  discard
proc jsSlice*(self: Blob; start: int64; endVal: int64; contentType: cstring): JsObject =
  discard
proc jsStream*(self: Blob): JsObject =
  discard
proc jsText*(self: Blob): JsObject =
  discard
proc jsArrayBuffer*(self: Blob): JsObject =
  discard
proc jsBytes*(self: Blob): JsObject =
  discard


proc jsBroadcastChannelName*(self: BroadcastChannel): cstring =
  discard
proc jsBroadcastChannelOnmessage*(self: BroadcastChannel): JsObject =
  discard
proc jsBroadcastChannelOnmessageerror*(self: BroadcastChannel): JsObject =
  discard
proc jsPostMessage*(self: BroadcastChannel; message: JsObject): void =
  discard
proc jsClose*(self: BroadcastChannel): void =
  discard

proc jsWriteContent*(self: BrowserFeedWriter): void =
  discard
proc jsClose*(self: BrowserFeedWriter): void =
  discard


proc CSSVal*() =
  discard
proc supports*(property: cstring; value: cstring): bool =
  discard

proc escape*(ident: cstring): cstring =
  discard

proc jsCSSAnimationAnimationName*(self: CSSAnimation): cstring =
  discard

proc jsCSSConditionRuleConditionText*(self: CSSConditionRule): cstring =
  discard

proc jsCSSCounterStyleRuleName*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRuleSystem*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRuleSymbols*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRuleAdditiveSymbols*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRuleNegative*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRulePrefix*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRuleSuffix*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRuleRange*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRulePad*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRuleSpeakAs*(self: CSSCounterStyleRule): cstring =
  discard
proc jsCSSCounterStyleRuleFallback*(self: CSSCounterStyleRule): cstring =
  discard

proc jsCSSFontFaceRuleStyle*(self: CSSFontFaceRule): JsObject =
  discard

proc jsCSSFontFeatureValuesRuleFontFamily*(self: CSSFontFeatureValuesRule): cstring =
  discard

proc jsCSSGroupingRuleCssRules*(self: CSSGroupingRule): JsObject =
  discard
proc jsInsertRule*(self: CSSGroupingRule; rule: cstring; index: uint32): uint32 =
  discard
proc jsDeleteRule*(self: CSSGroupingRule; index: uint32): void =
  discard

proc jsCSSImportRuleHref*(self: CSSImportRule): cstring =
  discard

proc jsCSSKeyframeRuleKeyText*(self: CSSKeyframeRule): cstring =
  discard
proc jsCSSKeyframeRuleStyle*(self: CSSKeyframeRule): JsObject =
  discard

proc jsCSSKeyframesRuleName*(self: CSSKeyframesRule): cstring =
  discard
proc jsCSSKeyframesRuleCssRules*(self: CSSKeyframesRule): JsObject =
  discard
proc jsAppendRule*(self: CSSKeyframesRule; rule: cstring): void =
  discard
proc jsDeleteRule*(self: CSSKeyframesRule; select: cstring): void =
  discard
proc jsFindRule*(self: CSSKeyframesRule; select: cstring): Option[JsObject] =
  discard

proc jsCSSMediaRuleMedia*(self: CSSMediaRule): JsObject =
  discard

proc jsCSSNamespaceRuleNamespaceURI*(self: CSSNamespaceRule): cstring =
  discard
proc jsCSSNamespaceRulePrefix*(self: CSSNamespaceRule): cstring =
  discard

proc jsCSSPageRuleStyle*(self: CSSPageRule): JsObject =
  discard

proc jsCSSPseudoElementTypeVal*(self: CSSPseudoElement): cstring =
  discard
proc jsCSSPseudoElementParentElement*(self: CSSPseudoElement): JsObject =
  discard

const jsCSSRuleSTYLE_RULE* : uint16 = 0
const jsCSSRuleCHARSET_RULE* : uint16 = 0
const jsCSSRuleIMPORT_RULE* : uint16 = 0
const jsCSSRuleMEDIA_RULE* : uint16 = 0
const jsCSSRuleFONT_FACE_RULE* : uint16 = 0
const jsCSSRulePAGE_RULE* : uint16 = 0
const jsCSSRuleNAMESPACE_RULE* : uint16 = 0
proc jsCSSRuleTypeVal*(self: CSSRule): uint16 =
  discard
proc jsCSSRuleCssText*(self: CSSRule): cstring =
  discard

proc jsCSSRuleListLength*(self: CSSRuleList): uint32 =
  discard
proc jsItem*(self: CSSRuleList; index: uint32): Option[JsObject] =
  discard

proc jsCSSStyleDeclarationCssText*(self: CSSStyleDeclaration): cstring =
  discard
proc jsCSSStyleDeclarationLength*(self: CSSStyleDeclaration): uint32 =
  discard
proc jsItem*(self: CSSStyleDeclaration; index: uint32): cstring =
  discard
proc jsGetCSSImageURLs*(self: CSSStyleDeclaration; property: cstring): JsObject =
  discard
proc jsGetPropertyValue*(self: CSSStyleDeclaration; property: cstring): cstring =
  discard
proc jsGetPropertyPriority*(self: CSSStyleDeclaration; property: cstring): cstring =
  discard
proc jsSetProperty*(self: CSSStyleDeclaration; property: cstring; value: cstring; priority: cstring): void =
  discard
proc jsRemoveProperty*(self: CSSStyleDeclaration; property: cstring): cstring =
  discard

proc jsCSSStyleRuleSelectorText*(self: CSSStyleRule): cstring =
  discard
proc jsCSSStyleRuleStyle*(self: CSSStyleRule): JsObject =
  discard

proc jsCSSStyleSheetCssRules*(self: CSSStyleSheet): JsObject =
  discard
proc jsCSSStyleSheetParsingMode*(self: CSSStyleSheet): JsObject =
  discard
proc jsInsertRule*(self: CSSStyleSheet; rule: cstring; index: uint32): uint32 =
  discard
proc jsDeleteRule*(self: CSSStyleSheet; index: uint32): void =
  discard
proc jsReplace*(self: CSSStyleSheet; text: cstring): JsObject =
  discard
proc jsReplaceSync*(self: CSSStyleSheet; text: cstring): void =
  discard


proc jsCSSTransitionTransitionProperty*(self: CSSTransition): cstring =
  discard

proc jsMatch*(self: Cache; request: JsObject; options: JsObject): JsObject =
  discard
proc jsMatchAll*(self: Cache; request: JsObject; options: JsObject): JsObject =
  discard
proc jsAdd*(self: Cache; request: JsObject): JsObject =
  discard
proc jsAddAll*(self: Cache; requests: JsObject): JsObject =
  discard
proc jsPut*(self: Cache; request: JsObject; response: JsObject): JsObject =
  discard
proc jsDelete*(self: Cache; request: JsObject; options: JsObject): JsObject =
  discard
proc jsKeys*(self: Cache; request: JsObject; options: JsObject): JsObject =
  discard

proc jsMatch*(self: CacheStorage; request: JsObject; options: JsObject): JsObject =
  discard
proc jsHas*(self: CacheStorage; cacheName: cstring): JsObject =
  discard
proc jsOpen*(self: CacheStorage; cacheName: cstring): JsObject =
  discard
proc jsDelete*(self: CacheStorage; cacheName: cstring): JsObject =
  discard
proc jsKeys*(self: CacheStorage): JsObject =
  discard

proc jsCanvasCaptureMediaStreamCanvas*(self: CanvasCaptureMediaStream): JsObject =
  discard
proc jsRequestFrame*(self: CanvasCaptureMediaStream): void =
  discard

proc jsCanvasCaptureMediaStreamTrackCanvas*(self: CanvasCaptureMediaStreamTrack): JsObject =
  discard
proc jsRequestFrame*(self: CanvasCaptureMediaStreamTrack): void =
  discard

const jsCanvasRenderingContext2DDRAWWINDOW_DRAW_CARET* : uint32 = 0
const jsCanvasRenderingContext2DDRAWWINDOW_DO_NOT_FLUSH* : uint32 = 0
const jsCanvasRenderingContext2DDRAWWINDOW_DRAW_VIEW* : uint32 = 0
const jsCanvasRenderingContext2DDRAWWINDOW_USE_WIDGET_LAYERS* : uint32 = 0
const jsCanvasRenderingContext2DDRAWWINDOW_ASYNC_DECODE_IMAGES* : uint32 = 0
proc jsDrawWindow*(self: CanvasRenderingContext2D; window: JsObject; x: float64; y: float64; w: float64; h: float64; bgColor: cstring; flags: uint32): void =
  discard
proc jsDemote*(self: CanvasRenderingContext2D): void =
  discard

proc jsAddColorStop*(self: CanvasGradient; offset: float32; color: cstring): void =
  discard

proc jsSetTransform*(self: CanvasPattern; matrix: JsObject): void =
  discard

proc jsTextMetricsWidth*(self: TextMetrics): float64 =
  discard
proc jsTextMetricsActualBoundingBoxLeft*(self: TextMetrics): float64 =
  discard
proc jsTextMetricsActualBoundingBoxRight*(self: TextMetrics): float64 =
  discard
proc jsTextMetricsFontBoundingBoxAscent*(self: TextMetrics): float64 =
  discard
proc jsTextMetricsFontBoundingBoxDescent*(self: TextMetrics): float64 =
  discard
proc jsTextMetricsActualBoundingBoxAscent*(self: TextMetrics): float64 =
  discard
proc jsTextMetricsActualBoundingBoxDescent*(self: TextMetrics): float64 =
  discard

proc jsAddPath*(self: Path2D; path: JsObject; transformation: JsObject): void =
  discard

proc jsCaretPositionOffset*(self: CaretPosition): uint32 =
  discard

proc jsCaretStateChangedEventCollapsed*(self: CaretStateChangedEvent): bool =
  discard
proc jsCaretStateChangedEventReason*(self: CaretStateChangedEvent): JsObject =
  discard
proc jsCaretStateChangedEventCaretVisible*(self: CaretStateChangedEvent): bool =
  discard
proc jsCaretStateChangedEventCaretVisuallyVisible*(self: CaretStateChangedEvent): bool =
  discard
proc jsCaretStateChangedEventSelectionVisible*(self: CaretStateChangedEvent): bool =
  discard
proc jsCaretStateChangedEventSelectionEditable*(self: CaretStateChangedEvent): bool =
  discard
proc jsCaretStateChangedEventSelectedTextContent*(self: CaretStateChangedEvent): cstring =
  discard



proc jsCharacterDataData*(self: CharacterData): cstring =
  discard
proc jsCharacterDataLength*(self: CharacterData): uint32 =
  discard
proc jsSubstringData*(self: CharacterData; offset: uint32; count: uint32): cstring =
  discard
proc jsAppendData*(self: CharacterData; data: cstring): void =
  discard
proc jsInsertData*(self: CharacterData; offset: uint32; data: cstring): void =
  discard
proc jsDeleteData*(self: CharacterData; offset: uint32; count: uint32): void =
  discard
proc jsReplaceData*(self: CharacterData; offset: uint32; count: uint32; data: cstring): void =
  discard

proc jsGetReports*(self: CheckerboardReportService): JsObject =
  discard
proc jsIsRecordingEnabled*(self: CheckerboardReportService): bool =
  discard
proc jsSetRecordingEnabled*(self: CheckerboardReportService; aEnabled: bool): void =
  discard
proc jsFlushActiveReports*(self: CheckerboardReportService): void =
  discard

proc jsClientUrl*(self: Client): cstring =
  discard
proc jsClientFrameType*(self: Client): JsObject =
  discard
proc jsClientTypeVal*(self: Client): JsObject =
  discard
proc jsClientId*(self: Client): cstring =
  discard
proc jsPostMessage*(self: Client; message: JsObject; transfer: JsObject): void =
  discard

proc jsWindowClientVisibilityState*(self: WindowClient): JsObject =
  discard
proc jsWindowClientFocused*(self: WindowClient): bool =
  discard
proc jsFocus*(self: WindowClient): JsObject =
  discard
proc jsNavigate*(self: WindowClient; url: cstring): JsObject =
  discard

proc jsGet*(self: Clients; id: cstring): JsObject =
  discard
proc jsMatchAll*(self: Clients; options: JsObject): JsObject =
  discard
proc jsOpenWindow*(self: Clients; url: cstring): JsObject =
  discard
proc jsClaim*(self: Clients): JsObject =
  discard


proc jsClipboardItemPresentationStyle*(self: ClipboardItem): JsObject =
  discard
proc jsClipboardItemTypes*(self: ClipboardItem): JsObject =
  discard
proc jsGetType*(self: ClipboardItem; typeVal: cstring): JsObject =
  discard
proc jsSupports*(self: typedesc[ClipboardItem]; typeVal: cstring): bool =
  discard

proc jsRead*(self: Clipboard; formats: JsObject): JsObject =
  discard
proc jsReadText*(self: Clipboard): JsObject =
  discard
proc jsWrite*(self: Clipboard; data: JsObject): JsObject =
  discard
proc jsWriteText*(self: Clipboard; data: cstring): JsObject =
  discard

proc jsCloseEventWasClean*(self: CloseEvent): bool =
  discard
proc jsCloseEventCode*(self: CloseEvent): uint16 =
  discard
proc jsCloseEventReason*(self: CloseEvent): cstring =
  discard

proc jsCommandEventCommand*(self: CommandEvent): cstring =
  discard


proc jsCompositionEventLocale*(self: CompositionEvent): cstring =
  discard
proc jsCompositionEventRanges*(self: CompositionEvent): JsObject =
  discard

proc consoleVal*() =
  discard
proc assert*(condition: bool; data: JsObject): void =
  discard
proc clear*(): void =
  discard
proc count*(label: cstring): void =
  discard
proc countReset*(label: cstring): void =
  discard
proc debug*(data: JsObject): void =
  discard
proc error*(data: JsObject): void =
  discard
proc info*(data: JsObject): void =
  discard
proc log*(data: JsObject): void =
  discard
proc table*(data: JsObject): void =
  discard
proc trace*(data: JsObject): void =
  discard
proc warn*(data: JsObject): void =
  discard
proc dir*(data: JsObject): void =
  discard
proc dirxml*(data: JsObject): void =
  discard
proc group*(data: JsObject): void =
  discard
proc groupCollapsed*(data: JsObject): void =
  discard
proc groupEnd*(): void =
  discard
proc time*(label: cstring): void =
  discard
proc timeLog*(label: cstring; data: JsObject): void =
  discard
proc timeEnd*(label: cstring): void =
  discard
proc exception*(data: JsObject): void =
  discard
proc timeStamp*(data: JsObject): void =
  discard
proc profile*(data: JsObject): void =
  discard
proc profileEnd*(data: JsObject): void =
  discard
proc createInstance*(options: JsObject): JsObject =
  discard

proc jsAssert*(self: ConsoleInstance; condition: bool; data: JsObject): void =
  discard
proc jsClear*(self: ConsoleInstance): void =
  discard
proc jsCount*(self: ConsoleInstance; label: cstring): void =
  discard
proc jsCountReset*(self: ConsoleInstance; label: cstring): void =
  discard
proc jsDebug*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsError*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsInfo*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsLog*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsTable*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsTrace*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsWarn*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsDir*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsDirxml*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsGroup*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsGroupCollapsed*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsGroupEnd*(self: ConsoleInstance): void =
  discard
proc jsTime*(self: ConsoleInstance; label: cstring): void =
  discard
proc jsTimeLog*(self: ConsoleInstance; label: cstring; data: JsObject): void =
  discard
proc jsTimeEnd*(self: ConsoleInstance; label: cstring): void =
  discard
proc jsException*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsTimeStamp*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsProfile*(self: ConsoleInstance; data: JsObject): void =
  discard
proc jsProfileEnd*(self: ConsoleInstance; data: JsObject): void =
  discard

proc jsConstantSourceNodeOffset*(self: ConstantSourceNode): JsObject =
  discard

proc jsConvolverNodeNormalize*(self: ConvolverNode): bool =
  discard

proc jsCookieStoreOnchange*(self: CookieStore): JsObject =
  discard
proc jsGet*(self: CookieStore; name: cstring): JsObject =
  discard
proc jsGet*(self: CookieStore; options: JsObject): JsObject =
  discard
proc jsGetAll*(self: CookieStore; name: cstring): JsObject =
  discard
proc jsGetAll*(self: CookieStore; options: JsObject): JsObject =
  discard
proc jsSet*(self: CookieStore; name: cstring; value: cstring): JsObject =
  discard
proc jsSet*(self: CookieStore; options: JsObject): JsObject =
  discard
proc jsDelete*(self: CookieStore; name: cstring): JsObject =
  discard
proc jsDelete*(self: CookieStore; options: JsObject): JsObject =
  discard

proc jsSubscribe*(self: CookieStoreManager; subscriptions: JsObject): JsObject =
  discard
proc jsGetSubscriptions*(self: CookieStoreManager): JsObject =
  discard
proc jsUnsubscribe*(self: CookieStoreManager; subscriptions: JsObject): JsObject =
  discard

proc jsCookieChangeEventChanged*(self: CookieChangeEvent): JsObject =
  discard
proc jsCookieChangeEventDeleted*(self: CookieChangeEvent): JsObject =
  discard

proc jsExtendableCookieChangeEventChanged*(self: ExtendableCookieChangeEvent): JsObject =
  discard
proc jsExtendableCookieChangeEventDeleted*(self: ExtendableCookieChangeEvent): JsObject =
  discard

proc jsCoordinatesLatitude*(self: Coordinates): float64 =
  discard
proc jsCoordinatesLongitude*(self: Coordinates): float64 =
  discard
proc jsCoordinatesAccuracy*(self: Coordinates): float64 =
  discard

proc jsCreateOfferRequestWindowID*(self: CreateOfferRequest): uint64 =
  discard
proc jsCreateOfferRequestInnerWindowID*(self: CreateOfferRequest): uint64 =
  discard
proc jsCreateOfferRequestCallID*(self: CreateOfferRequest): cstring =
  discard
proc jsCreateOfferRequestIsSecure*(self: CreateOfferRequest): bool =
  discard

proc jsCredentialId*(self: Credential): cstring =
  discard
proc jsCredentialTypeVal*(self: Credential): cstring =
  discard

proc jsGet*(self: CredentialsContainer; options: JsObject): JsObject =
  discard
proc jsCreate*(self: CredentialsContainer; options: JsObject): JsObject =
  discard
proc jsStore*(self: CredentialsContainer; credential: JsObject): JsObject =
  discard
proc jsPreventSilentAccess*(self: CredentialsContainer): JsObject =
  discard

proc jsCryptoSubtle*(self: Crypto): JsObject =
  discard
proc jsGetRandomValues*(self: Crypto; array: JsObject): JsObject =
  discard
proc jsRandomUUID*(self: Crypto): cstring =
  discard

proc jsDefine*(self: CustomElementRegistry; name: cstring; functionConstructor: JsObject; options: JsObject): void =
  discard
proc jsSetElementCreationCallback*(self: CustomElementRegistry; name: cstring; callback: JsObject): void =
  discard
proc jsGet*(self: CustomElementRegistry; name: cstring): JsObject =
  discard
proc jsWhenDefined*(self: CustomElementRegistry; name: cstring): JsObject =
  discard
proc jsUpgrade*(self: CustomElementRegistry; root: JsObject): void =
  discard

proc jsCustomEventDetail*(self: CustomEvent): JsObject =
  discard
proc jsInitCustomEvent*(self: CustomEvent; typeVal: cstring; canBubble: bool; cancelable: bool; detail: JsObject): void =
  discard

proc jsDOMErrorName*(self: DOMError): cstring =
  discard
proc jsDOMErrorMessage*(self: DOMError): cstring =
  discard

proc jsExceptionName*(self: Exception): cstring =
  discard
proc jsExceptionMessage*(self: Exception): cstring =
  discard

proc jsDOMExceptionName*(self: DOMException): cstring =
  discard
proc jsDOMExceptionMessage*(self: DOMException): cstring =
  discard
proc jsDOMExceptionCode*(self: DOMException): uint16 =
  discard
const jsDOMExceptionINDEX_SIZE_ERR* : uint16 = 0
const jsDOMExceptionDOMSTRING_SIZE_ERR* : uint16 = 0
const jsDOMExceptionHIERARCHY_REQUEST_ERR* : uint16 = 0
const jsDOMExceptionWRONG_DOCUMENT_ERR* : uint16 = 0
const jsDOMExceptionINVALID_CHARACTER_ERR* : uint16 = 0
const jsDOMExceptionNO_DATA_ALLOWED_ERR* : uint16 = 0
const jsDOMExceptionNO_MODIFICATION_ALLOWED_ERR* : uint16 = 0
const jsDOMExceptionNOT_FOUND_ERR* : uint16 = 0
const jsDOMExceptionNOT_SUPPORTED_ERR* : uint16 = 0
const jsDOMExceptionINUSE_ATTRIBUTE_ERR* : uint16 = 0
const jsDOMExceptionINVALID_STATE_ERR* : uint16 = 0
const jsDOMExceptionSYNTAX_ERR* : uint16 = 0
const jsDOMExceptionINVALID_MODIFICATION_ERR* : uint16 = 0
const jsDOMExceptionNAMESPACE_ERR* : uint16 = 0
const jsDOMExceptionINVALID_ACCESS_ERR* : uint16 = 0
const jsDOMExceptionVALIDATION_ERR* : uint16 = 0
const jsDOMExceptionTYPE_MISMATCH_ERR* : uint16 = 0
const jsDOMExceptionSECURITY_ERR* : uint16 = 0
const jsDOMExceptionNETWORK_ERR* : uint16 = 0
const jsDOMExceptionABORT_ERR* : uint16 = 0
const jsDOMExceptionURL_MISMATCH_ERR* : uint16 = 0
const jsDOMExceptionQUOTA_EXCEEDED_ERR* : uint16 = 0
const jsDOMExceptionTIMEOUT_ERR* : uint16 = 0
const jsDOMExceptionINVALID_NODE_TYPE_ERR* : uint16 = 0
const jsDOMExceptionDATA_CLONE_ERR* : uint16 = 0

proc jsHasFeature*(self: DOMImplementation): bool =
  discard
proc jsCreateDocumentType*(self: DOMImplementation; qualifiedName: cstring; publicId: cstring; systemId: cstring): JsObject =
  discard
proc jsCreateDocument*(self: DOMImplementation; namespace: Option[cstring]; qualifiedName: cstring; doctype: Option[JsObject]): JsObject =
  discard
proc jsCreateHTMLDocument*(self: DOMImplementation; title: cstring): JsObject =
  discard

proc jsDOMMatrixReadOnlyA*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyB*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyC*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyD*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyE*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyF*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM11*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM12*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM13*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM14*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM21*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM22*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM23*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM24*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM31*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM32*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM33*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM34*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM41*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM42*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM43*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyM44*(self: DOMMatrixReadOnly): float64 =
  discard
proc jsDOMMatrixReadOnlyIs2D*(self: DOMMatrixReadOnly): bool =
  discard
proc jsDOMMatrixReadOnlyIsIdentity*(self: DOMMatrixReadOnly): bool =
  discard
proc jsTranslate*(self: DOMMatrixReadOnly; tx: float64; ty: float64; tz: float64): JsObject =
  discard
proc jsScale*(self: DOMMatrixReadOnly; scale: float64; originX: float64; originY: float64): JsObject =
  discard
proc jsScale3d*(self: DOMMatrixReadOnly; scale: float64; originX: float64; originY: float64; originZ: float64): JsObject =
  discard
proc jsScaleNonUniform*(self: DOMMatrixReadOnly; scaleX: float64; scaleY: float64; scaleZ: float64; originX: float64; originY: float64; originZ: float64): JsObject =
  discard
proc jsRotate*(self: DOMMatrixReadOnly; angle: float64; originX: float64; originY: float64): JsObject =
  discard
proc jsRotateFromVector*(self: DOMMatrixReadOnly; x: float64; y: float64): JsObject =
  discard
proc jsRotateAxisAngle*(self: DOMMatrixReadOnly; x: float64; y: float64; z: float64; angle: float64): JsObject =
  discard
proc jsSkewX*(self: DOMMatrixReadOnly; sx: float64): JsObject =
  discard
proc jsSkewY*(self: DOMMatrixReadOnly; sy: float64): JsObject =
  discard
proc jsMultiply*(self: DOMMatrixReadOnly; other: JsObject): JsObject =
  discard
proc jsFlipX*(self: DOMMatrixReadOnly): JsObject =
  discard
proc jsFlipY*(self: DOMMatrixReadOnly): JsObject =
  discard
proc jsInverse*(self: DOMMatrixReadOnly): JsObject =
  discard
proc jsTransformPoint*(self: DOMMatrixReadOnly; point: JsObject): JsObject =
  discard
proc jsToFloat32Array*(self: DOMMatrixReadOnly): seq[float32] =
  discard
proc jsToFloat64Array*(self: DOMMatrixReadOnly): seq[float64] =
  discard
proc jsToJSON*(self: DOMMatrixReadOnly): JsObject =
  discard

proc jsDOMMatrixUnrestricted*(self: DOMMatrix): JsObject =
  discard
proc jsDOMMatrixA*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixB*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixC*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixD*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixE*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixF*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM11*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM12*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM13*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM14*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM21*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM22*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM23*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM24*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM31*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM32*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM33*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM34*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM41*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM42*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM43*(self: DOMMatrix): float64 =
  discard
proc jsDOMMatrixM44*(self: DOMMatrix): float64 =
  discard
proc jsMultiplySelf*(self: DOMMatrix; other: JsObject): JsObject =
  discard
proc jsPreMultiplySelf*(self: DOMMatrix; other: JsObject): JsObject =
  discard
proc jsTranslateSelf*(self: DOMMatrix; tx: float64; ty: float64; tz: float64): JsObject =
  discard
proc jsScaleSelf*(self: DOMMatrix; scale: float64; originX: float64; originY: float64): JsObject =
  discard
proc jsScale3dSelf*(self: DOMMatrix; scale: float64; originX: float64; originY: float64; originZ: float64): JsObject =
  discard
proc jsScaleNonUniformSelf*(self: DOMMatrix; scaleX: float64; scaleY: float64; scaleZ: float64; originX: float64; originY: float64; originZ: float64): JsObject =
  discard
proc jsRotateSelf*(self: DOMMatrix; angle: float64; originX: float64; originY: float64): JsObject =
  discard
proc jsRotateFromVectorSelf*(self: DOMMatrix; x: float64; y: float64): JsObject =
  discard
proc jsRotateAxisAngleSelf*(self: DOMMatrix; x: float64; y: float64; z: float64; angle: float64): JsObject =
  discard
proc jsSkewXSelf*(self: DOMMatrix; sx: float64): JsObject =
  discard
proc jsSkewYSelf*(self: DOMMatrix; sy: float64): JsObject =
  discard
proc jsInvertSelf*(self: DOMMatrix): JsObject =
  discard
proc jsSetMatrixValue*(self: DOMMatrix; transformList: cstring): JsObject =
  discard

proc jsParseFromString*(self: DOMParser; str: cstring; typeVal: JsObject): JsObject =
  discard
proc jsForceEnableXULXBL*(self: DOMParser): void =
  discard

proc jsDOMPointReadOnlyX*(self: DOMPointReadOnly): float64 =
  discard
proc jsDOMPointReadOnlyY*(self: DOMPointReadOnly): float64 =
  discard
proc jsDOMPointReadOnlyZ*(self: DOMPointReadOnly): float64 =
  discard
proc jsDOMPointReadOnlyW*(self: DOMPointReadOnly): float64 =
  discard
proc jsFromPoint*(self: typedesc[DOMPointReadOnly]; other: JsObject): JsObject =
  discard
proc jsMatrixTransform*(self: DOMPointReadOnly; matrix: JsObject): JsObject =
  discard
proc jsToJSON*(self: DOMPointReadOnly): JsObject =
  discard

proc jsDOMPointUnrestricted*(self: DOMPoint): JsObject =
  discard
proc jsDOMPointX*(self: DOMPoint): float64 =
  discard
proc jsDOMPointY*(self: DOMPoint): float64 =
  discard
proc jsDOMPointZ*(self: DOMPoint): float64 =
  discard
proc jsDOMPointW*(self: DOMPoint): float64 =
  discard
proc jsFromPoint*(self: typedesc[DOMPoint]; other: JsObject): JsObject =
  discard

proc jsDOMQuadP1*(self: DOMQuad): JsObject =
  discard
proc jsDOMQuadP2*(self: DOMQuad): JsObject =
  discard
proc jsDOMQuadP3*(self: DOMQuad): JsObject =
  discard
proc jsDOMQuadP4*(self: DOMQuad): JsObject =
  discard
proc jsDOMQuadBounds*(self: DOMQuad): JsObject =
  discard
proc jsGetBounds*(self: DOMQuad): JsObject =
  discard
proc jsToJSON*(self: DOMQuad): JsObject =
  discard

proc jsDOMRectUnrestricted*(self: DOMRect): JsObject =
  discard
proc jsDOMRectX*(self: DOMRect): float64 =
  discard
proc jsDOMRectY*(self: DOMRect): float64 =
  discard
proc jsDOMRectWidth*(self: DOMRect): float64 =
  discard
proc jsDOMRectHeight*(self: DOMRect): float64 =
  discard

proc jsDOMRectReadOnlyX*(self: DOMRectReadOnly): float64 =
  discard
proc jsDOMRectReadOnlyY*(self: DOMRectReadOnly): float64 =
  discard
proc jsDOMRectReadOnlyWidth*(self: DOMRectReadOnly): float64 =
  discard
proc jsDOMRectReadOnlyHeight*(self: DOMRectReadOnly): float64 =
  discard
proc jsDOMRectReadOnlyTop*(self: DOMRectReadOnly): float64 =
  discard
proc jsDOMRectReadOnlyRight*(self: DOMRectReadOnly): float64 =
  discard
proc jsDOMRectReadOnlyBottom*(self: DOMRectReadOnly): float64 =
  discard
proc jsDOMRectReadOnlyLeft*(self: DOMRectReadOnly): float64 =
  discard
proc jsToJSON*(self: DOMRectReadOnly): JsObject =
  discard

proc jsDOMRectListLength*(self: DOMRectList): uint32 =
  discard
proc jsItem*(self: DOMRectList; index: uint32): Option[JsObject] =
  discard

proc jsThen*(self: DOMRequest; fulfillCallback: Option[JsObject]; rejectCallback: Option[JsObject]): JsObject =
  discard
proc jsFireDetailedError*(self: DOMRequest; aError: JsObject): void =
  discard

proc jsDOMStringListLength*(self: DOMStringList): uint32 =
  discard
proc jsItem*(self: DOMStringList; index: uint32): Option[cstring] =
  discard
proc jsContains*(self: DOMStringList; string: cstring): bool =
  discard


proc jsDOMTokenListLength*(self: DOMTokenList): uint32 =
  discard
proc jsDOMTokenListValue*(self: DOMTokenList): cstring =
  discard
proc jsItem*(self: DOMTokenList; index: uint32): Option[cstring] =
  discard
proc jsContains*(self: DOMTokenList; token: cstring): bool =
  discard
proc jsAdd*(self: DOMTokenList; tokens: cstring): void =
  discard
proc jsRemove*(self: DOMTokenList; tokens: cstring): void =
  discard
proc jsReplace*(self: DOMTokenList; token: cstring; newToken: cstring): bool =
  discard
proc jsToggle*(self: DOMTokenList; token: cstring; force: bool): bool =
  discard
proc jsSupports*(self: DOMTokenList; token: cstring): bool =
  discard

proc jsDataTransferDropEffect*(self: DataTransfer): cstring =
  discard
proc jsDataTransferEffectAllowed*(self: DataTransfer): cstring =
  discard
proc jsDataTransferItems*(self: DataTransfer): JsObject =
  discard
proc jsDataTransferTypes*(self: DataTransfer): JsObject =
  discard
proc jsSetDragImage*(self: DataTransfer; image: JsObject; x: int32; y: int32): void =
  discard
proc jsGetData*(self: DataTransfer; format: cstring): cstring =
  discard
proc jsSetData*(self: DataTransfer; format: cstring; data: cstring): void =
  discard
proc jsClearData*(self: DataTransfer; format: cstring): void =
  discard

proc jsDataTransferItemKind*(self: DataTransferItem): cstring =
  discard
proc jsDataTransferItemTypeVal*(self: DataTransferItem): cstring =
  discard
proc jsGetAsString*(self: DataTransferItem; callback: Option[JsObject]): void =
  discard
proc jsGetAsFile*(self: DataTransferItem): Option[JsObject] =
  discard

proc jsDataTransferItemListLength*(self: DataTransferItemList): uint32 =
  discard
proc jsAdd*(self: DataTransferItemList; data: cstring; typeVal: cstring): Option[JsObject] =
  discard
proc jsAdd*(self: DataTransferItemList; data: JsObject): Option[JsObject] =
  discard
proc jsRemove*(self: DataTransferItemList; index: uint32): void =
  discard
proc jsClear*(self: DataTransferItemList): void =
  discard

proc jsDedicatedWorkerGlobalScopeName*(self: DedicatedWorkerGlobalScope): cstring =
  discard
proc jsDedicatedWorkerGlobalScopeOnmessage*(self: DedicatedWorkerGlobalScope): JsObject =
  discard
proc jsDedicatedWorkerGlobalScopeOnmessageerror*(self: DedicatedWorkerGlobalScope): JsObject =
  discard
proc jsPostMessage*(self: DedicatedWorkerGlobalScope; message: JsObject; transfer: JsObject): void =
  discard
proc jsClose*(self: DedicatedWorkerGlobalScope): void =
  discard

proc jsDelayNodeDelayTime*(self: DelayNode): JsObject =
  discard

proc jsDeviceLightEventValue*(self: DeviceLightEvent): float64 =
  discard




proc jsDeviceOrientationEventAbsolute*(self: DeviceOrientationEvent): bool =
  discard
proc jsInitDeviceOrientationEvent*(self: DeviceOrientationEvent; typeVal: cstring; canBubble: bool; cancelable: bool; alpha: Option[float64]; beta: Option[float64]; gamma: Option[float64]; absolute: bool): void =
  discard

proc jsDeviceProximityEventValue*(self: DeviceProximityEvent): float64 =
  discard
proc jsDeviceProximityEventMin*(self: DeviceProximityEvent): float64 =
  discard
proc jsDeviceProximityEventMax*(self: DeviceProximityEvent): float64 =
  discard

proc jsDirectoryName*(self: Directory): cstring =
  discard

proc jsDocumentImplementation*(self: Document): JsObject =
  discard
proc jsDocumentURL*(self: Document): cstring =
  discard
proc jsDocumentDocumentURI*(self: Document): cstring =
  discard
proc jsDocumentCompatMode*(self: Document): cstring =
  discard
proc jsDocumentCharacterSet*(self: Document): cstring =
  discard
proc jsDocumentCharset*(self: Document): cstring =
  discard
proc jsDocumentInputEncoding*(self: Document): cstring =
  discard
proc jsDocumentContentType*(self: Document): cstring =
  discard
proc jsGetElementsByTagName*(self: Document; localName: cstring): JsObject =
  discard
proc jsGetElementsByTagNameNS*(self: Document; namespace: Option[cstring]; localName: cstring): JsObject =
  discard
proc jsGetElementsByClassName*(self: Document; classNames: cstring): JsObject =
  discard
proc jsGetElementById*(self: Document; elementId: cstring): Option[JsObject] =
  discard
proc jsCreateElement*(self: Document; localName: cstring; options: JsObject): JsObject =
  discard
proc jsCreateElementNS*(self: Document; namespace: Option[cstring]; qualifiedName: cstring; options: JsObject): JsObject =
  discard
proc jsCreateDocumentFragment*(self: Document): JsObject =
  discard
proc jsCreateTextNode*(self: Document; data: cstring): JsObject =
  discard
proc jsCreateComment*(self: Document; data: cstring): JsObject =
  discard
proc jsCreateProcessingInstruction*(self: Document; target: cstring; data: cstring): JsObject =
  discard
proc jsImportNode*(self: Document; node: JsObject; deep: bool): JsObject =
  discard
proc jsAdoptNode*(self: Document; node: JsObject): JsObject =
  discard
proc jsCreateEvent*(self: Document; interfaceVal: cstring): JsObject =
  discard
proc jsCreateRange*(self: Document): JsObject =
  discard
proc jsCreateNodeIterator*(self: Document; root: JsObject; whatToShow: uint32; filter: Option[JsObject]): JsObject =
  discard
proc jsCreateTreeWalker*(self: Document; root: JsObject; whatToShow: uint32; filter: Option[JsObject]): JsObject =
  discard
proc jsCreateCDATASection*(self: Document; data: cstring): JsObject =
  discard
proc jsCreateAttribute*(self: Document; name: cstring): JsObject =
  discard
proc jsCreateAttributeNS*(self: Document; namespace: Option[cstring]; name: cstring): JsObject =
  discard

proc jsGetElementById*(self: DocumentFragment; elementId: cstring): Option[JsObject] =
  discard


proc jsDocumentTypeName*(self: DocumentType): cstring =
  discard
proc jsDocumentTypePublicId*(self: DocumentType): cstring =
  discard
proc jsDocumentTypeSystemId*(self: DocumentType): cstring =
  discard

proc jsInitDragEvent*(self: DragEvent; typeVal: cstring; canBubble: bool; cancelable: bool; aView: Option[JsObject]; aDetail: int32; aScreenX: int32; aScreenY: int32; aClientX: int32; aClientY: int32; aCtrlKey: bool; aAltKey: bool; aShiftKey: bool; aMetaKey: bool; aButton: uint16; aRelatedTarget: Option[JsObject]; aDataTransfer: Option[JsObject]): void =
  discard

proc jsDynamicsCompressorNodeThreshold*(self: DynamicsCompressorNode): JsObject =
  discard
proc jsDynamicsCompressorNodeKnee*(self: DynamicsCompressorNode): JsObject =
  discard
proc jsDynamicsCompressorNodeRatio*(self: DynamicsCompressorNode): JsObject =
  discard
proc jsDynamicsCompressorNodeReduction*(self: DynamicsCompressorNode): float32 =
  discard
proc jsDynamicsCompressorNodeAttack*(self: DynamicsCompressorNode): JsObject =
  discard
proc jsDynamicsCompressorNodeRelease*(self: DynamicsCompressorNode): JsObject =
  discard

proc jsElementLocalName*(self: Element): cstring =
  discard
proc jsElementTagName*(self: Element): cstring =
  discard
proc jsElementId*(self: Element): cstring =
  discard
proc jsElementClassName*(self: Element): cstring =
  discard
proc jsElementClassList*(self: Element): JsObject =
  discard
proc jsElementAttributes*(self: Element): JsObject =
  discard
proc jsElementFontSizeInflation*(self: Element): float32 =
  discard
proc jsGetAttributeNames*(self: Element): JsObject =
  discard
proc jsGetAttribute*(self: Element; name: cstring): Option[cstring] =
  discard
proc jsGetAttributeNS*(self: Element; namespace: Option[cstring]; localName: cstring): Option[cstring] =
  discard
proc jsToggleAttribute*(self: Element; name: cstring; force: bool): bool =
  discard
proc jsSetAttribute*(self: Element; name: cstring; value: cstring): void =
  discard
proc jsSetAttributeNS*(self: Element; namespace: Option[cstring]; name: cstring; value: cstring): void =
  discard
proc jsRemoveAttribute*(self: Element; name: cstring): void =
  discard
proc jsRemoveAttributeNS*(self: Element; namespace: Option[cstring]; localName: cstring): void =
  discard
proc jsHasAttribute*(self: Element; name: cstring): bool =
  discard
proc jsHasAttributeNS*(self: Element; namespace: Option[cstring]; localName: cstring): bool =
  discard
proc jsHasAttributes*(self: Element): bool =
  discard
proc jsClosest*(self: Element; selector: cstring): Option[JsObject] =
  discard
proc jsMatches*(self: Element; selector: cstring): bool =
  discard
proc jsWebkitMatchesSelector*(self: Element; selector: cstring): bool =
  discard
proc jsGetElementsByTagName*(self: Element; localName: cstring): JsObject =
  discard
proc jsGetElementsByTagNameNS*(self: Element; namespace: Option[cstring]; localName: cstring): JsObject =
  discard
proc jsGetElementsByClassName*(self: Element; classNames: cstring): JsObject =
  discard
proc jsGetElementsWithGrid*(self: Element): JsObject =
  discard
proc jsInsertAdjacentElement*(self: Element; where: cstring; element: JsObject): Option[JsObject] =
  discard
proc jsInsertAdjacentText*(self: Element; where: cstring; data: cstring): void =
  discard
proc jsSetPointerCapture*(self: Element; pointerId: int32): void =
  discard
proc jsReleasePointerCapture*(self: Element; pointerId: int32): void =
  discard
proc jsHasPointerCapture*(self: Element; pointerId: int32): bool =
  discard
proc jsSetCapture*(self: Element; retargetToElement: bool): void =
  discard
proc jsReleaseCapture*(self: Element): void =
  discard
proc jsSetCaptureAlways*(self: Element; retargetToElement: bool): void =
  discard
proc jsGetAttributeNode*(self: Element; name: cstring): Option[JsObject] =
  discard
proc jsSetAttributeNode*(self: Element; newAttr: JsObject): Option[JsObject] =
  discard
proc jsRemoveAttributeNode*(self: Element; oldAttr: JsObject): Option[JsObject] =
  discard
proc jsGetAttributeNodeNS*(self: Element; namespaceURI: Option[cstring]; localName: cstring): Option[JsObject] =
  discard
proc jsSetAttributeNodeNS*(self: Element; newAttr: JsObject): Option[JsObject] =
  discard
proc jsScrollByNoFlush*(self: Element; dx: int32; dy: int32): bool =
  discard
proc jsGetAsFlexContainer*(self: Element): Option[JsObject] =
  discard
proc jsGetGridFragments*(self: Element): JsObject =
  discard
proc jsGetTransformToAncestor*(self: Element; ancestor: JsObject): JsObject =
  discard
proc jsGetTransformToParent*(self: Element): JsObject =
  discard
proc jsGetTransformToViewport*(self: Element): JsObject =
  discard

proc jsErrorEventMessage*(self: ErrorEvent): cstring =
  discard
proc jsErrorEventFilename*(self: ErrorEvent): cstring =
  discard
proc jsErrorEventLineno*(self: ErrorEvent): uint32 =
  discard
proc jsErrorEventColno*(self: ErrorEvent): uint32 =
  discard
proc jsErrorEventError*(self: ErrorEvent): JsObject =
  discard

proc jsEventTypeVal*(self: Event): cstring =
  discard
const jsEventNONE* : uint16 = 0
const jsEventCAPTURING_PHASE* : uint16 = 0
const jsEventAT_TARGET* : uint16 = 0
const jsEventBUBBLING_PHASE* : uint16 = 0
proc jsEventEventPhase*(self: Event): uint16 =
  discard
proc jsEventBubbles*(self: Event): bool =
  discard
proc jsEventCancelable*(self: Event): bool =
  discard
proc jsEventDefaultPrevented*(self: Event): bool =
  discard
proc jsEventDefaultPreventedByChrome*(self: Event): bool =
  discard
proc jsEventDefaultPreventedByContent*(self: Event): bool =
  discard
proc jsEventComposed*(self: Event): bool =
  discard
proc jsEventIsTrusted*(self: Event): bool =
  discard
proc jsEventTimeStamp*(self: Event): JsObject =
  discard
proc jsEventCancelBubble*(self: Event): bool =
  discard
proc jsComposedPath*(self: Event): JsObject =
  discard
proc jsStopPropagation*(self: Event): void =
  discard
proc jsStopImmediatePropagation*(self: Event): void =
  discard
proc jsPreventDefault*(self: Event): void =
  discard
proc jsInitEvent*(self: Event; typeVal: cstring; bubbles: bool; cancelable: bool): void =
  discard

proc jsEventSourceUrl*(self: EventSource): cstring =
  discard
proc jsEventSourceWithCredentials*(self: EventSource): bool =
  discard
const jsEventSourceCONNECTING* : uint16 = 0
const jsEventSourceOPEN* : uint16 = 0
const jsEventSourceCLOSED* : uint16 = 0
proc jsEventSourceReadyState*(self: EventSource): uint16 =
  discard
proc jsEventSourceOnopen*(self: EventSource): JsObject =
  discard
proc jsEventSourceOnmessage*(self: EventSource): JsObject =
  discard
proc jsEventSourceOnerror*(self: EventSource): JsObject =
  discard
proc jsClose*(self: EventSource): void =
  discard

proc jsAddEventListener*(self: EventTarget; typeVal: cstring; listener: JsObject; options: JsObject; wantsUntrusted: Option[bool]): void =
  discard
proc jsRemoveEventListener*(self: EventTarget; typeVal: cstring; listener: JsObject; options: JsObject): void =
  discard
proc jsDispatchEvent*(self: EventTarget; event: JsObject): bool =
  discard

proc jsWaitUntil*(self: ExtendableEvent; p: JsObject): void =
  discard

proc jsExtendableMessageEventData*(self: ExtendableMessageEvent): JsObject =
  discard
proc jsExtendableMessageEventOrigin*(self: ExtendableMessageEvent): cstring =
  discard
proc jsExtendableMessageEventLastEventId*(self: ExtendableMessageEvent): cstring =
  discard
proc jsExtendableMessageEventPorts*(self: ExtendableMessageEvent): JsObject =
  discard

proc jsAddSearchProvider*(self: External; aDescriptionURL: cstring): void =
  discard
proc jsIsSearchProviderInstalled*(self: External; aSearchURL: cstring): uint32 =
  discard

proc jsFetchEventRequest*(self: FetchEvent): JsObject =
  discard
proc jsFetchEventIsReload*(self: FetchEvent): bool =
  discard
proc jsRespondWith*(self: FetchEvent; r: JsObject): void =
  discard

proc jsFetchObserverState*(self: FetchObserver): JsObject =
  discard
proc jsFetchObserverOnstatechange*(self: FetchObserver): JsObject =
  discard
proc jsFetchObserverOnrequestprogress*(self: FetchObserver): JsObject =
  discard
proc jsFetchObserverOnresponseprogress*(self: FetchObserver): JsObject =
  discard

proc jsFileName*(self: File): cstring =
  discard
proc jsFileLastModified*(self: File): int64 =
  discard

proc jsFileListLength*(self: FileList): uint32 =
  discard
proc jsItem*(self: FileList; index: uint32): Option[JsObject] =
  discard

const jsFileReaderEMPTY* : uint16 = 0
const jsFileReaderLOADING* : uint16 = 0
const jsFileReaderDONE* : uint16 = 0
proc jsFileReaderReadyState*(self: FileReader): uint16 =
  discard
proc jsFileReaderResultVal*(self: FileReader): JsObject =
  discard
proc jsFileReaderOnloadstart*(self: FileReader): JsObject =
  discard
proc jsFileReaderOnprogress*(self: FileReader): JsObject =
  discard
proc jsFileReaderOnload*(self: FileReader): JsObject =
  discard
proc jsFileReaderOnabort*(self: FileReader): JsObject =
  discard
proc jsFileReaderOnerror*(self: FileReader): JsObject =
  discard
proc jsFileReaderOnloadend*(self: FileReader): JsObject =
  discard
proc jsReadAsArrayBuffer*(self: FileReader; blob: JsObject): void =
  discard
proc jsReadAsBinaryString*(self: FileReader; filedata: JsObject): void =
  discard
proc jsReadAsText*(self: FileReader; blob: JsObject; label: cstring): void =
  discard
proc jsReadAsDataURL*(self: FileReader; blob: JsObject): void =
  discard
proc jsAbort*(self: FileReader): void =
  discard

proc jsReadAsArrayBuffer*(self: FileReaderSync; blob: JsObject): JsObject =
  discard
proc jsReadAsBinaryString*(self: FileReaderSync; blob: JsObject): cstring =
  discard
proc jsReadAsText*(self: FileReaderSync; blob: JsObject; encoding: cstring): cstring =
  discard
proc jsReadAsDataURL*(self: FileReaderSync; blob: JsObject): cstring =
  discard

proc jsFileSystemName*(self: FileSystem): cstring =
  discard
proc jsFileSystemRoot*(self: FileSystem): JsObject =
  discard

proc jsCreateReader*(self: FileSystemDirectoryEntry): JsObject =
  discard
proc jsGetFile*(self: FileSystemDirectoryEntry; path: Option[cstring]; options: JsObject; successCallback: JsObject; errorCallback: JsObject): void =
  discard
proc jsGetDirectory*(self: FileSystemDirectoryEntry; path: Option[cstring]; options: JsObject; successCallback: JsObject; errorCallback: JsObject): void =
  discard

proc jsReadEntries*(self: FileSystemDirectoryReader; successCallback: JsObject; errorCallback: JsObject): void =
  discard

proc jsFileSystemEntryIsFile*(self: FileSystemEntry): bool =
  discard
proc jsFileSystemEntryIsDirectory*(self: FileSystemEntry): bool =
  discard
proc jsFileSystemEntryName*(self: FileSystemEntry): cstring =
  discard
proc jsFileSystemEntryFullPath*(self: FileSystemEntry): cstring =
  discard
proc jsFileSystemEntryFilesystem*(self: FileSystemEntry): JsObject =
  discard
proc jsGetParent*(self: FileSystemEntry; successCallback: JsObject; errorCallback: JsObject): void =
  discard

proc jsFile*(self: FileSystemFileEntry; successCallback: JsObject; errorCallback: JsObject): void =
  discard

proc jsFileSystemHandleKind*(self: FileSystemHandle): JsObject =
  discard
proc jsFileSystemHandleName*(self: FileSystemHandle): cstring =
  discard
proc jsIsSameEntry*(self: FileSystemHandle; other: JsObject): JsObject =
  discard

proc jsGetFile*(self: FileSystemFileHandle): JsObject =
  discard
proc jsCreateWritable*(self: FileSystemFileHandle; options: JsObject): JsObject =
  discard
proc jsCreateSyncAccessHandle*(self: FileSystemFileHandle): JsObject =
  discard

proc jsFileSystemDirectoryHandleIterable*(self: FileSystemDirectoryHandle): JsObject =
  discard
proc jsFileSystemDirectoryHandleUSVString*(self: FileSystemDirectoryHandle): JsObject =
  discard
proc jsFileSystemDirectoryHandleFileSystemHandle*(self: FileSystemDirectoryHandle): JsObject =
  discard
proc jsGetFileHandle*(self: FileSystemDirectoryHandle; name: cstring; options: JsObject): JsObject =
  discard
proc jsGetDirectoryHandle*(self: FileSystemDirectoryHandle; name: cstring; options: JsObject): JsObject =
  discard
proc jsRemoveEntry*(self: FileSystemDirectoryHandle; name: cstring; options: JsObject): JsObject =
  discard
proc jsResolve*(self: FileSystemDirectoryHandle; possibleDescendant: JsObject): JsObject =
  discard

proc jsWrite*(self: FileSystemWritableFileStream; data: JsObject): JsObject =
  discard
proc jsSeek*(self: FileSystemWritableFileStream; position: uint64): JsObject =
  discard
proc jsTruncate*(self: FileSystemWritableFileStream; size: uint64): JsObject =
  discard

proc jsRead*(self: FileSystemSyncAccessHandle; buffer: JsObject; options: JsObject): uint64 =
  discard
proc jsWrite*(self: FileSystemSyncAccessHandle; buffer: JsObject; options: JsObject): uint64 =
  discard
proc jsTruncate*(self: FileSystemSyncAccessHandle; newSize: uint64): void =
  discard
proc jsGetSize*(self: FileSystemSyncAccessHandle): uint64 =
  discard
proc jsFlush*(self: FileSystemSyncAccessHandle): void =
  discard
proc jsClose*(self: FileSystemSyncAccessHandle): void =
  discard


proc jsFontFaceFamily*(self: FontFace): cstring =
  discard
proc jsFontFaceStyle*(self: FontFace): cstring =
  discard
proc jsFontFaceWeight*(self: FontFace): cstring =
  discard
proc jsFontFaceStretch*(self: FontFace): cstring =
  discard
proc jsFontFaceUnicodeRange*(self: FontFace): cstring =
  discard
proc jsFontFaceVariant*(self: FontFace): cstring =
  discard
proc jsFontFaceFeatureSettings*(self: FontFace): cstring =
  discard
proc jsFontFaceVariationSettings*(self: FontFace): cstring =
  discard
proc jsFontFaceDisplay*(self: FontFace): cstring =
  discard
proc jsFontFaceStatus*(self: FontFace): JsObject =
  discard
proc jsFontFaceLoaded*(self: FontFace): JsObject =
  discard
proc jsLoad*(self: FontFace): JsObject =
  discard

proc jsNext*(self: FontFaceSetIterator): JsObject =
  discard

proc jsFontFaceSetSize*(self: FontFaceSet): uint32 =
  discard
proc jsFontFaceSetOnloading*(self: FontFaceSet): JsObject =
  discard
proc jsFontFaceSetOnloadingdone*(self: FontFaceSet): JsObject =
  discard
proc jsFontFaceSetOnloadingerror*(self: FontFaceSet): JsObject =
  discard
proc jsFontFaceSetReady*(self: FontFaceSet): JsObject =
  discard
proc jsFontFaceSetStatus*(self: FontFaceSet): JsObject =
  discard
proc jsAdd*(self: FontFaceSet; font: JsObject): void =
  discard
proc jsHas*(self: FontFaceSet; font: JsObject): bool =
  discard
proc jsDelete*(self: FontFaceSet; font: JsObject): bool =
  discard
proc jsClear*(self: FontFaceSet): void =
  discard
proc jsEntries*(self: FontFaceSet): JsObject =
  discard
proc jsValues*(self: FontFaceSet): JsObject =
  discard
proc jsForEach*(self: FontFaceSet; cb: JsObject; thisArg: JsObject): void =
  discard
proc jsLoad*(self: FontFaceSet; font: cstring; text: cstring): JsObject =
  discard
proc jsCheck*(self: FontFaceSet; font: cstring; text: cstring): bool =
  discard

proc jsFontFaceSetLoadEventFontfaces*(self: FontFaceSetLoadEvent): JsObject =
  discard

proc jsAppend*(self: FormData; name: cstring; value: JsObject; filename: cstring): void =
  discard
proc jsAppend*(self: FormData; name: cstring; value: cstring): void =
  discard
proc jsDelete*(self: FormData; name: cstring): void =
  discard
proc jsGet*(self: FormData; name: cstring): Option[JsObject] =
  discard
proc jsGetAll*(self: FormData; name: cstring): JsObject =
  discard
proc jsHas*(self: FormData; name: cstring): bool =
  discard
proc jsSet*(self: FormData; name: cstring; value: JsObject; filename: cstring): void =
  discard
proc jsSet*(self: FormData; name: cstring; value: cstring): void =
  discard

proc jsGarbageCollect*(self: typedesc[FuzzingFunctions]): void =
  discard
proc jsCycleCollect*(self: typedesc[FuzzingFunctions]): void =
  discard
proc jsEnableAccessibility*(self: typedesc[FuzzingFunctions]): void =
  discard

proc jsGainNodeGain*(self: GainNode): JsObject =
  discard

proc jsGamepadId*(self: Gamepad): cstring =
  discard
proc jsGamepadIndex*(self: Gamepad): uint32 =
  discard
proc jsGamepadConnected*(self: Gamepad): bool =
  discard
proc jsGamepadTimestamp*(self: Gamepad): JsObject =
  discard
proc jsGamepadMapping*(self: Gamepad): JsObject =
  discard
proc jsGamepadAxes*(self: Gamepad): JsObject =
  discard
proc jsGamepadButtons*(self: Gamepad): JsObject =
  discard
proc jsGamepadDisplayId*(self: Gamepad): uint32 =
  discard

proc jsGamepadButtonPressed*(self: GamepadButton): bool =
  discard
proc jsGamepadButtonTouched*(self: GamepadButton): bool =
  discard
proc jsGamepadButtonValue*(self: GamepadButton): float64 =
  discard

proc jsGamepadHapticActuatorTypeVal*(self: GamepadHapticActuator): JsObject =
  discard


proc jsGamepadPoseHasOrientation*(self: GamepadPose): bool =
  discard
proc jsGamepadPoseHasPosition*(self: GamepadPose): bool =
  discard

proc jsGetCurrentPosition*(self: Geolocation; successCallback: JsObject; errorCallback: Option[JsObject]; options: JsObject): void =
  discard
proc jsWatchPosition*(self: Geolocation; successCallback: JsObject; errorCallback: Option[JsObject]; options: JsObject): int32 =
  discard
proc jsClearWatch*(self: Geolocation; watchId: int32): void =
  discard

proc jsGetUserMediaRequestWindowID*(self: GetUserMediaRequest): uint64 =
  discard
proc jsGetUserMediaRequestInnerWindowID*(self: GetUserMediaRequest): uint64 =
  discard
proc jsGetUserMediaRequestCallID*(self: GetUserMediaRequest): cstring =
  discard
proc jsGetUserMediaRequestRawID*(self: GetUserMediaRequest): cstring =
  discard
proc jsGetUserMediaRequestMediaSource*(self: GetUserMediaRequest): cstring =
  discard
proc jsGetUserMediaRequestIsSecure*(self: GetUserMediaRequest): bool =
  discard
proc jsGetUserMediaRequestIsHandlingUserInput*(self: GetUserMediaRequest): bool =
  discard
proc jsGetConstraints*(self: GetUserMediaRequest): JsObject =
  discard


proc jsHTMLAllCollectionLength*(self: HTMLAllCollection): uint32 =
  discard
proc jsHTMLAllCollectionName*(self: HTMLAllCollection): JsObject =
  discard
proc jsItem*(self: HTMLAllCollection; index: uint32): Option[JsObject] =
  discard
proc jsItem*(self: HTMLAllCollection; name: cstring): Option[JsObject] =
  discard
proc jsNamedItem*(self: HTMLAllCollection; name: cstring): Option[JsObject] =
  discard

proc jsHTMLAnchorElementTarget*(self: HTMLAnchorElement): cstring =
  discard
proc jsHTMLAnchorElementDownload*(self: HTMLAnchorElement): cstring =
  discard
proc jsHTMLAnchorElementPing*(self: HTMLAnchorElement): cstring =
  discard
proc jsHTMLAnchorElementRel*(self: HTMLAnchorElement): cstring =
  discard
proc jsHTMLAnchorElementReferrerPolicy*(self: HTMLAnchorElement): cstring =
  discard
proc jsHTMLAnchorElementRelList*(self: HTMLAnchorElement): JsObject =
  discard
proc jsHTMLAnchorElementHreflang*(self: HTMLAnchorElement): cstring =
  discard
proc jsHTMLAnchorElementTypeVal*(self: HTMLAnchorElement): cstring =
  discard
proc jsHTMLAnchorElementText*(self: HTMLAnchorElement): cstring =
  discard

proc jsHTMLAreaElementAlt*(self: HTMLAreaElement): cstring =
  discard
proc jsHTMLAreaElementCoords*(self: HTMLAreaElement): cstring =
  discard
proc jsHTMLAreaElementShape*(self: HTMLAreaElement): cstring =
  discard
proc jsHTMLAreaElementTarget*(self: HTMLAreaElement): cstring =
  discard
proc jsHTMLAreaElementDownload*(self: HTMLAreaElement): cstring =
  discard
proc jsHTMLAreaElementPing*(self: HTMLAreaElement): cstring =
  discard
proc jsHTMLAreaElementRel*(self: HTMLAreaElement): cstring =
  discard
proc jsHTMLAreaElementReferrerPolicy*(self: HTMLAreaElement): cstring =
  discard
proc jsHTMLAreaElementRelList*(self: HTMLAreaElement): JsObject =
  discard



proc jsHTMLBaseElementHref*(self: HTMLBaseElement): cstring =
  discard
proc jsHTMLBaseElementTarget*(self: HTMLBaseElement): cstring =
  discard


proc jsHTMLButtonElementAutofocus*(self: HTMLButtonElement): bool =
  discard
proc jsHTMLButtonElementDisabled*(self: HTMLButtonElement): bool =
  discard
proc jsHTMLButtonElementFormAction*(self: HTMLButtonElement): cstring =
  discard
proc jsHTMLButtonElementFormEnctype*(self: HTMLButtonElement): cstring =
  discard
proc jsHTMLButtonElementFormMethod*(self: HTMLButtonElement): cstring =
  discard
proc jsHTMLButtonElementFormNoValidate*(self: HTMLButtonElement): bool =
  discard
proc jsHTMLButtonElementFormTarget*(self: HTMLButtonElement): cstring =
  discard
proc jsHTMLButtonElementName*(self: HTMLButtonElement): cstring =
  discard
proc jsHTMLButtonElementTypeVal*(self: HTMLButtonElement): cstring =
  discard
proc jsHTMLButtonElementValue*(self: HTMLButtonElement): cstring =
  discard
proc jsHTMLButtonElementWillValidate*(self: HTMLButtonElement): bool =
  discard
proc jsHTMLButtonElementValidity*(self: HTMLButtonElement): JsObject =
  discard
proc jsHTMLButtonElementValidationMessage*(self: HTMLButtonElement): cstring =
  discard
proc jsHTMLButtonElementLabels*(self: HTMLButtonElement): JsObject =
  discard
proc jsCheckValidity*(self: HTMLButtonElement): bool =
  discard
proc jsReportValidity*(self: HTMLButtonElement): bool =
  discard
proc jsSetCustomValidity*(self: HTMLButtonElement; error: cstring): void =
  discard

proc jsHTMLCanvasElementWidth*(self: HTMLCanvasElement): uint32 =
  discard
proc jsHTMLCanvasElementHeight*(self: HTMLCanvasElement): uint32 =
  discard
proc jsGetContext*(self: HTMLCanvasElement; contextId: cstring; contextOptions: JsObject): Option[JsObject] =
  discard
proc jsToDataURL*(self: HTMLCanvasElement; typeVal: cstring; encoderOptions: JsObject): cstring =
  discard
proc jsToBlob*(self: HTMLCanvasElement; callback: JsObject; typeVal: cstring; encoderOptions: JsObject): void =
  discard

proc jsHTMLCollectionLength*(self: HTMLCollection): uint32 =
  discard
proc jsItem*(self: HTMLCollection; index: uint32): Option[JsObject] =
  discard
proc jsNamedItem*(self: HTMLCollection; name: cstring): Option[JsObject] =
  discard


proc jsHTMLDataElementValue*(self: HTMLDataElement): cstring =
  discard

proc jsHTMLDataListElementOptions*(self: HTMLDataListElement): JsObject =
  discard

proc jsHTMLDetailsElementOpen*(self: HTMLDetailsElement): bool =
  discard

proc jsHTMLDialogElementOpen*(self: HTMLDialogElement): bool =
  discard
proc jsHTMLDialogElementReturnValue*(self: HTMLDialogElement): cstring =
  discard
proc jsShow*(self: HTMLDialogElement): void =
  discard
proc jsShowModal*(self: HTMLDialogElement): void =
  discard
proc jsClose*(self: HTMLDialogElement; returnValue: cstring): void =
  discard

proc jsHTMLDirectoryElementCompact*(self: HTMLDirectoryElement): bool =
  discard


proc jsHTMLDocumentDomain*(self: HTMLDocument): cstring =
  discard
proc jsHTMLDocumentCookie*(self: HTMLDocument): cstring =
  discard
proc jsHTMLDocumentDesignMode*(self: HTMLDocument): cstring =
  discard
proc jsHTMLDocumentFgColor*(self: HTMLDocument): cstring =
  discard
proc jsHTMLDocumentLinkColor*(self: HTMLDocument): cstring =
  discard
proc jsHTMLDocumentVlinkColor*(self: HTMLDocument): cstring =
  discard
proc jsHTMLDocumentAlinkColor*(self: HTMLDocument): cstring =
  discard
proc jsHTMLDocumentBgColor*(self: HTMLDocument): cstring =
  discard
proc jsHTMLDocumentAll*(self: HTMLDocument): JsObject =
  discard
proc jsOpen*(self: HTMLDocument; typeVal: cstring; replace: cstring): JsObject =
  discard
proc jsOpen*(self: HTMLDocument; url: cstring; name: cstring; features: cstring; replace: bool): Option[JsObject] =
  discard
proc jsClose*(self: HTMLDocument): void =
  discard
proc jsWrite*(self: HTMLDocument; text: cstring): void =
  discard
proc jsWriteln*(self: HTMLDocument; text: cstring): void =
  discard
proc jsExecCommand*(self: HTMLDocument; commandId: cstring; showUI: bool; value: cstring): bool =
  discard
proc jsQueryCommandEnabled*(self: HTMLDocument; commandId: cstring): bool =
  discard
proc jsQueryCommandIndeterm*(self: HTMLDocument; commandId: cstring): bool =
  discard
proc jsQueryCommandState*(self: HTMLDocument; commandId: cstring): bool =
  discard
proc jsQueryCommandSupported*(self: HTMLDocument; commandId: cstring): bool =
  discard
proc jsQueryCommandValue*(self: HTMLDocument; commandId: cstring): cstring =
  discard
proc jsClear*(self: HTMLDocument): void =
  discard
proc jsCaptureEvents*(self: HTMLDocument): void =
  discard
proc jsReleaseEvents*(self: HTMLDocument): void =
  discard

proc jsHTMLElementTitle*(self: HTMLElement): cstring =
  discard
proc jsHTMLElementScrollHeight*(self: HTMLElement): int32 =
  discard
proc jsHTMLElementScrollTop*(self: HTMLElement): int32 =
  discard
proc jsHTMLElementLang*(self: HTMLElement): cstring =
  discard
proc jsHTMLElementDir*(self: HTMLElement): cstring =
  discard
proc jsHTMLElementInnerText*(self: HTMLElement): cstring =
  discard
proc jsHTMLElementHidden*(self: HTMLElement): bool =
  discard
proc jsHTMLElementInert*(self: HTMLElement): bool =
  discard
proc jsHTMLElementAccessKey*(self: HTMLElement): cstring =
  discard
proc jsHTMLElementAccessKeyLabel*(self: HTMLElement): cstring =
  discard
proc jsHTMLElementDraggable*(self: HTMLElement): bool =
  discard
proc jsHTMLElementContentEditable*(self: HTMLElement): cstring =
  discard
proc jsHTMLElementIsContentEditable*(self: HTMLElement): bool =
  discard
proc jsHTMLElementSpellcheck*(self: HTMLElement): bool =
  discard
proc jsClick*(self: HTMLElement): void =
  discard
proc jsFocus*(self: HTMLElement; options: JsObject): void =
  discard
proc jsBlur*(self: HTMLElement): void =
  discard
proc jsShowPopover*(self: HTMLElement; options: JsObject): void =
  discard
proc jsHidePopover*(self: HTMLElement): void =
  discard
proc jsTogglePopover*(self: HTMLElement; force: bool): bool =
  discard


proc jsHTMLEmbedElementSrc*(self: HTMLEmbedElement): cstring =
  discard
proc jsHTMLEmbedElementTypeVal*(self: HTMLEmbedElement): cstring =
  discard
proc jsHTMLEmbedElementWidth*(self: HTMLEmbedElement): cstring =
  discard
proc jsHTMLEmbedElementHeight*(self: HTMLEmbedElement): cstring =
  discard

proc jsHTMLFieldSetElementDisabled*(self: HTMLFieldSetElement): bool =
  discard
proc jsHTMLFieldSetElementName*(self: HTMLFieldSetElement): cstring =
  discard
proc jsHTMLFieldSetElementTypeVal*(self: HTMLFieldSetElement): cstring =
  discard
proc jsHTMLFieldSetElementElements*(self: HTMLFieldSetElement): JsObject =
  discard
proc jsHTMLFieldSetElementWillValidate*(self: HTMLFieldSetElement): bool =
  discard
proc jsHTMLFieldSetElementValidity*(self: HTMLFieldSetElement): JsObject =
  discard
proc jsHTMLFieldSetElementValidationMessage*(self: HTMLFieldSetElement): cstring =
  discard
proc jsCheckValidity*(self: HTMLFieldSetElement): bool =
  discard
proc jsReportValidity*(self: HTMLFieldSetElement): bool =
  discard
proc jsSetCustomValidity*(self: HTMLFieldSetElement; error: cstring): void =
  discard

proc jsHTMLFontElementColor*(self: HTMLFontElement): cstring =
  discard
proc jsHTMLFontElementFace*(self: HTMLFontElement): cstring =
  discard
proc jsHTMLFontElementSize*(self: HTMLFontElement): cstring =
  discard

proc jsNamedItem*(self: HTMLFormControlsCollection; name: cstring): Option[JsObject] =
  discard

proc jsHTMLFormElementAcceptCharset*(self: HTMLFormElement): cstring =
  discard
proc jsHTMLFormElementAction*(self: HTMLFormElement): cstring =
  discard
proc jsHTMLFormElementAutocomplete*(self: HTMLFormElement): cstring =
  discard
proc jsHTMLFormElementEnctype*(self: HTMLFormElement): cstring =
  discard
proc jsHTMLFormElementEncoding*(self: HTMLFormElement): cstring =
  discard
proc jsHTMLFormElementMethodVal*(self: HTMLFormElement): cstring =
  discard
proc jsHTMLFormElementName*(self: HTMLFormElement): cstring =
  discard
proc jsHTMLFormElementNoValidate*(self: HTMLFormElement): bool =
  discard
proc jsHTMLFormElementTarget*(self: HTMLFormElement): cstring =
  discard
proc jsHTMLFormElementElements*(self: HTMLFormElement): JsObject =
  discard
proc jsHTMLFormElementLength*(self: HTMLFormElement): int32 =
  discard
proc jsSubmit*(self: HTMLFormElement): void =
  discard
proc jsRequestSubmit*(self: HTMLFormElement; submitter: Option[JsObject]): void =
  discard
proc jsReset*(self: HTMLFormElement): void =
  discard
proc jsCheckValidity*(self: HTMLFormElement): bool =
  discard
proc jsReportValidity*(self: HTMLFormElement): bool =
  discard

proc jsHTMLFrameElementName*(self: HTMLFrameElement): cstring =
  discard
proc jsHTMLFrameElementScrolling*(self: HTMLFrameElement): cstring =
  discard
proc jsHTMLFrameElementSrc*(self: HTMLFrameElement): cstring =
  discard
proc jsHTMLFrameElementFrameBorder*(self: HTMLFrameElement): cstring =
  discard
proc jsHTMLFrameElementLongDesc*(self: HTMLFrameElement): cstring =
  discard
proc jsHTMLFrameElementNoResize*(self: HTMLFrameElement): bool =
  discard
proc jsHTMLFrameElementMarginHeight*(self: HTMLFrameElement): cstring =
  discard
proc jsHTMLFrameElementMarginWidth*(self: HTMLFrameElement): cstring =
  discard

proc jsHTMLFrameSetElementCols*(self: HTMLFrameSetElement): cstring =
  discard
proc jsHTMLFrameSetElementRows*(self: HTMLFrameSetElement): cstring =
  discard





proc jsHTMLIFrameElementSrc*(self: HTMLIFrameElement): cstring =
  discard
proc jsHTMLIFrameElementSrcdoc*(self: HTMLIFrameElement): cstring =
  discard
proc jsHTMLIFrameElementName*(self: HTMLIFrameElement): cstring =
  discard
proc jsHTMLIFrameElementSandbox*(self: HTMLIFrameElement): JsObject =
  discard
proc jsHTMLIFrameElementAllowFullscreen*(self: HTMLIFrameElement): bool =
  discard
proc jsHTMLIFrameElementAllowPaymentRequest*(self: HTMLIFrameElement): bool =
  discard
proc jsHTMLIFrameElementWidth*(self: HTMLIFrameElement): cstring =
  discard
proc jsHTMLIFrameElementHeight*(self: HTMLIFrameElement): cstring =
  discard
proc jsHTMLIFrameElementReferrerPolicy*(self: HTMLIFrameElement): cstring =
  discard

proc jsHTMLImageElementAlt*(self: HTMLImageElement): cstring =
  discard
proc jsHTMLImageElementSrc*(self: HTMLImageElement): cstring =
  discard
proc jsHTMLImageElementSrcset*(self: HTMLImageElement): cstring =
  discard
proc jsHTMLImageElementUseMap*(self: HTMLImageElement): cstring =
  discard
proc jsHTMLImageElementReferrerPolicy*(self: HTMLImageElement): cstring =
  discard
proc jsHTMLImageElementIsMap*(self: HTMLImageElement): bool =
  discard
proc jsHTMLImageElementWidth*(self: HTMLImageElement): uint32 =
  discard
proc jsHTMLImageElementHeight*(self: HTMLImageElement): uint32 =
  discard
proc jsHTMLImageElementDecoding*(self: HTMLImageElement): cstring =
  discard
proc jsHTMLImageElementNaturalWidth*(self: HTMLImageElement): uint32 =
  discard
proc jsHTMLImageElementNaturalHeight*(self: HTMLImageElement): uint32 =
  discard
proc jsHTMLImageElementComplete*(self: HTMLImageElement): bool =
  discard
proc jsDecode*(self: HTMLImageElement): JsObject =
  discard

proc jsHTMLInputElementAccept*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementAlt*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementAutocomplete*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementAutofocus*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementDefaultChecked*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementChecked*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementDisabled*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementFormAction*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementFormEnctype*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementFormMethod*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementFormNoValidate*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementFormTarget*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementHeight*(self: HTMLInputElement): uint32 =
  discard
proc jsHTMLInputElementIndeterminate*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementInputMode*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementMax*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementMaxLength*(self: HTMLInputElement): int32 =
  discard
proc jsHTMLInputElementMin*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementMinLength*(self: HTMLInputElement): int32 =
  discard
proc jsHTMLInputElementMultiple*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementName*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementPattern*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementPlaceholder*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementReadOnly*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementRequired*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementSize*(self: HTMLInputElement): uint32 =
  discard
proc jsHTMLInputElementSrc*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementStep*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementTypeVal*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementDefaultValue*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementValue*(self: HTMLInputElement): cstring =
  discard
proc jsHTMLInputElementValueAsNumber*(self: HTMLInputElement): float64 =
  discard
proc jsHTMLInputElementWidth*(self: HTMLInputElement): uint32 =
  discard
proc jsHTMLInputElementWillValidate*(self: HTMLInputElement): bool =
  discard
proc jsHTMLInputElementValidity*(self: HTMLInputElement): JsObject =
  discard
proc jsHTMLInputElementValidationMessage*(self: HTMLInputElement): cstring =
  discard
proc jsCheckValidity*(self: HTMLInputElement): bool =
  discard
proc jsReportValidity*(self: HTMLInputElement): bool =
  discard
proc jsSetCustomValidity*(self: HTMLInputElement; error: cstring): void =
  discard
proc jsSelect*(self: HTMLInputElement): void =
  discard
proc jsSetRangeText*(self: HTMLInputElement; replacement: cstring): void =
  discard
proc jsSetRangeText*(self: HTMLInputElement; replacement: cstring; start: uint32; endVal: uint32; selectionMode: JsObject): void =
  discard
proc jsSetSelectionRange*(self: HTMLInputElement; start: uint32; endVal: uint32; direction: cstring): void =
  discard
proc jsShowPicker*(self: HTMLInputElement): void =
  discard

proc jsHTMLLIElementValue*(self: HTMLLIElement): int32 =
  discard

proc jsHTMLLabelElementHtmlFor*(self: HTMLLabelElement): cstring =
  discard


proc jsHTMLLinkElementDisabled*(self: HTMLLinkElement): bool =
  discard
proc jsHTMLLinkElementHref*(self: HTMLLinkElement): cstring =
  discard
proc jsHTMLLinkElementRel*(self: HTMLLinkElement): cstring =
  discard
proc jsHTMLLinkElementRelList*(self: HTMLLinkElement): JsObject =
  discard
proc jsHTMLLinkElementMedia*(self: HTMLLinkElement): cstring =
  discard
proc jsHTMLLinkElementHreflang*(self: HTMLLinkElement): cstring =
  discard
proc jsHTMLLinkElementTypeVal*(self: HTMLLinkElement): cstring =
  discard
proc jsHTMLLinkElementReferrerPolicy*(self: HTMLLinkElement): cstring =
  discard
proc jsHTMLLinkElementSizes*(self: HTMLLinkElement): JsObject =
  discard

proc jsHTMLMapElementName*(self: HTMLMapElement): cstring =
  discard
proc jsHTMLMapElementAreas*(self: HTMLMapElement): JsObject =
  discard

proc jsHTMLMediaElementSrc*(self: HTMLMediaElement): cstring =
  discard
proc jsHTMLMediaElementCurrentSrc*(self: HTMLMediaElement): cstring =
  discard
const jsHTMLMediaElementNETWORK_EMPTY* : uint16 = 0
const jsHTMLMediaElementNETWORK_IDLE* : uint16 = 0
const jsHTMLMediaElementNETWORK_LOADING* : uint16 = 0
const jsHTMLMediaElementNETWORK_NO_SOURCE* : uint16 = 0
proc jsHTMLMediaElementNetworkState*(self: HTMLMediaElement): uint16 =
  discard
proc jsHTMLMediaElementPreload*(self: HTMLMediaElement): cstring =
  discard
proc jsHTMLMediaElementBuffered*(self: HTMLMediaElement): JsObject =
  discard
const jsHTMLMediaElementHAVE_NOTHING* : uint16 = 0
const jsHTMLMediaElementHAVE_METADATA* : uint16 = 0
const jsHTMLMediaElementHAVE_CURRENT_DATA* : uint16 = 0
const jsHTMLMediaElementHAVE_FUTURE_DATA* : uint16 = 0
const jsHTMLMediaElementHAVE_ENOUGH_DATA* : uint16 = 0
proc jsHTMLMediaElementReadyState*(self: HTMLMediaElement): uint16 =
  discard
proc jsHTMLMediaElementSeeking*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementCurrentTime*(self: HTMLMediaElement): float64 =
  discard
proc jsHTMLMediaElementDuration*(self: HTMLMediaElement): float64 =
  discard
proc jsHTMLMediaElementIsEncrypted*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementPaused*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementDefaultPlaybackRate*(self: HTMLMediaElement): float64 =
  discard
proc jsHTMLMediaElementPlaybackRate*(self: HTMLMediaElement): float64 =
  discard
proc jsHTMLMediaElementPlayed*(self: HTMLMediaElement): JsObject =
  discard
proc jsHTMLMediaElementSeekable*(self: HTMLMediaElement): JsObject =
  discard
proc jsHTMLMediaElementEnded*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementAutoplay*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementLoop*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementControls*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementVolume*(self: HTMLMediaElement): float64 =
  discard
proc jsHTMLMediaElementMuted*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementDefaultMuted*(self: HTMLMediaElement): bool =
  discard
proc jsHTMLMediaElementAudioTracks*(self: HTMLMediaElement): JsObject =
  discard
proc jsHTMLMediaElementVideoTracks*(self: HTMLMediaElement): JsObject =
  discard
proc jsLoad*(self: HTMLMediaElement): void =
  discard
proc jsCanPlayType*(self: HTMLMediaElement; typeVal: cstring): cstring =
  discard
proc jsFastSeek*(self: HTMLMediaElement; time: float64): void =
  discard
proc jsPlay*(self: HTMLMediaElement): JsObject =
  discard
proc jsPause*(self: HTMLMediaElement): void =
  discard
proc jsAddTextTrack*(self: HTMLMediaElement; kind: JsObject; label: cstring; language: cstring): JsObject =
  discard


proc jsHTMLMenuItemElementTypeVal*(self: HTMLMenuItemElement): cstring =
  discard
proc jsHTMLMenuItemElementLabel*(self: HTMLMenuItemElement): cstring =
  discard
proc jsHTMLMenuItemElementIcon*(self: HTMLMenuItemElement): cstring =
  discard
proc jsHTMLMenuItemElementDisabled*(self: HTMLMenuItemElement): bool =
  discard
proc jsHTMLMenuItemElementChecked*(self: HTMLMenuItemElement): bool =
  discard
proc jsHTMLMenuItemElementRadiogroup*(self: HTMLMenuItemElement): cstring =
  discard
proc jsHTMLMenuItemElementDefaultChecked*(self: HTMLMenuItemElement): bool =
  discard

proc jsHTMLMetaElementName*(self: HTMLMetaElement): cstring =
  discard
proc jsHTMLMetaElementHttpEquiv*(self: HTMLMetaElement): cstring =
  discard
proc jsHTMLMetaElementContent*(self: HTMLMetaElement): cstring =
  discard

proc jsHTMLMeterElementValue*(self: HTMLMeterElement): float64 =
  discard
proc jsHTMLMeterElementMin*(self: HTMLMeterElement): float64 =
  discard
proc jsHTMLMeterElementMax*(self: HTMLMeterElement): float64 =
  discard
proc jsHTMLMeterElementLow*(self: HTMLMeterElement): float64 =
  discard
proc jsHTMLMeterElementHigh*(self: HTMLMeterElement): float64 =
  discard
proc jsHTMLMeterElementOptimum*(self: HTMLMeterElement): float64 =
  discard
proc jsHTMLMeterElementLabels*(self: HTMLMeterElement): JsObject =
  discard

proc jsHTMLModElementCite*(self: HTMLModElement): cstring =
  discard
proc jsHTMLModElementDateTime*(self: HTMLModElement): cstring =
  discard

proc jsHTMLOListElementReversed*(self: HTMLOListElement): bool =
  discard
proc jsHTMLOListElementStart*(self: HTMLOListElement): int32 =
  discard
proc jsHTMLOListElementTypeVal*(self: HTMLOListElement): cstring =
  discard

proc jsHTMLObjectElementData*(self: HTMLObjectElement): cstring =
  discard
proc jsHTMLObjectElementTypeVal*(self: HTMLObjectElement): cstring =
  discard
proc jsHTMLObjectElementTypeMustMatch*(self: HTMLObjectElement): bool =
  discard
proc jsHTMLObjectElementName*(self: HTMLObjectElement): cstring =
  discard
proc jsHTMLObjectElementUseMap*(self: HTMLObjectElement): cstring =
  discard
proc jsHTMLObjectElementWidth*(self: HTMLObjectElement): cstring =
  discard
proc jsHTMLObjectElementHeight*(self: HTMLObjectElement): cstring =
  discard
proc jsHTMLObjectElementWillValidate*(self: HTMLObjectElement): bool =
  discard
proc jsHTMLObjectElementValidity*(self: HTMLObjectElement): JsObject =
  discard
proc jsHTMLObjectElementValidationMessage*(self: HTMLObjectElement): cstring =
  discard
proc jsCheckValidity*(self: HTMLObjectElement): bool =
  discard
proc jsReportValidity*(self: HTMLObjectElement): bool =
  discard
proc jsSetCustomValidity*(self: HTMLObjectElement; error: cstring): void =
  discard

proc jsHTMLOptGroupElementDisabled*(self: HTMLOptGroupElement): bool =
  discard
proc jsHTMLOptGroupElementLabel*(self: HTMLOptGroupElement): cstring =
  discard

proc jsHTMLOptionElementDisabled*(self: HTMLOptionElement): bool =
  discard
proc jsHTMLOptionElementLabel*(self: HTMLOptionElement): cstring =
  discard
proc jsHTMLOptionElementDefaultSelected*(self: HTMLOptionElement): bool =
  discard
proc jsHTMLOptionElementSelected*(self: HTMLOptionElement): bool =
  discard
proc jsHTMLOptionElementValue*(self: HTMLOptionElement): cstring =
  discard
proc jsHTMLOptionElementText*(self: HTMLOptionElement): cstring =
  discard
proc jsHTMLOptionElementIndex*(self: HTMLOptionElement): int32 =
  discard

proc jsHTMLOptionsCollectionLength*(self: HTMLOptionsCollection): uint32 =
  discard
proc jsHTMLOptionsCollectionSelectedIndex*(self: HTMLOptionsCollection): int32 =
  discard
proc jsAdd*(self: HTMLOptionsCollection; element: JsObject; before: Option[JsObject]): void =
  discard
proc jsRemove*(self: HTMLOptionsCollection; index: int32): void =
  discard

proc jsHTMLOutputElementHtmlFor*(self: HTMLOutputElement): JsObject =
  discard
proc jsHTMLOutputElementName*(self: HTMLOutputElement): cstring =
  discard
proc jsHTMLOutputElementTypeVal*(self: HTMLOutputElement): cstring =
  discard
proc jsHTMLOutputElementDefaultValue*(self: HTMLOutputElement): cstring =
  discard
proc jsHTMLOutputElementValue*(self: HTMLOutputElement): cstring =
  discard
proc jsHTMLOutputElementWillValidate*(self: HTMLOutputElement): bool =
  discard
proc jsHTMLOutputElementValidity*(self: HTMLOutputElement): JsObject =
  discard
proc jsHTMLOutputElementValidationMessage*(self: HTMLOutputElement): cstring =
  discard
proc jsHTMLOutputElementLabels*(self: HTMLOutputElement): JsObject =
  discard
proc jsCheckValidity*(self: HTMLOutputElement): bool =
  discard
proc jsReportValidity*(self: HTMLOutputElement): bool =
  discard
proc jsSetCustomValidity*(self: HTMLOutputElement; error: cstring): void =
  discard


proc jsHTMLParamElementName*(self: HTMLParamElement): cstring =
  discard
proc jsHTMLParamElementValue*(self: HTMLParamElement): cstring =
  discard



proc jsHTMLProgressElementValue*(self: HTMLProgressElement): float64 =
  discard
proc jsHTMLProgressElementMax*(self: HTMLProgressElement): float64 =
  discard
proc jsHTMLProgressElementPosition*(self: HTMLProgressElement): float64 =
  discard
proc jsHTMLProgressElementLabels*(self: HTMLProgressElement): JsObject =
  discard

proc jsHTMLQuoteElementCite*(self: HTMLQuoteElement): cstring =
  discard

proc jsHTMLScriptElementSrc*(self: HTMLScriptElement): cstring =
  discard
proc jsHTMLScriptElementTypeVal*(self: HTMLScriptElement): cstring =
  discard
proc jsHTMLScriptElementNoModule*(self: HTMLScriptElement): bool =
  discard
proc jsHTMLScriptElementCharset*(self: HTMLScriptElement): cstring =
  discard
proc jsHTMLScriptElementAsync*(self: HTMLScriptElement): bool =
  discard
proc jsHTMLScriptElementDeferVal*(self: HTMLScriptElement): bool =
  discard
proc jsHTMLScriptElementText*(self: HTMLScriptElement): cstring =
  discard

proc jsHTMLSelectElementAutofocus*(self: HTMLSelectElement): bool =
  discard
proc jsHTMLSelectElementAutocomplete*(self: HTMLSelectElement): cstring =
  discard
proc jsHTMLSelectElementDisabled*(self: HTMLSelectElement): bool =
  discard
proc jsHTMLSelectElementMultiple*(self: HTMLSelectElement): bool =
  discard
proc jsHTMLSelectElementName*(self: HTMLSelectElement): cstring =
  discard
proc jsHTMLSelectElementRequired*(self: HTMLSelectElement): bool =
  discard
proc jsHTMLSelectElementSize*(self: HTMLSelectElement): uint32 =
  discard
proc jsHTMLSelectElementTypeVal*(self: HTMLSelectElement): cstring =
  discard
proc jsHTMLSelectElementOptions*(self: HTMLSelectElement): JsObject =
  discard
proc jsHTMLSelectElementLength*(self: HTMLSelectElement): uint32 =
  discard
proc jsHTMLSelectElementSelectedOptions*(self: HTMLSelectElement): JsObject =
  discard
proc jsHTMLSelectElementSelectedIndex*(self: HTMLSelectElement): int32 =
  discard
proc jsHTMLSelectElementValue*(self: HTMLSelectElement): cstring =
  discard
proc jsHTMLSelectElementWillValidate*(self: HTMLSelectElement): bool =
  discard
proc jsHTMLSelectElementValidity*(self: HTMLSelectElement): JsObject =
  discard
proc jsHTMLSelectElementValidationMessage*(self: HTMLSelectElement): cstring =
  discard
proc jsHTMLSelectElementLabels*(self: HTMLSelectElement): JsObject =
  discard
proc jsItem*(self: HTMLSelectElement; index: uint32): Option[JsObject] =
  discard
proc jsNamedItem*(self: HTMLSelectElement; name: cstring): Option[JsObject] =
  discard
proc jsAdd*(self: HTMLSelectElement; element: JsObject; before: Option[JsObject]): void =
  discard
proc jsRemove*(self: HTMLSelectElement; index: int32): void =
  discard
proc jsCheckValidity*(self: HTMLSelectElement): bool =
  discard
proc jsReportValidity*(self: HTMLSelectElement): bool =
  discard
proc jsSetCustomValidity*(self: HTMLSelectElement; error: cstring): void =
  discard
proc jsRemove*(self: HTMLSelectElement): void =
  discard

proc jsHTMLSlotElementName*(self: HTMLSlotElement): cstring =
  discard
proc jsAssignedNodes*(self: HTMLSlotElement; options: JsObject): JsObject =
  discard

proc jsHTMLSourceElementSrc*(self: HTMLSourceElement): cstring =
  discard
proc jsHTMLSourceElementTypeVal*(self: HTMLSourceElement): cstring =
  discard


proc jsHTMLStyleElementDisabled*(self: HTMLStyleElement): bool =
  discard
proc jsHTMLStyleElementMedia*(self: HTMLStyleElement): cstring =
  discard
proc jsHTMLStyleElementTypeVal*(self: HTMLStyleElement): cstring =
  discard


proc jsHTMLTableCellElementColSpan*(self: HTMLTableCellElement): uint32 =
  discard
proc jsHTMLTableCellElementRowSpan*(self: HTMLTableCellElement): uint32 =
  discard
proc jsHTMLTableCellElementHeaders*(self: HTMLTableCellElement): cstring =
  discard
proc jsHTMLTableCellElementCellIndex*(self: HTMLTableCellElement): int32 =
  discard
proc jsHTMLTableCellElementAbbr*(self: HTMLTableCellElement): cstring =
  discard
proc jsHTMLTableCellElementScope*(self: HTMLTableCellElement): cstring =
  discard

proc jsHTMLTableColElementSpan*(self: HTMLTableColElement): uint32 =
  discard

proc jsHTMLTableElementTBodies*(self: HTMLTableElement): JsObject =
  discard
proc jsHTMLTableElementRows*(self: HTMLTableElement): JsObject =
  discard
proc jsCreateCaption*(self: HTMLTableElement): JsObject =
  discard
proc jsDeleteCaption*(self: HTMLTableElement): void =
  discard
proc jsCreateTHead*(self: HTMLTableElement): JsObject =
  discard
proc jsDeleteTHead*(self: HTMLTableElement): void =
  discard
proc jsCreateTFoot*(self: HTMLTableElement): JsObject =
  discard
proc jsDeleteTFoot*(self: HTMLTableElement): void =
  discard
proc jsCreateTBody*(self: HTMLTableElement): JsObject =
  discard
proc jsInsertRow*(self: HTMLTableElement; index: int32): JsObject =
  discard
proc jsDeleteRow*(self: HTMLTableElement; index: int32): void =
  discard

proc jsHTMLTableRowElementRowIndex*(self: HTMLTableRowElement): int32 =
  discard
proc jsHTMLTableRowElementSectionRowIndex*(self: HTMLTableRowElement): int32 =
  discard
proc jsHTMLTableRowElementCells*(self: HTMLTableRowElement): JsObject =
  discard
proc jsInsertCell*(self: HTMLTableRowElement; index: int32): JsObject =
  discard
proc jsDeleteCell*(self: HTMLTableRowElement; index: int32): void =
  discard

proc jsHTMLTableSectionElementRows*(self: HTMLTableSectionElement): JsObject =
  discard
proc jsInsertRow*(self: HTMLTableSectionElement; index: int32): JsObject =
  discard
proc jsDeleteRow*(self: HTMLTableSectionElement; index: int32): void =
  discard

proc jsHTMLTemplateElementContent*(self: HTMLTemplateElement): JsObject =
  discard

proc jsHTMLTextAreaElementAutocomplete*(self: HTMLTextAreaElement): cstring =
  discard
proc jsHTMLTextAreaElementAutofocus*(self: HTMLTextAreaElement): bool =
  discard
proc jsHTMLTextAreaElementCols*(self: HTMLTextAreaElement): uint32 =
  discard
proc jsHTMLTextAreaElementDisabled*(self: HTMLTextAreaElement): bool =
  discard
proc jsHTMLTextAreaElementMaxLength*(self: HTMLTextAreaElement): int32 =
  discard
proc jsHTMLTextAreaElementMinLength*(self: HTMLTextAreaElement): int32 =
  discard
proc jsHTMLTextAreaElementName*(self: HTMLTextAreaElement): cstring =
  discard
proc jsHTMLTextAreaElementPlaceholder*(self: HTMLTextAreaElement): cstring =
  discard
proc jsHTMLTextAreaElementReadOnly*(self: HTMLTextAreaElement): bool =
  discard
proc jsHTMLTextAreaElementRequired*(self: HTMLTextAreaElement): bool =
  discard
proc jsHTMLTextAreaElementRows*(self: HTMLTextAreaElement): uint32 =
  discard
proc jsHTMLTextAreaElementWrap*(self: HTMLTextAreaElement): cstring =
  discard
proc jsHTMLTextAreaElementTypeVal*(self: HTMLTextAreaElement): cstring =
  discard
proc jsHTMLTextAreaElementDefaultValue*(self: HTMLTextAreaElement): cstring =
  discard
proc jsHTMLTextAreaElementValue*(self: HTMLTextAreaElement): cstring =
  discard
proc jsHTMLTextAreaElementTextLength*(self: HTMLTextAreaElement): uint32 =
  discard
proc jsHTMLTextAreaElementWillValidate*(self: HTMLTextAreaElement): bool =
  discard
proc jsHTMLTextAreaElementValidity*(self: HTMLTextAreaElement): JsObject =
  discard
proc jsHTMLTextAreaElementValidationMessage*(self: HTMLTextAreaElement): cstring =
  discard
proc jsHTMLTextAreaElementLabels*(self: HTMLTextAreaElement): JsObject =
  discard
proc jsCheckValidity*(self: HTMLTextAreaElement): bool =
  discard
proc jsReportValidity*(self: HTMLTextAreaElement): bool =
  discard
proc jsSetCustomValidity*(self: HTMLTextAreaElement; error: cstring): void =
  discard
proc jsSelect*(self: HTMLTextAreaElement): void =
  discard
proc jsSetRangeText*(self: HTMLTextAreaElement; replacement: cstring): void =
  discard
proc jsSetRangeText*(self: HTMLTextAreaElement; replacement: cstring; start: uint32; endVal: uint32; mode: cstring): void =
  discard
proc jsSetSelectionRange*(self: HTMLTextAreaElement; start: uint32; endVal: uint32; direction: cstring): void =
  discard

proc jsHTMLTimeElementDateTime*(self: HTMLTimeElement): cstring =
  discard

proc jsHTMLTitleElementText*(self: HTMLTitleElement): cstring =
  discard

proc jsHTMLTrackElementKind*(self: HTMLTrackElement): cstring =
  discard
proc jsHTMLTrackElementSrc*(self: HTMLTrackElement): cstring =
  discard
proc jsHTMLTrackElementSrclang*(self: HTMLTrackElement): cstring =
  discard
proc jsHTMLTrackElementLabel*(self: HTMLTrackElement): cstring =
  discard
proc jsHTMLTrackElementDefault*(self: HTMLTrackElement): bool =
  discard
const jsHTMLTrackElementNONE* : uint16 = 0
const jsHTMLTrackElementLOADING* : uint16 = 0
const jsHTMLTrackElementLOADED* : uint16 = 0
const jsHTMLTrackElementERROR* : uint16 = 0
proc jsHTMLTrackElementReadyState*(self: HTMLTrackElement): uint16 =
  discard


proc jsHTMLVideoElementWidth*(self: HTMLVideoElement): uint32 =
  discard
proc jsHTMLVideoElementHeight*(self: HTMLVideoElement): uint32 =
  discard
proc jsHTMLVideoElementVideoWidth*(self: HTMLVideoElement): uint32 =
  discard
proc jsHTMLVideoElementVideoHeight*(self: HTMLVideoElement): uint32 =
  discard
proc jsHTMLVideoElementPoster*(self: HTMLVideoElement): cstring =
  discard

proc jsHashChangeEventOldURL*(self: HashChangeEvent): cstring =
  discard
proc jsHashChangeEventNewURL*(self: HashChangeEvent): cstring =
  discard
proc jsInitHashChangeEvent*(self: HashChangeEvent; typeArg: cstring; canBubbleArg: bool; cancelableArg: bool; oldURLArg: cstring; newURLArg: cstring): void =
  discard

proc jsHeadersGuard*(self: Headers): JsObject =
  discard
proc jsAppend*(self: Headers; name: cstring; value: cstring): void =
  discard
proc jsDelete*(self: Headers; name: cstring): void =
  discard
proc jsGet*(self: Headers; name: cstring): Option[cstring] =
  discard
proc jsHas*(self: Headers; name: cstring): bool =
  discard
proc jsSet*(self: Headers; name: cstring; value: cstring): void =
  discard


proc jsHistoryLength*(self: History): uint32 =
  discard
proc jsHistoryScrollRestoration*(self: History): JsObject =
  discard
proc jsHistoryState*(self: History): JsObject =
  discard
proc jsGo*(self: History; delta: int32): void =
  discard
proc jsBack*(self: History): void =
  discard
proc jsForward*(self: History): void =
  discard
proc jsPushState*(self: History; data: JsObject; title: cstring; url: Option[cstring]): void =
  discard
proc jsReplaceState*(self: History; data: JsObject; title: cstring; url: Option[cstring]): void =
  discard

proc jsIDBRequestResultVal*(self: IDBRequest): JsObject =
  discard
proc jsIDBRequestReadyState*(self: IDBRequest): JsObject =
  discard
proc jsIDBRequestOnsuccess*(self: IDBRequest): JsObject =
  discard
proc jsIDBRequestOnerror*(self: IDBRequest): JsObject =
  discard

proc jsIDBOpenDBRequestOnblocked*(self: IDBOpenDBRequest): JsObject =
  discard
proc jsIDBOpenDBRequestOnupgradeneeded*(self: IDBOpenDBRequest): JsObject =
  discard

proc jsIDBVersionChangeEventOldVersion*(self: IDBVersionChangeEvent): uint64 =
  discard

proc jsOpen*(self: IDBFactory; name: cstring; version: uint64): JsObject =
  discard
proc jsDeleteDatabase*(self: IDBFactory; name: cstring): JsObject =
  discard
proc jsCmp*(self: IDBFactory; first: JsObject; second: JsObject): int16 =
  discard

proc jsIDBDatabaseName*(self: IDBDatabase): cstring =
  discard
proc jsIDBDatabaseVersion*(self: IDBDatabase): uint64 =
  discard
proc jsIDBDatabaseOnabort*(self: IDBDatabase): JsObject =
  discard
proc jsIDBDatabaseOnclose*(self: IDBDatabase): JsObject =
  discard
proc jsIDBDatabaseOnerror*(self: IDBDatabase): JsObject =
  discard
proc jsIDBDatabaseOnversionchange*(self: IDBDatabase): JsObject =
  discard
proc jsTransaction*(self: IDBDatabase; storeNames: JsObject; mode: JsObject): JsObject =
  discard
proc jsClose*(self: IDBDatabase): void =
  discard
proc jsCreateObjectStore*(self: IDBDatabase; name: cstring; options: JsObject): JsObject =
  discard
proc jsDeleteObjectStore*(self: IDBDatabase; name: cstring): void =
  discard

proc jsIDBObjectStoreName*(self: IDBObjectStore): cstring =
  discard
proc jsIDBObjectStoreKeyPath*(self: IDBObjectStore): JsObject =
  discard
proc jsIDBObjectStoreTransaction*(self: IDBObjectStore): JsObject =
  discard
proc jsIDBObjectStoreAutoIncrement*(self: IDBObjectStore): bool =
  discard
proc jsPut*(self: IDBObjectStore; value: JsObject; key: JsObject): JsObject =
  discard
proc jsAdd*(self: IDBObjectStore; value: JsObject; key: JsObject): JsObject =
  discard
proc jsDelete*(self: IDBObjectStore; query: JsObject): JsObject =
  discard
proc jsClear*(self: IDBObjectStore): JsObject =
  discard
proc jsGet*(self: IDBObjectStore; query: JsObject): JsObject =
  discard
proc jsGetKey*(self: IDBObjectStore; query: JsObject): JsObject =
  discard
proc jsGetAll*(self: IDBObjectStore; query: JsObject; count: uint32): JsObject =
  discard
proc jsGetAllKeys*(self: IDBObjectStore; query: JsObject; count: uint32): JsObject =
  discard
proc jsCount*(self: IDBObjectStore; query: JsObject): JsObject =
  discard
proc jsOpenCursor*(self: IDBObjectStore; query: JsObject; direction: JsObject): JsObject =
  discard
proc jsOpenKeyCursor*(self: IDBObjectStore; query: JsObject; direction: JsObject): JsObject =
  discard
proc jsIndex*(self: IDBObjectStore; name: cstring): JsObject =
  discard
proc jsCreateIndex*(self: IDBObjectStore; name: cstring; keyPath: JsObject; options: JsObject): JsObject =
  discard
proc jsDeleteIndex*(self: IDBObjectStore; name: cstring): void =
  discard

proc jsIDBIndexName*(self: IDBIndex): cstring =
  discard
proc jsIDBIndexObjectStore*(self: IDBIndex): JsObject =
  discard
proc jsIDBIndexKeyPath*(self: IDBIndex): JsObject =
  discard
proc jsIDBIndexMultiEntry*(self: IDBIndex): bool =
  discard
proc jsIDBIndexUnique*(self: IDBIndex): bool =
  discard
proc jsGet*(self: IDBIndex; query: JsObject): JsObject =
  discard
proc jsGetKey*(self: IDBIndex; query: JsObject): JsObject =
  discard
proc jsGetAll*(self: IDBIndex; query: JsObject; count: uint32): JsObject =
  discard
proc jsGetAllKeys*(self: IDBIndex; query: JsObject; count: uint32): JsObject =
  discard
proc jsCount*(self: IDBIndex; query: JsObject): JsObject =
  discard
proc jsOpenCursor*(self: IDBIndex; query: JsObject; direction: JsObject): JsObject =
  discard
proc jsOpenKeyCursor*(self: IDBIndex; query: JsObject; direction: JsObject): JsObject =
  discard

proc jsIDBKeyRangeLower*(self: IDBKeyRange): JsObject =
  discard
proc jsIDBKeyRangeUpper*(self: IDBKeyRange): JsObject =
  discard
proc jsIDBKeyRangeLowerOpen*(self: IDBKeyRange): bool =
  discard
proc jsIDBKeyRangeUpperOpen*(self: IDBKeyRange): bool =
  discard
proc jsOnly*(self: typedesc[IDBKeyRange]; value: JsObject): JsObject =
  discard
proc jsLowerBound*(self: typedesc[IDBKeyRange]; lower: JsObject; open: bool): JsObject =
  discard
proc jsUpperBound*(self: typedesc[IDBKeyRange]; upper: JsObject; open: bool): JsObject =
  discard
proc jsBound*(self: typedesc[IDBKeyRange]; lower: JsObject; upper: JsObject; lowerOpen: bool; upperOpen: bool): JsObject =
  discard
proc jsIncludes*(self: IDBKeyRange; key: JsObject): bool =
  discard

proc jsIDBCursorSource*(self: IDBCursor): JsObject =
  discard
proc jsIDBCursorDirection*(self: IDBCursor): JsObject =
  discard
proc jsIDBCursorKey*(self: IDBCursor): JsObject =
  discard
proc jsIDBCursorPrimaryKey*(self: IDBCursor): JsObject =
  discard
proc jsAdvance*(self: IDBCursor; count: uint32): void =
  discard
proc jsContinueVal*(self: IDBCursor; key: JsObject): void =
  discard
proc jsContinuePrimaryKey*(self: IDBCursor; key: JsObject; primaryKey: JsObject): void =
  discard
proc jsUpdate*(self: IDBCursor; value: JsObject): JsObject =
  discard
proc jsDelete*(self: IDBCursor): JsObject =
  discard

proc jsIDBCursorWithValueValue*(self: IDBCursorWithValue): JsObject =
  discard

proc jsIDBTransactionMode*(self: IDBTransaction): JsObject =
  discard
proc jsIDBTransactionDb*(self: IDBTransaction): JsObject =
  discard
proc jsIDBTransactionOnabort*(self: IDBTransaction): JsObject =
  discard
proc jsIDBTransactionOncomplete*(self: IDBTransaction): JsObject =
  discard
proc jsIDBTransactionOnerror*(self: IDBTransaction): JsObject =
  discard
proc jsObjectStore*(self: IDBTransaction; name: cstring): JsObject =
  discard
proc jsAbort*(self: IDBTransaction): void =
  discard

proc jsIDBFileHandleMode*(self: IDBFileHandle): JsObject =
  discard
proc jsIDBFileHandleActive*(self: IDBFileHandle): bool =
  discard
proc jsIDBFileHandleOncomplete*(self: IDBFileHandle): JsObject =
  discard
proc jsIDBFileHandleOnabort*(self: IDBFileHandle): JsObject =
  discard
proc jsIDBFileHandleOnerror*(self: IDBFileHandle): JsObject =
  discard
proc jsGetMetadata*(self: IDBFileHandle; parameters: JsObject): Option[JsObject] =
  discard
proc jsReadAsArrayBuffer*(self: IDBFileHandle; size: uint64): Option[JsObject] =
  discard
proc jsReadAsText*(self: IDBFileHandle; size: uint64; encoding: Option[cstring]): Option[JsObject] =
  discard
proc jsWrite*(self: IDBFileHandle; value: JsObject): Option[JsObject] =
  discard
proc jsAppend*(self: IDBFileHandle; value: JsObject): Option[JsObject] =
  discard
proc jsTruncate*(self: IDBFileHandle; size: uint64): Option[JsObject] =
  discard
proc jsFlush*(self: IDBFileHandle): Option[JsObject] =
  discard
proc jsAbort*(self: IDBFileHandle): void =
  discard

proc jsIDBFileRequestOnprogress*(self: IDBFileRequest): JsObject =
  discard

proc jsBound*(self: typedesc[IDBLocaleAwareKeyRange]; lower: JsObject; upper: JsObject; lowerOpen: bool; upperOpen: bool): JsObject =
  discard

proc jsIDBMutableFileName*(self: IDBMutableFile): cstring =
  discard
proc jsIDBMutableFileTypeVal*(self: IDBMutableFile): cstring =
  discard
proc jsIDBMutableFileDatabase*(self: IDBMutableFile): JsObject =
  discard
proc jsIDBMutableFileOnabort*(self: IDBMutableFile): JsObject =
  discard
proc jsIDBMutableFileOnerror*(self: IDBMutableFile): JsObject =
  discard
proc jsOpen*(self: IDBMutableFile; mode: JsObject): JsObject =
  discard
proc jsGetFile*(self: IDBMutableFile): JsObject =
  discard

proc jsGetFrequencyResponse*(self: IIRFilterNode; frequencyHz: seq[float32]; magResponse: seq[float32]; phaseResponse: seq[float32]): void =
  discard

proc jsIdleDeadlineDidTimeout*(self: IdleDeadline): bool =
  discard
proc jsTimeRemaining*(self: IdleDeadline): JsObject =
  discard

proc jsImageBitmapWidth*(self: ImageBitmap): uint32 =
  discard
proc jsImageBitmapHeight*(self: ImageBitmap): uint32 =
  discard

proc jsTransferFromImageBitmap*(self: ImageBitmapRenderingContext; bitmap: JsObject): void =
  discard
proc jsTransferImageBitmap*(self: ImageBitmapRenderingContext; bitmap: JsObject): void =
  discard


const jsImageCaptureErrorFRAME_GRAB_ERROR* : uint16 = 0
const jsImageCaptureErrorSETTINGS_ERROR* : uint16 = 0
const jsImageCaptureErrorPHOTO_ERROR* : uint16 = 0
const jsImageCaptureErrorERROR_UNKNOWN* : uint16 = 0
proc jsImageCaptureErrorCode*(self: ImageCaptureError): uint16 =
  discard
proc jsImageCaptureErrorMessage*(self: ImageCaptureError): cstring =
  discard

proc jsImageDataWidth*(self: ImageData): uint32 =
  discard
proc jsImageDataHeight*(self: ImageData): uint32 =
  discard
proc jsImageDataData*(self: ImageData): JsObject =
  discard

proc jsImageDocumentImageIsOverflowing*(self: ImageDocument): bool =
  discard
proc jsImageDocumentImageIsResized*(self: ImageDocument): bool =
  discard
proc jsShrinkToFit*(self: ImageDocument): void =
  discard
proc jsRestoreImage*(self: ImageDocument): void =
  discard
proc jsRestoreImageTo*(self: ImageDocument; x: int32; y: int32): void =
  discard
proc jsToggleImageSize*(self: ImageDocument): void =
  discard

proc jsInputEventIsComposing*(self: InputEvent): bool =
  discard
proc jsInputEventInputType*(self: InputEvent): cstring =
  discard

proc jsIntersectionObserverEntryTime*(self: IntersectionObserverEntry): JsObject =
  discard
proc jsIntersectionObserverEntryBoundingClientRect*(self: IntersectionObserverEntry): JsObject =
  discard
proc jsIntersectionObserverEntryIntersectionRect*(self: IntersectionObserverEntry): JsObject =
  discard
proc jsIntersectionObserverEntryIsIntersecting*(self: IntersectionObserverEntry): bool =
  discard
proc jsIntersectionObserverEntryIntersectionRatio*(self: IntersectionObserverEntry): float64 =
  discard
proc jsIntersectionObserverEntryTarget*(self: IntersectionObserverEntry): JsObject =
  discard

proc jsIntersectionObserverRootMargin*(self: IntersectionObserver): cstring =
  discard
proc jsIntersectionObserverThresholds*(self: IntersectionObserver): JsObject =
  discard
proc jsIntersectionObserverIntersectionCallback*(self: IntersectionObserver): JsObject =
  discard
proc jsObserve*(self: IntersectionObserver; target: JsObject): void =
  discard
proc jsUnobserve*(self: IntersectionObserver; target: JsObject): void =
  discard
proc jsDisconnect*(self: IntersectionObserver): void =
  discard
proc jsTakeRecords*(self: IntersectionObserver): JsObject =
  discard

proc jsGetDisplayNames*(self: IntlUtils; locales: JsObject; options: JsObject): JsObject =
  discard
proc jsGetLocaleInfo*(self: IntlUtils; locales: JsObject): JsObject =
  discard

const jsKeyEventDOM_VK_CANCEL* : uint32 = 0
const jsKeyEventDOM_VK_HELP* : uint32 = 0
const jsKeyEventDOM_VK_BACK_SPACE* : uint32 = 0
const jsKeyEventDOM_VK_TAB* : uint32 = 0
const jsKeyEventDOM_VK_CLEAR* : uint32 = 0
const jsKeyEventDOM_VK_RETURN* : uint32 = 0
const jsKeyEventDOM_VK_SHIFT* : uint32 = 0
const jsKeyEventDOM_VK_CONTROL* : uint32 = 0
const jsKeyEventDOM_VK_ALT* : uint32 = 0
const jsKeyEventDOM_VK_PAUSE* : uint32 = 0
const jsKeyEventDOM_VK_CAPS_LOCK* : uint32 = 0
const jsKeyEventDOM_VK_KANA* : uint32 = 0
const jsKeyEventDOM_VK_HANGUL* : uint32 = 0
const jsKeyEventDOM_VK_EISU* : uint32 = 0
const jsKeyEventDOM_VK_JUNJA* : uint32 = 0
const jsKeyEventDOM_VK_FINAL* : uint32 = 0
const jsKeyEventDOM_VK_HANJA* : uint32 = 0
const jsKeyEventDOM_VK_KANJI* : uint32 = 0
const jsKeyEventDOM_VK_ESCAPE* : uint32 = 0
const jsKeyEventDOM_VK_CONVERT* : uint32 = 0
const jsKeyEventDOM_VK_NONCONVERT* : uint32 = 0
const jsKeyEventDOM_VK_ACCEPT* : uint32 = 0
const jsKeyEventDOM_VK_MODECHANGE* : uint32 = 0
const jsKeyEventDOM_VK_SPACE* : uint32 = 0
const jsKeyEventDOM_VK_PAGE_UP* : uint32 = 0
const jsKeyEventDOM_VK_PAGE_DOWN* : uint32 = 0
const jsKeyEventDOM_VK_END* : uint32 = 0
const jsKeyEventDOM_VK_HOME* : uint32 = 0
const jsKeyEventDOM_VK_LEFT* : uint32 = 0
const jsKeyEventDOM_VK_UP* : uint32 = 0
const jsKeyEventDOM_VK_RIGHT* : uint32 = 0
const jsKeyEventDOM_VK_DOWN* : uint32 = 0
const jsKeyEventDOM_VK_SELECT* : uint32 = 0
const jsKeyEventDOM_VK_PRINT* : uint32 = 0
const jsKeyEventDOM_VK_EXECUTE* : uint32 = 0
const jsKeyEventDOM_VK_PRINTSCREEN* : uint32 = 0
const jsKeyEventDOM_VK_INSERT* : uint32 = 0
const jsKeyEventDOM_VK_DELETE* : uint32 = 0
const jsKeyEventDOM_VK_0* : uint32 = 0
const jsKeyEventDOM_VK_1* : uint32 = 0
const jsKeyEventDOM_VK_2* : uint32 = 0
const jsKeyEventDOM_VK_3* : uint32 = 0
const jsKeyEventDOM_VK_4* : uint32 = 0
const jsKeyEventDOM_VK_5* : uint32 = 0
const jsKeyEventDOM_VK_6* : uint32 = 0
const jsKeyEventDOM_VK_7* : uint32 = 0
const jsKeyEventDOM_VK_8* : uint32 = 0
const jsKeyEventDOM_VK_9* : uint32 = 0
const jsKeyEventDOM_VK_COLON* : uint32 = 0
const jsKeyEventDOM_VK_SEMICOLON* : uint32 = 0
const jsKeyEventDOM_VK_LESS_THAN* : uint32 = 0
const jsKeyEventDOM_VK_EQUALS* : uint32 = 0
const jsKeyEventDOM_VK_GREATER_THAN* : uint32 = 0
const jsKeyEventDOM_VK_QUESTION_MARK* : uint32 = 0
const jsKeyEventDOM_VK_AT* : uint32 = 0
const jsKeyEventDOM_VK_A* : uint32 = 0
const jsKeyEventDOM_VK_B* : uint32 = 0
const jsKeyEventDOM_VK_C* : uint32 = 0
const jsKeyEventDOM_VK_D* : uint32 = 0
const jsKeyEventDOM_VK_E* : uint32 = 0
const jsKeyEventDOM_VK_F* : uint32 = 0
const jsKeyEventDOM_VK_G* : uint32 = 0
const jsKeyEventDOM_VK_H* : uint32 = 0
const jsKeyEventDOM_VK_I* : uint32 = 0
const jsKeyEventDOM_VK_J* : uint32 = 0
const jsKeyEventDOM_VK_K* : uint32 = 0
const jsKeyEventDOM_VK_L* : uint32 = 0
const jsKeyEventDOM_VK_M* : uint32 = 0
const jsKeyEventDOM_VK_N* : uint32 = 0
const jsKeyEventDOM_VK_O* : uint32 = 0
const jsKeyEventDOM_VK_P* : uint32 = 0
const jsKeyEventDOM_VK_Q* : uint32 = 0
const jsKeyEventDOM_VK_R* : uint32 = 0
const jsKeyEventDOM_VK_S* : uint32 = 0
const jsKeyEventDOM_VK_T* : uint32 = 0
const jsKeyEventDOM_VK_U* : uint32 = 0
const jsKeyEventDOM_VK_V* : uint32 = 0
const jsKeyEventDOM_VK_W* : uint32 = 0
const jsKeyEventDOM_VK_X* : uint32 = 0
const jsKeyEventDOM_VK_Y* : uint32 = 0
const jsKeyEventDOM_VK_Z* : uint32 = 0
const jsKeyEventDOM_VK_WIN* : uint32 = 0
const jsKeyEventDOM_VK_CONTEXT_MENU* : uint32 = 0
const jsKeyEventDOM_VK_SLEEP* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD0* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD1* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD2* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD3* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD4* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD5* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD6* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD7* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD8* : uint32 = 0
const jsKeyEventDOM_VK_NUMPAD9* : uint32 = 0
const jsKeyEventDOM_VK_MULTIPLY* : uint32 = 0
const jsKeyEventDOM_VK_ADD* : uint32 = 0
const jsKeyEventDOM_VK_SEPARATOR* : uint32 = 0
const jsKeyEventDOM_VK_SUBTRACT* : uint32 = 0
const jsKeyEventDOM_VK_DECIMAL* : uint32 = 0
const jsKeyEventDOM_VK_DIVIDE* : uint32 = 0
const jsKeyEventDOM_VK_F1* : uint32 = 0
const jsKeyEventDOM_VK_F2* : uint32 = 0
const jsKeyEventDOM_VK_F3* : uint32 = 0
const jsKeyEventDOM_VK_F4* : uint32 = 0
const jsKeyEventDOM_VK_F5* : uint32 = 0
const jsKeyEventDOM_VK_F6* : uint32 = 0
const jsKeyEventDOM_VK_F7* : uint32 = 0
const jsKeyEventDOM_VK_F8* : uint32 = 0
const jsKeyEventDOM_VK_F9* : uint32 = 0
const jsKeyEventDOM_VK_F10* : uint32 = 0
const jsKeyEventDOM_VK_F11* : uint32 = 0
const jsKeyEventDOM_VK_F12* : uint32 = 0
const jsKeyEventDOM_VK_F13* : uint32 = 0
const jsKeyEventDOM_VK_F14* : uint32 = 0
const jsKeyEventDOM_VK_F15* : uint32 = 0
const jsKeyEventDOM_VK_F16* : uint32 = 0
const jsKeyEventDOM_VK_F17* : uint32 = 0
const jsKeyEventDOM_VK_F18* : uint32 = 0
const jsKeyEventDOM_VK_F19* : uint32 = 0
const jsKeyEventDOM_VK_F20* : uint32 = 0
const jsKeyEventDOM_VK_F21* : uint32 = 0
const jsKeyEventDOM_VK_F22* : uint32 = 0
const jsKeyEventDOM_VK_F23* : uint32 = 0
const jsKeyEventDOM_VK_F24* : uint32 = 0
const jsKeyEventDOM_VK_NUM_LOCK* : uint32 = 0
const jsKeyEventDOM_VK_SCROLL_LOCK* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_FJ_JISHO* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_FJ_MASSHOU* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_FJ_TOUROKU* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_FJ_LOYA* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_FJ_ROYA* : uint32 = 0
const jsKeyEventDOM_VK_CIRCUMFLEX* : uint32 = 0
const jsKeyEventDOM_VK_EXCLAMATION* : uint32 = 0
const jsKeyEventDOM_VK_DOUBLE_QUOTE* : uint32 = 0
const jsKeyEventDOM_VK_HASH* : uint32 = 0
const jsKeyEventDOM_VK_DOLLAR* : uint32 = 0
const jsKeyEventDOM_VK_PERCENT* : uint32 = 0
const jsKeyEventDOM_VK_AMPERSAND* : uint32 = 0
const jsKeyEventDOM_VK_UNDERSCORE* : uint32 = 0
const jsKeyEventDOM_VK_OPEN_PAREN* : uint32 = 0
const jsKeyEventDOM_VK_CLOSE_PAREN* : uint32 = 0
const jsKeyEventDOM_VK_ASTERISK* : uint32 = 0
const jsKeyEventDOM_VK_PLUS* : uint32 = 0
const jsKeyEventDOM_VK_PIPE* : uint32 = 0
const jsKeyEventDOM_VK_HYPHEN_MINUS* : uint32 = 0
const jsKeyEventDOM_VK_OPEN_CURLY_BRACKET* : uint32 = 0
const jsKeyEventDOM_VK_CLOSE_CURLY_BRACKET* : uint32 = 0
const jsKeyEventDOM_VK_TILDE* : uint32 = 0
const jsKeyEventDOM_VK_VOLUME_MUTE* : uint32 = 0
const jsKeyEventDOM_VK_VOLUME_DOWN* : uint32 = 0
const jsKeyEventDOM_VK_VOLUME_UP* : uint32 = 0
const jsKeyEventDOM_VK_COMMA* : uint32 = 0
const jsKeyEventDOM_VK_PERIOD* : uint32 = 0
const jsKeyEventDOM_VK_SLASH* : uint32 = 0
const jsKeyEventDOM_VK_BACK_QUOTE* : uint32 = 0
const jsKeyEventDOM_VK_OPEN_BRACKET* : uint32 = 0
const jsKeyEventDOM_VK_BACK_SLASH* : uint32 = 0
const jsKeyEventDOM_VK_CLOSE_BRACKET* : uint32 = 0
const jsKeyEventDOM_VK_QUOTE* : uint32 = 0
const jsKeyEventDOM_VK_META* : uint32 = 0
const jsKeyEventDOM_VK_ALTGR* : uint32 = 0
const jsKeyEventDOM_VK_WIN_ICO_HELP* : uint32 = 0
const jsKeyEventDOM_VK_WIN_ICO_00* : uint32 = 0
const jsKeyEventDOM_VK_PROCESSKEY* : uint32 = 0
const jsKeyEventDOM_VK_WIN_ICO_CLEAR* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_RESET* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_JUMP* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_PA1* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_PA2* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_PA3* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_WSCTRL* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_CUSEL* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_ATTN* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_FINISH* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_COPY* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_AUTO* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_ENLW* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_BACKTAB* : uint32 = 0
const jsKeyEventDOM_VK_ATTN* : uint32 = 0
const jsKeyEventDOM_VK_CRSEL* : uint32 = 0
const jsKeyEventDOM_VK_EXSEL* : uint32 = 0
const jsKeyEventDOM_VK_EREOF* : uint32 = 0
const jsKeyEventDOM_VK_PLAY* : uint32 = 0
const jsKeyEventDOM_VK_ZOOM* : uint32 = 0
const jsKeyEventDOM_VK_PA1* : uint32 = 0
const jsKeyEventDOM_VK_WIN_OEM_CLEAR* : uint32 = 0
proc jsInitKeyEvent*(self: KeyEvent; typeVal: cstring; canBubble: bool; cancelable: bool; view: Option[JsObject]; ctrlKey: bool; altKey: bool; shiftKey: bool; metaKey: bool; keyCode: uint32; charCode: uint32): void =
  discard

proc jsKeyboardEventCharCode*(self: KeyboardEvent): uint32 =
  discard
proc jsKeyboardEventKeyCode*(self: KeyboardEvent): uint32 =
  discard
proc jsKeyboardEventAltKey*(self: KeyboardEvent): bool =
  discard
proc jsKeyboardEventCtrlKey*(self: KeyboardEvent): bool =
  discard
proc jsKeyboardEventShiftKey*(self: KeyboardEvent): bool =
  discard
proc jsKeyboardEventMetaKey*(self: KeyboardEvent): bool =
  discard
const jsKeyboardEventDOM_KEY_LOCATION_STANDARD* : uint32 = 0
const jsKeyboardEventDOM_KEY_LOCATION_LEFT* : uint32 = 0
const jsKeyboardEventDOM_KEY_LOCATION_RIGHT* : uint32 = 0
const jsKeyboardEventDOM_KEY_LOCATION_NUMPAD* : uint32 = 0
proc jsKeyboardEventLocation*(self: KeyboardEvent): uint32 =
  discard
proc jsKeyboardEventRepeat*(self: KeyboardEvent): bool =
  discard
proc jsKeyboardEventIsComposing*(self: KeyboardEvent): bool =
  discard
proc jsKeyboardEventKey*(self: KeyboardEvent): cstring =
  discard
proc jsKeyboardEventCode*(self: KeyboardEvent): cstring =
  discard
proc jsKeyboardEventInitDict*(self: KeyboardEvent): JsObject =
  discard
proc jsGetModifierState*(self: KeyboardEvent; key: cstring): bool =
  discard
proc jsInitKeyboardEvent*(self: KeyboardEvent; typeArg: cstring; bubblesArg: bool; cancelableArg: bool; viewArg: Option[JsObject]; keyArg: cstring; locationArg: uint32; ctrlKey: bool; altKey: bool; shiftKey: bool; metaKey: bool): void =
  discard

proc jsKeyframeEffectIterationComposite*(self: KeyframeEffect): JsObject =
  discard
proc jsKeyframeEffectComposite*(self: KeyframeEffect): JsObject =
  discard
proc jsGetKeyframes*(self: KeyframeEffect): JsObject =
  discard
proc jsSetKeyframes*(self: KeyframeEffect; keyframes: Option[JsObject]): void =
  discard

proc jsGetRowCount*(self: ListBoxObject): int32 =
  discard
proc jsGetRowHeight*(self: ListBoxObject): int32 =
  discard
proc jsGetNumberOfVisibleRows*(self: ListBoxObject): int32 =
  discard
proc jsGetIndexOfFirstVisibleRow*(self: ListBoxObject): int32 =
  discard
proc jsEnsureIndexIsVisible*(self: ListBoxObject; rowIndex: int32): void =
  discard
proc jsScrollToIndex*(self: ListBoxObject; rowIndex: int32): void =
  discard
proc jsScrollByLines*(self: ListBoxObject; numLines: int32): void =
  discard
proc jsGetItemAtIndex*(self: ListBoxObject; index: int32): Option[JsObject] =
  discard
proc jsGetIndexOfItem*(self: ListBoxObject; item: JsObject): int32 =
  discard

proc jsStop*(self: LocalMediaStream): void =
  discard

proc jsLocationHref*(self: Location): cstring =
  discard
proc jsLocationOrigin*(self: Location): cstring =
  discard
proc jsLocationProtocol*(self: Location): cstring =
  discard
proc jsLocationHost*(self: Location): cstring =
  discard
proc jsLocationHostname*(self: Location): cstring =
  discard
proc jsLocationPort*(self: Location): cstring =
  discard
proc jsLocationPathname*(self: Location): cstring =
  discard
proc jsLocationSearch*(self: Location): cstring =
  discard
proc jsLocationHash*(self: Location): cstring =
  discard
proc jsAssign*(self: Location; url: cstring): void =
  discard
proc jsReplace*(self: Location; url: cstring): void =
  discard
proc jsReload*(self: Location; forceget: bool): void =
  discard

proc jsMIDIAccessInputs*(self: MIDIAccess): JsObject =
  discard
proc jsMIDIAccessOutputs*(self: MIDIAccess): JsObject =
  discard
proc jsMIDIAccessOnstatechange*(self: MIDIAccess): JsObject =
  discard
proc jsMIDIAccessSysexEnabled*(self: MIDIAccess): bool =
  discard


proc jsMIDIInputOnmidimessage*(self: MIDIInput): JsObject =
  discard



proc jsSend*(self: MIDIOutput; data: JsObject; timestamp: JsObject): void =
  discard
proc jsClear*(self: MIDIOutput): void =
  discard


proc jsMIDIPortId*(self: MIDIPort): cstring =
  discard
proc jsMIDIPortTypeVal*(self: MIDIPort): JsObject =
  discard
proc jsMIDIPortState*(self: MIDIPort): JsObject =
  discard
proc jsMIDIPortConnection*(self: MIDIPort): JsObject =
  discard
proc jsMIDIPortOnstatechange*(self: MIDIPort): JsObject =
  discard
proc jsOpen*(self: MIDIPort): JsObject =
  discard
proc jsClose*(self: MIDIPort): JsObject =
  discard


proc jsMediaCapabilitiesInfoSupported*(self: MediaCapabilitiesInfo): bool =
  discard
proc jsMediaCapabilitiesInfoSmooth*(self: MediaCapabilitiesInfo): bool =
  discard
proc jsMediaCapabilitiesInfoPowerEfficient*(self: MediaCapabilitiesInfo): bool =
  discard

proc jsDecodingInfo*(self: MediaCapabilities; configuration: JsObject): JsObject =
  discard
proc jsEncodingInfo*(self: MediaCapabilities; configuration: JsObject): JsObject =
  discard

proc jsMediaDeviceInfoDeviceId*(self: MediaDeviceInfo): cstring =
  discard
proc jsMediaDeviceInfoKind*(self: MediaDeviceInfo): JsObject =
  discard
proc jsMediaDeviceInfoLabel*(self: MediaDeviceInfo): cstring =
  discard
proc jsMediaDeviceInfoGroupId*(self: MediaDeviceInfo): cstring =
  discard
proc jsToJSON*(self: MediaDeviceInfo): JsObject =
  discard

proc jsMediaDevicesOndevicechange*(self: MediaDevices): JsObject =
  discard
proc jsGetSupportedConstraints*(self: MediaDevices): JsObject =
  discard
proc jsEnumerateDevices*(self: MediaDevices): JsObject =
  discard
proc jsGetUserMedia*(self: MediaDevices; constraints: JsObject): JsObject =
  discard
proc jsGetDisplayMedia*(self: MediaDevices; constraints: JsObject): JsObject =
  discard


proc jsMediaEncryptedEventInitDataType*(self: MediaEncryptedEvent): cstring =
  discard

const jsMediaErrorMEDIA_ERR_ABORTED* : uint16 = 0
const jsMediaErrorMEDIA_ERR_NETWORK* : uint16 = 0
const jsMediaErrorMEDIA_ERR_DECODE* : uint16 = 0
const jsMediaErrorMEDIA_ERR_SRC_NOT_SUPPORTED* : uint16 = 0
proc jsMediaErrorCode*(self: MediaError): uint16 =
  discard
proc jsMediaErrorMessage*(self: MediaError): cstring =
  discard

proc jsMediaKeyErrorSystemCode*(self: MediaKeyError): uint32 =
  discard

proc jsMediaKeyMessageEventMessageType*(self: MediaKeyMessageEvent): JsObject =
  discard
proc jsMediaKeyMessageEventMessage*(self: MediaKeyMessageEvent): JsObject =
  discard

proc jsMediaKeySessionSessionId*(self: MediaKeySession): cstring =
  discard
proc jsMediaKeySessionExpiration*(self: MediaKeySession): float64 =
  discard
proc jsMediaKeySessionClosed*(self: MediaKeySession): JsObject =
  discard
proc jsMediaKeySessionKeyStatuses*(self: MediaKeySession): JsObject =
  discard
proc jsMediaKeySessionOnkeystatuseschange*(self: MediaKeySession): JsObject =
  discard
proc jsMediaKeySessionOnmessage*(self: MediaKeySession): JsObject =
  discard
proc jsGenerateRequest*(self: MediaKeySession; initDataType: cstring; initData: JsObject): JsObject =
  discard
proc jsLoad*(self: MediaKeySession; sessionId: cstring): JsObject =
  discard
proc jsUpdate*(self: MediaKeySession; response: JsObject): JsObject =
  discard
proc jsClose*(self: MediaKeySession): JsObject =
  discard
proc jsRemove*(self: MediaKeySession): JsObject =
  discard

proc jsMediaKeyStatusMapSize*(self: MediaKeyStatusMap): uint32 =
  discard
proc jsHas*(self: MediaKeyStatusMap; keyId: JsObject): bool =
  discard
proc jsGet*(self: MediaKeyStatusMap; keyId: JsObject): JsObject =
  discard

proc jsMediaKeySystemAccessKeySystem*(self: MediaKeySystemAccess): cstring =
  discard
proc jsGetConfiguration*(self: MediaKeySystemAccess): JsObject =
  discard
proc jsCreateMediaKeys*(self: MediaKeySystemAccess): JsObject =
  discard

proc jsMediaKeysKeySystem*(self: MediaKeys): cstring =
  discard
proc jsCreateSession*(self: MediaKeys; sessionType: JsObject): JsObject =
  discard
proc jsSetServerCertificate*(self: MediaKeys; serverCertificate: JsObject): JsObject =
  discard
proc jsGetStatusForPolicy*(self: MediaKeys; policy: JsObject): JsObject =
  discard

proc jsMediaListMediaText*(self: MediaList): cstring =
  discard
proc jsMediaListLength*(self: MediaList): uint32 =
  discard
proc jsItem*(self: MediaList; index: uint32): Option[cstring] =
  discard
proc jsDeleteMedium*(self: MediaList; oldMedium: cstring): void =
  discard
proc jsAppendMedium*(self: MediaList; newMedium: cstring): void =
  discard

proc jsMediaQueryListMedia*(self: MediaQueryList): cstring =
  discard
proc jsMediaQueryListMatches*(self: MediaQueryList): bool =
  discard
proc jsMediaQueryListOnchange*(self: MediaQueryList): JsObject =
  discard
proc jsAddListener*(self: MediaQueryList; listener: Option[JsObject]): void =
  discard
proc jsRemoveListener*(self: MediaQueryList; listener: Option[JsObject]): void =
  discard

proc jsMediaQueryListEventMedia*(self: MediaQueryListEvent): cstring =
  discard
proc jsMediaQueryListEventMatches*(self: MediaQueryListEvent): bool =
  discard

proc jsMediaRecorderStream*(self: MediaRecorder): JsObject =
  discard
proc jsMediaRecorderState*(self: MediaRecorder): JsObject =
  discard
proc jsMediaRecorderMimeType*(self: MediaRecorder): cstring =
  discard
proc jsMediaRecorderOndataavailable*(self: MediaRecorder): JsObject =
  discard
proc jsMediaRecorderOnerror*(self: MediaRecorder): JsObject =
  discard
proc jsMediaRecorderOnpause*(self: MediaRecorder): JsObject =
  discard
proc jsMediaRecorderOnresume*(self: MediaRecorder): JsObject =
  discard
proc jsMediaRecorderOnstart*(self: MediaRecorder): JsObject =
  discard
proc jsMediaRecorderOnstop*(self: MediaRecorder): JsObject =
  discard
proc jsMediaRecorderVideoBitsPerSecond*(self: MediaRecorder): uint32 =
  discard
proc jsMediaRecorderAudioBitsPerSecond*(self: MediaRecorder): uint32 =
  discard
proc jsMediaRecorderAudioBitrateMode*(self: MediaRecorder): JsObject =
  discard
proc jsStart*(self: MediaRecorder; timeSlice: int32): void =
  discard
proc jsStop*(self: MediaRecorder): void =
  discard
proc jsPause*(self: MediaRecorder): void =
  discard
proc jsResume*(self: MediaRecorder): void =
  discard
proc jsRequestData*(self: MediaRecorder): void =
  discard
proc jsIsTypeSupported*(self: typedesc[MediaRecorder]; typeVal: cstring): bool =
  discard

proc jsMediaRecorderErrorEventError*(self: MediaRecorderErrorEvent): JsObject =
  discard

proc jsMediaSourceSourceBuffers*(self: MediaSource): JsObject =
  discard
proc jsMediaSourceActiveSourceBuffers*(self: MediaSource): JsObject =
  discard
proc jsMediaSourceReadyState*(self: MediaSource): JsObject =
  discard
proc jsMediaSourceDuration*(self: MediaSource): float64 =
  discard
proc jsMediaSourceOnsourceopen*(self: MediaSource): JsObject =
  discard
proc jsMediaSourceOnsourceended*(self: MediaSource): JsObject =
  discard
proc jsMediaSourceOnsourceclose*(self: MediaSource): JsObject =
  discard
proc jsAddSourceBuffer*(self: MediaSource; typeVal: cstring): JsObject =
  discard
proc jsRemoveSourceBuffer*(self: MediaSource; sourceBuffer: JsObject): void =
  discard
proc jsEndOfStream*(self: MediaSource; error: JsObject): void =
  discard
proc jsSetLiveSeekableRange*(self: MediaSource; start: float64; endVal: float64): void =
  discard
proc jsClearLiveSeekableRange*(self: MediaSource): void =
  discard
proc jsIsTypeSupported*(self: typedesc[MediaSource]; typeVal: cstring): bool =
  discard

proc jsMediaStreamId*(self: MediaStream): cstring =
  discard
proc jsMediaStreamActive*(self: MediaStream): bool =
  discard
proc jsMediaStreamOnaddtrack*(self: MediaStream): JsObject =
  discard
proc jsMediaStreamOnremovetrack*(self: MediaStream): JsObject =
  discard
proc jsMediaStreamCurrentTime*(self: MediaStream): float64 =
  discard
proc jsGetAudioTracks*(self: MediaStream): JsObject =
  discard
proc jsGetVideoTracks*(self: MediaStream): JsObject =
  discard
proc jsGetTracks*(self: MediaStream): JsObject =
  discard
proc jsGetTrackById*(self: MediaStream; trackId: cstring): Option[JsObject] =
  discard
proc jsAddTrack*(self: MediaStream; track: JsObject): void =
  discard
proc jsRemoveTrack*(self: MediaStream; track: JsObject): void =
  discard
proc jsClone*(self: MediaStream): JsObject =
  discard
proc jsCountUnderlyingStreams*(self: typedesc[MediaStream]): JsObject =
  discard
proc jsAssignId*(self: MediaStream; id: cstring): void =
  discard

proc jsMediaStreamAudioDestinationNodeStream*(self: MediaStreamAudioDestinationNode): JsObject =
  discard


proc jsMediaStreamErrorName*(self: MediaStreamError): cstring =
  discard


proc jsMediaStreamTrackKind*(self: MediaStreamTrack): cstring =
  discard
proc jsMediaStreamTrackId*(self: MediaStreamTrack): cstring =
  discard
proc jsMediaStreamTrackLabel*(self: MediaStreamTrack): cstring =
  discard
proc jsMediaStreamTrackEnabled*(self: MediaStreamTrack): bool =
  discard
proc jsMediaStreamTrackMuted*(self: MediaStreamTrack): bool =
  discard
proc jsMediaStreamTrackOnmute*(self: MediaStreamTrack): JsObject =
  discard
proc jsMediaStreamTrackOnunmute*(self: MediaStreamTrack): JsObject =
  discard
proc jsMediaStreamTrackReadyState*(self: MediaStreamTrack): JsObject =
  discard
proc jsMediaStreamTrackOnended*(self: MediaStreamTrack): JsObject =
  discard
proc jsClone*(self: MediaStreamTrack): JsObject =
  discard
proc jsStop*(self: MediaStreamTrack): void =
  discard
proc jsGetConstraints*(self: MediaStreamTrack): JsObject =
  discard
proc jsGetSettings*(self: MediaStreamTrack): JsObject =
  discard
proc jsApplyConstraints*(self: MediaStreamTrack; constraints: JsObject): JsObject =
  discard
proc jsMutedChanged*(self: MediaStreamTrack; muted: bool): void =
  discard

proc jsMediaStreamTrackEventTrack*(self: MediaStreamTrackEvent): JsObject =
  discard

proc jsMessageChannelPort1*(self: MessageChannel): JsObject =
  discard
proc jsMessageChannelPort2*(self: MessageChannel): JsObject =
  discard

proc jsMessageEventData*(self: MessageEvent): JsObject =
  discard
proc jsMessageEventOrigin*(self: MessageEvent): cstring =
  discard
proc jsMessageEventLastEventId*(self: MessageEvent): cstring =
  discard
proc jsMessageEventPorts*(self: MessageEvent): JsObject =
  discard
proc jsInitMessageEvent*(self: MessageEvent; typeVal: cstring; bubbles: bool; cancelable: bool; data: JsObject; origin: cstring; lastEventId: cstring; source: Option[JsObject]; ports: JsObject): void =
  discard

proc jsMessagePortOnmessage*(self: MessagePort): JsObject =
  discard
proc jsMessagePortOnmessageerror*(self: MessagePort): JsObject =
  discard
proc jsPostMessage*(self: MessagePort; message: JsObject; transferable: JsObject): void =
  discard
proc jsStart*(self: MessagePort): void =
  discard
proc jsClose*(self: MessagePort): void =
  discard

proc jsMimeTypeDescription*(self: MimeType): cstring =
  discard
proc jsMimeTypeSuffixes*(self: MimeType): cstring =
  discard
proc jsMimeTypeTypeVal*(self: MimeType): cstring =
  discard

proc jsMimeTypeArrayLength*(self: MimeTypeArray): uint32 =
  discard
proc jsItem*(self: MimeTypeArray; index: uint32): Option[JsObject] =
  discard
proc jsNamedItem*(self: MimeTypeArray; name: cstring): Option[JsObject] =
  discard

proc jsMouseEventScreenX*(self: MouseEvent): int32 =
  discard
proc jsMouseEventScreenY*(self: MouseEvent): int32 =
  discard
proc jsMouseEventClientX*(self: MouseEvent): int32 =
  discard
proc jsMouseEventClientY*(self: MouseEvent): int32 =
  discard
proc jsMouseEventX*(self: MouseEvent): int32 =
  discard
proc jsMouseEventY*(self: MouseEvent): int32 =
  discard
proc jsMouseEventOffsetX*(self: MouseEvent): int32 =
  discard
proc jsMouseEventOffsetY*(self: MouseEvent): int32 =
  discard
proc jsMouseEventPageX*(self: MouseEvent): int32 =
  discard
proc jsMouseEventPageY*(self: MouseEvent): int32 =
  discard
proc jsMouseEventCtrlKey*(self: MouseEvent): bool =
  discard
proc jsMouseEventShiftKey*(self: MouseEvent): bool =
  discard
proc jsMouseEventAltKey*(self: MouseEvent): bool =
  discard
proc jsMouseEventMetaKey*(self: MouseEvent): bool =
  discard
proc jsMouseEventButton*(self: MouseEvent): int16 =
  discard
proc jsMouseEventButtons*(self: MouseEvent): uint16 =
  discard
proc jsMouseEventMovementX*(self: MouseEvent): int32 =
  discard
proc jsMouseEventMovementY*(self: MouseEvent): int32 =
  discard
proc jsInitMouseEvent*(self: MouseEvent; typeArg: cstring; canBubbleArg: bool; cancelableArg: bool; viewArg: Option[JsObject]; detailArg: int32; screenXArg: int32; screenYArg: int32; clientXArg: int32; clientYArg: int32; ctrlKeyArg: bool; altKeyArg: bool; shiftKeyArg: bool; metaKeyArg: bool; buttonArg: int16; relatedTargetArg: Option[JsObject]): void =
  discard
proc jsGetModifierState*(self: MouseEvent; keyArg: cstring): bool =
  discard

const jsMouseScrollEventHORIZONTAL_AXIS* : int32 = 0
const jsMouseScrollEventVERTICAL_AXIS* : int32 = 0
proc jsMouseScrollEventAxis*(self: MouseScrollEvent): int32 =
  discard
proc jsInitMouseScrollEvent*(self: MouseScrollEvent; typeVal: cstring; canBubble: bool; cancelable: bool; view: Option[JsObject]; detail: int32; screenX: int32; screenY: int32; clientX: int32; clientY: int32; ctrlKey: bool; altKey: bool; shiftKey: bool; metaKey: bool; button: int16; relatedTarget: Option[JsObject]; axis: int32): void =
  discard

const jsMutationEventMODIFICATION* : uint16 = 0
const jsMutationEventADDITION* : uint16 = 0
const jsMutationEventREMOVAL* : uint16 = 0
const jsMutationEventSMIL* : uint16 = 0
proc jsMutationEventPrevValue*(self: MutationEvent): cstring =
  discard
proc jsMutationEventNewValue*(self: MutationEvent): cstring =
  discard
proc jsMutationEventAttrName*(self: MutationEvent): cstring =
  discard
proc jsMutationEventAttrChange*(self: MutationEvent): uint16 =
  discard
proc jsInitMutationEvent*(self: MutationEvent; typeVal: cstring; canBubble: bool; cancelable: bool; relatedNode: Option[JsObject]; prevValue: cstring; newValue: cstring; attrName: cstring; attrChange: uint16): void =
  discard

proc jsMutationRecordTypeVal*(self: MutationRecord): cstring =
  discard
proc jsMutationRecordAddedNodes*(self: MutationRecord): JsObject =
  discard
proc jsMutationRecordRemovedNodes*(self: MutationRecord): JsObject =
  discard
proc jsMutationRecordAddedAnimations*(self: MutationRecord): JsObject =
  discard
proc jsMutationRecordChangedAnimations*(self: MutationRecord): JsObject =
  discard
proc jsMutationRecordRemovedAnimations*(self: MutationRecord): JsObject =
  discard

proc jsMutationObserverMutationCallback*(self: MutationObserver): JsObject =
  discard
proc jsMutationObserverMergeAttributeRecords*(self: MutationObserver): bool =
  discard
proc jsObserve*(self: MutationObserver; target: JsObject; options: JsObject): void =
  discard
proc jsDisconnect*(self: MutationObserver): void =
  discard
proc jsTakeRecords*(self: MutationObserver): JsObject =
  discard
proc jsGetObservingInfo*(self: MutationObserver): JsObject =
  discard

proc jsNamedNodeMapLength*(self: NamedNodeMap): uint32 =
  discard
proc jsGetNamedItem*(self: NamedNodeMap; name: cstring): Option[JsObject] =
  discard
proc jsSetNamedItem*(self: NamedNodeMap; arg: JsObject): Option[JsObject] =
  discard
proc jsRemoveNamedItem*(self: NamedNodeMap; name: cstring): JsObject =
  discard
proc jsItem*(self: NamedNodeMap; index: uint32): Option[JsObject] =
  discard
proc jsGetNamedItemNS*(self: NamedNodeMap; namespaceURI: Option[cstring]; localName: cstring): Option[JsObject] =
  discard
proc jsSetNamedItemNS*(self: NamedNodeMap; arg: JsObject): Option[JsObject] =
  discard
proc jsRemoveNamedItemNS*(self: NamedNodeMap; namespaceURI: Option[cstring]; localName: cstring): JsObject =
  discard


proc jsNavigatorAutomationInformationWebdriver*(self: NavigatorAutomationInformation): bool =
  discard

proc jsNetworkInformationTypeVal*(self: NetworkInformation): JsObject =
  discard
proc jsNetworkInformationOntypechange*(self: NetworkInformation): JsObject =
  discard

const jsNodeELEMENT_NODE* : uint16 = 0
const jsNodeATTRIBUTE_NODE* : uint16 = 0
const jsNodeTEXT_NODE* : uint16 = 0
const jsNodeCDATA_SECTION_NODE* : uint16 = 0
const jsNodeENTITY_REFERENCE_NODE* : uint16 = 0
const jsNodeENTITY_NODE* : uint16 = 0
const jsNodePROCESSING_INSTRUCTION_NODE* : uint16 = 0
const jsNodeCOMMENT_NODE* : uint16 = 0
const jsNodeDOCUMENT_NODE* : uint16 = 0
const jsNodeDOCUMENT_TYPE_NODE* : uint16 = 0
const jsNodeDOCUMENT_FRAGMENT_NODE* : uint16 = 0
const jsNodeNOTATION_NODE* : uint16 = 0
proc jsNodeNodeType*(self: Node): uint16 =
  discard
proc jsNodeNodeName*(self: Node): cstring =
  discard
proc jsNodeIsConnected*(self: Node): bool =
  discard
proc jsNodeChildNodes*(self: Node): JsObject =
  discard
const jsNodeDOCUMENT_POSITION_DISCONNECTED* : uint16 = 0
const jsNodeDOCUMENT_POSITION_PRECEDING* : uint16 = 0
const jsNodeDOCUMENT_POSITION_FOLLOWING* : uint16 = 0
const jsNodeDOCUMENT_POSITION_CONTAINS* : uint16 = 0
const jsNodeDOCUMENT_POSITION_CONTAINED_BY* : uint16 = 0
const jsNodeDOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC* : uint16 = 0
proc jsGetRootNode*(self: Node; options: JsObject): JsObject =
  discard
proc jsHasChildNodes*(self: Node): bool =
  discard
proc jsInsertBefore*(self: Node; node: JsObject; child: Option[JsObject]): JsObject =
  discard
proc jsAppendChild*(self: Node; node: JsObject): JsObject =
  discard
proc jsReplaceChild*(self: Node; node: JsObject; child: JsObject): JsObject =
  discard
proc jsRemoveChild*(self: Node; child: JsObject): JsObject =
  discard
proc jsNormalize*(self: Node): void =
  discard
proc jsCloneNode*(self: Node; deep: bool): JsObject =
  discard
proc jsIsSameNode*(self: Node; node: Option[JsObject]): bool =
  discard
proc jsIsEqualNode*(self: Node; node: Option[JsObject]): bool =
  discard
proc jsCompareDocumentPosition*(self: Node; other: JsObject): uint16 =
  discard
proc jsContains*(self: Node; other: Option[JsObject]): bool =
  discard
proc jsLookupPrefix*(self: Node; namespace: Option[cstring]): Option[cstring] =
  discard
proc jsLookupNamespaceURI*(self: Node; prefix: Option[cstring]): Option[cstring] =
  discard
proc jsIsDefaultNamespace*(self: Node; namespace: Option[cstring]): bool =
  discard

proc jsNodeIteratorRoot*(self: NodeIterator): JsObject =
  discard
proc jsNodeIteratorPointerBeforeReferenceNode*(self: NodeIterator): bool =
  discard
proc jsNodeIteratorWhatToShow*(self: NodeIterator): uint32 =
  discard
proc jsNextNode*(self: NodeIterator): Option[JsObject] =
  discard
proc jsPreviousNode*(self: NodeIterator): Option[JsObject] =
  discard
proc jsDetach*(self: NodeIterator): void =
  discard

proc jsNodeListLength*(self: NodeList): uint32 =
  discard
proc jsItem*(self: NodeList; index: uint32): Option[JsObject] =
  discard

proc jsNotificationPermission*(self: Notification): JsObject =
  discard
proc jsNotificationMaxActions*(self: Notification): uint32 =
  discard
proc jsNotificationOnclick*(self: Notification): JsObject =
  discard
proc jsNotificationOnshow*(self: Notification): JsObject =
  discard
proc jsNotificationOnerror*(self: Notification): JsObject =
  discard
proc jsNotificationOnclose*(self: Notification): JsObject =
  discard
proc jsNotificationTitle*(self: Notification): cstring =
  discard
proc jsNotificationDir*(self: Notification): JsObject =
  discard
proc jsNotificationImage*(self: Notification): cstring =
  discard
proc jsNotificationBadge*(self: Notification): cstring =
  discard
proc jsNotificationVibrate*(self: Notification): JsObject =
  discard
proc jsNotificationTimestamp*(self: Notification): uint64 =
  discard
proc jsNotificationRenotify*(self: Notification): bool =
  discard
proc jsNotificationRequireInteraction*(self: Notification): bool =
  discard
proc jsNotificationData*(self: Notification): JsObject =
  discard
proc jsNotificationActions*(self: Notification): JsObject =
  discard
proc jsRequestPermission*(self: typedesc[Notification]; permissionCallback: JsObject): JsObject =
  discard
proc jsClose*(self: Notification): void =
  discard

proc jsNotificationEventNotification*(self: NotificationEvent): JsObject =
  discard

proc jsNotifyPaintEventClientRects*(self: NotifyPaintEvent): JsObject =
  discard
proc jsNotifyPaintEventBoundingClientRect*(self: NotifyPaintEvent): JsObject =
  discard
proc jsNotifyPaintEventPaintRequests*(self: NotifyPaintEvent): JsObject =
  discard
proc jsNotifyPaintEventTransactionId*(self: NotifyPaintEvent): uint64 =
  discard
proc jsNotifyPaintEventPaintTimeStamp*(self: NotifyPaintEvent): JsObject =
  discard

proc jsFramebufferTextureMultiviewOVR*(self: OVR_multiview2; target: JsObject; attachment: JsObject; texture: Option[JsObject]; level: JsObject; baseViewIndex: JsObject; numViews: JsObject): void =
  discard

proc jsOfflineAudioCompletionEventRenderedBuffer*(self: OfflineAudioCompletionEvent): JsObject =
  discard

proc jsOfflineAudioContextLength*(self: OfflineAudioContext): uint32 =
  discard
proc jsOfflineAudioContextOncomplete*(self: OfflineAudioContext): JsObject =
  discard
proc jsStartRendering*(self: OfflineAudioContext): JsObject =
  discard

const jsOfflineResourceListUNCACHED* : uint16 = 0
const jsOfflineResourceListIDLE* : uint16 = 0
const jsOfflineResourceListCHECKING* : uint16 = 0
const jsOfflineResourceListDOWNLOADING* : uint16 = 0
const jsOfflineResourceListUPDATEREADY* : uint16 = 0
const jsOfflineResourceListOBSOLETE* : uint16 = 0
proc jsOfflineResourceListStatus*(self: OfflineResourceList): uint16 =
  discard
proc jsOfflineResourceListOnchecking*(self: OfflineResourceList): JsObject =
  discard
proc jsOfflineResourceListOnerror*(self: OfflineResourceList): JsObject =
  discard
proc jsOfflineResourceListOnnoupdate*(self: OfflineResourceList): JsObject =
  discard
proc jsOfflineResourceListOndownloading*(self: OfflineResourceList): JsObject =
  discard
proc jsOfflineResourceListOnprogress*(self: OfflineResourceList): JsObject =
  discard
proc jsOfflineResourceListOnupdateready*(self: OfflineResourceList): JsObject =
  discard
proc jsOfflineResourceListOncached*(self: OfflineResourceList): JsObject =
  discard
proc jsOfflineResourceListOnobsolete*(self: OfflineResourceList): JsObject =
  discard
proc jsUpdate*(self: OfflineResourceList): void =
  discard
proc jsSwapCache*(self: OfflineResourceList): void =
  discard

proc jsOffscreenCanvasWidth*(self: OffscreenCanvas): uint32 =
  discard
proc jsOffscreenCanvasHeight*(self: OffscreenCanvas): uint32 =
  discard
proc jsGetContext*(self: OffscreenCanvas; contextId: cstring; contextOptions: JsObject): Option[JsObject] =
  discard
proc jsTransferToImageBitmap*(self: OffscreenCanvas): JsObject =
  discard
proc jsConvertToBlob*(self: OffscreenCanvas; options: JsObject): JsObject =
  discard

proc jsOffscreenCanvasRenderingContext2DCanvas*(self: OffscreenCanvasRenderingContext2D): JsObject =
  discard

proc jsOscillatorNodeTypeVal*(self: OscillatorNode): JsObject =
  discard
proc jsOscillatorNodeFrequency*(self: OscillatorNode): JsObject =
  discard
proc jsOscillatorNodeDetune*(self: OscillatorNode): JsObject =
  discard
proc jsSetPeriodicWave*(self: OscillatorNode; periodicWave: JsObject): void =
  discard

proc jsPageTransitionEventPersisted*(self: PageTransitionEvent): bool =
  discard
proc jsPageTransitionEventInFrameSwap*(self: PageTransitionEvent): bool =
  discard

proc jsPaintRequestClientRect*(self: PaintRequest): JsObject =
  discard
proc jsPaintRequestReason*(self: PaintRequest): cstring =
  discard

proc jsPaintRequestListLength*(self: PaintRequestList): uint32 =
  discard
proc jsItem*(self: PaintRequestList; index: uint32): Option[JsObject] =
  discard

proc jsRegisterPaint*(self: PaintWorkletGlobalScope; name: cstring; paintCtor: JsObject): void =
  discard

proc jsPannerNodePanningModel*(self: PannerNode): JsObject =
  discard
proc jsPannerNodePositionX*(self: PannerNode): JsObject =
  discard
proc jsPannerNodePositionY*(self: PannerNode): JsObject =
  discard
proc jsPannerNodePositionZ*(self: PannerNode): JsObject =
  discard
proc jsPannerNodeOrientationX*(self: PannerNode): JsObject =
  discard
proc jsPannerNodeOrientationY*(self: PannerNode): JsObject =
  discard
proc jsPannerNodeOrientationZ*(self: PannerNode): JsObject =
  discard
proc jsPannerNodeDistanceModel*(self: PannerNode): JsObject =
  discard
proc jsPannerNodeRefDistance*(self: PannerNode): float64 =
  discard
proc jsPannerNodeMaxDistance*(self: PannerNode): float64 =
  discard
proc jsPannerNodeRolloffFactor*(self: PannerNode): float64 =
  discard
proc jsPannerNodeConeInnerAngle*(self: PannerNode): float64 =
  discard
proc jsPannerNodeConeOuterAngle*(self: PannerNode): float64 =
  discard
proc jsPannerNodeConeOuterGain*(self: PannerNode): float64 =
  discard
proc jsSetPosition*(self: PannerNode; x: float64; y: float64; z: float64): void =
  discard
proc jsSetOrientation*(self: PannerNode; x: float64; y: float64; z: float64): void =
  discard
proc jsSetVelocity*(self: PannerNode; x: float64; y: float64; z: float64): void =
  discard

proc jsPaymentAddressCountry*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressAddressLine*(self: PaymentAddress): JsObject =
  discard
proc jsPaymentAddressRegion*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressCity*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressDependentLocality*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressPostalCode*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressSortingCode*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressLanguageCode*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressOrganization*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressRecipient*(self: PaymentAddress): cstring =
  discard
proc jsPaymentAddressPhone*(self: PaymentAddress): cstring =
  discard
proc jsToJSON*(self: PaymentAddress): JsObject =
  discard

proc jsPaymentMethodChangeEventMethodName*(self: PaymentMethodChangeEvent): cstring =
  discard

proc jsUpdateWith*(self: PaymentRequestUpdateEvent; detailsPromise: JsObject): void =
  discard

proc jsPaymentResponseRequestId*(self: PaymentResponse): cstring =
  discard
proc jsPaymentResponseMethodName*(self: PaymentResponse): cstring =
  discard
proc jsPaymentResponseDetails*(self: PaymentResponse): JsObject =
  discard
proc jsToJSON*(self: PaymentResponse): JsObject =
  discard
proc jsComplete*(self: PaymentResponse; resultVal: JsObject): JsObject =
  discard

proc jsPerformanceTimeOrigin*(self: Performance): JsObject =
  discard
proc jsNow*(self: Performance): JsObject =
  discard

proc jsPerformanceEntryName*(self: PerformanceEntry): cstring =
  discard
proc jsPerformanceEntryEntryType*(self: PerformanceEntry): cstring =
  discard
proc jsPerformanceEntryStartTime*(self: PerformanceEntry): JsObject =
  discard
proc jsPerformanceEntryDuration*(self: PerformanceEntry): JsObject =
  discard
proc jsToJSON*(self: PerformanceEntry): JsObject =
  discard

proc jsPerformanceEntryEventName*(self: PerformanceEntryEvent): cstring =
  discard
proc jsPerformanceEntryEventEntryType*(self: PerformanceEntryEvent): cstring =
  discard
proc jsPerformanceEntryEventStartTime*(self: PerformanceEntryEvent): JsObject =
  discard
proc jsPerformanceEntryEventDuration*(self: PerformanceEntryEvent): JsObject =
  discard
proc jsPerformanceEntryEventEpoch*(self: PerformanceEntryEvent): float64 =
  discard
proc jsPerformanceEntryEventOrigin*(self: PerformanceEntryEvent): cstring =
  discard



const jsPerformanceNavigationTYPE_NAVIGATE* : uint16 = 0
const jsPerformanceNavigationTYPE_RELOAD* : uint16 = 0
const jsPerformanceNavigationTYPE_BACK_FORWARD* : uint16 = 0
const jsPerformanceNavigationTYPE_RESERVED* : uint16 = 0
proc jsPerformanceNavigationTypeVal*(self: PerformanceNavigation): uint16 =
  discard
proc jsPerformanceNavigationRedirectCount*(self: PerformanceNavigation): uint16 =
  discard
proc jsToJSON*(self: PerformanceNavigation): JsObject =
  discard

proc jsPerformanceNavigationTimingUnloadEventStart*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingUnloadEventEnd*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingDomInteractive*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingDomContentLoadedEventStart*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingDomContentLoadedEventEnd*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingDomComplete*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingLoadEventStart*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingLoadEventEnd*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingTypeVal*(self: PerformanceNavigationTiming): JsObject =
  discard
proc jsPerformanceNavigationTimingRedirectCount*(self: PerformanceNavigationTiming): uint16 =
  discard
proc jsToJSON*(self: PerformanceNavigationTiming): JsObject =
  discard

proc jsObserve*(self: PerformanceObserver; options: JsObject): void =
  discard
proc jsDisconnect*(self: PerformanceObserver): void =
  discard
proc jsTakeRecords*(self: PerformanceObserver): JsObject =
  discard

proc jsGetEntries*(self: PerformanceObserverEntryList; filter: JsObject): JsObject =
  discard
proc jsGetEntriesByType*(self: PerformanceObserverEntryList; entryType: cstring): JsObject =
  discard
proc jsGetEntriesByName*(self: PerformanceObserverEntryList; name: cstring; entryType: cstring): JsObject =
  discard

proc jsPerformanceResourceTimingInitiatorType*(self: PerformanceResourceTiming): cstring =
  discard
proc jsPerformanceResourceTimingNextHopProtocol*(self: PerformanceResourceTiming): cstring =
  discard
proc jsPerformanceResourceTimingWorkerStart*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingRedirectStart*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingRedirectEnd*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingFetchStart*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingDomainLookupStart*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingDomainLookupEnd*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingConnectStart*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingConnectEnd*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingSecureConnectionStart*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingRequestStart*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingResponseStart*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingResponseEnd*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsPerformanceResourceTimingTransferSize*(self: PerformanceResourceTiming): uint64 =
  discard
proc jsPerformanceResourceTimingEncodedBodySize*(self: PerformanceResourceTiming): uint64 =
  discard
proc jsPerformanceResourceTimingDecodedBodySize*(self: PerformanceResourceTiming): uint64 =
  discard
proc jsPerformanceResourceTimingServerTiming*(self: PerformanceResourceTiming): JsObject =
  discard
proc jsToJSON*(self: PerformanceResourceTiming): JsObject =
  discard

proc jsPerformanceServerTimingName*(self: PerformanceServerTiming): cstring =
  discard
proc jsPerformanceServerTimingDuration*(self: PerformanceServerTiming): JsObject =
  discard
proc jsPerformanceServerTimingDescription*(self: PerformanceServerTiming): cstring =
  discard
proc jsToJSON*(self: PerformanceServerTiming): JsObject =
  discard

proc jsPerformanceTimingNavigationStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingUnloadEventStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingUnloadEventEnd*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingRedirectStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingRedirectEnd*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingFetchStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingDomainLookupStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingDomainLookupEnd*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingConnectStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingConnectEnd*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingSecureConnectionStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingRequestStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingResponseStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingResponseEnd*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingDomLoading*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingDomInteractive*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingDomContentLoadedEventStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingDomContentLoadedEventEnd*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingDomComplete*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingLoadEventStart*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingLoadEventEnd*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingTimeToNonBlankPaint*(self: PerformanceTiming): uint64 =
  discard
proc jsPerformanceTimingTimeToDOMContentFlushed*(self: PerformanceTiming): uint64 =
  discard
proc jsToJSON*(self: PerformanceTiming): JsObject =
  discard


proc jsPermissionStatusState*(self: PermissionStatus): JsObject =
  discard
proc jsPermissionStatusOnchange*(self: PermissionStatus): JsObject =
  discard

proc jsQuery*(self: Permissions; permission: JsObject): JsObject =
  discard
proc jsRevoke*(self: Permissions; permission: JsObject): JsObject =
  discard

proc jsPluginDescription*(self: Plugin): cstring =
  discard
proc jsPluginFilename*(self: Plugin): cstring =
  discard
proc jsPluginVersion*(self: Plugin): cstring =
  discard
proc jsPluginName*(self: Plugin): cstring =
  discard
proc jsPluginLength*(self: Plugin): uint32 =
  discard
proc jsItem*(self: Plugin; index: uint32): Option[JsObject] =
  discard
proc jsNamedItem*(self: Plugin; name: cstring): Option[JsObject] =
  discard

proc jsPluginArrayLength*(self: PluginArray): uint32 =
  discard
proc jsItem*(self: PluginArray; index: uint32): Option[JsObject] =
  discard
proc jsNamedItem*(self: PluginArray; name: cstring): Option[JsObject] =
  discard
proc jsRefresh*(self: PluginArray; reloadDocuments: bool): void =
  discard

proc jsPluginCrashedEventPluginID*(self: PluginCrashedEvent): uint32 =
  discard
proc jsPluginCrashedEventPluginDumpID*(self: PluginCrashedEvent): cstring =
  discard
proc jsPluginCrashedEventPluginName*(self: PluginCrashedEvent): cstring =
  discard
proc jsPluginCrashedEventSubmittedCrashReport*(self: PluginCrashedEvent): bool =
  discard
proc jsPluginCrashedEventGmpPlugin*(self: PluginCrashedEvent): bool =
  discard

proc jsPointerEventPointerId*(self: PointerEvent): int32 =
  discard
proc jsPointerEventWidth*(self: PointerEvent): int32 =
  discard
proc jsPointerEventHeight*(self: PointerEvent): int32 =
  discard
proc jsPointerEventPressure*(self: PointerEvent): float32 =
  discard
proc jsPointerEventTangentialPressure*(self: PointerEvent): float32 =
  discard
proc jsPointerEventTiltX*(self: PointerEvent): int32 =
  discard
proc jsPointerEventTiltY*(self: PointerEvent): int32 =
  discard
proc jsPointerEventTwist*(self: PointerEvent): int32 =
  discard
proc jsPointerEventPointerType*(self: PointerEvent): cstring =
  discard
proc jsPointerEventIsPrimary*(self: PointerEvent): bool =
  discard
proc jsGetCoalescedEvents*(self: PointerEvent): JsObject =
  discard

proc jsPopStateEventState*(self: PopStateEvent): JsObject =
  discard


proc jsPositionCoords*(self: Position): JsObject =
  discard
proc jsPositionTimestamp*(self: Position): uint64 =
  discard

const jsPositionErrorPERMISSION_DENIED* : uint16 = 0
const jsPositionErrorPOSITION_UNAVAILABLE* : uint16 = 0
const jsPositionErrorTIMEOUT* : uint16 = 0
proc jsPositionErrorCode*(self: PositionError): uint16 =
  discard
proc jsPositionErrorMessage*(self: PositionError): cstring =
  discard


proc jsPresentationAvailabilityValue*(self: PresentationAvailability): bool =
  discard
proc jsPresentationAvailabilityOnchange*(self: PresentationAvailability): JsObject =
  discard

proc jsPresentationConnectionId*(self: PresentationConnection): cstring =
  discard
proc jsPresentationConnectionUrl*(self: PresentationConnection): cstring =
  discard
proc jsPresentationConnectionState*(self: PresentationConnection): JsObject =
  discard
proc jsPresentationConnectionOnconnect*(self: PresentationConnection): JsObject =
  discard
proc jsPresentationConnectionOnclose*(self: PresentationConnection): JsObject =
  discard
proc jsPresentationConnectionOnterminate*(self: PresentationConnection): JsObject =
  discard
proc jsPresentationConnectionBinaryType*(self: PresentationConnection): JsObject =
  discard
proc jsPresentationConnectionOnmessage*(self: PresentationConnection): JsObject =
  discard
proc jsSend*(self: PresentationConnection; data: cstring): void =
  discard
proc jsSend*(self: PresentationConnection; data: JsObject): void =
  discard
proc jsClose*(self: PresentationConnection): void =
  discard
proc jsTerminate*(self: PresentationConnection): void =
  discard

proc jsPresentationConnectionAvailableEventConnection*(self: PresentationConnectionAvailableEvent): JsObject =
  discard

proc jsPresentationConnectionCloseEventReason*(self: PresentationConnectionCloseEvent): JsObject =
  discard
proc jsPresentationConnectionCloseEventMessage*(self: PresentationConnectionCloseEvent): cstring =
  discard

proc jsPresentationConnectionListConnections*(self: PresentationConnectionList): JsObject =
  discard
proc jsPresentationConnectionListOnconnectionavailable*(self: PresentationConnectionList): JsObject =
  discard

proc jsPresentationReceiverConnectionList*(self: PresentationReceiver): JsObject =
  discard

proc jsPresentationRequestOnconnectionavailable*(self: PresentationRequest): JsObject =
  discard
proc jsStart*(self: PresentationRequest): JsObject =
  discard
proc jsReconnect*(self: PresentationRequest; presentationId: cstring): JsObject =
  discard
proc jsGetAvailability*(self: PresentationRequest): JsObject =
  discard
proc jsStartWithDevice*(self: PresentationRequest; deviceId: cstring): JsObject =
  discard

proc jsProcessingInstructionTarget*(self: ProcessingInstruction): cstring =
  discard

proc jsProgressEventLengthComputable*(self: ProgressEvent): bool =
  discard
proc jsProgressEventLoaded*(self: ProgressEvent): uint64 =
  discard
proc jsProgressEventTotal*(self: ProgressEvent): uint64 =
  discard


proc jsPromiseRejectionEventPromise*(self: PromiseRejectionEvent): JsObject =
  discard
proc jsPromiseRejectionEventReason*(self: PromiseRejectionEvent): JsObject =
  discard


proc jsSubscribe*(self: PushManagerImpl; options: JsObject): JsObject =
  discard
proc jsGetSubscription*(self: PushManagerImpl): JsObject =
  discard
proc jsPermissionState*(self: PushManagerImpl; options: JsObject): JsObject =
  discard

proc jsSubscribe*(self: PushManager; options: JsObject): JsObject =
  discard
proc jsGetSubscription*(self: PushManager): JsObject =
  discard
proc jsPermissionState*(self: PushManager; options: JsObject): JsObject =
  discard

proc jsArrayBuffer*(self: PushMessageData): JsObject =
  discard
proc jsBlob*(self: PushMessageData): JsObject =
  discard
proc jsJson*(self: PushMessageData): JsObject =
  discard
proc jsText*(self: PushMessageData): cstring =
  discard

proc jsPushSubscriptionEndpoint*(self: PushSubscription): cstring =
  discard
proc jsPushSubscriptionOptions*(self: PushSubscription): JsObject =
  discard
proc jsGetKey*(self: PushSubscription; name: JsObject): Option[JsObject] =
  discard
proc jsUnsubscribe*(self: PushSubscription): JsObject =
  discard
proc jsToJSON*(self: PushSubscription): JsObject =
  discard


proc jsRTCCertificateExpires*(self: RTCCertificate): uint64 =
  discard

proc jsRTCDTMFSenderOntonechange*(self: RTCDTMFSender): JsObject =
  discard
proc jsRTCDTMFSenderToneBuffer*(self: RTCDTMFSender): cstring =
  discard
proc jsInsertDTMF*(self: RTCDTMFSender; tones: cstring; duration: uint32; interToneGap: uint32): void =
  discard

proc jsRTCDTMFToneChangeEventTone*(self: RTCDTMFToneChangeEvent): cstring =
  discard

proc jsRTCDataChannelLabel*(self: RTCDataChannel): cstring =
  discard
proc jsRTCDataChannelReliable*(self: RTCDataChannel): bool =
  discard
proc jsRTCDataChannelReadyState*(self: RTCDataChannel): JsObject =
  discard
proc jsRTCDataChannelBufferedAmount*(self: RTCDataChannel): uint32 =
  discard
proc jsRTCDataChannelBufferedAmountLowThreshold*(self: RTCDataChannel): uint32 =
  discard
proc jsRTCDataChannelOnopen*(self: RTCDataChannel): JsObject =
  discard
proc jsRTCDataChannelOnerror*(self: RTCDataChannel): JsObject =
  discard
proc jsRTCDataChannelOnclose*(self: RTCDataChannel): JsObject =
  discard
proc jsRTCDataChannelOnmessage*(self: RTCDataChannel): JsObject =
  discard
proc jsRTCDataChannelOnbufferedamountlow*(self: RTCDataChannel): JsObject =
  discard
proc jsRTCDataChannelBinaryType*(self: RTCDataChannel): JsObject =
  discard
proc jsClose*(self: RTCDataChannel): void =
  discard
proc jsSend*(self: RTCDataChannel; data: cstring): void =
  discard
proc jsSend*(self: RTCDataChannel; data: JsObject): void =
  discard

proc jsRTCDataChannelEventChannel*(self: RTCDataChannelEvent): JsObject =
  discard

proc jsRTCIceCandidateCandidate*(self: RTCIceCandidate): cstring =
  discard
proc jsToJSON*(self: RTCIceCandidate): JsObject =
  discard

proc jsRTCIdentityProviderRegistrarHasIdp*(self: RTCIdentityProviderRegistrar): bool =
  discard
proc jsRegister*(self: RTCIdentityProviderRegistrar; idp: JsObject): void =
  discard
proc jsGenerateAssertion*(self: RTCIdentityProviderRegistrar; contents: cstring; origin: cstring; options: JsObject): JsObject =
  discard
proc jsValidateAssertion*(self: RTCIdentityProviderRegistrar; assertion: cstring; origin: cstring): JsObject =
  discard

proc jsRTCPeerConnectionSignalingState*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionIceGatheringState*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionIceConnectionState*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionConnectionState*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionPeerIdentity*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionId*(self: RTCPeerConnection): cstring =
  discard
proc jsRTCPeerConnectionOnnegotiationneeded*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOnicecandidate*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOnsignalingstatechange*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOnaddstream*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOnaddtrack*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOntrack*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOnremovestream*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOniceconnectionstatechange*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOnicegatheringstatechange*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOnconnectionstatechange*(self: RTCPeerConnection): JsObject =
  discard
proc jsRTCPeerConnectionOndatachannel*(self: RTCPeerConnection): JsObject =
  discard
proc jsGenerateCertificate*(self: typedesc[RTCPeerConnection]; keygenAlgorithm: JsObject): JsObject =
  discard
proc jsSetIdentityProvider*(self: RTCPeerConnection; provider: cstring; options: JsObject): void =
  discard
proc jsGetIdentityAssertion*(self: RTCPeerConnection): JsObject =
  discard
proc jsCreateOffer*(self: RTCPeerConnection; options: JsObject): JsObject =
  discard
proc jsCreateAnswer*(self: RTCPeerConnection; options: JsObject): JsObject =
  discard
proc jsSetLocalDescription*(self: RTCPeerConnection; description: JsObject): JsObject =
  discard
proc jsSetRemoteDescription*(self: RTCPeerConnection; description: JsObject): JsObject =
  discard
proc jsAddIceCandidate*(self: RTCPeerConnection; candidate: Option[JsObject]): JsObject =
  discard
proc jsSetConfiguration*(self: RTCPeerConnection; configuration: JsObject): void =
  discard
proc jsGetConfiguration*(self: RTCPeerConnection): JsObject =
  discard
proc jsGetLocalStreams*(self: RTCPeerConnection): JsObject =
  discard
proc jsGetRemoteStreams*(self: RTCPeerConnection): JsObject =
  discard
proc jsAddStream*(self: RTCPeerConnection; stream: JsObject): void =
  discard
proc jsAddTrack*(self: RTCPeerConnection; track: JsObject; stream: JsObject; moreStreams: JsObject): JsObject =
  discard
proc jsRemoveTrack*(self: RTCPeerConnection; sender: JsObject): void =
  discard
proc jsAddTransceiver*(self: RTCPeerConnection; trackOrKind: JsObject; init: JsObject): JsObject =
  discard
proc jsGetSenders*(self: RTCPeerConnection): JsObject =
  discard
proc jsGetReceivers*(self: RTCPeerConnection): JsObject =
  discard
proc jsGetTransceivers*(self: RTCPeerConnection): JsObject =
  discard
proc jsClose*(self: RTCPeerConnection): void =
  discard
proc jsGetStats*(self: RTCPeerConnection; selector: Option[JsObject]): JsObject =
  discard
proc jsCreateDataChannel*(self: RTCPeerConnection; label: cstring; dataChannelDict: JsObject): JsObject =
  discard

proc jsRTCPeerConnectionIceErrorEventUrl*(self: RTCPeerConnectionIceErrorEvent): cstring =
  discard
proc jsRTCPeerConnectionIceErrorEventErrorCode*(self: RTCPeerConnectionIceErrorEvent): uint16 =
  discard
proc jsRTCPeerConnectionIceErrorEventErrorText*(self: RTCPeerConnectionIceErrorEvent): cstring =
  discard


proc jsRTCRtpReceiverTrack*(self: RTCRtpReceiver): JsObject =
  discard
proc jsGetCapabilities*(self: typedesc[RTCRtpReceiver]; kind: cstring): Option[JsObject] =
  discard
proc jsGetStats*(self: RTCRtpReceiver): JsObject =
  discard
proc jsGetContributingSources*(self: RTCRtpReceiver): JsObject =
  discard
proc jsGetSynchronizationSources*(self: RTCRtpReceiver): JsObject =
  discard
proc jsSetStreamIds*(self: RTCRtpReceiver; streamIds: JsObject): void =
  discard
proc jsSetRemoteSendBit*(self: RTCRtpReceiver; sendBit: bool): void =
  discard
proc jsProcessTrackAdditionsAndRemovals*(self: RTCRtpReceiver; transceiver: JsObject; postProcessing: JsObject): void =
  discard

proc jsSetParameters*(self: RTCRtpSender; parameters: JsObject): JsObject =
  discard
proc jsGetParameters*(self: RTCRtpSender): JsObject =
  discard
proc jsReplaceTrack*(self: RTCRtpSender; withTrack: Option[JsObject]): JsObject =
  discard
proc jsGetStats*(self: RTCRtpSender): JsObject =
  discard
proc jsGetCapabilities*(self: typedesc[RTCRtpSender]; kind: cstring): Option[JsObject] =
  discard
proc jsGetStreams*(self: RTCRtpSender): JsObject =
  discard
proc jsSetStreams*(self: RTCRtpSender; streams: JsObject): void =
  discard
proc jsSetTrack*(self: RTCRtpSender; track: Option[JsObject]): void =
  discard
proc jsCheckWasCreatedByPc*(self: RTCRtpSender; pc: JsObject): void =
  discard

proc jsRTCRtpTransceiverSender*(self: RTCRtpTransceiver): JsObject =
  discard
proc jsRTCRtpTransceiverReceiver*(self: RTCRtpTransceiver): JsObject =
  discard
proc jsRTCRtpTransceiverStopped*(self: RTCRtpTransceiver): bool =
  discard
proc jsRTCRtpTransceiverDirection*(self: RTCRtpTransceiver): JsObject =
  discard
proc jsRTCRtpTransceiverAddTrackMagic*(self: RTCRtpTransceiver): bool =
  discard
proc jsRTCRtpTransceiverShouldRemove*(self: RTCRtpTransceiver): bool =
  discard
proc jsStop*(self: RTCRtpTransceiver): void =
  discard
proc jsSetCodecPreferences*(self: RTCRtpTransceiver; codecs: JsObject): void =
  discard
proc jsSetRemoteTrackId*(self: RTCRtpTransceiver; trackId: cstring): void =
  discard
proc jsRemoteTrackIdIs*(self: RTCRtpTransceiver; trackId: cstring): bool =
  discard
proc jsGetRemoteTrackId*(self: RTCRtpTransceiver): cstring =
  discard
proc jsSetAddTrackMagic*(self: RTCRtpTransceiver): void =
  discard
proc jsSetCurrentDirection*(self: RTCRtpTransceiver; direction: JsObject): void =
  discard
proc jsSetDirectionInternal*(self: RTCRtpTransceiver; direction: JsObject): void =
  discard
proc jsSetMid*(self: RTCRtpTransceiver; mid: cstring): void =
  discard
proc jsUnsetMid*(self: RTCRtpTransceiver): void =
  discard
proc jsSetStopped*(self: RTCRtpTransceiver): void =
  discard
proc jsGetKind*(self: RTCRtpTransceiver): cstring =
  discard
proc jsHasBeenUsedToSend*(self: RTCRtpTransceiver): bool =
  discard
proc jsSync*(self: RTCRtpTransceiver): void =
  discard
proc jsInsertDTMF*(self: RTCRtpTransceiver; tones: cstring; duration: uint32; interToneGap: uint32): void =
  discard

proc jsRTCSessionDescriptionTypeVal*(self: RTCSessionDescription): JsObject =
  discard
proc jsRTCSessionDescriptionSdp*(self: RTCSessionDescription): cstring =
  discard
proc jsToJSON*(self: RTCSessionDescription): JsObject =
  discard


proc jsRTCTrackEventReceiver*(self: RTCTrackEvent): JsObject =
  discard
proc jsRTCTrackEventTrack*(self: RTCTrackEvent): JsObject =
  discard
proc jsRTCTrackEventStreams*(self: RTCTrackEvent): JsObject =
  discard
proc jsRTCTrackEventTransceiver*(self: RTCTrackEvent): JsObject =
  discard

proc jsRadioNodeListValue*(self: RadioNodeList): cstring =
  discard

proc jsRangeStartContainer*(self: Range): JsObject =
  discard
proc jsRangeStartOffset*(self: Range): uint32 =
  discard
proc jsRangeEndContainer*(self: Range): JsObject =
  discard
proc jsRangeEndOffset*(self: Range): uint32 =
  discard
proc jsRangeCollapsed*(self: Range): bool =
  discard
proc jsRangeCommonAncestorContainer*(self: Range): JsObject =
  discard
const jsRangeSTART_TO_START* : uint16 = 0
const jsRangeSTART_TO_END* : uint16 = 0
const jsRangeEND_TO_END* : uint16 = 0
const jsRangeEND_TO_START* : uint16 = 0
proc jsSetStart*(self: Range; refNode: JsObject; offset: uint32): void =
  discard
proc jsSetEnd*(self: Range; refNode: JsObject; offset: uint32): void =
  discard
proc jsSetStartBefore*(self: Range; refNode: JsObject): void =
  discard
proc jsSetStartAfter*(self: Range; refNode: JsObject): void =
  discard
proc jsSetEndBefore*(self: Range; refNode: JsObject): void =
  discard
proc jsSetEndAfter*(self: Range; refNode: JsObject): void =
  discard
proc jsCollapse*(self: Range; toStart: bool): void =
  discard
proc jsSelectNode*(self: Range; refNode: JsObject): void =
  discard
proc jsSelectNodeContents*(self: Range; refNode: JsObject): void =
  discard
proc jsCompareBoundaryPoints*(self: Range; how: uint16; sourceRange: JsObject): int16 =
  discard
proc jsDeleteContents*(self: Range): void =
  discard
proc jsExtractContents*(self: Range): JsObject =
  discard
proc jsCloneContents*(self: Range): JsObject =
  discard
proc jsInsertNode*(self: Range; node: JsObject): void =
  discard
proc jsSurroundContents*(self: Range; newParent: JsObject): void =
  discard
proc jsCloneRange*(self: Range): JsObject =
  discard
proc jsDetach*(self: Range): void =
  discard
proc jsIsPointInRange*(self: Range; node: JsObject; offset: uint32): bool =
  discard
proc jsComparePoint*(self: Range; node: JsObject; offset: uint32): int16 =
  discard
proc jsIntersectsNode*(self: Range; node: JsObject): bool =
  discard

proc jsRequestMethodVal*(self: Request): cstring =
  discard
proc jsRequestUrl*(self: Request): cstring =
  discard
proc jsRequestHeaders*(self: Request): JsObject =
  discard
proc jsRequestDestination*(self: Request): JsObject =
  discard
proc jsRequestReferrer*(self: Request): cstring =
  discard
proc jsRequestReferrerPolicy*(self: Request): JsObject =
  discard
proc jsRequestMode*(self: Request): JsObject =
  discard
proc jsRequestCredentials*(self: Request): JsObject =
  discard
proc jsRequestCache*(self: Request): JsObject =
  discard
proc jsRequestRedirect*(self: Request): JsObject =
  discard
proc jsRequestIntegrity*(self: Request): cstring =
  discard
proc jsRequestSignal*(self: Request): JsObject =
  discard
proc jsClone*(self: Request): JsObject =
  discard
proc jsOverrideContentPolicyType*(self: Request; context: JsObject): void =
  discard

proc jsObserve*(self: ResizeObserver; target: JsObject; options: JsObject): void =
  discard
proc jsUnobserve*(self: ResizeObserver; target: JsObject): void =
  discard
proc jsDisconnect*(self: ResizeObserver): void =
  discard

proc jsResizeObserverEntryTarget*(self: ResizeObserverEntry): JsObject =
  discard
proc jsResizeObserverEntryContentRect*(self: ResizeObserverEntry): JsObject =
  discard
proc jsResizeObserverEntryBorderBoxSize*(self: ResizeObserverEntry): JsObject =
  discard
proc jsResizeObserverEntryContentBoxSize*(self: ResizeObserverEntry): JsObject =
  discard
proc jsResizeObserverEntryDevicePixelContentBoxSize*(self: ResizeObserverEntry): JsObject =
  discard

proc jsResizeObserverSizeInlineSize*(self: ResizeObserverSize): float64 =
  discard
proc jsResizeObserverSizeBlockSize*(self: ResizeObserverSize): float64 =
  discard

proc jsResponseTypeVal*(self: Response): JsObject =
  discard
proc jsResponseUrl*(self: Response): cstring =
  discard
proc jsResponseRedirected*(self: Response): bool =
  discard
proc jsResponseStatus*(self: Response): uint16 =
  discard
proc jsResponseOk*(self: Response): bool =
  discard
proc jsResponseStatusText*(self: Response): cstring =
  discard
proc jsResponseHeaders*(self: Response): JsObject =
  discard
proc jsError*(self: typedesc[Response]): JsObject =
  discard
proc jsRedirect*(self: typedesc[Response]; url: cstring; status: uint16): JsObject =
  discard
proc jsClone*(self: Response): JsObject =
  discard
proc jsCloneUnfiltered*(self: Response): JsObject =
  discard

proc jsSVGAElementTarget*(self: SVGAElement): JsObject =
  discard
proc jsSVGAElementDownload*(self: SVGAElement): cstring =
  discard
proc jsSVGAElementPing*(self: SVGAElement): cstring =
  discard
proc jsSVGAElementRel*(self: SVGAElement): cstring =
  discard
proc jsSVGAElementReferrerPolicy*(self: SVGAElement): cstring =
  discard
proc jsSVGAElementRelList*(self: SVGAElement): JsObject =
  discard
proc jsSVGAElementHreflang*(self: SVGAElement): cstring =
  discard
proc jsSVGAElementTypeVal*(self: SVGAElement): cstring =
  discard
proc jsSVGAElementText*(self: SVGAElement): cstring =
  discard

const jsSVGAngleSVG_ANGLETYPE_UNKNOWN* : uint16 = 0
const jsSVGAngleSVG_ANGLETYPE_UNSPECIFIED* : uint16 = 0
const jsSVGAngleSVG_ANGLETYPE_DEG* : uint16 = 0
const jsSVGAngleSVG_ANGLETYPE_RAD* : uint16 = 0
const jsSVGAngleSVG_ANGLETYPE_GRAD* : uint16 = 0
proc jsSVGAngleUnitType*(self: SVGAngle): uint16 =
  discard
proc jsSVGAngleValue*(self: SVGAngle): float32 =
  discard
proc jsSVGAngleValueInSpecifiedUnits*(self: SVGAngle): float32 =
  discard
proc jsSVGAngleValueAsString*(self: SVGAngle): cstring =
  discard
proc jsNewValueSpecifiedUnits*(self: SVGAngle; unitType: uint16; valueInSpecifiedUnits: float32): void =
  discard
proc jsConvertToSpecifiedUnits*(self: SVGAngle; unitType: uint16): void =
  discard




proc jsSVGAnimatedAngleBaseVal*(self: SVGAnimatedAngle): JsObject =
  discard
proc jsSVGAnimatedAngleAnimVal*(self: SVGAnimatedAngle): JsObject =
  discard

proc jsSVGAnimatedBooleanBaseVal*(self: SVGAnimatedBoolean): bool =
  discard
proc jsSVGAnimatedBooleanAnimVal*(self: SVGAnimatedBoolean): bool =
  discard

proc jsSVGAnimatedEnumerationBaseVal*(self: SVGAnimatedEnumeration): uint16 =
  discard
proc jsSVGAnimatedEnumerationAnimVal*(self: SVGAnimatedEnumeration): uint16 =
  discard

proc jsSVGAnimatedIntegerBaseVal*(self: SVGAnimatedInteger): int32 =
  discard
proc jsSVGAnimatedIntegerAnimVal*(self: SVGAnimatedInteger): int32 =
  discard

proc jsSVGAnimatedLengthBaseVal*(self: SVGAnimatedLength): JsObject =
  discard
proc jsSVGAnimatedLengthAnimVal*(self: SVGAnimatedLength): JsObject =
  discard

proc jsSVGAnimatedLengthListBaseVal*(self: SVGAnimatedLengthList): JsObject =
  discard
proc jsSVGAnimatedLengthListAnimVal*(self: SVGAnimatedLengthList): JsObject =
  discard

proc jsSVGAnimatedNumberBaseVal*(self: SVGAnimatedNumber): float32 =
  discard
proc jsSVGAnimatedNumberAnimVal*(self: SVGAnimatedNumber): float32 =
  discard

proc jsSVGAnimatedNumberListBaseVal*(self: SVGAnimatedNumberList): JsObject =
  discard
proc jsSVGAnimatedNumberListAnimVal*(self: SVGAnimatedNumberList): JsObject =
  discard

proc jsSVGAnimatedPreserveAspectRatioBaseVal*(self: SVGAnimatedPreserveAspectRatio): JsObject =
  discard
proc jsSVGAnimatedPreserveAspectRatioAnimVal*(self: SVGAnimatedPreserveAspectRatio): JsObject =
  discard


proc jsSVGAnimatedStringBaseVal*(self: SVGAnimatedString): cstring =
  discard
proc jsSVGAnimatedStringAnimVal*(self: SVGAnimatedString): cstring =
  discard

proc jsSVGAnimatedTransformListBaseVal*(self: SVGAnimatedTransformList): JsObject =
  discard
proc jsSVGAnimatedTransformListAnimVal*(self: SVGAnimatedTransformList): JsObject =
  discard

proc jsGetStartTime*(self: SVGAnimationElement): float32 =
  discard
proc jsGetCurrentTime*(self: SVGAnimationElement): float32 =
  discard
proc jsGetSimpleDuration*(self: SVGAnimationElement): float32 =
  discard
proc jsBeginElement*(self: SVGAnimationElement): void =
  discard
proc jsBeginElementAt*(self: SVGAnimationElement; offset: float32): void =
  discard
proc jsEndElement*(self: SVGAnimationElement): void =
  discard
proc jsEndElementAt*(self: SVGAnimationElement; offset: float32): void =
  discard

proc jsSVGCircleElementCx*(self: SVGCircleElement): JsObject =
  discard
proc jsSVGCircleElementCy*(self: SVGCircleElement): JsObject =
  discard
proc jsSVGCircleElementR*(self: SVGCircleElement): JsObject =
  discard

proc jsSVGClipPathElementClipPathUnits*(self: SVGClipPathElement): JsObject =
  discard
proc jsSVGClipPathElementTransform*(self: SVGClipPathElement): JsObject =
  discard

const jsSVGComponentTransferFunctionElementSVG_FECOMPONENTTRANSFER_TYPE_UNKNOWN* : uint16 = 0
const jsSVGComponentTransferFunctionElementSVG_FECOMPONENTTRANSFER_TYPE_IDENTITY* : uint16 = 0
const jsSVGComponentTransferFunctionElementSVG_FECOMPONENTTRANSFER_TYPE_TABLE* : uint16 = 0
const jsSVGComponentTransferFunctionElementSVG_FECOMPONENTTRANSFER_TYPE_DISCRETE* : uint16 = 0
const jsSVGComponentTransferFunctionElementSVG_FECOMPONENTTRANSFER_TYPE_LINEAR* : uint16 = 0
const jsSVGComponentTransferFunctionElementSVG_FECOMPONENTTRANSFER_TYPE_GAMMA* : uint16 = 0
proc jsSVGComponentTransferFunctionElementTypeVal*(self: SVGComponentTransferFunctionElement): JsObject =
  discard
proc jsSVGComponentTransferFunctionElementTableValues*(self: SVGComponentTransferFunctionElement): JsObject =
  discard
proc jsSVGComponentTransferFunctionElementSlope*(self: SVGComponentTransferFunctionElement): JsObject =
  discard
proc jsSVGComponentTransferFunctionElementIntercept*(self: SVGComponentTransferFunctionElement): JsObject =
  discard
proc jsSVGComponentTransferFunctionElementAmplitude*(self: SVGComponentTransferFunctionElement): JsObject =
  discard
proc jsSVGComponentTransferFunctionElementExponent*(self: SVGComponentTransferFunctionElement): JsObject =
  discard
proc jsSVGComponentTransferFunctionElementOffset*(self: SVGComponentTransferFunctionElement): JsObject =
  discard



proc jsSVGElementId*(self: SVGElement): cstring =
  discard
proc jsSVGElementClassName*(self: SVGElement): JsObject =
  discard

proc jsSVGEllipseElementCx*(self: SVGEllipseElement): JsObject =
  discard
proc jsSVGEllipseElementCy*(self: SVGEllipseElement): JsObject =
  discard
proc jsSVGEllipseElementRx*(self: SVGEllipseElement): JsObject =
  discard
proc jsSVGEllipseElementRy*(self: SVGEllipseElement): JsObject =
  discard

const jsSVGFEBlendElementSVG_FEBLEND_MODE_UNKNOWN* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_NORMAL* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_MULTIPLY* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_SCREEN* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_DARKEN* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_LIGHTEN* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_OVERLAY* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_COLOR_DODGE* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_COLOR_BURN* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_HARD_LIGHT* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_SOFT_LIGHT* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_DIFFERENCE* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_EXCLUSION* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_HUE* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_SATURATION* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_COLOR* : uint16 = 0
const jsSVGFEBlendElementSVG_FEBLEND_MODE_LUMINOSITY* : uint16 = 0
proc jsSVGFEBlendElementIn1*(self: SVGFEBlendElement): JsObject =
  discard
proc jsSVGFEBlendElementIn2*(self: SVGFEBlendElement): JsObject =
  discard
proc jsSVGFEBlendElementMode*(self: SVGFEBlendElement): JsObject =
  discard

const jsSVGFEColorMatrixElementSVG_FECOLORMATRIX_TYPE_UNKNOWN* : uint16 = 0
const jsSVGFEColorMatrixElementSVG_FECOLORMATRIX_TYPE_MATRIX* : uint16 = 0
const jsSVGFEColorMatrixElementSVG_FECOLORMATRIX_TYPE_SATURATE* : uint16 = 0
const jsSVGFEColorMatrixElementSVG_FECOLORMATRIX_TYPE_HUEROTATE* : uint16 = 0
const jsSVGFEColorMatrixElementSVG_FECOLORMATRIX_TYPE_LUMINANCETOALPHA* : uint16 = 0
proc jsSVGFEColorMatrixElementIn1*(self: SVGFEColorMatrixElement): JsObject =
  discard
proc jsSVGFEColorMatrixElementTypeVal*(self: SVGFEColorMatrixElement): JsObject =
  discard
proc jsSVGFEColorMatrixElementValues*(self: SVGFEColorMatrixElement): JsObject =
  discard

proc jsSVGFEComponentTransferElementIn1*(self: SVGFEComponentTransferElement): JsObject =
  discard

const jsSVGFECompositeElementSVG_FECOMPOSITE_OPERATOR_UNKNOWN* : uint16 = 0
const jsSVGFECompositeElementSVG_FECOMPOSITE_OPERATOR_OVER* : uint16 = 0
const jsSVGFECompositeElementSVG_FECOMPOSITE_OPERATOR_IN* : uint16 = 0
const jsSVGFECompositeElementSVG_FECOMPOSITE_OPERATOR_OUT* : uint16 = 0
const jsSVGFECompositeElementSVG_FECOMPOSITE_OPERATOR_ATOP* : uint16 = 0
const jsSVGFECompositeElementSVG_FECOMPOSITE_OPERATOR_XOR* : uint16 = 0
const jsSVGFECompositeElementSVG_FECOMPOSITE_OPERATOR_ARITHMETIC* : uint16 = 0
proc jsSVGFECompositeElementIn1*(self: SVGFECompositeElement): JsObject =
  discard
proc jsSVGFECompositeElementIn2*(self: SVGFECompositeElement): JsObject =
  discard
proc jsSVGFECompositeElementOperator*(self: SVGFECompositeElement): JsObject =
  discard
proc jsSVGFECompositeElementK1*(self: SVGFECompositeElement): JsObject =
  discard
proc jsSVGFECompositeElementK2*(self: SVGFECompositeElement): JsObject =
  discard
proc jsSVGFECompositeElementK3*(self: SVGFECompositeElement): JsObject =
  discard
proc jsSVGFECompositeElementK4*(self: SVGFECompositeElement): JsObject =
  discard

const jsSVGFEConvolveMatrixElementSVG_EDGEMODE_UNKNOWN* : uint16 = 0
const jsSVGFEConvolveMatrixElementSVG_EDGEMODE_DUPLICATE* : uint16 = 0
const jsSVGFEConvolveMatrixElementSVG_EDGEMODE_WRAP* : uint16 = 0
const jsSVGFEConvolveMatrixElementSVG_EDGEMODE_NONE* : uint16 = 0
proc jsSVGFEConvolveMatrixElementIn1*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementOrderX*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementOrderY*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementKernelMatrix*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementDivisor*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementBias*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementTargetX*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementTargetY*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementEdgeMode*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementKernelUnitLengthX*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementKernelUnitLengthY*(self: SVGFEConvolveMatrixElement): JsObject =
  discard
proc jsSVGFEConvolveMatrixElementPreserveAlpha*(self: SVGFEConvolveMatrixElement): JsObject =
  discard

proc jsSVGFEDiffuseLightingElementIn1*(self: SVGFEDiffuseLightingElement): JsObject =
  discard
proc jsSVGFEDiffuseLightingElementSurfaceScale*(self: SVGFEDiffuseLightingElement): JsObject =
  discard
proc jsSVGFEDiffuseLightingElementDiffuseConstant*(self: SVGFEDiffuseLightingElement): JsObject =
  discard
proc jsSVGFEDiffuseLightingElementKernelUnitLengthX*(self: SVGFEDiffuseLightingElement): JsObject =
  discard
proc jsSVGFEDiffuseLightingElementKernelUnitLengthY*(self: SVGFEDiffuseLightingElement): JsObject =
  discard

const jsSVGFEDisplacementMapElementSVG_CHANNEL_UNKNOWN* : uint16 = 0
const jsSVGFEDisplacementMapElementSVG_CHANNEL_R* : uint16 = 0
const jsSVGFEDisplacementMapElementSVG_CHANNEL_G* : uint16 = 0
const jsSVGFEDisplacementMapElementSVG_CHANNEL_B* : uint16 = 0
const jsSVGFEDisplacementMapElementSVG_CHANNEL_A* : uint16 = 0
proc jsSVGFEDisplacementMapElementIn1*(self: SVGFEDisplacementMapElement): JsObject =
  discard
proc jsSVGFEDisplacementMapElementIn2*(self: SVGFEDisplacementMapElement): JsObject =
  discard
proc jsSVGFEDisplacementMapElementScale*(self: SVGFEDisplacementMapElement): JsObject =
  discard
proc jsSVGFEDisplacementMapElementXChannelSelector*(self: SVGFEDisplacementMapElement): JsObject =
  discard
proc jsSVGFEDisplacementMapElementYChannelSelector*(self: SVGFEDisplacementMapElement): JsObject =
  discard

proc jsSVGFEDistantLightElementAzimuth*(self: SVGFEDistantLightElement): JsObject =
  discard
proc jsSVGFEDistantLightElementElevation*(self: SVGFEDistantLightElement): JsObject =
  discard

proc jsSVGFEDropShadowElementIn1*(self: SVGFEDropShadowElement): JsObject =
  discard
proc jsSVGFEDropShadowElementDx*(self: SVGFEDropShadowElement): JsObject =
  discard
proc jsSVGFEDropShadowElementDy*(self: SVGFEDropShadowElement): JsObject =
  discard
proc jsSVGFEDropShadowElementStdDeviationX*(self: SVGFEDropShadowElement): JsObject =
  discard
proc jsSVGFEDropShadowElementStdDeviationY*(self: SVGFEDropShadowElement): JsObject =
  discard
proc jsSetStdDeviation*(self: SVGFEDropShadowElement; stdDeviationX: float32; stdDeviationY: float32): void =
  discard






proc jsSVGFEGaussianBlurElementIn1*(self: SVGFEGaussianBlurElement): JsObject =
  discard
proc jsSVGFEGaussianBlurElementStdDeviationX*(self: SVGFEGaussianBlurElement): JsObject =
  discard
proc jsSVGFEGaussianBlurElementStdDeviationY*(self: SVGFEGaussianBlurElement): JsObject =
  discard
proc jsSetStdDeviation*(self: SVGFEGaussianBlurElement; stdDeviationX: float32; stdDeviationY: float32): void =
  discard

proc jsSVGFEImageElementPreserveAspectRatio*(self: SVGFEImageElement): JsObject =
  discard


proc jsSVGFEMergeNodeElementIn1*(self: SVGFEMergeNodeElement): JsObject =
  discard

const jsSVGFEMorphologyElementSVG_MORPHOLOGY_OPERATOR_UNKNOWN* : uint16 = 0
const jsSVGFEMorphologyElementSVG_MORPHOLOGY_OPERATOR_ERODE* : uint16 = 0
const jsSVGFEMorphologyElementSVG_MORPHOLOGY_OPERATOR_DILATE* : uint16 = 0
proc jsSVGFEMorphologyElementIn1*(self: SVGFEMorphologyElement): JsObject =
  discard
proc jsSVGFEMorphologyElementOperator*(self: SVGFEMorphologyElement): JsObject =
  discard
proc jsSVGFEMorphologyElementRadiusX*(self: SVGFEMorphologyElement): JsObject =
  discard
proc jsSVGFEMorphologyElementRadiusY*(self: SVGFEMorphologyElement): JsObject =
  discard

proc jsSVGFEOffsetElementIn1*(self: SVGFEOffsetElement): JsObject =
  discard
proc jsSVGFEOffsetElementDx*(self: SVGFEOffsetElement): JsObject =
  discard
proc jsSVGFEOffsetElementDy*(self: SVGFEOffsetElement): JsObject =
  discard

proc jsSVGFEPointLightElementX*(self: SVGFEPointLightElement): JsObject =
  discard
proc jsSVGFEPointLightElementY*(self: SVGFEPointLightElement): JsObject =
  discard
proc jsSVGFEPointLightElementZ*(self: SVGFEPointLightElement): JsObject =
  discard

proc jsSVGFESpecularLightingElementIn1*(self: SVGFESpecularLightingElement): JsObject =
  discard
proc jsSVGFESpecularLightingElementSurfaceScale*(self: SVGFESpecularLightingElement): JsObject =
  discard
proc jsSVGFESpecularLightingElementSpecularConstant*(self: SVGFESpecularLightingElement): JsObject =
  discard
proc jsSVGFESpecularLightingElementSpecularExponent*(self: SVGFESpecularLightingElement): JsObject =
  discard
proc jsSVGFESpecularLightingElementKernelUnitLengthX*(self: SVGFESpecularLightingElement): JsObject =
  discard
proc jsSVGFESpecularLightingElementKernelUnitLengthY*(self: SVGFESpecularLightingElement): JsObject =
  discard

proc jsSVGFESpotLightElementX*(self: SVGFESpotLightElement): JsObject =
  discard
proc jsSVGFESpotLightElementY*(self: SVGFESpotLightElement): JsObject =
  discard
proc jsSVGFESpotLightElementZ*(self: SVGFESpotLightElement): JsObject =
  discard
proc jsSVGFESpotLightElementPointsAtX*(self: SVGFESpotLightElement): JsObject =
  discard
proc jsSVGFESpotLightElementPointsAtY*(self: SVGFESpotLightElement): JsObject =
  discard
proc jsSVGFESpotLightElementPointsAtZ*(self: SVGFESpotLightElement): JsObject =
  discard
proc jsSVGFESpotLightElementSpecularExponent*(self: SVGFESpotLightElement): JsObject =
  discard
proc jsSVGFESpotLightElementLimitingConeAngle*(self: SVGFESpotLightElement): JsObject =
  discard

proc jsSVGFETileElementIn1*(self: SVGFETileElement): JsObject =
  discard

const jsSVGFETurbulenceElementSVG_TURBULENCE_TYPE_UNKNOWN* : uint16 = 0
const jsSVGFETurbulenceElementSVG_TURBULENCE_TYPE_FRACTALNOISE* : uint16 = 0
const jsSVGFETurbulenceElementSVG_TURBULENCE_TYPE_TURBULENCE* : uint16 = 0
const jsSVGFETurbulenceElementSVG_STITCHTYPE_UNKNOWN* : uint16 = 0
const jsSVGFETurbulenceElementSVG_STITCHTYPE_STITCH* : uint16 = 0
const jsSVGFETurbulenceElementSVG_STITCHTYPE_NOSTITCH* : uint16 = 0
proc jsSVGFETurbulenceElementBaseFrequencyX*(self: SVGFETurbulenceElement): JsObject =
  discard
proc jsSVGFETurbulenceElementBaseFrequencyY*(self: SVGFETurbulenceElement): JsObject =
  discard
proc jsSVGFETurbulenceElementNumOctaves*(self: SVGFETurbulenceElement): JsObject =
  discard
proc jsSVGFETurbulenceElementSeed*(self: SVGFETurbulenceElement): JsObject =
  discard
proc jsSVGFETurbulenceElementStitchTiles*(self: SVGFETurbulenceElement): JsObject =
  discard
proc jsSVGFETurbulenceElementTypeVal*(self: SVGFETurbulenceElement): JsObject =
  discard

proc jsSVGFilterElementFilterUnits*(self: SVGFilterElement): JsObject =
  discard
proc jsSVGFilterElementPrimitiveUnits*(self: SVGFilterElement): JsObject =
  discard
proc jsSVGFilterElementX*(self: SVGFilterElement): JsObject =
  discard
proc jsSVGFilterElementY*(self: SVGFilterElement): JsObject =
  discard
proc jsSVGFilterElementWidth*(self: SVGFilterElement): JsObject =
  discard
proc jsSVGFilterElementHeight*(self: SVGFilterElement): JsObject =
  discard

proc jsSVGForeignObjectElementX*(self: SVGForeignObjectElement): JsObject =
  discard
proc jsSVGForeignObjectElementY*(self: SVGForeignObjectElement): JsObject =
  discard
proc jsSVGForeignObjectElementWidth*(self: SVGForeignObjectElement): JsObject =
  discard
proc jsSVGForeignObjectElementHeight*(self: SVGForeignObjectElement): JsObject =
  discard


proc jsSVGGeometryElementPathLength*(self: SVGGeometryElement): JsObject =
  discard
proc jsGetTotalLength*(self: SVGGeometryElement): float32 =
  discard
proc jsGetPointAtLength*(self: SVGGeometryElement; distance: float32): JsObject =
  discard
proc jsIsPointInFill*(self: SVGGeometryElement; point: JsObject): bool =
  discard
proc jsIsPointInStroke*(self: SVGGeometryElement; point: JsObject): bool =
  discard

const jsSVGGradientElementSVG_SPREADMETHOD_UNKNOWN* : uint16 = 0
const jsSVGGradientElementSVG_SPREADMETHOD_PAD* : uint16 = 0
const jsSVGGradientElementSVG_SPREADMETHOD_REFLECT* : uint16 = 0
const jsSVGGradientElementSVG_SPREADMETHOD_REPEAT* : uint16 = 0
proc jsSVGGradientElementGradientUnits*(self: SVGGradientElement): JsObject =
  discard
proc jsSVGGradientElementGradientTransform*(self: SVGGradientElement): JsObject =
  discard
proc jsSVGGradientElementSpreadMethod*(self: SVGGradientElement): JsObject =
  discard

proc jsSVGGraphicsElementTransform*(self: SVGGraphicsElement): JsObject =
  discard
proc jsGetBBox*(self: SVGGraphicsElement; aOptions: JsObject): JsObject =
  discard
proc jsGetCTM*(self: SVGGraphicsElement): Option[JsObject] =
  discard
proc jsGetScreenCTM*(self: SVGGraphicsElement): Option[JsObject] =
  discard
proc jsGetTransformToElement*(self: SVGGraphicsElement; element: JsObject): JsObject =
  discard

proc jsSVGImageElementX*(self: SVGImageElement): JsObject =
  discard
proc jsSVGImageElementY*(self: SVGImageElement): JsObject =
  discard
proc jsSVGImageElementWidth*(self: SVGImageElement): JsObject =
  discard
proc jsSVGImageElementHeight*(self: SVGImageElement): JsObject =
  discard
proc jsSVGImageElementPreserveAspectRatio*(self: SVGImageElement): JsObject =
  discard

const jsSVGLengthSVG_LENGTHTYPE_UNKNOWN* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_NUMBER* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_PERCENTAGE* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_EMS* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_EXS* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_PX* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_CM* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_MM* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_IN* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_PT* : uint16 = 0
const jsSVGLengthSVG_LENGTHTYPE_PC* : uint16 = 0
proc jsSVGLengthUnitType*(self: SVGLength): uint16 =
  discard
proc jsSVGLengthValue*(self: SVGLength): float32 =
  discard
proc jsSVGLengthValueInSpecifiedUnits*(self: SVGLength): float32 =
  discard
proc jsSVGLengthValueAsString*(self: SVGLength): cstring =
  discard
proc jsNewValueSpecifiedUnits*(self: SVGLength; unitType: uint16; valueInSpecifiedUnits: float32): void =
  discard
proc jsConvertToSpecifiedUnits*(self: SVGLength; unitType: uint16): void =
  discard

proc jsSVGLengthListNumberOfItems*(self: SVGLengthList): uint32 =
  discard
proc jsClear*(self: SVGLengthList): void =
  discard
proc jsInitialize*(self: SVGLengthList; newItem: JsObject): JsObject =
  discard
proc jsGetItem*(self: SVGLengthList; index: uint32): JsObject =
  discard
proc jsInsertItemBefore*(self: SVGLengthList; newItem: JsObject; index: uint32): JsObject =
  discard
proc jsReplaceItem*(self: SVGLengthList; newItem: JsObject; index: uint32): JsObject =
  discard
proc jsRemoveItem*(self: SVGLengthList; index: uint32): JsObject =
  discard
proc jsAppendItem*(self: SVGLengthList; newItem: JsObject): JsObject =
  discard

proc jsSVGLineElementX1*(self: SVGLineElement): JsObject =
  discard
proc jsSVGLineElementY1*(self: SVGLineElement): JsObject =
  discard
proc jsSVGLineElementX2*(self: SVGLineElement): JsObject =
  discard
proc jsSVGLineElementY2*(self: SVGLineElement): JsObject =
  discard

proc jsSVGLinearGradientElementX1*(self: SVGLinearGradientElement): JsObject =
  discard
proc jsSVGLinearGradientElementY1*(self: SVGLinearGradientElement): JsObject =
  discard
proc jsSVGLinearGradientElementX2*(self: SVGLinearGradientElement): JsObject =
  discard
proc jsSVGLinearGradientElementY2*(self: SVGLinearGradientElement): JsObject =
  discard


const jsSVGMarkerElementSVG_MARKERUNITS_UNKNOWN* : uint16 = 0
const jsSVGMarkerElementSVG_MARKERUNITS_USERSPACEONUSE* : uint16 = 0
const jsSVGMarkerElementSVG_MARKERUNITS_STROKEWIDTH* : uint16 = 0
const jsSVGMarkerElementSVG_MARKER_ORIENT_UNKNOWN* : uint16 = 0
const jsSVGMarkerElementSVG_MARKER_ORIENT_AUTO* : uint16 = 0
const jsSVGMarkerElementSVG_MARKER_ORIENT_ANGLE* : uint16 = 0
proc jsSVGMarkerElementRefX*(self: SVGMarkerElement): JsObject =
  discard
proc jsSVGMarkerElementRefY*(self: SVGMarkerElement): JsObject =
  discard
proc jsSVGMarkerElementMarkerUnits*(self: SVGMarkerElement): JsObject =
  discard
proc jsSVGMarkerElementMarkerWidth*(self: SVGMarkerElement): JsObject =
  discard
proc jsSVGMarkerElementMarkerHeight*(self: SVGMarkerElement): JsObject =
  discard
proc jsSVGMarkerElementOrientType*(self: SVGMarkerElement): JsObject =
  discard
proc jsSVGMarkerElementOrientAngle*(self: SVGMarkerElement): JsObject =
  discard
proc jsSetOrientToAuto*(self: SVGMarkerElement): void =
  discard
proc jsSetOrientToAngle*(self: SVGMarkerElement; angle: JsObject): void =
  discard

const jsSVGMaskElementSVG_MASKTYPE_LUMINANCE* : uint16 = 0
const jsSVGMaskElementSVG_MASKTYPE_ALPHA* : uint16 = 0
proc jsSVGMaskElementMaskUnits*(self: SVGMaskElement): JsObject =
  discard
proc jsSVGMaskElementMaskContentUnits*(self: SVGMaskElement): JsObject =
  discard
proc jsSVGMaskElementX*(self: SVGMaskElement): JsObject =
  discard
proc jsSVGMaskElementY*(self: SVGMaskElement): JsObject =
  discard
proc jsSVGMaskElementWidth*(self: SVGMaskElement): JsObject =
  discard
proc jsSVGMaskElementHeight*(self: SVGMaskElement): JsObject =
  discard

proc jsSVGMatrixA*(self: SVGMatrix): float32 =
  discard
proc jsSVGMatrixB*(self: SVGMatrix): float32 =
  discard
proc jsSVGMatrixC*(self: SVGMatrix): float32 =
  discard
proc jsSVGMatrixD*(self: SVGMatrix): float32 =
  discard
proc jsSVGMatrixE*(self: SVGMatrix): float32 =
  discard
proc jsSVGMatrixF*(self: SVGMatrix): float32 =
  discard
proc jsMultiply*(self: SVGMatrix; secondMatrix: JsObject): JsObject =
  discard
proc jsInverse*(self: SVGMatrix): JsObject =
  discard
proc jsTranslate*(self: SVGMatrix; x: float32; y: float32): JsObject =
  discard
proc jsScale*(self: SVGMatrix; scaleFactor: float32): JsObject =
  discard
proc jsScaleNonUniform*(self: SVGMatrix; scaleFactorX: float32; scaleFactorY: float32): JsObject =
  discard
proc jsRotate*(self: SVGMatrix; angle: float32): JsObject =
  discard
proc jsRotateFromVector*(self: SVGMatrix; x: float32; y: float32): JsObject =
  discard
proc jsFlipX*(self: SVGMatrix): JsObject =
  discard
proc jsFlipY*(self: SVGMatrix): JsObject =
  discard
proc jsSkewX*(self: SVGMatrix; angle: float32): JsObject =
  discard
proc jsSkewY*(self: SVGMatrix; angle: float32): JsObject =
  discard


proc jsSVGNumberValue*(self: SVGNumber): float32 =
  discard

proc jsSVGNumberListNumberOfItems*(self: SVGNumberList): uint32 =
  discard
proc jsClear*(self: SVGNumberList): void =
  discard
proc jsInitialize*(self: SVGNumberList; newItem: JsObject): JsObject =
  discard
proc jsGetItem*(self: SVGNumberList; index: uint32): JsObject =
  discard
proc jsInsertItemBefore*(self: SVGNumberList; newItem: JsObject; index: uint32): JsObject =
  discard
proc jsReplaceItem*(self: SVGNumberList; newItem: JsObject; index: uint32): JsObject =
  discard
proc jsRemoveItem*(self: SVGNumberList; index: uint32): JsObject =
  discard
proc jsAppendItem*(self: SVGNumberList; newItem: JsObject): JsObject =
  discard

proc jsGetPathSegAtLength*(self: SVGPathElement; distance: float32): uint32 =
  discard

const jsSVGPathSegPATHSEG_UNKNOWN* : uint16 = 0
const jsSVGPathSegPATHSEG_CLOSEPATH* : uint16 = 0
const jsSVGPathSegPATHSEG_MOVETO_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_MOVETO_REL* : uint16 = 0
const jsSVGPathSegPATHSEG_LINETO_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_LINETO_REL* : uint16 = 0
const jsSVGPathSegPATHSEG_CURVETO_CUBIC_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_CURVETO_CUBIC_REL* : uint16 = 0
const jsSVGPathSegPATHSEG_CURVETO_QUADRATIC_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_CURVETO_QUADRATIC_REL* : uint16 = 0
const jsSVGPathSegPATHSEG_ARC_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_ARC_REL* : uint16 = 0
const jsSVGPathSegPATHSEG_LINETO_HORIZONTAL_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_LINETO_HORIZONTAL_REL* : uint16 = 0
const jsSVGPathSegPATHSEG_LINETO_VERTICAL_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_LINETO_VERTICAL_REL* : uint16 = 0
const jsSVGPathSegPATHSEG_CURVETO_CUBIC_SMOOTH_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_CURVETO_CUBIC_SMOOTH_REL* : uint16 = 0
const jsSVGPathSegPATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS* : uint16 = 0
const jsSVGPathSegPATHSEG_CURVETO_QUADRATIC_SMOOTH_REL* : uint16 = 0
proc jsSVGPathSegPathSegType*(self: SVGPathSeg): uint16 =
  discard
proc jsSVGPathSegPathSegTypeAsLetter*(self: SVGPathSeg): cstring =
  discard


proc jsSVGPathSegMovetoAbsX*(self: SVGPathSegMovetoAbs): float32 =
  discard
proc jsSVGPathSegMovetoAbsY*(self: SVGPathSegMovetoAbs): float32 =
  discard

proc jsSVGPathSegMovetoRelX*(self: SVGPathSegMovetoRel): float32 =
  discard
proc jsSVGPathSegMovetoRelY*(self: SVGPathSegMovetoRel): float32 =
  discard

proc jsSVGPathSegLinetoAbsX*(self: SVGPathSegLinetoAbs): float32 =
  discard
proc jsSVGPathSegLinetoAbsY*(self: SVGPathSegLinetoAbs): float32 =
  discard

proc jsSVGPathSegLinetoRelX*(self: SVGPathSegLinetoRel): float32 =
  discard
proc jsSVGPathSegLinetoRelY*(self: SVGPathSegLinetoRel): float32 =
  discard

proc jsSVGPathSegCurvetoCubicAbsX*(self: SVGPathSegCurvetoCubicAbs): float32 =
  discard
proc jsSVGPathSegCurvetoCubicAbsY*(self: SVGPathSegCurvetoCubicAbs): float32 =
  discard
proc jsSVGPathSegCurvetoCubicAbsX1*(self: SVGPathSegCurvetoCubicAbs): float32 =
  discard
proc jsSVGPathSegCurvetoCubicAbsY1*(self: SVGPathSegCurvetoCubicAbs): float32 =
  discard
proc jsSVGPathSegCurvetoCubicAbsX2*(self: SVGPathSegCurvetoCubicAbs): float32 =
  discard
proc jsSVGPathSegCurvetoCubicAbsY2*(self: SVGPathSegCurvetoCubicAbs): float32 =
  discard

proc jsSVGPathSegCurvetoCubicRelX*(self: SVGPathSegCurvetoCubicRel): float32 =
  discard
proc jsSVGPathSegCurvetoCubicRelY*(self: SVGPathSegCurvetoCubicRel): float32 =
  discard
proc jsSVGPathSegCurvetoCubicRelX1*(self: SVGPathSegCurvetoCubicRel): float32 =
  discard
proc jsSVGPathSegCurvetoCubicRelY1*(self: SVGPathSegCurvetoCubicRel): float32 =
  discard
proc jsSVGPathSegCurvetoCubicRelX2*(self: SVGPathSegCurvetoCubicRel): float32 =
  discard
proc jsSVGPathSegCurvetoCubicRelY2*(self: SVGPathSegCurvetoCubicRel): float32 =
  discard

proc jsSVGPathSegCurvetoQuadraticAbsX*(self: SVGPathSegCurvetoQuadraticAbs): float32 =
  discard
proc jsSVGPathSegCurvetoQuadraticAbsY*(self: SVGPathSegCurvetoQuadraticAbs): float32 =
  discard
proc jsSVGPathSegCurvetoQuadraticAbsX1*(self: SVGPathSegCurvetoQuadraticAbs): float32 =
  discard
proc jsSVGPathSegCurvetoQuadraticAbsY1*(self: SVGPathSegCurvetoQuadraticAbs): float32 =
  discard

proc jsSVGPathSegCurvetoQuadraticRelX*(self: SVGPathSegCurvetoQuadraticRel): float32 =
  discard
proc jsSVGPathSegCurvetoQuadraticRelY*(self: SVGPathSegCurvetoQuadraticRel): float32 =
  discard
proc jsSVGPathSegCurvetoQuadraticRelX1*(self: SVGPathSegCurvetoQuadraticRel): float32 =
  discard
proc jsSVGPathSegCurvetoQuadraticRelY1*(self: SVGPathSegCurvetoQuadraticRel): float32 =
  discard

proc jsSVGPathSegArcAbsX*(self: SVGPathSegArcAbs): float32 =
  discard
proc jsSVGPathSegArcAbsY*(self: SVGPathSegArcAbs): float32 =
  discard
proc jsSVGPathSegArcAbsR1*(self: SVGPathSegArcAbs): float32 =
  discard
proc jsSVGPathSegArcAbsR2*(self: SVGPathSegArcAbs): float32 =
  discard
proc jsSVGPathSegArcAbsAngle*(self: SVGPathSegArcAbs): float32 =
  discard
proc jsSVGPathSegArcAbsLargeArcFlag*(self: SVGPathSegArcAbs): bool =
  discard
proc jsSVGPathSegArcAbsSweepFlag*(self: SVGPathSegArcAbs): bool =
  discard

proc jsSVGPathSegArcRelX*(self: SVGPathSegArcRel): float32 =
  discard
proc jsSVGPathSegArcRelY*(self: SVGPathSegArcRel): float32 =
  discard
proc jsSVGPathSegArcRelR1*(self: SVGPathSegArcRel): float32 =
  discard
proc jsSVGPathSegArcRelR2*(self: SVGPathSegArcRel): float32 =
  discard
proc jsSVGPathSegArcRelAngle*(self: SVGPathSegArcRel): float32 =
  discard
proc jsSVGPathSegArcRelLargeArcFlag*(self: SVGPathSegArcRel): bool =
  discard
proc jsSVGPathSegArcRelSweepFlag*(self: SVGPathSegArcRel): bool =
  discard

proc jsSVGPathSegLinetoHorizontalAbsX*(self: SVGPathSegLinetoHorizontalAbs): float32 =
  discard

proc jsSVGPathSegLinetoHorizontalRelX*(self: SVGPathSegLinetoHorizontalRel): float32 =
  discard

proc jsSVGPathSegLinetoVerticalAbsY*(self: SVGPathSegLinetoVerticalAbs): float32 =
  discard

proc jsSVGPathSegLinetoVerticalRelY*(self: SVGPathSegLinetoVerticalRel): float32 =
  discard

proc jsSVGPathSegCurvetoCubicSmoothAbsX*(self: SVGPathSegCurvetoCubicSmoothAbs): float32 =
  discard
proc jsSVGPathSegCurvetoCubicSmoothAbsY*(self: SVGPathSegCurvetoCubicSmoothAbs): float32 =
  discard
proc jsSVGPathSegCurvetoCubicSmoothAbsX2*(self: SVGPathSegCurvetoCubicSmoothAbs): float32 =
  discard
proc jsSVGPathSegCurvetoCubicSmoothAbsY2*(self: SVGPathSegCurvetoCubicSmoothAbs): float32 =
  discard

proc jsSVGPathSegCurvetoCubicSmoothRelX*(self: SVGPathSegCurvetoCubicSmoothRel): float32 =
  discard
proc jsSVGPathSegCurvetoCubicSmoothRelY*(self: SVGPathSegCurvetoCubicSmoothRel): float32 =
  discard
proc jsSVGPathSegCurvetoCubicSmoothRelX2*(self: SVGPathSegCurvetoCubicSmoothRel): float32 =
  discard
proc jsSVGPathSegCurvetoCubicSmoothRelY2*(self: SVGPathSegCurvetoCubicSmoothRel): float32 =
  discard

proc jsSVGPathSegCurvetoQuadraticSmoothAbsX*(self: SVGPathSegCurvetoQuadraticSmoothAbs): float32 =
  discard
proc jsSVGPathSegCurvetoQuadraticSmoothAbsY*(self: SVGPathSegCurvetoQuadraticSmoothAbs): float32 =
  discard

proc jsSVGPathSegCurvetoQuadraticSmoothRelX*(self: SVGPathSegCurvetoQuadraticSmoothRel): float32 =
  discard
proc jsSVGPathSegCurvetoQuadraticSmoothRelY*(self: SVGPathSegCurvetoQuadraticSmoothRel): float32 =
  discard

proc jsSVGPathSegListNumberOfItems*(self: SVGPathSegList): uint32 =
  discard
proc jsGetItem*(self: SVGPathSegList; index: uint32): JsObject =
  discard

proc jsSVGPatternElementPatternUnits*(self: SVGPatternElement): JsObject =
  discard
proc jsSVGPatternElementPatternContentUnits*(self: SVGPatternElement): JsObject =
  discard
proc jsSVGPatternElementPatternTransform*(self: SVGPatternElement): JsObject =
  discard
proc jsSVGPatternElementX*(self: SVGPatternElement): JsObject =
  discard
proc jsSVGPatternElementY*(self: SVGPatternElement): JsObject =
  discard
proc jsSVGPatternElementWidth*(self: SVGPatternElement): JsObject =
  discard
proc jsSVGPatternElementHeight*(self: SVGPatternElement): JsObject =
  discard

proc jsSVGPointX*(self: SVGPoint): float32 =
  discard
proc jsSVGPointY*(self: SVGPoint): float32 =
  discard
proc jsMatrixTransform*(self: SVGPoint; matrix: JsObject): JsObject =
  discard

proc jsSVGPointListNumberOfItems*(self: SVGPointList): uint32 =
  discard
proc jsClear*(self: SVGPointList): void =
  discard
proc jsInitialize*(self: SVGPointList; newItem: JsObject): JsObject =
  discard
proc jsGetItem*(self: SVGPointList; index: uint32): JsObject =
  discard
proc jsInsertItemBefore*(self: SVGPointList; newItem: JsObject; index: uint32): JsObject =
  discard
proc jsReplaceItem*(self: SVGPointList; newItem: JsObject; index: uint32): JsObject =
  discard
proc jsRemoveItem*(self: SVGPointList; index: uint32): JsObject =
  discard
proc jsAppendItem*(self: SVGPointList; newItem: JsObject): JsObject =
  discard



const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_UNKNOWN* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_NONE* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMINYMIN* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMIDYMIN* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMAXYMIN* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMINYMID* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMIDYMID* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMAXYMID* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMINYMAX* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMIDYMAX* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_PRESERVEASPECTRATIO_XMAXYMAX* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_MEETORSLICE_UNKNOWN* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_MEETORSLICE_MEET* : uint16 = 0
const jsSVGPreserveAspectRatioSVG_MEETORSLICE_SLICE* : uint16 = 0
proc jsSVGPreserveAspectRatioAlign*(self: SVGPreserveAspectRatio): uint16 =
  discard
proc jsSVGPreserveAspectRatioMeetOrSlice*(self: SVGPreserveAspectRatio): uint16 =
  discard

proc jsSVGRadialGradientElementCx*(self: SVGRadialGradientElement): JsObject =
  discard
proc jsSVGRadialGradientElementCy*(self: SVGRadialGradientElement): JsObject =
  discard
proc jsSVGRadialGradientElementR*(self: SVGRadialGradientElement): JsObject =
  discard
proc jsSVGRadialGradientElementFx*(self: SVGRadialGradientElement): JsObject =
  discard
proc jsSVGRadialGradientElementFy*(self: SVGRadialGradientElement): JsObject =
  discard
proc jsSVGRadialGradientElementFr*(self: SVGRadialGradientElement): JsObject =
  discard

proc jsSVGRectX*(self: SVGRect): float32 =
  discard
proc jsSVGRectY*(self: SVGRect): float32 =
  discard
proc jsSVGRectWidth*(self: SVGRect): float32 =
  discard
proc jsSVGRectHeight*(self: SVGRect): float32 =
  discard

proc jsSVGRectElementX*(self: SVGRectElement): JsObject =
  discard
proc jsSVGRectElementY*(self: SVGRectElement): JsObject =
  discard
proc jsSVGRectElementWidth*(self: SVGRectElement): JsObject =
  discard
proc jsSVGRectElementHeight*(self: SVGRectElement): JsObject =
  discard
proc jsSVGRectElementRx*(self: SVGRectElement): JsObject =
  discard
proc jsSVGRectElementRy*(self: SVGRectElement): JsObject =
  discard

proc jsSVGSVGElementX*(self: SVGSVGElement): JsObject =
  discard
proc jsSVGSVGElementY*(self: SVGSVGElement): JsObject =
  discard
proc jsSVGSVGElementWidth*(self: SVGSVGElement): JsObject =
  discard
proc jsSVGSVGElementHeight*(self: SVGSVGElement): JsObject =
  discard
proc jsSVGSVGElementUseCurrentView*(self: SVGSVGElement): bool =
  discard
proc jsSVGSVGElementCurrentScale*(self: SVGSVGElement): float32 =
  discard
proc jsSVGSVGElementCurrentTranslate*(self: SVGSVGElement): JsObject =
  discard
proc jsSuspendRedraw*(self: SVGSVGElement; maxWaitMilliseconds: uint32): uint32 =
  discard
proc jsUnsuspendRedraw*(self: SVGSVGElement; suspendHandleID: uint32): void =
  discard
proc jsUnsuspendRedrawAll*(self: SVGSVGElement): void =
  discard
proc jsForceRedraw*(self: SVGSVGElement): void =
  discard
proc jsPauseAnimations*(self: SVGSVGElement): void =
  discard
proc jsUnpauseAnimations*(self: SVGSVGElement): void =
  discard
proc jsAnimationsPaused*(self: SVGSVGElement): bool =
  discard
proc jsGetCurrentTime*(self: SVGSVGElement): float32 =
  discard
proc jsSetCurrentTime*(self: SVGSVGElement; seconds: float32): void =
  discard
proc jsDeselectAll*(self: SVGSVGElement): void =
  discard
proc jsCreateSVGNumber*(self: SVGSVGElement): JsObject =
  discard
proc jsCreateSVGLength*(self: SVGSVGElement): JsObject =
  discard
proc jsCreateSVGAngle*(self: SVGSVGElement): JsObject =
  discard
proc jsCreateSVGPoint*(self: SVGSVGElement): JsObject =
  discard
proc jsCreateSVGMatrix*(self: SVGSVGElement): JsObject =
  discard
proc jsCreateSVGRect*(self: SVGSVGElement): JsObject =
  discard
proc jsCreateSVGTransform*(self: SVGSVGElement): JsObject =
  discard
proc jsCreateSVGTransformFromMatrix*(self: SVGSVGElement; matrix: JsObject): JsObject =
  discard
proc jsGetElementById*(self: SVGSVGElement; elementId: cstring): Option[JsObject] =
  discard

proc jsSVGScriptElementTypeVal*(self: SVGScriptElement): cstring =
  discard


proc jsSVGStopElementOffset*(self: SVGStopElement): JsObject =
  discard

proc jsSVGStringListLength*(self: SVGStringList): uint32 =
  discard
proc jsSVGStringListNumberOfItems*(self: SVGStringList): uint32 =
  discard
proc jsClear*(self: SVGStringList): void =
  discard
proc jsInitialize*(self: SVGStringList; newItem: cstring): cstring =
  discard
proc jsGetItem*(self: SVGStringList; index: uint32): cstring =
  discard
proc jsInsertItemBefore*(self: SVGStringList; newItem: cstring; index: uint32): cstring =
  discard
proc jsReplaceItem*(self: SVGStringList; newItem: cstring; index: uint32): cstring =
  discard
proc jsRemoveItem*(self: SVGStringList; index: uint32): cstring =
  discard
proc jsAppendItem*(self: SVGStringList; newItem: cstring): cstring =
  discard

proc jsSVGStyleElementXmlspace*(self: SVGStyleElement): cstring =
  discard
proc jsSVGStyleElementTypeVal*(self: SVGStyleElement): cstring =
  discard
proc jsSVGStyleElementMedia*(self: SVGStyleElement): cstring =
  discard
proc jsSVGStyleElementTitle*(self: SVGStyleElement): cstring =
  discard




const jsSVGTextContentElementLENGTHADJUST_UNKNOWN* : uint16 = 0
const jsSVGTextContentElementLENGTHADJUST_SPACING* : uint16 = 0
const jsSVGTextContentElementLENGTHADJUST_SPACINGANDGLYPHS* : uint16 = 0
proc jsSVGTextContentElementTextLength*(self: SVGTextContentElement): JsObject =
  discard
proc jsSVGTextContentElementLengthAdjust*(self: SVGTextContentElement): JsObject =
  discard
proc jsGetNumberOfChars*(self: SVGTextContentElement): int32 =
  discard
proc jsGetComputedTextLength*(self: SVGTextContentElement): float32 =
  discard
proc jsGetSubStringLength*(self: SVGTextContentElement; charnum: uint32; nchars: uint32): float32 =
  discard
proc jsGetStartPositionOfChar*(self: SVGTextContentElement; charnum: uint32): JsObject =
  discard
proc jsGetEndPositionOfChar*(self: SVGTextContentElement; charnum: uint32): JsObject =
  discard
proc jsGetExtentOfChar*(self: SVGTextContentElement; charnum: uint32): JsObject =
  discard
proc jsGetRotationOfChar*(self: SVGTextContentElement; charnum: uint32): float32 =
  discard
proc jsGetCharNumAtPosition*(self: SVGTextContentElement; point: JsObject): int32 =
  discard
proc jsSelectSubString*(self: SVGTextContentElement; charnum: uint32; nchars: uint32): void =
  discard


const jsSVGTextPathElementTEXTPATH_METHODTYPE_UNKNOWN* : uint16 = 0
const jsSVGTextPathElementTEXTPATH_METHODTYPE_ALIGN* : uint16 = 0
const jsSVGTextPathElementTEXTPATH_METHODTYPE_STRETCH* : uint16 = 0
const jsSVGTextPathElementTEXTPATH_SPACINGTYPE_UNKNOWN* : uint16 = 0
const jsSVGTextPathElementTEXTPATH_SPACINGTYPE_AUTO* : uint16 = 0
const jsSVGTextPathElementTEXTPATH_SPACINGTYPE_EXACT* : uint16 = 0
proc jsSVGTextPathElementStartOffset*(self: SVGTextPathElement): JsObject =
  discard
proc jsSVGTextPathElementMethodVal*(self: SVGTextPathElement): JsObject =
  discard
proc jsSVGTextPathElementSpacing*(self: SVGTextPathElement): JsObject =
  discard

proc jsSVGTextPositioningElementX*(self: SVGTextPositioningElement): JsObject =
  discard
proc jsSVGTextPositioningElementY*(self: SVGTextPositioningElement): JsObject =
  discard
proc jsSVGTextPositioningElementDx*(self: SVGTextPositioningElement): JsObject =
  discard
proc jsSVGTextPositioningElementDy*(self: SVGTextPositioningElement): JsObject =
  discard
proc jsSVGTextPositioningElementRotate*(self: SVGTextPositioningElement): JsObject =
  discard


const jsSVGTransformSVG_TRANSFORM_UNKNOWN* : uint16 = 0
const jsSVGTransformSVG_TRANSFORM_MATRIX* : uint16 = 0
const jsSVGTransformSVG_TRANSFORM_TRANSLATE* : uint16 = 0
const jsSVGTransformSVG_TRANSFORM_SCALE* : uint16 = 0
const jsSVGTransformSVG_TRANSFORM_ROTATE* : uint16 = 0
const jsSVGTransformSVG_TRANSFORM_SKEWX* : uint16 = 0
const jsSVGTransformSVG_TRANSFORM_SKEWY* : uint16 = 0
proc jsSVGTransformTypeVal*(self: SVGTransform): uint16 =
  discard
proc jsSVGTransformMatrix*(self: SVGTransform): JsObject =
  discard
proc jsSVGTransformAngle*(self: SVGTransform): float32 =
  discard
proc jsSetMatrix*(self: SVGTransform; matrix: JsObject): void =
  discard
proc jsSetTranslate*(self: SVGTransform; tx: float32; ty: float32): void =
  discard
proc jsSetScale*(self: SVGTransform; sx: float32; sy: float32): void =
  discard
proc jsSetRotate*(self: SVGTransform; angle: float32; cx: float32; cy: float32): void =
  discard
proc jsSetSkewX*(self: SVGTransform; angle: float32): void =
  discard
proc jsSetSkewY*(self: SVGTransform; angle: float32): void =
  discard

proc jsSVGTransformListNumberOfItems*(self: SVGTransformList): uint32 =
  discard
proc jsClear*(self: SVGTransformList): void =
  discard
proc jsInitialize*(self: SVGTransformList; newItem: JsObject): JsObject =
  discard
proc jsGetItem*(self: SVGTransformList; index: uint32): JsObject =
  discard
proc jsInsertItemBefore*(self: SVGTransformList; newItem: JsObject; index: uint32): JsObject =
  discard
proc jsReplaceItem*(self: SVGTransformList; newItem: JsObject; index: uint32): JsObject =
  discard
proc jsRemoveItem*(self: SVGTransformList; index: uint32): JsObject =
  discard
proc jsAppendItem*(self: SVGTransformList; newItem: JsObject): JsObject =
  discard
proc jsCreateSVGTransformFromMatrix*(self: SVGTransformList; matrix: JsObject): JsObject =
  discard
proc jsConsolidate*(self: SVGTransformList): Option[JsObject] =
  discard

const jsSVGUnitTypesSVG_UNIT_TYPE_UNKNOWN* : uint16 = 0
const jsSVGUnitTypesSVG_UNIT_TYPE_USERSPACEONUSE* : uint16 = 0
const jsSVGUnitTypesSVG_UNIT_TYPE_OBJECTBOUNDINGBOX* : uint16 = 0

proc jsSVGUseElementX*(self: SVGUseElement): JsObject =
  discard
proc jsSVGUseElementY*(self: SVGUseElement): JsObject =
  discard
proc jsSVGUseElementWidth*(self: SVGUseElement): JsObject =
  discard
proc jsSVGUseElementHeight*(self: SVGUseElement): JsObject =
  discard



proc jsScreenAvailWidth*(self: Screen): int32 =
  discard
proc jsScreenAvailHeight*(self: Screen): int32 =
  discard
proc jsScreenWidth*(self: Screen): int32 =
  discard
proc jsScreenHeight*(self: Screen): int32 =
  discard
proc jsScreenColorDepth*(self: Screen): int32 =
  discard
proc jsScreenPixelDepth*(self: Screen): int32 =
  discard
proc jsScreenTop*(self: Screen): int32 =
  discard
proc jsScreenLeft*(self: Screen): int32 =
  discard
proc jsScreenAvailTop*(self: Screen): int32 =
  discard
proc jsScreenAvailLeft*(self: Screen): int32 =
  discard

proc jsScreenLuminanceMin*(self: ScreenLuminance): float64 =
  discard
proc jsScreenLuminanceMax*(self: ScreenLuminance): float64 =
  discard
proc jsScreenLuminanceMaxAverage*(self: ScreenLuminance): float64 =
  discard

proc jsScreenOrientationTypeVal*(self: ScreenOrientation): JsObject =
  discard
proc jsScreenOrientationAngle*(self: ScreenOrientation): uint16 =
  discard
proc jsScreenOrientationOnchange*(self: ScreenOrientation): JsObject =
  discard
proc jsLock*(self: ScreenOrientation; orientation: JsObject): JsObject =
  discard
proc jsUnlock*(self: ScreenOrientation): void =
  discard

proc jsScriptProcessorNodeOnaudioprocess*(self: ScriptProcessorNode): JsObject =
  discard
proc jsScriptProcessorNodeBufferSize*(self: ScriptProcessorNode): int32 =
  discard

proc jsScrollAreaEventX*(self: ScrollAreaEvent): float32 =
  discard
proc jsScrollAreaEventY*(self: ScrollAreaEvent): float32 =
  discard
proc jsScrollAreaEventWidth*(self: ScrollAreaEvent): float32 =
  discard
proc jsScrollAreaEventHeight*(self: ScrollAreaEvent): float32 =
  discard
proc jsInitScrollAreaEvent*(self: ScrollAreaEvent; typeVal: cstring; canBubble: bool; cancelable: bool; view: Option[JsObject]; detail: int32; x: float32; y: float32; width: float32; height: float32): void =
  discard

proc jsScrollBoxObjectPositionX*(self: ScrollBoxObject): int32 =
  discard
proc jsScrollBoxObjectPositionY*(self: ScrollBoxObject): int32 =
  discard
proc jsScrollBoxObjectScrolledWidth*(self: ScrollBoxObject): int32 =
  discard
proc jsScrollBoxObjectScrolledHeight*(self: ScrollBoxObject): int32 =
  discard
proc jsScrollTo*(self: ScrollBoxObject; x: int32; y: int32): void =
  discard
proc jsScrollBy*(self: ScrollBoxObject; dx: int32; dy: int32): void =
  discard
proc jsScrollByIndex*(self: ScrollBoxObject; dindexes: int32): void =
  discard
proc jsScrollToElement*(self: ScrollBoxObject; child: JsObject): void =
  discard
proc jsEnsureElementIsVisible*(self: ScrollBoxObject; child: JsObject): void =
  discard

proc jsScrollViewChangeEventState*(self: ScrollViewChangeEvent): JsObject =
  discard

proc jsSecurityPolicyViolationEventDocumentURI*(self: SecurityPolicyViolationEvent): cstring =
  discard
proc jsSecurityPolicyViolationEventReferrer*(self: SecurityPolicyViolationEvent): cstring =
  discard
proc jsSecurityPolicyViolationEventBlockedURI*(self: SecurityPolicyViolationEvent): cstring =
  discard
proc jsSecurityPolicyViolationEventViolatedDirective*(self: SecurityPolicyViolationEvent): cstring =
  discard
proc jsSecurityPolicyViolationEventEffectiveDirective*(self: SecurityPolicyViolationEvent): cstring =
  discard
proc jsSecurityPolicyViolationEventOriginalPolicy*(self: SecurityPolicyViolationEvent): cstring =
  discard
proc jsSecurityPolicyViolationEventSourceFile*(self: SecurityPolicyViolationEvent): cstring =
  discard
proc jsSecurityPolicyViolationEventSample*(self: SecurityPolicyViolationEvent): cstring =
  discard
proc jsSecurityPolicyViolationEventDisposition*(self: SecurityPolicyViolationEvent): JsObject =
  discard
proc jsSecurityPolicyViolationEventStatusCode*(self: SecurityPolicyViolationEvent): uint16 =
  discard
proc jsSecurityPolicyViolationEventLineNumber*(self: SecurityPolicyViolationEvent): int32 =
  discard
proc jsSecurityPolicyViolationEventColumnNumber*(self: SecurityPolicyViolationEvent): int32 =
  discard

proc jsSelectionAnchorOffset*(self: Selection): uint32 =
  discard
proc jsSelectionFocusOffset*(self: Selection): uint32 =
  discard
proc jsSelectionIsCollapsed*(self: Selection): bool =
  discard
proc jsSelectionRangeCount*(self: Selection): uint32 =
  discard
proc jsSelectionTypeVal*(self: Selection): cstring =
  discard
proc jsGetRangeAt*(self: Selection; index: uint32): JsObject =
  discard
proc jsAddRange*(self: Selection; range: JsObject): void =
  discard
proc jsRemoveRange*(self: Selection; range: JsObject): void =
  discard
proc jsRemoveAllRanges*(self: Selection): void =
  discard
proc jsEmpty*(self: Selection): void =
  discard
proc jsCollapse*(self: Selection; node: Option[JsObject]; offset: uint32): void =
  discard
proc jsSetPosition*(self: Selection; node: Option[JsObject]; offset: uint32): void =
  discard
proc jsCollapseToStart*(self: Selection): void =
  discard
proc jsCollapseToEnd*(self: Selection): void =
  discard
proc jsExtend*(self: Selection; node: JsObject; offset: uint32): void =
  discard
proc jsSetBaseAndExtent*(self: Selection; anchorNode: JsObject; anchorOffset: uint32; focusNode: JsObject; focusOffset: uint32): void =
  discard
proc jsSelectAllChildren*(self: Selection; node: JsObject): void =
  discard
proc jsDeleteFromDocument*(self: Selection): void =
  discard
proc jsContainsNode*(self: Selection; node: JsObject; allowPartialContainment: bool): bool =
  discard

proc jsServiceWorkerScriptURL*(self: ServiceWorker): cstring =
  discard
proc jsServiceWorkerState*(self: ServiceWorker): JsObject =
  discard
proc jsServiceWorkerOnstatechange*(self: ServiceWorker): JsObject =
  discard
proc jsPostMessage*(self: ServiceWorker; message: JsObject; transferable: JsObject): void =
  discard

proc jsServiceWorkerContainerReady*(self: ServiceWorkerContainer): JsObject =
  discard
proc jsServiceWorkerContainerOncontrollerchange*(self: ServiceWorkerContainer): JsObject =
  discard
proc jsServiceWorkerContainerOnerror*(self: ServiceWorkerContainer): JsObject =
  discard
proc jsServiceWorkerContainerOnmessage*(self: ServiceWorkerContainer): JsObject =
  discard
proc jsRegister*(self: ServiceWorkerContainer; scriptURL: cstring; options: JsObject): JsObject =
  discard
proc jsGetRegistration*(self: ServiceWorkerContainer; documentURL: cstring): JsObject =
  discard
proc jsGetRegistrations*(self: ServiceWorkerContainer): JsObject =
  discard

proc jsServiceWorkerGlobalScopeClients*(self: ServiceWorkerGlobalScope): JsObject =
  discard
proc jsServiceWorkerGlobalScopeRegistration*(self: ServiceWorkerGlobalScope): JsObject =
  discard
proc jsServiceWorkerGlobalScopeOninstall*(self: ServiceWorkerGlobalScope): JsObject =
  discard
proc jsServiceWorkerGlobalScopeOnactivate*(self: ServiceWorkerGlobalScope): JsObject =
  discard
proc jsServiceWorkerGlobalScopeOnfetch*(self: ServiceWorkerGlobalScope): JsObject =
  discard
proc jsServiceWorkerGlobalScopeOnmessage*(self: ServiceWorkerGlobalScope): JsObject =
  discard
proc jsSkipWaiting*(self: ServiceWorkerGlobalScope): JsObject =
  discard

proc jsServiceWorkerRegistrationScope*(self: ServiceWorkerRegistration): cstring =
  discard
proc jsServiceWorkerRegistrationUpdateViaCache*(self: ServiceWorkerRegistration): JsObject =
  discard
proc jsServiceWorkerRegistrationOnupdatefound*(self: ServiceWorkerRegistration): JsObject =
  discard
proc jsUpdate*(self: ServiceWorkerRegistration): JsObject =
  discard
proc jsUnregister*(self: ServiceWorkerRegistration): JsObject =
  discard

proc jsShadowRootMode*(self: ShadowRoot): JsObject =
  discard
proc jsShadowRootHost*(self: ShadowRoot): JsObject =
  discard
proc jsShadowRootInnerHTML*(self: ShadowRoot): cstring =
  discard
proc jsGetElementById*(self: ShadowRoot; elementId: cstring): Option[JsObject] =
  discard
proc jsGetElementsByTagName*(self: ShadowRoot; localName: cstring): JsObject =
  discard
proc jsGetElementsByTagNameNS*(self: ShadowRoot; namespace: Option[cstring]; localName: cstring): JsObject =
  discard
proc jsGetElementsByClassName*(self: ShadowRoot; classNames: cstring): JsObject =
  discard

proc jsSharedWorkerPort*(self: SharedWorker): JsObject =
  discard

proc jsSharedWorkerGlobalScopeName*(self: SharedWorkerGlobalScope): cstring =
  discard
proc jsSharedWorkerGlobalScopeOnconnect*(self: SharedWorkerGlobalScope): JsObject =
  discard
proc jsClose*(self: SharedWorkerGlobalScope): void =
  discard

proc jsSourceBufferMode*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferUpdating*(self: SourceBuffer): bool =
  discard
proc jsSourceBufferBuffered*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferTimestampOffset*(self: SourceBuffer): float64 =
  discard
proc jsSourceBufferAudioTracks*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferVideoTracks*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferTextTracks*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferAppendWindowStart*(self: SourceBuffer): float64 =
  discard
proc jsSourceBufferAppendWindowEnd*(self: SourceBuffer): float64 =
  discard
proc jsSourceBufferOnupdatestart*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferOnupdate*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferOnupdateend*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferOnerror*(self: SourceBuffer): JsObject =
  discard
proc jsSourceBufferOnabort*(self: SourceBuffer): JsObject =
  discard
proc jsAppendBuffer*(self: SourceBuffer; data: JsObject): void =
  discard
proc jsAppendBufferAsync*(self: SourceBuffer; data: JsObject): JsObject =
  discard
proc jsAbort*(self: SourceBuffer): void =
  discard
proc jsRemove*(self: SourceBuffer; start: float64; endVal: float64): void =
  discard
proc jsRemoveAsync*(self: SourceBuffer; start: float64; endVal: float64): JsObject =
  discard
proc jsChangeType*(self: SourceBuffer; typeVal: cstring): void =
  discard

proc jsSourceBufferListLength*(self: SourceBufferList): uint32 =
  discard
proc jsSourceBufferListOnaddsourcebuffer*(self: SourceBufferList): JsObject =
  discard
proc jsSourceBufferListOnremovesourcebuffer*(self: SourceBufferList): JsObject =
  discard

proc jsSpeechGrammarSrc*(self: SpeechGrammar): cstring =
  discard
proc jsSpeechGrammarWeight*(self: SpeechGrammar): float32 =
  discard

proc jsSpeechGrammarListLength*(self: SpeechGrammarList): uint32 =
  discard
proc jsItem*(self: SpeechGrammarList; index: uint32): JsObject =
  discard
proc jsAddFromURI*(self: SpeechGrammarList; src: cstring; weight: float32): void =
  discard
proc jsAddFromString*(self: SpeechGrammarList; string: cstring; weight: float32): void =
  discard

proc jsSpeechRecognitionGrammars*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionLang*(self: SpeechRecognition): cstring =
  discard
proc jsSpeechRecognitionContinuous*(self: SpeechRecognition): bool =
  discard
proc jsSpeechRecognitionInterimResults*(self: SpeechRecognition): bool =
  discard
proc jsSpeechRecognitionMaxAlternatives*(self: SpeechRecognition): uint32 =
  discard
proc jsSpeechRecognitionServiceURI*(self: SpeechRecognition): cstring =
  discard
proc jsSpeechRecognitionOnaudiostart*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnsoundstart*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnspeechstart*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnspeechend*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnsoundend*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnaudioend*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnresult*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnnomatch*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnerror*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnstart*(self: SpeechRecognition): JsObject =
  discard
proc jsSpeechRecognitionOnend*(self: SpeechRecognition): JsObject =
  discard
proc jsStart*(self: SpeechRecognition; stream: JsObject): void =
  discard
proc jsStop*(self: SpeechRecognition): void =
  discard
proc jsAbort*(self: SpeechRecognition): void =
  discard

proc jsSpeechRecognitionAlternativeTranscript*(self: SpeechRecognitionAlternative): cstring =
  discard
proc jsSpeechRecognitionAlternativeConfidence*(self: SpeechRecognitionAlternative): float32 =
  discard

proc jsSpeechRecognitionErrorError*(self: SpeechRecognitionError): JsObject =
  discard

proc jsSpeechRecognitionEventResultIndex*(self: SpeechRecognitionEvent): uint32 =
  discard
proc jsSpeechRecognitionEventInterpretation*(self: SpeechRecognitionEvent): JsObject =
  discard

proc jsSpeechRecognitionResultLength*(self: SpeechRecognitionResult): uint32 =
  discard
proc jsSpeechRecognitionResultIsFinal*(self: SpeechRecognitionResult): bool =
  discard
proc jsItem*(self: SpeechRecognitionResult; index: uint32): JsObject =
  discard

proc jsSpeechRecognitionResultListLength*(self: SpeechRecognitionResultList): uint32 =
  discard
proc jsItem*(self: SpeechRecognitionResultList; index: uint32): JsObject =
  discard

proc jsSpeechSynthesisPending*(self: SpeechSynthesis): bool =
  discard
proc jsSpeechSynthesisSpeaking*(self: SpeechSynthesis): bool =
  discard
proc jsSpeechSynthesisPaused*(self: SpeechSynthesis): bool =
  discard
proc jsSpeechSynthesisOnvoiceschanged*(self: SpeechSynthesis): JsObject =
  discard
proc jsSpeak*(self: SpeechSynthesis; utterance: JsObject): void =
  discard
proc jsCancel*(self: SpeechSynthesis): void =
  discard
proc jsPause*(self: SpeechSynthesis): void =
  discard
proc jsResume*(self: SpeechSynthesis): void =
  discard
proc jsGetVoices*(self: SpeechSynthesis): JsObject =
  discard
proc jsForceEnd*(self: SpeechSynthesis): void =
  discard

proc jsSpeechSynthesisErrorEventError*(self: SpeechSynthesisErrorEvent): JsObject =
  discard

proc jsSpeechSynthesisEventUtterance*(self: SpeechSynthesisEvent): JsObject =
  discard
proc jsSpeechSynthesisEventCharIndex*(self: SpeechSynthesisEvent): uint32 =
  discard
proc jsSpeechSynthesisEventElapsedTime*(self: SpeechSynthesisEvent): float32 =
  discard

proc jsSpeechSynthesisUtteranceText*(self: SpeechSynthesisUtterance): cstring =
  discard
proc jsSpeechSynthesisUtteranceLang*(self: SpeechSynthesisUtterance): cstring =
  discard
proc jsSpeechSynthesisUtteranceVolume*(self: SpeechSynthesisUtterance): float32 =
  discard
proc jsSpeechSynthesisUtteranceRate*(self: SpeechSynthesisUtterance): float32 =
  discard
proc jsSpeechSynthesisUtterancePitch*(self: SpeechSynthesisUtterance): float32 =
  discard
proc jsSpeechSynthesisUtteranceOnstart*(self: SpeechSynthesisUtterance): JsObject =
  discard
proc jsSpeechSynthesisUtteranceOnend*(self: SpeechSynthesisUtterance): JsObject =
  discard
proc jsSpeechSynthesisUtteranceOnerror*(self: SpeechSynthesisUtterance): JsObject =
  discard
proc jsSpeechSynthesisUtteranceOnpause*(self: SpeechSynthesisUtterance): JsObject =
  discard
proc jsSpeechSynthesisUtteranceOnresume*(self: SpeechSynthesisUtterance): JsObject =
  discard
proc jsSpeechSynthesisUtteranceOnmark*(self: SpeechSynthesisUtterance): JsObject =
  discard
proc jsSpeechSynthesisUtteranceOnboundary*(self: SpeechSynthesisUtterance): JsObject =
  discard
proc jsSpeechSynthesisUtteranceChosenVoiceURI*(self: SpeechSynthesisUtterance): cstring =
  discard

proc jsSpeechSynthesisVoiceVoiceURI*(self: SpeechSynthesisVoice): cstring =
  discard
proc jsSpeechSynthesisVoiceName*(self: SpeechSynthesisVoice): cstring =
  discard
proc jsSpeechSynthesisVoiceLang*(self: SpeechSynthesisVoice): cstring =
  discard
proc jsSpeechSynthesisVoiceLocalService*(self: SpeechSynthesisVoice): bool =
  discard
proc jsSpeechSynthesisVoiceDefault*(self: SpeechSynthesisVoice): bool =
  discard


proc jsStereoPannerNodePan*(self: StereoPannerNode): JsObject =
  discard

proc jsStorageLength*(self: Storage): uint32 =
  discard
proc jsStorageIsSessionOnly*(self: Storage): bool =
  discard
proc jsKey*(self: Storage; index: uint32): Option[cstring] =
  discard
proc jsGetItem*(self: Storage; key: cstring): Option[cstring] =
  discard
proc jsSetItem*(self: Storage; key: cstring; value: cstring): void =
  discard
proc jsRemoveItem*(self: Storage; key: cstring): void =
  discard
proc jsClear*(self: Storage): void =
  discard

proc jsInitStorageEvent*(self: StorageEvent; typeVal: cstring; canBubble: bool; cancelable: bool; key: Option[cstring]; oldValue: Option[cstring]; newValue: Option[cstring]; url: Option[cstring]; storageArea: Option[JsObject]): void =
  discard

proc jsPersisted*(self: StorageManager): JsObject =
  discard
proc jsPersist*(self: StorageManager): JsObject =
  discard
proc jsEstimate*(self: StorageManager): JsObject =
  discard

proc jsReadableStreamLocked*(self: ReadableStream): bool =
  discard
proc jsReadableStreamIterable*(self: ReadableStream): JsObject =
  discard
proc jsReadableStreamAny*(self: ReadableStream): JsObject =
  discard
proc jsReadableStreamReadableStreamIteratorOptions*(self: ReadableStream): JsObject =
  discard
proc jsCancel*(self: ReadableStream; reason: JsObject): JsObject =
  discard
proc jsGetReader*(self: ReadableStream; options: JsObject): JsObject =
  discard
proc jsPipeThrough*(self: ReadableStream; transform: JsObject; options: JsObject): JsObject =
  discard
proc jsPipeTo*(self: ReadableStream; destination: JsObject; options: JsObject): JsObject =
  discard
proc jsTee*(self: ReadableStream): JsObject =
  discard

proc jsRead*(self: ReadableStreamDefaultReader): JsObject =
  discard
proc jsReleaseLock*(self: ReadableStreamDefaultReader): void =
  discard

proc jsRead*(self: ReadableStreamBYOBReader; view: JsObject): JsObject =
  discard
proc jsReleaseLock*(self: ReadableStreamBYOBReader): void =
  discard

proc jsClose*(self: ReadableStreamDefaultController): void =
  discard
proc jsEnqueue*(self: ReadableStreamDefaultController; chunk: JsObject): void =
  discard
proc jsError*(self: ReadableStreamDefaultController; e: JsObject): void =
  discard

proc jsClose*(self: ReadableByteStreamController): void =
  discard
proc jsEnqueue*(self: ReadableByteStreamController; chunk: JsObject): void =
  discard
proc jsError*(self: ReadableByteStreamController; e: JsObject): void =
  discard

proc jsRespond*(self: ReadableStreamBYOBRequest; bytesWritten: uint64): void =
  discard
proc jsRespondWithNewView*(self: ReadableStreamBYOBRequest; view: JsObject): void =
  discard

proc jsWritableStreamLocked*(self: WritableStream): bool =
  discard
proc jsAbort*(self: WritableStream; reason: JsObject): JsObject =
  discard
proc jsClose*(self: WritableStream): JsObject =
  discard
proc jsGetWriter*(self: WritableStream): JsObject =
  discard

proc jsWritableStreamDefaultWriterClosed*(self: WritableStreamDefaultWriter): JsObject =
  discard
proc jsWritableStreamDefaultWriterReady*(self: WritableStreamDefaultWriter): JsObject =
  discard
proc jsAbort*(self: WritableStreamDefaultWriter; reason: JsObject): JsObject =
  discard
proc jsClose*(self: WritableStreamDefaultWriter): JsObject =
  discard
proc jsReleaseLock*(self: WritableStreamDefaultWriter): void =
  discard
proc jsWrite*(self: WritableStreamDefaultWriter; chunk: JsObject): JsObject =
  discard

proc jsWritableStreamDefaultControllerSignal*(self: WritableStreamDefaultController): JsObject =
  discard
proc jsError*(self: WritableStreamDefaultController; e: JsObject): void =
  discard

proc jsTransformStreamReadable*(self: TransformStream): JsObject =
  discard
proc jsTransformStreamWritable*(self: TransformStream): JsObject =
  discard

proc jsEnqueue*(self: TransformStreamDefaultController; chunk: JsObject): void =
  discard
proc jsError*(self: TransformStreamDefaultController; reason: JsObject): void =
  discard
proc jsTerminate*(self: TransformStreamDefaultController): void =
  discard

proc jsByteLengthQueuingStrategyHighWaterMark*(self: ByteLengthQueuingStrategy): float64 =
  discard
proc jsByteLengthQueuingStrategySize*(self: ByteLengthQueuingStrategy): JsObject =
  discard

proc jsCountQueuingStrategyHighWaterMark*(self: CountQueuingStrategy): float64 =
  discard
proc jsCountQueuingStrategySize*(self: CountQueuingStrategy): JsObject =
  discard


proc jsStyleSheetTypeVal*(self: StyleSheet): cstring =
  discard
proc jsStyleSheetMedia*(self: StyleSheet): JsObject =
  discard
proc jsStyleSheetDisabled*(self: StyleSheet): bool =
  discard
proc jsStyleSheetSourceMapURL*(self: StyleSheet): cstring =
  discard
proc jsStyleSheetSourceURL*(self: StyleSheet): cstring =
  discard

proc jsStyleSheetApplicableStateChangeEventApplicable*(self: StyleSheetApplicableStateChangeEvent): bool =
  discard

proc jsStyleSheetChangeEventDocumentSheet*(self: StyleSheetChangeEvent): bool =
  discard

proc jsStyleSheetListLength*(self: StyleSheetList): uint32 =
  discard
proc jsItem*(self: StyleSheetList; index: uint32): Option[JsObject] =
  discard


proc jsCryptoKeyTypeVal*(self: CryptoKey): JsObject =
  discard
proc jsCryptoKeyExtractable*(self: CryptoKey): bool =
  discard
proc jsCryptoKeyAlgorithm*(self: CryptoKey): JsObject =
  discard
proc jsCryptoKeyUsages*(self: CryptoKey): JsObject =
  discard

proc jsEncrypt*(self: SubtleCrypto; algorithm: JsObject; key: JsObject; data: JsObject): JsObject =
  discard
proc jsDecrypt*(self: SubtleCrypto; algorithm: JsObject; key: JsObject; data: JsObject): JsObject =
  discard
proc jsSign*(self: SubtleCrypto; algorithm: JsObject; key: JsObject; data: JsObject): JsObject =
  discard
proc jsVerify*(self: SubtleCrypto; algorithm: JsObject; key: JsObject; signature: JsObject; data: JsObject): JsObject =
  discard
proc jsDigest*(self: SubtleCrypto; algorithm: JsObject; data: JsObject): JsObject =
  discard
proc jsGenerateKey*(self: SubtleCrypto; algorithm: JsObject; extractable: bool; keyUsages: JsObject): JsObject =
  discard
proc jsDeriveKey*(self: SubtleCrypto; algorithm: JsObject; baseKey: JsObject; derivedKeyType: JsObject; extractable: bool; keyUsages: JsObject): JsObject =
  discard
proc jsDeriveBits*(self: SubtleCrypto; algorithm: JsObject; baseKey: JsObject; length: uint32): JsObject =
  discard
proc jsImportKey*(self: SubtleCrypto; format: JsObject; keyData: JsObject; algorithm: JsObject; extractable: bool; keyUsages: JsObject): JsObject =
  discard
proc jsExportKey*(self: SubtleCrypto; format: JsObject; key: JsObject): JsObject =
  discard
proc jsWrapKey*(self: SubtleCrypto; format: JsObject; key: JsObject; wrappingKey: JsObject; wrapAlgorithm: JsObject): JsObject =
  discard
proc jsUnwrapKey*(self: SubtleCrypto; format: JsObject; wrappedKey: JsObject; unwrappingKey: JsObject; unwrapAlgorithm: JsObject; unwrappedKeyAlgorithm: JsObject; extractable: bool; keyUsages: JsObject): JsObject =
  discard

proc jsTCPServerSocketLocalPort*(self: TCPServerSocket): uint16 =
  discard
proc jsTCPServerSocketOnconnect*(self: TCPServerSocket): JsObject =
  discard
proc jsTCPServerSocketOnerror*(self: TCPServerSocket): JsObject =
  discard
proc jsClose*(self: TCPServerSocket): void =
  discard

proc jsTCPServerSocketEventSocket*(self: TCPServerSocketEvent): JsObject =
  discard

proc jsTCPSocketHost*(self: TCPSocket): cstring =
  discard
proc jsTCPSocketPort*(self: TCPSocket): uint16 =
  discard
proc jsTCPSocketSsl*(self: TCPSocket): bool =
  discard
proc jsTCPSocketBufferedAmount*(self: TCPSocket): uint64 =
  discard
proc jsTCPSocketReadyState*(self: TCPSocket): JsObject =
  discard
proc jsTCPSocketBinaryType*(self: TCPSocket): JsObject =
  discard
proc jsTCPSocketOnopen*(self: TCPSocket): JsObject =
  discard
proc jsTCPSocketOndrain*(self: TCPSocket): JsObject =
  discard
proc jsTCPSocketOndata*(self: TCPSocket): JsObject =
  discard
proc jsTCPSocketOnerror*(self: TCPSocket): JsObject =
  discard
proc jsTCPSocketOnclose*(self: TCPSocket): JsObject =
  discard
proc jsUpgradeToSecure*(self: TCPSocket): void =
  discard
proc jsSuspend*(self: TCPSocket): void =
  discard
proc jsResume*(self: TCPSocket): void =
  discard
proc jsClose*(self: TCPSocket): void =
  discard
proc jsCloseImmediately*(self: TCPSocket): void =
  discard
proc jsSend*(self: TCPSocket; data: cstring): bool =
  discard
proc jsSend*(self: TCPSocket; data: JsObject; byteOffset: uint32; byteLength: uint32): bool =
  discard

proc jsTCPSocketErrorEventName*(self: TCPSocketErrorEvent): cstring =
  discard
proc jsTCPSocketErrorEventMessage*(self: TCPSocketErrorEvent): cstring =
  discard

proc jsTCPSocketEventData*(self: TCPSocketEvent): JsObject =
  discard

proc jsTextWholeText*(self: Text): cstring =
  discard
proc jsSplitText*(self: Text; offset: uint32): JsObject =
  discard

proc jsTextClauseStartOffset*(self: TextClause): int32 =
  discard
proc jsTextClauseEndOffset*(self: TextClause): int32 =
  discard
proc jsTextClauseIsCaret*(self: TextClause): bool =
  discard
proc jsTextClauseIsTargetClause*(self: TextClause): bool =
  discard

proc jsTextDecoderEncoding*(self: TextDecoder): cstring =
  discard
proc jsTextDecoderFatal*(self: TextDecoder): bool =
  discard
proc jsDecode*(self: TextDecoder; input: JsObject; options: JsObject): cstring =
  discard

proc jsTextEncoderEncoding*(self: TextEncoder): cstring =
  discard
proc jsEncode*(self: TextEncoder; input: cstring): seq[uint8] =
  discard

proc jsTextTrackKind*(self: TextTrack): JsObject =
  discard
proc jsTextTrackLabel*(self: TextTrack): cstring =
  discard
proc jsTextTrackLanguage*(self: TextTrack): cstring =
  discard
proc jsTextTrackId*(self: TextTrack): cstring =
  discard
proc jsTextTrackInBandMetadataTrackDispatchType*(self: TextTrack): cstring =
  discard
proc jsTextTrackMode*(self: TextTrack): JsObject =
  discard
proc jsTextTrackOncuechange*(self: TextTrack): JsObject =
  discard
proc jsAddCue*(self: TextTrack; cue: JsObject): void =
  discard
proc jsRemoveCue*(self: TextTrack; cue: JsObject): void =
  discard

proc jsTextTrackCueId*(self: TextTrackCue): cstring =
  discard
proc jsTextTrackCueStartTime*(self: TextTrackCue): float64 =
  discard
proc jsTextTrackCueEndTime*(self: TextTrackCue): float64 =
  discard
proc jsTextTrackCuePauseOnExit*(self: TextTrackCue): bool =
  discard
proc jsTextTrackCueOnenter*(self: TextTrackCue): JsObject =
  discard
proc jsTextTrackCueOnexit*(self: TextTrackCue): JsObject =
  discard

proc jsTextTrackCueListLength*(self: TextTrackCueList): uint32 =
  discard
proc jsGetCueById*(self: TextTrackCueList; id: cstring): Option[JsObject] =
  discard

proc jsTextTrackListLength*(self: TextTrackList): uint32 =
  discard
proc jsTextTrackListOnchange*(self: TextTrackList): JsObject =
  discard
proc jsTextTrackListOnaddtrack*(self: TextTrackList): JsObject =
  discard
proc jsTextTrackListOnremovetrack*(self: TextTrackList): JsObject =
  discard
proc jsGetTrackById*(self: TextTrackList; id: cstring): Option[JsObject] =
  discard

proc jsTimeEventDetail*(self: TimeEvent): int32 =
  discard
proc jsInitTimeEvent*(self: TimeEvent; aType: cstring; aView: Option[JsObject]; aDetail: int32): void =
  discard

proc jsTimeRangesLength*(self: TimeRanges): uint32 =
  discard
proc jsStart*(self: TimeRanges; index: uint32): float64 =
  discard
proc jsEndVal*(self: TimeRanges; index: uint32): float64 =
  discard

proc jsToggleEventOldState*(self: ToggleEvent): cstring =
  discard
proc jsToggleEventNewState*(self: ToggleEvent): cstring =
  discard

proc jsTouchIdentifier*(self: Touch): int32 =
  discard
proc jsTouchScreenX*(self: Touch): int32 =
  discard
proc jsTouchScreenY*(self: Touch): int32 =
  discard
proc jsTouchClientX*(self: Touch): int32 =
  discard
proc jsTouchClientY*(self: Touch): int32 =
  discard
proc jsTouchPageX*(self: Touch): int32 =
  discard
proc jsTouchPageY*(self: Touch): int32 =
  discard
proc jsTouchRadiusX*(self: Touch): int32 =
  discard
proc jsTouchRadiusY*(self: Touch): int32 =
  discard
proc jsTouchRotationAngle*(self: Touch): float32 =
  discard
proc jsTouchForce*(self: Touch): float32 =
  discard

proc jsTouchEventTouches*(self: TouchEvent): JsObject =
  discard
proc jsTouchEventTargetTouches*(self: TouchEvent): JsObject =
  discard
proc jsTouchEventChangedTouches*(self: TouchEvent): JsObject =
  discard
proc jsTouchEventAltKey*(self: TouchEvent): bool =
  discard
proc jsTouchEventMetaKey*(self: TouchEvent): bool =
  discard
proc jsTouchEventCtrlKey*(self: TouchEvent): bool =
  discard
proc jsTouchEventShiftKey*(self: TouchEvent): bool =
  discard
proc jsInitTouchEvent*(self: TouchEvent; typeVal: cstring; canBubble: bool; cancelable: bool; view: Option[JsObject]; detail: int32; ctrlKey: bool; altKey: bool; shiftKey: bool; metaKey: bool; touches: Option[JsObject]; targetTouches: Option[JsObject]; changedTouches: Option[JsObject]): void =
  discard

proc jsTouchListLength*(self: TouchList): uint32 =
  discard
proc jsItem*(self: TouchList; index: uint32): Option[JsObject] =
  discard


proc jsTransitionEventPropertyName*(self: TransitionEvent): cstring =
  discard
proc jsTransitionEventElapsedTime*(self: TransitionEvent): float32 =
  discard
proc jsTransitionEventPseudoElement*(self: TransitionEvent): cstring =
  discard

proc jsTreeBoxObjectFocused*(self: TreeBoxObject): bool =
  discard
proc jsTreeBoxObjectRowHeight*(self: TreeBoxObject): int32 =
  discard
proc jsTreeBoxObjectRowWidth*(self: TreeBoxObject): int32 =
  discard
proc jsTreeBoxObjectHorizontalPosition*(self: TreeBoxObject): int32 =
  discard
proc jsTreeBoxObjectSelectionRegion*(self: TreeBoxObject): JsObject =
  discard
proc jsGetFirstVisibleRow*(self: TreeBoxObject): int32 =
  discard
proc jsGetLastVisibleRow*(self: TreeBoxObject): int32 =
  discard
proc jsGetPageLength*(self: TreeBoxObject): int32 =
  discard
proc jsEnsureRowIsVisible*(self: TreeBoxObject; index: int32): void =
  discard
proc jsEnsureCellIsVisible*(self: TreeBoxObject; row: int32; col: Option[JsObject]): void =
  discard
proc jsScrollToRow*(self: TreeBoxObject; index: int32): void =
  discard
proc jsScrollByLines*(self: TreeBoxObject; numLines: int32): void =
  discard
proc jsScrollByPages*(self: TreeBoxObject; numPages: int32): void =
  discard
proc jsInvalidate*(self: TreeBoxObject): void =
  discard
proc jsInvalidateColumn*(self: TreeBoxObject; col: Option[JsObject]): void =
  discard
proc jsInvalidateRow*(self: TreeBoxObject; index: int32): void =
  discard
proc jsInvalidateCell*(self: TreeBoxObject; row: int32; col: Option[JsObject]): void =
  discard
proc jsInvalidateRange*(self: TreeBoxObject; startIndex: int32; endIndex: int32): void =
  discard
proc jsGetRowAt*(self: TreeBoxObject; x: int32; y: int32): int32 =
  discard
proc jsGetCellAt*(self: TreeBoxObject; x: int32; y: int32): JsObject =
  discard
proc jsGetCellAt*(self: TreeBoxObject; x: int32; y: int32; row: JsObject; column: JsObject; childElt: JsObject): void =
  discard
proc jsGetCoordsForCellItem*(self: TreeBoxObject; row: int32; col: JsObject; element: cstring): Option[JsObject] =
  discard
proc jsGetCoordsForCellItem*(self: TreeBoxObject; row: int32; col: JsObject; element: cstring; x: JsObject; y: JsObject; width: JsObject; height: JsObject): void =
  discard
proc jsIsCellCropped*(self: TreeBoxObject; row: int32; col: Option[JsObject]): bool =
  discard
proc jsRowCountChanged*(self: TreeBoxObject; index: int32; count: int32): void =
  discard
proc jsBeginUpdateBatch*(self: TreeBoxObject): void =
  discard
proc jsEndUpdateBatch*(self: TreeBoxObject): void =
  discard
proc jsClearStyleAndImageCaches*(self: TreeBoxObject): void =
  discard
proc jsRemoveImageCacheEntry*(self: TreeBoxObject; row: int32; col: JsObject): void =
  discard

proc jsTreeViewRowCount*(self: TreeView): int32 =
  discard
const jsTreeViewDROP_BEFORE* : int16 = 0
const jsTreeViewDROP_ON* : int16 = 0
const jsTreeViewDROP_AFTER* : int16 = 0
proc jsGetRowProperties*(self: TreeView; row: int32): cstring =
  discard
proc jsGetCellProperties*(self: TreeView; row: int32; column: JsObject): cstring =
  discard
proc jsGetColumnProperties*(self: TreeView; column: JsObject): cstring =
  discard
proc jsIsContainer*(self: TreeView; row: int32): bool =
  discard
proc jsIsContainerOpen*(self: TreeView; row: int32): bool =
  discard
proc jsIsContainerEmpty*(self: TreeView; row: int32): bool =
  discard
proc jsIsSeparator*(self: TreeView; row: int32): bool =
  discard
proc jsIsSorted*(self: TreeView): bool =
  discard
proc jsCanDrop*(self: TreeView; row: int32; orientation: int32; dataTransfer: Option[JsObject]): bool =
  discard
proc jsDrop*(self: TreeView; row: int32; orientation: int32; dataTransfer: Option[JsObject]): void =
  discard
proc jsGetParentIndex*(self: TreeView; row: int32): int32 =
  discard
proc jsHasNextSibling*(self: TreeView; row: int32; afterIndex: int32): bool =
  discard
proc jsGetLevel*(self: TreeView; row: int32): int32 =
  discard
proc jsGetImageSrc*(self: TreeView; row: int32; column: JsObject): cstring =
  discard
proc jsGetCellValue*(self: TreeView; row: int32; column: JsObject): cstring =
  discard
proc jsGetCellText*(self: TreeView; row: int32; column: JsObject): cstring =
  discard
proc jsSetTree*(self: TreeView; tree: Option[JsObject]): void =
  discard
proc jsToggleOpenState*(self: TreeView; row: int32): void =
  discard
proc jsCycleHeader*(self: TreeView; column: JsObject): void =
  discard
proc jsSelectionChanged*(self: TreeView): void =
  discard
proc jsCycleCell*(self: TreeView; row: int32; column: JsObject): void =
  discard
proc jsIsEditable*(self: TreeView; row: int32; column: JsObject): bool =
  discard
proc jsIsSelectable*(self: TreeView; row: int32; column: JsObject): bool =
  discard
proc jsSetCellValue*(self: TreeView; row: int32; column: JsObject; value: cstring): void =
  discard
proc jsSetCellText*(self: TreeView; row: int32; column: JsObject; value: cstring): void =
  discard
proc jsPerformAction*(self: TreeView; action: cstring): void =
  discard
proc jsPerformActionOnRow*(self: TreeView; action: cstring; row: int32): void =
  discard
proc jsPerformActionOnCell*(self: TreeView; action: cstring; row: int32; column: JsObject): void =
  discard

proc jsTreeWalkerRoot*(self: TreeWalker): JsObject =
  discard
proc jsTreeWalkerWhatToShow*(self: TreeWalker): uint32 =
  discard
proc jsTreeWalkerCurrentNode*(self: TreeWalker): JsObject =
  discard
proc jsParentNode*(self: TreeWalker): Option[JsObject] =
  discard
proc jsFirstChild*(self: TreeWalker): Option[JsObject] =
  discard
proc jsLastChild*(self: TreeWalker): Option[JsObject] =
  discard
proc jsPreviousSibling*(self: TreeWalker): Option[JsObject] =
  discard
proc jsNextSibling*(self: TreeWalker): Option[JsObject] =
  discard
proc jsPreviousNode*(self: TreeWalker): Option[JsObject] =
  discard
proc jsNextNode*(self: TreeWalker): Option[JsObject] =
  discard

const jsU2FOK* : uint16 = 0
const jsU2FOTHER_ERROR* : uint16 = 0
const jsU2FBAD_REQUEST* : uint16 = 0
const jsU2FCONFIGURATION_UNSUPPORTED* : uint16 = 0
const jsU2FDEVICE_INELIGIBLE* : uint16 = 0
const jsU2FTIMEOUT* : uint16 = 0
proc jsRegister*(self: U2F; appId: cstring; registerRequests: JsObject; registeredKeys: JsObject; callback: JsObject; opt_timeoutSeconds: Option[int32]): void =
  discard
proc jsSign*(self: U2F; appId: cstring; challenge: cstring; registeredKeys: JsObject; callback: JsObject; opt_timeoutSeconds: Option[int32]): void =
  discard

proc jsUDPMessageEventRemoteAddress*(self: UDPMessageEvent): cstring =
  discard
proc jsUDPMessageEventRemotePort*(self: UDPMessageEvent): uint16 =
  discard
proc jsUDPMessageEventData*(self: UDPMessageEvent): JsObject =
  discard

proc jsUDPSocketAddressReuse*(self: UDPSocket): bool =
  discard
proc jsUDPSocketLoopback*(self: UDPSocket): bool =
  discard
proc jsUDPSocketReadyState*(self: UDPSocket): JsObject =
  discard
proc jsUDPSocketOpened*(self: UDPSocket): JsObject =
  discard
proc jsUDPSocketClosed*(self: UDPSocket): JsObject =
  discard
proc jsUDPSocketOnmessage*(self: UDPSocket): JsObject =
  discard
proc jsClose*(self: UDPSocket): JsObject =
  discard
proc jsJoinMulticastGroup*(self: UDPSocket; multicastGroupAddress: cstring): void =
  discard
proc jsLeaveMulticastGroup*(self: UDPSocket; multicastGroupAddress: cstring): void =
  discard
proc jsSend*(self: UDPSocket; data: JsObject; remoteAddress: Option[cstring]; remotePort: Option[uint16]): bool =
  discard

proc jsUIEventDetail*(self: UIEvent): int32 =
  discard
proc jsInitUIEvent*(self: UIEvent; aType: cstring; aCanBubble: bool; aCancelable: bool; aView: Option[JsObject]; aDetail: int32): void =
  discard

proc jsURLHref*(self: URL): cstring =
  discard
proc jsURLOrigin*(self: URL): cstring =
  discard
proc jsURLProtocol*(self: URL): cstring =
  discard
proc jsURLUsername*(self: URL): cstring =
  discard
proc jsURLPassword*(self: URL): cstring =
  discard
proc jsURLHost*(self: URL): cstring =
  discard
proc jsURLHostname*(self: URL): cstring =
  discard
proc jsURLPort*(self: URL): cstring =
  discard
proc jsURLPathname*(self: URL): cstring =
  discard
proc jsURLSearch*(self: URL): cstring =
  discard
proc jsURLSearchParams*(self: URL): JsObject =
  discard
proc jsURLHash*(self: URL): cstring =
  discard
proc jsToJSON*(self: URL): cstring =
  discard

proc jsAppend*(self: URLSearchParams; name: cstring; value: cstring): void =
  discard
proc jsDelete*(self: URLSearchParams; name: cstring): void =
  discard
proc jsGet*(self: URLSearchParams; name: cstring): Option[cstring] =
  discard
proc jsGetAll*(self: URLSearchParams; name: cstring): JsObject =
  discard
proc jsHas*(self: URLSearchParams; name: cstring): bool =
  discard
proc jsSet*(self: URLSearchParams; name: cstring; value: cstring): void =
  discard
proc jsSort*(self: URLSearchParams): void =
  discard

proc jsUserActivationHasBeenActive*(self: UserActivation): bool =
  discard
proc jsUserActivationIsActive*(self: UserActivation): bool =
  discard

proc jsUserProximityEventNear*(self: UserProximityEvent): bool =
  discard

proc jsVRFieldOfViewUpDegrees*(self: VRFieldOfView): float64 =
  discard
proc jsVRFieldOfViewRightDegrees*(self: VRFieldOfView): float64 =
  discard
proc jsVRFieldOfViewDownDegrees*(self: VRFieldOfView): float64 =
  discard
proc jsVRFieldOfViewLeftDegrees*(self: VRFieldOfView): float64 =
  discard

proc jsVRDisplayCapabilitiesHasPosition*(self: VRDisplayCapabilities): bool =
  discard
proc jsVRDisplayCapabilitiesHasOrientation*(self: VRDisplayCapabilities): bool =
  discard
proc jsVRDisplayCapabilitiesHasExternalDisplay*(self: VRDisplayCapabilities): bool =
  discard
proc jsVRDisplayCapabilitiesCanPresent*(self: VRDisplayCapabilities): bool =
  discard
proc jsVRDisplayCapabilitiesMaxLayers*(self: VRDisplayCapabilities): uint32 =
  discard

proc jsVRStageParametersSizeX*(self: VRStageParameters): float32 =
  discard
proc jsVRStageParametersSizeZ*(self: VRStageParameters): float32 =
  discard


proc jsVRFrameDataTimestamp*(self: VRFrameData): JsObject =
  discard
proc jsVRFrameDataPose*(self: VRFrameData): JsObject =
  discard

proc jsVRSubmitFrameResultFrameNum*(self: VRSubmitFrameResult): uint32 =
  discard

proc jsVREyeParametersFieldOfView*(self: VREyeParameters): JsObject =
  discard
proc jsVREyeParametersRenderWidth*(self: VREyeParameters): uint32 =
  discard
proc jsVREyeParametersRenderHeight*(self: VREyeParameters): uint32 =
  discard

proc jsVRDisplayPresentingGroups*(self: VRDisplay): uint32 =
  discard
proc jsVRDisplayGroupMask*(self: VRDisplay): uint32 =
  discard
proc jsVRDisplayIsConnected*(self: VRDisplay): bool =
  discard
proc jsVRDisplayIsPresenting*(self: VRDisplay): bool =
  discard
proc jsVRDisplayCapabilities*(self: VRDisplay): JsObject =
  discard
proc jsVRDisplayDisplayId*(self: VRDisplay): uint32 =
  discard
proc jsVRDisplayDisplayName*(self: VRDisplay): cstring =
  discard
proc jsVRDisplayDepthNear*(self: VRDisplay): float64 =
  discard
proc jsVRDisplayDepthFar*(self: VRDisplay): float64 =
  discard
proc jsGetEyeParameters*(self: VRDisplay; whichEye: JsObject): JsObject =
  discard
proc jsGetFrameData*(self: VRDisplay; frameData: JsObject): bool =
  discard
proc jsGetPose*(self: VRDisplay): JsObject =
  discard
proc jsGetSubmitFrameResult*(self: VRDisplay; resultVal: JsObject): bool =
  discard
proc jsResetPose*(self: VRDisplay): void =
  discard
proc jsRequestAnimationFrame*(self: VRDisplay; callback: JsObject): int32 =
  discard
proc jsCancelAnimationFrame*(self: VRDisplay; handle: int32): void =
  discard
proc jsRequestPresent*(self: VRDisplay; layers: JsObject): JsObject =
  discard
proc jsExitPresent*(self: VRDisplay): JsObject =
  discard
proc jsGetLayers*(self: VRDisplay): JsObject =
  discard
proc jsSubmitFrame*(self: VRDisplay): void =
  discard

proc jsSetEyeResolution*(self: VRMockDisplay; aRenderWidth: uint32; aRenderHeight: uint32): void =
  discard
proc jsSetEyeParameter*(self: VRMockDisplay; eye: JsObject; offsetX: float64; offsetY: float64; offsetZ: float64; upDegree: float64; rightDegree: float64; downDegree: float64; leftDegree: float64): void =
  discard
proc jsSetPose*(self: VRMockDisplay; position: Option[seq[float32]]; linearVelocity: Option[seq[float32]]; linearAcceleration: Option[seq[float32]]; orientation: Option[seq[float32]]; angularVelocity: Option[seq[float32]]; angularAcceleration: Option[seq[float32]]): void =
  discard
proc jsSetMountState*(self: VRMockDisplay; isMounted: bool): void =
  discard
proc jsUpdate*(self: VRMockDisplay): void =
  discard

proc jsNewButtonEvent*(self: VRMockController; button: uint32; pressed: bool): void =
  discard
proc jsNewAxisMoveEvent*(self: VRMockController; axis: uint32; value: float64): void =
  discard
proc jsNewPoseMove*(self: VRMockController; position: Option[seq[float32]]; linearVelocity: Option[seq[float32]]; linearAcceleration: Option[seq[float32]]; orientation: Option[seq[float32]]; angularVelocity: Option[seq[float32]]; angularAcceleration: Option[seq[float32]]): void =
  discard

proc jsAttachVRDisplay*(self: VRServiceTest; id: cstring): JsObject =
  discard
proc jsAttachVRController*(self: VRServiceTest; id: cstring): JsObject =
  discard

proc jsVTTCueVertical*(self: VTTCue): JsObject =
  discard
proc jsVTTCueSnapToLines*(self: VTTCue): bool =
  discard
proc jsVTTCueLine*(self: VTTCue): JsObject =
  discard
proc jsVTTCueLineAlign*(self: VTTCue): JsObject =
  discard
proc jsVTTCuePosition*(self: VTTCue): JsObject =
  discard
proc jsVTTCuePositionAlign*(self: VTTCue): JsObject =
  discard
proc jsVTTCueSize*(self: VTTCue): float64 =
  discard
proc jsVTTCueAlign*(self: VTTCue): JsObject =
  discard
proc jsVTTCueText*(self: VTTCue): cstring =
  discard
proc jsGetCueAsHTML*(self: VTTCue): JsObject =
  discard

proc jsVTTRegionId*(self: VTTRegion): cstring =
  discard
proc jsVTTRegionWidth*(self: VTTRegion): float64 =
  discard
proc jsVTTRegionLines*(self: VTTRegion): int32 =
  discard
proc jsVTTRegionRegionAnchorX*(self: VTTRegion): float64 =
  discard
proc jsVTTRegionRegionAnchorY*(self: VTTRegion): float64 =
  discard
proc jsVTTRegionViewportAnchorX*(self: VTTRegion): float64 =
  discard
proc jsVTTRegionViewportAnchorY*(self: VTTRegion): float64 =
  discard
proc jsVTTRegionScroll*(self: VTTRegion): JsObject =
  discard

proc jsValidityStateValueMissing*(self: ValidityState): bool =
  discard
proc jsValidityStateTypeMismatch*(self: ValidityState): bool =
  discard
proc jsValidityStatePatternMismatch*(self: ValidityState): bool =
  discard
proc jsValidityStateTooLong*(self: ValidityState): bool =
  discard
proc jsValidityStateTooShort*(self: ValidityState): bool =
  discard
proc jsValidityStateRangeUnderflow*(self: ValidityState): bool =
  discard
proc jsValidityStateRangeOverflow*(self: ValidityState): bool =
  discard
proc jsValidityStateStepMismatch*(self: ValidityState): bool =
  discard
proc jsValidityStateBadInput*(self: ValidityState): bool =
  discard
proc jsValidityStateCustomError*(self: ValidityState): bool =
  discard
proc jsValidityStateValid*(self: ValidityState): bool =
  discard

proc jsVideoFrameCodedWidth*(self: VideoFrame): uint32 =
  discard
proc jsVideoFrameCodedHeight*(self: VideoFrame): uint32 =
  discard
proc jsVideoFrameDisplayWidth*(self: VideoFrame): uint32 =
  discard
proc jsVideoFrameDisplayHeight*(self: VideoFrame): uint32 =
  discard
proc jsVideoFrameTimestamp*(self: VideoFrame): int64 =
  discard
proc jsVideoFrameColorSpace*(self: VideoFrame): JsObject =
  discard
proc jsAllocationSize*(self: VideoFrame; options: JsObject): uint32 =
  discard
proc jsCopyTo*(self: VideoFrame; destination: JsObject; options: JsObject): JsObject =
  discard
proc jsClone*(self: VideoFrame): JsObject =
  discard
proc jsClose*(self: VideoFrame): void =
  discard

proc jsToJSON*(self: VideoColorSpace): JsObject =
  discard

proc jsVideoPlaybackQualityCreationTime*(self: VideoPlaybackQuality): JsObject =
  discard
proc jsVideoPlaybackQualityTotalVideoFrames*(self: VideoPlaybackQuality): uint32 =
  discard
proc jsVideoPlaybackQualityDroppedVideoFrames*(self: VideoPlaybackQuality): uint32 =
  discard
proc jsVideoPlaybackQualityCorruptedVideoFrames*(self: VideoPlaybackQuality): uint32 =
  discard


proc jsVideoTrackId*(self: VideoTrack): cstring =
  discard
proc jsVideoTrackKind*(self: VideoTrack): cstring =
  discard
proc jsVideoTrackLabel*(self: VideoTrack): cstring =
  discard
proc jsVideoTrackLanguage*(self: VideoTrack): cstring =
  discard
proc jsVideoTrackSelected*(self: VideoTrack): bool =
  discard

proc jsVideoTrackListLength*(self: VideoTrackList): uint32 =
  discard
proc jsVideoTrackListSelectedIndex*(self: VideoTrackList): int32 =
  discard
proc jsVideoTrackListOnchange*(self: VideoTrackList): JsObject =
  discard
proc jsVideoTrackListOnaddtrack*(self: VideoTrackList): JsObject =
  discard
proc jsVideoTrackListOnremovetrack*(self: VideoTrackList): JsObject =
  discard
proc jsGetTrackById*(self: VideoTrackList; id: cstring): Option[JsObject] =
  discard

proc jsVisualViewportOffsetLeft*(self: VisualViewport): float64 =
  discard
proc jsVisualViewportOffsetTop*(self: VisualViewport): float64 =
  discard
proc jsVisualViewportPageLeft*(self: VisualViewport): float64 =
  discard
proc jsVisualViewportPageTop*(self: VisualViewport): float64 =
  discard
proc jsVisualViewportWidth*(self: VisualViewport): float64 =
  discard
proc jsVisualViewportHeight*(self: VisualViewport): float64 =
  discard
proc jsVisualViewportScale*(self: VisualViewport): float64 =
  discard
proc jsVisualViewportOnresize*(self: VisualViewport): JsObject =
  discard
proc jsVisualViewportOnscroll*(self: VisualViewport): JsObject =
  discard
proc jsVisualViewportOnscrollend*(self: VisualViewport): JsObject =
  discard

proc jsWaveShaperNodeOversample*(self: WaveShaperNode): JsObject =
  discard

proc jsPublicKeyCredentialRawId*(self: PublicKeyCredential): JsObject =
  discard
proc jsPublicKeyCredentialResponse*(self: PublicKeyCredential): JsObject =
  discard
proc jsGetClientExtensionResults*(self: PublicKeyCredential): JsObject =
  discard

proc jsAuthenticatorResponseClientDataJSON*(self: AuthenticatorResponse): JsObject =
  discard

proc jsAuthenticatorAttestationResponseAttestationObject*(self: AuthenticatorAttestationResponse): JsObject =
  discard
proc jsGetTransports*(self: AuthenticatorAttestationResponse): JsObject =
  discard
proc jsGetAuthenticatorData*(self: AuthenticatorAttestationResponse): JsObject =
  discard
proc jsGetPublicKey*(self: AuthenticatorAttestationResponse): Option[JsObject] =
  discard
proc jsGetPublicKeyAlgorithm*(self: AuthenticatorAttestationResponse): JsObject =
  discard

proc jsAuthenticatorAssertionResponseAuthenticatorData*(self: AuthenticatorAssertionResponse): JsObject =
  discard
proc jsAuthenticatorAssertionResponseSignature*(self: AuthenticatorAssertionResponse): JsObject =
  discard







proc jsWebGLContextEventStatusMessage*(self: WebGLContextEvent): cstring =
  discard

proc jsMultiDrawArraysWEBGL*(self: WEBGL_multi_draw; mode: JsObject; firstsList: JsObject; firstsOffset: JsObject; countsList: JsObject; countsOffset: JsObject; drawcount: JsObject): void =
  discard
proc jsMultiDrawElementsWEBGL*(self: WEBGL_multi_draw; mode: JsObject; countsList: JsObject; countsOffset: JsObject; typeVal: JsObject; offsetsList: JsObject; offsetsOffset: JsObject; drawcount: JsObject): void =
  discard
proc jsMultiDrawArraysInstancedWEBGL*(self: WEBGL_multi_draw; mode: JsObject; firstsList: JsObject; firstsOffset: JsObject; countsList: JsObject; countsOffset: JsObject; instanceCountsList: JsObject; instanceCountsOffset: JsObject; drawcount: JsObject): void =
  discard
proc jsMultiDrawElementsInstancedWEBGL*(self: WEBGL_multi_draw; mode: JsObject; countsList: JsObject; countsOffset: JsObject; typeVal: JsObject; offsetsList: JsObject; offsetsOffset: JsObject; instanceCountsList: JsObject; instanceCountsOffset: JsObject; drawcount: JsObject): void =
  discard









proc jsWebGLActiveInfoSize*(self: WebGLActiveInfo): JsObject =
  discard
proc jsWebGLActiveInfoTypeVal*(self: WebGLActiveInfo): JsObject =
  discard
proc jsWebGLActiveInfoName*(self: WebGLActiveInfo): cstring =
  discard

proc jsWebGLShaderPrecisionFormatRangeMin*(self: WebGLShaderPrecisionFormat): JsObject =
  discard
proc jsWebGLShaderPrecisionFormatRangeMax*(self: WebGLShaderPrecisionFormat): JsObject =
  discard
proc jsWebGLShaderPrecisionFormatPrecision*(self: WebGLShaderPrecisionFormat): JsObject =
  discard

proc jsBufferData*(self: WebGLRenderingContext; target: JsObject; size: JsObject; usage: JsObject): void =
  discard
proc jsBufferData*(self: WebGLRenderingContext; target: JsObject; data: Option[JsObject]; usage: JsObject): void =
  discard
proc jsBufferData*(self: WebGLRenderingContext; target: JsObject; data: JsObject; usage: JsObject): void =
  discard
proc jsBufferSubData*(self: WebGLRenderingContext; target: JsObject; offset: JsObject; data: JsObject): void =
  discard
proc jsCompressedTexImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; internalformat: JsObject; width: JsObject; height: JsObject; border: JsObject; data: JsObject): void =
  discard
proc jsCompressedTexSubImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; xoffset: JsObject; yoffset: JsObject; width: JsObject; height: JsObject; format: JsObject; data: JsObject): void =
  discard
proc jsReadPixels*(self: WebGLRenderingContext; x: JsObject; y: JsObject; width: JsObject; height: JsObject; format: JsObject; typeVal: JsObject; pixels: Option[JsObject]): void =
  discard
proc jsTexImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; internalformat: JsObject; width: JsObject; height: JsObject; border: JsObject; format: JsObject; typeVal: JsObject; pixels: Option[JsObject]): void =
  discard
proc jsTexImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; internalformat: JsObject; format: JsObject; typeVal: JsObject; pixels: JsObject): void =
  discard
proc jsTexImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; internalformat: JsObject; format: JsObject; typeVal: JsObject; image: JsObject): void =
  discard
proc jsTexImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; internalformat: JsObject; format: JsObject; typeVal: JsObject; canvas: JsObject): void =
  discard
proc jsTexImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; internalformat: JsObject; format: JsObject; typeVal: JsObject; video: JsObject): void =
  discard
proc jsTexImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; internalformat: JsObject; format: JsObject; typeVal: JsObject; video_frame: JsObject): void =
  discard
proc jsTexSubImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; xoffset: JsObject; yoffset: JsObject; width: JsObject; height: JsObject; format: JsObject; typeVal: JsObject; pixels: Option[JsObject]): void =
  discard
proc jsTexSubImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; xoffset: JsObject; yoffset: JsObject; format: JsObject; typeVal: JsObject; pixels: JsObject): void =
  discard
proc jsTexSubImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; xoffset: JsObject; yoffset: JsObject; format: JsObject; typeVal: JsObject; image: JsObject): void =
  discard
proc jsTexSubImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; xoffset: JsObject; yoffset: JsObject; format: JsObject; typeVal: JsObject; canvas: JsObject): void =
  discard
proc jsTexSubImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; xoffset: JsObject; yoffset: JsObject; format: JsObject; typeVal: JsObject; video: JsObject): void =
  discard
proc jsTexSubImage2D*(self: WebGLRenderingContext; target: JsObject; level: JsObject; xoffset: JsObject; yoffset: JsObject; format: JsObject; typeVal: JsObject; video_frame: JsObject): void =
  discard
proc jsUniform1fv*(self: WebGLRenderingContext; location: Option[JsObject]; data: JsObject): void =
  discard
proc jsUniform2fv*(self: WebGLRenderingContext; location: Option[JsObject]; data: JsObject): void =
  discard
proc jsUniform3fv*(self: WebGLRenderingContext; location: Option[JsObject]; data: JsObject): void =
  discard
proc jsUniform4fv*(self: WebGLRenderingContext; location: Option[JsObject]; data: JsObject): void =
  discard
proc jsUniform1iv*(self: WebGLRenderingContext; location: Option[JsObject]; data: JsObject): void =
  discard
proc jsUniform2iv*(self: WebGLRenderingContext; location: Option[JsObject]; data: JsObject): void =
  discard
proc jsUniform3iv*(self: WebGLRenderingContext; location: Option[JsObject]; data: JsObject): void =
  discard
proc jsUniform4iv*(self: WebGLRenderingContext; location: Option[JsObject]; data: JsObject): void =
  discard
proc jsUniformMatrix2fv*(self: WebGLRenderingContext; location: Option[JsObject]; transpose: JsObject; data: JsObject): void =
  discard
proc jsUniformMatrix3fv*(self: WebGLRenderingContext; location: Option[JsObject]; transpose: JsObject; data: JsObject): void =
  discard
proc jsUniformMatrix4fv*(self: WebGLRenderingContext; location: Option[JsObject]; transpose: JsObject; data: JsObject): void =
  discard



proc jsGetSupportedProfiles*(self: WEBGL_compressed_texture_astc): Option[JsObject] =
  discard






proc jsGetTranslatedShaderSource*(self: WEBGL_debug_shaders; shader: JsObject): cstring =
  discard




proc jsLoseContext*(self: WEBGL_lose_context): void =
  discard
proc jsRestoreContext*(self: WEBGL_lose_context): void =
  discard





proc jsDrawBuffersWEBGL*(self: WEBGL_draw_buffers; buffers: JsObject): void =
  discard







proc jsCreateVertexArrayOES*(self: OES_vertex_array_object): Option[JsObject] =
  discard
proc jsDeleteVertexArrayOES*(self: OES_vertex_array_object; arrayObject: Option[JsObject]): void =
  discard
proc jsIsVertexArrayOES*(self: OES_vertex_array_object; arrayObject: Option[JsObject]): JsObject =
  discard
proc jsBindVertexArrayOES*(self: OES_vertex_array_object; arrayObject: Option[JsObject]): void =
  discard

proc jsDrawArraysInstancedANGLE*(self: ANGLE_instanced_arrays; mode: JsObject; first: JsObject; count: JsObject; primcount: JsObject): void =
  discard
proc jsDrawElementsInstancedANGLE*(self: ANGLE_instanced_arrays; mode: JsObject; count: JsObject; typeVal: JsObject; offset: JsObject; primcount: JsObject): void =
  discard
proc jsVertexAttribDivisorANGLE*(self: ANGLE_instanced_arrays; index: JsObject; divisor: JsObject): void =
  discard



proc jsCreateQueryEXT*(self: EXT_disjoint_timer_query): Option[JsObject] =
  discard
proc jsDeleteQueryEXT*(self: EXT_disjoint_timer_query; query: Option[JsObject]): void =
  discard
proc jsIsQueryEXT*(self: EXT_disjoint_timer_query; query: Option[JsObject]): bool =
  discard
proc jsBeginQueryEXT*(self: EXT_disjoint_timer_query; target: JsObject; query: JsObject): void =
  discard
proc jsEndQueryEXT*(self: EXT_disjoint_timer_query; target: JsObject): void =
  discard
proc jsQueryCounterEXT*(self: EXT_disjoint_timer_query; query: JsObject; target: JsObject): void =
  discard
proc jsGetQueryEXT*(self: EXT_disjoint_timer_query; target: JsObject; pname: JsObject): JsObject =
  discard
proc jsGetQueryObjectEXT*(self: EXT_disjoint_timer_query; query: JsObject; pname: JsObject): JsObject =
  discard

proc jsGetParameter*(self: MOZ_debug; pname: JsObject): JsObject =
  discard

proc jsSetMatrixValue*(self: WebKitCSSMatrix; transformList: cstring): JsObject =
  discard
proc jsMultiply*(self: WebKitCSSMatrix; other: JsObject): JsObject =
  discard
proc jsInverse*(self: WebKitCSSMatrix): JsObject =
  discard
proc jsTranslate*(self: WebKitCSSMatrix; tx: float64; ty: float64; tz: float64): JsObject =
  discard
proc jsScale*(self: WebKitCSSMatrix; scaleX: float64; scaleY: float64; scaleZ: float64): JsObject =
  discard
proc jsRotate*(self: WebKitCSSMatrix; rotX: float64; rotY: float64; rotZ: float64): JsObject =
  discard
proc jsRotateAxisAngle*(self: WebKitCSSMatrix; x: float64; y: float64; z: float64; angle: float64): JsObject =
  discard
proc jsSkewX*(self: WebKitCSSMatrix; sx: float64): JsObject =
  discard
proc jsSkewY*(self: WebKitCSSMatrix; sy: float64): JsObject =
  discard

proc jsWebSocketUrl*(self: WebSocket): cstring =
  discard
const jsWebSocketCONNECTING* : uint16 = 0
const jsWebSocketOPEN* : uint16 = 0
const jsWebSocketCLOSING* : uint16 = 0
const jsWebSocketCLOSED* : uint16 = 0
proc jsWebSocketReadyState*(self: WebSocket): uint16 =
  discard
proc jsWebSocketBufferedAmount*(self: WebSocket): uint32 =
  discard
proc jsWebSocketOnopen*(self: WebSocket): JsObject =
  discard
proc jsWebSocketOnerror*(self: WebSocket): JsObject =
  discard
proc jsWebSocketOnclose*(self: WebSocket): JsObject =
  discard
proc jsWebSocketExtensions*(self: WebSocket): cstring =
  discard
proc jsWebSocketProtocol*(self: WebSocket): cstring =
  discard
proc jsWebSocketOnmessage*(self: WebSocket): JsObject =
  discard
proc jsWebSocketBinaryType*(self: WebSocket): JsObject =
  discard
proc jsClose*(self: WebSocket; code: uint16; reason: cstring): void =
  discard
proc jsSend*(self: WebSocket; data: cstring): void =
  discard
proc jsSend*(self: WebSocket; data: JsObject): void =
  discard

const jsWheelEventDOM_DELTA_PIXEL* : uint32 = 0
const jsWheelEventDOM_DELTA_LINE* : uint32 = 0
const jsWheelEventDOM_DELTA_PAGE* : uint32 = 0
proc jsWheelEventDeltaX*(self: WheelEvent): float64 =
  discard
proc jsWheelEventDeltaY*(self: WheelEvent): float64 =
  discard
proc jsWheelEventDeltaZ*(self: WheelEvent): float64 =
  discard
proc jsWheelEventDeltaMode*(self: WheelEvent): uint32 =
  discard

proc jsWindowWindow*(self: Window): JsObject =
  discard
proc jsWindowSelf*(self: Window): JsObject =
  discard
proc jsWindowName*(self: Window): cstring =
  discard
proc jsWindowLocation*(self: Window): JsObject =
  discard
proc jsWindowHistory*(self: Window): JsObject =
  discard
proc jsWindowCustomElements*(self: Window): JsObject =
  discard
proc jsWindowLocationbar*(self: Window): JsObject =
  discard
proc jsWindowMenubar*(self: Window): JsObject =
  discard
proc jsWindowPersonalbar*(self: Window): JsObject =
  discard
proc jsWindowScrollbars*(self: Window): JsObject =
  discard
proc jsWindowStatusbar*(self: Window): JsObject =
  discard
proc jsWindowToolbar*(self: Window): JsObject =
  discard
proc jsWindowStatus*(self: Window): cstring =
  discard
proc jsWindowClosed*(self: Window): bool =
  discard
proc jsWindowEvent*(self: Window): JsObject =
  discard
proc jsWindowFrames*(self: Window): JsObject =
  discard
proc jsWindowLength*(self: Window): uint32 =
  discard
proc jsWindowOpener*(self: Window): JsObject =
  discard
proc jsWindowNavigator*(self: Window): JsObject =
  discard
proc jsWindowExternal*(self: Window): JsObject =
  discard
proc jsWindowApplicationCache*(self: Window): JsObject =
  discard
proc jsClose*(self: Window): void =
  discard
proc jsStop*(self: Window): void =
  discard
proc jsFocus*(self: Window): void =
  discard
proc jsBlur*(self: Window): void =
  discard
proc jsOpen*(self: Window; url: cstring; target: cstring; features: cstring): Option[JsObject] =
  discard
proc jsAlert*(self: Window): void =
  discard
proc jsAlert*(self: Window; message: cstring): void =
  discard
proc jsConfirm*(self: Window; message: cstring): bool =
  discard
proc jsPrompt*(self: Window; message: cstring; default: cstring): Option[cstring] =
  discard
proc jsPrint*(self: Window): void =
  discard
proc jsPostMessage*(self: Window; message: JsObject; targetOrigin: cstring; transfer: JsObject): void =
  discard

proc jsWorkerOnmessage*(self: Worker): JsObject =
  discard
proc jsWorkerOnmessageerror*(self: Worker): JsObject =
  discard
proc jsTerminate*(self: Worker): void =
  discard
proc jsPostMessage*(self: Worker; message: JsObject; transfer: JsObject): void =
  discard


proc jsWorkerDebuggerGlobalScopeGlobal*(self: WorkerDebuggerGlobalScope): JsObject =
  discard
proc jsWorkerDebuggerGlobalScopeOnmessage*(self: WorkerDebuggerGlobalScope): JsObject =
  discard
proc jsCreateSandbox*(self: WorkerDebuggerGlobalScope; name: cstring; prototype: JsObject): JsObject =
  discard
proc jsLoadSubScript*(self: WorkerDebuggerGlobalScope; url: cstring; sandbox: JsObject): void =
  discard
proc jsEnterEventLoop*(self: WorkerDebuggerGlobalScope): void =
  discard
proc jsLeaveEventLoop*(self: WorkerDebuggerGlobalScope): void =
  discard
proc jsPostMessage*(self: WorkerDebuggerGlobalScope; message: cstring): void =
  discard
proc jsSetImmediate*(self: WorkerDebuggerGlobalScope; handler: JsObject): void =
  discard
proc jsReportError*(self: WorkerDebuggerGlobalScope; message: cstring): void =
  discard
proc jsRetrieveConsoleEvents*(self: WorkerDebuggerGlobalScope): JsObject =
  discard
proc jsSetConsoleEventHandler*(self: WorkerDebuggerGlobalScope; handler: Option[JsObject]): void =
  discard

proc jsWorkerGlobalScopeSelf*(self: WorkerGlobalScope): JsObject =
  discard
proc jsWorkerGlobalScopeLocation*(self: WorkerGlobalScope): JsObject =
  discard
proc jsWorkerGlobalScopeNavigator*(self: WorkerGlobalScope): JsObject =
  discard
proc jsWorkerGlobalScopeOnerror*(self: WorkerGlobalScope): JsObject =
  discard
proc jsWorkerGlobalScopeOnoffline*(self: WorkerGlobalScope): JsObject =
  discard
proc jsWorkerGlobalScopeOnonline*(self: WorkerGlobalScope): JsObject =
  discard
proc jsImportScripts*(self: WorkerGlobalScope; urls: cstring): void =
  discard

proc jsWorkerLocationHref*(self: WorkerLocation): cstring =
  discard
proc jsWorkerLocationOrigin*(self: WorkerLocation): cstring =
  discard
proc jsWorkerLocationProtocol*(self: WorkerLocation): cstring =
  discard
proc jsWorkerLocationHost*(self: WorkerLocation): cstring =
  discard
proc jsWorkerLocationHostname*(self: WorkerLocation): cstring =
  discard
proc jsWorkerLocationPort*(self: WorkerLocation): cstring =
  discard
proc jsWorkerLocationPathname*(self: WorkerLocation): cstring =
  discard
proc jsWorkerLocationSearch*(self: WorkerLocation): cstring =
  discard
proc jsWorkerLocationHash*(self: WorkerLocation): cstring =
  discard


proc jsAddModule*(self: Worklet; moduleURL: cstring; options: JsObject): JsObject =
  discard



proc jsXMLHttpRequestOnreadystatechange*(self: XMLHttpRequest): JsObject =
  discard
const jsXMLHttpRequestUNSENT* : uint16 = 0
const jsXMLHttpRequestOPENED* : uint16 = 0
const jsXMLHttpRequestHEADERS_RECEIVED* : uint16 = 0
const jsXMLHttpRequestLOADING* : uint16 = 0
const jsXMLHttpRequestDONE* : uint16 = 0
proc jsXMLHttpRequestReadyState*(self: XMLHttpRequest): uint16 =
  discard
proc jsXMLHttpRequestTimeout*(self: XMLHttpRequest): uint32 =
  discard
proc jsXMLHttpRequestWithCredentials*(self: XMLHttpRequest): bool =
  discard
proc jsXMLHttpRequestUpload*(self: XMLHttpRequest): JsObject =
  discard
proc jsXMLHttpRequestResponseURL*(self: XMLHttpRequest): cstring =
  discard
proc jsXMLHttpRequestStatus*(self: XMLHttpRequest): uint16 =
  discard
proc jsXMLHttpRequestStatusText*(self: XMLHttpRequest): cstring =
  discard
proc jsXMLHttpRequestResponseType*(self: XMLHttpRequest): JsObject =
  discard
proc jsXMLHttpRequestResponse*(self: XMLHttpRequest): JsObject =
  discard
proc jsOpen*(self: XMLHttpRequest; methodVal: cstring; url: cstring): void =
  discard
proc jsOpen*(self: XMLHttpRequest; methodVal: cstring; url: cstring; async: bool; user: Option[cstring]; password: Option[cstring]): void =
  discard
proc jsSetRequestHeader*(self: XMLHttpRequest; header: cstring; value: cstring): void =
  discard
proc jsSend*(self: XMLHttpRequest; body: Option[JsObject]): void =
  discard
proc jsAbort*(self: XMLHttpRequest): void =
  discard
proc jsGetResponseHeader*(self: XMLHttpRequest; header: cstring): Option[cstring] =
  discard
proc jsGetAllResponseHeaders*(self: XMLHttpRequest): cstring =
  discard
proc jsOverrideMimeType*(self: XMLHttpRequest; mime: cstring): void =
  discard

proc jsXMLHttpRequestEventTargetOnloadstart*(self: XMLHttpRequestEventTarget): JsObject =
  discard
proc jsXMLHttpRequestEventTargetOnprogress*(self: XMLHttpRequestEventTarget): JsObject =
  discard
proc jsXMLHttpRequestEventTargetOnabort*(self: XMLHttpRequestEventTarget): JsObject =
  discard
proc jsXMLHttpRequestEventTargetOnerror*(self: XMLHttpRequestEventTarget): JsObject =
  discard
proc jsXMLHttpRequestEventTargetOnload*(self: XMLHttpRequestEventTarget): JsObject =
  discard
proc jsXMLHttpRequestEventTargetOntimeout*(self: XMLHttpRequestEventTarget): JsObject =
  discard
proc jsXMLHttpRequestEventTargetOnloadend*(self: XMLHttpRequestEventTarget): JsObject =
  discard


proc jsSerializeToString*(self: XMLSerializer; root: JsObject): cstring =
  discard

proc jsEvaluate*(self: XPathExpression; contextNode: JsObject; typeVal: uint16; resultVal: Option[JsObject]): JsObject =
  discard
proc jsEvaluateWithContext*(self: XPathExpression; contextNode: JsObject; contextPosition: uint32; contextSize: uint32; typeVal: uint16; resultVal: Option[JsObject]): JsObject =
  discard

const jsXPathResultANY_TYPE* : uint16 = 0
const jsXPathResultNUMBER_TYPE* : uint16 = 0
const jsXPathResultSTRING_TYPE* : uint16 = 0
const jsXPathResultBOOLEAN_TYPE* : uint16 = 0
const jsXPathResultUNORDERED_NODE_ITERATOR_TYPE* : uint16 = 0
const jsXPathResultORDERED_NODE_ITERATOR_TYPE* : uint16 = 0
const jsXPathResultUNORDERED_NODE_SNAPSHOT_TYPE* : uint16 = 0
const jsXPathResultORDERED_NODE_SNAPSHOT_TYPE* : uint16 = 0
const jsXPathResultANY_UNORDERED_NODE_TYPE* : uint16 = 0
const jsXPathResultFIRST_ORDERED_NODE_TYPE* : uint16 = 0
proc jsXPathResultResultType*(self: XPathResult): uint16 =
  discard
proc jsXPathResultNumberValue*(self: XPathResult): float64 =
  discard
proc jsXPathResultStringValue*(self: XPathResult): cstring =
  discard
proc jsXPathResultBooleanValue*(self: XPathResult): bool =
  discard
proc jsXPathResultInvalidIteratorState*(self: XPathResult): bool =
  discard
proc jsXPathResultSnapshotLength*(self: XPathResult): uint32 =
  discard
proc jsIterateNext*(self: XPathResult): Option[JsObject] =
  discard
proc jsSnapshotItem*(self: XPathResult; index: uint32): Option[JsObject] =
  discard

const jsXSLTProcessorDISABLE_ALL_LOADS* : uint32 = 0
proc jsXSLTProcessorFlags*(self: XSLTProcessor): uint32 =
  discard
proc jsImportStylesheet*(self: XSLTProcessor; style: JsObject): void =
  discard
proc jsTransformToFragment*(self: XSLTProcessor; source: JsObject; output: JsObject): JsObject =
  discard
proc jsTransformToDocument*(self: XSLTProcessor; source: JsObject): JsObject =
  discard
proc jsSetParameter*(self: XSLTProcessor; namespaceURI: cstring; localName: cstring; value: JsObject): void =
  discard
proc jsGetParameter*(self: XSLTProcessor; namespaceURI: cstring; localName: cstring): Option[JsObject] =
  discard
proc jsRemoveParameter*(self: XSLTProcessor; namespaceURI: cstring; localName: cstring): void =
  discard
proc jsClearParameters*(self: XSLTProcessor): void =
  discard
proc jsReset*(self: XSLTProcessor): void =
  discard

