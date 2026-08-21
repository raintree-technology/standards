---
id: PROFILE-SPECIALIST-MARKETING
title: Specialist marketing profile
description: Routes paid media, outreach, public engagement, sales operations, app-store, media, and distribution work to the applicable governed standards.
type: profile
status: draft
governance_status: draft
release_target: post-v1
owners: [marketing, growth, sales, privacy, legal]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [specialist-marketing, campaign-operations, external-distribution]
tags: [profile, marketing, channels]
depends_on: [MARKETING-LIFECYCLE, FND-EVIDENCE, FND-TRUST, PRIVACY-DATA, ANALYTICS-MEASUREMENT, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-13T23:45:00Z" }
---

# Specialist marketing profile

Use for marketing and revenue work that extends beyond the core lifecycle route. Activate every conditional standard that matches the actual channel, platform, asset, data path, or sales operation.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `MARKETING-LIFECYCLE` — positioning, claims, value exchange, permission, targeting, and lifecycle controls
- `FND-EVIDENCE` — substantiation, uncertainty, comparison, and decision records
- `FND-TRUST` — informed choice, honest framing, and practical exit
- `PRIVACY-DATA` — collection, sourcing, recipients, profiling, retention, and rights
- `ANALYTICS-MEASUREMENT` — metric contracts, attribution limits, identity, and quality
- `AGENT-VERIFICATION` — final channel inspection and evidence-backed handoff

## Conditional standards

- Paid placements, sponsored creative, or advertising accounts → `MARKETING-PAID-MEDIA`
- Cold email, calls, text, messaging, prospecting, or purchased contact data → `MARKETING-DIRECT-OUTREACH`
- Public relations, social publishing, communities, creators, influencers, or partnerships → `MARKETING-PUBLIC-ENGAGEMENT`
- Sales enablement, competitive intelligence, CRM, lead routing, forecasting, or revenue operations → `SALES-REVENUE-OPERATIONS`
- Apple App Store or Google Play discovery and listing work → `DISCOVERY-APP-STORES`
- Image, audio, video, ad creative, synthetic media, or licensed asset work → `MEDIA-PRODUCTION-RIGHTS`
- Directories, lead assets, referrals, incentives, contests, or syndication → `MARKETING-DISTRIBUTION`
- Experiment or controlled comparison → `PROFILE-GROWTH-EXPERIMENT`
- Public destination or search surface → `PROFILE-PUBLIC-WEB-PAGE`
- Interface or product-flow change → `PROFILE-UI-FEATURE`
- Model-generated material or agent execution → `PROFILE-AGENTIC-SYSTEM`

## Completion evidence

- `MARKETING-PAID-MEDIA-001`, `MARKETING-DIRECT-OUTREACH-001`, `MARKETING-DISTRIBUTION-001`, and `MARKETING-PUBLIC-ENGAGEMENT-001`, as activated — The task contract lists every active channel, jurisdiction, platform, partner, asset, identity, data flow, claim, incentive, and authority boundary.
- `MARKETING-PAID-MEDIA-007`, `MARKETING-DIRECT-OUTREACH-005`, `MARKETING-DISTRIBUTION-007`, `MARKETING-PUBLIC-ENGAGEMENT-007`, `DISCOVERY-APP-STORES-007`, and `MEDIA-PRODUCTION-RIGHTS-007`, as activated — Each activated specialist standard has its stated launch, measurement, complaint, pause, correction, and retirement evidence.
- `MARKETING-PAID-MEDIA-001` and `DISCOVERY-APP-STORES-001` — Current platform terms and jurisdiction-specific requirements are pinned in the work record and reviewed by a qualified owner when applicable.
- `MARKETING-LIFECYCLE-008`, `ANALYTICS-MEASUREMENT-005`, `MARKETING-PAID-MEDIA-006`, and `MARKETING-DISTRIBUTION-007`, as activated — Costs and outcomes reconcile with authoritative systems; attribution, overlap, modeled data, fraud, and uncertainty are explicit.
- `AGENT-VERIFICATION-002` and `MARKETING-PUBLIC-ENGAGEMENT-002` — A final journey inspection covers rendered disclosure, choice, accessibility, destination truth, suppression, offboarding, and stale-copy removal.
- `AGENT-VERIFICATION-005` — Unresolved limitations and exceptions identify owner, scope, risk, compensating control, expiry, and follow-up date.
