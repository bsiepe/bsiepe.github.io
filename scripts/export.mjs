// Generates the exports from data/ into build/exports/:
//   publications.bib        BibTeX (UTF-8, for biblatex/biber or a UTF-8-aware BibTeX)
//   publications.json       CSL-JSON
//   Simulation-Lecture-Dates.ics   calendar for data/lecture_series.yml
// Bibliographic core only: no abstracts, links, areas, or notes. Hidden entries are left out.
//
// Usage: node scripts/export.mjs   (or: npm run export)
// The site copies these files to their URLs (see site/scripts/sync-assets.mjs).

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import YAML from "yaml";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const SITE = "https://bsiepe.github.io";
const outDir = path.join(root, "build", "exports");
fs.mkdirSync(outDir, { recursive: true });

const load = (name) => YAML.parse(fs.readFileSync(path.join(root, "data", `${name}.yml`), "utf8"));
const visible = (xs) => xs.filter((x) => !x.hidden);
const pubs = visible(load("publications"));
const fullName = (p) => (p.given ? `${p.given} ${p.family}` : p.family);

// --- BibTeX -----------------------------------------------------------------

const BIB_TYPES = { article: "article", preprint: "misc", chapter: "incollection", report: "techreport", thesis: "phdthesis" };
const bibEscape = (s) => String(s).replace(/([&%$#_])/g, "\\$1");
// Escaped when built (author, editor via bibNames; title) or verbatim in biblatex (doi, url).
const RAW_FIELDS = new Set(["author", "editor", "title", "doi", "url"]);
const bibNames = (ps) =>
  ps.map((p) => (p.given ? `${bibEscape(p.family)}, ${bibEscape(p.given)}` : `{${bibEscape(p.family)}}`)).join(" and ");

function bibEntry(p) {
  const f = [
    ["author", bibNames(p.authors)],
    ["title", bibEscape(p.title)],
  ];
  if (p.type === "article") f.push(["journal", p.venue]);
  if (p.type === "preprint") f.push(["howpublished", p.venue]);
  if (p.type === "report") f.push(["institution", p.venue], ["number", p.report_number]);
  if (p.type === "chapter") {
    f.push(["booktitle", p.book_title], ["editor", bibNames(p.editors)], ["publisher", p.publisher], ["series", p.series]);
  }
  f.push(
    ["year", p.year],
    ["volume", p.volume],
    ["number", p.type === "article" ? p.issue : undefined],
    ["pages", p.pages ? p.pages.replace("-", "--") : p.article_number],
    ["doi", p.doi ?? p.preprint_doi],
    ["url", p.doi || p.preprint_doi ? undefined : p.url],
    ["langid", p.language === "de" ? "german" : undefined],
    ["pubstate", p.status === "in-press" ? "inpress" : undefined],
  );
  const body = f
    .filter(([, v]) => v !== undefined && v !== "")
    .map(([k, v]) => `  ${k} = {${RAW_FIELDS.has(k) ? v : bibEscape(v)}}`)
    .join(",\n");
  return `@${BIB_TYPES[p.type]}{${p.id},\n${body}\n}`;
}

const bibHeader = `% Publications of Björn Siepe. Generated from data/publications.yml; do not edit.\n% ${SITE}/publications/\n`;
fs.writeFileSync(path.join(outDir, "publications.bib"), bibHeader + "\n" + pubs.map(bibEntry).join("\n\n") + "\n");

// --- CSL-JSON ---------------------------------------------------------------

const CSL_TYPES = { article: "article-journal", preprint: "article", chapter: "chapter", report: "report", thesis: "thesis" };
const cslNames = (ps) => ps.map((p) => (p.given ? { family: p.family, given: p.given } : { literal: p.family }));

function cslEntry(p) {
  const e = {
    id: p.id,
    type: CSL_TYPES[p.type],
    title: p.title,
    author: cslNames(p.authors),
    issued: { "date-parts": [[p.year]] },
    "container-title": p.type === "chapter" ? p.book_title : p.type === "article" ? p.venue : undefined,
    publisher: p.type === "chapter" ? p.publisher : p.type === "preprint" || p.type === "report" ? p.venue : undefined,
    "collection-title": p.series,
    editor: p.editors ? cslNames(p.editors) : undefined,
    volume: p.volume,
    issue: p.type === "article" ? p.issue : undefined,
    page: p.pages,
    number: p.report_number ?? p.article_number,
    DOI: p.doi ?? p.preprint_doi,
    URL: p.doi || p.preprint_doi ? undefined : p.url,
    language: p.language,
    status: p.status === "in-press" ? "in press" : undefined,
  };
  return Object.fromEntries(Object.entries(e).filter(([, v]) => v !== undefined));
}

fs.writeFileSync(path.join(outDir, "publications.json"), JSON.stringify(pubs.map(cslEntry), null, 2) + "\n");

// --- iCalendar for the lecture series -----------------------------------------

const series = load("lecture_series");

// Wall-clock time in `tz` -> UTC "YYYYMMDDTHHMMSSZ".
function toUtc(date, time, tz, addMinutes = 0) {
  const [y, mo, d] = date.split("-").map(Number);
  const [h, mi] = time.split(":").map(Number);
  const guess = Date.UTC(y, mo - 1, d, h, mi + addMinutes);
  const parts = Object.fromEntries(
    new Intl.DateTimeFormat("en-US", { timeZone: tz, hourCycle: "h23", year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit" })
      .formatToParts(new Date(guess))
      .map((x) => [x.type, Number(x.value)]),
  );
  const offset = Date.UTC(parts.year, parts.month - 1, parts.day, parts.hour, parts.minute) - guess;
  return stamp(new Date(guess - offset));
}
const stamp = (dt) => dt.toISOString().replace(/[-:]/g, "").replace(/\.\d{3}/, "");
const icsText = (s) => String(s).replace(/\\/g, "\\\\").replace(/;/g, "\\;").replace(/,/g, "\\,").replace(/\n/g, "\\n");

// Fold lines at 75 octets (RFC 5545), without splitting UTF-8 characters.
function fold(line) {
  const out = [];
  let cur = "";
  for (const ch of line) {
    if (Buffer.byteLength(cur + ch) > (out.length ? 74 : 75)) {
      out.push(cur);
      cur = "";
    }
    cur += ch;
  }
  out.push(cur);
  return out.join("\r\n ");
}

const pageUrl = `${SITE}/simulation-talk-series/`;
const now = stamp(new Date());
const events = visible(series.sessions).map((s) => {
  const desc = [`Title of the talk: "${s.title}"`];
  if (s.links?.join) desc.push(`Meeting room: ${s.links.join}`);
  desc.push(`Additional infos: ${pageUrl}`);
  return [
    "BEGIN:VEVENT",
    `UID:${series.id}-${s.date}@bsiepe.github.io`,
    `DTSTAMP:${now}`,
    `DTSTART:${toUtc(s.date, s.time, series.timezone)}`,
    `DTEND:${toUtc(s.date, s.time, series.timezone, series.duration_minutes)}`,
    `SUMMARY:${icsText(`Simulation Lunch Lectures: ${s.speakers.map(fullName).join(", ")}`)}`,
    `DESCRIPTION:${icsText(desc.join("\n"))}`,
    s.links?.join && `URL:${s.links.join}`,
    "BEGIN:VALARM",
    "ACTION:DISPLAY",
    "TRIGGER:-PT30M",
    "DESCRIPTION:Reminder",
    "END:VALARM",
    "END:VEVENT",
  ].filter(Boolean);
});
const ics = [
  "BEGIN:VCALENDAR",
  "VERSION:2.0",
  "PRODID:-//bsiepe.github.io//lecture series//EN",
  "CALSCALE:GREGORIAN",
  `X-WR-CALNAME:${icsText(series.title)}`,
  ...events.flat(),
  "END:VCALENDAR",
];
fs.writeFileSync(path.join(outDir, "Simulation-Lecture-Dates.ics"), ics.map(fold).join("\r\n") + "\r\n");

console.log(`exports: ${pubs.length} publications (bib, json), ${events.length} lecture sessions (ics) -> build/exports/`);
