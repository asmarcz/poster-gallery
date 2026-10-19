// Student research competitions: the category a poster competed in and how far it got.
export const srcCategories = {
  undergraduate: "Undergraduate",
  graduate: "Graduate",
} as const;

export const srcResults = {
  finalist: "Finalist",
  first: "1st place",
  second: "2nd place",
  third: "3rd place",
} as const;

export type SrcCategory = keyof typeof srcCategories;
export type SrcResult = keyof typeof srcResults;
