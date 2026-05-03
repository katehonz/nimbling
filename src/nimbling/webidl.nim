## WebIDL parser and Nim binding generator.
## Parses WebIDL specification files and outputs nimbling-annotated Nim code.
## Equivalent to wasm-bindgen's webidl bindings crate.

import std/strutils
import std/tables

import common

# ─── WebIDL AST Types ───

type
  WebIDLType* = enum
    witInterface, witPartialInterface, witDictionary, witEnum,
    witCallback, witCallbackInterface, witTypedef, witMixin,
    witIncludes, witNamespace

  WebIDLMember* = object
    name*: string
    memberType*: string
    returnType*: string
    args*: seq[(string, string)]
    isStatic*: bool
    isReadonly*: bool
    isOptional*: bool

  WebIDLDefinition* = object
    kind*: WebIDLType
    name*: string
    members*: seq[WebIDLDefinition]
    fields*: seq[WebIDLMember]
    variants*: seq[string]
    parent*: string
    namespace*: string

# ─── Tokenizer ───

type
  TokenKind = enum
    tkIdent, tkString, tkNumber, tkSymbol, tkEof

  Token = object
    kind: TokenKind
    value: string

  Lexer = object
    src: string
    pos: int

proc initLexer(src: string): Lexer =
  Lexer(src: src, pos: 0)

proc skipWhitespace(l: var Lexer) =
  while l.pos < l.src.len:
    case l.src[l.pos]
    of ' ', '\t', '\r', '\n':
      inc l.pos
    of '/':
      if l.pos + 1 < l.src.len and l.src[l.pos + 1] == '/':
        while l.pos < l.src.len and l.src[l.pos] != '\n':
          inc l.pos
      elif l.pos + 1 < l.src.len and l.src[l.pos + 1] == '*':
        inc l.pos
        inc l.pos
        while l.pos + 1 < l.src.len and not (l.src[l.pos] == '*' and l.src[l.pos + 1] == '/'):
          inc l.pos
        if l.pos + 1 < l.src.len:
          inc l.pos
          inc l.pos
      else:
        break
    else:
      break

proc nextToken(l: var Lexer): Token =
  l.skipWhitespace()
  if l.pos >= l.src.len:
    return Token(kind: tkEof, value: "")

  let c = l.src[l.pos]

  if c in IdentStartChars:
    var s = ""
    while l.pos < l.src.len and l.src[l.pos] in IdentChars:
      s.add(l.src[l.pos])
      inc l.pos
    return Token(kind: tkIdent, value: s)

  if c == '"' or c == '\'':
    let quote = c
    inc l.pos
    var s = ""
    while l.pos < l.src.len and l.src[l.pos] != quote:
      if l.src[l.pos] == '\\' and l.pos + 1 < l.src.len:
        inc l.pos
        s.add(l.src[l.pos])
      else:
        s.add(l.src[l.pos])
      inc l.pos
    if l.pos < l.src.len:
      inc l.pos
    return Token(kind: tkString, value: s)

  if c in Digits or (c == '-' and l.pos + 1 < l.src.len and l.src[l.pos + 1] in Digits):
    var s = ""
    if c == '-':
      s.add('-')
      inc l.pos
    while l.pos < l.src.len and l.src[l.pos] in Digits:
      s.add(l.src[l.pos])
      inc l.pos
    if l.pos < l.src.len and l.src[l.pos] == '.':
      s.add('.')
      inc l.pos
      while l.pos < l.src.len and l.src[l.pos] in Digits:
        s.add(l.src[l.pos])
        inc l.pos
    return Token(kind: tkNumber, value: s)

  inc l.pos
  return Token(kind: tkSymbol, value: $c)

proc peek(l: var Lexer): Token =
  let saved = l.pos
  result = l.nextToken()
  l.pos = saved

proc expect(l: var Lexer, value: string): Token =
  result = l.nextToken()
  if result.value != value:
    raise newException(ValueError, "Expected '" & value & "' but got '" & result.value & "' at position " & $l.pos)

proc tryConsume(l: var Lexer, value: string): bool =
  let saved = l.pos
  let tok = l.nextToken()
  if tok.value == value:
    return true
  l.pos = saved
  return false

# ─── Parser ───

