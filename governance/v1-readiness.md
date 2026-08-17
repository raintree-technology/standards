---
type: Governance
title: Version 1.0 readiness
description: Release gates, reviewer assignments, representative profile walkthroughs, and unresolved approval blockers for raintree.standards v1.0.
tags: [governance, v1, release, review]
generated: { by: codex/gpt-5, at: "2026-08-17T17:22:48Z" }
---

# Version 1.0 readiness

The bounded v1 corpus is authored and routed, but it is not approved for release. This record separates completed agent work from decisions that require independent or qualified human reviewers.

## Release gates

- [x] Catalog includes foundations, standards, patterns, playbooks, and profiles.
- [x] V1 domain baseline and vendor playbooks are drafted.
- [x] Stable IDs, rule structure, source parity, profile routing, and dependency validity have automated checks.
- [x] Source-set owners and review dates are registered.
- [x] Specialist marketing work is bounded outside v1 and authored as separately targeted drafts.
- [x] Full-catalog agent review is recorded with source-access and independence limitations.
- [x] Post-v1 drafts are cataloged without becoming false v1 release blockers.
- [ ] Every governed document has independent `verified` provenance against the final artifact.
- [ ] AI, security, privacy, accessibility, and marketing/legal documents have qualified human approval.
- [ ] A repository owner has approved vulnerability response timing and decision authority, and a representative response exercise has passed.
- [ ] Material public documentation has representative-reader and assistive-technology evidence against the declared support target.
- [ ] All review findings are resolved or covered by approved exceptions.
- [ ] The release validation command passes with no blockers.
- [ ] The work-in-progress warning is removed and the approved commit is tagged `v1.0.0`.

## Required reviewers

| Corpus | Required independent roles | Approval focus |
|---|---|---|
| All governed documents | Standards owner plus a non-author domain reviewer | Rule clarity, source support, feasibility, conflicts, and evidence |
| `AI-AGENTS` and agentic profile | AI, security, privacy, product, and engineering | Model behavior, evaluation validity, tool authority, data paths, and operation |
| `SECURITY-APPLICATION` and service/incident routes | Security and engineering | Threat coverage, control accuracy, response, and verification |
| `PRIVACY-DATA`, marketing, GA4, and data quality | Privacy and qualified legal owner for applicable jurisdictions | Authority, consent, rights, direct marketing, recipients, retention, and claims |
| Accessibility, UI, web, and Apple materials | Accessibility, design, and relevant platform engineering | Conformance target, assistive behavior, platform accuracy, and manual evidence |
| Operations and engineering | Operations, support, security, and engineering | Objectives, incident authority, recovery, supply chain, and vendor risk |
| Post-v1 specialist extensions and commercial evidence reviews | Marketing, research, sales/revenue operations, privacy, legal, accessibility, copyright/media, and Apple/Google platform owners as applicable | Channel law, platform policy, claim strength, source provenance, professional-assurance boundaries, data sourcing, incentives, rights, account authority, and operational feasibility |
| `INTEGRATIONS-VENDOR` and provider playbooks | Platform, security, privacy, operations, and payments, financial-data, lifecycle, data, or web owners as applicable | Provider contract accuracy, skill routing, source freshness, authority, callbacks, configuration, recovery, and exit |

Reviewers must add their own `verified` event only after inspecting the final revision. Approval notes must identify findings, resolutions, exceptions, and the artifact revision.

## Representative profile walkthroughs

These static walkthroughs confirm that routing reaches the intended governed documents. They do not prove a real product satisfies the rules.

| Scenario | Activated profiles and key evidence | Routing result |
|---|---|---|
| Public product launch with search and analytics | Public web, UI feature, product feature, functional writing, GSC, GA4, privacy, security | Complete; human approval pending |
| Apple account-management flow | Apple interface, UI feature, product feature, privacy, security, error content | Complete; device and accessibility review pending |
| Versioned tenant API | Service/API, database change, security, reliability, functional writing | Complete; integration and authorization review pending |
| Production database migration | Database change, service/API when exposed, data quality, reliability when recovery is material | Complete; engine-specific evidence pending |
| GA4 ecommerce setup | Marketing lifecycle, public web, GA4, analytics, privacy, data quality | Complete; consent, reconciliation, and legal review pending |
| Lifecycle retention campaign | Marketing lifecycle, growth experiment when compared, writing, UI when in product, privacy | Complete; channel and jurisdiction review pending |
| Service incident and restore | Reliability/incident, database change, security, privacy when affected, writing and error content | Complete; exercise evidence pending |
| Tool-using agent release | Agentic system, service/API, engineering, security, privacy, reliability, UI when present | Complete; repeated evaluation and qualified review pending |
| Buyer-facing supplier evidence sample | Commercial evidence review, functional writing, evidence, trust, specialist marketing, sales, privacy when prospect data is stored | Complete as a static route; independent research, sales, privacy, and legal review pending |

## Approval record template

For each document, record:

- Document ID and exact revision
- Reviewer identity and qualified role
- Sources and versions inspected
- Rules sampled or fully reviewed
- Findings and resolution links
- Approved exceptions and expiration
- Residual risk and next review date
- `verified.by` and `verified.at` added by the reviewer

## Current blockers

The [full-catalog agent review](agent-review-2026-08-13.md) has no unresolved agent-detectable finding, but it is not independent or qualified approval. The following evidence cannot be supplied by the authoring agent:

- `WRITING-FUNCTIONAL-013`: representative intended readers must complete the comprehension review.
- `FND-ACCESSIBILITY-001`, `WEB-QUALITY-005`, and `WEB-QUALITY-015`: a qualified accessibility reviewer must inspect the declared target and record representative browser, input, zoom, and assistive-technology results.
- `SECURITY-APPLICATION-016`: the repository owner must approve response timing and authority, then an authorized reviewer must record a representative exercise.
- `ENGINEERING-QUALITY-005` and `AGENT-VERIFICATION-007`: a qualified non-author must review the exact final revision.

The release gate is expected to fail until this human work is complete. Use the linked templates to record real evidence. Do not downgrade the gate, mark agent research as independent verification, or promote drafts to make the command pass.
