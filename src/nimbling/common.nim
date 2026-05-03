## Shared types, constants, and schema definition for nimbling.
## Equivalent to wasm-bindgen-shared.

import std/options
import std/strutils
import leb128

export options
export leb128

const SchemaVersion* = "0.2.0"

# ─── Type ID constants (mirrors tys.rs) ───
const
  TY_I8* = 0'u32
  TY_U8* = 1'u32
  TY_I16* = 2'u32
  TY_U16* = 3'u32
  TY_I32* = 4'u32
  TY_U32* = 5'u32
  TY_I64* = 6'u32
  TY_U64* = 7'u32
  TY_I64_AS_F64* = 8'u32
  TY_U64_AS_F64* = 9'u32
  TY_I128* = 10'u32
  TY_U128* = 11'u32
  TY_F32* = 12'u32
  TY_F64* = 13'u32
  TY_BOOLEAN* = 14'u32
  TY_FUNCTION* = 15'u32
  TY_CLOSURE* = 16'u32
  TY_CACHED_STRING* = 17'u32
  TY_STRING* = 18'u32
  TY_REF* = 19'u32
  TY_REFMUT* = 20'u32
  TY_LONGREF* = 21'u32
  TY_SLICE* = 22'u32
  TY_VECTOR* = 23'u32
  TY_EXTERNREF* = 24'u32
  TY_NAMED_EXTERNREF* = 25'u32
  TY_ENUM* = 26'u32
  TY_STRING_ENUM* = 27'u32
  TY_RUST_STRUCT* = 28'u32   # kept for compat with wasm-bindgen schema
  TY_CHAR* = 29'u32
  TY_OPTIONAL* = 30'u32
  TY_RESULT* = 31'u32
  TY_UNIT* = 32'u32
  TY_CLAMPED* = 33'u32
  TY_NONNULL* = 34'u32
  TY_RAW_POINTER* = 35'u32

# ─── Custom section name (must match CLI) ───
const CustomSectionName* = "__nimbling_unstable"

# ─── JS glue prefixes ───
const
  NbgPrefix* = "__nbg_"        # replaces __wbg_
  MallocFn* = "__nbg_malloc"
  FreeFn* = "__nbg_free"
  DescribeFnPrefix* = "__nbg_describe_"

# ─── Schema: Program descriptor types ───
# These mirror the Rust `shared_api!` struct definitions.

type
  ImportModuleKind* = enum
    imNamed
    imRawNamed
    imInline

  ImportModule* = object
    case kind*: ImportModuleKind
    of imNamed:     name*: string
    of imRawNamed:  rawName*: string
    of imInline:    inlineIdx*: uint32

  MethodKind* = enum
    mkConstructor
    mkOperation

  OperationKind* = enum
    opRegular
    opRegularThis
    opGetter
    opSetter
    opIndexingGetter
    opIndexingSetter
    opIndexingDeleter

  Operation* = object
    isStatic*: bool
    kind*: OperationKind
    propertyName*: string

  MethodData* = object
    class*: string
    methodKind*: MethodKind
    operation*: Operation

  FunctionArgumentData* = object
    name*: string
    tyOverride*: string
    optional*: bool
    desc*: string

  FunctionDesc* = object
    args*: seq[FunctionArgumentData]
    isAsync*: bool
    name*: string
    generateTypescript*: bool
    generateJsdoc*: bool
    variadic*: bool
    retTyOverride*: string
    retDesc*: string

  ImportKind* = enum
    ikFunction
    ikStatic
    ikString
    ikType
    ikEnum

  ImportFunction* = object
    shim*: string
    catch*: bool
    variadic*: bool
    assertNoShim*: bool
    methodData*: Option[MethodData]
    structural*: bool
    function*: FunctionDesc

  ImportStatic* = object
    name*: string
    shim*: string

  ImportString* = object
    shim*: string
    string*: string

  ImportType* = object
    name*: string
    instanceofShim*: string
    vendorPrefixes*: seq[string]

  StringEnum* = object
    name*: string
    variantValues*: seq[string]
    comments*: seq[string]
    generateTypescript*: bool
    jsNamespace*: seq[string]

  ImportKindObj* = object
    case kind*: ImportKind
    of ikFunction: funcData*: ImportFunction
    of ikStatic:   staticData*: ImportStatic
    of ikString:   stringData*: ImportString
    of ikType:     typeData*: ImportType
    of ikEnum:     enumData*: StringEnum

  Import* = object
    module*: Option[ImportModule]
    jsNamespace*: seq[seq[string]]
    reexport*: Option[string]
    generateTypescript*: bool
    importKind*: ImportKindObj

  ExportKind* = enum
    ekFunction
    ekStruct
    ekEnum

  Export* = object
    class*: Option[string]
    comments*: seq[string]
    consumed*: bool
    function*: FunctionDesc
    jsNamespace*: seq[string]
    methodKind*: MethodKind
    startKind*: int  # 0=None, 1=Public, 2=Private

  EnumVariant* = object
    name*: string
    value*: uint32
    comments*: seq[string]

  NimEnum* = object
    name*: string
    signed*: bool
    variants*: seq[EnumVariant]
    comments*: seq[string]
    generateTypescript*: bool
    jsNamespace*: seq[string]
    hole*: uint32
    private*: bool

  StructField* = object
    name*: string
    readonly*: bool
    comments*: seq[string]
    generateTypescript*: bool
    generateJsdoc*: bool
    tyOverride*: string

  NimStruct* = object
    name*: string
    nimName*: string
    fields*: seq[StructField]
    comments*: seq[string]
    isInspectable*: bool
    generateTypescript*: bool
    jsNamespace*: seq[string]
    private*: bool

  LinkedModule* = object
    module*: ImportModule
    linkFunctionName*: string

  LocalModule* = object
    identifier*: string
    contents*: string
    linkedModule*: bool

  LitOrExpr* = object
    isExpr*: bool
    value*: string

  Program* = object
    exports*: seq[Export]
    enums*: seq[NimEnum]
    imports*: seq[Import]
    structs*: seq[NimStruct]
    typescriptCustomSections*: seq[LitOrExpr]
    localModules*: seq[LocalModule]
    inlineJs*: seq[string]
    uniqueCrateIdentifier*: string
    packageJson*: Option[string]
    linkedModules*: seq[LinkedModule]
    descriptors*: seq[seq[uint32]]  ## raw u32 streams from __nbg_describe_*

# ─── JS Identifier utilities ───

proc isValidIdent*(s: string): bool =
  if s.len == 0: return false
  case s[0]
  of '0'..'9': return false
  else: discard
  for c in s:
    case c
    of 'a'..'z', 'A'..'Z', '0'..'9', '_', '$': discard
    else: return false
  return true

proc qualifiedName*(jsNamespace: seq[string], jsName: string): string =
  if jsNamespace.len > 0:
    result = jsNamespace.join("__") & "__" & jsName
  else:
    result = jsName

# Mangled internal names
proc newFunction*(structName: string): string =
  result = NbgPrefix
  for c in structName: result.add(c.toLowerAscii())
  result.add("_new")

proc freeFunction*(structName: string): string =
  result = NbgPrefix
  for c in structName: result.add(c.toLowerAscii())
  result.add("_free")

proc structFieldGet*(s, f: string): string =
  result = NbgPrefix & "get_"
  for c in s: result.add(c.toLowerAscii())
  result.add('_')
  result.add(f)

proc structFieldSet*(s, f: string): string =
  result = NbgPrefix & "set_"
  for c in s: result.add(c.toLowerAscii())
  result.add('_')
  result.add(f)
