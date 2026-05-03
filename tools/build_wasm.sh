#!/bin/bash
# End-to-end build script for nimbling wasm target.
# Requires: Nim >= 2.0, clang with wasm32 target, and either wasi-sdk or emscripten.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

NIM_FILE="${1:-$PROJECT_DIR/examples/hello/hello.nim}"
OUT_WASM="${2:-$PROJECT_DIR/examples/hello/hello.wasm}"
NIMCACHE="${3:-/tmp/nimcache_nimbling_wasm}"

WASI_SDK="${WASI_SDK_PATH:-/opt/wasi-sdk}"
EMSDK="${EMSDK:-}"

echo "=== nimbling wasm build ==="
echo "Input:  $NIM_FILE"
echo "Output: $OUT_WASM"
echo "Nimcache: $NIMCACHE"
echo ""

# Step 1: Nim → C
nim c \
  --path:"$PROJECT_DIR/src" \
  --os:standalone \
  --cpu:wasm32 \
  --mm:orc \
  -d:wasm32 \
  -d:release \
  --compileOnly \
  --nimcache:"$NIMCACHE" \
  "$NIM_FILE"

echo "=== Nim → C OK ==="

# Step 2: C → WASM
if [ -d "$WASI_SDK" ]; then
  echo "Using wasi-sdk: $WASI_SDK"
  CC="$WASI_SDK/bin/clang"
  SYSROOT="--sysroot=$WASI_SDK/share/wasi-sysroot"
  "$CC" --target=wasm32-wasi $SYSROOT \
    -O3 \
    -Wl,--export-all \
    -Wl,--no-entry \
    -o "$OUT_WASM" \
    "$NIMCACHE"/*.c
elif [ -n "$EMSDK" ] && [ -x "$EMSDK/upstream/emscripten/emcc" ]; then
  echo "Using emscripten: $EMSDK"
  "$EMSDK/upstream/emscripten/emcc" \
    -O3 \
    -s WASM=1 \
    -s SIDE_MODULE=0 \
    -s EXPORT_ALL=1 \
    -o "$OUT_WASM" \
    "$NIMCACHE"/*.c
else
  echo "ERROR: No wasm linker found."
  echo "Please install wasi-sdk and set WASI_SDK_PATH, or activate emscripten."
  echo ""
  echo "Quick install (Debian/Ubuntu):"
  echo "  sudo apt install wasi-sdk"
  echo ""
  echo "Or download from: https://github.com/WebAssembly/wasi-sdk"
  exit 1
fi

echo "=== C → WASM OK ==="
echo "Output: $OUT_WASM"

# Step 3: Post-process with nimbling CLI
CLI_BIN="$PROJECT_DIR/src/nimbling/cli"
if [ ! -x "$CLI_BIN" ]; then
  echo "Building nimbling CLI..."
  (cd "$PROJECT_DIR" && nimble buildCli)
fi

PKG_DIR="$(dirname "$OUT_WASM")/pkg"
"$CLI_BIN" "$OUT_WASM" --out-dir "$PKG_DIR" --target bundler

echo "=== nimbling CLI OK ==="
echo "Package output: $PKG_DIR"
ls -la "$PKG_DIR"
