---
id: PRIVACY-DATA
title: Personal data handling
description: Governs purpose, minimization, choice, rights, retention, sharing, and privacy risk for personal data.
type: standard
status: draft
governance_status: draft
owners: [privacy, legal, product, security]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [product-feature, growth-experiment, public-web-page, database-change]
tags: [privacy, personal-data, consent, retention, rights]
depends_on: [FND-TRUST, FND-EVIDENCE, FND-CHANGE]
generated: { by: codex/gpt-5, at: "2026-08-13T19:35:12Z" }
sources:
  - id: nist-privacy-framework-1
    resource: https://www.nist.gov/document/nist-privacy-frameworkv10pdf
    title: NIST Privacy Framework, Version 1.0
    author: organization:nist
  - id: w3c-privacy-principles
    resource: https://www.w3.org/TR/privacy-principles/
    title: Privacy Principles
    author: organization:w3c
  - id: ico-data-protection-principles
    resource: https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/
    title: A guide to the data protection principles
    author: organization:ico
  - id: ico-data-protection-design-default
    resource: https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/guide-to-accountability-and-governance/data-protection-by-design-and-by-default/
    title: Data protection by design and by default
    author: organization:ico
  - id: ico-dpia
    resource: https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/guide-to-accountability-and-governance/data-protection-impact-assessments/
    title: Data protection impact assessments
    author: organization:ico
  - id: openai-data-controls
    resource: https://developers.openai.com/api/docs/guides/your-data
    title: Data controls in the OpenAI platform
    author: organization:openai
---

# Personal data handling

Personal-data processing must have a defined purpose, a governing authority, privacy-protective defaults, and verifiable controls across its full life cycle. This standard applies to data that identifies, relates to, describes, can be linked to, or can reasonably single out a person or household, including inferred and pseudonymous data.

This standard does not determine which laws apply or provide legal advice. Record the governing law, contract, organization policy, and qualified privacy or legal decision where they set a specific obligation. A stricter applicable requirement takes precedence.

## Rules

### PRIVACY-DATA-001 — Map the processing before implementation

**Level:** required  
**Applies when:** A system collects, receives, derives, stores, uses, discloses, transfers, or deletes personal data.

Maintain a processing record that identifies the people affected; data categories, including inferences and linkable identifiers; source; purpose; processing operations; systems and locations; recipients; organization role; owner; access groups; retention; deletion path; and governing policy or decision.

**Why:** Privacy controls cannot cover data flows, copies, or responsibilities that remain unknown.

**Verify:**

- Trace representative data from collection or receipt through storage, use, logs, exports, recipients, backups, and deletion.
- Compare the record with actual schemas, payloads, network destinations, access configuration, and vendor settings.
- Confirm every processing operation and recipient has a named owner and stated purpose.

**Exceptions:** An incident can require immediate containment before the record is complete; document the emergency processing and reconcile the record during response.

### PRIVACY-DATA-002 — Establish authority for each purpose

**Level:** required  
**Applies when:** Personal-data processing is proposed or its purpose, data, people, recipient, location, or decision impact materially changes.

Record the permitted purpose and the law, contract, organization policy, or qualified privacy or legal decision that authorizes it before processing begins. Do not treat product value, technical availability, a privacy notice, or consent language alone as authority when the governing regime requires another condition.

**Why:** A technically possible data use can still be unlawful, unfair, contractually barred, or outside what people reasonably expect.

**Verify:**

- Link each purpose in the processing record to a current governing source and responsible decision owner.
- Confirm the authority covers the actual data categories, people, operations, recipients, and locations.
- Check changes against the original scope before reusing existing data.

**Exceptions:** Urgent processing needed to protect a person or respond to an incident must follow the applicable emergency authority and receive retrospective qualified review.

### PRIVACY-DATA-003 — Minimize data and exposure by default

**Level:** required  
**Applies when:** Choosing data to collect, derive, retain, expose, request, or share.

Use only the data, precision, identifiability, frequency, and retention needed for the recorded purpose. Choose local, aggregate, coarse, ephemeral, or user-supplied data over persistent or inferred data when those choices meet the purpose. Default optional processing and access to off or the narrowest scope.

