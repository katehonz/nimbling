## WIT (WebAssembly Interface Types) adapter system for nimbling.
## Provides adapter instructions, builders, binary encoding/decoding,
## and JS codegen from adapter descriptions.
## Equivalent to wasm-bindgen's wit adapter pipeline.

import std/strformat
import std/strutils
import common
import encode
import leb128

# ─── Adapter Instruction Types ───

type
  AdapterInstructionKind* = enum
    aiArgGet
    aiCallImport
    aiCallExport
    aiCallMethod
    aiLoadRetptr
    aiStoreRetptr
    aiLoadI32
    aiStoreI32
    aiLoadI64
    aiStoreI64
    aiLoadF32
    aiStoreF32
    aiLoadF64
    aiStoreF64
    aiLoadStringWasm
    aiStoreStringWasm
    aiLoadStringOwned
    aiStoreStringOwned
    aiLoadExternref
    aiStoreExternref
    aiLoadRef
    aiStoreRef
    aiLoadBool
    aiStoreBool
    aiOptionGet
    aiOptionSet
    aiVectorGet
    aiVectorSet
    aiClosureGet
    aiClosureSet
    aiRethrow
    aiThrow
    aiReturn
    aiUnit

  AdapterInstruction* = object
    kind*: AdapterInstructionKind
    argIdx*: int
    funcIdx*: int
    importIdx*: int
    offset*: int
    size*: int
    name*: string

  AdapterFunc* = object
    name*: string
    instructions*: seq[AdapterInstruction]
    params*: seq[string]
    retType*: string
    isAsync*: bool
    isConstructor*: bool
    isMethod*: bool
    className*: string

# ─── Instruction constructors ───

proc mkInstr(kind: AdapterInstructionKind, argIdx = -1, funcIdx = -1,
             importIdx = -1, offset = 0, size = 0, name = ""): AdapterInstruction =
  AdapterInstruction(kind: kind, argIdx: argIdx, funcIdx: funcIdx,
                     importIdx: importIdx, offset: offset, size: size, name: name)

proc argGet*(idx: int): AdapterInstruction = mkInstr(aiArgGet, argIdx = idx)

proc callImport*(idx: int, name = ""): AdapterInstruction =
  mkInstr(aiCallImport, importIdx = idx, name = name)

proc callExport*(idx: int, name = ""): AdapterInstruction =
  mkInstr(aiCallExport, funcIdx = idx, name = name)

proc callMethod*(name: string): AdapterInstruction =
  mkInstr(aiCallMethod, name = name)

proc loadI32*(offset = 0): AdapterInstruction =
  mkInstr(aiLoadI32, offset = offset)

proc storeI32*(offset = 0): AdapterInstruction =
  mkInstr(aiStoreI32, offset = offset)

proc loadI64*(offset = 0): AdapterInstruction =
  mkInstr(aiLoadI64, offset = offset)

proc storeI64*(offset = 0): AdapterInstruction =
  mkInstr(aiStoreI64, offset = offset)

proc loadF32*(offset = 0): AdapterInstruction =
  mkInstr(aiLoadF32, offset = offset)

proc storeF32*(offset = 0): AdapterInstruction =
  mkInstr(aiStoreF32, offset = offset)

proc loadF64*(offset = 0): AdapterInstruction =
  mkInstr(aiLoadF64, offset = offset)

proc storeF64*(offset = 0): AdapterInstruction =
  mkInstr(aiStoreF64, offset = offset)

proc loadStringWasm*(offset = 0, size = 0): AdapterInstruction =
  mkInstr(aiLoadStringWasm, offset = offset, size = size)

proc storeStringWasm*(offset = 0, size = 0): AdapterInstruction =
  mkInstr(aiStoreStringWasm, offset = offset, size = size)

proc loadStringOwned*(offset = 0, size = 0): AdapterInstruction =
  mkInstr(aiLoadStringOwned, offset = offset, size = size)

proc storeStringOwned*(offset = 0, size = 0): AdapterInstruction =
  mkInstr(aiStoreStringOwned, offset = offset, size = size)

