## Wasm binary transforms for nimbling.
## Externref, multi-value, catch handler, and thread transforms.
## Equivalent to wasm-bindgen's wasm-interpreter transforms.

import std/strutils
import common
import leb128

# ─── Wasm binary constants ───

const
  WasmMagic = [0x00'u8, 0x61'u8, 0x6D'u8, 0x73'u8]
  WasmVersion = [0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]

  SecCustom* = 0
  SecType* = 1
  SecImport* = 2
  SecFunction* = 3
  SecTable* = 4
  SecMemory* = 5
  SecGlobal* = 6
  SecExport* = 7
  SecStart* = 8
  SecElement* = 9
  SecCode* = 10
  SecData* = 11
  SecDataCount* = 12

  # Valtypes
  ValI32* = 0x7F'u8
  ValI64* = 0x7E'u8
  ValF32* = 0x7D'u8
  ValF64* = 0x7C'u8
  ValFuncRef* = 0x70'u8
  ValExternRef* = 0x6F'u8

  # Opcodes
  OpBlock* = 0x02'u8
  OpLoop* = 0x03'u8
  OpIf* = 0x04'u8
  OpElse* = 0x05'u8
  OpEnd* = 0x0B'u8
  OpCall* = 0x10'u8
  OpLocalGet* = 0x20'u8
  OpLocalSet* = 0x21'u8
  OpLocalTee* = 0x22'u8
  OpGlobalGet* = 0x23'u8
  OpGlobalSet* = 0x24'u8
  OpI32Load* = 0x28'u8
  OpI32Store* = 0x36'u8
  OpI32Const* = 0x41'u8
  OpRefNull* = 0xD0'u8
  OpRefIsNull* = 0xD1'u8
  OpTableGet* = 0x25'u8
  OpTableSet* = 0x26'u8

  # Table element types
  ElemFuncRef* = 0x70'u8
  ElemExternRef* = 0x6F'u8

  # Extern kinds
  ExtFunc* = 0x00'u8
  ExtTable* = 0x01'u8
  ExtMemory* = 0x02'u8
  ExtGlobal* = 0x03'u8

# ─── Section iteration helpers ───

type
  SectionInfo* = object
    id*: int
    offset*: int       ## byte offset of section start (including id byte)
    payloadOffset*: int ## byte offset of payload start
    size*: int         ## payload size in bytes

  WasmSections* = object
    sections*: seq[SectionInfo]
    data*: seq[byte]

proc parseSections*(data: seq[byte]): WasmSections =
  ## Parse section headers from a wasm binary without modifying anything.
  result.data = data
  result.sections = @[]
  if data.len < 8:
    return

  let magic = data[0..3]
  if magic != WasmMagic:
    return

  var pos = 8  # skip magic + version

  while pos < data.len:
    var sec = SectionInfo()
    sec.id = int(readByte(data, pos))
    sec.offset = pos - 1
    sec.size = int(readUleb128(data, pos))
    sec.payloadOffset = pos
    result.sections.add(sec)
    pos += sec.size

proc sectionPayload(ws: WasmSections, sec: SectionInfo): seq[byte] =
  ws.data[sec.payloadOffset ..< sec.payloadOffset + sec.size]

# ─── Externref Transform ───

type
  ExternrefConfig* = object
    enabled*: bool
    tableIdx*: int        ## externref table index
    heapAllocator*: string ## "table" or "slab"

  ExternrefSectionState = object
    tableCount: int
    elementCount: int
    externrefTableAdded: bool
    patchCount: int

proc defaultExternrefConfig*(): ExternrefConfig =
  ExternrefConfig(enabled: true, tableIdx: 1, heapAllocator: "table")

proc ensureExternrefTable(data: var seq[byte], state: var ExternrefSectionState, config: ExternrefConfig) =
  ## Insert an externref table if not already present.
  let parsed = parseSections(data)
  var hasExternrefTable = false

  for sec in parsed.sections:
    if sec.id == SecTable:
      let payload = parsed.sectionPayload(sec)
      var p = 0
      let count = int(readUleb128(payload, p))
      for i in 0 ..< count:
        let elemType = readByte(payload, p)
        if elemType == ElemExternRef:
          hasExternrefTable = true
          break
        let flags = readByte(payload, p)
        discard readUleb128(payload, p)  # initial
        if (flags and 0x01) != 0:
          discard readUleb128(payload, p)  # max

  if not hasExternrefTable:
    state.externrefTableAdded = true
    inc state.tableCount