**Why:** Each extra field, copy, recipient, and unit of precision increases misuse, breach, inference, and re-identification risk.

**Verify:**

- Justify each personal-data field and inference against the recorded purpose.
- Inspect actual payloads, tables, logs, exports, and default settings for undisclosed or unnecessary fields.
- Test whether the purpose still works after removing, coarsening, aggregating, shortening, or processing data locally.

**Exceptions:** A broader scope requires a documented necessity, the governing approval, and controls proportionate to the added risk.

### PRIVACY-DATA-004 — Control secondary use and purpose changes

**Level:** required  
**Applies when:** Existing personal data may be used for a purpose, model, audience, recipient, or decision not covered by its original record.

Do not begin the new use until a qualified owner assesses compatibility with the original purpose and authority, updates the processing record, provides any required notice or choice, and approves added safeguards. Keep data collected for safety or abuse prevention from being reused for unrelated growth, evaluation, or profiling without separate authority.

**Why:** Quiet repurposing defeats meaningful expectations and can turn a defensible collection into harmful surveillance.

**Verify:**

- Compare the proposed use, people, data, context, consequences, and recipients with the original record.
- Inspect data contracts, access grants, joins, feature pipelines, and exports for unrecorded reuse.
- Confirm notices, controls, retention, and deletion behavior match the approved purpose change.

**Exceptions:** None without the governing privacy or legal decision.

### PRIVACY-DATA-005 — Explain processing at the relevant time

**Level:** required  
**Applies when:** Personal data is collected, requested, inferred, shared, or used in a way a person may not reasonably expect.

Present accurate, plain-language information close to the relevant interaction. Explain what data is involved, why it is needed, important recipients, material consequences, retention or its determining criteria, available choices and rights, and how to exercise them. The explanation must match actual behavior and remain available after the interaction.

**Why:** A distant or vague policy does not support an informed decision at the point where data changes hands.

**Verify:**

- Compare the rendered explanation with observed storage, network, sharing, and retention behavior.
- Confirm a person can find material information before providing data or enabling optional processing.
- Recheck the explanation after changes to purpose, recipients, controls, or retention.

**Exceptions:** A qualified decision can delay a notice where immediate disclosure would defeat a lawful investigation or create a documented safety risk; record when and how notice will occur.

### PRIVACY-DATA-006 — Make consent specific and reversible

**Level:** required  
**Applies when:** The governing privacy or legal process selects consent as the authority or required control for processing.

Request an informed, specific, affirmative choice for each materially distinct optional purpose. Do not use silence, preselected controls, bundled unrelated purposes, misleading emphasis, or service denial for processing that is not needed to provide the requested service. Record the consent version, purposes, time, and method. Make review and withdrawal no harder than giving consent, and stop future processing promptly across recipients and systems.

**Why:** Consent that does not reveal a person's intent is not a reliable control and shifts privacy work onto the person.

**Verify:**

- Exercise accept, reject, partial choice, later review, and withdrawal paths in the final interface.
- Confirm optional processing stays off before consent and stops after withdrawal, including queued work and downstream recipients.
- Inspect the consent record and notice version needed to prove what the person chose.

**Exceptions:** Consent is not required when a different recorded authority governs the processing, but applicable notice, objection, minimization, and rights rules still apply.

### PRIVACY-DATA-007 — Support applicable data rights end to end

**Level:** required  
**Applies when:** Governing law, contract, policy, or product commitment grants access, correction, deletion, portability, restriction, objection, or opt-out rights.

Provide an owned request process that verifies identity in proportion to the disclosure or action risk, searches every in-scope system and recipient, applies the correct action, records exceptions, meets the governing deadline, and gives a clear response. Do not collect more identity evidence than the request requires or use the process to discourage a valid request.

**Why:** A front-end request form does not honor a right if copies, vendors, derived data, or deadlines are missed.

**Verify:**

