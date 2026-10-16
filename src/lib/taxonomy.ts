import { readFileSync } from "node:fs";
import { join } from "node:path";
import { parse } from "yaml";

type RawTaxonomy = Record<string, { label: string; subfields?: Record<string, string> }>;

export interface Field {
  id: string;
  label: string;
  /** Top-level field id; equal to `id` for a top-level field. */
  root: string;
}

// Resolved from the project root: this module is bundled, so its own location moves.
const raw: RawTaxonomy = parse(readFileSync(join(process.cwd(), "taxonomy.yml"), "utf8"));

export const fields: Field[] = Object.entries(raw).flatMap(([root, { label, subfields }]) => [
  { id: root, label, root },
  ...Object.entries(subfields ?? {}).map(([sub, subLabel]) => ({ id: `${root}/${sub}`, label: subLabel, root })),
]);

const byId = new Map(fields.map((f) => [f.id, f]));

export const fieldIds = fields.map((f) => f.id);

export function field(id: string): Field {
  const f = byId.get(id);
  if (!f) throw new Error(`Unknown field "${id}"`);
  return f;
}

/** Groups field ids under their top-level field, in order of first appearance. */
export function groupFields(ids: string[]): { root: Field; children: Field[] }[] {
  const groups = new Map<string, Field[]>();
  for (const id of ids) {
    const f = field(id);
    const children = groups.get(f.root) ?? [];
    if (f.id !== f.root) children.push(f);
    groups.set(f.root, children);
  }
  return [...groups].map(([root, children]) => ({ root: field(root), children }));
}
