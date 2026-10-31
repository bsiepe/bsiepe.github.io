// CV built on the academicv template (https://typst.app/universe/package/academicv,
// Apache-2.0). This file is only an adapter: it reads data/*.yml and hands the
// entries to academicv's layouts. academicv's own YAML format is not used, so
// data/ stays the only source.
//
// Build:   node scripts/build-cv.mjs
// Preview: typst watch --root . --font-path fonts --ignore-system-fonts cv/variants/academic.typ
// Font:    Libertinus Serif (academicv's default, built into Typst); `--input font=plex-serif`
//          or `--input font=plex-sans` switches to IBM Plex (files in fonts/).

#import "@preview/academicv:1.1.0": setrules, showrules, layout-header, layout-timeline, layout-numbered-list, layout-prose

#let cobalt = rgb("#0047AB")

#let load(name) = yaml("/data/" + name + ".yml")
#let get(d, key, default: none) = d.at(key, default: default)
#let visible(xs) = xs.filter(x => not get(x, "hidden", default: false))

// ---------------------------------------------------------------- helpers

// academicv's list layouts evaluate Typst markup, so plain text must be escaped.
#let esc(s) = {
  let out = str(s)
  for c in ("\\", "#", "*", "_", "`", "$", "@", "<", "[", "]", "~") { out = out.replace(c, "\\" + c) }
  out.replace("//", "/\u{200B}/")
}

#let year-of(d) = str(d).slice(0, 4)
#let month-year(d) = { let s = str(d); if s.len() >= 7 { s.slice(5, 7) + "/" + s.slice(0, 4) } else { s.slice(0, 4) } }
#let fmt-end(d, f) = if d == "present" { "Present" } else { f(d) }
// One compact date string; academicv would otherwise insert " - " and wrap.
#let period(start, end, f) = { let a = f(start); let b = fmt-end(end, f); if a == b { a } else { a + "–" + b } }
// "2022", "2023", "2024", "2026" -> "2022–2024, 2026"
#let compress-years(ys) = {
  let ys = ys.map(y => int(year-of(y))).dedup().sorted()
  let runs = ()
  let start = ys.first()
  let prev = start
  for y in ys.slice(1) {
    if y == prev + 1 { prev = y } else {
      runs.push(if start == prev { str(start) } else { str(start) + "–" + str(prev) })
      start = y
      prev = y
    }
  }
  runs.push(if start == prev { str(start) } else { str(start) + "–" + str(prev) })
  runs.join(", ")
}
#let end-key(e) = { let v = get(e, "end", default: get(e, "start", default: "0000")); if v == "present" { "9999" } else { str(v) } }
#let cap(s) = if s.len() == 0 { s } else { upper(s.first()) + s.slice(1) }
#let end-punct(s) = if s.ends-with(".") or s.ends-with("?") or s.ends-with("!") { s } else { s + "." }
#let amount(a) = {
  let v = a.value
  let whole = calc.floor(v)
  let digits = str(whole).clusters().rev()
  let grouped = ()
  for (i, c) in digits.enumerate() {
    if i > 0 and calc.rem(i, 3) == 0 { grouped.push(",") }
    grouped.push(c)
  }
  let s = grouped.rev().join()
  let cents = calc.round((v - whole) * 100)
  if cents > 0 { s += "." + (if cents < 10 { "0" } else { "" }) + str(int(cents)) }
  (EUR: "€", USD: "$", GBP: "£").at(a.currency, default: a.currency + " ") + s
}
#let initials(given) = {
  if given == none { return "" }
  given.split(" ").filter(p => p != "").map(p => {
    if p.ends-with(".") and p.len() <= 4 { p } else { p.split("-").map(q => q.clusters().first() + ".").join("-") }
  }).join(" ")
}
#let short-name(p) = { let g = initials(get(p, "given")); if g == "" { p.family } else { p.family + ", " + g } }
#let full-name(p) = { let g = get(p, "given"); if g == none { p.family } else { g + " " + p.family } }
#let editor-name(p) = { let g = initials(get(p, "given")); if g == "" { p.family } else { g + " " + p.family } }
#let and-join(xs) = if xs.len() <= 1 { xs.join() } else if xs.len() == 2 { xs.at(0) + " & " + xs.at(1) } else { xs.slice(0, -1).join(", ") + ", & " + xs.last() }
#let nonempty(xs) = xs.filter(x => x != none and x != "")