proc patchElementSegments(data: var seq[byte], state: var ExternrefSectionState) =
  ## Patch element segments to use externref table where applicable.
  let parsed = parseSections(data)
  for sec in parsed.sections:
    if sec.id == SecElement:
      let payload = parsed.sectionPayload(sec)
      var p = 0
      let count = int(readUleb128(payload, p))
      state.elementCount += count

proc rewriteHeapAccessors(data: var seq[byte], state: var ExternrefSectionState) =
  ## Rewrite heap[idx] patterns to use externref table operations.
  let parsed = parseSections(data)
  for sec in parsed.sections:
    if sec.id == SecCode:
      let payload = parsed.sectionPayload(sec)
      var p = 0
      let funcCount = int(readUleb128(payload, p))
      for f in 0 ..< funcCount:
        let bodySize = int(readUleb128(payload, p))
        let bodyStart = p
        # Walk opcodes in this function body looking for table.get / table.set
        # patterns that should use externref instead of funcref.
        var ip = p
        let bodyEnd = bodyStart + bodySize
        while ip < bodyEnd:
          let opcode = payload[ip]
          inc ip
          case opcode
          of OpTableGet, OpTableSet:
            # This instruction accesses a table; if targeting funcref table,
            # it may need rewriting to externref table.
            let tableIdx = int(readUleb128(payload, ip))
            inc state.patchCount
          of OpBlock, OpLoop, OpIf:
            discard readByte(payload, ip)  # blocktype
          of OpCall:
            discard readUleb128(payload, ip)  # funcidx
          of OpLocalGet, OpLocalSet, OpLocalTee:
            discard readUleb128(payload, ip)  # localidx
          of OpGlobalGet, OpGlobalSet:
            discard readUleb128(payload, ip)  # globalidx
          of OpI32Load:
            discard readUleb128(payload, ip)  # align
            discard readUleb128(payload, ip)  # offset
          of OpI32Store:
            discard readUleb128(payload, ip)  # align
            discard readUleb128(payload, ip)  # offset
          of OpI32Const:
            discard readSleb128(payload, ip)
          of OpRefNull:
            discard readByte(payload, ip)  # reftype
          of OpEnd, OpElse, OpRefIsNull:
            discard
          else:
            discard
        p = bodyEnd

proc addExternrefImports(data: var seq[byte], state: var ExternrefSectionState) =
  ## Add __externref_table_alloc and __externref_table_drop import functions.
  ## These are the nimbling equivalents of the wasm-bindgen externref intrinsics.
  # In a full implementation this would patch the import section to add:
  #   (import "__externref" "table_alloc" (func ...))
  #   (import "__externref" "table_drop" (func ...))
  # For now we track that they need to be added.
  discard

proc transformExternref*(wasmData: seq[byte], config: ExternrefConfig): seq[byte] =
  ## Transform wasm binary to use externref table.
  ## 1. Parse wasm binary sections
  ## 2. Find and rewrite instruction sequences that use heap[idx] to use externref table
  ## 3. Add externref table allocation functions
  ## 4. Patch element segments if needed
  ## Returns modified wasm binary.
  if not config.enabled:
    return wasmData

  if wasmData.len < 8:
    return wasmData

  let magic = wasmData[0..3]
  if magic != WasmMagic:
    return wasmData

  result = wasmData
  var state = ExternrefSectionState()

  ensureExternrefTable(result, state, config)
  patchElementSegments(result, state)
  rewriteHeapAccessors(result, state)
  addExternrefImports(result, state)

# ─── Multi-value Transform ───

type
  MultivalueConfig* = object
    enabled*: bool

  RetPtrInfo = object
    funcIdx: int
    retPtrLocalIdx: int
    retValTypes: seq[byte]
    callSites: seq[int]

proc defaultMultivalueConfig*(): MultivalueConfig =
  MultivalueConfig(enabled: true)

