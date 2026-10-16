# Poster Gallery

A static gallery of academic posters, built with [Astro](https://astro.build) and published on
GitHub Pages. Each poster is a folder under `posters/` with its metadata, PDF and optionally
its source; each submission is a pull request.

- Submitting a poster: [CONTRIBUTING.md](CONTRIBUTING.md)
- Reviewing a submission: [REVIEWING.md](REVIEWING.md)
- Research fields: [taxonomy.yml](taxonomy.yml)

## How it works

- `scripts/prepare-assets.mjs` runs before Astro. It checks each poster folder, copies the PDF
  into `public/` (Pages serves it, so it opens in the browser) and renders WebP thumbnails of
  the first page with `pdftoppm`. Thumbnails are cached in `.cache/thumbs` by the PDF's hash,
  so only new or changed posters are rendered.
- `src/content.config.ts` validates every `poster.yml`; an invalid file fails the build.
- `.github/workflows/site.yml` builds every pull request and deploys `main` to Pages, keeping
  the thumbnail cache and Astro's cache between runs.

## Setup

Set **Settings → Pages → Source** to **GitHub Actions**.

Folders named `posters/example-*` are ignored by git: use them for local sample content.

## Local development

Needs Node.js 22+ and `pdftoppm` (poppler-utils).

```sh
npm ci
npm run dev
```

## Limits

GitHub Pages sites are limited to 1 GB, and every deploy uploads the whole site, PDFs included.
The build prints the total PDF size and warns past 800 MB. All PDF links go through `pdfUrl()`
in `src/lib/posters.ts`, so moving PDFs to other hosting later is a change in one place.