type
  Parser = object
    lexer: Lexer

proc initParser(src: string): Parser =
  Parser(lexer: initLexer(src))

proc parseTypeRef(p: var Parser): string =
  let tok = p.lexer.nextToken()
  if tok.kind == tkEof:
    return ""
  result = tok.value
  if result == "unsigned":
    let next = p.lexer.nextToken()
    result = "unsigned " & next.value
  elif result == "long":
    if p.lexer.peek().value == "long":
      discard p.lexer.nextToken()
      result = "long long"
  elif result == "unrestricted":
    let next = p.lexer.nextToken()
    result = "unrestricted " & next.value
  if p.lexer.tryConsume("?"):
    result = result & "?"

proc parseArgList(p: var Parser): seq[(string, string)] =
  result = @[]
  discard p.lexer.expect("(")
  if p.lexer.peek().value == ")":
    discard p.lexer.nextToken()
    return result
  while true:
    var isOptional = false
    if p.lexer.tryConsume("optional"):
      isOptional = true
    let argType = p.parseTypeRef()
    var argName = ""
    let nameTok = p.lexer.nextToken()
    if nameTok.kind == tkIdent:
      argName = nameTok.value
    else:
      p.lexer.pos -= nameTok.value.len
    if p.lexer.tryConsume("="):
      discard p.lexer.nextToken()
    result.add((argName, argType))
    if not p.lexer.tryConsume(","):
      break
  discard p.lexer.expect(")")

proc parseMember(p: var Parser, inheritStatic: bool = false): WebIDLMember =
  result = WebIDLMember()
  result.isStatic = inheritStatic

  if p.lexer.tryConsume("static"):
    result.isStatic = true
  if p.lexer.tryConsume("readonly"):
    result.isReadonly = true
  if p.lexer.tryConsume("attribute"):
    result.memberType = "attribute"
    result.returnType = p.parseTypeRef()
    let nameTok = p.lexer.nextToken()
    result.name = nameTok.value
    discard p.lexer.tryConsume(";")
    return
  if p.lexer.tryConsume("const"):
    result.memberType = "const"
    result.returnType = p.parseTypeRef()
    let nameTok = p.lexer.nextToken()
    result.name = nameTok.value
    discard p.lexer.tryConsume("=")
    if p.lexer.peek().kind in {tkNumber, tkIdent}:
      discard p.lexer.nextToken()
    discard p.lexer.tryConsume(";")
    return
  if p.lexer.tryConsume("stringifier"):
    result.memberType = "stringifier"
    result.returnType = "DOMString"
    if p.lexer.tryConsume(";"):
      return
  if p.lexer.tryConsume("serializer"):
    result.memberType = "serializer"
    if p.lexer.tryConsume(";"):
      return
  if p.lexer.tryConsume("iterable"):
    result.memberType = "iterable"
    discard p.lexer.tryConsume("<")
    result.returnType = p.parseTypeRef()
    while p.lexer.tryConsume(","):
      discard p.parseTypeRef()
    discard p.lexer.tryConsume(">")
    discard p.lexer.tryConsume(";")
    return
  if p.lexer.tryConsume("maplike"):
    result.memberType = "maplike"
    discard p.lexer.tryConsume("<")
    result.returnType = p.parseTypeRef()
    discard p.lexer.tryConsume(",")
    discard p.parseTypeRef()
    discard p.lexer.tryConsume(">")
    discard p.lexer.tryConsume(";")
    return
  if p.lexer.tryConsume("setlike"):
    result.memberType = "setlike"
    discard p.lexer.tryConsume("<")
    result.returnType = p.parseTypeRef()
    discard p.lexer.tryConsume(">")
    discard p.lexer.tryConsume(";")
    return

  result.returnType = p.parseTypeRef()
  if result.returnType == "":
    return

  let nameTok = p.lexer.nextToken()
  if nameTok.kind != tkIdent:
    p.lexer.pos -= nameTok.value.len
    result.name = ""
    result.memberType = "attribute"
    discard p.lexer.tryConsume(";")
    return

  result.name = nameTok.value

  if p.lexer.peek().value == "(":
    result.memberType = "operation"
    result.args = p.parseArgList()
  else:
    result.memberType = "attribute"
  discard p.lexer.tryConsume(";")

