## nimbling — Nim to Wasm/JS bindings
## ===========================================
## The main entry point for the nimbling library.
##
## Provides:
## - `{.wasmBindgen.}` pragma for exporting/importing JS functions
## - `JsValue` type for working with JS objects
## - `Closure[T]` for callbacks
## - Runtime support functions for Wasm memory management
##
## Architecture:
## ┌─────────────┐     ┌──────────────┐     ┌─────────────┐
## │ Compile-time │ ──▶ │  .wasm file  │ ──▶ │  nimbling   │
## │ Nim Macro    │     │ (custom sec) │     │  CLI tool   │
## └─────────────┘     └──────────────┘     └─────────────┘
##                                                    │
##                                           ┌────────▼────────┐
##                                           │  JS glue code    │
##                                           │  + .wasm output  │
##                                           └─────────────────┘
##
## Inspired by wasm-bindgen (Rust), built for Nim.

import nimbling/common
import nimbling/runtime
import nimbling/macroimpl

# Re-export core types
export common
export runtime.JsValue
export runtime.Closure
export runtime.fromIdx
export macroimpl.wasmBindgen

when defined(wasm32):
  export runtime.nbgMalloc
  export runtime.nbgFree

when isMainModule:
  echo "nimbling v" & SchemaVersion
  echo "Nim to Wasm/JS bindings — like wasm-bindgen for Nim"
  echo "https://github.com/nimbling/nimbling"
