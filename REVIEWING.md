# Reviewing a poster

CI checks the folder and that `poster.yml` is valid. Check the rest by hand. Agents: report
problems with file and line, and leave approving and merging to a maintainer.

## Scope

- One folder in `posters/`, plus `taxonomy.yml` if it adds a field.
- A specific slug: `gradual-notebooks-splash-2026`, not `my-poster`.

## Metadata

- Title, authors (order and spelling), affiliations, conference and year match the poster.
- The conference name matches other posters from the same event
  (`grep -rh "name:" posters/*/poster.yml`).
- ORCID iDs belong to the named authors.
- `thesis` has the right level, and its link leads to the thesis.
- Links and the DOI resolve to what they claim.
- Values the PR says were looked up online match their sources. Ask about any that look
  looked up but aren't declared.

## Fields and tags

- `fields` uses the most specific entries, and matches the paper's ACM CCS concepts, preprint
  categories (arXiv, bioRxiv, medRxiv, ChemRxiv) or Springer subjects where it has them.
- Tags are lowercase (except proper nouns), don't repeat the field, and don't duplicate an
  existing tag under another spelling (`grep -rh -A20 "^tags:" posters/*/poster.yml`).
- A new `taxonomy.yml` field is really missing, sits under the right parent, and has a
  PascalCase id.

## Files and links

- `poster.pdf` is the final poster and is under 50 MB.
- `abstract.pdf` is this poster's extended abstract, and the DOI belongs to it.
- The `-source/` folders hold the sources of their PDFs, without build leftovers, secrets or
  personal data.
- `artifact` points to the research, not to the poster's source.
- `editable` points to an online-only tool (Google Slides, Canva, …), shows the same poster,
  and is view-only.
- The authors agree to publishing it, and nothing is under embargo.
