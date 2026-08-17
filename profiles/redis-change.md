---
id: PROFILE-REDIS-CHANGE
title: Redis change profile
description: Routes Redis design, configuration, client, cache, session, stream, and operational changes to data, security, reliability, and verification requirements.
type: profile
status: draft
governance_status: draft
owners: [data, engineering, operations, security]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [redis-change, redis-operation, cache-change, session-store-change, redis-stream-change]
tags: [profile, redis, cache, database]
depends_on: [DATA-REDIS, FND-CHANGE, FND-EVIDENCE, OPERATIONS-RELIABILITY, SECURITY-APPLICATION, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:27:22Z" }
---

# Redis change profile

Use for Redis workload design, key or data-model changes, client integration, caching, session storage, rate limiting, streams or Pub/Sub, memory and eviction configuration, clustering, persistence, backup, failover, security, upgrades, and production operation.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `DATA-REDIS` — Redis workload contracts, memory, data model, clients, commands, availability, recovery, messaging, and locks
- `FND-CHANGE` — blast radius, rollout, stop conditions, reversal, and post-change verification
- `FND-EVIDENCE` — representative evidence and bounded performance, durability, and correctness claims
- `OPERATIONS-RELIABILITY` — objectives, signals, alerts, runbooks, incidents, and recovery exercises
- `SECURITY-APPLICATION` — network, identity, command authority, data protection, and security verification
- `AGENT-VERIFICATION` — final-state inspection, checks, limitations, and handoff

## Conditional standards

- Redis schema or durable-data migration, re-keying, bulk transformation, or backup and restore change → `PROFILE-DATABASE-CHANGE`
- Application API or service behavior, cache contract, error, timeout, or retry change → `PROFILE-SERVICE-API`
- Personal, confidential, or regulated data in values, keys, telemetry, backups, or streams → `PRIVACY-DATA`
- New secrets, credential delivery, or rotation path → `SECURITY-SECRETS`
- Production incident, failover, restoration, or recovery exercise → `PROFILE-RELIABILITY-INCIDENT`
- JavaScript or TypeScript client or operational tooling → `ENGINEERING-JS-QUALITY`
- Model-driven Redis planning, command generation, mutation, operation, or recovery → `PROFILE-AGENTIC-SYSTEM`

## Completion evidence

- `DATA-REDIS-001` — Every workload has a recorded source of truth, staleness, loss, eviction, unavailable-state, and recovery contract, and shared policy boundaries are compatible.
- `DATA-REDIS-002` and `DATA-REDIS-003` — Effective memory and eviction configuration plus representative key, collection, resident-memory, hot-key, and slot-distribution evidence establish the supported bounds.
- `DATA-REDIS-004` — Concurrent expiry, invalidation, refill, source-failure, and cold-cache tests demonstrate bounded stale data and dependency load.
- `DATA-REDIS-005` and `DATA-REDIS-006` — Client configuration and interruption tests establish bounded connections, deadlines, retries, ambiguous mutations, command work, scripts, and pipelines.
- `DATA-REDIS-007` — Network-denial, effective ACL, command-denial, and credential or certificate rotation evidence covers every application and operator identity.
- `DATA-REDIS-008` and `DATA-REDIS-009` — Failover and isolated restore or reconstruction exercises reconcile acknowledged, persisted, replicated, lost, duplicated, rejected, and recovered state against declared objectives.
- `DATA-REDIS-010` and `DATA-REDIS-011` — Alerts, runbooks, and failure exercises cover slow, unavailable, full, partitioned, flushed, failed-over, restored, cold, and recovering conditions without uncontrolled dependency load.
- `DATA-REDIS-012` when messaging is used — Disconnect, crash, duplication, ordering, pending-work, poison-message, retention, and reconciliation evidence matches the declared delivery contract.
- `DATA-REDIS-013` when locks are used — Expiry, pause, partition, takeover, stale-holder, fencing or alternate enforcement, renewal, and cleanup tests cover the protected resource.
- `FND-CHANGE-008` and `AGENT-VERIFICATION-005` — Post-change evidence binds the effective Redis and client state to checks, results, limitations, owners, and recovery.
