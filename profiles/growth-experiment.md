---
id: PROFILE-GROWTH-EXPERIMENT
title: Growth experiment profile
description: Routes growth experiments to evidence, measurement, trust, and safe-change requirements.
type: profile
status: stable
governance_status: active
owners: [growth, product, analytics]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [growth-experiment]
tags: [profile, growth, experiment]
depends_on: [GROWTH-EXPERIMENTS, ANALYTICS-MEASUREMENT, FND-TRUST, FND-EVIDENCE, FND-CHANGE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
---

# Growth experiment profile

Use for acquisition, activation, monetization, engagement, retention, referral, lifecycle, and conversion experiments.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `GROWTH-EXPERIMENTS` — hypothesis, assignment, decision, and learning
- `ANALYTICS-MEASUREMENT` — trustworthy instrumentation and metric definitions
- `FND-TRUST` — consent, consequences, guardrails, and truthful claims
- `FND-EVIDENCE` — distinguish causal evidence from inference
- `FND-CHANGE` — bounded exposure and recovery
- `AGENT-VERIFICATION` — final-artifact inspection and reproducible handoff

## Conditional standards

- Public acquisition page → `PROFILE-PUBLIC-WEB-PAGE`
- Positioning, acquisition, conversion, onboarding, retention, or lifecycle treatment → `PROFILE-MARKETING-LIFECYCLE`
- Product behavior change → `PROFILE-PRODUCT-FEATURE`
- User interface treatment → `PROFILE-UI-FEATURE`
- Email, push, or lifecycle messaging → `PROFILE-FUNCTIONAL-WRITING` and `PRIVACY-DATA`; record the governing channel and communication policy because this library does not define channel-specific permission rules
- Personal data, tracking, profiling, personalization, identity stitching, or audience transfer → `PRIVACY-DATA`
- Google Analytics 4 implementation → `PLAYBOOK-GA4`
- Model, prompt, retrieval, tool, memory, or agent behavior is the treatment or makes treatment decisions → `PROFILE-AGENTIC-SYSTEM`

## Completion evidence

- `GROWTH-EXPERIMENTS-001` and `GROWTH-EXPERIMENTS-007` — A timestamped pre-exposure hypothesis, analysis plan, decision threshold, and sensitivity plan exist.
- `GROWTH-EXPERIMENTS-002` and `GROWTH-EXPERIMENTS-008` — Eligibility, assignment, exposure, contamination, balance, and integrity checks are recorded.
- `GROWTH-EXPERIMENTS-003`, `GROWTH-EXPERIMENTS-004`, and `ANALYTICS-MEASUREMENT-005` — The primary metric and guardrails have exact definitions and decision rules.
- `ANALYTICS-MEASUREMENT-003` — A known treatment and control action were traced through the full measurement path.
- `GROWTH-EXPERIMENTS-005` — The actual stop condition matches the predeclared horizon or sequential method, or an early safety stop is identified.
- `GROWTH-EXPERIMENTS-006` and `FND-EVIDENCE-004` — The durable result records effect, uncertainty, limitations, and the stop, ship, iterate, or abandon decision.
- `GROWTH-EXPERIMENTS-010` and `FND-EVIDENCE-007` — The result reports effect size, uncertainty, baseline, practical threshold, and relevant costs in interpretable units.
- `GROWTH-EXPERIMENTS-011` — Policy review confirms every arm preserves applicable legal, safety, accessibility, privacy, security, and contractual baselines.
- `GROWTH-EXPERIMENTS-012` — Variant QA and bounded-ramp evidence cover treatment delivery, assignment, events, guardrails, and stop controls.
- When `PRIVACY-DATA` is active, `PRIVACY-DATA-002`, `PRIVACY-DATA-003`, `PRIVACY-DATA-004`, `PRIVACY-DATA-006`, and `PRIVACY-DATA-013` — The experiment records authority, minimization, purpose boundaries, applicable choice, and privacy-risk review before exposure.
- When `PROFILE-AGENTIC-SYSTEM` is active, the experiment separates stochastic trial variance from assigned treatment effects and records the exact agent configuration, evaluation baseline, authority, safety limits, and outcome checks.
- `AGENT-VERIFICATION-005` — The handoff links the experiment plan, implementation, analysis, decision, checks, and unresolved risks.
