import { readFileSync } from "node:fs";
import { join } from "node:path";
import { parse } from "yaml";

type RawTaxonomy = Record<string, { label: string; subfields?: Record<string, string> }>;
/** ACM CCS concept path ("ACMCCS/SoftwareAndItsEngineering/…") to its name. */
type RawAcmCcs = Record<string, string>;

export interface Field {
  id: string;
  label: string;
  /** Top-level field id; equal to `id` for a top-level field. */
  root: string;
  /** Ids of the broader fields this one also counts as: its ancestors in the ACM CCS tree. */
  broader: string[];
}

/** The field's own name, without the ACM class in front ("Just-in-time compilers"). */
export function shortName(f: Field): string {
  return f.label.split(" → ").at(-1)!;
}

// Resolved from the project root: this module is bundled, so its own location moves.
const read = (file: string) => parse(readFileSync(join(process.cwd(), file), "utf8"));
const raw: RawTaxonomy = read("taxonomy.yml");
const acmCcs: RawAcmCcs = read("acm-ccs.yml");

/** The field whose subfields also include every ACM CCS concept. */
const ACM_ROOT = "CS";

export const fields: Field[] = Object.entries(raw).flatMap(([root, { label, subfields }]) => [
  { id: root, label, root, broader: [] },
  ...Object.entries(subfields ?? {}).map(([sub, subLabel]) => ({
    id: `${root}/${sub}`,
    label: subLabel,
    root,
    broader: [],
  })),
  ...(root === ACM_ROOT ? Object.entries(acmCcs).map(([path, name]) => acmField(root, path, name)) : []),
]);

function acmField(root: string, path: string, name: string): Field {
  const steps = path.split("/");
  // Every prefix below "ACMCCS" itself is an ancestor: ACMCCS/A, ACMCCS/A/B, …
  const ancestors = steps.slice(2).map((_, i) => steps.slice(0, i + 2).join("/"));
  const topClass = ancestors[0];
  return {
    id: `${root}/${path}`,
    // Named like the ACM templates do: "Software and its engineering → Just-in-time compilers".
    label: topClass ? `${acmCcs[topClass]} → ${name}` : name,
    root,
    broader: ancestors.map((a) => `${root}/${a}`),
  };
}

const byId = new Map(fields.map((f) => [f.id, f]));

export const fieldIds = fields.map((f) => f.id);

export function field(id: string): Field {
  const f = byId.get(id);
  if (!f) throw new Error(`Unknown field "${id}"`);
  return f;
}

/** Every field id a poster filed under `id` should be found by: itself, its broader fields and its root. */
export function matchingFields(id: string): string[] {
  const f = field(id);
  return [f.id, ...f.broader, f.root];
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
