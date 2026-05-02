## Runtime types for nimbling: JsValue, Closure, memory management.
## These are used in user code compiled to wasm.

import common

type
  JsValue* = object
    idx*: uint32

  Closure*[T] = object
    idx*: uint32

# ─── JS object heap stubs (needed by =destroy/=copy emit blocks) ───
# These are C stubs; real implementation will come from JS glue.
when defined(wasm32):
  {.emit: """
  static void __nbg_object_drop_ref(unsigned int idx) { (void)idx; }
  static void __nbg_object_clone_ref(unsigned int idx) { (void)idx; }
  static void __nbg_closure_drop(unsigned int idx) { (void)idx; }
  """.}

proc `=destroy`*(v: var JsValue) =
  ## Drop the JS object reference.
  when defined(wasm32):
    {.emit: "__nbg_object_drop_ref(`v`.idx);".}

proc `=copy`*(dest: var JsValue, src: JsValue) =
  ## Shallow copy — both share the same idx.
  when defined(wasm32):
    dest.idx = src.idx
    {.emit: "__nbg_object_clone_ref(`dest`.idx);".}

proc `=destroy`*[T](c: var Closure[T]) =
  when defined(wasm32):
    {.emit: "__nbg_closure_drop(`c`.idx);".}

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