proc loadExternref*(): AdapterInstruction = mkInstr(aiLoadExternref)
proc storeExternref*(): AdapterInstruction = mkInstr(aiStoreExternref)
proc loadRef*(): AdapterInstruction = mkInstr(aiLoadRef)
proc storeRef*(): AdapterInstruction = mkInstr(aiStoreRef)
proc loadBool*(): AdapterInstruction = mkInstr(aiLoadBool)
proc storeBool*(): AdapterInstruction = mkInstr(aiStoreBool)
proc loadRetptr*(offset = 0): AdapterInstruction = mkInstr(aiLoadRetptr, offset = offset)
proc storeRetptr*(offset = 0): AdapterInstruction = mkInstr(aiStoreRetptr, offset = offset)
proc optionGet*(): AdapterInstruction = mkInstr(aiOptionGet)
proc optionSet*(): AdapterInstruction = mkInstr(aiOptionSet)
proc vectorGet*(idx: int): AdapterInstruction = mkInstr(aiVectorGet, argIdx = idx)
proc vectorSet*(idx: int): AdapterInstruction = mkInstr(aiVectorSet, argIdx = idx)
proc closureGet*(idx: int): AdapterInstruction = mkInstr(aiClosureGet, argIdx = idx)
proc closureSet*(idx: int): AdapterInstruction = mkInstr(aiClosureSet, argIdx = idx)
proc rethrow*(): AdapterInstruction = mkInstr(aiRethrow)
proc throw*(name: string): AdapterInstruction = mkInstr(aiThrow, name = name)
proc retInstr*(): AdapterInstruction = mkInstr(aiReturn)
proc unit*(): AdapterInstruction = mkInstr(aiUnit)

# ─── Type name → adapter instruction mapping ───

proc loadInstrForType*(typeName: string): AdapterInstruction =
  case typeName
  of "i32", "u32", "int", "uint", "i16", "u16", "i8", "u8", "char", "enum":
    loadI32()
  of "i64", "u64":
    loadI64()
  of "f32":
    loadF32()
  of "f64", "number":
    loadF64()
  of "string", "String":
    loadStringWasm()
  of "bool", "boolean":
    loadBool()
  of "JsValue", "ref", "any":
    loadExternref()
  of "Closure":
    loadRef()
  else:
    loadExternref()

proc storeInstrForType*(typeName: string): AdapterInstruction =
  case typeName
  of "i32", "u32", "int", "uint", "i16", "u16", "i8", "u8", "char", "enum":
    storeI32()
  of "i64", "u64":
    storeI64()
  of "f32":
    storeF32()
  of "f64", "number":
    storeF64()
  of "string", "String":
    storeStringWasm()
  of "bool", "boolean":
    storeBool()
  of "JsValue", "ref", "any":
    storeExternref()
  of "Closure":
    storeRef()
  else:
    storeExternref()

# ─── Adapter Function Builders ───

proc buildImportAdapter*(funcName: string, params: seq[(string, string)],
                         retType: string): AdapterFunc =
  ## Build adapter instructions for an import function.
  ## The adapter loads args from wasm, calls the JS function, stores the result.
  ## params is seq[(argName, argTypeName)].
  result.name = funcName
  result.retType = retType
  result.instructions = @[]

  for i, (argName, argTy) in params:
    result.params.add(argTy)
    result.instructions.add(argGet(i))
    if argTy == "string" or argTy == "String":
      # String args: load ptr+len from wasm linear memory
      result.instructions.add(loadStringWasm())
    else:
      result.instructions.add(loadInstrForType(argTy))

  result.instructions.add(callImport(0, name = funcName))

  if retType != "" and retType != "unit" and retType != "void":
    if retType == "string" or retType == "String":
      result.instructions.add(storeStringWasm())
    else:
      result.instructions.add(storeInstrForType(retType))
    result.instructions.add(retInstr())
  else:
    result.instructions.add(unit())
    result.instructions.add(retInstr())

proc buildExportAdapter*(funcName: string, params: seq[(string, string)],
                         retType: string): AdapterFunc =
  ## Build adapter instructions for an export function.
  ## The adapter loads args from JS context, calls the wasm function, stores the result.
  result.name = funcName
  result.retType = retType
  result.instructions = @[]

  for i, (argName, argTy) in params:
    result.params.add(argTy)
    result.instructions.add(argGet(i))
    if argTy == "string" or argTy == "String":
      result.instructions.add(storeStringWasm())
    else:
      result.instructions.add(storeInstrForType(argTy))

  result.instructions.add(callExport(0, name = funcName))

  if retType != "" and retType != "unit" and retType != "void":
    if retType == "string" or retType == "String":
      result.instructions.add(loadStringWasm())
    else:
      result.instructions.add(loadInstrForType(retType))
    result.instructions.add(retInstr())
  else:
    result.instructions.add(unit())
    result.instructions.add(retInstr())

