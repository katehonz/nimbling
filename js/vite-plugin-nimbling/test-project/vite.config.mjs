import { defineConfig } from 'vite';
import nimbling from 'vite-plugin-nimbling';

export default defineConfig({
  plugins: [
    nimbling({
      target: 'web',
      verbose: true,
      cliPath: '../../../src/nimbling/cli',
    }),
  ],
});
