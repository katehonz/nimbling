## WebIDL parser and Nim binding generator.
## Parses WebIDL specification files and outputs nimbling-annotated Nim code.
## Equivalent to wasm-bindgen's webidl bindings crate.

import std/strutils
import std/tables
import std/sets

import common

# ─── WebIDL AST Types ───

type
  WebIDLType* = enum
    witInterface, witPartialInterface, witDictionary, witPartialDictionary, witEnum,
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
    of '#':
      while l.pos < l.src.len and l.src[l.pos] != '\n':
        inc l.pos
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

  if c == '.' and l.pos + 2 < l.src.len and l.src[l.pos + 1] == '.' and l.src[l.pos + 2] == '.':
    l.pos += 3
    return Token(kind: tkSymbol, value: "...")

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

proc skipExtendedAttrs(p: var Parser): string =
  ## Skip `[...]` extended attribute blocks. Returns comma-separated attribute names.
  if not p.lexer.tryConsume("["):
    return ""
  var depth = 1
  while depth > 0:
    let tok = p.lexer.nextToken()
    if tok.kind == tkEof:
      return ""
    case tok.value
    of "[":
      inc depth
    of "]":
      dec depth
    else:
      discard

proc parseTypeRef(p: var Parser): string =
  # Skip extended attributes that may appear before a type
  while p.lexer.peek().value == "[":
    discard p.skipExtendedAttrs()
  # Handle parenthesized union types: (Type or Type2 or Type3)
  if p.lexer.tryConsume("("):
    discard p.parseTypeRef()
    while p.lexer.tryConsume("or"):
      discard p.parseTypeRef()
    discard p.lexer.tryConsume(")")
    result = "JsObject"
    if p.lexer.tryConsume("?"):
      result = result & "?"
    return result
  let tok = p.lexer.nextToken()
  if tok.kind == tkEof:
    return ""
  result = tok.value
  if result == "unsigned":
    let next = p.lexer.nextToken()
    result = "unsigned " & next.value
    if next.value == "long" and p.lexer.peek().value == "long":
      discard p.lexer.nextToken()
      result = "unsigned long long"
  elif result == "long":
    if p.lexer.peek().value == "long":
      discard p.lexer.nextToken()
      result = "long long"
  elif result == "unrestricted":
    let next = p.lexer.nextToken()
    result = "unrestricted " & next.value
  # Handle generic types with angle brackets
  elif result in ["sequence", "FrozenArray", "record", "Promise", "ObservableArray", "DOMStringList"]:
    discard p.lexer.tryConsume("<")
    while true:
      discard p.parseTypeRef()
      if not p.lexer.tryConsume(","):
        break
    discard p.lexer.tryConsume(">")
    result = "JsObject"
    if p.lexer.tryConsume("?"):
      result = result & "?"
    return result
  # Handle union types: skip `or` alternatives
  while p.lexer.peek().value == "or":
    discard p.lexer.nextToken()
    discard p.parseTypeRef()
  if p.lexer.tryConsume("?"):
    result = result & "?"

proc parseArgList(p: var Parser): seq[(string, string)] =
  result = @[]
  discard p.lexer.expect("(")
  if p.lexer.peek().value == ")":
    discard p.lexer.nextToken()
    return result
  while true:
    # Skip extended attributes before optional/type
    while p.lexer.peek().value == "[":
      discard p.skipExtendedAttrs()
    var isOptional = false
    if p.lexer.tryConsume("optional"):
      isOptional = true
    let argType = p.parseTypeRef()
    # Handle variadic type syntax: Type... Name
    discard p.lexer.tryConsume("...")
    var argName = ""
    let nameTok = p.lexer.nextToken()
    if nameTok.kind == tkIdent:
      argName = nameTok.value
    else:
      p.lexer.pos -= nameTok.value.len
    if p.lexer.tryConsume("="):
      # Skip default value — can be complex (e.g. = 1000, = "str", = Enum.val)
      var depth = 0
      while true:
        let dv = p.lexer.peek()
        if dv.kind == tkEof:
          break
        if depth == 0 and dv.value in [",", ")"]:
          break
        if dv.value == "(": inc depth
        if dv.value == ")":
          if depth == 0: break
          dec depth
        discard p.lexer.nextToken()
    result.add((argName, argType))
    if not p.lexer.tryConsume(","):
      break
  discard p.lexer.expect(")")

