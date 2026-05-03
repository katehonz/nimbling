## Test suite for nimbling

import std/unittest
import std/strutils

import nimbling/common
import nimbling/encode
import nimbling/decode
import nimbling/describe
import nimbling/jsgen

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
