---
id: PROFILE-MARKETING-LIFECYCLE
title: Marketing lifecycle profile
description: Routes positioning, acquisition, conversion, onboarding, retention, and lifecycle work to evidence, trust, privacy, analytics, and verification requirements.
type: profile
status: draft
governance_status: draft
owners: [marketing, product, growth, analytics, legal]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [marketing-lifecycle, campaign, conversion-flow]
tags: [profile, marketing, lifecycle]
depends_on: [MARKETING-LIFECYCLE, FND-EVIDENCE, FND-TRUST, PRIVACY-DATA, ANALYTICS-MEASUREMENT, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
---

# Marketing lifecycle profile

Use for positioning, customer research, acquisition content, conversion flows, onboarding, lifecycle messaging, retention, churn work, and related measurement.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `MARKETING-LIFECYCLE` — lifecycle claims, permission, conversion, targeting, value, and learning
- `FND-EVIDENCE` — claim support, uncertainty, attribution limits, and reproducibility
- `FND-TRUST` — informed choice, honest framing, and practical exit
- `PRIVACY-DATA` — collection, profiling, audiences, recipients, retention, and rights
- `ANALYTICS-MEASUREMENT` — event and metric contracts, identity, lineage, and quality
- `AGENT-VERIFICATION` — final journey inspection and handoff

## Conditional standards

- Public acquisition or content page → `PROFILE-PUBLIC-WEB-PAGE`
- Experiment or controlled comparison → `PROFILE-GROWTH-EXPERIMENT`
- Interface or product-flow change → `PROFILE-UI-FEATURE`
- Google Analytics 4 implementation → `PLAYBOOK-GA4`
- Search Console operation → `PLAYBOOK-GSC`
- Resend email delivery, sender, domain, or webhook change → `PLAYBOOK-RESEND`
- Database or audience pipeline change → `DATA-DATABASE` and `DATA-QUALITY`
- Model-generated content, targeting, or agent execution → `PROFILE-AGENTIC-SYSTEM`
- Paid media, outreach, public engagement, sales operations, app-store, media-production, referral, or distribution work → `PROFILE-SPECIALIST-MARKETING`

## Completion evidence

- `MARKETING-LIFECYCLE-001` through `MARKETING-LIFECYCLE-003` — Positioning, research provenance, claim map, evidence, and qualifications are current.
- `MARKETING-LIFECYCLE-004` through `MARKETING-LIFECYCLE-007` — The complete offer, permission, value, exit, and targeting journeys preserve material choice and data boundaries.
- `MARKETING-LIFECYCLE-008` and `ANALYTICS-MEASUREMENT-005` — Metrics, attribution limits, costs, guardrails, and time horizons support the decision.
- `PRIVACY-DATA-002`, `PRIVACY-DATA-006`, and `PRIVACY-DATA-012` — Authority, choice, suppression, vendors, and recipients are approved for the actual audience and jurisdiction.
- `MARKETING-LIFECYCLE-009` — Active material and automation have owners, evidence, review dates, and retirement behavior.
- `AGENT-VERIFICATION-002` and `AGENT-VERIFICATION-005` — The final journey and handoff cover every active channel, state, and unresolved limitation.
- When `PLAYBOOK-RESEND` is active, include its manifest, zero-gap surface classification, selected capability IDs and authority classes, email skill route, dated official sources, workflow and evaluation results, sender and consent boundaries, suppression behavior, delivery-event replay, telemetry, recovery, and exit evidence.
