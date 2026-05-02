## JavaScript glue code generator.
## Takes a decoded Program and produces the JS wrapper module.
## Equivalent to js/mod.rs + js/binding.rs in wasm-bindgen CLI.

import common
import std/strformat
import std/strutils
import std/sequtils

type
  JsGenTarget* = enum
    jsBundler     # ES module with imports from wasm
    jsWeb         # for direct browser use
    jsNoModules   # classic script, no modules
    jsNode        # Node.js commonjs
    jsDeno        # Deno module

  JsGen* = object
    target*: JsGenTarget
    prog*: Program
    wasmName*: string
    output*: string
    indent*: int

proc newJsGen*(prog: Program, target: JsGenTarget, wasmName: string): JsGen =
  JsGen(prog: prog, target: target, wasmName: wasmName, indent: 0)

proc addLine(g: var JsGen, s: string) =
  let pad = "  ".repeat(g.indent)
  g.output.add(pad & s & "\n")

proc add(g: var JsGen, s: string) =
  g.output.add(s)

proc indent(g: var JsGen) = inc g.indent
proc dedent(g: var JsGen) = dec g.indent

# ─── JS helpers (standard across all targets) ───

const jsHelpers = """
let wasm;

const heap = new Array(128).fill(undefined);
heap.push(undefined, null, true, false);
let heap_next = 132;

function addHeapObject(obj) {
  if (heap_next === heap.length) heap.push(heap.length + 1);
  const idx = heap_next;
  heap_next = heap[idx];
  heap[idx] = obj;
  return idx;
}

function addBorrowedObject(obj) {
  heap.push(obj);
  return heap.length - 1;
}

function dropObject(idx) {
  heap[idx] = heap_next;
  heap_next = idx;
}

function takeObject(idx) {
  const ret = heap[idx];
  heap[idx] = heap_next;
  heap_next = idx;
  return ret;
}

function isLikeNone(x) {
  return x === undefined || x === null;
}

let cachedTextDecoder = new TextDecoder('utf-8', { ignoreBOM: true, fatal: true });
cachedTextDecoder.decode();

let cachedUint8Memory0 = null;

function getUint8Memory0() {
  if (cachedUint8Memory0 === null || cachedUint8Memory0.byteLength === 0) {
    cachedUint8Memory0 = new Uint8Array(wasm.memory.buffer);
  }
  return cachedUint8Memory0;
}

function getStringFromWasm(ptr, len) {
  ptr = ptr >>> 0;
  return cachedTextDecoder.decode(getUint8Memory0().subarray(ptr, ptr + len));
}

function passStringToWasm(arg) {
  if (typeof(arg) !== 'string') throw new Error('expected a string argument');
  const buf = new TextEncoder('utf-8').encode(arg);
  const len = buf.length;
  const ptr = wasm.__nbg_malloc(len, 1) >>> 0;
  getUint8Memory0().set(buf, ptr);
  return [ptr, len];
}

let WASM_VECTOR_LEN = 0;

function passArray8ToWasm(arg) {
  const ptr = wasm.__nbg_malloc(arg.length * 1, 1) >>> 0;
  getUint8Memory0().set(arg, ptr);
  WASM_VECTOR_LEN = arg.length;
  return ptr;
}
"""

proc generateHelpers(g: var JsGen) =
  g.add(jsHelpers)

# ─── Generate import shims ───

proc generateImportShim(g: var JsGen, imp: Import) =
  case imp.importKind.kind
  of ikFunction:
    let f = imp.importKind.funcData
    let shimName = f.shim
    let jsFnName = f.function.name
    let modulePath = if imp.module.isSome and imp.module.get.kind == imNamed:
                       imp.module.get.name
                     else:
                       ""

    g.addLine(&"// Import shim for '{jsFnName}' from '{modulePath}'")

    if modulePath.len > 0 and modulePath.startsWith("./") or modulePath.startsWith("../"):
      g.addLine(&"import {{ {jsFnName} }} from '{modulePath}';")

    g.addLine(&"export function {shimName}(arg0, arg1, wasmretptr) {{")
    g.indent()

    # Generate argument conversions based on types
    # For now, simple string conversion example:
    g.addLine(&"const arg = getStringFromWasm(arg0, arg1);")
    g.addLine(&"const result = {jsFnName}(arg);")
    g.addLine(&"if (typeof result === 'string') {{")
    g.indent()
    g.addLine("const [retptr, retlen] = passStringToWasm(result);")
    g.addLine("(new Uint32Array(wasm.memory.buffer))[wasmretptr / 4] = retlen;")
    g.addLine("return retptr;")
    g.dedent()
    g.addLine("}")

    g.dedent()
    g.addLine("}")
    g.add("")

  of ikStatic, ikString, ikType, ikEnum:
    g.addLine(&"// Import shim (non-function) — todo")
    g.add("")

