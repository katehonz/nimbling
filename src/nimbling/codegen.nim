## Code generation helpers: type mapping, wrapper builders.
## Used by macroimpl.nim at compile time.

import common
import std/macros
import std/tables

# ─── Compile-time enum registry ───
var enumRegistry* {.compileTime.}: Table[string, NimEnum]

proc isEnumType*(tname: string): bool {.compileTime.} =
  enumRegistry.hasKey(tname)

proc getEnum*(tname: string): NimEnum {.compileTime.} =
  enumRegistry[tname]

# ─── Compile-time struct registry ───
var structRegistry* {.compileTime.}: Table[string, NimStruct]

proc isStructType*(tname: string): bool {.compileTime.} =
  structRegistry.hasKey(tname)

proc getStruct*(tname: string): NimStruct {.compileTime.} =
  structRegistry[tname]

# ─── Nim type name → TY_* constant ───

proc nimTypeToTyId*(tname: string): uint32 =
  ## Map a Nim type name string to the corresponding TY_* constant.
  case tname
  of "int8":    TY_I8
  of "uint8", "byte": TY_U8
  of "int16":   TY_I16
  of "uint16":  TY_U16
  of "int32", "cint": TY_I32
  of "uint32", "cuint": TY_U32
  of "int64":   TY_I64
  of "uint64":  TY_U64
  of "float32": TY_F32
  of "float64": TY_F64
  of "bool":    TY_BOOLEAN
  of "string":  TY_STRING
  of "JsValue": TY_EXTERNREF
  of "char":    TY_CHAR
  else:
    when nimvm:
      if isEnumType(tname): TY_ENUM
      elif isStructType(tname): TY_RUST_STRUCT
      else: TY_EXTERNREF
    else:
      TY_EXTERNREF

proc isStringType*(tname: string): bool =
  tname == "string"

proc isVoidNode*(node: NimNode): bool =
  node.kind == nnkEmpty

proc typeName*(node: NimNode): string =
  ## Extract the type name from a NimNode (ident, bracket expr, or empty).
  case node.kind
  of nnkIdent, nnkSym: result = node.strVal
  of nnkBracketExpr:   result = node[0].strVal
  of nnkEmpty:         result = ""
  else:                result = ""

# ─── Parse formal params into (name, typeName) pairs ───

proc parseFormalParams*(params: NimNode): seq[(string, string)] =
  ## Handles `a, b: int32` (multi-name defs) correctly.
  result = @[]
  for i in 1..<params.len:
    let p = params[i]
    if p.kind == nnkIdentDefs:
      let typeNode = p[^2]          # second-to-last child is the type
      let tname = typeNode.typeName()
      # All children except last two (type, default) are names
      for j in 0..<(p.len - 2):
        case p[j].kind
        of nnkIdent, nnkSym:
          result.add((p[j].strVal, tname))
        else:
          discard

# ─── JS type name for shim generation ───

proc jsTypeName*(tname: string): string =
  ## Map Nim type names to JS type descriptions for jsgen.
  case tname
  of "string":  "string"
  of "int32", "cint", "int16", "int8", "uint32", "cuint",
     "uint16", "uint8": "number"
  of "int64", "uint64": "bigint"
  of "float32", "float64": "number"
  of "bool": "boolean"
  else:
    when nimvm:
      if isEnumType(tname): "number"
      elif isStructType(tname): "jsvalue"
      else: "any"
    else:
      "any"

# ─── Wasm ABI type conversion helpers ───

proc nimTypeToWasmAbiType*(tname: string): string =
  ## Returns the wasm ABI type for a Nim type.
  ## "string" -> "uint32" (x2 for ptr+len), "int32" -> "int32", etc.
  case tname
  of "int8", "uint8", "byte": "int32"
  of "int16", "uint16": "int32"
  of "int32", "cint", "uint32", "cuint": "int32"
  of "int64", "uint64": "int64"
  of "float32": "float32"
  of "float64": "float64"
  of "bool": "int32"
  of "string": "uint32"
  of "JsValue": "uint32"
  else:
    when nimvm:
      if isEnumType(tname): "int32"
      elif isStructType(tname): "uint32"
      else: "uint32"
    else:
      "uint32"

proc hasWasmAbiConversion*(tname: string): bool =
  ## Returns true if this type needs ABI conversion (e.g. string, JsValue)
  when nimvm:
    tname == "string" or tname == "JsValue" or isEnumType(tname) or isStructType(tname)
  else:
    tname == "string" or tname == "JsValue"

proc abiArgCount*(tname: string): int =
  ## How many wasm arguments a Nim type produces.
  ## string -> 2 (ptr, len), others -> 1
  if tname == "string": 2 else: 1

proc abiArgNames*(baseName: string, tname: string): seq[string] =
  ## Generate wasm argument names for a parameter.
  if tname == "string":
    @[baseName & "_ptr", baseName & "_len"]
  else:
    @[baseName]

proc argConvertStmts*(varName: string, baseName: string, tname: string): string =
  ## Generate Nim code string to convert wasm ABI args to Nim types.
  ## Returns Nim source code as string.
  if tname == "string":
    "var " & varName & " = newString(int(" & baseName & "_len))\n" &
    "  if " & baseName & "_len > 0:\n" &
    "    copyMem(addr " & varName & "[0], cast[pointer](" & baseName & "_ptr), int(" & baseName & "_len))"
  elif tname == "JsValue":
    "var " & varName & " = JsValue(idx: " & baseName & ")"
  else:
    "var " & varName & " = " & baseName

proc retConvertStmts*(retVar: string, tname: string): string =
  ## Generate Nim code string to convert return value from Nim to wasm ABI.
  ## Returns Nim source code as string.
  if tname == "string":
    "let retDataLen = uint32(" & retVar & ".len)\n" &
    "var retDataPtr: uint32 = 0\n" &
    "if retDataLen > 0:\n" &
    "  retDataPtr = cast[uint32](nbgMalloc(retDataLen, 1))\n" &
    "  copyMem(cast[pointer](retDataPtr), unsafeAddr " & retVar & "[0], int(retDataLen))\n" &
    "let retBoxPtr = cast[uint32](nbgMalloc(8, 4))\n" &
    "cast[ptr uint32](cast[pointer](retBoxPtr))[] = retDataPtr\n" &
    "cast[ptr uint32](cast[pointer](cast[uint](retBoxPtr) + 4))[] = retDataLen\n" &
    "return retBoxPtr"
  elif tname == "JsValue":
    "return " & retVar & ".idx"
  else:
    "return " & retVar
