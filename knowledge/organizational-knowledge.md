---
id: KNOWLEDGE-SYSTEMS
title: Organizational knowledge systems
description: Requirements for governed company knowledge across source systems, derived stores, retrieval, and answer surfaces.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [knowledge, data, security, privacy, ai, engineering]
last_reviewed: 2026-08-16
review_by: 2027-02-16
stale_after: 2027-02-16
applies_to: [company-brain, enterprise-search, knowledge-base, retrieval-system, expertise-discovery]
tags: [knowledge, retrieval, provenance, authorization, audit]
depends_on: [FND-EVIDENCE, FND-TRUST, FND-CHANGE, DATA-QUALITY, SECURITY-APPLICATION, PRIVACY-DATA, ENGINEERING-QUALITY, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T06:08:51Z" }
sources:
  - id: w3c-prov-o
    resource: https://www.w3.org/TR/prov-o/
    title: PROV-O The PROV Ontology
    author: organization:w3c
  - id: nist-sp-800-53r5
    resource: https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final
    title: Security and Privacy Controls for Information Systems and Organizations
    author: organization:nist
  - id: nist-ai-rmf-1
    resource: https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-ai-rmf-10
    title: Artificial Intelligence Risk Management Framework AI RMF 1.0
    author: organization:nist
  - id: nist-ai-600-1
    resource: https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence
    title: Artificial Intelligence Risk Management Framework Generative Artificial Intelligence Profile
    author: organization:nist
---

# Organizational knowledge systems

A company-brain system must keep organizational knowledge attributable, appropriately accessible, current enough for its declared uses, and correctable across source systems, derived stores, retrieval paths, and answer surfaces. This standard governs how information participates in the knowledge system; it does not replace the standards governing the source system itself.

This draft requires independent review of the final artifact and qualified AI, security, privacy, data, and engineering review before it can become stable.

## Rules

### KNOWLEDGE-SYSTEMS-001 — Define the knowledge-system boundary

**Level:** required
**Applies when:** Designing, operating, or materially changing a system that collects, indexes, retrieves, summarizes, connects, or answers from organizational information.

Record the system's purposes, intended users and automated consumers, supported decisions, source systems, derived stores, retrieval and output surfaces, owners, data classifications, environments, exclusions, and known unsuitable uses. Identify where domain standards and external policy govern each source and consumer.

**Why:** An undefined boundary hides data flows, unsupported reliance, unowned sources, and control gaps between ingestion and use.

**Verify:**

- Compare the recorded boundary with current connectors, jobs, stores, models, interfaces, exports, logs, identities, and network destinations.
- Trace each source and consumer to an owner, purpose, classification, governing route, and declared use.
- Confirm excluded systems and unsupported decisions are not silently reachable through alternate paths.

**Exceptions:** Emergency incident access can precede a complete boundary record when the governing incident process authorizes it; reconcile the record after containment.

### KNOWLEDGE-SYSTEMS-002 — Preserve source authority and ownership

**Level:** required
**Applies when:** Knowledge is copied, normalized, summarized, ranked, inferred, or combined from one or more sources.

Identify the authoritative source and owner for each material fact or record type, define precedence and conflict behavior, and keep derived indexes and summaries subordinate to those authorities. Do not present availability in the knowledge system as proof that content is approved, complete, or current.

**Why:** A convenient derived copy can silently become a second source of truth with different ownership, meaning, and lifecycle.

**Verify:**

- Trace representative answers and records to their declared source of authority and current owner.
- Exercise conflicting, superseded, draft, deleted, and ownerless sources against the precedence rules.
- Confirm interfaces distinguish source content, derived content, and approved organizational policy where that distinction affects reliance.

**Exceptions:** A derived product can be authoritative for a defined output when its owner, inputs, transformation, approval, quality contract, and correction path are recorded under `DATA-QUALITY`.

### KNOWLEDGE-SYSTEMS-003 — Preserve provenance through derivation and retrieval

**Level:** required
**Applies when:** Content is copied, chunked, transformed, embedded, summarized, joined, ranked, inferred, cited, or exported.

Preserve enough provenance to identify the source system, stable source reference, source version or event, source and ingestion times, material transformations and model configuration, scope, and lineage to derived copies. Keep protected provenance available through access-controlled references rather than removing it.

**Why:** Content without lineage cannot be checked for authority, freshness, transformation error, affected consumers, or correction scope.

**Verify:**

- Trace representative output backward to source content and forward to indexes, summaries, caches, evaluations, exports, and consumers.
- Reproduce or explain each material transformation using its recorded version, inputs, and time.
- Confirm citations resolve to the evidence actually used rather than a similar or later source.

**Exceptions:** None for material knowledge; protected source details may remain hidden from unauthorized users while still being available to qualified reviewers.

### KNOWLEDGE-SYSTEMS-004 — Preserve authorization across every knowledge path

**Level:** required
**Applies when:** Any participating source, record, field, relationship, inference, or output has access restrictions.

Apply `SECURITY-APPLICATION-002` to ingestion, processing, indexes, search, synthesis, caches, logs, exports, administration, and background jobs. A derived store or combined answer must not grant access broader than the effective source permissions and approved inference policy for the requesting actor, tenant, purpose, and time.

**Why:** Centralized retrieval can bypass source controls or reveal restricted facts through snippets, rankings, counts, metadata, or inference.

**Verify:**

- Exercise unauthenticated, wrong-user, wrong-group, wrong-role, wrong-tenant, stale-membership, suspended, deleted, and service-identity access through every output path.
- Change and revoke representative source permissions and confirm derived stores, caches, results, citations, exports, and logs stop disclosure within the declared limit.
- Test whether result counts, titles, embeddings, summaries, related items, and error differences reveal protected content.

**Exceptions:** Explicitly public information must be classified public at the authoritative source and checked for protected fields, drafts, and joined inferences.

### KNOWLEDGE-SYSTEMS-005 — Reconcile ingestion and source change

**Level:** required
**Applies when:** Knowledge moves from a source into another store, index, cache, model, or consumer.

Define identity, ordering, deduplication, replay, checkpoint, retry, partial-failure, and reconciliation behavior for each data path. Set use-specific freshness objectives and account for accepted, rejected, delayed, duplicated, missing, corrected, restricted, and deleted records.

**Why:** A successful ingestion job can still leave silently missing, duplicated, reordered, or stale knowledge in active use.

**Verify:**

- Exercise initial load, incremental update, duplicate event, late arrival, retry, out-of-order change, partial source outage, and full reconciliation.
- Compare source and derived counts, stable identifiers, update markers, rejections, and sampled meaning.
- Confirm freshness breaches qualify or stop affected retrieval and reach an accountable owner.

**Exceptions:** A bounded archival snapshot may stop synchronizing when its fixed time boundary and unsuitable current uses are explicit at retrieval and output.

### KNOWLEDGE-SYSTEMS-006 — Propagate correction, restriction, and deletion

**Level:** required
**Applies when:** Source content can be corrected, reclassified, access-restricted, expired, withdrawn, or deleted.

Apply `DATA-QUALITY-007`, `PRIVACY-DATA-007`, and `PRIVACY-DATA-008` as applicable across raw copies, chunks, embeddings, summaries, links, caches, model context, feedback, evaluations, exports, recipients, backups, and restoration. Define immediate suppression and later physical deletion behavior separately when deletion cannot complete at once.

**Why:** Removing a source record does not protect people or decisions if derived knowledge remains searchable or returns after restoration.

**Verify:**

- Trace representative correction, restriction, and deletion requests through every material copy and recipient.
- Confirm suppressed content cannot be retrieved while asynchronous deletion is pending.
- Restore from backup in a safe exercise and verify tombstones or equivalent state prevent deleted knowledge from returning to active use.

**Exceptions:** A lawfully retained audit or backup copy requires a documented authority, isolation, access boundary, retention period, and prevention of ordinary retrieval or reuse.

### KNOWLEDGE-SYSTEMS-007 — Bound source connectors and evidence envelopes

**Level:** required
**Applies when:** A connector, adapter, import, plugin, crawler, API client, or custom job participates in the knowledge system.

Define each connector's purpose, owner, identity, source scope, permissions, fields, schedule or event triggers, side effects, schema, output contract, error behavior, limits, retention, and removal path. Use a consistent evidence envelope that carries the provenance, authorization, lifecycle, and classification fields needed by downstream controls without pretending unlike source meanings are identical.

**Why:** Extensible connectors can expand authority, disclosure, and semantic ambiguity faster than downstream retrieval code can detect.

**Verify:**

- Inspect effective credentials, source allowlists and denylists, destinations, schedules, payloads, logs, and disable behavior.
- Validate malformed, oversized, unauthorized, rate-limited, duplicated, and partially returned inputs at the trusted boundary.
- Confirm a new source cannot become queryable until its owner, classification, authority, lifecycle, and verification evidence are recorded.

**Exceptions:** An isolated non-production evaluation may query synthetic or approved public data before full onboarding when it has no private source access, production credentials, durable consumers, or retained data; record its scope and cleanup. A one-time import still requires a bounded identity, declared source and destination, reconciliation, and cleanup evidence.

### KNOWLEDGE-SYSTEMS-008 — Match retrieval to measured information needs

**Level:** required
**Applies when:** Search, ranking, routing, recommendation, or retrieval selects organizational knowledge for a person or automated consumer.

Identify the question and evidence types the system must support, including exact identifiers, paraphrases, current status, authoritative policy, and scoped domain questions. Select and combine retrieval methods only when evaluation shows they improve those uses, and prevent irrelevant source volume or one ranking signal from silently determining authority.

**Why:** One retrieval method can appear plausible while missing exact tokens, paraphrases, current sources, minority domains, or the evidence needed for the decision.

**Verify:**

- Evaluate representative exact, semantic, recent, scoped, cross-source, ambiguous, and unanswerable questions.
- Inspect retrieved candidates before synthesis for authority, relevance, diversity, recency, and permission.
- Compare proposed ranking, fusion, filtering, and expansion changes against a fixed evaluation set and important segments.

**Exceptions:** A single deterministic lookup can use one retrieval method when the supported key, source, completeness, and failure behavior are verified.

### KNOWLEDGE-SYSTEMS-009 — Preserve context and material conflict

**Level:** required
**Applies when:** A system returns excerpts, chunks, summaries, fused results, or cross-source answers.

Include enough surrounding context to retain the source's subject, conditions, time, status, qualifications, and material disagreement. Do not merge duplicate or related evidence in a way that hides independent support, dissent, version differences, or a more authoritative source.

**Why:** An isolated passage can reverse meaning when headings, preconditions, later corrections, or conflicting evidence are removed.

**Verify:**

- Inspect answers where the matching passage depends on nearby headings, definitions, caveats, dates, or replies.
- Exercise conflicting sources with different owners, authority, versions, and freshness.
- Confirm deduplication and source caps retain the provenance and disagreement needed to assess the answer.

**Exceptions:** Exact record lookup can omit surrounding prose when the returned fields carry their complete definition, state, time, and authority.

### KNOWLEDGE-SYSTEMS-010 — Ground answers and fail honestly

**Level:** required
**Applies when:** A system summarizes, recommends, explains, or answers from organizational knowledge.

Make each material factual claim traceable to accessible evidence and distinguish source observation, generated inference, recommendation, and unresolved uncertainty according to `FND-EVIDENCE`. Refuse, narrow, or escalate when evidence is absent, inaccessible, stale beyond the declared use, materially conflicting, or outside scope.

**Why:** Fluent synthesis can turn weak retrieval, hidden conflict, or missing evidence into false organizational certainty.

**Verify:**

- Follow citations from representative claims to the exact supporting passages and confirm the requester may access them.
- Test missing, stale, conflicting, low-confidence, poisoned, and out-of-scope evidence.
- Confirm unsupported answers do not invent sources, experts, approvals, policies, or completed actions.

**Exceptions:** Low-risk exploratory ideation may proceed without factual grounding when the output is clearly framed as ideation and is not stored as authoritative knowledge.

### KNOWLEDGE-SYSTEMS-011 — Evaluate the complete knowledge path

**Level:** required
**Applies when:** Releasing or materially changing sources, connectors, transformations, permissions, retrieval, ranking, synthesis, models, scopes, or output interfaces.

Evaluate the integrated path from source state and actor permissions through retrieval to the final outcome. Include representative successes, misses, denials, unanswerable questions, stale and conflicting evidence, correction and deletion, prompt injection where models are present, dependency failure, latency, and cost. Apply `FND-EVIDENCE-008` through `FND-EVIDENCE-010` and `AI-AGENTS` when stochastic or model-based components affect results.

**Why:** Component scores do not show whether the released system gives the right evidence to the right actor and handles absence safely.

**Verify:**

- Record the source snapshot, permission state, configuration, task provenance, graders, trial count, metrics, segments, failures, latency, and cost.
- Hold out evaluation tasks from tuning and inspect representative false acceptance, false rejection, permission, and citation failures.
- Re-run material cases after changes and bind approval to the exact integrated artifact.

**Exceptions:** A deterministic bounded change may use focused tests when the unchanged surrounding path and its prior evidence remain applicable.

### KNOWLEDGE-SYSTEMS-012 — Keep use and control activity auditable

**Level:** required
**Applies when:** Operating a knowledge system for people, automations, or agents.

Record the source and project scope, requesting actor or protected correlation, retrieval and policy decisions, evidence references, denials, administrative changes, exports, errors, and final outcome needed for investigation and governance. Apply `SECURITY-APPLICATION-013`, minimize logged content, protect log access and integrity, and define retention and review triggers.

**Why:** Final answers alone cannot show which sources, permissions, transformations, and retrieval decisions caused a disclosure or incorrect result.

**Verify:**

- Trace representative success, denial, correction, export, administrative change, and failure from request to outcome.
- Confirm logs support investigation without containing secrets or unnecessary protected content.
- Test loss, delay, duplicate events, tampering, clock skew, and alert or review routing where material.

**Exceptions:** Where identifying the requester creates disproportionate risk, use the minimum protected correlation that still supports abuse response and authorized audit.

### KNOWLEDGE-SYSTEMS-013 — Govern correction, ownership transfer, and retirement

**Level:** required
**Applies when:** People can report incorrect knowledge, a source changes ownership, or a connector, source, index, model, or project scope is retired.

Provide an owned path to report, assess, correct, communicate, and verify material knowledge errors. Transfer ownership explicitly, notify affected consumers of meaning or availability changes, and remove obsolete access, jobs, data, credentials, references, and unsupported claims during retirement.

**Why:** A knowledge system decays when errors have no repair path and retired sources remain discoverable or privileged.

**Verify:**

- Exercise correction of a source fact and a derived summary through affected outputs and consumers.
- Inspect ownership transfer for current contacts, permissions, service levels, and unresolved incidents.
- Reconcile retirement across connectors, schedules, stores, caches, credentials, exports, documentation, and monitoring.

**Exceptions:** An immutable historical archive may remain discoverable when its fixed period, authority, access, and unsuitable current uses are explicit.

### KNOWLEDGE-SYSTEMS-014 — Protect people in expertise and workforce inference

**Level:** required
**Applies when:** A system identifies experts, ranks people, summarizes employee activity, infers skills or relationships, or informs work allocation, evaluation, access, discipline, or another consequential workforce decision.

Apply `PRIVACY-DATA`, `FND-TRUST`, and the governing employment, human-resources, and legal policy. Define the permitted purpose, evidence, affected people, correction and contest path, human decision boundary, and prohibited uses. Do not treat message volume, repository activity, reactions, retrieval rank, or model inference alone as proof of expertise, performance, intent, or suitability.

**Why:** Convenient activity signals can be incomplete, biased, context-dependent, and harmful when converted into judgments about people.

**Verify:**

- Inspect source coverage, missing populations, proxy effects, uncertainty, explanation, access, retention, and correction behavior.
- Test sparse, common-name, team-change, leave, contractor, new-hire, and disputed-attribution cases.
- Confirm consequential decisions receive the required qualified human review and do not rely on the knowledge result as sole evidence.

**Exceptions:** A person may publish a self-declared expertise profile for an approved directory purpose when access, correction, withdrawal, and prohibited downstream uses remain governed.

## Guidance

Meet knowledge where it is created when that preserves useful work patterns and source ownership. A central index can improve discovery, but centralization also concentrates permission, privacy, retention, and incident risk. Choose physical replication, federated queries, or a mixture according to measured needs and the accepted failure boundary.

Do not prescribe embeddings, one database, one ranking formula, one chunk size, or one orchestration model as policy. Exact lookup, full-text search, structured query, graph traversal, semantic retrieval, recency signals, and human routing solve different problems. Evaluate the combination against actual questions and failure costs.

Treat summaries, embeddings, inferred expertise, and generated links as derived data products. They inherit source restrictions and require their own lineage, correction, lifecycle, and quality evidence. A citation improves inspectability but does not repair unauthorized, stale, or irrelevant evidence.

## Examples

### Permission change

Non-compliant: Removing a person from a restricted source stops direct access, but old snippets and summaries remain visible in search until the next weekly rebuild.

Compliant: The permission event suppresses affected results and cached answers within the declared revocation limit. Reconciliation later removes or rekeys derived copies, and an audit test confirms the former member cannot infer content from titles, counts, related items, or errors.

### Conflicting guidance

Non-compliant: The answer cites the newest chat message as policy because its recency score is highest.

Compliant: The answer identifies the approved policy as authoritative, notes the newer operational discussion as unresolved conflicting evidence, and routes the discrepancy to both owners.

## Sources

- World Wide Web Consortium, [PROV-O: The PROV Ontology](https://www.w3.org/TR/prov-o/). Reviewed August 16, 2026.
- National Institute of Standards and Technology, [Security and Privacy Controls for Information Systems and Organizations, SP 800-53 Revision 5 Update 1](https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final). Reviewed August 16, 2026.
- National Institute of Standards and Technology, [Artificial Intelligence Risk Management Framework 1.0](https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-ai-rmf-10), January 26, 2023. Reviewed August 16, 2026.
- National Institute of Standards and Technology, [Artificial Intelligence Risk Management Framework: Generative Artificial Intelligence Profile, NIST AI 600-1](https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence), July 26, 2024. Reviewed August 16, 2026.
