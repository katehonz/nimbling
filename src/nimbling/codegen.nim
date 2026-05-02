## Code generation helpers: type mapping, wrapper builders.
## Used by macroimpl.nim at compile time.

import common
import std/macros
import std/strutils

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
  else:         TY_EXTERNREF

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
  else: "any"
