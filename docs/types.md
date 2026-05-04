# Type System

Deep dive into how nimbling handles type conversions between Nim, WebAssembly, and JavaScript.

---

## Type ID Constants

All types are identified by a `uint32` Type ID. These are defined in `common.nim`:

| ID | Constant | Description |
|----|----------|-------------|
| 0 | `TY_I8` | 8-bit signed integer |
| 1 | `TY_U8` | 8-bit unsigned integer |
| 2 | `TY_I16` | 16-bit signed integer |
| 3 | `TY_U16` | 16-bit unsigned integer |
| 4 | `TY_I32` | 32-bit signed integer |
| 5 | `TY_U32` | 32-bit unsigned integer |
| 6 | `TY_I64` | 64-bit signed integer |
| 7 | `TY_U64` | 64-bit unsigned integer |
| 8 | `TY_I64_AS_F64` | i64 bit-cast to f64 |
| 9 | `TY_U64_AS_F64` | u64 bit-cast to f64 |
| 10 | `TY_I128` | 128-bit signed integer |
| 11 | `TY_U128` | 128-bit unsigned integer |
| 12 | `TY_F32` | 32-bit float |
| 13 | `TY_F64` | 64-bit float |
| 14 | `TY_BOOLEAN` | Boolean |
| 15 | `TY_FUNCTION` | Function reference |
| 16 | `TY_CLOSURE` | Closure (function with environment) |
| 17 | `TY_CACHED_STRING` | Cached interned string |
| 18 | `TY_STRING` | UTF-8 string |
| 19 | `TY_REF` | Reference to heap object |
| 20 | `TY_REFMUT` | Mutable reference |
| 21 | `TY_LONGREF` | Extended reference |
| 22 | `TY_SLICE` | Slice (ptr + len) |
| 23 | `TY_VECTOR` | SIMD vector |
| 24 | `TY_EXTERNREF` | External reference (JsValue) |
| 25 | `TY_NAMED_EXTERNREF` | Named external reference |
| 26 | `TY_ENUM` | Nim enum |
| 27 | `TY_STRING_ENUM` | String enum variant |
| 28 | `TY_RUST_STRUCT` | Rust-compatible struct |
| 29 | `TY_CHAR` | Unicode character |
| 30 | `TY_OPTIONAL` | Optional value (maybe null) |
| 31 | `TY_RESULT` | Result type (Ok/Err) |
| 32 | `TY_UNIT` | Unit type (void) |
| 33 | `TY_CLAMPED` | Clamped to byte range |
| 34 | `TY_NONNULL` | Non-null pointer |
| 35 | `TY_RAW_POINTER` | Raw pointer |

---

## Nim to Wasm ABI

### Primitive Types

| Nim Type | Wasm Value | Notes |
|----------|------------|-------|
| `int8` | i32 | Sign-extended |
| `uint8`, `byte` | i32 | Zero-extended |
| `int16` | i32 | Sign-extended |
| `uint16` | i32 | Zero-extended |
| `int32`, `cint` | i32 | Direct |
| `uint32`, `cuint` | i32 | Direct |
| `int64` | i64 | Direct |
| `uint64` | i64 | Direct |
| `float32` | f32 | Direct |
| `float64` | f64 | Direct |
| `bool` | i32 | 0 = false, 1 = true |

### String Type

Nim `string` is passed as a struct (pointer + length):

```
┌─────────────┬─────────────┐
│ ptr: i32   │ len: i32   │
└─────────────┴─────────────┘
```

On the Nim side, the generated wrapper converts:
```nim
# Generated shim receives:
proc __nbg_shim_greet(name_ptr: uint32, name_len: uint32): uint32 =
  # Convert WASM string to Nim string
  var name = newString(name_len.int)
  if name_len > 0:
    copyMem(addr name[0], cast[pointer](name_ptr), name_len.int)
  # Call user function
  let ret = greet(name)
  # Convert Nim string to boxed WASM string
  let boxed = boxWasmString(ret)
  return boxed
```

### JsValue Type

