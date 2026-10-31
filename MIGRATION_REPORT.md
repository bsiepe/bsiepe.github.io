# Migration report

Stage 2 is reviewed in three parts. This file grows with each part.

- **2a Publications** (this section, 2026-10-31)
- 2b Talks and workshops (pending)
- 2c Everything else (pending)

## 2a Publications

### Rules applied

- A repo source (website `publications/index.qmd`, LaTeX CV, Hugo preprint entry,
  talk pages) always wins over Crossref/DataCite. Where two repo sources disagree,
  the value Crossref confirms is used. If Crossref confirms neither, the more
  complete repo value is used. Every such case is listed under **Decide**.
- Crossref/DataCite only fill fields that no repo source has. Every fill is listed
  under **Filled**.
- Given names: Crossref's full given names replace repo initials only when they
  match those initials (e.g. "D. W." -> "Daniel W."). Otherwise the repo initials
  stay and the case is listed.
- Your own entry is always `Siepe, Björn S.`.

### Counts

| Source | Entries |
|---|---|
| LaTeX CV | 26 (6 preprints incl. 1 report, 18 articles, 2 chapters) |
| Website | 25 (missing: the 2021 German chapter) |
| `my_pubs.bib` | 18, of which 5 are earlier versions of these papers; not used |
| `data/publications.yml` | 26 |

### Decide

Values currently in `data/` are in **bold**.

1. **siepe-preregister-simulation-study**
   - Preprint DOI `10.31234/osf.io/cxjrb` (website and LaTeX) **does not resolve**.
     `10.31234/osf.io/cxjrb_v1` resolves, with the same title. Data: **`cxjrb`**.
   - Author order. Repo: **Siepe, Bartoš, Peikert, Heck, Sarafoglou, Boulesteix,
     Pawel**. Crossref: Siepe, Bartoš, Boulesteix, Heck, Peikert, Sarafoglou, Pawel.
2. **kloft-interval-consensus-model**
   - DOI. The website's `10.1007/s11336-024-10007-w` does not resolve. LaTeX:
     **`10.1017/psy.2025.10058`** (resolves, matches).
   - Status. Website and LaTeX: **advance online**. Crossref: 91(1), 199-222,
     print March 2026. Data has the volume and pages from Crossref, so it is
     inconsistent until you set the status.
3. **langener-preregistering-passive-smartphone**
   - Status. Website and LaTeX: **advance online**. Crossref: 56(8), 8289-8307
     (filled). Same inconsistency as above.
4. **rimpler-fred**
   - Pages. Website and LaTeX: **1-11**. Crossref: 51(4), 490-500. Volume and issue
     are filled from Crossref, so data now reads 51(4), 1-11.
5. **pawel-missingness-simulation-studies**
   - Title. Website and LaTeX: "...A Review of **Present** Practices...". Crossref
     and arXiv: "...A Review of Current Practices...".
6. **siepe-understanding-ema-data**
   - Title. Repo: **"Understanding EMA Data: A Tutorial on Exploring Item Performance
     in Ecological Momentary Assessment Data"**. Crossref: "Understanding
     Ecological-Momentary-Assessment Data: A Tutorial on Exploring Item Performance
     in Ecological-Momentary-Assessment Data".
7. **siepe-bayesian-idiographic-networks**
   - Authors. Website: 2 (Siepe, Heck). LaTeX and Crossref: **3 (Siepe, Kloft, Heck)**.
   - The abstract is from the 2023 preprint. The published version may differ.
8. **siepe-dynamic-network-features-treatment-selection**
   - Preprint version. Publication list: **`2c8xf_v1`**. Talk page: `2c8xf_v2`.
9. **pfadt-methodological-metamorphosis**
   - Preprint DOI. LaTeX: `ck3js` (does not resolve). Website: **`ck3js_v1`**.
10. **talia-attachment-group-psychotherapy**
    - Authors. Website: 7 (drops Neukel, Kaess, Bempohl, Herpertz without marking
      a gap). LaTeX: truncated with "...". Crossref: **11**.
    - "Bempohl, Felix" is spelled that way in Crossref. Please check the spelling.
11. **westhoff-psychological-flexibility-daily-lives**
    - Website: "Ciarocchi". LaTeX and Crossref: **"Ciarrochi"**.
12. **freeborn-language-learning-temporal-networks**
    - Book title. Repo: "Research Methods in Applied Linguistics (Vol. 14)". Crossref
      identifies this as the **series**; the book is **"Research Methods in CDST
      Approaches to SLD"** (filled). Crossref's chapter title has no subtitle.
