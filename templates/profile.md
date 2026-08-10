---
type: Template
title: Task profile authoring template
description: Starting structure for an OKF-compatible Raintree task profile.
tags: [template, profiles, authoring]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
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
applies_to:
  - <task-name>
tags: [profile, <domain>]
depends_on: []
generated: { by: "human:<author-id>", at: "<ISO-8601 datetime>" }
# verified: { by: "human:<reviewer-id>", at: "<ISO-8601 datetime>" }
---
```

# `<Task profile title>`

Use this profile when...

## Required standards

- `STANDARD-ID` — why it applies

## Conditional standards

- Condition → `STANDARD-ID`

## Completion evidence

- Evidence the agent must provide before declaring the task complete
