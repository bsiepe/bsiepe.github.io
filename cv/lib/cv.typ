// CV template. Reads data/*.yml directly; no other inputs.
// Variants in cv/variants/ call `cv(...)` and override only what differs.
//
// Build:   node scripts/build-cv.mjs
// Preview: typst watch --root . --font-path fonts --ignore-system-fonts cv/variants/academic.typ
// Font:    serif by default; `--input font=sans` switches to IBM Plex Sans.

#let cobalt = rgb("#0047AB")
#let muted = luma(95)
#let rule = luma(190)
#let date-w = 3.6cm

// The static Plex files register SemiBold as its own family, so `strong`
// is mapped to it explicitly in `cv()`.
#let families = (
  serif: (body: "IBM Plex Serif", strong: "IBM Plex Serif SmBld"),
  sans: (body: "IBM Plex Sans", strong: "IBM Plex Sans SmBld"),
)

#let load(name) = yaml("/data/" + name + ".yml")
#let get(d, key, default: none) = d.at(key, default: default)
#let visible(xs) = xs.filter(x => not get(x, "hidden", default: false))

// ---------------------------------------------------------------- dates

#let year-of(d) = str(d).slice(0, 4)
#let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
#let month-year(d) = {
  let s = str(d)
  if s.len() >= 7 { months.at(int(s.slice(5, 7)) - 1) + " " + s.slice(0, 4) } else { s.slice(0, 4) }
}
#let period-months(start, end) = {
  let a = month-year(start)
  let b = if end == "present" { "present" } else { month-year(end) }
  if a == b { a } else { a + " – " + b }
}
#let period-years(start, end) = {
  let a = year-of(start)
  let b = if end == "present" { "present" } else { year-of(end) }
  if a == b { a } else { a + "–" + b }
}
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
// Sort key that orders "present" after any date.
#let end-key(e) = { let v = get(e, "end", default: get(e, "start", default: "0000")); if v == "present" { "9999" } else { str(v) } }

// ---------------------------------------------------------------- text helpers

#let dash(s) = str(s).replace("-", "–")
#let sep = h(0.4em) + text(fill: muted, "·") + h(0.4em)
#let label-link(url, label) = box(link(url, text(size: 0.85em, label)))
#let url-of(v) = if type(v) == dictionary { v.url } else { v }
#let note-of(v) = if type(v) == dictionary { get(v, "note") } else { none }
#let end-punct(s) = if s.ends-with(".") or s.ends-with("?") or s.ends-with("!") { s } else { s + "." }
#let cap(s) = if s.len() == 0 { s } else { upper(s.first()) + s.slice(1) }
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
  let sym = (EUR: "€", USD: "$", GBP: "£").at(a.currency, default: a.currency + " ")
  sym + s
}

// ---------------------------------------------------------------- names

#let initials(given) = {
  if given == none { return "" }
  given.split(" ").filter(p => p != "").map(p => {
    if p.ends-with(".") and p.len() <= 4 { p } else {
      p.split("-").map(q => q.clusters().first() + ".").join("-")
    }
  }).join(" ")
}
#let short-name(p) = {
  let g = initials(get(p, "given"))
  if g == "" { p.family } else { p.family + ", " + g }
}
#let full-name(p) = { let g = get(p, "given"); if g == none { p.family } else { g + " " + p.family } }
#let editor-name(p) = { let g = initials(get(p, "given")); if g == "" { p.family } else { g + " " + p.family } }
#let and-join(xs) = if xs.len() <= 1 { xs.join() } else if xs.len() == 2 { xs.at(0) + " & " + xs.at(1) } else { xs.slice(0, -1).join(", ") + ", & " + xs.last() }

// ---------------------------------------------------------------- layout primitives

#let section(title) = block(above: 1.9em, below: 0.9em, sticky: true, {
  text(size: 12.5pt, fill: cobalt, strong(title))
  v(-0.55em)
  line(length: 100%, stroke: 0.4pt + rule)
})

#let subsection(title) = block(above: 1.3em, below: 0.7em, sticky: true,
  text(size: 0.8em, tracking: 0.08em, fill: muted, upper(title)))

