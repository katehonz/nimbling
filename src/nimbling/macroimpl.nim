## Macro implementation: the `{.wasmBindgen.}` pragma.
## This is the compile-time engine that:
## 1. Parses Nim AST for annotated procs
## 2. Generates export wrappers with ABI conversion
## 3. Generates descriptor functions for the CLI interpreter
## 4. Encodes program metadata for the custom wasm section

import std/macros
import std/tables
import common
import encode
import codegen
import macroimpl_closure
import macroimpl_async
import macroimpl_attrs

# ─── Build an {.exportc, cdecl.} wrapper proc ───

proc buildShimProc(procName: string, args: seq[(string, string)],
                   retTypeStr: string, isVoid: bool): NimNode =
  ## Generates a wrapper proc that converts wasm ABI ↔ Nim types.
  ##
  ## For `proc greet(name: string): string`:
  ##   proc __nbg_shim_greet(name_ptr, name_len: uint32): uint32 {.exportc, cdecl.} =
  ##     var name = newString(name_len.int)
  ##     if name_len > 0: copyMem(addr name[0], cast[pointer](name_ptr), name_len.int)
  ##     let ret = greet(name)
  ##     # box the return string...
  ##
  ## For `proc add(a, b: int32): int32`:
  ##   proc __nbg_shim_add(a, b: int32): int32 {.exportc, cdecl.} =
  ##     return add(a, b)

  let shimName = ident("__nbg_shim_" & procName)
  let origName = ident(procName)

  # ── formal params ──
  var formalParams = newNimNode(nnkFormalParams)

  if isVoid:
    formalParams.add(newEmptyNode())
  elif retTypeStr == "string":
    formalParams.add(ident("uint32"))      # boxed string handle
  else:
    formalParams.add(ident(nimTypeToWasmAbiType(retTypeStr)))

  for (pname, ptype) in args:
    if ptype == "string":
      formalParams.add(newIdentDefs(ident(pname & "_ptr"), ident("uint32")))
      formalParams.add(newIdentDefs(ident(pname & "_len"), ident("uint32")))
    else:
      formalParams.add(newIdentDefs(ident(pname), ident(nimTypeToWasmAbiType(ptype))))

  # ── body ──
  var body = newStmtList()

  # 1) convert string args: ptr+len → Nim string
  for (pname, ptype) in args:
    if ptype == "string":
      let s = ident(pname)
      let p = ident(pname & "_ptr")
      let l = ident(pname & "_len")
      body.add quote do:
        var `s` = newString(int(`l`))
        if `l` > 0:
          copyMem(addr `s`[0], cast[pointer](`p`), int(`l`))

  # 1b) cast enum args from int32 → enum type
  for (pname, ptype) in args:
    if isEnumType(ptype):
      let p = ident(pname)
      let enumType = ident(ptype)
      body.add quote do:
        var `p` = cast[`enumType`](`p`)

  # 1c) cast struct args from uint32 pointer → struct value
  for (pname, ptype) in args:
    if isStructType(ptype):
      let p = ident(pname)
      let structType = ident(ptype)
      body.add quote do:
        var `p` = cast[ptr `structType`](`p`)[]

  # 2) build the call to the original proc
  var call = newCall(origName)
  for (pname, _) in args:
    call.add(ident(pname))

  # 3) handle return value
  if isVoid:
    body.add(call)
  elif retTypeStr == "string":
    let retId = genSym(nskLet, "ret")
    let dataLen = ident("dataLen")
    let dataPtr = ident("dataPtr")
    let boxPtr  = ident("boxPtr")
    let mallocFn = ident("nbgMalloc")
    body.add(newLetStmt(retId, call))
    # Box the string: allocate {data_ptr, data_len} struct in wasm memory
    body.add quote do:
      let `dataLen` = uint32(`retId`.len)
      var `dataPtr`: uint32 = 0
      if `dataLen` > 0:
        `dataPtr` = cast[uint32](`mallocFn`(`dataLen`, 1))
        copyMem(cast[pointer](`dataPtr`), unsafeAddr `retId`[0], int(`dataLen`))
      let `boxPtr` = cast[uint32](`mallocFn`(8, 4))
      cast[ptr uint32](cast[pointer](`boxPtr`))[]       = `dataPtr`
      cast[ptr uint32](cast[pointer](cast[uint](`boxPtr`) + 4))[] = `dataLen`
      return `boxPtr`
  elif isEnumType(retTypeStr):
    let retId = genSym(nskLet, "ret")
    body.add(newLetStmt(retId, call))
    body.add quote do:
      return cast[int32](`retId`)
  elif isStructType(retTypeStr):
    let retId = genSym(nskLet, "ret")
    let retPtr = genSym(nskLet, "retPtr")
    let structType = ident(retTypeStr)
    let mallocFn = ident("nbgMalloc")
    body.add(newLetStmt(retId, call))
    body.add quote do:
      let `retPtr` = cast[uint32](`mallocFn`(sizeof(`structType`).uint32, 4))
      cast[ptr `structType`](`retPtr`)[] = `retId`
      return `retPtr`
  else:
    body.add(nnkReturnStmt.newTree(call))

  # ── assemble proc def ──
  result = nnkProcDef.newTree(
    shimName, newEmptyNode(), newEmptyNode(),
    formalParams,
    nnkPragma.newTree(ident("exportc"), ident("cdecl")),
    newEmptyNode(),
    body
  )

