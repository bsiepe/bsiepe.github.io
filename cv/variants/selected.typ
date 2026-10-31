// Selected publications with one-line contribution statements.
// Uses `selected: true` and `contribution` in data/publications.yml.
#import "../lib/cv.typ": cv
#cv(
  title: "Selected publications",
  sections: ("publications",),
  selected-only: true,
  contributions: true,
)
