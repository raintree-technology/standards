---
id: AI-AGENTS
title: Agentic systems
description: Governs architecture, context, tools, autonomy, evaluation, safety, and operation for systems in which models select or perform actions.
type: standard
status: draft
governance_status: draft
owners: [ai, product, engineering, security, privacy]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [agentic-system, product-feature]
tags: [ai, agents, tools, evaluation, safety, context]
depends_on: [FND-EVIDENCE, FND-TRUST, FND-CHANGE, AGENT-VERIFICATION, PRIVACY-DATA]
generated: { by: codex/gpt-5, at: "2026-08-13T19:35:12Z" }
sources:
  - id: anthropic-effective-agents
    resource: https://www.anthropic.com/engineering/building-effective-agents
    title: Building effective agents
    author: organization:anthropic
  - id: anthropic-agent-evals
    resource: https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
    title: Demystifying evals for AI agents
    author: organization:anthropic
  - id: anthropic-agent-containment
    resource: https://www.anthropic.com/engineering/how-we-contain-claude
    title: How we contain Claude across products
    author: organization:anthropic
  - id: anthropic-prompt-injection
    resource: https://www.anthropic.com/research/prompt-injection-defenses
    title: Mitigating the risk of prompt injections in browser use
    author: organization:anthropic
  - id: anthropic-claude-code
    resource: https://code.claude.com/docs/en/best-practices
    title: Best practices for Claude Code
    author: organization:anthropic
  - id: openai-agent-safety
    resource: https://developers.openai.com/api/docs/guides/agent-builder-safety
    title: Safety in building agents
    author: organization:openai
  - id: openai-evaluation
    resource: https://developers.openai.com/api/docs/guides/evaluation-best-practices
    title: Evaluation best practices
    author: organization:openai
  - id: openai-agents
    resource: https://developers.openai.com/api/docs/guides/agents
    title: Agents SDK
    author: organization:openai
  - id: openai-agents-md
    resource: https://learn.chatgpt.com/docs/agent-configuration/agents-md
    title: Custom instructions with AGENTS.md
    author: organization:openai
  - id: scale-swe-bench-pro
    resource: https://scale.com/blog/swe-bench-pro
    title: SWE-Bench Pro - Raising the Bar for Agentic Coding
    author: organization:scale-ai
  - id: scale-mcp-atlas
    resource: https://scale.com/blog/mcp-atlas
    title: Actions, Not Words - MCP-Atlas Raises the Bar for Agentic Evaluation
    author: organization:scale-ai
  - id: scale-swe-atlas
    resource: https://scale.com/blog/swe-atlas
    title: SWE Atlas - Evaluating AI Coding Agents in Real Codebases
    author: organization:scale-ai
  - id: cognition-playbooks
    resource: https://docs.devin.ai/product-guides/creating-playbooks
    title: Creating Playbooks
    author: organization:cognition
  - id: cognition-knowledge
    resource: https://docs.devin.ai/product-guides/knowledge
    title: Knowledge
    author: organization:cognition
  - id: cognition-testing
    resource: https://docs.devin.ai/work-with-devin/testing-and-recordings
    title: Testing and Video Recordings
    author: organization:cognition
---

# Agentic systems

Agentic systems must earn autonomy through measurable task performance, constrained authority, observable actions, and safe recovery. This standard applies when a model chooses steps, invokes tools, changes external state, delegates work, or operates across multiple turns. It covers fixed model workflows as well as dynamically planned agents.

Provider features and model behavior change quickly. Treat provider documentation as implementation evidence for that provider, not as a universal guarantee. Revalidate current model, API, retention, safety, and tool behavior before release. This draft requires qualified AI, security, and privacy review before it becomes stable.

## Rules

### AI-AGENTS-001 — Use the simplest architecture that meets measured needs

**Level:** required  
**Applies when:** Designing or materially changing a model workflow, agent, orchestration layer, or multi-agent system.

