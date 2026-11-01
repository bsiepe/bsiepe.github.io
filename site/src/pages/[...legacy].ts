// Redirect pages for old URLs, generated from ../../redirects.yml.
// Each one is written at the exact old file path (e.g. talks/<folder>/index-saa.html),
// since GitHub Pages has no server-side redirects.
import fs from 'node:fs';
import path from 'node:path';
import type { APIRoute } from 'astro';
import YAML from 'yaml';
import { url } from '../utils/paths';

export function getStaticPaths() {
	const file = path.join(process.cwd(), 'redirects.yml');
	const { redirects } = YAML.parse(fs.readFileSync(file, 'utf8')) as { redirects: Record<string, string> };
	return Object.entries(redirects).map(([from, to]) => ({
		params: { legacy: from.replace(/^\//, '') },
		props: { to },
	}));
}

const esc = (s: string) => s.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;');

export const GET: APIRoute = ({ props, site }) => {
	const to = url(props.to as string);
	const abs = new URL(to, site).href;
	const html = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Moved</title>
<meta name="robots" content="noindex">
<link rel="canonical" href="${esc(abs)}">
<meta http-equiv="refresh" content="0; url=${esc(to)}">
</head>
<body>
<p>This page has moved to <a href="${esc(to)}">${esc(abs)}</a>.</p>
</body>
</html>
`;
	return new Response(html, { headers: { 'Content-Type': 'text/html; charset=utf-8' } });
};
