---
id: WEB-QUALITY
title: Public web quality
description: Defines accessible, performant, resilient, secure, private, and discoverable public web experiences.
type: standard
status: stable
governance_status: active
owners: [web, design, security]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [public-web-page, web-application]
tags: [web, accessibility, performance, resilience, security, privacy]
depends_on: [FND-CHANGE, FND-TRUST, FND-ACCESSIBILITY, SEO-FOUNDATIONS]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: wcag-22
    resource: https://www.w3.org/TR/WCAG22/
    title: Web Content Accessibility Guidelines 2.2
    author: organization:w3c
  - id: html-standard
    resource: https://html.spec.whatwg.org/multipage/
    title: HTML Standard
    author: organization:whatwg
  - id: ietf-http-semantics
    resource: https://www.rfc-editor.org/rfc/rfc9110.html
    title: HTTP Semantics
    author: organization:ietf
  - id: w3c-ethical-web
    resource: https://www.w3.org/TR/ethical-web-principles/
    title: Ethical Web Principles
    author: organization:w3c
  - id: w3c-csp
    resource: https://www.w3.org/TR/CSP3/
    title: Content Security Policy Level 3
    author: organization:w3c
  - id: w3c-referrer-policy
    resource: https://www.w3.org/TR/referrer-policy/
    title: Referrer Policy
    author: organization:w3c
  - id: w3c-permissions-policy
    resource: https://www.w3.org/TR/permissions-policy/
    title: Permissions Policy
    author: organization:w3c
  - id: google-core-web-vitals
    resource: https://web.dev/articles/vitals
    title: Web Vitals
    author: organization:google
  - id: google-core-web-vitals-thresholds
    resource: https://web.dev/articles/defining-core-web-vitals-thresholds
    title: How the Core Web Vitals metrics thresholds were defined
    author: organization:google
---

# Public web quality

A public web experience must be understandable, operable, fast enough, resilient, secure, privacy-conscious, discoverable, and usable across its supported environments. Visual correctness alone is not completion.

This standard sets product-quality gates. Legal accessibility, privacy, security, and records requirements remain additive and require the applicable organizational policy and qualified owner.

## Document foundations

### WEB-QUALITY-001 — Ship correct document identity and structure

**Level:** required
**Applies when:** Serving an HTML document.

Use the standards-mode doctype, valid document language and direction, an early UTF-8 declaration, a responsive viewport that does not disable zoom, one descriptive document title, logical landmarks, and one primary main region.

**Why:** Browsers, assistive technology, translation tools, search systems, and sharing clients depend on document-level semantics before interpreting page content.

**Verify:**

- Inspect the delivered HTML and browser accessibility tree.
- Confirm title, language, direction, encoding, viewport, and landmarks match the rendered page.

**Exceptions:** Embedded fragments that are not complete documents inherit identity from their host and must not duplicate page-level structure.

### WEB-QUALITY-002 — Use native semantics before recreating behavior

**Level:** required
**Applies when:** Implementing controls, navigation, headings, forms, dialogs, disclosure, tables, or page structure.

Use the native element whose semantics and behavior match the interaction. Add ARIA only to fill a real semantic gap, and implement the complete expected keyboard and state behavior when a custom control is necessary.

**Why:** Native elements provide interoperable semantics and interaction behavior that partial custom implementations often omit.

**Verify:**

- Inspect role, name, state, value, and relationships in the accessibility tree.
- Operate custom controls with keyboard and assistive technology patterns appropriate to the control.

**Exceptions:** A custom element can replace a native control when the native element cannot express the required interaction and the custom behavior is fully verified.

## Accessibility

### WEB-QUALITY-003 — Support keyboard operation and visible focus

**Level:** required
**Applies when:** A page contains interactive behavior.

Make every interaction reachable and operable through a keyboard in a logical order. Keep focus visible, unobscured, and out of traps; restore or move focus intentionally after dialogs, navigation, removal, and other context changes.

**Why:** Keyboard access supports people who cannot or do not use a pointer and exposes interaction-order defects for every user.

**Verify:**

- Complete each material flow using only the keyboard.
- Check focus order, focus appearance, skip paths, dialog containment, escape behavior, and focus return.

**Exceptions:** Path-dependent input such as freehand drawing can require a pointer when an equivalent outcome is available by another method.

### WEB-QUALITY-004 — Provide names, labels, alternatives, and errors

**Level:** required
**Applies when:** Presenting controls, forms, images, media, status changes, or validation.

Expose programmatic names and labels, purposeful text alternatives, captions or transcripts where required, and errors connected to affected controls. Do not use color, placeholder text, position, sound, or icon shape as the only carrier of meaning.

**Why:** Visible context is not always available to assistive technology or users with different sensory access.

**Verify:**

