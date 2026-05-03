# Getting Started with nimbling

A practical guide to building WebAssembly applications with Nim using `nimbling`.

---

## Prerequisites

- **Nim 2.0+** — Install via [choosenim](https://github.com/matrix-org/choosenim):
  ```bash
  curl https://nim-lang.org/choosenim/init.sh | sh
  choosenim stable
  ```
- **WebAssembly toolchain** — Choose one:
  - [wasi-sdk](https://github.com/WebAssembly/wasi-sdk) — For standalone WASM
  - [emscripten](https://emscripten.org/) — For browser Node.js targets

---

## Installation

```bash
git clone https://github.com/katehonz/nimbling.git
cd nimble
nimble install  # or: nimble develop
```

Or add to your `*.nimble` file:
```nim
requires "nimbling >= 0.1.0"
```

---

## Project Structure

```
myproject/
├── src/
│   └── mymodule.nim      # Your Nim code
├── pkg/                   # Generated output
└── build.sh              # Build script
```

---

## Step 1: Write Nim Code

Create `src/hello.nim`:

```nim
import nimbling

proc greet*(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"

proc add*(a, b: int32): int32 {.wasmBindgen.} =
  result = a + b

proc getValue*(): int32 {.wasmBindgen.} =
  result = 42

wasmBindgenFinalize()
```

---

## Step 2: Compile to WebAssembly

### Option A: wasi-sdk (Standalone)

```bash
# Step 1: Compile Nim → C
nim c --path:src \
      --cc:clang \
      --os:standalone \
      --mm:orc \
      -d:wasm32 \
      -d:release \
      --compileOnly \
      --nimcache:/tmp/nimcache \
      src/hello.nim

# Step 2: Compile C → WASM
clang --target=wasm32 \
      -nostdlib \
      -Wl,--no-entry \
      -Wl,--export-all \
      -o hello.wasm \
      /tmp/nimcache/*.c
```

### Option B: Emscripten (Browser/Node)

```bash
# Install emsdk first
source ~/emsdk/emsdk_env.sh

# Compile Nim → C with Emscripten
nim c --path:src \
      -d:emscripten \
      -d:wasm32 \
      -d:release \
      --compileOnly \
      --nimcache:/tmp/nimcache \
      src/hello.nim

# Compile C → WASM
emcc -o hello.js \
     -s WASM=1 \
     -s EXPORTED_FUNCTIONS="['_main','_greet','_add','_getValue','_nbgMalloc',...]" \
     /tmp/nimcache/*.c
```

---

## Step 3: Generate JavaScript Bindings

```bash
# Build the CLI tool first (once)
nimble buildCli

# Generate JS glue code
./src/nimbling/cli hello.wasm \
    --out-dir pkg/ \
    --target bundler
```

This creates:

```
pkg/
├── hello.js          # JavaScript glue module
├── hello_bg.wasm     # Transformed Wasm module
└── hello.d.ts        # TypeScript declarations
```

---

## Step 4: Use in JavaScript

### Bundler (Webpack/Vite)

```javascript
import init, { greet, add, getValue } from './pkg/hello.js';

await init();

console.log(greet("World"));     // "Hello, World!"
console.log(add(2, 3));          // 5
console.log(getValue());         // 42
```

### Node.js

```javascript
const { greet, add, getValue } = require('./pkg/hello.js');

(async () => {
  await require('./pkg/hello_bg.wasm');
  console.log(greet("Node"));    // "Hello, Node!"
})();
```

### Browser (ES Modules)

```html
<script type="module">
  import init, { greet } from './pkg/hello.js';

  const wasm = await fetch('./pkg/hello_bg.wasm');
  await init(wasm);

  document.getElementById('output').textContent = greet("Browser");
</script>
```

---

## Working with JavaScript Objects

### Importing JS Functions

```nim
import nimbling

# Import a JS function from the DOM
{.wasmBindgen: "document".}
proc getElementById*(id: string): JsValue {.importc: "getElementById".}

# Use it
let el = getElementById("myDiv")
```

### Using JsValue

```nim
import nimbling

proc createObject*(): JsValue {.wasmBindgen.} =
  result = JsValue(idx: 0)  # Will be set by JS glue

proc getProperty*(obj: JsValue, key: string): JsValue {.wasmBindgen.} =
  discard  # JS: return heap[obj.idx][key]
```

### Closures/Callbacks

```nim
import nimbling

type
  Callback* = proc(a: int32): int32

proc callWithCallback*(fn: Callback, value: int32): int32 {.wasmBindgen.} =
  result = fn(value) * 2
```

---

## Working with WebIDL Bindings

nimbling includes pre-generated Web API bindings:

```nim
import nimbling/web_sys

# Document API
let doc = window.document()
let canvas = doc.createElement("canvas")
discard canvas.getContext("webgl")

# Console API
console.log("Hello from Nim!")
console.error("An error occurred")

# Fetch API
proc fetchUrl*(url: string): JsValue {.wasmBindgen.} =
  discard  # Use fetch() from web_sys
```

See [docs/webidl-guide.md](webidl-guide.md) for detailed WebIDL usage.

---

## Building Examples

```bash
# Run the hello example natively (for testing)
nim c --path:src -r examples/hello/hello.nim

# Build hello for WASM
nimble wasm
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Run tests | `nimble test` |
| Build CLI | `nimble buildCli` |
| Build hello for WASM | `nimble wasm` |
| Compile Nim → C | `nim c --compileOnly --nimcache:/tmp ..` |
| Compile C → WASM | `clang --target=wasm32 -o out.wasm *.c` |

---

## Next Steps

- [API Reference](api.md) — Full API documentation
- [Architecture](architecture.md) — How nimbling works internally
- [WebIDL Guide](webidl-guide.md) — Using `webidlBind`
- [CLI Reference](cli-reference.md) — CLI tool options
- [Troubleshooting](troubleshooting.md) — Common issues