---
type: Reference
title: Raintree Standards
description: Entry point for Raintree's governed, agent-readable quality standards.
tags: [standards, governance, agents]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: okf-v02
    resource: https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md
    title: Open Knowledge Format v0.2
    author: org:GoogleCloudPlatform
---

# Raintree Standards

> [!WARNING]
> **Work in progress:** Requirements and document structure may change before version 1.0.

Raintree Standards defines acceptance criteria for people and agents working on Raintree projects. Use it to identify applicable requirements, collect evidence, and report exceptions or unresolved gaps.

This repository is a governed standards library, not a general collection of tips. Each standard states when its rules apply, their requirement levels, and the evidence needed to verify them.

## Use the library

1. Choose the profile in [`profiles/`](profiles/) that most closely matches your task.
2. Read every standard listed in that profile's `depends_on` field.
3. Determine which rules apply to the task's context and risks.
4. Collect the evidence required by each applicable rule.
5. Report satisfied rules, approved exceptions, and unresolved gaps by stable rule ID.

Useful entry points:

- [Authority and requirement levels](governance/authority.md)
- [Contribution requirements](governance/contributing.md)
- [Agentic system profile](profiles/agentic-system.md)
- [Database change profile](profiles/database-change.md)
- [Functional writing profile](profiles/functional-writing.md)
- [Growth experiment profile](profiles/growth-experiment.md)
- [Product feature profile](profiles/product-feature.md)
- [Public web page profile](profiles/public-web-page.md)
- [Specialist marketing profile](profiles/specialist-marketing.md)

## Format

Markdown is the source of truth. The repository is an Open Knowledge Format (OKF) v0.2 bundle with a stricter Raintree application profile. Each concept document begins with YAML front matter for machine-readable metadata.

- [`schema/standard.schema.json`](schema/standard.schema.json) defines the Raintree standard contract.
- [`catalog.yaml`](catalog.yaml) indexes governed documents for agents and other tools.
- Markdown keeps the standards readable, reviewable, and easy to cite.

OKF supplies portable discovery, provenance, trust, and lifecycle conventions. Raintree adds stable IDs, controlled document types, ownership, applicability, dependencies, rule levels, exceptions, and verification requirements. Consumers must preserve unknown front-matter fields rather than treating the Raintree profile as the complete OKF vocabulary.

## Lifecycle metadata

The `status` field uses OKF's `draft`, `stable`, and `deprecated` values. The `governance_status` field uses Raintree's `draft`, `active`, `deprecated`, and `retired` values. A stable document requires `verified` provenance from an independent reviewer before a versioned release.

The `stale_after` date matches `review_by` when a review deadline exists. If a document has no `verified` field, it has not been independently verified. Migration, source discovery, and structural validation do not count as content verification. [`source-register.yaml`](source-register.yaml) records the owner and freshness policy for each governed external source set.

## Library model

| Type | Purpose |
|---|---|
| Foundation | Cross-cutting constraints such as security, privacy, accessibility, reliability, trust, and evidence quality |
| Standard | Testable requirements for a domain |
| Pattern | A preferred implementation approach with known tradeoffs |
| Playbook | An ordered procedure for recurring work |
| Profile | A task-oriented bundle of applicable standards |
| Decision | A durable record explaining an important choice |

## Coverage

The bounded v1 corpus covers agentic systems, APIs, engineering quality, database and data quality, product delivery, interaction design, accessibility, interface content, lifecycle marketing, analytics, experiments, privacy, application security, search, public web quality, functional writing, reliability, incidents, and cross-cutting foundations. Post-v1 drafts now cover specialist marketing channels, sales and revenue operations, app stores, and media production. The [coverage matrix](coverage.md) maps recurring work to standards and profiles. New documents plus agentic systems, privacy, and application security remain governed drafts pending the independent and qualified reviews listed in [version 1.0 readiness](governance/v1-readiness.md).

## Agent access

Agents may read, search, cite, and apply this library. They must not change it unless a user explicitly assigns a standards-maintenance task. This rule is defined in [`AGENTS.md`](AGENTS.md) and enforced through review and repository ownership; it does not depend only on filesystem permissions.

## Contribute and report problems

- Read [CONTRIBUTING.md](CONTRIBUTING.md) before proposing a change.
- Report sensitive security concerns according to [SECURITY.md](SECURITY.md).
- Follow the [Code of Conduct](CODE_OF_CONDUCT.md) in project spaces.

## License

Standards and documentation are available under [CC BY 4.0](LICENSE.md). Code in `scripts/` and `schema/` is available under the MIT License. See [LICENSE.md](LICENSE.md) for the complete scope and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for source attribution.