- Inspect accessible names, descriptions, field relationships, image alternatives, and media alternatives.
- Trigger validation and status updates, then confirm the message is perceivable and connected to the relevant action or field.

**Exceptions:** Decorative content must be omitted from assistive output rather than given redundant descriptions.

### WEB-QUALITY-005 — Test accessibility behavior, not only markup

**Level:** required
**Applies when:** Shipping or materially changing an interactive flow.

Test keyboard operation, focus movement, zoom and reflow, text spacing, meaningful screen-reader announcements, reduced motion, contrast, target size, and automated rules appropriate to the change.

**Why:** Automated checks and valid markup do not reproduce every interaction, visual, or assistive-technology failure.

**Verify:**

- Record the flows, environments, tools, manual checks, and outcomes.
- Confirm automated findings were reviewed rather than accepted or dismissed without inspection.

**Exceptions:** When a required environment is unavailable, test the closest substitute and report the unverified behavior and risk.

### WEB-QUALITY-006 — Set and enforce a performance budget

**Level:** required
**Applies when:** Shipping a public experience or materially increasing its resource or execution cost.

Define budgets for loading, responsiveness, visual stability, transferred resources, server response, and third-party impact using representative devices, networks, locations, and user journeys. Validate laboratory behavior and available field data.

**Why:** Fast development hardware and warm local caches hide delays experienced on ordinary devices and networks.

**Verify:**

- Record the budget, test profile, page or flow, cold and warm behavior, and measured results.
- Attribute material regressions to specific resources, code, server work, or third parties.

**Exceptions:** A justified regression requires an approved budget change, documented user tradeoff, and follow-up owner; it is not a passing result.

## Performance and resilience

### WEB-QUALITY-007 — Preserve a useful baseline under partial failure

**Level:** recommended
**Applies when:** JavaScript, an API, storage, a third party, a font, or nonessential media can fail independently.

Keep primary content and essential actions understandable where practical. Provide explicit loading, empty, offline, timeout, stale, and error states rather than indefinite, blank, or misleading UI.

**Why:** Distributed dependencies fail separately, and an all-or-nothing page can turn a minor outage into complete loss of function.

**Verify:**

- Disable or delay each material dependency and inspect the resulting page and recovery path.
- Confirm users can distinguish empty data from failed loading and know whether their work was preserved.

**Exceptions:** A capability that cannot function safely without its dependency must fail closed with an actionable explanation.

### WEB-QUALITY-008 — Prevent avoidable layout instability

**Level:** required
**Applies when:** Loading images, embeds, ads, fonts, banners, personalization, or asynchronous content.

Reserve stable space, provide intrinsic dimensions or an aspect ratio, and avoid inserting unexpected content before the user's reading or interaction position. Keep placeholders representative of final layout.

**Why:** Unexpected movement causes misclicks, lost reading position, and visual disorientation.

**Verify:**

- Observe cold loading and delayed dependencies at representative viewport sizes.
- Measure layout movement and inspect the user-visible causes.

**Exceptions:** User-requested expansion can move surrounding content when the initiating control and result remain clear.

### WEB-QUALITY-009 — Minimize and constrain third-party code

**Level:** required
**Applies when:** Loading analytics, advertising, widgets, tag managers, embeds, fonts, or remote scripts.

Document purpose, owner, provider, data access, consent behavior, performance cost, security boundary, failure behavior, and removal path. Grant the least capability practical and isolate untrusted content where possible.

**Why:** Third-party code can execute with site privileges, collect data, block rendering, change independently, and fail outside the site's release process.

**Verify:**

- Inspect actual network, storage, script, frame, and permission behavior before and after consent.
- Disable the provider and confirm the page fails safely.
- Confirm unused integrations and permissions are removed.

**Exceptions:** A first-party hosted asset is still governed when another organization controls its contents or behavior.

## Security and privacy

### WEB-QUALITY-010 — Keep secrets and privileged decisions off public clients

**Level:** prohibited
**Applies when:** Building browser-delivered code or configuration.

Never place secrets, private keys, privileged credentials, or authorization decisions in a browser. Treat every delivered resource, source map, environment value, and network request as publicly observable.

**Why:** Obfuscation, environment naming, hidden routes, and client checks do not create a security boundary.

**Verify:**

- Inspect built assets, source maps, HTML, runtime configuration, browser storage, and network traffic for credentials and privileged data.
- Confirm the server independently enforces authorization for every protected action and object.

**Exceptions:** Public identifiers and publishable client keys are allowed only within their documented limited capability and server-enforced controls.

### WEB-QUALITY-011 — Make collection and consent behavior truthful

**Level:** required
**Applies when:** Storing or transmitting identifiers, behavioral data, device data, or user-provided information.

Make actual network and storage behavior match the disclosed purpose and consent state. Do not collect first and merely hide the interface until consent. Define retention, deletion, access, and provider behavior under the applicable privacy policy.