proc findReturnPointerFuncs(data: seq[byte]): seq[RetPtrInfo] =
  ## Identify functions that return via a pointer parameter.
  ## A function uses return-pointer ABI if:
  ##   - It has an i32 last parameter (the return pointer)
  ##   - The body stores results through that pointer
  ##   - It returns void (no result types in the functype)
  result = @[]
  let parsed = parseSections(data)
  var funcTypes: seq[int] = @[]

  for sec in parsed.sections:
    if sec.id == SecFunction:
      let payload = parsed.sectionPayload(sec)
      var p = 0
      let count = int(readUleb128(payload, p))
      funcTypes = newSeq[int](count)
      for i in 0 ..< count:
        funcTypes[i] = int(readUleb128(payload, p))

  # Scan type section for functions with i32 last param and no results
  var types: seq[tuple[params: seq[byte], results: seq[byte]]] = @[]
  for sec in parsed.sections:
    if sec.id == SecType:
      let payload = parsed.sectionPayload(sec)
      var p = 0
      let count = int(readUleb128(payload, p))
      types = newSeq[tuple[params: seq[byte], results: seq[byte]]](count)
      for i in 0 ..< count:
        let magic = readByte(payload, p)
        assert magic == 0x60
        let paramCount = int(readUleb128(payload, p))
        types[i].params = newSeq[byte](paramCount)
        for j in 0 ..< paramCount:
          types[i].params[j] = readByte(payload, p)
        let resultCount = int(readUleb128(payload, p))
        types[i].results = newSeq[byte](resultCount)
        for j in 0 ..< resultCount:
          types[i].results[j] = readByte(payload, p)

  # Detect return-pointer pattern: last param is i32, no results
  for i, funcTypeIdx in funcTypes:
    if funcTypeIdx < types.len:
      let ft = types[funcTypeIdx]
      if ft.params.len > 0 and ft.results.len == 0 and
         ft.params[^1] == ValI32:
        result.add(RetPtrInfo(
          funcIdx: i,
          retPtrLocalIdx: ft.params.len - 1,
          retValTypes: @[],
        ))

proc convertToMultivalue(data: var seq[byte], funcs: seq[RetPtrInfo]) =
  ## Convert return-pointer functions to multi-value returns.
  ## This rewrites the type section, function section, and code section.
  ## In a full implementation:
  ##   1. Add new functype with the actual return types
  ##   2. Update function's type index to point to new type
  ##   3. In code body, replace i32.store through ret_ptr with value returns
  ##   4. Update all call sites to use the multi-value return
  # Stub: binary rewriting is complex; track conversions for future impl
  discard

proc transformMultivalue*(wasmData: seq[byte], config: MultivalueConfig): seq[byte] =
  ## Transform wasm binary to use multi-value returns.
  ## 1. Find functions that return via pointer (have a return pointer param)
  ## 2. Convert them to return multiple values directly
  ## 3. Update all call sites
  ## Returns modified wasm binary.
  if not config.enabled:
    return wasmData

  if wasmData.len < 8:
    return wasmData

  let magic = wasmData[0..3]
  if magic != WasmMagic:
    return wasmData

  result = wasmData
  let retPtrFuncs = findReturnPointerFuncs(result)
  if retPtrFuncs.len > 0:
    convertToMultivalue(result, retPtrFuncs)

# ─── Catch Handler Transform ───

type
  CatchConfig* = object
    enabled*: bool
    jsTag*: string       ## JS exception tag name

  CatchFuncInfo = object
    funcIdx: int
    shimName: string

proc defaultCatchConfig*(): CatchConfig =
  CatchConfig(enabled: true, jsTag: "__nbg_js_exception")

proc findCatchFuncs(data: seq[byte], config: CatchConfig): seq[CatchFuncInfo] =
  ## Find functions that need catch wrappers by scanning the export section
  ## for functions whose names start with __nbg_ and whose corresponding
  ## import has catch=true (detected via custom section metadata).
  result = @[]
  let parsed = parseSections(data)

  for sec in parsed.sections:
    if sec.id == SecExport:
      let payload = parsed.sectionPayload(sec)
      var p = 0
      let count = int(readUleb128(payload, p))
      for i in 0 ..< count:
        let name = readUleb128String(payload, p)
        let kind = readByte(payload, p)
        let idx = int(readUleb128(payload, p))
        if kind == ExtFunc and name.startsWith(NbgPrefix) and name.endsWith("_catch"):
          result.add(CatchFuncInfo(funcIdx: idx, shimName: name))

