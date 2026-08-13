---
id: PLAYBOOK-APPLE-HIG
title: Apple HIG interface audit
description: Versioned procedure for auditing Apple-platform interfaces against current Apple guidance with optional HIG Doctor evidence.
type: playbook
status: draft
governance_status: draft
owners: [design, apple-platforms, accessibility, engineering]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [apple-interface, apple-platform]
tags: [playbook, apple, hig, audit]
depends_on: [DESIGN-INTERACTION, FND-ACCESSIBILITY, CONTENT-INTERFACE]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: apple-hig
    resource: https://developer.apple.com/design/human-interface-guidelines
    title: Human Interface Guidelines
    author: organization:apple
  - id: apple-accessibility
    resource: https://developer.apple.com/design/human-interface-guidelines/accessibility
    title: Accessibility
    author: organization:apple
  - id: apple-layout
    resource: https://developer.apple.com/design/human-interface-guidelines/layout
    title: Layout
    author: organization:apple
  - id: hig-doctor
    resource: https://github.com/raintree-technology/hig-doctor
    title: HIG Doctor
    author: organization:raintree-technology
---

# Apple HIG interface audit

Use this playbook for Apple-platform work after applying the universal interaction, accessibility, content, trust, and product standards. Apple documentation is canonical for Apple HIG guidance. Automated HIG Doctor findings are supporting evidence, not proof of conformance or design quality.

## Version record

At the August 13, 2026 review, the HIG Doctor repository documented JSON schema version 2, tool version 2.0.0, and an Apple HIG content snapshot dated February 2, 2025. Record the actual tool, rules catalog, engine tier, configuration, baseline, and HIG snapshot used for each audit; recheck current releases rather than copying these values.

## Procedure

1. **Declare platform scope.** Record iOS, iPadOS, macOS, watchOS, tvOS, or visionOS versions, devices, window modes, orientations, inputs, accessibility settings, locales, and Apple technologies in scope.
2. **Review current canonical guidance.** Read the current Apple HIG foundations, applicable components, patterns, inputs, platform conventions, and technology guidance. Record page titles and review date.
3. **Walk the complete task.** Inspect hierarchy, navigation, controls, content, status, errors, permissions, destructive actions, interruption, restoration, and platform integration using realistic data.
4. **Exercise adaptation.** Cover Dynamic Type, VoiceOver, Voice Control where supported, keyboard or focus navigation, increased contrast, reduced motion, dark appearance, localization, right-to-left layout, rotation, multitasking, and resizable windows as applicable.
5. **Run optional automated evidence.** Run HIG Doctor against the final source with a pinned tool and rules version. Preserve JSON or SARIF, engine tiers, configuration, exclusions, suppressions, baseline, and warnings.
6. **Review every material finding manually.** Confirm the cited current HIG page, inspect the actual rendered behavior, identify false positives and false negatives, and record the resolution or governed exception.
7. **Inspect what automation cannot prove.** Review hierarchy, task coherence, platform fit, content quality, state transitions, visual relationships, runtime accessibility, gestures, animation purpose, data accuracy, and real-device behavior.
8. **Retest the final artifact.** Verify resolved findings and representative flows on supported devices or closest justified environments, then bind approval to the exact build.

## Tool boundaries

- HIG Doctor's Apple rules may cite Apple HIG directly; its web and cross-platform rules represent broader accessibility and UI-quality checks and must not be labeled Apple HIG conformance.
- Regex and structural or AST checks have different detection limits. Record the engine reported for each finding.
- A baseline hides known findings from a new-findings gate; it does not approve or remove them.
- Suppression requires the rule ID, reason, approver, scope, and review date.

## Completion evidence

- Platform and environment matrix.
- Current Apple HIG pages reviewed with dates.
- Complete-flow and accessibility manual review results.
- Optional HIG Doctor versioned output and configuration.
- Finding disposition, false-positive and false-negative review, exceptions, and retest evidence.
- Final device or simulator inspection tied to the released build.

## Sources

- Apple, [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines). Reviewed August 13, 2026.
- Apple, [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility). Reviewed August 13, 2026.
- Apple, [Layout](https://developer.apple.com/design/human-interface-guidelines/layout). Reviewed August 13, 2026.
- Raintree Technology, [HIG Doctor](https://github.com/raintree-technology/hig-doctor), used as versioned audit tooling and MIT-licensed structure rather than canonical Apple guidance. Reviewed August 13, 2026.