// Every entry has the same shape:
//   title ....................................... date
//   sub (muted)
//   – detail
#let entry(title, date: none, sub: none, details: ()) = {
  let cells = (title, align(right, text(size: 0.9em, fill: muted, number-type: "lining", if date == none { [] } else { date })))
  // Only the first line carries a date, so the lines below use the full width.
  if sub != none { cells.push(grid.cell(colspan: 2, text(fill: muted, sub))) }
  for d in details { cells.push(grid.cell(colspan: 2, grid(columns: (0.9em, 1fr), text(fill: muted, "–"), d))) }
  block(above: 0.75em, below: 0.75em, breakable: false,
    grid(columns: (1fr, date-w), column-gutter: 1em, row-gutter: 0.35em, ..cells))
}

#let plain(body) = block(above: 0.8em, below: 0.8em, body)

// ---------------------------------------------------------------- header

#let header(profile) = {
  let n = profile.name
  let display = (n.given, get(n, "middle"), n.family).filter(x => x != none).join(" ")
  let email = profile.email.at(get(profile.email, "cv", default: "work"))
  let line1 = (
    link("mailto:" + email, email),
    get(profile, "phone"),
    link(profile.website, profile.website.replace("https://", "")),
  ).filter(x => x != none)
  let line2 = (
    link("https://orcid.org/" + profile.orcid, "ORCID " + profile.orcid),
    link("https://github.com/" + profile.github, "github.com/" + profile.github),
  ) + get(profile, "extra_links", default: ()).map(l => link(l.url, l.label))
  align(center, {
    block(below: 1.2em, text(size: 24pt, strong(display)))
    block(below: 0.35em, text(size: 1.1em, profile.position))
    block(below: 1em, text(fill: muted, [#profile.affiliation.institution#if get(profile.affiliation, "unit") != none [, #profile.affiliation.unit]]))
    block(below: 0.35em, text(size: 0.92em, line1.map(box).join(sep)))
    text(size: 0.92em, line2.map(box).join(sep))
  })
}

#let research-profile(profile) = {
  let p = get(profile, "research_profile")
  if p != none { block(above: 1.8em, p) }
}

// ---------------------------------------------------------------- sections

#let positions-section(cfg) = {
  section("Positions")
  let rank = (research: "3", consulting: "2", freelance: "2", student-assistant: "1")
  for p in visible(load("positions")).sorted(key: p => rank.at(p.kind) + end-key(p) + str(p.start)).rev() {
    let where = (p.institution, get(p, "unit")).filter(x => x != none).join(", ")
    let extra = (get(p, "project"), if get(p, "pi") != none { "PI: " + full-name(p.pi) }).filter(x => x != none)
    entry(strong(p.title), date: period-months(p.start, p.end),
      sub: ((where,) + extra).join(sep),
      details: if cfg.descriptions and get(p, "description") != none { (p.description,) } else { () })
  }
}

#let stays-section(cfg) = {
  section("Research stays")
  for s in visible(load("research_stays")).sorted(key: s => s.start).rev() {
    let where = (s.institution, get(s, "unit")).filter(x => x != none).join(", ")
    let extra = (get(s, "project"), if get(s, "host") != none { "Host: " + full-name(s.host) }).filter(x => x != none)
    entry(strong(s.role), date: period-months(s.start, s.end), sub: ((where,) + extra).join(sep))
  }
}

