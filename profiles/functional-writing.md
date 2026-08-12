---
id: PROFILE-FUNCTIONAL-WRITING
title: Functional writing profile
description: Routes functional writing to clarity, evidence, trust, and final-artifact review requirements.
type: profile
status: stable
governance_status: active
owners: [content, standards]
last_reviewed: 2026-08-12
review_by: 2027-02-12
stale_after: 2027-02-12
applies_to: [functional-writing]
tags: [profile, writing, content]
depends_on: [WRITING-FUNCTIONAL, FND-EVIDENCE, FND-TRUST, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-12T00:00:00Z" }
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
- Public documentation or indexable page → `PROFILE-PUBLIC-WEB-PAGE`
- Functional writing that contains a marketing or conversion claim → `FND-EVIDENCE` and `FND-TRUST`; no marketing-specific standard exists, so escalate unresolved claim or tone questions to the content or product owner
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
