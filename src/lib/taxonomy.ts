import { readFileSync } from "node:fs";
import { join } from "node:path";
import { parse } from "yaml";

interface RawField {
  label: string;
  subfields?: Record<string, string>;
  schemes?: Record<string, { label: string; file: string }>;
}

export interface Scheme {
  /** Id prefix of the scheme's fields, e.g. "CS/ACMCCS". */
  id: string;
  label: string;
}

export interface Field {
  id: string;
  label: string;
  /** Top-level field id; equal to `id` for a top-level field. */
  root: string;
  /** Ids of the broader fields this one also counts as: its ancestors within its scheme. */
  broader: string[];
  /** The classification scheme the field comes from, if any. */
  scheme?: Scheme;
}

// Resolved from the project root: this module is bundled, so its own location moves.
const read = (file: string) => parse(readFileSync(join(process.cwd(), file), "utf8"));
const raw: Record<string, RawField> = read("taxonomy.yml");

export const fields: Field[] = Object.entries(raw).flatMap(([root, { label, subfields, schemes }]) => [
  { id: root, label, root, broader: [] },
  ...Object.entries(subfields ?? {}).map(([sub, subLabel]) => ({
    id: `${root}/${sub}`,
    label: subLabel,
    root,
    broader: [],
  })),
  ...Object.entries(schemes ?? {}).flatMap(([key, { label: schemeLabel, file }]) => {
    const scheme = { id: `${root}/${key}`, label: schemeLabel };
    const entries: Record<string, string> = read(file);
    return Object.entries(entries).map(([path, name]) => schemeField(root, scheme, entries, path, name));
  }),
]);

function schemeField(root: string, scheme: Scheme, entries: Record<string, string>, path: string, name: string): Field {
  const steps = path.split("/");
  const ancestors = steps.slice(0, -1).map((_, i) => steps.slice(0, i + 1).join("/"));
  return {
    id: `${scheme.id}/${path}`,
    // Deeper entries name their top-level class first, as the ACM templates do:
    // "Software and its engineering → Just-in-time compilers".
    label: ancestors.length ? `${entries[ancestors[0]]} → ${name}` : name,
    root,
    broader: ancestors.map((a) => `${scheme.id}/${a}`),
    scheme,
  };
}

const byId = new Map(fields.map((f) => [f.id, f]));

export const fieldIds = fields.map((f) => f.id);

export function field(id: string): Field {
  const f = byId.get(id);
  if (!f) throw new Error(`Unknown field "${id}"`);
  return f;
}

/** The field's own name, without its top-level class in front ("Just-in-time compilers"). */
export function shortName(f: Field): string {
  return f.label.split(" → ").at(-1)!;
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
