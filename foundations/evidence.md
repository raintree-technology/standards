---
id: FND-EVIDENCE
title: Evidence and claims
type: foundation
status: active
owners: [standards]
last_reviewed: 2026-08-10
review_by: 2027-02-10
applies_to: [all-work]
tags: [evidence, research, verification]
---

# Evidence and claims

Decisions and completion claims must be proportional to the evidence available.

## Rules

### FND-EVIDENCE-001 — Separate fact, inference, and recommendation

**Level:** required  
**Applies when:** Reporting research, analysis, diagnosis, or results.

Distinguish directly observed facts from inferences and recommendations. Do not present an inference as an observed result.

**Verify:** The handoff identifies material assumptions and gives the evidence supporting consequential claims.

### FND-EVIDENCE-002 — Use current primary sources for volatile claims

**Level:** required  
**Applies when:** A claim depends on current law, platform behavior, vendor limits, pricing, security advice, search behavior, or active standards.

Verify the claim against a current primary or authoritative source and record the source near the claim.

**Verify:** A reviewer can open the source and find direct support for the claim.

### FND-EVIDENCE-003 — Do not claim unperformed verification

**Level:** prohibited  
**Applies when:** Describing tests, reviews, deployments, measurements, or user behavior.

Never imply that a check ran or passed when it did not.

**Verify:** The stated evidence corresponds to actual output, an artifact, or a clearly labeled manual observation.

### FND-EVIDENCE-004 — Match confidence to sample quality

**Level:** required  
**Applies when:** Drawing conclusions from analytics, experiments, interviews, incidents, or partial repository inspection.

State meaningful limitations such as sample size, selection bias, missing data, instrumentation gaps, and uninspected scope.

## Guidance

Strong evidence is inspectable and reproducible. A passing test is evidence for the behavior it covers, not proof that the entire system is correct. A metric movement is an observation, not automatically proof of causation.

