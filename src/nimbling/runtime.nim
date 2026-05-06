## Runtime types for nimbling: JsValue, Closure, JsFuture, memory management.
## These are used in user code compiled to wasm.

type
  JsValue* = object
    idx*: uint32

  Closure*[T] = object
    idx*: uint32

  JsFuture* = distinct JsValue
    ## A handle to a JS Promise that can be awaited from Nim async code.
    ## Use `spawnLocal` to run Nim async code on the JS event loop.

# ─── JS object heap stubs (needed by =destroy/=copy emit blocks) ───
# These are C stubs; real implementation will come from JS glue.
when defined(wasm32):
  {.emit: """
  static void __nbg_object_drop_ref(unsigned int idx) { (void)idx; }
  static void __nbg_object_clone_ref(unsigned int idx) { (void)idx; }
  static void __nbg_closure_drop(unsigned int idx) { (void)idx; }
  static void __nbg_throw(void *ptr, int len) { (void)ptr; (void)len; }
  static void __nbg_rethrow(unsigned int idx) { (void)idx; }
  static void __nbg_panic_error(void *ptr, int len) { (void)ptr; (void)len; }
  """.}

proc `=destroy`*(v: var JsValue) =
  ## Drop the JS object reference.
  when defined(wasm32):
    let idx = v.idx
    {.emit: "__nbg_object_drop_ref(`idx`);".}

proc `=copy`*(dest: var JsValue, src: JsValue) =
  ## Shallow copy — both share the same idx.
  dest.idx = src.idx
  when defined(wasm32):
    let idx = dest.idx
    {.emit: "__nbg_object_clone_ref(`idx`);".}

proc `=destroy`*[T](c: var Closure[T]) =
  when defined(wasm32):
    let idx = c.idx
    {.emit: "__nbg_closure_drop(`idx`);".}

# ─── Memory allocator + boxed string helpers ───
# Slab allocator with free lists per size class and memory.grow support.

when defined(wasm32):
  const
    PageSize = 64 * 1024
    HeaderSize = sizeof(uint32)
    NumSizeClasses = 8
    SizeClasses: array[NumSizeClasses, uint32] = [
      16'u32, 32'u32, 64'u32, 128'u32,
      256'u32, 512'u32, 1024'u32, 2048'u32
    ]
    MaxSlabSize = 2048'u32

  type
    FreeNode = ptr FreeNodeObj
    FreeNodeObj = object
      next: FreeNode

  var
    nbgHeapData: array[1024 * 1024, byte]
    freeLists: array[NumSizeClasses, FreeNode]
    bumpPos: uint32
    bumpLimit: uint32
    heapInitialized: bool = false

  proc alignUp(val, alignVal: uint32): uint32 {.inline.} =
    if alignVal <= 1:
      return val
    let mask = alignVal - 1
    result = (val + mask) and (not mask)

  proc sizeToClass(size: uint32): int {.inline.} =
    for i in 0 ..< NumSizeClasses:
      if size <= SizeClasses[i]:
        return i
    result = -1

  proc memorySizePages(): int32 {.inline.} =
    {.emit: "`result` = __builtin_wasm_memory_size(0);".}

  proc memoryGrowPages(delta: int32): int32 {.inline.} =
    {.emit: "`result` = __builtin_wasm_memory_grow(0, `delta`);".}

  proc initHeap() =
    if heapInitialized:
      return
    heapInitialized = true
    let base = cast[uint32](addr nbgHeapData[0])
    # Align base to MaxSlabSize so every slab block is aligned to its size
    bumpPos = alignUp(base, MaxSlabSize)
    bumpLimit = base + uint32(sizeof(nbgHeapData))
    let currentPages = memorySizePages()
    let currentSize = uint32(currentPages) * PageSize
    if bumpLimit > currentSize:
      bumpLimit = currentSize

  proc growMemoryIfNeeded(needed: uint32): bool =
    if bumpPos + needed <= bumpLimit:
      return true
    let currentPages = memorySizePages()
    let currentSize = uint32(currentPages) * PageSize
    if bumpLimit < currentSize:
      bumpLimit = currentSize
    if bumpPos + needed <= bumpLimit:
      return true
    let neededSize = bumpPos + needed
    let neededPages = int32((neededSize + PageSize - 1) div PageSize)
    let currentLimitPages = int32((bumpLimit + PageSize - 1) div PageSize)
    let deltaPages = neededPages - currentLimitPages
    if deltaPages <= 0:
      return bumpPos + needed <= bumpLimit
    let prevPages = memoryGrowPages(deltaPages)
    if prevPages < 0:
      return false
    bumpLimit = uint32(prevPages + deltaPages) * PageSize
    return bumpPos + needed <= bumpLimit

  proc allocFromBump(size: uint32): pointer =
    if not growMemoryIfNeeded(size):
      return nil
    result = cast[pointer](bumpPos)
    bumpPos += size

  proc slabAlloc(sizeClassIdx: int): pointer =
    let node = freeLists[sizeClassIdx]
    if node != nil:
      freeLists[sizeClassIdx] = node.next
      return cast[pointer](node)
    let blockSize = SizeClasses[sizeClassIdx]
    bumpPos = alignUp(bumpPos, blockSize)
    return allocFromBump(blockSize)

  proc nbgMalloc*(size: uint32, align: uint32): ptr UncheckedArray[byte] {.
      exportc: "__nbg_malloc", cdecl.} =
    initHeap()
    if size == 0:
      return nil
    let totalSize = size + HeaderSize
    let szClass = sizeToClass(totalSize)
    var raw: pointer
    if szClass >= 0:
      raw = slabAlloc(szClass)
    else:
      let alignedTotal = alignUp(totalSize, align)
      raw = allocFromBump(alignedTotal)
    if raw == nil:
      return nil
    cast[ptr uint32](raw)[] = size
    result = cast[ptr UncheckedArray[byte]](cast[uint](raw) + HeaderSize)

  proc nbgFree*(p: pointer, size: uint32, align: uint32) {.
      exportc: "__nbg_free", cdecl.} =
    if p == nil:
      return
    let raw = cast[uint](p) - HeaderSize
    let userSize = cast[ptr uint32](raw)[]
    let totalSize = userSize + HeaderSize
    let szClass = sizeToClass(totalSize)
    if szClass >= 0:
      let blockSize = SizeClasses[szClass]
      let blockStart = raw and (not (blockSize - 1))
      let node = cast[FreeNode](blockStart)
      node.next = freeLists[szClass]
      freeLists[szClass] = node
    # Large bump allocations are intentionally leaked

  proc nbgRealloc*(p: pointer, newSize: uint32, align: uint32): ptr UncheckedArray[byte] {.
      exportc: "__nbg_realloc", cdecl.} =
    if p == nil:
      return nbgMalloc(newSize, align)
    if newSize == 0:
      nbgFree(p, 0, align)
      return nil
    let raw = cast[uint](p) - HeaderSize
    let oldSize = cast[ptr uint32](raw)[]
    result = nbgMalloc(newSize, align)
    if result != nil:
      let copySize = if oldSize < newSize: oldSize else: newSize
      let src = cast[ptr UncheckedArray[byte]](p)
      let dst = cast[ptr UncheckedArray[byte]](result)
      for i in 0 ..< int(copySize):
        dst[i] = src[i]
      nbgFree(p, oldSize, align)

  proc getHeapBase*(): pointer =
    initHeap()
    result = cast[pointer](addr nbgHeapData[0])

  # ─── Boxed string helpers ───
  # Layout: [data_ptr: u32, data_len: u32] = 8 bytes
  proc nbgBoxedStrPtr*(handle: uint32): uint32 {.
      exportc: "__nbg_boxed_str_ptr", cdecl.} =
    result = cast[ptr uint32](cast[pointer](handle))[]

  proc nbgBoxedStrLen*(handle: uint32): uint32 {.
      exportc: "__nbg_boxed_str_len", cdecl.} =
    result = cast[ptr uint32](cast[pointer](cast[uint](handle) + 4))[]

  proc nbgBoxedStrFree*(handle: uint32) {.
      exportc: "__nbg_boxed_str_free", cdecl.} =
    if handle != 0:
      nbgFree(cast[pointer](handle), 8, 4)

