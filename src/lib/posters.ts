import { getCollection, type CollectionEntry } from "astro:content";
import assets from "../generated/assets.json";
import { site, url } from "../site";

/** The poster itself or its extended abstract: a PDF and the files it was made from. */
export interface PosterDocument {
  pdf: string | null;
  pdfBytes: number | null;
  sourceFiles: string[];
}

export interface PosterAsset {
  thumbs: Record<string, string>;
  width: number;
  height: number;
  poster: PosterDocument & { pdf: string; pdfBytes: number };
  abstract: PosterDocument | null;
}

export type Part = "poster" | "abstract";

export type Poster = CollectionEntry<"posters">["data"] & {
  slug: string;
  asset: PosterAsset;
};

const manifest = assets as Record<string, PosterAsset>;

/** Newest first; posters without a year go last, ties sorted by title. */
export async function getPosters(): Promise<Poster[]> {
  const entries = await getCollection("posters");
  for (const e of entries) {
    // The dev server builds the asset list once at startup; posters added later are missing from it.
    if (!manifest[e.id]) throw new Error(`No assets for posters/${e.id}; run "npm run prepare-assets".`);
  }
  return entries
    .map((e) => ({ ...e.data, slug: e.id, asset: manifest[e.id] }))
    .sort((a, b) => (b.year ?? -Infinity) - (a.year ?? -Infinity) || a.title.localeCompare(b.title));
}

export function pdfUrl(p: Poster): string {
  return url(p.asset.poster.pdf);
}

export function thumbSrcset(p: Poster): string {
  return Object.entries(p.asset.thumbs)
    .map(([w, path]) => `${url(path)} ${w}w`)
    .join(", ");
}

export function thumbSrc(p: Poster, width: number): string {
  return url(p.asset.thumbs[width]);
}

const sourceFormats: Record<string, string> = {
  pptx: "PowerPoint",
  ppt: "PowerPoint",
  docx: "Word",
  doc: "Word",
  odp: "LibreOffice",
  odt: "LibreOffice",
  odg: "LibreOffice",
  key: "Keynote",
  pages: "Pages",
  tex: "LaTeX",
  typ: "Typst",
  svg: "SVG",
  ai: "Illustrator",
  indd: "InDesign",
  afdesign: "Affinity",
  afpub: "Affinity",
};

const textSources = new Set(["tex", "typ", "svg", "bib", "md", "txt"]);

/**
 * Link to the poster's or abstract's source folder at the commit the site was built from, named
 * after its main format. A single file links straight to the file; several link to the folder.
 */
export function sourceLink(p: Poster, part: Part): { url: string; label: string } | undefined {
  const files = p.asset[part]?.sourceFiles ?? [];
  if (!files.length) return undefined;

  const counts = new Map<string, number>();
  for (const f of files) {
    const format = sourceFormats[f.split(".").pop()!.toLowerCase()];
    if (format) counts.set(format, (counts.get(format) ?? 0) + 1);
  }
  const format = [...counts].sort((a, b) => b[1] - a[1])[0]?.[0];
  const label = format ? `${format} source` : "Source";

  const base = `${site.commit}/posters/${p.slug}/${part}-source`;
  if (files.length > 1) return { url: `${site.repoUrl}/tree/${base}`, label };
  // GitHub shows text files; binary ones (.pptx, .key, …) are better downloaded directly.
  const file = files[0].split("/").map(encodeURIComponent).join("/");
  const view = textSources.has(file.split(".").pop()!.toLowerCase()) ? "blob" : "raw";
  return { url: `${site.repoUrl}/${view}/${base}/${file}`, label };
}

/** Link to the poster in a proprietary online editor; Google links open Google's "make a copy" page. */
export function editableLink(p: Poster): { url: string; label: string } | undefined {
  if (!p.editable) return undefined;
  const google = p.editable.match(/^https:\/\/docs\.google\.com\/(presentation|document|drawings)\/d\/[^/?#]+/);
  if (google) {
    const app = { presentation: "Google Slides", document: "Google Docs", drawings: "Google Drawings" }[google[1]];
    return { url: `${google[0]}/copy`, label: `Copy in ${app}` };
  }
  const host = new URL(p.editable).hostname.replace(/^www\./, "");
  const app = { "canva.com": "Canva", "figma.com": "Figma" }[host];
  return { url: p.editable, label: app ? `Open in ${app}` : "Open editable version" };
}

/** "Ada Lovelace", "Ada Lovelace and Charles Babbage", "Ada Lovelace et al." */
export function authorsShort(p: Poster): string | undefined {
  const names = p.authors?.map((a) => a.name);
  if (!names?.length) return undefined;
  if (names.length === 1) return names[0];
  if (names.length === 2) return `${names[0]} and ${names[1]}`;
  return `${names[0]} et al.`;
}

/** "VMIL 2026", "VMIL", "2026", or undefined. The year is left out if the name already has it. */
export function venueLine(p: Poster): string | undefined {
  const name = p.conference?.name;
  const year = p.year && !name?.includes(String(p.year)) ? p.year : undefined;
  return [name, year].filter(Boolean).join(" ") || undefined;
}

export function formatBytes(bytes: number): string {
  const MiB = 1024 * 1024;
  return bytes >= MiB ? `${(bytes / MiB).toFixed(1)} MB` : `${Math.max(1, Math.round(bytes / 1024))} KB`;
}

function bibEscape(s: string): string {
  return s.replace(/[&%#_$]/g, (c) => `\\${c}`);
}

/** A @misc entry with whatever metadata the poster has. */
export function bibtex(p: Poster, pageUrl: string): string {
  const fields: [string, string | undefined][] = [
    ["title", `{${bibEscape(p.title)}}`],
    ["author", p.authors?.map((a) => bibEscape(a.name)).join(" and ")],
    ["year", p.year?.toString()],
    ["howpublished", p.conference ? `Poster presented at ${bibEscape(p.conference.name)}` : "Poster"],
    ["doi", p.doi],
    ["url", pageUrl],
  ];
  const body = fields
    .filter((f): f is [string, string] => Boolean(f[1]))
    .map(([k, v]) => `  ${k.padEnd(12)} = {${v}}`)
    .join(",\n");
  return `@misc{${p.slug},\n${body}\n}`;
}
