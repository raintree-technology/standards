---
type: Reference
title: Version 1 coverage matrix
description: Maps the bounded Raintree v1 task surface to governed standards, profiles, playbooks, and remaining approval work.
tags: [coverage, v1, standards, profiles]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
---

# Version 1 coverage matrix

The bounded v1 baseline covers recurring product, engineering, service, data, web, UI, marketing-lifecycle, AI, and operational work. “Authored” means the rules and routes exist; it does not mean independent or qualified approval is complete.

| Work area | Required standards and profiles | Vendor or platform playbook | V1 state |
|---|---|---|---|
| Agentic systems | `AI-AGENTS`, `ENGINEERING-QUALITY`, agentic profile | None | Authored; qualified review pending |
| APIs and services | `API-CONTRACTS`, `ENGINEERING-QUALITY`, `OPERATIONS-RELIABILITY`, service/API profile | None | Authored; qualified review pending |
| Database and data | `DATA-DATABASE`, `DATA-QUALITY`, database-change profile | GA4 when an analytics implementation | Authored; qualified review pending |
| Product delivery | `PRODUCT-DELIVERY`, product-feature profile | None | Authored; qualified review pending |
| Universal UI and content | `DESIGN-INTERACTION`, `FND-ACCESSIBILITY`, `CONTENT-INTERFACE`, UI-feature profile | None | Authored; accessibility review pending |
| Apple interfaces | Universal UI corpus and Apple-interface profile | Apple HIG audit | Authored; platform review pending |
| Public web and search | `WEB-QUALITY`, `SEO-FOUNDATIONS`, public-web profile | Search Console | Authored; source and accessibility review pending |
| Analytics and experiments | `ANALYTICS-MEASUREMENT`, `GROWTH-EXPERIMENTS`, growth-experiment profile | GA4 | Authored; analytics and privacy review pending |
| Core lifecycle marketing | `MARKETING-LIFECYCLE`, marketing-lifecycle profile | GA4 and Search Console when applicable | Authored; marketing, privacy, and legal review pending |
| Functional writing and errors | `WRITING-FUNCTIONAL`, `CONTENT-ERRORS`, functional-writing profile | None | Existing stable corpus; independent verification pending |
| Reliability and incidents | `OPERATIONS-RELIABILITY`, `FND-CHANGE`, reliability/incident profile | None | Authored; operations and security review pending |
| Privacy and application security | `PRIVACY-DATA`, `SECURITY-APPLICATION` | None | Existing drafts; qualified review pending |

## Cross-cutting foundations

Every active profile routes directly or conditionally to evidence, trust, safe change, accessibility, privacy, security, and agent verification according to the task's behavior and risk.

## Outside the v1 boundary

The former specialist queue is now authored as governed drafts: `MARKETING-PAID-MEDIA`, `MARKETING-DIRECT-OUTREACH`, `MARKETING-PUBLIC-ENGAGEMENT`, `MARKETING-DISTRIBUTION`, `SALES-REVENUE-OPERATIONS`, `DISCOVERY-APP-STORES`, and `MEDIA-PRODUCTION-RIGHTS`, routed by `PROFILE-SPECIALIST-MARKETING`. These documents remain outside the bounded v1 release and need independent, domain-qualified review before activation. The [marketing coverage map](marketing/coverage.md) records each external Marketing Skills task and its exact route.
