---
id: AGENT-VERIFICATION
title: Agent verification and handoff
description: Requires proportionate verification and reproducible, honest handoffs for agent work.
type: standard
status: stable
governance_status: active
owners: [standards]
last_reviewed: 2026-08-10
review_by: 2027-02-10
stale_after: 2027-02-10
applies_to: [all-agent-work]
tags: [agents, testing, handoff]
depends_on: [FND-EVIDENCE]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Agent verification and handoff

Agents must leave users with an accurate account of what changed, what was verified, and what remains uncertain.

## Rules

### AGENT-VERIFICATION-001 — Verify in proportion to risk

**Level:** required  
**Applies when:** An agent changes an artifact or system.

Run the narrowest checks that directly exercise the changed behavior, plus broader checks warranted by likely blast radius. High-risk work requires failure-path and recovery verification, not only a happy path.

### AGENT-VERIFICATION-002 — Inspect the final artifact

**Level:** required  
**Applies when:** Generating or transforming code, documents, data, images, interfaces, or configuration.

Review the resulting artifact in its intended form. Successful generation is not evidence of correctness or acceptable presentation.

### AGENT-VERIFICATION-003 — Preserve unrelated user work

**Level:** required  
**Applies when:** Working in a mutable repository or shared system.

Inspect current state, distinguish pre-existing changes, and avoid overwriting or reverting unrelated work.

### AGENT-VERIFICATION-004 — Report residual uncertainty

**Level:** required  
**Applies when:** Any relevant check could not run or evidence is incomplete.

State what was not verified, why, and the practical risk. Do not bury limitations beneath a general claim of completion.

### AGENT-VERIFICATION-005 — Make the handoff reproducible

**Level:** required  
**Applies when:** Completing implementation or analysis.

Identify material outputs, verification performed, outcomes, exceptions, and any next action the user must take. Cite applicable failed or deferred standards by ID.
