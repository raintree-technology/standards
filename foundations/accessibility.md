---
id: FND-ACCESSIBILITY
title: Accessibility and inclusive interaction
description: Cross-platform requirements for perceivable, operable, understandable, and compatible product experiences.
type: foundation
status: draft
governance_status: draft
owners: [accessibility, design, engineering]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [user-interface, content, communication]
tags: [accessibility, inclusive-design, interaction]
depends_on: [FND-EVIDENCE, FND-TRUST]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: wcag-22
    resource: https://www.w3.org/TR/WCAG22/
    title: Web Content Accessibility Guidelines 2.2
    author: organization:w3c
  - id: wai-aria-12
    resource: https://www.w3.org/TR/wai-aria-1.2/
    title: Accessible Rich Internet Applications 1.2
    author: organization:w3c
  - id: apple-hig-accessibility
    resource: https://developer.apple.com/design/human-interface-guidelines/accessibility
    title: Accessibility
    author: organization:apple
  - id: android-accessibility
    resource: https://developer.android.com/guide/topics/ui/accessibility
    title: Build accessible apps
    author: organization:google
---

# Accessibility and inclusive interaction

People must be able to perceive, understand, navigate, and operate supported experiences using the input, display, language, and assistive configurations they need. Legal conformance targets remain jurisdiction-specific and require qualified review.

## Rules

### FND-ACCESSIBILITY-001 — Define the accessibility target

**Level:** required
**Applies when:** Creating or materially changing a user-facing product, service, document, or communication.

Record the supported platforms, accessibility baseline, user groups, assistive technologies, input methods, and any governing legal or contractual target before acceptance testing.

**Why:** A generic claim of accessibility cannot be verified without a defined scope and conformance target.

**Verify:**

- Inspect the release record for the declared target, supported environments, and qualified owner.
- Confirm that excluded environments or criteria have evidence, risk, and an approved exception.

**Exceptions:** None for work presented as accessible or governed by an accessibility obligation.

### FND-ACCESSIBILITY-002 — Preserve equivalent meaning and operation

**Level:** required
**Applies when:** Information or functionality uses visual, auditory, motion, gesture, spatial, or timed presentation.

Provide an equivalent way to perceive the information and complete the task without depending on one sense, precise gesture, device orientation, or time-limited response unless that characteristic is essential.

**Why:** A single presentation or input channel can exclude people and make recovery impossible.

**Verify:**

- Exercise the task without color, sound, motion, dragging, hover, or a precise pointer as applicable.
- Inspect text alternatives, captions, transcripts, status announcements, and simpler input paths.

**Exceptions:** Essential sensory or timing characteristics require documented purpose, the closest practical alternative, and qualified accessibility review.

### FND-ACCESSIBILITY-003 — Support navigation and focus

**Level:** required
**Applies when:** An experience contains interactive controls, navigation, dialogs, dynamic regions, or multiple steps.

Keep focus visible, logical, and under user control. Make every supported action reachable without a pointer, preserve a meaningful reading order, and return focus predictably after temporary surfaces close.

**Why:** Missing or unexpected focus prevents keyboard, switch, voice, and screen-reader users from locating and operating controls.

**Verify:**

- Complete representative flows with keyboard or the platform-equivalent non-pointer input.
- Inspect focus order, focus appearance, modal containment, escape behavior, and focus restoration.

**Exceptions:** None for functionality that the target platform exposes through discrete navigation.

### FND-ACCESSIBILITY-004 — Expose names, roles, states, and relationships

**Level:** required
**Applies when:** Software renders controls, status, validation, structure, or changing content.

Use native platform semantics where available and expose accurate names, roles, values, states, errors, instructions, and relationships to accessibility APIs.

**Why:** Visual appearance alone does not provide the programmatic information assistive technology needs.

**Verify:**

- Inspect the accessibility tree or platform inspector for representative states.
- Operate custom components with a supported screen reader and input method.

**Exceptions:** A custom semantic implementation is allowed only when no native element meets the behavior and the complete interaction contract is tested.

### FND-ACCESSIBILITY-005 — Preserve readable and adaptable presentation

**Level:** required
**Applies when:** Presenting text, icons, controls, data, or layouts.

Maintain sufficient contrast, scalable text, distinguishable focus and state, usable target sizes, and reflow or adaptation under supported zoom, text size, orientation, contrast, color scheme, and localization settings.

**Why:** Fixed or low-contrast presentation can make content unreadable or controls unusable.

**Verify:**

- Measure applicable contrast and target-size criteria against the declared baseline.
- Inspect representative screens at supported zoom, text-size, contrast, theme, orientation, and locale extremes.

**Exceptions:** Brand or data colors may remain when an additional accessible cue and an equivalent high-contrast presentation are provided.

### FND-ACCESSIBILITY-006 — Make errors and changes understandable

**Level:** required
**Applies when:** Input can fail, content changes asynchronously, or an action has material consequences.

Identify errors in text, associate them with the affected input, announce important changes without stealing control, and provide prevention, review, correction, or reversal for consequential actions.

**Why:** Users can miss visual-only errors and unexpected updates or be unable to recover from a mistake.

**Verify:**

- Trigger validation, loading, success, failure, timeout, and destructive-action states with assistive technology.
- Confirm the user can locate, understand, correct, and resubmit without losing valid work.

**Exceptions:** None for errors that block completion or actions with material consequences.

### FND-ACCESSIBILITY-007 — Test with people and assistive technology

**Level:** required
**Applies when:** Accessibility materially affects release acceptance.

Combine automated checks, manual interaction checks, accessibility-tree inspection, and representative human evaluation. Do not treat an automated scan as proof of conformance.

**Why:** Automated tools detect only part of the applicable behavior and cannot determine whether a task is understandable or practical.

**Verify:**

- Preserve tool versions, configurations, findings, manual checks, environments, and resolved or accepted limitations.
- Include qualified review or representative user evaluation for high-impact, novel, or repeatedly failing flows.

**Exceptions:** Early prototypes may defer human evaluation when no release claim is made and the review is scheduled before commitment.

## Guidance

Use WCAG as the web baseline and current platform guidance for native applications. Platform guidance can strengthen a target but does not replace applicable law or a declared conformance standard. Include disability and assistive-technology perspectives during design, not only after implementation.

## Examples

### Checkout confirmation

Non-compliant: A purchase occurs when an icon-only button is tapped; the error state is shown only by a red border.

Compliant: The control has an accessible name, the order is reviewed before purchase, errors are identified in text and programmatically associated, and the completed purchase is announced without moving focus unexpectedly.

## Sources

- World Wide Web Consortium, [Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/). Reviewed August 13, 2026.
- World Wide Web Consortium, [Accessible Rich Internet Applications 1.2](https://www.w3.org/TR/wai-aria-1.2/). Reviewed August 13, 2026.
- Apple, [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility). Reviewed August 13, 2026.
- Google, [Build accessible apps](https://developer.android.com/guide/topics/ui/accessibility). Reviewed August 13, 2026.