Start with the least autonomous design that can meet the task contract: deterministic software, one model call, a fixed workflow, a tool-using agent, and then multiple agents in that order of increasing complexity. Add autonomy, handoffs, memory, or parallel agents only when evaluation shows a material improvement that justifies added latency, cost, nondeterminism, security exposure, and operational burden.

**Why:** Architectural complexity creates more failure paths and can hide prompts, state, and tool decisions without improving the user outcome.

**Verify:**

- Compare the selected design with at least one simpler feasible design on task success, safety, latency, cost, and operability.
- Record which evaluation result justified each added agent, handoff, memory layer, or dynamic planning step.
- Confirm the team can inspect the underlying instructions, model calls, tool calls, and state transitions despite framework abstractions.

**Exceptions:** A short-lived prototype can test a more complex design when it has no material authority or real-user impact and is clearly labeled experimental.

### AI-AGENTS-002 — Define the task contract before prompting

**Level:** required  
**Applies when:** Creating an agent capability, workflow, reusable prompt, skill, or playbook.

Define the intended user, trigger, input boundary, desired outcome, required and forbidden actions, available tools, success and failure states, postconditions, escalation conditions, resource limits, and completion evidence before optimizing prompts or models.

**Why:** An agent cannot reliably know when it is done or when to stop if the outcome and boundaries exist only as unstated reviewer expectations.

**Verify:**

- Trace each task-contract element to instructions, control logic, a tool boundary, or an evaluation assertion.
- Confirm a reference solution or known-safe procedure can satisfy the contract without relying on hidden grader expectations.
- Test ambiguous, incomplete, conflicting, and out-of-scope requests against the escalation behavior.

**Exceptions:** Exploratory assistance can begin with an open question, but it must not gain action authority until its contract is defined.

### AI-AGENTS-003 — Separate trusted instructions from untrusted content

**Level:** required  
**Applies when:** A model receives user text, retrieved documents, webpages, emails, files, tool output, database content, or messages from another model.

Classify instruction sources by authority and keep untrusted content in the lowest appropriate authority channel. Never interpolate untrusted content into system, developer, policy, tool-description, or executable instruction fields. Mark data as data, preserve provenance, and use validated structured fields when information must cross into a higher-trust decision.

**Why:** Prompt injection succeeds when content controlled by an attacker is treated as an instruction with authority over tools or private context.

**Verify:**

- Trace every dynamic value entering high-authority prompts, tool definitions, policies, and executable templates to a trusted source and validation boundary.
- Test direct, indirect, encoded, multilingual, quoted, and tool-returned injection attempts.
- Confirm retrieved content cannot change permissions, reveal hidden context, select unapproved recipients, or redefine task success.

**Exceptions:** None for untrusted data that can influence privileged behavior.

### AI-AGENTS-004 — Keep context relevant, attributable, and current

**Level:** required  
**Applies when:** An agent uses conversation history, retrieval, memory, repository instructions, knowledge entries, summaries, or prior-session state.

Include only context needed for the current decision. Preserve source, scope, precedence, freshness, and confidence. Define retrieval triggers and conflict behavior. Summarize or discard stale and low-value material before it crowds out current instructions, and do not let generated summaries silently become authoritative facts.

**Why:** Long or noisy context can dilute instructions, revive stale guidance, conceal conflicts, and increase disclosure and prompt-injection risk.

**Verify:**

- Inspect the effective context for representative tasks and identify why each material item was included.
- Test nested instruction scopes, conflicting knowledge, stale entries, long sessions, irrelevant retrieval, and summary drift.
- Confirm users or operators can identify which durable guidance and prior state affected a consequential action.

**Exceptions:** Full transcripts can be retained for an approved audit purpose, but the active context should still contain only the subset needed for the decision.

### AI-AGENTS-005 — Design tools as constrained contracts

**Level:** required  
**Applies when:** A model can select or invoke a function, API, MCP server, shell, browser, database, file operation, or other tool.

