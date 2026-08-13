---
id: MARKETING-DISTRIBUTION
title: Distribution, referral, and acquisition assets
description: Requirements for accurate directory listings, consent-aware lead assets, governed referrals, and measurable distribution programs.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [marketing, growth, privacy, legal]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [directory-listing, lead-magnet, referral-program, prize-promotion, distribution-program]
tags: [marketing, distribution, referrals, acquisition]
depends_on: [MARKETING-LIFECYCLE, FND-EVIDENCE, FND-TRUST, PRIVACY-DATA, ANALYTICS-MEASUREMENT]
generated: { by: codex/gpt-5, at: "2026-08-13T23:45:00Z" }
sources:
  - id: ftc-advertising-faq
    resource: https://www.ftc.gov/business-guidance/resources/advertising-faqs-guide-small-business
    title: "Advertising FAQ's: A Guide for Small Business"
    author: organization:us-federal-trade-commission
  - id: ftc-endorsement-faq
    resource: https://www.ftc.gov/business-guidance/resources/ftcs-endorsement-guides-what-people-are-asking
    title: "FTC's Endorsement Guides: What People Are Asking"
    author: organization:us-federal-trade-commission
  - id: ftc-lead-generation
    resource: https://www.ftc.gov/business-guidance/blog/2017/07/lead-generation-when-product-personal-data
    title: "Lead generation: When the product is personal data"
    author: organization:us-federal-trade-commission
---

# Distribution, referral, and acquisition assets

Distribution programs must preserve accurate representation, informed choice, data boundaries, and honest measurement as content and incentives move through directories, partners, customers, and automated channels. Promotion and privacy law vary by jurisdiction; qualified review is required where a program creates legal duties.

## Rules

### MARKETING-DISTRIBUTION-001 — Define the distribution contract

**Level:** required
**Applies when:** Submitting, syndicating, gating, referring, rewarding, or otherwise distributing an acquisition asset or offer.

Record the audience, jurisdictions, channel, asset or listing, value exchange, claims, data flow, partner roles, incentive, budget, owner, duration, measures, stop conditions, and governing channel terms before launch.

**Why:** Distribution can multiply an inaccurate claim, unauthorized data transfer, or incentive before the source is corrected.

**Verify:**

- Compare every active channel, partner, listing, form, and automation with the approved contract.
- Confirm owners can update, pause, or remove each copy and revoke partner access.

**Exceptions:** A no-cost test still requires claim, data, authority, and stop controls.

### MARKETING-DISTRIBUTION-002 — Keep directory and syndicated facts current

**Level:** required
**Applies when:** Publishing product, organization, location, availability, price, or contact information outside an owned canonical surface.

Use an authoritative source for each material field, disclose sponsorship or commercial placement, prohibit fabricated reviews or engagement, and set a review and removal path for every destination.

**Why:** Stale or manipulated third-party listings can mislead people after the owned source changes.

**Verify:**

- Reconcile live listings with the canonical source and inspect rendered links, categories, claims, and disclosures.
- Check expiration, duplicate, ownership-transfer, correction, and removal behavior.

**Exceptions:** A platform-controlled field may remain unavailable when the limitation and correction request are recorded.

### MARKETING-DISTRIBUTION-003 — Make the lead-asset exchange explicit

**Level:** required
**Applies when:** Access to a guide, tool, template, event, result, or other asset asks for personal data or a marketing permission.

State what the person receives, what data is required, why it is needed, who receives it, and whether future communication is optional. Do not imply that unrelated marketing permission is required for an otherwise available asset.

**Why:** Calling an asset free can conceal payment through personal data or future contact.

**Verify:**

- Walk the form, delivery, confirmation, follow-up, withdrawal, deletion, and suppression journeys.
- Confirm promised value is delivered without hidden terms and optional permissions remain optional.

**Exceptions:** A required communication may accompany the requested service when it is necessary to deliver or secure that service.

### MARKETING-DISTRIBUTION-004 — Govern referrals and incentives

**Level:** required
**Applies when:** A customer, partner, employee, creator, or other participant may receive value for a referral, recommendation, share, review, or conversion.

