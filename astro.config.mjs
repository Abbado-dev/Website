// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
	site: 'https://abbado.dev',
	integrations: [
		starlight({
			title: 'Abbado',
			description: 'AI coding agent orchestrator. Multi-agent, multi-model, multi-CLI.',
			logo: {
				src: './src/assets/logo.svg',
				replacesTitle: false,
			},
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/abbado-dev/abbado' },
				{ icon: 'discord', label: 'Discord', href: '#' },
			],
			editLink: {
				baseUrl: 'https://github.com/abbado-dev/website/edit/main/',
			},
			customCss: ['./src/styles/custom.css'],
			sidebar: [
				{
					label: 'Getting Started',
					items: [
						{ label: 'Introduction', slug: 'docs/introduction' },
						{ label: 'Installation', slug: 'docs/installation' },
						{ label: 'Quick Start', slug: 'docs/quickstart' },
					],
				},
				{
					label: 'Core Concepts',
					items: [
						{ label: 'Projects & Repos', slug: 'docs/concepts/projects' },
						{ label: 'Agents & Templates', slug: 'docs/concepts/agents' },
						{ label: 'Sessions & Terminal', slug: 'docs/concepts/sessions' },
						{ label: 'Hooks Integration', slug: 'docs/concepts/hooks' },
					],
				},
				{
					label: 'Features',
					items: [
						{ label: 'Git Workflow', slug: 'docs/features/git-workflow' },
						{ label: 'Notifications', slug: 'docs/features/notifications' },
						{ label: 'Task Tracking', slug: 'docs/features/task-tracking' },
						{ label: 'Multi-Provider', slug: 'docs/features/multi-provider' },
					],
				},
				{
					label: 'Reference',
					items: [
						{ label: 'API', slug: 'docs/reference/api' },
						{ label: 'Configuration', slug: 'docs/reference/configuration' },
						{ label: 'CLI Hooks', slug: 'docs/reference/hooks' },
					],
				},
			],
		}),
	],
});