Give each tool one clear purpose, distinct boundaries from similar tools, typed and bounded parameters, explicit units and defaults, structured results, actionable errors, side-effect classification, and examples for difficult cases. Reject unknown fields and invalid combinations at the trusted boundary. Prefer tool shapes that make the safe action easy and invalid actions impossible.

**Why:** Real tool-use evaluations repeatedly find failures in tool discovery, parameter construction, schema compliance, orchestration, and error recovery.

**Verify:**

- Test selection among near-synonym and distractor tools, parameter boundaries, units, dates, enumerations, missing fields, and incompatible combinations.
- Review tool names, descriptions, schemas, errors, and examples with representative models rather than assuming they are self-explanatory.
- Confirm the server validates authorization and arguments independently of the model.

**Exceptions:** A broad low-level tool needs stronger containment, approval, monitoring, and task-specific wrappers for common high-impact operations.

### AI-AGENTS-006 — Grant the minimum authority for each run

**Level:** required  
**Applies when:** An agent can access private data, spend money, communicate externally, change durable state, execute code, or invoke privileged tools.

Grant only the identities, data, tools, destinations, scopes, and duration needed for the current task. Separate read, propose, approve, and execute capabilities. Require a human approval at the last meaningful point before high-impact, irreversible, external, or ambiguous actions, and show the exact target, data, and consequence being approved.

**Why:** Model alignment and prompt guardrails are probabilistic; capability boundaries limit harm even when instructions fail.

**Verify:**

- Inspect effective credentials, tool scopes, network destinations, data access, expiration, and approval configuration.
- Exercise wrong-target, excess-scope, hidden-side-effect, replay, stale-approval, and changed-after-approval cases.
- Confirm denial or unavailable approval stops the action without silently selecting a broader path.

**Exceptions:** Unattended execution can replace per-action approval only inside a qualified, isolated boundary whose worst-case impact is accepted and whose task contract fixes the allowed actions.

### AI-AGENTS-007 — Contain execution independently of model behavior

**Level:** required  
**Applies when:** An agent runs code, browses untrusted content, manipulates files, uses third-party tools, or can reach internal or external networks.

Run the agent in an environment that independently constrains process, filesystem, credential, network, data, and resource access. Keep secrets and sensitive data outside the environment unless the task requires them. Restrict egress and tool permissions, isolate tenants and runs, and destroy or reset mutable environments according to the task's data and retention policy.

**Why:** Model-level defenses influence behavior but cannot guarantee that a capable or compromised agent will stay within intended boundaries.

**Verify:**

- Attempt access outside allowed files, processes, networks, credentials, tenants, tools, time, memory, storage, and spend.
- Confirm a poisoned document, tool result, dependency, or webpage cannot expand the environment's authority.
- Inspect environment reset, artifact export, log retention, and incident isolation between runs.

**Exceptions:** Execution on a user's local system requires clear scope, recoverable changes, protected credentials, approvals for material side effects, and a documented worst-case boundary.

### AI-AGENTS-008 — Control personal and confidential data across the model path

**Level:** required  
**Applies when:** Prompts, context, files, embeddings, traces, evaluations, feedback, or tool calls may contain personal, confidential, regulated, or proprietary data.

Apply `PRIVACY-DATA-016`, which owns the model-path data-governance requirement, to every path the agent system creates, including orchestration, delegation, tool calls, memory, and observability. Extend the same governance to confidential, regulated, and proprietary data. Do not assume API inputs, hidden prompts, traces, or evaluation datasets are ephemeral.

**Why:** Agent systems copy data through more surfaces than the final prompt and response, and provider defaults can differ by product or endpoint.

**Verify:**

- Run the `PRIVACY-DATA-016` verification across the agent's full path inventory, including delegated agents and tools.
- Confirm redaction and minimization occur before data enters any path that does not need the original value.

**Exceptions:** None without the governing privacy, security, and contractual decision.

### AI-AGENTS-009 — Use environmental truth to drive progress

**Level:** required  
**Applies when:** An agent claims completion, changes external state, or performs a multi-step task.

