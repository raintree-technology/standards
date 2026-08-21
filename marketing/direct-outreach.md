---
id: MARKETING-DIRECT-OUTREACH
title: Direct outreach and prospecting
description: Requirements for lawful sourcing, relevant outreach, sender identity, frequency, suppression, vendors, and evidence.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [marketing, sales, privacy, legal]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [cold-email, prospecting, direct-message, marketing-call, marketing-text]
tags: [marketing, outreach, prospecting, communications]
depends_on: [MARKETING-LIFECYCLE, PRIVACY-DATA, FND-TRUST, CONTENT-INTERFACE]
generated: { by: codex/gpt-5, at: "2026-08-13T23:20:00Z" }
sources:
  - id: ftc-can-spam
    resource: https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business
    title: CAN-SPAM Act A Compliance Guide for Business
    author: organization:us-federal-trade-commission
  - id: ico-electronic-mail
    resource: https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/guidance-on-direct-marketing-using-electronic-mail/
    title: Guidance on direct marketing using electronic mail
    author: organization:uk-information-commissioners-office
  - id: fcc-revocation
    resource: https://docs.fcc.gov/public/attachments/FCC-24-24A1_Rcd.pdf
    title: Rules concerning revocation of consent for robocalls and robotexts
    author: organization:us-federal-communications-commission
---

# Direct outreach and prospecting

Direct outreach must use an authorized and attributable contact source, be relevant to the recipient and channel, identify the sender, respect jurisdiction and platform rules, and make refusal effective across every sender and system.

## Rules

### MARKETING-DIRECT-OUTREACH-001 — Approve the audience and channel before contact

**Level:** required  
**Applies when:** Contacting a person or organization through email, text, call, voicemail, social direct message, or comparable directed channel.

Record recipient type, source, jurisdiction, channel, solicitation status, authority or permission, purpose, sender, frequency, and required disclosures before enrollment.

**Why:** Public or purchased contact information is not universal permission to market through every channel.

**Verify:**

- Trace sampled recipients to source, collection context, applicable rule, and approved campaign.
- Confirm individual, corporate, customer, lead, and role-address distinctions are handled where law requires them.

**Exceptions:** A response to a specific request remains limited to that requested communication unless separate marketing authority exists.

### MARKETING-DIRECT-OUTREACH-002 — Govern prospect data provenance

**Level:** required  
**Applies when:** Collecting, enriching, purchasing, scraping, inferring, or importing prospect data.

Record source, collection date, stated purpose, seller or provider, license or terms, accuracy, sensitive fields, notice, objection path, retention, recipients, and prohibited use. Reject data without defensible provenance.

**Why:** Lists can contain unlawfully collected, stale, sensitive, misidentified, or suppressed contacts.

**Verify:**

- Audit a sample through the original source, transformations, enrichment, imports, and active destinations.
- Test correction, objection, deletion, and suppression through derived copies and vendors.

**Exceptions:** Confidential source detail may use a protected reference but cannot be omitted from governance review.

### MARKETING-DIRECT-OUTREACH-003 — Identify the sender and purpose truthfully

**Level:** required  
**Applies when:** Sending or instigating direct outreach.

Use accurate routing, sender identity, subject or opening, organizational relationship, commercial purpose, and contact information. Do not impersonate a colleague, customer, independent researcher, or personal acquaintance.

**Why:** Misleading identity or pretext prevents an informed decision and damages channel trust.

**Verify:**

- Inspect delivered messages, caller presentation, domains, reply paths, redirects, and vendor identities.
- Confirm generated personalization does not invent prior contact, knowledge, or relationship.

**Exceptions:** Protected investigations and safety communications follow their own authorized procedures and are not marketing.

### MARKETING-DIRECT-OUTREACH-004 — Keep outreach relevant and bounded

**Level:** required  
**Applies when:** Selecting message content, personalization, sequence, cadence, or follow-up.

