---
id: PRODUCT-DELIVERY
title: Product delivery
description: Requirements for evidence-led discovery, clear requirements, controlled launch, onboarding, and outcome review.
type: standard
status: draft
governance_status: draft
owners: [product, design, engineering, analytics]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [product-feature, product-launch]
tags: [product, discovery, requirements, launch]
depends_on: [FND-EVIDENCE, FND-TRUST, FND-CHANGE, ANALYTICS-MEASUREMENT]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: uk-service-standard
    resource: https://www.gov.uk/service-manual/service-standard
    title: Service Standard
    author: organization:uk-government
  - id: uk-understand-users
    resource: https://www.gov.uk/service-manual/service-standard/point-1-understand-user-needs
    title: Understand users and their needs
    author: organization:uk-government
  - id: uk-define-success
    resource: https://www.gov.uk/service-manual/service-standard/point-10-define-success-publish-performance-data
    title: Define what success looks like and publish performance data
    author: organization:uk-government
---

# Product delivery

Product work must solve an evidenced user and business problem, state the intended behavior and limits, launch within controlled boundaries, and measure whether the released outcome worked without transferring hidden costs or harm.

## Rules

### PRODUCT-DELIVERY-001 — Ground the problem in evidence

**Level:** required  
**Applies when:** Proposing a new product capability or material behavior change.

Identify the affected users, their context and unmet need, current behavior, business objective, evidence, uncertainty, and why intervention is warranted.

**Why:** Feature requests and stakeholder preferences can be mistaken for verified user problems.

**Verify:**

- Trace the problem statement to research, observed behavior, support evidence, or measured outcomes.
- Distinguish observation, inference, and proposed solution.

**Exceptions:** A bounded discovery prototype may begin with a hypothesis when it is not presented as validated demand.

### PRODUCT-DELIVERY-002 — Define the outcome and non-goals

**Level:** required  
**Applies when:** Work is prioritized or accepted for implementation.

State the intended user and business outcome, measurable success and guardrails, non-goals, constraints, dependencies, and conditions that would stop or change the work.

**Why:** Output-based scope can ship while failing the underlying need or causing unmeasured harm.

**Verify:**

- Confirm acceptance and measurement evidence can distinguish success, failure, and harmful tradeoffs.
- Check that non-goals prevent implied commitments.

**Exceptions:** None for committed product work.

### PRODUCT-DELIVERY-003 — Specify complete behavior and states

**Level:** required  
**Applies when:** A feature changes user-visible or externally observable behavior.

Define normal, empty, loading, partial, error, offline, denied, interrupted, repeated, cancelled, completed, and recovery states that can materially occur, including permissions and data effects.

**Why:** Teams often design the happy path while users experience ambiguous or unsafe edge states.

**Verify:**

- Walk the requirement against representative state transitions and active profiles.
- Confirm each material state has ownership, content, instrumentation, and acceptance evidence.

**Exceptions:** Inapplicable states may be omitted when the reason is recorded.

### PRODUCT-DELIVERY-004 — Prioritize by value, risk, and cost

**Level:** required  
**Applies when:** Choosing between competing product work or scope.

Record the decision using expected user value, strategic fit, evidence strength, delivery and operating cost, opportunity cost, dependencies, and material risk rather than a score alone.

**Why:** A single ranking number hides assumptions and can reward confident estimates over important but uncertain work.

**Verify:**

- Inspect the underlying evidence and assumptions for the selected and displaced work.
- Confirm legal, safety, accessibility, privacy, security, and reliability obligations are not traded away as optional value.

**Exceptions:** Urgent obligations and incident remediation may bypass ordinary ranking with the reason recorded.

### PRODUCT-DELIVERY-005 — Validate the riskiest assumption early

**Level:** required  
**Applies when:** A material assumption about value, usability, feasibility, viability, or safety remains unresolved.

Choose the smallest valid research, prototype, technical exercise, or controlled exposure that can change the decision before committing broader cost or impact.

**Why:** Polishing low-risk details does not reduce the uncertainty most likely to invalidate the product decision.

**Verify:**

- Connect the validation method and sample to the stated assumption and decision threshold.
- Record contradictory and null evidence as well as supportive results.

**Exceptions:** A mandatory change may proceed without value validation but still requires usability, feasibility, and risk evidence.

### PRODUCT-DELIVERY-006 — Launch with explicit readiness and recovery

**Level:** required  
**Applies when:** Releasing behavior to users or dependent systems.

Confirm functional, content, accessibility, privacy, security, analytics, support, operational, communication, rollout, and recovery readiness for the final artifact.

**Why:** A technically working feature can fail because its surrounding service and operating conditions are unprepared.

**Verify:**

- Complete the active profile evidence and record approval against the exact release.
- Exercise rollback or containment and confirm support can identify and route failures.

**Exceptions:** Emergency releases use the approved emergency process and record deferred readiness work with owners and deadlines.

### PRODUCT-DELIVERY-007 — Design onboarding around achieved value

**Level:** required  
**Applies when:** Users must learn, configure, migrate, or grant access before receiving value.

Minimize required setup, explain requested commitment in context, preserve skip or return paths where practical, and measure successful value rather than completion of instructional steps alone.

**Why:** Onboarding can optimize checklist completion while delaying value or coercing unnecessary data and permissions.

**Verify:**

- Observe representative new and returning users reaching the defined outcome.
- Inspect abandonment, denial, error, resume, and changed-context paths.

**Exceptions:** Required safety, legal, or security steps may not be skippable but must explain why they are required.

### PRODUCT-DELIVERY-008 — Review outcomes and close temporary work

**Level:** required  
**Applies when:** A launched change reaches its defined review point.

Compare outcomes and guardrails with the predeclared baseline, document limitations and segments, decide to keep, change, expand, or remove the behavior, and close temporary flags, compatibility, and support conditions.

**Why:** Features become permanent without proving value or removing rollout complexity.

**Verify:**

- Inspect the outcome review, decision, owners, and cleanup evidence.
- Confirm measurement and support data cover the released population and relevant time horizon.

**Exceptions:** None; the review may conclude that more evidence is needed with a new bounded deadline.

## Guidance

Discovery and delivery are continuous risk reduction, not separate ceremonies. Use qualitative evidence to understand needs and mechanisms and quantitative evidence to estimate prevalence and outcomes. Do not convert roadmap confidence into factual certainty.

## Examples

### New onboarding checklist

Non-compliant: Ship a seven-step checklist because competitors have one and measure checklist completion.

Compliant: Identify where new users fail to reach first value, test the riskiest explanation, remove avoidable setup, measure achieved value and guardrails, and review whether the checklist itself remains necessary.

## Sources

- UK Government, [Service Standard](https://www.gov.uk/service-manual/service-standard). Reviewed August 13, 2026.
- UK Government, [Understand users and their needs](https://www.gov.uk/service-manual/service-standard/point-1-understand-user-needs). Reviewed August 13, 2026.
- UK Government, [Define what success looks like and publish performance data](https://www.gov.uk/service-manual/service-standard/point-10-define-success-publish-performance-data). Reviewed August 13, 2026.
