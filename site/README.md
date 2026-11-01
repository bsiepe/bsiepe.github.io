# Website

Astro site, based on the [astro-scholar](https://github.com/shravanngoswamii/astro-scholar)
theme (MIT, see `LICENSE`; the theme's own README is `README.theme.md`).

The site has no content of its own. It reads:

- `../data/*.yml` through `src/lib/data.ts` (validated by `../scripts/validate.mjs`),
- `../content/blog/<slug>/index.md` as the `blog` collection,
- files outside `site/` (talk slides, photos, the CV PDF), copied into `public/`
  under their original paths by `scripts/sync-assets.mjs` before every dev and build run.

## Commands

Node version in `.nvmrc`. First, in the repo root:

    npm install
    npm run cv        # CV PDFs (needs Typst)
    npm run export    # publications.bib, publications.json, lecture series .ics

Then in this folder:

    npm install
    npm run dev       # local preview at http://localhost:4321
    npm run build     # dist/, with search index and URL-mapping check

Talk thumbnails need `pdftoppm` (poppler); without it, talks get title cards.
CI runs the same steps (`../.github/workflows/site.yml`).
