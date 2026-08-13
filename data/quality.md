---
id: DATA-QUALITY
title: Data quality and lifecycle
description: Requirements for meaningful, owned, traceable, validated, and governed data products.
type: standard
status: draft
governance_status: draft
owners: [data, analytics, engineering, privacy]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [data-model, data-pipeline, data-product]
tags: [data, quality, lineage, lifecycle]
depends_on: [FND-EVIDENCE, FND-CHANGE, PRIVACY-DATA]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: uk-data-quality-framework
    resource: https://www.gov.uk/government/publications/the-government-data-quality-framework
    title: The Government Data Quality Framework
    author: organization:uk-government
  - id: w3c-prov-o
    resource: https://www.w3.org/TR/prov-o/
    title: PROV-O The PROV Ontology
    author: organization:w3c
  - id: nist-data-integrity
    resource: https://csrc.nist.gov/pubs/sp/1800/25/final
    title: Data Integrity Identifying and Protecting Assets Against Ransomware and Other Destructive Events
    author: organization:nist
---

# Data quality and lifecycle

Data products must preserve defined meaning, provenance, fitness for use, and accountable ownership from collection through transformation, sharing, retention, and disposal.

## Rules

### DATA-QUALITY-001 — Define meaning and intended decisions

**Level:** required
**Applies when:** Creating or materially changing a dataset, field, metric, model, or data product.

Define the business meaning, unit, population, grain, valid values, time semantics, source, intended decisions, and known unsuitable uses.

**Why:** Technically valid values can still be interpreted incorrectly when their meaning and decision scope are implicit.

**Verify:**

- Trace representative fields and metrics to their definitions and intended decisions.
- Confirm producers and consumers agree on grain, time, null, and update semantics.

**Exceptions:** Raw landing data may defer normalized meaning when provenance, access, retention, and promotion controls are explicit.

### DATA-QUALITY-002 — Assign accountable ownership

**Level:** required
**Applies when:** Data is relied on by another team, product, report, model, or operational process.

Assign owners for meaning, production, access, quality incidents, retention, and consumer communication, with a maintained contact and escalation route.

**Why:** Shared data degrades when no one owns definitions, failures, or breaking changes.

**Verify:**

- Inspect the catalog or contract for current owners and response expectations.
- Exercise escalation for a representative quality failure.

**Exceptions:** None for production data products.

### DATA-QUALITY-003 — Preserve end-to-end lineage

**Level:** required
**Applies when:** Data is copied, joined, aggregated, inferred, corrected, or exported.

Record material sources, transformations, versions, filters, joins, models, destinations, and processing times so a result can be traced backward and impact can be traced forward.

**Why:** Without lineage, errors cannot be scoped, reproduced, corrected, or communicated reliably.

**Verify:**

- Trace a representative published value to source records and transformation versions.
- Identify affected consumers from a simulated source or definition change.

**Exceptions:** Protected lineage details may use access-controlled references rather than public documentation.

### DATA-QUALITY-004 — Set measurable quality expectations

**Level:** required
**Applies when:** Data supports a release, operational process, customer experience, financial result, or material decision.

Define and monitor the relevant completeness, validity, consistency, uniqueness, timeliness, accuracy, and reconciliation expectations with thresholds tied to use.

**Why:** A generic quality score hides which failure would invalidate a particular decision.

**Verify:**

- Run checks on representative normal, late, missing, duplicate, malformed, and conflicting data.
- Confirm threshold breaches reach an owner and stop or qualify affected use.

**Exceptions:** Accuracy that cannot be measured directly requires a documented proxy, sampling method, and limitation.

### DATA-QUALITY-005 — Reconcile boundaries and durable outcomes

**Level:** required
**Applies when:** Data crosses systems, batches, queues, financial boundaries, or mutable source states.

Account for accepted, rejected, duplicated, delayed, corrected, and missing records and reconcile totals and material invariants at defined boundaries.

**Why:** Successful jobs can still silently lose, repeat, or reinterpret data between stages.

**Verify:**

- Compare boundary counts, control totals, identifiers, and sampled meaning.
- Exercise replay, late arrival, duplicate delivery, and partial failure.

**Exceptions:** None when the data represents money, rights, safety, or irreversible user effects.

### DATA-QUALITY-006 — Govern schema and meaning changes

**Level:** required
**Applies when:** Producers can change fields, values, timing, identity, or interpretation used by consumers.

Version material changes, assess affected consumers, provide a compatibility or migration period, and confirm adoption before removing the old meaning.

**Why:** A schema can remain parseable while silently changing the decisions produced from it.

**Verify:**

- Run consumer contract checks and compare old and new results on representative data.
- Inspect usage and owner approval before retirement.

**Exceptions:** Emergency correction of dangerously wrong data may shorten migration when affected consumers and remediation are recorded.

### DATA-QUALITY-007 — Control correction and deletion through derived copies

**Level:** required
**Applies when:** Source data can be corrected, restricted, expired, or deleted.

Propagate the required change through caches, indexes, aggregates, exports, models, backups, and downstream recipients or record why a copy is lawfully retained and isolated.

**Why:** Correcting only the source leaves inconsistent or prohibited derived data in active use.

**Verify:**

- Exercise a representative correction and deletion across every material copy.
- Confirm downstream completion, exceptions, and reconciliation evidence.

**Exceptions:** Immutable audit or backup copies may follow a documented retention and access regime that prevents ordinary use.

### DATA-QUALITY-008 — Make quality incidents recoverable

**Level:** required
**Applies when:** Incorrect data can propagate to decisions, users, models, or external recipients.

Provide detection, quarantine, stop, replay or correction, consumer notification, and post-recovery verification procedures proportionate to impact.

**Why:** Fast pipelines amplify defects unless they can stop and repair affected state.

**Verify:**

- Rehearse a representative late, corrupt, duplicated, and semantically wrong input.
- Confirm recovery does not overwrite newer valid data or repeat external effects.

**Exceptions:** None for high-impact data products.

## Guidance

Quality is fitness for a declared use, not perfection in the abstract. Keep raw evidence where justified, but prevent unreviewed raw data from becoming an authoritative decision source. Treat inferred and modeled attributes as data products with provenance and uncertainty.

## Examples

### Revenue dataset

Non-compliant: A dashboard sums charge events without refunds, currency normalization, deduplication, or a defined recognition date.

Compliant: The metric contract defines recognized revenue, currency conversion, grain, refunds, late events, deduplication, reconciliation to the payment system, owner, and permitted decisions.

## Sources

- UK Government, [The Government Data Quality Framework](https://www.gov.uk/government/publications/the-government-data-quality-framework). Reviewed August 13, 2026.
- World Wide Web Consortium, [PROV-O: The PROV Ontology](https://www.w3.org/TR/prov-o/). Reviewed August 13, 2026.
- National Institute of Standards and Technology, [Data Integrity: Identifying and Protecting Assets Against Ransomware and Other Destructive Events](https://csrc.nist.gov/pubs/sp/1800/25/final). Reviewed August 13, 2026.
