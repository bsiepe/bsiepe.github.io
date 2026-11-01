# Website

Astro site, based on the [astro-scholar](https://github.com/shravanngoswamii/astro-scholar)
theme (MIT, see `LICENSE`; the theme's own README is `README.theme.md`).

The site has no content of its own. It reads:

- `../data/*.yml` through `src/lib/data.ts` (validated by `../scripts/validate.mjs`),
- `../content/blog/<slug>/index.md` as the `blog` collection,
- files outside `site/` (talk slides, photos, the CV PDF), copied into `public/`
  under their original paths by `scripts/sync-assets.mjs` before every dev and build run.

## Commands

Node version in `.nvmrc`. On Windows with fnm (PowerShell), each command runs
through `fnm exec` with `npm.cmd`. First, in the repo root:

    fnm exec --using=24 npm.cmd install
    fnm exec --using=24 npm.cmd run cv        # CV PDFs (needs Typst)
    fnm exec --using=24 npm.cmd run export    # publications.bib, publications.json, lecture series .ics

Then in this folder (`cd site`):

    fnm exec --using=24 npm.cmd install
    fnm exec --using=24 npm.cmd run dev       # local preview at http://localhost:4321
    fnm exec --using=24 npm.cmd run build     # dist/, with search index and URL-mapping check
    fnm exec --using=24 npm.cmd run preview   # serves dist/, including search

Install steps are needed once (and after dependency changes). Rerun `cv` and
`export` after changing `data/`; restart `dev` to pick up a new CV PDF.
With fnm set up in the PowerShell profile, plain `npm install`, `npm run dev`, etc. work too.

Talk thumbnails need `pdftoppm` (poppler); without it, talks get title cards.
CI runs the same steps (`../.github/workflows/site.yml`).