# ─── Generate export shims ───

proc generateExportShim(g: var JsGen, exp: Export) =
  let funcName = exp.function.name
  let exportName = exp.function.name  # could have js_name override
  let args = exp.function.args

  g.addLine(&"export function {exportName}({args.mapIt(it.name).join(\", \")}) {{")
  g.indent()

  # Convert each JS argument to wasm ABI
  var wasmArgs: seq[string] = @[]
  for i, arg in args:
    g.addLine(&"const [ptr{i}, len{i}] = passStringToWasm({arg.name});")
    wasmArgs.add(&"ptr{i}, len{i}")

  # Call wasm
  g.addLine(&"const ret = wasm.{funcName}({wasmArgs.join(\", \")});")

  # Convert return value
  g.addLine("const ptr = wasm.__nbg_boxed_str_ptr(ret);")
  g.addLine("const len = wasm.__nbg_boxed_str_len(ret);")
  g.addLine("const realRet = getStringFromWasm(ptr, len);")
  g.addLine("wasm.__nbg_boxed_str_free(ret);")

  # Free arguments
  for i in 0..<args.len:
    g.addLine(&"wasm.__nbg_free(ptr{i}, len{i}, 1);")

  g.addLine("return realRet;")
  g.dedent()
  g.addLine("}")
  g.add("")

# ─── Main generation loop ───

proc generate*(g: var JsGen): string =
  ## Generate the complete JS glue module.

  g.output = ""

  # Module header
  case g.target
  of jsBundler, jsWeb, jsDeno:
    if g.target == jsDeno:
      g.addLine(&"import * as wasm from './{g.wasmName}';")
    else:
      g.addLine(&"import * as wasm from './{g.wasmName}_bg.js';")
      g.addLine(&"let imports = {{}};")

  of jsNoModules:
    g.addLine("(function() {")
    g.indent()
    g.addLine(&"const wasm = wasm_bindgen;")

  of jsNode:
    g.addLine(&"const wasm = require('./{g.wasmName}_bg.js');")
  g.add("")

  # Apply linked modules
  for lm in g.prog.linkedModules:
    g.addLine(&"// Linked module: {lm.module.name} via {lm.linkFunctionName}")

  # Generate helpers
  g.generateHelpers()
  g.add("")

  # Initialization function
  g.addLine("async function __nbg_load(module, imports) {")
  g.indent()
  g.addLine("if (typeof Response === 'function' && module instanceof Response) {")
  g.indent()
  g.addLine("if (typeof WebAssembly.instantiateStreaming === 'function') {")
  g.indent()
  if g.target == jsNode:
    g.addLine(&"throw new Error('Node.js streaming init not supported');")
  else:
    g.addLine("try {")
    g.indent()
    g.addLine("return await WebAssembly.instantiateStreaming(module, imports);")
    g.dedent()
    g.addLine("} catch (e) {")
    g.indent()
    g.addLine("if (module.headers.get('Content-Type') != 'application/wasm') {")
    g.indent()
    g.addLine("console.warn('Server did not respond with application/wasm. Falling back to ArrayBuffer.');")
    g.dedent()
    g.addLine("}")
    g.dedent()
    g.addLine("}")
  g.dedent()
  g.addLine("}")
  g.addLine("const bytes = await module.arrayBuffer();")
  g.addLine("return await WebAssembly.instantiate(bytes, imports);")
  g.dedent()
  g.addLine("}")
  g.add("")

  # init function
  g.addLine("async function init(input) {")
  g.indent()

  case g.target
  of jsWeb, jsNoModules:
    g.addLine(&"const imports = {{}};")
    g.addLine(&"const result = await __nbg_load(input, imports);")
  of jsBundler:
    g.addLine(&"const imports = {{}};")
    g.addLine(&"const result = await __nbg_load(input, imports);")
  of jsNode:
    g.addLine(&"const imports = {{}};")
    g.addLine("const path = require('path').join(__dirname, input);")
    g.addLine("const bytes = require('fs').readFileSync(path);")
    g.addLine("const result = await WebAssembly.instantiate(bytes, imports);")
  of jsDeno:
    g.addLine("const imports = {};")
    g.addLine("const result = await __nbg_load(input, imports);")

  g.addLine("wasm = result.instance.exports;")
  g.addLine("__nbg_init.__wbindgen_wasm_module = result.instance;")
  g.addLine("return wasm;")
  g.dedent()
  g.addLine("}")
  g.add("")

  # Default export
  g.addLine("export default init;")
  g.add("")

  # Generate import shims
  for imp in g.prog.imports:
    g.generateImportShim(imp)

  # Generate export shims
  for exp in g.prog.exports:
    g.generateExportShim(exp)

  # Module footer
  if g.target == jsNoModules:
    g.dedent()
    g.addLine("})();")

  result = g.output
