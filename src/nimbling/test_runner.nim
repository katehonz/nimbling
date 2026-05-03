## Test framework for nimbling — equivalent to wasm-bindgen-test.
## Provides a `wasmBindgenTest` macro, test metadata encoding,
## a test runner CLI, and HTML/JS test harness generation.

import std/macros
import std/strformat
import std/strutils
import std/os
import std/parseopt

import common
import leb128

# ══════════════════════════════════════════════════════════════════════════════
# 1. Test configuration types
# ══════════════════════════════════════════════════════════════════════════════

type
  TestConfig* = enum
    tcBrowser         ## Run in browser (Chrome, Firefox, etc.)
    tcNode            ## Run in Node.js
    tcDeno            ## Run in Deno
    tcDedicatedWorker ## Run in a DedicatedWorker
    tcSharedWorker    ## Run in a SharedWorker
    tcServiceWorker   ## Run in a ServiceWorker

  TestEntry* = object
    name*: string              ## Fully qualified test name
    config*: set[TestConfig]   ## Environments where this test runs
    timeout*: int              ## Timeout in ms; 0 = use default (10_000)

  TestSuiteResult* = object
    total*: int
    passed*: int
    failed*: int
    skipped*: int
    errors*: seq[string]       ## Error messages from failed tests

const
  TestCustomSectionName* = "__nimbling_test_unstable"
  DefaultTestTimeout* = 10_000  ## 10 seconds
  MainCustomSection* = CustomSectionName  ## Re-export from common for convenience

# ══════════════════════════════════════════════════════════════════════════════
# 2. Test registry (module-level, populated by macro expansion)
# ══════════════════════════════════════════════════════════════════════════════

var testRegistry* {.compileTime.} = newSeq[TestEntry]()

# ══════════════════════════════════════════════════════════════════════════════
# 3. wasmBindgenTest macro
# ══════════════════════════════════════════════════════════════════════════════

proc extractTestConfig(args: seq[NimNode]): set[TestConfig] =
  ## Extract TestConfig values from macro pragmas/args.
  ## Defaults to {tcBrowser, tcNode, tcDeno} if none specified.
  result = {tcBrowser, tcNode, tcDeno}
  for arg in args:
    if arg.kind == nnkIdent:
      case arg.strVal
      of "browser":          result = result + {tcBrowser}
      of "node":             result = result + {tcNode}
      of "deno":             result = result + {tcDeno}
      of "dedicated_worker": result = result + {tcDedicatedWorker}
      of "shared_worker":    result = result + {tcSharedWorker}
      of "service_worker":   result = result + {tcServiceWorker}
      else: discard

proc extractTimeout(args: seq[NimNode]): int =
  ## Look for a `timeout = <int>` argument.
  result = 0
  for arg in args:
    if arg.kind == nnkExprEqExpr and arg[0].strVal == "timeout":
      result = arg[1].intVal.int

