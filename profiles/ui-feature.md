---
id: PROFILE-UI-FEATURE
title: User interface feature profile
description: Routes interface work to interaction, accessibility, content, trust, product, and verification requirements.
type: profile
status: draft
governance_status: draft
owners: [design, product, engineering, accessibility, content]
last_reviewed: 2026-08-17
review_by: 2027-02-17
stale_after: 2027-02-17
applies_to: [user-interface, product-feature]
tags: [profile, ui, design, accessibility]
depends_on: [DESIGN-INTERACTION, FND-ACCESSIBILITY, CONTENT-INTERFACE, PRODUCT-DELIVERY, FND-TRUST, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T08:30:41Z" }
---

# User interface feature profile

Use for new or materially changed user flows, screens, controls, forms, navigation, system states, and responsive behavior on any platform.

## Required standards

The front-matter `depends_on` list is the authoritative machine-readable route. This section explains why each dependency applies and must match that list.

- `DESIGN-INTERACTION` — complete flows, navigation, controls, forms, adaptation, and recovery
- `FND-ACCESSIBILITY` — equivalent perception and operation across supported needs
- `CONTENT-INTERFACE` — labels, guidance, states, confirmations, and localization
- `PRODUCT-DELIVERY` — evidenced problem, outcome, requirements, launch, and review
- `FND-TRUST` — informed choice and protection against manipulation
- `AGENT-VERIFICATION` — final rendered inspection and handoff

## Conditional standards

- JavaScript or TypeScript implementation → `ENGINEERING-JS-QUALITY`
- Client logs, errors, or operational events sent off the device → `OPERATIONS-LOGGING`
- Public or browser-delivered page → `PROFILE-PUBLIC-WEB-PAGE`
- Apple platform → `PROFILE-APPLE-INTERFACE`
- Personal-data processing → `PRIVACY-DATA`
- Authentication, authorization, upload, untrusted input, or administrative action → `SECURITY-APPLICATION`
- Analytics, experimentation, or personalization → `ANALYTICS-MEASUREMENT` and, when compared, `PROFILE-GROWTH-EXPERIMENT`
- User-facing failure → `CONTENT-ERRORS`
- Model-generated or agentic behavior → `PROFILE-AGENTIC-SYSTEM`
- Contract assent, privacy or cookie choice, recurring enrollment or cancellation, age assurance, policy enforcement, or another legal-document interaction → `PROFILE-LEGAL-DOCUMENT`

## Completion evidence

- `PRODUCT-DELIVERY-001` through `PRODUCT-DELIVERY-003` — The problem, outcome, non-goals, and complete behavior states are explicit.
- `DESIGN-INTERACTION-001` through `DESIGN-INTERACTION-007` — Representative flows cover navigation, controls, forms, adaptation, latency, mistakes, and recovery.
- `FND-ACCESSIBILITY-001` through `FND-ACCESSIBILITY-007` — The declared accessibility target is tested manually and with supported tools and assistive technology.
- `CONTENT-INTERFACE-001` through `CONTENT-INTERFACE-008` — Rendered interface content matches behavior, consequence, accessibility, and locale conditions.
- `PRODUCT-DELIVERY-006` and `AGENT-VERIFICATION-002` — Readiness and final-artifact inspection cover every active profile and material state.
- `PRODUCT-DELIVERY-008` — The outcome review and temporary-work closure have an owner and review point.
- When client logs leave the device, `OPERATIONS-LOGGING-013` — Shipped behavior minimizes data before logging, treats client claims as untrusted, bounds submission, and verifies device, network, and retained destinations.
