# vite-plugin-nimbling

Vite plugin for [nimbling](https://github.com/zikomone/nimbling) — import `.nim` files directly in your Vite projects.

## Installation

```bash
npm install --save-dev vite-plugin-nimbling
```

Make sure you also have the `nimbling` CLI installed (via nimble):

```bash
nimble install nimbling
# or use the local CLI:
nimbling --help
```

## Usage

```js
// vite.config.js
import { defineConfig } from 'vite';
import nimbling from 'vite-plugin-nimbling';

export default defineConfig({
  plugins: [
    nimbling({
      // Options:
      target: 'web',        // 'web' | 'bundler' | 'nodejs' | 'deno'
      cliPath: 'nimbling',  // path to nimbling CLI binary
      cacheDir: '.nimbling-cache',
      verbose: false,
    })
  ]
});
```

Then in your app:

```js
import { greet, add } from './counter.nim';

async function main() {
  await greet();   // nimbling handles init() automatically
  console.log(add(2, 3));
}
main();
```

## How It Works

1. **Intercept `.nim` imports** — the plugin resolves `*.nim` files before Vite processes them.
2. **Compile to WASM** — runs `nim c --cpu:wasm32` + `clang --target=wasm32` to produce `.wasm`.
3. **Generate JS glue** — runs `nimbling` CLI on the `.wasm` to emit the JavaScript bindings.
4. **Emit as Vite asset** — copies `_bg.wasm` to `dist/_nimbling/` during build.

If you already have a pre-built `.wasm` next to your `.nim`, it will be used directly.

## HMR (Hot Module Replacement)

Editing a `.nim` file in dev mode (`vite dev`) triggers:

1. Automatic recompilation
2. **Full page reload** — WASM modules cannot be safely hot-swapped, so a full reload is issued. This ensures the new `.wasm` is picked up cleanly.

## Configuration Options

| Option      | Type      | Default             | Description                                  |
|-------------|-----------|---------------------|----------------------------------------------|
| `target`    | `string`  | `'web'`             | JS target: `web`, `bundler`, `nodejs`, `deno` |
| `cliPath`   | `string`  | auto-detect         | Path to nimbling CLI binary                  |
| `cacheDir`  | `string`  | `.nimbling-cache`   | Directory for intermediate files             |
| `nimOptions`| `string`  | `''`                | Extra flags passed to `nim c`                |
| `verbose`   | `boolean` | `false`             | Log compilation commands                     |

## Requirements

- **Vite** 4.x / 5.x / 6.x
- **Nim** 2.x
- **nimbling** CLI (install via `nimble install nimbling`)
- **clang** with WASM target support

## License

MIT