proc parseMember(p: var Parser, inheritStatic: bool = false): WebIDLMember =
  result = WebIDLMember()
  result.isStatic = inheritStatic

  # Skip extended attributes like [Pure], [Throws], etc.
  while p.lexer.peek().value == "[":
    discard p.skipExtendedAttrs()

  if p.lexer.tryConsume("static"):
    result.isStatic = true
  if p.lexer.tryConsume("readonly"):
    result.isReadonly = true
  if p.lexer.tryConsume("constructor"):
    result.memberType = "constructor"
    result.name = "constructor"
    if p.lexer.peek().value == "(":
      result.args = p.parseArgList()
    discard p.lexer.tryConsume(";")
    return
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
  if p.lexer.tryConsume("inherit"):
    discard
  if p.lexer.tryConsume("getter") or p.lexer.tryConsume("setter") or p.lexer.tryConsume("deleter"):
    result.memberType = "operation"
    result.returnType = p.parseTypeRef()
    let nameTok = p.lexer.nextToken()
    if nameTok.kind == tkIdent:
      result.name = nameTok.value
    else:
      p.lexer.pos -= nameTok.value.len
    if p.lexer.peek().value == "(":
      result.args = p.parseArgList()
    discard p.lexer.tryConsume(";")
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
    # Skip extended attributes before required/optional
    while p.lexer.peek().value == "[":
      discard p.skipExtendedAttrs()
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
  var lastPos = -1
  var loops = 0
  while p.lexer.peek().value != "}":
    let pos = p.lexer.pos
    if pos == lastPos:
      raise newException(ValueError, "parseInterfaceBody stuck at position " & $pos)
    lastPos = pos
    inc loops
    if loops > 10000:
      raise newException(ValueError, "parseInterfaceBody too many iterations")
    result.add(p.parseMember())
  discard p.lexer.nextToken()
  discard p.lexer.tryConsume(";")

proc parseCallback(p: var Parser, name: string): WebIDLDefinition =
  result = WebIDLDefinition(kind: witCallback, name: name)
  discard p.parseTypeRef()
  discard p.parseArgList()  # consume args to advance lexer, no storage field available
  discard p.lexer.tryConsume(";")

