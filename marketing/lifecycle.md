---
id: MARKETING-LIFECYCLE
title: Marketing lifecycle
description: Requirements for evidence-led positioning, acquisition, conversion, onboarding, retention, and lifecycle communication.
type: standard
status: draft
governance_status: draft
owners: [marketing, product, growth, analytics, legal]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [marketing-lifecycle, campaign, conversion-flow]
tags: [marketing, positioning, conversion, retention]
depends_on: [FND-EVIDENCE, FND-TRUST, ANALYTICS-MEASUREMENT, PRIVACY-DATA]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: ftc-advertising
    resource: https://www.ftc.gov/business-guidance/advertising-marketing
    title: Advertising and Marketing
    author: organization:us-federal-trade-commission
  - id: ico-direct-marketing
    resource: https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/direct-marketing-guidance/
    title: Direct marketing guidance
    author: organization:uk-information-commissioners-office
  - id: marketing-skills
    resource: https://github.com/coreyhaines31/marketingskills
    title: Marketing Skills for AI Agents
    author: human:corey-haines
---

# Marketing lifecycle

Marketing must connect an evidenced audience need to a truthful offer, earn attention and permission, preserve product and user guardrails, and measure durable value across acquisition, conversion, onboarding, and retention. Jurisdiction-specific communication and advertising obligations require qualified legal review.

## Rules

### MARKETING-LIFECYCLE-001 — Maintain an evidenced positioning record

**Level:** required
**Applies when:** Creating strategy, claims, campaigns, sales material, or lifecycle content.

Record the target audience, problem, alternatives, differentiated value, supporting evidence, objections, limitations, prohibited claims, and approved terminology.

**Why:** Disconnected campaigns drift into conflicting audiences and unsupported promises.

**Verify:**

- Trace campaign claims and calls to action to the current positioning record and product behavior.
- Confirm evidence and limitations remain current for the targeted audience and market.

**Exceptions:** Exploratory concepts may use hypotheses when they are clearly labeled and are not published as claims.

### MARKETING-LIFECYCLE-002 — Ground audience insight in attributable research

**Level:** required
**Applies when:** A decision relies on customer language, needs, objections, segments, or behavior.

Record source, sample, method, period, selection limits, consent or authority, and the distinction between observed language and the team's interpretation.

**Why:** Anecdotes and selected quotes can be presented as representative demand without supporting scope.

**Verify:**

- Trace important insights to interviews, support records, behavioral evidence, or research artifacts.
- Check whether excluded, lost, dissatisfied, and non-converting people are represented where relevant.

**Exceptions:** A single anecdote may motivate research but cannot support a prevalence or market claim.

### MARKETING-LIFECYCLE-003 — Substantiate express and implied claims before publication

**Level:** required
**Applies when:** Content communicates product performance, comparison, results, price, scarcity, safety, endorsement, or other decision-relevant facts.

Identify the reasonable overall impression, support each material express and implied claim with evidence suitable to the claim, and place qualifications where people will notice and understand them.

**Why:** A literally true statement can still create a misleading overall impression or omit a material condition.

**Verify:**

- Map claims to current sources, product versions, populations, time periods, and required qualifications.
- Review comparative, testimonial, visual, and generated content for implied claims and material connections.

**Exceptions:** Subjective opinion must remain recognizable as opinion and cannot imply unheld objective evidence.

### MARKETING-LIFECYCLE-004 — Preserve a truthful offer and conversion path

**Level:** required
**Applies when:** Asking a person to sign up, buy, subscribe, start a trial, grant access, or provide lead information.

Present the included value, total material cost, recurring terms, eligibility, limitations, data use, cancellation or exit, and next step before commitment. Do not use obstruction, false urgency, disguised advertising, or preselected material consent.

**Why:** Local conversion gains can come from confusion or coercion and create refunds, complaints, churn, and legal risk.

**Verify:**

- Walk the path from acquisition claim through commitment, confirmation, billing, and exit.
- Confirm the strongest visual framing agrees with the complete terms and actual product.

**Exceptions:** None for material terms or consent.

### MARKETING-LIFECYCLE-005 — Govern communication permission and frequency

**Level:** required
**Applies when:** Sending marketing email, text, push, in-product promotion, or other directed lifecycle communication.

Record the governing jurisdiction and policy, lawful authority or permission, sender identity, purpose, audience, frequency, suppression, withdrawal, and proof of delivery behavior before activation.