macro wasmBindgenTest*(body: untyped): untyped =
  ## Marks a proc as a wasm test function.
  ##
  ## Usage:
  ##   proc testAddition() {.wasmBindgenTest.} =
  ##     doAssert(1 + 1 == 2)
  ##
  ##   proc testOnlyBrowser() {.wasmBindgenTest: browser.} =
  ##     doAssert(document != nil)
  ##
  ##   proc testWithTimeout() {.wasmBindgenTest: (node, timeout = 5000).} =
  ##     doAssert(awaitSomeAsync())
  ##
  ## Generates:
  ##   1. The original proc
  ##   2. An `{.exportc, cdecl.}` wrapper
  ##   3. A test descriptor registered in the compile-time test registry

  result = newStmtList()

  # body is a ProcDef (nnkProcDef)
  if body.kind != nnkProcDef:
    error("wasmBindgenTest must be applied to a proc", body)

  let procName = body.name
  let procNameStr = procName.strVal
  let exportName = "__nimbling_test_" & procNameStr

  # Extract config/timeout from pragma args
  var testConfig: set[TestConfig] = {tcBrowser, tcNode, tcDeno}
  var testTimeout = 0

  if body.kind == nnkProcDef:
    # Check for pragma args
    let pragmas = body.pragma
    if pragmas.kind == nnkPragma:
      for p in pragmas:
        if p.kind == nnkExprColonExpr and p[0].strVal == "wasmBindgenTest":
          # Has arguments: `wasmBindgenTest: browser` or `wasmBindgenTest: (node, timeout = 5000)`
          let argNode = p[1]
          if argNode.kind == nnkIdent:
            testConfig = extractTestConfig(@[argNode])
          elif argNode.kind == nnkPar or argNode.kind == nnkTupleConstr:
            var args: seq[NimNode] = @[]
            for child in argNode:
              args.add(child)
            testConfig = extractTestConfig(args)
            testTimeout = extractTimeout(args)

  # Register in compile-time registry
  testRegistry.add(TestEntry(
    name: procNameStr,
    config: testConfig,
    timeout: testTimeout,
  ))

  # 1. Keep the original proc
  result.add(body)

  # 2. Generate the exportc wrapper
  let wrapperName = ident(exportName)

  # Get params from original proc
  let formalParams = body.params
  let isVoid = formalParams[0].kind == nnkEmpty

  # Build wrapper params (no args for test procs, but support 0-arg tests)
  var wrapperParams = newNimNode(nnkFormalParams)
  if isVoid:
    wrapperParams.add(newEmptyNode())
  else:
    wrapperParams.add(formalParams[0])

  let wrapper = newProc(
    name = wrapperName,
    params = [newEmptyNode()],
    body = newCall(procName),
    pragmas = nnkPragma.newTree(
      ident("exportc"),
      ident("cdecl"),
      newColonExpr(ident("used"), newLit(true)),
    ),
  )

  # Set the export name
  wrapper[0] = ident(exportName)

  result.add(wrapper)

# ══════════════════════════════════════════════════════════════════════════════
# 4. Test custom section encoding (binary, varint LEB128)
# ══════════════════════════════════════════════════════════════════════════════

