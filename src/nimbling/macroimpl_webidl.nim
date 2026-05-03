## Compile-time WebIDL → Nim binding generation macro.
## Parses WebIDL definitions and generates Nim types + proc bindings
## following the same pattern as web_sys.nim / js_sys.nim.
##
## Usage:
##
##   webidlBind:
##     interface Node {
##       readonly attribute unsigned short nodeType;
##       attribute DOMString nodeName;
##       Node appendChild(Node newChild);
##       static Document createDocument();
##     };
##     interface Document {
##       Element getElementById(DOMString id);
##     };
##
## Generates distinct JsValue types + {.emit.} proc wrappers.

import std/macros
import std/strutils

import webidl

# ─── Type mapping: WebIDL → Nim ───

proc widlTypeToNim(widlType: string): string =
  # Strip optional marker (prefix or suffix `?`)
  var t = widlType
  if t.endsWith("?"):
    t = t[0..^2]
  if t.startsWith("?"):
    t = t[1..^1]
  case t
  of "boolean": return "bool"
  of "byte", "octet": return "uint8"
  of "short": return "int16"
  of "unsigned short": return "uint16"
  of "long", "int": return "int32"
  of "unsigned long", "unsigned int": return "uint32"
  of "long long": return "int64"
  of "unsigned long long": return "uint64"
  of "float", "unrestricted float": return "float32"
  of "double", "unrestricted double": return "float64"
  of "DOMString", "USVString", "ByteString", "UTF8String": return "string"
  of "void": return ""
  of "Promise": return "JsValue"
  else:
    return t  # assume it's a user-defined DOM type

proc widlTypeToJsExpr(argName: string, widlType: string): string =
  var t = widlType
  if t.endsWith("?"): t = t[0..^2]
  if t.startsWith("?"): t = t[1..^1]
  case t
  of "boolean", "byte", "octet", "short", "unsigned short",
     "long", "int", "unsigned long", "unsigned int",
     "long long", "unsigned long long":
    "`" & argName & "`"
  of "float", "unrestricted float", "double", "unrestricted double":
    "`" & argName & "`"
  of "DOMString", "USVString", "ByteString", "UTF8String":
    "`" & argName & "`"
  else:
    "heap[`" & argName & "`.idx]"

proc widlReturnToResultExpr(retType: string): string =
  if retType.len == 0:
    ""
  elif retType in ["bool", "int8", "uint8", "int16", "uint16",
      "int32", "uint32", "int64", "uint64", "float32", "float64", "string"]:
    "`result` = ret;"
  else:
    "`result` = {idx: addHeapObject(ret)};"

proc widlReturnNil(retType: string): string =
  if retType.len == 0:
    ""
  elif retType == "string":
    "\"\""
  elif retType == "bool":
    "false"
  elif retType in ["int8", "uint8", "int16", "uint16", "int32",
              "uint32", "int64", "uint64", "float32", "float64"]:
    "0"
  else:
    retType & "(JsValue(idx: 0))"

proc widlSanitize(name: string): string =
  result = name
  if result.len > 0 and result[0] in 'A'..'Z':
    result[0] = result[0].toLowerAscii()
  const reserved = ["addr", "and", "as", "asm", "bind", "block", "break",
                    "case", "cast", "concept", "const", "continue", "converter",
                    "defer", "discard", "distinct", "div", "do", "elif", "else",
                    "end", "enum", "except", "export", "finally", "for", "from",
                    "func", "if", "import", "in", "include", "interface", "is",
                    "isnot", "iterator", "let", "macro", "method", "mixin", "mod",
                    "nil", "not", "notin", "object", "of", "or", "out", "proc",
                    "ptr", "raise", "ref", "return", "shl", "shr", "static",
                    "template", "try", "tuple", "type", "using", "var", "when",
                    "while", "with", "without", "xor", "yield"]
  if result.toLowerAscii() in reserved:
    result = result & "Val"

# ─── NimNode AST builders ───

proc buildDistinctTypeDef(typeName: string): NimNode =
  result = newNimNode(nnkTypeSection)
  result.add nnkTypeDef.newTree(
    newIdentNode(typeName),
    newEmptyNode(),
    nnkDistinctTy.newTree(newIdentNode("JsValue"))
  )

