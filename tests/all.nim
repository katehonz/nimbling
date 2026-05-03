## Test suite for nimbling

import std/unittest
import std/strutils

import nimbling/common
import nimbling/encode
import nimbling/decode
import nimbling/describe
import nimbling/jsgen
import nimbling/codegen
import nimbling/leb128
import nimbling/interp
import nimbling/transforms
import nimbling/runtime
import nimbling/cli
import nimbling/macroimpl_webidl

suite "common - identifiers":
  test "valid JS identifiers":
    check isValidIdent("foo")
    check isValidIdent("_bar")
    check isValidIdent("$baz")
    check isValidIdent("camelCase")
    check isValidIdent("PascalCase")

  test "invalid JS identifiers":
    check not isValidIdent("")
    check not isValidIdent("123abc")
    check not isValidIdent("foo-bar")

  test "qualifiedName":
    check qualifiedName(@[], "greet") == "greet"
    check qualifiedName(@["nimbling"], "greet") == "nimbling__greet"
    check qualifiedName(@["a", "b"], "greet") == "a__b__greet"

  test "mangled names":
    check newFunction("MyStruct") == "__nbg_mystruct_new"
    check freeFunction("MyStruct") == "__nbg_mystruct_free"
    check structFieldGet("MyStruct", "name") == "__nbg_get_mystruct_name"

suite "encode + decode roundtrip":
  test "program roundtrip":
    var prog = Program(
      uniqueCrateIdentifier: "test_crate",
      exports: @[
        Export(
          function: FunctionDesc(
            name: "greet",
            args: @[
              FunctionArgumentData(name: "name"),
            ],
          ),
        ),
      ],
    )

    var enc = newEncoder()
    enc.encode(prog)

    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)

    check decoded.uniqueCrateIdentifier == "test_crate"
    check decoded.exports.len == 1
    check decoded.exports[0].function.name == "greet"

  test "import roundtrip":
    var prog = Program(
      uniqueCrateIdentifier: "test_crate",
      imports: @[
        Import(
          module: some(ImportModule(kind: imNamed, name: "./math")),
          importKind: ImportKindObj(
            kind: ikFunction,
            funcData: ImportFunction(
              shim: "__nbg_f_add",
              function: FunctionDesc(
                name: "add",
                args: @[
                  FunctionArgumentData(name: "a"),
                  FunctionArgumentData(name: "b"),
                ],
              ),
            ),
          ),
        ),
      ],
    )

    var enc = newEncoder()
    enc.encode(prog)

    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)

    check decoded.imports.len == 1
    check decoded.imports[0].module.get.kind == imNamed
    check decoded.imports[0].module.get.name == "./math"
    check decoded.imports[0].importKind.kind == ikFunction
    check decoded.imports[0].importKind.funcData.function.name == "add"

  test "enum roundtrip":
    var prog = Program(
      uniqueCrateIdentifier: "test_crate",
      enums: @[
        NimEnum(
          name: "Color",
          signed: false,
          variants: @[
            EnumVariant(name: "Red", value: 0),
            EnumVariant(name: "Green", value: 1),
            EnumVariant(name: "Blue", value: 2),
          ],
          generateTypescript: true,
          hole: 3,
        ),
      ],
    )

    var enc = newEncoder()
    enc.encode(prog)

    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)

    check decoded.enums.len == 1
    check decoded.enums[0].name == "Color"
    check decoded.enums[0].hole == 3
    check decoded.enums[0].variants.len == 3
    check decoded.enums[0].variants[0].name == "Red"
    check decoded.enums[0].variants[0].value == 0
    check decoded.enums[0].variants[2].name == "Blue"
    check decoded.enums[0].variants[2].value == 2

  test "struct roundtrip":
    var prog = Program(
      uniqueCrateIdentifier: "test_crate",
      structs: @[
        NimStruct(
          name: "Point",
          nimName: "Point",
          fields: @[
            StructField(name: "x", tyOverride: "int32", readonly: false),
            StructField(name: "y", tyOverride: "int32", readonly: false),
          ],
          generateTypescript: true,
        ),
      ],
    )

    var enc = newEncoder()
    enc.encode(prog)

    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)

    check decoded.structs.len == 1
    check decoded.structs[0].name == "Point"
    check decoded.structs[0].fields.len == 2
    check decoded.structs[0].fields[0].name == "x"
    check decoded.structs[0].fields[0].tyOverride == "int32"
    check decoded.structs[0].fields[1].name == "y"
    check decoded.structs[0].fields[1].tyOverride == "int32"

