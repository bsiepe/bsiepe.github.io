# Website and CV redesign

## Goal

One source of truth in this repo that renders:
1. a redesigned CV (Typst, several variants),
2. a redesigned website (Astro, static, GitHub Pages),
3. bibliographic exports of my publications (BibTeX, CSL-JSON), later synced to Zotero.

The current Quarto site stays live and untouched on `main` until cutover.
All work happens on the `redesign` branch.

## Ground truth and data flow

- `data/*.yml` is the only ground truth for everything structured: publications,
  talks, workshops, software, CV sections, news, profile and contact data.
- `content/blog/` (Markdown) is the ground truth for blog posts.
- `schema/*.schema.json` (JSON Schema) is the single definition of the data model.
  The validation script uses it directly; Astro collection schemas are generated
  from it, never maintained by hand.
- Data flows one way only: YAML -> CV, website, exports, Zotero.
  Nothing is ever read back from Zotero, OpenAlex, or Crossref into `data/`
  automatically. External sources may only produce suggestions or reports.
- I never edit my own publications in Zotero. Changes there do not flow back.
- Data is complete. Templates decide what to show. Do not drop entries because
  a CV variant will not display them.

## Stages and review gates

Work through these in order. STOP means: summarize what was done, list open
questions, and wait for my explicit go-ahead.

0. **Inventory.** Compare the inventory section below with the actual repo and
   `cv-legacy/`. Report anything missing or different. STOP.
1. **Schema.** Propose the JSON Schema for every data file, with one filled example
   entry per file using my real data. Point out fields where sources disagree or
   where no source has the information. STOP.
2. **Migration.** Migrate everything into `data/` and `content/`. Write the
   validation script and `MIGRATION_REPORT.md` (see Verification). STOP.
   I review the report entry by entry; nothing downstream starts before that.
3. **Typst CV.** Build the CV templates reading `data/` directly. Iterate with me
   using live preview. STOP before stage 4.
4. **Website design handoff.** I create designs in Claude Design and put the
   handoff (exports, screenshots, notes) in `design/`. Do not start the visual
   design of the site before `design/` exists. If the handoff is ambiguous, ask;
   do not fill gaps with framework or template defaults.
5. **Astro site.** Build the site from `data/`, `content/`, and `design/`.
   Include the URL mapping and redirect pages. STOP before cutover.
6. **Cutover.** Only after my approval (see Build and deployment).
7. **Later, separate tasks:** Zotero API sync, DOI-to-YAML stub helper,
   OpenAlex check. See the last section.

## Inventory of the current repo (must all be migrated or deliberately retired)

Verified in stage 0 (2026-10-31).

- `index.qmd`: bio text (about page, jolla template), a photo
  (`files/images/headshot_bjoern_siepe.jpg`), and a News timeline
  (`news-row` blocks, currently 3).
- `publications/index.qmd`: 25 publications as hand-written HTML blocks
  (title, initials-style authors, venue). Link labels: Paper, Preprint, Code,
  Code & Data, Code & Synthetic Data, Preregistration, Shiny App, Website,
  Chapter, Report. "Code & Data" is one URL for both. The link data exists only here.
  The LaTeX CV has 26: the 2021 German chapter (Talia & Siepe, Klett-Cotta)
  is not on the website.
- `publications/2023-07-19_bayesian-idiographic-networks_siepe-heck/`: leftover
  Hugo-Academic-style entry with abstract, summary, and url fields. Migrate its
  abstract/summary into the publication entry, then retire the folder.
- `talks/`: 18 folders, one `.qmd` each, with front matter (title, date,
  categories, image, description, license, `cv: pdf1..pdfN`). PDFs are per event:
  e.g. the openESM folder holds 7 PDFs for 7 venues. Pages embed the PDF in an
  iframe and offer a download button. 25 talk PDFs in `talks/`, plus one
  (`rStatsClub-Talk-Siepe-2026.pdf`) in `workshops/`.
  DGPPN 2022, DPK 2023, and APS 2023 have no slides file. FSM 2024 has
  self-contained HTML slides (15 MB) instead of a PDF.
  Folder names and front-matter dates disagree for 8 talks; the description
  line often lists several venues in one string. Talk pages link to related
  papers and repos. Page file names vary (`index-saa.qmd`, ...), so current URLs
  do too.
  The LaTeX CV lists 16 invited talks, 21 conference contributions, and 2 posters;
  many have no website page. DPK 2023 is only on the website.