Define eligibility, reward, attribution window, prohibited conduct, fraud controls, tax or reporting ownership, disclosure wording, dispute handling, and termination. Require material connections to be apparent with the recommendation.

**Why:** Undisclosed or poorly controlled incentives can create deceptive endorsements, spam, self-referrals, and disputes.

**Verify:**

- Inspect participant instructions, sample shares, reward calculations, disclosures, reversals, and abuse cases.
- Confirm the program does not condition rewards on a positive opinion or suppress honest negative experience.

**Exceptions:** Non-promotional service credits may use simplified disclosure when recipients cannot reasonably mistake the communication for independent advocacy.

### MARKETING-DISTRIBUTION-005 — Review contests, prizes, and chance-based promotions by jurisdiction

**Level:** required
**Applies when:** Distribution includes a contest, sweepstakes, drawing, prize, random selection, or purchase-linked chance.

Before launch, obtain qualified review of classification, eligibility, geography, age, entry method, purchase conditions, official rules, disclosures, registration or bonding, tax handling, winner selection, publicity rights, and platform terms.

**Why:** Promotion rules differ by jurisdiction and a small structural choice can change the legal classification.

**Verify:**

- Compare the live promotion and every shortened or social version with approved official rules.
- Preserve entry, selection, notification, prize delivery, complaint, and closure records.

**Exceptions:** None when chance, consideration, or a prize may be present; qualified review determines applicability.

### MARKETING-DISTRIBUTION-006 — Limit partner and lead data movement

**Level:** required
**Applies when:** A directory, affiliate, partner, referral system, form provider, or lead buyer receives personal, confidential, or audience data.

Identify recipients and onward transfers, verify recipient identity and purpose, minimize fields, set retention and deletion, constrain reuse, protect transfer, honor rights and suppression, and monitor complaints and misuse.

**Why:** A lead can expose the person to unknown recipients and uses that were not apparent at collection.

**Verify:**

- Trace representative records from collection through every recipient, rejection, resale prohibition, deletion, and suppression path.
- Inspect contracts, access, exports, logs, complaints, and recipient offboarding.

**Exceptions:** None for hidden recipients or uses outside the represented purpose.

### MARKETING-DISTRIBUTION-007 — Measure net value and retire the program

**Level:** required
**Applies when:** Evaluating or ending a distribution, referral, listing, or acquisition-asset program.

Report total cost, incentive and partner fees, reach, qualified outcomes, overlap, attribution limits, downstream value, fraud, complaints, privacy effects, and guardrails. Remove or correct stale assets, links, listings, permissions, and automation when the program ends.

**Why:** Gross signups can hide duplicated demand, low-quality leads, incentive abuse, and long-lived data or claims.

**Verify:**

- Reconcile channel records with financial, product, support, privacy, and authoritative listing data.
- Confirm closure across partners, localization, caches, redirects, rewards, access, retention, and suppression.

**Exceptions:** Directional measures are permitted when uncertainty and non-causal limits are stated.

## Guidance

Treat directories and partners as external publishers, not passive pipes. Keep a destination inventory and a canonical record for material facts. Do not use incentives to manufacture praise, and do not infer permission for unrelated contact from asset delivery or referral participation.

## Examples

### Referral download campaign

Non-compliant: Gate a template behind an email field, enroll every downloader in promotion, reward five-star reviews, and send full lead records to unspecified partners.

Compliant: Explain the asset and optional follow-up separately, disclose referral rewards, accept honest feedback, restrict recipient data and reuse, reconcile net outcomes, and retain a tested shutdown path.

## Sources

- US Federal Trade Commission, [Advertising FAQ's: A Guide for Small Business](https://www.ftc.gov/business-guidance/resources/advertising-faqs-guide-small-business). Reviewed August 13, 2026.
- US Federal Trade Commission, [FTC's Endorsement Guides: What People Are Asking](https://www.ftc.gov/business-guidance/resources/ftcs-endorsement-guides-what-people-are-asking). Reviewed August 13, 2026.
- US Federal Trade Commission, [Lead generation: When the product is personal data](https://www.ftc.gov/business-guidance/blog/2017/07/lead-generation-when-product-personal-data). Reviewed August 13, 2026.
