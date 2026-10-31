# Website

Astro site, based on the [astro-scholar](https://github.com/shravanngoswamii/astro-scholar)
theme (MIT, see `LICENSE`; the theme's own README is `README.theme.md`).

The site has no content of its own. It reads:

- `../data/*.yml` through `src/lib/data.ts` (validated by `../scripts/validate.mjs`),
- `../content/blog/<slug>/index.md` as the `blog` collection,
- files outside `site/` (talk slides, photos, the CV PDF), copied into `public/`
  under their original paths by `scripts/sync-assets.mjs` before every dev and build run.

## Commands

Node 24 (see `.nvmrc`). Run from this folder:

    npm install
    npm run dev       # local preview at http://localhost:4321
    npm run build     # static site in dist/, with the Pagefind search index

Build the CV first (`npm run cv` in the repo root) so `/cv/cv_siepe.pdf` exists.
