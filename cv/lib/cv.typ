// CV template. Reads data/*.yml directly; no other inputs.
// Variants in cv/variants/ call `cv(...)` and override only what differs.
//
// Build:   node scripts/build-cv.mjs
// Preview: typst watch --root . --font-path fonts --ignore-system-fonts cv/variants/academic.typ

#let cobalt = rgb("#0047AB")
#let font = "IBM Plex Sans"
// The static Plex files register SemiBold as its own family.
#let font-semibold = "IBM Plex Sans SmBld"
#let semibold(body) = text(font: font-semibold, weight: 600, body)
#let date-col = 2.9cm

#let load(name) = yaml("/data/" + name + ".yml")
#let get(d, key, default: none) = d.at(key, default: default)
#let visible(xs) = xs.filter(x => not get(x, "hidden", default: false))

// ---------------------------------------------------------------- dates

#let year-of(d) = str(d).slice(0, 4)
#let month-year(d) = {
  let s = str(d)
  if s.len() >= 7 { s.slice(5, 7) + "/" + s.slice(0, 4) } else { s.slice(0, 4) }
}
#let period-months(start, end) = {
  let a = month-year(start)
  let b = if end == "present" { "present" } else { month-year(end) }
  if a == b { a } else { a + "–" + b }
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
#let label-link(url, label) = link(url, text(size: 0.82em, fill: cobalt, label))
#let url-of(v) = if type(v) == dictionary { v.url } else { v }
#let note-of(v) = if type(v) == dictionary { get(v, "note") } else { none }
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

// ---------------------------------------------------------------- layout

#let section(title) = block(above: 1.5em, below: 0.75em, sticky: true,
  text(fill: cobalt, size: 11pt, semibold(title)))
#let subsection(title) = block(above: 1.1em, below: 0.55em, sticky: true,
  semibold(title))
#let entry(when, body) = block(above: 0.55em, below: 0.55em, breakable: false,
  grid(columns: (date-col, 1fr), column-gutter: 0.6em,
    text(number-type: "lining", number-width: "tabular", when), body))
#let detail(body) = block(above: 0.25em, text(size: 0.92em, body))

// ---------------------------------------------------------------- sections

#let header(profile) = {
  let n = profile.name
  let display = n.given + " " + get(n, "middle", default: "") + " " + n.family
  block(below: 0.7em, text(size: 20pt, semibold(display.replace("  ", " "))))
  block(below: 0.6em, text(size: 1.05em)[#profile.position, #profile.affiliation.institution])
  let email = profile.email.at(get(profile.email, "cv", default: "work"))
  let parts = (
    link("mailto:" + email, email),
    if get(profile, "phone") != none { profile.phone },
    link(profile.website, profile.website.replace("https://", "")),
    link("https://orcid.org/" + profile.orcid, "ORCID " + profile.orcid),
    link("https://github.com/" + profile.github, "github.com/" + profile.github),
  ) + get(profile, "extra_links", default: ()).map(l => link(l.url, l.label))
  text(size: 0.92em, parts.filter(p => p != none).map(p => box(p)).join(h(0.5em) + "·" + h(0.5em)))
}

#let research-profile(profile) = {
  let p = get(profile, "research_profile")
  if p != none { block(above: 1.2em, par(justify: false, p)) }
}

#let positions-section(cfg) = {
  section("Positions")
  let rank = (research: "3", consulting: "2", freelance: "2", student-assistant: "1")
  for p in visible(load("positions")).sorted(key: p => rank.at(p.kind) + end-key(p) + str(p.start)).rev() {
    let pi = get(p, "pi")
    entry(period-months(p.start, p.end))[
      *#p.title*, #p.institution#if get(p, "unit") != none [, #p.unit]#if get(p, "project") != none [, #p.project]#if pi != none [ (PI: #full-name(pi))]
      #if cfg.descriptions and get(p, "description") != none { detail(p.description) }
    ]
  }
}