#let grants-section(cfg) = {
  section("Grants")
  let gs = visible(load("grants")).sorted(key: g => g.date).rev()
  let big = gs.filter(g => g.kind in ("research-grant", "internal-grant"))
  let small = gs.filter(g => g.kind not in ("research-grant", "internal-grant"))
  for g in big {
    let facts = (
      if get(g, "amount") != none { amount(g.amount) + if get(g, "amount_note") != none { " (" + g.amount_note + ")" } else { "" } },
      if get(g, "role") == "pi" { "Principal investigator" },
      get(g, "purpose"),
    ).filter(x => x != none)
    entry(strong(g.name), date: year-of(g.date), sub: facts.join(sep),
      details: if get(g, "project_title") != none { (emph(g.project_title),) } else { () })
  }
  if small.len() > 0 {
    subsection("Travel grants and scholarships")
    for g in small {
      let facts = (
        if get(g, "amount") != none { amount(g.amount) + if get(g, "amount_note") != none { " (" + g.amount_note + ")" } else { "" } },
        get(g, "purpose"),
      ).filter(x => x != none)
      entry([#g.name#if facts.len() > 0 { sep + text(fill: muted, facts.join(sep)) }], date: year-of(g.date))
    }
  }
}

#let education-section(cfg) = {
  section("Education")
  let levels = if cfg.school { ("doctorate", "master", "bachelor", "school") } else { ("doctorate", "master", "bachelor") }
  for e in visible(load("education")).filter(e => e.level in levels).sorted(key: e => e.start).rev() {
    let thesis = get(e, "thesis")
    let title = e.degree + if get(e, "field") != none { " in " + e.field } else { "" }
    entry(strong(title), date: period-years(e.start, e.end),
      sub: (e.institution, get(e, "distinction")).filter(x => x != none).join(sep),
      details: if thesis != none and not get(thesis, "hidden", default: false) { ([Thesis: #emph(thesis.title)],) } else { () })
  }
}

// --- publications

#let format-authors(p, max: 20) = {
  let n = p.authors.len()
  let sf = get(p, "shared_first", default: ())
  let ss = get(p, "shared_second", default: ())
  let one(a, i) = {
    let mark = if (i + 1) in sf { super("†") } else if (i + 1) in ss { super("‡") } else { [] }
    let name = short-name(a)
    if get(a, "me", default: false) { [#strong(name)#mark] } else { [#name#mark] }
  }
  let shown = range(n)
  if n > max {
    // APA 7: first 19, ellipsis, last. Keep my own entry if it falls in the gap.
    let me = p.authors.position(a => get(a, "me", default: false))
    shown = range(max - 1) + (if me != none and me >= max - 1 and me < n - 1 { (me,) } else { () }) + (n - 1,)
  }
  let out = []
  for (k, i) in shown.enumerate() {
    if k > 0 {
      let gap = i != shown.at(k - 1) + 1
      let last = k == shown.len() - 1
      out += if gap { [, … ] } else if last { [, & ] } else { [, ] }
    }
    out += one(p.authors.at(i), i)
  }
  out
}

#let venue-details(p) = {
  if p.type == "chapter" {
    let eds = get(p, "editors", default: ())
    let inner = ()
    if get(p, "series") != none { inner.push(p.series) }
    if get(p, "volume") != none { inner.push("Vol. " + p.volume) }
    if get(p, "pages") != none { inner.push("pp. " + dash(p.pages)) }
    [In #and-join(eds.map(editor-name)) (#if eds.len() == 1 [Ed.] else [Eds.]), #emph(p.book_title)#if inner.len() > 0 [ (#inner.join(", "))]. #p.publisher.]
  } else if p.type == "report" {
    [#emph(p.venue)#if get(p, "report_number") != none [ (No. #p.report_number)].]
  } else {
    let vol = get(p, "volume")
    let out = [#emph[#p.venue#if vol != none [, #vol]]]
    if get(p, "issue") != none { out += [(#p.issue)] }
    if get(p, "pages") != none { out += [, #dash(p.pages)] }
    if get(p, "article_number") != none and get(p, "pages") == none { out += [, Article #p.article_number] }
    out += [.]
    if p.status == "advance-online" { out += [ Advance online publication.] }
    if p.status == "in-press" { out += [ In press.] }
    out
  }
}

#let pub-links(p) = {
  let ls = get(p, "links", default: (:))
  let items = ()
  if get(p, "doi") != none { items.push(label-link("https://doi.org/" + p.doi, "Paper")) }
  else if get(p, "url") != none { items.push(label-link(p.url, "Full text")) }
  if get(p, "preprint_doi") != none { items.push(label-link("https://doi.org/" + p.preprint_doi, "Preprint")) }
  else if get(ls, "preprint") != none { items.push(label-link(url-of(ls.preprint), "Preprint")) }
  let code = get(ls, "code")
  let data = get(ls, "data")
  let synthetic = note-of(data) == "synthetic data"
  if code != none and data != none and url-of(code) == url-of(data) {
    items.push(label-link(url-of(code), if synthetic { "Code & Synthetic Data" } else { "Code & Data" }))
  } else {
    if code != none { items.push(label-link(url-of(code), "Code")) }
    if data != none { items.push(label-link(url-of(data), if synthetic { "Synthetic Data" } else { "Data" })) }
  }
  for (key, lab) in (("materials", "Materials"), ("prereg", "Preregistration"), ("supplement", "Supplement"), ("app", "App"), ("website", "Website")) {
    if get(ls, key) != none { items.push(label-link(url-of(ls.at(key)), lab)) }
  }
  items
}

// The last author's initials already end in a period, unless the name has no
// initials or carries a shared-authorship marker.
#let authors-end(p) = {
  let n = p.authors.len()
  let marked = n in get(p, "shared_first", default: ()) or n in get(p, "shared_second", default: ())
  if initials(get(p.authors.last(), "given")) == "" or marked { "." } else { "" }
}

#let hang = 1.4em
#let pub-entry(p, cfg) = block(above: 0.75em, below: 0.75em, breakable: false, {
  par(hanging-indent: hang)[#format-authors(p, max: cfg.max-authors)#if cfg.year-in-text [ (#p.year).] else [#authors-end(p)] #end-punct(p.title) #venue-details(p)]
  if cfg.contributions and get(p, "contribution") != none {
    block(above: 0.4em, pad(left: hang, text(fill: muted)[Contribution: #p.contribution]))
  }
  let links = pub-links(p)
  if links.len() > 0 { block(above: 0.4em, pad(left: hang, links.join(h(0.9em)))) }
})

#let publications-section(cfg) = {
  section(if cfg.selected-only { "Selected publications" } else { "Publications" })
  let ps = visible(load("publications"))
  if cfg.selected-only { ps = ps.filter(p => get(p, "selected", default: false)) }
  if ps.len() == 0 {
    text(fill: red)[No publications are marked `selected: true` in data/publications.yml.]
    return
  }
  let groups = (
    ("Peer-reviewed articles", ps.filter(p => p.type == "article")),
    ("Book chapters", ps.filter(p => p.type == "chapter")),
    ("Reports", ps.filter(p => p.type == "report")),
    ("Preprints", ps.filter(p => p.type == "preprint")),
  )
  for (title, items) in groups {
    if items.len() == 0 { continue }
    subsection(title)
    for p in items.sorted(key: p => p.year).rev() { pub-entry(p, cfg) }
  }
  if ps.any(p => get(p, "shared_first") != none or get(p, "shared_second") != none) {
    block(above: 1em, text(size: 0.85em, fill: muted)[#super("†") Shared first authorship. #h(0.8em) #super("‡") Shared second authorship.])
  }
}

// --- software

#let software-section(cfg) = {
  section("Software and research infrastructure")
  for s in visible(load("software")).sorted(key: s => get(s, "contribution_year", default: s.year)).rev() {
    let ls = get(s, "links", default: (:))
    let langs = get(s, "languages", default: ())
    let what = if s.kind == "package" and langs.len() > 0 { langs.join(" and ") + " package" } else { cap(s.kind) }
    let items = ()
    if get(s, "doi") != none { items.push(label-link("https://doi.org/" + s.doi, "CRAN")) }
    else if get(ls, "cran") != none { items.push(label-link(ls.cran, "CRAN")) }
    if get(ls, "pypi") != none { items.push(label-link(ls.pypi, "PyPI")) }
    if get(ls, "github") != none { items.push(label-link(ls.github, "GitHub")) }
    if get(ls, "website") != none { items.push(label-link(ls.website, "Website")) }
    if get(ls, "docs") != none { items.push(label-link(ls.docs, "Docs")) }
    let roles = cap(s.roles.map(r => r.replace("-", " ")).join(", "))
    entry([#strong(s.name)#sep#text(fill: muted, what)], date: str(get(s, "contribution_year", default: s.year)),
      sub: (get(s, "description"), roles).filter(x => x != none).join(sep),
      details: if items.len() > 0 { (items.join(h(0.9em)),) } else { () })
  }
}

// --- talks

#let venue-year(e) = { let y = year-of(e.date); if e.venue.contains(y) { e.venue } else { e.venue + " " + y } }
#let place(e) = {
  let inst = get(e, "institution")
  let city = get(e, "city")
  if inst != none and city != none and inst.contains(city) { city = none }
  (inst, if get(e, "online", default: false) { "online" } else { city }).filter(p => p != none).join(", ")
}

#let talks-section(cfg) = {
  section("Talks")
  let talks = visible(load("talks")).map(t => (..t, events: visible(t.events)))
  let flat = talks.map(t => t.events.map(e => (talk: t, ev: e))).flatten()

  // Keynotes, invited talks, colloquia: one entry per event.
  let invited = flat.filter(x => x.ev.type in ("keynote", "invited", "colloquium")).sorted(key: x => str(x.ev.date)).rev()
  if invited.len() > 0 {
    subsection("Keynotes, invited talks, and colloquia")
    for x in invited {
      let e = x.ev
      let co = get(e, "coauthors", default: ())
      let where = (e.venue, place(e)).filter(p => p != "").join(", ")
      let sub = (if e.type == "keynote" { "Keynote" }, where, if co.len() > 0 { "with " + and-join(co.map(full-name)) }).filter(p => p != none)
      entry(get(e, "title", default: x.talk.title), date: year-of(e.date), sub: sub.join(sep))
    }
  }

  // Conference presentations and posters: one entry per deck, venues combined.
  let per-deck(types) = talks.map(t => {
    let evs = t.events.filter(e => e.type in types and ("speaker" in e.roles or "coauthor" in e.roles)).sorted(key: e => str(e.date)).rev()
    (talk: t, evs: evs)
  }).filter(d => d.evs.len() > 0).sorted(key: d => str(d.evs.first().date)).rev()
  for (title, types) in (("Conference presentations", ("symposium", "conference", "lightning")), ("Posters", ("poster",))) {
    let decks = per-deck(types)
    if decks.len() == 0 { continue }
    subsection(title)
    for d in decks {
      let co-only = d.evs.all(e => "speaker" not in e.roles)
      let venues = d.evs.map(e => venue-year(e) + if get(e, "award") != none { " (" + e.award + ")" } else { "" })
      entry(d.talk.title, date: compress-years(d.evs.map(e => e.date)),
        sub: ((if co-only { ("Co-author",) } else { () }) + (venues.join("; "),)).join(sep))
    }
  }

  // Panels and sessions organized or chaired, without a talk of my own.
  let panels = flat.filter(x => x.ev.type == "panel" or ("speaker" not in x.ev.roles and "coauthor" not in x.ev.roles)).sorted(key: x => str(x.ev.date)).rev()
  if panels.len() > 0 {
    subsection("Panels and sessions")
    for x in panels {
      let e = x.ev
      entry(get(e, "title", default: x.talk.title), date: year-of(e.date),
        sub: cap(e.roles.join(" and ")) + sep + venue-year(e))
    }
  }
}

// --- workshops

#let workshops-section(cfg) = {
  section("Workshops")
  let ws = visible(load("workshops")).map(w => (..w, sessions: visible(w.sessions)))
  for w in ws.sorted(key: w => w.sessions.map(s => str(s.date)).sorted().last()).rev() {
    let ss = w.sessions.sorted(key: s => str(s.date)).rev()
    let co = ss.map(s => get(s, "coinstructors", default: ())).flatten().dedup(key: p => p.family)
    let where(s) = (s.host, get(s, "institution"), if get(s, "online", default: false) { "online" } else { none }).filter(b => b != none).join(", ")
    let hours(s) = { let h = get(s, "duration_hours"); if h != none { str(h) + "\u{a0}h" } else { "" } }
    let groups = ()
    for s in ss {
      let k = where(s) + "|" + hours(s)
      let i = groups.position(g => g.key == k)
      if i == none { groups.push((key: k, place: where(s), hours: hours(s), dates: (s.date,))) }
      else { groups.at(i).dates.push(s.date) }
    }
    // Years go in parentheses only when the workshop was held at several places.
    let parts = groups.map(g => {
      let bits = ((g.hours,) + (if groups.len() > 1 { (compress-years(g.dates),) } else { () })).filter(x => x != "")
      g.place + if bits.len() > 0 { " (" + bits.join(", ") + ")" } else { "" }
    })
    let sub = (parts.join("; "), if co.len() > 0 { "with " + and-join(co.map(full-name)) }).filter(x => x != none)
    entry(w.title, date: compress-years(ss.map(s => s.date)), sub: sub.join(sep))
  }
}

// --- teaching, supervision, awards, service, memberships, reviewing, community, media, training

#let teaching-section(cfg) = {
  section("Teaching")
  let levels = (bachelor: "Bachelor’s level", master: "Master’s level", doctoral: "Doctoral level", mixed: "Mixed levels")
  for t in visible(load("teaching")).sorted(key: t => t.years.map(str).sorted().last()).rev() {
    let lv = get(t, "level")
    let sub = (t.institution, get(t, "description"), if lv != none { levels.at(lv) }).filter(x => x != none)
    entry(t.title, date: compress-years(t.years), sub: sub.join(sep))
  }
}

#let supervision-section(cfg) = {
  section("Supervision")
  let s = load("supervision")
  let c(role, level) = s.counts.filter(x => x.role == role and x.level == level).map(x => x.count).sum(default: 0)
  entry([First supervisor#sep#text(fill: muted)[#c("first", "bachelor") bachelor’s and #c("first", "master") master’s theses]])
  entry([Second supervisor#sep#text(fill: muted)[#c("second", "bachelor") bachelor’s and #c("second", "master") master’s theses]])
}

#let awards-section(cfg) = {
  section("Awards")
  for a in visible(load("awards")).sorted(key: a => a.date).rev() {
    entry(strong(a.name), date: year-of(a.date),
      sub: (a.awarder, if get(a, "for") != none { "for " + a.for }).filter(x => x != none).join(sep))
  }
}

#let span(e) = if get(e, "years") != none { compress-years(e.years) } else { period-years(e.start, e.end) }
#let span-key(e) = if get(e, "years") != none { e.years.map(str).sorted().last() + e.years.map(str).sorted().first() } else { end-key(e) + str(e.start) }

#let service-section(cfg) = {
  section("Service")
  let all = visible(load("service"))
  let ed = all.filter(s => s.kind == "editorial")
  let rest = all.filter(s => s.kind != "editorial")
  if ed.len() > 0 {
    subsection("Editorial")
    for s in ed.sorted(key: span-key).rev() { entry([#s.role#sep#text(fill: muted, s.organization)], date: span(s)) }
  }
  subsection("Academic service")
  for s in rest.sorted(key: span-key).rev() { entry([#s.role#sep#text(fill: muted, s.organization)], date: span(s)) }
}

#let memberships-section(cfg) = {
  section("Memberships")
  for m in visible(load("memberships")).sorted(key: m => m.start).rev() {
    entry([#m.organization#if get(m, "abbreviation") != none [ (#m.abbreviation)]], date: period-years(m.start, m.end))
  }
}

#let reviewing-section(cfg) = {
  section("Reviewing")
  let rs = visible(load("reviewing"))
  let journals = rs.filter(r => r.kind != "conference").map(r => r.venue).sorted(key: lower)
  let confs = rs.filter(r => r.kind == "conference")
  plain[Ad-hoc reviewer for #journals.map(emph).join(", ").]
  if confs.len() > 0 {
    plain[Conference reviewer for #confs.map(r => [#r.venue (#compress-years(get(r, "dates", default: ())))]).join("; ").]
  }
}

#let community-section(cfg) = {
  section("Community service")
  let cs = visible(load("community")).filter(c => c.end == "present" or int(year-of(c.end)) >= cfg.community-from)
  for c in cs.sorted(key: end-key).rev() {
    entry([#c.role#sep#text(fill: muted)[#c.organization#if get(c, "description") != none [ (#c.description)]]], date: period-years(c.start, c.end))
  }
}

#let media-section(cfg) = {
  section("Media coverage")
  for m in visible(load("media")) {
    entry([#link(m.url, m.outlet)#sep#text(fill: muted, cap(m.kind.replace("-", " ")))],
      date: if get(m, "date") != none { year-of(m.date) })
  }
}

#let training-section(cfg) = {
  section("Training")
  for t in visible(load("training")).sorted(key: t => t.date).rev() {
    entry([#t.title#sep#text(fill: muted)[#t.provider#if get(t, "platform") != none [, #t.platform]]], date: year-of(t.date))
  }
}

// ---------------------------------------------------------------- main

#let renderers = (
  profile: (cfg, profile) => research-profile(profile),
  positions: (cfg, profile) => positions-section(cfg),
  research-stays: (cfg, profile) => stays-section(cfg),
  grants: (cfg, profile) => grants-section(cfg),
  education: (cfg, profile) => education-section(cfg),
  publications: (cfg, profile) => publications-section(cfg),
  software: (cfg, profile) => software-section(cfg),
  talks: (cfg, profile) => talks-section(cfg),
  workshops: (cfg, profile) => workshops-section(cfg),
  teaching: (cfg, profile) => teaching-section(cfg),
  supervision: (cfg, profile) => supervision-section(cfg),
  awards: (cfg, profile) => awards-section(cfg),
  service: (cfg, profile) => service-section(cfg),
  memberships: (cfg, profile) => memberships-section(cfg),
  reviewing: (cfg, profile) => reviewing-section(cfg),
  community: (cfg, profile) => community-section(cfg),
  media: (cfg, profile) => media-section(cfg),
  training: (cfg, profile) => training-section(cfg),
)

#let academic-sections = (
  "profile", "positions", "research-stays", "grants", "education", "publications",
  "software", "talks", "workshops", "teaching", "supervision", "awards", "service",
  "memberships", "reviewing", "community",
)

#let cv(
  sections: academic-sections,
  title: "Curriculum Vitae",
  font: sys.inputs.at("font", default: "serif"),  // "serif" or "sans"
  selected-only: false,   // publications: only entries with selected: true
  contributions: false,   // publications: print the one-line contribution statement
  max-authors: 20,        // publications: truncate longer author lists (APA 7 style)
  year-in-text: true,     // publications: year after the authors (APA)
  school: false,          // education: include school
  community-from: 2019,   // community service: drop entries that ended before this year
  descriptions: true,     // positions: print descriptions
) = {
  let profile = load("profile")
  let fam = families.at(font)
  let cfg = (selected-only: selected-only, contributions: contributions, max-authors: max-authors,
    year-in-text: year-in-text, school: school, community-from: community-from, descriptions: descriptions)
  let built = sys.inputs.at("date", default: datetime.today().display())
  let me = (profile.name.given, get(profile.name, "middle"), profile.name.family).filter(x => x != none).join(" ")

  set document(title: title + ", " + me, author: me)
  set text(font: fam.body, size: if font == "serif" { 9.75pt } else { 9.5pt }, lang: "en", number-type: "lining", hyphenate: false)
  set par(leading: 0.62em, spacing: 0.8em, justify: false)
  set page(
    paper: "a4",
    margin: (x: 2.3cm, top: 2.2cm, bottom: 2.2cm),
    footer: context text(size: 0.8em, fill: muted)[
      #me #h(1fr) Updated #built #h(1fr) #counter(page).display() / #counter(page).final().first()
    ],
  )
  show strong: it => text(font: fam.strong, weight: 600, it.body)
  show link: set text(fill: cobalt)

  header(profile)
  for s in sections {
    assert(s in renderers, message: "unknown CV section: " + s)
    renderers.at(s)(cfg, profile)
  }
}