- Run representative requests through intake, identity checks, system discovery, action, recipient propagation, and response.
- Reconcile found, corrected, exported, retained, and deleted records against the processing map.
- Confirm refusals, partial actions, and legal holds cite their authority and receive required review.

**Exceptions:** Follow the governing exception or refusal process; record its basis, scope, approver, notice, and review path.

### PRIVACY-DATA-008 — Enforce retention and deletion across copies

**Level:** required  
**Applies when:** Personal data is stored, cached, logged, exported, backed up, or held by a recipient.

Set a retention period or objective deletion trigger for each purpose before collection. Delete, de-identify under an approved process, or return data when the purpose or authority ends. Cover raw, derived, indexed, cached, logged, exported, backup, and recipient copies, and prevent deleted data from silently returning during restoration.

**Why:** A policy period has no effect unless every material copy expires and restoration preserves deletion state.

**Verify:**

- Compare configured expiration and deletion jobs with the processing record.
- Trace a representative expiration or deletion through primary, downstream, vendor, and backup handling.
- Reconcile eligible, processed, failed, excepted, and remaining records and monitor recurring jobs.

**Exceptions:** A legal hold or other governing preservation duty may suspend deletion only for the defined data, purpose, people, and period; restrict access and resume deletion when the hold ends.

### PRIVACY-DATA-009 — Preserve accuracy, provenance, and correction

**Level:** required  
**Applies when:** Personal data or an inference affects a user-facing state, eligibility, safety action, material decision, or disclosure.

Record the source, observation or inference status, relevant time, and known limits. Keep data accurate enough for its purpose, expose or route correction when applicable, and propagate material corrections to dependent systems and recipients. Do not present an inference as a verified fact.

**Why:** Stale, misattributed, or inferred data can cause denial, embarrassment, unsafe action, or repeated harm across copied systems.

**Verify:**

- Test correction and propagation for a representative record and dependent outcome.
- Inspect high-impact uses for source, freshness, confidence, and human review where required.
- Confirm interfaces and exports distinguish supplied, observed, calculated, and inferred values when that distinction matters.

**Exceptions:** An immutable audit record can preserve the original event while attaching the correction and preventing the incorrect value from driving current decisions.

### PRIVACY-DATA-010 — Treat pseudonymous and linkable data as personal

**Level:** required  
**Applies when:** Direct identifiers are removed, transformed, hashed, tokenized, aggregated, or kept separately.

Assess realistic singling-out, linkage, inference, and reversal risk using internal and reasonably available external data. Continue personal-data controls for pseudonymous or linkable data. Describe data as de-identified only when a qualified process defines the threat model, technical transformation, access and disclosure limits, re-identification prohibition, review interval, and response to increased linkage risk.

**Why:** Removing a name does not prevent a persistent identifier, unique behavior, small group, or auxiliary dataset from identifying a person.

**Verify:**

- Test uniqueness, small groups, precision, persistence, join paths, and access to separation keys.
- Inspect contracts and access controls for re-identification restrictions and onward disclosure.
- Reassess after new datasets, recipients, attacks, or business uses change the threat model.

**Exceptions:** None for data that remains reasonably linkable under the governing assessment.

### PRIVACY-DATA-011 — Assess heightened and collective harm

**Level:** required  
**Applies when:** Processing involves sensitive context or data, children, people with reduced power or safety options, precise location, communications, biometrics, finances, health, protected traits, third-party data, or group-level inference.

Obtain qualified privacy review before processing. Assess harm to individuals, households, communities, and people represented in data but not operating the product. Apply stricter minimization, access, disclosure, retention, testing, and human-review controls, and avoid deriving sensitive traits unless the approved purpose requires them.

**Why:** Sensitivity depends on context and consequences, and one person's choice cannot authorize harm to other people represented in the same data.

**Verify:**

- Identify affected people and groups, power differences, misuse cases, and consequences in the risk record.
- Confirm the qualified reviewer, approved purpose, safeguards, residual risk, and stop conditions.
- Exercise protections for disclosure, coercion, household sharing, administrator access, and account compromise where relevant.

**Exceptions:** None without a qualified privacy or legal decision and any required specialist review.

