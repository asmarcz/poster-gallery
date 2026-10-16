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
- Links and the DOI resolve to what they claim.

## Tags and fields

Tags are free text, so they need a careful look, or the filters fill with near-duplicates.

- Each tag is lowercase (unless a proper noun or acronym) and doesn't duplicate an existing
  tag under another spelling: `type inference`, not `Type-Inference`. Compare with
  `grep -rh -A20 "^tags:" posters/*/poster.yml`.
- Tags don't repeat the field.
- `fields` uses the most specific fitting id.
- A new entry in `taxonomy.yml` is really missing, sits under the right parent, has a
  PascalCase id and a spelled-out label.

## Files

- `poster.pdf` is the final poster, opens, and is under 50 MB.
- `source/`, if present, is the source of this PDF, without build leftovers, secrets or
  personal data.
- The authors agree to publishing it, and nothing is under embargo.