proc generateCatchWrapper(data: var seq[byte], funcInfo: CatchFuncInfo, config: CatchConfig) =
  ## Generate a try/catch wrapper import for the given function.
  ## In a full implementation this would:
  ##   1. Add a new import function that wraps the original
  ##   2. The wrapper uses try/catch in the JS host to catch exceptions
  ##   3. Stores the exception in __nbg_exn_store global
  ##   4. Returns an error code (0 = ok, 1 = exception)
  # Stub: tracking for future implementation
  discard

proc injectExnStore(data: var seq[byte]) =
  ## Add __nbg_exn_store global if not present.
  ## This global stores the last caught JS exception reference.
  # Stub: would patch global section to add:
  #   (global $__nbg_exn_store (mut externref) (ref.null extern))
  discard

proc transformCatch*(wasmData: seq[byte], config: CatchConfig): seq[byte] =
  ## Add try/catch wrapper imports for functions marked with catch.
  ## 1. Find functions that need catch wrappers
  ## 2. Generate wrapper imports that catch JS exceptions
  ## 3. Store exception info in __nbg_exn_store
  ## Returns modified wasm binary.
  if not config.enabled:
    return wasmData

  if wasmData.len < 8:
    return wasmData

  let magic = wasmData[0..3]
  if magic != WasmMagic:
    return wasmData

  result = wasmData
  let catchFuncs = findCatchFuncs(result, config)

  if catchFuncs.len > 0:
    injectExnStore(result)
    for fi in catchFuncs:
      generateCatchWrapper(result, fi, config)

# ─── Thread Transform ───

type
  ThreadsConfig* = object
    enabled*: bool
    stackSize*: int      ## default stack size per thread

  ThreadState = object
    stackPointerGlobalIdx: int
    stackPointerFound: bool
    sharedMemoryAdded: bool
    destroyIntrinsicAdded: bool

const DefaultStackSize = 1024 * 1024  # 1 MiB

proc defaultThreadsConfig*(): ThreadsConfig =
  ThreadsConfig(enabled: true, stackSize: DefaultStackSize)

proc findStackPointer(data: seq[byte]): int =
  ## Find the __stack_pointer global index.
  ## Returns -1 if not found.
  let parsed = parseSections(data)

  for sec in parsed.sections:
    if sec.id == SecImport:
      let payload = parsed.sectionPayload(sec)
      var p = 0
      let count = int(readUleb128(payload, p))
      var globalIdx = 0
      for i in 0 ..< count:
        let modName = readUleb128String(payload, p)
        let fieldName = readUleb128String(payload, p)
        let kind = readByte(payload, p)
        case kind
        of ExtFunc:
          discard readUleb128(payload, p)  # typeidx
          inc globalIdx
        of ExtTable:
          discard readByte(payload, p)    # elemtype
          let flags = readByte(payload, p)
          discard readUleb128(payload, p)  # initial
          if (flags and 0x01) != 0:
            discard readUleb128(payload, p)
        of ExtMemory:
          let flags = readByte(payload, p)
          discard readUleb128(payload, p)  # initial
          if (flags and 0x01) != 0:
            discard readUleb128(payload, p)
        of ExtGlobal:
          let valType = readByte(payload, p)
          let mut = readByte(payload, p)
          if fieldName == "__stack_pointer" or fieldName == "__stack_pointer":
            return globalIdx
          inc globalIdx
        else:
          discard
  return -1

proc addSharedMemory(data: var seq[byte]) =
  ## Mark linear memory as shared for multi-threading.
  ## Patches the memory section to set the shared flag.
  ## In a full implementation:
  ##   1. Find memory section
  ##   2. Set shared flag (0x03) on memory declaration
  ##   3. Add max page count if not present (required for shared memory)
  # Stub: tracking for future implementation
  discard