### PRIVACY-DATA-012 — Govern recipients, processors, and transfers

**Level:** required  
**Applies when:** Personal data is disclosed to another team, legal entity, service provider, partner, public audience, or processing location.

Before disclosure, verify that the recipient and transfer are covered by the recorded purpose and authority. Record the data, role, location, access path, onward recipients, and owner. Require terms and controls for instructions, confidentiality, access, security, retention, deletion or return, rights support, incident notice, subprocessors, and verification. Apply any governing transfer review.

**Why:** The originating organization remains exposed to harm when a recipient uses, retains, transfers, or loses data outside the approved boundaries.

**Verify:**

- Compare contracts, vendor configuration, network destinations, and account access with the processing record.
- Confirm subprocessor and location changes trigger review rather than silent expansion.
- Test deletion, export, access removal, and incident-contact paths with material recipients.

**Exceptions:** A legally compelled disclosure follows its governing review and minimization process and must be recorded to the extent permitted.

### PRIVACY-DATA-013 — Perform privacy risk review before high-risk processing

**Level:** required  
**Applies when:** Processing is novel, large-scale, systematic, sensitive, hard to avoid, difficult to reverse, used for monitoring or profiling, combines datasets, makes or supports consequential decisions, or otherwise meets a governing impact-assessment trigger.

Complete the required privacy impact assessment before implementation or procurement. Describe purposes, necessity, proportionality, information flows, affected people, threats, harms, mitigations, alternatives, consultation, owners, residual risk, approval, and review triggers. Do not release processing whose residual risk requires consultation or acceptance that has not occurred.

**Why:** Late review makes invasive design choices and vendor commitments costly to change and can hide risk to people behind business benefits.

**Verify:**

- Confirm the assessment reflects the actual design, recipients, defaults, retention, and data flow.
- Trace each material risk to an implemented control, owner, evidence, and residual-risk decision.
- Reopen the assessment after material purpose, population, data, model, recipient, scale, or threat changes.

**Exceptions:** An emergency can use the applicable expedited review path; record scope, safeguards, expiration, and retrospective assessment.

### PRIVACY-DATA-014 — Keep personal data out of unsafe development paths

**Level:** required  
**Applies when:** Developing, testing, debugging, demonstrating, supporting, training, or evaluating a system outside its approved production processing.

Use synthetic, generated, or approved de-identified data by default. Do not copy production personal data into local, test, preview, demo, support, or training environments unless the recorded purpose cannot be met otherwise and a qualified owner approves scope, access, security, retention, deletion, and disclosure controls.

**Why:** Non-production systems and ad hoc files often have broader access, weaker monitoring, and forgotten copies.

**Verify:**

- Inspect fixtures, snapshots, logs, screenshots, exports, tickets, prompts, and debug tools for personal data.
- Confirm approved exceptions contain only the minimum records and fields and expire on schedule.
- Verify cleanup from developer devices, temporary storage, support tools, and vendor systems.

**Exceptions:** The qualified approval described in the rule is the only exception; it must be time-bounded and reviewable.

### PRIVACY-DATA-015 — Verify privacy behavior in the released system

**Level:** required  
**Applies when:** Releasing or materially changing personal-data processing.

Test the actual end-to-end system against its processing record, notices, choices, rights, access rules, retention, recipients, and impact assessment. Include negative and lifecycle states, not only the successful collection path. Record evidence, limitations, and unresolved risk without exposing personal data in the evidence itself.

**Why:** A tracking plan, design, or configuration review cannot prove what the integrated system sends, stores, reveals, or deletes.

**Verify:**

- Inspect storage and network behavior before choice, after each choice, after withdrawal, after account changes, and after deletion where applicable.
- Exercise unauthorized access, recipient failure, duplicate requests, restoration, and partial-system outage where those states affect privacy.
- Confirm evidence is redacted, access-controlled, retained only as needed, and mapped to active rules.

**Exceptions:** If a destructive or production test is unsafe, use the closest safe environment, identify every material difference, and arrange the governing post-release check.

### PRIVACY-DATA-016 — Govern model inputs, traces, evaluation, and feedback

