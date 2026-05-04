# Troubleshooting Guide

Solutions to common issues when using nimbling.

---

## Compilation Issues

### "Cannot open file: nimbling"

**Problem**: Nim cannot find the nimbling module.

**Solution**: Use `--path:src` when compiling:
```bash
nim c --path:src -r your_file.nim
```

Or add to your `*.nimble`:
```nim
requires "nimbling"
```

---

### "undeclared identifier: wasmBindgen"

**Problem**: The `{.wasmBindgen.}` pragma is not recognized.

**Solution**: Import nimbling at the top of your file:
```nim
import nimbling
```

---

### "expected a pragma"

**Problem**: The wasmBindgen pragma syntax is wrong.

**Solution**: Use `.wasmBindgen.` (dot notation) not `{.wasmBindgen.}`:
```nim
# Wrong
proc greet(name: string): string {wasmBindgen.} =

# Correct
proc greet(name: string): string {.wasmBindgen.} =
```

---

### "unknown pragma wasmBindgenFinalize"

**Problem**: `wasmBindgenFinalize()` is not in scope.

**Solution**: Call it after all wasmBindgen procs in a module that imports nimbling:
```nim
import nimbling

proc greet(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"

wasmBindgenFinalize()  # Must be called once per module
```

---

## WASM Compilation Issues

### "clang: error: unknown target triple wasm32"

**Problem**: clang does not have the wasm32 target.

**Solution**: Install wasi-sdk or emscripten with wasm support:
```bash
# wasi-sdk
export WASM_SDK_PATH=/path/to/wasi-sdk
clang --target=wasm32 ...

# or emscripten
source ~/emsdk/emsdk_env.sh
emcc ...
```

---

### "undefined reference to `__nbg_malloc`"

**Problem**: The runtime functions are not exported from your WASM.

**Solution**: Ensure `runtime.nim` is imported and the functions are compiled in:
```nim
import nimbling/runtime

when defined(wasm32):
  export runtime.nbgMalloc
  export runtime.nbgFree
```

---

### "section too big" or "out of memory"

**Problem**: Your WASM binary is too large for the default limits.

**Solution**: Increase memory limits in your build:
```bash
# Emscripten
emcc -s TOTAL_MEMORY=536870912 ...  # 512MB
emcc -s ALLOW_MEMORY_GROWTH=1 ...
```

---

## CLI Issues

### "Error: custom section '__nimbling_unstable' not found"

**Problem**: The WASM file was not compiled with nimbling, or `wasmBindgenFinalize()` was not called.

**Solution**:
1. Ensure `wasmBindgenFinalize()` is called in your Nim module
2. Verify the WASM file contains `__nimbling_unstable`:
```bash
# Check for custom sections
wasm-objdump -h your.wasm | grep -i nimble
```

---

### "Error: failed to decode program descriptor"

**Problem**: The binary format in the custom section is corrupted or from a different version.

**Solution**: Rebuild from source with the same version of nimbling:
```bash
nimble buildCli
nim c --path:src your_module.nim
# Then re-run nimbling CLI
```

---

### "Error: unknown target 'xyz'"

**Problem**: The target name is misspelled or not supported.

**Solution**: Use a valid target:
```bash
nimbling input.wasm --target bundler  # Options: bundler, web, no-modules, nodejs, deno
```

---

## Runtime Issues

### "JsValue is not a valid type for wasmBindgen"

**Problem**: JsValue cannot be used directly as return type for exports (it can only be passed as arguments).

**Solution**: Return a concrete type instead, or use a wrapper:
```nim
# Wrong
proc getGlobal*(): JsValue {.wasmBindgen.} = ...

# Correct - use concrete types
proc getValue*(): int32 {.wasmBindgen.} = ...
```

---

### "string conversion failed"

**Problem**: A string passed from JavaScript contains null bytes or invalid UTF-8.

**Solution**: This is a known limitation. Use `seq[byte]` for binary data:
```nim
proc processBinary*(data: seq[byte]): seq[byte] {.wasmBindgen.} =
  result = data
```

