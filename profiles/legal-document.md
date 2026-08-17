---
id: PROFILE-LEGAL-DOCUMENT
title: Public legal document profile
description: Routes terms, privacy notices, policies, addenda, and legal centers to scope, accuracy, presentation, change control, and qualified review requirements.
type: profile
status: draft
governance_status: draft
release_target: post-v1
owners: [legal, privacy, standards]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [legal-document, terms-of-service, privacy-notice, cookie-notice, data-processing-addendum, acceptable-use-policy]
tags: [profile, legal, privacy]
depends_on: [LEGAL-PUBLISHED-TERMS, PRIVACY-DATA, FND-TRUST, FND-EVIDENCE, FND-ACCESSIBILITY, WRITING-FUNCTIONAL, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T07:46:46Z" }
---

# Public legal document profile

Use this profile to create, adopt, revise, publish, or operationalize terms of service, privacy or cookie notices, acceptable-use policies, data-processing or transfer addenda, subprocessor pages, service or security terms, AI policies, and public legal centers. A qualified legal owner must approve applicability and substance; agent or general editorial review is not legal approval.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `LEGAL-PUBLISHED-TERMS` — document scope, architecture, practice accuracy, presentation, assent evidence, versioning, change control, and operational verification
- `PRIVACY-DATA` — processing authority, data map, notice, choice, rights, retention, recipients, transfers, and released-system behavior
- `FND-TRUST` — informed choice, honest framing, material consequences, and practical exit
- `FND-EVIDENCE` — source authority, claim strength, uncertainty, and completion evidence
- `FND-ACCESSIBILITY` — accessible documents, controls, channels, and representative testing
- `WRITING-FUNCTIONAL` — audience, terminology, structure, plain language, localization, and comprehension
- `AGENT-VERIFICATION` — proportionate checks, specialist review boundaries, final inspection, and handoff

## Conditional standards

- Signup, checkout, renewal, cancellation, consent, rights, or other interactive legal flow → `PROFILE-UI-FEATURE`
- Public or indexable legal page or legal center → `PROFILE-PUBLIC-WEB-PAGE`
- Collection, use, sharing, retention, model processing, or deletion of personal data → every applicable rule in `PRIVACY-DATA`, not only notice rules
- Model-generated output, model data use, automated decisions, or agent actions → `PROFILE-AGENTIC-SYSTEM`
- Authentication, authorization, uploads, external links or fetches, rights request intake, or other application behavior → `SECURITY-APPLICATION`
- Prices, renewals, trials, offers, testimonials, or acquisition claims → `PROFILE-MARKETING-LIFECYCLE`
- App-store privacy declarations or store-specific terms → `DISCOVERY-APP-STORES`
- Recurring subscription, trial, automatic renewal, renewal notice, price change, or cancellation → `LEGAL-PUBLISHED-TERMS-016`, `FND-TRUST`, and the governing commerce, billing, and jurisdiction decision
- Cookies, SDKs, local storage, pixels, fingerprinting, advertising identifiers, or privacy preference signals → `LEGAL-PUBLISHED-TERMS-017`, `PRIVACY-DATA`, and `WEB-QUALITY-011`
- Age restriction, age assurance, parental process, or service used by minors → `LEGAL-PUBLISHED-TERMS-018`, `PRIVACY-DATA-011`, and the governing child-safety and legal decision
- Content or conduct enforcement, account restriction, suspension, termination, or appeal → `LEGAL-PUBLISHED-TERMS-019`, `FND-TRUST`, and the governing safety, security, or platform policy
- Merger, acquisition, insolvency, assignment, product shutdown, or entity change → `LEGAL-PUBLISHED-TERMS-020`, `PRIVACY-DATA`, and `FND-CHANGE`
- Children, employment, health, finance, education, biometrics, precise location, communications, regulated professional services, or another heightened domain → no complete sector-specific legal standard exists in this library; obtain the governing qualified review and record the external policy before publication

## Completion evidence

- `LEGAL-PUBLISHED-TERMS-001` — The scope record names the entity, product, audience, jurisdictions, languages, dates, owners, and required qualified review.
- `LEGAL-PUBLISHED-TERMS-002` — The document map resolves components, incorporation, precedence, negotiated overrides, and regional variants.
- `LEGAL-PUBLISHED-TERMS-003` and `PRIVACY-DATA-001` — Each material statement traces to current processing, product, vendor, security, support, or commercial evidence.
- `LEGAL-PUBLISHED-TERMS-004` and `FND-TRUST-001` — Material consequences appear in representative decision flows before commitment.
- `LEGAL-PUBLISHED-TERMS-005`, `LEGAL-PUBLISHED-TERMS-006`, and `PRIVACY-DATA-006` — Contract assent, notice, and consent are distinguished; stored evidence reproduces the exact applicable version and interaction.
- `LEGAL-PUBLISHED-TERMS-007` and `LEGAL-PUBLISHED-TERMS-008` — Archive, diff, notice, effective-time, transition, objection, cancellation, refund, and data-treatment evidence covers material changes.
- When a privacy notice applies, `LEGAL-PUBLISHED-TERMS-009` and `PRIVACY-DATA-005` — The complete and point-of-collection notices match the processing map and provide working contact, rights, and choice paths.
- When AI applies, `LEGAL-PUBLISHED-TERMS-010`, `FND-TRUST-008`, and `PRIVACY-DATA-016` — Reliance limits, content treatment, provider behavior, training, evaluation, logging, human access, and restricted uses agree across documents and systems.
- `LEGAL-PUBLISHED-TERMS-011`, `FND-ACCESSIBILITY-001`, and `WRITING-FUNCTIONAL-013` — Rendered accessibility and comprehension evidence covers the intended audience, channels, and supported languages.
- `LEGAL-PUBLISHED-TERMS-012` and `AGENT-VERIFICATION-005` — The release record covers the published documents and the behavior they govern, names qualified approvals, and reports limitations and deferred routes.
- For electronic formation or required electronic records, `LEGAL-PUBLISHED-TERMS-013` and `LEGAL-PUBLISHED-TERMS-015` — The rendered interaction provides conspicuous notice, unambiguous assent, access before agreement, and a reproducible retainable copy under the governing decision.
- For non-negotiated or consumer terms, `LEGAL-PUBLISHED-TERMS-014` — The clause-risk record covers substantive fairness, discretion, remedies, conflicting agreements, and qualified approval.
- For recurring offers, `LEGAL-PUBLISHED-TERMS-016` — Enrollment, consent, acknowledgment, reminders, renewal, billing, cancellation, refund, and evidence retention pass end-to-end review.
- For device storage, tracking, or preference signals, `LEGAL-PUBLISHED-TERMS-017` — The inventory and observed storage, network, SDK, redirect, and server behavior agree before choice, after each choice, after withdrawal, and with applicable signals.
- For minors or age assurance, `LEGAL-PUBLISHED-TERMS-018` — Audience, comprehension, age states, parental paths, data minimization, accuracy, correction, and deletion have qualified review and tested evidence.
- For restriction or termination, `LEGAL-PUBLISHED-TERMS-019` — Comparable-case sampling and warning, action, notice, appeal, reversal, export, and refund tests show policy and operation agree.
- For corporate transfer or shutdown, `LEGAL-PUBLISHED-TERMS-020` — Contract, privacy, consent, prepaid value, export, rights, deletion, notice, and successor obligations are reconciled and assigned.

## Review boundary

Agents may research, draft, compare, test, and prepare review evidence. They must not select governing law, declare a clause enforceable, claim regulatory compliance, or record qualified approval without the responsible human professional.
