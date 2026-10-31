# Migration report

Stage 2 is reviewed in three parts. This file grows with each part.

- **2a Publications** (this section, 2026-10-31, revised after review)
- 2b Talks and workshops (pending)
- 2c Everything else (pending)

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