#let stays-section(cfg) = {
  section("Research stays")
  for s in visible(load("research_stays")).sorted(key: s => s.start).rev() {
    let host = get(s, "host")
    entry(period-months(s.start, s.end))[
      *#s.role*, #s.institution#if get(s, "unit") != none [, #s.unit]#if get(s, "project") != none [, #s.project]#if host != none [ (Host: #full-name(host))]
    ]
  }
}

#let grants-section(cfg) = {
  section("Grants")
  let gs = visible(load("grants")).sorted(key: g => g.date).rev()
  let big = gs.filter(g => g.kind in ("research-grant", "internal-grant"))
  let small = gs.filter(g => g.kind not in ("research-grant", "internal-grant"))
  for g in big {
    let lead = g.kind == "research-grant"
    entry(year-of(g.date))[
      #if lead [*#g.name*] else [#g.name]#if get(g, "amount") != none [, #amount(g.amount)]#if get(g, "amount_note") != none [ (#g.amount_note)]#if get(g, "role") == "pi" [, principal investigator]
      #if get(g, "project_title") != none { detail["#g.project_title"] }
      #if get(g, "purpose") != none { detail(g.purpose) }
    ]
  }
  if small.len() > 0 {
    subsection("Travel grants and scholarships")
    for g in small {
      entry(year-of(g.date))[
        #g.name#if get(g, "amount") != none [, #amount(g.amount)]#if get(g, "amount_note") != none [ (#g.amount_note)]#if get(g, "purpose") != none [. #g.purpose]
      ]
    }
  }
}

