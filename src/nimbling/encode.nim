## Binary encoder for Program metadata.
## Writes varint-encoded program descriptor — equivalent to encode.rs

import common

type
  Encoder* = object
    buf*: seq[byte]

proc newEncoder*(): Encoder =
  Encoder(buf: @[])

proc putByte(e: var Encoder, b: byte) =
  e.buf.add(b)

proc varint32(e: var Encoder, v: uint32) =
  var val = v
  while val > 0x7F'u32:
    putByte(e, byte((val and 0x7F'u32) or 0x80'u32))
    val = val shr 7
  putByte(e, byte(val))

proc encode*(e: var Encoder, b: bool) =
  putByte(e, if b: 1'u8 else: 0'u8)

proc encode*(e: var Encoder, v: uint32) =
  e.varint32(v)

proc encode*(e: var Encoder, v: int) =
  assert v >= 0
  e.varint32(uint32(v))

proc encode*(e: var Encoder, s: string) =
  e.encode(s.len)
  for c in s:
    putByte(e, byte(c))

proc encode*[T](e: var Encoder, xs: seq[T]) =
  e.encode(xs.len)
  for x in xs:
    e.encode(x)

proc encode*[T](e: var Encoder, opt: Option[T]) =
  if opt.isNone:
    putByte(e, 0'u8)
  else:
    putByte(e, 1'u8)
    e.encode(opt.get())

# ─── Encode the full Program ───

proc encode*(e: var Encoder, p: ImportModule) =
  e.encode(ord(p.kind))
  case p.kind
  of imNamed:    e.encode(p.name)
  of imRawNamed: e.encode(p.rawName)
  of imInline:   e.encode(p.inlineIdx)

proc encode*(e: var Encoder, fa: FunctionArgumentData) =
  e.encode(fa.name)
  e.encode(fa.tyOverride)
  e.encode(fa.optional)
  e.encode(fa.desc)

proc encode*(e: var Encoder, f: FunctionDesc) =
  e.encode(f.args)
  e.encode(f.isAsync)
  e.encode(f.name)
  e.encode(f.generateTypescript)
  e.encode(f.generateJsdoc)
  e.encode(f.variadic)
  e.encode(f.retTyOverride)
  e.encode(f.retDesc)

proc encode*(e: var Encoder, op: Operation) =
  e.encode(op.isStatic)
  e.encode(ord(op.kind))
  e.encode(op.propertyName)

proc encode*(e: var Encoder, md: MethodData) =
  e.encode(md.class)
  e.encode(ord(md.methodKind))
  e.encode(md.operation)

proc encode*(e: var Encoder, imf: ImportFunction) =
  e.encode(imf.shim)
  e.encode(imf.catch)
  e.encode(imf.variadic)
  e.encode(imf.assertNoShim)
  e.encode(imf.methodData)
  e.encode(imf.structural)
  e.encode(imf.function)

proc encode*(e: var Encoder, ist: ImportStatic) =
  e.encode(ist.name)
  e.encode(ist.shim)

proc encode*(e: var Encoder, istr: ImportString) =
  e.encode(istr.shim)
  e.encode(istr.string)

proc encode*(e: var Encoder, it: ImportType) =
  e.encode(it.name)
  e.encode(it.instanceofShim)
  e.encode(it.vendorPrefixes)

proc encode*(e: var Encoder, se: StringEnum) =
  e.encode(se.name)
  e.encode(se.variantValues)
  e.encode(se.comments)
  e.encode(se.generateTypescript)
  e.encode(se.jsNamespace)

proc encode*(e: var Encoder, ik: ImportKindObj) =
  e.encode(ord(ik.kind))
  case ik.kind
  of ikFunction: e.encode(ik.funcData)
  of ikStatic:   e.encode(ik.staticData)
  of ikString:   e.encode(ik.stringData)
  of ikType:     e.encode(ik.typeData)
  of ikEnum:     e.encode(ik.enumData)

proc encode*(e: var Encoder, imp: Import) =
  e.encode(imp.module)
  e.encode(imp.jsNamespace)
  e.encode(imp.reexport)
  e.encode(imp.generateTypescript)
  e.encode(imp.importKind)

proc encode*(e: var Encoder, exp: Export) =
  e.encode(exp.class)
  e.encode(exp.comments)
  e.encode(exp.consumed)
  e.encode(exp.function)
  e.encode(exp.jsNamespace)
  e.encode(ord(exp.methodKind))
  e.encode(exp.startKind)

proc encode*(e: var Encoder, ev: EnumVariant) =
  e.encode(ev.name)
  e.encode(ev.value)
  e.encode(ev.comments)

proc encode*(e: var Encoder, ne: NimEnum) =
  e.encode(ne.name)
  e.encode(ne.signed)
  e.encode(ne.variants)
  e.encode(ne.comments)
  e.encode(ne.generateTypescript)
  e.encode(ne.jsNamespace)
  e.encode(ne.private)

proc encode*(e: var Encoder, sf: StructField) =
  e.encode(sf.name)
  e.encode(sf.readonly)
  e.encode(sf.comments)
  e.encode(sf.generateTypescript)
  e.encode(sf.generateJsdoc)

proc encode*(e: var Encoder, ns: NimStruct) =
  e.encode(ns.name)
  e.encode(ns.nimName)
  e.encode(ns.fields)
  e.encode(ns.comments)
  e.encode(ns.isInspectable)
  e.encode(ns.generateTypescript)
  e.encode(ns.jsNamespace)
  e.encode(ns.private)

proc encode*(e: var Encoder, lm: LinkedModule) =
  e.encode(lm.module)
  e.encode(lm.linkFunctionName)

proc encode*(e: var Encoder, lm: LocalModule) =
  e.encode(lm.identifier)
  e.encode(lm.contents)
  e.encode(lm.linkedModule)

proc encode*(e: var Encoder, loe: LitOrExpr) =
  e.encode(loe.isExpr)
  e.encode(loe.value)

proc encode*(e: var Encoder, prog: Program) =
  e.encode(SchemaVersion)
  e.encode(prog.exports)
  e.encode(prog.enums)
  e.encode(prog.imports)
  e.encode(prog.structs)
  e.encode(prog.typescriptCustomSections)
  e.encode(prog.localModules)
  e.encode(prog.inlineJs)
  e.encode(prog.uniqueCrateIdentifier)
  e.encode(prog.packageJson)
  e.encode(prog.linkedModules)
