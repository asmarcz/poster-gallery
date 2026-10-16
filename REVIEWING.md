# Reviewing a poster

CI checks the folder, that the PDF exists and that `poster.yml` is valid. This list is
everything it can't check. Agents: report problems with file and line, and leave approving
and merging to a maintainer.

## Scope

- The PR touches one folder in `posters/`, plus `taxonomy.yml` if it adds a field.
- The slug is specific: `gradual-notebooks-splash-2026`, not `my-poster`.

## Metadata matches the PDF

- Title and authors match the poster, authors in the same order and spelling.
- Affiliations, conference and year match the poster. The conference name is written the
  same way as on other posters from that event (`grep -rh "name:" posters/*/poster.yml`).
- ORCID iDs belong to the named authors (open the link).
- `thesis`, if set, has the right level for the degree, and its link leads to that thesis.
- Links and the DOI resolve to what they claim.
- Every value the PR description says was looked up online is checked against its source
  with extra care; values that look looked up but are not declared are asked about.

## Tags and fields

Tags are free text, so they need a careful look, or the filters fill with near-duplicates.

- Each tag is lowercase (unless a proper noun or acronym) and doesn't duplicate an existing
  tag under another spelling: `type inference`, not `Type-Inference`. Compare with
  `grep -rh -A20 "^tags:" posters/*/poster.yml`.
- Tags don't repeat the field.
- `fields` uses the most specific fitting id.
- ACM CCS fields match the paper's CCS concepts, arXiv fields the preprint's categories, and
  Springer fields the SpringerLink subjects, if there are any.
- A new entry in `taxonomy.yml` is really missing, sits under the right parent, has a
  PascalCase id and a spelled-out label.

## Files

- `poster.pdf` is the final poster, opens, and is under 50 MB.
- `abstract.pdf`, if present, is the extended abstract of this poster, and the DOI belongs
  to it.
- `poster-source/` and `abstract-source/`, if present, are the sources of the matching PDF,
  without build leftovers, secrets or personal data.
- A `repository` link to an online editor (Google Slides, Canva, …) is read-only for anyone
  with the link. A link that grants edit access must be changed before merging.
- The authors agree to publishing it, and nothing is under embargo.
