// Site-wide values, derived from ../data/profile.yml (the only place for personal data).

import { profile } from './lib/data';

const p = profile();
const fullName = [p.name.given, p.name.family].join(' ');

export const SITE_TITLE = fullName;
export const SITE_DESCRIPTION = `${fullName}, ${p.position} at ${p.affiliation.institution}.`;
export const CV_URL = '/cv/cv_siepe.pdf';

export const PROFILE = p;
export const EMAIL: string = p.email[p.email.website ?? 'work'];

export const SOCIAL_LINKS: ReadonlyArray<{ label: string; href: string }> = [
	{ label: 'Email', href: `mailto:${EMAIL}` },
	{ label: 'GitHub', href: `https://github.com/${p.github}` },
	{ label: 'ORCID', href: `https://orcid.org/${p.orcid}` },
	{ label: 'Bluesky', href: `https://bsky.app/profile/${p.bluesky}` },
	{ label: 'LinkedIn', href: p.linkedin },
];

// GoatCounter analytics, production builds only. The script is self-hosted
// (public/js/count.js, ISC license); only the page-view beacon goes to this endpoint.
// Explicit exception to the no-external-requests rule (REDESIGN.md, open question 2).
export const GOATCOUNTER_ENDPOINT = 'https://bsiepe.goatcounter.com/count';
