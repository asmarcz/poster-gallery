import type { APIRoute } from "astro";
import { url } from "../site";

// GitHub Pages serves a project site under a path, so crawlers only read this file when the
// site has a domain of its own; the sitemap line still helps tools that fetch it directly.
export const GET: APIRoute = ({ site }) => {
  const lines = ["User-agent: *", "Allow: /"];
  if (site) lines.push(`Sitemap: ${new URL(url("sitemap-index.xml"), site)}`);
  return new Response(lines.join("\n") + "\n", { headers: { "Content-Type": "text/plain" } });
};