**Why:** Interface text cannot create consent when the underlying collection already occurred or exceeds the stated purpose.

**Verify:**

- Inspect cookies, local storage, requests, pixels, server events, and third-party behavior before acceptance, after acceptance, and after withdrawal.
- Confirm the privacy record names purpose, data, recipients, retention, and governing policy.

**Exceptions:** Strictly necessary storage or transmission can occur without optional consent only when the applicable policy authorizes it and the classification is documented.

### WEB-QUALITY-012 — Externalize and localize complete meaning

**Level:** required
**Applies when:** A product supports or plans to support multiple locales.

Use locale-aware formatting and externalized complete messages. Do not concatenate translated sentence fragments or assume text length, plural rules, name shape, address shape, time zone, number format, or reading direction.

**Why:** Language is structural; replacing English words alone does not preserve grammar, layout, or meaning in other locales.

**Verify:**

- Render representative long, short, plural, right-to-left, and non-Latin content.
- Check locale selection, fallback, document language and direction, formatting, truncation, and assistive output.

**Exceptions:** Internal prototypes can defer translation when externalization is preserved and the limitation is recorded.

## Internationalization and machine readiness

### WEB-QUALITY-013 — Expose stable, truthful meaning to machines

**Level:** recommended
**Applies when:** Content is public or intended for agents, search engines, feeds, sharing clients, or integrations.

Use descriptive titles, semantic headings, stable URLs, meaningful links, accessible names, truthful structured metadata, and server-visible primary content. Keep machine-readable representations consistent with what users receive.

**Why:** Machine consumers rely on document semantics and metadata rather than visual inference.

**Verify:**

- Compare rendered content, accessibility semantics, response metadata, sharing previews, and structured data.
- Confirm stable identifiers and links resolve without requiring hidden application state.

**Exceptions:** Private or personalized data must not be exposed to improve machine readability.

### WEB-QUALITY-014 — Protect transport and browser execution boundaries

**Level:** required
**Applies when:** Serving a production public web experience.

Use secure transport and engine-appropriate controls for content execution, framing, cross-origin access, referrer disclosure, and sensitive caching. Define these controls at the response or platform layer and review exceptions narrowly.

**Why:** Browser defaults cannot infer which origins, scripts, frames, or caches the application intends to trust.

**Verify:**

- Inspect production response headers and effective browser policy on representative documents and assets.
- Exercise allowed and blocked origin, framing, and content-loading cases.
- Confirm sensitive responses are not stored or shared beyond their intended boundary.

**Exceptions:** A required integration can receive the minimum scoped exception after security review and must have an owner and removal condition.

### WEB-QUALITY-015 — Verify supported environments and input modes

**Level:** required
**Applies when:** Releasing or materially changing a public page or flow.

Define supported browser, device, viewport, input, and assistive-technology coverage according to audience and risk. Inspect the material journey across representative environments, including touch and keyboard where applicable.

**Why:** A flow that works in one development browser can fail because of engine, viewport, input, storage, or network differences.

**Verify:**

- Record the support policy, selected coverage, and result for each material journey.
- Include at least one narrow viewport and each engine or platform that represents meaningful audience or contractual coverage.

**Exceptions:** Unsupported environments must receive an understandable fallback or support message when practical.

### WEB-QUALITY-016 — Respect motion, timing, and input alternatives

**Level:** required
**Applies when:** A page uses animation, auto-updating content, time limits, dragging, gestures, pointer paths, or motion triggered by interaction.

Honor reduced-motion preferences, provide a way to disable nonessential interaction-triggered motion, and avoid flashes that exceed the governing accessibility threshold. Let users pause or control moving and auto-updating content, extend adjustable time limits, and complete path- or gesture-based actions through a simpler input unless the path is essential.

**Why:** Motion, flashing, time pressure, and path-dependent input can cause physical symptoms or make a task impossible for users with vestibular, motor, cognitive, or vision disabilities.

**Verify:**

- Exercise the flow with reduced motion, keyboard, touch, pointer, zoom, and relevant assistive technology.
- Test pause, stop, hide, extension, timeout warning, dragging alternative, and single-pointer behavior where applicable.
- Inspect animation introduced by hover, focus, scrolling, loading, and state changes, not only decorative transitions.

**Exceptions:** Motion, timing, or path can remain essential when removing it would fundamentally change the information or activity; document the necessity and provide the closest accessible alternative.

### WEB-QUALITY-017 — Prevent high-impact input errors

**Level:** required
**Applies when:** A web flow creates a legal or financial commitment, changes or deletes user-controlled data, submits test responses, or publishes sensitive information.

Make the submission reversible, validate and allow correction, or provide a review and confirmation step that exposes the material values and consequences before final submission. Preserve entered data through correction where security permits.

