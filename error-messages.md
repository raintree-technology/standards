---
id: CONTENT-ERRORS
title: Error messages
description: Defines actionable, safe, accessible, and technically honest user-facing failure messages.
type: standard
status: stable
governance_status: active
owners: [content, product, design]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [product-feature, public-web-page, support-experience, functional-writing]
tags: [content, errors, interface-copy]
depends_on: [FND-TRUST, FND-ACCESSIBILITY, WRITING-FUNCTIONAL, CONTENT-INTERFACE]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: wcag-22
    resource: https://www.w3.org/TR/WCAG22/
    title: Web Content Accessibility Guidelines 2.2
    author: organization:w3c
  - id: ietf-http-semantics
    resource: https://www.rfc-editor.org/rfc/rfc9110.html
    title: HTTP Semantics
    author: organization:ietf
  - id: ietf-additional-status
    resource: https://www.rfc-editor.org/rfc/rfc6585.html
    title: Additional HTTP Status Codes
    author: organization:ietf
  - id: ietf-problem-details
    resource: https://www.rfc-editor.org/rfc/rfc9457.html
    title: Problem Details for HTTP APIs
    author: organization:ietf
  - id: wix-error-messages
    resource: https://wix-ux.com/when-life-gives-you-lemons-write-better-error-messages-46c5223e1a2f
    title: When life gives you lemons, write better error messages
    author: human:jenni-nadler
  - id: anthropic-effective-agents
    resource: https://www.anthropic.com/engineering/building-effective-agents
    title: Building effective agents
    author: organization:anthropic
  - id: scale-mcp-atlas
    resource: https://scale.com/blog/mcp-atlas
    title: Actions, Not Words - MCP-Atlas Raises the Bar for Agentic Evaluation
    author: organization:scale-ai
---

# Error messages

A user-facing failure must leave the user knowing what happened and what to do next, with the cause, preservation state, and support path included when relevant. This standard covers inline validation, toasts, banners, dialogs, full-page failures, offline states, and failure-caused empty states.

Prevent avoidable failures before writing them: validate at the right time, preserve input, autosave where appropriate, disable actions that cannot succeed, and confirm destructive actions.

## Rules

### CONTENT-ERRORS-001 — State what happened and the next action

**Level:** required
**Applies when:** Showing any user-facing failure.

State what did or did not happen, then give one concrete next action or an honest statement that no action is available yet. Include the known cause, what was preserved or lost, and a support path when they affect the user's decision.

**Why:** “Something went wrong” confirms failure but does not help the user recover or judge impact.

**Verify:**

- Identify the failed action or unavailable state in the message.
- Follow the stated next step and confirm it can resolve or route around the actual trigger.
- Confirm preservation and loss claims against system behavior.

**Exceptions:** A security-sensitive message can withhold cause under `CONTENT-ERRORS-004` but still owes the user the failed outcome and a safe next action.

### CONTENT-ERRORS-002 — Match the surface and persistence to severity

**Level:** required
**Applies when:** Choosing where and how a failure appears.

Place field-specific errors at the field, ongoing conditions in a persistent page-level region, blocking decisions in a focused interruption, and destination failures on a full page. Any message that requires action must remain available until the action is completed, replaced, or intentionally dismissed.

**Why:** A blocking failure hidden in a temporary toast strands users, while a dialog for a minor correction interrupts them unnecessarily.

**Verify:**

- Trigger the failure in context and confirm the message appears where the user is looking or acting.
- Confirm actionable content does not disappear before it can be read and used.
- Check repeated and simultaneous errors for priority and duplication.

**Exceptions:** A toast can report a non-blocking outcome when no immediate response is required or the same recovery action remains available elsewhere.

### CONTENT-ERRORS-003 — Use calm language without blame

**Level:** required
**Applies when:** Writing failure text or action labels.

Use plain, direct language that matches the stakes. Describe the condition rather than blaming the user or a provider. Do not use playful interjections, jokes, excessive apology, or jargon. Label the primary action with the recovery verb.

**Why:** Users often encounter errors while stressed or interrupted; blame and vague tone increase confusion without improving recovery.

