---
id: OPERATIONS-RELIABILITY
title: Operations and reliability
description: Requirements for service objectives, observability, runbooks, incidents, recovery, support, and vendor dependencies.
type: standard
status: draft
governance_status: draft
owners: [operations, engineering, security, support]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [service-operation, incident, vendor-change]
tags: [operations, reliability, incidents, support]
depends_on: [FND-EVIDENCE, FND-CHANGE, ENGINEERING-QUALITY]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: nist-csf-20
    resource: https://www.nist.gov/cyberframework
    title: Cybersecurity Framework 2.0
    author: organization:nist
  - id: nist-incident-800-61r3
    resource: https://csrc.nist.gov/pubs/sp/800/61/r3/final
    title: Incident Response Recommendations and Considerations for Cybersecurity Risk Management
    author: organization:nist
  - id: google-sre
    resource: https://sre.google/sre-book/table-of-contents/
    title: Site Reliability Engineering
    author: organization:google
  - id: nist-supply-chain-800-161r1
    resource: https://csrc.nist.gov/pubs/sp/800/161/r1/final
    title: Cybersecurity Supply Chain Risk Management Practices for Systems and Organizations
    author: organization:nist
---

# Operations and reliability

Services must define the outcomes they protect, detect material degradation, provide practiced response and recovery, support affected users, and govern external dependencies throughout their lifecycle.

## Rules

### OPERATIONS-RELIABILITY-001 — Define service objectives from user outcomes

**Level:** required
**Applies when:** A service supports production users, business processes, or dependent systems.

Define the critical journeys and measurable availability, correctness, latency, durability, and recovery objectives that protect them, including the population and measurement window.

**Why:** Infrastructure health can appear normal while users cannot complete the service's purpose.

**Verify:**

- Reproduce each objective from recorded events and compare it with representative user experience.
- Confirm owners and decision rules for budget consumption or objective breach.

**Exceptions:** A low-impact internal service may use simpler objectives when users, impact, and support expectations are explicit.

### OPERATIONS-RELIABILITY-002 — Observe symptoms, causes, and dependencies

**Level:** required
**Applies when:** A service can degrade outside direct operator observation.

Collect bounded, protected signals for user-visible outcomes, traffic, errors, latency, saturation, change events, and critical dependencies with enough context to scope a failure.

**Why:** Cause-only monitoring misses unknown failures and symptom-only monitoring slows diagnosis.

**Verify:**

- Inject or simulate representative dependency, capacity, configuration, correctness, and availability failures.
- Confirm dashboards and traces distinguish affected journeys, tenants, regions, versions, and dependencies where permitted.

**Exceptions:** None for critical production services.

### OPERATIONS-RELIABILITY-003 — Alert only when action is defined

**Level:** required
**Applies when:** A signal can page or interrupt a responder.

Tie alerts to material impact or imminent risk, an owned response, severity, routing, deduplication, and escalation. Review false, missed, noisy, and unactionable alerts.

**Why:** Alert volume without actionable meaning delays response and trains responders to ignore signals.

**Verify:**

- Trigger representative alerts and follow routing through acknowledgment and escalation.
- Inspect alert history for sustained noise, gaps, and response outcomes.

**Exceptions:** Experimental alerts may be non-paging while thresholds are calibrated.

### OPERATIONS-RELIABILITY-004 — Maintain executable runbooks

**Level:** required
**Applies when:** Diagnosis, containment, recovery, failover, or support depends on non-obvious operational steps.

Document triggers, authority, prerequisites, safe commands or actions, expected output, stop conditions, communication, rollback, verification, and escalation using current system names and access paths.

**Why:** A stale or ambiguous runbook increases error during time pressure.

**Verify:**

- Have a responder other than the author execute or simulate the procedure.
- Review runbooks after system changes, exercises, and incidents.

**Exceptions:** A fully automated procedure still requires an operator contract and manual containment path.

### OPERATIONS-RELIABILITY-005 — Govern incident command and communication

**Level:** required
**Applies when:** An event materially threatens confidentiality, integrity, availability, safety, money, or user trust.

Assign incident command, severity, technical and communication roles, decision log, containment authority, update cadence, stakeholder routes, evidence preservation, and closure criteria.

**Why:** Unclear authority and inconsistent communication compound impact and lose decision evidence.

**Verify:**

