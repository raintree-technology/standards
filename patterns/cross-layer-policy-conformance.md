---
id: PATTERN-CROSS-LAYER-POLICY-CONFORMANCE
title: Cross-layer policy conformance
description: A source-neutral pattern for preserving policy obligations across exposed capabilities, validation, execution, containment, and release.
type: pattern
status: draft
governance_status: draft
release_target: post-v1
owners: [engineering, security, data, ai]
last_reviewed: 2026-08-16
review_by: 2027-02-16
stale_after: 2027-02-16
applies_to: [policy-bearing-system, agentic-system, data-agent]
tags: [policy, conformance, contracts, evidence, release]
depends_on: [FND-EVIDENCE, AI-AGENTS, API-CONTRACTS, DATA-QUALITY, ENGINEERING-QUALITY, SECURITY-APPLICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T06:25:28Z" }
sources:
  - id: policystrata-e316ac8
    resource: https://github.com/raintree-technology/policystrata/tree/e316ac8460f13b2960834342d4a0cdd2b6a3b1a2
    title: PolicyStrata at e316ac8
    author: organization:raintree-technology
---

# Cross-layer policy conformance

Use this pattern when one policy obligation is represented or enforced by several components. A component can pass its local tests while changing, dropping, or misapplying an obligation received from another component. Test the policy-bearing transitions as well as each component.

This pattern applies `FND-EVIDENCE`, `AI-AGENTS`, `API-CONTRACTS`, `DATA-QUALITY`, `ENGINEERING-QUALITY`, and `SECURITY-APPLICATION`. It adds no requirement to those standards. This draft requires independent review of the final artifact and qualified security, data, AI, and engineering review before it can become stable.

## Applicability

Apply the pattern when a policy appears in two or more surfaces, such as a model-visible tool manifest, semantic plan, validator, compiler, query, authorization layer, database policy, approval service, or output-release check. It is especially useful when the surfaces deploy independently or use different policy representations.

The strongest cited implementation evidence is for SQL and data-agent stacks. Applying the pattern to browser actions, code execution, general tool use, or human approval workflows requires contracts, fixtures, and fault models for that domain. Do not present evidence from one domain as validation of another.

## Structure

1. **Canonical policy** defines the obligations to preserve. It has an accountable owner, stable identifiers, declared scope, and a representation that an independent checker can evaluate.
2. **Policy-bearing surfaces** expose, transform, enforce, contain, or release policy-relevant behavior. Inventory each surface and record its deployed version.
3. **Transition responsibilities** state what each receiving surface must preserve, reject, add, or prove. Different surfaces may have different decisions because they have different jobs.
4. **Independent observations** capture the request, intermediate representation, decision, effect, containment, and release state needed to check each responsibility.
5. **Conformance detection** identifies the first observed responsibility violation. It records later containment separately instead of treating containment as proof that the earlier transition was correct.
6. **Release evidence** preserves a reproducible witness, configuration versions, input provenance, and the limits of the exercised fault model.

The version vector should cover every artifact that can change the result, including the canonical policy, schemas, manifests, validators, compilers, database policies, release controls, adapters, detector, generator, fault operators, fixtures, and task set. Hash or otherwise bind material artifacts when a comparison or release decision depends on exact identity.

## Responsibilities and evidence

Define each transition contract in terms of obligations rather than simple decision equality. For example, an authorized semantic request may require a compiler to preserve tenant scope and business meaning, while a database policy may independently contain rows outside that scope. A compiler failure remains a conformance failure even when the database blocks the resulting query.

Use observations from outside the transformation under test where practical. A compiler should not be its own policy oracle. A trace importer, adapter, evidence emitter, or gate that can silently remove a finding belongs to the trusted computing base. Protect that boundary with required-field validation, input counts or checksums, known-good and known-bad canaries, independent gate recomputation, and result-shape assertions appropriate to the risk.

Record at least:

- canonical and observed decisions with stable policy references;
- the first violated transition and its declared responsibility;
- whether and where the violation was contained;
- whether an output or effect was released;
- the complete version vector and execution environment;
- evidence provenance and evidence level;
- a reduced witness that preserves the policy distinction, when safe to retain.

Keep raw prompts, rows, credentials, private schemas, and other sensitive payloads out of portable evidence. Retain protected references, hashes, policy identifiers, and redacted facts when they are sufficient for reproduction and review.

## Regression design

Maintain both failure-catching and behavior-preserving cases:

- known violations that should become or remain detected;
- contained violations that should remain contained;
- forbidden requests that should remain denied;
- allowed requests that should remain usable;
- clean controls that should produce no finding.

Inject faults at declared transitions where a deterministic fault model is practical. Count killed, survived, equivalent, malformed, clean-control, and false-positive cases separately. Freeze the detector and fault taxonomy before calling a generated set held out. Externally authored or incident-derived cases should remain distinguishable from cases produced by the same taxonomy used to build the detector.

A minimized witness should preserve the failure class, first violated transition, principal or actor meaning, material data distinction, containment result, and release result. Describe bounded replay reduction as bounded replay reduction, not global minimization or source-code root-cause proof.

## Examples

### Compiler fault contained by the database

A compiler lowers an authorized tenant-scoped request using a stale tenant key. The database policy blocks the cross-tenant rows. Report the compiler as the first violated transition and the database as the containment layer. Do not mark the trace clean merely because no rows were released.

### Unsafe release after an upstream denial

A validator denies a sensitive metric, but a release component returns a cached result to the caller. Report both the upstream denial and the unsafe release. The release check must not infer authority from the presence of a result.

### Legitimate behavior denied

A new policy version permits an approved aggregate, but a stale validator rejects it. An allowed-request control catches the over-restriction. Negative cases alone would miss this regression.

### Fault outside the taxonomy

A test suite injects missing tenant predicates but has no operator for timezone or aggregation-grain drift. A perfect injected-case score supports only the declared operators and fixtures. Record the uncovered class as a gap rather than claiming general policy-drift detection.

### Missing or corrupted trace evidence

An importer silently drops records with a newly added field. The scan finds no violation because it observed no affected trace. Treat required trace counts, schema failures, and canary outcomes as gate inputs so missing evidence fails visibly instead of producing a clean conclusion.

## Tradeoffs

- Transition contracts localize drift but add policy modeling, trace, fixture, and ownership work.
- Independent observations reduce circular checks but expand the trusted computing base and data-handling surface.
- Fault injection makes declared coverage reproducible but can create false confidence when the taxonomy is narrow or co-developed with the detector.
- Minimized witnesses help review and repair but can omit context unless the reducer preserves the material policy distinction.
- Runtime enforcement can reduce exposure but adds latency and availability dependencies. Its adoption is separate from CI conformance testing.

## Do not use when

Do not build a cross-layer conformance system when one authoritative component makes and enforces the entire decision and an integration test can observe the final effect directly. Do not use a scanner as a substitute for application authorization, database controls, approval enforcement, or other runtime boundaries. A clean scan means no modeled violation was observed in the exercised evidence; it does not prove authorization correctness or recall on unknown production failures.

## Verification

- Trace representative allow, deny, contain, and release cases through every declared surface.
- Mutate each transition and confirm the first failing responsibility is localized without hiding later containment.
- Run clean and legitimate-behavior controls and inspect false denials as well as false allowances.
- Corrupt or remove trace inputs and verify that evidence-integrity controls fail visibly.
- Reproduce a witness from its policy reference, inputs, version vector, and protected evidence references.
- Review whether the claimed evidence level, domain, fault-model coverage, and limitations match what actually ran.

## Evidence limits

PolicyStrata reports full coverage over its published deterministic mutation operators and fixtures, not recall on unknown production faults. Its cited comparative result shows that responsibility-scoped transition checks observed cases missed by modeled point-control baselines. Treat that as implementation and fault-model evidence for SQL and data-agent systems, not a universal effectiveness claim.

## Sources

- Raintree Technology, [PolicyStrata at commit e316ac8](https://github.com/raintree-technology/policystrata/tree/e316ac8460f13b2960834342d4a0cdd2b6a3b1a2). Reviewed August 16, 2026. Used as first-party implementation and evaluation evidence for responsibility-scoped transition contracts, version vectors, fault injection, witness localization, and evidence limits.
