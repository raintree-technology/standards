---
type: Playbook
title: Contributing standards
description: Acceptance, writing, and review requirements for maintaining the standards library.
tags: [governance, contribution, review]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Contributing standards

Only update this repository when explicitly assigned a standards-maintenance task.

## Acceptance criteria

A new or materially changed standard must:

- Address a recurring decision or material risk.
- Separate mandatory rules from explanatory guidance.
- Use stable, unique rule IDs.
- Define applicability and verification evidence.
- Cite primary sources for external factual claims where practical.
- Avoid vendor-specific prescriptions unless the vendor is intentionally part of the policy.
- State important tradeoffs and exceptions.
- Include at least one realistic example for rules that are easy to misinterpret.
- Add or update relevant task profiles.
- Update `catalog.yaml`.
- Preserve unknown OKF front-matter fields when reading and writing documents.
- Record `generated` after a meaningful content change; record `verified` only after an independent source or resource check.

## Writing style

- Write for a capable agent or practitioner encountering the situation mid-task.
- State the outcome first, followed by rationale and implementation detail.
- Prefer measurable thresholds only when evidence supports them.
- Do not convert personal preference into policy.
- Do not use “best practice” as its own justification.
- Describe risks without pretending all projects have the same scale or threat model.

## Review

Review changes for technical correctness, operational feasibility, unintended incentives, and conflicts with existing rules. High-impact security, legal, privacy, financial, or regulatory standards require a qualified human owner.
