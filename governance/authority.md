---
type: Governance
title: Authority and requirement levels
description: Defines requirement strength, precedence, conflict handling, and freshness semantics.
tags: [governance, authority, requirements]
generated: { by: codex/gpt-5, at: "2026-08-12T00:00:00Z" }
---

# Authority and requirement levels

Standards are binding according to their rule-level labels, not according to how strongly the prose happens to be worded.

## Requirement levels

| Level | Meaning | Agent behavior |
|---|---|---|
| `required` | A release or decision gate | Block completion or record an approved exception |
| `recommended` | The default approach | Follow it or state a concrete, context-specific reason for deviating |
| `contextual` | Binding when its stated condition is true | Determine and record whether the condition applies |
| `optional` | A useful enhancement | Consider it without implying it is required |
| `avoid` | Usually harmful | Do not use without a documented justification |
| `prohibited` | Unacceptable | Do not proceed; an ordinary exception cannot authorize it |

The RFC-style words MUST, SHOULD, and MAY may appear in source material, but library documents use the levels above.

## Rule construction

An enforceable rule contains:

- A stable ID
- One independently testable requirement
- The conditions under which it applies
- A reason tied to user, business, security, or operational risk
- Verification evidence an agent can inspect
- Exceptions or escalation instructions where appropriate

Broad advice belongs in explanatory guidance, not in a `required` rule.

## Profile composition

A profile's front-matter `depends_on` list is the authoritative machine-readable set of standards that always apply. Its **Required standards** section must contain the same IDs and explains why they apply.

When more than one profile applies, combine their required standards. Conditional routes are additive: activate every route whose condition is true. The task is complete only when it satisfies the completion evidence from every active profile and standard. If two active rules conflict, use the conflict process below.

A conditional route must name a governed ID. If this library has no applicable standard, the route must state the gap, name the role that must decide, and require the governing external policy or decision to be recorded.

## Conflicts

Use the precedence in `AGENTS.md`. When two repository rules at the same level conflict, prefer the more specific rule and report the conflict to the library owner. Do not quietly choose the easier rule.

## Freshness

The `last_reviewed` date means the content was intentionally assessed on that date; it does not guarantee that a volatile external fact remains current. Revalidate claims involving laws, platform behavior, vendor limits, browser support, search engines, or active threats before relying on them.