13. **Name variants across entries.** Please choose one form per person:
    - Peña Loray: **"Pena Loray"** in pena-loray (LaTeX, Crossref) vs website
      "Peña Loray"; **"Peña Loray"** in hehlmann (all sources).
    - Fried: website and LaTeX vary between "E. I." and "E. I. F.", Crossref has
      "Eiko I.". Data: **E. I. F.** in vogelsmeier and openesm, **E. I.** in
      cloos, **Eiko I.** where all sources agree.
    - Rubel: **"J. A."** (website) vs "J." (LaTeX) vs "Julian" (Crossref) in
      pena-loray; "Julian A." in hehlmann.
    - Huth "K. B. S." vs Crossref "Karoline"; Dukers-Muijrers "N. H." vs "Nicole";
      Elsherif "M. M." vs "Mahmoud". Repo initials kept.
14. **talia-bindungsmuster-psychotherapie** (LaTeX only)
    - Publisher spelled **"Klett Cotta"**. Editor only as **"Brisch"** (no given name).
      No DOI or URL.

### Filled from Crossref/DataCite

| Entry | Fields |
|---|---|
| siepe-openesm | issue 8, `preprint_doi` 10.31234/osf.io/qfdtb_v2 (from Crossref's has-preprint) |
| kloft-interval-consensus-model | volume 91, issue 1, pages 199-222 |
| pawel-missingness-simulation-studies | volume 80, issue 1, pages 31-48, status published (no repo source states one) |
| siepe-understanding-ema-data | article number 25152459241286877 |
| freeborn-language-learning-temporal-networks | book title, editors' given names (Wander, Vanessa) |
| westhoff-psychological-flexibility-daily-lives | issue 1 |
| langener-preregistering-passive-smartphone | full author list (20; repo truncates), volume 56, issue 8, pages 8289-8307 |
| rimpler-fred | volume 51, issue 4 |
| talia-attachment-group-psychotherapy | authors 7 to 10 (Neukel, Kaess, Bempohl, Herpertz) |
| pfadt-methodological-metamorphosis | full author list (46; repo truncates) |
| all entries with a DOI | full given names where they match the repo initials |

### Derived (not stated as such in any source)

- Preprint DOIs from URLs: `10.31234/osf.io/ybns6` (siepe-ema-passive-sensors),
  `10.31234/osf.io/p4xf8` (langener), `10.48550/arXiv.2409.18527` (pawel). All
  resolve and match.
- `10.31234/osf.io/dvj8g` for siepe-understanding-ema-data comes from the MITNB
  2024 talk page, not from the publication list.
- "Code & Data" links (12) are stored as `code` and `data` with the same URL.
  "Code & Synthetic Data" links (3) are stored with `note: synthetic data` on `data`.
- I4R report: `type: report`, `status: published`.

### Empty

- All 26: `areas`, `tags`, `selected`, `contribution`.
- 25 of 26: `abstract`, `summary` (only siepe-bayesian-idiographic-networks has them).
- siepe-robustness-reproduction-cox: no DOI; coauthor given names are initials.
- talia-bindungsmuster-psychotherapie: no DOI, no URL, no editor given name.

### DOI check

38 DOIs. 37 resolve. Title, year, and first author match for 33; the others are
listed below. Year is compared for published DOIs only.

| Entry | DOI | Resolves | Title | Year | First author |
|---|---|---|---|---|---|
| siepe-preregister-simulation-study | `10.31234/osf.io/cxjrb` | **no** | | | |
| pawel-missingness-simulation-studies | `10.1080/00031305.2025.2540002` | yes | **no** (Current/Present) | yes | yes |
| pawel-missingness-simulation-studies | `10.48550/arXiv.2409.18527` | yes | **no** (Current/Present) | | yes |
| siepe-understanding-ema-data | `10.1177/25152459241286877` | yes | **no** (EMA spelled out) | yes | yes |
| freeborn-language-learning-temporal-networks | `10.1075/rmal.14.08fre` | yes | partial (no subtitle) | yes | yes |

Not in data, but found in the sources: `10.1007/s11336-024-10007-w` (website,
Interval Consensus Model) and `10.31234/osf.io/ck3js` (LaTeX) do not resolve.

<details>
<summary>All 38 DOIs</summary>

| Entry | Field | DOI | Resolves | Title | Year | First author |
|---|---|---|---|---|---|---|
| pena-loray-sample-size-institutional-effects | preprint_doi | `10.31234/osf.io/gswc9_v1` | yes (crossref) | yes | (2026) | yes |
| siepe-dynamic-network-features-treatment-selection | doi | `10.1037/met0000872` | yes (crossref) | yes | yes | yes |
| siepe-dynamic-network-features-treatment-selection | preprint_doi | `10.31234/osf.io/2c8xf_v1` | yes (crossref) | yes | (2025) | yes |
| vogelsmeier-careless-responding-ema | doi | `10.1037/met0000845` | yes (crossref) | yes | yes | yes |
| vogelsmeier-careless-responding-ema | preprint_doi | `10.31234/osf.io/4dfbz_v1` | yes (crossref) | yes | (2025) | yes |
| siepe-openesm | doi | `10.3758/s13428-026-03112-y` | yes (crossref) | yes | yes | yes |
| siepe-openesm | preprint_doi | `10.31234/osf.io/qfdtb_v2` | yes (crossref) | yes | (2026) | yes |
| haslbeck-model-checking-var | doi | `10.1037/met0000855` | yes (crossref) | yes | yes | yes |
| haslbeck-model-checking-var | preprint_doi | `10.31234/osf.io/k6uz4_v2` | yes (crossref) | yes | (2025) | yes |
| siepe-preregister-simulation-study | preprint_doi | `10.31234/osf.io/cxjrb` | **no** | | | |
| huth-social-connection-loneliness | preprint_doi | `10.31234/osf.io/mt76k_v1` | yes (crossref) | yes | (2026) | yes |
| bartos-living-synthetic-benchmarks | preprint_doi | `10.48550/arXiv.2510.19489` | yes (datacite) | yes | (2025) | yes |
| pfadt-methodological-metamorphosis | preprint_doi | `10.31234/osf.io/ck3js_v1` | yes (crossref) | yes | (2025) | yes |
| hehlmann-affect-dynamics-treatment-outcome | doi | `10.1037/pas0001384` | yes (crossref) | yes | yes | yes |
| hehlmann-affect-dynamics-treatment-outcome | preprint_doi | `10.31234/osf.io/3r9q6_v1` | yes (crossref) | yes | (2026) | yes |
| kloft-interval-consensus-model | doi | `10.1017/psy.2025.10058` | yes (crossref) | yes | yes | yes |
| kloft-interval-consensus-model | preprint_doi | `10.31234/osf.io/dzvw2` | yes (crossref) | yes | (2024) | yes |
| pawel-missingness-simulation-studies | doi | `10.1080/00031305.2025.2540002` | yes (crossref) | **no** | yes | yes |
| pawel-missingness-simulation-studies | preprint_doi | `10.48550/arXiv.2409.18527` | yes (datacite) | **no** | (2024) | yes |
| siepe-ema-passive-sensors | doi | `10.1037/abn0001013` | yes (crossref) | yes | yes | yes |
| siepe-ema-passive-sensors | preprint_doi | `10.31234/osf.io/ybns6` | yes (crossref) | yes | (2024) | yes |
| siepe-multiverse-dynamic-networks | doi | `10.5964/meth.15665` | yes (crossref) | yes | yes | yes |
| siepe-multiverse-dynamic-networks | preprint_doi | `10.31219/osf.io/etm3u` | yes (crossref) | yes | (2023) | yes |
| cloos-visual-analog-scales | doi | `10.1525/collabra.142735` | yes (crossref) | yes | yes | yes |
| cloos-visual-analog-scales | preprint_doi | `10.31219/osf.io/h2p4w_v1` | yes (crossref) | yes | (2025) | yes |
| siepe-understanding-ema-data | doi | `10.1177/25152459241286877` | yes (crossref) | **no** | yes | yes |
| siepe-understanding-ema-data | preprint_doi | `10.31234/osf.io/dvj8g` | yes (crossref) | yes | (2024) | yes |
| freeborn-language-learning-temporal-networks | doi | `10.1075/rmal.14.08fre` | yes (crossref) | partial | yes | yes |
| siepe-simulation-studies-template | doi | `10.1037/met0000695` | yes (crossref) | yes | yes | yes |
| siepe-simulation-studies-template | preprint_doi | `10.31234/osf.io/ufgy6` | yes (crossref) | yes | (2023) | yes |
| siepe-bayesian-idiographic-networks | doi | `10.1037/met0000672` | yes (crossref) | yes | yes | yes |
| siepe-bayesian-idiographic-networks | preprint_doi | `10.31234/osf.io/uwfjc` | yes (crossref) | yes | (2023) | yes |
| siepe-time-varying-networks-depression | doi | `10.2196/50136` | yes (crossref) | yes | yes | yes |
| westhoff-psychological-flexibility-daily-lives | doi | `10.1038/s41598-024-58598-3` | yes (crossref) | yes | yes | yes |
| langener-preregistering-passive-smartphone | doi | `10.3758/s13428-024-02474-5` | yes (crossref) | yes | yes | yes |
| langener-preregistering-passive-smartphone | preprint_doi | `10.31234/osf.io/p4xf8` | yes (crossref) | yes | (2024) | yes |
| rimpler-fred | doi | `10.1007/s10488-023-01324-4` | yes (crossref) | yes | yes | yes |
| talia-attachment-group-psychotherapy | doi | `10.4081/ripppo.2022.653` | yes (crossref) | yes | yes | yes |

</details>

### Link check

48 links, 32 unique URLs, checked 2026-10-31. No errors. The two Shiny apps
(`bsiepe.shinyapps.io/shiny-app/`, `solo-fsw.shinyapps.io/FRED/`) return 202
(app starting up), which is not an error.
