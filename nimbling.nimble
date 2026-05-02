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
  exec "nim c --path:src -r tests/all.nim"

# Build with wasm target helper
task wasm, "Build an example for wasm":
  exec "nim c --cc:clang --os:standalone --gc:orc -d:wasm32 -d:release examples/hello/hello.nim"