proc parseEnumBody(p: var Parser): seq[string] =
  result = @[]
  discard p.lexer.expect("{")
  while true:
    let tok = p.lexer.nextToken()
    if tok.kind == tkEof or tok.value == "}":
      break
    if tok.kind == tkString:
      result.add(tok.value)
    discard p.lexer.tryConsume(",")
    if p.lexer.peek().value == "}":
      discard p.lexer.nextToken()
      break
  discard p.lexer.tryConsume(";")

proc parseDictionaryBody(p: var Parser): seq[WebIDLMember] =
  result = @[]
  discard p.lexer.expect("{")
  while p.lexer.peek().value != "}":
    var m = WebIDLMember()
    m.memberType = "field"
    if p.lexer.tryConsume("required"):
      m.isOptional = false
    elif p.lexer.tryConsume("optional"):
      m.isOptional = true
    m.returnType = p.parseTypeRef()
    let nameTok = p.lexer.nextToken()
    m.name = nameTok.value
    if p.lexer.tryConsume("="):
      discard p.lexer.nextToken()
    discard p.lexer.tryConsume(";")
    result.add(m)
  discard p.lexer.nextToken()
  discard p.lexer.tryConsume(";")

proc parseInterfaceBody(p: var Parser): seq[WebIDLMember] =
  result = @[]
  discard p.lexer.expect("{")
  while p.lexer.peek().value != "}":
    result.add(p.parseMember())
  discard p.lexer.nextToken()
  discard p.lexer.tryConsume(";")

proc parseCallback(p: var Parser, name: string): WebIDLDefinition =
  result = WebIDLDefinition(kind: witCallback, name: name)
  discard p.parseTypeRef()
  discard p.lexer.expect("(")
  while p.lexer.peek().value != ")":
    discard p.parseTypeRef()
    discard p.lexer.nextToken()
    discard p.lexer.tryConsume(",")
  discard p.lexer.nextToken()
  discard p.lexer.tryConsume(";")

proc parseDefinition(p: var Parser): WebIDLDefinition =
  var tok = p.lexer.nextToken()
  if tok.kind == tkEof:
    return WebIDLDefinition()

  let isPartial = tok.value == "partial"
  if isPartial:
    tok = p.lexer.nextToken()

  case tok.value
  of "interface":
    let nameTok = p.lexer.nextToken()
    let name = nameTok.value
    if p.lexer.tryConsume(":"):
      discard p.parseTypeRef()
    if p.lexer.peek().value == "{":
      let members = p.parseInterfaceBody()
      result = WebIDLDefinition(
        kind: if isPartial: witPartialInterface else: witInterface,
        name: name,
        fields: members,
      )
    else:
      result = WebIDLDefinition(kind: witInterface, name: name)
      discard p.lexer.tryConsume(";")
  of "dictionary":
    let nameTok = p.lexer.nextToken()
    let name = nameTok.value
    var parent = ""
    if p.lexer.tryConsume(":"):
      parent = p.parseTypeRef()
    let fields = p.parseDictionaryBody()
    result = WebIDLDefinition(
      kind: witDictionary,
      name: name,
      fields: fields,
      parent: parent,
    )
  of "enum":
    let nameTok = p.lexer.nextToken()
    let name = nameTok.value
    let variants = p.parseEnumBody()
    result = WebIDLDefinition(
      kind: witEnum,
      name: name,
      variants: variants,
    )
  of "callback":
    let nameTok = p.lexer.nextToken()
    let name = nameTok.value
    if p.lexer.tryConsume("="):
      result = p.parseCallback(name)
    elif p.lexer.peek().value == "{":
      let members = p.parseInterfaceBody()
      result = WebIDLDefinition(
        kind: witCallbackInterface,
        name: name,
        fields: members,
      )
    else:
      result = WebIDLDefinition(kind: witCallback, name: name)
      discard p.lexer.tryConsume(";")
  of "typedef":
    discard p.parseTypeRef()
    let nameTok = p.lexer.nextToken()
    result = WebIDLDefinition(kind: witTypedef, name: nameTok.value)
    discard p.lexer.tryConsume(";")
  of "mixin":
    let nameTok = p.lexer.nextToken()
    let name = nameTok.value
    let members = p.parseInterfaceBody()
    result = WebIDLDefinition(
      kind: witMixin,
      name: name,
      fields: members,
    )
  of "includes":
    let nameTok = p.lexer.nextToken()
    let name = nameTok.value
    discard p.lexer.nextToken()
    let mixinName = p.lexer.nextToken().value
    result = WebIDLDefinition(
      kind: witIncludes,
      name: name,
      parent: mixinName,
    )
    discard p.lexer.tryConsume(";")
  of "namespace":
    let nameTok = p.lexer.nextToken()
    let name = nameTok.value
    let members = p.parseInterfaceBody()
    result = WebIDLDefinition(
      kind: witNamespace,
      name: name,
      fields: members,
      namespace: name,
    )
  else:
    if p.lexer.tryConsume("interface"):
      let name = tok.value
      let members = p.parseInterfaceBody()
      result = WebIDLDefinition(
        kind: if isPartial: witPartialInterface else: witInterface,
        name: name,
        fields: members,
      )
    else:
      result = WebIDLDefinition()