# ─── Helper: emit multi-u32 enum descriptor ───

proc emitDescribeEnum(body: var NimNode, ne: NimEnum) =
  let descCall = ident("__nbg_describe")
  body.add(newCall(descCall, newLit(TY_ENUM)))
  # emit name length
  body.add(newCall(descCall, newLit(ne.name.len.uint32)))
  # emit each char
  for c in ne.name:
    body.add(newCall(descCall, newLit(uint32(c))))
  # emit hole
  body.add(newCall(descCall, newLit(ne.hole)))

# ─── Helper: emit multi-u32 struct descriptor ───

proc emitDescribeStruct(body: var NimNode, ns: NimStruct) =
  let descCall = ident("__nbg_describe")
  body.add(newCall(descCall, newLit(TY_RUST_STRUCT)))
  # emit name length
  body.add(newCall(descCall, newLit(ns.name.len.uint32)))
  # emit each char
  for c in ns.name:
    body.add(newCall(descCall, newLit(uint32(c))))

# ─── Build a __nbg_describe_* descriptor proc ───

proc buildDescribeProc(procName: string, args: seq[(string, string)],
                       retTyId: uint32, retTypeStr: string, isVoid: bool): NimNode =
  ## Generates:
  ##   proc __nbg_describe_NAME() {.exportc, cdecl.} =
  ##     __nbg_describe(TY_ARG0)
  ##     __nbg_describe(TY_ARG1)
  ##     __nbg_describe(TY_RET)

  let descFnName = ident(DescribeFnPrefix & procName)
  let descCall   = ident("__nbg_describe")

  var body = newStmtList()

  # describe each argument type
  for (_, ptype) in args:
    if isEnumType(ptype):
      emitDescribeEnum(body, getEnum(ptype))
    elif isStructType(ptype):
      emitDescribeStruct(body, getStruct(ptype))
    else:
      let tyLit = newLit(nimTypeToTyId(ptype))
      body.add(newCall(descCall, tyLit))

  # describe return type
  if isVoid:
    body.add(newCall(descCall, newLit(TY_UNIT)))
  elif isEnumType(retTypeStr):
    emitDescribeEnum(body, getEnum(retTypeStr))
  elif isStructType(retTypeStr):
    emitDescribeStruct(body, getStruct(retTypeStr))
  else:
    body.add(newCall(descCall, newLit(retTyId)))

  result = nnkProcDef.newTree(
    descFnName, newEmptyNode(), newEmptyNode(),
    nnkFormalParams.newTree(newEmptyNode()),
    nnkPragma.newTree(ident("exportc"), ident("cdecl")),
    newEmptyNode(),
    body
  )

# ─── Compile-time state ───

var describeImportDeclared {.compileTime.} = false
var compileTimeProgram {.compileTime.}: Program

proc accumulateExport*(exp: Export) {.compileTime.} =
  compileTimeProgram.exports.add(exp)

# ─── Main macro ───

