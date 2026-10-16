// Prepares everything the site needs from posters/<slug>/ before Astro runs:
// - checks that each poster folder has a valid name, a poster.yml and a poster.pdf,
// - copies the PDF into public/ so GitHub Pages serves it (and browsers show it inline),
// - renders WebP thumbnails of the first page, cached by the PDF's hash in .cache/thumbs,
// - writes src/generated/assets.json, which the pages read.
//
// Thumbnails are only rendered for PDFs that are new or changed since the cache was filled.
// Bump THUMB_VERSION when the rendering settings change, so old cache entries are not reused.

import { execFile } from "node:child_process";
import { createHash } from "node:crypto";
import { existsSync } from "node:fs";
import { copyFile, mkdir, mkdtemp, readdir, readFile, rm, stat, writeFile } from "node:fs/promises";
import { availableParallelism, tmpdir } from "node:os";
import { join } from "node:path";
import { promisify } from "node:util";
import sharp from "sharp";

const run = promisify(execFile);

const THUMB_VERSION = 1;
const THUMB_WIDTHS = [480, 960, 1600];
const RENDER_LONG_EDGE = 2400;
const SLUG = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;
const MiB = 1024 * 1024;
const PAGES_LIMIT_WARNING = 800 * MiB;

const root = new URL("..", import.meta.url).pathname;
const postersDir = join(root, "posters");
const cacheDir = join(root, ".cache", "thumbs");
const publicDir = join(root, "public", "posters");
const manifestPath = join(root, "src", "generated", "assets.json");

async function sha256(path) {
  return createHash("sha256").update(await readFile(path)).digest("hex");
}

/** Renders page 1 into the cache unless it is already there; returns the image size. */
async function thumbnails(pdf, hash) {
  const key = `v${THUMB_VERSION}-${hash}`;
  const metaPath = join(cacheDir, `${key}.json`);
  if (existsSync(metaPath) && THUMB_WIDTHS.every((w) => existsSync(join(cacheDir, `${key}-${w}.webp`)))) {
    return { key, ...JSON.parse(await readFile(metaPath, "utf8")), cached: true };
  }

  const tmp = await mkdtemp(join(tmpdir(), "poster-thumb-"));
  try {
    const prefix = join(tmp, "page");
    await run("pdftoppm", ["-f", "1", "-l", "1", "-singlefile", "-png", "-scale-to", String(RENDER_LONG_EDGE), pdf, prefix]);
    const png = `${prefix}.png`;
    const { width, height } = await sharp(png).metadata();
    for (const w of THUMB_WIDTHS) {
      await sharp(png)
        .resize({ width: Math.min(w, width) })
        .webp({ quality: 82 })
        .toFile(join(cacheDir, `${key}-${w}.webp`));
    }
    await writeFile(metaPath, JSON.stringify({ width, height }));
    return { key, width, height, cached: false };
  } finally {
    await rm(tmp, { recursive: true, force: true });
  }
}

async function prepare(slug) {
  const dir = join(postersDir, slug);
  const errors = [];
  if (!SLUG.test(slug)) errors.push(`folder name must be lowercase words joined by hyphens, e.g. "my-poster-2026"`);
  if (!existsSync(join(dir, "poster.yml"))) errors.push("poster.yml is missing");
  const pdf = join(dir, "poster.pdf");
  if (!existsSync(pdf)) errors.push("poster.pdf is missing");
  if (errors.length) return { slug, errors };

  const hash = await sha256(pdf);
  const { size } = await stat(pdf);
  const thumb = await thumbnails(pdf, hash);

  const out = join(publicDir, slug);
  await mkdir(out, { recursive: true });
  // The PDF keeps the slug as its name so downloads are recognisable.
  await copyFile(pdf, join(out, `${slug}.pdf`));
  const short = hash.slice(0, 10);
  const srcset = {};
  for (const w of THUMB_WIDTHS) {
    const name = `thumb-${w}-${short}.webp`;
    await copyFile(join(cacheDir, `${thumb.key}-${w}.webp`), join(out, name));
    srcset[w] = `posters/${slug}/${name}`;
  }

  return {
    slug,
    errors,
    cached: thumb.cached,
    asset: {
      pdf: `posters/${slug}/${slug}.pdf`,
      pdfBytes: size,
      thumbs: srcset,
      width: thumb.width,
      height: thumb.height,
      hasSource: existsSync(join(dir, "source")),
    },
  };
}

/** Runs `fn` over `items` with at most `limit` running at once. */
async function pool(items, limit, fn) {
  const results = [];
  let next = 0;
  const workers = Array.from({ length: Math.min(limit, items.length) }, async () => {
    while (next < items.length) {
      const i = next++;
      results[i] = await fn(items[i]);
    }
  });
  await Promise.all(workers);
  return results;
}

const slugs = (await readdir(postersDir, { withFileTypes: true })).filter((e) => e.isDirectory()).map((e) => e.name).sort();

// public/posters is generated output: start clean so removed posters disappear.
await rm(publicDir, { recursive: true, force: true });
await mkdir(cacheDir, { recursive: true });

const results = await pool(slugs, availableParallelism(), prepare);

const failed = results.filter((r) => r.errors.length);
if (failed.length) {
  for (const r of failed) for (const e of r.errors) console.error(`posters/${r.slug}: ${e}`);
  process.exit(1);
}

const manifest = Object.fromEntries(results.map((r) => [r.slug, r.asset]));
await mkdir(join(root, "src", "generated"), { recursive: true });
await writeFile(manifestPath, JSON.stringify(manifest, null, 2) + "\n");

const rendered = results.filter((r) => !r.cached).length;
const total = results.reduce((sum, r) => sum + r.asset.pdfBytes, 0);
console.log(
  `${results.length} posters, ${(total / MiB).toFixed(1)} MiB of PDFs; ` +
    `${rendered} thumbnail${rendered === 1 ? "" : "s"} rendered, ${results.length - rendered} from cache`,
);
if (total > PAGES_LIMIT_WARNING) {
  console.warn(`warning: PDFs total ${(total / MiB).toFixed(0)} MiB; GitHub Pages sites are limited to 1 GB`);
}
