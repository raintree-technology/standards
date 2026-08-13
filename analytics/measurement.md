---
id: ANALYTICS-MEASUREMENT
title: Product and growth measurement
description: Defines decision-driven, interpretable, privacy-conscious product and growth instrumentation.
type: standard
status: stable
governance_status: active
owners: [analytics, product]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [product-feature, growth-experiment, public-web-page]
tags: [analytics, events, metrics, privacy]
depends_on: [FND-EVIDENCE, FND-TRUST, DATA-QUALITY]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: ico-purpose-limitation
    resource: https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/purpose-limitation/
    title: Purpose limitation
    author: organization:ico
  - id: ico-data-minimisation
    resource: https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/data-minimisation/
    title: Data minimisation
    author: organization:ico
  - id: owasp-logging
    resource: https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html
    title: Logging Cheat Sheet
    author: organization:owasp
  - id: w3c-privacy-principles
    resource: https://www.w3.org/TR/privacy-principles/
    title: Privacy Principles
    author: organization:w3c
  - id: opentelemetry-events
    resource: https://opentelemetry.io/docs/specs/semconv/general/events/
    title: Semantic conventions for events
    author: organization:opentelemetry
  - id: opentelemetry-stability
    resource: https://opentelemetry.io/docs/specs/otel/versioning-and-stability/
    title: Versioning and stability for OpenTelemetry clients
    author: organization:opentelemetry
---

# Product and growth measurement

Instrumentation must produce interpretable evidence for a defined decision without collecting data merely because it might be useful later. This standard governs behavioral events, properties, identity, metrics, funnels, cohorts, dashboards, and measurement changes.

## Rules

### ANALYTICS-MEASUREMENT-001 — Start with a decision

**Level:** required
**Applies when:** Adding or materially changing an event, property, dashboard, or metric.

Document the decision the measurement supports, the question it answers, its owner, and the action that materially different outcomes would trigger.

**Why:** Data without a decision purpose creates collection cost and privacy risk without a clear way to act.

**Verify:**

- Trace the proposed event or metric to a named decision and owner.
- Confirm at least two plausible outcomes have stated interpretations or actions.

**Exceptions:** Operational telemetry can support incident detection rather than a product decision; identify the operational purpose and retention policy.

### ANALYTICS-MEASUREMENT-002 — Give events stable semantic contracts

**Level:** required
**Applies when:** Instrumenting behavioral events.

Define the trigger, actor, object, event time, processing time, required and optional properties, allowed values, identity semantics, source, owner, and versioning policy. Name the observed fact rather than an implementation detail.

**Why:** The same event name can otherwise represent different actions across clients, releases, and analysts.

**Verify:**

- Trigger the event from each producing path and compare it with the contract.
- Confirm retries, refreshes, duplicate callbacks, and background work cannot silently change the event's meaning.

**Exceptions:** None for events used in decisions or reporting.

### ANALYTICS-MEASUREMENT-003 — Validate the full measurement path

**Level:** required
**Applies when:** Shipping new or changed instrumentation.

Verify that the real user or system action emits the expected number of correctly shaped events, reaches the intended destination, respects consent, and appears in downstream analysis with correct identity and time semantics.

**Why:** Client logs or network requests do not prove that ingestion, transformation, identity stitching, and reporting preserve the event.

**Verify:**

- Follow a known event from source through ingestion, transformation, storage, and a representative query or dashboard.
- Check positive, absent-consent, duplicate, retry, offline, and failure behavior where relevant.

**Exceptions:** If production validation is unsafe, use staging and report differences in endpoints, consent, volume, identity, or transformations.

### ANALYTICS-MEASUREMENT-004 — Minimize collected and exposed data

**Level:** required
**Applies when:** Choosing event properties, identity data, or analytics access.

Collect only the fields needed for the documented purpose. Do not send secrets, credentials, session tokens, unrestricted URLs, free-form user content, or unnecessary personal data. Restrict access and precision to what the decision requires.

**Why:** Extra fields increase breach, misuse, retention, and re-identification risk without improving the stated decision.

**Verify:**

