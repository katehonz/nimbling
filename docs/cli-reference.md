# CLI Reference

Complete reference for the `nimbling` command-line tool.

---

## Synopsis

```bash
nimbling [options] <input.wasm>
nimbling <input.wasm> --out-dir <dir> --target <target>
nimbling <input.wasm> -o <dir> -t <target>
```

---

## Options

### Input/Output

| Flag | Description | Default |
|------|-------------|---------|
| `<input.wasm>` | Input WASM file | (required) |
| `-o, --out-dir <dir>` | Output directory | `pkg` |
| `--target <target>` | Target platform | `bundler` |
| `--debug, -d` | Enable debug output | false |
| `--no-typescript` | Skip .d.ts generation | false |

---

## Targets

The `--target` option specifies the JavaScript module format:

| Target | Description | Use Case |
|--------|-------------|----------|
| `bundler` | ES modules with wasm import | Webpack, Vite, Rollup |
| `web` | Native ES modules | Modern browsers (no bundler) |
| `no-modules` | Classic script tags | Legacy browsers |
| `nodejs` | CommonJS module | Node.js |
| `deno` | ES modules for Deno | Deno runtime |

---

## Output Files

The CLI generates three files:

```
<out-dir>/
├── {name}.js          # JavaScript glue module
├── {name}_bg.wasm     # Transformed Wasm module
└── {name}.d.ts        # TypeScript declarations
```

For `web` target, also generates:

```
<out-dir>/
├── {name}.js
├── {name}_bg.wasm
├── {name}.d.ts
└── {name}.ts          # TypeScript wrapper
```

---

## Usage Examples

### Basic Usage

```bash
nimbling input.wasm
# Output: pkg/input.js, pkg/input_bg.wasm, pkg/input.d.ts
```

### Specify Output Directory

```bash
nimbling input.wasm --out-dir ./dist
# Output: dist/input.js, dist/input_bg.wasm, dist/input.d.ts
```

### Specify Target

```bash
nimbling input.wasm --target nodejs --out-dir ./dist
# Output: dist/input.js, dist/input_bg.wasm, dist/input.d.ts
```

### Debug Mode

```bash
nimbling input.wasm --debug --out-dir ./dist
# Shows: custom section contents, decode process, generated code
```

### Skip TypeScript

```bash
nimbling input.wasm --no-typescript --out-dir ./dist
# Output: dist/input.js, dist/input_bg.wasm (no .d.ts)
```

### All Options

```bash
nimbling input.wasm \
  --out-dir ./build \
  --target web \
  --debug \
  --no-typescript
```

---

## Debug Output

With `--debug`, the CLI prints:

```
=== nimbling CLI ===
Input: input.wasm
Output: ./dist (target: bundler)

Extracting custom section '__nimbling_unstable'...
Custom section found: 1,234 bytes

Decoding Program descriptor...
  Schema version: 0.2.0
  Exports: 3
  Imports: 0
  Enums: 1
  Structs: 0

Executing type descriptors...
  __nbg_describe_greet: [TY_STRING, TY_STRING]
  __nbg_describe_add: [TY_I32, TY_I32, TY_I32]

Generating JS glue code...
  Target: bundler
  Writing: ./dist/input.js
  Writing: ./dist/input_bg.wasm
  Writing: ./dist/input.d.ts

Done.
```

---

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Error (file not found, parse error, etc.) |
| 2 | Invalid arguments |

---

## Environment Variables

| Variable | Description |
|----------|-------------|
| `NIMBLING_CACHE` | Cache directory for temp files |

---

## Integration with Build Systems

### npm scripts

```json
{
  "scripts": {
    "build:wasm": "nim c --os:standalone --mm:orc -d:wasm32 src/main.nim && nimble buildCli && nimbling main.wasm --out-dir pkg --target bundler",
    "build:wasm:debug": "nim c -d:debug --os:standalone --mm:orc -d:wasm32 src/main.nim && nimble buildCli && nimbling main.wasm --out-dir pkg --target bundler --debug"
  }
}
```

### Makefile

