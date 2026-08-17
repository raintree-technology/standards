---
id: PROFILE-CODE-REMOVAL
title: Code removal profile
description: Routes unused-code and dependency cleanup through Knip, Ruff, deptry, contextual Vulture, safe change, engineering checks, and final verification.
type: profile
status: draft
governance_status: draft
release_target: post-v1
owners: [engineering]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [code-removal, dead-code-removal, dependency-cleanup]
tags: [profile, engineering, cleanup]
depends_on: [ENGINEERING-CODE-REMOVAL, FND-CHANGE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T08:39:18Z" }
---

# Code removal profile

Use for deleting unused files, exports, symbols, imports, dependencies, scripts, commands, registrations, or workspace packages. Combine it with every profile affected by the removed behavior.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `ENGINEERING-CODE-REMOVAL` — reachable-surface definition, layered Knip, Ruff, deptry, and contextual Vulture analysis, canaries, bounded deletion, and exception control
- `FND-CHANGE` — failure boundary, recovery, final-state inspection, and change evidence
- `AGENT-VERIFICATION` — risk-matched checks, actual-flow inspection, and reproducible handoff

## Conditional standards

- TypeScript or JavaScript cleanup in a Raintree-owned repository → `ENGINEERING-JS-QUALITY`
- Removal changes a public API, SDK, library contract, command interface, webhook, or service route → `PROFILE-SERVICE-API`
- Removal changes user-visible behavior → `PROFILE-PRODUCT-FEATURE`
- Removal changes a database, schema, query, migration, backup, restore, or data job → `PROFILE-DATABASE-CHANGE`
- Removal changes authentication, authorization, secrets, untrusted-input handling, dependency exposure, or another security control → `SECURITY-APPLICATION`
- Removal changes personal-data collection, use, retention, deletion, disclosure, or transfer → `PRIVACY-DATA`
- Removal changes runtime reliability, monitoring, recovery, support, or incident behavior → `OPERATIONS-RELIABILITY`

## Completion evidence

- `ENGINEERING-CODE-REMOVAL-001` and `ENGINEERING-CODE-REMOVAL-002` — The analysis record names the reachable surface, configuration, implicit consumers, candidate traces, and classification decisions.
- When TypeScript or JavaScript is in scope, `ENGINEERING-CODE-REMOVAL-003` — Knip ordinary and applicable production results, configuration, commands, remaining findings, and suppressions are recorded.
- When Python bindings are in scope, `ENGINEERING-CODE-REMOVAL-004` — Ruff version, resolved rules, commands, diagnostics, unsafe-fix decisions, re-exports, and analysis limits are recorded.
- When Python dependencies are in scope, `ENGINEERING-CODE-REMOVAL-008` — deptry's version, environment, source and dependency scope, group classification, findings, exceptions, and post-change environment checks are recorded.
- When broader Python definition discovery is applicable, `ENGINEERING-CODE-REMOVAL-009` — Vulture's version, scope, confidence threshold, checked whitelist, findings, manual classifications, and analysis limits are recorded.
- `ENGINEERING-CODE-REMOVAL-005` — Approved fix scope, the final diff, dependency metadata, and risk-matched analyzer, type, import, packaging, build, test, and startup checks show the final graph and supported behavior.
- `ENGINEERING-CODE-REMOVAL-006` — Every retained finding or suppression has narrow scope, rationale, ownership, and a review trigger.
- When recurring enforcement is retained, `ENGINEERING-CODE-REMOVAL-007` — The blocking scope, baseline, known-finding test, owner, and tightening milestone are recorded without calling accepted backlog clean.
- `ENGINEERING-CODE-REMOVAL-010` — Applicable positive and negative canaries prove that the configured analyzers detect known dead items and retain supported dynamic, public, generated, packaged, and side-effect-driven behavior.
- `FND-CHANGE-008` and `AGENT-VERIFICATION-005` — The handoff records the actual final state, check results, unrun checks, limitations, active conditional standards, recovery path, and owners.
- When a conditional standard is active, include its rule-level completion evidence before declaring the cleanup complete.
