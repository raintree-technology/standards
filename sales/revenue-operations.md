---
id: SALES-REVENUE-OPERATIONS
title: Sales enablement and revenue operations
description: Requirements for governed sales claims, lead lifecycle, routing, systems of record, forecasting, and handoff.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [sales, revenue-operations, marketing, finance, legal]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [sales-enablement, revenue-operations, lead-lifecycle, competitive-intelligence]
tags: [sales, revenue-operations, enablement, pipeline]
depends_on: [FND-EVIDENCE, MARKETING-LIFECYCLE, DATA-QUALITY, PRIVACY-DATA]
generated: { by: codex/gpt-5, at: "2026-08-13T23:20:00Z" }
sources:
  - id: ftc-comparative-advertising
    resource: https://www.ftc.gov/legal-library/browse/statement-policy-regarding-comparative-advertising
    title: Statement of Policy Regarding Comparative Advertising
    author: organization:us-federal-trade-commission
  - id: doj-antitrust-guidance
    resource: https://www.justice.gov/atr/guidelines-and-policy-statements-0
    title: Antitrust Guidelines and Policy Statements
    author: organization:us-department-of-justice
  - id: sec-investment-marketing
    resource: https://www.sec.gov/resources-small-businesses/small-business-compliance-guides/investment-adviser-marketing
    title: Investment Adviser Marketing
    author: organization:us-securities-and-exchange-commission
---

# Sales enablement and revenue operations

Sales and revenue systems must carry accurate claims and commitments from first contact through qualification, contracting, delivery, renewal, and reporting without hidden data changes, conflicted incentives, or unsupported forecasts. Regulated industries require their governing rules in addition to this baseline.

## Rules

### SALES-REVENUE-OPERATIONS-001 — Govern sales claims and collateral

**Level:** required
**Applies when:** Providing decks, demos, proposals, battlecards, scripts, case studies, comparisons, or generated responses to prospects or customers.

Version approved claims, evidence, product scope, pricing, security and privacy statements, customer proof, prohibited representations, owner, and expiry. Separate current capability from roadmap and custom commitment.

**Why:** Sales material can create contractual expectations that product, security, or operations cannot meet.

**Verify:**

- Sample delivered material and recorded demos against the approved source and actual product version.
- Confirm stale collateral and generated knowledge are withdrawn from every tool and partner.

**Exceptions:** Custom answers require the accountable product or domain owner and must be captured in the opportunity record.

### SALES-REVENUE-OPERATIONS-002 — Keep competitive intelligence attributable and lawful

**Level:** required
**Applies when:** Collecting, analyzing, or sharing competitor products, prices, customers, strategy, or claims.

Use lawful sources and access, preserve provenance and date, distinguish observation from inference, avoid confidential or deceptively obtained material, and route competitively sensitive exchange through qualified legal review.

**Why:** Stale or improperly acquired intelligence can mislead customers and create intellectual-property or competition risk.

**Verify:**

- Trace material comparative claims and internal recommendations to current sources and methods.
- Inspect collection identities, access terms, partner exchanges, and retained confidential material.

**Exceptions:** None for theft, impersonation, access circumvention, or prohibited competitor coordination.

### SALES-REVENUE-OPERATIONS-003 — Define lead and opportunity state contracts

**Level:** required
**Applies when:** Leads, accounts, contacts, opportunities, stages, scores, territories, or lifecycle states drive work or reporting.

Define entry, exit, owner, evidence, time, allowed transitions, duplicates, recycling, loss, suppression, and historical behavior for each state and score.

**Why:** Ambiguous stages produce unreliable forecasts, duplicate contact, unfair routing, and conflicting reports.

**Verify:**

- Exercise creation, merge, reassignment, disqualification, re-entry, loss, renewal, deletion, and source correction.
- Reconcile sampled records with the contract and downstream reports.

**Exceptions:** Exploratory scores may remain advisory when they cannot automate eligibility, contact, or material treatment.

