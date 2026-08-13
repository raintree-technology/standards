---
type: Template
title: Task profile authoring template
description: Starting structure for an OKF-compatible Raintree task profile.
tags: [template, profiles, authoring]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
---

# Task profile authoring template

Copy the front matter below into a new Markdown document and replace every angle-bracketed value. Do not publish placeholder values.

```yaml
---
id: <PROFILE-TASK>
title: <Task profile title>
description: <One-sentence summary of the work this profile routes.>
type: profile
status: draft
governance_status: draft
owners:
  - <team-or-role>
last_reviewed: <YYYY-MM-DD>
review_by: <YYYY-MM-DD>
stale_after: <same date as review_by>
applies_to:
  - <task-name>
tags: [profile, <domain>]
depends_on:
  - <REQUIRED-STANDARD-ID>
generated: { by: "human:<author-id>", at: "<ISO-8601 datetime>" }
# Add only after an independent reviewer checks the exact artifact. Required for stable status.
# verified: { by: "human:<reviewer-id>", at: "<ISO-8601 datetime>" }
---
```

# `<Task profile title>`

Use this profile when...

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. Keep this section synchronized with it.

- `STANDARD-ID` — why it applies

## Conditional standards

- Condition → `STANDARD-ID`
- Condition with no governed standard → state the gap, escalation owner, and required decision record

## Completion evidence

- `STANDARD-RULE-ID` — Artifact, check output, or review record the agent must provide before declaring the task complete