Make the agent inspect authoritative external state after material actions and before completion. Prefer executable checks, API reads, database state, rendered artifacts, or other outcome evidence over the agent's narration. Define maximum steps, time, cost, retries, and no-progress conditions, and stop or escalate when they are reached.

**Why:** Multi-turn errors compound, and a fluent completion message can disagree with the actual environment.

**Verify:**

- Compare the final claim with the final environment state and task postconditions.
- Test partial success, stale reads, asynchronous completion, tool failure, contradictory observations, loops, and repeated no-progress actions.
- Confirm limits stop further action and preserve enough state for safe review or recovery.

**Exceptions:** A purely advisory agent can rely on cited source evidence rather than mutable state, but it must still distinguish observation from inference.

### AI-AGENTS-010 — Make actions repeat-safe and recoverable

**Level:** required  
**Applies when:** Tool calls can be retried, duplicated, reordered, interrupted, or partially completed.

Define idempotency, deduplication, ordering, transaction, compensation, timeout, retry, and resume behavior for every material side effect. Give the agent structured error state and a bounded recovery path. Do not let generic retries repeat payments, messages, deletions, account changes, or other non-idempotent actions.

**Why:** Models and distributed systems both retry and fail partially; combining them can multiply durable side effects.

**Verify:**

- Exercise duplicate requests, lost responses, timeouts after success, out-of-order steps, partial writes, cancellation, resume, and compensation.
- Confirm the agent distinguishes retryable, terminal, approval-required, and already-completed outcomes.
- Reconcile side effects after an interrupted run before allowing it to continue.

**Exceptions:** An irreversible action without compensation requires confirmation, a unique operation key, and an authoritative post-action check before any retry.

### AI-AGENTS-011 — Escalate ambiguity and high-impact judgment

**Level:** required  
**Applies when:** Missing information, preference, conflicting authority, novel conditions, or material risk can change the correct action.

Ask the person or qualified owner who holds the missing authority rather than guessing. Define escalation triggers for security, privacy, legal, financial, safety, access, destructive change, public communication, and other high-impact domains. Present the decision, evidence, alternatives, and consequence at the checkpoint.

**Why:** An agent can research facts but cannot infer a user's unstated preference or replace accountable specialist judgment.

**Verify:**

- Test underspecified requests, conflicting policies, missing recipients or targets, uncertain identity, novel risk, and unavailable approvers.
- Confirm the agent does not convert uncertainty into permission or treat a previous approval as authority for changed scope.
- Review escalation quality with the accountable domain owner.

**Exceptions:** Low-risk, reversible choices can use documented defaults when the user can see and change the result.

### AI-AGENTS-012 — Version the full agent configuration

**Level:** required  
**Applies when:** An agent or model workflow informs decisions or performs recurring work.

Version the model or snapshot, provider, system and developer instructions, tool schemas, orchestration code, retrieval and memory rules, guardrails, policies, environment image, and evaluation suite as one releaseable configuration. Treat changes to any of them as behavior changes and evaluate before promotion.

**Why:** The same user prompt can behave differently after a model, tool, context, policy, or scaffold change even when application code is unchanged.

**Verify:**

- Reconstruct a representative run from recorded configuration identifiers and protected inputs.
- Compare evaluation, safety, latency, and cost results across the exact candidate and baseline configurations.
- Confirm provider aliases or automatic upgrades cannot bypass the release decision where stable behavior is required.

**Exceptions:** A provider without pinned versions requires stronger continuous evaluation, bounded rollout, drift detection, and a documented fallback.

### AI-AGENTS-013 — Build representative, balanced evaluation tasks

**Level:** required  
**Applies when:** Developing, selecting, changing, or releasing an agentic system.

Create evaluation tasks from actual requirements, production distributions, observed failures, expert risk analysis, and realistic edge cases. Cover both when a behavior should occur and when it should not. Include valid alternative paths, ambiguous inputs, long context, multilingual or multimodal input where supported, tool distractors, failures, and high-risk abuse cases.