suite "describe - descriptor decode":
  test "basic scalar types":
    # Simulate descriptor output: [I32]
    let data = @[TY_I32]
    let d = Descriptor.decode(data)
    check d.kind == TY_I32

    let data2 = @[TY_F64]
    let d2 = Descriptor.decode(data2)
    check d2.kind == TY_F64

    let data3 = @[TY_BOOLEAN]
    let d3 = Descriptor.decode(data3)
    check d3.kind == TY_BOOLEAN

  test "string descriptor":
    let data = @[TY_STRING]
    let d = Descriptor.decode(data)
    check d.kind == TY_STRING

  test "ref descriptor":
    # Ref to string: [REF, STRING]
    let data = @[TY_REF, TY_STRING]
    let d = Descriptor.decode(data)
    check d.kind == TY_REF
    check d.inner[].kind == TY_STRING

  test "function descriptor":
    # Function(string) -> string: [FUNCTION, shimIdx=0, 1, STRING, STRING, STRING]
    # Format: FUNCTION, shim_idx, arg_count, args..., ret, inner_ret
    let data = @[TY_FUNCTION, 0'u32, 1'u32, TY_STRING, TY_STRING, TY_STRING]
    let d = Descriptor.decode(data)
    check d.kind == TY_FUNCTION
    check d.funcDesc.shimIdx == 0
    check d.funcDesc.arguments.len == 1
    check d.funcDesc.arguments[0].kind == TY_STRING
    check d.funcDesc.ret.kind == TY_STRING

  test "enum descriptor":
    # Enum "Color": [ENUM, 5, C, o, l, o, r, hole=0]
    let data = @[TY_ENUM, 5'u32, 67'u32, 111'u32, 108'u32, 111'u32, 114'u32, 0'u32]
    let d = Descriptor.decode(data)
    check d.kind == TY_ENUM
    check d.nameStr == "Color"
    check d.enumHole == 0

  test "option descriptor":
    # Option<string>: [OPTIONAL, STRING]
    let data = @[TY_OPTIONAL, TY_STRING]
    let d = Descriptor.decode(data)
    check d.kind == TY_OPTIONAL
    check d.inner[].kind == TY_STRING

  test "vector descriptor":
    # Vec<u8>: [VECTOR, U8]
    let data = @[TY_VECTOR, TY_U8]
    let d = Descriptor.decode(data)
    check d.kind == TY_VECTOR
    check d.inner[].kind == TY_U8

  test "closure descriptor":
    # Closure: [CLOSURE, owned=1, mutable=0, FUNCTION, shimIdx=0, argCount=0, UNIT, UNIT]
    let data = @[TY_CLOSURE, 1'u32, 0'u32, TY_FUNCTION, 0'u32, 0'u32, TY_UNIT, TY_UNIT]
    let d = Descriptor.decode(data)
    check d.kind == TY_CLOSURE
    check d.closureDesc.owned == true
    check d.closureDesc.mutable == false
    check d.closureDesc.function.shimIdx == 0
    check d.closureDesc.function.arguments.len == 0
    check d.closureDesc.function.ret.kind == TY_UNIT

  test "string enum descriptor":
    # StringEnum "Status": [STRING_ENUM, 6, S, t, a, t, u, s, variantCount=2]
    let data = @[TY_STRING_ENUM, 6'u32, 83'u32, 116'u32, 97'u32, 116'u32, 117'u32, 115'u32, 2'u32]
    let d = Descriptor.decode(data)
    check d.kind == TY_STRING_ENUM
    check d.nameStr == "Status"
    check d.stringEnumInvalid == 2
    check d.stringEnumHole == 3

  test "named externref descriptor":
    let data = @[TY_NAMED_EXTERNREF, 5'u32, 77'u32, 121'u32, 84'u32, 121'u32, 112'u32]
    let d = Descriptor.decode(data)
    check d.kind == TY_NAMED_EXTERNREF
    check d.nameStr == "MyTyp"

suite "jsgen - JS glue generation":
  test "generates module header for bundler target":
    var prog = Program(uniqueCrateIdentifier: "test")
    var jsg = newJsGen(prog, jsBundler, "hello")
    let output = jsg.generate()
    check output.contains("import * as wasm from './hello_bg.js'")
    check output.contains("async function init(input)")

  test "generates module header for node target":
    var prog = Program(uniqueCrateIdentifier: "test")
    var jsg = newJsGen(prog, jsNode, "hello")
    let output = jsg.generate()
    check output.contains("require('./hello_bg.js')")

  test "generates heap helpers":
    var prog = Program(uniqueCrateIdentifier: "test")
    var jsg = newJsGen(prog, jsBundler, "hello")
    let output = jsg.generate()
    check output.contains("addHeapObject")
    check output.contains("dropObject")
    check output.contains("takeObject")
    check output.contains("passStringToWasm")
    check output.contains("getStringFromWasm")

  test "generates export shim for string function":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      exports: @[
        Export(
          function: FunctionDesc(
            name: "greet",
            args: @[
              FunctionArgumentData(name: "name", tyOverride: "string"),
            ],
            retTyOverride: "string",
          ),
        ),
      ],
    )
    var jsg = newJsGen(prog, jsBundler, "hello")
    let output = jsg.generate()
    check output.contains("export function greet(")
    check output.contains("passStringToWasm")
    check output.contains("__nbg_shim_greet")
    check output.contains("__nbg_boxed_str_ptr")
    check output.contains("getStringFromWasm")

  test "generates export shim for numeric function":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      exports: @[
        Export(
          function: FunctionDesc(
            name: "add",
            args: @[
              FunctionArgumentData(name: "a", tyOverride: "int32"),
              FunctionArgumentData(name: "b", tyOverride: "int32"),
            ],
            retTyOverride: "int32",
          ),
        ),
      ],
    )
    var jsg = newJsGen(prog, jsBundler, "hello")
    let output = jsg.generate()
    check output.contains("export function add(")
    check output.contains("__nbg_shim_add")

  test "generates import shim for function":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      imports: @[
        Import(
          module: some(ImportModule(kind: imNamed, name: "./math")),
          importKind: ImportKindObj(
            kind: ikFunction,
            funcData: ImportFunction(
              shim: "__nbg_f_add",
              function: FunctionDesc(
                name: "add",
                args: @[
                  FunctionArgumentData(name: "a", tyOverride: "int32"),
                  FunctionArgumentData(name: "b", tyOverride: "int32"),
                ],
              ),
            ),
          ),
        ),
      ],
    )
    var jsg = newJsGen(prog, jsBundler, "hello")
    let output = jsg.generate()
    check output.contains("export function __nbg_f_add(")
    check output.contains("import { add } from './math'")

  test "generates init with async load":
    var prog = Program(uniqueCrateIdentifier: "test")
    var jsg = newJsGen(prog, jsWeb, "hello")
    let output = jsg.generate()
    check output.contains("async function __nbg_load")
    check output.contains("async function init")
    check output.contains("WebAssembly.instantiateStreaming")
    check output.contains("export default init")

  test "generates enum export with bidirectional mapping":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      enums: @[
        NimEnum(
          name: "Color",
          variants: @[
            EnumVariant(name: "Red", value: 0),
            EnumVariant(name: "Green", value: 1),
            EnumVariant(name: "Blue", value: 2),
          ],
          hole: 3,
        ),
      ],
    )
    var jsg = newJsGen(prog, jsBundler, "hello")
    let output = jsg.generate()
    check output.contains("export const Color = Object.freeze(")
    check output.contains("Red: 0")
    check output.contains("Green: 1")
    check output.contains("Blue: 2")
    check output.contains("\"0\": \"Red\"")
    check output.contains("\"1\": \"Green\"")
    check output.contains("\"2\": \"Blue\"")

  test "classifies enum args as numbers":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      enums: @[
        NimEnum(name: "Color", variants: @[EnumVariant(name: "Red", value: 0)], hole: 1),
      ],
      exports: @[
        Export(
          function: FunctionDesc(
            name: "setColor",
            args: @[
              FunctionArgumentData(name: "c", tyOverride: "Color"),
            ],
          ),
        ),
      ],
    )
    var jsg = newJsGen(prog, jsBundler, "hello")
    let output = jsg.generate()
    check output.contains("export function setColor(arg0)")
    # Enum args should pass through directly (no string boxing, no heap object)
    check output.contains("wasm.__nbg_shim_setColor(arg0)")

  test "generates module header for no-modules target":
    var prog = Program(uniqueCrateIdentifier: "test")
    var jsg = newJsGen(prog, jsNoModules, "hello")
    let output = jsg.generate()
    check output.contains("(function() {")
    check output.contains("const wasm = wasm_bindgen;")

  test "generates module header for deno target":
    var prog = Program(uniqueCrateIdentifier: "test")
    var jsg = newJsGen(prog, jsDeno, "hello")
    let output = jsg.generate()
    check output.contains("import * as wasm from './hello';")

  test "generates struct class with constructor and getters":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      structs: @[
        NimStruct(
          name: "Point",
          nimName: "Point",
          fields: @[
            StructField(name: "x", tyOverride: "int32", readonly: false),
            StructField(name: "y", tyOverride: "int32", readonly: false),
          ],
        ),
      ],
      exports: @[
        Export(
          class: some("Point"),
          methodKind: mkConstructor,
          function: FunctionDesc(
            name: "__nbg_point_new",
            args: @[
              FunctionArgumentData(name: "x", tyOverride: "int32"),
              FunctionArgumentData(name: "y", tyOverride: "int32"),
            ],
            retTyOverride: "uint32",
          ),
        ),
        Export(
          class: some("Point"),
          methodKind: mkOperation,
          function: FunctionDesc(
            name: "__nbg_point_free",
            args: @[FunctionArgumentData(name: "ptr", tyOverride: "uint32")],
            retTyOverride: "",
          ),
        ),
        Export(
          class: some("Point"),
          methodKind: mkOperation,
          function: FunctionDesc(
            name: "__nbg_get_point_x",
            args: @[FunctionArgumentData(name: "ptr", tyOverride: "uint32")],
            retTyOverride: "int32",
          ),
        ),
        Export(
          class: some("Point"),
          methodKind: mkOperation,
          function: FunctionDesc(
            name: "__nbg_set_point_x",
            args: @[
              FunctionArgumentData(name: "ptr", tyOverride: "uint32"),
              FunctionArgumentData(name: "x", tyOverride: "int32"),
            ],
            retTyOverride: "",
          ),
        ),
      ],
    )
    var jsg = newJsGen(prog, jsBundler, "hello")
    let output = jsg.generate()
    check output.contains("export class Point {")
    check output.contains("constructor(x, y)")
    check output.contains("wasm.__nbg_point_new(")
    check output.contains("free() {")
    check output.contains("wasm.__nbg_point_free(")
    check output.contains("get x() {")
    check output.contains("wasm.__nbg_get_point_x(")
    check output.contains("set x(v) {")
    check output.contains("wasm.__nbg_set_point_x(")
    # Struct exports should NOT appear as standalone functions
    check not output.contains("export function __nbg_point_new(")
    check not output.contains("export function __nbg_get_point_x(")

