# Adding a poster

One poster per pull request. If you use a coding agent, you can hand it this file and your
poster and let it do the rest.

## Files

```
posters/<slug>/
  poster.yml        metadata (required)
  poster.pdf        the poster as presented (required)
  poster-source/    what poster.pdf was made from (optional)
  abstract.pdf      the extended abstract, e.g. from the proceedings (optional)
  abstract-source/  what abstract.pdf was made from (optional)
```

The slug is the poster's URL: lowercase words joined by hyphens, specific enough to stay
unique, e.g. `gradual-notebooks-splash-2026`.

Keep each PDF under 50 MB. Whatever tool you made them in, export them to PDF, and share the
source too, so others can see how they were made:

| Made in | Share |
|---|---|
| LaTeX, Typst, Inkscape, … | the source files in the `-source/` folder |
| PowerPoint, Word, Keynote, LibreOffice | the `.pptx`, `.docx`, … file in the `-source/` folder |
| Google Slides or Docs | the link as `repository:` (sharing: *Anyone with the link: Viewer*), plus a `.pptx`/`.docx` export in the `-source/` folder |
| Canva, Figma, Overleaf | a view link as `repository:`, plus an export in the `-source/` folder if the tool has one |

The link lets others make an exact copy; the exported file stays even if the link stops
working.

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

fields:                      # ids from taxonomy.yml and its schemes, see below
  - CS/ACMCCS/SoftwareAndItsEngineering/SoftwareNotationsAndTools/Compilers/JustInTimeCompilers
  - CS/arXiv/cs.PL

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

paper: https://example.org/paper.pdf   # a related full paper, if any
doi: 10.1145/1234567.1234568    # usually the extended abstract's; without https://doi.org/
repository: https://github.com/you/project   # or a Google Slides, Overleaf, … link
```

Tags are free keywords for what the field doesn't say: methods, organisms, materials, topics.
Reuse existing spellings where you can. For example:

| Field | Tags |
|---|---|
| `CS/ACMCCS/…/GeneralProgrammingLanguages` | `type inference`, `Rust`, `notebooks` |
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
the `-source/` folders hold exactly what the PDFs were made from. Either, both or neither is
fine.

The `abstract:` key is a short summary shown on the page; `abstract.pdf` is the full extended
abstract. A poster usually has one DOI, the extended abstract's, and it goes in `doi:`.

Fields come from [taxonomy.yml](taxonomy.yml): a top-level id like `Biology` or a subfield
like `Biology/Ecology`. Pick the most specific one. If none fits, add it to `taxonomy.yml` in
the same pull request.

Fields also use established classification schemes, listed under `schemes:` in
`taxonomy.yml`, with their entries in [taxonomy/](taxonomy/). An id from a scheme is the
field, the scheme and the entry's path:

- Every field has the Springer Nature subjects of its disciplines, e.g.
  `Biology/SpringerLifeSciences/Ecology/LandscapeEcology`. If the paper was published by
  Springer, use the subjects listed on its SpringerLink page.
- Computer Science also has [ACM CCS](https://dl.acm.org/ccs), in
  [taxonomy/acm-ccs.yml](taxonomy/acm-ccs.yml):
  `CS/ACMCCS/SoftwareAndItsEngineering/SoftwareNotationsAndTools/Compilers/JustInTimeCompilers`.
  If the paper has CCS concepts (`\ccsdesc{Software and its engineering~Just-in-time
  compilers}` in the ACM LaTeX template), use those.
- Computer Science also has [arXiv](https://arxiv.org/category_taxonomy), in
  [taxonomy/arxiv-cs.yml](taxonomy/arxiv-cs.yml): `CS/arXiv/cs.PL`. If there is an arXiv
  preprint, use its categories.

Pick the most specific entries that fit; several fields, from several schemes, are fine.

Agents: take the metadata from the PDF, and ask the author for anything it doesn't show
(conference, year, source, repository) rather than guessing. You may look up missing
details online, such as the DOI, the conference's full name and URL, or ORCID iDs, but say so
explicitly: tell the author, and list every value you found online, with where you found
it, in the pull request description.

## Check and submit

Fork the repository and add the folder on a branch. `npm run build` fails with an
explanation if something is wrong (needs Node.js 22+ and `pdftoppm`). CI runs the same check
on the pull request.

```sh
gh pr create --title "Add poster: <title>" --template .github/PULL_REQUEST_TEMPLATE.md
```

Submissions are reviewed by hand before merging ([REVIEWING.md](REVIEWING.md)).
