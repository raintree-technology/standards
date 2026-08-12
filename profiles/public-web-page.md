---
id: PROFILE-PUBLIC-WEB-PAGE
title: Public web page profile
description: Routes public web work to quality, search, trust, evidence, and verification requirements.
type: profile
status: stable
governance_status: active
owners: [web, design, seo, content]
last_reviewed: 2026-08-12
review_by: 2027-02-12
stale_after: 2027-02-12
applies_to: [public-web-page, landing-page, marketing-site]
tags: [profile, web, seo]
depends_on: [WEB-QUALITY, SEO-FOUNDATIONS, FND-TRUST, FND-EVIDENCE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-12T00:00:00Z" }
---

# Public web page profile

Use for landing pages, marketing pages, public documentation, editorial pages, and indexable application surfaces.

## Required standards

- `WEB-QUALITY` — document, accessibility, performance, resilience, security, and privacy quality
- `SEO-FOUNDATIONS` — crawling, indexing, canonicalization, and content purpose
- `FND-TRUST` — truthful claims and informed choices
- `FND-EVIDENCE` — factual and comparative claims
- `AGENT-VERIFICATION` — rendered inspection and handoff

## Conditional standards

- Experiment or personalization → `GROWTH-EXPERIMENTS` and `ANALYTICS-MEASUREMENT`
- Form or user data collection → applicable privacy, security, and retention policy
- URL or platform migration → `SEO-FOUNDATIONS-007` plus a dedicated migration plan

## Completion evidence

- Page purpose and intended audience are explicit.
- Rendered behavior was inspected on representative viewport sizes.
- Keyboard, focus, labels, hierarchy, contrast, zoom, and error states were checked.
- Indexability, status code, canonical, metadata, internal links, and structured data are intentional.
- Performance and third-party behavior were measured.
- Analytics and consent behavior were validated end to end.