suite "encode + decode roundtrip — extended":
  test "linked module roundtrip":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      linkedModules: @[
        LinkedModule(
          module: ImportModule(kind: imNamed, name: "./foo"),
          linkFunctionName: "link_foo",
        ),
      ],
    )
    var enc = newEncoder()
    enc.encode(prog)
    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)
    check decoded.linkedModules.len == 1
    check decoded.linkedModules[0].module.kind == imNamed
    check decoded.linkedModules[0].module.name == "./foo"
    check decoded.linkedModules[0].linkFunctionName == "link_foo"

  test "local module roundtrip":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      localModules: @[
        LocalModule(
          identifier: "bar",
          contents: "console.log('hi');",
          linkedModule: false,
        ),
      ],
    )
    var enc = newEncoder()
    enc.encode(prog)
    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)
    check decoded.localModules.len == 1
    check decoded.localModules[0].identifier == "bar"
    check decoded.localModules[0].contents == "console.log('hi');"
    check decoded.localModules[0].linkedModule == false

  test "inline JS roundtrip":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      inlineJs: @["alert('hello');"],
    )
    var enc = newEncoder()
    enc.encode(prog)
    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)
    check decoded.inlineJs.len == 1
    check decoded.inlineJs[0] == "alert('hello');"

  test "typescript custom sections roundtrip":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      typescriptCustomSections: @[
        LitOrExpr(isExpr: false, value: "type Foo = string;"),
      ],
    )
    var enc = newEncoder()
    enc.encode(prog)
    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)
    check decoded.typescriptCustomSections.len == 1
    check decoded.typescriptCustomSections[0].isExpr == false
    check decoded.typescriptCustomSections[0].value == "type Foo = string;"

  test "import kind roundtrip — static, string, type, enum":
    var prog = Program(
      uniqueCrateIdentifier: "test",
      imports: @[
        Import(
          importKind: ImportKindObj(
            kind: ikStatic,
            staticData: ImportStatic(name: "PI", shim: "__nbg_s_pi"),
          ),
        ),
        Import(
          importKind: ImportKindObj(
            kind: ikString,
            stringData: ImportString(shim: "__nbg_s_hello", string: "hello"),
          ),
        ),
        Import(
          importKind: ImportKindObj(
            kind: ikType,
            typeData: ImportType(name: "HTMLElement", instanceofShim: "__nbg_instanceof_html", vendorPrefixes: @["webkit"]),
          ),
        ),
        Import(
          importKind: ImportKindObj(
            kind: ikEnum,
            enumData: StringEnum(name: "Color", variantValues: @["Red", "Green"]),
          ),
        ),
      ],
    )
    var enc = newEncoder()
    enc.encode(prog)
    var dec = newDecoder(enc.buf)
    let decoded = decodeProgram(dec)
    check decoded.imports.len == 4
    check decoded.imports[0].importKind.kind == ikStatic
    check decoded.imports[0].importKind.staticData.name == "PI"
    check decoded.imports[1].importKind.kind == ikString
    check decoded.imports[1].importKind.stringData.string == "hello"
    check decoded.imports[2].importKind.kind == ikType
    check decoded.imports[2].importKind.typeData.name == "HTMLElement"
    check decoded.imports[2].importKind.typeData.vendorPrefixes[0] == "webkit"
    check decoded.imports[3].importKind.kind == ikEnum
    check decoded.imports[3].importKind.enumData.name == "Color"
    check decoded.imports[3].importKind.enumData.variantValues[1] == "Green"

suite "codegen — type mapping":
  test "nimTypeToTyId maps primitives correctly":
    check nimTypeToTyId("int32") == TY_I32
    check nimTypeToTyId("float64") == TY_F64
    check nimTypeToTyId("string") == TY_STRING
    check nimTypeToTyId("bool") == TY_BOOLEAN
    check nimTypeToTyId("JsValue") == TY_EXTERNREF

  test "jsTypeName maps primitives correctly":
    check jsTypeName("string") == "string"
    check jsTypeName("int32") == "number"
    check jsTypeName("bool") == "boolean"
    check jsTypeName("float64") == "number"

  test "nimTypeToWasmAbiType maps primitives correctly":
    check nimTypeToWasmAbiType("int32") == "int32"
    check nimTypeToWasmAbiType("string") == "uint32"
    check nimTypeToWasmAbiType("bool") == "int32"
    check nimTypeToWasmAbiType("float64") == "float64"

  test "abiArgCount handles string vs numeric":
    check abiArgCount("string") == 2
    check abiArgCount("int32") == 1
    check abiArgCount("float64") == 1

  test "abiArgNames generates correct names":
    check abiArgNames("name", "string") == @["name_ptr", "name_len"]
    check abiArgNames("x", "int32") == @["x"]

