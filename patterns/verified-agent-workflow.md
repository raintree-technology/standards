---
id: PATTERN-VERIFIED-AGENT-WORKFLOW
title: Verified agent workflow
description: A source-neutral pattern for separating variable model work from deterministic validation, bounded execution, and release decisions.
type: pattern
status: draft
governance_status: draft
release_target: post-v1
owners: [ai, engineering, security, data]
last_reviewed: 2026-08-16
review_by: 2027-02-16
stale_after: 2027-02-16
applies_to: [agentic-system, model-workflow, policy-bearing-system]
tags: [agents, verification, policy, evaluation, release]
depends_on: [FND-EVIDENCE, AI-AGENTS, API-CONTRACTS, DATA-QUALITY, ENGINEERING-QUALITY, SECURITY-APPLICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T06:25:28Z" }
sources:
  - id: policystrata-e316ac8
    resource: https://github.com/raintree-technology/policystrata/tree/e316ac8460f13b2960834342d4a0cdd2b6a3b1a2
    title: PolicyStrata at e316ac8
    author: organization:raintree-technology
  - id: anthropic-claude-cookbooks-content-moderation-35f2eec
    resource: https://github.com/anthropics/claude-cookbooks/tree/35f2eec7e44897c537e44441b7dff2f0ecbfb804/capabilities/content_moderation
    title: Content policy enforcement with Claude
    author: organization:anthropic
---

# Verified agent workflow

Use this pattern when a model proposes structured work whose correctness or policy compliance can be checked independently before an effect or release. Keep variable model behavior outside the trusted decision boundary where deterministic or authoritative checks can make the final decision.

This pattern applies `FND-EVIDENCE`, `AI-AGENTS`, `API-CONTRACTS`, `DATA-QUALITY`, `ENGINEERING-QUALITY`, and `SECURITY-APPLICATION`. It adds no requirement to those standards. This draft requires independent review of the final artifact and qualified AI, security, data, and engineering review before it can become stable.

## Applicability

Apply the pattern when the workflow can represent a proposal as a constrained intermediate artifact and validate that artifact against schemas, policy, state, and authority before execution. Examples include semantic queries, content-policy rules, tool plans, change proposals, approval requests, and bounded transformations.

The pattern is less suitable when correctness depends mainly on open-ended judgment that no independent checker, qualified reviewer, or authoritative environment can assess. In that case, narrow the authority and make the human judgment boundary explicit.

## Structure

1. **Governed inputs** identify instructions, policy, context, data, and their authority and versions.
2. **Model proposal** emits a constrained intermediate representation rather than taking the final policy or release decision.
3. **Structural validation** rejects unknown fields, invalid operations, missing references, incompatible types, excessive scope, and unsupported clauses before effects.
4. **Independent policy validation** compares the proposal with canonical obligations and current authoritative state.
5. **Bounded execution** uses a narrow tool or interpreter with minimum authority, limits, repeat-safe behavior, and independent containment.
6. **Release validation** checks the final result and upstream decisions before data, content, or effects cross the release boundary.
7. **Evidence capture** records proposal, checks, effects, version vector, policy references, failures, and protected reproduction material.

Do not silently drop a policy clause or unsupported operation during translation. Preserve it as rejected, unresolved, or requiring qualified review. Treat missing or indeterminate values according to an explicit policy; where a mistaken allowance is material, route uncertainty to denial or review rather than guessing.

## Separation of measures

Deterministic conformance asks whether a known proposal or trace preserves declared obligations. Model reachability asks whether the model produces or attempts that proposal under representative conditions. These are different measurements.

Report separately:

- conformance coverage over the declared schemas, contracts, fixtures, and fault operators;
- per-attempt task and policy outcomes;
- success after the actual retry or candidate-selection policy;
- consistent success across repeated use;
- unsafe release or effect rates;
- latency, cost, escalation, and abstention where they affect adoption.

A deterministic test can pass even when the model never reaches the tested action. A model can produce a valid-looking proposal while a later transformation or release control breaks the policy. Evaluate both paths without merging them into one score.

## Versioning and evidence

Freeze or record every input that can change an outcome: model and sampling settings, system and task instructions, policy and schema versions, tool contracts, intermediate representation, validators, runtime controls, release checks, fixtures, graders, fault operators, retry policy, dependencies, and environment.

Use stable policy and trace identifiers. Capture the first observed responsibility failure and any later containment. Keep known-bad, known-good, allow, deny, escalation, and abstention cases. Preserve minimized witnesses only when they retain the actor, policy distinction, effect, containment, and release result and do not expose sensitive inputs.

Model-written validators, model judges, and self-reported completion are not independent merely because they run in a separate prompt. Calibrate judgment-based graders against qualified review, and prefer environmental or deterministic checks for facts the system can inspect directly.

## Examples

### Compiled policy rules

A model converts policy prose into typed rules over an approved schema. Static validation rejects unknown fields, invalid operators, and unrepresented clauses. At runtime another model may extract typed facts, but a deterministic engine evaluates the rules and returns approve, block, flag, or review with a trace. The policy owner reviews and versions the compiled artifact before release.

This design improves inspectability but does not make model-extracted facts deterministic. Evaluate extraction errors separately, preserve uncertain values, and keep high-impact judgments within the required human or authoritative boundary.

### Model never reaches the tested action

A deterministic conformance test passes for a tenant-scoped tool call. In repeated end-to-end trials, the model always chooses a different tool and never emits that call. Report the conformance result as capability-path coverage and the end-to-end trials as reachability evidence. Do not claim the tested path represents actual agent behavior.

### Valid proposal, unsafe release

A model emits a valid query and the database correctly contains restricted rows, but a response builder includes values from an earlier unfiltered result. The release check must consider upstream authority and containment state, not only the final response shape.

### Over-restrictive repair

A validator repair stops a forbidden operation but also rejects a legitimate approved case. Positive controls and allowed-request trials expose the regression. A lower unsafe-action rate alone is not sufficient evidence of a good repair.

## Tradeoffs

- Constrained artifacts improve checking and replay but limit the proposal language and require schema evolution.
- Independent validators reduce reliance on model judgment but become policy-bearing components that need versioning and tests.
- Bounded execution limits harm but may increase denials, escalation, latency, or user-visible incompleteness.
- Repeated end-to-end evaluation describes variable behavior but costs more and can still miss rare failures.
- Human review handles ambiguity but needs clear authority, evidence, workload limits, and disagreement handling.

## Do not use when

Do not add a model simply to translate an already structured policy or request that ordinary code can process more directly. Do not let a model-generated artifact authorize itself, expand its own tools, bypass runtime authorization, or release its own unchecked result. Do not describe a successful demonstration or selected retry as reliability evidence.

## Verification

- Test malformed, unknown, oversized, unauthorized, ambiguous, and unsupported proposals before execution.
- Compare the intermediate artifact and final effect with an independent policy or environmental oracle.
- Exercise allow, deny, review, abstain, contained, and unsafe-release cases.
- Inject faults at validation, execution, containment, and release transitions and localize the first failure.
- Run repeated end-to-end trials with the deployed retry and selection policy; report reachability and reliability separately from deterministic conformance.
- Reproduce representative passes and failures from the recorded version vector and protected evidence.
- Corrupt or omit evidence and confirm the gate reports an evidence failure rather than a clean outcome.

## Evidence limits

The cited Claude cookbook demonstrates one model-assisted compilation and extraction design over small synthetic content-moderation examples. It is implementation evidence, not a general policy-effectiveness result. PolicyStrata supplies stronger deterministic evidence for transition contracts in SQL and data-agent stacks, but its fault-model results do not establish model reliability or recall on unknown production failures.

## Sources

- Raintree Technology, [PolicyStrata at commit e316ac8](https://github.com/raintree-technology/policystrata/tree/e316ac8460f13b2960834342d4a0cdd2b6a3b1a2). Reviewed August 16, 2026. Used for the distinction between deterministic conformance and model reachability, transition localization, version freezing, and evidence boundaries.
- Anthropic, [Content policy enforcement with Claude at commit 35f2eec](https://github.com/anthropics/claude-cookbooks/tree/35f2eec7e44897c537e44441b7dff2f0ecbfb804/capabilities/content_moderation). Reviewed August 16, 2026. Used as a concrete model-assisted compile, validate, extract, and deterministically evaluate example. Its synthetic sample result is not used as general effectiveness evidence.