# ─── Unsafe constructors for generated code ───

proc fromIdx*(T: typedesc[JsValue], idx: uint32): JsValue {.inline.} =
  JsValue(idx: idx)

# ─── JsFuture helpers ───

proc jsFuture*(promise: JsValue): JsFuture {.inline.} =
  ## Wrap a raw JsValue (expected to be a JS Promise) as a JsFuture.
  JsFuture(promise)

proc promise*(future: JsFuture): JsValue {.inline.} =
  ## Get the underlying JsValue handle.
  JsValue(future)

# ─── spawnLocal: run Nim code on the JS event loop ───

proc spawnLocal*(callback: proc()) =
  ## Schedule a proc to run on the JS event loop (next tick).
  ## Equivalent to `setTimeout(callback, 0)` in JS.
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var fn = heap[`callback`.idx];
    if (typeof fn === 'function') {
      setTimeout(fn, 0);
    }
    """.}
  else:
    callback()

proc spawnLocalFuture*(futurePtr: uint32) =
  ## Low-level: register a Nim future for polling on the JS event loop.
  ## The existing async polling infrastructure (`__nbg_async_tasks`) will
  ## tick the future on each interval until completion.
  ##
  ## `futurePtr` is obtained via `cast[uint32](cast[pointer](myFuture))`.
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    var idx = `futurePtr` >>> 0;
    if (typeof __nbg_async_tasks !== 'undefined') {
      __nbg_async_tasks.set(idx, {
        future_idx: idx,
        resolve: function() {},
        reject: function(err) { console.error('spawnLocal error:', err); }
      });
      __nbg_async_start_polling();
    }
    """.}

proc futureToPromise*(futurePtr: uint32): uint32 =
  ## Low-level: convert a Nim future pointer to a JS Promise heap index.
  ## `futurePtr` is obtained via `cast[uint32](cast[pointer](myFuture))`.
  ## Returns the heap index of the created Promise.
  when defined(wasm32) and not defined(emscripten):
    {.emit: """
    if (typeof __nbg_future_to_promise !== 'undefined') {
      `result` = __nbg_future_to_promise(`futurePtr`);
    } else {
      `result` = 0;
    }
    """.}
  else:
    result = 0