proc buildAttrGetter(interfaceName: string, field: WebIDLMember): NimNode =
  let procName = newIdentNode(widlSanitize(field.name))
  let retType = widlTypeToNim(field.returnType)
  let retTypeNode = if retType.len == 0: newEmptyNode() else: newIdentNode(retType)
  let selfType = newIdentNode(interfaceName)
  let retJs = widlReturnToResultExpr(retType)
  let retNil = widlReturnNil(retType)

  let emitBody = if retJs.len > 0:
    "var ret = heap[`self`.idx]." & field.name & ";\n" & retJs
  else:
    "heap[`self`.idx]." & field.name & ";"

  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(retTypeNode)
  formalParams.add(newIdentDefs(newIdentNode("self"), selfType))

  var body = newStmtList()
  body.add nnkWhenStmt.newTree(
    nnkElifBranch.newTree(
      nnkCall.newTree(newIdentNode("defined"), newIdentNode("wasm32")),
      nnkStmtList.newTree(
        newNimNode(nnkPragma).add(
          nnkExprColonExpr.newTree(newIdentNode("emit"), newLit(emitBody))
        )
      )
    ),
    nnkElse.newTree(
      nnkStmtList.newTree(
        if retNil.len == 0:
          newNimNode(nnkDiscardStmt).add(newEmptyNode())
        else:
          parseStmt("result = " & retNil)
      )
    )
  )

  result = nnkProcDef.newTree(
    procName,
    newEmptyNode(),
    newEmptyNode(),
    formalParams,
    newEmptyNode(),
    newEmptyNode(),
    body
  )

proc buildAttrSetter(interfaceName: string, field: WebIDLMember): NimNode =
  let procName = newIdentNode(widlSanitize(field.name) & "=")
  let selfType = newIdentNode(interfaceName)
  let valType = widlTypeToNim(field.returnType)
  let valTypeNode = if valType.len == 0: newEmptyNode() else: newIdentNode(valType)

  let jsVal = widlTypeToJsExpr("value", valType)
  let emitBody = "heap[`self`.idx]." & field.name & " = " & jsVal & ";"

  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(newEmptyNode())
  formalParams.add(newIdentDefs(newIdentNode("self"), selfType))
  formalParams.add(newIdentDefs(newIdentNode("value"), valTypeNode))

  var body = newStmtList()
  body.add nnkWhenStmt.newTree(
    nnkElifBranch.newTree(
      nnkCall.newTree(newIdentNode("defined"), newIdentNode("wasm32")),
      nnkStmtList.newTree(
        newNimNode(nnkPragma).add(
          nnkExprColonExpr.newTree(newIdentNode("emit"), newLit(emitBody))
        )
      )
    ),
    nnkElse.newTree(
      nnkStmtList.newTree(
        nnkDiscardStmt.newTree(newEmptyNode())
      )
    )
  )

  result = nnkProcDef.newTree(
    procName,
    newEmptyNode(),
    newEmptyNode(),
    formalParams,
    newEmptyNode(),
    newEmptyNode(),
    body
  )

proc buildMethod(interfaceName: string, field: WebIDLMember, parentName: string = ""): NimNode =
  let procName = newIdentNode(widlSanitize(field.name))
  let retType = widlTypeToNim(field.returnType)
  let retTypeNode = if retType.len == 0: newEmptyNode() else: newIdentNode(retType)
  let retJs = widlReturnToResultExpr(retType)
  let retNil = widlReturnNil(retType)

  var callExpr: string
  let selfType = if parentName.len > 0: newIdentNode(parentName) else: newIdentNode(interfaceName)

  if field.isStatic:
    callExpr = interfaceName
  else:
    callExpr = "heap[`self`.idx]"

  callExpr.add("." & field.name & "(")

  for i, (argName, argType) in field.args:
    if i > 0: callExpr.add(", ")
    let nimArgTy = widlTypeToNim(argType)
    callExpr.add(widlTypeToJsExpr(argName, nimArgTy))
  callExpr.add(")")

  let emitBody = if retJs.len > 0:
    "var ret = " & callExpr & ";\n" & retJs
  else:
    callExpr & ";"

  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(retTypeNode)

  if not field.isStatic:
    formalParams.add(newIdentDefs(newIdentNode("self"), selfType))

  for (argName, argType) in field.args:
    let nimTy = widlTypeToNim(argType)
    formalParams.add(newIdentDefs(newIdentNode(widlSanitize(argName)), newIdentNode(nimTy)))

  var body = newStmtList()
  body.add nnkWhenStmt.newTree(
    nnkElifBranch.newTree(
      nnkCall.newTree(newIdentNode("defined"), newIdentNode("wasm32")),
      nnkStmtList.newTree(
        newNimNode(nnkPragma).add(
          nnkExprColonExpr.newTree(newIdentNode("emit"), newLit(emitBody))
        )
      )
    ),
    nnkElse.newTree(
      nnkStmtList.newTree(
        if retNil.len == 0:
          newNimNode(nnkDiscardStmt).add(newEmptyNode())
        else:
          parseStmt("result = " & retNil)
      )
    )
  )

  result = nnkProcDef.newTree(
    procName,
    newEmptyNode(),
    newEmptyNode(),
    formalParams,
    newEmptyNode(),
    newEmptyNode(),
    body
  )

