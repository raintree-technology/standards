---
id: PROFILE-RELIABILITY-INCIDENT
title: Reliability and incident profile
description: Routes service operation and incidents to objectives, evidence, safe change, security, support, recovery, and verification requirements.
type: profile
status: draft
governance_status: draft
owners: [operations, engineering, security, support]
last_reviewed: 2026-08-17
review_by: 2027-02-17
stale_after: 2027-02-17
applies_to: [service-operation, incident, recovery]
tags: [profile, reliability, incident]
depends_on: [OPERATIONS-RELIABILITY, FND-CHANGE, FND-EVIDENCE, SECURITY-APPLICATION, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T08:25:04Z" }
---

# Reliability and incident profile

Use for production service operation, readiness exercises, material incidents, recovery, and post-incident corrective work.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `OPERATIONS-RELIABILITY` — objectives, signals, response, recovery, support, learning, and vendors
- `FND-CHANGE` — authority, containment, stop conditions, and safe recovery
- `FND-EVIDENCE` — factual timelines, uncertainty, claims, and provenance
- `SECURITY-APPLICATION` — security controls, detection, vulnerability, and incident response
- `AGENT-VERIFICATION` — final-state verification and handoff

## Conditional standards

- Personal-data exposure, loss, corruption, or rights impact → `PRIVACY-DATA`
- Database corruption, restoration, or correction → `PROFILE-DATABASE-CHANGE`
- API compatibility or dependency failure → `PROFILE-SERVICE-API`
- User-facing status, workaround, or error content → `CONTENT-ERRORS` and `PROFILE-FUNCTIONAL-WRITING`
- Model-driven diagnosis, remediation, or communication → `PROFILE-AGENTIC-SYSTEM`
- Server-side TypeScript logging changes or incident evidence from a Pino-supported runtime → `OPERATIONS-LOGGING`
- External provider involvement → `OPERATIONS-RELIABILITY-009` plus the governing vendor contract and contact process

## Completion evidence

- `OPERATIONS-RELIABILITY-001` through `OPERATIONS-RELIABILITY-004` — Objectives, signals, alerts, and runbooks are current and exercised.
- `OPERATIONS-RELIABILITY-005` — Command, severity, roles, decisions, evidence, and communication are recorded.
- `FND-CHANGE-003`, `FND-CHANGE-005`, and `FND-CHANGE-007` — Containment, stop conditions, authority, and promotion decisions are explicit.
- `OPERATIONS-RELIABILITY-006` and `FND-CHANGE-008` — Recovery meets measured objectives and the final state is reconciled.
- `OPERATIONS-RELIABILITY-007` — The factual review produces owned corrective work and a later effectiveness check.
- `OPERATIONS-LOGGING-002` through `OPERATIONS-LOGGING-014` when active — Collected Pino events preserve safe structure, context, errors, lifecycle evidence, pipeline health, protected storage, client trust boundaries, and supportable audit claims.
- `OPERATIONS-RELIABILITY-008` and `CONTENT-ERRORS-001` when active — Affected users and support receive accurate impact, next actions, and resolution.
- `AGENT-VERIFICATION-005` — The handoff records impact, timeline, actions, checks, remaining risk, owners, and follow-up dates.