// A small heading inside a section (academicv has none).
// Default indent matches the text column of academicv's timeline (7em + 1em
// gutter + 0.5em pad); lists use 3em (2em number column + 1em gutter).
#let subheading(t, indent: 8.5em) = block(above: 1.1em, below: 0.6em, sticky: true, pad(left: indent, text(weight: "semibold", t)))
#let section-title(t) = heading(level: 2, t)

// One timeline block. Entries are dictionaries with start-date / end-date and
// the fields named in primary / secondary / tertiary.
#let timeline(entries, primary, secondary: (), tertiary: (), settings) = layout-timeline(entries,
  primary-element: primary, secondary-element: secondary, tertiary-element: tertiary, settings: settings)

// ---------------------------------------------------------------- publications (markup strings)

#let format-authors(p, max: 20) = {
  let n = p.authors.len()
  let sf = get(p, "shared_first", default: ())
  let ss = get(p, "shared_second", default: ())
  let one(a, i) = {
    let mark = if (i + 1) in sf { "#super[†]" } else if (i + 1) in ss { "#super[‡]" } else { "" }
    let name = esc(short-name(a))
    if get(a, "me", default: false) { "*" + name + "*" + mark } else { name + mark }
  }
  let shown = range(n)
  if n > max {
    // APA 7: first 19, ellipsis, last. Keep my own entry if it falls in the gap.
    let me = p.authors.position(a => get(a, "me", default: false))
    shown = range(max - 1) + (if me != none and me >= max - 1 and me < n - 1 { (me,) } else { () }) + (n - 1,)
  }
  let out = ""
  for (k, i) in shown.enumerate() {
    if k > 0 {
      let gap = i != shown.at(k - 1) + 1
      out += if gap { ", … " } else if k == shown.len() - 1 { ", & " } else { ", " }
    }
    out += one(p.authors.at(i), i)
  }
  out
}

#let venue-markup(p) = {
  if p.type == "chapter" {
    let eds = get(p, "editors", default: ())
    let inner = nonempty((get(p, "series"), if get(p, "volume") != none { "Vol. " + p.volume }, if get(p, "pages") != none { "pp. " + p.pages.replace("-", "–") }))
    "In " + esc(and-join(eds.map(editor-name))) + (if eds.len() == 1 { " (Ed.), " } else { " (Eds.), " }) + "_" + esc(p.book_title) + "_" + (if inner.len() > 0 { " (" + esc(inner.join(", ")) + ")" } else { "" }) + ". " + esc(p.publisher) + "."
  } else if p.type == "report" {
    "_" + esc(p.venue) + "_" + (if get(p, "report_number") != none { " (No. " + esc(p.report_number) + ")" } else { "" }) + "."
  } else {
    let out = "_" + esc(p.venue) + (if get(p, "volume") != none { ", " + esc(p.volume) } else { "" }) + "_"
    if get(p, "issue") != none { out += "(" + esc(p.issue) + ")" }
    if get(p, "pages") != none { out += ", " + p.pages.replace("-", "–") }
    else if get(p, "article_number") != none { out += ", Article " + esc(p.article_number) }
    out += "."
    if p.status == "advance-online" { out += " Advance online publication." }
    if p.status == "in-press" { out += " In press." }
    out
  }
}

