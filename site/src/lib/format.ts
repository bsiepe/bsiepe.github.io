// Formatting helpers shared by the pages. Same conventions as the CV (cv/lib/cv.typ).

import type { Link, Person, Publication } from './data';

export const urlOf = (l: Link) => (typeof l === 'string' ? l : l.url);
export const noteOf = (l: Link) => (typeof l === 'string' ? undefined : l.note);

export function initials(given?: string): string {
	if (!given) return '';
	return given
		.split(' ')
		.filter(Boolean)
		.map((p) => (p.endsWith('.') && p.length <= 4 ? p : p.split('-').map((q) => `${[...q][0]}.`).join('-')))
		.join(' ');
}

// APA 7 truncation: up to `max` authors in full, otherwise the first max-1, an
// ellipsis (null), and the last. My own entry is kept if it falls in the gap.
export function shownAuthors(authors: Person[], max = 20): (number | null)[] {
	const n = authors.length;
	if (n <= max) return authors.map((_, i) => i);
	const me = authors.findIndex((a) => a.me);
	const head = [...Array(max - 1).keys()];
	const mine = me >= max - 1 && me < n - 1 ? [null, me] : [];
	return [...head, ...mine, null, n - 1];
}

export const shortName = (p: Person) => (initials(p.given) ? `${p.family}, ${initials(p.given)}` : p.family);
export const fullName = (p: Person) => (p.given ? `${p.given} ${p.family}` : p.family);

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

// "2026", "2026-07", or "2026-07-01" -> "2026", "Jul 2026", "1 Jul 2026"
export function formatDate(d: string | number): string {
	const [y, m, day] = String(d).split('-');
	if (!m) return y;
	const mm = MONTHS[Number(m) - 1];
	return day ? `${Number(day)} ${mm} ${y}` : `${mm} ${y}`;
}

export const year = (d: string | number) => String(d).slice(0, 4);

export const AREA_LABELS: Record<string, string> = {
	simulation: 'Simulation studies',
	timeseries: 'Time series',
	esm: 'Experience sampling',
	bayesian: 'Bayesian statistics',
	networks: 'Network analysis',
	'open-science': 'Open science',
	metascience: 'Metascience',
};

// Venue line for a publication, APA style, without the authors and title.
export function venueParts(p: Publication): { venue?: string; rest: string } {
	if (p.type === 'chapter') {
		const eds = (p.editors ?? []).map((e) => (initials(e.given) ? `${initials(e.given)} ${e.family}` : e.family));
		const inner = [p.series, p.volume && `Vol. ${p.volume}`, p.pages && `pp. ${p.pages.replace('-', '–')}`].filter(Boolean);
		return {
			venue: p.book_title,
			rest: `In ${eds.join(', ')} (${eds.length === 1 ? 'Ed.' : 'Eds.'})${inner.length ? ` (${inner.join(', ')})` : ''}. ${p.publisher ?? ''}`.trim(),
		};
	}
	if (p.type === 'report') return { venue: p.venue, rest: p.report_number ? `No. ${p.report_number}` : '' };
	const bits: string[] = [];
	if (p.volume) bits.push(p.issue ? `${p.volume}(${p.issue})` : p.volume);
	if (p.pages) bits.push(p.pages.replace('-', '–'));
	else if (p.article_number) bits.push(`Article ${p.article_number}`);
	if (p.status === 'advance-online') bits.push('Advance online publication');
	if (p.status === 'in-press') bits.push('In press');
	return { venue: p.venue, rest: bits.join(', ') };
}

// Fixed artifact slots, shown on every publication; missing ones are greyed out.
export function artifactSlots(p: Publication) {
	const ls = p.links ?? {};
	const preprint = p.preprint_doi ? `https://doi.org/${p.preprint_doi}` : ls.preprint ? urlOf(ls.preprint) : undefined;
	const slots: { label: string; href?: string }[] =
		p.type === 'preprint'
			? [{ label: 'Preprint', href: preprint }]
			: [
					{ label: 'Paper', href: p.doi ? `https://doi.org/${p.doi}` : p.url },
					{ label: 'Preprint', href: preprint },
				];
	return slots.concat([
		{ label: 'Code', href: ls.code ? urlOf(ls.code) : undefined },
		{ label: ls.data && noteOf(ls.data) ? 'Data (synthetic)' : 'Data', href: ls.data ? urlOf(ls.data) : undefined },
		{ label: 'Materials', href: ls.materials ? urlOf(ls.materials) : undefined },
		{ label: 'Prereg', href: ls.prereg ? urlOf(ls.prereg) : undefined },
	]);
}

// Extra links that are not part of the fixed slots.
export function extraLinks(p: Publication) {
	const ls = p.links ?? {};
	return [
		['supplement', 'Supplement'],
		['app', 'App'],
		['website', 'Website'],
		['slides', 'Slides'],
	]
		.filter(([k]) => ls[k])
		.map(([k, label]) => ({ label, href: urlOf(ls[k]) }));
}

export const TALK_TYPES: Record<string, string> = {
	keynote: 'Keynote',
	invited: 'Invited talk',
	colloquium: 'Colloquium',
	symposium: 'Symposium talk',
	conference: 'Conference talk',
	lightning: 'Lightning talk',
	panel: 'Panel',
	poster: 'Poster',
};

export function place(e: { institution?: string; city?: string; online?: boolean }) {
	let city = e.city;
	if (e.institution && city && e.institution.includes(city)) city = undefined;
	return [e.institution, e.online ? 'online' : city].filter(Boolean).join(', ');
}