macro wasmBindgen*(body: untyped): untyped =
  ## Main pragma macro. Use as:
  ##   {.wasmBindgen.}
  ##   proc myFunc(a: string): string = ...
  ##
  ## Generates:
  ##   1. Original proc (unchanged)
  ##   2. __nbg_shim_<name>  — {.exportc, cdecl.} wrapper with ABI conversion
  ##   3. __nbg_describe_<name> — descriptor function for CLI interpreter

  if body.kind != nnkProcDef:
    error("wasmBindgen can only be applied to proc definitions", body)

  let procDef  = body
  let procNameNode = procDef[0]
  let procName = if procNameNode.kind == nnkPostfix: procNameNode[1].strVal else: procNameNode.strVal
  let params   = procDef[3]
  let retType  = params[0]
  let isVoid   = isVoidNode(retType)
  let retTypeStr = if isVoid: "" else: retType.typeName()
  let retTyId    = if isVoid: TY_UNIT else: nimTypeToTyId(retTypeStr)

  let args = parseFormalParams(params)

  # Parse wasmBindgen attributes from proc pragmas
  let attrs = parseBindgenAttrs(procDef[4])
  let exportJsName = exportJsName(attrs, procName)

  # Check for closure types in args/return
  var hasClosure = false
  for (_, ptype) in args:
    if isClosureType(ptype):
      hasClosure = true
      break
  if not hasClosure and not isVoid and isClosureType(retTypeStr):
    hasClosure = true

  # Check for async
  let async = isAsyncProc(procDef)

  # Accumulate export in compile-time program metadata
  var funcArgs = newSeq[FunctionArgumentData]()
  for (aname, atype) in args:
    funcArgs.add(FunctionArgumentData(name: aname, tyOverride: atype))

  compileTimeProgram.exports.add(Export(
    function: FunctionDesc(
      name: exportJsName,
      args: funcArgs,
      retTyOverride: retTypeStr,
      isAsync: async,
    ),
    methodKind: if baConstructor in attrs.flags: mkConstructor else: mkOperation,
  ))

  if compileTimeProgram.uniqueCrateIdentifier.len == 0:
    compileTimeProgram.uniqueCrateIdentifier = "crate_" & procName

  result = newStmtList()

  # 1) Original proc — always present (works natively and in wasm)
  result.add(procDef)

  # 2-3) Wasm-specific code: export wrapper + descriptor (only compiled for wasm32)
  var wasmBody = newStmtList()

  # Declare __nbg_describe import (once per compilation unit)
  if not describeImportDeclared:
    let descFn = ident("__nbg_describe")
    wasmBody.add quote do:
      proc `descFn`(v: uint32) {.importc.}
    describeImportDeclared = true

  # Export wrapper
  if hasClosure:
    wasmBody.add(buildClosureExportWrapper(procName, args, retTypeStr, isVoid, params))
  elif async:
    wasmBody.add(buildAsyncExportWrapper(procName, args, retTypeStr))
  else:
    wasmBody.add(buildShimProc(procName, args, retTypeStr, isVoid))

  # Descriptor function
  if async:
    emitAsyncDescriptor(wasmBody, procName, args, retTyId)
  else:
    wasmBody.add(buildDescribeProc(procName, args, retTyId, retTypeStr, isVoid))

  # Build: when defined(wasm32): <wasmBody>
  let whenBranch = nnkElifBranch.newTree(
    newCall(ident("defined"), ident("wasm32")),
    wasmBody
  )
  let whenStmt = nnkWhenStmt.newTree(whenBranch)
  result.add(whenStmt)

# ─── Helpers for wasmBindgenType macro ───

proc parseEnumType(enumTy: NimNode, enumName: string) {.compileTime.} =
  var variants = newSeq[EnumVariant]()
  var nextValue: uint32 = 0
  for i in 1 ..< enumTy.len:
    let field = enumTy[i]
    var vname: string
    var vval: uint32
    if field.kind == nnkEnumFieldDef:
      vname = field[0].strVal
      vval = uint32(field[2].intVal)
      nextValue = vval + 1
    elif field.kind in {nnkIdent, nnkSym}:
      vname = field.strVal
      vval = nextValue
      nextValue = vval + 1
    else:
      continue
    variants.add(EnumVariant(name: vname, value: vval))

  if variants.len == 0:
    return

  var maxValue: uint32 = 0
  for v in variants:
    if v.value > maxValue: maxValue = v.value
  var hole: uint32
  if maxValue == uint32(variants.len - 1):
    hole = uint32(variants.len)
  else:
    hole = maxValue + 1

  let ne = NimEnum(
    name: enumName,
    signed: false,
    variants: variants,
    comments: @[],
    generateTypescript: true,
    jsNamespace: @[],
    hole: hole,
    private: false,
  )
  compileTimeProgram.enums.add(ne)
  enumRegistry[enumName] = ne

