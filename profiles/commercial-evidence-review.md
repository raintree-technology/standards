---
id: PROFILE-COMMERCIAL-EVIDENCE-REVIEW
title: Commercial evidence review profile
description: Routes project, supplier, facility, and counterparty evidence reviews to scope, provenance, claims, trust, writing, and handoff requirements.
type: profile
status: draft
governance_status: draft
release_target: post-v1
owners: [standards, research, sales]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [commercial-evidence-review, project-evidence-review, supplier-evidence-review, diligence-sample]
tags: [profile, research, evidence, sales]
depends_on: [FND-EVIDENCE, FND-TRUST, WRITING-FUNCTIONAL, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-14T03:10:36Z" }
---

# Commercial evidence review profile

Use this profile for a decision memo or sample that tests public or authorized
claims about a project, supplier, facility, product, or counterparty. The review
must help a named reader make one decision without turning incomplete research
into assurance, certification, or professional advice.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route.
This section explains why each dependency applies and must match that list.

- `FND-EVIDENCE` — claim strength, source freshness, provenance, uncertainty,
  conflicts, and quantitative meaning
- `FND-TRUST` — honest limits, automated authorship, and informed reliance
- `WRITING-FUNCTIONAL` — reader, decision, terminology, structure, tables, and
  final-artifact review
- `AGENT-VERIFICATION` — proportionate checks, final inspection, uncertainty,
  and reproducible handoff

## Conditional standards

- Offer, proposal, sales sample, or buyer-facing collateral →
  `PROFILE-SPECIALIST-MARKETING`, including `MARKETING-LIFECYCLE` and
  `SALES-REVENUE-OPERATIONS`
- Prospect research or directed outreach → `MARKETING-DIRECT-OUTREACH` and
  `PRIVACY-DATA`
- Authorized client records or personal data → `PRIVACY-DATA`; activate
  `SECURITY-APPLICATION` when access, storage, transfer, or deletion creates a
  security boundary
- Legal, regulatory, compliance, reserve, assay, provenance, investment, or
  performance conclusion → no professional-assurance standard exists in this
  library; narrow the review or obtain a qualified reviewer and record the
  governing external policy

## Completion evidence

- `WRITING-FUNCTIONAL-001` and `WRITING-FUNCTIONAL-004` — The opening names the
  intended reader, decision, deadline or decision window, and main conclusion.
- `FND-EVIDENCE-001` — The review separates observed records, interpretation,
  and recommended next questions.
- `FND-EVIDENCE-002` and `FND-EVIDENCE-005` — A dated source register records
  source type, issuer, publication date, location, review date, and material
  limits.
- `FND-EVIDENCE-004` — The scope states exclusions, missing evidence, source
  cutoff, and limits on generalization.
- `FND-EVIDENCE-006` — Material conflicts and stale claims remain visible, with
  the preferred interpretation and reason recorded.
- `FND-EVIDENCE-007` and `WRITING-FUNCTIONAL-012` — Capacity, output, price,
  schedule, ownership, and other quantities include units, time basis, status,
  and uncertainty needed for the decision.
- `FND-TRUST-008` — A model-generated draft identifies automated authorship,
  source limits, verification state, and the responsible human reviewer.
- `WRITING-FUNCTIONAL-002` — Every material conclusion maps to evidence or an
  explicit unknown; announced targets are not presented as achieved results.
- `WRITING-FUNCTIONAL-007` — The memo, claim register, source register, and open
  questions link to one another with descriptive link text.
- `WRITING-FUNCTIONAL-010` and `AGENT-VERIFICATION-002` — The final memo and
  registers are inspected together in their delivery format.
- `AGENT-VERIFICATION-004` and `AGENT-VERIFICATION-005` — The handoff names
  unverified evidence, deferred review, files, checks, and the next decision.

## Decision boundary

The review may describe what the cited record supports. It must not imply that
the reviewer inspected a site, tested material, authenticated private records,
verified legal title, certified compliance, or predicted performance unless
that work occurred under an applicable qualified standard and is identified
precisely.
