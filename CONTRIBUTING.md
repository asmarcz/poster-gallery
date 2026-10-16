# Submitting a poster

Each poster is one folder under `posters/`, added in its own pull request.
These instructions are written so that both people and coding agents can follow them.

## 1. Create the folder

```
posters/<slug>/
  poster.yml      required: metadata
  poster.pdf      required: the poster itself
  source/         optional: the source the PDF was built from
```

`<slug>` becomes the poster's URL. Use lowercase words joined by hyphens, and make it
specific enough to stay unique, e.g. `gradual-notebooks-splash-2026`.

## 2. Write `poster.yml`

Only `title` is required. Leave out any key you have no value for: don't write empty values.

```yaml
title: Incremental Type Inference for Gradually Typed Notebooks

authors:                      # in the order printed on the poster
  - name: Mira Svoboda
    affiliation: Example University      # optional
    url: https://example.org/~mira       # optional
  - Daniel Okafor                        # a plain name is fine too

fields:                       # one or more ids from taxonomy.yml
  - CS/ProgrammingLanguages

tags:                         # free-form keywords, lowercase unless a proper noun
  - type inference
  - notebooks

conference:                   # or just: conference: SPLASH 2026
  name: SPLASH 2026
  location: Oakland, CA                  # optional
  url: https://example.org/splash-2026   # optional

year: 2026

abstract: |                   # blank line between paragraphs
  First paragraph.

  Second paragraph.

paper: https://example.org/paper.pdf     # link to the associated paper
doi: 10.1145/1234567.1234568             # bare DOI, not a https://doi.org/ link
repository: https://github.com/you/project   # the project's repository, on any host
```

Unknown keys are rejected, so a typo like `feilds:` fails the check instead of being ignored.

### Fields

Fields come from [`taxonomy.yml`](taxonomy.yml). Use a top-level id (`Biology`) or a subfield
(`Biology/Ecology`); prefer the most specific one that fits. If nothing fits, add the field to
`taxonomy.yml` in the same pull request and say so in the PR description.

## 3. Add the PDF and, ideally, its source

- `poster.pdf` is published as-is and opens in the browser. Files over 50 MB make the
  repository slow for everyone; GitHub refuses files over 100 MB.
- `source/` should contain the source of **exactly this PDF** (LaTeX, Typst, Inkscape SVG, …),
  so the poster can be rebuilt or corrected later. The site links to it.
- `repository:` in `poster.yml` is for the living project, which may have moved on since.
  You can provide both, either, or neither.

## 4. Check locally (optional)

Needs Node.js 22+ and `pdftoppm` (from poppler-utils).

```sh
npm ci
npm run build      # fails with a message if poster.yml or the folder is invalid
npm run preview    # look at the result on http://localhost:4321
```

## 5. Open the pull request

One poster per pull request. From the command line:

```sh
gh pr create --title "Add poster: <title>" --template .github/PULL_REQUEST_TEMPLATE.md
```

CI builds the site with your poster; a red check means `poster.yml` or the folder needs fixing,
and the log says what. A maintainer then reviews the submission by hand
(see [REVIEWING.md](REVIEWING.md)) and merges it, after which it appears on the site.
