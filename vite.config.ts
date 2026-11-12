// @lovable.dev/vite-tanstack-config already includes the following — do NOT add them manually
// or the app will break with duplicate plugins:
//   - TanStack devtools (dev-only, first), tanstackStart, viteReact, tailwindcss, tsConfigPaths,
//     nitro (build-only using cloudflare as a default target), VITE_* env injection, @ path alias,
//     React/TanStack dedupe, error logger plugins, and sandbox detection (port/host/strictPort).
// You can pass additional config via defineConfig({ vite: { ... }, etc... }) if needed.
import fs from "node:fs";
import path from "node:path";
import { defineConfig } from "@lovable.dev/vite-tanstack-config";

/**
 * Server-side code reads configuration from process.env, but Vite only exposes
 * VITE_* variables on its own. Load the local files into process.env so
 * `npm run dev` behaves like the deployed worker, which receives these as real
 * environment variables. Anything already set in the environment wins.
 */
function loadServerEnv() {
  for (const file of [".env", ".dev.vars"]) {
    const filePath = path.resolve(process.cwd(), file);
    if (!fs.existsSync(filePath)) continue;
    for (const line of fs.readFileSync(filePath, "utf8").split(/\r?\n/)) {
      const match = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$/);
      if (!match) continue;
      const key = match[1]!;
      if (process.env[key] !== undefined) continue;
      process.env[key] = (match[2] ?? "").trim().replace(/^["']|["']$/g, "");
    }
  }
}

loadServerEnv();

export default defineConfig({
  tanstackStart: {
    // Redirect TanStack Start's bundled server entry to src/server.ts (our SSR error wrapper).
    // nitro/vite builds from this
    server: { entry: "server" },
  },
});
