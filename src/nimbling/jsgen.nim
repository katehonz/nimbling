## JavaScript glue code generator.
## Takes a decoded Program and produces the JS wrapper module.
## Equivalent to js/mod.rs + js/binding.rs in wasm-bindgen CLI.

import common
import std/strformat
import std/strutils
import macroimpl_closure
import macroimpl_async

type
  JsGenTarget* = enum
    jsBundler     # ES module with imports from wasm
    jsWeb         # for direct browser use
    jsNoModules   # classic script, no modules
    jsNode        # Node.js commonjs
    jsDeno        # Deno module
    jsNodeModule  # Node.js ESM (experimental-nodejs-module)
    jsModule      # Source-phase import WASM module

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

// ─── Intrinsics: Memory & Module Access ───
function __nbg_memory() { return wasm.memory; }
function __nbg_module() { return null; }
function __nbg_exports() { return wasm; }
function __nbg_instance() { return null; }
function __nbg_function_table() { return wasm.__indirect_function_table; }
function __nbg_panic_error(msg, len) {
  throw new Error(getStringFromWasm(msg, len));
}

// ─── Intrinsics: Type Predicates ───
function __nbg_is_null(idx) { return heap[idx] === null; }
function __nbg_is_undefined(idx) { return heap[idx] === undefined; }
function __nbg_is_string(idx) { return typeof heap[idx] === 'string'; }
function __nbg_is_function(idx) { return typeof heap[idx] === 'function'; }
function __nbg_is_object(idx) { return heap[idx] !== null && typeof heap[idx] === 'object'; }
function __nbg_is_symbol(idx) { return typeof heap[idx] === 'symbol'; }
function __nbg_is_bigint(idx) { return typeof heap[idx] === 'bigint'; }
function __nbg_is_number(idx) { return typeof heap[idx] === 'number'; }
function __nbg_is_boolean(idx) { return typeof heap[idx] === 'boolean'; }
function __nbg_is_falsy(idx) { return !heap[idx]; }
function __nbg_is_truthy(idx) { return !!heap[idx]; }
function __nbg_is_array(idx) { return Array.isArray(heap[idx]); }

// ─── Intrinsics: String/Number/Boolean Value Extraction ───
function __nbg_string_get(idx) { return heap[idx]; }
function __nbg_number_get(idx) { return heap[idx]; }
function __nbg_boolean_get(idx) { return heap[idx]; }
function __nbg_debug_string(idx) {
  let v = heap[idx];
  if (typeof v === 'function') return `[object Function]`;
  try { return String(v); } catch(e) { return `[object]`; }
}

// ─── Intrinsics: Type Predicates v2 ───
function __nbg_typeof(idx) {
  let v = heap[idx];
  if (v === null) return 'null';
  if (v === undefined) return 'undefined';
  if (Array.isArray(v)) return 'array';
  return typeof v;
}
function __nbg_js_in(idx_a, idx_b) {
  return heap[idx_a] in heap[idx_b];
}

// ─── Intrinsics: Object Heap Management ───
function __nbg_object_clone_ref(idx) {
  let obj = heap[idx];
  if (obj && typeof obj === 'object' && !(obj instanceof Object)) {
    addHeapObject(obj);
  }
}
function __nbg_object_drop_ref(idx) {
  takeObject(idx);
}
function __nbg_externref_heap_live_count() {
  return heap.length - heap_next;
}

// ─── Intrinsics: Arithmetic Operators ───
function __nbg_add(a, b) { return a + b; }
function __nbg_sub(a, b) { return a - b; }
function __nbg_mul(a, b) { return a * b; }
function __nbg_div(a, b) { return a / b; }
function __nbg_rem(a, b) { return a % b; }
function __nbg_pow(a, b) { return Math.pow(a, b); }
function __nbg_neg(a) { return -a; }
function __nbg_checked_div(a, b) { if (b === 0) throw new Error('division by zero'); return a / b; }

// ─── Intrinsics: Bitwise Operators ───
function __nbg_bit_and(a, b) { return a & b; }
function __nbg_bit_or(a, b)  { return a | b; }
function __nbg_bit_xor(a, b) { return a ^ b; }
function __nbg_bit_not(a)    { return ~a; }
function __nbg_shl(a, b)     { return a << b; }
function __nbg_shr(a, b)     { return a >> b; }
function __nbg_unsigned_shr(a, b) { return a >>> b; }