#let education-section(cfg) = {
  section("Education")
  let levels = if cfg.school { ("doctorate", "master", "bachelor", "school") } else { ("doctorate", "master", "bachelor") }
  for e in visible(load("education")).filter(e => e.level in levels).sorted(key: e => e.start).rev() {
    let thesis = get(e, "thesis")
    entry(period-years(e.start, e.end))[
      *#e.degree#if get(e, "field") != none [ in #e.field]*, #e.institution#if get(e, "distinction") != none [, #e.distinction]
      #if thesis != none and not get(thesis, "hidden", default: false) { detail[Thesis: #thesis.title] }
    ]
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
    if get(a, "me", default: false) { [*#name*#mark] } else { [#name#mark] }
  }
  let shown = range(n)
  let gap = false
  if n > max {
    // APA 7: first 19, ellipsis, last. Keep my own entry if it falls in the gap.
    let me = p.authors.position(a => get(a, "me", default: false))
    shown = range(max - 1) + (if me != none and me >= max - 1 and me < n - 1 { (me,) } else { () }) + (n - 1,)
    gap = true
  }
  let parts = shown.map(i => one(p.authors.at(i), i))
  if gap {
    // join with ellipsis before the last shown item(s) that follow a gap
    let out = []
    for (k, i) in shown.enumerate() {
      if k > 0 {
        let prev = shown.at(k - 1)
        out += if i != prev + 1 { [, … ] } else { [, ] }
      }
      out += parts.at(k)
    }
    out
  } else if parts.len() == 1 { parts.first() }
  else if parts.len() == 2 { [#parts.at(0), & #parts.at(1)] }
  else { parts.slice(0, -1).join([, ]) + [, & ] + parts.last() }
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
  if get(p, "preprint_doi") != none and p.type != "preprint" { items.push(label-link("https://doi.org/" + p.preprint_doi, "Preprint")) }
  else if get(p, "preprint_doi") != none { items.push(label-link("https://doi.org/" + p.preprint_doi, "Preprint")) }
  else if get(ls, "preprint") != none { items.push(label-link(url-of(ls.preprint), "Preprint")) }
  let code = get(ls, "code")
  let data = get(ls, "data")
  if code != none and data != none and url-of(code) == url-of(data) {
    items.push(label-link(url-of(code), if note-of(data) == "synthetic data" { "Code & Synthetic Data" } else { "Code & Data" }))
  } else {
    if code != none { items.push(label-link(url-of(code), "Code")) }
    if data != none { items.push(label-link(url-of(data), if note-of(data) == "synthetic data" { "Synthetic Data" } else { "Data" })) }
  }
  for (key, lab) in (("materials", "Materials"), ("prereg", "Preregistration"), ("supplement", "Supplement"), ("app", "App"), ("website", "Website")) {
    if get(ls, key) != none { items.push(label-link(url-of(ls.at(key)), lab)) }
  }
  if items.len() > 0 { block(above: 0.3em, items.join(h(0.9em))) }
}

// The last author's initials already end in a period, unless the name has no
// initials or carries a shared-authorship marker.
#let authors-end(p) = {
  let n = p.authors.len()
  let marked = n in get(p, "shared_first", default: ()) or n in get(p, "shared_second", default: ())
  if initials(get(p.authors.last(), "given")) == "" or marked { "." } else { "" }
}

#let pub-entry(p, cfg) = entry(str(p.year))[
  #format-authors(p, max: cfg.max-authors)#if cfg.year-in-text [ (#p.year).] else [#authors-end(p)] #end-punct(p.title) #venue-details(p)
  #if cfg.contributions and get(p, "contribution") != none { detail[_Contribution:_ #p.contribution] }
  #pub-links(p)
]

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
  let any-shared = ps.any(p => get(p, "shared_first") != none or get(p, "shared_second") != none)
  if any-shared {
    block(above: 0.9em, text(size: 0.85em)[#super("†") Shared first authorship. #h(0.6em) #super("‡") Shared second authorship.])
  }
}

// --- software

#let software-section(cfg) = {
  section("Software and research infrastructure")
  let kinds = (package: "package", database: "database", website: "website", app: "app")
  for s in visible(load("software")).sorted(key: s => get(s, "contribution_year", default: s.year)).rev() {
    let ls = get(s, "links", default: (:))
    let langs = get(s, "languages", default: ())
    let what = if s.kind == "package" and langs.len() > 0 { langs.join(" and ") + " package" } else { kinds.at(s.kind) }
    let items = ()
    if get(s, "doi") != none { items.push(label-link("https://doi.org/" + s.doi, "CRAN")) }
    else if get(ls, "cran") != none { items.push(label-link(ls.cran, "CRAN")) }
    if get(ls, "pypi") != none { items.push(label-link(ls.pypi, "PyPI")) }
    if get(ls, "github") != none { items.push(label-link(ls.github, "GitHub")) }
    if get(ls, "website") != none { items.push(label-link(ls.website, "Website")) }
    if get(ls, "docs") != none { items.push(label-link(ls.docs, "Docs")) }
    let roles = s.roles.map(r => r.replace("-", " ")).join(", ")
    entry(str(get(s, "contribution_year", default: s.year)))[
      *#s.name* (#what)#if get(s, "description") != none [: #s.description]. #upper(roles.first())#roles.slice(1).
      #if items.len() > 0 { block(above: 0.3em, items.join(h(0.9em))) }
    ]
  }
}

// --- talks

#let venue-year(e) = { let y = year-of(e.date); if e.venue.contains(y) { e.venue } else { e.venue + " " + y } }
#let where(e) = {
  let inst = get(e, "institution")
  let city = get(e, "city")
  if inst != none and city != none and inst.contains(city) { city = none }
  let parts = (inst, if get(e, "online", default: false) { "online" } else { city })
  parts.filter(p => p != none).join(", ")
}