#let link-markup(url, label) = "#link(\"" + url + "\")[" + label + "]"
#let pub-links(p) = {
  let ls = get(p, "links", default: (:))
  let url-of(v) = if type(v) == dictionary { v.url } else { v }
  let items = ()
  if get(p, "doi") != none { items.push(link-markup("https://doi.org/" + p.doi, "Paper")) }
  else if get(p, "url") != none { items.push(link-markup(p.url, "Full text")) }
  if get(p, "preprint_doi") != none { items.push(link-markup("https://doi.org/" + p.preprint_doi, "Preprint")) }
  else if get(ls, "preprint") != none { items.push(link-markup(url-of(ls.preprint), "Preprint")) }
  let code = get(ls, "code")
  let data = get(ls, "data")
  let synthetic = type(data) == dictionary and get(data, "note") == "synthetic data"
  if code != none and data != none and url-of(code) == url-of(data) {
    items.push(link-markup(url-of(code), if synthetic { "Code & Synthetic Data" } else { "Code & Data" }))
  } else {
    if code != none { items.push(link-markup(url-of(code), "Code")) }
    if data != none { items.push(link-markup(url-of(data), if synthetic { "Synthetic Data" } else { "Data" })) }
  }
  for (key, lab) in (("materials", "Materials"), ("prereg", "Preregistration"), ("supplement", "Supplement"), ("app", "App"), ("website", "Website")) {
    if get(ls, key) != none { items.push(link-markup(url-of(ls.at(key)), lab)) }
  }
  items
}

#let pub-markup(p, cfg) = {
  let s = format-authors(p, max: cfg.max-authors) + " (" + str(p.year) + "). " + esc(end-punct(p.title)) + " " + venue-markup(p)
  if cfg.contributions and get(p, "contribution") != none { s += " \\ #text(size: 0.9em)[_Contribution:_ " + esc(p.contribution) + "]" }
  let links = pub-links(p)
  if links.len() > 0 { s += " \\ #text(size: 0.85em)[" + links.join(" #h(0.8em) ") + "]" }
  s
}

// ---------------------------------------------------------------- sections

#let profile-section(cfg, settings) = {
  let p = get(load("profile"), "research_profile")
  if p != none {
    section-title("Research Profile")
    layout-prose((esc(p),))
  }
}

#let positions-section(cfg, settings) = {
  section-title("Positions")
  let rank = (research: "3", consulting: "2", freelance: "2", student-assistant: "1")
  let entries = visible(load("positions")).sorted(key: p => rank.at(p.kind) + end-key(p) + str(p.start)).rev().map(p => (
    start-date: period(p.start, p.end, month-year),
    title: p.title,
    place: nonempty((p.institution, get(p, "unit"))).join(", "),
    info: nonempty((get(p, "project"), if get(p, "pi") != none { "PI: " + full-name(p.pi) })).join(", "),
    description: if cfg.descriptions { get(p, "description") },
  ))
  timeline(entries, ("title", "place"), secondary: ("info",), tertiary: ("description",), settings)
}

#let stays-section(cfg, settings) = {
  section-title("Research Stays")
  let entries = visible(load("research_stays")).sorted(key: s => s.start).rev().map(s => (
    start-date: period(s.start, s.end, month-year),
    institution: s.institution,
    role: s.role,
    info: nonempty((get(s, "unit"), get(s, "project"), if get(s, "host") != none { "Host: " + full-name(s.host) })).join(", "),
  ))
  timeline(entries, ("institution",), secondary: ("role",), tertiary: ("info",), settings)
}

#let grants-section(cfg, settings) = {
  section-title("Grants")
  let gs = visible(load("grants")).sorted(key: g => g.date).rev()
  let fmt(g) = (
    start-date: year-of(g.date),
    name: g.name,
    facts: nonempty((
      if get(g, "amount") != none { amount(g.amount) + if get(g, "amount_note") != none { " (" + g.amount_note + ")" } else { "" } },
      if get(g, "role") == "pi" { "principal investigator" },
    )).join(", "),
    project: get(g, "project_title"),
    purpose: get(g, "purpose"),
  )
  timeline(gs.filter(g => g.kind in ("research-grant", "internal-grant")).map(fmt), ("name", "facts"), secondary: ("project",), tertiary: ("purpose",), settings)
  let small = gs.filter(g => g.kind not in ("research-grant", "internal-grant"))
  if small.len() > 0 {
    subheading("Travel grants and scholarships")
    timeline(small.map(fmt), ("name", "facts"), tertiary: ("purpose",), settings)
  }
}

