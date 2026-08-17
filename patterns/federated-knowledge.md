---
id: PATTERN-FEDERATED-KNOWLEDGE
title: Federated organizational knowledge
description: A source-neutral pattern for preserving native authority while making organizational evidence discoverable through a shared retrieval layer.
type: pattern
status: draft
governance_status: draft
release_target: post-v1
owners: [knowledge, data, security, privacy, ai, engineering]
last_reviewed: 2026-08-16
review_by: 2027-02-16
stale_after: 2027-02-16
applies_to: [company-brain, enterprise-search, retrieval-system]
tags: [knowledge, federation, retrieval, provenance]
depends_on: [KNOWLEDGE-SYSTEMS]
generated: { by: codex/gpt-5, at: "2026-08-17T06:08:51Z" }
sources:
  - id: cerebras-knowledge-base
    resource: https://www.cerebras.ai/blog/how-we-built-our-knowledge-base
    title: How we built our knowledge base
    author: organization:cerebras
  - id: reciprocal-rank-fusion
    resource: https://doi.org/10.1145/1571941.1572114
    title: Reciprocal Rank Fusion Outperforms Condorcet and Individual Rank Learning Methods
    author: Cormack, Clarke, and Büttcher
  - id: w3c-prov-o
    resource: https://www.w3.org/TR/prov-o/
    title: PROV-O The PROV Ontology
    author: organization:w3c
---

# Federated organizational knowledge

Keep information in systems suited to creating and maintaining it, then expose governed evidence through source-specific adapters and a shared retrieval boundary. The pattern reduces forced migration and duplicate authoring while preserving the source ownership, permissions, provenance, and lifecycle required by `KNOWLEDGE-SYSTEMS`.

This draft requires independent review of the final artifact and qualified AI, security, privacy, data, and engineering review before it can become stable.

## Structure

1. **Authoritative native sources** own content, meaning, access, correction, and lifecycle.
2. **Bounded adapters** read approved scopes and emit a common evidence envelope without erasing source semantics.
3. **Derived retrieval stores** hold only the content and signals needed for declared uses and remain rebuildable from governed sources.
4. **Scoped retrieval** selects sources and retrieval methods according to the actor, project, question type, and permitted purpose.
5. **Evidence-first output** returns attributable evidence before or alongside generated synthesis.

An evidence envelope should carry, directly or through protected references:

- source system, stable source identifier, location, owner, and authority class;
- source version or event, source time, ingestion time, and last verified time;
- content classification, tenant or organizational scope, and authorization reference;
- source and derived content type, transformation lineage, and model or process version;
- freshness objective, retention or deletion state, and correction status;
- retrieval scores or reasons as diagnostic signals, not claims of truth.

The envelope is a shared control surface, not a claim that a message, code symbol, policy section, database row, and generated summary have the same meaning.

## Retrieval choices

Use the smallest set of retrieval methods that meets measured needs. Exact search can preserve error strings, identifiers, names, flags, and citations. Structured query can preserve typed meaning. Semantic retrieval can connect paraphrases. Freshness, authority, and project scope can qualify relevance. Rank fusion and reranking can combine signals, but they do not replace permission checks, source authority, or end-to-end evaluation.

Expand a selected fragment with the surrounding context needed to preserve headings, preconditions, dates, caveats, and corrections. Merge or cap repeated chunks only when the final evidence still exposes independent support, disagreement, and provenance.

## Tradeoffs

- Federated ownership avoids one authoring system but creates connector, reconciliation, and permission-propagation work.
- Replicated indexes reduce query latency but increase breach, deletion, restoration, and staleness risk.
- Shared envelopes simplify downstream tools but can flatten source-specific meaning if fields and limitations are not retained.
- Generated summaries improve consistency and retrieval signal but introduce another derived data product that can omit, distort, or outlive its source.
- Project or domain scopes improve relevance but require ownership, overlap, default, and cross-scope behavior to be explicit.

## Do not use when

Do not add a shared knowledge layer when authoritative source search already meets the measured need, when permissions or deletion cannot propagate safely, when the organization cannot own connector operations, or when concentrating the data creates an unacceptable failure boundary. A directory of sources and owners may be the safer first step.

## Verification

- Trace representative evidence from each source through its adapter, derived stores, retrieval, and output.
- Compare derived access and lifecycle behavior with the authoritative source.
- Evaluate exact, semantic, current, scoped, conflicting, denied, and unanswerable questions.
- Disable and rebuild a representative source integration without losing corrections, permissions, or deletion state.

## Sources

- Cerebras, [How we built our knowledge base](https://www.cerebras.ai/blog/how-we-built-our-knowledge-base), July 16, 2026. Reviewed from the published article capture August 16, 2026. Used as implementation evidence, not universal policy.
- Gordon V. Cormack, Charles L. A. Clarke, and Stefan Büttcher, [Reciprocal Rank Fusion Outperforms Condorcet and Individual Rank Learning Methods](https://doi.org/10.1145/1571941.1572114), SIGIR 2009. Reviewed August 16, 2026. Used as retrieval research, not a required ranking prescription.
- World Wide Web Consortium, [PROV-O: The PROV Ontology](https://www.w3.org/TR/prov-o/). Reviewed August 16, 2026.
