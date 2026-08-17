---
id: ENGINEERING-QUALITY
title: Engineering quality
description: Requirements for architecture, testing, dependencies, review, and release readiness.
type: standard
status: draft
governance_status: draft
owners: [engineering, security, operations]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [software-change, service-change]
tags: [engineering, architecture, testing, dependencies]
depends_on: [FND-EVIDENCE, FND-CHANGE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T06:11:16Z" }
sources:
  - id: nist-ssdf-11
    resource: https://csrc.nist.gov/pubs/sp/800/218/final
    title: Secure Software Development Framework Version 1.1
    author: organization:nist
  - id: slsa-10
    resource: https://slsa.dev/spec/v1.0/
    title: Supply-chain Levels for Software Artifacts 1.0
    author: organization:open-source-security-foundation
  - id: cisa-secure-by-design
    resource: https://www.cisa.gov/securebydesign
    title: Secure by Design
    author: organization:cisa
---

# Engineering quality

Software changes must have an explicit design boundary, evidence proportionate to risk, controlled dependencies, review, and a release decision based on the integrated result.

## Rules

### ENGINEERING-QUALITY-001 — Record consequential design decisions

**Level:** required
**Applies when:** A change introduces a durable boundary, dependency, data flow, failure mode, or operational commitment.

Record the problem, constraints, considered options, decision, consequences, ownership, and conditions that would trigger reconsideration.

**Why:** Architecture becomes accidental when future maintainers cannot distinguish a constraint from an incidental implementation.

**Verify:**

- Trace the implemented boundaries and dependencies to the decision record.
- Confirm rejected options and material tradeoffs are represented accurately.

**Exceptions:** Small local changes with no durable design consequence may rely on the change description.

### ENGINEERING-QUALITY-002 — Keep components and authority bounded

**Level:** required
**Applies when:** Adding or changing a component, service, job, library, or automation.

Give each component a focused responsibility, explicit interface, minimum required authority, owned failure behavior, and observable resource boundary.

**Why:** Coupled responsibilities and broad authority increase blast radius and make failures hard to isolate.

**Verify:**

- Inspect imports, network paths, permissions, storage access, and failure propagation.
- Exercise an unavailable or malformed dependency and observe containment.

**Exceptions:** A deliberately combined component requires a recorded reason and evidence that separation would add more risk than it removes.

### ENGINEERING-QUALITY-003 — Test behavior at the cheapest effective layer

**Level:** required
**Applies when:** A change creates or modifies behavior that can regress.

Map material behavior and risk to deterministic unit, contract, integration, end-to-end, property, performance, security, or manual checks at the lowest layer that can prove the claim.

**Why:** One test layer either misses integrated behavior or makes all feedback slow and fragile.

**Verify:**

- Review the behavior-to-check map and run the selected checks against the final change.
- Confirm failure, boundary, compatibility, and recovery behavior are represented.

**Exceptions:** Unautomatable behavior requires a repeatable manual procedure, evidence, and owner.

### ENGINEERING-QUALITY-004 — Control dependency introduction and change

**Level:** required
**Applies when:** Adding, replacing, upgrading, or materially reconfiguring a dependency.

Confirm necessity, maintenance state, source, license, integrity, transitive impact, runtime authority, failure behavior, and removal path before adoption.

**Why:** Dependencies add code, authority, update obligations, and supply-chain risk beyond the imported API.

**Verify:**

- Inspect the resolved dependency graph, provenance, license, advisories, and effective permissions.
- Exercise upgrade, unavailability, malformed output, and removal where material.

**Exceptions:** Emergency remediation may use abbreviated review when follow-up has an owner and deadline.

### ENGINEERING-QUALITY-005 — Require review independent of authorship

**Level:** required
**Applies when:** A change can affect users, production data, security, privacy, money, availability, or a shared interface.

Have a qualified reviewer who did not author the change inspect its design, implementation, evidence, and residual risk before release.

**Why:** Authors share assumptions with their implementation and can miss systematic errors.

**Verify:**

- Record reviewer identity, artifact version, findings, resolutions, and approval scope.
- Confirm later changes did not invalidate the reviewed artifact.

**Exceptions:** A documented emergency process may permit retrospective review within a defined deadline.

### ENGINEERING-QUALITY-006 — Build from attributable inputs

**Level:** required
**Applies when:** Producing a deployable artifact or distributed package.

Use versioned source, locked inputs, protected build steps, attributable artifacts, and integrity evidence sufficient to connect the release to the reviewed source and configuration.

**Why:** A reviewed source change does not prove the distributed artifact used the same inputs or process.

**Verify:**

- Trace the artifact to source revision, dependency resolution, build identity, and configuration.
- Confirm protected release credentials and artifact integrity checks work.

**Exceptions:** Local prototypes not distributed or deployed may omit formal provenance when clearly marked non-release.

### ENGINEERING-QUALITY-007 — Make failure observable without exposing sensitive data

**Level:** required
**Applies when:** Software runs outside an author's direct interactive control.

Emit structured health, error, latency, saturation, and dependency signals tied to user and business outcomes, while excluding or protecting secrets and personal data.

**Why:** A failure that cannot be detected, scoped, or correlated cannot be operated safely.

**Verify:**

- Trigger representative failures and trace them through logs, metrics, traces, alerts, and operator guidance.
- Inspect telemetry for excessive sensitive data and unbounded cardinality.

**Exceptions:** Highly constrained offline tools may use an explicit result artifact instead of continuous telemetry.

### ENGINEERING-QUALITY-008 — Release only the reviewed final state

**Level:** required
**Applies when:** Approving a build, deployment, package, or handoff.

Run risk-matched checks on the final integrated artifact, inspect intended behavior, record unresolved limitations, and bind approval to the exact version released.

**Why:** Earlier passing evidence can become stale after integration, configuration, or packaging changes.

**Verify:**

- Match check output, reviewer approval, artifact identity, configuration, and deployment record.
- Confirm rollback, monitoring, and ownership remain valid for that version.

**Exceptions:** None for a production release; an emergency release follows the governed emergency process.

## Guidance

Prefer the simplest design that meets measured needs. Add abstraction only when it removes current duplication, isolates a real boundary, or enables an explicit requirement. Treat generated code and AI-authored changes as authored work subject to the same review and evidence.

## Examples

### New serialization library

Non-compliant: Add a large package because its API is convenient and rely on the package lock alone.

Compliant: Compare the existing capability and candidate package, inspect the resolved graph and license, constrain its use behind the serialization boundary, test malformed data and upgrade behavior, and record the removal path.

## Sources

- National Institute of Standards and Technology, [Secure Software Development Framework Version 1.1](https://csrc.nist.gov/pubs/sp/800/218/final). Reviewed August 13, 2026.
- Open Source Security Foundation, [Supply-chain Levels for Software Artifacts 1.0](https://slsa.dev/spec/v1.0/). Reviewed August 13, 2026.
- Cybersecurity and Infrastructure Security Agency, [Secure by Design](https://www.cisa.gov/securebydesign). Reviewed August 13, 2026.
