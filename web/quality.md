---
id: WEB-QUALITY
title: Public web quality
type: standard
status: active
owners: [web, design, security]
last_reviewed: 2026-08-10
review_by: 2026-11-10
applies_to: [public-web-page, web-application]
tags: [web, accessibility, performance, resilience, security, privacy]
depends_on: [FND-CHANGE, FND-TRUST, SEO-FOUNDATIONS]
---

# Public web quality

A good web experience is understandable, operable, fast enough, secure, privacy-conscious, resilient, and discoverable. Visual correctness alone is not completion.

## Document foundations

### WEB-QUALITY-001 — Ship valid document identity

**Level:** required  
**Applies when:** Serving an HTML document.

Use the standards-mode doctype, valid document language, UTF-8 declaration, responsive viewport without disabling zoom, one descriptive title, and one main landmark.

### WEB-QUALITY-002 — Use semantic elements before recreating behavior

**Level:** required  
**Applies when:** Implementing controls, navigation, headings, forms, dialogs, disclosure, or page structure.

Use the native element whose semantics and behavior match the interaction. Add ARIA only to fill a real semantic gap; do not use ARIA to disguise an incorrect element.

## Accessibility

### WEB-QUALITY-003 — Support keyboard and visible focus

**Level:** required  
**Applies when:** A page contains interactive behavior.

Every interaction must be reachable and operable with a keyboard in a logical order, with visible focus that is not obscured or trapped.

### WEB-QUALITY-004 — Provide names, labels, alternatives, and errors

**Level:** required  
**Applies when:** Presenting controls, forms, images, status changes, or validation.

Expose programmatic names and labels, purposeful text alternatives, and errors connected to the affected control. Color, placeholder text, position, or icon shape alone must not carry essential meaning.

### WEB-QUALITY-005 — Test accessibility behavior, not only markup

**Level:** required  
**Applies when:** Shipping or materially changing an interactive flow.

Test keyboard operation, focus movement, zoom/reflow, meaningful screen-reader announcements, reduced motion, contrast, and automated checks appropriate to the change.

## Performance and resilience

### WEB-QUALITY-006 — Set a performance budget around user outcomes

**Level:** required  
**Applies when:** Shipping a public experience or materially increasing its resource cost.

Define budgets for loading, responsiveness, visual stability, transferred resources, and third-party impact using representative devices and networks. Validate both laboratory behavior and available field data.

### WEB-QUALITY-007 — Preserve a useful baseline under partial failure

**Level:** recommended  
**Applies when:** JavaScript, an API, a third party, a font, or nonessential media can fail independently.

Keep primary content and essential actions understandable where practical. Provide explicit loading, empty, offline, timeout, and error states rather than indefinite or blank UI.

### WEB-QUALITY-008 — Prevent avoidable layout instability

**Level:** required  
**Applies when:** Loading images, embeds, ads, fonts, or asynchronous content.

Reserve space or use stable dimensions, and do not insert unexpected content ahead of the user's current position.

## Security and privacy

### WEB-QUALITY-009 — Minimize and constrain third-party code

**Level:** required  
**Applies when:** Loading analytics, ads, widgets, tag managers, embeds, or remote scripts.

Document purpose, owner, data access, consent behavior, performance cost, and removal path. Apply browser security controls and the least capability practical.

### WEB-QUALITY-010 — Do not place secrets in public clients

**Level:** prohibited  
**Applies when:** Building browser-delivered code or configuration.

Never rely on source obfuscation, environment naming, or an unlinked URL to protect a secret. Anything delivered to a browser must be treated as public.

### WEB-QUALITY-011 — Make collection and consent behavior truthful

**Level:** required  
**Applies when:** Storing or transmitting identifiers, behavioral data, or user-provided information.

Ensure actual network and storage behavior matches the disclosed purpose and consent state. Reject mechanisms that collect first and merely hide the interface until consent.

## Internationalization and agent readiness

### WEB-QUALITY-012 — Keep translatable UI out of structural code

**Level:** required  
**Applies when:** A product supports or plans to support multiple locales.

Use locale-aware formatting and externalized messages. Do not build sentences by concatenating translated fragments or assume text length, name shape, address shape, or reading direction.

### WEB-QUALITY-013 — Expose stable meaning to machines

**Level:** recommended  
**Applies when:** Content is public or intended for agents, search engines, feeds, or integrations.

Use descriptive titles, semantic headings, stable URLs, meaningful link text, structured metadata where truthful, accessible names, and server-visible primary content.

## Release evidence

Record representative browser/device coverage, accessibility checks, performance results, security/privacy review of third parties, broken-link and status-code checks, and any known exceptions.