- `workshops/`: 5 entries, some link to external repos (`bsiepe/dynamical-networks-workshop`,
  `bsiepe/repro-workshop`, `bsiepe/Talks`), OSF, and Zenodo. Folder
  `2025-02-31_preregistration-workshop` has an invalid date; front matter says 2025-01-31.
  The reproducibility workshop page is named `prereg-workshop-index.qmd`.
  The ECR 2024 workshop has self-contained HTML slides (20 MB).
  The LaTeX CV lists 10 workshops.
- `software/index.qmd`: 8 items in three groups (Websites & Databases, R packages,
  Python packages), hand-written HTML. openESM R and Python packages are two
  items here and one in the LaTeX CV (7 items).
- `blog/`: one post (`2026-05-20_varcheck`) with executed R chunks (`freeze`, `cache`),
  figures, two authors.
- `simulation-talk-series/index.qmd`: lunch lecture series schedule as an HTML
  table (date, speakers, title, Join / slides / recording links), plus
  `Simulation-Lecture-Dates.ics`. The `.ics` is to be generated from
  `lecture_series.yml` and served at its current URL.
- `files/images/`: four photos of me. `headshot_bjoern_siepe.jpg` is on the home
  page; `bjoern_headshot.png` (2.9 MB) is the social preview image.
- `cv/index.qmd`: embeds `cv_siepe.pdf` (built outside the repo from LaTeX).
  The URL of that PDF is likely linked from applications and must keep working.
- `impressum/impressum.qmd`: Impressum plus a short Datenschutz section.
- `goatcounter.html`: GoatCounter analytics snippet.
- Font Awesome and academicons via Quarto extensions and via cdnjs.
- `docs/` is the committed render output that GitHub Pages serves; `_site/` and
  `_freeze/` are Quarto artifacts (both tracked in git).
- `cv-legacy/`: LaTeX source (`latex/cv_english.tex`, `latex/resume.cls`,
  `latex/my_pubs.bib`) and PDF of my current CV. Cross-check sources only.
  `bjoern_siepe_cv_english.pdf` is the current CV; the served `cv/cv_siepe.pdf`
  is older. `my_pubs.bib` is effectively unused (18 old entries, mostly 2022/23
  conference abstracts); it only serves as a record of old talks and posters.
  There is no Zotero export: my Zotero library is not up to date and is not
  used as a source.
- LaTeX CV sections without a data file yet: Research Interests (4 bullets; no
  source has a research profile paragraph), Editorial Positions, Travel Grants &
  Scholarships, internships (mixed with research visits). Supervision exists only
  as counts. Commented-out content (MSc thesis, GPAs, a committee, skills,
  per-journal review counts with months, one APS 2022 talk) is migrated into
  `data/` and marked so that no template shows it by default.

## Data model

Files in `data/`. Field lists are minimums; propose additions in stage 1.

Stage 1 result (approved 2026-10-31): `schema/*.schema.json` is the binding
definition and supersedes the field lists below where they differ. Decisions:
talk events have `roles` (a list, incl. `coauthor`) and optional per-event
`title`; workshops have `sessions` like talk events; editorial positions are
`service.yml` entries with `kind: editorial`; internships live in
`research_stays.yml`; `hidden: true` marks commented-out legacy content;
file paths equal URL paths; countries are ISO alpha-2 codes; dates are quoted
strings (unquoted dates fail validation); titles are plain text, long-text
fields allow inline Markdown only; publication ids are `<first-author>-<keywords>`
without year; packages released for R and Python are two software entries.

- `profile.yml`: name, current position and affiliation, email, ORCID, GitHub,
  Bluesky, LinkedIn, Twitter, short research profile for the CV, and contact data
  for the Impressum. My institution changes soon; contact data must live only here.
- `publications.yml`, one entry per paper (not per version):
  `id` (stable slug), `type` (article, preprint, chapter, report, ...),
  `title`, `authors` as structured `{family, given}` with my entry marked,
  `shared_first` and `shared_second` (author positions), `venue`, `volume`, `issue`,
  `pages`, `year`, `status` (preprint, published, advance-online, in-press),
  `doi` (published version), `preprint_doi`,
  `links` (preprint, code, data, materials, prereg, supplement, slides),
  `areas`, `selected`, `abstract`, `summary`.
  Book chapters also need editors, book title, publisher.
  Store complete author lists. Truncation is a template decision.