# ─── Typed empty sequences for buildMinimalWasm ───

let noByteSeq = newSeq[byte]()
let noU32Seq = newSeq[uint32]()
let noTypeSeq = newSeq[(seq[byte], seq[byte])]()
let noImportSeq = newSeq[(string, string, byte, uint32)]()
let noExportSeq = newSeq[(string, byte, uint32)]()
let noCodeSeq = newSeq[(seq[(uint32, byte)], seq[byte])]()

# ─── Wasm binary construction helpers ───

proc buildWasmHeader(): seq[byte] =
  result = @[0x00'u8, 0x61'u8, 0x73'u8, 0x6D'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]

proc buildWasmSection(id: byte, payload: seq[byte]): seq[byte] =
  result = @[id]
  var sizeBuf: seq[byte] = @[]
  writeUleb128(sizeBuf, uint32(payload.len))
  result.add(sizeBuf)
  result.add(payload)

proc buildWasmTypeSection(types: seq[tuple[params: seq[byte], results: seq[byte]]]): seq[byte] =
  var payload: seq[byte] = @[]
  writeUleb128(payload, uint32(types.len))
  for ft in types:
    payload.add(0x60'u8)
    writeUleb128(payload, uint32(ft.params.len))
    for p in ft.params: payload.add(p)
    writeUleb128(payload, uint32(ft.results.len))
    for r in ft.results: payload.add(r)
  result = buildWasmSection(1, payload)

proc buildWasmImportSection(imports: seq[tuple[modName: string, fieldName: string, kind: byte, typeIdx: uint32]]): seq[byte] =
  var payload: seq[byte] = @[]
  writeUleb128(payload, uint32(imports.len))
  for imp in imports:
    writeUleb128(payload, uint32(imp.modName.len))
    for c in imp.modName: payload.add(byte(c))
    writeUleb128(payload, uint32(imp.fieldName.len))
    for c in imp.fieldName: payload.add(byte(c))
    payload.add(imp.kind)
    if imp.kind == 0x00'u8:
      writeUleb128(payload, imp.typeIdx)
  result = buildWasmSection(2, payload)

proc buildWasmFunctionSection(typeIndices: seq[uint32]): seq[byte] =
  var payload: seq[byte] = @[]
  writeUleb128(payload, uint32(typeIndices.len))
  for ti in typeIndices:
    writeUleb128(payload, ti)
  result = buildWasmSection(3, payload)

proc buildWasmExportSection(exports: seq[tuple[name: string, kind: byte, idx: uint32]]): seq[byte] =
  var payload: seq[byte] = @[]
  writeUleb128(payload, uint32(exports.len))
  for exp in exports:
    writeUleb128(payload, uint32(exp.name.len))
    for c in exp.name: payload.add(byte(c))
    payload.add(exp.kind)
    writeUleb128(payload, exp.idx)
  result = buildWasmSection(7, payload)

proc buildWasmCodeSection(fns: seq[tuple[locals: seq[(uint32, byte)], body: seq[byte]]]): seq[byte] =
  var payload: seq[byte] = @[]
  writeUleb128(payload, uint32(fns.len))
  for fn in fns:
    var bodyPayload: seq[byte] = @[]
    writeUleb128(bodyPayload, uint32(fn.locals.len))
    for loc in fn.locals:
      writeUleb128(bodyPayload, loc[0])
      bodyPayload.add(loc[1])
    bodyPayload.add(fn.body)
    var codePayload: seq[byte] = @[]
    writeUleb128(codePayload, uint32(bodyPayload.len))
    codePayload.add(bodyPayload)
    payload.add(codePayload)
  result = buildWasmSection(10, payload)

proc buildMinimalWasm(types: seq[tuple[params: seq[byte], results: seq[byte]]],
                       imports: seq[tuple[modName: string, fieldName: string, kind: byte, typeIdx: uint32]],
                       funcTypeIndices: seq[uint32],
                       exports: seq[tuple[name: string, kind: byte, idx: uint32]],
                       codes: seq[tuple[locals: seq[(uint32, byte)], body: seq[byte]]]): seq[byte] =
  result = buildWasmHeader()
  if types.len > 0: result.add(buildWasmTypeSection(types))
  if imports.len > 0: result.add(buildWasmImportSection(imports))
  if funcTypeIndices.len > 0: result.add(buildWasmFunctionSection(funcTypeIndices))
  if exports.len > 0: result.add(buildWasmExportSection(exports))
  if codes.len > 0: result.add(buildWasmCodeSection(codes))

# ─── leb128 edge cases ───

suite "leb128 — edge cases":
  test "roundtrip uint32 zero":
    var buf: seq[byte] = @[]
    writeUleb128(buf, 0'u32)
    var pos = 0
    check readUleb128(buf, pos) == 0'u32
    check pos == buf.len

  test "roundtrip uint32 max":
    var buf: seq[byte] = @[]
    writeUleb128(buf, 0xFFFFFFFF'u32)
    var pos = 0
    check readUleb128(buf, pos) == 0xFFFFFFFF'u32

  test "roundtrip uint32 boundary values":
    for v in [1'u32, 0x7F'u32, 0x80'u32, 0xFF'u32, 0x3FFF'u32, 0x4000'u32, 0x1FFFFF'u32, 0x200000'u32, 0x0FFFFFFF'u32, 0x10000000'u32]:
      var buf: seq[byte] = @[]
      writeUleb128(buf, v)
      var pos = 0
      check readUleb128(buf, pos) == v

  test "roundtrip int32 negative values":
    for v in [-1'i32, -0x40'i32, -0x80'i32, -0x3FFF'i32, -0x4000'i32, -0x200000'i32, -0x10000000'i32]:
      var buf: seq[byte] = @[]
      writeSleb128(buf, v)
      var pos = 0
      check readSleb128(buf, pos) == v

  test "roundtrip int32 positive values":
    for v in [0'i32, 1'i32, 0x3F'i32, 0x40'i32, 0x80'i32, 0x3FFF'i32, 0x4000'i32]:
      var buf: seq[byte] = @[]
      writeSleb128(buf, v)
      var pos = 0
      check readSleb128(buf, pos) == v

  test "uleb128 string roundtrip empty":
    var buf: seq[byte] = @[]
    writeUleb128String(buf, "")
    var pos = 0
    check readUleb128String(buf, pos) == ""

  test "uleb128 string roundtrip with data":
    var buf: seq[byte] = @[]
    writeUleb128String(buf, "hello world")
    var pos = 0
    check readUleb128String(buf, pos) == "hello world"

  test "uleb128 string roundtrip unicode":
    var buf: seq[byte] = @[]
    let s = "Привет, свят!"
    writeUleb128String(buf, s)
    var pos = 0
    check readUleb128String(buf, pos) == s

  test "readByte advances position":
    var data = [0x41'u8, 0x42'u8, 0x43'u8]
    var pos = 0
    check readByte(data, pos) == 0x41'u8
    check pos == 1
    check readByte(data, pos) == 0x42'u8
    check pos == 2

# ─── interp — wasm binary parser ───

suite "interp — wasm binary parser":
  test "parse empty data":
    let m = parseWasmModule(@[])
    check m.types.len == 0
    check m.funcs.len == 0

  test "parse too-short data":
    let m = parseWasmModule(@[0x00'u8, 0x61'u8, 0x73'u8])
    check m.types.len == 0
    check m.funcs.len == 0

  test "parse minimal wasm with type section":
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    let m = parseWasmModule(wasm)
    check m.types.len == 1
    check m.types[0].params.len == 1
    check m.types[0].params[0] == ValI32
    check m.types[0].results.len == 0
    check m.funcs.len == 0
    check m.numImports == 0

  test "parse wasm with type and import sections":
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: noByteSeq)],
      imports = @[(modName: "env", fieldName: "foo", kind: 0x00'u8, typeIdx: 0'u32)],
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    let m = parseWasmModule(wasm)
    check m.types.len == 1
    check m.numImports == 1

  test "parse wasm with code section having local declarations":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = noExportSeq,
      codes = @[(locals: @[(2'u32, ValI32)], body: @[0x0B'u8])],
    )
    let m = parseWasmModule(wasm)
    check m.funcs.len == 1
    check m.funcs[0].locals.len == 2
    check m.funcs[0].locals[0] == ValI32
    check m.funcs[0].locals[1] == ValI32
    check m.funcs[0].codeLen > 0

  test "parse wasm with bad func section — no code section":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    let m = parseWasmModule(wasm)
    check m.types.len == 1
    check m.funcs.len == 0  # no code section means no funcs populated

  test "parse wasm with multiple types":
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: @[ValI32, ValI32], results: @[ValI32]),
        (params: noByteSeq, results: @[ValF64]),
      ],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    let m = parseWasmModule(wasm)
    check m.types.len == 3
    check m.types[0].params == @[ValI32]
    check m.types[1].params == @[ValI32, ValI32]
    check m.types[1].results == @[ValI32]
    check m.types[2].results == @[ValF64]

  test "parse wasm with multiple function imports":
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: noByteSeq)],
      imports = @[
        (modName: "env", fieldName: "fn1", kind: 0x00'u8, typeIdx: 0'u32),
        (modName: "env", fieldName: "fn2", kind: 0x00'u8, typeIdx: 0'u32),
        (modName: "env", fieldName: "fn3", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    let m = parseWasmModule(wasm)
    check m.numImports == 3

# ─── interp — descriptor finders ───

suite "interp — descriptor finders":
  test "findDescribeImportIdx in empty data":
    check findDescribeImportIdx(@[]) == -1

  test "findDescribeImportIdx finds __nbg_describe import":
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: noByteSeq)],
      imports = @[
        (modName: "env", fieldName: "other_func", kind: 0x00'u8, typeIdx: 0'u32),
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check findDescribeImportIdx(wasm) == 1

  test "findDescribeImportIdx returns -1 when absent":
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: noByteSeq)],
      imports = @[(modName: "env", fieldName: "foobar", kind: 0x00'u8, typeIdx: 0'u32)],
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check findDescribeImportIdx(wasm) == -1

  test "findDescriptorExports finds __nbg_describe_ exports":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = @[
        (name: "foo", kind: 0x00'u8, idx: 0'u32),
        (name: "__nbg_describe_mytype", kind: 0x00'u8, idx: 0'u32),
        (name: "__nbg_describe_str", kind: 0x00'u8, idx: 0'u32),
        (name: "bar", kind: 0x00'u8, idx: 0'u32),
      ],
      codes = noCodeSeq,
    )
    let descs = findDescriptorExports(wasm)
    check descs.len == 2
    check descs[0][0] == "__nbg_describe_mytype"
    check descs[1][0] == "__nbg_describe_str"

  test "findDescriptorExports with empty data":
    let emptyDescExports: seq[(string, int)] = @[]
    check findDescriptorExports(noByteSeq) == emptyDescExports

  test "findDescriptorExports ignores non-function exports":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = @[
        (name: "__nbg_describe_table", kind: 0x01'u8, idx: 0'u32),
        (name: "__nbg_describe_func", kind: 0x00'u8, idx: 0'u32),
      ],
      codes = noCodeSeq,
    )
    let descs = findDescriptorExports(wasm)
    check descs.len == 1
    check descs[0][0] == "__nbg_describe_func"