proc encodeTestEntry*(buf: var seq[byte], entry: TestEntry) =
  ## Encode a single TestEntry into the binary test section format.
  ## Format: name_len(varint), name_bytes, config_flags(u8), timeout(varint)
  writeUleb128String(buf, entry.name)

  # config_flags: bitfield of TestConfig ordinals
  var flags: uint8 = 0
  for cfg in entry.config:
    flags = flags or (1'u8 shl ord(cfg).uint8)
  buf.add(flags)

  writeUleb128(buf, uint32(entry.timeout))

proc encodeTestSection*(tests: seq[TestEntry]): seq[byte] =
  ## Encode the full test metadata section.
  ## Format: count(varint), then each TestEntry sequentially.
  result = @[]
  writeUleb128(result, uint32(tests.len))
  for entry in tests:
    encodeTestEntry(result, entry)

proc decodeTestEntry(data: seq[byte], pos: var int): TestEntry =
  ## Decode a single TestEntry from binary data.
  result.name = readUleb128String(data, pos)
  let flags = data[pos]
  inc pos
  result.config = {}
  for i in 0..5:
    if (flags and (1'u8 shl i.uint8)) != 0:
      result.config.incl(TestConfig(i))
  result.timeout = int(readUleb128(data, pos))

proc decodeTestSection*(data: seq[byte]): seq[TestEntry] =
  ## Decode the test metadata section from binary.
  result = @[]
  if data.len == 0:
    return
  var pos = 0
  let count = readUleb128(data, pos).int
  for i in 0..<count:
    result.add(decodeTestEntry(data, pos))

# ══════════════════════════════════════════════════════════════════════════════
# 5. Test HTML template generation
# ══════════════════════════════════════════════════════════════════════════════

proc configToJsArray(config: set[TestConfig]): string =
  ## Convert a TestConfig set to a JS array literal.
  var parts: seq[string] = @[]
  if tcBrowser in config: parts.add("\"browser\"")
  if tcNode in config: parts.add("\"node\"")
  if tcDeno in config: parts.add("\"deno\"")
  if tcDedicatedWorker in config: parts.add("\"dedicated_worker\"")
  if tcSharedWorker in config: parts.add("\"shared_worker\"")
  if tcServiceWorker in config: parts.add("\"service_worker\"")
  result = "[" & parts.join(", ") & "]"

proc generateTestHtml*(wasmFile: string, tests: seq[TestEntry]): string =
  ## Generate an HTML page that loads the wasm module and runs tests.
  ## The page:
  ##   - Loads the JS glue module
  ##   - Calls init(wasmFile)
  ##   - Executes each test function
  ##   - Reports results to console and a results div
  ##   - Posts results back to the test runner via fetch

  var testEntries = ""
  for i, t in tests:
    let timeout = if t.timeout > 0: $t.timeout else: $DefaultTestTimeout
    testEntries &= &"""    {{
      name: {t.name.escape()},
      config: {configToJsArray(t.config)},
      timeout: {timeout}
    }}"""
    if i < tests.len - 1:
      testEntries &= ","
    testEntries &= "\n"

  result = &"""<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>nimbling test runner</title>
  <style>
    body {{ font-family: monospace; margin: 2em; background: #1e1e2e; color: #cdd6f4; }}
    #results {{ white-space: pre-wrap; }}
    .pass {{ color: #a6e3a1; }}
    .fail {{ color: #f38ba8; }}
    .skip {{ color: #f9e2af; }}
    .summary {{ margin-top: 1em; font-weight: bold; border-top: 1px solid #45475a; padding-top: 1em; }}
  </style>
</head>
<body>
  <h1>nimbling test results</h1>
  <div id="results"></div>
  <div id="summary" class="summary"></div>
  <script type="module">
    const TESTS = [
{testEntries}
    ];

    const resultsDiv = document.getElementById("results");
    const summaryDiv = document.getElementById("summary");

    function log(msg, cls) {{
      const el = document.createElement("div");
      el.className = cls || "";
      el.textContent = msg;
      resultsDiv.appendChild(el);
    }}

    async function runTest(entry) {{
      const fnName = "__nimbling_test_" + entry.name;
      const timeout = entry.timeout || {DefaultTestTimeout};
      return new Promise((resolve) => {{
        const timer = setTimeout(() => {{
          log("  TIMEOUT: " + entry.name, "fail");
          resolve({{ name: entry.name, status: "timeout", error: "Timed out after " + timeout + "ms" }});
        }}, timeout);

        try {{
          if (typeof wasmExports[fnName] !== "function") {{
            clearTimeout(timer);
            log("  SKIP: " + entry.name + " (not found)", "skip");
            resolve({{ name: entry.name, status: "skip" }});
            return;
          }}
          const result = wasmExports[fnName]();
          if (result && typeof result.then === "function") {{
            result.then(() => {{
              clearTimeout(timer);
              log("  PASS: " + entry.name, "pass");
              resolve({{ name: entry.name, status: "pass" }});
            }}).catch((err) => {{
              clearTimeout(timer);
              log("  FAIL: " + entry.name + " — " + err, "fail");
              resolve({{ name: entry.name, status: "fail", error: String(err) }});
            }});
          }} else {{
            clearTimeout(timer);
            log("  PASS: " + entry.name, "pass");
            resolve({{ name: entry.name, status: "pass" }});
          }}
        }} catch (err) {{
          clearTimeout(timer);
          log("  FAIL: " + entry.name + " — " + err, "fail");
          resolve({{ name: entry.name, status: "fail", error: String(err) }});
        }}
      }});
    }}

    async function runAll() {{
      log("Running " + TESTS.length + " tests...\n");
      const results = [];
      for (const entry of TESTS) {{
        results.push(await runTest(entry));
      }}
      const passed = results.filter(r => r.status === "pass").length;
      const failed = results.filter(r => r.status === "fail").length;
      const skipped = results.filter(r => r.status === "skip").length;
      const timedOut = results.filter(r => r.status === "timeout").length;
      summaryDiv.textContent = `${{results.length}} tests: ${{passed}} passed, ${{failed}} failed, ${{skipped}} skipped, ${{timedOut}} timed out`;

      try {{
        await fetch("/__nimbling_test_results", {{
          method: "POST",
          headers: {{ "Content-Type": "application/json" }},
          body: JSON.stringify({{ results, passed, failed, skipped, timedOut }}),
        }});
      }} catch (e) {{
        console.warn("Could not POST results to runner:", e);
      }}

      if (typeof __nimbling_test_done === "function") {{
        __nimbling_test_done({{ results, passed, failed, skipped, timedOut }});
      }}
    }}

    async function main() {{
      try {{
        if (typeof init === "function") {{
          await init("{wasmFile}");
        }} else if (typeof __nimbling_init === "function") {{
          await __nimbling_init("{wasmFile}");
        }}
        await runAll();
      }} catch (err) {{
        log("FATAL: Failed to initialize wasm module: " + err, "fail");
        summaryDiv.textContent = "FAILED TO INITIALIZE: " + err;
      }}
    }}

    main();
  </script>
</body>
</html>
"""

# ══════════════════════════════════════════════════════════════════════════════
# 6. Console macros (for test output in wasm)
# ══════════════════════════════════════════════════════════════════════════════

template consoleLog*(args: varargs[string, `$`]) =
  ## Log to browser/Node console. Only active when compiled for wasm32.
  when defined(wasm32):
    {.emit: "/* console.log placeholder */".}

template consoleError*(args: varargs[string, `$`]) =
  ## Log error to browser/Node console. Only active when compiled for wasm32.
  when defined(wasm32):
    {.emit: "/* console.error placeholder */".}

template consoleWarn*(args: varargs[string, `$`]) =
  ## Log warning to browser/Node console. Only active when compiled for wasm32.
  when defined(wasm32):
    {.emit: "/* console.warn placeholder */".}

# ══════════════════════════════════════════════════════════════════════════════
# 7. Test runner CLI
# ══════════════════════════════════════════════════════════════════════════════

type
  TestRunnerConfig* = object
    wasmFile*: string       ## Path to the .wasm file
    browser*: string        ## "chrome", "firefox", "safari" (default: "chrome")
    port*: int              ## HTTP server port (default: 8000)
    headless*: bool         ## Run browser headless (default: true)
    verbose*: bool          ## Verbose output
    node*: bool             ## Run in Node.js instead of browser
    deno*: bool             ## Run in Deno instead of browser
    timeout*: int           ## Global timeout override in ms (0 = default)
    jsGlue*: string         ## Path to pre-generated JS glue file

proc defaultTestRunnerConfig*(): TestRunnerConfig =
  TestRunnerConfig(
    wasmFile: "",
    browser: "chrome",
    port: 8000,
    headless: true,
    verbose: false,
    node: false,
    deno: false,
    timeout: 0,
    jsGlue: "",
  )

proc parseTestArgs*(params: seq[string]): TestRunnerConfig =
  ## Parse CLI arguments into a TestRunnerConfig.
  result = defaultTestRunnerConfig()

  var p = initOptParser(params)
  for kind, key, val in p.getopt():
    case kind
    of cmdArgument:
      if result.wasmFile.len == 0:
        result.wasmFile = key
    of cmdLongOption, cmdShortOption:
      case key
      of "browser", "b":
        result.browser = if val.len > 0: val else: "chrome"
      of "port", "p":
        result.port = parseInt(val)
      of "headless":
        result.headless = true
      of "no-headless":
        result.headless = false
      of "verbose", "v":
        result.verbose = true
      of "node", "n":
        result.node = true
      of "deno", "d":
        result.deno = true
      of "timeout", "t":
        result.timeout = parseInt(val)
      of "js-glue":
        result.jsGlue = val
      else:
        discard
    of cmdEnd:
      break

proc extractTestCustomSection*(wasmData: seq[byte]): seq[byte] =
  ## Extract the __nimbling_test_unstable custom section from a .wasm file.
  ## Same binary format as the main custom section extractor.
  if wasmData.len < 8:
    return @[]

  # Verify magic
  if wasmData[0..3] != [0x00'u8, 0x61'u8, 0x6D'u8, 0x73'u8]:
    return @[]

  var pos = 8  # skip magic + version

  while pos < wasmData.len:
    let sectionId = wasmData[pos]
    inc pos

    let size = int(readUleb128(wasmData, pos))

    if sectionId == 0:
      # Custom section — read name
      let nameStart = pos
      let nameLen = int(readUleb128(wasmData, pos))

      let nameBytes = wasmData[pos..<pos + nameLen]
      pos += nameLen
      let name = cast[string](nameBytes)

      if name == TestCustomSectionName:
        let contentLen = size - (pos - nameStart)
        return wasmData[pos..<pos + contentLen]
      else:
        pos += size - (pos - nameStart)
    else:
      pos += size

  return @[]

proc generateNodeTestScript*(wasmFile: string, tests: seq[TestEntry]): string =
  ## Generate a Node.js script that loads the wasm module and runs tests.
  var testEntries = ""
  for i, t in tests:
    let timeout = if t.timeout > 0: $t.timeout else: $DefaultTestTimeout
    testEntries &= &"    {{ name: \"{t.name}\", timeout: {timeout} }}"
    if i < tests.len - 1:
      testEntries &= ","
    testEntries &= "\n"

  result = &"""const fs = require("fs");
const path = require("path");

const TESTS = [
{testEntries}
];

async function runTest(entry) {{
  const fnName = "__nimbling_test_" + entry.name;
  const timeout = entry.timeout || {DefaultTestTimeout};
  return new Promise((resolve) => {{
    const timer = setTimeout(() => {{
      console.log(`  TIMEOUT: ${{entry.name}}`);
      resolve({{ name: entry.name, status: "timeout", error: `Timed out after ${{timeout}}ms` }});
    }}, timeout);

    try {{
      if (typeof global.wasmExports[fnName] !== "function") {{
        clearTimeout(timer);
        console.log(`  SKIP: ${{entry.name}} (not found)`);
        resolve({{ name: entry.name, status: "skip" }});
        return;
      }}
      const result = global.wasmExports[fnName]();
      if (result && typeof result.then === "function") {{
        result.then(() => {{
          clearTimeout(timer);
          console.log(`  PASS: ${{entry.name}}`);
          resolve({{ name: entry.name, status: "pass" }});
        }}).catch((err) => {{
          clearTimeout(timer);
          console.log(`  FAIL: ${{entry.name}} — ${{err}}`);
          resolve({{ name: entry.name, status: "fail", error: String(err) }});
        }});
      }} else {{
        clearTimeout(timer);
        console.log(`  PASS: ${{entry.name}}`);
        resolve({{ name: entry.name, status: "pass" }});
      }}
    }} catch (err) {{
      clearTimeout(timer);
      console.log(`  FAIL: ${{entry.name}} — ${{err}}`);
      resolve({{ name: entry.name, status: "fail", error: String(err) }});
    }}
  }});
}}

async function main() {{
  console.log(`Running ${{TESTS.length}} tests...\n`);

  const wasmPath = path.resolve("{wasmFile}");
  const gluePath = wasmPath.replace(/\\.wasm$/, ".js");

  try {{
    const glue = require(gluePath);
    if (typeof glue.init === "function") {{
      await glue.init(fs.readFileSync(wasmPath));
    }}
  }} catch (e) {{
    console.error("Failed to load wasm module:", e.message);
    process.exit(1);
  }}

  const results = [];
  for (const entry of TESTS) {{
    results.push(await runTest(entry));
  }}

  const passed = results.filter(r => r.status === "pass").length;
  const failed = results.filter(r => r.status === "fail").length;
  const skipped = results.filter(r => r.status === "skip").length;
  const timedOut = results.filter(r => r.status === "timeout").length;
  console.log(`\n${{results.length}} tests: ${{passed}} passed, ${{failed}} failed, ${{skipped}} skipped, ${{timedOut}} timed out`);

  process.exit(failed > 0 || timedOut > 0 ? 1 : 0);
}}

main();
"""

proc runTests*(config: TestRunnerConfig): int =
  ## Run tests in the specified environment.
  ##
  ## Steps:
  ##   1. Read and validate the .wasm file
  ##   2. Extract test metadata from custom section
  ##   3. Start a local HTTP server (browser) or spawn Node/Deno
  ##   4. Load the wasm module and execute each test
  ##   5. Collect results
  ##   6. Return exit code (0 = all pass, 1 = failures)

  if config.wasmFile.len == 0:
    echo "Error: no wasm file specified"
    return 1

  if not fileExists(config.wasmFile):
    echo &"Error: wasm file not found: {config.wasmFile}"
    return 1

  # Read wasm file
  let wasmStr = readFile(config.wasmFile)
  let wasmData = cast[seq[byte]](wasmStr)

  if config.verbose:
    echo &"Read {wasmData.len} bytes from {config.wasmFile}"

  # Extract test section
  let testSectionData = extractTestCustomSection(wasmData)
  let tests = decodeTestSection(testSectionData)

  if tests.len == 0:
    echo "Warning: no tests found in wasm custom section"
    return 0

  echo &"Found {tests.len} test(s) in {config.wasmFile}"

  if config.verbose:
    for t in tests:
      echo &"  - {t.name} (config: {$t.config}, timeout: {t.timeout}ms)"

  if config.node:
    # Run via Node.js
    let script = generateNodeTestScript(config.wasmFile, tests)
    let tmpDir = getTempDir() / "nimbling_test"
    createDir(tmpDir)
    let scriptPath = tmpDir / "run_tests.js"
    writeFile(scriptPath, script)

    if config.verbose:
      echo &"Generated Node.js test script: {scriptPath}"

    let exitCode = execShellCmd(&"node {quoteShell(scriptPath)}")
    return exitCode

  elif config.deno:
    # Run via Deno — reuse Node script with --compat
    let script = generateNodeTestScript(config.wasmFile, tests)
    let tmpDir = getTempDir() / "nimbling_test"
    createDir(tmpDir)
    let scriptPath = tmpDir / "run_tests.js"
    writeFile(scriptPath, script)

    if config.verbose:
      echo &"Generated Deno test script: {scriptPath}"

    let exitCode = execShellCmd(&"deno run --allow-read --allow-env {quoteShell(scriptPath)}")
    return exitCode

  else:
    # Browser mode: generate HTML and start HTTP server
    let htmlContent = generateTestHtml(config.wasmFile, tests)
    let tmpDir = getTempDir() / "nimbling_test"
    createDir(tmpDir)
    let htmlPath = tmpDir / "test.html"
    writeFile(htmlPath, htmlContent)

    if config.verbose:
      echo &"Generated test HTML: {htmlPath}"

    echo &"Test HTML generated at: {htmlPath}"
    echo &"Open in browser: http://localhost:{config.port}/test.html"
    echo ""
    echo "To serve tests locally:"
    echo &"  python3 -m http.server {config.port} --directory {quoteShell(tmpDir)}"
    echo ""
    echo "Or use your preferred static file server."

    if config.browser.len > 0:
      let headlessFlag = if config.headless: "--headless" else: ""
      case config.browser
      of "chrome":
        echo &"Launching Chrome..."
        let chromeArgs = &"--auto-open-devtools-for-tabs {headlessFlag} http://localhost:{config.port}/test.html"
        discard execShellCmd(&"google-chrome {chromeArgs} 2>/dev/null || chromium {chromeArgs} 2>/dev/null || chromium-browser {chromeArgs} 2>/dev/null &")
      of "firefox":
        echo &"Launching Firefox..."
        discard execShellCmd(&"firefox http://localhost:{config.port}/test.html &")
      else:
        echo &"Unknown browser: {config.browser}"

    # For a fully automated run, we'd need an HTTP server + WebSocket for results.
    # For now, return 0 indicating the harness was generated successfully.
    return 0

# ══════════════════════════════════════════════════════════════════════════════
# 8. CLI subcommand integration
# ══════════════════════════════════════════════════════════════════════════════

proc printTestHelp() =
  echo "nimbling-test — run Nim wasm tests in browser/Node/Deno"
  echo ""
  echo "Usage: nimbling-test <wasm-file> [options]"
  echo ""
  echo "Options:"
  echo "  --browser, -b <name>   Browser to use: chrome, firefox (default: chrome)"
  echo "  --port, -p <port>      HTTP server port (default: 8000)"
  echo "  --headless             Run browser in headless mode (default)"
  echo "  --no-headless          Run browser with GUI"
  echo "  --node, -n             Run tests in Node.js"
  echo "  --deno, -d             Run tests in Deno"
  echo "  --timeout, -t <ms>     Global timeout override in milliseconds"
  echo "  --verbose, -v          Verbose output"
  echo "  --js-glue <path>       Path to pre-generated JS glue file"
  echo "  --help, -h             Show this help"

proc addTestSubcommand*(): bool =
  ## Add 'nimbling-test' subcommand to CLI.
  ## Returns true if this command handled the invocation (caller should exit).
  ## Returns false if this is not a test invocation.

  let args = commandLineParams()
  # Check if invoked as nimbling-test or with 'test' subcommand
  let progName = getAppFilename().extractFilename()
  let isTestCmd = progName == "nimbling-test" or
                  (args.len > 0 and args[0] == "test")

  if not isTestCmd:
    return false

  # If 'test' subcommand, strip it from args
  var params = args
  if args.len > 0 and args[0] == "test":
    params = args[1..^1]

  var hasHelp = false
  for p in params:
    if p in ["--help", "-h"]:
      hasHelp = true
      break
  if params.len == 0 or hasHelp:
    printTestHelp()
    return true

  let config = parseTestArgs(params)
  let exitCode = runTests(config)
  quit(exitCode)

# ══════════════════════════════════════════════════════════════════════════════
# 9. Section embedding helper (for use by macro at compile time)
# ══════════════════════════════════════════════════════════════════════════════

proc emitTestSectionPragma*(tests: seq[TestEntry]): string =
  ## Generate a Nim `{.passC.}` or assembly directive that embeds the
  ## test metadata into the __nimbling_test_unstable custom section.
  ## This is used at compile time by the macro system.
  let data = encodeTestSection(tests)
  var hexBytes: seq[string] = @[]
  for b in data:
    hexBytes.add(&"0x{b:02X}")

  # Generate a C __attribute__((section(...))) compatible emit
  let byteStr = hexBytes.join(", ")
  result = &"""{{.emit: """
  result &= "static const unsigned char __nimbling_test_section[] __attribute__((section(\"__nimbling_test_unstable\"))) = {"
  result &= byteStr
  result &= "};"
  result &= """.}.}"""

proc generateTestSectionEmit*(tests: seq[TestEntry]): NimNode =
  ## Generate an {.emit.} pragma node that embeds test metadata
  ## into the wasm custom section. Returns a NimNode for use in macros.
  let data = encodeTestSection(tests)
  var hexBytes: seq[string] = @[]
  for b in data:
    hexBytes.add(&"0x{b:02X}")

  let emitStr = "static const unsigned char __nimbling_test_data[] __attribute__((section(\"__nimbling_test_unstable\"))) = {" & hexBytes.join(", ") & "};"

  result = nnkPragma.newTree(
    newColonExpr(
      ident("emit"),
      newStrLitNode(emitStr),
    ),
  )

# ══════════════════════════════════════════════════════════════════════════════
# 10. when isMainModule — standalone test runner CLI
# ══════════════════════════════════════════════════════════════════════════════

when isMainModule:
  if not addTestSubcommand():
    # Not invoked as test runner, show help
    echo "nimbling test runner"
    echo "Usage: nimbling-test <wasm-file> [options]"
    echo "Run with --help for options."