- `talks.yml`, one entry per deck:
  `id`, `title`, `areas`, `abstract`, `links` (e.g. materials repo),
  optional `doi` (only decks I archive on Zenodo, manually),
  optional `thumbnail` (otherwise generated from the first PDF page),
  `events`: list of `{date, venue, city, country, online, type, role, file, coauthors}`.
  `type`: keynote, invited, colloquium, symposium, conference, lightning, panel, poster.
  `role`: speaker, chair, organizer, panelist.
  `file` is per event and points to that event's PDF.
- `workshops.yml`: `id`, `title`, `dates`, `host`, `location` or online,
  `duration_hours`, `coinstructors`, `description`, `links` (materials, repo, osf,
  zenodo), `license`, `areas`.
- `software.yml`: `name`, `language` or kind, `role` (author, maintainer,
  contributor), `coauthors`, `year`, `links` (cran, pypi, github, docs, doi),
  `description`.
- CV sections: `positions.yml` (month precision), `education.yml`,
  `research_stays.yml`, `grants.yml`, `awards.yml`, `teaching.yml`,
  `supervision.yml`, `service.yml`, `memberships.yml`, `reviewing.yml`,
  `media.yml`, `training.yml`, `community.yml`.
- `news.yml`: `date`, `text` (Markdown), optional `link`.
- `lecture_series.yml`: series metadata plus sessions
  `{date, time, speakers, title, links: {join, slides, recording}}`.
- Area tags: `simulation`, `timeseries`, `esm`. Entries can have several.
  Finer topic tags are allowed but normalized (one spelling, one case).
- Dates: ISO 8601 (`YYYY`, `YYYY-MM`, or `YYYY-MM-DD`, at the precision known).
  Never pad unknown precision with invented days or months.

## Blog

- Render the existing VARcheck post once through Quarto to Markdown with its
  figures and commit the output to `content/blog/<slug>/`. Keep the source `.qmd`
  next to it.
- New posts are plain Markdown, or `.qmd` rendered to Markdown locally with a
  script in `scripts/` before Astro picks them up. Astro never executes code.

## Verification

- `scripts/validate`: validates every file in `data/` against `schema/`. Fails on
  missing required fields, malformed dates or DOIs, unknown area tags, duplicate ids,
  and `file` paths that do not exist. Runs locally and in CI before any build.
- `MIGRATION_REPORT.md`:
  - entry counts per section in the LaTeX CV (`.tex` and `my_pubs.bib`),
    the website, and `data/`;
  - every disagreement between sources (titles, author lists, dates, venues),
    not resolved by you;
  - every field left empty;
  - every field filled from Crossref or DataCite, marked as such;
  - for every DOI: whether it resolves, and whether title, year, and first author
    match Crossref/DataCite;
  - every link that returns an error.
  Keep it short and scannable. I go through it entry by entry.
- Never invent metadata. Unknown stays empty and goes into the report.

## CV

- Typst reads `data/*.yml` directly via `yaml()`. No R, no LaTeX.
- Structure of the default academic variant: plain contact line, short research
  profile paragraph, positions, grants (DFG Eigene Stelle prominent, small stipends
  grouped), education, publications, software, talks, workshops, teaching,
  supervision, awards, service, reviewing.
  Omitted in this variant but kept in the data: online courses, school, pre-2019
  community service.
- Years only, except where duration matters (positions, research stays).
- Talks grouped by type. Keynotes, invited talks, and colloquia get one line each.
  Conference talks get one line per deck with venues and years combined.
  Posters separate.
- Publications: bold own name, †/‡ markers with legend, artifact links as small
  hyperlinked labels after each entry, showing only links that exist.
- Variants: parameters for section order, filters, and `selected`-only lists;
  thin variant files in `cv/variants/` that import the base template and override
  only what differs. Planned variants: academic default, full, selected publications
  with one-line contribution statements. A conservative variant must remain possible
  over the same data.
- Look: one typeface family, cobalt `#0047AB` only for section headings and links,
  single column, no icons. Try years in a narrow left margin column.
  No decoration that carries no information.
- Fonts are committed in `fonts/` (open licenses only) so CI builds are reproducible.
  Set PDF metadata (title, author). Print the build date.
- Output: the academic default must be served at the existing CV PDF URL.

## Website

- Distinctive through information structure, not ornament. One photo of me,
  placed as the design handoff specifies; no icon cards, no decorative elements
  that carry no information.
- Pages: home (bio, news), publications, talks, workshops, software, blog,
  CV (download link, no iframe), lecture series, Impressum, Datenschutz.
