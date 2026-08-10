---
id: PROFILE-DATABASE-CHANGE
title: Database change profile
description: Routes database changes to integrity, safety, evidence, and verification requirements.
type: profile
status: stable
governance_status: active
owners: [data, engineering]
last_reviewed: 2026-08-10
applies_to: [database-change]
tags: [profile, database]
depends_on: [DATA-DATABASE, FND-CHANGE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Database change profile

Use for schema migrations, backfills, query changes, indexes, retention jobs, data corrections, and backup or restore changes.

## Required standards

- `DATA-DATABASE` — integrity, compatibility, performance, and recovery
- `FND-CHANGE` — blast radius, detection, and recovery
- `FND-EVIDENCE` — support performance and correctness claims
- `AGENT-VERIFICATION` — final verification and handoff

## Conditional standards

- Collection, deletion, retention, or personal data → applicable privacy policy and legal review
- New product behavior → `PROFILE-PRODUCT-FEATURE`
- Analytics warehouse or event model → `ANALYTICS-MEASUREMENT`

## Completion evidence

- Invariants and ownership are explicit.
- Forward and compatibility paths are tested.
- Production-scale lock and resource risks are assessed.
- Recovery is defined for semantic or destructive changes.
- Monitoring and contraction follow-up have owners.
