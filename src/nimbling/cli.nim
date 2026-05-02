## CLI tool — nimbling the equivalent of `wasm-bindgen` CLI.
## Reads a compiled .wasm file, extracts custom sections with nimbling
## metadata, generates JavaScript glue code, and outputs the result.
##
## Usage: nimbling input.wasm --out-dir out/ --target bundler

import std/os
import std/parseopt
import std/strformat
import std/strutils

import common
import decode
import jsgen

type
  CliConfig* = object
    input*: string
    outDir*: string
    target*: JsGenTarget
    debug*: bool
    noTypescript*: bool
    noModules*: bool
    wasmName*: string

proc parseArgs(): CliConfig =
  result = CliConfig(
    target: jsBundler,
    outDir: "pkg",
    wasmName: "",
  )

  var p = initOptParser()
  for kind, key, val in p.getopt():
    case kind
    of cmdArgument:
      result.input = key
      if result.wasmName.len == 0:
        result.wasmName = key.extractFilename().split('.')[0]
    of cmdLongOption, cmdShortOption:
      case key
      of "out-dir", "o":
        result.outDir = val
      of "target", "t":
        case val
        of "bundler":      result.target = jsBundler
        of "web":          result.target = jsWeb
        of "no-modules":   result.target = jsNoModules
        of "nodejs":       result.target = jsNode
        of "deno":         result.target = jsDeno
        else:
          echo &"Unknown target: {val}, using bundler"
      of "debug", "d":
        result.debug = true
      of "no-typescript":
        result.noTypescript = true
      of "no-modules":
        result.noModules = true
      else:
        discard
    of cmdEnd:
      break

proc extractCustomSection(wasmData: seq[byte], sectionName: string): seq[byte] =
  ## Parse a .wasm binary and extract a named custom section.
  ## WebAssembly binary format is:
  ##   magic: 4 bytes (0x00, 0x61, 0x73, 0x6D)
  ##   version: 4 bytes (0x01, 0x00, 0x00, 0x00)
  ##   sections: sequence of (section_id, payload_len, payload)
  ##
  ## Custom section: section_id = 0
  ##   payload: name_len, name_bytes, content_bytes

  if wasmData.len < 8:
    return @[]

  # Verify magic
  let magic = wasmData[0..3]
  if magic != [0x00'u8, 0x61'u8, 0x6D'u8, 0x73'u8]:
    echo "Warning: invalid wasm magic bytes"
    return @[]

  var pos = 8  # skip magic + version

  while pos < wasmData.len:
    let sectionId = wasmData[pos]
    inc pos

    # Read LEB128 varuint32 for section size
    var size: int = 0
    var shift = 0
    while pos < wasmData.len:
      let b = wasmData[pos]
      inc pos
      size = size or ((int(b) and 0x7F) shl shift)
      if (b and 0x80) == 0:
        break
      shift += 7

    if sectionId == 0:
      # Custom section — read name
      var nameLen: int = 0
      shift = 0
      let nameStart = pos
      while pos < nameStart + size and pos < wasmData.len:
        let b = wasmData[pos]
        inc pos
        nameLen = nameLen or ((int(b) and 0x7F) shl shift)
        if (b and 0x80) == 0:
          break
        shift += 7

      let nameBytes = wasmData[pos..<pos + nameLen]
      pos += nameLen
      let name = cast[string](nameBytes)

      if name == sectionName:
        let contentLen = size - (pos - nameStart)
        return wasmData[pos..<pos + contentLen]
      else:
        pos += size - (pos - nameStart)
    else:
      # Skip non-custom section
      pos += size

  return @[]

proc runCli*() =
  let config = parseArgs()

  if config.input.len == 0:
    echo "nimbling — Nim to Wasm/JS bindings CLI"
    echo ""
    echo "Usage: nimbling <input.wasm> [options]"
    echo ""
    echo "Options:"
    echo "  --out-dir, -o <dir>    Output directory (default: pkg)"
    echo "  --target, -t <target>  Target: bundler, web, no-modules, nodejs, deno"
    echo "  --debug, -d            Enable debug output"
    echo "  --no-typescript        Skip generating .d.ts files"
    return

  # Read input wasm
  if not config.input.fileExists():
    echo &"Error: input file not found: {config.input}"
    quit(1)

  let wasmStr = readFile(config.input)
  let wasmData = cast[seq[byte]](wasmStr)
  if config.debug:
    echo &"Read {wasmData.len} bytes from {config.input}"

  # Extract custom section
  let customData = extractCustomSection(wasmData, CustomSectionName)
  if config.debug:
    echo &"Custom section '{CustomSectionName}': {customData.len} bytes"

  if customData.len == 0:
    echo "Warning: no nimbling custom section found. Outputting minimal JS glue."
    # Still generate basic JS glue with no specific exports/imports
    let emptyProg = Program(uniqueCrateIdentifier: "unknown")
    var jsg = newJsGen(emptyProg, config.target, config.wasmName)
    let jsOutput = jsg.generate()

    createDir(config.outDir)
    let jsPath = config.outDir / (config.wasmName & ".js")
    writeFile(jsPath, jsOutput)
    echo &"Generated {jsPath}"
    return

  # Decode program
  var decoder = newDecoder(customData)
  let prog = decodeProgram(decoder)

  if config.debug:
    echo &"Decoded program: {prog.exports.len} exports, {prog.imports.len} imports"
    for exp in prog.exports:
      echo &"  export: {exp.function.name}"

  # Generate JS
  var jsg = newJsGen(prog, config.target, config.wasmName)
  let jsOutput = jsg.generate()

  # Write outputs
  createDir(config.outDir)

  let jsPath = config.outDir / (config.wasmName & ".js")
  writeFile(jsPath, jsOutput)
  echo &"Generated {jsPath}"

  # Copy/reference the wasm file
  let wasmOut = config.outDir / (config.wasmName & "_bg.wasm")
  copyFile(config.input, wasmOut)
  echo &"Copied wasm to {wasmOut}"

  if not config.noTypescript:
    let tsPath = config.outDir / (config.wasmName & ".d.ts")
    var ts = "/* TypeScript declarations for " & config.wasmName & " */\n"
    ts &= "export function init(input: RequestInfo | URL | Response | BufferSource | WebAssembly.Module): Promise<typeof wasmExports>;\n"
    ts &= "\n"
    ts &= "declare namespace wasmExports {\n"
    for exp in prog.exports:
      ts &= "  export function " & exp.function.name & "(...args: any[]): any;\n"
    ts &= "}\n"
    writeFile(tsPath, ts)
    echo &"Generated {tsPath}"

  echo "Done."

when isMainModule:
  runCli()
