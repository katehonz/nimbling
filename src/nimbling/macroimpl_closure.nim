## Closure support for nimbling: JS callback export/import wrappers.
## Handles detection, shim generation, descriptor emission, and JS glue.
##
## When a proc with {.wasmBindgen.} has Closure parameters or return types,
## this module generates the appropriate ABI conversion shims.

import std/macros
import common
import codegen

# ─── Closure type detection ───

proc isClosureType*(tname: string): bool =
  ## Returns true if the type name represents a Closure type.
  ## Matches "Closure", "Closure[T]", and "ScopedClosure".
  result = tname == "Closure" or tname == "ScopedClosure"

# ─── Parse formal params preserving type AST nodes ───

type
  ClosureParam = object
    name: string
    typeName: string
    typeNode: NimNode

proc parseClosureParams(params: NimNode): seq[ClosureParam] =
  result = @[]
  for i in 1 ..< params.len:
    let p = params[i]
    if p.kind == nnkIdentDefs:
      let typeNode = p[^2]
      let tname = typeNode.typeName()
      for j in 0 ..< (p.len - 2):
        case p[j].kind
        of nnkIdent, nnkSym:
          result.add(ClosureParam(
            name: p[j].strVal,
            typeName: tname,
            typeNode: typeNode,
          ))
        else: discard

# ─── Build wasm ABI shim for closure-bearing procs ───

proc buildClosureExportWrapper*(procName: string, args: seq[(string, string)],
                                retTypeStr: string, isVoid: bool,
                                paramsNode: NimNode): NimNode =
  ## Generates a wrapper proc that converts wasm ABI to Nim types for procs
  ## that have Closure parameters or return values.
  ##
  ## Closure args are received as uint32 (JS heap index) and cast to the
  ## proper Closure[T] type. Closure returns have their .idx extracted.

  let shimName = ident("__nbg_shim_" & procName)
  let origName = ident(procName)

  var closureParams = parseClosureParams(paramsNode)

  # ── formal params ──
  var formalParams = newNimNode(nnkFormalParams)

  if isVoid:
    formalParams.add(newEmptyNode())
  elif isClosureType(retTypeStr):
    formalParams.add(ident("uint32"))
  elif retTypeStr == "string":
    formalParams.add(ident("uint32"))
  else:
    formalParams.add(ident(nimTypeToWasmAbiType(retTypeStr)))

  for i, cp in closureParams:
    if cp.typeName == "string":
      formalParams.add(newIdentDefs(ident(cp.name & "_ptr"), ident("uint32")))
      formalParams.add(newIdentDefs(ident(cp.name & "_len"), ident("uint32")))
    elif isClosureType(cp.typeName):
      formalParams.add(newIdentDefs(ident(cp.name & "_idx"), ident("uint32")))
    else:
      formalParams.add(newIdentDefs(ident(cp.name), ident(nimTypeToWasmAbiType(cp.typeName))))

  # ── body ──
  var body = newStmtList()

  var needMalloc = false
  if retTypeStr == "string":
    needMalloc = true
  for cp in closureParams:
    if cp.typeName == "string":
      needMalloc = true

  if needMalloc:
    let mallocFn = ident("nbgMalloc")
    body.add quote do:
      proc `mallocFn`(size, align: uint32): pointer {.importc: "__nbg_malloc", nodecl.}

  # 1) convert string args: ptr+len -> Nim string
  for cp in closureParams:
    if cp.typeName == "string":
      let s = ident(cp.name)
      let p = ident(cp.name & "_ptr")
      let l = ident(cp.name & "_len")
      body.add quote do:
        var `s` = newString(int(`l`))
        if `l` > 0:
          copyMem(addr `s`[0], cast[pointer](`p`), int(`l`))

  # 1b) cast enum args from int32 -> enum type
  for cp in closureParams:
    if isEnumType(cp.typeName):
      let p = ident(cp.name)
      let enumType = cp.typeNode
      body.add quote do:
        var `p` = cast[`enumType`](`p`)

  # 1c) cast struct args from uint32 pointer -> struct value
  for cp in closureParams:
    if isStructType(cp.typeName):
      let p = ident(cp.name)
      let structType = cp.typeNode
      body.add quote do:
        var `p` = cast[ptr `structType`](`p`)[]

  # 1d) cast closure args from uint32 -> Closure[T]
  for cp in closureParams:
    if isClosureType(cp.typeName):
      let p = ident(cp.name)
      let l = ident(cp.name & "_idx")
      let closureType = cp.typeNode
      body.add quote do:
        var `p` = cast[`closureType`](`l`)

  # 2) build the call to the original proc
  var call = newCall(origName)
  for cp in closureParams:
    call.add(ident(cp.name))

  # 3) handle return value
  if isVoid:
    body.add(call)
  elif isClosureType(retTypeStr):
    let retId = genSym(nskLet, "ret")
    body.add(newLetStmt(retId, call))
    body.add quote do:
      return `retId`.idx
  elif retTypeStr == "string":
    let retId = genSym(nskLet, "ret")
    let dataLen = ident("dataLen")
    let dataPtr = ident("dataPtr")
    let boxPtr = ident("boxPtr")
    let mallocFn = ident("nbgMalloc")
    body.add(newLetStmt(retId, call))
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
  let pragmas = nnkPragmaExpr.newTree(
    shimName,
    nnkPragma.newTree(ident("exportc"), ident("cdecl"))
  )

  result = nnkProcDef.newTree(
    pragmas, newEmptyNode(), newEmptyNode(),
    formalParams, newEmptyNode(), newEmptyNode(),
    body
  )

