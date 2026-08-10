---
id: GROWTH-EXPERIMENTS
title: Growth experiments
description: Requires growth experiments to produce trustworthy learning and durable user and business value.
type: standard
status: stable
governance_status: active
owners: [growth, product, analytics]
last_reviewed: 2026-08-10
review_by: 2027-02-10
stale_after: 2027-02-10
applies_to: [growth-experiment]
tags: [growth, experiments, conversion, retention]
depends_on: [FND-EVIDENCE, FND-TRUST, ANALYTICS-MEASUREMENT]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Growth experiments

Growth work must create durable customer and business value, not merely move a local metric.

## Rules

### GROWTH-EXPERIMENTS-001 — Write the hypothesis before exposure

**Level:** required  
**Applies when:** Comparing a treatment against a baseline or changing a growth mechanism.

Record the user problem, proposed mechanism, target population, expected direction, primary metric, guardrail metrics, and decision rule before viewing treatment outcomes.

### GROWTH-EXPERIMENTS-002 — Define assignment and contamination risks

**Level:** required  
**Applies when:** Running a controlled experiment.

Specify unit of randomization, eligibility, exposure, persistence, concurrent experiments, and ways treatment can leak between groups.

### GROWTH-EXPERIMENTS-003 — Use one declared primary decision metric

**Level:** required  
**Applies when:** An experiment determines a ship decision.

Choose the primary metric in advance. Treat additional cuts and metrics as supporting or exploratory unless the analysis plan states otherwise.

### GROWTH-EXPERIMENTS-004 — Protect guardrails and user trust

**Level:** required  
**Applies when:** The treatment can affect cost, comprehension, accessibility, cancellations, refunds, complaints, or long-term retention.

Define acceptable guardrail bounds and do not ship a winner that breaches them without explicit review.

### GROWTH-EXPERIMENTS-005 — Do not stop opportunistically

**Level:** prohibited  
**Applies when:** Repeatedly observing experiment results.

Do not end an experiment merely when a desired significance threshold appears. Use a predeclared horizon or a valid sequential method.

### GROWTH-EXPERIMENTS-006 — Preserve negative results

**Level:** required  
**Applies when:** An experiment concludes.

Record implementation, exposure, result, limitations, decision, and reusable learning. A non-winning result is organizational knowledge, not failed work.