#let education-section(cfg, settings) = {
  section-title("Education")
  let levels = if cfg.school { ("doctorate", "master", "bachelor", "school") } else { ("doctorate", "master", "bachelor") }
  let entries = visible(load("education")).filter(e => e.level in levels).sorted(key: e => e.start).rev().map(e => {
    let thesis = get(e, "thesis")
    (
      start-date: period(e.start, e.end, year-of),
      institution: e.institution,
      degree: e.degree + (if get(e, "field") != none { " in " + e.field } else { "" }) + (if get(e, "distinction") != none { ", " + e.distinction } else { "" }),
      thesis: if thesis != none and not get(thesis, "hidden", default: false) { "Thesis: " + thesis.title },
    )
  })
  timeline(entries, ("institution",), secondary: ("degree",), tertiary: ("thesis",), settings)
}

#let publications-section(cfg, settings) = {
  section-title(if cfg.selected-only { "Selected Publications" } else { "Publications" })
  let ps = visible(load("publications"))
  if cfg.selected-only { ps = ps.filter(p => get(p, "selected", default: false)) }
  if ps.len() == 0 { text(fill: red)[No publications are marked `selected: true` in data/publications.yml.]; return }
  for (title, kind) in (("Peer-reviewed articles", "article"), ("Book chapters", "chapter"), ("Reports", "report"), ("Preprints", "preprint")) {
    let items = ps.filter(p => p.type == kind).sorted(key: p => p.year).rev()
    if items.len() == 0 { continue }
    subheading(title, indent: 3em)
    layout-numbered-list(items.map(p => pub-markup(p, cfg)))
  }
  if ps.any(p => get(p, "shared_first") != none or get(p, "shared_second") != none) {
    block(above: 0.8em, pad(left: 3em, text(size: 0.85em)[#super[†] Shared first authorship. #h(0.8em) #super[‡] Shared second authorship.]))
  }
}

#let software-section(cfg, settings) = {
  section-title("Software and Research Infrastructure")
  let entries = visible(load("software")).sorted(key: s => get(s, "contribution_year", default: s.year)).rev().map(s => {
    let ls = get(s, "links", default: (:))
    let langs = get(s, "languages", default: ())
    let links = nonempty((
      if get(s, "doi") != none { link("https://doi.org/" + s.doi)[CRAN] } else if get(ls, "cran") != none { link(ls.cran)[CRAN] },
      if get(ls, "pypi") != none { link(ls.pypi)[PyPI] },
      if get(ls, "github") != none { link(ls.github)[GitHub] },
      if get(ls, "website") != none { link(ls.website)[Website] },
    ))
    (
      start-date: str(get(s, "contribution_year", default: s.year)),
      name: s.name,
      kind: if s.kind == "package" and langs.len() > 0 { langs.join(" and ") + " package" } else { cap(s.kind) },
      description: nonempty((get(s, "description"), cap(s.roles.map(r => r.replace("-", " ")).join(", ")))).join(". "),
      links: if links.len() > 0 { links.join(h(0.8em)) },
    )
  })
  timeline(entries, ("name", "kind"), secondary: ("description",), tertiary: ("links",), settings)
}

#let venue-year(e) = { let y = year-of(e.date); if e.venue.contains(y) { e.venue } else { e.venue + " " + y } }
#let place(e) = {
  let inst = get(e, "institution")
  let city = get(e, "city")
  if inst != none and city != none and inst.contains(city) { city = none }
  nonempty((inst, if get(e, "online", default: false) { "online" } else { city })).join(", ")
}

