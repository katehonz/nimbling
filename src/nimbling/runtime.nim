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
# These are wasm exports — the JS glue calls them.
# Uses a simple bump allocator over a static 1 MB heap buffer.

when defined(wasm32):
  var nbgHeapData: array[1024 * 1024, byte]
  var nbgHeapPos: uint32 = 0

  proc nbgMalloc*(size: uint32, align: uint32): ptr UncheckedArray[byte] {.
      exportc: "__nbg_malloc", cdecl.} =
    let mask = align - 1
    nbgHeapPos = (nbgHeapPos + mask) and (not mask)
    result = cast[ptr UncheckedArray[byte]](addr nbgHeapData[nbgHeapPos])
    nbgHeapPos += size

  proc nbgFree*(p: pointer, size: uint32, align: uint32) {.
      exportc: "__nbg_free", cdecl.} =
    discard  # bump allocator — no-op

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
    discard  # bump allocator — no-op

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