**Level:** required  
**Applies when:** Personal data can enter a model prompt, context, file, embedding, memory, tool call, trace, evaluation dataset, annotation task, feedback path, or provider support process.

Map and govern each data path separately. Record provider, product, endpoint, region, subprocessors, human access, retention, training or improvement use, storage controls, deletion, and incident terms from current official documentation and contract settings. Minimize or redact before transfer and do not infer that a chat, API, hidden prompt, trace, or evaluation feature shares another feature's controls.

**Why:** Model systems create copies beyond visible input and output, and provider data controls can vary by account, feature, endpoint, and date.

**Verify:**

- Trace representative data through orchestration, model calls, tools, storage, observability, evaluation, feedback, support, and deletion.
- Compare actual account and endpoint settings with the current governing contract and official provider documentation.
- Exercise redaction, opt-out where applicable, access restriction, retention expiry, deletion, and provider exit.

**Exceptions:** None without the governing privacy, legal, security, and contractual decision.

## Guidance

Start privacy work while purpose and architecture can still change. A notice or consent dialog cannot repair an unnecessary collection, an unlimited retention period, or a data model that cannot locate and delete a person's records.

Use “personal data” as a practical engineering boundary, not only as a list of obvious identity fields. Device identifiers, account IDs, precise timestamps, URLs, behavior sequences, household data, and model features can be personal when they permit linkage, inference, or singling out.

Keep the processing record close to the implementation and procurement record. It should be specific enough that an engineer can find each source, destination, job, recipient, and deletion mechanism. Reference external inventories when they are authoritative rather than copying details that will drift.

Do not turn every privacy question into a consent prompt. First determine whether the processing is necessary, appropriate, and authorized. When choice is required, make it meaningful and preserve service for declined optional processing.

## Examples

### Optional analytics

Non-compliant: A page loads an analytics SDK and persistent identifier before showing a banner. Rejecting the banner changes its color but does not stop collection.

Compliant: The processing record identifies the analytics purpose, fields, recipient, retention, authority, and deletion path. Optional storage and requests remain off until the applicable choice. Reject and withdraw paths stop future collection and update the recipient. A network trace verifies each state.

### Support investigation

Non-compliant: An engineer copies a production database and user screenshots to a personal development environment because reproducing the issue is faster there.

Compliant: The team reproduces with synthetic data first. If a minimum production sample is necessary, a qualified owner approves named fields, people, environment, access, expiration, and cleanup. Evidence is redacted and the temporary copy is deleted and verified.

### De-identification

Non-compliant: A dataset is called anonymous because email addresses were replaced with stable hashes while precise events and timestamps remain available.

Compliant: The assessment considers hashing reversibility, uniqueness, auxiliary datasets, small groups, and recipient access. Until the approved transformation and contractual controls meet the stated threat model, the dataset retains personal-data controls.

## Sources

- National Institute of Standards and Technology, [NIST Privacy Framework, Version 1.0](https://www.nist.gov/document/nist-privacy-frameworkv10pdf), January 16, 2020. Reviewed August 13, 2026. Version 1.1 was still an initial public draft on the review date, so this standard relies on the final 1.0 publication.
- World Wide Web Consortium, [Privacy Principles](https://www.w3.org/TR/privacy-principles/), May 15, 2025. Reviewed August 13, 2026.
- UK Information Commissioner's Office, [A guide to the data protection principles](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/). Reviewed August 13, 2026. Apply it only where the governing law or organization policy adopts its requirements.
- UK Information Commissioner's Office, [Data protection by design and by default](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/guide-to-accountability-and-governance/data-protection-by-design-and-by-default/). Reviewed August 13, 2026.
- UK Information Commissioner's Office, [Data protection impact assessments](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/guide-to-accountability-and-governance/data-protection-impact-assessments/). Reviewed August 13, 2026.
- OpenAI, [Data controls in the OpenAI platform](https://developers.openai.com/api/docs/guides/your-data). Reviewed August 13, 2026. This source illustrates endpoint-specific controls; verify the current official documentation and contract for every provider in use.