### SALES-REVENUE-OPERATIONS-004 — Route ownership fairly and recoverably

**Level:** required
**Applies when:** Rules or models assign accounts, leads, credit, response priority, territory, commission, or service level.

Version routing rules, inputs, tie-breaking, capacity, protected and sensitive proxies, overrides, audit, dispute, and fallback. Prevent silent loss and duplicate ownership.

**Why:** Opaque routing affects customer response, employee compensation, workload, and access to opportunity.

**Verify:**

- Replay representative boundary, conflict, absence, stale-data, override, and system-failure cases.
- Review outcome distribution and disputes for systematic error or unfair impact.

**Exceptions:** Manual assignment requires named authority and the same audit and dispute record.

### SALES-REVENUE-OPERATIONS-005 — Preserve commitments through handoff

**Level:** required
**Applies when:** Responsibility moves among marketing, sales, legal, finance, implementation, support, success, or renewal teams.

Record promised scope, exclusions, price and term, security and privacy commitments, dependencies, customer objectives, risks, owner, acceptance, and unresolved decisions in the shared system of record.

**Why:** Verbal or tool-local promises are lost after signature and surface later as delivery failure or conflict.

**Verify:**

- Trace sampled closed opportunities into contract, implementation plan, support state, billing, and renewal.
- Confirm deviations from standard product and policy have explicit approval and ownership.

**Exceptions:** None for material customer commitments.

### SALES-REVENUE-OPERATIONS-006 — Make forecasts and attribution reproducible

**Level:** required
**Applies when:** Pipeline, bookings, revenue, retention, quota, or source attribution affects decisions or compensation.

Define population, time, currency, stage probability, ownership, credit, split, inclusion, adjustments, recognition boundary, model, and uncertainty; preserve historical snapshots and changes.

**Why:** Mutable stages and discretionary credit can make forecasts appear precise while hiding bias and retroactive changes.

**Verify:**

- Reproduce reported totals from immutable or versioned inputs and reconcile with finance where applicable.
- Compare forecast with outcome by segment and report systematic error and manual adjustments.

**Exceptions:** Directional planning may use ranges when assumptions and uncertainty are explicit.

### SALES-REVENUE-OPERATIONS-007 — Control system-of-record access and automation

**Level:** required
**Applies when:** People, integrations, imports, models, or agents read or change revenue data or trigger customer action.

Use least privilege, field and action ownership, protected exports, validation, idempotent updates, approval for high-impact bulk action, monitoring, rollback or correction, and revocation.

**Why:** Revenue systems combine personal data, confidential negotiations, communication authority, and financial reporting.

**Verify:**

- Exercise denied access, malformed import, duplicate update, bulk reassignment, automated message, deletion, export, and offboarding.
- Reconcile automated changes and customer effects after interruption or retry.

**Exceptions:** Emergency correction follows the governed change and incident process.

## Guidance

Keep one semantic contract even when multiple systems store the lifecycle. Do not use activity volume as a substitute for customer value or pipeline quality. High-stakes financial, employment, competition, and regulated-sales decisions require qualified review.

## Examples

### Security commitment

Non-compliant: A generated proposal promises a certification and regional hosting that the product does not have, then disappears into an email thread.

Compliant: Collateral pulls from approved versioned claims, deviations require domain approval, and every signed commitment flows into implementation, support, billing, and renewal records.

## Sources

- US Federal Trade Commission, [Statement of Policy Regarding Comparative Advertising](https://www.ftc.gov/legal-library/browse/statement-policy-regarding-comparative-advertising). Reviewed August 13, 2026.
- US Department of Justice, [Antitrust Guidelines and Policy Statements](https://www.justice.gov/atr/guidelines-and-policy-statements-0). Reviewed August 13, 2026.
- US Securities and Exchange Commission, [Investment Adviser Marketing](https://www.sec.gov/resources-small-businesses/small-business-compliance-guides/investment-adviser-marketing), used as an example of additional sector-specific requirements. Reviewed August 13, 2026.
