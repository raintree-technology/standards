---
id: PROFILE-GROWTH-EXPERIMENT
title: Growth experiment profile
description: Routes growth experiments to evidence, measurement, trust, and safe-change requirements.
type: profile
status: stable
governance_status: active
owners: [growth, product, analytics]
last_reviewed: 2026-08-10
applies_to: [growth-experiment]
tags: [profile, growth, experiment]
depends_on: [GROWTH-EXPERIMENTS, ANALYTICS-MEASUREMENT, FND-TRUST]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Growth experiment profile

Use for acquisition, activation, monetization, engagement, retention, referral, lifecycle, and conversion experiments.

## Required standards

- `GROWTH-EXPERIMENTS` — hypothesis, assignment, decision, and learning
- `ANALYTICS-MEASUREMENT` — trustworthy instrumentation and metric definitions
- `FND-TRUST` — consent, consequences, guardrails, and truthful claims
- `FND-EVIDENCE` — distinguish causal evidence from inference
- `FND-CHANGE` — bounded exposure and recovery

## Conditional standards

- Public acquisition page → `PROFILE-PUBLIC-WEB-PAGE`
- Product behavior change → `PROFILE-PRODUCT-FEATURE`
- Email, push, or lifecycle messaging → applicable consent and communication standards

## Completion evidence

- Pre-exposure hypothesis and analysis plan exist.
- Eligibility, assignment, exposure, and contamination risks are defined.
- Primary and guardrail metrics have exact definitions.
- Instrumentation is validated end to end.
- Stop, ship, iterate, or abandon decision is recorded with limitations.
