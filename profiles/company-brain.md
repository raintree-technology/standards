---
id: PROFILE-COMPANY-BRAIN
title: Company brain profile
description: Routes organizational knowledge systems to source authority, evidence, trust, change, data, security, privacy, engineering, and verification requirements.
type: profile
status: draft
governance_status: draft
release_target: post-v1
owners: [knowledge, product, data, security, privacy, ai, engineering]
last_reviewed: 2026-08-16
review_by: 2027-02-16
stale_after: 2027-02-16
applies_to: [company-brain, enterprise-search, knowledge-base, retrieval-system, expertise-discovery]
tags: [profile, knowledge, retrieval, audit]
depends_on: [KNOWLEDGE-SYSTEMS, FND-EVIDENCE, FND-TRUST, FND-CHANGE, DATA-QUALITY, SECURITY-APPLICATION, PRIVACY-DATA, ENGINEERING-QUALITY, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T08:37:00Z" }
---

# Company brain profile

Use for systems that collect, index, connect, retrieve, summarize, recommend, or answer from organizational information for people, automations, or agents. Apply the profile to every participating source, connector, derived store, retrieval path, output surface, and administrative path in the declared boundary.

This draft requires independent review of the final artifact and qualified AI, security, privacy, data, and engineering review before it can become stable.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `KNOWLEDGE-SYSTEMS` — source authority, provenance, authorization parity, lifecycle, retrieval, answers, evaluation, operation, and workforce safeguards
- `FND-EVIDENCE` — attributable claims, current sources, uncertainty, conflicts, and valid evaluation
- `FND-TRUST` — honest automation, limits, user control, and protection from unsupported reliance
- `FND-CHANGE` — failure boundaries, rollout, recovery, stop conditions, and final-state validation
- `DATA-QUALITY` — meaning, ownership, lineage, reconciliation, correction, and deletion across derived data
- `SECURITY-APPLICATION` — trust boundaries, authorization, untrusted input, logs, abuse controls, and integrated verification
- `PRIVACY-DATA` — purpose, authority, minimization, rights, retention, inference, model paths, and release evidence
- `ENGINEERING-QUALITY` — bounded architecture, testing, dependencies, provenance, observability, review, and release state
- `AGENT-VERIFICATION` — proportionate checks, final inspection, uncertainty, independent review, and reproducible handoff

## Conditional standards

- JavaScript or TypeScript implementation → `ENGINEERING-JS-QUALITY`
- Models, agents, generated summaries, embeddings, durable memory, model grading, or model-selected retrieval or actions → `AI-AGENTS`
- Service, API, library, SDK, webhook, or event contract → `PROFILE-SERVICE-API`
- Database schema, query, index, migration, backup, restore, retention, or data mutation → `PROFILE-DATABASE-CHANGE`
- New usage, quality, cost, safety, or operational measurement → `ANALYTICS-MEASUREMENT`
- User interface → `PROFILE-UI-FEATURE`; public browser surface → `PROFILE-PUBLIC-WEB-PAGE`
- Production operation, reliability exercise, dependency failure, or incident response → `PROFILE-RELIABILITY-INCIDENT`
- User-facing answers, citations, explanations, audit reports, failures, refusals, or escalation messages → `PROFILE-FUNCTIONAL-WRITING`; user-facing failures also activate `CONTENT-ERRORS`
- Secret creation, access, delivery, rotation, exposure, or migration in a Raintree system → `PROFILE-SECRETS-MANAGEMENT`; for other adopters, a qualified security owner must select and record the governing organizational secrets policy in addition to `SECURITY-APPLICATION`
- A participating source has a governing domain standard or external policy → apply that route in addition to this profile; participation in the company brain does not replace source-system governance
- Workforce or consequential people decisions → no employment-decision standard exists in this library; obtain the governing human-resources, privacy, legal, and organizational policy and record the qualified decision

## Completion evidence

- `KNOWLEDGE-SYSTEMS-001` and `SECURITY-APPLICATION-001` — A current boundary and threat model identify sources, consumers, flows, owners, classifications, trust boundaries, exclusions, and governing routes.
- `KNOWLEDGE-SYSTEMS-002` and `KNOWLEDGE-SYSTEMS-003` — Authority, precedence, provenance, transformation lineage, source versions, and protected references are inspectable from representative outputs.
- `KNOWLEDGE-SYSTEMS-004` — Integrated negative-access tests cover every retrieval and output path plus permission change and revocation.
- `KNOWLEDGE-SYSTEMS-005` through `KNOWLEDGE-SYSTEMS-007` — Connector contracts, reconciliation, freshness, retries, correction, restriction, deletion, restoration, and removal are exercised.
- `KNOWLEDGE-SYSTEMS-008` through `KNOWLEDGE-SYSTEMS-010` — Representative exact, semantic, current, scoped, conflicting, denied, and unanswerable questions support the retrieval and grounding claims.
- `KNOWLEDGE-SYSTEMS-011` — The held-out integrated evaluation records source and permission state, configuration, graders, trials, segments, failures, latency, cost, and release identity.
- `KNOWLEDGE-SYSTEMS-012` and `SECURITY-APPLICATION-013` — Protected audit records trace representative use, denial, change, export, and failure without unnecessary sensitive content.
- `KNOWLEDGE-SYSTEMS-013` — Correction, ownership transfer, and retirement exercises close every affected source, derived store, access grant, consumer, and operational control.
- `KNOWLEDGE-SYSTEMS-014` when active — Purpose, evidence limits, correction and contest paths, prohibited uses, and qualified human review protect people affected by expertise or workforce inference.
- `AGENT-VERIFICATION-005` — The handoff identifies the audited or released artifact, active routes, evidence, checks, results, exceptions, untested scope, and unresolved risks.
- Every active conditional route contributes its own rule-level completion evidence before the system is described as complete or conforming.