**Why:** Product access or possession of contact data does not automatically authorize every marketing message.

**Verify:**

- Exercise subscribe, refuse, withdraw, suppress, re-consent, complaint, and account-deletion paths.
- Confirm suppression applies across vendors, retries, imports, and derived audiences within required time.

**Exceptions:** Transactional or legally required messages must remain limited to that purpose and not smuggle in promotion.

### MARKETING-LIFECYCLE-006 — Optimize for achieved value, not compelled activity

**Level:** required
**Applies when:** Improving signup, onboarding, activation, engagement, paywalls, cancellation, or retention.

Define the user value and business outcome, protect guardrails, preserve meaningful choice, and reject tactics that increase a local metric by delaying exit, withholding material information, or driving low-quality activity.

**Why:** A metric can improve while user value, trust, support burden, or long-term retention worsens.

**Verify:**

- Review the complete journey and downstream cohorts, complaints, reversals, support, and retention.
- Confirm success is not defined solely by clicks, completion, or prevented cancellation.

**Exceptions:** None for deceptive or coercive behavior.

### MARKETING-LIFECYCLE-007 — Separate personalization from sensitive inference

**Level:** required
**Applies when:** Content, offer, timing, or channel varies by identity, behavior, model, segment, or inferred attribute.

Use only authorized, necessary data; document the targeting rule and sensitive proxies; provide applicable notice and control; and prevent protected or vulnerable groups from receiving harmful exclusion, pressure, or differential terms.

**Why:** Seemingly ordinary segments can reveal sensitive traits or create unfair and opaque treatment.

**Verify:**

- Inspect input attributes, derived segments, recipients, exclusions, model behavior, and outcome differences.
- Exercise correction, withdrawal, deletion, and fallback behavior.

**Exceptions:** Safety or eligibility targeting requires the governing policy, evidence, and qualified review.

### MARKETING-LIFECYCLE-008 — Measure incrementality and durable outcomes honestly

**Level:** required
**Applies when:** Evaluating a campaign, channel, conversion change, or lifecycle program.

Define the decision, cost, exposure, attribution limits, baseline, primary outcome, guardrails, and time horizon. Distinguish observed platform attribution from causal incrementality and report uncertainty.

**Why:** Platform reports can assign credit without showing that the activity caused additional durable value.

**Verify:**

- Reconcile platform, product, and financial measures where practical.
- Record attribution model, identity and consent gaps, modeled data, lag, overlap, and excluded costs.

**Exceptions:** Directional reporting may guide exploration when its causal and coverage limits are explicit.

### MARKETING-LIFECYCLE-009 — Preserve learning and retire stale material

**Level:** required
**Applies when:** A campaign, offer, message, segment, or lifecycle program ends or materially changes.

Record the version, audience, exposure, result, limitations, decision, and reusable learning; remove or revalidate stale claims, endorsements, pricing, links, and automation.

**Why:** Unowned material continues making outdated promises and repeated campaigns relearn the same result.

**Verify:**

- Trace active content and automations to a current owner, evidence record, and review date.
- Confirm ended campaigns no longer enroll or message people unexpectedly.

**Exceptions:** Archived material may remain when clearly dated, non-operative, and excluded from active journeys.

## Guidance

Use community skill libraries to discover recurring tasks and workflow gaps, not as authority for policy. Keep specialist channels outside this v1 standard unless their rules are independently sourced and reviewed. A good lifecycle connects the promise, product experience, measurement, support, and exit rather than optimizing each surface independently.

## Examples

### Cancellation offer

Non-compliant: Hide cancellation behind multiple screens and present an expiring discount without showing its future renewal price.

Compliant: Make cancellation easy to locate, state the discount duration and renewal price, preserve the ability to leave, record the user's choice, and evaluate saved accounts alongside complaints, refunds, and later retention.

## Sources

- US Federal Trade Commission, [Advertising and Marketing](https://www.ftc.gov/business-guidance/advertising-marketing). Reviewed August 13, 2026.
- UK Information Commissioner's Office, [Direct marketing guidance](https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/direct-marketing-guidance/). Reviewed August 13, 2026.
- Corey Haines and contributors, [Marketing Skills for AI Agents](https://github.com/coreyhaines31/marketingskills), used as an MIT-licensed coverage inventory rather than normative authority. Reviewed August 13, 2026.
