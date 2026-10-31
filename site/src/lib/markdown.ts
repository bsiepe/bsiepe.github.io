// Renders the Markdown fields in data/ (bio, news, abstracts) with Astro's own processor.
import { createMarkdownProcessor } from '@astrojs/markdown-remark';

const processor = await createMarkdownProcessor();

export async function md(source: string): Promise<string> {
	return (await processor.render(source)).code;
}

// For one-line fields: drops the surrounding <p>.
export async function mdInline(source: string): Promise<string> {
	return (await md(source)).replace(/^<p>([\s\S]*)<\/p>\s*$/, '$1');
}
