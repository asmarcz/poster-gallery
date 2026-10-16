import { getCollection, type CollectionEntry } from "astro:content";
import assets from "../generated/assets.json";
import { site, url } from "../site";

export interface PosterAsset {
  pdf: string;
  pdfBytes: number;
  thumbs: Record<string, string>;
  width: number;
  height: number;
  hasSource: boolean;
}

export type Poster = CollectionEntry<"posters">["data"] & {
  slug: string;
  asset: PosterAsset;
};

const manifest = assets as Record<string, PosterAsset>;

/** Newest first; posters without a year go last, ties sorted by title. */
export async function getPosters(): Promise<Poster[]> {
  const entries = await getCollection("posters");
  return entries
    .map((e) => ({ ...e.data, slug: e.id, asset: manifest[e.id] }))
    .sort((a, b) => (b.year ?? -Infinity) - (a.year ?? -Infinity) || a.title.localeCompare(b.title));
}

export function pdfUrl(p: Poster): string {
  return url(p.asset.pdf);
}

export function thumbSrcset(p: Poster): string {
  return Object.entries(p.asset.thumbs)
    .map(([w, path]) => `${url(path)} ${w}w`)
    .join(", ");
}

export function thumbSrc(p: Poster, width: number): string {
  return url(p.asset.thumbs[width]);
}

export function sourceUrl(p: Poster): string | undefined {
  return p.asset.hasSource ? `${site.repoUrl}/tree/${site.commit}/posters/${p.slug}/source` : undefined;
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
