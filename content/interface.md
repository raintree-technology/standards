---
id: CONTENT-INTERFACE
title: Interface content
description: Requirements for clear labels, guidance, states, confirmations, inclusive language, and localization-ready interface text.
type: standard
status: draft
governance_status: draft
owners: [content, design, product, accessibility]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [interface-content, product-feature]
tags: [content, interface, localization]
depends_on: [WRITING-FUNCTIONAL, FND-TRUST, FND-ACCESSIBILITY]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: digital-plain-language-design
    resource: https://digital.gov/guides/plain-language/design
    title: Design for understanding
    author: organization:us-government
  - id: plain-language-guidelines
    resource: https://www.plainlanguage.gov/guidelines/
    title: Federal Plain Language Guidelines
    author: organization:us-government
  - id: w3c-i18n
    resource: https://www.w3.org/International/i18n-drafts/nav/about
    title: Internationalization techniques authoring web pages
    author: organization:w3c
---

# Interface content

Interface text must help people recognize, decide, act, and recover in context without hiding consequences, relying on internal terminology, or breaking when localized.

## Rules

### CONTENT-INTERFACE-001 — Name controls by their outcome

**Level:** required  
**Applies when:** Text labels an action, destination, field, option, or setting.

Use the shortest specific wording that tells the user what the control affects or where it goes. Keep the visible label and accessible name consistent.

**Why:** Generic labels force users to infer meaning from position or surrounding content.

**Verify:**

- Read labels out of visual context and confirm their target or result remains distinguishable.
- Compare rendered labels, accessible names, analytics names, and documentation.

**Exceptions:** Universally understood platform controls may use an icon when an accurate accessible name and discoverable meaning remain.

### CONTENT-INTERFACE-002 — Explain required information in context

**Level:** required  
**Applies when:** Asking for input, permission, consent, configuration, or commitment.

State what is needed, why it is needed when not obvious, the expected format or scope, and any material consequence before the user commits.

**Why:** Users cannot make an informed choice when purpose and consequence appear only after submission.

**Verify:**

- Inspect the decision point without relying on hidden help, terms, or post-submit errors.
- Confirm optional and required inputs are identified consistently.

**Exceptions:** None for material data use, payment, authorization, or irreversible effects.

### CONTENT-INTERFACE-003 — Give every state a useful message

**Level:** required  
**Applies when:** A view or component can be empty, loading, pending, offline, partially complete, unavailable, successful, or failed.

State the current condition, its scope, whether work is continuing or preserved, and the next available action. Do not use success language before the outcome is confirmed.

**Why:** Blank or vague states make users guess whether the system, data, or their action failed.

**Verify:**

- Trigger each material state and compare the message with actual system state and available actions.
- Confirm status is announced appropriately to assistive technology.

**Exceptions:** Decorative or self-evident transient states may omit text when equivalent programmatic status exists.

### CONTENT-INTERFACE-004 — Make confirmations specific to the consequence

**Level:** required  
**Applies when:** Asking a user to confirm a consequential action.

Name the action, affected object or scope, immediate and delayed consequences, reversibility, and the exact commitment control. Avoid generic questions such as “Are you sure?”

**Why:** Generic confirmations become habitual and do not help users catch the wrong action or target.

**Verify:**

- Review confirmation text with realistic names, counts, permissions, and partial outcomes.
- Confirm cancel and commitment controls cannot be confused.

**Exceptions:** None when confirmation is the primary safeguard.

### CONTENT-INTERFACE-005 — Use inclusive, non-blaming language

**Level:** required  
**Applies when:** Referring to people, identity, ability, failure, eligibility, or behavior.

Use relevant, respectful, specific language; avoid stereotypes, unnecessary identity references, assumptions, blame, and metaphors that obscure the task.

**Why:** Exclusionary or blaming language harms users and can make instructions less accurate.

**Verify:**

- Review terms with affected users or qualified guidance when identity or harm is material.
- Check that failure messages describe the condition and recovery rather than assigning fault.

**Exceptions:** Exact user-provided, legal, clinical, or policy terms may be retained when required and explained in plain language.

### CONTENT-INTERFACE-006 — Keep terminology consistent across the journey

**Level:** required  
**Applies when:** The same object, action, status, or measure appears in multiple surfaces.

Use one governed term unless a platform convention or audience requires a documented variation. Do not alternate synonyms for style.

**Why:** Users can mistake inconsistent names for different concepts or states.

**Verify:**

- Search the interface, messages, help, notifications, and support material for concept variants.
- Confirm the terminology source has an owner and definition.

**Exceptions:** Audience-specific language may vary when the mapping is explicit and tested.

### CONTENT-INTERFACE-007 — Prepare complete units for localization

**Level:** required  
**Applies when:** Interface content may be translated or localized.

Store complete messages with context, variables, plural and grammatical behavior, and sufficient layout flexibility. Do not build sentences from separately translated fragments.

**Why:** Fragmented text loses grammar, meaning, and accessibility across languages.

**Verify:**

- Inspect representative short, long, plural, gender-sensitive, bidirectional, and fallback locales.
- Confirm variables are safe, named, formatted, and visible to translators with context.

**Exceptions:** Atomic labels and values may remain separate when they do not form a grammatical sentence.

### CONTENT-INTERFACE-008 — Review content in the rendered interaction

**Level:** required  
**Applies when:** Approving interface content for release.

Inspect the final text with realistic data, layout, states, input methods, and assistive output rather than approving strings in isolation.

**Why:** Correct source text can truncate, reorder, lose association, or contradict behavior when rendered.

**Verify:**

- Record the environments, states, locales, and assistive presentation inspected.
- Confirm the rendered action and protocol result match the words.

**Exceptions:** None for consequential or frequently used interfaces.

## Guidance

Prefer familiar words and direct sentences. Put the outcome before background. Coordinate interface content with product behavior so the message does not promise recovery, timing, access, or completion the system cannot provide.

## Examples

### Empty search result

Non-compliant: “Nothing here.”

Compliant: “No invoices match ‘April’. Check the spelling, remove a filter, or clear the search.”

## Sources

- US General Services Administration, [Design for understanding](https://digital.gov/guides/plain-language/design). Reviewed August 13, 2026.
- US Government, [Federal Plain Language Guidelines](https://www.plainlanguage.gov/guidelines/). Reviewed August 13, 2026.
- World Wide Web Consortium, [Internationalization techniques: Authoring web pages](https://www.w3.org/International/i18n-drafts/nav/about). Reviewed August 13, 2026.
