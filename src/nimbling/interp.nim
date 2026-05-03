## Wasm bytecode interpreter for extracting type descriptors.
## Executes __nbg_describe_* functions from a .wasm binary.
## Equivalent to wasm-bindgen's interpreter/mod.rs.

import std/strutils
import common

type
  WasmFuncType* = object
    params*: seq[byte]   ## valtype bytes per param
    results*: seq[byte]  ## valtype bytes per result

  FuncDecl* = object
    typeIdx*: int        ## index into module.types
    codeOffset*: int     ## offset into module.codeData
    codeLen*: int        ## bytecount of function body
    locals*: seq[byte]   ## declared locals (not counting params)

  WasmModule* = object
    types*: seq[WasmFuncType]
    funcs*: seq[FuncDecl]
    codeData*: seq[byte]
    numImports*: int       ## count of imported functions

# ─── LEB128 helpers ───

proc readU32BE(data: openArray[byte], pos: var int): uint32 =
  var shift = 0
  while pos < data.len:
    let b = data[pos]
    inc pos
    result = result or ((uint32(b) and 0x7F) shl shift)
    if (b and 0x80) == 0:
      break
    shift += 7

proc readS32BE(data: openArray[byte], pos: var int): int32 =
  var shift = 0
  var b: byte
  while pos < data.len:
    b = data[pos]
    inc pos
    result = result or ((int32(b) and 0x7F) shl shift)
    if (b and 0x80) == 0:
      break
    shift += 7
  if (shift < 32) and ((b and 0x40) != 0):
    result = result or ((not 0'i32) shl shift)

proc readByte(data: openArray[byte], pos: var int): byte =
  result = data[pos]
  inc pos

# ─── Wasm binary parser ───

proc parseWasmModule*(data: seq[byte]): WasmModule =
  ## Parse type, import, function, and code sections.
  if data.len < 8:
    return result

  var pos = 8  # skip magic + version
  var funcSectionTypes: seq[int] = @[]

  while pos < data.len:
    let sectionId = data[pos]
    inc pos
    let sectionSize = int(readU32BE(data, pos))
    let sectionEnd = pos + sectionSize

    case sectionId
    of 1: # Type section
      let count = int(readU32BE(data, pos))
      result.types = newSeq[WasmFuncType](count)
      for i in 0 ..< count:
        let magic = readByte(data, pos)
        assert magic == 0x60, "expected functype magic 0x60, got 0x" & $magic
        let paramCount = int(readU32BE(data, pos))
        result.types[i].params = newSeq[byte](paramCount)
        for j in 0 ..< paramCount:
          result.types[i].params[j] = readByte(data, pos)
        let resultCount = int(readU32BE(data, pos))
        result.types[i].results = newSeq[byte](resultCount)
        for j in 0 ..< resultCount:
          result.types[i].results[j] = readByte(data, pos)

    of 2: # Import section
      let count = int(readU32BE(data, pos))
      for i in 0 ..< count:
        let modLen = int(readU32BE(data, pos))
        pos += modLen
        let fieldLen = int(readU32BE(data, pos))
        pos += fieldLen
        let importKind = readByte(data, pos)
        case importKind
        of 0x00: # function import
          inc result.numImports
          discard readU32BE(data, pos)  # type index
        of 0x01: # table import
          discard readByte(data, pos)   # elemtype
          let flags = readByte(data, pos)
          discard readU32BE(data, pos)  # initial
          if (flags and 0x01) != 0:
            discard readU32BE(data, pos)  # max
        of 0x02: # memory import
          let flags = readByte(data, pos)
          discard readU32BE(data, pos)  # initial
          if (flags and 0x01) != 0:
            discard readU32BE(data, pos)  # max
        of 0x03: # global import
          discard readByte(data, pos)   # valtype
          discard readByte(data, pos)   # mutability
        else:
          discard

    of 3: # Function section
      let count = int(readU32BE(data, pos))
      funcSectionTypes = newSeq[int](count)
      for i in 0 ..< count:
        funcSectionTypes[i] = int(readU32BE(data, pos))

    of 10: # Code section
      let count = int(readU32BE(data, pos))
      result.funcs = newSeq[FuncDecl](count)
      let codeDataStart = pos
      for i in 0 ..< count:
        let codeSize = int(readU32BE(data, pos))
        let bodyStart = pos

        # local declarations
        let localGroupCount = int(readU32BE(data, pos))
        var localTypes: seq[byte] = @[]
        for j in 0 ..< localGroupCount:
          let groupCount = int(readU32BE(data, pos))
          let valType = readByte(data, pos)
          for k in 0 ..< groupCount:
            localTypes.add(valType)

        let bodyEnd = bodyStart + codeSize
        result.funcs[i].codeOffset = pos
        result.funcs[i].codeLen = bodyEnd - pos
        result.funcs[i].typeIdx = funcSectionTypes[i]
        result.funcs[i].locals = localTypes

        pos = bodyEnd
      result.codeData = data[codeDataStart ..< pos]

    else:
      pos = sectionEnd

# ─── Find imported __nbg_describe index ───

proc findDescribeImportIdx*(data: seq[byte]): int =
  ## Scan the import section for a function named `__nbg_describe`.
  ## Returns its wasm function index, or -1 if not found.
  if data.len < 8:
    return -1

  var pos = 8
  var funcIdx = 0

  while pos < data.len:
    let sectionId = data[pos]
    inc pos
    let sectionSize = int(readU32BE(data, pos))
    let sectionEnd = pos + sectionSize

    if sectionId == 2: # Import section
      let count = int(readU32BE(data, pos))
      for i in 0 ..< count:
        let modLen = int(readU32BE(data, pos))
        pos += modLen
        let fieldLen = int(readU32BE(data, pos))
        let fieldData = data[pos ..< pos + fieldLen]
        pos += fieldLen
        let importKind = readByte(data, pos)
        if importKind == 0x00: # function import
          discard readU32BE(data, pos)  # type index
          if cast[string](fieldData) == "__nbg_describe":
            return funcIdx
          inc funcIdx
        else:
          if importKind == 0x01:
            discard readByte(data, pos)
            let flags = readByte(data, pos)
            discard readU32BE(data, pos)
            if (flags and 0x01) != 0:
              discard readU32BE(data, pos)
          elif importKind == 0x02:
            let flags = readByte(data, pos)
            discard readU32BE(data, pos)
            if (flags and 0x01) != 0:
              discard readU32BE(data, pos)
          elif importKind == 0x03:
            discard readByte(data, pos)
            discard readByte(data, pos)
    pos = sectionEnd

  return -1

# ─── Find descriptor exports ───

proc findDescriptorExports*(data: seq[byte]): seq[(string, int)] =
  ## Scan the export section for entries whose name starts with `__nbg_describe_`.
  ## Returns (fullName, wasmFuncIdx) pairs.
  if data.len < 8:
    return @[]

  var pos = 8

  while pos < data.len:
    let sectionId = data[pos]
    inc pos
    let sectionSize = int(readU32BE(data, pos))
    let sectionEnd = pos + sectionSize

    if sectionId == 7: # Export section
      let count = int(readU32BE(data, pos))
      for i in 0 ..< count:
        let nameLen = int(readU32BE(data, pos))
        let nameBytes = data[pos ..< pos + nameLen]
        pos += nameLen
        let exportKind = readByte(data, pos)
        let exportIdx = int(readU32BE(data, pos))
        let name = cast[string](nameBytes)
        if exportKind == 0x00 and name.startsWith(DescribeFnPrefix):
          result.add((name, exportIdx))

    pos = sectionEnd

# ─── Wasm opcodes ───

const
  OP_NOP         = 0x01'u8
  OP_BLOCK       = 0x02'u8
  OP_LOOP        = 0x03'u8
  OP_IF          = 0x04'u8
  OP_ELSE        = 0x05'u8
  OP_END         = 0x0B'u8
  OP_BR          = 0x0C'u8
  OP_BR_IF       = 0x0D'u8
  OP_RETURN      = 0x0F'u8
  OP_CALL        = 0x10'u8
  OP_DROP        = 0x1A'u8
  OP_LOCAL_GET   = 0x20'u8
  OP_LOCAL_SET   = 0x21'u8
  OP_LOCAL_TEE   = 0x22'u8
  OP_GLOBAL_GET  = 0x23'u8
  OP_GLOBAL_SET  = 0x24'u8
  OP_I32_CONST   = 0x41'u8
  OP_I32_EQZ     = 0x45'u8
  OP_I32_EQ      = 0x46'u8
  OP_I32_NE      = 0x47'u8
  OP_I32_LT_S    = 0x48'u8
  OP_I32_LT_U    = 0x49'u8
  OP_I32_GT_S    = 0x4A'u8
  OP_I32_GT_U    = 0x4B'u8
  OP_I32_ADD     = 0x6A'u8
  OP_I32_SUB     = 0x6B'u8
  OP_I32_MUL     = 0x6C'u8

# ─── Interpreter ───

proc runDescriptorFunction(
  module: WasmModule,
  wasmFuncIdx: int,
  describeImportIdx: int,
): seq[uint32] =
  ## Execute a single descriptor function and collect all uint32 values
  ## passed to `__nbg_describe`.

  # Convert wasm function index → module-defined function index
  let definedIdx = wasmFuncIdx - module.numImports
  if definedIdx < 0 or definedIdx >= module.funcs.len:
    return @[]

  let fi = module.funcs[definedIdx]

  # Build local slots: params (from type) + declared locals
  let ft = module.types[fi.typeIdx]
  var localCount = ft.params.len + fi.locals.len
  var locals: seq[uint32]
  locals.setLen(localCount)

  # IP within the code section byte array
  var ip = fi.codeOffset
  let codeEnd = fi.codeOffset + fi.codeLen

  var stack: seq[uint32] = @[]

  while ip < codeEnd:
    let op = module.codeData[ip]
    inc ip

    case op
    of OP_NOP:
      discard

    of OP_BLOCK:
      discard readByte(module.codeData, ip)

    of OP_LOOP:
      discard readByte(module.codeData, ip)

    of OP_IF:
      discard readByte(module.codeData, ip)
      let cond = stack.pop()
      if cond == 0:
        # skip to else or end — simplified: skip past matching end
        var depth = 1
        while ip < codeEnd and depth > 0:
          case module.codeData[ip]
          of OP_BLOCK, OP_LOOP, OP_IF:
            inc depth
            inc ip
            discard readByte(module.codeData, ip)
          of OP_END:
            dec depth
            inc ip
          of OP_ELSE:
            if depth == 1: dec depth
            inc ip
          else:
            inc ip

    of OP_ELSE:
      # skip to enclosing end
      var depth = 1
      while ip < codeEnd and depth > 0:
        case module.codeData[ip]
        of OP_BLOCK, OP_LOOP, OP_IF:
          inc depth
          inc ip
          discard readByte(module.codeData, ip)
        of OP_END:
          dec depth
          inc ip
        of OP_ELSE:
          if depth == 1: dec depth
          inc ip
        else:
          inc ip

    of OP_END:
      break

    of OP_BR:
      discard readU32BE(module.codeData, ip)
      break

    of OP_BR_IF:
      discard readU32BE(module.codeData, ip)
      if stack.pop() != 0:
        break

    of OP_RETURN:
      break

    of OP_CALL:
      let calleeIdx = int(readU32BE(module.codeData, ip))
      if calleeIdx == describeImportIdx:
        # __nbg_describe(v): pop v and collect it
        result.add(stack.pop())
      else:
        # other calls (shouldn't happen in descriptor functions)
        discard

    of OP_DROP:
      discard stack.pop()

    of OP_LOCAL_GET:
      let idx = int(readU32BE(module.codeData, ip))
      stack.add(locals[idx])

    of OP_LOCAL_SET:
      let idx = int(readU32BE(module.codeData, ip))
      locals[idx] = stack.pop()

    of OP_LOCAL_TEE:
      let idx = int(readU32BE(module.codeData, ip))
      locals[idx] = stack[^1]

    of OP_GLOBAL_GET:
      discard readU32BE(module.codeData, ip)
      stack.add(0)

    of OP_GLOBAL_SET:
      discard readU32BE(module.codeData, ip)
      discard stack.pop()

    of OP_I32_CONST:
      let val = readS32BE(module.codeData, ip)
      stack.add(uint32(cast[uint64](int64(val)) and 0xFFFFFFFF'u64))

    of OP_I32_EQZ:
      let a = stack.pop()
      stack.add(if a == 0: 1'u32 else: 0'u32)

    of OP_I32_EQ:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(if a == b: 1'u32 else: 0'u32)

    of OP_I32_NE:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(if a != b: 1'u32 else: 0'u32)

    of OP_I32_LT_S:
      let b = cast[int32](stack.pop())
      let a = cast[int32](stack.pop())
      stack.add(if a < b: 1'u32 else: 0'u32)

    of OP_I32_LT_U:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(if a < b: 1'u32 else: 0'u32)

    of OP_I32_GT_S:
      let b = cast[int32](stack.pop())
      let a = cast[int32](stack.pop())
      stack.add(if a > b: 1'u32 else: 0'u32)

    of OP_I32_GT_U:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(if a > b: 1'u32 else: 0'u32)

    of OP_I32_ADD:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(a + b)

    of OP_I32_SUB:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(a - b)

    of OP_I32_MUL:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(a * b)

    else:
      # Unknown opcode — skip to end (descriptor functions are simple)
      break

# ─── Main entry point ───

proc extractDescriptors*(wasmData: seq[byte]): seq[seq[uint32]] =
  ## Parse the .wasm binary, locate all `__nbg_describe_*` exports,
  ## execute each one, and return a sequence of uint32 descriptors
  ## (one per descriptor function).
  let module = parseWasmModule(wasmData)
  let describeIdx = findDescribeImportIdx(wasmData)
  let descriptors = findDescriptorExports(wasmData)

  for (name, funcIdx) in descriptors:
    let vals = runDescriptorFunction(module, funcIdx, describeIdx)
    if vals.len > 0:
      result.add(vals)