proc buildMethodAdapter*(className, methodName: string,
                         params: seq[(string, string)],
                         retType: string,
                         isConstructor = false): AdapterFunc =
  ## Build adapter instructions for a class method.
  result.name = className & "_" & methodName
  result.retType = retType
  result.isMethod = true
  result.isConstructor = isConstructor
  result.className = className
  result.instructions = @[]

  if not isConstructor:
    result.instructions.add(argGet(0))
    result.instructions.add(loadExternref())

  for i, (argName, argTy) in params:
    let adjIdx = if isConstructor: i else: i + 1
    result.params.add(argTy)
    result.instructions.add(argGet(adjIdx))
    result.instructions.add(loadInstrForType(argTy))

  result.instructions.add(callMethod(methodName))

  if isConstructor:
    result.instructions.add(storeExternref())
    result.instructions.add(retInstr())
  elif retType != "" and retType != "unit" and retType != "void":
    result.instructions.add(storeInstrForType(retType))
    result.instructions.add(retInstr())
  else:
    result.instructions.add(unit())
    result.instructions.add(retInstr())

# ─── WIT Section Encoding ───

proc encodeInstr(e: var Encoder, instr: AdapterInstruction) =
  e.encode(uint32(ord(instr.kind)))
  e.encode(instr.argIdx)
  e.encode(instr.funcIdx)
  e.encode(instr.importIdx)
  e.encode(instr.offset)
  e.encode(instr.size)
  e.encode(instr.name)

proc decodeInstr(data: seq[byte], pos: var int): AdapterInstruction =
  let kindOrd = int(readUleb128(data, pos))
  result.kind = AdapterInstructionKind(kindOrd)
  result.argIdx = int(readUleb128(data, pos))
  result.funcIdx = int(readUleb128(data, pos))
  result.importIdx = int(readUleb128(data, pos))
  result.offset = int(readUleb128(data, pos))
  result.size = int(readUleb128(data, pos))
  result.name = readUleb128String(data, pos)

proc encodeWitSection*(adapters: seq[AdapterFunc]): seq[byte] =
  ## Encode adapter functions as a WIT custom section.
  ## Format: adapter_count, then for each:
  ##   name_len, name, param_count, params, retType,
  ##   flags (isAsync|isConstructor|isMethod), className,
  ##   instruction_count, instructions...
  var e = newEncoder()
  e.encode(adapters.len)
  for adapter in adapters:
    e.encode(adapter.name)
    e.encode(adapter.params)
    e.encode(adapter.retType)
    let flags = (if adapter.isAsync: 1 else: 0) or
                (if adapter.isConstructor: 2 else: 0) or
                (if adapter.isMethod: 4 else: 0)
    e.encode(flags)
    e.encode(adapter.className)
    e.encode(adapter.instructions.len)
    for instr in adapter.instructions:
      e.encodeInstr(instr)
  result = e.buf

proc decodeWitSection*(data: seq[byte]): seq[AdapterFunc] =
  ## Decode adapter functions from a WIT custom section.
  result = @[]
  if data.len == 0:
    return

  var pos = 0
  let adapterCount = int(readUleb128(data, pos))
  result = newSeq[AdapterFunc](adapterCount)

  for a in 0 ..< adapterCount:
    result[a].name = readUleb128String(data, pos)
    let paramCount = int(readUleb128(data, pos))
    result[a].params = newSeq[string](paramCount)
    for i in 0 ..< paramCount:
      result[a].params[i] = readUleb128String(data, pos)
    result[a].retType = readUleb128String(data, pos)
    let flags = int(readUleb128(data, pos))
    result[a].isAsync = (flags and 1) != 0
    result[a].isConstructor = (flags and 2) != 0
    result[a].isMethod = (flags and 4) != 0
    result[a].className = readUleb128String(data, pos)
    let instrCount = int(readUleb128(data, pos))
    result[a].instructions = newSeq[AdapterInstruction](instrCount)
    for i in 0 ..< instrCount:
      result[a].instructions[i] = decodeInstr(data, pos)

# ─── WIT to JS Codegen ───

