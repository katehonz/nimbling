import std/os
import std/times
import std/strutils
import nimbling/webidl

let webidlDir = paramStr(1)
let outputFile = paramStr(2)

var allDefs: seq[WebIDLDefinition]
var ok = 0
var bad = 0
var timedOut = 0

for file in walkFiles(webidlDir / "*.webidl"):
  let t0 = epochTime()
  let src = readFile(file)
  let fname = file.extractFilename()
  stdout.write(fname[0..min(fname.len-1, 29)])
  stdout.write(if fname.len < 30: " ".repeat(30 - fname.len) else: "")
  stdout.flushFile()

  try:
    # Previously these 24 files were skipped due to infinite-loop bugs in the parser.
    # All parser bugs have been fixed (May 2026) — no files are skipped anymore.
    discard

    let defs = parseWebIDL(src)
    let dt = epochTime() - t0
    if dt > 1.0:
      stdout.write("SLOW(" & $dt.int & "s) ok:" & $defs.len & "\n")
    else:
      stdout.write("ok:" & $defs.len & "\n")
    if defs.len > 0:
      allDefs.add(defs)
      inc ok
    else:
      inc bad
  except CatchableError as e:
    let dt = epochTime() - t0
    let errText = e.msg
    stdout.write("FAIL(" & errText[0..min(errText.len-1, 35)] & ")\n")
    inc bad
  stdout.flushFile()

echo "\n\nParsed: ", ok, " OK, ", bad, " failed, ", allDefs.len, " definitions"

if allDefs.len > 0:
  try:
    let types = analyzeTypes(allDefs)
    let nimCode = generateNimBindings(allDefs, types)

    if outputFile.len > 0:
      writeFile(outputFile, nimCode)
      echo "Written ", nimCode.len, " bytes to ", outputFile
    else:
      echo nimCode[0..min(nimCode.len-1, 5000)]
  except CatchableError as e:
    echo "Generation error: ", e.msg
    echo "Stack: ", getStackTrace()
    writeFile("debug_last_error.txt", e.msg & "\n" & getStackTrace())

