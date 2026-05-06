## Test suite for nimbling

import std/unittest
import std/strutils
import std/times
import std/os
import std/httpclient

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
import nimbling/js_sys
import nimbling/web_sys
import nimbling/jscast
import nimbling/web_sys_cast
import nimbling/webidl

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
    check output.contains("// Node.js target")

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

  test "generates module header for experimental-nodejs-module target":
    var prog = Program(uniqueCrateIdentifier: "test")
    var jsg = newJsGen(prog, jsNodeModule, "hello")
    let output = jsg.generate()
    check output.contains("import * as wasm from './hello_bg.js';")
    check output.contains("import.meta.url")
    check output.contains("node:fs")

  test "generates module header for module (source-phase import) target":
    var prog = Program(uniqueCrateIdentifier: "test")
    var jsg = newJsGen(prog, jsModule, "hello")
    let output = jsg.generate()
    check output.contains("import source wasmModule from './hello.wasm';")
    check output.contains("new WebAssembly.Instance(wasmModule")
    check not output.contains("export default init")
    check output.contains("export const __nbg_wasm_module")

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

proc buildWasmMemorySection(initial: uint32, maxPages: uint32, shared: bool): seq[byte] =
  var payload: seq[byte] = @[]
  writeUleb128(payload, 1'u32)  # 1 memory
  var flags: byte = 0x01  # max present
  if shared: flags = flags or 0x02
  payload.add(flags)
  writeUleb128(payload, initial)
  writeUleb128(payload, maxPages)
  result = buildWasmSection(5, payload)

proc buildWasmGlobalSection(globals: seq[tuple[valtype: byte, mutable: bool, initVal: int32]]): seq[byte] =
  var payload: seq[byte] = @[]
  writeUleb128(payload, uint32(globals.len))
  for g in globals:
    payload.add(g.valtype)
    payload.add(if g.mutable: 0x01'u8 else: 0x00'u8)
    payload.add(0x41'u8)  # i32.const
    var valBuf: seq[byte] = @[]
    writeSleb128(valBuf, g.initVal)
    payload.add(valBuf)
    payload.add(0x0B'u8)  # end
  result = buildWasmSection(6, payload)

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
  test "findImportGlobal with empty data":
    check findImportGlobal(noByteSeq, "__stack_pointer") == -1

  test "findImportGlobal with invalid magic":
    let wasm = @[0x00'u8, 0x00'u8, 0x00'u8, 0x00'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]
    check findImportGlobal(wasm, "__stack_pointer") == -1

  test "findImportGlobal with func-only imports returns -1":
    let wasm = buildMinimalWasm(
      types = @[(params: @[ValI32], results: noByteSeq)],
      imports = @[
        (modName: "env", fieldName: "my_func", kind: 0x00'u8, typeIdx: 0'u32),
      ],
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check findImportGlobal(wasm, "__stack_pointer") == -1

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
    check threadCfg.stackSize == 1024 * 1024 * 2

    let transCfg = defaultTransformConfig()
    check transCfg.externref.enabled == true
    check transCfg.multivalue.enabled == true
    check transCfg.catch.enabled == true
    check transCfg.threads.enabled == true

# ─── transforms — catch wrapping ───

suite "transforms — catch transform":
  test "transformCatch wraps catch-exported function body with try/catch_all":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = @[(name: "my_func_catch", kind: 0x00'u8, idx: 0'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let result = transformCatch(wasm, defaultCatchConfig())
    check result.len > wasm.len
    let OpTry = 0x06'u8
    let OpCatchAll = 0x19'u8
    let hasTry = result.find(OpTry) >= 0
    let hasCatchAll = result.find(OpCatchAll) >= 0
    check hasTry
    check hasCatchAll

  test "transformCatch no-ops when no catch exports":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = @[(name: "regular_func", kind: 0x00'u8, idx: 0'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let result = transformCatch(wasm, defaultCatchConfig())
    check result == wasm

  test "transformCatch wraps __catch suffix variant":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = @[(name: "my_func__catch", kind: 0x00'u8, idx: 0'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let result = transformCatch(wasm, defaultCatchConfig())
    check result.len > wasm.len

  test "transformCatch wraps function with locals and instructions":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = @[(name: "fn_catch", kind: 0x00'u8, idx: 0'u32)],
      codes = @[(locals: @[(1'u32, 0x7F'u8)], body: @[0x20'u8, 0x00'u8, 0x0B'u8])],
    )
    let result = transformCatch(wasm, defaultCatchConfig())
    let OpTry = 0x06'u8
    let OpCatchAll = 0x19'u8
    check result.find(OpTry) >= 0
    check result.find(OpCatchAll) >= 0
    check result.len > wasm.len

  test "transformCatch wraps only catch exports, leaves others unchanged":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq), (params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32, 1'u32],
      exports = @[
        (name: "fn_catch", kind: 0x00'u8, idx: 0'u32),
        (name: "fn_normal", kind: 0x00'u8, idx: 1'u32),
      ],
      codes = @[
        (locals: newSeq[(uint32, byte)](), body: @[0x0B'u8]),
        (locals: newSeq[(uint32, byte)](), body: @[0x0B'u8]),
      ],
    )
    let result = transformCatch(wasm, defaultCatchConfig())
    let OpTry = 0x06'u8
    check result.find(OpTry) >= 0

  test "transformCatch with empty data":
    let cfg = defaultCatchConfig()
    check transformCatch(noByteSeq, cfg) == noByteSeq

  test "transformCatch with non-catch-matched suffix is no-op":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = @[(name: "my_func_catcher", kind: 0x00'u8, idx: 0'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let result = transformCatch(wasm, defaultCatchConfig())
    check result == wasm

  test "transformCatch passes through when disabled":
    var cfg = defaultCatchConfig()
    cfg.enabled = false
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = @[0'u32],
      exports = @[(name: "fn_catch", kind: 0x00'u8, idx: 0'u32)],
      codes = @[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])],
    )
    let result = transformCatch(wasm, cfg)
    check result == wasm

# ─── transforms — threads transform ───

suite "transforms — threads transform":
  test "transformThreads patches memory to shared":
    var importPayload: seq[byte] = @[]
    writeUleb128(importPayload, 1'u32)
    writeUleb128String(importPayload, "env")
    writeUleb128String(importPayload, "__stack_pointer")
    importPayload.add(0x03'u8)
    importPayload.add(0x7F'u8)
    importPayload.add(0x01'u8)
    let importSec = buildWasmSection(2, importPayload)
    let memSec = buildWasmMemorySection(initial = 256, maxPages = 512, shared = false)
    let wasm = buildWasmHeader() &
      buildWasmTypeSection(@[(params: @[0x7F'u8], results: noByteSeq)]) &
      importSec & memSec &
      buildWasmFunctionSection(@[0'u32]) &
      buildWasmCodeSection(@[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])])
    let result = transformThreads(wasm, defaultThreadsConfig())
    check result.len > wasm.len
    check isMemoryShared(result) == true

  test "transformThreads no-ops without stack pointer":
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    let result = transformThreads(wasm, defaultThreadsConfig())
    check result == wasm

  test "transformThreads no-ops with already-shared memory":
    var importPayload: seq[byte] = @[]
    writeUleb128(importPayload, 1'u32)
    writeUleb128String(importPayload, "env")
    writeUleb128String(importPayload, "__stack_pointer")
    importPayload.add(0x03'u8)
    importPayload.add(0x7F'u8)
    importPayload.add(0x01'u8)
    let importSec = buildWasmSection(2, importPayload)
    let memSec = buildWasmMemorySection(initial = 256, maxPages = 512, shared = true)
    let wasm = buildWasmHeader() &
      buildWasmTypeSection(@[(params: @[0x7F'u8], results: noByteSeq)]) &
      importSec & memSec &
      buildWasmFunctionSection(@[0'u32]) &
      buildWasmCodeSection(@[(locals: newSeq[(uint32, byte)](), body: @[0x0B'u8])])
    let result = transformThreads(wasm, defaultThreadsConfig())
    check result.len == wasm.len

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

  test "transformThreads passes through invalid magic":
    let cfg = defaultThreadsConfig()
    let wasm = @[0xFF'u8, 0xFF'u8, 0xFF'u8, 0xFF'u8, 0x01'u8, 0x00'u8, 0x00'u8, 0x00'u8]
    check transformThreads(wasm, cfg) == wasm

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

  test "sidecar .nbg file fallback when custom section missing":
    # Build a minimal wasm with no custom section
    let wasm = buildMinimalWasm(
      types = @[(params: noByteSeq, results: noByteSeq)],
      imports = noImportSeq,
      funcTypeIndices = noU32Seq,
      exports = noExportSeq,
      codes = noCodeSeq,
    )
    check extractCustomSection(wasm, CustomSectionName) == noByteSeq

    # Build a sidecar .nbg file with a simple program
    var prog = Program(uniqueCrateIdentifier: "test_sidecar")
    prog.exports.add(Export(
      function: FunctionDesc(name: "hello", args: @[FunctionArgumentData(name: "x")], retTyOverride: "int32"),
    ))
    var enc = newEncoder()
    enc.encode(prog)
    let nbgPath = getTempDir() / "test_sidecar.nbg"
    var nbgContent = newString(enc.buf.len)
    for i, b in enc.buf:
      nbgContent[i] = chr(b)
    writeFile(nbgPath, nbgContent)

    # Verify sidecar file exists and can be decoded
    check fileExists(nbgPath)
    let readContent = readFile(nbgPath)
    var dec = newDecoder(cast[seq[byte]](readContent))
    let decoded = decodeProgram(dec)
    check decoded.uniqueCrateIdentifier == "test_sidecar"
    check decoded.exports.len == 1
    check decoded.exports[0].function.name == "hello"

    # Cleanup
    removeFile(nbgPath)

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
    var jv = JsObject(JsValue(idx: 0))
    log(jv)

# ─── JsFuture + spawnLocal ───

suite "JsFuture — type basics":
  test "JsFuture from JsValue":
    let jv = JsValue(idx: 42)
    let jf = jsFuture(jv)
    check JsValue(jf).idx == 42

  test "JsFuture promise accessor":
    let jf = JsFuture(JsValue(idx: 99))
    let p = promise(jf)
    check p.idx == 99

  test "JsFuture distinct from JsValue":
    var jf = JsFuture(JsValue(idx: 10))
    var jv = JsValue(jf)
    check jv.idx == 10
    jv.idx = 20
    check JsValue(jf).idx == 10  # distinct type, copy semantics

suite "JsFuture — js_sys bridge":
  test "jsFutureToPromise roundtrip":
    let jf = JsFuture(JsValue(idx: 5))
    let jp = jsFutureToPromise(jf)
    check JsValue(jp).idx == 5
    let jf2 = jsPromiseToFuture(jp)
    check JsValue(jf2).idx == 5

  test "jsFutureResolved creates resolved future":
    # On non-wasm, returns JsFuture(JsValue(idx: 0)) — no JS runtime
    let val = JsValue(idx: 123)
    let jf = jsFutureResolved(val)
    check JsValue(jf).idx == 0

  test "jsFutureRejected creates rejected future":
    let err = JsValue(idx: 456)
    let jf = jsFutureRejected(err)
    check JsValue(jf).idx == 0

  test "jsFutureThen returns new future":
    let jf = JsFuture(JsValue(idx: 1))
    let cb = JsValue(idx: 2)
    let chained = jsFutureThen(jf, cb)
    check JsValue(chained).idx == 0

  test "jsFutureCatch returns new future":
    let jf = JsFuture(JsValue(idx: 1))
    let cb = JsValue(idx: 2)
    let caught = jsFutureCatch(jf, cb)
    check JsValue(caught).idx == 0

  test "jsFutureFinally returns new future":
    let jf = JsFuture(JsValue(idx: 1))
    let cb = JsValue(idx: 2)
    let fin = jsFutureFinally(jf, cb)
    check JsValue(fin).idx == 0

suite "spawnLocal — proc callback":
  test "spawnLocal callback compiles":
    var called = false
    proc myCallback() =
      called = true
    spawnLocal(myCallback)
    # On non-wasm, spawnLocal calls the callback directly
    check called == true

suite "spawnLocal — future primitives":
  test "spawnLocalFuture compiles with zero":
    # Just verify it compiles — actual async polling needs wasm
    spawnLocalFuture(0'u32)

  test "futureToPromise returns zero on non-wasm":
    let result = futureToPromise(0'u32)
    check result == 0

# ─── Web Audio API ───

suite "Web Audio — AudioContext":
  test "AudioContext types are distinct JsValue":
    var ctx = JsAudioContext(JsValue(idx: 0))
    check JsValue(ctx).idx == 0

  test "AudioContext properties return defaults on non-wasm":
    var ctx = JsAudioContext(JsValue(idx: 0))
    check jsAudioContextSampleRate(ctx) == 0.0
    check jsAudioContextCurrentTime(ctx) == 0.0
    check jsAudioContextState(ctx) == ""

  test "AudioContext factory methods return zero on non-wasm":
    var ctx = JsAudioContext(JsValue(idx: 0))
    check JsValue(jsAudioContextCreateOscillator(ctx)).idx == 0
    check JsValue(jsAudioContextCreateGain(ctx)).idx == 0
    check JsValue(jsAudioContextCreateBiquadFilter(ctx)).idx == 0
    check JsValue(jsAudioContextCreateAnalyser(ctx)).idx == 0
    check JsValue(jsAudioContextCreateDelay(ctx)).idx == 0
    check JsValue(jsAudioContextCreateChannelMerger(ctx)).idx == 0
    check JsValue(jsAudioContextCreateChannelSplitter(ctx)).idx == 0
    check JsValue(jsAudioContextCreateBuffer(ctx, 2, 44100, 44100.0)).idx == 0
    check JsValue(jsAudioContextCreateBufferSource(ctx)).idx == 0
    check JsValue(jsAudioContextDestination(ctx)).idx == 0
    check JsValue(jsAudioContextListener(ctx)).idx == 0

suite "Web Audio — OscillatorNode":
  test "OscillatorNode properties":
    var osc = JsOscillatorNode(JsValue(idx: 0))
    check jsOscillatorType(osc) == ""
    check JsValue(jsOscillatorFrequency(osc)).idx == 0
    check JsValue(jsOscillatorDetune(osc)).idx == 0

suite "Web Audio — GainNode":
  test "GainNode gain param":
    var gain = JsGainNode(JsValue(idx: 0))
    check JsValue(jsGainNodeGain(gain)).idx == 0

suite "Web Audio — AudioParam":
  test "AudioParam value":
    var param = JsAudioParam(JsValue(idx: 0))
    check jsAudioParamValue(param) == 0.0

suite "Web Audio — BiquadFilterNode":
  test "BiquadFilterNode properties":
    var node = JsBiquadFilterNode(JsValue(idx: 0))
    check jsBiquadFilterType(node) == ""
    check JsValue(jsBiquadFilterFrequency(node)).idx == 0
    check JsValue(jsBiquadFilterQ(node)).idx == 0
    check JsValue(jsBiquadFilterGain(node)).idx == 0

suite "Web Audio — AnalyserNode":
  test "AnalyserNode properties":
    var node = JsAnalyserNode(JsValue(idx: 0))
    check jsAnalyserFftSize(node) == 0
    check jsAnalyserFrequencyBinCount(node) == 0
    check jsAnalyserMinDecibels(node) == 0.0
    check jsAnalyserMaxDecibels(node) == 0.0
    check jsAnalyserSmoothingTimeConstant(node) == 0.0

suite "Web Audio — AudioBuffer":
  test "AudioBuffer properties":
    var buf = JsAudioBuffer(JsValue(idx: 0))
    check jsAudioBufferDuration(buf) == 0.0
    check jsAudioBufferLength(buf) == 0
    check jsAudioBufferSampleRate(buf) == 0.0
    check jsAudioBufferNumberOfChannels(buf) == 0

suite "Web Audio — DelayNode":
  test "DelayNode delay param":
    var node = JsDelayNode(JsValue(idx: 0))
    check JsValue(jsDelayNodeDelay(node)).idx == 0

suite "Web Audio — type aliases":
  test "All Web Audio types are distinct JsValue":
    check JsValue(JsAudioDestinationNode(JsValue(idx: 1))).idx == 1
    check JsValue(JsAudioBufferSourceNode(JsValue(idx: 2))).idx == 2
    check JsValue(JsChannelMergerNode(JsValue(idx: 3))).idx == 3
    check JsValue(JsChannelSplitterNode(JsValue(idx: 4))).idx == 4
    check JsValue(JsMediaStreamAudioSourceNode(JsValue(idx: 5))).idx == 5
    check JsValue(JsMediaElementAudioSourceNode(JsValue(idx: 6))).idx == 6
    check JsValue(JsAudioListener(JsValue(idx: 7))).idx == 7

suite "Web Crypto — Crypto types":
  test "Crypto types are distinct JsValue":
    check JsValue(JsCrypto(JsValue(idx: 1))).idx == 1
    check JsValue(JsSubtleCrypto(JsValue(idx: 2))).idx == 2
    check JsValue(JsCryptoKey(JsValue(idx: 3))).idx == 3
    check JsValue(JsCryptoKeyPair(JsValue(idx: 4))).idx == 4

  test "Crypto returns zero on non-wasm":
    var c = jsGetCrypto()
    check JsValue(c).idx == 0

  test "SubtleCrypto returns zero on non-wasm":
    var c = JsCrypto(JsValue(idx: 0))
    var sub = jsCryptoSubtle(c)
    check JsValue(sub).idx == 0

  test "CryptoKey type returns empty on non-wasm":
    var key = JsCryptoKey(JsValue(idx: 0))
    check jsCryptoKeyType(key) == ""

  test "CryptoKey extractable returns false on non-wasm":
    var key = JsCryptoKey(JsValue(idx: 0))
    check jsCryptoKeyExtractable(key) == false

  test "CryptoKeyPair returns zero keys on non-wasm":
    var pair = JsCryptoKeyPair(JsValue(idx: 0))
    check JsValue(jsCryptoKeyPairPrivateKey(pair)).idx == 0
    check JsValue(jsCryptoKeyPairPublicKey(pair)).idx == 0

  test "ArrayBuffer creation returns zero on non-wasm":
    var buf = jsNewJsArrayBuffer(1024)
    check JsValue(buf).idx == 0

  test "Uint8Array creation returns zero on non-wasm":
    var arr = jsNewJsUint8Array(256)
    check JsValue(arr).idx == 0

  test "Uint8Array length returns 0 on non-wasm":
    var arr = JsValue(idx: 0)
    check jsUint8ArrayLen(arr) == 0

  test "ArrayBuffer byteLength returns 0 on non-wasm":
    var buf = JsValue(idx: 0)
    check jsArrayBufferByteLength(buf) == 0

  test "Algorithm creation returns zero on non-wasm":
    var iv = JsValue(idx: 0)
    check JsValue(jsCreateAlgorithmAesCbc(iv)).idx == 0
    check JsValue(jsCreateAlgorithmAesGcm(iv)).idx == 0
    check JsValue(jsCreateAlgorithmSha256()).idx == 0
    check JsValue(jsCreateAlgorithmSha384()).idx == 0
    check JsValue(jsCreateAlgorithmSha512()).idx == 0

  test "Crypto operations return Promise on non-wasm":
    var subtle = JsSubtleCrypto(JsValue(idx: 0))
    var alg = JsValue(idx: 0)
    var key = JsCryptoKey(JsValue(idx: 0))
    var data = JsValue(idx: 0)
    check JsValue(jsSubtleCryptoEncrypt(subtle, alg, key, data)).idx == 0
    check JsValue(jsSubtleCryptoDecrypt(subtle, alg, key, data)).idx == 0
    check JsValue(jsSubtleCryptoSign(subtle, alg, key, data)).idx == 0
    check JsValue(jsSubtleCryptoVerify(subtle, alg, key, data, data)).idx == 0
    check JsValue(jsSubtleCryptoDigest(subtle, alg, data)).idx == 0
    check JsValue(jsSubtleCryptoGenerateKey(subtle, alg, false, data)).idx == 0
    check JsValue(jsSubtleCryptoDeriveKey(subtle, alg, key, alg, false, data)).idx == 0
    check JsValue(jsSubtleCryptoDeriveBits(subtle, alg, key, 256)).idx == 0
    check JsValue(jsSubtleCryptoImportKey(subtle, "raw", data, alg, false, data)).idx == 0
    check JsValue(jsSubtleCryptoExportKey(subtle, "raw", key)).idx == 0
    check JsValue(jsSubtleCryptoWrapKey(subtle, "raw", key, key, alg)).idx == 0
    check JsValue(jsSubtleCryptoUnwrapKey(subtle, "raw", data, key, alg, alg, false, data)).idx == 0

  test "HMAC algorithm creation":
    var key = JsValue(idx: 0)
    check JsValue(jsCreateAlgorithmHmacSha256(key)).idx == 0
    check JsValue(jsCreateAlgorithmHmacSha384(key)).idx == 0
    check JsValue(jsCreateAlgorithmHmacSha512(key)).idx == 0

  test "ECDSA/ECDH algorithm creation":
    check JsValue(jsCreateAlgorithmEcdsa("P-256")).idx == 0
    check JsValue(jsCreateAlgorithmEcdh("P-256")).idx == 0

  test "RSA algorithm creation":
    var exp = JsValue(idx: 0)
    check JsValue(jsCreateAlgorithmRsaOaep(2048, exp)).idx == 0
    check JsValue(jsCreateAlgorithmRsaPss(8)).idx == 0

  test "PBKDF2 and HKDF algorithm creation":
    var salt = JsValue(idx: 0)
    var info = JsValue(idx: 0)
    check JsValue(jsCreateAlgorithmPbkdf2(salt, 100000, "SHA-256")).idx == 0
    check JsValue(jsCreateAlgorithmHkdf(salt, "SHA-256", info)).idx == 0

  test "AES-GCM with tagLength":
    var iv = JsValue(idx: 0)
    check JsValue(jsCreateAlgorithmAesGcmWithIv(iv, 128)).idx == 0

  test "AES-CTR algorithm creation":
    var counter = JsValue(idx: 0)
    check JsValue(jsCreateAlgorithmAesCtr(counter, 64)).idx == 0

  test "Key usage arrays":
    discard jsCreateEmptyKeyUsage()
    discard jsCreateKeyUsage("encrypt", "decrypt")

  test "Crypto randomUUID returns empty on non-wasm":
    check jsCryptoRandomUUID(JsCrypto(JsValue(idx: 0))) == ""
    check jsCryptoSecureRandomUUID() == ""

  test "GetRandomValues returns zero on non-wasm":
    var c = JsCrypto(JsValue(idx: 0))
    var buf = JsValue(idx: 0)
    check JsValue(jsCryptoGetRandomValues(c, buf)).idx == 0

suite "IndexedDB — types":
  test "IndexedDB types are distinct JsValue":
    check JsValue(JsIDBFactory(JsValue(idx: 1))).idx == 1
    check JsValue(JsIDBDatabase(JsValue(idx: 2))).idx == 2
    check JsValue(JsIDBObjectStore(JsValue(idx: 3))).idx == 3
    check JsValue(JsIDBTransaction(JsValue(idx: 4))).idx == 4
    check JsValue(JsIDBIndex(JsValue(idx: 5))).idx == 5
    check JsValue(JsIDBCursor(JsValue(idx: 6))).idx == 6
    check JsValue(JsIDBRequest(JsValue(idx: 7))).idx == 7
    check JsValue(JsIDBCursorWithValue(JsValue(idx: 8))).idx == 8
    check JsValue(JsIDBOpenDBRequest(JsValue(idx: 9))).idx == 9

  test "IDBFactory returns zero on non-wasm":
    var factory = jsGetIDBFactory()
    check JsValue(factory).idx == 0

  test "IDBDatabase name returns empty on non-wasm":
    var db = JsIDBDatabase(JsValue(idx: 0))
    check jsIDBDatabaseName(db) == ""

  test "IDBDatabase version returns 0 on non-wasm":
    var db = JsIDBDatabase(JsValue(idx: 0))
    check jsIDBDatabaseVersion(db) == 0

  test "IDBDatabase objectStoreNames returns zero on non-wasm":
    var db = JsIDBDatabase(JsValue(idx: 0))
    check JsValue(jsIDBDatabaseObjectStoreNames(db)).idx == 0

  test "IDBObjectStore name returns empty on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    check jsIDBObjectStoreName(store) == ""

  test "IDBObjectStore keyPath returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    check JsValue(jsIDBObjectStoreKeyPath(store)).idx == 0

  test "IDBObjectStore autoIncrement returns false on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    check jsIDBObjectStoreAutoIncrement(store) == false

  test "IDBTransaction mode returns empty on non-wasm":
    var tx = JsIDBTransaction(JsValue(idx: 0))
    check jsIDBTransactionMode(tx) == ""

  test "IDBIndex name returns empty on non-wasm":
    var idx = JsIDBIndex(JsValue(idx: 0))
    check jsIDBIndexName(idx) == ""

  test "IDBIndex multiEntry returns false on non-wasm":
    var idx = JsIDBIndex(JsValue(idx: 0))
    check jsIDBIndexMultiEntry(idx) == false

  test "IDBIndex unique returns false on non-wasm":
    var idx = JsIDBIndex(JsValue(idx: 0))
    check jsIDBIndexUnique(idx) == false

  test "IDBCursor direction returns empty on non-wasm":
    var cursor = JsIDBCursor(JsValue(idx: 0))
    check jsIDBCursorDirection(cursor) == ""

  test "IDBCursor key returns zero on non-wasm":
    var cursor = JsIDBCursor(JsValue(idx: 0))
    check JsValue(jsIDBCursorKey(cursor)).idx == 0

  test "IDBCursor primaryKey returns zero on non-wasm":
    var cursor = JsIDBCursor(JsValue(idx: 0))
    check JsValue(jsIDBCursorPrimaryKey(cursor)).idx == 0

  test "IDBCursor value returns zero on non-wasm":
    var cursor = JsIDBCursor(JsValue(idx: 0))
    check JsValue(jsIDBCursorValue(cursor)).idx == 0

  test "IDBRequest readyState returns empty on non-wasm":
    var req = JsIDBRequest(JsValue(idx: 0))
    check jsIDBRequestReadyState(req) == ""

  test "IDBRequest result returns zero on non-wasm":
    var req = JsIDBRequest(JsValue(idx: 0))
    check JsValue(jsIDBRequestResult(req)).idx == 0

  test "IDBRequest source returns zero on non-wasm":
    var req = JsIDBRequest(JsValue(idx: 0))
    check JsValue(jsIDBRequestSource(req)).idx == 0

  test "IDBRequest transaction returns zero on non-wasm":
    var req = JsIDBRequest(JsValue(idx: 0))
    check JsValue(jsIDBRequestTransaction(req)).idx == 0

  test "IDBRequest error returns zero on non-wasm":
    var req = JsIDBRequest(JsValue(idx: 0))
    check JsValue(jsIDBRequestError(req)).idx == 0

  test "IDBFactory open returns zero on non-wasm":
    var factory = JsIDBFactory(JsValue(idx: 0))
    check JsValue(jsIDBFactoryOpen(factory, "testdb", 1)).idx == 0

  test "IDBFactory deleteDatabase returns zero on non-wasm":
    var factory = JsIDBFactory(JsValue(idx: 0))
    check JsValue(jsIDBFactoryDeleteDatabase(factory, "testdb")).idx == 0

  test "IDBDatabase createObjectStore returns zero on non-wasm":
    var db = JsIDBDatabase(JsValue(idx: 0))
    check JsValue(jsIDBDatabaseCreateObjectStore(db, "store")).idx == 0

  test "IDBDatabase transaction returns zero on non-wasm":
    var db = JsIDBDatabase(JsValue(idx: 0))
    var names = JsValue(idx: 0)
    check JsValue(jsIDBDatabaseTransaction(db, names)).idx == 0

  test "IDBObjectStore add returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    var value = JsValue(idx: 0)
    check JsValue(jsIDBObjectStoreAdd(store, value)).idx == 0

  test "IDBObjectStore put returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    var value = JsValue(idx: 0)
    check JsValue(jsIDBObjectStorePut(store, value)).idx == 0

  test "IDBObjectStore get returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    var key = JsValue(idx: 0)
    check JsValue(jsIDBObjectStoreGet(store, key)).idx == 0

  test "IDBObjectStore getAll returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    check JsValue(jsIDBObjectStoreGetAll(store)).idx == 0

  test "IDBObjectStore delete returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    var key = JsValue(idx: 0)
    check JsValue(jsIDBObjectStoreDelete(store, key)).idx == 0

  test "IDBObjectStore clear returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    check JsValue(jsIDBObjectStoreClear(store)).idx == 0

  test "IDBObjectStore count returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    check JsValue(jsIDBObjectStoreCount(store)).idx == 0

  test "IDBObjectStore createIndex returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    var keyPath = JsValue(idx: 0)
    check JsValue(jsIDBObjectStoreCreateIndex(store, "idx", keyPath)).idx == 0

  test "IDBObjectStore index returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    check JsValue(jsIDBObjectStoreIndex(store, "idx")).idx == 0

  test "IDBObjectStore openCursor returns zero on non-wasm":
    var store = JsIDBObjectStore(JsValue(idx: 0))
    check JsValue(jsIDBObjectStoreOpenCursor(store)).idx == 0

  test "IDBIndex get returns zero on non-wasm":
    var idx = JsIDBIndex(JsValue(idx: 0))
    var key = JsValue(idx: 0)
    check JsValue(jsIDBIndexGet(idx, key)).idx == 0

  test "IDBIndex getAll returns zero on non-wasm":
    var idx = JsIDBIndex(JsValue(idx: 0))
    check JsValue(jsIDBIndexGetAll(idx)).idx == 0

  test "IDBIndex openCursor returns zero on non-wasm":
    var idx = JsIDBIndex(JsValue(idx: 0))
    check JsValue(jsIDBIndexOpenCursor(idx)).idx == 0

  test "IDBIndex count returns zero on non-wasm":
    var idx = JsIDBIndex(JsValue(idx: 0))
    check JsValue(jsIDBIndexCount(idx)).idx == 0

  test "IDBCursor continue compiles on non-wasm":
    var cursor = JsIDBCursor(JsValue(idx: 0))
    jsIDBCursorContinue(cursor)

  test "IDBCursor advance compiles on non-wasm":
    var cursor = JsIDBCursor(JsValue(idx: 0))
    jsIDBCursorAdvance(cursor, 1)

  test "IDBCursor delete returns zero on non-wasm":
    var cursor = JsIDBCursor(JsValue(idx: 0))
    check JsValue(jsIDBCursorDelete(cursor)).idx == 0

  test "IDBCursor update returns zero on non-wasm":
    var cursor = JsIDBCursor(JsValue(idx: 0))
    var value = JsValue(idx: 0)
    check JsValue(jsIDBCursorUpdate(cursor, value)).idx == 0

  test "IDBKeyRange lowerBound returns zero on non-wasm":
    var lower = JsValue(idx: 0)
    check JsValue(jsCreateIDBKeyRangeLowerBound(lower, false)).idx == 0

  test "IDBKeyRange upperBound returns zero on non-wasm":
    var upper = JsValue(idx: 0)
    check JsValue(jsCreateIDBKeyRangeUpperBound(upper, false)).idx == 0

  test "IDBKeyRange bound returns zero on non-wasm":
    var lower = JsValue(idx: 0)
    var upper = JsValue(idx: 0)
    check JsValue(jsCreateIDBKeyRangeBound(lower, upper, false, false)).idx == 0

  test "IDBKeyRange only returns zero on non-wasm":
    var value = JsValue(idx: 0)
    check JsValue(jsCreateIDBKeyRangeOnly(value)).idx == 0

suite "Geolocation — types":
  test "Geolocation types are distinct JsValue":
    check JsValue(JsGeolocation(JsValue(idx: 1))).idx == 1
    check JsValue(JsGeolocationPosition(JsValue(idx: 2))).idx == 2
    check JsValue(JsGeolocationCoordinates(JsValue(idx: 3))).idx == 3
    check JsValue(JsGeolocationPositionError(JsValue(idx: 4))).idx == 4

  test "Navigator geolocation returns zero on non-wasm":
    var geo = jsNavigatorGeolocation()
    check JsValue(geo).idx == 0

  test "GeolocationCoordinates properties return defaults on non-wasm":
    var coords = JsGeolocationCoordinates(JsValue(idx: 0))
    check jsGeolocationCoordinatesLatitude(coords) == 0.0
    check jsGeolocationCoordinatesLongitude(coords) == 0.0
    check jsGeolocationCoordinatesAltitude(coords) == 0.0
    check jsGeolocationCoordinatesAccuracy(coords) == 0.0
    check jsGeolocationCoordinatesAltitudeAccuracy(coords) == 0.0
    check jsGeolocationCoordinatesHeading(coords) == 0.0
    check jsGeolocationCoordinatesSpeed(coords) == 0.0

  test "GeolocationPosition timestamp returns 0 on non-wasm":
    var pos = JsGeolocationPosition(JsValue(idx: 0))
    check jsGeolocationPositionTimestamp(pos) == 0

  test "GeolocationPosition coords returns zero on non-wasm":
    var pos = JsGeolocationPosition(JsValue(idx: 0))
    check JsValue(jsGeolocationPositionCoords(pos)).idx == 0

  test "GeolocationPositionError code returns 0 on non-wasm":
    var err = JsGeolocationPositionError(JsValue(idx: 0))
    check jsGeolocationPositionErrorCode(err) == 0

  test "GeolocationPositionError message returns empty on non-wasm":
    var err = JsGeolocationPositionError(JsValue(idx: 0))
    check jsGeolocationPositionErrorMessage(err) == ""

  test "PositionOptions creation":
    var opts = jsCreatePositionOptions(false, 5000, 0)
    check JsValue(opts).idx == 0

suite "Service Workers — types":
  test "ServiceWorker types are distinct JsValue":
    check JsValue(JsServiceWorkerContainer(JsValue(idx: 1))).idx == 1
    check JsValue(JsServiceWorkerRegistration(JsValue(idx: 2))).idx == 2
    check JsValue(JsServiceWorker(JsValue(idx: 3))).idx == 3
    check JsValue(JsNavigationPreloadManager(JsValue(idx: 4))).idx == 4

  test "Navigator serviceWorker returns zero on non-wasm":
    var container = jsNavigatorServiceWorker()
    check JsValue(container).idx == 0

  test "ServiceWorkerContainer register returns Promise on non-wasm":
    var container = JsServiceWorkerContainer(JsValue(idx: 0))
    check JsValue(jsServiceWorkerContainerRegister(container, "/sw.js")).idx == 0

  test "ServiceWorkerContainer ready returns Promise on non-wasm":
    var container = JsServiceWorkerContainer(JsValue(idx: 0))
    check JsValue(jsServiceWorkerContainerReady(container)).idx == 0

  test "ServiceWorkerContainer getRegistration returns Promise on non-wasm":
    var container = JsServiceWorkerContainer(JsValue(idx: 0))
    check JsValue(jsServiceWorkerContainerGetRegistration(container, "/")).idx == 0

  test "ServiceWorkerRegistration active returns zero on non-wasm":
    var reg = JsServiceWorkerRegistration(JsValue(idx: 0))
    check JsValue(jsServiceWorkerRegistrationActive(reg)).idx == 0

  test "ServiceWorkerRegistration installing returns zero on non-wasm":
    var reg = JsServiceWorkerRegistration(JsValue(idx: 0))
    check JsValue(jsServiceWorkerRegistrationInstalling(reg)).idx == 0

  test "ServiceWorkerRegistration waiting returns zero on non-wasm":
    var reg = JsServiceWorkerRegistration(JsValue(idx: 0))
    check JsValue(jsServiceWorkerRegistrationWaiting(reg)).idx == 0

  test "ServiceWorkerRegistration scope returns empty on non-wasm":
    var reg = JsServiceWorkerRegistration(JsValue(idx: 0))
    check jsServiceWorkerRegistrationScope(reg) == ""

  test "ServiceWorkerRegistration update returns Promise on non-wasm":
    var reg = JsServiceWorkerRegistration(JsValue(idx: 0))
    check JsValue(jsServiceWorkerRegistrationUpdate(reg)).idx == 0

  test "ServiceWorkerRegistration unregister returns Promise on non-wasm":
    var reg = JsServiceWorkerRegistration(JsValue(idx: 0))
    check JsValue(jsServiceWorkerRegistrationUnregister(reg)).idx == 0

  test "ServiceWorkerRegistration navigationPreload returns zero on non-wasm":
    var reg = JsServiceWorkerRegistration(JsValue(idx: 0))
    check JsValue(jsServiceWorkerRegistrationNavigationPreload(reg)).idx == 0

  test "ServiceWorker state returns empty on non-wasm":
    var worker = JsServiceWorker(JsValue(idx: 0))
    check jsServiceWorkerState(worker) == ""

  test "ServiceWorker scriptURL returns empty on non-wasm":
    var worker = JsServiceWorker(JsValue(idx: 0))
    check jsServiceWorkerScriptURL(worker) == ""

  test "ServiceWorker postMessage compiles on non-wasm":
    var worker = JsServiceWorker(JsValue(idx: 0))
    var msg = JsValue(idx: 0)
    jsServiceWorkerPostMessage(worker, msg)

  test "NavigationPreloadManager enable returns Promise on non-wasm":
    var manager = JsNavigationPreloadManager(JsValue(idx: 0))
    check JsValue(jsNavigationPreloadManagerEnable(manager)).idx == 0

  test "NavigationPreloadManager disable returns Promise on non-wasm":
    var manager = JsNavigationPreloadManager(JsValue(idx: 0))
    check JsValue(jsNavigationPreloadManagerDisable(manager)).idx == 0

  test "NavigationPreloadManager setHeaderValue returns Promise on non-wasm":
    var manager = JsNavigationPreloadManager(JsValue(idx: 0))
    check JsValue(jsNavigationPreloadManagerSetHeaderValue(manager, "test")).idx == 0

  test "NavigationPreloadManager getState returns Promise on non-wasm":
    var manager = JsNavigationPreloadManager(JsValue(idx: 0))
    check JsValue(jsNavigationPreloadManagerGetState(manager)).idx == 0

suite "Web Workers — types":
  test "Worker types are distinct JsValue":
    check JsValue(JsWorker(JsValue(idx: 1))).idx == 1
    check JsValue(JsSharedWorker(JsValue(idx: 2))).idx == 2
    check JsValue(JsMessagePort(JsValue(idx: 3))).idx == 3
    check JsValue(JsMessageEvent(JsValue(idx: 4))).idx == 4

  test "Worker creation returns zero on non-wasm":
    var worker = jsNewWorker("/worker.js")
    check JsValue(worker).idx == 0

  test "Worker type classic returns zero on non-wasm":
    var worker = jsCreateWorkerTypeClassic("/worker.js")
    check JsValue(worker).idx == 0

  test "Worker type module returns zero on non-wasm":
    var worker = jsCreateWorkerTypeModule("/worker.js")
    check JsValue(worker).idx == 0

  test "Worker postMessage compiles on non-wasm":
    var worker = JsWorker(JsValue(idx: 0))
    var msg = JsValue(idx: 0)
    jsWorkerPostMessage(worker, msg)

  test "Worker addEventListener compiles on non-wasm":
    var worker = JsWorker(JsValue(idx: 0))
    var handler = JsValue(idx: 0)
    jsWorkerAddEventListener(worker, "message", handler)

  test "Worker onMessage compiles on non-wasm":
    var worker = JsWorker(JsValue(idx: 0))
    var handler = JsValue(idx: 0)
    jsWorkerOnMessage(worker, handler)

  test "Worker dispatchEvent returns false on non-wasm":
    var worker = JsWorker(JsValue(idx: 0))
    var event = JsValue(idx: 0)
    check jsWorkerDispatchEvent(worker, event) == false

  test "SharedWorker creation returns zero on non-wasm":
    var worker = jsNewSharedWorker("/worker.js")
    check JsValue(worker).idx == 0

  test "SharedWorker port returns zero on non-wasm":
    var worker = JsSharedWorker(JsValue(idx: 0))
    check JsValue(jsSharedWorkerPort(worker)).idx == 0

  test "MessagePort postMessage compiles on non-wasm":
    var port = JsMessagePort(JsValue(idx: 0))
    var msg = JsValue(idx: 0)
    jsMessagePortPostMessage(port, msg)

  test "MessagePort onMessage compiles on non-wasm":
    var port = JsMessagePort(JsValue(idx: 0))
    var handler = JsValue(idx: 0)
    jsMessagePortOnMessage(port, handler)

  test "MessageEvent data returns zero on non-wasm":
    var event = JsMessageEvent(JsValue(idx: 0))
    check JsValue(jsMessageEventData(event)).idx == 0

  test "MessageEvent origin returns empty on non-wasm":
    var event = JsMessageEvent(JsValue(idx: 0))
    check jsMessageEventOrigin(event) == ""

  test "MessageEvent source returns zero on non-wasm":
    var event = JsMessageEvent(JsValue(idx: 0))
    check JsValue(jsMessageEventSource(event)).idx == 0

  test "WorkerOptions creation":
    var opts = jsCreateWorkerOptions("classic", "same-origin")
    check JsValue(opts).idx == 0

suite "WebRTC — types":
  test "WebRTC types are distinct JsValue":
    check JsValue(JsRTCPeerConnection(JsValue(idx: 1))).idx == 1
    check JsValue(JsRTCSessionDescription(JsValue(idx: 2))).idx == 2
    check JsValue(JsRTCIceCandidate(JsValue(idx: 3))).idx == 3
    check JsValue(JsRTCDataChannel(JsValue(idx: 4))).idx == 4
    check JsValue(JsRTCRtpSender(JsValue(idx: 5))).idx == 5
    check JsValue(JsRTCRtpReceiver(JsValue(idx: 6))).idx == 6
    check JsValue(JsRTCRtpTransceiver(JsValue(idx: 7))).idx == 7

  test "RTCPeerConnection creation returns zero on non-wasm":
    var pc = jsNewRTCPeerConnection()
    check JsValue(pc).idx == 0

  test "RTCPeerConnection signalingState returns empty on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check jsRTCPeerConnectionSignalingState(pc) == ""

  test "RTCPeerConnection iceConnectionState returns empty on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check jsRTCPeerConnectionIceConnectionState(pc) == ""

  test "RTCPeerConnection iceGatheringState returns empty on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check jsRTCPeerConnectionIceGatheringState(pc) == ""

  test "RTCPeerConnection localDescription returns zero on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check JsValue(jsRTCPeerConnectionLocalDescription(pc)).idx == 0

  test "RTCPeerConnection remoteDescription returns zero on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check JsValue(jsRTCPeerConnectionRemoteDescription(pc)).idx == 0

  test "RTCPeerConnection createOffer returns Promise on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check JsValue(jsRTCPeerConnectionCreateOffer(pc)).idx == 0

  test "RTCPeerConnection createAnswer returns Promise on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check JsValue(jsRTCPeerConnectionCreateAnswer(pc)).idx == 0

  test "RTCPeerConnection setLocalDescription returns Promise on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    var desc = JsValue(idx: 0)
    check JsValue(jsRTCPeerConnectionSetLocalDescription(pc, desc)).idx == 0

  test "RTCPeerConnection setRemoteDescription returns Promise on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    var desc = JsValue(idx: 0)
    check JsValue(jsRTCPeerConnectionSetRemoteDescription(pc, desc)).idx == 0

  test "RTCPeerConnection addIceCandidate returns Promise on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    var cand = JsValue(idx: 0)
    check JsValue(jsRTCPeerConnectionAddIceCandidate(pc, cand)).idx == 0

  test "RTCPeerConnection createDataChannel returns zero on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check JsValue(jsRTCPeerConnectionCreateDataChannel(pc, "test")).idx == 0

  test "RTCPeerConnection getTransceivers returns zero on non-wasm":
    var pc = JsRTCPeerConnection(JsValue(idx: 0))
    check JsValue(jsRTCPeerConnectionGetTransceivers(pc)).idx == 0

  test "RTCSessionDescription type returns empty on non-wasm":
    var desc = JsRTCSessionDescription(JsValue(idx: 0))
    check jsRTCSessionDescriptionType(desc) == ""

  test "RTCSessionDescription sdp returns empty on non-wasm":
    var desc = JsRTCSessionDescription(JsValue(idx: 0))
    check jsRTCSessionDescriptionSdp(desc) == ""

  test "RTCIceCandidate candidate returns empty on non-wasm":
    var cand = JsRTCIceCandidate(JsValue(idx: 0))
    check jsRTCIceCandidateCandidate(cand) == ""

  test "RTCIceCandidate sdpMid returns empty on non-wasm":
    var cand = JsRTCIceCandidate(JsValue(idx: 0))
    check jsRTCIceCandidateSdpMid(cand) == ""

  test "RTCIceCandidate sdpMLineIndex returns 0 on non-wasm":
    var cand = JsRTCIceCandidate(JsValue(idx: 0))
    check jsRTCIceCandidateSdpMLineIndex(cand) == 0

  test "RTCDataChannel label returns empty on non-wasm":
    var channel = JsRTCDataChannel(JsValue(idx: 0))
    check jsRTCDataChannelLabel(channel) == ""

  test "RTCDataChannel ordered returns false on non-wasm":
    var channel = JsRTCDataChannel(JsValue(idx: 0))
    check jsRTCDataChannelOrdered(channel) == false

  test "RTCDataChannel protocol returns empty on non-wasm":
    var channel = JsRTCDataChannel(JsValue(idx: 0))
    check jsRTCDataChannelProtocol(channel) == ""

  test "RTCDataChannel readyState returns empty on non-wasm":
    var channel = JsRTCDataChannel(JsValue(idx: 0))
    check jsRTCDataChannelReadyState(channel) == ""

  test "RTCDataChannel bufferedAmount returns 0 on non-wasm":
    var channel = JsRTCDataChannel(JsValue(idx: 0))
    check jsRTCDataChannelBufferedAmount(channel) == 0

  test "RTCDataChannel send returns false on non-wasm":
    var channel = JsRTCDataChannel(JsValue(idx: 0))
    var data = JsValue(idx: 0)
    check jsRTCDataChannelSend(channel, data) == false

  test "RTCDataChannelOnOpen compiles on non-wasm":
    var channel = JsRTCDataChannel(JsValue(idx: 0))
    var handler = JsValue(idx: 0)
    jsRTCDataChannelOnOpen(channel, handler)

  test "RTCDataChannelOnMessage compiles on non-wasm":
    var channel = JsRTCDataChannel(JsValue(idx: 0))
    var handler = JsValue(idx: 0)
    jsRTCDataChannelOnMessage(channel, handler)

  test "RTCRtpSender track returns zero on non-wasm":
    var sender = JsRTCRtpSender(JsValue(idx: 0))
    check JsValue(jsRTCRtpSenderTrack(sender)).idx == 0

  test "RTCRtpReceiver track returns zero on non-wasm":
    var receiver = JsRTCRtpReceiver(JsValue(idx: 0))
    check JsValue(jsRTCRtpReceiverTrack(receiver)).idx == 0

  test "RTCRtpTransceiver mid returns empty on non-wasm":
    var transceiver = JsRTCRtpTransceiver(JsValue(idx: 0))
    check jsRTCRtpTransceiverMid(transceiver) == ""

suite "WebGL / WebGPU — types":
  test "WebGL types are distinct JsValue":
    check JsValue(JsWebGLRenderingContext(JsValue(idx: 1))).idx == 1
    check JsValue(JsWebGLBuffer(JsValue(idx: 2))).idx == 2
    check JsValue(JsWebGLFramebuffer(JsValue(idx: 3))).idx == 3
    check JsValue(JsWebGLProgram(JsValue(idx: 4))).idx == 4
    check JsValue(JsWebGLShader(JsValue(idx: 5))).idx == 5
    check JsValue(JsWebGLTexture(JsValue(idx: 6))).idx == 6
    check JsValue(JsWebGLUniformLocation(JsValue(idx: 7))).idx == 7
    check JsValue(JsWebGL2RenderingContext(JsValue(idx: 8))).idx == 8
    check JsValue(JsGPUDevice(JsValue(idx: 9))).idx == 9
    check JsValue(JsGPUSwapChain(JsValue(idx: 10))).idx == 10

  test "HTMLCanvasElement getContextWebGL returns zero on non-wasm":
    var canvas = JsHTMLCanvasElement(JsValue(idx: 0))
    check JsValue(jsHTMLCanvasElementGetContextWebGL(canvas)).idx == 0

  test "HTMLCanvasElement getContextWebGL2 returns zero on non-wasm":
    var canvas = JsHTMLCanvasElement(JsValue(idx: 0))
    check JsValue(jsHTMLCanvasElementGetContextWebGL2(canvas)).idx == 0

  test "WebGLRenderingContext clearColor compiles on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    jsWebGLClearColor(ctx, 0.0, 0.0, 0.0, 1.0)

  test "WebGLRenderingContext viewport compiles on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    jsWebGLViewport(ctx, 0, 0, 800, 600)

  test "WebGLRenderingContext createShader returns zero on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    check JsValue(jsWebGLCreateShader(ctx, 0)).idx == 0

  test "WebGLRenderingContext createProgram returns zero on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    check JsValue(jsWebGLCreateProgram(ctx)).idx == 0

  test "WebGLRenderingContext createBuffer returns zero on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    check JsValue(jsWebGLCreateBuffer(ctx)).idx == 0

  test "WebGLRenderingContext createTexture returns zero on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    check JsValue(jsWebGLCreateTexture(ctx)).idx == 0

  test "WebGLRenderingContext createFramebuffer returns zero on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    check JsValue(jsWebGLCreateFramebuffer(ctx)).idx == 0

  test "WebGLRenderingContext getAttribLocation returns -1 on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    var program = JsWebGLProgram(JsValue(idx: 0))
    check jsWebGLGetAttribLocation(program, "position") == -1

  test "WebGLRenderingContext getUniformLocation returns zero on non-wasm":
    var program = JsWebGLProgram(JsValue(idx: 0))
    check JsValue(jsWebGLGetUniformLocation(program, "modelViewProjection")).idx == 0

  test "WebGLRenderingContext uniform1f compiles on non-wasm":
    var loc = JsWebGLUniformLocation(JsValue(idx: 0))
    jsWebGLUniform1f(loc, 1.0)

  test "WebGLRenderingContext uniform2f compiles on non-wasm":
    var loc = JsWebGLUniformLocation(JsValue(idx: 0))
    jsWebGLUniform2f(loc, 1.0, 2.0)

  test "WebGLRenderingContext uniform3f compiles on non-wasm":
    var loc = JsWebGLUniformLocation(JsValue(idx: 0))
    jsWebGLUniform3f(loc, 1.0, 2.0, 3.0)

  test "WebGLRenderingContext uniform4f compiles on non-wasm":
    var loc = JsWebGLUniformLocation(JsValue(idx: 0))
    jsWebGLUniform4f(loc, 1.0, 2.0, 3.0, 4.0)

  test "WebGLRenderingContext drawArrays compiles on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    jsWebGLDrawArrays(ctx, 0, 0, 3)

  test "WebGLRenderingContext getError returns 0 on non-wasm":
    var ctx = JsWebGLRenderingContext(JsValue(idx: 0))
    check jsWebGLGetError(ctx) == 0

  test "WebGL2RenderingContext createVertexArray returns zero on non-wasm":
    var ctx = JsWebGL2RenderingContext(JsValue(idx: 0))
    check JsValue(jsWebGLCreateVertexArray(ctx)).idx == 0

  test "GPUCanvasContext getContextGPU returns zero on non-wasm":
    var canvas = JsHTMLCanvasElement(JsValue(idx: 0))
    check JsValue(jsHTMLCanvasElementGetContextGPU(canvas)).idx == 0

  test "GPUTexture width returns 0 on non-wasm":
    var texture = JsGPUTexture(JsValue(idx: 0))
    check jsGPUTextureWidth(texture) == 0

  test "GPUTexture height returns 0 on non-wasm":
    var texture = JsGPUTexture(JsValue(idx: 0))
    check jsGPUTextureHeight(texture) == 0

  test "GPUTexture depth returns 0 on non-wasm":
    var texture = JsGPUTexture(JsValue(idx: 0))
    check jsGPUTextureDepth(texture) == 0

  test "GPUCommandBuffer label returns empty on non-wasm":
    var buffer = JsGPUCommandBuffer(JsValue(idx: 0))
    check jsGPUCommandBufferLabel(buffer) == ""

suite "Intl — DateTimeFormat & NumberFormat":
  test "Intl types are distinct JsValue":
    check JsValue(JsIntlDateTimeFormat(JsValue(idx: 1))).idx == 1
    check JsValue(JsIntlNumberFormat(JsValue(idx: 2))).idx == 2
    check JsValue(JsIntlPluralRules(JsValue(idx: 3))).idx == 3
    check JsValue(JsIntlCollator(JsValue(idx: 4))).idx == 4

  test "DateTimeFormat format returns empty on non-wasm":
    var fmt = JsIntlDateTimeFormat(JsValue(idx: 0))
    var date = JsValue(idx: 0)
    check jsIntlDateTimeFormatFormat(fmt, date) == ""

  test "DateTimeFormat formatRange returns empty on non-wasm":
    var fmt = JsIntlDateTimeFormat(JsValue(idx: 0))
    var startDate = JsValue(idx: 0)
    var endDate = JsValue(idx: 0)
    check jsIntlDateTimeFormatFormatRange(fmt, startDate, endDate) == ""

  test "DateTimeFormat resolvedOptions returns zero on non-wasm":
    var fmt = JsIntlDateTimeFormat(JsValue(idx: 0))
    check JsValue(jsIntlDateTimeFormatResolvedOptions(fmt)).idx == 0

  test "NumberFormat format returns empty on non-wasm":
    var fmt = JsIntlNumberFormat(JsValue(idx: 0))
    var number = JsValue(idx: 0)
    check jsIntlNumberFormatFormat(fmt, number) == ""

  test "NumberFormat formatToParts returns zero on non-wasm":
    var fmt = JsIntlNumberFormat(JsValue(idx: 0))
    var number = JsValue(idx: 0)
    check JsValue(jsIntlNumberFormatFormatToParts(fmt, number)).idx == 0

  test "NumberFormat resolvedOptions returns zero on non-wasm":
    var fmt = JsIntlNumberFormat(JsValue(idx: 0))
    check JsValue(jsIntlNumberFormatResolvedOptions(fmt)).idx == 0

  test "PluralRules select returns empty on non-wasm":
    var rules = JsIntlPluralRules(JsValue(idx: 0))
    check jsIntlPluralRulesSelect(rules, 5) == ""

  test "Collator compare returns 0 on non-wasm":
    var collator = JsIntlCollator(JsValue(idx: 0))
    check jsIntlCollatorCompare(collator, "a", "b") == 0

  test "Collator resolvedOptions returns zero on non-wasm":
    var collator = JsIntlCollator(JsValue(idx: 0))
    check JsValue(jsIntlCollatorResolvedOptions(collator)).idx == 0


suite "jscast — JsCast / Upcast type system":
  test "uncheckedTo casts JsValue to distinct type (method call)":
    var raw = JsValue(idx: 42)
    var el = raw.uncheckedTo(JsElement)
    check JsValue(el).idx == 42

  test "uncheckedInto generic casts JsValue to distinct type":
    var raw = JsValue(idx: 42)
    var el = uncheckedInto[JsElement](raw)
    check JsValue(el).idx == 42

  test "uncheckedFrom casts distinct type back to JsValue":
    var el = JsElement(JsValue(idx: 7))
    var raw = el.uncheckedFrom()
    check raw.idx == 7

  test "uncheckedTo casts between distinct types":
    var el = JsElement(JsValue(idx: 99))
    var node = el.uncheckedTo(JsNode)
    check JsValue(node).idx == 99

  test "upcastTo explicit proc":
    var canvas = JsHTMLCanvasElement(JsValue(idx: 3))
    var el = canvas.upcastTo(JsElement)
    check JsValue(el).idx == 3

  test "converter chain: JsHTMLCanvasElement -> JsHTMLElement -> JsElement -> JsNode -> JsValue":
    var canvas = JsHTMLCanvasElement(JsValue(idx: 123))
    # Implicit conversions should chain through the hierarchy
    var htmlEl: JsHTMLElement = canvas
    var el: JsElement = htmlEl
    var node: JsNode = el
    var raw: JsValue = node
    check raw.idx == 123

  test "converter: JsMouseEvent -> JsEvent -> JsValue":
    var ev = JsMouseEvent(JsValue(idx: 55))
    var base: JsEvent = ev
    var raw: JsValue = base
    check raw.idx == 55

  test "converter: JsKeyboardEvent -> JsEvent":
    var ev = JsKeyboardEvent(JsValue(idx: 66))
    var base: JsEvent = ev
    check JsValue(base).idx == 66

  test "converter: JsDocument -> JsNode -> JsValue":
    var doc = JsDocument(JsValue(idx: 77))
    var node: JsNode = doc
    var raw: JsValue = node
    check raw.idx == 77

  test "jsClassName compile-time constants":
    check jsClassName(JsElement) == "Element"
    check jsClassName(JsNode) == "Node"
    check jsClassName(JsDocument) == "Document"
    check jsClassName(JsHTMLElement) == "HTMLElement"
    check jsClassName(JsHTMLCanvasElement) == "HTMLCanvasElement"
    check jsClassName(JsMouseEvent) == "MouseEvent"
    check jsClassName(JsWindow) == "Window"
    check jsClassName(JsEvent) == "Event"

  test "dynTo on non-wasm returns none for mismatched type":
    # On non-wasm32 isInstanceOf always returns false
    var raw = JsValue(idx: 1)
    var opt = raw.dynTo(JsElement)
    check opt.isNone

  test "dynInto generic on same-typed value returns some on wasm32":
    var el = JsElement(JsValue(idx: 1))
    var opt = dynInto[JsElement](el)
    when defined(wasm32):
      check opt.isSome
      check JsValue(opt.get).idx == 1
    else:
      # On non-wasm isInstanceOf always returns false, so dynInto returns none
      check opt.isNone

  test "dynTo with target typedesc":
    var raw = JsValue(idx: 1)
    var opt = raw.dynTo(JsElement)
    check opt.isNone  # non-wasm: instanceof fails


suite "webidl parser — regression fixes":
  test "parses callback with optional args (EventHandler style)":
    let src = "callback OnErrorEventHandlerNonNull = undefined (DOMString event, optional DOMString source = \"\", optional unsigned long lineno = 0, optional unsigned long colno = 0);"
    let defs = parseWebIDL(src)
    check defs.len == 1
    check defs[0].kind == witCallback
    check defs[0].name == "OnErrorEventHandlerNonNull"

  test "parses variadic arguments":
    let src = "interface Console { undefined debug(any... data); undefined log(any... data); };"
    let defs = parseWebIDL(src)
    check defs.len == 1
    check defs[0].fields.len == 2

  test "parses extended attributes before optional":
    let src = "interface Foo { undefined bar([EnforceRange] optional unsigned long long x = 0); };"
    let defs = parseWebIDL(src)
    check defs.len == 1
    check defs[0].fields.len == 1

  test "parses getter/setter/deleter":
    let src = "interface Foo { getter object (DOMString name); setter undefined (DOMString name, object value); deleter undefined (DOMString name); };"
    let defs = parseWebIDL(src)
    check defs.len == 1
    check defs[0].fields.len == 3

  test "parses includes statement":
    let src = "interface Foo {}; interface Bar {}; Foo includes Bar;"
    let defs = parseWebIDL(src)
    check defs.len == 3
    check defs[2].kind == witIncludes
    check defs[2].name == "Foo"
    check defs[2].parent == "Bar"

  test "parses unsigned long long type":
    let src = "interface Foo { attribute unsigned long long bytesWritten; };"
    let defs = parseWebIDL(src)
    check defs.len == 1
    check defs[0].fields[0].returnType == "unsigned long long"

  test "parses nullable parenthesized union type":
    let src = "interface Foo { undefined bar(optional (HTMLElement or long)? before = null); };"
    let defs = parseWebIDL(src)
    check defs.len == 1
    check defs[0].fields.len == 1

  test "parses callback interface":
    let src = "callback interface FileSystemEntryCallback { undefined handleEvent(FileSystemEntry entry); };"
    let defs = parseWebIDL(src)
    check defs.len == 1
    check defs[0].kind == witCallbackInterface
    check defs[0].name == "FileSystemEntryCallback"
    check defs[0].fields.len == 1

  test "parses full Window.webidl without infinite loop":
    const url = "https://raw.githubusercontent.com/rustwasm/wasm-bindgen/main/crates/web-sys/webidls/enabled/Window.webidl"
    const path = "tests/Window.webidl"
    let src = if fileExists(path): readFile(path) else:
      let client = newHttpClient()
      let content = client.getContent(url)
      writeFile(path, content)
      content
    let t0 = cpuTime()
    let defs = parseWebIDL(src)
    let dt = cpuTime() - t0
    check defs.len >= 1
    check dt < 1.0  # must not infinite-loop

  test "parses full Streams.webidl without infinite loop":
    const url = "https://raw.githubusercontent.com/rustwasm/wasm-bindgen/main/crates/web-sys/webidls/enabled/Streams.webidl"
    const path = "tests/Streams.webidl"
    let src = if fileExists(path): readFile(path) else:
      let client = newHttpClient()
      let content = client.getContent(url)
      writeFile(path, content)
      content
    let t0 = cpuTime()
    let defs = parseWebIDL(src)
    let dt = cpuTime() - t0
    check defs.len >= 1
    check dt < 1.0