#let talks-section(cfg, settings) = {
  section-title("Talks")
  let talks = visible(load("talks")).map(t => (..t, events: visible(t.events)))
  let flat = talks.map(t => t.events.map(e => (talk: t, ev: e))).flatten()

  let invited = flat.filter(x => x.ev.type in ("keynote", "invited", "colloquium")).sorted(key: x => str(x.ev.date)).rev()
  if invited.len() > 0 {
    subheading("Keynotes, invited talks, and colloquia")
    timeline(invited.map(x => {
      let e = x.ev
      let co = get(e, "coauthors", default: ())
      (
        start-date: year-of(e.date),
        title: get(e, "title", default: x.talk.title),
        where: nonempty((if e.type == "keynote" { "Keynote" }, e.venue, place(e))).join(", "),
        with: if co.len() > 0 { "With " + and-join(co.map(full-name)) },
      )
    }), ("title",), secondary: ("where",), tertiary: ("with",), settings)
  }

  let per-deck(types) = talks.map(t => {
    let evs = t.events.filter(e => e.type in types and ("speaker" in e.roles or "coauthor" in e.roles)).sorted(key: e => str(e.date)).rev()
    (talk: t, evs: evs)
  }).filter(d => d.evs.len() > 0).sorted(key: d => str(d.evs.first().date)).rev()
  for (title, types) in (("Conference presentations", ("symposium", "conference", "lightning")), ("Posters", ("poster",))) {
    let decks = per-deck(types)
    if decks.len() == 0 { continue }
    subheading(title)
    timeline(decks.map(d => (
      start-date: compress-years(d.evs.map(e => e.date)),
      title: d.talk.title,
      venues: d.evs.map(e => venue-year(e) + if get(e, "award") != none { " (" + e.award + ")" } else { "" }).join("; "),
      note: if d.evs.all(e => "speaker" not in e.roles) { "Co-author" },
    )), ("title",), secondary: ("venues",), tertiary: ("note",), settings)
  }

  let panels = flat.filter(x => x.ev.type == "panel" or ("speaker" not in x.ev.roles and "coauthor" not in x.ev.roles)).sorted(key: x => str(x.ev.date)).rev()
  if panels.len() > 0 {
    subheading("Panels and sessions")
    timeline(panels.map(x => (
      start-date: year-of(x.ev.date),
      title: get(x.ev, "title", default: x.talk.title),
      where: cap(x.ev.roles.join(" and ")) + ", " + venue-year(x.ev),
    )), ("title",), secondary: ("where",), settings)
  }
}

#let workshops-section(cfg, settings) = {
  section-title("Workshops")
  let ws = visible(load("workshops")).map(w => (..w, sessions: visible(w.sessions)))
  let entries = ws.sorted(key: w => w.sessions.map(s => str(s.date)).sorted().last()).rev().map(w => {
    let ss = w.sessions.sorted(key: s => str(s.date)).rev()
    let co = ss.map(s => get(s, "coinstructors", default: ())).flatten().dedup(key: p => p.family)
    let where(s) = nonempty((s.host, get(s, "institution"), if get(s, "online", default: false) { "online" })).join(", ")
    let hours(s) = { let h = get(s, "duration_hours"); if h != none { str(h) + "\u{a0}h" } else { "" } }
    let groups = ()
    for s in ss {
      let k = where(s) + "|" + hours(s)
      let i = groups.position(g => g.key == k)
      if i == none { groups.push((key: k, place: where(s), hours: hours(s), dates: (s.date,))) } else { groups.at(i).dates.push(s.date) }
    }
    let parts = groups.map(g => {
      let bits = nonempty((g.hours,) + (if groups.len() > 1 { (compress-years(g.dates),) } else { () }))
      g.place + if bits.len() > 0 { " (" + bits.join(", ") + ")" } else { "" }
    })
    (
      start-date: compress-years(ss.map(s => s.date)),
      title: w.title,
      where: parts.join("; "),
      with: if co.len() > 0 { "With " + and-join(co.map(full-name)) },
    )
  })
  timeline(entries, ("title",), secondary: ("where",), tertiary: ("with",), settings)
}

