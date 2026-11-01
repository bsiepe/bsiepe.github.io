// Reads the shared data in ../data/*.yml (the only source; see REDESIGN.md).
// Runs at build time only. Validation happens in ../scripts/validate.mjs.

import fs from 'node:fs';
import path from 'node:path';
import YAML from 'yaml';

// Astro runs from site/, so the repo root is one level up.
export const repoRoot = path.resolve(process.cwd(), '..');

const cache = new Map<string, unknown>();

export function load<T = any>(name: string): T {
	if (!cache.has(name)) {
		const file = path.join(repoRoot, 'data', `${name}.yml`);
		cache.set(name, YAML.parse(fs.readFileSync(file, 'utf8')));
	}
	return cache.get(name) as T;
}

export const visible = <T extends { hidden?: boolean }>(xs: T[]): T[] => xs.filter((x) => !x.hidden);

export interface Person { family: string; given?: string; me?: boolean }
export type Link = string | { url: string; note?: string };

export interface Publication {
	id: string; type: string; title: string; authors: Person[]; year: number; status: string;
	venue?: string; volume?: string; issue?: string; pages?: string; article_number?: string;
	report_number?: string; book_title?: string; series?: string; editors?: Person[]; publisher?: string;
	doi?: string; preprint_doi?: string; url?: string; links?: Record<string, Link>;
	shared_first?: number[]; shared_second?: number[]; areas?: string[]; abstract?: string; selected?: boolean; hidden?: boolean;
}

export interface TalkEvent {
	date: string; title?: string; venue: string; institution?: string; city?: string; country?: string;
	online?: boolean; type: string; roles: string[]; coauthors?: Person[]; file?: string; award?: string; hidden?: boolean;
}
export interface Talk {
	id: string; title: string; areas?: string[]; tags?: string[]; abstract?: string; publications?: string[];
	links?: Record<string, Link>; license?: string; events: TalkEvent[]; hidden?: boolean;
}

export interface WorkshopSession {
	date: string; end_date?: string; title?: string; host: string; institution?: string; city?: string; country?: string;
	online?: boolean; duration_hours?: number; format?: string; coinstructors?: Person[]; file?: string; hidden?: boolean;
}
export interface Workshop {
	id: string; title: string; description?: string; areas?: string[]; tags?: string[]; links?: Record<string, Link>;
	doi?: string; license?: string; sessions: WorkshopSession[]; hidden?: boolean;
}

export interface LectureSession {
	date: string; time: string; speakers: Person[]; title: string;
	links?: { join?: string; slides?: string; recording?: string }; hidden?: boolean;
}
export interface LectureSeries {
	id: string; title: string; about?: string; schedule?: string; organizer?: string; contact_email?: string;
	timezone: string; duration_minutes: number; sessions: LectureSession[];
}

export const publications = () => visible(load<Publication[]>('publications'));
export const talks = () =>
	visible(load<Talk[]>('talks'))
		.map((t) => ({ ...t, events: visible(t.events).sort((a, b) => b.date.localeCompare(a.date)) }))
		.filter((t) => t.events.length > 0)
		.sort((a, b) => b.events[0].date.localeCompare(a.events[0].date));
export const workshops = () =>
	visible(load<Workshop[]>('workshops'))
		.map((w) => ({ ...w, sessions: visible(w.sessions).sort((a, b) => b.date.localeCompare(a.date)) }))
		.filter((w) => w.sessions.length > 0)
		.sort((a, b) => b.sessions[0].date.localeCompare(a.sessions[0].date));
export const lectureSeries = () => {
	const s = load<LectureSeries>('lecture_series');
	return { ...s, sessions: visible(s.sessions).sort((a, b) => a.date.localeCompare(b.date)) };
};
export const software = () => visible(load<any[]>('software'));
export const news = () => visible(load<any[]>('news')).sort((a, b) => String(b.date).localeCompare(String(a.date)));
export const profile = () => load<any>('profile');
