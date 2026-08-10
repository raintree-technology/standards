---
id: PROFILE-PRODUCT-FEATURE
title: Product feature profile
description: Routes user-facing feature work to trust, safe-change, evidence, and verification requirements.
type: profile
status: stable
governance_status: active
owners: [product, design, engineering]
last_reviewed: 2026-08-10
applies_to: [product-feature]
tags: [profile, product]
depends_on: [FND-TRUST, FND-CHANGE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Product feature profile

Use for new or materially changed user-facing behavior.

## Required standards

- `FND-TRUST` — informed, non-coercive user decisions
- `FND-CHANGE` — rollout, observability, and recovery
- `FND-EVIDENCE` — factual claims and validation evidence
- `AGENT-VERIFICATION` — end-to-end inspection and handoff

## Conditional standards

- Browser interface → `WEB-QUALITY`
- Public discovery surface → `SEO-FOUNDATIONS`
- New events or metrics → `ANALYTICS-MEASUREMENT`
- Experiment or staged behavior comparison → `GROWTH-EXPERIMENTS`
- Database or query change → `DATA-DATABASE`
- User-facing failure → `CONTENT-ERRORS`

## Completion evidence

- User problem, target audience, success outcome, and non-goals are explicit.
- Loading, empty, error, permission, offline, and destructive states are handled where relevant.
- Accessibility, privacy, security, analytics, rollout, and support impact were considered.
- The actual end-to-end user flow was inspected.