**Verify:**

- Remove “Oops,” “Whoops,” “Yikes,” “Uh oh,” and similar openers.
- Replace mechanism-first language, error codes, and passive blame with user-relevant meaning.
- Confirm buttons say what they do, such as “Reconnect account” or “Try again,” rather than “OK.”

**Exceptions:** A legal or safety message can require formal language, but must remain understandable and actionable.

### CONTENT-ERRORS-004 — Balance specificity with security

**Level:** required
**Applies when:** The system knows a cause, but disclosing it could expose accounts, fraud controls, internal architecture, or sensitive state.

Give the most specific explanation that remains safe. Do not reveal whether an account exists, which credential was correct, detection thresholds, stack traces, queries, file paths, secrets, or internal service names.

**Why:** Detailed diagnostics can help an attacker enumerate accounts, bypass controls, or map internal systems.

**Verify:**

- Review authentication, password reset, access, anti-abuse, payment, and rate-limit messages for enumeration and implementation disclosure.
- Confirm detailed diagnostics are recorded only in protected logs with a correlation path for support.

**Exceptions:** A non-sensitive request or correlation ID can appear in secondary text when support can use it and it conveys no protected information.

### CONTENT-ERRORS-005 — Preserve work and provide a way out

**Level:** required
**Applies when:** A failed action involves user input, a retry, an external dependency, or a recurring condition.

Preserve valid input and completed work where technically possible. Make retry safe, state what was retained, prevent duplicate side effects, and provide an alternate path or support route when retry can fail again.

**Why:** Recovery that destroys work, double-charges, duplicates actions, or loops indefinitely turns a transient failure into user harm.

**Verify:**

- Trigger failure before and after submission, then inspect retained input and durable state.
- Repeat the action and confirm idempotency or explicit duplicate protection where needed.
- Follow the alternate or support path.

**Exceptions:** Sensitive fields can require re-entry when retention would create greater security risk; explain the requirement without exposing the sensitive value.

### CONTENT-ERRORS-006 — Make errors accessible

**Level:** required
**Applies when:** A failure appears in a visual or interactive interface.

Use words and semantics in addition to color or icons. Connect inline errors to their fields, identify invalid state programmatically, announce dynamic errors appropriately, and move focus only when needed to make a failed submission understandable.

**Why:** Visual placement, color, and live changes are not perceivable in the same way by every user.

**Verify:**

- Trigger errors with keyboard and a representative screen reader.
- Confirm the error is announced once, names the affected field or action, and does not trap or unexpectedly steal focus.
- Inspect contrast, zoom, reflow, and persistence.

**Exceptions:** Static content already encountered in reading order does not need a live announcement.

### CONTENT-ERRORS-007 — Localize complete messages

**Level:** required
**Applies when:** Error text can be translated or shown in more than one locale.

Provide translators complete sentences with named placeholders and context. Do not concatenate fragments, embed assumptions about word order, or hard-code locale-specific dates, numbers, or time zones. Allow layout expansion and set correct language and direction.

**Why:** Error messages often contain variables and instructions whose grammar and order differ across languages.

**Verify:**

- Inspect placeholder definitions and translator context.
- Render representative long, plural, right-to-left, and non-Latin messages.
- Confirm full-page navigation and support routes remain in the user's locale.

**Exceptions:** A product with one supported locale must still keep dynamic values distinct from sentence fragments.

### CONTENT-ERRORS-008 — Keep protocol and human meaning consistent

**Level:** required
**Applies when:** A failure is represented through HTTP or another machine-consumed protocol.

Return the status and retry metadata that describe the actual condition. Do not serve missing or failed content with a success status, redirect unrelated missing pages to a generic destination, or describe planned downtime while returning success.

**Why:** Crawlers, clients, caches, monitoring, and automation act on protocol semantics even when the visible copy sounds correct.

**Verify:**

- Inspect headers and rendered bodies for missing, forbidden, gone, server-failure, maintenance, and rate-limit cases.
- Confirm planned unavailability uses `503` and appropriate `Retry-After`; client-specific throttling uses `429` and appropriate retry guidance.
- Verify error pages remain available when the application or a third party is unavailable.

