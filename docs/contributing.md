# Contributing to nimbling

## Code Style

- Nim 2.0+ (uses ORC/ARC memory management)
- `import std/options` for `Option[T]`, `export options` in `common.nim`
- All public symbols end with `*`
- Type IDs from `common.nim` use the `TY_` prefix
- No comments in generated code unless necessary

## Development Setup

```bash
# Clone
git clone https://github.com/katehonz/nimbling.git
cd nimbling

# Install Nim 2.0+ via choosenim
curl https://nim-lang.org/choosenim/init.sh | sh
choosenim stable

# Run tests
nimble test

# Build CLI
nimble buildCli
```

## Adding a New Type to the Program Schema

1. Define the type in `common.nim` (in the type section)
2. Add an `encode()` overload in `encode.nim`
3. Add a `decode*()` proc in `decode.nim`
4. Update `decodeProgram()` to read the new field
5. Write a roundtrip test in `tests/all.nim`
6. Bump `SchemaVersion`

## Adding a New Nim Type to the Macro

1. Add the type mapping in `codegen.nim` (`nimTypeToTyId`)
2. Update `buildShimProc` in `macroimpl.nim` to handle the ABI conversion
3. Update `classifyArgType` in `jsgen.nim` for JS-side conversion
4. Add tests

## Architecture Overview

```
User Code (Nim)
    |
    v
{.wasmBindgen.} macro (macroimpl.nim)
    |-- Parses AST
    |-- Generates __nbg_shim_* (exportc wrapper)
    |-- Generates __nbg_describe_* (type descriptor)
    v
.wasm binary
    |
    v
nimbling CLI (cli.nim)
    |-- Extracts __nimbling_unstable custom section
    |-- Decodes Program (decode.nim)
    |-- Executes __nbg_describe_* (interp.nim)
    |-- Applies wasm transforms (transforms.nim)
    |-- Generates JS glue (jsgen.nim)
    v
Output: {name}.js + {name}_bg.wasm + {name}.d.ts
```

## Testing

```bash
# Run all tests
nimble test

# Run with verbose output
nim c --path:src -r tests/all.nim

# Compile hello example (native)
nim c --path:src -r examples/hello/hello.nim

# Compile hello example (wasm32)
nim c --path:src --cc:clang --os:standalone --mm:orc -d:wasm32 -d:release examples/hello/hello.nim
```

## Debug Tips

```bash
# Compile CLI with debug output
nim c -d:debug --path:src src/nimbling/cli.nim

# Run a specific test
nim c -r --path:src -d:debug tests/all.nim

# Check generated JS
./src/nimbling/cli test.wasm --out-dir /tmp/out --target bundler
cat /tmp/out/*.js
```

## Pull Request Guidelines

1. All tests must pass (`nimble test` — 134 tests)
2. New features should include tests
3. Update documentation if changing public API
4. Keep commits focused and well-described

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
