---
type: Reference
title: raintree.standards
description: Entry point for Raintree's governed, agent-readable quality standards.
tags: [standards, governance, agents]
generated: { by: codex/gpt-5, at: "2026-08-17T17:16:31Z" }
sources:
  - id: okf-v02
    resource: https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md
    title: Open Knowledge Format v0.2
    author: org:GoogleCloudPlatform
---

# raintree.standards

> [!WARNING]
> **Work in progress:** Before version 1.0, requirements and document structure can
> change. Check the document status and review metadata before relying on a rule for
> release approval.

Use raintree.standards to find acceptance criteria for work on Raintree projects. The
library helps practitioners and agents identify requirements, collect evidence, and
report exceptions or unresolved gaps.

This repository is a governed standards library, not a general collection of tips.
Each standard states when its rules apply, how strongly they apply, and what evidence
verifies them.

## Use the library

Start with a defined task and its intended outcome.

1. Choose the profile in [`profiles/`](profiles/) that most closely matches the task.
2. Read every standard listed in that profile's `depends_on` field.
3. Determine which rules apply to the task's context and risks.
4. Collect the evidence required by each applicable rule.
5. Report satisfied rules, approved exceptions, and unresolved gaps by stable rule ID.

The result should be a task record that connects each applicable rule to evidence, an
approved exception, or an unresolved gap.

Useful entry points:

- [Authority and requirement levels](governance/authority.md)
- [Contribution requirements](governance/contributing.md)
- [Agentic system profile](profiles/agentic-system.md)
- [Commercial evidence review profile](profiles/commercial-evidence-review.md)
- [Company brain profile](profiles/company-brain.md)
- [Database change profile](profiles/database-change.md)
- [Redis change profile](profiles/redis-change.md)
- [Functional writing profile](profiles/functional-writing.md)
- [Growth experiment profile](profiles/growth-experiment.md)
- [Product feature profile](profiles/product-feature.md)
- [Public web page profile](profiles/public-web-page.md)
- [Programmatic interface and service change profile](profiles/service-api-change.md)
- [Specialist marketing profile](profiles/specialist-marketing.md)
- [Standards conformance audit](playbooks/standards-audit.md)

## Format

Markdown is the source of truth. The repository uses Open Knowledge Format (OKF) v0.2
with a stricter Raintree application profile. Each concept document begins with YAML
front matter for machine-readable metadata.

- [`schema/standard.schema.json`](schema/standard.schema.json) defines the Raintree standard contract.
- [`schema/integration-capability.schema.json`](schema/integration-capability.schema.json) defines supporting vendor capability maps used by governed playbooks.
- [`schema/integration-manifest.schema.json`](schema/integration-manifest.schema.json) defines discovery, official-domain, artifact, and agent-skill routing for each provider bundle.
- [`catalog.yaml`](catalog.yaml) indexes governed documents for agents and other tools.
- Markdown keeps the standards readable, reviewable, and easy to cite.

OKF supplies portable discovery, provenance, trust, and lifecycle conventions.
Raintree adds stable IDs, controlled document types, ownership, applicability,
dependencies, rule levels, exceptions, and verification requirements. Tools that
read and write these documents must preserve unknown front-matter fields because the
Raintree profile does not define the complete OKF vocabulary.

## Lifecycle metadata

The `status` field uses OKF's `draft`, `stable`, and `deprecated` values. The
`governance_status` field uses Raintree's `draft`, `active`, `deprecated`, and
`retired` values. A stable document requires `verified` provenance from an independent
reviewer before a versioned release.

The `stale_after` date matches `review_by` when a review deadline exists. A document
without a `verified` field has not received independent verification. Migration,
source discovery, and structural validation do not count as content verification.
[`source-register.yaml`](source-register.yaml) records the owner and freshness policy
for each governed external source set.

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

The bounded v1 corpus covers recurring product, engineering, data, web, content,
marketing, AI, and operational work. The [coverage matrix](coverage.md) maps each work
area to its standards, profiles, playbooks, and approval state.

Post-v1 drafts cover organizational knowledge systems, standards audits, specialist
marketing channels, sales and revenue operations, app stores, media production, and
commercial evidence reviews. New documents, agentic systems, privacy, and application
security remain governed drafts pending the reviews listed in
[version 1.0 readiness](governance/v1-readiness.md).

Supporting [integration bundles](integrations/) connect volatile provider surfaces to
official sources, workflows, evaluations, and optional capability maps. Each named
provider has its own playbook and manifest. Agent skills are versioned review aids;
they do not turn provider documentation into universal policy.

## Agent access

Agents may read, search, cite, and apply this library. They must not change it unless a
user explicitly assigns a standards-maintenance task. [`AGENTS.md`](AGENTS.md) defines
this rule. Review and repository ownership enforce it even when filesystem permissions
allow changes.

## Apply the library to this repository

Repository changes must use the same standards as work in other Raintree projects.
Start with the route that matches the artifact being changed:

| Repository work | Primary route | Common additional standards |
|---|---|---|
| Standards, profiles, playbooks, and public documentation | [Functional writing profile](profiles/functional-writing.md) | `FND-EVIDENCE`, `FND-TRUST`, and `FND-ACCESSIBILITY` |
| Repository-wide conformance review | [Standards conformance audit](playbooks/standards-audit.md) | Every profile and conditional route activated by the inspected scope |
| Agent instructions and reusable procedures | [Agentic system profile](profiles/agentic-system.md) | `WRITING-FUNCTIONAL` and `AGENT-VERIFICATION` |
| Ruby validators, schemas, and command interfaces | [Programmatic interface and service change profile](profiles/service-api-change.md) | `ENGINEERING-QUALITY`, `SECURITY-APPLICATION`, and `API-CONTRACTS` |
| Continuous integration and repository automation | `ENGINEERING-QUALITY` | `FND-CHANGE`, `SECURITY-APPLICATION`, and `AGENT-VERIFICATION` |

Apply only rules whose conditions are true. Record missing evidence as a gap or unknown;
do not add approval, verification, or conformance claims that the available evidence
does not support.

## Contribute and report problems

- Read [CONTRIBUTING.md](CONTRIBUTING.md) before proposing a change.
- Report sensitive security concerns according to [SECURITY.md](SECURITY.md).
- Follow the [Code of Conduct](CODE_OF_CONDUCT.md) in project spaces.

## License

Standards and documentation are available under [CC BY 4.0](LICENSE.md). Software, schemas, workflows, and executable configuration are available under the MIT License. See [LICENSE.md](LICENSE.md) for the complete scope and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for source attribution.
