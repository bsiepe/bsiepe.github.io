# bsiepe.github.io

Source of my academic website, [bsiepe.github.io](https://bsiepe.github.io), and my CV.

- `data/*.yml`: publications, talks, workshops, software, CV sections, news, profile.
  Checked against `schema/` by `npm run validate`.
- `content/`: blog posts and legal pages (Markdown).
- `site/`: the website (Astro). `cv/`: the CV (Typst).
- `talks/`, `workshops/`, `files/images/`: slides and photos, served at the same paths.

Every push to `main` validates the data, builds the CV and the site, and deploys to
GitHub Pages (`.github/workflows/site.yml`).

## Local preview

Needs Node 24 (version in `.nvmrc`) and, for the CV, Typst.

```sh
npm install && npm run validate && npm run cv && npm run export   # in the repo root
cd site && npm install && npm run dev                             # http://localhost:4321
```

`npm run build && npm run preview` (in `site/`) serves the production build, including search.
On Windows with fnm, prefix each command with `fnm exec --using=24` and use `npm.cmd`
(see `site/README.md`).