#let teaching-section(cfg, settings) = {
  section-title("Teaching")
  let levels = (bachelor: "bachelor’s level", master: "master’s level", doctoral: "doctoral level", mixed: "mixed levels")
  let entries = visible(load("teaching")).sorted(key: t => t.years.map(str).sorted().last()).rev().map(t => (
    start-date: compress-years(t.years),
    title: t.title,
    institution: t.institution,
    description: nonempty((get(t, "description"), if get(t, "level") != none { "(" + levels.at(t.level) + ")" })).join(" "),
  ))
  timeline(entries, ("title", "institution"), secondary: ("description",), settings)
}

#let supervision-section(cfg, settings) = {
  section-title("Supervision")
  let s = load("supervision")
  let c(role, level) = str(s.counts.filter(x => x.role == role and x.level == level).map(x => x.count).sum(default: 0))
  layout-prose(("First supervisor: " + c("first", "bachelor") + " bachelor’s and " + c("first", "master") + " master’s theses. Second supervisor: " + c("second", "bachelor") + " bachelor’s and " + c("second", "master") + " master’s theses.",))
}

#let awards-section(cfg, settings) = {
  section-title("Awards")
  timeline(visible(load("awards")).sorted(key: a => a.date).rev().map(a => (
    start-date: year-of(a.date), name: a.name, awarder: a.awarder, reason: if get(a, "for") != none { "For " + get(a, "for") },
  )), ("name", "awarder"), tertiary: ("reason",), settings)
}

#let span-dates(e) = if get(e, "years") != none { (start-date: compress-years(e.years)) } else {
  (start-date: period(e.start, e.end, year-of))
}
#let span-key(e) = if get(e, "years") != none { e.years.map(str).sorted().last() + e.years.map(str).sorted().first() } else { end-key(e) + str(e.start) }

#let service-section(cfg, settings) = {
  section-title("Service")
  let all = visible(load("service"))
  let fmt(s) = (..span-dates(s), role: s.role, organization: s.organization)
  let ed = all.filter(s => s.kind == "editorial")
  if ed.len() > 0 {
    subheading("Editorial")
    timeline(ed.sorted(key: span-key).rev().map(fmt), ("role", "organization"), settings)
    subheading("Academic service")
  }
  timeline(all.filter(s => s.kind != "editorial").sorted(key: span-key).rev().map(fmt), ("role", "organization"), settings)
}

#let memberships-section(cfg, settings) = {
  section-title("Memberships")
  timeline(visible(load("memberships")).sorted(key: m => m.start).rev().map(m => (
    start-date: period(m.start, m.end, year-of),
    organization: m.organization + if get(m, "abbreviation") != none { " (" + m.abbreviation + ")" } else { "" },
  )), ("organization",), settings)
}

#let reviewing-section(cfg, settings) = {
  section-title("Reviewing")
  let rs = visible(load("reviewing"))
  let journals = rs.filter(r => r.kind != "conference").map(r => "_" + esc(r.venue) + "_").sorted(key: lower)
  let confs = rs.filter(r => r.kind == "conference").map(r => esc(r.venue) + " (" + compress-years(get(r, "dates", default: ())) + ")")
  layout-prose(("Ad-hoc reviewer for " + journals.join(", ") + ".",) + if confs.len() > 0 { ("Conference reviewer for " + confs.join("; ") + ".",) } else { () })
}

#let community-section(cfg, settings) = {
  section-title("Community Service")
  let cs = visible(load("community")).filter(c => c.end == "present" or int(year-of(c.end)) >= cfg.community-from)
  timeline(cs.sorted(key: end-key).rev().map(c => (
    start-date: period(c.start, c.end, year-of),
    role: c.role,
    organization: c.organization + if get(c, "description") != none { " (" + c.description + ")" } else { "" },
  )), ("role", "organization"), settings)
}

