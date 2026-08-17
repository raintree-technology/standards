---
type: Reference
title: Version 1 coverage matrix
description: Maps the bounded Raintree v1 task surface to governed standards, profiles, playbooks, and remaining approval work.
tags: [coverage, v1, standards, profiles]
generated: { by: codex/gpt-5, at: "2026-08-17T17:08:47Z" }
---

# Version 1 coverage matrix

Use this matrix to find the governed route and approval state for a recurring work
area. The bounded version 1 baseline covers product, engineering, services, data, web,
interfaces, lifecycle marketing, AI, and operations. “Authored” means that rules and
routes exist; it does not mean that independent or qualified approval is complete.

| Work area | Required standards and profiles | Vendor or platform playbook | V1 state |
|---|---|---|---|
| Agentic systems | `AI-AGENTS`, `ENGINEERING-QUALITY`, agentic profile; `ENGINEERING-JS-QUALITY` for JavaScript and TypeScript | Trellis for JavaScript and TypeScript; vendored anti-slop through Oxlint for TypeScript | Authored; qualified review pending |
| Programmatic interfaces and services | `API-CONTRACTS`, `ENGINEERING-QUALITY`, `ENGINEERING-JS-QUALITY` for JavaScript and TypeScript, `OPERATIONS-RELIABILITY`, programmatic-interface/service profile | Trellis for JavaScript and TypeScript; vendored anti-slop through Oxlint for TypeScript | Authored; qualified review pending |
| Database and data | `DATA-DATABASE`, `DATA-QUALITY`, `DATA-REDIS`, database-change and Redis-change profiles; `ENGINEERING-JS-QUALITY` for JavaScript and TypeScript tooling | Trellis for JavaScript and TypeScript; vendored anti-slop through Oxlint for TypeScript; GA4 when an analytics implementation | Authored; Redis draft and qualified review pending |
| Product delivery | `PRODUCT-DELIVERY`, product-feature profile; `ENGINEERING-JS-QUALITY` for JavaScript and TypeScript | Trellis for JavaScript and TypeScript; vendored anti-slop through Oxlint for TypeScript | Authored; qualified review pending |
| Universal UI and content | `DESIGN-INTERACTION`, `FND-ACCESSIBILITY`, `CONTENT-INTERFACE`, UI-feature profile; `ENGINEERING-JS-QUALITY` for JavaScript and TypeScript | Trellis for JavaScript and TypeScript; vendored anti-slop through Oxlint for TypeScript | Authored; accessibility review pending |
| Apple interfaces | Universal UI corpus and Apple-interface profile | Apple HIG audit | Authored; platform review pending |
| Public web and search | `WEB-QUALITY`, `SEO-FOUNDATIONS`, public-web profile; `ENGINEERING-JS-QUALITY` for JavaScript and TypeScript | Trellis for JavaScript and TypeScript; vendored anti-slop through Oxlint for TypeScript; Search Console | Authored; source and accessibility review pending |
| Analytics and experiments | `ANALYTICS-MEASUREMENT`, `GROWTH-EXPERIMENTS`, growth-experiment profile | GA4 | Authored; analytics and privacy review pending |
| Core lifecycle marketing | `MARKETING-LIFECYCLE`, marketing-lifecycle profile | GA4 and Search Console when applicable | Authored; marketing, privacy, and legal review pending |
| Functional writing and errors | `WRITING-FUNCTIONAL`, `CONTENT-ERRORS`, functional-writing profile | None | Existing stable corpus; independent verification pending |
| Commercial evidence reviews | Commercial-evidence-review profile, `FND-EVIDENCE`, `WRITING-FUNCTIONAL`, conditional sales, marketing, privacy, and security routes | None | Post-v1 draft; research, sales, and qualified domain review pending |
| Public legal documents | `LEGAL-PUBLISHED-TERMS`, legal-document profile, `PRIVACY-DATA`, `FND-TRUST`, `WRITING-FUNCTIONAL` | None | Post-v1 draft; qualified legal and privacy review pending |
| Organizational knowledge systems | `KNOWLEDGE-SYSTEMS`, company-brain profile, federated-knowledge pattern | Standards conformance audit | Post-v1 draft; knowledge, AI, data, security, privacy, product, and engineering review pending |
| Code and dependency removal | `ENGINEERING-CODE-REMOVAL`, code-removal profile, `FND-CHANGE`, `AGENT-VERIFICATION` | Knip plus Biome/Trellis for TypeScript/JavaScript; Ruff, deptry, and contextual Vulture for Python | Post-v1 draft; engineering review pending |
| Reliability and incidents | `OPERATIONS-RELIABILITY`, `FND-CHANGE`, reliability/incident profile | None | Authored; operations and security review pending |
| Privacy and application security | `PRIVACY-DATA`, `SECURITY-APPLICATION` | None | Existing drafts; qualified review pending |
| Secrets and credentials | `SECURITY-SECRETS`, secrets/Infisical profile | None; Infisical is required by the standard | Authored; qualified security and operations review pending |
| External platforms | `INTEGRATIONS-VENDOR` plus the closest task profile | Separate Stripe, Plaid, Vercel, Resend, Neon, and Cloudflare playbooks with manifest-backed review bundles | Post-v1 drafts; provider-domain review pending |

## Cross-cutting foundations

Every active profile routes directly or conditionally to evidence, trust, safe change, accessibility, privacy, security, and agent verification according to the task's behavior and risk.

## Outside the v1 boundary

The former specialist queue is now authored as governed drafts: `MARKETING-PAID-MEDIA`, `MARKETING-DIRECT-OUTREACH`, `MARKETING-PUBLIC-ENGAGEMENT`, `MARKETING-DISTRIBUTION`, `SALES-REVENUE-OPERATIONS`, `DISCOVERY-APP-STORES`, and `MEDIA-PRODUCTION-RIGHTS`, routed by `PROFILE-SPECIALIST-MARKETING`. `LEGAL-PUBLISHED-TERMS` and `PROFILE-LEGAL-DOCUMENT` add a post-v1 route for public terms, notices, policies, and addenda. These documents remain outside the bounded v1 release and need independent, domain-qualified review before activation. The [marketing coverage map](marketing/coverage.md) records each external Marketing Skills task and its exact route.
