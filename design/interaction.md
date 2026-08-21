---
id: DESIGN-INTERACTION
title: Interaction design
description: Requirements for coherent flows, navigation, forms, states, responsive behavior, and governed design systems.
type: standard
status: draft
governance_status: draft
owners: [design, product, engineering, accessibility]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [user-interface, product-feature]
tags: [design, interaction, usability, design-system]
depends_on: [FND-ACCESSIBILITY, FND-TRUST, PRODUCT-DELIVERY]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: wcag-22
    resource: https://www.w3.org/TR/WCAG22/
    title: Web Content Accessibility Guidelines 2.2
    author: organization:w3c
  - id: uswds-design-principles
    resource: https://designsystem.digital.gov/design-principles/
    title: USWDS Design Principles
    author: organization:us-government
  - id: apple-hig
    resource: https://developer.apple.com/design/human-interface-guidelines
    title: Human Interface Guidelines
    author: organization:apple
---

# Interaction design

Interfaces must help people understand where they are, what they can do, what will happen, and how to recover across supported devices, inputs, content, and system states.

## Rules

### DESIGN-INTERACTION-001 — Design the complete task flow

**Level:** required  
**Applies when:** A user starts, progresses through, or exits a multi-step task.

Map entry points, prerequisites, decisions, state changes, exits, interruptions, resumption, success, and recovery before approving the interaction.

**Why:** Screen-by-screen design misses transitions where users lose context, work, or control.

**Verify:**

- Walk representative first-time, returning, interrupted, denied, failed, and completed journeys.
- Confirm the system state and next available action at every transition.

**Exceptions:** A single atomic action may use a state model instead of a journey map.

### DESIGN-INTERACTION-002 — Keep navigation and hierarchy predictable

**Level:** required  
**Applies when:** Users move among views, sections, modes, or nested content.

Use consistent destinations, labels, placement, hierarchy, back behavior, and location cues. Do not change navigation context merely because an element receives focus or input.

**Why:** Inconsistent navigation increases memory load and can strand users after a state change.

**Verify:**

- Exercise deep links, back and forward navigation, refresh or relaunch, and responsive variants.
- Confirm repeated destinations retain meaning and relative organization.

**Exceptions:** A changed context may use different navigation when the transition is explicit and reversible.

### DESIGN-INTERACTION-003 — Use familiar controls with complete states

**Level:** required  
**Applies when:** Selecting or creating an interactive component.

Prefer the platform or design-system component whose semantics and behavior match the task. Define default, hover where relevant, focus, active, selected, disabled, loading, success, error, and unavailable states.

**Why:** Custom or incomplete controls create inconsistent behavior and accessibility gaps.

**Verify:**

- Compare the rendered component with its governed contract across input modes and states.
- Confirm a custom component supplies the complete semantics and interaction behavior it replaces.

**Exceptions:** A new pattern requires documented need, usability and accessibility evidence, ownership, and addition to the design system when reused.

### DESIGN-INTERACTION-004 — Make forms efficient and recoverable

**Level:** required  
**Applies when:** Users enter, select, review, or submit information.

Ask only for needed information, use suitable input controls and autocomplete, preserve valid work, validate at a helpful time, explain requirements, and support correction before resubmission.

**Why:** Forms impose direct effort and errors can block essential tasks or destroy work.

**Verify:**

- Complete the form with valid, invalid, partial, pasted, autofilled, long, localized, and interrupted input.
- Confirm labels, instructions, errors, focus, review, and resubmission remain coherent.

**Exceptions:** Security-sensitive fields may restrict persistence or autocomplete when the threat and user impact are documented.

### DESIGN-INTERACTION-005 — Adapt without losing meaning or operation

**Level:** required  
**Applies when:** Layout can change with viewport, window, orientation, input, text size, locale, or content length.

Reflow and reprioritize while preserving essential content, controls, relationships, reading order, and task continuity. Do not hide required functionality only because space is constrained.

**Why:** A layout that merely shrinks can obscure actions, overlap content, and break alternate input modes.

**Verify:**

- Inspect declared breakpoints and extremes for text, zoom, locale, orientation, window size, and input mode.
- Confirm hidden or moved content remains discoverable and operable.

**Exceptions:** Platform-inapplicable features may be absent when the product scope states the difference.

### DESIGN-INTERACTION-006 — Represent system status and latency

**Level:** required  
**Applies when:** An action, load, synchronization, or background process is not immediate.

Show whether work is pending, progressing, delayed, completed, partially completed, failed, cancelled, or safe to leave. Prevent duplicate commitment while preserving a controlled retry or cancel path.

**Why:** Silent latency causes repeated actions, lost confidence, and abandonment.

**Verify:**

- Exercise fast, slow, offline, timeout, partial, cancelled, repeated, and recovered states.
- Confirm status is perceivable without trapping input or fabricating progress.

**Exceptions:** Imperceptibly short deterministic work need not display progress.

### DESIGN-INTERACTION-007 — Prevent and recover from consequential mistakes

**Level:** required  
**Applies when:** An action can cause financial, privacy, security, legal, destructive, or difficult-to-reverse effects.

Present the consequence before commitment and provide appropriate review, confirmation, authorization, reversal, or recovery without relying on a generic confirmation dialog alone.

**Why:** Familiar or visually prominent controls can make severe actions too easy to trigger accidentally.

**Verify:**

- Exercise accidental activation, wrong target, stale state, duplicate action, cancellation, and recovery.
- Confirm the safeguard describes the specific object and consequence.

**Exceptions:** Immediate emergency action may omit confirmation when delay creates greater harm and recovery is addressed.

### DESIGN-INTERACTION-008 — Govern reusable design decisions

**Level:** required  
**Applies when:** Components, tokens, patterns, or content conventions are reused across products.

Version their contract, accessibility behavior, supported variants, ownership, adoption guidance, change policy, and deprecation path. Keep implementation and design references synchronized.

**Why:** An unmanaged design system spreads defects and inconsistent behavior faster than local code.

**Verify:**

- Compare representative product instances with the released component contract.
- Run visual, behavioral, accessibility, and compatibility checks before promotion.

**Exceptions:** A one-off local pattern need not enter the shared system unless reuse or governance value is demonstrated.

## Guidance

Treat visual polish as support for comprehension, hierarchy, and feedback. Use motion to explain change without delaying work or excluding people. Validate with realistic content and tasks rather than idealized placeholder screens.

## Examples

### Destructive bulk action

Non-compliant: A red trash icon immediately deletes selected records and shows a temporary toast.

Compliant: The action names the selected scope and consequence, requires appropriate authorization and review, prevents duplicate submission, reports partial outcomes, and provides reversal or a documented recovery path.

## Sources

- World Wide Web Consortium, [Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/). Reviewed August 13, 2026.
- US Web Design System, [Design Principles](https://designsystem.digital.gov/design-principles/). Reviewed August 13, 2026.
- Apple, [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines). Reviewed August 13, 2026.