**Exceptions:** Security policy can intentionally collapse some client-visible statuses; document the policy and preserve accurate internal observability.

### CONTENT-ERRORS-009 — Map each message to a known trigger

**Level:** required
**Applies when:** Implementing, reviewing, or reusing an error message.

Give each message or failure family a stable identifier and map it to its triggering conditions, owning component, severity, user impact, and recovery path. Do not reuse one generic string across failures that require different actions.

**Why:** Writers cannot make a message accurate without knowing what the system knows, and teams cannot prioritize errors they cannot trace.

**Verify:**

- Follow the message ID from interface to code path, logs or telemetry, and content owner.
- Confirm every mapped trigger has the same user meaning and recovery action.

**Exceptions:** A last-resort unknown-error fallback can cover truly unclassified failures if it creates a traceable diagnostic event and an owned follow-up.

### CONTENT-ERRORS-010 — Review failures as product behavior

**Level:** required
**Applies when:** Shipping a new failure path or maintaining a recurring one.

Review frequency, blocking impact, recovery success, accessibility, support demand, and fallback use. Prioritize failures by user harm and frequency, and retire obsolete messages and telemetry.

**Why:** Error content becomes inaccurate as systems and recovery paths change, and frequent messages often reveal preventable product defects.

**Verify:**

- Inspect real trigger and recovery data after release on a defined schedule.
- Confirm high-frequency, high-impact, and fallback errors have owners and actions.
- Re-run the ship checklist after system or support-path changes.

**Exceptions:** Low-volume systems can use scheduled manual review when automated frequency data is unavailable.

### CONTENT-ERRORS-011 — Use stable machine-readable API problems

**Level:** required
**Applies when:** An HTTP API returns errors to software clients and does not already have a governed domain error format.

Use RFC 9457 problem details or an equally stable documented contract. Give each problem type durable semantics, an appropriate HTTP status, a short stable title, occurrence-specific human detail, structured extension fields for machine decisions, and documentation for recovery.

**Why:** Clients break when they must parse human prose, implementation messages, or inconsistent response shapes to decide how to recover.

**Verify:**

- Compare representative responses with the published schema and problem-type documentation.
- Confirm clients branch on status, type, and structured fields rather than localized `detail` text.
- Review problem fields for internal, personal, account-enumeration, and security-sensitive disclosure.

**Exceptions:** An established domain protocol can retain its native error format when status and recovery semantics are documented and consistent.

### CONTENT-ERRORS-012 — Prevent high-impact submission errors

**Level:** required
**Applies when:** A submission creates a legal or financial commitment, changes or deletes user-controlled data, publishes sensitive information, or is otherwise difficult to reverse.

Before final submission, provide at least one effective safeguard: make the action reversible, validate and let the user correct the data, or present a review and confirmation step that identifies the material consequence.

**Why:** An explanatory error shown after an irreversible action cannot prevent the loss, obligation, or disclosure.

**Verify:**

- Complete the flow with an intentional mistake and confirm the safeguard detects, exposes, or reverses it.
- Confirm the review step displays the decision-relevant values and consequence, not only a generic confirmation question.
- Test keyboard, assistive-technology, timeout, retry, and duplicate-submission behavior.

**Exceptions:** None when the governing accessibility or product policy requires error prevention; other high-impact flows need an approved alternate control if all three safeguards are technically impossible.

### CONTENT-ERRORS-013 — Make tool failures actionable to agents

**Level:** required
**Applies when:** An API, function, MCP tool, job, or command returns an error that an automated caller may handle.

Return a stable error code or type, safe human summary, affected operation or field, retry classification, and structured correction details needed to recover. Distinguish invalid input, unauthorized scope, unavailable approval, rate or resource limit, temporary dependency failure, conflict, already-completed state, and terminal failure. Do not expose secrets or let free-form error text become executable instruction.

**Why:** Agents often abandon recoverable tasks, retry terminal failures, or repeat side effects when errors do not identify what can safely change.

**Verify:**

