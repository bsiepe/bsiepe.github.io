# Design brief: personal academic website and CV

Björn Siepe, postdoctoral researcher in psychological methods (Marburg University).
Two products share one data source: a static website and a PDF CV.
This folder shows their current state. I want design suggestions for both.

## What is in this folder

- `site/`: full-page screenshots of every page type, named
  `<nn>-<page>-<desktop|mobile>-<light|dark>.png` (desktop 1280 px, mobile 390 px).
- `cv/`: the academic CV as PDF and one PNG per page.

## Audience and purpose

Researchers, hiring committees, students, and collaborators. They come to find a
paper and its materials, slides of a talk, software, or the CV. The site should
feel like a careful researcher made it: plain, precise, information first.

## Website: fixed

- Content and structure: pages Home (bio, news, recent publications),
  Publications, Talks (list and one page per talk), Workshops, Software, Blog,
  CV (download link), lecture series, Impressum, Datenschutz.
- Every publication shows the same artifact slots in the same order: Paper,
  Preprint, Code, Data, Materials, Prereg. Missing ones stay visible, greyed out.
- Three research areas with a colour each: Simulation studies (cobalt
  `#0047AB`), Time series (`#2a9d8f`), Experience sampling (`#c77d2a`). Papers in
  two areas show both. The area filter on Publications and Talks stays.
- Talks list: thumbnail of the first slide, or a plain title card.
- Light and dark mode, both equally good.
- One photo of me, on the home page.
- Technical limits: no external requests at page load, so fonts must be
  self-hostable (OFL or similar) and no third-party embeds. Plain HTML/CSS, no
  heavy JavaScript. The site is built on the astro-scholar theme; suggestions
  should be achievable by restyling it (CSS, component markup), not by a new
  framework.

## Website: open for suggestions

- Typography: typefaces, sizes, weights, line length. Current: Atkinson
  Hyperlegible for text, Georgia-like serif for headings.
- Spacing and density of lists (publications, talks, workshops).
- Header and navigation, footer.
- Home page layout: how bio, photo, news, and recent papers are arranged.
- Presentation of the artifact slots and area labels.
- Overall character. It should be distinctive through information structure,
  not ornament.

## Website: what I do not want

- A "vibe-coded" look: light-grey caps-lock labels, gradients, glow, decorative
  icon cards, elements that carry no information.
- A left sidebar with my photo.
- Metrics (citation counts, download counts).
- Marketing tone in any text.

## CV: fixed

- Built on the Typst template `academicv`: section headings with a rule, a
  timeline with dates on the left. Libertinus Serif by default; IBM Plex Serif
  and Plex Sans are available.
- Section order: contact line, research profile, positions, grants, education,
  publications, software, talks, workshops, teaching, supervision, awards,
  service, reviewing.
- Publications in APA style with my name in bold, shared-authorship markers, and
  small linked artifact labels after each entry.
- Cobalt `#0047AB` for links.

## CV: open for suggestions

- Spacing, hierarchy, and density; how to make 9 pages easier to scan.
- Repeated years in the timeline: show a year once when consecutive entries
  share it (planned).
- Typography within the template: sizes, weights, font choice among the three.
- How grants, talks (grouped by type), and service are laid out.

## What to hand back

Annotated screenshots or mock-ups of the pages you would change, with notes on
what changed and why. Concrete values help most: font names and sizes, spacing
in px or rem, colours as hex. Results go into `design/` in this repository.