---

### "heap index out of bounds"

**Problem**: A JsValue with an invalid index is being used.

**Solution**: Ensure JsValue objects are only created from valid heap indices:
```nim
# Don't create JsValue from arbitrary indices
let invalid = JsValue(idx: 999999)  # Dangerous!

# Only create from heap allocations
let valid = JsValue(idx: addHeapObject(someJsObject))
```

---

### "closure was garbage collected"

**Problem**: A closure reference became invalid before being used.

**Solution**: Keep references to closures alive on the JavaScript side:
```javascript
// Store closure reference
window.myCallback = Module.cwrap('processCallback', 'number', ['number']);
```

---

## Type Conversion Issues

### "expected string, got number"

**Problem**: Type mismatch between Nim and JavaScript.

**Solution**: Check the Type Conversions table in [types.md](types.md):

| Nim Type | JS Type |
|----------|---------|
| `int32` | number |
| `float64` | number |
| `string` | string |
| `bool` | boolean |
| `JsValue` | any |

---

### "cannot convert seq[T] to JsValue"

**Problem**: Sequences cannot be automatically converted to JsValue.

**Solution**: For array-like objects, use a different approach:
```nim
# Instead of returning seq directly as JsValue
proc getArray*(): seq[int32] {.wasmBindgen.} =
  result = @[1, 2, 3]
```

---

## WebIDL Issues

### "webidlBind: parse error at line X"

**Problem**: The WebIDL syntax is invalid.

**Solution**: Check the WebIDL syntax:
```nim
# Wrong
webidlBind("""
  interface Foo {
    attribute string name;  # Missing type
  };
""")

# Correct
webidlBind("""
  interface Foo {
    attribute DOMString name;
  };
""")
```

---

### "webidlBind: unhandled type 'X'"

**Problem**: The type is not yet supported by the WebIDL parser.

**Solution**: File an issue or use manual bindings instead:
```nim
proc getProperty*(): JsValue =
  when defined(wasm32):
    {.emit: "return heap[`result`.idx].propertyName;".}
  else:
    result = JsValue(idx: 0)
```

---

## Memory Issues

### "memory access out of bounds"

**Problem**: Reading past the end of WASM linear memory.

**Solution**:
1. Check array/string bounds before access
2. Use safe Nim constructs (avoid `addr` on slices)
3. Increase WASM memory:

```bash
emcc -s TOTAL_MEMORY=134217728 ...  # 128MB
```

---

### "stack overflow"

**Problem**: Deep recursion or large stack allocation.

**Solution**: Reduce recursion depth or allocate on the heap:
```nim
# Instead of deep recursion
proc sum(n: int32): int32 =
  if n <= 0: return 0
  return n + sum(n - 1)  # Stack overflow for large n

# Iterative approach
proc sum(n: int32): int32 =
  var total = 0
  for i in 0 .. n:
    total += i
  return total
```

---

## Debugging Tips

### Enable Debug Output

```bash
# Compile CLI with debug
nim c -d:debug --path:src src/nimbling/cli.nim

# Run with debug
./src/nimbling/cli input.wasm --debug --out-dir pkg/
```

---

### Check Generated JS

```bash
nimbling input.wasm --out-dir /tmp/out
cat /tmp/out/*.js
```

---

### Inspect WASM Binary

```bash
# List sections
wasm-objdump -h input.wasm

# Disassemble
wasm-dis input.wasm -o input.wat

# Check exports
wasm-objdump -j export -d input.wasm
```

---

### Verbose Test Output

```bash
nim c -r --path:src -d:debug tests/all.nim
```

---

## Getting Help

- **GitHub Issues**: https://github.com/katehonz/nimbling/issues
- **Discussions**: https://github.com/katehonz/nimbling/discussions

When filing an issue, include:
1. Nim version (`nim --version`)
2. nimbling version
3. Full error message
4. Minimal reproduction case