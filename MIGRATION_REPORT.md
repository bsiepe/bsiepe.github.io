# Migration report

Stage 2 is reviewed in three parts. This file grows with each part.

- **2a Publications** (2026-10-31, revised after review)
- **2b Talks and workshops** (2026-10-31, accepted as proposed)
- **2c Everything else** (2026-10-31, see below)

## 2a Publications

### Rules applied

- **Crossref/DataCite wins** for bibliographic fields (title, authors, given
  names, volume, issue, pages, status) whenever it has a record. Decided by you
  on 2026-10-31 after the first review.
- The published article's record is used where one exists, otherwise the
  preprint's record.
- Your own entry is always `Siepe, Björn S.`.
- Titles keep the repo capitalisation when Crossref differs only in case or a
  trailing period (APA deposits titles in sentence case).
- Repo sources are used where Crossref has nothing: links, shared authorship,
  the two entries without DOI, and preprint DOIs.

### Counts

| Source | Entries |
|---|---|
| LaTeX CV | 26 (6 preprints incl. 1 report, 18 articles, 2 chapters) |
| Website | 25 (missing: the 2021 German chapter) |
| `my_pubs.bib` | 18, of which 5 are earlier versions of these papers; not used |
| `data/publications.yml` | 26 |

### Changed by the Crossref rule

