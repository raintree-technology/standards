---
id: PROFILE-PUBLIC-WEB-PAGE
title: Public web page profile
description: Routes public web work to quality, search, trust, evidence, and verification requirements.
type: profile
status: draft
governance_status: draft
owners: [web, design, seo, content]
last_reviewed: 2026-08-17
review_by: 2027-02-17
stale_after: 2027-02-17
applies_to: [public-web-page, landing-page, marketing-site]
tags: [profile, web, seo]
depends_on: [WEB-QUALITY, SEO-FOUNDATIONS, FND-ACCESSIBILITY, FND-TRUST, FND-EVIDENCE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T08:30:41Z" }
---

# Public web page profile

Use for landing pages, marketing pages, public documentation, editorial pages, and indexable application surfaces.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `WEB-QUALITY` — document, accessibility, performance, resilience, security, and privacy quality
- `SEO-FOUNDATIONS` — crawling, indexing, canonicalization, and content purpose
- `FND-ACCESSIBILITY` — declared accessibility target and cross-input verification
- `FND-TRUST` — truthful claims and informed choices
- `FND-EVIDENCE` — factual and comparative claims
- `AGENT-VERIFICATION` — rendered inspection and handoff

## Conditional standards

- JavaScript or TypeScript implementation → `ENGINEERING-JS-QUALITY`
- Browser logs, errors, or operational events sent off the device → `OPERATIONS-LOGGING`
- Experiment or personalization → `GROWTH-EXPERIMENTS` and `ANALYTICS-MEASUREMENT`
- Interactive flow, form, navigation, or state change → `PROFILE-UI-FEATURE`
- Documentation, marketing claims, interface text, or explanatory content → `PROFILE-FUNCTIONAL-WRITING`
- Terms, privacy or cookie notice, acceptable-use policy, legal addendum, or legal center → `PROFILE-LEGAL-DOCUMENT`
- Form, upload, account, personalization, or other personal-data processing → `PRIVACY-DATA`
- Form submission, upload, authentication, authorization, server-side fetch, or other application behavior beyond static delivery → `SECURITY-APPLICATION`
- Public chat, model-generated content, retrieval, browser agent, or model-selected tool use → `PROFILE-AGENTIC-SYSTEM`
- URL or platform migration → `SEO-FOUNDATIONS-007` plus a dedicated migration plan
- Search Console ownership, inspection, or monitoring → `PLAYBOOK-GSC`
- Google Analytics 4 implementation → `PLAYBOOK-GA4`
- Core acquisition, conversion, or lifecycle marketing → `PROFILE-MARKETING-LIFECYCLE`
- Product portfolio, open-source index, repository landing page, or public project profile → `MARKETING-PROJECT-SHOWCASE`
- Paid placement destination, referral asset, syndicated listing, public engagement, or other specialist channel → `PROFILE-SPECIALIST-MARKETING`
- Vercel → `PLAYBOOK-VERCEL`; Cloudflare → `PLAYBOOK-CLOUDFLARE`; Resend → `PLAYBOOK-RESEND`; Stripe → `PLAYBOOK-STRIPE`; Plaid → `PLAYBOOK-PLAID`; Neon → `PLAYBOOK-NEON`
- Another material hosting or service platform without a named playbook → `INTEGRATIONS-VENDOR`, current official provider documentation, and a recorded library gap

## Completion evidence

- `SEO-FOUNDATIONS-001` and `FND-TRUST-001` — The page record identifies its audience and purpose, and the final page presents material consequences before commitment.
- `WEB-QUALITY-001`, `WEB-QUALITY-002`, and `WEB-QUALITY-015` — Delivered document semantics and rendered behavior were inspected across the declared representative environments.
- `WEB-QUALITY-003`, `WEB-QUALITY-004`, and `WEB-QUALITY-005` — Keyboard, focus, names, labels, alternatives, errors, contrast, zoom, reflow, and appropriate assistive behavior were checked.
- `SEO-FOUNDATIONS-002`, `SEO-FOUNDATIONS-003`, `SEO-FOUNDATIONS-004`, `SEO-FOUNDATIONS-006`, and `SEO-FOUNDATIONS-008` — Indexability, protocol status, canonical signals, structured data, titles, headings, and links are intentional and consistent.
- `WEB-QUALITY-006`, `WEB-QUALITY-008`, and `WEB-QUALITY-009` — Performance results, layout behavior, and third-party impact were measured against their budgets and documented boundaries.
- `WEB-QUALITY-011` — Actual storage and network behavior was inspected before consent, after consent, and after withdrawal where applicable.
- `SEO-FOUNDATIONS-011` — The page or generated page family has an identified audience, owner, source basis, and distinct user value rather than ranking-only variation.
- When localized, `SEO-FOUNDATIONS-012` and `WEB-QUALITY-012` — Locale URLs, content, language metadata, reciprocal alternates, fallback, layout, and locale switching were verified.
- When motion, timing, dragging, or gesture behavior exists, `WEB-QUALITY-016` — Reduced motion, control, time adjustment, and simpler input alternatives were exercised.
- For consequential submissions, `WEB-QUALITY-017` and `CONTENT-ERRORS-012` — Reversal, validation and correction, or review and confirmation prevents material input errors.
- When browser permissions are requested, `WEB-QUALITY-018` — Grant, denial, revocation, embedded capability, and fallback behavior were inspected.
- When browser logs leave the device, `OPERATIONS-LOGGING-002`, `OPERATIONS-LOGGING-005`, `OPERATIONS-LOGGING-007`, and `OPERATIONS-LOGGING-011` through `OPERATIONS-LOGGING-014` — Events are typed, minimized, bounded, treated as untrusted, protected through deletion, and separated from authoritative audit evidence.
- When `PRIVACY-DATA` is active, `PRIVACY-DATA-001`, `PRIVACY-DATA-003`, `PRIVACY-DATA-005`, `PRIVACY-DATA-006`, and `PRIVACY-DATA-015` — The processing map, minimization, rendered explanation, choice states, and observed network and storage behavior agree.
- When `SECURITY-APPLICATION` is active, `SECURITY-APPLICATION-002`, `SECURITY-APPLICATION-005`, `SECURITY-APPLICATION-006`, `SECURITY-APPLICATION-010`, and `SECURITY-APPLICATION-015` — Authorization, untrusted input, uploaded content, deployment configuration, and integrated verification evidence cover the page's application behavior.
- When `PROFILE-AGENTIC-SYSTEM` is active, its evidence covers model limits, user control, prompt injection, data paths, tools, repeated outcomes, refusals, escalation, and final-state verification.
- When `PLAYBOOK-GSC` is active, record the exact property, workflow, capability and authority boundary, source and data dates, filters, affected URL cohort, Google-observed evidence, direct corroboration, approvals for mutations, residual uncertainty, and a passing integration-bundle validation result.
- When a provider playbook is active, include its manifest, zero-gap surface classification, selected capability IDs and authority classes, exact skill route or gap, dated official-source review, workflow and evaluation results, released configuration, browser and callback boundaries, privacy-safe telemetry, failure behavior, recovery, and exit evidence.
- `AGENT-VERIFICATION-002` and `AGENT-VERIFICATION-005` — The final page was inspected in its intended medium and the handoff records checks, results, exceptions, and limitations.
- When a conditional standard is active, include its rule-level completion evidence before declaring the page complete.