**Why:** Demo prompts and one-sided datasets reward narrow behavior that can fail on real traffic or over-trigger a feature.

**Verify:**

- Map every task to a requirement, failure, risk, or production slice and record important missing populations.
- Run reference solutions to prove tasks are solvable and graders accept valid alternatives.
- Compare evaluation input shape, tools, context, and environment with the intended deployment.

**Exceptions:** An early prototype can begin with a small task set, but it must cover its core success, refusal, failure, and escalation paths before user exposure.

### AI-AGENTS-014 — Protect evaluation validity and generalization

**Level:** required  
**Applies when:** Evaluation results support a model, architecture, prompt, safety, or release decision.

Separate development, regression, and held-out evaluation data. Track task provenance and possible training or prompt contamination. Use reproducible environments, freeze material task and grader changes for comparisons, and test on internal or otherwise unseen work representative of the deployment before claiming generalization.

**Why:** Public benchmark familiarity, leaked solutions, changing dependencies, and grader edits can make scores rise without a better system.

**Verify:**

- Record dataset partitions, exposure history, environment image, dependency state, task version, grader version, and evaluation configuration.
- Check for benchmark recognition, answer leakage, flaky infrastructure, impossible tasks, and tests that encode an implementation rather than behavior.
- Reproduce a sample of passes and failures from clean environments.

**Exceptions:** Public benchmarks can support comparison when contamination limits are stated, but they cannot replace evaluation on the system's own tasks and environments.

### AI-AGENTS-015 — Measure repeated end-to-end outcomes

**Level:** required  
**Applies when:** A stochastic model or agent is evaluated for quality, safety, reliability, latency, or cost.

Run enough independent trials to reveal variability and report the metric that matches the operating promise. Distinguish per-trial success, success in at least one of several attempts, consistent success across all attempts, partial credit, safety failures, latency, tokens, tool calls, and cost. Do not report the best run as typical performance.

**Why:** A system that sometimes succeeds can look reliable in a single hand-picked trace, while repeated autonomy compounds failure probability and expense.

**Verify:**

- Record trial count, random or sampling settings, environment reset, aggregation, uncertainty, and failure distribution.
- Compare per-task and segment results rather than only one overall average.
- Confirm the reported metric matches whether production gets one attempt, retries, selection among candidates, or unattended repeated use.

**Exceptions:** Deterministic control checks can run once when determinism is verified; model-involved behavior still needs repeated trials proportionate to risk and variability.

### AI-AGENTS-016 — Grade outcome, process, and policy separately

**Level:** required  
**Applies when:** Evaluating a multi-step agent or tool-using workflow.

Grade authoritative final state, required intermediate behavior, and policy compliance with separate assertions. Prefer deterministic state and programmatic checks where they directly measure the requirement. Use model graders for judgment that needs them, calibrate those graders against expert human labels, inspect full traces for diagnosis, and allow valid alternative strategies.

**Why:** A correct final sentence can hide an unperformed action, while a rigid expected trajectory can reject a better valid solution.

**Verify:**

- Compare grader decisions with expert review on representative passes, failures, and borderline cases.
- Measure false acceptance, false rejection, disagreement, and sensitivity to irrelevant style or verbosity.
- Inspect failures to distinguish model, harness, tool, environment, task, and grader causes.

**Exceptions:** Exact-output tasks can use a single deterministic assertion when wording or structure is itself the requirement.

### AI-AGENTS-017 — Red-team the agent and its tools

**Level:** required  
**Applies when:** An agent processes untrusted content, accesses private context, or can take actions.

Test adversarial instructions and conventional attacks across user input, retrieved content, files, webpages, tool results, memory, inter-agent messages, and environment artifacts. Cover data exfiltration, permission expansion, hidden action, policy override, confused deputy behavior, unsafe code, indirect injection, denial of service, and approval manipulation. Re-run material attacks after model, prompt, tool, or control changes.

