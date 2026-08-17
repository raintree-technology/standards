---
id: PROFILE-FUNCTIONAL-WRITING
title: Functional writing profile
description: Routes functional writing to clarity, evidence, trust, and final-artifact review requirements.
type: profile
status: stable
governance_status: active
owners: [content, standards]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [functional-writing]
tags: [profile, writing, content]
depends_on: [WRITING-FUNCTIONAL, FND-EVIDENCE, FND-TRUST, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-14T03:10:36Z" }
---

# Functional writing profile

Use for documentation, explanations, answers, summaries, commit messages, pull request descriptions, interface text, reports, and emails. Do not use for fiction or marketing copy unless the task explicitly adopts this profile.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `WRITING-FUNCTIONAL` — reader, language, structure, procedures, summaries, and review
- `FND-EVIDENCE` — factual claims, uncertainty, and completion statements
- `FND-TRUST` — truthful framing and informed reader choices
- `AGENT-VERIFICATION` — final-artifact inspection and honest handoff

## Conditional standards

- User-facing failure message → `CONTENT-ERRORS`
- Interface label, guidance, state, confirmation, or localization unit → `CONTENT-INTERFACE`
- Public documentation or indexable page → `PROFILE-PUBLIC-WEB-PAGE`
- Personal data in documentation, reports, messages, examples, screenshots, or review evidence → `PRIVACY-DATA`
- Repository instructions, prompts, tool descriptions, skills, playbooks, or durable knowledge for agents → `AI-AGENTS`
- Functional writing that contains a marketing or conversion claim → `PROFILE-MARKETING-LIFECYCLE`
- Sales collateral, outreach, public relations, sponsored content, app-store copy, or partner material → `PROFILE-SPECIALIST-MARKETING`
- Project, supplier, facility, counterparty, or diligence evidence review → `PROFILE-COMMERCIAL-EVIDENCE-REVIEW`
- Legal, regulatory, safety, or medical content → no domain standard exists in this library; escalate to a qualified reviewer and record the governing external policy before publication

## Completion evidence

- `WRITING-FUNCTIONAL-001` — The self-review note or artifact opening identifies the intended reader and primary purpose.
- `WRITING-FUNCTIONAL-002` — Citations, source links, or the review note connect material claims to evidence and record uncertainty.
- `WRITING-FUNCTIONAL-003` — The final artifact or terminology-check output shows consistent, exact names, labels, and values.
- `WRITING-FUNCTIONAL-004` — The final artifact places the outcome before supporting detail.
- `WRITING-FUNCTIONAL-006` — A procedure walkthrough or review note confirms that steps work in order and state non-obvious results.
- `WRITING-FUNCTIONAL-007` — The rendered artifact shows that headings, lists, warnings, and links match their meaning.
- `WRITING-FUNCTIONAL-008` — The rendered artifact or accessibility check confirms exact interface labels, distinguished literals, and text alternatives for meaningful images.
- `WRITING-FUNCTIONAL-009` — For change records, the commit, pull request, or change-log view shows a compliant summary and body structure.
- `WRITING-FUNCTIONAL-010` and `AGENT-VERIFICATION-002` — The handoff names the medium inspected and records the final-artifact review result.
- When localized, `WRITING-FUNCTIONAL-011` — Translation units and representative rendered locales preserve complete meaning, formatting, layout, and accessible names.
- When quantitative or tabular, `WRITING-FUNCTIONAL-012` and `FND-EVIDENCE-007` — Units, populations, periods, denominators, uncertainty, headers, and text equivalents make the result interpretable.
- When consequential or repeatedly misunderstood, `WRITING-FUNCTIONAL-013` — The comprehension record shows representative readers can find, understand, and act on the material information.
- When `CONTENT-ERRORS` is active, `CONTENT-ERRORS-001`, `CONTENT-ERRORS-002`, `CONTENT-ERRORS-004`, `CONTENT-ERRORS-006`, and `CONTENT-ERRORS-008` — The rendered failure states show actionable content, appropriate placement, safe specificity, accessible behavior, and truthful protocol semantics.
- When `PRIVACY-DATA` is active, `PRIVACY-DATA-003`, `PRIVACY-DATA-005`, `PRIVACY-DATA-012`, and `PRIVACY-DATA-014` — The artifact includes only needed personal data, explains relevant processing, controls recipients, and keeps personal data out of unsafe evidence and development paths.
- When `AI-AGENTS` is active, `WRITING-FUNCTIONAL-014`, `AI-AGENTS-002`, and `AI-AGENTS-020` — The instruction artifact defines scope, outcome, required input, procedure, postconditions, forbidden actions, escalation, verification, ownership, and versioned reuse.
