// Checks the URL mapping in redirects.yml against the old site (../docs) and the
// new build (dist/):
//   1. every file in ../docs exists at the same path in dist/, is redirected, or is retired;
//   2. every redirect page was built, and its target (including #anchor) exists in dist/.
// Exits with 1 on any problem. Skips check 1 when ../docs no longer exists (after cutover).
//
// Usage (after `npm run build`): node scripts/check-urls.mjs

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import YAML from 'yaml';

const site = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const dist = path.join(site, 'dist');
const docs = path.join(site, '..', 'docs');
const { redirects, retired } = YAML.parse(fs.readFileSync(path.join(site, 'redirects.yml'), 'utf8'));

const files = (dir) =>
	fs
		.readdirSync(dir, { withFileTypes: true, recursive: true })
		.filter((e) => e.isFile())
		.map((e) => '/' + path.relative(dir, path.join(e.parentPath, e.name)).split(path.sep).join('/'));

// `**` matches any number of segments, `*` matches within one segment.
const toRegex = (glob) =>
	new RegExp('^' + glob.replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/\*\*/g, '\0').replace(/\*/g, '[^/]*').replace(/\0/g, '.*') + '$');
const retiredRes = retired.map((r) => toRegex(r.path));

// "/x/" or "/x/#a" -> "/x/index.html"
const targetFile = (u) => {
	const p = decodeURI(u.split('#')[0]);
	return p.endsWith('/') ? p + 'index.html' : p;
};

if (!fs.existsSync(dist)) {
	console.error('check-urls: dist/ not found; run `npm run build` first.');
	process.exit(1);
}
const built = new Set(files(dist));
const problems = [];

if (fs.existsSync(docs)) {
	let kept = 0, redirected = 0, gone = 0;
	for (const f of files(docs)) {
		if (redirects[f]) redirected++;
		else if (retiredRes.some((re) => re.test(f))) gone++;
		else if (built.has(f)) kept++;
		else problems.push(`not mapped: ${f} (missing in dist/, not redirected, not retired)`);
	}
	console.log(`check-urls: docs/ files: ${kept} kept, ${redirected} redirected, ${gone} retired`);
} else {
	console.log('check-urls: ../docs not found, skipping the old-URL check');
}

for (const [from, to] of Object.entries(redirects)) {
	if (!built.has(targetFile(to))) problems.push(`redirect target missing: ${from} -> ${to}`);
	if (!built.has(from)) problems.push(`redirect page not built: ${from}`);
}

// Anchors on redirect targets: the target page must contain id="<anchor>".
for (const [from, to] of Object.entries(redirects)) {
	const anchor = to.split('#')[1];
	if (!anchor) continue;
	const f = path.join(dist, targetFile(to));
	if (fs.existsSync(f) && !fs.readFileSync(f, 'utf8').includes(`id="${anchor}"`)) {
		problems.push(`anchor missing: ${from} -> ${to}`);
	}
}

if (problems.length) {
	console.error(problems.map((p) => `  ${p}`).join('\n'));
	process.exit(1);
}
console.log(`check-urls: ok (${Object.keys(redirects).length} redirects)`);