proc parseDefinition(p: var Parser): WebIDLDefinition =
  # Skip any leading extended attributes (e.g. [Exposed=*], [Constructor(...)], etc.)
  while p.lexer.peek().value == "[":
    discard p.skipExtendedAttrs()

  var tok = p.lexer.nextToken()
  if tok.kind == tkEof:
    return WebIDLDefinition()

  let isPartial = tok.value == "partial"
  if isPartial:
    tok = p.lexer.nextToken()

  case tok.value
  of "interface":
    # Handle `interface mixin Name` (Mozilla-specific syntax)
    var isMixin = false
    if p.lexer.peek().value == "mixin":
      discard p.lexer.nextToken()
      isMixin = true
    let nameTok = p.lexer.nextToken()
    let name = nameTok.value
    if p.lexer.tryConsume(":"):
      discard p.parseTypeRef()
    if p.lexer.peek().value == "{":
      let members = p.parseInterfaceBody()
      result = WebIDLDefinition(
        kind: if isPartial: witPartialInterface else: (if isMixin: witMixin else: witInterface),
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
      kind: if isPartial: witPartialDictionary else: witDictionary,
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
    var nameTok = p.lexer.nextToken()
    if nameTok.value == "interface":
      let ifaceName = p.lexer.nextToken().value
      let members = p.parseInterfaceBody()
      result = WebIDLDefinition(
        kind: witCallbackInterface,
        name: ifaceName,
        fields: members,
      )
    else:
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
    if p.lexer.tryConsume("includes"):
      let name = tok.value
      let mixinName = p.lexer.nextToken().value
      result = WebIDLDefinition(
        kind: witIncludes,
        name: name,
        parent: mixinName,
      )
      discard p.lexer.tryConsume(";")
    elif p.lexer.tryConsume("interface"):
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
  var lastPos = -1
  var loops = 0
  while p.lexer.peek().kind != tkEof:
    let pos = p.lexer.pos
    if pos == lastPos:
      echo "STUCK at pos ", pos, " after ", loops, " loops"
      break
    lastPos = pos
    inc loops
    if loops > 20000:
      echo "TOO MANY loops: ", loops
      break
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
  # Resolve partial interfaces/dictionaries: merge fields into the primary definition
  for d in defs:
    if d.kind == witPartialInterface or d.kind == witPartialDictionary:
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
  of "DOMString", "USVString", "ByteString", "UTF8String": return "string"
  of "DOMTimeStamp": return "uint64"
  of "PredefinedColorSpace": return "JsObject"
  of "any", "object": return "JsObject"
  of "void", "undefined": return "void"
  of "ArrayBuffer", "ArrayBufferView", "BufferSource": return "JsObject"
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
    # Unknown types fall back to JsObject to avoid undeclared identifier errors.
    # This covers missing typedefs, external types, and types from skipped files.
    return "JsObject"

proc sanitizeIdent(name: string): string =
  ## Make a WebIDL identifier safe for Nim.
  result = name
  # Strip leading underscores (invalid in Nim identifiers)
  while result.len > 0 and result[0] == '_':
    result = result[1..^1]
  # Prefix leading digits (invalid in Nim identifiers)
  if result.len > 0 and result[0] in '0'..'9':
    result = "n" & result
  if result.len > 0 and result[0] in 'A'..'Z':
    result[0] = result[0].toLowerAscii()
  const reserved = ["addr", "and", "as", "asm", "bind", "block", "break", "case",
                    "cast", "concept", "const", "continue", "converter", "defer",
                    "discard", "distinct", "div", "do", "elif", "else", "end",
                    "enum", "except", "export", "finally", "for", "from", "func",
                    "if", "import", "in", "include", "interface", "is", "isnot",
                    "iterator", "let", "macro", "method", "mixin", "mod", "nil",
                    "not", "notin", "object", "of", "or", "out", "proc", "ptr",
                    "raise", "ref", "result", "return", "shl", "shr", "static", "template",
                    "try", "tuple", "type", "using", "var", "when", "while", "with",
                    "without", "xor", "yield"]
  if result.toLowerAscii() in reserved:
    result = result & "Val"

proc nimFieldName(name: string): string =
  result = sanitizeIdent(name)
  if result.len > 0:
    result[0] = result[0].toLowerAscii()

# ─── Code Generator ───

proc isValidNimIdent(s: string): bool =
  if s.len == 0: return false
  if s[0] notin {'a'..'z', 'A'..'Z', '_'}: return false
  for c in s:
    if c notin {'a'..'z', 'A'..'Z', '0'..'9', '_'}: return false
  return true

# ─── Emit helpers ───

proc isWasmValueType(nimType: string): bool =
  ## Types that pass directly through C/Wasm (no heap wrapper needed).
  nimType in ["bool", "int8", "uint8", "int16", "uint16", "int32", "uint32",
              "int64", "uint64", "float32", "float64", "string", "void"]

proc isSeqType(nimType: string): bool =
  nimType.startsWith("seq[")

proc isHeapRefType(nimType: string): bool =
  ## Types that go through heap[] wrapping in emit.
  not isWasmValueType(nimType) and not isSeqType(nimType)

proc argToJsExpr(argName: string, nimType: string): string =
  ## Build JS expression for a function argument.
  if isHeapRefType(nimType):
    "heap[`" & argName & "`.idx]"
  else:
    "`" & argName & "`"

proc emitReturnStmt(nimType: string): string =
  ## Build the return-assignment emit statement after `var ret = ...`.
  if nimType == "void": return ""
  if isSeqType(nimType):
    return "`result` = {idx: addHeapObject(ret)};"
  if isWasmValueType(nimType):
    if nimType == "bool": "`result` = ret ? 1 : 0;"
    else: "`result` = ret;"
  else:
    "`result` = {idx: addHeapObject(ret)};"

proc defaultReturnExpr(nimType: string, typeName: string = ""): string =
  ## Build the default return expression for non-wasm fallback.
  if nimType == "void": return "discard"
  if nimType == "bool": return "false"
  if nimType == "string": return "\"\""
  if isSeqType(nimType): return "@[]"
  if nimType.startsWith("Option["):
    return "none(" & nimType[7..^2] & ")"
  if isWasmValueType(nimType): return "0"
  return nimType & "(JsValue(idx: 0))"

proc formatEmit(body: string): string =
  ## Wrap emit body in proper Nim string quotes.
  if '\n' in body:
    "\"\"\"" & body & "\"\"\""
  else:
    "\"" & body & "\""

# ─── Main code generator ───

proc generateNimBindings*(defs: seq[WebIDLDefinition], types: Table[string, WebIDLDefinition]): string =
  ## Generate Nim source code with real {.emit.} blocks for wasm32 interop.
  ## Two-pass: types first, then procs, to avoid forward-reference errors.
  var typeSection = ""
  var procSection = ""

  for d in defs:
    case d.kind
    of witInterface:
      typeSection.add("  " & d.name & "* = distinct JsValue\n")

    of witDictionary:
      typeSection.add("  " & d.name & "* = distinct JsValue\n")

    of witEnum:
      typeSection.add("  " & d.name & "* = enum\n")
      for i, v in d.variants:
        if v.len == 0: continue
        var cleanV = ""
        for c in v:
          if c in {'a'..'z', 'A'..'Z', '0'..'9', '_'}:
            cleanV.add(c)
          else:
            cleanV.add('_')
        var variantName = sanitizeIdent(cleanV)
        if variantName.len > 0:
          variantName[0] = variantName[0].toUpperAscii()
          typeSection.add("    " & d.name & variantName & "\n")

    of witCallback, witCallbackInterface:
      discard  # skip bare `proc` types; they can't have meaningful emit blocks

    of witTypedef:
      typeSection.add("  " & d.name & "* = JsObject\n")

    of witNamespace:
      discard

    of witMixin:
      typeSection.add("  " & d.name & "* = distinct JsValue\n")

    of witPartialInterface, witPartialDictionary, witIncludes:
      discard

  # Second pass: procs with real emit blocks
  var generatedProcs = initHashSet[string]()
  for d in defs:
    case d.kind
    of witInterface, witDictionary, witMixin:
      let typeName = d.name
      for f in d.fields:
        if f.memberType == "attribute":
          if f.name.len == 0: continue
          let fieldName = nimFieldName(f.name)
          if not isValidNimIdent(fieldName): continue
          let nimTy = webidlTypeToNim(f.returnType)
          if not isValidNimIdent(nimTy) and nimTy notin ["JsObject", "string", "bool", "void"]: continue
          let getterName = "js" & typeName & fieldName[0].toUpperAscii() & fieldName[1..^1]
          if getterName in generatedProcs: continue
          generatedProcs.incl(getterName)

          let retAssignStmt = emitReturnStmt(nimTy)
          let defRet = defaultReturnExpr(nimTy, typeName)
          let emitBody = if retAssignStmt.len > 0:
            "var ret = heap[`self`.idx]." & f.name & ";\n" & retAssignStmt
          else:
            "heap[`self`.idx]." & f.name & ";"

          procSection.add("proc " & getterName & "*(self: " & typeName & "): " & nimTy & " =\n")
          procSection.add("  when defined(wasm32):\n")
          procSection.add("    {.emit: " & formatEmit(emitBody) & ".}\n")
          procSection.add("  else:\n")
          if defRet == "discard":
            procSection.add("    discard\n")
          else:
            procSection.add("    result = " & defRet & "\n")

          # Generate setter if not readonly
          if not f.isReadonly and nimTy != "void":
            let setterName = getterName & "Eq"
            if setterName notin generatedProcs:
              generatedProcs.incl(setterName)
              let jsVal = argToJsExpr("value", nimTy)
              let setEmit = "heap[`self`.idx]." & f.name & " = " & jsVal & ";"
              procSection.add("proc `" & fieldName & "=`*(self: " & typeName & "; value: " & nimTy & ") =\n")
              procSection.add("  when defined(wasm32):\n")
              procSection.add("    {.emit: " & formatEmit(setEmit) & ".}\n")
              procSection.add("  else:\n")
              procSection.add("    discard\n")

        elif f.memberType == "const":
          let nimTy = webidlTypeToNim(f.returnType)
          if nimTy == "JsObject": continue
          let constName = "js" & typeName & f.name[0].toUpperAscii() & f.name[1..^1]
          if constName in generatedProcs: continue
          generatedProcs.incl(constName)
          procSection.add("const " & constName & "* : " & nimTy & " = 0\n")

      for f in d.fields:
        if f.memberType == "operation":
          if f.name.len == 0: continue
          if not isValidNimIdent(sanitizeIdent(f.name)): continue
          if f.returnType in ["setter", "deleter", "getter", "stringifier", "serializer"]: continue
          let retTy = webidlTypeToNim(f.returnType)
          let procBaseName = "js" & sanitizeIdent(f.name)[0].toUpperAscii() & sanitizeIdent(f.name)[1..^1]

          # Build argument strings
          var formalArgs: seq[string]
          var jsArgs: seq[string]
          var allArgsStr = "self: " & typeName
          if not f.isStatic:
            formalArgs.add("self: " & typeName)
          for (argName, argType) in f.args:
            let nimArgTy = webidlTypeToNim(argType)
            let nf = nimFieldName(argName)
            formalArgs.add(nf & ": " & nimArgTy)
            jsArgs.add(argToJsExpr(nf, nimArgTy))
          for i, fa in formalArgs:
            if i > 0 or f.isStatic:
              if allArgsStr.len > 0: allArgsStr.add("; ")
              allArgsStr.add(fa)

          let procSignature = procBaseName & "(" & allArgsStr & "):" & retTy
          if procSignature in generatedProcs: continue
          generatedProcs.incl(procSignature)

          # Build JS call expression
          var callObj: string
          if f.isStatic:
            callObj = typeName
          else:
            callObj = "heap[\x60self\x60.idx]"
          var callStr = "var ret = " & callObj & "." & f.name & "("
          for i, ja in jsArgs:
            if i > 0: callStr.add(", ")
            callStr.add(ja)
          callStr.add(')')
          let retAssignStmt = emitReturnStmt(retTy)
          var emitBody: string
          if retAssignStmt.len > 0:
            emitBody = callStr & ";\n" & retAssignStmt
          else:
            emitBody = callStr & ";"
          let defRet = defaultReturnExpr(retTy, typeName)

          if f.isStatic:
            var staticArgs = ""
            for (argName, argType) in f.args:
              let na = nimFieldName(argName)
              let nt = webidlTypeToNim(argType)
              if staticArgs.len > 0: staticArgs.add("; ")
              staticArgs.add(na & ": " & nt)
            if staticArgs.len > 0: staticArgs = "; " & staticArgs
            procSection.add("proc " & procBaseName & "*(self: typedesc[" & typeName & "]" & staticArgs & "): " & retTy & " =\n")
          else:
            procSection.add("proc " & procBaseName & "*(" & allArgsStr & "): " & retTy & " =\n")
          procSection.add("  when defined(wasm32):\n")
          procSection.add("    {.emit: " & formatEmit(emitBody) & ".}\n")
          procSection.add("  else:\n")
          if defRet == "discard":
            procSection.add("    discard\n")
          else:
            procSection.add("    result = " & defRet & "\n")
      procSection.add("\n")

    of witNamespace:
      for f in d.fields:
        if f.memberType == "operation":
          let retTy = webidlTypeToNim(f.returnType)
          var formalArgs: seq[string]
          var jsArgs: seq[string]
          for (argName, argType) in f.args:
            let nimArgTy = webidlTypeToNim(argType)
            let nf = nimFieldName(argName)
            formalArgs.add(nf & ": " & nimArgTy)
            jsArgs.add(argToJsExpr(nf, nimArgTy))
          let allArgs = formalArgs.join("; ")
          let nsProc = sanitizeIdent(f.name)
          if nsProc in generatedProcs: continue
          generatedProcs.incl(nsProc)

          var callStr = "var ret = " & d.name & "." & f.name & "(" & jsArgs.join(", ") & ")"
          let retAssignStmt = emitReturnStmt(retTy)
          let emitBody = if retAssignStmt.len > 0:
            callStr & ";\n" & retAssignStmt
          else:
            callStr & ";"
          let defRet = defaultReturnExpr(retTy)
          procSection.add("proc " & nsProc & "*(" & allArgs & "): " & retTy & " =\n")
          procSection.add("  when defined(wasm32):\n")
          procSection.add("    {.emit: " & formatEmit(emitBody) & ".}\n")
          procSection.add("  else:\n")
          if defRet == "discard":
            procSection.add("    discard\n")
          else:
            procSection.add("    result = " & defRet & "\n")
      procSection.add("\n")

    else:
      discard

  result = ""
  result.add("## Auto-generated WebIDL bindings for nimbling.\n")
  result.add("import nimbling/runtime\n")
  result.add("import nimbling/js_sys\n")
  result.add("import std/options\n\n")
  if typeSection.len > 0:
    result.add("type\n" & typeSection & "\n")
  result.add(procSection)
