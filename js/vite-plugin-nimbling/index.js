/**
 * Vite plugin for nimbling — compile Nim files to WebAssembly on the fly.
 *
 * Usage in vite.config.js:
 *   import { defineConfig } from 'vite';
 *   import nimbling from 'vite-plugin-nimbling';
 *
 *   export default defineConfig({
 *     plugins: [nimbling()]
 *   });
 *
 * Then in your app:
 *   import { greet } from './hello.nim';
 */

import { promises as fs } from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { exec } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

function execAsync(cmd, opts = {}) {
  return new Promise((resolve, reject) => {
    exec(cmd, opts, (err, stdout, stderr) => {
      if (err) {
        err.stdout = stdout;
        err.stderr = stderr;
        reject(err);
      } else {
        resolve({ stdout, stderr });
      }
    });
  });
}

async function which(cmd) {
  try {
    const { stdout } = await execAsync(`which ${cmd}`);
    return stdout.trim();
  } catch {
    return null;
  }
}

async function findNimblingCli() {
  // 1. Try PATH
  const fromPath = await which('nimbling');
  if (fromPath) return fromPath;

  // 2. Walk up from cwd looking for src/nimbling/cli (local dev)
  let dir = process.cwd();
  for (let i = 0; i < 10; i++) {
    const local = path.join(dir, 'src', 'nimbling', 'cli');
    try {
      await fs.access(local);
      return local;
    } catch {}
    const parent = path.dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }

  // 3. Common install locations
  const candidates = [
    path.join(process.cwd(), 'node_modules', '.bin', 'nimbling'),
    path.join(os.homedir(), '.nimble', 'bin', 'nimbling'),
    path.join(os.homedir(), '.local', 'bin', 'nimbling'),
    '/usr/local/bin/nimbling',
    '/usr/bin/nimbling',
  ];
  for (const c of candidates) {
    try {
      await fs.access(c);
      return c;
    } catch {}
  }
  return null;
}