Use only necessary information, connect the message to a credible recipient context, avoid sensitive or intrusive inference, cap attempts and duration, and stop when the premise is invalid or the person signals disinterest.

**Why:** Scale and generated personalization can turn weak relevance into repeated harassment or reveal unexpected surveillance.

**Verify:**

- Review samples across sequence positions, segments, negative responses, role changes, and stale records.
- Inspect frequency across campaigns, brands, vendors, identities, and channels.

**Exceptions:** Safety, fraud, contractual, or service notices remain limited to their non-marketing purpose.

### MARKETING-DIRECT-OUTREACH-005 — Make refusal immediate and durable

**Level:** required  
**Applies when:** A recipient can withdraw, object, opt out, block, or request no further contact.

Offer an accessible refusal path appropriate to the channel, accept reasonable refusal language, suppress further governed contact within the applicable deadline, and retain only what is needed to honor suppression.

**Why:** A refusal that works only in one tool or exact syntax does not preserve meaningful control.

**Verify:**

- Exercise links, replies, spoken requests, standard text keywords, complaints, account deletion, imports, retries, and vendor handoffs.
- Confirm suppression wins over later list refresh, enrichment, scoring, or campaign membership.

**Exceptions:** Legally required or requested service messages may continue without promotional content.

### MARKETING-DIRECT-OUTREACH-006 — Control senders, domains, automation, and vendors

**Level:** required  
**Applies when:** A system or third party sources contacts, generates messages, or sends on the organization's behalf.

Use approved identities, least privilege, authentication, volume and frequency limits, quality sampling, complaint monitoring, content and list controls, incident response, and contractual responsibility. Preserve a global stop mechanism.

**Why:** The organization can remain responsible when an agent, affiliate, lead seller, or platform performs the sending.

**Verify:**

- Inspect vendor contracts, access, domain authentication, automation rules, sampling, complaints, suppression exchange, and offboarding.
- Trigger the global stop and verify queued, scheduled, retried, and distributed sending halts.

**Exceptions:** None for external senders acting on the organization's behalf.

### MARKETING-DIRECT-OUTREACH-007 — Measure quality without rewarding pressure

**Level:** required  
**Applies when:** Evaluating people, automation, lists, or campaigns.

Measure qualified outcomes, complaints, refusals, invalid contacts, reputation, downstream value, and harm alongside sends, opens, replies, meetings, or pipeline. Do not reward behavior that bypasses permission or suppression.

**Why:** Volume targets can incentivize misleading personalization, excessive contact, and poor-quality pipeline.

**Verify:**

- Reconcile campaign reports with suppression, complaint, delivery, sales, and customer outcomes.
- Review outlier senders and segments for policy violations rather than assuming higher activity is better.

**Exceptions:** None for performance systems affecting compensation or automated optimization.

## Guidance

Treat laws and platform rules as jurisdiction- and channel-specific. This standard sets a protective baseline but does not decide whether a particular list, message, or call is lawful. Obtain qualified review before launch and whenever recipients or channels change.

## Examples

### Purchased prospect list

Non-compliant: Import a list labeled “opted in,” generate fictional familiarity, send from rotating domains, and remove only exact unsubscribe-link clicks.

Compliant: Verify provenance and permission scope, identify the sender and commercial purpose, cap the sequence, accept reasonable objections, synchronize suppression, monitor complaints, and delete unsupported contacts.

## Sources

- US Federal Trade Commission, [CAN-SPAM Act: A Compliance Guide for Business](https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business). Reviewed August 13, 2026.
- UK Information Commissioner's Office, [Guidance on direct marketing using electronic mail](https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/guidance-on-direct-marketing-using-electronic-mail/). Reviewed August 13, 2026.
- US Federal Communications Commission, [Rules concerning revocation of consent for robocalls and robotexts](https://docs.fcc.gov/public/attachments/FCC-24-24A1_Rcd.pdf). Reviewed August 13, 2026.
