# Adding a poster

One poster per pull request. If you use a coding agent, you can hand it this file and your
poster and let it do the rest.

## Files

```
posters/<slug>/
  poster.yml    metadata (required)
  poster.pdf    the poster (required)
  source/       what the PDF was made from (optional)
```

The slug is the poster's URL: lowercase words joined by hyphens, specific enough to stay
unique, e.g. `gradual-notebooks-splash-2026`.

Keep the PDF under 50 MB. Whatever tool you made the poster in, export it to PDF for
`poster.pdf`, and share the source too, so others can see how it was made:

| Made in | Share |
|---|---|
| LaTeX, Typst, Inkscape, … | the source files in `source/` |
| PowerPoint, Word, Keynote, LibreOffice | the `.pptx`, `.docx`, … file in `source/` |
| Google Slides or Docs | a link in `editable:` (set sharing to *Anyone with the link: Viewer*), plus a `.pptx`/`.docx` export in `source/` |
| Canva, Figma, Overleaf | a view link in `editable:`, plus an export in `source/` if the tool has one |

A link lets others make an exact copy; the file in `source/` stays even if the link stops
working. Google links get a "make a copy" button automatically.

## poster.yml

Only `title` is required. Leave out keys you have no value for.

```yaml
title: Incremental Type Inference for Gradually Typed Notebooks

authors:                     # in the order on the poster
  - name: Mira Svoboda
    affiliation: Example University
    url: https://example.org/~mira
    orcid: 0000-0002-1825-0097   # without https://orcid.org/
  - Daniel Okafor            # a name alone works too

fields:                      # ids from taxonomy.yml
  - CS/SoftwareAndItsEngineering

tags:                        # free keywords, lowercase
  - type inference

conference:                  # or just: conference: SPLASH 2026
  name: SPLASH 2026
  location: Oakland, CA
  url: https://example.org/splash-2026

year: 2026

thesis:                      # if the poster presents a thesis; or just: thesis: master
  level: master              # bachelor, master or doctoral
  title: Type Inference for Notebooks
  url: https://example.org/theses/12345

abstract: |                  # blank line between paragraphs
  First paragraph.

  Second paragraph.

paper: https://example.org/paper.pdf
doi: 10.1145/1234567.1234568    # without https://doi.org/
repository: https://github.com/you/project
editable: https://docs.google.com/presentation/d/…/edit   # poster in an online editor
```

Tags are free keywords for what the field doesn't say: methods, organisms, materials, topics.
Reuse existing spellings where you can. For example:

| Field | Tags |
|---|---|
| `CS/SoftwareAndItsEngineering` | `programming languages`, `type inference`, `compilers` |
| `Biology/Genetics` | `CRISPR`, `single-cell RNA-seq`, `Arabidopsis thaliana` |
| `Chemistry` | `catalysis`, `perovskites`, `NMR spectroscopy` |
| `Physics` | `quantum optics`, `Monte Carlo simulation` |
| `EarthSciences` | `glaciology`, `remote sensing`, `urban heat islands` |
| `Medicine` | `randomized controlled trial`, `sepsis` |
| `Humanities` | `medieval manuscripts`, `digital humanities` |

Thesis levels don't depend on the country: Bc. and BSc are `bachelor`; Mgr., Ing. and MSc are
`master`; Ph.D. is `doctoral`. `url` points to the thesis itself, e.g. in your university's
repository.

`repository` is the project's own repository, which may have moved on since the poster;
`source/` is the poster as submitted. Either, both or neither is fine.

Fields come from [taxonomy.yml](taxonomy.yml): a top-level id like `Biology` or a subfield
like `Biology/Ecology`. Pick the most specific one. If none fits, add it to `taxonomy.yml` in
the same pull request.

Agents: take the metadata from the PDF, and ask the author for anything it doesn't show
(conference, year, source, repository) rather than guessing.

## Check and submit

Fork the repository and add the folder on a branch. `npm run build` fails with an
explanation if something is wrong (needs Node.js 22+ and `pdftoppm`). CI runs the same check
on the pull request.

```sh
gh pr create --title "Add poster: <title>" --template .github/PULL_REQUEST_TEMPLATE.md
```

Submissions are reviewed by hand before merging ([REVIEWING.md](REVIEWING.md)).
