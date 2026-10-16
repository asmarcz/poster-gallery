import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";
import { fieldIds } from "./lib/taxonomy";

// Authors and conferences may be written as a plain name; both forms become objects.
const nameOrObject = <T extends z.ZodType>(schema: T) =>
  z.preprocess((v) => (typeof v === "string" ? { name: v } : v), schema);

const author = nameOrObject(
  z.strictObject({
    name: z.string().min(1),
    affiliation: z.string().min(1).optional(),
    url: z.url().optional(),
  }),
);

const conference = nameOrObject(
  z.strictObject({
    name: z.string().min(1),
    location: z.string().min(1).optional(),
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
        error: (issue) => `Unknown field "${issue.input}". Use an id from taxonomy.yml, or add it there.`,
      }),
    )
    .min(1)
    .optional(),
  tags: z.array(z.string().min(1)).optional(),
  conference: conference.optional(),
  year: z.int().min(1900).max(2100).optional(),
  abstract: z.string().min(1).optional(),
  paper: z.url().optional(),
  doi: z
    .string()
    .regex(/^10\.\d{4,9}\/\S+$/, 'Write the bare DOI, e.g. "10.1145/3689492.3690052", not a URL.')
    .optional(),
  repository: z.url().optional(),
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
