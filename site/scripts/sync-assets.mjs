// Copies files that live outside site/ into site/public/ under the same paths,
// so that every file path in data/ is also its URL path (see REDESIGN.md):
//   talks/**, workshops/** (slides), files/images/** (photos), and the CV PDF
//   built by `npm run cv` in the repo root (build/cv/cv_siepe.pdf -> /cv/cv_siepe.pdf),
//   and the exports built by `npm run export` (build/exports/ -> see EXPORTS below).
// The copies are git-ignored. Runs before `astro dev` and `astro build`.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const site = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const repo = path.resolve(site, '..');
const pub = path.join(site, 'public');

function copyTree(rel, exts) {
	const src = path.join(repo, rel);
	if (!fs.existsSync(src)) return 0;
	let n = 0;
	for (const entry of fs.readdirSync(src, { withFileTypes: true, recursive: true })) {
		if (!entry.isFile()) continue;
		const from = path.join(entry.parentPath, entry.name);
		if (exts && !exts.includes(path.extname(entry.name).toLowerCase())) continue;
		const to = path.join(pub, path.relative(repo, from));
		fs.mkdirSync(path.dirname(to), { recursive: true });
		if (!fs.existsSync(to) || fs.statSync(to).mtimeMs < fs.statSync(from).mtimeMs) fs.copyFileSync(from, to);
		n++;
	}
	return n;
}

const slides = ['.pdf', '.html'];
const counts = {
	talks: copyTree('talks', slides),
	workshops: copyTree('workshops', slides),
	images: copyTree(path.join('files', 'images')),
};

const cv = path.join(repo, 'build', 'cv', 'cv_siepe.pdf');
if (fs.existsSync(cv)) {
	fs.mkdirSync(path.join(pub, 'cv'), { recursive: true });
	fs.copyFileSync(cv, path.join(pub, 'cv', 'cv_siepe.pdf'));
	counts.cv = 1;
} else {
	console.warn('sync-assets: build/cv/cv_siepe.pdf not found; run `npm run cv` in the repo root first.');
}
// Exports from ../scripts/export.mjs and the URLs they are served at.
const EXPORTS = {
	'publications.bib': 'publications.bib',
	'publications.json': 'publications.json',
	'Simulation-Lecture-Dates.ics': 'simulation-talk-series/Simulation-Lecture-Dates.ics',
};
counts.exports = 0;
for (const [file, dest] of Object.entries(EXPORTS)) {
	const from = path.join(repo, 'build', 'exports', file);
	if (!fs.existsSync(from)) {
		console.warn(`sync-assets: build/exports/${file} not found; run \`npm run export\` in the repo root first.`);
		continue;
	}
	fs.mkdirSync(path.dirname(path.join(pub, dest)), { recursive: true });
	fs.copyFileSync(from, path.join(pub, dest));
	counts.exports++;
}

console.log('sync-assets:', Object.entries(counts).map(([k, v]) => `${k} ${v}`).join(', '));
