## Type descriptor system for nimbling.
## Equivalent to WasmDescribe trait + Descriptor enum from wasm-bindgen.

import common

type
  VectorKind* = enum
    vkI8, vkU8, vkClampedU8, vkI16, vkU16, vkI32, vkU32
    vkI64, vkU64, vkF32, vkF64, vkString, vkExternref, vkNamedExternref

  Descriptor* = object
    kind*: uint32
    inner*: ptr Descriptor    # for REF, SLICE, VECTOR, OPTIONAL, RESULT
    funcDesc*: ptr FunctionDescriptor
    closureDesc*: ptr ClosureDescriptor
    nameStr*: string           # for NAMED_EXTERNREF, ENUM, STRING_ENUM, RUST_STRUCT
    enumHole*: uint32
    stringEnumInvalid*: uint32
    stringEnumHole*: uint32

  FunctionDescriptor* = object
    arguments*: seq[Descriptor]
    shimIdx*: uint32
    ret*: Descriptor
    innerRet*: Descriptor

  ClosureDescriptor* = object
    owned*: bool
    mutable*: bool
    function*: FunctionDescriptor

# ─── Helper: allocate a Descriptor on heap, return pointer ───

proc newDesc*(): ptr Descriptor =
  result = cast[ptr Descriptor](alloc0(sizeof(Descriptor)))

# ─── Decode descriptor from u32 stream ───

proc getU32(data: var seq[uint32], idx: var int): uint32 =
  result = data[idx]
  inc idx

proc getStringFromU32(data: var seq[uint32], idx: var int): string =
  let len = getU32(data, idx).int
  result = newString(len)
  for i in 0..<len:
    let cu = getU32(data, idx)
    result[i] = char(cu)

proc decodeDescriptor(data: var seq[uint32], idx: var int, clamped: bool = false): Descriptor

proc decodeFunction(data: var seq[uint32], idx: var int): FunctionDescriptor =
  result.shimIdx = getU32(data, idx)
  let argCount = getU32(data, idx).int
  result.arguments = newSeq[Descriptor](argCount)
  for i in 0..<argCount:
    result.arguments[i] = decodeDescriptor(data, idx)
  result.ret = decodeDescriptor(data, idx)
  result.innerRet = decodeDescriptor(data, idx)

proc decodeClosure(data: var seq[uint32], idx: var int): ClosureDescriptor =
  result.owned = getU32(data, idx) == 1
  result.mutable = getU32(data, idx) == 1
  assert getU32(data, idx) == TY_FUNCTION
  result.function = decodeFunction(data, idx)

proc decodeDescriptor(data: var seq[uint32], idx: var int, clamped: bool = false): Descriptor =
  let ty = getU32(data, idx)
  result.kind = ty
  case ty
  of TY_FUNCTION:
    result.funcDesc = cast[ptr FunctionDescriptor](alloc0(sizeof(FunctionDescriptor)))
    result.funcDesc[] = decodeFunction(data, idx)
  of TY_CLOSURE:
    result.closureDesc = cast[ptr ClosureDescriptor](alloc0(sizeof(ClosureDescriptor)))
    result.closureDesc[] = decodeClosure(data, idx)
  of TY_REF, TY_REFMUT, TY_SLICE, TY_VECTOR, TY_OPTIONAL, TY_RESULT:
    result.inner = newDesc()
    result.inner[] = decodeDescriptor(data, idx)
  of TY_LONGREF:
    let inner = decodeDescriptor(data, idx)
    if inner.kind == TY_EXTERNREF or inner.kind == TY_NAMED_EXTERNREF:
      result = inner
    else:
      result.kind = TY_REF
      result.inner = newDesc()
      result.inner[] = inner
  of TY_NAMED_EXTERNREF:
    result.nameStr = getStringFromU32(data, idx)
  of TY_ENUM:
    result.nameStr = getStringFromU32(data, idx)
    result.enumHole = getU32(data, idx)
  of TY_STRING_ENUM:
    result.nameStr = getStringFromU32(data, idx)
    let variantCount = getU32(data, idx)
    result.stringEnumInvalid = variantCount
    result.stringEnumHole = variantCount + 1
  of TY_RUST_STRUCT:
    result.nameStr = getStringFromU32(data, idx)
  of TY_CLAMPED:
    result = decodeDescriptor(data, idx, clamped = true)
  else:
    discard

proc decode*(T: typedesc[Descriptor], data: seq[uint32]): Descriptor =
  var d = data
  var idx = 0
  result = decodeDescriptor(d, idx)
  assert idx == d.len, "remaining data in descriptor stream: " & $idx & " / " & $d.len

proc `$`*(d: Descriptor): string =
  case d.kind
  of TY_I8: "i8"
  of TY_U8: "u8"
  of TY_I16: "i16"
  of TY_U16: "u16"
  of TY_I32: "i32"
  of TY_U32: "u32"
  of TY_I64: "i64"
  of TY_U64: "u64"
  of TY_F32: "f32"
  of TY_F64: "f64"
  of TY_BOOLEAN: "bool"
  of TY_STRING: "string"
  of TY_EXTERNREF: "externref"
  of TY_UNIT: "unit"
  of TY_REF: "ref(" & $d.inner[] & ")"
  of TY_OPTIONAL: "option(" & $d.inner[] & ")"
  of TY_FUNCTION: "function"
  else: "descriptor(" & $d.kind & ")"
