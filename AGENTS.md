---
type: Agent Instructions
title: raintree.standards repository instructions
description: Binding instructions for agents reading or maintaining the raintree.standards library.
tags: [agents, governance, read-only]
generated: { by: codex/gpt-5, at: "2026-08-17T17:16:31Z" }
---

# raintree.standards repository instructions

This repository is the authoritative, read-only standards library for agents working on Raintree projects.

## Default access

- Read, search, cite, and apply these standards.
- Do not create, edit, move, rename, or delete files in this repository unless the user explicitly assigns a standards-maintenance task.
- A request to implement work in another repository is not permission to update this repository.
- If guidance is missing, report the gap. Do not invent a rule and attribute it to this library.
- If a project conflicts with a required standard, surface the conflict and follow the exception process. Do not silently weaken the standard.

## How to use the library

1. Identify the task profile in `profiles/` that most closely matches the work.
2. Load every standard listed as required by that profile.
3. Apply relevant cross-cutting standards from `foundations/` even when the profile does not mention them explicitly.
4. Treat requirement levels according to `governance/authority.md`.
5. Verify each applicable rule using its stated evidence before claiming completion.
6. In the handoff, cite failed or intentionally deferred rules by stable ID.

## Precedence

Follow this order when guidance conflicts:

1. Applicable law and regulation
2. Explicit user instruction for the current task
3. Organization policy
4. Required standards in this repository
5. Task profiles
6. Project conventions
7. Agent preference

An instruction at a higher level may authorize a scoped exception, but it does not erase or rewrite the underlying standard.

## Maintenance tasks

When explicitly asked to maintain this repository:

- Follow `governance/contributing.md`.
- Use `playbooks/standards-audit.md` and `templates/audit-report.md` for a repository-wide conformance review.
- Start new standards from `templates/standard.md`.
- Use stable IDs and valid YAML front matter.
- Prefer testable rules over general advice.
- Preserve existing IDs; never reuse a retired ID.
- Update `catalog.yaml` when adding, moving, or retiring a standard or profile.

## Completion and escalation

- Inspect the final artifact in its intended form and run every check listed in `CONTRIBUTING.md`.
- Report changed files, check results, limitations, and unresolved rules by stable ID.
- Do not record `verified` provenance or qualified approval for your own work.
- Stop and ask the accountable owner when a change needs a new policy choice, external authority, qualified review, production access, or an approval that the task does not provide.

The standards owners maintain these instructions. Review them after a recurring agent
failure, a change to repository governance, or a change to the standards-audit process.