# ─── Closure descriptor emission ───

proc emitClosureDescriptor*(body: var NimNode, procName: string,
                            args: seq[(string, string)], retTypeStr: string,
                            retTyId: uint32, isVoid: bool, closureIdx: var int) =
  ## Emits the __nbg_describe() call sequence for a closure descriptor.
  ## Appends statements to `body`.
  ##
  ## Format per wasm-bindgen schema:
  ##   TY_CLOSURE
  ##   owned flag (uint32: 1 for owned)
  ##   mutable flag (uint32: 1 for mutable)
  ##   TY_FUNCTION
  ##   shimIdx (uint32: 0 for exports)
  ##   argCount (uint32)
  ##   [arg type descriptors...]
  ##   ret type descriptor
  ##   innerRet type descriptor (same as ret for non-Result types)

  let descCall = ident("__nbg_describe")

  # TY_CLOSURE
  body.add(newCall(descCall, newLit(TY_CLOSURE)))
  # owned
  body.add(newCall(descCall, newLit(1'u32)))
  # mutable
  body.add(newCall(descCall, newLit(1'u32)))
  # TY_FUNCTION
  body.add(newCall(descCall, newLit(TY_FUNCTION)))
  # shimIdx (0 for exports)
  body.add(newCall(descCall, newLit(0'u32)))
  # argCount
  body.add(newCall(descCall, newLit(args.len.uint32)))

  # arg type descriptors
  for (_, ptype) in args:
    if isEnumType(ptype):
      let ne = getEnum(ptype)
      body.add(newCall(descCall, newLit(TY_ENUM)))
      body.add(newCall(descCall, newLit(ne.name.len.uint32)))
      for c in ne.name:
        body.add(newCall(descCall, newLit(uint32(c))))
      body.add(newCall(descCall, newLit(ne.hole)))
    elif isStructType(ptype):
      let ns = getStruct(ptype)
      body.add(newCall(descCall, newLit(TY_RUST_STRUCT)))
      body.add(newCall(descCall, newLit(ns.name.len.uint32)))
      for c in ns.name:
        body.add(newCall(descCall, newLit(uint32(c))))
    else:
      let tyLit = newLit(nimTypeToTyId(ptype))
      body.add(newCall(descCall, tyLit))

  # ret type descriptor
  if isVoid:
    body.add(newCall(descCall, newLit(TY_UNIT)))
  elif isEnumType(retTypeStr):
    let ne = getEnum(retTypeStr)
    body.add(newCall(descCall, newLit(TY_ENUM)))
    body.add(newCall(descCall, newLit(ne.name.len.uint32)))
    for c in ne.name:
      body.add(newCall(descCall, newLit(uint32(c))))
    body.add(newCall(descCall, newLit(ne.hole)))
  elif isStructType(retTypeStr):
    let ns = getStruct(retTypeStr)
    body.add(newCall(descCall, newLit(TY_RUST_STRUCT)))
    body.add(newCall(descCall, newLit(ns.name.len.uint32)))
    for c in ns.name:
      body.add(newCall(descCall, newLit(uint32(c))))
  else:
    body.add(newCall(descCall, newLit(retTyId)))

  # innerRet (same as ret for non-Result types)
  if isVoid:
    body.add(newCall(descCall, newLit(TY_UNIT)))
  elif isEnumType(retTypeStr):
    let ne = getEnum(retTypeStr)
    body.add(newCall(descCall, newLit(TY_ENUM)))
    body.add(newCall(descCall, newLit(ne.name.len.uint32)))
    for c in ne.name:
      body.add(newCall(descCall, newLit(uint32(c))))
    body.add(newCall(descCall, newLit(ne.hole)))
  elif isStructType(retTypeStr):
    let ns = getStruct(retTypeStr)
    body.add(newCall(descCall, newLit(TY_RUST_STRUCT)))
    body.add(newCall(descCall, newLit(ns.name.len.uint32)))
    for c in ns.name:
      body.add(newCall(descCall, newLit(uint32(c))))
  else:
    body.add(newCall(descCall, newLit(retTyId)))

# ─── Closure JS glue generation ───

proc generateClosureGlueJs*(): string =
  ## Returns JS code string for closure intrinsics.
  ## These functions handle wrapping/unwrapping Nim closures as JS callbacks.

  result = """
// ─── Closure Intrinsics ───
function __nbg_closure_wrapper(idx) {
  return function(...args) {
    const closure = takeObject(idx);
    return closure.apply(this, args);
  };
}

function __nbg_create_closure(fn) {
  return addHeapObject(fn);
}

function __nbg_closure_drop(idx) {
  takeObject(idx);
}

function __nbg_call_closure(idx, ...args) {
  const fn = heap[idx];
  if (typeof fn !== 'function') throw new Error('expected a function');
  return fn.apply(this, args);
}

function __nbg_closure_arg_to_wasm(arg) {
  const callIdx = addHeapObject(arg);
  return callIdx;
}
"""
