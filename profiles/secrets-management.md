---
id: PROFILE-SECRETS-MANAGEMENT
title: Secrets and Infisical change profile
description: Routes Infisical adoption, access, delivery, precedence, rotation, exposure, control-plane operation, recovery, and migration to governed requirements.
type: profile
status: draft
governance_status: draft
owners: [security, platform, engineering, operations]
last_reviewed: 2026-08-16
review_by: 2026-11-16
stale_after: 2026-11-16
applies_to: [secret-management-change, infisical-adoption, credential-migration, secret-rotation, secret-exposure]
tags: [profile, security, secrets, infisical, credentials]
depends_on: [SECURITY-SECRETS, SECURITY-APPLICATION, ENGINEERING-QUALITY, OPERATIONS-RELIABILITY, FND-CHANGE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T06:04:34Z" }
---

# Secrets and Infisical change profile

Use for creating or changing secrets, adopting or configuring Infisical, changing human or workload access, integrating local development or CI/CD, delivering or synchronizing secrets, rotating or restoring credentials, investigating exposure, operating the control plane, or migrating from another store.

Combine this profile with every other profile affected by the consumer. For example, a database credential rotation also activates `PROFILE-DATABASE-CHANGE` when it changes database roles, availability, or recovery behavior.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `SECURITY-SECRETS` — Infisical authority, hierarchy, identities, delivery, rotation, detection, availability, control-plane operation, resolution, sync, and migration
- `SECURITY-APPLICATION` — trust boundaries, least privilege, safe evidence, integrated verification, and incident response
- `ENGINEERING-QUALITY` — bounded dependencies, checks, review, provenance, and final-state release evidence
- `OPERATIONS-RELIABILITY` — dependency objectives, observability, runbooks, response, recovery, and provider exit planning
- `FND-CHANGE` — blast radius, stop conditions, rollout, rollback, cleanup, and post-change checks
- `AGENT-VERIFICATION` — final-state inspection and reproducible handoff

## Conditional standards

- Secret grants access to a database, migration, backup, or data job → `PROFILE-DATABASE-CHANGE`
- Secret is used by an API, service, job, webhook, SDK, library, or command interface → `PROFILE-SERVICE-API`
- Secret is used by a model, agent, tool, browser automation, or autonomous workflow → `PROFILE-AGENTIC-SYSTEM`
- Secret is used by a public website build or runtime → `PROFILE-PUBLIC-WEB-PAGE`
- Secret affects a user-facing feature or application behavior → `PROFILE-PRODUCT-FEATURE`
- Secret contains, unlocks, encrypts, or transfers personal or regulated data → `PRIVACY-DATA`
- Work is part of an outage, exposure, compromise, restore, or emergency rotation → `PROFILE-RELIABILITY-INCIDENT`

## Completion evidence

- `SECURITY-SECRETS-001` and `SECURITY-SECRETS-002` — The protected inventory maps issuers, Infisical hierarchy, owners, permission sets, consumers, templates, and allowed replicas without values or private topology in public artifacts; no deprecated service token or shadow authority remains.
- `SECURITY-SECRETS-003` — The effective union of roles, groups, additional privileges, approvals, and administrator access demonstrates named, temporary, independently approved access and exercised provisioning, expiry, urgent removal, and break-glass behavior.
- `SECURITY-SECRETS-004` — Machine identity evidence maps distinct permission sets and permitted replicas, proves exact workload-authentication bindings and token limits, and includes negative repository, environment, claim, namespace, network, expiry, and use-limit checks.
- `SECURITY-SECRETS-005` — Delivery and cache evidence covers the selected CLI, SDK, API, Agent, Kubernetes, or sync path; startup, refresh, expiry, denial, staleness, restart, revocation delay, cleanup, and final artifacts create no unintended copy or silent fallback.
- `SECURITY-SECRETS-006` — Dynamic, dual-phase, single-phase, emergency, and restore evidence as applicable covers authoritative issuer state, consumer refresh, monitoring, new-value acceptance, old-value rejection, and safe recovery.
- `SECURITY-SECRETS-007` and `SECURITY-APPLICATION-016` — Staged, history, CI, connected-source, and artifact detection; protected triage; narrow suppressions; issuer response; audit review; and integrated security verification cover the final scope.
- `SECURITY-SECRETS-008` and `OPERATIONS-RELIABILITY-005` — Outage, latency, denial, token expiry, stale cache, audit-stream loss, alert failure, break-glass, restore, revocation, and recovery exercises match the declared service and retention behavior.
- `SECURITY-SECRETS-009` and `FND-CHANGE-008` — Migration reconciliation proves consumers use Infisical, deprecated authentication, legacy values, fallback paths, and temporary dual delivery are removed or governed by expiring exceptions, and the post-change state is verified.
- `SECURITY-SECRETS-010` — Organization and instance evidence covers policy ownership, SSO, MFA, sessions, provisioning, templates, approvals, administrators, audit retention, and capability-aware substitutes; self-hosted evidence also covers TLS, network policy, key separation, encrypted backups, restore, availability, capacity, monitoring, upgrades, and offboarding.
- `SECURITY-SECRETS-011` — Personal override, reference, import, and sync evidence covers environment restrictions, permission expansion, API behavior, precedence, missing and duplicate values, conflict and deletion settings, destination drift, reconciliation, removal, and recovery.
- `ENGINEERING-QUALITY-005` and `AGENT-VERIFICATION-005` — Independent review and handoff bind checks, limitations, recovery, and ownership to the exact final artifact and configuration.
