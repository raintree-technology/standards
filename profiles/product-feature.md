---
id: PROFILE-PRODUCT-FEATURE
title: Product feature profile
description: Routes user-facing feature work to trust, safe-change, evidence, and verification requirements.
type: profile
status: stable
governance_status: active
owners: [product, design, engineering]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [product-feature]
tags: [profile, product]
depends_on: [PRODUCT-DELIVERY, ENGINEERING-QUALITY, FND-TRUST, FND-CHANGE, FND-EVIDENCE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T08:21:30Z" }
---

# Product feature profile

Use for new or materially changed user-facing behavior.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `PRODUCT-DELIVERY` — evidenced need, complete requirements, launch readiness, onboarding, and outcome review
- `ENGINEERING-QUALITY` — design, checks, dependencies, review, and released artifact integrity
- `FND-TRUST` — informed, non-coercive user decisions
- `FND-CHANGE` — rollout, observability, and recovery
- `FND-EVIDENCE` — factual claims and validation evidence
- `AGENT-VERIFICATION` — end-to-end inspection and handoff

## Conditional standards

- JavaScript or TypeScript implementation → `ENGINEERING-JS-QUALITY`
- User interface → `PROFILE-UI-FEATURE`
- Browser interface → `WEB-QUALITY`
- Apple-platform interface → `PROFILE-APPLE-INTERFACE`
- Public discovery surface → `SEO-FOUNDATIONS`
- New events or metrics → `ANALYTICS-MEASUREMENT`
- Google Analytics 4 implementation → `PLAYBOOK-GA4`
- Experiment or staged behavior comparison → `GROWTH-EXPERIMENTS`
- Database or query change → `DATA-DATABASE`
- Dataset, model, pipeline, lineage, or quality change → `DATA-QUALITY`
- User-facing failure → `CONTENT-ERRORS`
- Documentation, interface text, messages, or summaries → `PROFILE-FUNCTIONAL-WRITING`
- New or changed public terms, privacy or cookie notice, assent, recurring offer, cancellation term, acceptable-use rule, age boundary, or legal commitment → `PROFILE-LEGAL-DOCUMENT`
- Model-generated behavior, retrieval, memory, tool use, delegation, or autonomous action → `PROFILE-AGENTIC-SYSTEM`
- Collection, inference, retention, deletion, disclosure, transfer, or other processing of personal data → `PRIVACY-DATA`
- Authentication, authorization, tenancy, secrets, untrusted input, file handling, external callbacks, administrative actions, or other security-sensitive behavior → `SECURITY-APPLICATION`
- Service or API change → `PROFILE-SERVICE-API`
- New operational responsibility, reliability target, runbook, vendor dependency, or incident path → `OPERATIONS-RELIABILITY`
- Positioning, conversion, onboarding, retention, or lifecycle messaging → `PROFILE-MARKETING-LIFECYCLE`
- App-store listing, referral, incentive, lead asset, or externally distributed campaign → `PROFILE-SPECIALIST-MARKETING`

## Completion evidence

- `FND-TRUST-001`, `FND-TRUST-002`, `FND-TRUST-005`, and `FND-TRUST-007` — The final interaction shows consequences, choices, defaults, total obligations, provenance, and tradeoffs at the decision point.
- `FND-CHANGE-001`, `FND-CHANGE-002`, `FND-CHANGE-005`, `FND-CHANGE-007`, and `FND-CHANGE-008` — The change record defines failure boundaries, recovery, rollout decisions, authorization, final state, and owners.
- `FND-EVIDENCE-001` and `FND-EVIDENCE-003` — The decision record separates observed behavior from inference and makes no unsupported completion claim.
- `AGENT-VERIFICATION-001` — Verification maps the feature's material behavior and risks to checks or documented limitations.
- `AGENT-VERIFICATION-002` — The actual end-to-end user flow and relevant states were inspected in their intended form.
- `AGENT-VERIFICATION-005` — The handoff records outputs, checks, results, active conditional standards, exceptions, and next actions.
- When the feature affects a high-impact governed domain, `AGENT-VERIFICATION-007` — The qualified independent review and decision are recorded against the released artifact.
- When `PRIVACY-DATA` is active, `PRIVACY-DATA-001`, `PRIVACY-DATA-002`, `PRIVACY-DATA-003`, `PRIVACY-DATA-013`, and `PRIVACY-DATA-015` — The processing map, authority, minimization decision, risk review, and released-system evidence cover the actual feature.
- When `SECURITY-APPLICATION` is active, `SECURITY-APPLICATION-001`, `SECURITY-APPLICATION-002`, `SECURITY-APPLICATION-015`, and relevant control rules — The threat model, authorization negatives, version-qualified verification plan, findings, retests, and residual-risk decisions cover the integrated feature.
- When `PROFILE-AGENTIC-SYSTEM` is active, include its architecture decision, task contract, authority boundary, evaluation suite, repeated-trial results, adversarial evidence, operational limits, and qualified review.
- When a conditional standard is active, include its rule-level completion evidence before declaring the feature complete.