**Why:** External content and tools form an adversarial input surface, and no model-level defense removes prompt-injection risk by itself.

**Verify:**

- Preserve attack cases, exact configuration, outcome, trace, control that stopped or missed the attack, and residual risk.
- Test adaptive repeated attempts rather than only obvious one-shot strings.
- Confirm environmental and permission boundaries hold even when the model follows the malicious instruction.

**Exceptions:** A model with no untrusted input, private context, or action authority can use a narrower misuse review, with those boundaries verified.

### AI-AGENTS-018 — Observe decisions, tool use, and operational limits

**Level:** required  
**Applies when:** Operating an agentic system for users or recurring internal work.

Record the configuration, task, high-level decisions, tool selection, validated arguments, results, approvals, state transitions, retries, errors, final outcome, latency, token use, and cost needed for debugging and governance. Protect sensitive reasoning and data, use stable correlation, and alert on loops, repeated denial, unusual tool or data access, limit exhaustion, safety-control activation, and outcome failure.

**Why:** Final responses alone cannot reveal whether failure came from task understanding, tool selection, parameters, orchestration, environment, or policy.

**Verify:**

- Trace representative successful, failed, refused, escalated, retried, and interrupted runs end to end.
- Confirm logs exclude secrets and unnecessary personal data and follow approved access and retention.
- Test alert routing and the operator's ability to stop, isolate, and investigate a run.

**Exceptions:** If full traces contain protected data, store a minimized event record and keep detailed evidence in a restricted, short-lived diagnostic path.

### AI-AGENTS-019 — Parallelize only separable work

**Level:** required  
**Applies when:** Multiple model calls, agents, or sessions work concurrently or hand work to one another.

Define independent scopes, inputs, output contracts, ownership boundaries, shared-state rules, budgets, and a synthesis or conflict-resolution step before parallel execution. Do not let workers edit the same mutable state or authorize one another without an explicit coordinator. Use multiple agents only when measured gains exceed coordination failures and added nondeterminism.

**Why:** Parallel agents can duplicate work, race on shared files, amplify incorrect assumptions, lose decisions during handoff, and make total authority hard to see.

**Verify:**

- Test conflicting outputs, duplicate actions, partial worker failure, stale shared state, circular handoffs, coordinator failure, and budget exhaustion.
- Compare parallel and single-agent results on success, consistency, latency, cost, and review effort.
- Confirm synthesis preserves dissent, provenance, unresolved conflicts, and required evidence rather than selecting the most confident output.

**Exceptions:** Independent read-only analysis can use lighter coordination when each result remains attributable and a reviewer performs final synthesis.

### AI-AGENTS-020 — Maintain reusable instructions as governed knowledge

**Level:** required  
**Applies when:** A correction, workflow, project rule, tool procedure, or successful task pattern will recur.

Place durable project-wide guidance in the repository's governed instruction or knowledge system and task-specific procedures in versioned skills or playbooks. Give each item a scope or trigger, owner, source, postconditions, forbidden actions, required inputs, and review path. Derive updates from reviewed successes and failures, remove duplicates, resolve conflicts, and retire stale guidance.

**Why:** Repeating corrections in chat wastes effort, while unscoped or conflicting memory can inject stale behavior into unrelated tasks.

**Verify:**

- Inspect which instruction and knowledge items a representative run retrieved and why.
- Test scope, precedence, conflicts, missing prerequisites, postconditions, and rollback to a prior version.
- Link each material update to a reviewed session, incident, evaluation failure, project rule, or owner decision.

**Exceptions:** One-time task detail can remain in the task record when it has no expected reuse.

## Guidance

Treat the model, harness, instructions, tools, context, environment, guardrails, and evaluations as one system. A model leaderboard does not predict performance on a different tool set, repository, policy, or scaffold.

