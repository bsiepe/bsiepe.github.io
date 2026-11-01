# Website design handoff

Decided 2026-11-01. This is the stage 4 handoff for the Astro site (stage 5).
Where it differs from `design/input/BRIEF.md`, this file wins.

Reference mock: `design/compare/index.html` (open it in a browser). It opens on the
chosen design: direction 3 "Scholarly", serif Crimson Pro, palette "Neutral + cobalt".
The other directions and options on that page were rejected and are kept only for reference.

## Decisions

- Headings and publication titles in Crimson Pro; running text in Atkinson Hyperlegible.
- Neutral white ground with the CV's cobalt as the only accent. No warm cream ground
  and no oxblood: both read as AI-generated.
- No time-series line or other motif in the header.
- Little space above the name on first load.
- The home page shows "Selected publications": entries with `selected: true` in
  `data/publications.yml`, newest first. Already built into `site/src/pages/index.astro`.
- Publication materials: only the ones that exist are shown, in a fixed order
  (Paper, Preprint, Code, Data, Materials, Prereg). Nothing greyed out.
- News dates and publication years use one style, in one margin column.
- Contact block under the photo: work email; ORCID, OSF, GitHub; Bluesky, LinkedIn.
  No CV link there, because the header already has one.

## Fonts

Self-hosted woff2, latin and latin-ext subsets, OFL 1.1. Files and license texts are in
`design/compare/fonts/` (`crimson-pro-*`, `atkinson-hyperlegible-*`, `licenses/`), with the
`@font-face` rules in `fonts.css`. These replace the current `site/public/fonts/atkinson-*.woff`.

| Role | Face | Weights |
| --- | --- | --- |
| Running text, metadata, navigation | Atkinson Hyperlegible | 400, 400 italic, 700 |
| h1, h2, wordmark, footer name, publication titles, dates and years | Crimson Pro | 500 (headings), 600 (titles), 400 (dates) |

## Colour

| Token | Light | Dark |
| --- | --- | --- |
| ground | `#ffffff` | `#131518` |
| ink (text, headings) | `#1b1c1e` | `#e6e7e9` |
| ink-2 (journal names) | `#36383c` | `#cdd0d4` |
| muted (role, authors, venue, dates) | `#56595e` | `#a2a6ab` |
| step (footer background) | `#f2f3f5` | `#1c1f23` |
| accent (links) | `#0047ab` | `#8db1ff` |

Topics have no colours (changed 2026-11-01, when the three areas became seven topics).
Running text is always full ink. No gradients, shadows, divider lines or uppercase labels.

## Type scale

| Use | Size / line height | Face, weight |
| --- | --- | --- |
| h1 (name) | 48 px / 1.05, tracking −0.01em | Crimson Pro 500 |
| h2 (section) | 30 px / 1.15 | Crimson Pro 500 |
| Publication title | 21 px / 1.3 | Crimson Pro 600 |
| Wordmark, footer name | 21 px | Crimson Pro 500 |
| Body | 17 px / 1.65 | Atkinson 400 |
| Role line | 16 px | Atkinson 400, muted |
| Navigation, authors, venue, materials, topics, contact | 15 px (22 px line height in entries) | Atkinson 400 |
| News dates, publication years | 17 px, lining tabular figures | Crimson Pro 400, muted |

Phones (≤ 560 px): h1 32 px, h2 24 px, dates and years 15 px.

## Spacing and frame

- 8 px scale: 8, 16, 24, 32, 48, 64, 96.
- Content max width 1040 px; side margins 32 px (16 px on phones).
- Section gap 96 px (64 px on phones). h2 to content: 32 px.
- Header: 24 px above the row; wordmark left, navigation and the search and theme buttons
  right, on one row down to 680 px; below that the navigation wraps to its own row.
- Intro: 48 px below the header. h1, then role 8 px below, then the bio 32 px below.
  Bio measure 66ch.

## Home page layout

Desktop:

```
Björn Siepe                                   Publications Talks ... CV  [search] [theme]

Björn Siepe                     (h1)
Postdoctoral Researcher, Psychological Methods Lab, Marburg University

Bio, 66ch ......................................   [photo 240 px, 4:5, 4 px radius]
................................................   email
................................................   ORCID · OSF · GitHub
................................................   Bluesky · LinkedIn

News
Jul 2026   text
Jul 2026   text

Selected publications
2026       Authors (muted)
           Title (serif)
           Journal, volume(issue), pages
           Paper · Preprint · Code      Topic · Topic
```

- The photo's top lines up with the first line of the bio (32 px + 6 px below the role).
  The contact block sits 24 px under the photo, in the same 240 px column.
- News dates and publication years sit in an 80 px column with a 24 px gap, on the same
  left edge as the name, bio and section headings. Entry text starts 104 px in.
  "All publications" lines up with the entry text.
- Within a publication list a year is printed only for the first entry of that year.
- 561–860 px: the photo shrinks to at most 30vw and sits beside the name and bio; the
  contact block stays under it.
- ≤ 560 px: photo 96 px beside the name; bio full width; contact block after the bio;
  dates and years sit above their entry instead of in a column.

## Publication entry

```
authors        15/22 px, muted, own name in 600 and ink
  4 px
title          Crimson Pro 600, 21/27 px, ink; link without underline, accent and underline on hover
  4 px
venue          15/22 px, muted; journal name and volume italic in ink-2
  8 px
materials      15 px, accent, regular weight, underline only on hover,
               separated by a muted middle dot with 8 px on each side
  32 px gap    topic labels on the same line, muted, separated by middle dots
```

40 px between entries. Topics always appear in the order of the topic list.

## Contact block

15 px / 1.6, links in accent without underline (underline on hover), 4 px between lines,
middle dots between links on one line. Values come from `data/profile.yml`
(`email.work`, `orcid`, `osf`, `github`, `bluesky`, `linkedin`).

## Not decided here

The other page types (publications list with the topic filter, talks list and talk page,
workshops, software, blog, lecture series, legal pages) follow the same tokens and the
publication entry above. Their layouts are designed in stage 5 and shown for review.