// ─── Intrinsics: Comparison Operators ───
function __nbg_lt(a, b)  { return a < b ? 1 : 0; }
function __nbg_le(a, b)  { return a <= b ? 1 : 0; }
function __nbg_gt(a, b)  { return a > b ? 1 : 0; }
function __nbg_ge(a, b)  { return a >= b ? 1 : 0; }
function __nbg_eq(a, b)  { return a === b ? 1 : 0; }
function __nbg_loose_eq(a, b) { return a == b ? 1 : 0; }

// ─── Intrinsics: Object Operations ───
function __nbg_object_add(idx_a, idx_b) { return addHeapObject(heap[idx_a] + heap[idx_b]); }
function __nbg_object_sub(idx_a, idx_b) { return addHeapObject(heap[idx_a] - heap[idx_b]); }
function __nbg_delete_prop(idx, prop) { return delete heap[idx][prop] ? 1 : 0; }
function __nbg_instanceof(idx_a, idx_b) { return heap[idx_a] instanceof heap[idx_b] ? 1 : 0; }

// ─── Intrinsics: JS Property Access ───
function __nbg_js_get(idx, prop_idx) {
  let obj = heap[idx];
  let prop = heap[prop_idx];
  return addHeapObject(obj[prop]);
}
function __nbg_js_set(idx, prop_idx, val_idx) {
  heap[idx][heap[prop_idx]] = heap[val_idx];
}

// ─── Intrinsics: Throw ───
function __nbg_throw(idx, len) { throw getStringFromWasm(idx, len); }
function __nbg_rethrow(idx) { throw heap[idx]; }

