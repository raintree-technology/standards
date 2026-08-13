---
id: PROFILE-DATABASE-CHANGE
title: Database change profile
description: Routes database changes to integrity, safety, evidence, and verification requirements.
type: profile
status: stable
governance_status: active
owners: [data, engineering]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [database-change]
tags: [profile, database]
depends_on: [DATA-DATABASE, FND-CHANGE, FND-EVIDENCE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-13T19:35:12Z" }
---

# Database change profile

Use for schema migrations, backfills, query changes, indexes, retention jobs, data corrections, and backup or restore changes.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `DATA-DATABASE` — integrity, compatibility, performance, and recovery
- `FND-CHANGE` — blast radius, detection, and recovery
- `FND-EVIDENCE` — support performance and correctness claims
- `AGENT-VERIFICATION` — final verification and handoff

## Conditional standards

- Collection, deletion, retention, correction, transfer, or other processing of personal data → `PRIVACY-DATA`
- New product behavior → `PROFILE-PRODUCT-FEATURE`
- Analytics warehouse or event model → `ANALYTICS-MEASUREMENT`
- Model-driven planning, SQL generation, migration execution, recovery, or data correction → `PROFILE-AGENTIC-SYSTEM`

## Completion evidence

- `DATA-DATABASE-001` and `DATA-DATABASE-009` — The schema, migration review, and reconciliation output identify invariants and verify preserved data meaning.
- `DATA-DATABASE-002` — The compatibility matrix and deployment record show that old and new application versions work through expansion and migration.
- `DATA-DATABASE-003` and `DATA-DATABASE-004` — Representative lock, resource, query-plan, and timing evidence is attached to the change record.
- `DATA-DATABASE-005` and `FND-CHANGE-002` — The recovery procedure and exercise record cover durable data and side effects.
- `DATA-DATABASE-008` — Backfill output accounts for eligible, processed, skipped, failed, and remaining records and demonstrates restart behavior.
- `DATA-DATABASE-010` and `FND-CHANGE-005` — Deferred contraction, monitoring, stop conditions, and promotion decisions have named owners.
- `DATA-DATABASE-011` — Concurrency evidence covers conflicts, retries, isolation, and external side effects where shared records can be updated concurrently.
- `DATA-DATABASE-012` and `FND-CHANGE-007` — Effective privileges, change authorization, operator identity, and removal of temporary access are recorded.
- `FND-CHANGE-008` — Post-change evidence confirms intended state, monitoring health, and closure or ownership of temporary conditions.
- `AGENT-VERIFICATION-002` and `AGENT-VERIFICATION-005` — The final database state or closest safe representation was inspected and the handoff records checks, outcomes, and limitations.
- When `PRIVACY-DATA` is active, `PRIVACY-DATA-001`, `PRIVACY-DATA-008`, `PRIVACY-DATA-009`, `PRIVACY-DATA-014`, and `PRIVACY-DATA-015` — The processing map, retention or deletion exercise, correction behavior, non-production controls, and released data flow cover every material copy.
- When `PROFILE-AGENTIC-SYSTEM` is active, the agent has bounded database authority, exact approvals, dry-run or preview evidence, repeat-safe operations, environmental checks, stop conditions, and human review before destructive or production effects.
