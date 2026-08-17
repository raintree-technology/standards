---
type: Template
title: Pattern authoring template
description: Starting structure for an OKF-compatible optional Raintree architecture pattern.
tags: [template, patterns, authoring]
generated: { by: codex/gpt-5, at: "2026-08-17T06:25:28Z" }
---

# Pattern authoring template

Use patterns for recurring implementation approaches that help apply existing standards. A pattern is optional guidance, not a new requirement. Put mandatory behavior in a standard with stable rule IDs.

Copy the front matter below and replace every angle-bracketed value. Do not publish placeholder values.

```yaml
---
id: PATTERN-<SUBJECT>
title: <Human-readable pattern title>
description: <One-sentence description of the approach and outcome.>
type: pattern
status: draft
governance_status: draft
release_target: post-v1
owners: [<qualified-owner-roles>]
last_reviewed: <YYYY-MM-DD>
review_by: <YYYY-MM-DD>
stale_after: <same date as review_by>
applies_to: [<task-or-system-type>]
tags: [<domain>, <approach>]
depends_on: [<GOVERNED-STANDARD-ID>]
generated: { by: "human:<author-id>", at: "<ISO-8601 datetime>" }
# Add only after an independent reviewer checks the exact artifact.
# verified: { by: "human:<reviewer-id>", at: "<ISO-8601 datetime>" }
# sources:
#   - id: <stable-source-id>
#     resource: <URL or bundle-relative path>
#     title: <Primary source title>
#     author: <person-or-organization>
---
```

# `<Human-readable pattern title>`

State the recurring problem, the outcome the pattern protects, and how it relates to the standards in `depends_on`. State that the pattern adds no requirement to those standards.

## Applicability

Describe the conditions that make the pattern useful. Identify the evidenced reference domain and any domains that need separate validation.

## Structure

Describe the smallest set of components, boundaries, artifacts, and data flows needed to apply the approach. Identify authoritative inputs and final decision or effect boundaries.

## Responsibilities and evidence

Assign ownership and responsibility at each material boundary. Define the records, versions, provenance, and protected evidence needed to inspect or reproduce behavior.

## Examples

Include representative success, failure, over-restriction, missing-evidence, and out-of-scope cases when they affect correct interpretation.

## Tradeoffs

State operational cost, complexity, latency, availability, privacy, security, and maintenance tradeoffs that could change the adoption decision.

## Do not use when

Name the simpler or safer conditions where the pattern should not be adopted. State what the pattern cannot replace.

## Verification

- Name inspectable tests, traces, artifacts, or review records.
- Exercise expected behavior and legitimate behavior that must remain allowed.
- Test missing, stale, malformed, and conflicting evidence where applicable.
- Confirm claims stay within the tested domain, sample, environment, and fault model.

## Evidence limits

Separate observed results from inference. State important limits in the cited implementation or research evidence, including synthetic data, shared taxonomies, missing independent operation, or untested domains.

## Sources

Prefer primary, durable, version-pinned sources. Explain what each source supports and what it does not establish. Register the source set and review schedule in `source-register.yaml`. Keep the pattern `draft` until a different qualified actor records `verified` against the exact artifact.
