## Hello World example for nimbling.
##
## Build:
##   nim c --cc:clang --os:standalone --gc:orc -d:wasm32 hello.nim
##
## Then post-process:
##   nimbling hello.wasm --out-dir pkg/ --target bundler

import nimbling

# Export a function to JavaScript
proc greet(name: string): string {.wasmBindgen.} =
  result = "Hello, " & name & "!"

# Export another function — takes and returns integers
proc add(a, b: int32): int32 {.wasmBindgen.} =
  result = a + b

# Finalize — embeds the custom wasm section with metadata for the CLI.
# This must be called once per module, after all wasmBindgen procs.
wasmBindgenFinalize()

# This would be the user's application logic
when isMainModule:
  # When compiled natively, this runs
  echo greet("World")
  echo add(3, 4)
