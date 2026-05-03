## Async/Promise support for nimbling.
## Provides detection of async procs, generation of Promise-based export
## wrappers, async descriptor emission, and JS glue code for Promise bridging.

import std/macros
import common
import codegen

# ─── Async detection ───

proc isAsyncProc*(procDef: NimNode): bool =
  ## Returns true if the procDef has an {.async.} pragma or
  ## its return type is a Future[T].
  let namePragma = procDef[0]
  if namePragma.kind == nnkPragmaExpr:
    for child in namePragma:
      if child.kind == nnkPragma:
        for p in child:
          if p.kind == nnkIdent and p.strVal == "async":
            return true
  let retType = procDef[3][0]
  if retType.kind == nnkBracketExpr:
    let baseType = retType[0]
    if baseType.kind in {nnkIdent, nnkSym} and baseType.strVal == "Future":
      return true
  return false

# ─── Async export wrapper generation ───

proc buildAsyncExportWrapper*(procName: string, args: seq[(string, string)],
                               retTypeStr: string): NimNode =
  ## Generates an export wrapper for an async proc.
  ##
  ## For `proc greet(name: string): Future[string] {.async.}`:
  ##   proc __nbg_shim_greet(name_ptr, name_len: uint32): uint32 {.exportc, cdecl.} =
  ##     var name = newString(name_len.int)
  ##     if name_len > 0: copyMem(addr name[0], cast[pointer](name_ptr), name_len.int)
  ##     let future = greet(name)
  ##     let promiseIdx = __nbg_future_to_promise(cast[uint32](cast[pointer](future)))
  ##     return promiseIdx
  ##
  ## `retTypeStr` is the inner type of the Future (T from Future[T]), or "" if void.

  let shimName = ident("__nbg_shim_" & procName)
  let origName = ident(procName)
  let createPromise = ident("__nbg_future_to_promise")

  # ── formal params ──
  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(ident("uint32"))

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

  # 2) build the call to the original async proc
  var call = newCall(origName)
  for (pname, _) in args:
    call.add(ident(pname))

  let futureVar = genSym(nskLet, "future")
  body.add(newLetStmt(futureVar, call))

  # 3) convert Future[T] to JS Promise via the intrinsic
  body.add quote do:
    let promiseIdx = `createPromise`(cast[uint32](cast[pointer](`futureVar`)))
    return promiseIdx

  # ── assemble proc def ──
  let pragmas = nnkPragmaExpr.newTree(
    shimName,
    nnkPragma.newTree(ident("exportc"), ident("cdecl"))
  )

  let shimProc = nnkProcDef.newTree(
    pragmas, newEmptyNode(), newEmptyNode(),
    formalParams, newEmptyNode(), newEmptyNode(),
    body
  )

  # Return a stmtList that declares the JS import and the shim proc
  result = newStmtList()
  result.add quote do:
    proc `createPromise`(futurePtr: uint32): uint32 {.importc, nodecl.}
  result.add(shimProc)

# ─── Async descriptor emission ───

proc emitAsyncDescriptor*(body: var NimNode, procName: string,
                           args: seq[(string, string)], retTyId: uint32) =
  ## Emits a `__nbg_describe_NAME` descriptor function for an async proc.
  ## The descriptor stream format is identical to regular procs; the
  ## `isAsync = true` flag is set in the Export metadata by the caller.

  let descFnName = ident(DescribeFnPrefix & procName)
  let descCall   = ident("__nbg_describe")

  var descBody = newStmtList()

  for (_, ptype) in args:
    if isEnumType(ptype):
      let ne = getEnum(ptype)
      descBody.add(newCall(descCall, newLit(TY_ENUM)))
      descBody.add(newCall(descCall, newLit(ne.name.len.uint32)))
      for c in ne.name:
        descBody.add(newCall(descCall, newLit(uint32(c))))
      descBody.add(newCall(descCall, newLit(ne.hole)))
    elif isStructType(ptype):
      let ns = getStruct(ptype)
      descBody.add(newCall(descCall, newLit(TY_RUST_STRUCT)))
      descBody.add(newCall(descCall, newLit(ns.name.len.uint32)))
      for c in ns.name:
        descBody.add(newCall(descCall, newLit(uint32(c))))
    else:
      let tyLit = newLit(nimTypeToTyId(ptype))
      descBody.add(newCall(descCall, tyLit))

  if retTyId == TY_UNIT:
    descBody.add(newCall(descCall, newLit(TY_UNIT)))
  elif retTyId == TY_ENUM:
    descBody.add(newCall(descCall, newLit(TY_ENUM)))
  elif retTyId == TY_RUST_STRUCT:
    descBody.add(newCall(descCall, newLit(TY_RUST_STRUCT)))
  else:
    descBody.add(newCall(descCall, newLit(retTyId)))

  let pragmas = nnkPragmaExpr.newTree(
    descFnName,
    nnkPragma.newTree(ident("exportc"), ident("cdecl"))
  )

  let descProcDef = nnkProcDef.newTree(
    pragmas, newEmptyNode(), newEmptyNode(),
    nnkFormalParams.newTree(newEmptyNode()),
    newEmptyNode(), newEmptyNode(),
    descBody
  )

  body.add(descProcDef)

# ─── Async JS glue generation ───

proc generateAsyncGlueJs*(): string =
  ## Returns JavaScript code for the `__nbg_future_to_promise` intrinsic
  ## that bridges Nim async Futures to JS Promises.
  result = """
// ─── Async/Promise Bridging ───

const __nbg_async_tasks = new Map();
let __nbg_async_ticker = null;

function __nbg_future_to_promise(future_idx) {
    const task_id = future_idx >>> 0;
    if (!wasm.__nbg_wasm_future_done(task_id)) {
        return new Promise((resolve, reject) => {
            __nbg_async_tasks.set(task_id, { resolve, reject, future_idx: task_id });
            __nbg_async_start_polling();
        });
    } else {
        const result = wasm.__nbg_wasm_future_take(task_id);
        return Promise.resolve(result);
    }
}

function __nbg_async_poll_tasks() {
    let any_pending = false;
    for (const [task_id, task] of __nbg_async_tasks) {
        if (wasm.__nbg_wasm_future_done(task.future_idx)) {
            const result = wasm.__nbg_wasm_future_take(task.future_idx);
            task.resolve(result);
            __nbg_async_tasks.delete(task_id);
        } else {
            any_pending = true;
        }
    }
    if (!any_pending) {
        clearInterval(__nbg_async_ticker);
        __nbg_async_ticker = null;
    }
}

function __nbg_async_start_polling() {
    if (__nbg_async_ticker === null) {
        __nbg_async_ticker = setInterval(__nbg_async_poll_tasks, 10);
    }
}

function __nbg_async_clear() {
    if (__nbg_async_ticker !== null) {
        clearInterval(__nbg_async_ticker);
        __nbg_async_ticker = null;
    }
    for (const [task_id, task] of __nbg_async_tasks) {
        task.reject(new Error('Async task cancelled'));
    }
    __nbg_async_tasks.clear();
}
"""