export default function nimblingPlugin(options = {}) {
  const {
    target = 'web',
    nimOptions = '',
    cliPath = null,
    cacheDir = '.nimbling-cache',
    verbose = false,
  } = options;

  let resolvedCli = cliPath;

  async function compileNim(nimFile) {
    const baseName = path.basename(nimFile, '.nim');
    const outDir = path.join(path.dirname(nimFile), cacheDir);
    const wasmFile = path.join(outDir, `${baseName}.wasm`);
    const jsFile = path.join(outDir, `${baseName}.js`);
    const mjsFile = path.join(outDir, `${baseName}.mjs`);
    const generatedJs = target === 'nodejs' ? mjsFile : jsFile;

    // Look for pre-compiled .wasm next to .nim
    const prebuiltWasm = path.join(path.dirname(nimFile), `${baseName}.wasm`);
    let sourceWasm = wasmFile;
    let needsNimCompile = true;

    try {
      const [nimStat, wasmStat] = await Promise.all([
        fs.stat(nimFile),
        fs.stat(prebuiltWasm),
      ]);
      if (wasmStat.mtimeMs >= nimStat.mtimeMs) {
        sourceWasm = prebuiltWasm;
        needsNimCompile = false;
      }
    } catch {}

    if (needsNimCompile) {
      if (verbose) console.log('[nimbling] Compiling', nimFile);
      await fs.mkdir(outDir, { recursive: true });
      const nimcache = path.join(outDir, 'nimcache');
      await fs.mkdir(nimcache, { recursive: true });

      // Nim → C
      const nimCmd = [
        'nim c',
        nimOptions,
        '--cc:clang',
        '--os:standalone',
        '--cpu:wasm32',
        '-d:wasm32',
        '-d:release',
        '--compileOnly',
        `--nimcache:${nimcache}`,
        `--out:${path.join(nimcache, baseName)}`,
        `"${nimFile}"`,
      ].join(' ');

      if (verbose) console.log('[nimbling]', nimCmd);
      const nimResult = await execAsync(nimCmd);
      if (verbose && nimResult.stdout) console.log(nimResult.stdout);

      // C → WASM
      const cFiles = (await fs.readdir(nimcache))
        .filter(f => f.endsWith('.c'))
        .map(f => path.join(nimcache, f))
        .join(' ');

      let nimLibPath = '';
      try {
        const { stdout: nimPath } = await execAsync('which nim');
        const base = nimPath.trim();
        nimLibPath = path.join(path.dirname(base), '..', 'lib', 'nim');
        await fs.access(path.join(nimLibPath, 'nimbase.h'));
      } catch {
        for (const p of ['/usr/local/lib/nim', '/usr/lib/nim', '/usr/share/nim']) {
          try {
            await fs.access(path.join(p, 'lib', 'nimbase.h'));
            nimLibPath = path.join(p, 'lib');
            break;
          } catch {}
        }
      }
      const includeFlag = nimLibPath ? `-I"${nimLibPath}"` : '';

      const clangCmd = [
        'clang',
        '--target=wasm32',
        '-nostdlib',
        includeFlag,
        '-Wl,--no-entry',
        '-Wl,--export-all',
        `-o "${wasmFile}"`,
        cFiles,
      ].filter(Boolean).join(' ');

      if (verbose) console.log('[nimbling]', clangCmd);
      try {
        const clangResult = await execAsync(clangCmd);
        if (verbose && clangResult.stdout) console.log(clangResult.stdout);
      } catch (err) {
        if (sourceWasm !== prebuiltWasm) {
          try {
            await fs.stat(prebuiltWasm);
            console.warn('[nimbling] WASM compilation failed, using prebuilt:', prebuiltWasm);
            sourceWasm = prebuiltWasm;
          } catch {
            throw err;
          }
        } else {
          throw err;
        }
      }
    } else {
      await fs.mkdir(outDir, { recursive: true });
      await fs.copyFile(sourceWasm, wasmFile);
    }

    // nimbling CLI → JS glue
    const nbgCmd = [
      `"${resolvedCli}"`,
      `"${sourceWasm}"`,
      `--out-dir "${outDir}"`,
      `--target ${target}`,
    ].join(' ');

    if (verbose) console.log('[nimbling]', nbgCmd);
    const nbgResult = await execAsync(nbgCmd);
    if (verbose && nbgResult.stdout) console.log(nbgResult.stdout);

    return { outDir, wasmFile, generatedJs };
  }

  return {
    name: 'nimbling',
    enforce: 'pre',

    async buildStart() {
      if (!resolvedCli) {
        resolvedCli = await findNimblingCli();
        if (!resolvedCli) {
          throw new Error(
            'nimbling CLI not found. Install it via `nimble install nimbling` or set cliPath option.'
          );
        }
      }
      if (verbose) console.log('[nimbling] CLI:', resolvedCli);
    },

    async resolveId(source, importer) {
      if (!source.endsWith('.nim')) return null;
      if (path.isAbsolute(source)) return source;
      if (!importer) return null;
      return path.resolve(path.dirname(importer), source);
    },

    async load(id) {
      if (!id.endsWith('.nim')) return null;

      const nimFile = id;
      const baseName = path.basename(nimFile, '.nim');
      const outDir = path.join(path.dirname(nimFile), cacheDir);
      const generatedJs = path.join(outDir, `${baseName}${target === 'nodejs' ? '.mjs' : '.js'}`);

      // Check if rebuild is needed
      let needsBuild = true;
      try {
        const [nimStat, jsStat] = await Promise.all([
          fs.stat(nimFile),
          fs.stat(generatedJs),
        ]);
        if (jsStat.mtimeMs > nimStat.mtimeMs) {
          needsBuild = false;
        }
      } catch {}

      if (needsBuild) {
        await compileNim(nimFile);
      }

      const bgWasmName = `${baseName}_bg.wasm`;
      const bgWasmPath = path.join(outDir, bgWasmName);
      this.emitFile({
        type: 'asset',
        fileName: `_nimbling/${baseName}_bg.wasm`,
        source: await fs.readFile(bgWasmPath),
      });

      const relativeJs = path.relative(path.dirname(id), generatedJs);
      const relPath = './' + relativeJs.replace(/\\/g, '/');

      return (
        `export * from ${JSON.stringify(relPath)};\n` +
        `export { default } from ${JSON.stringify(relPath)};\n`
      );
    },

    async handleHotUpdate({ file, server }) {
      if (!file.endsWith('.nim')) return;

      if (verbose) console.log('[nimbling] HMR update for', file);

      try {
        await compileNim(file);
        // WASM modules cannot be safely hot-swapped, so trigger full reload
        server.ws.send({ type: 'full-reload', path: '*' });
        return [];
      } catch (err) {
        console.error('[nimbling] HMR compilation failed:', err.message);
        server.ws.send({
          type: 'error',
          err: {
            message: err.message,
            stack: err.stack || '',
          },
        });
        return [];
      }
    },
  };
}