Choose workflow patterns by task shape. Fixed sequences fit known steps. Routing fits reliably separable categories. Parallel calls fit independent work or multiple judgments. An orchestrator fits tasks whose subtasks cannot be known in advance. An evaluator loop fits outputs with clear criteria and measurable improvement. A free-form agent fits open-ended work only when the environment provides useful feedback and the allowed failure boundary is acceptable.

Do not expose hidden chain-of-thought as an observability requirement. Record decisions, tool calls, state changes, outcomes, and concise rationales needed for review without depending on private reasoning text.

Keep tool catalogs small for each task. Similar or irrelevant tools create discovery errors. Give the model a search or routing layer only when it is itself evaluated, bounded, and observable.

## Examples

### Architecture choice

Non-compliant: A support flow begins with five specialist agents because each department might need its own prompt.

Compliant: A single constrained workflow handles the measured task set. Evaluation identifies one category whose tools and policy conflict with the rest, so routing isolates that category. A multi-agent design is reconsidered only if the routed workflow fails a defined target.

### Prompt injection boundary

Non-compliant: Text extracted from an uploaded invoice is inserted into a developer message that tells the model which payment tool to call.

Compliant: The file remains labeled untrusted. A constrained extractor produces validated invoice fields. Server-side authorization and approval determine whether the payment operation is allowed, and the runtime cannot access unrelated recipients or credentials.

### Agent evaluation

Non-compliant: The team runs ten demo prompts, keeps the best screenshots, and reports that the agent reliably completes the workflow.

Compliant: The suite includes real successes, failures, refusals, ambiguous inputs, tool distractors, and held-out tasks in reproducible environments. Multiple trials report per-attempt success, consistency, safety failures, latency, and cost. State checks grade outcomes while human-calibrated graders assess judgment.

## Sources

- Anthropic, [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents), December 19, 2024. Reviewed August 13, 2026. Anthropic notes that its tooling discussion has changed since publication; this standard relies on the architectural principles and revalidates current product behavior separately.
- Anthropic, [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents), January 9, 2026. Reviewed August 13, 2026.
- Anthropic, [How we contain Claude across products](https://www.anthropic.com/engineering/how-we-contain-claude). Reviewed August 13, 2026.
- Anthropic, [Mitigating the risk of prompt injections in browser use](https://www.anthropic.com/research/prompt-injection-defenses), November 24, 2025. Reviewed August 13, 2026.
- Anthropic, [Best practices for Claude Code](https://code.claude.com/docs/en/best-practices). Reviewed August 13, 2026.
- OpenAI, [Safety in building agents](https://developers.openai.com/api/docs/guides/agent-builder-safety). Reviewed August 13, 2026. The page marks Agent Builder as deprecated, so this standard adopts its general threat and control guidance rather than its product-specific workflow.
- OpenAI, [Evaluation best practices](https://developers.openai.com/api/docs/guides/evaluation-best-practices). Reviewed August 13, 2026.
- OpenAI, [Agents SDK](https://developers.openai.com/api/docs/guides/agents). Reviewed August 13, 2026.
- OpenAI, [Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md). Reviewed August 13, 2026.
- Scale AI, [SWE-Bench Pro: Raising the Bar for Agentic Coding](https://scale.com/blog/swe-bench-pro), September 19, 2025. Reviewed August 13, 2026.
- Scale AI, [Actions, Not Words: MCP-Atlas Raises the Bar for Agentic Evaluation](https://scale.com/blog/mcp-atlas), September 19, 2025. Reviewed August 13, 2026.
- Scale AI, [SWE Atlas: Evaluating AI Coding Agents in Real Codebases](https://scale.com/blog/swe-atlas), March 4, 2026. Reviewed August 13, 2026.
- Cognition, [Creating Playbooks](https://docs.devin.ai/product-guides/creating-playbooks). Reviewed August 13, 2026.
- Cognition, [Knowledge](https://docs.devin.ai/product-guides/knowledge). Reviewed August 13, 2026.
- Cognition, [Testing and Video Recordings](https://docs.devin.ai/work-with-devin/testing-and-recordings). Reviewed August 13, 2026.