proc parseStructType(objectTy: NimNode, structName: string) {.compileTime.} =
  let recList = objectTy[2]
  var fields = newSeq[StructField]()

  for fieldDef in recList:
    if fieldDef.kind != nnkIdentDefs:
      continue
    let typeNode = fieldDef[^2]
    let tname = typeNode.typeName()
    for j in 0 ..< (fieldDef.len - 2):
      case fieldDef[j].kind
      of nnkIdent, nnkSym:
        fields.add(StructField(
          name: fieldDef[j].strVal,
          tyOverride: tname,
          readonly: false,
        ))
      else:
        discard

  let ns = NimStruct(
    name: structName,
    nimName: structName,
    fields: fields,
    comments: @[],
    isInspectable: false,
    generateTypescript: true,
    jsNamespace: @[],
    private: false,
  )
  compileTimeProgram.structs.add(ns)
  structRegistry[structName] = ns

# ─── Compile-time pragma for annotation ───

macro wasmBindgenType*(body: untyped): untyped =
  ## Annotation for structs/enums to be exposed to JS.
  result = body

  var typeDef: NimNode
  if body.kind == nnkTypeDef:
    typeDef = body
  elif body.kind == nnkTypeSection and body.len > 0 and body[0].kind == nnkTypeDef:
    typeDef = body[0]
  else:
    return

  let typeExpr = typeDef[2]
  let nameNode = typeDef[0]
  var typeName: string
  if nameNode.kind == nnkPragmaExpr:
    typeName = nameNode[0].strVal
  elif nameNode.kind in {nnkIdent, nnkSym}:
    typeName = nameNode.strVal
  else:
    return

  if typeExpr.kind == nnkEnumTy:
    parseEnumType(typeExpr, typeName)
    return

  var objectTy: NimNode
  if typeExpr.kind == nnkObjectTy:
    objectTy = typeExpr
  elif typeExpr.kind == nnkRefTy and typeExpr[0].kind == nnkObjectTy:
    objectTy = typeExpr[0]
  else:
    return

template wasmBindgenModule*(modulePath: static string, body: untyped): untyped =
  ## Annotation for JS import blocks.
  body

# ─── Struct shim generators ───

proc buildStructNewShim(ns: NimStruct): NimNode =
  let shimName = ident(newFunction(ns.name))
  let structType = ident(ns.name)
  let mallocFn = ident("nbgMalloc")

  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(ident("uint32"))

  var body = newStmtList()

  # String field conversions
  for field in ns.fields:
    if field.tyOverride == "string":
      let s = ident(field.name)
      let p = ident(field.name & "_ptr")
      let l = ident(field.name & "_len")
      body.add quote do:
        var `s` = newString(int(`l`))
        if `l` > 0:
          copyMem(addr `s`[0], cast[pointer](`p`), int(`l`))

  # Build object constructor
  var initStmt = nnkObjConstr.newTree(structType)
  for field in ns.fields:
    initStmt.add(newColonExpr(ident(field.name), ident(field.name)))

  body.add(newLetStmt(ident("s"), initStmt))
  body.add quote do:
    let memPtr = `mallocFn`(sizeof(`structType`).uint32, 4)
    cast[ptr `structType`](memPtr)[] = s
    return cast[uint32](memPtr)

  # Formal params
  for field in ns.fields:
    if field.tyOverride == "string":
      formalParams.add(newIdentDefs(ident(field.name & "_ptr"), ident("uint32")))
      formalParams.add(newIdentDefs(ident(field.name & "_len"), ident("uint32")))
    else:
      formalParams.add(newIdentDefs(ident(field.name), ident(nimTypeToWasmAbiType(field.tyOverride))))

  result = nnkProcDef.newTree(
    shimName, newEmptyNode(), newEmptyNode(),
    formalParams,
    nnkPragma.newTree(ident("exportc"), ident("cdecl")),
    newEmptyNode(),
    body
  )