proc jsTypeCheck(varName, typeName: string): string =
  case typeName
  of "string", "String":
    &"typeof {varName} === 'string'"
  of "bool", "boolean":
    &"typeof {varName} === 'boolean'"
  of "i32", "u32", "int", "uint", "f32", "f64", "number":
    &"typeof {varName} === 'number'"
  of "i64", "u64":
    &"typeof {varName} === 'bigint'"
  else:
    &"typeof {varName} === 'object' && {varName} !== null"

proc generateJsFromAdapter*(adapter: AdapterFunc): string =
  ## Generate JavaScript code from adapter instructions.
  ## Returns JS function body string.
  var lines: seq[string] = @[]
  let indent = "    "

  lines.add(&"// Adapter: {adapter.name}")

  if adapter.isMethod:
    lines.add(&"// Method on {adapter.className}")

  var argNames: seq[string] = @[]
  for i in 0 ..< adapter.params.len:
    argNames.add(&"arg{i}")

  if adapter.isMethod and not adapter.isConstructor:
    argNames.insert("self", 0)

  lines.add(&"function {adapter.name}({argNames.join(\", \")}) {{")
  lines.add(&"{indent}try {{")

  # Process instructions
  var callTarget = ""
  var callArgs: seq[string] = @[]
  var retVar = "__ret"
  var hasReturn = false

  for instr in adapter.instructions:
    case instr.kind
    of aiArgGet:
      let name = if instr.argIdx < argNames.len: argNames[instr.argIdx]
                 else: &"arg{instr.argIdx}"
      callArgs.add(name)

    of aiCallImport:
      callTarget = instr.name
      let argsStr = callArgs.join(", ")
      if adapter.retType != "" and adapter.retType != "unit" and adapter.retType != "void":
        lines.add(&"{indent}const {retVar} = {callTarget}({argsStr});")
        hasReturn = true
      else:
        lines.add(&"{indent}{callTarget}({argsStr});")
      callArgs = @[]

    of aiCallExport:
      callTarget = instr.name
      let argsStr = callArgs.join(", ")
      if adapter.retType != "" and adapter.retType != "unit" and adapter.retType != "void":
        lines.add(&"{indent}const {retVar} = wasm.{callTarget}({argsStr});")
        hasReturn = true
      else:
        lines.add(&"{indent}wasm.{callTarget}({argsStr});")
      callArgs = @[]

    of aiCallMethod:
      if adapter.isConstructor:
        let argsStr = callArgs.join(", ")
        lines.add(&"{indent}const {retVar} = new {adapter.className}({argsStr});")
        hasReturn = true
      else:
        let argsStr = callArgs.join(", ")
        if adapter.retType != "" and adapter.retType != "unit" and adapter.retType != "void":
          lines.add(&"{indent}const {retVar} = self.{instr.name}({argsStr});")
          hasReturn = true
        else:
          lines.add(&"{indent}self.{instr.name}({argsStr});")
      callArgs = @[]

    of aiLoadI32:
      if callArgs.len > 0:
        callArgs[^1] = &"({callArgs[^1]} | 0)"
    of aiStoreI32:
      discard
    of aiLoadI64:
      if callArgs.len > 0:
        callArgs[^1] = &"BigInt({callArgs[^1]})"
    of aiStoreI64:
      discard
    of aiLoadF32:
      discard
    of aiStoreF32:
      discard
    of aiLoadF64:
      discard
    of aiStoreF64:
      discard
    of aiLoadStringWasm:
      lines.add(&"{indent}const __sptr = wasm.__nbg_malloc({callArgs[^1]}.length, 1);")
      lines.add(&"{indent}getUint8Memory0().set(new TextEncoder().encode({callArgs[^1]}), __sptr);")
      callArgs[^1] = &"__sptr"
    of aiStoreStringWasm:
      discard
    of aiLoadStringOwned:
      discard
    of aiStoreStringOwned:
      if hasReturn:
        lines.add(&"{indent}const __rptr = wasm.__nbg_boxed_str_ptr({retVar});")
        lines.add(&"{indent}const __rlen = wasm.__nbg_boxed_str_len({retVar});")
        lines.add(&"{indent}const __sret = getStringFromWasm(__rptr, __rlen);")
        lines.add(&"{indent}wasm.__nbg_boxed_str_free({retVar});")
        retVar = "__sret"
    of aiLoadExternref:
      if callArgs.len > 0:
        callArgs[^1] = &"addHeapObject({callArgs[^1]})"
    of aiStoreExternref:
      if hasReturn:
        lines.add(&"{indent}const __oret = takeObject({retVar});")
        retVar = "__oret"
    of aiLoadRef:
      discard
    of aiStoreRef:
      discard
    of aiLoadBool:
      if callArgs.len > 0:
        callArgs[^1] = &"({callArgs[^1]} ? 1 : 0)"
    of aiStoreBool:
      if hasReturn:
        lines.add(&"{indent}const __bret = {retVar} !== 0;")
        retVar = "__bret"
    of aiLoadRetptr:
      discard
    of aiStoreRetptr:
      discard
    of aiOptionGet:
      discard
    of aiOptionSet:
      if hasReturn:
        lines.add(&"{indent}const __oret2 = {retVar} === 0 ? undefined : {retVar};")
        retVar = "__oret2"
    of aiVectorGet:
      discard
    of aiVectorSet:
      discard
    of aiClosureGet:
      discard
    of aiClosureSet:
      discard
    of aiRethrow:
      lines.add(&"{indent}throw heap[{callArgs[^1]}];")
    of aiThrow:
      lines.add(&"{indent}throw new Error('{instr.name}');")
    of aiReturn:
      if hasReturn:
        lines.add(&"{indent}return {retVar};")
      else:
        lines.add(&"{indent}return;")
    of aiUnit:
      discard

  lines.add(&"  }} catch (e) {{")
  lines.add(&"{indent}throw e;")
  lines.add("  }")
  lines.add("}")

  result = lines.join("\n")

