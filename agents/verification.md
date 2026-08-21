---
id: AGENT-VERIFICATION
title: Agent verification and handoff
description: Requires proportionate verification and reproducible, honest handoffs for agent work.
type: standard
status: stable
governance_status: active
owners: [standards]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [all-agent-work]
tags: [agents, testing, handoff]
depends_on: [FND-EVIDENCE]
generated: { by: codex/gpt-5, at: "2026-08-13T19:35:12Z" }
sources:
  - id: google-sre-testing
    resource: https://sre.google/sre-book/testing-reliability/
    title: Testing for Reliability
    author: organization:google
  - id: nist-ssdf
    resource: https://csrc.nist.gov/pubs/sp/800/218/final
    title: Secure Software Development Framework Version 1.1
    author: organization:nist
  - id: anthropic-claude-code
    resource: https://code.claude.com/docs/en/best-practices
    title: Best practices for Claude Code
    author: organization:anthropic
  - id: openai-agents-md
    resource: https://learn.chatgpt.com/docs/agent-configuration/agents-md
    title: Custom instructions with AGENTS.md
    author: organization:openai
  - id: scale-swe-atlas
    resource: https://scale.com/blog/swe-atlas
    title: SWE Atlas - Evaluating AI Coding Agents in Real Codebases
    author: organization:scale-ai
  - id: cognition-testing
    resource: https://docs.devin.ai/work-with-devin/testing-and-recordings
    title: Testing and Video Recordings
    author: organization:cognition
  - id: cognition-knowledge
    resource: https://docs.devin.ai/product-guides/knowledge
    title: Knowledge
    author: organization:cognition
---

# Agent verification and handoff

Agents must leave users with an accurate, reproducible account of what changed, what was inspected, what passed or failed, and what remains uncertain.

## Rules

### AGENT-VERIFICATION-001 — Verify in proportion to risk

**Level:** required  
**Applies when:** An agent changes an artifact or system.

Run the narrowest checks that directly exercise the changed behavior, plus broader checks warranted by likely blast radius. Include failure-path and recovery verification when those paths carry material risk.

**Why:** A generic check can pass without exercising the behavior changed, while excessive unrelated checking wastes time and obscures relevant failures.

**Verify:**

- Map each material requirement and risk to a check or documented limitation.
- Confirm the chosen environment, inputs, and failure cases represent the change being claimed.

**Exceptions:** A check can be deferred only when the limitation, risk, and next verification owner are reported.

### AGENT-VERIFICATION-002 — Inspect the final artifact

**Level:** required  
**Applies when:** Generating or transforming code, documents, data, images, interfaces, or configuration.

Review the resulting artifact in its intended form. Successful generation, compilation, or serialization is not evidence of correct content or acceptable presentation.

**Why:** Source-level checks do not reveal every rendering, integration, ordering, accessibility, or contextual defect.

**Verify:**

- Open or render the deliverable in the closest available form to its real use.
- Inspect the user-visible outcome, key states, and surrounding context affected by the change.

**Exceptions:** If the intended medium is unavailable, inspect the closest representation and report the difference.

### AGENT-VERIFICATION-003 — Preserve unrelated user work

**Level:** required  
**Applies when:** Working in a mutable repository or shared system.

Inspect current state before editing, distinguish pre-existing changes, and avoid overwriting, reverting, formatting, or including unrelated work.

**Why:** A technically correct change is still harmful if it destroys or silently absorbs another person's work.

**Verify:**

- Compare the final change set with the initial state and requested scope.
- Identify any overlapping pre-existing edits and how they were preserved.

**Exceptions:** None without explicit authorization from the owner of the affected work.

### AGENT-VERIFICATION-004 — Report residual uncertainty

**Level:** required  
**Applies when:** Any relevant check could not run, failed, used a substitute environment, or left evidence incomplete.

State what was not verified, why, and the practical risk. Separate pre-existing failures from failures introduced by the change.

