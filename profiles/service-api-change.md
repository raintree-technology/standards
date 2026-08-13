---
id: PROFILE-SERVICE-API
title: Service and API change profile
description: Routes service and API changes to contract, engineering, security, reliability, change, and verification requirements.
type: profile
status: draft
governance_status: draft
owners: [engineering, platform, security, operations]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [service-change, api-change]
tags: [profile, service, api]
depends_on: [API-CONTRACTS, ENGINEERING-QUALITY, OPERATIONS-RELIABILITY, SECURITY-APPLICATION, FND-CHANGE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
---

# Service and API change profile

Use for new or materially changed APIs, services, jobs, webhooks, integrations, and service-to-service contracts.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `API-CONTRACTS` — interface meaning, errors, bounds, retries, compatibility, and authorization
- `ENGINEERING-QUALITY` — architecture, checks, dependencies, review, provenance, and release readiness
- `OPERATIONS-RELIABILITY` — objectives, observability, response, recovery, and vendor dependencies
- `SECURITY-APPLICATION` — threat boundaries and integrated control verification
- `FND-CHANGE` — blast radius, rollout, stop conditions, and recovery
- `AGENT-VERIFICATION` — final-state inspection and reproducible handoff

## Conditional standards

- Personal, confidential, or regulated data → `PRIVACY-DATA`
- Database, schema, query, or backfill change → `PROFILE-DATABASE-CHANGE`
- New analytics events or service metrics → `ANALYTICS-MEASUREMENT`
- Model-driven requests, tools, or autonomous operation → `PROFILE-AGENTIC-SYSTEM`
- Public browser surface → `PROFILE-PUBLIC-WEB-PAGE`
- User or agent-facing failures → `CONTENT-ERRORS`

## Completion evidence

- `API-CONTRACTS-001`, `API-CONTRACTS-002`, and `API-CONTRACTS-003` — The versioned contract and exercised responses cover operations, semantics, errors, limits, and side effects.
- `API-CONTRACTS-004`, `API-CONTRACTS-005`, and `API-CONTRACTS-007` — Bound, continuation, interruption, retry, deduplication, and throttling evidence covers expected load and failure.
- `API-CONTRACTS-006` — Supported client versions pass and removal decisions use measured adoption.
- `API-CONTRACTS-008` and `SECURITY-APPLICATION-002` — Positive and negative authorization checks cover tenant, object, field, bulk, and nested boundaries.
- `ENGINEERING-QUALITY-005` and `ENGINEERING-QUALITY-008` — Independent review and final-artifact approval bind to the released version.
- `OPERATIONS-RELIABILITY-001` through `OPERATIONS-RELIABILITY-006` — Objectives, signals, alerts, runbooks, response, and recovery are exercised.
- `FND-CHANGE-008` and `AGENT-VERIFICATION-005` — The post-change state and handoff record checks, results, limitations, owners, and recovery.
