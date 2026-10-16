// Thesis levels, independent of what a country calls the degree:
// Bc. and BSc are bachelor; Mgr., Ing. and MSc are master; Ph.D. is doctoral.
export const thesisLevels = {
  bachelor: "Bachelor’s thesis",
  master: "Master’s thesis",
  doctoral: "Doctoral thesis",
} as const;

export type ThesisLevel = keyof typeof thesisLevels;