proc buildStructFreeShim(ns: NimStruct): NimNode =
  let shimName = ident(freeFunction(ns.name))
  let structType = ident(ns.name)
  let freeFn = ident("nbgFree")

  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(newEmptyNode())
  formalParams.add(newIdentDefs(ident("ptr"), ident("uint32")))

  var body = newStmtList()
  body.add quote do:
    `freeFn`(ptr, sizeof(`structType`).uint32, 4)

  result = nnkProcDef.newTree(
    shimName, newEmptyNode(), newEmptyNode(),
    formalParams,
    nnkPragma.newTree(ident("exportc"), ident("cdecl")),
    newEmptyNode(),
    body
  )

proc buildStructGetterShim(ns: NimStruct, field: StructField): NimNode =
  let shimName = ident(structFieldGet(ns.name, field.name))
  let structType = ident(ns.name)

  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(ident(nimTypeToWasmAbiType(field.tyOverride)))
  formalParams.add(newIdentDefs(ident("ptr"), ident("uint32")))

  var body = newStmtList()

  if field.tyOverride == "string":
    let retId = genSym(nskLet, "ret")
    let dataLen = ident("dataLen")
    let dataPtr = ident("dataPtr")
    let boxPtr = ident("boxPtr")
    let mallocFn = ident("nbgMalloc")
    let castNode = nnkCast.newTree(
      nnkBracketExpr.newTree(ident("ptr"), structType),
      ident("ptr")
    )
    let fieldAccess = newDotExpr(castNode, ident(field.name))
    body.add(newLetStmt(retId, fieldAccess))
    body.add quote do:
      let `dataLen` = uint32(`retId`.len)
      var `dataPtr`: uint32 = 0
      if `dataLen` > 0:
        `dataPtr` = cast[uint32](`mallocFn`(`dataLen`, 1))
        copyMem(cast[pointer](`dataPtr`), unsafeAddr `retId`[0], int(`dataLen`))
      let `boxPtr` = cast[uint32](`mallocFn`(8, 4))
      cast[ptr uint32](cast[pointer](`boxPtr`))[] = `dataPtr`
      cast[ptr uint32](cast[pointer](cast[uint](`boxPtr`) + 4))[] = `dataLen`
      return `boxPtr`
  else:
    let castNode = nnkCast.newTree(
      nnkBracketExpr.newTree(ident("ptr"), structType),
      ident("ptr")
    )
    let fieldAccess = newDotExpr(castNode, ident(field.name))
    body.add(nnkReturnStmt.newTree(fieldAccess))

  result = nnkProcDef.newTree(
    shimName, newEmptyNode(), newEmptyNode(),
    formalParams,
    nnkPragma.newTree(ident("exportc"), ident("cdecl")),
    newEmptyNode(),
    body
  )

proc buildStructSetterShim(ns: NimStruct, field: StructField): NimNode =
  let shimName = ident(structFieldSet(ns.name, field.name))
  let structType = ident(ns.name)

  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(newEmptyNode())
  formalParams.add(newIdentDefs(ident("ptr"), ident("uint32")))

  var body = newStmtList()

  if field.tyOverride == "string":
    let s = ident(field.name)
    let p = ident(field.name & "_ptr")
    let l = ident(field.name & "_len")
    formalParams.add(newIdentDefs(p, ident("uint32")))
    formalParams.add(newIdentDefs(l, ident("uint32")))
    body.add quote do:
      var `s` = newString(int(`l`))
      if `l` > 0:
        copyMem(addr `s`[0], cast[pointer](`p`), int(`l`))
    let castNode = nnkCast.newTree(
      nnkBracketExpr.newTree(ident("ptr"), structType),
      ident("ptr")
    )
    let fieldAccess = newDotExpr(castNode, ident(field.name))
    body.add(newAssignment(fieldAccess, ident(field.name)))
  else:
    formalParams.add(newIdentDefs(ident(field.name), ident(nimTypeToWasmAbiType(field.tyOverride))))
    let castNode = nnkCast.newTree(
      nnkBracketExpr.newTree(ident("ptr"), structType),
      ident("ptr")
    )
    let fieldAccess = newDotExpr(castNode, ident(field.name))
    body.add(newAssignment(fieldAccess, ident(field.name)))

  result = nnkProcDef.newTree(
    shimName, newEmptyNode(), newEmptyNode(),
    formalParams,
    nnkPragma.newTree(ident("exportc"), ident("cdecl")),
    newEmptyNode(),
    body
  )

