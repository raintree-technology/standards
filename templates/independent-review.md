---
type: Template
title: Independent review template
description: Evidence record for review by a qualified person who did not author the change.
tags: [template, review, approval, evidence]
generated: { by: codex/gpt-5, at: "2026-08-17T17:22:48Z" }
---

# Independent review template

Use this record when `ENGINEERING-QUALITY-005`, `AGENT-VERIFICATION-007`, or another rule requires independent or qualified review. The author must not fill in the review decision on the reviewer's behalf.

## Review scope

| Field | Value |
|---|---|
| Artifact and exact revision | `<files and immutable revision>` |
| Governing rules or policy | `<stable IDs or policy references>` |
| Author | `<identity>` |
| Reviewer and qualified role | `<identity and role>` |
| Independence from authorship | `<basis>` |
| Evidence inspected | `<tests, sources, records, and environments>` |
| Review date | `<date>` |

## Findings

| Finding | Risk | Required change or exception | Resolution evidence | Status |
|---|---|---|---|---|
| `<finding>` | `<effect>` | `<action>` | `<reference>` | `<open | resolved | accepted by authorized exception>` |

## Decision

- Decision: `<approved | approved for stated scope | changes required | blocked>`
- Approval scope: `<exact artifact, use, environment, and period>`
- Residual risk and unresolved conditions: `<details>`
- Follow-up owner and date: `<owner and due date>`
- Reviewer attestation: `<reviewer confirms the decision applies to the exact revision above>`

