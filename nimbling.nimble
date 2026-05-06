# Package

version       = "0.1.0"
author        = "Nimbling Team"
description   = "Nim-to-Wasm/JS bindings — like wasm-bindgen for Nim"
license       = "MIT"
srcDir        = "src"

# Dependencies
requires "nim >= 2.0.0"

# CLI binary — built from src/nimbling/cli.nim
bin           = @["nimbling/cli"]

task buildCli, "Build the nimbling CLI tool":
  exec "nim c -d:release src/nimbling/cli.nim"

task test, "Run all tests":
  exec "nim c -d:ssl --path:src -r tests/all.nim"

task e2e, "Run end-to-end tests":
  exec "node tests/e2e/test.mjs"

# Build with wasm target helper
# Two-step process: Nim → C → .wasm via clang
# Requires: clang with wasm32 target (wasi-sdk or emscripten)
task wasm, "Build hello example for wasm32":
  # Step 1: Compile Nim → C
  exec "nim c --path:src --cc:clang --cpu:wasm32 --os:standalone --mm:orc -d:wasm32 -d:release --compileOnly --nimcache:/tmp/nimcache_wasm examples/hello/hello.nim"
  echo "C files generated in /tmp/nimcache_wasm"
  echo "To produce .wasm, run:"
  echo "  clang --target=wasm32 -nostdlib -Wl,--no-entry -Wl,--export-all -o hello.wasm /tmp/nimcache_wasm/*.c"
