## Binary decoder for Program metadata.
## Reads varint-encoded program descriptor from a binary stream.
## Equivalent to shared program decode path in wasm-bindgen CLI.

import common
import std/streams

type
  Decoder* = object
    stream*: StringStream
    pos*: int

  DecodeError* = object of CatchableError

proc newDecoder*(data: seq[byte]): Decoder =
  let s = newStringStream(cast[string](data))
  Decoder(stream: s)

proc readByte(d: var Decoder): byte =
  result = byte(d.stream.readChar())
  inc d.pos

proc readVarint32(d: var Decoder): uint32 =
  var shift = 0'u32
  while true:
    let b = d.readByte()
    result = result or ((uint32(b) and 0x7F'u32) shl shift)
    if (b and 0x80) == 0:
      break
    shift += 7

proc decodeBool(d: var Decoder): bool =
  d.readByte() != 0

proc decodeU32(d: var Decoder): uint32 =
  d.readVarint32()

proc decodeInt(d: var Decoder): int =
  int(d.readVarint32())

proc decodeString(d: var Decoder): string =
  let len = d.decodeInt()
  result = newString(len)
  for i in 0..<len:
    result[i] = char(d.readByte())

proc decodeOptionString(d: var Decoder): Option[string] =
  if d.decodeBool():
    result = some(d.decodeString())

proc decodeSeqString(d: var Decoder): seq[string] =
  let len = d.decodeInt()
  result = newSeq[string](len)
  for i in 0..<len:
    result[i] = d.decodeString()

proc decodeImportModule(d: var Decoder): ImportModule =
  let kind = d.decodeInt()
  case kind
  of 0: result = ImportModule(kind: imNamed, name: d.decodeString())
  of 1: result = ImportModule(kind: imRawNamed, rawName: d.decodeString())
  of 2: result = ImportModule(kind: imInline, inlineIdx: d.decodeU32())
  else: raise newException(DecodeError, "bad ImportModule kind")

proc decodeFunctionArg(d: var Decoder): FunctionArgumentData =
  FunctionArgumentData(
    name: d.decodeString(),
    tyOverride: d.decodeString(),
    optional: d.decodeBool(),
    desc: d.decodeString(),
  )

proc decodeFunctionDesc(d: var Decoder): FunctionDesc =
  let argCount = d.decodeInt()
  var args = newSeq[FunctionArgumentData](argCount)
  for i in 0..<argCount:
    args[i] = d.decodeFunctionArg()
  FunctionDesc(
    args: args,
    isAsync: d.decodeBool(),
    name: d.decodeString(),
    generateTypescript: d.decodeBool(),
    generateJsdoc: d.decodeBool(),
    variadic: d.decodeBool(),
    retTyOverride: d.decodeString(),
    retDesc: d.decodeString(),
  )

proc decodeOperation(d: var Decoder): Operation =
  Operation(
    isStatic: d.decodeBool(),
    kind: OperationKind(d.decodeInt()),
    propertyName: d.decodeString(),
  )

proc decodeMethodData(d: var Decoder): MethodData =
  MethodData(
    class: d.decodeString(),
    methodKind: MethodKind(d.decodeInt()),
    operation: d.decodeOperation(),
  )

proc decodeOptionMethodData(d: var Decoder): Option[MethodData] =
  if d.decodeBool():
    result = some(d.decodeMethodData())

proc decodeImportFunction(d: var Decoder): ImportFunction =
  ImportFunction(
    shim: d.decodeString(),
    catch: d.decodeBool(),
    variadic: d.decodeBool(),
    assertNoShim: d.decodeBool(),
    methodData: d.decodeOptionMethodData(),
    structural: d.decodeBool(),
    function: d.decodeFunctionDesc(),
  )

proc decodeImportStatic(d: var Decoder): ImportStatic =
  ImportStatic(
    name: d.decodeString(),
    shim: d.decodeString(),
  )

proc decodeImportString(d: var Decoder): ImportString =
  ImportString(
    shim: d.decodeString(),
    string: d.decodeString(),
  )

proc decodeImportType(d: var Decoder): ImportType =
  ImportType(
    name: d.decodeString(),
    instanceofShim: d.decodeString(),
    vendorPrefixes: d.decodeSeqString(),
  )

proc decodeStringEnum(d: var Decoder): StringEnum =
  StringEnum(
    name: d.decodeString(),
    variantValues: d.decodeSeqString(),
    comments: d.decodeSeqString(),
    generateTypescript: d.decodeBool(),
    jsNamespace: d.decodeSeqString(),
  )

proc decodeImportKind(d: var Decoder): ImportKindObj =
  let kind = d.decodeInt()
  case kind
  of 0: result = ImportKindObj(kind: ikFunction, funcData: d.decodeImportFunction())
  of 1: result = ImportKindObj(kind: ikStatic, staticData: d.decodeImportStatic())
  of 2: result = ImportKindObj(kind: ikString, stringData: d.decodeImportString())
  of 3: result = ImportKindObj(kind: ikType, typeData: d.decodeImportType())
  of 4: result = ImportKindObj(kind: ikEnum, enumData: d.decodeStringEnum())
  else: raise newException(DecodeError, "bad ImportKind")

proc decodeOptionImportModule(d: var Decoder): Option[ImportModule] =
  if d.decodeBool():
    result = some(d.decodeImportModule())

proc decodeNestedSeqString(d: var Decoder): seq[seq[string]] =
  let outerLen = d.decodeInt()
  result = newSeq[seq[string]](outerLen)
  for i in 0..<outerLen:
    result[i] = d.decodeSeqString()

proc decodeImport(d: var Decoder): Import =
  Import(
    module: d.decodeOptionImportModule(),
    jsNamespace: d.decodeNestedSeqString(),
    reexport: d.decodeOptionString(),
    generateTypescript: d.decodeBool(),
    importKind: d.decodeImportKind(),
  )

proc decodeExport(d: var Decoder): Export =
  Export(
    class: d.decodeOptionString(),
    comments: d.decodeSeqString(),
    consumed: d.decodeBool(),
    function: d.decodeFunctionDesc(),
    jsNamespace: d.decodeSeqString(),
    methodKind: MethodKind(d.decodeInt()),
    startKind: d.decodeInt(),
  )

proc decodeEnumVariant(d: var Decoder): EnumVariant =
  EnumVariant(
    name: d.decodeString(),
    value: d.decodeU32(),
    comments: d.decodeSeqString(),
  )

proc decodeNimEnum(d: var Decoder): NimEnum =
  let name = d.decodeString()
  let signed = d.decodeBool()
  let varCount = d.decodeInt()
  var vars = newSeq[EnumVariant](varCount)
  for i in 0..<varCount:
    vars[i] = d.decodeEnumVariant()
  NimEnum(
    name: name,
    signed: signed,
    variants: vars,
    comments: d.decodeSeqString(),
    generateTypescript: d.decodeBool(),
    jsNamespace: d.decodeSeqString(),
    hole: d.decodeU32(),
    private: d.decodeBool(),
  )

proc decodeStructField(d: var Decoder): StructField =
  StructField(
    name: d.decodeString(),
    readonly: d.decodeBool(),
    comments: d.decodeSeqString(),
    generateTypescript: d.decodeBool(),
    generateJsdoc: d.decodeBool(),
    tyOverride: d.decodeString(),
  )

proc decodeNimStruct(d: var Decoder): NimStruct =
  let name = d.decodeString()
  let nimName = d.decodeString()
  let fieldCount = d.decodeInt()
  var fields = newSeq[StructField](fieldCount)
  for i in 0..<fieldCount:
    fields[i] = d.decodeStructField()
  NimStruct(
    name: name,
    nimName: nimName,
    fields: fields,
    comments: d.decodeSeqString(),
    isInspectable: d.decodeBool(),
    generateTypescript: d.decodeBool(),
    jsNamespace: d.decodeSeqString(),
    private: d.decodeBool(),
  )

proc decodeLinkedModule(d: var Decoder): LinkedModule =
  LinkedModule(
    module: d.decodeImportModule(),
    linkFunctionName: d.decodeString(),
  )

proc decodeLocalModule(d: var Decoder): LocalModule =
  LocalModule(
    identifier: d.decodeString(),
    contents: d.decodeString(),
    linkedModule: d.decodeBool(),
  )

proc decodeLitOrExpr(d: var Decoder): LitOrExpr =
  LitOrExpr(
    isExpr: d.decodeBool(),
    value: d.decodeString(),
  )

proc decodeProgram*(d: var Decoder): Program =
  ## Decode a full Program from the binary stream.
  let schemaVersion = d.decodeString()
  if schemaVersion != SchemaVersion:
    raise newException(DecodeError,
      "schema version mismatch: got " & schemaVersion & ", expected " & SchemaVersion)

  let exportCount = d.decodeInt()
  var exports = newSeq[Export](exportCount)
  for i in 0..<exportCount:
    exports[i] = d.decodeExport()

  let enumCount = d.decodeInt()
  var enums = newSeq[NimEnum](enumCount)
  for i in 0..<enumCount:
    enums[i] = d.decodeNimEnum()

  let importCount = d.decodeInt()
  var imports = newSeq[Import](importCount)
  for i in 0..<importCount:
    imports[i] = d.decodeImport()

  let structCount = d.decodeInt()
  var structs = newSeq[NimStruct](structCount)
  for i in 0..<structCount:
    structs[i] = d.decodeNimStruct()

  let tsCount = d.decodeInt()
  var tsSections = newSeq[LitOrExpr](tsCount)
  for i in 0..<tsCount:
    tsSections[i] = d.decodeLitOrExpr()

  let lmCount = d.decodeInt()
  var localModules = newSeq[LocalModule](lmCount)
  for i in 0..<lmCount:
    localModules[i] = d.decodeLocalModule()

  let ijCount = d.decodeInt()
  var inlineJs = newSeq[string](ijCount)
  for i in 0..<ijCount:
    inlineJs[i] = d.decodeString()

  let uniqueId = d.decodeString()
  let pj = d.decodeOptionString()

  let linkedCount = d.decodeInt()
  var linkedModules = newSeq[LinkedModule](linkedCount)
  for i in 0..<linkedCount:
    linkedModules[i] = d.decodeLinkedModule()

  result = Program(
    exports: exports,
    enums: enums,
    imports: imports,
    structs: structs,
    typescriptCustomSections: tsSections,
    localModules: localModules,
    inlineJs: inlineJs,
    uniqueCrateIdentifier: uniqueId,
    packageJson: pj,
    linkedModules: linkedModules,
  )
