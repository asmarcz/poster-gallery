import { authorsShort, type Poster } from "./posters";
import { url } from "../site";

/** The abstract's opening, or a sentence built from the metadata when there is no abstract. */
export function description(p: Poster): string {
  if (p.abstract) {
    const text = p.abstract.replace(/\s+/g, " ").trim();
    return text.length <= 200 ? text : `${text.slice(0, 197).replace(/\s+\S*$/, "")}…`;
  }
  // "Poster by Ada Lovelace et al. at SPLASH 2026.", "Poster by Ada Lovelace, 2025.", "Poster: <title>."
  const by = authorsShort(p);
  const conference = p.conference?.name;
  const year = p.year && !conference?.includes(String(p.year)) ? p.year : undefined;
  if (!by && !conference && !year) return `Poster: ${p.title}.`;
  return `Poster${by ? ` by ${by}` : ""}${conference ? ` at ${conference}` : ""}${year ? `, ${year}` : ""}.`;
}

const absolute = (path: string, site: URL) => new URL(url(path), site).href;

/**
 * Google Scholar's citation_* meta tags (https://scholar.google.com/intl/en/scholar/inclusion.html).
 * Scholar needs absolute URLs, so they are only emitted when the site's origin is known.
 */
export function citationMeta(p: Poster, site: URL | undefined): [string, string][] {
  const tags: [string, string][] = [["citation_title", p.title]];
  for (const a of p.authors ?? []) {
    tags.push(["citation_author", a.name]);
    if (a.affiliation) tags.push(["citation_author_institution", a.affiliation]);
    if (a.orcid) tags.push(["citation_author_orcid", `https://orcid.org/${a.orcid}`]);
  }
  if (p.year) tags.push(["citation_publication_date", String(p.year)]);
  if (p.conference) tags.push(["citation_conference_title", p.conference.name]);
  if (p.doi) tags.push(["citation_doi", p.doi]);
  if (p.tags?.length) tags.push(["citation_keywords", p.tags.join("; ")]);
  if (site) {
    tags.push(["citation_pdf_url", absolute(p.asset.poster.pdf, site)]);
    tags.push(["citation_abstract_html_url", absolute(`posters/${p.slug}/`, site)]);
  }
  return tags;
}

/** schema.org description of the poster for search engines. */
export function jsonLd(p: Poster, site: URL | undefined): Record<string, unknown> {
  const link = (path: string) => (site ? absolute(path, site) : url(path));
  return {
    "@context": "https://schema.org",
    "@type": "ScholarlyArticle",
    genre: "poster",
    headline: p.title,
    name: p.title,
    url: link(`posters/${p.slug}/`),
    author: p.authors?.map((a) => ({
      "@type": "Person",
      name: a.name,
      ...(a.url && { url: a.url }),
      ...(a.orcid && { sameAs: `https://orcid.org/${a.orcid}` }),
      ...(a.affiliation && { affiliation: { "@type": "Organization", name: a.affiliation } }),
    })),
    ...(p.year && { datePublished: String(p.year) }),
    ...(p.abstract && { abstract: p.abstract.trim() }),
    ...(p.tags && { keywords: p.tags.join(", ") }),
    ...(p.doi && { identifier: `https://doi.org/${p.doi}` }),
    image: link(p.asset.thumbs[960]),
    encoding: { "@type": "MediaObject", contentUrl: link(p.asset.poster.pdf), encodingFormat: "application/pdf" },
  };
}