`JsValue` represents a handle to a JavaScript object in the shared heap:

```
JsValue = object
  idx: uint32  -- index into JS heap array
```

- `idx < 128`: Stack (temporary/borrowed references)
- `idx >= 128`: Slab (owned objects)

### Sequence Type

`seq[T]` is passed the same way as strings:

```
┌─────────────┬─────────────┐
│ ptr: i32   │ len: i32   │
└─────────────┴─────────────┘
```

The pointer is to a TypedArray on the JavaScript side.

---

## JavaScript Conversions

### JS Glue Code (Generated)

The JS glue code (`jsgen.nim`) generates conversion functions:

```javascript
// String to WASM
function passStringToWasm(arg) {
  const encoder = new TextEncoder();
  const encoded = encoder.encode(arg);
  const ptr = wasm.__nbg_malloc(encoded.length, 1);
  const mem = new Uint8Array(wasm.memory.buffer);
  mem.set(encoded, ptr);
  return [ptr, encoded.length];
}

// String from WASM
function getStringFromWasm(ptr, len) {
  const mem = new Uint8Array(wasm.memory.buffer);
  const bytes = mem.slice(ptr, ptr + len);
  const decoder = new TextDecoder('utf-8');
  return decoder.decode(bytes);
}
```

### Export Shims

```javascript
// Exported function: greet(name: string) -> string
export function greet(arg0) {
  const [ptr0, len0] = passStringToWasm(arg0);
  try {
    const ret = wasm.__nbg_shim_greet(ptr0, len0);
    const rptr = wasm.__nbg_boxed_str_ptr(ret);
    const rlen = wasm.__nbg_boxed_str_len(ret);
    const realRet = getStringFromWasm(rptr, rlen);
    wasm.__nbg_boxed_str_free(ret);
    wasm.__nbg_free(ptr0, len0, 1);
    return realRet;
  } finally {
    // cleanup
  }
}
```

### Import Shims

```javascript
// Import shim for JS Math.random()
export function __nbg_f_jsMath_random() {
  return Math.random();
}
```

---

## JS Object Heap

The JS heap is a shared array that allows both environments to reference the same objects.

### Layout

```
heap: Array<any>
├── [0..127]   Stack (temporary/borrowed references)
├── [128..N]   Slab (owned objects with reference counting)
└── [N+1..]    Free slots
```

### Stack (Indices 0-127)

Temporary references for a single function call:

- **Push**: When Nim receives a JsValue argument
- **Pop**: When the function returns

```javascript
function addBorrowedObject(obj) {
  if (stack_pointer <= 0) throw new Error("stack overflow");
  heap[--stack_pointer] = obj;
  return stack_pointer;
}
```

### Slab (Indices 128+)

Owned objects with dynamic lifetime:

```javascript
let heap_next = 132;  // First free slot after sentinel values
const sentinel = [undefined, null, true, false];

function addHeapObject(obj) {
  if (heap_next < heap.length) {
    const idx = heap_next++;
    heap[idx] = obj;
    return idx;
  }
  // Grow heap
  heap.push(obj);
  return heap.length - 1;
}

function dropObject(idx) {
  heap[idx] = undefined;
  // Maybe add to free list
}
```

---

## Boxed Strings

Strings returned from Wasm are "boxed" — stored in WASM linear memory with a handle passed as a single i32:

```
Layout (8 bytes):
┌──────────────────┬──────────────────┐
│ data_ptr: u32    │ data_len: u32    │
└──────────────────┴──────────────────┘
         │
         └── Points to UTF-8 bytes in WASM memory
```

Helper functions on the Nim side:
```nim
proc nbgBoxedStrPtr*(handle: uint32): uint32 =
  cast[ptr uint32](cast[pointer](handle))[]

proc nbgBoxedStrLen*(handle: uint32): uint32 =
  cast[ptr uint32](cast[pointer](cast[uint](handle) + 4))[]

proc nbgBoxedStrFree*(handle: uint32) =
  # bump allocator: no-op
  discard
```

---

## Type Descriptor System