# ─── Program to Adapters Conversion ───

proc classifyParamType(arg: FunctionArgumentData): string =
  if arg.tyOverride.len > 0:
    return arg.tyOverride
  if arg.name.toLowerAscii().contains("name") or
     arg.name.toLowerAscii().contains("str"):
    return "string"
  return "i32"

proc programToAdapters*(prog: Program): seq[AdapterFunc] =
  ## Convert a Program descriptor to adapter functions.
  ## This bridges the old Program-based metadata with the new WIT-based system.
  result = @[]

  for imp in prog.imports:
    case imp.importKind.kind
    of ikFunction:
      let f = imp.importKind.funcData
      var params: seq[(string, string)] = @[]
      for arg in f.function.args:
        params.add((arg.name, classifyParamType(arg)))
      let retTy = if f.function.retTyOverride.len > 0: f.function.retTyOverride
                  else: ""
      var adapter = buildImportAdapter(f.shim, params, retTy)
      adapter.isAsync = f.function.isAsync
      result.add(adapter)

    of ikStatic:
      let s = imp.importKind.staticData
      result.add(buildImportAdapter(s.shim, @[], ""))

    of ikString:
      let s = imp.importKind.stringData
      result.add(buildImportAdapter(s.shim, @[], "string"))

    of ikType:
      let t = imp.importKind.typeData
      result.add(buildImportAdapter(t.instanceofShim, @[("obj", "JsValue")], "bool"))

    of ikEnum:
      discard

  for exp in prog.exports:
    var params: seq[(string, string)] = @[]
    for arg in exp.function.args:
      params.add((arg.name, classifyParamType(arg)))
    let retTy = if exp.function.retTyOverride.len > 0: exp.function.retTyOverride
                else: ""

    if exp.class.isSome:
      let className = exp.class.get()
      if exp.methodKind == mkConstructor:
        var adapter = buildMethodAdapter(className, "new", params, "", isConstructor = true)
        result.add(adapter)
      else:
        let methodName = exp.function.name
        var adapter = buildMethodAdapter(className, methodName, params, retTy)
        result.add(adapter)
    else:
      var adapter = buildExportAdapter(exp.function.name, params, retTy)
      adapter.isAsync = exp.function.isAsync
      result.add(adapter)

  for ns in prog.structs:
    let className = ns.name
    var ctorParams: seq[(string, string)] = @[]
    for field in ns.fields:
      ctorParams.add((field.name, field.tyOverride))
    result.add(buildMethodAdapter(className, "new", ctorParams, "", isConstructor = true))

    for field in ns.fields:
      let getterName = "get_" & field.name
      var getterAdapter = buildMethodAdapter(className, getterName, @[], field.tyOverride)
      result.add(getterAdapter)

      if not field.readonly:
        let setterName = "set_" & field.name
        var setterAdapter = buildMethodAdapter(className, setterName,
                                               @[(field.name, field.tyOverride)], "")
        result.add(setterAdapter)
