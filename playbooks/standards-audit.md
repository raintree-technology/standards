---
id: PLAYBOOK-STANDARDS-AUDIT
title: Standards conformance audit
description: Source-neutral procedure for applying Raintree profiles, inspecting code and live-system evidence, and reporting scoped conformance without implying certification.
type: playbook
status: draft
governance_status: draft
release_target: post-v1
owners: [standards, ai, security, privacy, data, engineering]
last_reviewed: 2026-08-16
review_by: 2027-02-16
stale_after: 2027-02-16
applies_to: [standards-audit, conformance-review, company-brain-audit]
tags: [playbook, audit, evidence, conformance]
depends_on: [FND-EVIDENCE, FND-TRUST, WRITING-FUNCTIONAL, AI-AGENTS, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T06:08:51Z" }
---

# Standards conformance audit

Use this playbook to audit a repository, system, release, or bounded decision against Raintree standards. An audit result applies only to the declared subject, version, environment, evidence, and cutoff date. It is not certification and does not support claims about uninspected scope.

This draft requires independent review of the final artifact and qualified AI, security, privacy, data, and engineering review before it can become stable.

Start from [`templates/audit-report.md`](../templates/audit-report.md). Keep sensitive evidence in its approved system and record a protected reference rather than copying it into the report.

## Governing standards

- `FND-EVIDENCE` — claim strength, provenance, freshness, conflicts, uncertainty, and valid evaluation
- `FND-TRUST` — honest framing, automated judgment, user control, and reliance boundaries
- `WRITING-FUNCTIONAL` — intended reader, clear terms, executable procedure, report structure, and comprehension
- `AI-AGENTS` — task contracts, authority boundaries, governed instructions, and evaluation when an agent conducts or supports the audit
- `AGENT-VERIFICATION` — proportionate checks, final inspection, residual uncertainty, independent review, and reproducible handoff

## Status contract

Use exactly one status for each in-scope rule:

| Status | Meaning |
|---|---|
| `pass` | Inspected evidence demonstrates that the rule is handled according to its requirement level for the declared scope and version. |
| `fail` | The applicable obligation is not met or prohibited behavior is present. Incomplete implementation is a failure, not a partial pass. |
| `unknown` | The auditor lacks enough evidence to determine whether the rule is met. |
| `not applicable` | The rule's stated condition is false for the declared scope, or an optional enhancement was not selected, with the reason recorded. |
| `approved exception` | An authorized, current exception satisfies `governance/exceptions.md` for the exact rule and scope; prohibited rules cannot use this status. |
| `stale evidence` | Evidence once existed but is too old, superseded, or mismatched to support the current claim. |

Do not use `partial pass`. Record incomplete implementation as `fail` and insufficient proof as `unknown`. For `recommended` rules, `pass` means the default was followed or a concrete context-specific deviation reason was recorded. For `avoid` rules, `pass` means the behavior is absent or its required justification and review are recorded. A compensating control does not change a failure to `pass` unless the rule's exception permits it and the governing approval is recorded.

## Overall result

- `conforming` — every applicable `required` and active `contextual` rule is `pass` or `approved exception`; every `prohibited` rule is `pass`; every applicable `recommended` and `avoid` rule is `pass` or `approved exception`; and every rule's applicability was decided.
- `non-conforming` — an applicable `required`, active `contextual`, `recommended`, or `avoid` rule is `fail`, or a `prohibited` rule is `fail` because the prohibited behavior is present.
- `indeterminate` — no known failure establishes non-conformance, but an applicable `required`, active `contextual`, `prohibited`, `recommended`, or `avoid` rule is `unknown` or `stale evidence`.

When both a known failure and missing evidence exist, report `non-conforming` and keep the unknown or stale findings visible. Optional rules do not affect the overall result. A prohibited rule can only be `pass`, `fail`, `unknown`, `not applicable`, or `stale evidence`.

## Procedure

1. **Declare the audit decision and boundary.** Record the intended reader and decision, subject, owners, system boundary, environments, version or commit, time period, evidence cutoff, supported uses, exclusions, and expected report date. Identify laws, organization policy, contracts, or external standards that remain additive.
2. **Select profiles and routes.** Choose the closest primary task profile. Load every front-matter `depends_on` standard, then activate every conditional route whose condition is true. Combine multiple applicable profiles. Record the reason for each route and any library gap that requires an external owner decision.
3. **Build the rule inventory.** List every rule from the active standards. Record its level, condition, applicability decision, planned evidence, and responsible reviewer. Do not remove an unfavorable or difficult rule from the inventory.
4. **Route provider evidence.** Activate the exact named playbook for Stripe, Plaid, Vercel, Resend, Neon, Cloudflare, or Google Search Console and load its manifest-backed bundle. Use the zero-gap ledger to classify every in-scope provider surface, select capabilities by exact interface and authority, execute matching workflows, and run applicable evaluations. If no named playbook or capability exists, activate `INTEGRATIONS-VENDOR`, use current official provider documentation, and record the library gap. Record each applicable agent skill and package version or gap as a review aid. Classify provider documentation as normative and engineering articles as informative. Resolve skill, sample, and source conflicts under `INTEGRATIONS-VENDOR-008`; do not let an informative article or cross-provider sample become the sole authority for provider behavior. A repository-only inspection cannot pass rules that require live control-plane or released-system evidence.
5. **Inspect actual evidence.** Compare design records and repository artifacts with authorized live configuration, identities, permissions, data, logs, rendered outputs, tests, operational records, and final state as applicable. Record source, version, method, environment, collection time, access classification, and expiry for each evidence item.
6. **Trace representative paths.** Follow material data and authority from input through validation, processing, storage, derivation, access decisions, output, logging, export, retention, correction, deletion, backup, and restoration. Sample normal and high-impact paths rather than relying only on documentation.
7. **Exercise failure and boundary cases.** Cover normal use, denial, stale or conflicting state, partial failure, retry, revoked access, missing evidence, unsupported requests, recovery, and interrupted operations. For providers, include invalid callbacks, duplicates, reordering, ambiguous timeouts, credential revocation, quota or cost exhaustion, control-plane drift, outage, reconciliation, rollback or compensation, and exit. Add domain-specific abuse, accessibility, privacy, security, financial, or safety cases required by the active standards.
8. **Record findings and result.** Assign one permitted status per rule, link evidence, state the direct observation, distinguish inference, explain risk, identify an owner and follow-up, and preserve conflicts and limitations. Apply the overall-result contract without averaging or hiding required failures behind a score.
9. **Review exceptions.** Confirm every exception names the rule, exact scope, reason, risk, compensating controls, accountable approver, expiry, and return-to-compliance work. An auditor or agent may propose but must not approve an exception on another person's behalf.
10. **Retest and close.** Retest resolved findings against the final artifact and environment. Rebuild the rule inventory if scope or behavior changed. Bind the report to the final version and preserve unknowns, stale evidence, untested areas, open exceptions, and required qualified review in the conclusion.

## Evidence boundaries

- A policy or design document proves what was intended, not what a live system enforces.
- A code test proves only the paths, inputs, configuration, and environment it exercised.
- A screenshot without source, time, identity, scope, and method is weak evidence.
- An automated scanner finding needs manual interpretation; a clean scan does not prove conformance.
- A source-system control does not prove that derived stores, caches, exports, and restores preserve it.
- Reviewer confidence, aggregate scores, and selected successful demonstrations do not replace rule-level evidence.

## Completion evidence

- Completed scope, profile-routing record, and rule inventory.
- Evidence register with protected references and freshness.
- Rule-by-rule findings using only the defined statuses.
- Exceptions checked against `governance/exceptions.md`.
- Overall result derived from the status contract.
- Retest evidence bound to the final subject and version.
- Independent and qualified reviews required by active standards.
- Explicit unknowns, stale evidence, untested scope, conflicts, and next owners.
- When a material provider is in scope, the exact provider playbook and `INTEGRATIONS-VENDOR-001` through `INTEGRATIONS-VENDOR-014` — The report contains a separate provider record, manifest and skill route or gap, normative and informative source classification, conflict decisions, negative-path inventory, live configuration, exercised callbacks and failures, cost and quota bounds, recovery, and exit evidence.
- `WRITING-FUNCTIONAL-001`, `WRITING-FUNCTIONAL-004`, and `WRITING-FUNCTIONAL-007` — The final report identifies its reader and decision, states the scoped result first, and uses clear headings, tables, and links.
- `WRITING-FUNCTIONAL-013` when the audit governs a consequential or repeated decision — Representative readers can find, understand, and act on the result and material limitations.
- `WRITING-FUNCTIONAL-014`, `AI-AGENTS-002`, and `AI-AGENTS-020` when an agent uses the playbook — The audit task defines its scope, required inputs, forbidden actions, escalation, postconditions, verification, owner, and versioned reuse.

## Examples

### Missing live authorization evidence

Repository tests cover role checks, but the auditor cannot inspect deployed policy or exercise a revoked user. The applicable authorization rule is `unknown`, not `pass`, and the overall result is `indeterminate` unless another required rule already fails.

### Incomplete deletion propagation

The source and search index delete a record, but an answer cache retains it until manual expiry. The applicable deletion rule is `fail`, even if remediation is scheduled, and the overall result is `non-conforming`.
