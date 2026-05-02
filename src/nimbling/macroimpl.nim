## Macro implementation: the `{.wasmBindgen.}` pragma.
## This is the compile-time engine that:
## 1. Parses Nim AST for annotated procs/types
## 2. Generates export/import wrappers
## 3. Encodes program metadata
## 4. Embeds encoded data as a custom wasm section

import std/macros
import common
import encode

type
  ParserCtx = object
    program*: Program
    uniqueId*: string

proc newParserCtx*(uniqueId: string): ParserCtx =
  ParserCtx(
    program: Program(uniqueCrateIdentifier: uniqueId),
    uniqueId: uniqueId,
  )

# ─── Parse exported proc ───

proc parseExportProc(ctx: var ParserCtx, procDef: NimNode) =
  ## Build an Export entry from a Nim proc definition.
  let name = procDef[0].strVal
  var fargs: seq[FunctionArgumentData] = @[]
  var isAsync = false

  # Extract params
  let params = procDef[3]
  for i in 1..<params.len:
    let paramDef = params[i]
    var pname = "arg" & $i
    if paramDef.kind == nnkIdentDefs:
      pname = paramDef[0].strVal
    fargs.add(FunctionArgumentData(name: pname))

  let funcDesc = FunctionDesc(
    name: name,
    args: fargs,
    isAsync: isAsync,
    generateTypescript: true,
    generateJsdoc: true,
  )

  ctx.program.exports.add(Export(
    function: funcDesc,
    methodKind: MethodKind.mkOperation,
  ))

# ─── Parse imported function ───

proc parseImportProc(ctx: var ParserCtx, externBlock: NimNode, module: string) =
  ## Build an Import entry from an extern block.
  for child in externBlock.children:
    if child.kind == nnkProcDef:
      let name = child[0].strVal
      var fargs: seq[FunctionArgumentData] = @[]

      let params = child[3]
      for i in 1..<params.len:
        let paramDef = params[i]
        var pname = "arg" & $i
        if paramDef.kind == nnkIdentDefs:
          pname = paramDef[0].strVal
        fargs.add(FunctionArgumentData(name: pname))

      let shim = "__nbg_f_" & name
      let funcDesc = FunctionDesc(name: name, args: fargs)
      let importFunc = ImportFunction(shim: shim, function: funcDesc)
      let ofModule =
        if module.startsWith("./") or module.startsWith("../"):
          ImportModule(kind: imNamed, name: module)
        else:
          ImportModule(kind: imRawNamed, rawName: module)

      ctx.program.imports.add(Import(
        module: some(ofModule),
        importKind: ImportKindObj(kind: ikFunction, funcData: importFunc),
      ))

# ─── Main macro: wasmBindgen ───

macro wasmBindgen*(body: untyped): untyped =
  ## Main pragma macro. Use as:
  ##   {.wasmBindgen.}
  ##   proc myFunc(a: string): string = ...
  ##   {.wasmBindgen: "module".}
  ##   proc externalFunc(): cint {.importc.}
  ##
  ## This macro processes the annotated item and:
  ## - Generates export wrappers with {.exportc.}
  ## - Generates descriptor functions
  ## - Embeds program metadata

  result = body

  # In a full implementation, this macro would:
  # 1. Walk the AST for {.wasmBindgen.} annotated items
  # 2. Parse each proc/type into the Program AST
  # 3. Generate wrapper Nim code (exportc shims)
  # 4. Generate __nbg_describe_* functions
  # 5. Embed the serialized Program as a custom section
  #
  # For the initial implementation, we provide the architecture
  # and scaffolding. The actual macro expansion requires deep
  # AST manipulation that depends on the Nim compiler internals.

  # Example placeholder — generates a descriptor function
  # and exportc wrapper

  when false:  # placeholder for actual macro expansion
    let ctx = newParserCtx("my_crate")
    ctx.parseExportProc(body)
    let encoded = newEncoder()
    encoded.encode(ctx.program)

    # Embed custom section
    result = quote do:
      `body`

      proc `__nbg_describe`(x: uint32) {.importc, nodecl.}

      # Generated descriptor functions would go here

# ─── Compile-time pragma for annotation ───

template wasmBindgenType*(body: untyped): untyped =
  ## Annotation for structs/enums to be exposed to JS.
  body

template wasmBindgenModule*(modulePath: static string, body: untyped): untyped =
  ## Annotation for JS import blocks.
  body
