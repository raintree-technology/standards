# Integration capability maps

* [External platform integrations](vendor-platforms.md) - Source-neutral requirements shared by material provider integrations.
* [Google Search Console](google-search-console/) - Full capability map with sources, semantics, workflows, and evaluations.
* [Stripe](stripe/) - Payment lifecycle, webhook, idempotency, and release checks.
* [Plaid](plaid/) - Link, token-boundary, webhook, and recovery checks.
* [Vercel](vercel/) - Deployment, environment, observability, and firewall checks.
* [Resend](resend/) - Sender, delivery, suppression, and webhook checks.
* [Neon](neon/) - Connection, branch, migration, and recovery checks.
* [Cloudflare](cloudflare/) - Workers runtime, binding, cache, and deployment checks.

Provider documentation is normative for provider behavior. Provider and other first-party engineering articles are informative: they may explain failure modes and design tradeoffs, but they cannot be the only source for a mapped capability. Agent skills route reviews and expose checks; they do not override the provider playbook or current official documentation. Apply `INTEGRATIONS-VENDOR-008` whenever those sources disagree.