**Why:** A general completion claim can cause the user to assume missing coverage or known failures do not exist.

**Verify:**

- Confirm every omitted, failed, or partial check appears in the handoff.
- Check that uncertainty is stated next to the affected claim or output.

**Exceptions:** None.

### AGENT-VERIFICATION-005 — Make the handoff reproducible

**Level:** required  
**Applies when:** Completing implementation or analysis.

Identify material outputs, verification performed, outcomes, exceptions, and any next action the user must take. Cite applicable failed or deferred standards by stable ID.

**Why:** A future maintainer must be able to locate the work and understand its evidence without reconstructing the entire session.

**Verify:**

- Follow file, artifact, source, and check references from the handoff.
- Confirm claimed outcomes match the recorded output and final change set.

**Exceptions:** None.

### AGENT-VERIFICATION-006 — Remove temporary work

**Level:** required  
**Applies when:** The task creates diagnostics, generated previews, temporary data, debug code, or scratch files that are not deliverables.

Remove temporary artifacts and restore temporary configuration before handoff. Preserve any artifact needed to reproduce a reported result or explicitly identify it as a deliverable.

**Why:** Leftover diagnostics and configuration can expose data, alter behavior, or confuse later work.

**Verify:**

- Inspect the final change set and relevant runtime state for task-created temporary material.
- Confirm retained artifacts are named in the handoff and have a clear purpose.

**Exceptions:** Keep evidence required for audit or reproduction in its approved location.

### AGENT-VERIFICATION-007 — Require independent review for high-impact work

**Level:** required  
**Applies when:** A change materially affects security, privacy, legal or regulatory obligations, financial behavior, access control, destructive data handling, or another domain that requires an accountable specialist.

Obtain review from the qualified owner required by the governing policy. The implementing agent can prepare evidence and recommendations but cannot treat self-review as independent approval.

**Why:** High-impact work needs domain authority and a second perspective on assumptions, abuse paths, and consequences that the implementer may miss.

**Verify:**

- Identify the governing policy, required reviewer role, reviewed scope, decision, and unresolved conditions.
- Confirm the reviewed artifact matches the version released or handed off.

**Exceptions:** Emergency containment can precede review when the incident policy authorizes it; retrospective review and durable remediation remain required.

### AGENT-VERIFICATION-008 — Ground the plan in the actual system

**Level:** required  
**Applies when:** An agent will diagnose, design, or change an unfamiliar or materially complex system.

Inspect governing instructions, current state, relevant architecture, dependencies, existing patterns, and runtime behavior before choosing an implementation. Separate exploration and planning from mutation when a wrong assumption could expand scope or harm existing work.

**Why:** Agents that begin from a plausible prior can implement the wrong model of the system cleanly and quickly.

**Verify:**

- Trace material plan assumptions to inspected files, configuration, documentation, runtime output, or an identified owner decision.
- Confirm the plan names affected boundaries, likely files or systems, preserved behavior, risks, and verification before edits begin.
- Record important differences between expected and observed system behavior.

**Exceptions:** A trivial, local edit whose behavior and scope are directly visible can combine exploration and implementation.

### AGENT-VERIFICATION-009 — Give the agent an executable completion signal

**Level:** required  
**Applies when:** Delegating implementation or transformation work to an agent.

Provide or derive a check the agent can run against the intended outcome, such as a focused test, build, query, rendered inspection, state comparison, schema validation, or reference artifact. Define what pass, fail, and partial evidence mean before the agent uses the check as its stop condition.

**Why:** Without an inspectable success signal, an agent stops when the work appears done and shifts every missed defect to later human review.

**Verify:**

- Confirm the check exercises the requested postcondition rather than only syntax or an intermediate step.
- Run a known failing or pre-change case where feasible to prove the check can detect absence of the result.
- Inspect the final evidence instead of accepting the agent's summary of it.