// ─── Intrinsics: BigInt Helpers ───
function __nbg_bigint_from_i64(lo, hi) {
  return addHeapObject(BigInt(lo) | (BigInt(hi) << 32n));
}
function __nbg_bigint_get_as_i64(idx) {
  let n = BigInt(heap[idx]);
  return [Number(n & 0xFFFFFFFFn), Number((n >> 32n) & 0xFFFFFFFFn)];
}
"""

type
  IntrinsicKind* = enum
    ikMemory, ikModule, ikExports, ikInstance, ikFunctionTable, ikPanicError
    ikIsNull, ikIsUndefined, ikIsString, ikIsFunction, ikIsObject, ikIsSymbol, ikIsBigint
    ikIsNumber, ikIsBoolean, ikIsFalsy, ikIsTruthy, ikIsArray
    ikStringGet, ikNumberGet, ikBooleanGet, ikDebugString
    ikTypeof, ikJsIn
    ikObjectCloneRef, ikObjectDropRef, ikExternrefHeapLiveCount
    ikAdd, ikSub, ikMul, ikDiv, ikRem, ikPow, ikNeg, ikCheckedDiv
    ikBitAnd, ikBitOr, ikBitXor, ikBitNot, ikShl, ikShr, ikUnsignedShr
    ikLt, ikLe, ikGt, ikGe, ikEq, ikLooseEq
    ikObjectAdd, ikObjectSub, ikJsGet, ikJsSet
    ikThrow, ikRethrow
    ikBigintFromI64, ikBigintGetAsI64

proc intrinsicName*(k: IntrinsicKind): string =
  case k
  of ikMemory: "__nbg_memory"
  of ikModule: "__nbg_module"
  of ikExports: "__nbg_exports"
  of ikInstance: "__nbg_instance"
  of ikFunctionTable: "__nbg_function_table"
  of ikPanicError: "__nbg_panic_error"
  of ikIsNull: "__nbg_is_null"
  of ikIsUndefined: "__nbg_is_undefined"
  of ikIsString: "__nbg_is_string"
  of ikIsFunction: "__nbg_is_function"
  of ikIsObject: "__nbg_is_object"
  of ikIsSymbol: "__nbg_is_symbol"
  of ikIsBigint: "__nbg_is_bigint"
  of ikIsNumber: "__nbg_is_number"
  of ikIsBoolean: "__nbg_is_boolean"
  of ikIsFalsy: "__nbg_is_falsy"
  of ikIsTruthy: "__nbg_is_truthy"
  of ikIsArray: "__nbg_is_array"
  of ikStringGet: "__nbg_string_get"
  of ikNumberGet: "__nbg_number_get"
  of ikBooleanGet: "__nbg_boolean_get"
  of ikDebugString: "__nbg_debug_string"
  of ikTypeof: "__nbg_typeof"
  of ikJsIn: "__nbg_js_in"
  of ikObjectCloneRef: "__nbg_object_clone_ref"
  of ikObjectDropRef: "__nbg_object_drop_ref"
  of ikExternrefHeapLiveCount: "__nbg_externref_heap_live_count"
  of ikAdd: "__nbg_add"
  of ikSub: "__nbg_sub"
  of ikMul: "__nbg_mul"
  of ikDiv: "__nbg_div"
  of ikRem: "__nbg_rem"
  of ikPow: "__nbg_pow"
  of ikNeg: "__nbg_neg"
  of ikCheckedDiv: "__nbg_checked_div"
  of ikBitAnd: "__nbg_bit_and"
  of ikBitOr: "__nbg_bit_or"
  of ikBitXor: "__nbg_bit_xor"
  of ikBitNot: "__nbg_bit_not"
  of ikShl: "__nbg_shl"
  of ikShr: "__nbg_shr"
  of ikUnsignedShr: "__nbg_unsigned_shr"
  of ikLt: "__nbg_lt"
  of ikLe: "__nbg_le"
  of ikGt: "__nbg_gt"
  of ikGe: "__nbg_ge"
  of ikEq: "__nbg_eq"
  of ikLooseEq: "__nbg_loose_eq"
  of ikObjectAdd: "__nbg_object_add"
  of ikObjectSub: "__nbg_object_sub"
  of ikJsGet: "__nbg_js_get"
  of ikJsSet: "__nbg_js_set"
  of ikThrow: "__nbg_throw"
  of ikRethrow: "__nbg_rethrow"
  of ikBigintFromI64: "__nbg_bigint_from_i64"
  of ikBigintGetAsI64: "__nbg_bigint_get_as_i64"

proc generateHelpers(g: var JsGen) =
  g.add(jsHelpers)
  g.add(generateClosureGlueJs())
  g.add(generateAsyncGlueJs())

# ─── Type analysis helpers ───

proc isEnumName(name: string, prog: Program): bool =
  for ne in prog.enums:
    if ne.name == name:
      return true
  return false

proc classifyArgType(g: JsGen, arg: FunctionArgumentData): string =
  ## Returns "string", "number", "boolean", "jsvalue", or "enum"
  let t = arg.tyOverride
  if t == "string": return "string"
  if t in ["bool"]: return "boolean"
  if t in ["JsValue", "Closure"]: return "jsvalue"
  if isEnumName(t, g.prog): return "enum"
  return "number"  # int32, float64, etc.

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

    if modulePath.len > 0 and (modulePath.startsWith("./") or modulePath.startsWith("../")):
      g.addLine(&"import {{ {jsFnName} }} from '{modulePath}';")

    # Build arg list for the shim signature
    var shimArgs: seq[string] = @[]
    for i, arg in f.function.args:
      let argTy = classifyArgType(g, arg)
      if argTy == "string":
        shimArgs.add(&"arg{i}_ptr")
        shimArgs.add(&"arg{i}_len")
      else:
        shimArgs.add(&"arg{i}")

    g.addLine(&"export function {shimName}({shimArgs.join(\", \")}, wasmretptr) {{")
    g.indent()

    # Convert wasm args → JS args
    var jsCallArgs: seq[string] = @[]
    for i, arg in f.function.args:
      let argTy = classifyArgType(g, arg)
      if argTy == "string":
        g.addLine(&"const arg{i} = getStringFromWasm(arg{i}_ptr, arg{i}_len);")
      jsCallArgs.add(&"arg{i}")

    g.addLine(&"const result = {jsFnName}({jsCallArgs.join(\", \")});")

    # Handle return value
    if f.function.args.len > 0:
      g.addLine(&"if (typeof result === 'string') {{")
      g.indent()
      g.addLine("const [retptr, retlen] = passStringToWasm(result);")
      g.addLine("(new Uint32Array(wasm.memory.buffer))[wasmretptr / 4] = retlen;")
      g.addLine("return retptr;")
      g.dedent()
      g.addLine("}")
      g.addLine("return result;")

    g.dedent()
    g.addLine("}")
    g.add("")

  of ikStatic:
    let s = imp.importKind.staticData
    g.addLine(&"// Import shim (static): {s.name}")
    g.addLine(&"export function {s.shim}() {{ return {s.name}; }}")
    g.add("")

  of ikString:
    let s = imp.importKind.stringData
    g.addLine(&"// Import shim (string constant): {s.string}")
    g.addLine(&"export function {s.shim}() {{ return '{s.string}'; }}")
    g.add("")

  of ikType:
    let t = imp.importKind.typeData
    g.addLine(&"// Import shim (type): {t.name}")
    g.addLine(&"export function {t.instanceofShim}(arg) {{ return arg instanceof {t.name}; }}")
    g.add("")

  of ikEnum:
    let e = imp.importKind.enumData
    g.addLine(&"// Import shim (enum): {e.name}")
    g.add("")

# ─── Generate export shims ───

proc generateExportShim(g: var JsGen, exp: Export) =
  if exp.class.isSome:
    return  # Handled by struct class generation

  let funcName = exp.function.name
  let exportName = exp.function.name
  let args = exp.function.args
  let shimFuncName = "__nbg_shim_" & funcName

  # Check if any arg is a string or return is string
  var hasStringArgs = false
  for arg in args:
    if classifyArgType(g, arg) == "string":
      hasStringArgs = true
      break

  let hasStringReturn = exp.function.retTyOverride == "string"

  # JS function signature
  var jsArgs: seq[string] = @[]
  for i, arg in args:
    jsArgs.add(&"arg{i}")

  g.addLine(&"export function {exportName}({jsArgs.join(\", \")}) {{")
  g.indent()

  # Convert JS args → wasm args
  var wasmArgs: seq[string] = @[]
  for i, arg in args:
    let argTy = classifyArgType(g, arg)
    if argTy == "string":
      g.addLine(&"const [ptr{i}, len{i}] = passStringToWasm(arg{i});")
      wasmArgs.add(&"ptr{i}, len{i}")
    elif argTy == "jsvalue":
      g.addLine(&"const idx{i} = addHeapObject(arg{i});")
      wasmArgs.add(&"idx{i}")
    else:
      wasmArgs.add(&"arg{i}")

  # Call the wasm shim function
  g.addLine(&"const ret = wasm.{shimFuncName}({wasmArgs.join(\", \")});")

  # Convert return value
  if hasStringReturn:
    g.addLine("const rptr = wasm.__nbg_boxed_str_ptr(ret);")
    g.addLine("const rlen = wasm.__nbg_boxed_str_len(ret);")
    g.addLine("const realRet = getStringFromWasm(rptr, rlen);")
    g.addLine("wasm.__nbg_boxed_str_free(ret);")
    # Free string args
    for i, arg in args:
      if classifyArgType(g, arg) == "string":
        g.addLine(&"wasm.__nbg_free(ptr{i}, len{i}, 1);")
    g.addLine("return realRet;")
  else:
    # Free string args
    for i, arg in args:
      if classifyArgType(g, arg) == "string":
        g.addLine(&"wasm.__nbg_free(ptr{i}, len{i}, 1);")
    g.addLine("return ret;")

  g.dedent()
  g.addLine("}")
  g.add("")

# ─── Generate struct classes ───

proc generateStructClass(g: var JsGen, ns: NimStruct) =
  g.addLine(&"export class {ns.name} {{")
  g.indent()

  # Constructor
  var jsCtorArgs: seq[string] = @[]
  for field in ns.fields:
    jsCtorArgs.add(field.name)
  g.addLine(&"constructor({jsCtorArgs.join(\", \")}) {{")
  g.indent()

  var wasmCtorArgs: seq[string] = @[]
  var stringIdx = 0
  for field in ns.fields:
    if field.tyOverride == "string":
      g.addLine(&"const [ptr{stringIdx}, len{stringIdx}] = passStringToWasm({field.name});")
      wasmCtorArgs.add(&"ptr{stringIdx}")
      wasmCtorArgs.add(&"len{stringIdx}")
      stringIdx += 1
    else:
      wasmCtorArgs.add(field.name)
  g.addLine(&"this.__wbg_ptr = wasm.{newFunction(ns.name)}({wasmCtorArgs.join(\", \")});")
  g.dedent()
  g.addLine("}")

  # free()
  g.addLine("free() {")
  g.indent()
  g.addLine(&"wasm.{freeFunction(ns.name)}(this.__wbg_ptr);")
  g.dedent()
  g.addLine("}")

  # Getters and setters
  for field in ns.fields:
    let getterName = structFieldGet(ns.name, field.name)

    g.addLine(&"get {field.name}() {{")
    g.indent()
    g.addLine(&"const ret = wasm.{getterName}(this.__wbg_ptr);")
    if field.tyOverride == "string":
      g.addLine("const rptr = wasm.__nbg_boxed_str_ptr(ret);")
      g.addLine("const rlen = wasm.__nbg_boxed_str_len(ret);")
      g.addLine("const realRet = getStringFromWasm(rptr, rlen);")
      g.addLine("wasm.__nbg_boxed_str_free(ret);")
      g.addLine("return realRet;")
    else:
      g.addLine("return ret;")
    g.dedent()
    g.addLine("}")

    if not field.readonly:
      let setterName = structFieldSet(ns.name, field.name)
      g.addLine(&"set {field.name}(v) {{")
      g.indent()
      if field.tyOverride == "string":
        g.addLine("const [ptr0, len0] = passStringToWasm(v);")
        g.addLine(&"wasm.{setterName}(this.__wbg_ptr, ptr0, len0);")
      else:
        g.addLine(&"wasm.{setterName}(this.__wbg_ptr, v);")
      g.dedent()
      g.addLine("}")

  g.dedent()
  g.addLine("}")
  g.add("")

# ─── Main generation loop ───

proc generate*(g: var JsGen): string =
  ## Generate the complete JS glue module.

  g.output = ""

  # Module header
  case g.target
  of jsBundler:
    g.addLine(&"import * as wasm from './{g.wasmName}_bg.js';")
    g.addLine(&"let imports = {{}};")
  of jsWeb:
    g.addLine(&"// Web target — wasm loaded via init()")
    g.addLine("let wasm;")
  of jsDeno:
    g.addLine(&"import * as wasm from './{g.wasmName}';")
    g.addLine(&"let imports = {{}};")

  of jsNode:
    g.addLine(&"// Node.js target — wasm loaded via init()")
    g.addLine("let wasm;")
  of jsNoModules:
    g.addLine("(function() {")
    g.indent()
    g.addLine(&"const wasm = wasm_bindgen;")


  of jsNodeModule:
    g.addLine(&"import * as wasm from './{g.wasmName}_bg.js';")
    g.addLine(&"let imports = {{}};")
  of jsModule:
    g.addLine(&"import source wasmModule from './{g.wasmName}.wasm';")
    g.addLine(&"let imports = {{}};")
    g.addLine("let wasm;")
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
  g.dedent()
  g.addLine("}")
  g.add("")

  # init function
  g.addLine("async function init(input) {")
  g.indent()

  case g.target
  of jsWeb:
    g.addLine(&"const imports = {{}};")
    g.addLine("const response = await fetch(input);")
    g.addLine(&"const result = await __nbg_load(response, imports);")
  of jsNoModules:
    g.addLine(&"const imports = {{}};")
    g.addLine(&"const result = await __nbg_load(input, imports);")
  of jsBundler:
    g.addLine(&"const imports = {{}};")
    g.addLine(&"const result = await __nbg_load(input, imports);")
  of jsNode:
    g.addLine(&"const imports = {{}};")
    g.addLine("const { join } = await import('node:path');")
    g.addLine("const { readFileSync } = await import('node:fs');")
    g.addLine("const path = join(import.meta.dirname, input);")
    g.addLine("const bytes = readFileSync(path);")
    g.addLine("const result = await WebAssembly.instantiate(bytes, imports);")
  of jsDeno:
    g.addLine("const imports = {};")
    g.addLine("const result = await __nbg_load(input, imports);")
  of jsNodeModule:
    g.addLine(&"const imports = {{}};")
    g.addLine("const wasmUrl = new URL('./{g.wasmName}_bg.wasm', import.meta.url);")
    g.addLine("const wasmBytes = (await import('node:fs')).readFileSync(wasmUrl);")
    g.addLine("const wasmModule = new WebAssembly.Module(wasmBytes);")
    g.addLine("const result = new WebAssembly.Instance(wasmModule, imports);")
  of jsModule:
    g.addLine(&"const imports = {{}};")
    g.addLine("const result = new WebAssembly.Instance(wasmModule, imports);")

  g.addLine("wasm = result.instance.exports;")
  g.addLine("__nbg_init.__wbindgen_wasm_module = result.instance;")
  g.addLine("return wasm;")
  g.dedent()
  g.addLine("}")
  g.addLine("const __nbg_init = { init };")
  g.add("")

  # Default export
  if g.target != jsModule:
    g.addLine("export default init;")
  else:
    g.addLine("export const __nbg_wasm_module = wasmModule;")
  g.add("")

  # Generate enum exports
  for ne in g.prog.enums:
    var entries: seq[string] = @[]
    for v in ne.variants:
      entries.add(&"{v.name}: {v.value}")
      entries.add(&"\"{v.value}\": \"{v.name}\"")
    g.addLine(&"export const {ne.name} = Object.freeze({{ {entries.join(\", \")} }});")
    g.add("")

  # Generate struct classes
  for ns in g.prog.structs:
    generateStructClass(g, ns)

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
