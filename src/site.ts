import { execFileSync } from "node:child_process";

// GitHub Actions sets these; locally they fall back to the values below.
const server = process.env.GITHUB_SERVER_URL ?? "https://github.com";
const repository = process.env.GITHUB_REPOSITORY ?? "asmarcz/poster-gallery";

function currentCommit(): string {
  if (process.env.GITHUB_SHA) return process.env.GITHUB_SHA;
  try {
    return execFileSync("git", ["rev-parse", "HEAD"], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim();
  } catch {
    return "main";
  }
}

export const site = {
  title: "Poster Gallery",
  description: "Academic posters with their PDFs and source.",
  repoUrl: `${server}/${repository}`,
  /** Source links point at the commit the site was built from, so they match the published PDF. */
  commit: currentCommit(),
};

export const contributingUrl = `${site.repoUrl}/blob/main/CONTRIBUTING.md`;

/** Prefixes a site-relative path with the configured base path. */
export function url(path = ""): string {
  return import.meta.env.BASE_URL.replace(/\/?$/, "/") + path.replace(/^\//, "");
}
