## Macro implementation: the `{.wasmBindgen.}` pragma.
## This is the compile-time engine that:
## 1. Parses Nim AST for annotated procs
## 2. Generates export wrappers with ABI conversion
## 3. Generates descriptor functions for the CLI interpreter
## 4. Encodes program metadata for the custom wasm section

import std/macros
import common
import encode
import codegen

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
    formalParams.add(ident(retTypeStr))

  for (pname, ptype) in args:
    if ptype == "string":
      formalParams.add(newIdentDefs(ident(pname & "_ptr"), ident("uint32")))
      formalParams.add(newIdentDefs(ident(pname & "_len"), ident("uint32")))
    else:
      formalParams.add(newIdentDefs(ident(pname), ident(ptype)))

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

# ─── Build a __nbg_describe_* descriptor proc ───

proc buildDescribeProc(procName: string, args: seq[(string, string)],
                       retTyId: uint32, isVoid: bool): NimNode =
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
    let tyLit = newLit(nimTypeToTyId(ptype))
    body.add(newCall(descCall, tyLit))

  # describe return type
  if isVoid:
    body.add(newCall(descCall, newLit(TY_UNIT)))
  else:
    body.add(newCall(descCall, newLit(retTyId)))

  let pragmas = nnkPragmaExpr.newTree(
    descFnName,
    nnkPragma.newTree(ident("exportc"), ident("cdecl"))
  )

  result = nnkProcDef.newTree(
    pragmas, newEmptyNode(), newEmptyNode(),
    nnkFormalParams.newTree(newEmptyNode()),
    newEmptyNode(), newEmptyNode(),
    body
  )

# ─── Compile-time state ───

var describeImportDeclared {.compileTime.} = false

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
  let procName = procDef[0].strVal
  let params   = procDef[3]
  let retType  = params[0]
  let isVoid   = isVoidNode(retType)
  let retTypeStr = if isVoid: "" else: retType.typeName()
  let retTyId    = if isVoid: TY_UNIT else: nimTypeToTyId(retTypeStr)

  let args = parseFormalParams(params)

  result = newStmtList()

  # 1) Original proc — always present (works natively and in wasm)
  result.add(procDef)

  # 2-3) Wasm-specific code: export wrapper + descriptor (only compiled for wasm32)
  var wasmBody = newStmtList()

  # Declare __nbg_describe import (once per compilation unit)
  if not describeImportDeclared:
    let descFn = ident("__nbg_describe")
    wasmBody.add quote do:
      proc `descFn`(v: uint32) {.importc, nodecl.}
    describeImportDeclared = true

  # Export wrapper
  wasmBody.add(buildShimProc(procName, args, retTypeStr, isVoid))

  # Descriptor function
  wasmBody.add(buildDescribeProc(procName, args, retTyId, isVoid))

  # Build: when defined(wasm32): <wasmBody>
  let whenBranch = nnkElifBranch.newTree(
    newCall(ident("defined"), ident("wasm32")),
    wasmBody
  )
  let whenStmt = nnkWhenStmt.newTree(whenBranch)
  result.add(whenStmt)

# ─── Compile-time pragma for annotation ───

template wasmBindgenType*(body: untyped): untyped =
  ## Annotation for structs/enums to be exposed to JS.
  body

template wasmBindgenModule*(modulePath: static string, body: untyped): untyped =
  ## Annotation for JS import blocks.
  body