proc parseWebIDL*(source: string): seq[WebIDLDefinition] =
  ## Parse a WebIDL source string into AST.
  result = @[]
  var p = initParser(source)
  while p.lexer.peek().kind != tkEof:
    let def = p.parseDefinition()
    if def.name.len > 0:
      result.add(def)

# ─── First-pass analysis ───

proc analyzeTypes*(defs: seq[WebIDLDefinition]): Table[string, WebIDLDefinition] =
  ## Build type lookup table from all definitions.
  result = initTable[string, WebIDLDefinition]()
  for d in defs:
    if d.name.len > 0:
      result[d.name] = d
  # Resolve partial interfaces: merge fields into the primary definition
  for d in defs:
    if d.kind == witPartialInterface:
      if d.name in result:
        var primary = result[d.name]
        primary.fields.add(d.fields)
        result[d.name] = primary
  # Resolve includes (mixin merging)
  for d in defs:
    if d.kind == witIncludes:
      if d.name in result and d.parent in result:
        var primary = result[d.name]
        let mixinDef = result[d.parent]
        primary.fields.add(mixinDef.fields)
        result[d.name] = primary

# ─── Type mapping ───

proc webidlTypeToNim(widlType: string): string =
  case widlType
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
  of "DOMString", "USVString", "ByteString", "UTF8String": return "cstring"
  of "any", "object": return "JsObject"
  of "void": return "void"
  of "ArrayBuffer", "ArrayBufferView": return "JsObject"
  of "Uint8Array": return "seq[uint8]"
  of "Int8Array": return "seq[int8]"
  of "Uint16Array": return "seq[uint16]"
  of "Int16Array": return "seq[int16]"
  of "Uint32Array": return "seq[uint32]"
  of "Int32Array": return "seq[int32]"
  of "Float32Array": return "seq[float32]"
  of "Float64Array": return "seq[float64]"
  of "Promise": return "Future[JsObject]"
  else:
    if widlType.endsWith("?"):
      return "Option[" & webidlTypeToNim(widlType[0..^2]) & "]"
    return widlType

proc sanitizeIdent(name: string): string =
  ## Make a WebIDL identifier safe for Nim.
  result = name
  if result.len > 0 and result[0] in 'A'..'Z':
    result[0] = result[0].toLowerAscii()
  const reserved = ["addr", "and", "as", "asm", "bind", "block", "break", "case",
                    "cast", "concept", "const", "continue", "converter", "defer",
                    "discard", "distinct", "div", "do", "elif", "else", "end",
                    "enum", "except", "export", "finally", "for", "from", "func",
                    "if", "import", "in", "include", "interface", "is", "isnot",
                    "iterator", "let", "macro", "method", "mixin", "mod", "nil",
                    "not", "notin", "object", "of", "or", "out", "proc", "ptr",
                    "raise", "ref", "return", "shl", "shr", "static", "template",
                    "try", "tuple", "type", "using", "var", "when", "while", "with",
                    "without", "xor", "yield"]
  if result.toLowerAscii() in reserved:
    result = result & "Val"

