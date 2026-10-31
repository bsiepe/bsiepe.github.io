import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

// Blog posts live in ../content/blog/<slug>/index.md (the source of truth).
// Their front matter is validated against ../schema/blog.schema.json by
// ../scripts/validate.mjs; this schema only shapes the fields for the pages.
const person = z.object({ family: z.string(), given: z.string().optional(), me: z.boolean().optional() });

const blog = defineCollection({
	loader: glob({
		base: '../content/blog',
		pattern: '*/index.md',
		generateId: ({ entry }) => entry.split('/')[0],
	}),
	schema: ({ image }) =>
		z.object({
			title: z.string(),
			date: z.coerce.date(),
			updated: z.coerce.date().optional(),
			description: z.string().optional(),
			authors: z.array(person),
			areas: z.array(z.string()).optional(),
			tags: z.array(z.string()).optional(),
			image: image().optional(),
			publications: z.array(z.string()).optional(),
			software: z.array(z.string()).optional(),
			draft: z.boolean().optional(),
		}),
});

export const collections = { blog };
