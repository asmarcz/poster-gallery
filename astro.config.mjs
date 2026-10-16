import { defineConfig } from "astro/config";

// In CI, actions/configure-pages provides the Pages origin and base path
// (e.g. https://lab.github.io and /poster-gallery). Locally the site lives at /.
export default defineConfig({
  site: process.env.SITE || undefined,
  base: process.env.BASE_PATH || "/",
  trailingSlash: "always",
});