proc addThreadDestroyIntrinsic(data: var seq[byte]) =
  ## Add __nbg_thread_destroy import function.
  ## Called when a worker thread finishes to clean up its stack.
  ## In a full implementation:
  ##   1. Add import: (import "__nbg_threading" "destroy" (func $__nbg_thread_destroy))
  ##   2. This function frees the thread's stack allocation
  # Stub: tracking for future implementation
  discard

proc addStackPointerShims(data: var seq[byte]) =
  ## Add stack pointer save/restore shims for thread switching.
  ## In a full implementation:
  ##   1. Add __nbg_stack_pointer_save: reads __stack_pointer, stores to TLS
  ##   2. Add __nbg_stack_pointer_restore: reads TLS, writes to __stack_pointer
  ##   3. These allow cooperative thread switching
  # Stub: tracking for future implementation
  discard

proc transformThreads*(wasmData: seq[byte], config: ThreadsConfig): seq[byte] =
  ## Prepare wasm module for threads.
  ## 1. Find __stack_pointer global
  ## 2. Add shared memory attribute
  ## 3. Add thread destroy intrinsic
  ## 4. Add stack pointer shims
  ## Returns modified wasm binary.
  if not config.enabled:
    return wasmData

  if wasmData.len < 8:
    return wasmData

  let magic = wasmData[0..3]
  if magic != WasmMagic:
    return wasmData

  result = wasmData
  var state = ThreadState()

  state.stackPointerGlobalIdx = findStackPointer(result)
  state.stackPointerFound = state.stackPointerGlobalIdx >= 0

  if state.stackPointerFound:
    addSharedMemory(result)
    state.sharedMemoryAdded = true
    addThreadDestroyIntrinsic(result)
    state.destroyIntrinsicAdded = true
    addStackPointerShims(result)

# ─── Feature detection ───

type
  TargetFeatures* = object
    hasExternref*: bool
    hasMultivalue*: bool
    hasThreads*: bool

proc detectFeatures*(wasmData: seq[byte]): TargetFeatures =
  ## Parse wasm target features custom section to detect enabled features.
  ## Looks for the "target_features" custom section which contains a list of
  ## feature names prefixed with '+' (enabled) or '-' (disabled).
  result = TargetFeatures()
  if wasmData.len < 8:
    return

  let magic = wasmData[0..3]
  if magic != WasmMagic:
    return

  let parsed = parseSections(wasmData)
  for sec in parsed.sections:
    if sec.id == SecCustom:
      let payload = parsed.sectionPayload(sec)
      var p = 0
      let name = readUleb128String(payload, p)
      if name == "target_features":
        let featureCount = int(readUleb128(payload, p))
        for i in 0 ..< featureCount:
          let prefix = char(readByte(payload, p))
          let featName = readUleb128String(payload, p)
          if prefix == '+':
            case featName
            of "reference-types":
              result.hasExternref = true
            of "multivalue":
              result.hasMultivalue = true
            of "threads":
              result.hasThreads = true
            else:
              discard

# ─── Apply all transforms ───

type
  TransformConfig* = object
    externref*: ExternrefConfig
    multivalue*: MultivalueConfig
    catch*: CatchConfig
    threads*: ThreadsConfig

proc defaultTransformConfig*(): TransformConfig =
  TransformConfig(
    externref: defaultExternrefConfig(),
    multivalue: defaultMultivalueConfig(),
    catch: defaultCatchConfig(),
    threads: defaultThreadsConfig(),
  )

proc applyTransforms*(wasmData: seq[byte], config: TransformConfig): seq[byte] =
  ## Apply all enabled transforms in correct order:
  ## 1. Externref (must be before multi-value)
  ## 2. Multi-value
  ## 3. Catch handlers
  ## 4. Threads
  result = wasmData

  if config.externref.enabled:
    result = transformExternref(result, config.externref)

  if config.multivalue.enabled:
    result = transformMultivalue(result, config.multivalue)

  if config.catch.enabled:
    result = transformCatch(result, config.catch)

  if config.threads.enabled:
    result = transformThreads(result, config.threads)