- Exercise the incident process with technical, security, privacy, support, legal, and business participants appropriate to impact.
- Confirm external statements distinguish confirmed facts, current impact, actions, and uncertainty.

**Exceptions:** Small events may combine roles but must retain one accountable commander and decision record.

### OPERATIONS-RELIABILITY-006 — Practice recovery against objectives

**Level:** required
**Applies when:** A service or dependency has recovery point, recovery time, continuity, or failover expectations.

Exercise recovery from isolated, partial, regional, corrupted, unavailable, and dependency-loss conditions as applicable, measuring achieved outcome rather than procedure completion alone.

**Why:** Backups and failover configurations can exist without restoring a usable service in time.

**Verify:**

- Record recovered data and function, elapsed time, unmet dependencies, manual work, and objective comparison.
- Confirm return-to-normal avoids split state, repeated side effects, and hidden degradation.

**Exceptions:** None for critical durable services; untested paths must be treated as unresolved risk.

### OPERATIONS-RELIABILITY-007 — Learn without distorting incident evidence

**Level:** required
**Applies when:** An incident or near miss reveals a material control, design, process, or organizational weakness.

Build a factual timeline, distinguish contributing conditions from triggers, identify detection and response gaps, assign bounded corrective work, and verify whether the change reduced recurrence or impact.

**Why:** Blame or a single root-cause label hides system conditions and produces weak corrective actions.

**Verify:**

- Trace conclusions to logs, artifacts, interviews, and decisions with stated uncertainty.
- Follow corrective actions through acceptance evidence and later effectiveness review.

**Exceptions:** Sensitive details may be access-controlled, but affected owners still need actionable findings.

### OPERATIONS-RELIABILITY-008 — Support affected users through recovery

**Level:** required
**Applies when:** Users may encounter failure, delay, data inconsistency, or degraded behavior.

Give support current impact, affected scope, safe workarounds, escalation, communication status, and recovery verification without exposing protected incident details.

**Why:** Technical recovery is incomplete when users cannot understand or resolve their remaining state.

**Verify:**

- Exercise a representative support case from report through resolution and correction.
- Reconcile technical recovery with customer accounts, messages, credits, or follow-up where applicable.

**Exceptions:** None when users retain an unresolved material effect.

### OPERATIONS-RELIABILITY-009 — Govern vendor dependencies

**Level:** required
**Applies when:** An external provider can affect critical function, data, security, compliance, cost, or recovery.

Record purpose, owner, data and authority, contract and service expectations, concentration risk, monitoring, incident contact, portability, termination, data return or deletion, and tested fallback or accepted dependency risk.

**Why:** Outsourcing operation does not transfer accountability and can create opaque single points of failure.

**Verify:**

- Review provider evidence and exercise outage, degraded service, credential compromise, contract change, and exit scenarios proportionate to risk.
- Confirm inventory and access are removed after termination.

**Exceptions:** Commodity low-impact services may use a standardized review when impact and replaceability are proven.

## Guidance

Use service objectives to make tradeoffs, not to excuse preventable harm. Prefer fewer meaningful alerts and rehearsed actions. Treat incidents as user and business events as well as technical failures, and preserve privacy when collecting operational evidence.

## Examples

### Vendor outage

Non-compliant: The team learns from customer reports that a single messaging provider is unavailable and has no way to identify undelivered critical messages.

Compliant: Delivery outcomes are monitored, affected messages are reconciled, the runbook defines containment and fallback, support has current guidance, and the vendor dependency and accepted residual risk have an owner.

## Sources

- National Institute of Standards and Technology, [Cybersecurity Framework 2.0](https://www.nist.gov/cyberframework). Reviewed August 13, 2026.
- National Institute of Standards and Technology, [Incident Response Recommendations and Considerations for Cybersecurity Risk Management](https://csrc.nist.gov/pubs/sp/800/61/r3/final), SP 800-61 Rev. 3. Reviewed August 13, 2026.
- Google, [Site Reliability Engineering](https://sre.google/sre-book/table-of-contents/). Reviewed August 13, 2026.
- National Institute of Standards and Technology, [Cybersecurity Supply Chain Risk Management Practices for Systems and Organizations](https://csrc.nist.gov/pubs/sp/800/161/r1/final), SP 800-161 Rev. 1. Reviewed August 13, 2026.
