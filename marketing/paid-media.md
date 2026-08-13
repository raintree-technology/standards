---
id: MARKETING-PAID-MEDIA
title: Paid media and advertising operations
description: Requirements for truthful, authorized, measurable, and controlled paid advertising across external platforms.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [marketing, growth, analytics, privacy, legal]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [paid-advertising, sponsored-content, ad-creative]
tags: [marketing, advertising, paid-media]
depends_on: [MARKETING-LIFECYCLE, FND-EVIDENCE, FND-TRUST, PRIVACY-DATA, ANALYTICS-MEASUREMENT]
generated: { by: codex/gpt-5, at: "2026-08-13T23:20:00Z" }
sources:
  - id: ftc-advertising
    resource: https://www.ftc.gov/business-guidance/advertising-marketing
    title: Advertising and Marketing
    author: organization:us-federal-trade-commission
  - id: eu-dsa
    resource: https://digital-strategy.ec.europa.eu/en/policies/digital-services-act
    title: The Digital Services Act
    author: organization:european-commission
  - id: ico-direct-marketing
    resource: https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/direct-marketing-guidance/
    title: Direct marketing guidance
    author: organization:uk-information-commissioners-office
---

# Paid media and advertising operations

Paid advertising must identify its sponsor, support its claims, respect audience and platform restrictions, control spend and authority, and measure durable outcomes without treating platform attribution as causal proof. Applicable advertising law and platform policy require current qualified review.

## Rules

### MARKETING-PAID-MEDIA-001 — Approve the campaign contract before spend

**Level:** required
**Applies when:** Funding a paid placement, sponsored distribution, promotion, or ad experiment.

Record the objective, audience, jurisdictions, offer, claims, creative variants, destinations, budget, bid authority, schedule, owners, platform policies, stop conditions, and success and guardrail measures before launch.

**Why:** Platform automation can expand spend and exposure faster than ambiguous campaign intent can be corrected.

**Verify:**

- Compare the live campaign, account settings, creative, destination, and budget controls with the approved contract.
- Confirm the operator and automation cannot exceed approved spend, audience, geography, or duration.

**Exceptions:** A bounded platform test may use provisional performance targets but still requires spend, claim, audience, and stop controls.

### MARKETING-PAID-MEDIA-002 — Make sponsorship and material terms apparent

**Level:** required
**Applies when:** A placement could be mistaken for editorial, organic, independent, or user-generated content.

Identify the content as advertising or sponsored communication and disclose the responsible advertiser and material conditions where people encounter the claim.

**Why:** People evaluate paid persuasion differently from independent information.

**Verify:**

- Inspect every rendered placement, format, language, device, and truncated state for visible sponsorship and qualifications.
- Confirm platform labels do not hide or contradict required advertiser disclosures.

**Exceptions:** None when the commercial nature or sponsor would otherwise be unclear.

### MARKETING-PAID-MEDIA-003 — Keep creative and destination claims consistent

**Level:** required
**Applies when:** An ad links, deep-links, or directs people to an offer, form, store, or product experience.

Ensure the strongest express and implied claim, price, availability, eligibility, urgency, and visual representation remain supported and consistent through the destination and commitment path.

**Why:** A truthful landing page does not cure a misleading ad, and a truthful ad does not cure hidden destination terms.

**Verify:**

- Walk each active creative through its destination, checkout or signup, confirmation, and exit.
- Test expired, unavailable, ineligible, localized, and out-of-stock conditions.

**Exceptions:** None for material claims and terms.

### MARKETING-PAID-MEDIA-004 — Govern targeting and exclusions

**Level:** required
**Applies when:** Audience delivery uses personal data, inferred attributes, lookalikes, exclusions, location, age, or automated optimization.

Document the input data, authority, sensitive proxies, intended and excluded recipients, platform expansion settings, fairness and harm review, and applicable notice or control. Do not target or exclude using prohibited sensitive data or protected status.

**Why:** Platform-selected delivery can create opaque discrimination, vulnerability targeting, or use beyond the source purpose.

**Verify:**

- Inspect uploaded audiences, platform-generated expansion, exclusions, delivery reports, and deletion or suppression behavior.
- Compare outcomes across relevant groups without collecting unnecessary sensitive data.

**Exceptions:** Legally required eligibility or safety restrictions need the governing rule and qualified approval.

### MARKETING-PAID-MEDIA-005 — Control accounts, partners, and spend

**Level:** required
**Applies when:** People, agencies, platforms, or automation can publish ads or commit budget.

Use named identities, least privilege, approval thresholds, protected payment methods, change logging, separation of duties for high spend, and rapid revocation. Define agency and platform responsibilities contractually.

**Why:** Advertising accounts combine public publishing, customer data, brand authority, and direct financial access.

**Verify:**

- Inspect effective roles, tokens, linked accounts, billing, automated rules, and change history.
- Exercise spend alerts, pause, credential revocation, and agency offboarding.

**Exceptions:** Small campaigns may combine approval roles within a documented maximum exposure.

### MARKETING-PAID-MEDIA-006 — Measure incrementality, cost, and harm

**Level:** required
**Applies when:** Reporting campaign performance or making a budget decision.

Report spend, fees, exposure, outcome quality, attribution model, overlap, lag, modeled data, fraud or invalid traffic, downstream value, and guardrails. Use controlled evidence for causal incrementality claims.

**Why:** Platform-reported credit can double count conversions and reward low-quality or already-likely outcomes.

**Verify:**

- Reconcile platform cost and outcome data with authoritative financial and product systems.
- Compare attributed results with a suitable baseline, holdout, lift method, or explicit non-causal limitation.

**Exceptions:** Directional optimization may use platform metrics when causal and financial limits are stated.

### MARKETING-PAID-MEDIA-007 — Stop and archive campaigns completely

**Level:** required
**Applies when:** An offer, claim, audience, creative, event, or campaign expires or becomes invalid.

Pause all placements and automated variants, revoke obsolete audiences and access, reconcile final spend and outcomes, preserve required records, and remove stale destinations or route them truthfully.

**Why:** Forgotten automation can continue spending, targeting, and making outdated claims.

**Verify:**

- Inspect account, network, localization, experiment, remarketing, and partner states after closure.
- Confirm final billing, audience retention, destination behavior, and owner sign-off.

**Exceptions:** Evergreen campaigns require a current owner, evidence review, and recurring expiration check.

## Guidance

Treat platform recommendations as vendor proposals, not policy. Pin the applicable platform-policy version in the campaign record and revalidate it before launch. Separate creative exploration from authorization to publish or spend.

## Examples

### Automated audience expansion

Non-compliant: Upload customer emails, enable unrestricted audience expansion, accept platform attribution, and allow the campaign to spend until the account limit.

Compliant: Approve the data purpose and jurisdictions, constrain expansion and exclusions, cap spend and duration, validate ad-to-offer consistency, reconcile outcomes, and retain a tested pause path.

## Sources

- US Federal Trade Commission, [Advertising and Marketing](https://www.ftc.gov/business-guidance/advertising-marketing). Reviewed August 13, 2026.
- European Commission, [The Digital Services Act](https://digital-strategy.ec.europa.eu/en/policies/digital-services-act). Reviewed August 13, 2026.
- UK Information Commissioner's Office, [Direct marketing guidance](https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/direct-marketing-guidance/). Reviewed August 13, 2026.
