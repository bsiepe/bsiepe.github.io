// Talk thumbnails: the first page of the most recent PDF of each talk, rendered
// with pdftoppm into public/thumbnails/talks/<id>.png (git-ignored). A talk's
// `thumbnail` field in data/talks.yml overrides this and is copied instead.
// Talks with neither get no image; the pages show a plain title card.
// Only re-renders when the source is newer than the thumbnail.
//
// The pdftoppm binary (poppler) is taken from $PDFTOPPM, else from PATH. If it
// is missing, existing thumbnails are kept and the rest fall back to title cards.

import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import YAML from 'yaml';

const site = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const repo = path.resolve(site, '..');
const outDir = path.join(site, 'public', 'thumbnails', 'talks');
const pdftoppm = process.env.PDFTOPPM || 'pdftoppm';
fs.mkdirSync(outDir, { recursive: true });

const talks = YAML.parse(fs.readFileSync(path.join(repo, 'data', 'talks.yml'), 'utf8')).filter((t) => !t.hidden);
const fresh = (src, dest) => fs.existsSync(dest) && fs.statSync(dest).mtimeMs >= fs.statSync(src).mtimeMs;

let rendered = 0, copied = 0, cards = 0, missingTool = false;
const wanted = new Set();
for (const t of talks) {
	if (t.thumbnail) {
		const src = path.join(repo, t.thumbnail);
		const dest = path.join(outDir, t.id + path.extname(src).toLowerCase());
		wanted.add(path.basename(dest));
		if (!fresh(src, dest)) fs.copyFileSync(src, dest);
		copied++;
		continue;
	}
	const latest = t.events
		.filter((e) => !e.hidden && e.file?.toLowerCase().endsWith('.pdf'))
		.sort((a, b) => b.date.localeCompare(a.date))[0];
	if (!latest) {
		cards++;
		continue;
	}
	const src = path.join(repo, latest.file);
	const dest = path.join(outDir, `${t.id}.png`);
	wanted.add(path.basename(dest));
	if (fresh(src, dest)) continue;
	if (missingTool) continue;
	try {
		// -singlefile writes <prefix>.png; 640 px wide is enough for a list thumbnail.
		execFileSync(pdftoppm, ['-png', '-f', '1', '-l', '1', '-singlefile', '-scale-to-x', '640', '-scale-to-y', '-1', src, dest.replace(/\.png$/, '')]);
		rendered++;
	} catch (e) {
		if (e.code !== 'ENOENT') throw e;
		missingTool = true;
		console.warn(`thumbnails: pdftoppm not found ("${pdftoppm}"); install poppler or set PDFTOPPM. Talks without a thumbnail get a title card.`);
	}
}

// Remove thumbnails of talks that no longer have one.
for (const f of fs.readdirSync(outDir)) if (!wanted.has(f)) fs.rmSync(path.join(outDir, f));

console.log(`thumbnails: ${rendered} rendered, ${copied} from data, ${cards} title cards`);
