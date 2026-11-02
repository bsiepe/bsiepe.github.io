# CLAUDE.md

The website (Astro, `site/`) and the CV (Typst, `cv/`) are built from `data/` and
`content/` by the GitHub Action and deployed to GitHub Pages from `main`.
The Quarto site was retired at cutover on 2026-11-02.

Read `REDESIGN.md` before changing the data model, the site, or the CV: it records
the decisions and working rules. Design values for the site are in `design/HANDOFF.md`.

Slide files in `talks/` and `workshops/` and photos in `files/images/` are sources
for the site (copied by `site/scripts/sync-assets.mjs`); do not move them.
