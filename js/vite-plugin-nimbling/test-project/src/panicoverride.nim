# Standalone panic override for wasm32 target
proc panic(msg: string) =
  discard

proc rawOutput(s: string) =
  discard
