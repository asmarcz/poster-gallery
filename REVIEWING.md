# Reviewing a submission

For maintainers and for agents asked to review a poster pull request.
CI already checks the folder name, that `poster.pdf` exists, and that `poster.yml` matches the
schema (required title, known keys, field ids from `taxonomy.yml`, URL and DOI formats).
Everything below is what CI cannot judge and must be checked by reading the submission.
An agent should report each problem it finds with the file and line, and must not approve or
merge on its own.

## Scope

- [ ] The PR adds or changes exactly one folder under `posters/`, plus `taxonomy.yml` if a new
      field is introduced. Changes to anything else belong in a separate PR.
- [ ] The slug is specific (topic plus venue or year), not generic like `poster` or `my-poster`.

## Metadata matches the PDF

Open `poster.pdf` and compare:

- [ ] `title` matches the poster's title (capitalisation may differ).
- [ ] `authors` lists the same people, in the same order, with names spelled as on the poster.
      Affiliations, if given, match the poster.
- [ ] `conference` and `year` are plausible for the poster; the conference name follows the
      form already used by other posters from the same event (compare with
      `grep -rh "name:" posters/*/poster.yml`).
- [ ] `abstract`, if given, describes this poster and contains no markup that will not render
      (it is shown as plain paragraphs).
- [ ] `paper`, `doi`, `repository` and author `url`s resolve and point to what they claim.

## Free-form values need a human check

`tags` and new `taxonomy.yml` entries are not validated against anything, so review them
carefully; inconsistencies here fragment the filters on the site.

- [ ] Each tag is meaningful and not a duplicate in disguise of an existing tag: compare with
      `grep -rh -A20 "^tags:" posters/*/poster.yml` and ask for the existing spelling
      (`type inference`, not `Type-Inference` or `type-inference`).
- [ ] Tags are lowercase unless they are proper nouns or acronyms, and do not repeat the field.
- [ ] A new field in `taxonomy.yml` is genuinely missing: no existing field or subfield fits,
      the id is PascalCase, it sits under the right parent, and its label is spelled out.
- [ ] `fields` uses the most specific fitting id.

## Files

- [ ] `poster.pdf` is the final poster (not a draft, not a paper), opens, and has no
      password or broken fonts.
- [ ] The PDF is under 50 MB. If it is far larger than its content warrants (e.g. embedded
      full-resolution photos), ask the author whether a smaller export is possible.
- [ ] `source/`, if present, is the source of this PDF, contains no build artefacts beyond what
      is needed, and contains no secrets, credentials, personal data or large unrelated files.
- [ ] Everything submitted can be published: the authors agree to it being public, and
      nothing is under embargo.