proc nimFieldName(name: string): string =
  result = sanitizeIdent(name)
  if result.len > 0:
    result[0] = result[0].toLowerAscii()

# ─── Code Generator ───

proc generateNimBindings*(defs: seq[WebIDLDefinition], types: Table[string, WebIDLDefinition]): string =
  ## Generate Nim source code with {.wasmBindgen.} annotations.
  result = ""
  result.add("## Auto-generated WebIDL bindings for nimbling.\n")
  result.add("import nimbling\n\n")

  for d in defs:
    case d.kind
    of witInterface:
      result.add("type\n")
      result.add("  " & d.name & "* {.wasmBindgen.} = object\n")
      for f in d.fields:
        if f.memberType == "attribute":
          let nimTy = webidlTypeToNim(f.returnType)
          result.add("    " & nimFieldName(f.name) & "*: " & nimTy & "\n")
        elif f.memberType == "const":
          let nimTy = webidlTypeToNim(f.returnType)
          result.add("    " & nimFieldName(f.name) & "*: " & nimTy & "\n")
      result.add("\n")

      for f in d.fields:
        if f.memberType == "operation":
          let retTy = webidlTypeToNim(f.returnType)
          var args = "self: " & d.name
          for (argName, argType) in f.args:
            args.add("; " & nimFieldName(argName) & ": " & webidlTypeToNim(argType))
          if f.isStatic:
            args = ""
            for i, (argName, argType) in f.args:
              if i > 0: args.add("; ")
              args.add(nimFieldName(argName) & ": " & webidlTypeToNim(argType))
            if args.len > 0:
              args = "; " & args
            result.add("proc " & sanitizeIdent(f.name) & "*(self: typedesc[" & d.name & "]" & args & "): " & retTy & " {.wasmBindgen.}\n")
          else:
            result.add("proc " & sanitizeIdent(f.name) & "*(" & args & "): " & retTy & " {.wasmBindgen.}\n")
      result.add("\n")

    of witDictionary:
      result.add("type\n")
      result.add("  " & d.name & "* {.wasmBindgen.} = object\n")
      for f in d.fields:
        let nimTy = webidlTypeToNim(f.returnType)
        var suffix = ""
        if f.isOptional:
          suffix = " ## optional"
        result.add("    " & nimFieldName(f.name) & "*: " & nimTy & suffix & "\n")
      result.add("\n")

    of witEnum:
      result.add("type\n")
      result.add("  " & d.name & "* {.wasmBindgen.} = enum\n")
      for i, v in d.variants:
        var variantName = sanitizeIdent(v)
        variantName[0] = variantName[0].toUpperAscii()
        result.add("    " & variantName & "\n")
      result.add("\n")

    of witCallback:
      result.add("type\n")
      result.add("  " & d.name & "* = proc" & "\n")
      result.add("\n")

    of witTypedef:
      result.add("type\n")
      result.add("  " & d.name & "* = JsObject\n")
      result.add("\n")

    of witNamespace:
      result.add("proc " & d.name & "Val*() {.wasmBindgen.}\n")
      for f in d.fields:
        if f.memberType == "operation":
          let retTy = webidlTypeToNim(f.returnType)
          var args = ""
          for i, (argName, argType) in f.args:
            if i > 0: args.add("; ")
            args.add(nimFieldName(argName) & ": " & webidlTypeToNim(argType))
          result.add("proc " & sanitizeIdent(f.name) & "*(" & args & "): " & retTy & " {.wasmBindgen.}\n")
      result.add("\n")

    of witPartialInterface, witMixin, witIncludes, witCallbackInterface:
      discard

proc webidlToNim*(webidlSource: string): string =
  ## Parse WebIDL and generate Nim bindings in one step.
  let defs = parseWebIDL(webidlSource)
  let types = analyzeTypes(defs)
  result = generateNimBindings(defs, types)

when isMainModule:
  let testIdl = """
  interface Node {
    readonly attribute unsigned short nodeType;
    attribute DOMString? nodeName;
    Node appendChild(Node newChild);
    static Node createDocument();
  };

  dictionary ScrollOptions {
    required ScrollBehavior behavior;
  };

  enum ScrollBehavior { "auto", "instant", "smooth" };
  """

  let nimCode = webidlToNim(testIdl)
  echo nimCode
