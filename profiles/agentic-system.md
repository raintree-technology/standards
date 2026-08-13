---
id: PROFILE-AGENTIC-SYSTEM
title: Agentic system profile
description: Routes model workflows and agents to architecture, evidence, trust, safe-change, and verification requirements.
type: profile
status: draft
governance_status: draft
owners: [ai, product, engineering, security, privacy]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [agentic-system]
tags: [profile, ai, agents]
depends_on: [AI-AGENTS, FND-EVIDENCE, FND-TRUST, FND-CHANGE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-13T19:35:12Z" }
---

# Agentic system profile

Use for model workflows or agents that select steps, invoke tools, use memory or retrieval, delegate work, change external state, or operate across multiple turns.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `AI-AGENTS` — architecture, context, tools, autonomy, evaluation, safety, and operation
- `FND-EVIDENCE` — grounded claims, evaluation validity, uncertainty, and reproducibility
- `FND-TRUST` — informed choice, user control, and honest representation of automated behavior
- `FND-CHANGE` — bounded rollout, stop conditions, recovery, and release evidence
- `AGENT-VERIFICATION` — final-state inspection and reproducible handoff

## Conditional standards

- Personal, confidential, regulated, or proprietary data in prompts, context, traces, evaluation, feedback, or tools → `PRIVACY-DATA`
- Untrusted content, code execution, network access, private data access, external communication, durable side effects, authentication, authorization, or privileged tools → `SECURITY-APPLICATION`
- New events, traces, quality metrics, cost metrics, or dashboards → `ANALYTICS-MEASUREMENT`
- Browser interface or public agent surface → `WEB-QUALITY`
- Database access or mutation → `DATA-DATABASE`
- User-facing failures, refusals, tool errors, or escalation messages → `CONTENT-ERRORS`
- Instructions, explanations, interface text, reports, or handoffs → `PROFILE-FUNCTIONAL-WRITING`
- Experiment comparing models, prompts, tools, or agent behavior on users → `PROFILE-GROWTH-EXPERIMENT`

## Completion evidence

- `AI-AGENTS-001` and `AI-AGENTS-002` — The architecture decision and task contract show why the selected autonomy is needed and what success, failure, limits, and escalation mean.
- `AI-AGENTS-003`, `AI-AGENTS-006`, and `AI-AGENTS-007` — Trust-boundary tests, effective permissions, approvals, and containment evidence limit untrusted influence and worst-case authority.
- `AI-AGENTS-004`, `AI-AGENTS-005`, and `AI-AGENTS-020` — Effective context, tool contracts, retrieved knowledge, and versioned reusable instructions are inspectable and scoped.
- `AI-AGENTS-009`, `AI-AGENTS-010`, and `FND-CHANGE-002` — Environmental outcome checks, stop conditions, repeat safety, recovery, and interruption behavior are exercised.
- `AI-AGENTS-012` through `AI-AGENTS-016` — The exact configuration, representative tasks, held-out design, repeated trials, outcome graders, trace review, and human calibration support the release claim.
- `AI-AGENTS-017` and `SECURITY-APPLICATION-015` when active — Adversarial cases and integrated security verification cover prompt injection, data leakage, tool misuse, and permission boundaries.
- `AI-AGENTS-018` — Traces, alerts, cost and latency limits, safety events, and operator stop controls work for representative runs.
- `AI-AGENTS-019` when parallel or multi-agent — Scope isolation, conflicts, partial failure, synthesis, and measured benefit are recorded.
- `AGENT-VERIFICATION-005` — The handoff identifies the configuration, evaluation suite, released artifact, checks, outcomes, exceptions, and unresolved risks.
- When a conditional standard is active, include its rule-level completion evidence before declaring the system complete.