- Publications: fixed artifact slots per paper (preprint, data, code, materials,
  prereg), missing ones greyed out, not hidden. Area tags visible; papers spanning
  two areas make that visible.
- Talks: one page per deck, sorted by most recent event, all events listed, each
  with its own PDF. Thumbnail from the first page of the most recent PDF
  (`pdftoppm`) unless `thumbnail` is set. The existing per-talk images are not
  carried over. Talks without any PDF need a fallback (open question).
- No metrics (download counts, citation counts) unless I ask.
- Exports: `publications.bib` and `publications.json` (CSL-JSON, bibliographic
  core only) generated at build and served at stable URLs.
- URLs: before cutover, produce a mapping from every current URL (from `docs/`)
  to its new URL. Keep paths where reasonable; otherwise generate redirect pages
  (GitHub Pages has no server-side redirects).
- PDF URLs (the CV and every talk PDF) keep their exact current paths, or are
  served at both old and new paths. Redirect pages only work for HTML.
- Ask me before deciding: interactive filtering (small vanilla JS) vs static pages
  per area; whether to keep GoatCounter; whether to add site search (if yes,
  Pagefind, no external service).

## Privacy and legal

- No external requests at page load: self-host fonts and icons; no cdnjs, no
  Google Fonts, no embeds from third parties.
- Impressum and Datenschutz must match what the site actually does (GitHub Pages
  hosting, analytics if kept). The current Impressum cites the TMG, which has been
  replaced by the DDG. Draft updated texts for my review; do not publish legal
  text without my explicit approval.

## Build and deployment

- GitHub Action on push: validate -> build CV variants -> generate exports ->
  build Astro -> deploy via GitHub Pages artifact. Pull requests and the `redesign`
  branch build without deploying.
- Pin versions: Node (`.nvmrc` and in the Action), Typst (exact version in the
  Action), committed lockfile.
- Astro: minimal dependencies, plain `.astro` components and CSS, no React/Vue
  islands unless something truly needs interactivity. No upgrades without reason.
- `data/`, `schema/`, `content/`, and the Typst CV must not depend on Astro.
  The presentation layer has to stay replaceable.
- Cutover (only after my approval): switch the Pages source to GitHub Actions,
  verify the URL mapping live, then remove `docs/`, `_site/`, `_freeze/`, and the
  Quarto files in a separate commit.

## Later, separate tasks

- **Zotero sync:** local script, never in CI. Pushes publications from YAML into a
  dedicated Zotero collection via the Web API. Matches on `doi`, falling back to
  `preprint_doi`; updates items in place. Dry-run mode by default; never deletes
  items without explicit confirmation. API key in a local `.env`, never committed.
- **DOI-to-YAML stub helper:** queries Crossref/DataCite and writes a draft entry
  for me to complete.
- **OpenAlex check:** weekly GitHub Action querying OpenAlex for my ORCID; opens an
  issue when a DOI appears that is not in `data/`. Never writes to `data/`.

## Working rules

- Never invent metadata; never resolve source disagreements yourself.
- Do not modify or delete existing site files before cutover.
- Ask when something is ambiguous instead of choosing a default.
- Small, reviewable commits with clear messages.
- Generated text: plain and direct. No em dashes, no marketing tone, no overclaiming.

## Open questions (to settle before the stage that needs them)

1. Crossref/DataCite during migration: "never read back automatically" conflicts
   with "fields filled from Crossref, marked as such". Proposal: migration may fill
   only fields no repo source has, each fill listed in the report. Needed by stage 2.
   Resolved after the 2a review (2026-10-31): Crossref/DataCite wins for
   bibliographic fields whenever it has a record. This is a one-time migration
   step; afterwards data/ stays the only ground truth.
2. GoatCounter is an external request at page load, which conflicts with the
   privacy rule. Options: drop, self-host the script, or explicit exception.
   Needed by stage 5.
3. Resolved in stage 1: dates are quoted strings.
4. Resolved in stage 1: titles plain text, long-text fields inline Markdown.
5. Astro schemas generated from JSON Schema, or no Astro schema at all with
   `scripts/validate` as the only gate. Stage 5.
6. Ship the Typst CV to `main` (replacing `cv/cv_siepe.pdf`) right after stage 3,
   before the website is done.
7. Resolved: stage 2 is split into 2a publications, 2b talks and workshops,
   2c everything else, each with its own report section and review.
8. Thumbnail fallback for talks without a PDF (HTML slides, or no slides).
   Stage 5.