```makefile
WASM_DIR = pkg
SRC = src/main.nim

$(WASM_DIR)/%.js: $(SRC)
	nim c --os:standalone --mm:orc -d:wasm32 $<
	nimbling $< --out-dir $(WASM_DIR) --target bundler

build: $(WASM_DIR)/main.js

clean:
	rm -rf $(WASM_DIR)/*.wasm $(WASM_DIR)/*.js $(WASM_DIR)/*.d.ts
```

### Vite Plugin (Conceptual)

```javascript
// vite.config.js
import { defineConfig } from 'vite';

export default defineConfig({
  optimizeDeps: {
    exclude: ['nimbling']
  },
  build: {
    target: 'esnext'
  }
});
```

---

## Program Schema Reference

The CLI extracts and decodes the `Program` schema embedded in the WASM:

### Schema Structure

```nim
type
  Program* = object
    exports*: seq[Export]           # Exported functions/structs/enums
    enums*: seq[NimEnum]            # Nim enum definitions
    imports*: seq[Import]           # Imported JS functions
    structs*: seq[NimStruct]        # Nim struct definitions
    typescriptCustomSections*: seq[LitOrExpr]
    localModules*: seq[LocalModule]
    inlineJs*: seq[string]
    uniqueCrateIdentifier*: string
    packageJson*: Option[string]
    linkedModules*: seq[LinkedModule]
    descriptors*: seq[seq[uint32]]  # Raw type descriptor streams
```

### Export Object

```nim
type
  Export* = object
    class*: Option[string]          # Containing class (if method)
    comments*: seq[string]
    consumed*: bool
    function*: FunctionDesc         # Function signature
    jsNamespace*: seq[string]       # Namespace path
    methodKind*: MethodKind         # Constructor/Operation
    startKind*: int                 # 0=None, 1=Public, 2=Private
```

### Import Object

```nim
type
  Import* = object
    module*: Option[ImportModule]   # JS module path
    jsNamespace*: seq[seq[string]]   # Nested namespace
    reexport*: Option[string]
    generateTypescript*: bool
    importKind*: ImportKindObj       # Function/Static/String/Type/Enum
```

---

## Custom Section Format

The custom section `__nimbling_unstable` contains:

```
┌──────────────────────────────────────────────┐
│ name_len: varuint32 = 19                      │
│ name: "__nimbling_unstable"                   │
├──────────────────────────────────────────────┤
│ payload:                                     │
│   schema_version: string (varint length+data) │
│   exports: vec<Export>                        │
│   enums: vec<NimEnum>                        │
│   imports: vec<Import>                        │
│   structs: vec<NimStruct>                    │
│   ...                                        │
└──────────────────────────────────────────────┘
```

All integers are LEB128-encoded for compactness.

---

## Wasm Transforms

The CLI can apply transforms to the WASM binary:

### Externref Transform

Replaces heap array access with externref table operations:

```wat
;; Before
i32.const 132
i32.load

;; After
i32.const 132
table.get externref
```

### Multi-value Transform

Converts return-pointer ABIs to multi-value returns:

```wat
;; Before
(func $greet (param i32 i32) (result i32)
  i32.const 8
  call $__nbg_boxed_str_ptr
)

;; After
(func $greet (param i32 i32) (result i32 i32)
  ...
)
```

### Catch Transform

Wraps function bodies with try/catch for exception handling:

```wat
;; Before
(func $mayThrow (result i32)
  ...
)

;; After
(func $mayThrow (result i32)
  try (result i32)
    ...
  catch_all
    i32.const 0
  end
)
```

### Threads Transform

Adds shared memory and TLS support:

- Patches memory section to `shared=1`
- Makes `__tls_base` global mutable
- Adds thread-local storage shims

---

## Error Messages

| Message | Cause | Solution |
|---------|-------|----------|
| `custom section not found` | `wasmBindgenFinalize()` not called | Add call to your Nim module |
| `failed to decode program` | Corrupted custom section | Rebuild from source |
| `unknown target 'xyz'` | Invalid target name | Use: bundler, web, no-modules, nodejs, deno |
| `cannot open input.wasm` | File doesn't exist | Check path |
| `permission denied` | No read/write access | Check file permissions |

---

## See Also

- [Getting Started](getting-started.md) — Basic CLI usage
- [Architecture](architecture.md) — CLI pipeline details
- [Troubleshooting](troubleshooting.md) — CLI issues