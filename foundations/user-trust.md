---
id: FND-TRUST
title: User trust
description: Protects informed user choice from concealment, coercion, and manufactured urgency.
type: foundation
status: stable
governance_status: active
owners: [product]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [product-feature, growth-experiment, public-web-page, lifecycle-message, functional-writing]
tags: [trust, consent, dark-patterns]
generated: { by: codex/gpt-5, at: "2026-08-13T19:35:12Z" }
sources:
  - id: w3c-ethical-web
    resource: https://www.w3.org/TR/ethical-web-principles/
    title: Ethical Web Principles
    author: organization:w3c
  - id: w3c-design-principles
    resource: https://www.w3.org/TR/design-principles/
    title: Web Platform Design Principles
    author: organization:w3c
  - id: w3c-privacy-principles
    resource: https://www.w3.org/TR/privacy-principles/
    title: Privacy Principles
    author: organization:w3c
  - id: ftc-dark-patterns
    resource: https://www.ftc.gov/news-events/news/press-releases/2022/09/ftc-report-shows-rise-sophisticated-dark-patterns-designed-trick-trap-consumers
    title: FTC report shows rise in sophisticated dark patterns designed to trick and trap consumers
    author: organization:ftc
  - id: anthropic-trustworthy-agents
    resource: https://www.anthropic.com/research/trustworthy-agents
    title: Trustworthy agents in practice
    author: organization:anthropic
  - id: openai-agent-safety
    resource: https://developers.openai.com/api/docs/guides/agent-builder-safety
    title: Safety in building agents
    author: organization:openai
---

# User trust

Products and communications must help people make informed choices without concealment, coercion, manufactured urgency, or avoidable lock-in.

## Rules

### FND-TRUST-001 — Represent consequences before commitment

**Level:** required  
**Applies when:** An action charges money, publishes information, deletes data, changes access, starts a recurring obligation, or is difficult to reverse.

Explain the material consequence before the user commits. Place the explanation at the decision point and state price, recurrence, audience, data impact, or irreversibility in concrete terms.

**Why:** Information shown after commitment cannot support informed consent.

**Verify:**

- Review the final interaction from the user's perspective.
- Confirm the consequence is visible before confirmation without requiring unrelated navigation or fine-print interpretation.

**Exceptions:** None.

### FND-TRUST-002 — Preserve meaningful choice

**Level:** required  
**Applies when:** Requesting consent, enrollment, tracking, upgrades, permissions, or communication preferences.

Make acceptance and refusal understandable and similarly accessible. Do not make refusal misleading, punitive, preselected where active consent is required, or needlessly difficult.

**Why:** A nominal choice is not meaningful when one option is hidden, confusing, or burdened with unrelated friction.

**Verify:**

- Compare the language, visual prominence, steps, and consequences of accepting and refusing.
- Confirm a refusal is honored across every path that accesses the same capability or data.

**Exceptions:** A dangerous or unsupported state can require an extra warning when the warning is factual and proportionate.

### FND-TRUST-003 — Do not fabricate proof or urgency

**Level:** prohibited  
**Applies when:** Showing scarcity, countdowns, testimonials, activity, popularity, endorsements, or demand.

Do not invent, exaggerate, or present stale evidence as current. Do not imply a time, inventory, or social constraint that does not exist.

**Why:** Manufactured pressure distorts decisions and makes factual claims the product cannot substantiate.

**Verify:**

- Trace each claim to current evidence and its display logic.
- Confirm the claim expires or updates when its supporting condition changes.

**Exceptions:** None.

### FND-TRUST-004 — Optimize with user guardrails

**Level:** required  
**Applies when:** Optimizing conversion, engagement, retention, or revenue.

Evaluate user harm and downstream outcomes alongside the target metric. At minimum consider complaints, cancellations, refunds, reversals, accessibility, comprehension, and long-term retention where relevant.

**Why:** A local metric can improve by shifting cost, confusion, or harm to another part of the user journey.

**Verify:**

- Review the metric definition and decision record for user-centered guardrails.
- Confirm a breached guardrail receives explicit review rather than being hidden by the primary result.

**Exceptions:** Inapplicable guardrails can be omitted when the reason is recorded.

### FND-TRUST-005 — Make defaults and framing honest

**Level:** required  
**Applies when:** Setting a default, ordering choices, recommending an option, or describing an alternative.

Choose and explain defaults according to the user's likely intent and material interests. State relevant costs and tradeoffs consistently across options.

**Why:** Defaults and framing influence decisions even when every option remains technically available.

**Verify:**

- Confirm the default has a documented user-centered rationale.
- Compare option labels and descriptions for asymmetric omissions, emotionally loaded wording, or false equivalence.

**Exceptions:** A legal or safety requirement can determine the default; identify the governing requirement.

### FND-TRUST-006 — Provide a practical exit or reversal

**Level:** required  
**Applies when:** A user can subscribe, enroll, grant access, publish, connect data, or begin a recurring relationship.

Provide a discoverable way to stop, revoke, export, undo, or leave that is proportionate to the way the user entered. Explain effects that cannot be reversed.

