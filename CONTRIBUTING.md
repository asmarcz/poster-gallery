# Adding a poster

One poster per pull request. You can hand this file and your poster to a coding agent.

The posters already in [posters/](posters/) can be a good source of inspiration, and a handy
way to see how others filled things in.

## Files

```
posters/<slug>/
  poster.yml        metadata (required)
  poster.pdf        the poster as presented (required)
  poster-source/    what poster.pdf was made from
  abstract.pdf      the extended abstract, e.g. from the proceedings
  abstract-source/  what abstract.pdf was made from
```

The slug is the poster's URL, e.g. `gradual-notebooks-splash-2026`. Keep each PDF under 50 MB.

Commit the source files in the `-source/` folders: LaTeX, Typst, `.pptx`, `.docx`, SVG, …
For Google Slides, Canva and other online-only tools, put a view link in `editable:` and an
export in `poster-source/`.

## poster.yml

Only `title` is required. Leave out what you don't have.

```yaml
title: Incremental Type Inference for Gradually Typed Notebooks

authors:                     # in the order on the poster
  - name: Mira Svoboda
    affiliation: Example University
    url: https://example.org/~mira
    orcid: 0000-0002-1825-0097
  - Daniel Okafor            # a name alone works too

fields:                      # see Fields below
  - CS/ACMCCS/SoftwareAndItsEngineering/SoftwareNotationsAndTools/Compilers/JustInTimeCompilers
  - CS/arXiv/cs.PL

tags:                        # see Tags below
  - type inference

conference:                  # or just: conference: SPLASH 2026
  name: SPLASH 2026
  location: Oakland, CA
  url: https://example.org/splash-2026

displayed:                   # where the printed poster hangs; or just the place as text
  place: Hall on the 12th floor, building A, Example University, Prague
  url: https://maps.example.org/…

year: 2026

thesis:                      # or just: thesis: master
  level: master              # bachelor, master or doctoral
  title: Type Inference for Notebooks
  url: https://example.org/theses/12345

src:                         # student research competition; or just: src: true, src: first
  category: graduate         # undergraduate or graduate, if the competition has categories
  result: first              # finalist, first, second or third

abstract: |                  # short summary for the page
  First paragraph.

  Second paragraph.

paper: https://doi.org/10.1145/1234567.1234568   # any link to the paper
doi: 10.1145/1234567.1234568                      # usually the extended abstract's
artifact: https://github.com/you/tool             # the tool, code or data the poster presents
editable: https://docs.google.com/presentation/d/…/edit   # Google Slides, Canva, …
```

## Fields

Use ids from [taxonomy.yml](taxonomy.yml) and the schemes in [taxonomy/](taxonomy/):

- Springer subjects, for every field: `Biology/SpringerLifeSciences/Ecology/LandscapeEcology`.
  Reuse the subjects on the paper's SpringerLink page.
- [ACM CCS](https://dl.acm.org/ccs), for Computer Science:
  `CS/ACMCCS/SoftwareAndItsEngineering/…/JustInTimeCompilers`. Reuse the paper's `\ccsdesc`.
- [arXiv](https://arxiv.org/category_taxonomy), for Computer Science: `CS/arXiv/cs.PL`.
  Reuse the preprint's categories.

Pick the most specific entries; several are fine. If nothing fits, add a field to
`taxonomy.yml` in the same pull request.

## Tags

Free keywords for what the fields don't cover. Lowercase, and reuse existing spellings.

| Field | Tags |
|---|---|
| Computer Science | `type inference`, `Rust`, `notebooks` |
| Biology | `CRISPR`, `single-cell RNA-seq`, `Arabidopsis thaliana` |
| Chemistry | `catalysis`, `perovskites`, `NMR spectroscopy` |
| Physics | `quantum optics`, `Monte Carlo simulation` |
| Earth Sciences | `glaciology`, `remote sensing`, `urban heat islands` |
| Medicine | `randomized controlled trial`, `sepsis` |
| Humanities | `medieval manuscripts`, `digital humanities` |

## For agents

Take the metadata from the PDFs and ask the author for the rest. If you look anything up
online (DOI, conference URL, ORCID), tell the author and list each value with its source in
the pull request description.

## Submit

Work in a fork, on a branch. `npm run build` checks the folder (needs Node.js 22+ and
`pdftoppm`); CI runs the same check.

```sh
gh repo fork asmarcz/poster-gallery --clone
cd poster-gallery
git switch -c add-<slug>
# add posters/<slug>/, run npm run build, commit
git push -u origin add-<slug>
gh pr create --title "Add poster: <title>" --template .github/PULL_REQUEST_TEMPLATE.md
```

`--clone` makes your fork `origin` and this repository `upstream`, so the pull request goes
here without asking. In an existing clone, run `gh repo fork --remote` instead.

A maintainer reviews it by hand ([REVIEWING.md](REVIEWING.md)) before merging.