#let media-section(cfg, settings) = {
  section-title("Media Coverage")
  timeline(visible(load("media")).map(m => (
    start-date: if get(m, "date") != none { year-of(m.date) },
    outlet: link(m.url, m.outlet),
    kind: cap(m.kind.replace("-", " ")),
  )), ("outlet", "kind"), settings)
}

#let training-section(cfg, settings) = {
  section-title("Training")
  timeline(visible(load("training")).sorted(key: t => t.date).rev().map(t => (
    start-date: year-of(t.date), title: t.title,
    provider: t.provider + if get(t, "platform") != none { " (" + t.platform + ")" } else { "" },
  )), ("title", "provider"), settings)
}

// ---------------------------------------------------------------- main

#let renderers = (
  profile: profile-section, positions: positions-section, research-stays: stays-section,
  grants: grants-section, education: education-section, publications: publications-section,
  software: software-section, talks: talks-section, workshops: workshops-section,
  teaching: teaching-section, supervision: supervision-section, awards: awards-section,
  service: service-section, memberships: memberships-section, reviewing: reviewing-section,
  community: community-section, media: media-section, training: training-section,
)

#let academic-sections = (
  "profile", "positions", "research-stays", "grants", "education", "publications",
  "software", "talks", "workshops", "teaching", "supervision", "awards", "service",
  "memberships", "reviewing", "community",
)

#let fonts = (libertinus: "Libertinus Serif", plex-serif: "IBM Plex Serif", plex-sans: "IBM Plex Sans")

#let cv(
  sections: academic-sections,
  title: "Curriculum Vitae",
  font: sys.inputs.at("font", default: "libertinus"),  // "libertinus", "plex-serif", or "plex-sans"
  selected-only: false,   // publications: only entries with selected: true
  contributions: false,   // publications: print the one-line contribution statement
  max-authors: 20,        // publications: truncate longer author lists (APA 7 style)
  school: false,          // education: include school
  community-from: 2019,   // community service: drop entries that ended before this year
  descriptions: true,     // positions: print descriptions
) = {
  let profile = load("profile")
  let cfg = (selected-only: selected-only, contributions: contributions, max-authors: max-authors,
    school: school, community-from: community-from, descriptions: descriptions)
  let settings = (
    font-heading: fonts.at(font), font-body: fonts.at(font),
    fontsize: 10pt, spacing-section: 10pt, spacing-entry: 0.6em, spacing-element: 3pt, spacing-line: 5pt,
    color-hyperlink: cobalt,
  )
  let me = (profile.name.given, get(profile.name, "middle"), profile.name.family).filter(x => x != none).join(" ")
  let built = sys.inputs.at("date", default: datetime.today().display())

  // academicv's header expects its own `personal` structure; map ours onto it.
  let email = profile.email.at(get(profile.email, "cv", default: "work"))
  let header-data = (
    personal: (
      name: me,
      titles: (profile.position,),
      location: (institution: profile.affiliation.institution, unit: get(profile.affiliation, "unit")),
      contact: (email: email, phone: get(profile, "phone"), website: profile.website),
      profiles: (
        (url: "https://orcid.org/" + profile.orcid),
        (url: "https://github.com/" + profile.github),
      ) + get(profile, "extra_links", default: ()).map(l => (url: l.url)),
    ),
    sections: ((key: "personal", layout: "header", "show": true, "include": ("titles", "location", "contact")),),
  )

  set document(title: title + ", " + me, author: me)
  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2cm, bottom: 2.2cm),
    footer: context align(center, text(size: 0.8em)[#counter(page).display() / #counter(page).final().first() #h(1.5em) Updated #built]),
  )
  show: doc => showrules(settings, setrules(settings, doc))
  // Ragged right: justified text without hyphenation leaves wide gaps.
  set par(justify: false)

  layout-header(header-data, settings)
  for s in sections {
    assert(s in renderers, message: "unknown CV section: " + s)
    renderers.at(s)(cfg, settings)
  }
}