- Review actual payloads and downstream tables, not only the tracking plan.
- Justify each sensitive, identifying, or high-cardinality property against the decision purpose.
- Confirm access controls and redaction apply in debug and export paths.

**Exceptions:** A legally approved purpose can require sensitive data; record the governing policy, access boundary, and retention rule.

### ANALYTICS-MEASUREMENT-005 — Define denominator, eligibility, and time

**Level:** required
**Applies when:** Reporting a rate, funnel, cohort, retention value, or experiment outcome.

State who can enter the metric, the numerator, denominator, identity unit, time zone, event-time or processing-time basis, window, exclusions, repeated-action handling, and late-arriving-data policy.

**Why:** A metric name alone cannot reveal who had an opportunity to act or when an outcome counts.

**Verify:**

- Reproduce the metric from its written definition and source data.
- Test boundary cases at window edges, identity changes, repeated events, and delayed ingestion.

**Exceptions:** A raw count can omit a denominator but must still define unit, scope, and time window.

### ANALYTICS-MEASUREMENT-006 — Make identity behavior explicit

**Level:** required
**Applies when:** Measurement spans anonymous and authenticated use, devices, accounts, workspaces, or shared entities.

Define when identifiers are created, linked, split, reset, deleted, and used as the unit of analysis. Avoid retroactive stitching that changes historical populations without an explicit policy.

**Why:** Identity rules can double-count people, merge different users, or rewrite historical metrics after sign-in.

**Verify:**

- Exercise sign-in, sign-out, account switching, shared-device, deletion, and merge behavior relevant to the product.
- Compare event-level identifiers with the metric's declared analysis unit.

**Exceptions:** Anonymous aggregate measurement can omit identity rules when no persistent or linkable identifier exists.

### ANALYTICS-MEASUREMENT-007 — Version meaning changes

**Level:** required
**Applies when:** A trigger, property, identity rule, transformation, or metric definition changes meaning.

Version the contract or create a new event or metric. Record the effective time, migration behavior, dashboard impact, and whether old and new values can be compared.

**Why:** Silent semantic changes create plausible-looking time series that combine unlike data.

**Verify:**

- Inspect the change record and downstream queries for the version boundary.
- Confirm dashboards annotate, split, or restate history according to the compatibility decision.

**Exceptions:** A correction that restores the documented meaning can retain the version when affected data is backfilled or clearly annotated.

### ANALYTICS-MEASUREMENT-008 — Monitor data quality and ownership

**Level:** required
**Applies when:** A metric or event informs recurring decisions, experiments, financial reporting, or critical operations.

Assign an owner and monitor expected volume, schema, null rates, duplicates, freshness, and key distribution changes. Define escalation and deprecation paths.

**Why:** Instrumentation can degrade silently while dashboards continue to render.

**Verify:**

- Inspect quality checks and alert routing for the event or dataset.
- Confirm the owner can identify producers, consumers, retention, and dependent decisions.

**Exceptions:** Short-lived exploratory instrumentation can use a manual review if it has an expiration date and is excluded from durable reporting.

### ANALYTICS-MEASUREMENT-009 — Define retention and deletion behavior

**Level:** required
**Applies when:** Analytics stores identifiers, personal data, or detailed behavioral history.

Set retention according to the stated purpose and governing policy. Define deletion, anonymization, export, and downstream propagation behavior before collection begins.

**Why:** Data cannot be minimized or user rights honored when copies and retention periods are unknown.

**Verify:**

- Trace a deletion or expiration through raw, transformed, exported, and backup data according to policy.
- Confirm retention configuration matches the documented period.

**Exceptions:** Legal preservation requirements override routine deletion only within their documented scope and duration.

### ANALYTICS-MEASUREMENT-010 — Bound names, values, and cardinality

**Level:** required
**Applies when:** Defining event names, property names, identifiers, arrays, free-form values, or dimensions used for grouping and filtering.

Keep event and property names stable and free of dynamic values. Use typed, bounded values and documented enumerations where practical. Identify and control fields whose unique values, length, or nested structure can grow without a known limit.

**Why:** Dynamic names and unbounded values create unpredictable cost, slow or unusable queries, accidental personal-data capture, and contracts that consumers cannot enumerate.