#let talks-section(cfg) = {
  section("Talks")
  let talks = visible(load("talks")).map(t => (..t, events: visible(t.events)))
  let flat = talks.map(t => t.events.map(e => (talk: t, ev: e))).flatten()

  // 1. Keynotes, invited talks, colloquia: one line per event.
  let invited = flat.filter(x => x.ev.type in ("keynote", "invited", "colloquium")).sorted(key: x => str(x.ev.date)).rev()
  if invited.len() > 0 {
    subsection("Keynotes, invited talks, and colloquia")
    for x in invited {
      let e = x.ev
      let co = get(e, "coauthors", default: ())
      let w = where(e)
      entry(year-of(e.date))[
        #if e.type == "keynote" [*Keynote.* ]#emph(end-punct(get(e, "title", default: x.talk.title))) #e.venue#if w != "" [, #w].#if co.len() > 0 [ With #and-join(co.map(full-name)).]
      ]
    }
  }

  // 2. Conference presentations and 3. posters: one line per deck, venues combined.
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
      entry(compress-years(d.evs.map(e => e.date)))[
        #emph(end-punct(d.talk.title))#if co-only [ (Co-author.)] #venues.join("; ").
      ]
    }
  }

  // 4. Panels and sessions organized or chaired (without a talk of my own).
  let panels = flat.filter(x => x.ev.type == "panel" or ("speaker" not in x.ev.roles and "coauthor" not in x.ev.roles)).sorted(key: x => str(x.ev.date)).rev()
  if panels.len() > 0 {
    subsection("Panels and sessions")
    for x in panels {
      let e = x.ev
      let roles = e.roles.join(" and ")
      entry(year-of(e.date))[
        #emph(end-punct(get(e, "title", default: x.talk.title))) #upper(roles.first())#roles.slice(1), #venue-year(e).
      ]
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
    let place(s) = (s.host, get(s, "institution"), if get(s, "online", default: false) { "online" } else { none }).filter(b => b != none).join(", ")
    let hours(s) = { let h = get(s, "duration_hours"); if h != none { str(h) + " h" } else { "" } }
    let groups = ()
    for s in ss {
      let k = place(s) + "|" + hours(s)
      let i = groups.position(g => g.key == k)
      if i == none { groups.push((key: k, place: place(s), hours: hours(s), dates: (s.date,))) }
      else { groups.at(i).dates.push(s.date) }
    }
    // Years go in parentheses only when the workshop was held at several places.
    let parts = groups.map(g => {
      let bits = (g.hours,) + (if groups.len() > 1 { (compress-years(g.dates),) } else { () })
      let bits = bits.filter(x => x != "")
      g.place + if bits.len() > 0 { " (" + bits.join("; ") + ")" } else { "" }
    })
    entry(compress-years(ss.map(s => s.date)))[
      #emph(end-punct(w.title)) #parts.join("; ").#if co.len() > 0 [ With #and-join(co.map(full-name)).]
    ]
  }
}

// --- teaching, supervision, awards, service, memberships, reviewing, community, media, training

#let teaching-section(cfg) = {
  section("Teaching")
  let levels = (bachelor: "bachelor’s level", master: "master’s level", doctoral: "doctoral level", mixed: "mixed levels")
  for t in visible(load("teaching")).sorted(key: t => t.years.map(str).sorted().last()).rev() {
    let lv = get(t, "level")
    entry(compress-years(t.years))[
      #emph(t.title), #t.institution#if get(t, "description") != none [. #t.description]#if lv != none [ (#levels.at(lv))].
    ]
  }
}

#let supervision-section(cfg) = {
  section("Supervision")
  let s = load("supervision")
  let c(role, level) = s.counts.filter(x => x.role == role and x.level == level).map(x => x.count).sum(default: 0)
  [First supervisor: #c("first", "bachelor") bachelor's and #c("first", "master") master's theses. Second supervisor: #c("second", "bachelor") bachelor's and #c("second", "master") master's theses.]
}

#let awards-section(cfg) = {
  section("Awards")
  for a in visible(load("awards")).sorted(key: a => a.date).rev() {
    entry(year-of(a.date))[*#a.name*, #a.awarder#if get(a, "for") != none [, for #emph(a.for)].]
  }
}