**Why:** Consent loses value when users cannot later withdraw it or understand what withdrawal changes.

**Verify:**

- Complete the exit or reversal flow using an ordinary account.
- Confirm retained data, remaining charges, access changes, and timing are stated before final confirmation.

**Exceptions:** Identity or security checks can protect a high-impact exit, but must not add unrelated retention friction.

### FND-TRUST-007 — Do not disguise commercial content or material terms

**Level:** prohibited  
**Applies when:** Presenting prices, fees, subscriptions, advertisements, endorsements, rankings, comparisons, or sponsored content.

Do not hide mandatory costs or renewal terms, make advertisements resemble independent content, imply a neutral ranking when placement is paid, or use visual hierarchy to obscure a material alternative or term.

**Why:** Users cannot make an informed decision when the interface conceals who benefits, what the total obligation is, or why an option is presented.

**Verify:**

- Trace the displayed price through checkout and confirm all unavoidable charges and recurrence are disclosed before commitment.
- Inspect advertising, sponsorship, affiliate, ranking, and comparison surfaces for clear provenance and selection criteria.
- Compare prominence and wording of material terms and alternatives at the decision point.

**Exceptions:** Taxes or usage-dependent charges that cannot be known in advance must be explained with the calculation basis and shown as soon as the required inputs are available.

### FND-TRUST-008 — Identify automated judgment and its limits

**Level:** required  
**Applies when:** A model or agent generates consequential information, recommendations, decisions, communications, or actions that a person could reasonably mistake for verified human work.

Make the automated role, material limits, source basis, and responsible human or organization clear at the point where they affect trust or action. Do not imply that an agent observed, verified, understood, approved, or completed more than the evidence shows.

**Why:** People cannot calibrate reliance or seek review when automated output is presented as authoritative human judgment.

**Verify:**

- Review the final interaction for who or what produced the result, what evidence it used, and who remains accountable.
- Confirm uncertainty, unavailable evidence, and unperformed actions appear next to the affected claim.
- Test whether a reasonable user can distinguish a draft, recommendation, simulated action, pending action, and completed action.

**Exceptions:** Routine low-risk automation need not announce every mechanical step when the product context already makes automation clear and no material judgment is implied.

### FND-TRUST-009 — Preserve control over delegated actions

**Level:** required  
**Applies when:** A system proposes or performs actions on a person's behalf.

Let the person see and change the objective, important assumptions, scope, recipients, data, and material consequences before a high-impact or hard-to-reverse action. Provide practical pause, cancel, correction, escalation, and recovery paths, and do not turn silence or delayed response into permission for expanded action.

**Why:** Delegation is not informed when the system can silently broaden the task or commit consequences the person did not review.

**Verify:**

- Exercise review, edit, approve, deny, pause, cancel, timeout, partial completion, and recovery states.
- Confirm approval binds the exact action and expires or reopens when target, data, cost, or consequence changes.
- Verify denied or unanswered requests do not proceed through a different tool or fallback.

**Exceptions:** A pre-authorized, low-impact recurring action can proceed within a visible scope, limit, duration, and revocation control.

## Guidance

Evaluate the whole journey, not one screen. A clear button does not repair a misleading acquisition claim, a hidden recurring charge, or a cancellation path that requires a different channel.

Use neutral, concrete language. State “Continue with the free plan” rather than “No, I do not want to grow.” Give the same care to decline, later, and close paths as to the preferred conversion path.

When business and user interests differ, record the tradeoff and decision owner. Do not disguise the conflict as a writing or layout choice.

## Examples

### Recurring purchase

Non-compliant: “Start free trial” with the renewal price visible only after confirmation.

Compliant: “Start 14-day free trial. Then $20 per month until canceled.” The price and recurrence appear next to the confirmation control.

### Consent

Non-compliant: A prominent “Accept all” button and a low-contrast link that opens several additional screens to refuse.

Compliant: “Accept all” and “Reject nonessential” are available at the same decision point, and both choices take effect immediately.

## Sources

- World Wide Web Consortium, [Ethical Web Principles](https://www.w3.org/TR/ethical-web-principles/), December 12, 2024. Reviewed August 13, 2026.
- World Wide Web Consortium, [Web Platform Design Principles](https://www.w3.org/TR/design-principles/), February 24, 2026. Reviewed August 13, 2026.
- World Wide Web Consortium, [Privacy Principles](https://www.w3.org/TR/privacy-principles/), May 15, 2025. Reviewed August 13, 2026.
- Federal Trade Commission, [FTC report shows rise in sophisticated dark patterns designed to trick and trap consumers](https://www.ftc.gov/news-events/news/press-releases/2022/09/ftc-report-shows-rise-sophisticated-dark-patterns-designed-trick-trap-consumers), September 15, 2022. Reviewed August 13, 2026.
- Anthropic, [Trustworthy agents in practice](https://www.anthropic.com/research/trustworthy-agents). Reviewed August 13, 2026.
- OpenAI, [Safety in building agents](https://developers.openai.com/api/docs/guides/agent-builder-safety). Reviewed August 13, 2026.
