// Lists works that OpenAlex attributes to my ORCID but whose DOI is not in data/.
// Read-only: never writes to data/ (REDESIGN.md, "Later, separate tasks").
//
// Known DOIs: every `doi` and `preprint_doi` in data/*.yml, plus the DOIs in
// scripts/openalex-ignore.yml (works I checked and do not want listed, with a reason).
// Preprint versions are compared without their _vN suffix, so a new PsyArXiv
// version of a known preprint is not reported.
//
// Works are found through author records, not the works ORCID filter (that filter
// returned hundreds of coauthors' works in Nov 2026): the record linked to my ORCID,
// plus records under my name that OpenAlex has not linked to any ORCID yet.
//
// Usage: node scripts/openalex-check.mjs [--out report.md]
// Prints the number of new works; with --out, also writes a Markdown report.
// OPENALEX_API_KEY (optional, free at openalex.org/settings/api): without it, requests
// share a small daily budget with everyone on the same IP address.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import YAML from 'yaml';

const repo = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const read = (f) => YAML.parse(fs.readFileSync(path.join(repo, f), 'utf8'));

const norm = (doi) =>
	String(doi)
		.trim()
		.toLowerCase()
		.replace(/^https?:\/\/(dx\.)?doi\.org\//, '')
		.replace(/_v\d+$/, '');

// Collect every DOI anywhere in data/, at any depth.
const known = new Set();
const collect = (v) => {
	if (Array.isArray(v)) v.forEach(collect);
	else if (v && typeof v === 'object')
		for (const [k, x] of Object.entries(v)) {
			if ((k === 'doi' || k === 'preprint_doi') && x) known.add(norm(x));
			else collect(x);
		}
};
for (const f of fs.readdirSync(path.join(repo, 'data')).filter((f) => f.endsWith('.yml'))) collect(read(`data/${f}`));

// Titles of my publications, to tell copies of known papers (repository deposits,
// earlier preprints) from works that are really new.
const squash = (t) => String(t ?? '').normalize('NFD').replace(/\p{M}/gu, '').toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim();
const titles = read('data/publications.yml').map((p) => squash(p.title));
const sameTitle = (w) => {
	const t = squash(w.title);
	return t.length > 15 && titles.some((k) => k === t || k.startsWith(t + ' ') || t.startsWith(k + ' '));
};

const ignoreFile = 'scripts/openalex-ignore.yml';
const ignored = fs.existsSync(path.join(repo, ignoreFile)) ? read(ignoreFile) ?? [] : [];
for (const i of ignored) known.add(norm(i.doi));

const profile = read('data/profile.yml');
const orcid = profile.orcid;
const key = process.env.OPENALEX_API_KEY ? `&api_key=${encodeURIComponent(process.env.OPENALEX_API_KEY)}` : '';
const api = async (q) => {
	const res = await fetch(`https://api.openalex.org/${q}${q.includes('?') ? '' : '?'}${key}`);
	if (!res.ok) throw new Error(`OpenAlex request failed: ${res.status} ${res.statusText} (${q})`);
	return res.json();
};

// Author records: the one linked to the ORCID, plus unlinked ones with my name.
const main = await api(`authors/orcid:${orcid}?select=id,display_name,works_count`);
const name = `${profile.name.given} ${profile.name.family}`;
const fold = (s) => s.normalize('NFD').replace(/\p{M}/gu, '').toLowerCase();
const matches = (await api(`authors?search=${encodeURIComponent(name)}&per-page=50&select=id,display_name,orcid,works_count`)).results
	.filter((a) => !a.orcid && fold(a.display_name).includes(fold(profile.name.family)) && fold(a.display_name).startsWith(fold(profile.name.given).slice(0, 3)));
const authors = [main, ...matches];
const ids = authors.map((a) => a.id.split('/').pop());

// All works of those records, with cursor paging.
const works = [];
for (let cursor = '*'; cursor; ) {
	const body = await api(`works?filter=authorships.author.id:${ids.join('|')}&per-page=200&cursor=${encodeURIComponent(cursor)}`);
	works.push(...body.results);
	cursor = body.meta.next_cursor;
}

// A work counts as known if any of its DOIs (main record or other locations) is known.
const dois = (w) =>
	[w.doi, ...(w.locations ?? []).map((l) => l.landing_page_url)]
		.filter((u) => u && /doi\.org\//i.test(u))
		.map(norm);
const fresh = works
	.filter((w) => w.doi && !dois(w).some((d) => known.has(d)))
	.sort((a, b) => (b.publication_date ?? '').localeCompare(a.publication_date ?? ''));

// One entry per DOI (OpenAlex sometimes has duplicate records).
const seen = new Set();
const report = fresh.filter((w) => !seen.has(norm(w.doi)) && seen.add(norm(w.doi)));

const line = (w) => {
	const venue = w.primary_location?.source?.display_name ?? 'unknown venue';
	return `- [ ] **${w.title ?? '(no title)'}** (${w.publication_year ?? 'n.d.'}). ${venue}, ${w.type}. https://doi.org/${norm(w.doi)}`;
};
const newWorks = report.filter((w) => !sameTitle(w));
const copies = report.filter(sameTitle);
const md = [
	`OpenAlex lists ${report.length} work(s) for ORCID ${orcid} whose DOI is not in \`data/\`.`,
	'',
	`## Not in data/ (${newWorks.length})`,
	'',
	...(newWorks.length ? newWorks.map(line) : ['None.']),
	'',
	`## Same title as a publication in data/ (${copies.length})`,
	'',
	'Usually a repository copy or an earlier preprint with its own DOI.',
	'',
	...(copies.length ? copies.map(line) : ['None.']),
	'',
	'For each: add it to `data/` (a new entry, or a missing `doi`/`preprint_doi`), or add the',
	`DOI with a reason to \`${ignoreFile}\` so it is not listed again.`,
	'',
	`Checked ${works.length} OpenAlex works from ${authors.length} author record(s) (${ids.join(', ')}; the first is linked to the ORCID)`,
	`against ${known.size} known DOIs on ${new Date().toISOString().slice(0, 10)}.`,
].join('\n');

const outIdx = process.argv.indexOf('--out');
if (outIdx > -1) fs.writeFileSync(process.argv[outIdx + 1], md + '\n');
console.log(report.length);
if (outIdx === -1 && report.length) console.error(md);
