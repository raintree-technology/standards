---
id: PROFILE-APPLE-INTERFACE
title: Apple interface profile
description: Routes Apple-platform interfaces to universal quality requirements and a current Apple HIG audit.
type: profile
status: draft
governance_status: draft
owners: [apple-platforms, design, engineering, accessibility]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [apple-interface, ios, ipados, macos, watchos, tvos, visionos]
tags: [profile, apple, hig]
depends_on: [DESIGN-INTERACTION, FND-ACCESSIBILITY, CONTENT-INTERFACE, PLAYBOOK-APPLE-HIG, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
---

# Apple interface profile

Use for interfaces shipped on iOS, iPadOS, macOS, watchOS, tvOS, or visionOS.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `DESIGN-INTERACTION` — universal task, component, state, adaptation, and recovery behavior
- `FND-ACCESSIBILITY` — cross-platform accessibility target and evidence
- `CONTENT-INTERFACE` — clear and localizable interface language
- `PLAYBOOK-APPLE-HIG` — current Apple-platform guidance and audit procedure
- `AGENT-VERIFICATION` — final build inspection and reproducible handoff

## Conditional standards

- New product behavior → `PRODUCT-DELIVERY`
- Personal or protected Apple-framework data → `PRIVACY-DATA`
- Authentication, authorization, secrets, files, networking, or payments → `SECURITY-APPLICATION`
- Public web content inside or linked from the app → `PROFILE-PUBLIC-WEB-PAGE`
- Analytics or experimentation → `ANALYTICS-MEASUREMENT` or `PROFILE-GROWTH-EXPERIMENT`
- Model-generated or agentic behavior → `PROFILE-AGENTIC-SYSTEM`
- App Store metadata, submission, review, or discovery work → `DISCOVERY-APP-STORES` through `PROFILE-SPECIALIST-MARKETING`

## Completion evidence

- `FND-ACCESSIBILITY-001` — The platform, device, assistive-technology, input, locale, and conformance matrix is approved.
- `DESIGN-INTERACTION-001`, `DESIGN-INTERACTION-003`, and `DESIGN-INTERACTION-005` — Complete tasks, platform controls, and adaptive layouts are inspected on representative Apple environments.
- `PLAYBOOK-APPLE-HIG` — Current Apple HIG pages, optional tool versions, manual review, findings, suppressions, gaps, and final retest are recorded.
- `FND-ACCESSIBILITY-007` — Automated output is combined with manual and assistive-technology evidence.
- `AGENT-VERIFICATION-002` and `AGENT-VERIFICATION-005` — The final build and handoff identify exact environments, checks, limitations, and owners.