**Why:** Users need a way to detect and correct consequential mistakes before an irreversible outcome.

**Verify:**

- Intentionally submit incorrect material values and confirm the safeguard works with keyboard and assistive technology.
- Check duplicate submission, back navigation, timeout, refresh, retry, and interrupted-network behavior.
- Confirm review and confirmation content meets `FND-TRUST-001` and error behavior meets `CONTENT-ERRORS`.

**Exceptions:** None where the governing accessibility requirement applies; otherwise document the approved alternate safeguard.

### WEB-QUALITY-018 — Request browser capabilities in context

**Level:** required
**Applies when:** Requesting location, camera, microphone, notifications, clipboard, fullscreen, sensors, storage, or another permission-controlled browser capability.

Request the minimum capability only after a user action that makes the purpose clear. Explain the effect before the browser prompt, handle denial and revocation without trapping the user, and restrict capabilities for embedded or third-party content through Permissions Policy and sandboxing where supported.

**Why:** Unexpected or overbroad prompts reduce meaningful consent and can grant embedded content capabilities unrelated to the user's task.

**Verify:**

- Exercise first request, grant, denial, dismissal, revocation, repeat visit, and unsupported-browser paths.
- Inspect effective permissions for top-level and embedded documents.
- Confirm the feature remains understandable and offers an alternate path when optional permission is denied.

**Exceptions:** A capability essential to the product can block that specific function after denial, but must explain the dependency and leave unrelated functions available.

## Guidance

Start with a correct document and native controls. Add client behavior in layers, preserve server and browser semantics, and design each remote dependency as a failure boundary.

Use WCAG 2.2 Level AA as the default technical accessibility target unless a stricter law, contract, or organizational policy applies. Conformance claims require the full scope and process defined by the governing accessibility policy; this standard does not create a legal conformance claim by itself.

Performance budgets should reflect the actual audience and task. Keep raw resource budgets alongside outcome metrics so teams can act before field performance degrades. Review third-party scripts as both performance and security dependencies.

For public pages without a stricter product budget, use the current Core Web Vitals “good” thresholds as a review baseline at the 75th percentile: LCP at or below 2.5 seconds, INP at or below 200 milliseconds, and CLS at or below 0.1. Revalidate the metric set and thresholds before relying on them because Google treats them as an evolving program. Segment field results by material device and experience rather than hiding a poor population in a sitewide average.

Treat Content Security Policy as defense in depth, not a substitute for output encoding and input handling. Introduce restrictive policies through reporting where needed, review violations, then enforce the smallest source and capability set the application needs. Set an intentional referrer policy for pages whose URLs or navigation context can reveal personal, sensitive, or capability-bearing information.

## Examples

### Custom control

Non-compliant: A styled `div` submits a form on mouse click and uses `role="button"` without keyboard behavior or focus styling.

Compliant: A native `button` submits the form. If a custom widget is truly required, its name, role, state, keyboard behavior, focus management, and disabled behavior match the expected pattern.

### Consent

Non-compliant: Analytics requests fire on initial page load while the banner waits for a choice.

Compliant: Nonessential requests and storage remain absent until consent. Withdrawal stops future collection and follows the documented deletion policy.

### Dependency failure

Non-compliant: A blocked chat widget prevents the entire support page from rendering.

Compliant: The page loads its primary support content and shows a direct fallback contact method when the widget fails.

## Release evidence

Record final rendered inspection, representative environment coverage, accessibility checks, performance results, dependency-failure behavior, third-party security and privacy review, status and link checks, localization coverage where applicable, and approved exceptions.

## Sources

- World Wide Web Consortium, [Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/), W3C Recommendation, October 5, 2023. Reviewed August 13, 2026.
- WHATWG, [HTML Standard](https://html.spec.whatwg.org/multipage/). Reviewed August 13, 2026.
- Internet Engineering Task Force, [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), June 2022. Reviewed August 13, 2026.
- World Wide Web Consortium, [Ethical Web Principles](https://www.w3.org/TR/ethical-web-principles/), December 12, 2024. Reviewed August 13, 2026.
- World Wide Web Consortium, [Content Security Policy Level 3](https://www.w3.org/TR/CSP3/). Reviewed August 13, 2026.
- World Wide Web Consortium, [Referrer Policy](https://www.w3.org/TR/referrer-policy/). Reviewed August 13, 2026.
- World Wide Web Consortium, [Permissions Policy](https://www.w3.org/TR/permissions-policy/). Reviewed August 13, 2026.
- Google, [Web Vitals](https://web.dev/articles/vitals). Reviewed August 13, 2026.
- Google, [How the Core Web Vitals metrics thresholds were defined](https://web.dev/articles/defining-core-web-vitals-thresholds), last updated May 7, 2025. Reviewed August 13, 2026.
