## Attribute parsing for `{.wasmBindgen(...).}` pragma.
## Extracts jsName, getter, setter, constructor, catch, variadic,
## structural, start, private, skipTypescript, inspectable flags
## and provides JS code generation helpers for wrapper patterns.

import std/macros

type
  BindgenAttr* = enum
    baJsName
    baGetter
    baSetter
    baConstructor
    baCatch
    baVariadic
    baStructural
    baStart
    baPrivate
    baSkipTypescript
    baInspectable

  BindgenAttrs* = object
    jsName*: string
    flags*: set[BindgenAttr]

proc parseBindgenAttrs*(pragmaNode: NimNode): BindgenAttrs =
  if pragmaNode.kind == nnkEmpty:
    return

  var node = pragmaNode

  if node.kind == nnkPragma:
    for child in node:
      let ck = child.kind
      if ck == nnkIdent and $child == "wasmBindgen":
        return BindgenAttrs()
      elif ck == nnkCall and $child[0] == "wasmBindgen":
        node = child
        break
      elif ck == nnkExprColonExpr and $child[0] == "wasmBindgen":
        node = child[1]
        break

  if node.kind != nnkCall:
    if node.kind == nnkIdent and $node == "wasmBindgen":
      return BindgenAttrs()
    return

  var argNodes: seq[NimNode]
  for i in 1 ..< node.len:
    let child = node[i]
    if child.kind in {nnkStmtList, nnkArgList, nnkBracket}:
      for sub in child:
        argNodes.add(sub)
    else:
      argNodes.add(child)

  for arg in argNodes:
    case arg.kind
    of nnkExprColonExpr:
      let key = $arg[0]
      if key == "jsName":
        result.jsName = $arg[1]
        if result.jsName.len >= 2 and result.jsName[0] == '"' and result.jsName[^1] == '"':
          result.jsName = result.jsName[1 .. ^2]
    of nnkIdent:
      let flagName = $arg
      case flagName
      of "getter":          result.flags.incl baGetter
      of "setter":          result.flags.incl baSetter
      of "constructor":     result.flags.incl baConstructor
      of "catch":           result.flags.incl baCatch
      of "variadic":        result.flags.incl baVariadic
      of "structural":      result.flags.incl baStructural
      of "start":           result.flags.incl baStart
      of "private":         result.flags.incl baPrivate
      of "skipTypescript":  result.flags.incl baSkipTypescript
      of "inspectable":     result.flags.incl baInspectable
      else: discard
    else: discard

proc exportJsName*(attrs: BindgenAttrs, defaultName: string): string =
  if attrs.jsName.len > 0: attrs.jsName else: defaultName

proc generateGetterWrapperJs*(funcName: string, jsName: string, structName: string): string =
  result = "export function " & funcName & "(ptr) {\n"
  result.add("    const ret = wasm." & funcName & "(ptr);\n")
  result.add("    return ret;\n")
  result.add("}\n")

proc generateSetterWrapperJs*(funcName: string, jsName: string, structName: string): string =
  result = "export function " & funcName & "(ptr, val) {\n"
  result.add("    wasm." & funcName & "(ptr, val);\n")
  result.add("}\n")

proc generateConstructorWrapperJs*(funcName: string, jsName: string, args: seq[string]): string =
  var argList = ""
  for i, a in args:
    if i > 0: argList.add(", ")
    argList.add(a)
  result = "export function " & funcName & "(" & argList & ") {\n"
  result.add("    const ptr = wasm." & funcName & "(" & argList & ");\n")
  result.add("    const obj = Object.create(" & jsName & ".prototype);\n")
  result.add("    obj.__wbg_ptr = ptr;\n")
  result.add("    return obj;\n")
  result.add("}\n")

proc generateCatchWrapperJs*(funcName: string): string =
  result = "export function " & funcName & "_catch(...args) {\n"
  result.add("    try {\n")
  result.add("        return wasm." & funcName & "(...args);\n")
  result.add("    } catch (e) {\n")
  result.add("        console.error('Error in " & funcName & ":', e);\n")
  result.add("        return undefined;\n")
  result.add("    }\n")
  result.add("}\n")
