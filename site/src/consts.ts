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

// Analytics stay off unless PUBLIC_UMAMI_WEBSITE_ID is set (decision pending, see REDESIGN.md).
export const UMAMI_SRC = import.meta.env.PUBLIC_UMAMI_SRC ?? '';
export const UMAMI_WEBSITE_ID = import.meta.env.PUBLIC_UMAMI_WEBSITE_ID ?? '';