proc makeStructArgData(field: StructField): seq[FunctionArgumentData] =
  if field.tyOverride == "string":
    result = @[
      FunctionArgumentData(name: field.name & "_ptr", tyOverride: "uint32"),
      FunctionArgumentData(name: field.name & "_len", tyOverride: "uint32"),
    ]
  else:
    result = @[FunctionArgumentData(name: field.name, tyOverride: field.tyOverride)]

# ─── Finalize: embed the Program as a custom wasm section ───

macro wasmBindgenFinalize*(): untyped =
  ## Must be called after all `{.wasmBindgen.}` annotations to embed metadata.
  ## Encodes the accumulated Program and emits it as a custom wasm section
  ## via C `__attribute__((section(...)))`.

  # Add struct exports to compile-time program
  for structName, ns in structRegistry:
    # Constructor export
    var newArgs = newSeq[FunctionArgumentData]()
    for field in ns.fields:
      if field.tyOverride == "string":
        newArgs.add(FunctionArgumentData(name: field.name & "_ptr", tyOverride: "uint32"))
        newArgs.add(FunctionArgumentData(name: field.name & "_len", tyOverride: "uint32"))
      else:
        newArgs.add(FunctionArgumentData(name: field.name, tyOverride: field.tyOverride))
    compileTimeProgram.exports.add(Export(
      class: some(ns.name),
      methodKind: mkConstructor,
      function: FunctionDesc(
        name: newFunction(ns.name),
        args: newArgs,
        retTyOverride: "uint32",
      ),
    ))

    # Free export
    compileTimeProgram.exports.add(Export(
      class: some(ns.name),
      methodKind: mkOperation,
      function: FunctionDesc(
        name: freeFunction(ns.name),
        args: @[FunctionArgumentData(name: "ptr", tyOverride: "uint32")],
        retTyOverride: "",
      ),
    ))

    # Getter and setter exports
    for field in ns.fields:
      compileTimeProgram.exports.add(Export(
        class: some(ns.name),
        methodKind: mkOperation,
        function: FunctionDesc(
          name: structFieldGet(ns.name, field.name),
          args: @[FunctionArgumentData(name: "ptr", tyOverride: "uint32")],
          retTyOverride: field.tyOverride,
        ),
      ))
      if not field.readonly:
        var setArgs = @[FunctionArgumentData(name: "ptr", tyOverride: "uint32")]
        if field.tyOverride == "string":
          setArgs.add(FunctionArgumentData(name: field.name & "_ptr", tyOverride: "uint32"))
          setArgs.add(FunctionArgumentData(name: field.name & "_len", tyOverride: "uint32"))
        else:
          setArgs.add(FunctionArgumentData(name: field.name, tyOverride: field.tyOverride))
        compileTimeProgram.exports.add(Export(
          class: some(ns.name),
          methodKind: mkOperation,
          function: FunctionDesc(
            name: structFieldSet(ns.name, field.name),
            args: setArgs,
            retTyOverride: "",
          ),
        ))

  # Encode program
  var enc = newEncoder()
  enc.encode(compileTimeProgram)
  let bytes = enc.buf

  var cArray = ""
  for i, b in bytes:
    if i > 0: cArray.add(",")
    cArray.add($b)

  let cDef = "static const unsigned char __nbg_section_data[] __attribute__((used, section(\"" &
    CustomSectionName & "\"))) = {" & cArray & "};\n"

  let emitStr = newStrLitNode(cDef)

  result = newStmtList()

  # Generate struct shim procs (wasm32 only)
  var wasmBody = newStmtList()
  for structName, ns in structRegistry:
    wasmBody.add(buildStructNewShim(ns))
    wasmBody.add(buildStructFreeShim(ns))
    for field in ns.fields:
      wasmBody.add(buildStructGetterShim(ns, field))
      if not field.readonly:
        wasmBody.add(buildStructSetterShim(ns, field))

  if wasmBody.len > 0:
    let whenBranch = nnkElifBranch.newTree(
      newCall(ident("defined"), ident("wasm32")),
      wasmBody
    )
    let whenStmt = nnkWhenStmt.newTree(whenBranch)
    result.add(whenStmt)

  result.add quote do:
    when defined(wasm32):
      {.emit: `emitStr`.}
