---
id: FND-CHANGE
title: Safe and reversible change
description: Scales rollout, observability, and recovery controls to the risk of a change.
type: foundation
status: stable
governance_status: active
owners: [engineering]
last_reviewed: 2026-08-10
review_by: 2027-02-10
stale_after: 2027-02-10
applies_to: [database-change, product-feature, deployment, growth-experiment]
tags: [reversibility, rollout, reliability]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Safe and reversible change

The risk of a change must determine its rollout, observability, and recovery plan.

## Rules

### FND-CHANGE-001 — Identify the failure boundary

**Level:** required  
**Applies when:** A change can affect production users, data, security, revenue, or external integrations.

Document what can fail, the maximum plausible impact, and how the failure will be detected.

### FND-CHANGE-002 — Define recovery before release

**Level:** required  
**Applies when:** The change is not trivially reversible.

Define rollback, roll-forward, restoration, or containment steps before release. “Revert the commit” is insufficient when data or external side effects may have changed.

### FND-CHANGE-003 — Limit blast radius

**Level:** recommended  
**Applies when:** Partial rollout, feature flags, canaries, dry runs, or bounded batches are feasible.

Use the smallest rollout that can produce useful evidence, then expand deliberately.

### FND-CHANGE-004 — Preserve observability through the transition

**Level:** required  
**Applies when:** A change modifies critical behavior or a key metric.

Ensure operators can distinguish expected transition effects from failures and compare pre-change and post-change behavior.