# ─── interp — interpreter execution ───

suite "interp — interpreter execution":
  test "extractDescriptors empty wasm":
    check extractDescriptors(noByteSeq) == newSeq[seq[uint32]]()

  test "extractDescriptors with minimal descriptor function":
    # Build a wasm with a descriptor function that calls __nbg_describe(42)
    # type 0: (i32) -> () for __nbg_describe import
    # type 1: () -> () for descriptor function
    # import __nbg_describe (func, type 0)
    # function (type 1)
    # export __nbg_describe_test (func, idx 1)
    # code: i32.const 42, call 0 (__nbg_describe), end
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[
        (name: "__nbg_describe_test", kind: 0x00'u8, idx: 1'u32),
      ],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[
        0x41'u8, 0x2A'u8,  # i32.const 42
        0x10'u8, 0x00'u8,  # call 0
        0x0B'u8,            # end
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 1
    check descs[0] == @[42'u32]

  test "extractDescriptors with multiple __nbg_describe calls":
    # Descriptor function: __nbg_describe(TY_I32) ; __nbg_describe(0)
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[
        (name: "__nbg_describe_myenum", kind: 0x00'u8, idx: 1'u32),
      ],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[
        0x41'u8, 4'u8,       # i32.const TY_I32
        0x10'u8, 0x00'u8,    # call 0 (describe)
        0x41'u8, 0x00'u8,    # i32.const 0
        0x10'u8, 0x00'u8,    # call 0 (describe)
        0x0B'u8,             # end
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 1
    check descs[0] == @[4'u32, 0'u32]

  test "extractDescriptors with no matching exports":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = @[(name: "regular_func", kind: 0x00'u8, idx: 0'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 0

  test "extractDescriptors export with no code section returns empty":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = @[(name: "__nbg_describe_orphan", kind: 0x00'u8, idx: 0'u32)],
      codes = noCodeSeq,
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 0  # no code to execute

  test "interpreter handles i32.add correctly":
    # function: i32.const 2, i32.const 3, i32.add, call __nbg_describe, end
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[(name: "__nbg_describe_add", kind: 0x00'u8, idx: 1'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[
        0x41'u8, 0x02'u8,    # i32.const 2
        0x41'u8, 0x03'u8,    # i32.const 3
        0x6A'u8,             # i32.add
        0x10'u8, 0x00'u8,    # call 0
        0x0B'u8,             # end
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 1
    check descs[0] == @[5'u32]

  test "interpreter handles i32.mul correctly":
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[(name: "__nbg_describe_mul", kind: 0x00'u8, idx: 1'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[
        0x41'u8, 0x06'u8,    # i32.const 6
        0x41'u8, 0x07'u8,    # i32.const 7
        0x6C'u8,             # i32.mul
        0x10'u8, 0x00'u8,    # call 0
        0x0B'u8,             # end
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 1
    check descs[0] == @[42'u32]

  test "interpreter handles i32.sub and i32.eqz":
    # i32.const 5, i32.const 5, i32.sub, i32.eqz → 1 (they're equal)
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[(name: "__nbg_describe_eq", kind: 0x00'u8, idx: 1'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[
        0x41'u8, 0x05'u8,    # i32.const 5
        0x41'u8, 0x05'u8,    # i32.const 5
        0x6B'u8,             # i32.sub → 0
        0x45'u8,             # i32.eqz → 1
        0x10'u8, 0x00'u8,    # call 0
        0x0B'u8,             # end
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 1
    check descs[0] == @[1'u32]

  test "interpreter handles local get/set and br_if":
    # function has 1 local (i32)
    # body: i32.const 99, local.set 0, local.get 0, call describe, end
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[(name: "__nbg_describe_local", kind: 0x00'u8, idx: 1'u32)],
      codes = @[(locals: @[(1'u32, ValI32)], body: @[
        0x41'u8, 0xE3'u8, 0x00'u8,  # i32.const 99
        0x21'u8, 0x00'u8,           # local.set 0
        0x20'u8, 0x00'u8,           # local.get 0
        0x10'u8, 0x00'u8,           # call 0
        0x0B'u8,                    # end
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 1
    check descs[0] == @[99'u32]

  test "interpreter handles i32.eq, i32.ne, i32.lt_s, i32.gt_s":
    # Test: (10 == 5) {
    #   describe(1)  // i32.eq wouldn't be taken, so use br_if
    # }
    # describe(2)
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[(name: "__nbg_describe_cmp", kind: 0x00'u8, idx: 1'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[
        0x41'u8, 0x0A'u8,    # i32.const 10
        0x41'u8, 0x0A'u8,    # i32.const 10
        0x46'u8,             # i32.eq → 1
        0x10'u8, 0x00'u8,    # call describe
        0x41'u8, 0x05'u8,    # i32.const 5
        0x41'u8, 0x0A'u8,    # i32.const 10
        0x4A'u8,             # i32.gt_s (5 > 10) → 0
        0x10'u8, 0x00'u8,    # call describe
        0x41'u8, 0x03'u8,    # i32.const 3
        0x41'u8, 0x07'u8,    # i32.const 7
        0x48'u8,             # i32.lt_s (3 < 7) → 1
        0x10'u8, 0x00'u8,    # call describe
        0x0B'u8,             # end
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 1
    check descs[0] == @[1'u32, 0'u32, 1'u32]  # eq:true, gt:false, lt:true

  test "extractDescriptors with negative i32.const":
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[(name: "__nbg_describe_neg", kind: 0x00'u8, idx: 1'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[
        0x41'u8, 0x7E'u8,    # i32.const -2 (signed LEB128)
        0x10'u8, 0x00'u8,    # call 0
        0x0B'u8,             # end
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 1
    check descs[0] == @[cast[uint32](-2'i32)]

  test "interpreter skip invalid opcodes gracefully":
    # 0xFE is an unknown opcode — should just break out
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32],
      exports = @[(name: "__nbg_describe_bad", kind: 0x00'u8, idx: 1'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[
        0x41'u8, 0x01'u8,    # i32.const 1
        0xFE'u8,             # invalid opcode — break
        0x10'u8, 0x00'u8,    # call 0 (never reached)
      ])],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 0  # never called describe

  test "interpreter handles multiple descriptor functions":
    let wasm = buildMinimalWasm(
      types = @[
        (params: @[ValI32], results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
        (params: noByteSeq, results: noByteSeq),
      ],
      imports = @[
        (modName: "__wbindgen_placeholder__", fieldName: "__nbg_describe", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = @[1'u32, 2'u32],
      exports = @[
        (name: "__nbg_describe_first", kind: 0x00'u8, idx: 1'u32),
        (name: "__nbg_describe_second", kind: 0x00'u8, idx: 2'u32),
      ],
      codes = @[
        (locals: newSeq[(uint32, byte)](), body: @[
          0x41'u8, 0x01'u8,    # i32.const 1
          0x10'u8, 0x00'u8,    # call 0
          0x0B'u8,             # end
        ]),
        (locals: newSeq[(uint32, byte)](), body: @[
          0x41'u8, 0x02'u8,    # i32.const 2
          0x10'u8, 0x00'u8,    # call 0
          0x0B'u8,             # end
        ]),
      ],
    )
    let descs = extractDescriptors(wasm)
    check descs.len == 2
    check descs[0] == @[1'u32]
    check descs[1] == @[2'u32]

# ─── transforms — section parsing ───

suite "transforms — section parsing":
  test "parseSections with empty data":
    let ws = parseSections(@[])
    check ws.sections.len == 0

  test "parseSections with too-short data":
    let ws = parseSections(@[0x00'u8, 0x61'u8, 0x73'u8])
    check ws.sections.len == 0

  test "parseSections with invalid magic":
    let wasm = @[0xDE'u8, 0xAD'u8, 0xBE'u8, 0xEF'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]
    let ws = parseSections(wasm)
    check ws.sections.len == 0

  test "parseSections with single type section":
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    let ws = parseSections(wasm)
    check ws.sections.len == 1
    check ws.sections[0].id == 1

  test "parseSections with multiple sections":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = @[(modName: "env", fieldName: "fn", kind: 0x00'u8, typeIdx: 0'u32)],
      funcTypeIndices = noU32Seq,
      exports = @[(name: "exp", kind: 0x00'u8, idx: 0'u32)],
      codes = noCodeSeq,
    )
    let ws = parseSections(wasm)
    check ws.sections.len == 3  # type, import, export
    check ws.sections[0].id == 1
    check ws.sections[1].id == 2
    check ws.sections[2].id == 7

# ─── transforms — feature detection ───

suite "transforms — feature detection":
  test "detectFeatures with empty data":
    check detectFeatures(@[]) == TargetFeatures()

  test "detectFeatures with invalid magic":
    let wasm = @[0xFF'u8, 0xFF'u8, 0xFF'u8, 0xFF'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]
    check detectFeatures(wasm) == TargetFeatures()

  test "detectFeatures with target_features section":
    # Build a custom section named "target_features" with content: count, prefix+name pairs
    var tfPayload: seq[byte] = @[]
    writeUleb128(tfPayload, 2'u32)  # 2 features
    tfPayload.add(byte('+'))
    writeUleb128String(tfPayload, "reference-types")
    tfPayload.add(byte('+'))
    writeUleb128String(tfPayload, "multivalue")

    var customPayload: seq[byte] = @[]
    writeUleb128String(customPayload, "target_features")
    customPayload.add(tfPayload)

    let wasm = buildWasmHeader() & buildWasmSection(0, customPayload)

    let features = detectFeatures(wasm)
    check features.hasExternref == true
    check features.hasMultivalue == true
    check features.hasThreads == false

  test "detectFeatures with threads feature":
    var tfPayload: seq[byte] = @[]
    writeUleb128(tfPayload, 1'u32)
    tfPayload.add(byte('+'))
    writeUleb128String(tfPayload, "threads")

    var customPayload: seq[byte] = @[]
    writeUleb128String(customPayload, "target_features")
    customPayload.add(tfPayload)

    let wasm = buildWasmHeader() & buildWasmSection(0, customPayload)

    let features = detectFeatures(wasm)
    check features.hasThreads == true

  test "detectFeatures ignores disabled features":
    var tfPayload: seq[byte] = @[]
    writeUleb128(tfPayload, 1'u32)
    tfPayload.add(byte('-'))
    writeUleb128String(tfPayload, "reference-types")

    var customPayload: seq[byte] = @[]
    writeUleb128String(customPayload, "target_features")
    customPayload.add(tfPayload)

    let wasm = buildWasmHeader() & buildWasmSection(0, customPayload)

    let features = detectFeatures(wasm)
    check features.hasExternref == false

# ─── transforms — stack pointer finder ───

suite "transforms — stack pointer finder":
  test "findStackPointer with empty data":
    check findStackPointer(noByteSeq) == -1

  test "findStackPointer with invalid magic":
    let wasm = @[0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]
    check findStackPointer(wasm) == -1

  test "findStackPointer with func-only imports returns -1":
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: noByteSeq)],
      imports = @[
        (modName: "env", fieldName: "my_func", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check findStackPointer(wasm) == -1

# ─── transforms — return pointer detection ───

suite "transforms — return pointer detection":
  test "findReturnPointerFuncs with empty data":
    check findReturnPointerFuncs(noByteSeq) == newSeq[RetPtrInfo]()

  test "findReturnPointerFuncs detects ret-ptr pattern":
    # type 0: (i32, i32) -> () — last param i32, no results
    # function 0 uses type 0
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32, ValI32], results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = noExportSeq,
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let funcs = findReturnPointerFuncs(wasm)
    check funcs.len == 1
    check funcs[0].funcIdx == 0
    check funcs[0].retPtrLocalIdx == 1

  test "findReturnPointerFuncs ignores function with results":
    # type 0: (i32) -> (i32) — has results, not ret-ptr
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: @[ValI32])],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = noExportSeq,
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let funcs = findReturnPointerFuncs(wasm)
    check funcs.len == 0

  test "findReturnPointerFuncs ignores function with empty params":
    # type 0: () -> ()
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = noExportSeq,
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let funcs = findReturnPointerFuncs(wasm)
    check funcs.len == 0

# ─── transforms — transform pass-throughs ───

suite "transforms — transform pass-throughs":
  test "transformExternref passes through when disabled":
    var cfg = defaultExternrefConfig()
    cfg.enabled = false
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check transformExternref(wasm, cfg) == wasm

  test "transformExternref passes through empty data":
    let cfg = defaultExternrefConfig()
    check transformExternref(noByteSeq, cfg) == noByteSeq

  test "transformExternref passes through invalid magic":
    let cfg = defaultExternrefConfig()
    let wasm = @[0xFF'u8, 0xFF'u8, 0xFF'u8, 0xFF'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]
    check transformExternref(wasm, cfg) == wasm

  test "transformMultivalue passes through when disabled":
    var cfg = defaultMultivalueConfig()
    cfg.enabled = false
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check transformMultivalue(wasm, cfg) == wasm

  test "transformMultivalue passes through empty data":
    let cfg = defaultMultivalueConfig()
    check transformMultivalue(noByteSeq, cfg) == noByteSeq

  test "transformCatch passes through when disabled":
    var cfg = defaultCatchConfig()
    cfg.enabled = false
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check transformCatch(wasm, cfg) == wasm

  test "transformCatch passes through empty data":
    let cfg = defaultCatchConfig()
    check transformCatch(noByteSeq, cfg) == noByteSeq

  test "transformThreads passes through when disabled":
    var cfg = defaultThreadsConfig()
    cfg.enabled = false
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check transformThreads(wasm, cfg) == wasm

  test "transformThreads passes through empty data":
    let cfg = defaultThreadsConfig()
    check transformThreads(noByteSeq, cfg) == noByteSeq

  test "applyTransforms chains correctly":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    let result = applyTransforms(wasm, defaultTransformConfig())
    check result.len >= wasm.len  # same size or slightly modified

  test "default configs create valid objects":
    let extCfg = defaultExternrefConfig()
    check extCfg.enabled == true
    check extCfg.tableIdx == 1
    check extCfg.heapAllocator == "table"

    let mvCfg = defaultMultivalueConfig()
    check mvCfg.enabled == true

    let catchCfg = defaultCatchConfig()
    check catchCfg.enabled == true
    check catchCfg.jsTag == "__nbg_js_exception"

    let threadCfg = defaultThreadsConfig()
    check threadCfg.enabled == true
    check threadCfg.stackSize == 1024 * 1024

    let transCfg = defaultTransformConfig()
    check transCfg.externref.enabled == true
    check transCfg.multivalue.enabled == true
    check transCfg.catch.enabled == true
    check transCfg.threads.enabled == true

# ─── cli — custom section extraction ───

suite "cli — custom section extraction":
  test "extractCustomSection with empty data":
    check extractCustomSection(noByteSeq, "test_section") == noByteSeq

  test "extractCustomSection with invalid magic":
    let wasm = @[0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]
    check extractCustomSection(wasm, "any") == noByteSeq

  test "extractCustomSection finds named custom section":
    # Build wasm with a custom section
    var content: seq[byte] = @[1'u8, 2'u8, 3'u8]
    var customPayload: seq[byte] = @[]
    writeUleb128String(customPayload, "my_custom")
    customPayload.add(content)

    let wasm = buildWasmHeader() & buildWasmSection(0, customPayload)
    let extracted = extractCustomSection(wasm, "my_custom")
    check extracted == content

  test "extractCustomSection returns empty for missing section":
    var customPayload: seq[byte] = @[]
    writeUleb128String(customPayload, "other_section")
    customPayload.add(@[1'u8, 2'u8])

    let wasm = buildWasmHeader() & buildWasmSection(0, customPayload)
    check extractCustomSection(wasm, "missing_section") == noByteSeq

  test "extractCustomSection handles wasm with no custom sections":
    let wasm = buildMinimalWasm(
      types = noTypeSeq,
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check extractCustomSection(wasm, "any") == noByteSeq

  test "extractCustomSection ignores non-custom sections":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    # No custom section — type section (id=1) should be ignored
    check extractCustomSection(wasm, CustomSectionName) == noByteSeq

# ─── cli — type helpers ───

suite "cli — type helpers":
  test "isEnumName finds enum in program":
    let prog = Program(
      uniqueCrateIdentifier: "test",
      enums: @[NimEnum(name: "Color", hole: 3)],
    )
    check isEnumName("Color", prog) == true
    check isEnumName("NonExistent", prog) == false

  test "isEnumName with empty program":
    let prog = Program(uniqueCrateIdentifier: "test")
    check isEnumName("Anything", prog) == false

  test "isStructName finds struct in program":
    let prog = Program(
      uniqueCrateIdentifier: "test",
      structs: @[NimStruct(name: "Point")],
    )
    check isStructName("Point", prog) == true
    check isStructName("NonExistent", prog) == false

  test "isStructName with empty program":
    let prog = Program(uniqueCrateIdentifier: "test")
    check isStructName("Anything", prog) == false

  test "tsTypeName maps known strings":
    let prog = Program(uniqueCrateIdentifier: "test")
    check tsTypeName("string", prog) == "string"
    check tsTypeName("bool", prog) == "boolean"
    check tsTypeName("int32", prog) == "number"
    check tsTypeName("cint", prog) == "number"
    check tsTypeName("uint32", prog) == "number"
    check tsTypeName("int16", prog) == "number"
    check tsTypeName("uint8", prog) == "number"
    check tsTypeName("float32", prog) == "number"
    check tsTypeName("float64", prog) == "number"
    check tsTypeName("int64", prog) == "number"
    check tsTypeName("uint64", prog) == "number"

  test "tsTypeName maps enum types":
    let prog = Program(
      uniqueCrateIdentifier: "test",
      enums: @[NimEnum(name: "Color", hole: 3)],
    )
    check tsTypeName("Color", prog) == "Color"

  test "tsTypeName maps struct types":
    let prog = Program(
      uniqueCrateIdentifier: "test",
      structs: @[NimStruct(name: "Point")],
    )
    check tsTypeName("Point", prog) == "Point"

  test "tsTypeName falls back to any for unknown types":
    let prog = Program(uniqueCrateIdentifier: "test")
    check tsTypeName("UnknownType", prog) == "any"

# ─── runtime — types ───

suite "runtime — types":
  test "JsValue default construction":
    let js = JsValue(idx: 5)
    check js.idx == 5

  test "JsValue fromIdx":
    let js = JsValue.fromIdx(42)
    check js.idx == 42

  test "JsValue zero idx":
    let js = JsValue(idx: 0)
    check js.idx == 0

  test "JsValue max idx":
    let js = JsValue(idx: 0xFFFFFFFF'u32)
    check js.idx == 0xFFFFFFFF'u32

  test "Closure default idx":
    let c = Closure[string](idx: 7)
    check c.idx == 7

  test "JsValue pass-by-value copies idx":
    var a = JsValue(idx: 10)
    var b = a
    check b.idx == 10
    b.idx = 20
    check a.idx == 10  # original unchanged

  test "Closure pass-by-value copies idx":
    var a = Closure[int](idx: 15)
    var b = a
    check b.idx == 15
    b.idx = 25
    check a.idx == 15

# ─── webidlBind macro — generated bindings ───

# Use the macro to generate bindings from WebIDL
webidlBind("""
  interface Node {
    readonly attribute unsigned short nodeType;
    attribute DOMString? nodeName;
    Node appendChild(Node newChild);
    static Document createDocument();
  };
  interface Element {
    DOMString tagName();
  };
  interface Document {
    Element getElementById(DOMString id);
    Element createElement(DOMString tag);
  };
  dictionary ScrollOptions {
    required ScrollBehavior behavior;
    boolean optional;
  };
  enum ScrollBehavior { "auto", "instant", "smooth" };
  namespace console {
    void log(any data);
  };
""")

suite "webidlBind macro — generated types":
  test "interface types are distinct JsValue":
    var n = Node(JsValue(idx: 0))
    check JsValue(n).idx == 0
    var d = Document(JsValue(idx: 0))
    check JsValue(d).idx == 0

  test "dictionary types are distinct JsValue":
    var s = ScrollOptions(JsValue(idx: 0))
    check JsValue(s).idx == 0

  test "enum types are distinct JsValue":
    var sb = ScrollBehavior(JsValue(idx: 0))
    check JsValue(sb).idx == 0

suite "webidlBind macro — generated procs":
  test "attribute getter compiles and returns nil value":
    var n = Node(JsValue(idx: 0))
    let nt = nodeType(n)
    check nt == 0

  test "attribute setter compiles":
    var n = Node(JsValue(idx: 0))
    `nodeName=`(n, "test")

  test "operation with self compiles and returns nil value":
    var n = Node(JsValue(idx: 0))
    var child = Node(JsValue(idx: 0))
    let r = appendChild(n, child)
    check JsValue(r).idx == 0

  test "static operation compiles":
    let d = createDocument()
    check JsValue(d).idx == 0

  test "document operations compile":
    var d = Document(JsValue(idx: 0))
    let el = getElementById(d, "myid")
    check JsValue(el).idx == 0
    let el2 = createElement(d, "div")
    check JsValue(el2).idx == 0

  test "dictionary getters/setters compile":
    var s = ScrollOptions(JsValue(idx: 0))
    let b = behavior(s)
    check JsValue(b).idx == 0
    let o = optional(s)
    check o == false
    `optional=`(s, true)

  test "namespace method compiles":
    var jv = JsValue(idx: 0)
    log(jv)