| Entry | Change |
|---|---|
| siepe-preregister-simulation-study | preprint DOI `cxjrb` (does not resolve) -> `cxjrb_v1`; author order now Siepe, Bartoš, Boulesteix, Heck, Peikert, Sarafoglou, Pawel |
| kloft-interval-consensus-model | DOI from LaTeX (the website's does not resolve); status advance online -> published, 91(1), 199-222 |
| langener-preregistering-passive-smartphone | status advance online -> published, 56(8), 8289-8307; 20 authors |
| rimpler-fred | 51(4), pages 1-11 -> 490-500 |
| pawel-missingness-simulation-studies | title "Present Practices" -> "Current Practices"; 80(1), 31-48, published |
| siepe-understanding-ema-data | title now spells out "Ecological-Momentary-Assessment" twice |
| siepe-bayesian-idiographic-networks | 3 authors (website had 2) |
| talia-attachment-group-psychotherapy | 11 authors (website had 7) |
| pfadt-methodological-metamorphosis | 46 authors; preprint DOI `ck3js_v1` (LaTeX's `ck3js` does not resolve) |
| westhoff-psychological-flexibility-daily-lives | "Ciarrochi" (website had "Ciarocchi") |
| freeborn-language-learning-temporal-networks | book title "Research Methods in CDST Approaches to SLD", series "Research Methods in Applied Linguistics" vol. 14, editors' given names |
| siepe-openesm | preprint DOI `qfdtb_v2` added (from Crossref; no repo source had it) |
| siepe-dynamic-network-features-treatment-selection | preprint DOI `2c8xf_v1` -> `2c8xf_v2` (latest version; the talk page links v2) |
| given names, several entries | Crossref form, also where it has fewer initials than the repo: Rubel "Julian", Haslbeck "Jonas", Huth "Karoline", Dukers-Muijrers "Nicole", Elsherif "Mahmoud", Fried "Eiko I." / "Eiko" |

### Still worth a look

- **Inconsistent across records.** Crossref spells "Pena Loray" in the 2026
  preprint and "Peña Loray" in the Hehlmann article. Fried is "Eiko I." in most
  records and "Eiko" in the Collabra one. Data follows each record. A template
  that prints initials shows the same "J. S." / "E. I." either way, except
  "E." for the Collabra entry.
- **"Bempohl, Felix"** (Talia et al. 2022) is spelled that way in Crossref.
  Possibly a typo in the deposit.
- **siepe-understanding-ema-data**: the preprint DOI `dvj8g` comes from the MITNB
  2024 talk page, not from the publication list.

### Filled

- **Abstracts** for 24 entries: 11 from the article record, 13 from the preprint
  record (APA and some others deposit no abstract with the article; the preprint
  abstract may differ from the published one). Not filled: the I4R report and the
  2021 chapter (no record). One abstract (JMIR) is structured; its section
  headings are bold.
- **Areas**, proposed by me, for 20 entries. Six have none because none of
  simulation / timeseries / esm fits: huth (loneliness, longitudinal),
  pfadt (metascience), kloft (psychometrics), the I4R report, and both Talia
  papers. Please correct:

| Area | Entries |
|---|---|
| simulation | pena-loray (Monte Carlo sample-size study), preregister-simulation-study, living-synthetic-benchmarks, missingness-simulation-studies, simulation-studies-template |
| timeseries | dynamic-network-features, model-checking-var, multiverse-dynamic-networks, freeborn (temporal networks), bayesian-idiographic-networks, time-varying-networks-depression |
| esm | careless-responding-ema, openesm, ema-passive-sensors, visual-analog-scales, understanding-ema-data, preregistering-passive-smartphone, fred |
| timeseries + esm | hehlmann (affect dynamics), westhoff (dynamic network in daily life) |

### Derived (not stated as such in any source)

- Preprint DOIs from URLs: `10.31234/osf.io/ybns6`, `10.31234/osf.io/p4xf8`,
  `10.48550/arXiv.2409.18527`. All resolve and match.
- "Code & Data" links (12) are stored as `code` and `data` with the same URL.
  "Code & Synthetic Data" links (3) are stored with `note: synthetic data` on `data`.
- I4R report: `type: report`, `status: published`.

### Empty

- All 26: `tags`, `selected`, `contribution`.
- siepe-robustness-reproduction-cox: no DOI, no abstract; coauthor given names are initials.
- talia-bindungsmuster-psychotherapie: no DOI, no URL, no abstract; editor only "Brisch";
  publisher spelled "Klett Cotta" as in the LaTeX CV.

### DOI check

38 DOIs, all resolve. Title, year, and first author match for 36. The two
remaining title differences are expected:

| Entry | DOI | Note |
|---|---|---|
| siepe-understanding-ema-data | `10.31234/osf.io/dvj8g` (preprint) | the preprint kept the short title "Understanding EMA Data" |
| freeborn-language-learning-temporal-networks | `10.1075/rmal.14.08fre` | Crossref stores the subtitle in a separate field; title plus subtitle matches |

### Link check

48 links, 32 unique URLs, checked 2026-10-31. All return 200.

## 2b Talks and workshops

### Rules applied

- No Crossref equivalent exists, so a fixed rule decides between sources:
  - **LaTeX CV** for title, venue, type, and role.
  - **Website** for day-precision dates and slides files.
  - **`my_pubs.bib`** for coauthors and months of 2022/23 talks.
- One entry per deck. Website folders whose talks have the **same CV title** are
  merged into one entry. Different titles stay separate entries.
- An event keeps its own `title` when the CV used a different title for it.
- Areas come from the website categories (Simulation Studies -> simulation,
  Time Series -> timeseries, EMA -> esm). The rest of each category list
  becomes tags. LaTeX-only talks: areas proposed by me.

### Counts

| Source | Talks | Workshops |
|---|---|---|
| LaTeX CV | 16 invited, 21 conference, 2 posters (+1 commented out) | 10 |
| Website | 18 pages, 26 slides files (25 PDF, 1 HTML) | 5 pages, 2 slides files |
| `my_pubs.bib` | 11 talk/poster entries (4 not in the CV) | |
| `data/` | 29 entries, 45 events (5 hidden) | 8 entries, 10 sessions |

All 28 slides files are referenced exactly once. All 7 external links return 200.

### Decide

1. **Merged decks.** Merged because the CV titles are identical. Split any you
   want as separate pages:
   - temporal-dynamics-depression: DGPPN 2022 + DPK 2023 (two website folders)
   - bayesian-idiographic-networks: FGME 2023 + IMPS 2024 (two folders)
   - simulation-studies-psychology: VMP 2024 + SIPS 2024 + DAGStat 2025 (two folders)
   - simulation-studies-state-of-the-art: FU Berlin, DGPs 2025, Münster, Lunch
     Lectures, Flake Lab, MSMR keynote (berlin-methods-kolloquium folder + MSMR folder)
2. **IMPS 2024.** The website files `IMPS24-Bjoern-Siepe.pdf` under the 2024
   simulation talk. The CV lists IMPS 2024 only as the panel "Quality Standards for
   Simulation Studies in Psychometrics". Data: a **separate panel entry with that PDF**.
3. **Titles where the website differs from the CV.** Data uses the CV title:

   | Entry | CV (in data) | Website |
   |---|---|---|
   | MSMR keynote | Simulation Studies for Methodological Research: Status Quo, Issues, and Potential Solutions | Simulation Studies in Psychology |
   | warn-d-ema-items | Developing EMA Items to Build an Early Warning System for Depression (WARN-D Study) | Item Validation in the WARN-D Study |
   | multiverse-dynamic-networks | GIMME, GIMME more (network models): Multiverse analysis for dynamic network models | Multiverse Analysis for Dynamic Network Models |
   | Lunch Lectures event | ...State of the Art, Issues, and Potential Solutions | series page: Simulation studies in psychology: State of the art, problems, and potential solutions |
   | preregistration-workshop | Preregistration in psychology and related fields | When, how, and why (not) to preregister |
   | openesm-workshop | ...Experience Sampling Datasets | ...experience sampling research |
   | introduction-dynamic-network-analysis (2024) | Introduction to Dynamic Network Analysis | Introduction to Dynamic Networks |
   | dynamic-network-analysis-r (2023) | Dynamic Network Analysis in R | Introduction to Dynamic Networks |

4. **Did you present these?** APS 2023 "Augmenting Self-Reports..." and ICPS 2023
   "Using passive sensor data...": the CV footnote says "shared first-authorship or
   coauthor with significant contributions". The bib lists Rieble or Proppert first.
   Data: **roles [coauthor]**. The same applies to the 5 hidden entries.
5. **2023 dynamic networks workshop.** The website has one "two part" page dated
   2023-06-28. The CV has two workshops: March 2023 "Introduction to Dynamic Network
   Analysis" (1.5h) and June 2023 "Dynamic Network Analysis in R" (3h). Data: **two
   entries**. The March one is a second session of the 2024 introduction workshop
   (same title), and the website page maps to June. Was March the first part of the
   two-part workshop?
6. **Dates where sources disagree.**
   - MITNB 2024: website **2024-04-16**, CV May 2024.
   - APS 2023 WARN-D items: website **2023-05-28**, bib June 2023.
   - Folder names differ from the front matter for DGPPN (**11-28** vs 11-01),
     APS 2023 (**05-28** vs 05-26), FGME 2023 (**09-12** vs 10-09), FSM
     (**02-15** vs 02-16), LIfBi (**06-25** vs 06-24). Front matter used.
   - Not used: the openESM page date 2026-08-05 and the 2024 simulation page date
     2024-06-07 (one date for several events).
7. **Hidden entries from `my_pubs.bib` only** (not in the CV): sleep and voice data
   (DGPPN 2022), triangulating self-reports (ICPS 2023), multimodal poster (APS 2023),
   Westhoff poster (DPK 2023; the bib lists only Westhoff as author). Plus the APS
   2022 talk that was commented out in the CV. Keep them hidden or delete?

### Derived (not stated as such in any source)

- License: the website says "CC BY" without version. Data: **CC-BY-4.0**, because
  the two workshop pages that name a version say 4.0. MSMR and JuMi pages state no
  license; their entries have none.
- Dates:
  - FU Berlin 2025-04-16 and Oxford EDGE 2025-11-17 come from the folder names
    (they match the CV month).
  - Research abroad panel 2026-10 (same meeting as the JuMi talk, 2026-10-06).
  - SAA 2025 poster 2025-05 (Best Poster Award dated 05/2025).
  - Lunch Lectures 2026-07-01 (series page).
  - APS 2022 2022-05-25 (commented-out CV line).
- Host of "Research on research methods": the youth member representatives of the
  DGPs Methods and Evaluation Division, taken from the lecture series page, which
  describes their yearly online workshop on simulation studies in German.
- `publications` links come from the talk pages, except two that I proposed:
  temporal-dynamics-depression -> siepe-time-varying-networks-depression, and the
  uncertainty poster -> siepe-dynamic-network-features-treatment-selection.
- Areas proposed by me (LaTeX-only entries): benchmarking-time-series-methods
  (timeseries), uncertainty poster (timeseries), both quality-standards panels
  (simulation), research-on-research-methods (simulation), augmenting and ICPS
  talks and the hidden ones (esm, timeseries for sleep/voice). No area: research
  abroad panel, ML symposium, preregistration talk, EFPSA primer, several
  workshops. "Towards Benchmarking of Psychological Time Series" has only
  simulation (from its website categories); timeseries may fit too.
- Posters: role speaker (the CV lists them as your poster presentations).
- Workshop descriptions are the website text, shortened only by dropping "The
  workshop consisted of". One typo fixed ("beneficts").

### Not carried over

- The per-talk images (thumbnails will come from the PDFs, as decided).
- The Zenodo link on the reproducibility workshop page: it credits the preview
  image (The Turing Way), not workshop material.

### Empty

- `abstract` for all talks (no source has one).
- Event dates at year precision only: 11 of 45. Month precision: 15.
- `city` for online events. `online` for the preregistration workshop (not stated).

## 2c Everything else

Profile, software, CV sections, news, lecture series, blog.

### Rules applied

- **LaTeX CV** for all CV sections (positions to community service).
- **Website** for the profile text, news, lecture series, and software links.
- **Registries win for software**, in line with the Crossref rule: CRAN DOI
  records (Crossref), the CRAN page, and PyPI.
- Commented-out CV content is migrated: grades (not printed by default
  templates), the M.Sc. thesis, the appointment committee, and skills (hidden).

### Counts

| File | LaTeX CV | Website | `data/` |
|---|---|---|---|
| positions | 7 | | 7 |
| education | 5 | | 5 |
| research_stays | 5 | | 5 |
| grants | 2 research + 7 travel/scholarship | | 9 |
| awards | 3 | | 3 |
| teaching | 5 | | 5 |
| supervision | 4 counts | | 4 counts |
| service | 13 + 2 editorial (+1 commented out) | | 16 (1 hidden) |
| memberships | 2 | | 2 |
| reviewing | 17 journals, 2 conferences | | 19 |
| media | 9 links | | 9 |
| training | 6 | | 6 |
| community | 5 | | 5 |
| news | | 3 | 3 |
| lecture_series | | 6 sessions (.ics: 3, consistent) | 6 sessions |
| software | 7 | 8 | 8 |
| profile | header, interests, skills | bio, links, Impressum | 1 |
| blog | | 1 post | 1 post |

### Decide

1. **Position title.** Website bio: "postdoctoral researcher". CV: "Scientific
   Assistant, 10/2022 - present". Data: **profile says Postdoctoral Researcher;
   positions.yml has Scientific Assistant until present**. Split the position at
   07/2026?
2. **Software changed by the registry rule.**
   - tsnet: description now "**Fitting**, Comparing, and Visualizing Networks
     Based on Time Series Data".
   - openesm (R): CRAN lists **Siepe and Kloft** (CV: Siepe only); description
     "Access the Open Experience Sampling Method Database".
   - openesm (Python): description from PyPI, "Access openESM experience sampling
     datasets"; PyPI lists only you.
   - gimme: **year 2014** (first release on CRAN), `contribution_year: 2025` (CV).
   - intervalpsych: the DOI `10.32614/CRAN.package.intervalpsych` (CV and
     website) **does not resolve**. Data uses the CRAN page URL instead.
3. **Broken link in the blog post.** "[raw code](https://github.com/bsiepe/bsiepe.github.io/blog)"
   returns 404, also on the live site. Once the site moves, the source will be
   `content/blog/varcheck/index.qmd`. Should I point the link there?
4. **Blog date.** Folder 2026-05-20, front matter **2026-05-26**. Data uses the
   front matter. New slug: `varcheck` (the old URL goes into the stage 5 mapping).

### Derived or chosen by me

- `kind` / `level` values in positions, research stays, grants, service, teaching.
- Doctorate field "Psychological Methods" comes from the website bio (the CV names none).
- Grants: no funder for the Erasmus stipend and the Deutschlandstipendium (the CV
  names none); `funder` is now optional in the schema.
- Media dates from URLs: Leiden 2025-07, Guardian 2025-08-08, The Signal 2025-12.
- Lecture series `about`: the page text, minus the lines now held in fields
  (time, organizer, contact) or generated by the site (meeting-link note, .ics
  link), and without the emoji.
- Bio links `../publications` etc. are now root paths (`/publications/`).
- Blog post: converted once from Quarto's frozen results; no code was re-run.
  Code, output, and figures are unchanged. Math is written as `$...$`, so the
  site needs a math renderer (stage 5). The two R figures have no alt text.
- Schema additions: `software.contribution_year`, `schema/blog.schema.json` for
  post front matter (also checked by `scripts/validate.mjs`).

### Empty

- profile `research_profile` (the CV paragraph still has to be written).
  Update (stage 3): a draft was written from the bio at your request and is
  used by the CV. It is new prose, not sourced text; review and edit it.
- supervision `as_of`.
- DFG grant: funding period and programme name.
- City for the German Depression Foundation internship.

### Not migrated (retired at cutover)

Listing pages (`*/index.qmd`), `_metadata.yml` files, `styles.css`, the two unused
photos (`bjoern_headshot.jpg`, `portrait_bjoern.jpg`, kept in the repo). GoatCounter
and the Impressum/Datenschutz text are stage 5 decisions; the Impressum contact
data is in `profile.yml`.

### Link check

All links in the 2c files return 200, except:
- the broken blog link above (404);
- LinkedIn (999), two tandfonline.com links in the blog post, and Techspot (403).
  These sites block automated requests; the pages open in a browser.
