## Hello World example for nimbling.
##
## Build:
##   nim c --cc:clang --os:standalone --gc:orc -d:wasm32 hello.nim
##
## Then post-process:
##   nimbling hello.wasm --out-dir pkg/ --target bundler

import nimbling

# Export a function to JavaScript
{.wasmBindgen.}
proc greet(name: string): string =
  result = "Hello, " & name & "!"

# Export another function — takes and returns integers
{.wasmBindgen.}
proc add(a, b: int32): int32 =
  result = a + b

# This would be the user's application logic
when isMainModule:
  # When compiled natively, this runs
  echo greet("World")
  echo add(3, 4)
