## Code generation: produces Nim wrapper functions and descriptor functions.
## Equivalent to codegen.rs in wasm-bindgen-macro-support.

import common
import std/macros

type
  CodegenCtx* = object
    exports*: seq[Export]
    imports*: seq[Import]
    uniqueId*: string
    counter*: int

proc newCodegenCtx*(uniqueId: string): CodegenCtx =
  CodegenCtx(uniqueId: uniqueId)

proc nextId(ctx: var CodegenCtx): int =
  result = ctx.counter
  inc ctx.counter

# ─── Generate export wrapper for a Nim proc ───
# Takes a Nim proc like `proc greet(a: string): string`
# Generates an extern "C" wrapper that takes ptr/len args and returns ptr/len.

proc shimName*(ctx: var CodegenCtx, funcName: string): string =
  result = "__nbg_shim_" & funcName & "_" & $ctx.nextId()

proc generateExportWrapper*(ctx: var CodegenCtx, procDef: NimNode): NimNode =
  ## Given a Nim proc definition node, generate:
  ## 1. An `{.exportc.}` wrapper that converts wasm ABI ↔ Nim types
  ## 2. A `__nbg_describe_*` function
  ## Returns the modified AST with both additions.
  result = procDef

  # In a real implementation, this would:
  # - Parse the proc signature (params, return type)
  # - Generate string/ptr conversion shims
  # - Emit descriptor function
  # For now, we provide the scaffolding.

  let name = procDef[0].strVal
  # Generates: proc `__nbg_describe_name`() {.exportc.} = ...
  # This is a placeholder; the real macro will generate actual descriptor calls.

proc generateImportWrapper*(ctx: var CodegenCtx, externBlock: NimNode): NimNode =
  ## Given an extern block with imports, generate JS import shims.
  result = externBlock

# ─── Descriptor function generation ───

proc generateDescribeFn*(name: string, describeArgs: seq[(string, string)]): string =
  ## Generate the Nim source for a __nbg_describe_* function.
  ## describeArgs is a list of (type, description) pairs.
  result = "proc $1() {.exportc, cdecl.} =\n" % ["__nbg_describe_" & name]
  for (ty, desc) in describeArgs:
    result.add("  __nbg_describe($1)  # $2\n" % [desc, ty])

# ─── JS Shim body generator templating ───

proc passStringToWasm*(): string =
  ## JS helper: convert JS string to wasm ptr/len
  """
function passStringToWasm(arg) {
  const buf = new TextEncoder('utf-8').encode(arg);
  const len = buf.length;
  const ptr = wasm.__nbg_malloc(len, 1);
  let array = new Uint8Array(wasm.memory.buffer);
  array.set(buf, ptr);
  return [ptr, len];
}
"""

proc getStringFromWasm*(): string =
  ## JS helper: read string from wasm memory
  """
function getStringFromWasm(ptr, len) {
  const mem = new Uint8Array(wasm.memory.buffer);
  const slice = mem.slice(ptr, ptr + len);
  return new TextDecoder('utf-8').decode(slice);
}
"""