**Verify:**

- Measure observed and expected cardinality, value size, array length, and payload size for representative and worst-case inputs.
- Confirm identifiers and free-form content appear in governed properties rather than names.
- Test unknown enumeration values and forward-compatible consumers.

**Exceptions:** A high-cardinality identifier can be collected when the documented decision requires record-level correlation and access, retention, and cost controls are explicit.

### ANALYTICS-MEASUREMENT-011 — Preserve transformation lineage

**Level:** required
**Applies when:** Raw events are cleaned, joined, filtered, sampled, modeled, aggregated, corrected, or exported before a decision uses them.

Record the source datasets, transformation version, filters, joins, identity rules, sampling or weighting, correction logic, and effective period. Make it possible to trace a reported value back to the producing contracts and code.

**Why:** A stable dashboard can change meaning because of an upstream model or identity transformation that the metric definition does not reveal.

**Verify:**

- Follow a representative result from report to model, transformed data, raw events, and producing code.
- Reconcile row counts and exclusions at material transformation boundaries.
- Confirm version changes are reviewable and annotated under `ANALYTICS-MEASUREMENT-007`.

**Exceptions:** A one-time exploratory analysis can preserve its query and input snapshot instead of a maintained lineage system.

### ANALYTICS-MEASUREMENT-012 — Treat linkable data as sensitive

**Level:** required
**Applies when:** Data is pseudonymous, hashed, device-linked, precise, or combinable with other data to identify or single out a person or household.

Do not describe linkable data as anonymous solely because direct names or emails were removed. Apply purpose, access, retention, deletion, and sharing controls according to its realistic re-identification and inference risk.

**Why:** Persistent identifiers and detailed behavior can remain personal or sensitive through linkage even without obvious identity fields.

**Verify:**

- Review what internal and external datasets can be joined to the analytics data.
- Inspect uniqueness, precision, persistence, and small-group reporting for singling-out risk.
- Confirm privacy descriptions and access controls match the actual linkage capability.

**Exceptions:** Data can be treated as de-identified only through the governing privacy process and its required technical and contractual controls.

## Guidance

Prefer events that describe completed facts, such as `report_exported`, over interface implementation, such as `export_button_clicked`, unless the click itself is the decision-relevant fact. Record failures separately from successful outcomes.

Keep properties typed and bounded. Use enumerations for known states, explicit units for quantities, and stable IDs rather than display names. High-cardinality free text is difficult to govern and often captures unintended personal data.

Treat dashboards as views over governed definitions, not as the definition itself. Keep semantic contracts close to the code or data model and make changes reviewable.

## Examples

### Event contract

Non-compliant: `signup` fires when the page loads for some clients and when account creation succeeds for others.

Compliant: `account_created` fires once after durable account creation. Its contract defines the account as the analysis unit, server event time, allowed acquisition-source values, and retry deduplication key.

### Rate definition

Non-compliant: “Activation rate = activated users / users.”

Compliant: “Weekly activation rate is the number of new workspaces created in UTC during the week that publish one item within seven complete days, divided by eligible workspaces created in that week. Internal, deleted-before-publication, and imported workspaces are excluded.”

## Sources

- UK Information Commissioner's Office, [Purpose limitation](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/purpose-limitation/). Reviewed August 13, 2026.
- UK Information Commissioner's Office, [Data minimisation](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/data-minimisation/). Reviewed August 13, 2026.
- OWASP Foundation, [Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html). Reviewed August 13, 2026.
- World Wide Web Consortium, [Privacy Principles](https://www.w3.org/TR/privacy-principles/), May 15, 2025. Reviewed August 13, 2026.
- OpenTelemetry, [Semantic conventions for events](https://opentelemetry.io/docs/specs/semconv/general/events/), Semantic Conventions 1.43.0. Reviewed August 13, 2026. This source governs telemetry rather than product analytics directly; this standard adopts its event-contract principles where the concepts overlap.
- OpenTelemetry, [Versioning and stability for OpenTelemetry clients](https://opentelemetry.io/docs/specs/otel/versioning-and-stability/). Reviewed August 13, 2026.
