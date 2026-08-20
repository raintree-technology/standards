---
type: decision
status: draft
description: Records the first-use and portfolio-comprehension review for the open-source documentation rebuild.
owners: [marketing, web, open-source]
last_reviewed: 2026-08-20
generated: { by: codex/gpt-5, at: "2026-08-20T21:00:00Z" }
---

# Open-source showcase implementation review

This record covers the implementation review for `MARKETING-PROJECT-SHOWCASE`.
It is not the independent writing and accessibility approval required to move
the standard out of draft.

## Developer task

**Prompt:** Install one project and reach a first useful result without opening
an exhaustive reference.

**Path tested:** DocPull root README → install → initialize `stripe-docs` → sync
→ inspect project diff.

**Observed misunderstanding:** The earlier README placed concepts and command
inventory before the primary install path. It also mixed the open-source context
engine with language that could be read as a hosted intelligence product.

**Correction:** Installation and one project workflow now come first. The
hosted-product boundary is explicit, and advanced commands and contracts link to
named guides.

**Retest:** A reader can identify the install command, expected files, proof
image, and local/network boundary from the first adoption path.

## Portfolio visitor task

**Prompt:** Explain what each open-source project proves and where to inspect
its evidence.

**Observed misunderstandings:** HIG Doctor was described as if all 431 checks
were direct Apple HIG checks. Raintree Standards linked to a stale anchor. The
portfolio had no machine-readable record connecting audience, outcome,
responsibility, evidence, and limitations.

**Correction:** HIG Doctor now distinguishes direct Apple-platform checks from
aligned cross-platform rules. The Standards action points to `#start-with-a-task`.
The typed catalog now projects the five records to `/portfolio/projects.json`,
structured data, portfolio copy, personal-site copy, and discovery files.

**Retest:** Each project has a distinct outcome, audience, source repository,
evidence link, limitation, and direct next action in the canonical record.

## Accessibility approval still required

The automated website viewport and browser-error checks pass. Before approving
the draft standard, an independent reviewer must inspect all five repository
READMEs in GitHub's desktop and narrow layouts and record keyboard navigation,
400% zoom, screen-reader reading order, link wording, code-block alternatives,
and proof-visual alternative text. This check requires published GitHub renders
and was not represented as complete in this implementation review.
