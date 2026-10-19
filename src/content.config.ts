import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";
import { fieldIds } from "./lib/taxonomy";
import { srcCategories, srcResults, type SrcCategory, type SrcResult } from "./lib/competition";
import { thesisLevels } from "./lib/thesis";

// Authors, conferences and theses may be written as a single value; both forms become objects.
const shorthand = <T extends z.ZodType>(key: string, schema: T) =>
  z.preprocess((v) => (typeof v === "string" ? { [key]: v } : v), schema);

// ORCID iDs end in an ISO 7064 mod 11-2 check digit, which catches most typos.
function validOrcid(id: string): boolean {
  const digits = id.replaceAll("-", "");
  let total = 0;
  for (const d of digits.slice(0, -1)) total = (total + Number(d)) * 2;
  const check = (12 - (total % 11)) % 11;
  return digits.at(-1) === (check === 10 ? "X" : String(check));
}

const author = shorthand(
  "name",
  z.strictObject({
    name: z.string().min(1),
    affiliation: z.string().min(1).optional(),
    url: z.url().optional(),
    orcid: z
      .string()
      .regex(/^\d{4}-\d{4}-\d{4}-\d{3}[\dX]$/, {
        error: 'Write the bare ORCID iD, e.g. "0000-0002-1825-0097", not a URL.',
        abort: true,
      })
      .refine(validOrcid, "This ORCID iD has a wrong check digit; check it for typos.")
      .optional(),
  }),
);

const thesis = shorthand(
  "level",
  z.strictObject({
    level: z.enum(Object.keys(thesisLevels) as [keyof typeof thesisLevels], {
      error: () => `Thesis level must be one of: ${Object.keys(thesisLevels).join(", ")}.`,
    }),
    title: z.string().min(1).optional(),
    url: z.url().optional(),
  }),
);

// `src: true` for a competition without categories, `src: graduate` for a category alone.
const src = z.preprocess(
  (v) => (v === true ? {} : typeof v === "string" ? { category: v } : v),
  z.strictObject({
    category: z
      .enum(Object.keys(srcCategories) as [SrcCategory], {
        error: () => `SRC category must be one of: ${Object.keys(srcCategories).join(", ")}.`,
      })
      .optional(),
    result: z
      .enum(Object.keys(srcResults) as [SrcResult], {
        error: () => `SRC result must be one of: ${Object.keys(srcResults).join(", ")}.`,
      })
      .optional(),
  }),
);

const conference = shorthand(
  "name",
  z.strictObject({
    name: z.string().min(1),
    location: z.string().min(1).optional(),
    url: z.url().optional(),
  }),
);

// Where the printed poster hangs, e.g. a corridor at the author's institution.
const displayed = shorthand(
  "place",
  z.strictObject({
    place: z.string().min(1),
    url: z.url().optional(),
  }),
);

// Strict objects so a misspelled key ("feilds:") fails the build instead of being ignored.
const poster = z.strictObject({
  title: z.string().min(1),
  authors: z.array(author).min(1).optional(),
  fields: z
    .array(
      z.enum(fieldIds as [string, ...string[]], {
        error: (issue) => `Unknown field "${issue.input}". Use an id from taxonomy.yml or its schemes in taxonomy/, or add it to taxonomy.yml.`,
      }),
    )
    .min(1)
    .optional(),
  tags: z.array(z.string().min(1)).optional(),
  conference: conference.optional(),
  displayed: displayed.optional(),
  year: z.int().min(1900).max(2100).optional(),
  thesis: thesis.optional(),
  src: src.optional(),
  abstract: z.string().min(1).optional(),
  paper: z.url().optional(),
  doi: z
    .string()
    .regex(/^10\.\d{4,9}\/\S+$/, 'Write the bare DOI, e.g. "10.1145/3689492.3690052", not a URL.')
    .optional(),
  artifact: z.url().optional(),
  editable: z.url().optional(),
});

export const collections = {
  posters: defineCollection({
    // One folder per poster; the folder name is the poster's URL slug.
    loader: glob({
      pattern: "*/poster.yml",
      base: "./posters",
      generateId: ({ entry }) => entry.split("/")[0],
    }),
    schema: poster,
  }),
};