proc buildNamespaceMethod(nsName: string, field: WebIDLMember): NimNode =
  let procName = newIdentNode(widlSanitize(field.name))
  let retType = widlTypeToNim(field.returnType)
  let retTypeNode = if retType.len == 0: newEmptyNode() else: newIdentNode(retType)
  let retJs = widlReturnToResultExpr(retType)
  let retNil = widlReturnNil(retType)

  var callExpr = nsName & "." & field.name & "("
  for i, (argName, argType) in field.args:
    if i > 0: callExpr.add(", ")
    let nimArgTy = widlTypeToNim(argType)
    callExpr.add(widlTypeToJsExpr(argName, nimArgTy))
  callExpr.add(")")

  let emitBody = if retJs.len > 0:
    "var ret = " & callExpr & ";\n" & retJs
  else:
    callExpr & ";"

  var formalParams = newNimNode(nnkFormalParams)
  formalParams.add(retTypeNode)

  for (argName, argType) in field.args:
    let nimTy = widlTypeToNim(argType)
    formalParams.add(newIdentDefs(newIdentNode(widlSanitize(argName)), newIdentNode(nimTy)))

  var body = newStmtList()
  body.add nnkWhenStmt.newTree(
    nnkElifBranch.newTree(
      nnkCall.newTree(newIdentNode("defined"), newIdentNode("wasm32")),
      nnkStmtList.newTree(
        newNimNode(nnkPragma).add(
          nnkExprColonExpr.newTree(newIdentNode("emit"), newLit(emitBody))
        )
      )
    ),
    nnkElse.newTree(
      nnkStmtList.newTree(
        if retNil.len == 0:
          newNimNode(nnkDiscardStmt).add(newEmptyNode())
        else:
          parseStmt("result = " & retNil)
      )
    )
  )

  result = nnkProcDef.newTree(
    procName,
    newEmptyNode(),
    newEmptyNode(),
    formalParams,
    newEmptyNode(),
    newEmptyNode(),
    body
  )

# ─── Main macro ───

macro webidlBind*(idlCode: static[string]): untyped =
  ## Parse WebIDL from a static string and generate Nim proc/type
  ## bindings using {.emit.} blocks (same pattern as web_sys.nim).
  ##
  ## .. code-block:: nim
  ##   webidlBind(\"\"\"
  ##     interface Node {
  ##       readonly attribute unsigned short nodeType;
  ##       Node appendChild(Node newChild);
  ##     };
  ##   \"\"\")
  let idlStr = idlCode
  let defs = parseWebIDL(idlStr)

  result = newStmtList()

  # Generate type definitions for all interfaces
  for d in defs:
    case d.kind
    of witInterface:
      result.add(buildDistinctTypeDef(d.name))
    of witDictionary:
      result.add(buildDistinctTypeDef(d.name))
    of witEnum:
      result.add(buildDistinctTypeDef(d.name))
    of witCallback, witCallbackInterface:
      result.add(buildDistinctTypeDef(d.name))
    of witNamespace:
      discard  # no type needed
    else:
      discard

  # 3) Generate attribute getters/setters and method calls
  for d in defs:
    case d.kind
    of witInterface:
      for f in d.fields:
        case f.memberType
        of "attribute":
          result.add(buildAttrGetter(d.name, f))
          if not f.isReadonly:
            result.add(buildAttrSetter(d.name, f))
        of "operation":
          result.add(buildMethod(d.name, f))
        else:
          discard
    of witNamespace:
      for f in d.fields:
        if f.memberType == "operation":
          result.add(buildNamespaceMethod(d.name, f))
    of witDictionary:
      for f in d.fields:
        result.add(buildAttrGetter(d.name, f))
        if not f.isReadonly:
          result.add(buildAttrSetter(d.name, f))
    else:
      discard