#let span(e) = if get(e, "years") != none { compress-years(e.years) } else { period-years(e.start, e.end) }
#let span-key(e) = if get(e, "years") != none { e.years.map(str).sorted().last() + e.years.map(str).sorted().first() } else { end-key(e) + str(e.start) }

#let service-section(cfg) = {
  section("Service")
  let all = visible(load("service"))
  let ed = all.filter(s => s.kind == "editorial")
  let rest = all.filter(s => s.kind != "editorial")
  for s in ed.sorted(key: span-key).rev() + rest.sorted(key: span-key).rev() {
    entry(span(s))[#s.role, #s.organization]
  }
}

#let memberships-section(cfg) = {
  section("Memberships")
  for m in visible(load("memberships")).sorted(key: m => m.start).rev() {
    entry(period-years(m.start, m.end))[#m.organization#if get(m, "abbreviation") != none [ (#m.abbreviation)]]
  }
}

#let reviewing-section(cfg) = {
  section("Reviewing")
  let rs = visible(load("reviewing"))
  let journals = rs.filter(r => r.kind != "conference").map(r => r.venue).sorted(key: lower)
  let confs = rs.filter(r => r.kind == "conference")
  [Ad-hoc reviewer for #journals.map(emph).join("; ").]
  if confs.len() > 0 {
    parbreak()
    [Conference reviewer for #confs.map(r => [#r.venue (#compress-years(get(r, "dates", default: ())))]).join("; ").]
  }
}

#let community-section(cfg) = {
  section("Community service")
  let cs = visible(load("community")).filter(c => c.end == "present" or int(year-of(c.end)) >= cfg.community-from)
  for c in cs.sorted(key: end-key).rev() {
    entry(period-years(c.start, c.end))[#c.role, #c.organization#if get(c, "description") != none [ (#c.description)]]
  }
}

#let media-section(cfg) = {
  section("Media coverage")
  for m in visible(load("media")) {
    entry(if get(m, "date") != none { year-of(m.date) } else { "" })[
      #link(m.url, m.outlet)#if get(m, "title") != none [: #m.title] (#m.kind.replace("-", " "))
    ]
  }
}

#let training-section(cfg) = {
  section("Training")
  for t in visible(load("training")).sorted(key: t => t.date).rev() {
    entry(year-of(t.date))[#emph(t.title), #t.provider#if get(t, "platform") != none [ (#t.platform)]]
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
  selected-only: false,   // publications: only entries with selected: true
  contributions: false,   // publications: print the one-line contribution statement
  max-authors: 20,        // publications: truncate longer author lists (APA 7 style)
  year-in-text: false,    // publications: repeat the year after the authors (it is in the margin)
  school: false,          // education: include school
  community-from: 2019,   // community service: drop entries that ended before this year
  descriptions: true,     // positions: print descriptions
) = {
  let profile = load("profile")
  let cfg = (selected-only: selected-only, contributions: contributions, max-authors: max-authors, year-in-text: year-in-text,
    school: school, community-from: community-from, descriptions: descriptions)
  let built = sys.inputs.at("date", default: datetime.today().display())
  let me = profile.name.given + " " + get(profile.name, "middle", default: "") + " " + profile.name.family

  set document(title: title + ", " + me, author: me)
  set text(font: font, size: 9.5pt, lang: "en", number-type: "lining")
  set par(leading: 0.62em, spacing: 0.8em)
  set page(
    paper: "a4",
    margin: (x: 2cm, top: 1.8cm, bottom: 2cm),
    footer: context text(size: 0.8em)[
      #me, #lower(title) #h(1fr) Updated #built #h(1fr) #counter(page).display() / #counter(page).final().first()
    ],
  )
  show link: set text(fill: cobalt)
  show strong: it => semibold(it.body)

  header(profile)
  for s in sections {
    assert(s in renderers, message: "unknown CV section: " + s)
    renderers.at(s)(cfg, profile)
  }
}
