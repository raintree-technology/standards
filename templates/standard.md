---
type: Template
title: Standard authoring template
description: Starting structure for an OKF-compatible governed Raintree standard.
tags: [template, standards, authoring]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
---

# Standard authoring template

Copy the front matter below into a new Markdown document and replace every angle-bracketed value. Do not publish placeholder values.

```yaml
---
id: <DOMAIN-SUBJECT>
title: <Human-readable title>
description: <One-sentence summary used by OKF indexes, search, and previews.>
type: standard
status: draft
governance_status: draft
owners:
  - <team-or-role>
last_reviewed: <YYYY-MM-DD>
review_by: <YYYY-MM-DD>
stale_after: <same date as review_by>
applies_to:
  - <task-profile>
tags:
  - <domain>
depends_on: []
generated: { by: "human:<author-id>", at: "<ISO-8601 datetime>" }
# Add only after an independent reviewer checks the exact artifact. Required for stable status.
# verified: { by: "human:<reviewer-id>", at: "<ISO-8601 datetime>" }
# sources:
#   - id: <stable-source-id>
#     resource: <URL or bundle-relative path>
#     title: <Primary source title>
---
```

# `<Human-readable title>`

State the outcome this standard protects and the scope it covers.

## Rules

### `<DOMAIN-SUBJECT-001>` — `<Imperative rule title>`

**Level:** required  
**Applies when:** State the testable condition.

State one requirement precisely.

**Why:** Connect the rule to a concrete risk or outcome.

**Verify:**

- Name inspectable evidence, a test, a query, or an artifact.

**Exceptions:** State allowed exceptions and required approval, or “None.”

## Guidance

Explain implementation choices, tradeoffs, and common failure modes without turning every preference into a requirement.

## Examples

Show a compliant and non-compliant application when interpretation is not obvious.

## Sources

Prefer primary, durable sources. Record access or review dates for volatile material.

Add the document's source-set owner, reviewed version or publication date, volatility, and next review date to `source-register.yaml`. Keep the document `draft` until a different qualified actor records `verified`.