- Exercise each error class and confirm a caller can choose correct, retry, stop, escalate, or reconcile behavior without parsing prose.
- Test malformed inputs, wrong units and enumerations, duplicate actions, timeouts after success, partial completion, and unavailable approval.
- Confirm untrusted downstream error content remains labeled data and cannot alter tool authority or instructions.

**Exceptions:** A public client can receive a less detailed safe error while protected logs retain the correlation and diagnostic detail needed by operators.

## Guidance

Use this order when the information applies:

1. What happened.
2. Why it happened.
3. What was preserved or lost.
4. What the user can do.
5. Where the user can go if recovery fails.

Space-constrained messages can omit cause, preservation, or support only when the surrounding interface provides them. They cannot omit the failed outcome or next action.

Select the surface from the user's situation:

| Situation | Preferred surface |
|---|---|
| One field needs correction | Inline at the field when correction is possible |
| A non-blocking action failed and no response is required | Toast, if recovery remains available elsewhere |
| An ongoing condition affects the page or application | Persistent banner or status region |
| The flow cannot continue without a decision or correction | Dialog or focused inline interruption |
| The destination cannot load | Full-page error with truthful protocol status |

Use fine print for correlation IDs and technical details intended for support. Keep the human headline and primary action focused on recovery.

## Templates

### Internal failure with retry

> Couldn't [complete action]. [What was preserved.] This was due to an issue on our end. [Specific retry action]. If it keeps happening, contact [support route].

### Invalid input

> [Field] must [specific requirement].

### Missing access

> [Blocked action] requires [permission or role]. [How to request or change it].

### Offline

> You're offline. [What is available or preserved.] [What reconnecting restores].

### No available action

> [What happened and impact]. We're working on it. [When or where to check for updates]. [Support route if needed].

## Examples

| Non-compliant | Problem | Compliant |
|---|---|---|
| “Whoops! Something went wrong. Try later.” | Playful, generic, and vague | “We couldn't load your reports due to an issue on our end. Refresh to try again. If it keeps happening, contact Support.” |
| “You entered an invalid email.” | Blames the user and omits the rule | “Enter an email address in the format name@example.com.” |
| “PayFlow isn't responding.” | Blames a provider and omits payment state | “We couldn't process the payment. You haven't been charged. Try again in a few minutes.” |
| “Error 403: Forbidden” | Leads with a code and gives no route | “You don't have access to this page. Request access from the workspace owner.” |

## Ship checklist

- [ ] States what did or did not happen.
- [ ] Gives one concrete next action or an honest no-action state.
- [ ] Gives the known safe cause and preservation state when relevant.
- [ ] Offers a route out when retry can fail.
- [ ] Uses calm, plain language without blame or playful tone.
- [ ] Reveals no sensitive account, control, or implementation detail.
- [ ] Uses the correct persistent surface for its severity.
- [ ] Preserves input and prevents duplicate side effects where relevant.
- [ ] Works with keyboard, assistive technology, zoom, and reflow.
- [ ] Uses complete localizable messages.
- [ ] Matches protocol status and retry semantics.
- [ ] Maps to a stable trigger and owner.

## Sources

- World Wide Web Consortium, [Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/), W3C Recommendation, October 5, 2023. Reviewed August 13, 2026.
- Internet Engineering Task Force, [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), June 2022. Reviewed August 13, 2026.
- Internet Engineering Task Force, [RFC 6585: Additional HTTP Status Codes](https://www.rfc-editor.org/rfc/rfc6585.html), April 2012. Reviewed August 13, 2026.
- Internet Engineering Task Force, [RFC 9457: Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html), July 2023. Reviewed August 13, 2026.
- Jenni Nadler, [When life gives you lemons, write better error messages](https://wix-ux.com/when-life-gives-you-lemons-write-better-error-messages-46c5223e1a2f), 2022. Existing provenance source; automated review was unavailable because the site returned `403 Forbidden` on August 13, 2026.
- Anthropic, [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents), December 19, 2024. Reviewed August 13, 2026.
- Scale AI, [Actions, Not Words: MCP-Atlas Raises the Bar for Agentic Evaluation](https://scale.com/blog/mcp-atlas), September 19, 2025. Reviewed August 13, 2026.