Type descriptors (`describe.nim`) describe the types of function arguments and returns. They're used by the CLI to generate correct JS glue code.

### Descriptor Format

Each type is encoded as a `uint32`:

```
Bits 0-7:   Type ID (0-35)
Bits 8-31:  Extended info (for structs, optionals, etc.)
```

### Common Descriptors

| Type | Encoding |
|------|----------|
| `i32` | `TY_I32` (4) |
| `f64` | `TY_F64` (13) |
| `bool` | `TY_BOOLEAN` (14) |
| `string` | `TY_STRING` (18) |
| `JsValue` | `TY_EXTERNREF` (24) |

### Example: `proc greet(name: string): string`

```
__nbg_describe_greet():
  __nbg_describe(TY_STRING)   // arg[0]: string
  __nbg_describe(TY_STRING)   // result: string
```

The CLI's stack-machine interpreter executes these and decodes the type IDs.

---

## Optional Types

`Option[T]` is encoded as:

```
┌──────────┬────────────────────┐
│ tag: i32 │ value (if present) │
└──────────┴────────────────────┘

tag = 0: None
tag = 1: Some(value)
```

```javascript
// Reading Option[T] on JS side
function getOptionalInt(handle) {
  const tag = wasm.__nbg_get_i32(handle);
  if (tag === 0) return null;
  const value = wasm.__nbg_get_i32(handle + 4);
  return value;
}
```

---

## Closure Representation

A closure is stored in the heap as:

```
Closure[T] = object
  idx: uint32  -- index to heap entry containing:
                 { function: JSFunction, env: UserData }
```

The JS side wraps the closure:
```javascript
function __nbg_closure_stub(idx, ...args) {
  const closure = heap[idx];
  return closure.function(closure.env, ...args);
}
```

---

## Memory Allocator

nimbling uses a simple bump allocator for WASM linear memory:

```nim
when defined(wasm32):
  var nbgHeapData: array[1024 * 1024, byte]  # 1MB static buffer
  var nbgHeapPos: uint32 = 0

  proc nbgMalloc*(size: uint32, align: uint32): ptr UncheckedArray[byte] =
    let mask = align - 1
    nbgHeapPos = (nbgHeapPos + mask) and (not mask)
    result = addr nbgHeapData[nbgHeapPos]
    nbgHeapPos += size
```

This is a **bump allocator** — it can only allocate, never free individual objects. Memory is reclaimed when the Wasm module is destroyed.

---

## Reference Counting

Owned objects in the slab use reference counting:

```javascript
const refcounts = new Map();

function addHeapObject(obj) {
  const idx = heap_next++;
  heap[idx] = obj;
  refcounts.set(idx, 1);
  return idx;
}

function dropObject(idx) {
  const count = refcounts.get(idx) - 1;
  refcounts.set(idx, count);
  if (count <= 0) {
    heap[idx] = undefined;
    refcounts.delete(idx);
  }
}

function cloneObject(idx) {
  refcounts.set(idx, refcounts.get(idx) + 1);
}
```

On the Nim side, `=destroy` hooks call `__nbg_object_drop_ref`:
```nim
proc `=destroy`*(v: var JsValue) =
  when defined(wasm32):
    let idx = v.idx
    {.emit: "__nbg_object_drop_ref(`idx`);".}
```

---

## Custom Section Format

Metadata is embedded in the WASM binary as a custom section named `__nimbling_unstable`:

```
┌────────────────────────────┐
│ name_len: varuint32        │  strlen("__nimbling_unstable")
│ name: "__nimbling_unstable" │
├────────────────────────────┤
│ payload:                   │
│   schema_version: string   │
│   exports: vec<Export>     │
│   imports: vec<Import>     │
│   enums: vec<NimEnum>      │
│   structs: vec<NimStruct>  │
│   ...                      │
└────────────────────────────┘
```

All integers use LEB128 varint encoding for compactness.

---

## See Also

- [API Reference](api.md) — Type definitions
- [Architecture](architecture.md) — How the heap system works
- [Getting Started](getting-started.md) — Practical type usage