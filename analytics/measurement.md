---
id: ANALYTICS-MEASUREMENT
title: Product and growth measurement
description: Defines decision-driven, interpretable, privacy-conscious product and growth instrumentation.
type: standard
status: stable
governance_status: active
owners: [analytics, product]
last_reviewed: 2026-08-10
review_by: 2027-02-10
stale_after: 2027-02-10
applies_to: [product-feature, growth-experiment, public-web-page]
tags: [analytics, events, metrics, privacy]
depends_on: [FND-EVIDENCE, FND-TRUST]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Product and growth measurement

Instrumentation must produce interpretable evidence without collecting data merely because it might be useful later.

## Rules

### ANALYTICS-MEASUREMENT-001 — Start with a decision

**Level:** required  
**Applies when:** Adding an event, property, dashboard, or metric.

Document the decision the measurement supports, its definition, and the action different outcomes would trigger.

### ANALYTICS-MEASUREMENT-002 — Give events stable semantic contracts

**Level:** required  
**Applies when:** Instrumenting behavioral events.

Define trigger, actor, object, timestamp semantics, required properties, ownership, and versioning. Name the observed fact rather than the implementation detail.

### ANALYTICS-MEASUREMENT-003 — Validate end to end

**Level:** required  
**Applies when:** Shipping new or changed instrumentation.

Verify the real user action produces one correctly shaped event, reaches the intended destination, respects consent, and appears in downstream analysis with expected identity and time semantics.

### ANALYTICS-MEASUREMENT-004 — Minimize collected data

**Level:** required  
**Applies when:** Choosing event properties or identity data.

Collect only what is needed for the documented decision. Do not place secrets, free-form user content, credentials, or unnecessary personal data in analytics payloads.

### ANALYTICS-MEASUREMENT-005 — Define metric denominator and eligibility

**Level:** required  
**Applies when:** Reporting a rate, funnel, cohort, or experiment outcome.

State who could qualify, the time window, exclusions, identity unit, and late-arriving-data behavior. A metric name alone is not a definition.
