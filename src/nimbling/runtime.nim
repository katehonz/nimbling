## Runtime types for nimbling: JsValue, Closure, memory management.
## These are used in user code compiled to wasm.

import common

type
  JsValue* = object
    idx*: uint32

  Closure*[T] = object
    idx*: uint32

proc `=destroy`*(v: var JsValue) =
  ## Drop the JS object reference.
  when defined(wasm32):
    {.emit: "__nbg_object_drop_ref(`v`.idx);".}

proc `=copy`*(dest: var JsValue, src: JsValue) =
  ## Shallow copy — both share the same idx.
  when defined(wasm32):
    dest.idx = src.idx
    # Increment refcount if we had refcounting
    {.emit: "__nbg_object_clone_ref(`dest`.idx);".}

proc `=destroy`*[T](c: var Closure[T]) =
  when defined(wasm32):
    {.emit: "__nbg_closure_drop(`c`.idx);".}

# ─── Import declarations for JS runtime functions ───
# These are provided by the generated JS glue code.

when defined(wasm32):
  proc nbgMalloc*(size: uint32, align: uint32): ptr UncheckedArray[byte] {.
    importc: "__nbg_malloc", nodecl.}
  proc nbgFree*(ptr: pointer, size: uint32, align: uint32) {.
    importc: "__nbg_free", nodecl.}
  proc nbgBoxedStrPtr*(s: pointer): ptr UncheckedArray[byte] {.
    importc: "__nbg_boxed_str_ptr", nodecl.}
  proc nbgBoxedStrLen*(s: pointer): uint32 {.
    importc: "__nbg_boxed_str_len", nodecl.}
  proc nbgBoxedStrFree*(s: pointer) {.
    importc: "__nbg_boxed_str_free", nodecl.}

# ─── Unsafe constructors for generated code ───

proc fromIdx*(T: typedesc[JsValue], idx: uint32): JsValue {.inline.} =
  JsValue(idx: idx)