**Exceptions:** Judgment-only work can use a defined review rubric and qualified final-artifact inspection when no executable oracle exists.

### AGENT-VERIFICATION-010 — Review autonomous trajectories and outcomes

**Level:** required  
**Applies when:** An agent performs multiple steps, uses tools, delegates, retries, or changes external state without synchronous review of every step.

Review the final authoritative state and enough of the trajectory to detect unauthorized scope, unsafe shortcuts, hidden failures, repeated dead ends, policy violations, and accidental reliance on unavailable or private information. Treat the model and harness together as the evaluated system.

**Why:** A correct final artifact can be produced through an unsafe process, while a plausible transcript can end in incorrect external state.

**Verify:**

- Reconcile intended and actual files, records, messages, recipients, tool calls, permissions, and side effects.
- Inspect high-risk decisions, approvals, retries, errors, and deviations from the plan or instructions.
- Confirm the exact model, harness, tools, environment, and instruction set associated with the evidence.

**Exceptions:** A single-step read-only task with deterministic evidence can omit trajectory review when its input and output boundary is verified.

### AGENT-VERIFICATION-011 — Turn recurring corrections into scoped guidance

**Level:** required  
**Applies when:** The same project rule, setup step, tool procedure, failure, or reviewer correction is likely to recur.

Update the repository's governed agent instructions, skill, playbook, or knowledge system at the narrowest useful scope. State the trigger, expected outcome, required inputs, forbidden actions, verification, source, and owner. Resolve conflicts and duplicates rather than adding another overlapping instruction.

**Why:** Chat-only corrections disappear, while unscoped memory and duplicated instructions create inconsistent behavior across later tasks.

**Verify:**

- Start a representative new run and confirm the guidance is discovered in the intended scope and absent outside it.
- Trace the addition or change to a reviewed failure, successful workflow, project rule, or owner decision.
- Confirm stale or superseded guidance is retired through its governed process.

**Exceptions:** Do not persist one-time user data, secrets, temporary workarounds, or preferences that have no durable owner.

## Guidance

Start verification from the acceptance criteria, not from whichever checks are easiest to run. A syntax validator is appropriate evidence for syntax; it does not prove user behavior. Prefer deterministic, repeatable checks, then add manual inspection where meaning or presentation requires judgment.

Record exact commands or procedures only when they help another person reproduce the result. Do not include secrets, private data, or irrelevant logs. When a check fails before the change, preserve the evidence and report it without expanding scope unless asked.

## Examples

### Honest handoff

Non-compliant: “Everything passes.”

Compliant: “The catalog validator passes for 16 governed documents. I inspected the five changed profiles as rendered Markdown. External links were not checked because network access was unavailable.”

### Final-artifact inspection

Non-compliant: A slide deck export succeeds, so the task is declared complete.

Compliant: The exported deck is opened and inspected for clipping, order, contrast, and missing assets; any unavailable playback check is reported.

## Sources

- Google, [Testing for Reliability](https://sre.google/sre-book/testing-reliability/), Site Reliability Engineering. Reviewed August 13, 2026.
- National Institute of Standards and Technology, [Secure Software Development Framework Version 1.1](https://csrc.nist.gov/pubs/sp/800/218/final), SP 800-218, February 2022. Reviewed August 13, 2026.
- Anthropic, [Best practices for Claude Code](https://code.claude.com/docs/en/best-practices). Reviewed August 13, 2026.
- OpenAI, [Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md). Reviewed August 13, 2026.
- Scale AI, [SWE Atlas: Evaluating AI Coding Agents in Real Codebases](https://scale.com/blog/swe-atlas), March 4, 2026. Reviewed August 13, 2026.
- Cognition, [Testing and Video Recordings](https://docs.devin.ai/work-with-devin/testing-and-recordings). Reviewed August 13, 2026.
- Cognition, [Knowledge](https://docs.devin.ai/product-guides/knowledge). Reviewed August 13, 2026.
