---
id: PLAYBOOK-GA4
title: Google Analytics 4 implementation
description: Versioned procedure for implementing and validating GA4 events, ecommerce, consent, identity, attribution, retention, and export behavior.
type: playbook
status: draft
governance_status: draft
owners: [analytics, privacy, engineering, marketing]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [analytics-implementation, ga4]
tags: [playbook, google, ga4, analytics]
depends_on: [ANALYTICS-MEASUREMENT, PRIVACY-DATA, FND-EVIDENCE]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: ga4-events
    resource: https://developers.google.com/analytics/devguides/collection/ga4/events
    title: Set up events
    author: organization:google
  - id: ga4-validation
    resource: https://developers.google.com/analytics/devguides/collection/protocol/ga4/validating-events
    title: Validate events
    author: organization:google
  - id: ga4-ecommerce
    resource: https://developers.google.com/analytics/devguides/collection/ga4/ecommerce
    title: Measure ecommerce
    author: organization:google
  - id: ga4-consent
    resource: https://support.google.com/analytics/answer/12335634
    title: Consent signal
    author: organization:google
  - id: ga4-attribution
    resource: https://support.google.com/analytics/answer/14547371
    title: Attribution
    author: organization:google
---

# Google Analytics 4 implementation

Use this playbook when GA4 is an implementation target for `ANALYTICS-MEASUREMENT`. GA4's reports, attribution, identity, and modeled results are vendor outputs and must not silently redefine the organization's metric contract or causal claims.

## Preconditions

- Approve the measurement decision, event contract, data classification, authority, consent behavior, retention, recipients, regions, and deletion requirements.
- Record organization, account, property, data-stream, tag or SDK, consent implementation, export, and environment identifiers without committing credentials.
- Establish development and production separation and owners for analytics, privacy, implementation, and downstream use.

## Procedure

1. **Map the contract to GA4.** Prefer current recommended events and prescribed parameters when their meaning matches. Document any custom event or parameter and prevent reserved-name or meaning conflicts.
2. **Minimize collection.** Disable unneeded automatic or enhanced measurement, advertising, user-provided data, signals, and integrations. Prohibit secrets and unnecessary personal or high-cardinality values.
3. **Implement consent and identity.** Define behavior before choice, after grant, after denial, after withdrawal, across regions, and across devices. Document user identifiers, session behavior, stitching, modeled data, and deletion limits.
4. **Implement ecommerce atomically.** Define item, currency, value, transaction, promotion, purchase, cancellation, and refund semantics. Prevent duplicate purchase events and reconcile revenue with the authoritative commerce system.
5. **Validate syntax before production.** Use supported debug and validation tools, noting that a validation endpoint may not validate every credential or business-semantic error.
6. **Validate the complete path.** Trigger known actions and inspect browser or app emission, consent state, collection endpoint, DebugView or realtime visibility, processing, reports, export, transformations, and downstream dashboards.
7. **Test negative and repeat cases.** Cover refusal, withdrawal, offline or blocked collection, duplicate actions, retries, refunds, cross-domain behavior, session boundaries, clock and currency variation, and deleted users.
8. **Document reporting limits.** Record processing lag, thresholds, sampling where applicable, modeled results, attribution settings, lookback, identity, time zone, currency, and discrepancies with product or financial systems.
9. **Control changes.** Version event meaning, GA4 configuration, audiences, key events, links, imports, custom definitions, retention, and exports; review access and downstream recipients.
10. **Close with reconciliation.** Compare known test activity and production aggregates with authoritative product and financial evidence; record residual mismatch and ownership.

## Failure handling

- If events are syntactically accepted but semantically wrong, stop affected decision use, version the correction, assess historical repair, and notify consumers.
- If consent or deletion behavior fails, stop the affected collection or sharing path and activate privacy incident handling.
- If vendor reports cannot be reconciled, narrow the claim; do not rewrite the product metric to match the vendor total.

## Completion evidence

- Approved event and metric contracts mapped to GA4 names and parameters.
- Data, consent, identity, retention, access, recipient, and deletion review.
- Debug, validation, negative-case, full-path, and reconciliation output.
- Ecommerce duplicate and refund evidence when applicable.
- Configuration and export inventory with versions and owners.
- Reporting limitations, discrepancies, and next review date.

## Sources

- Google, [Set up events](https://developers.google.com/analytics/devguides/collection/ga4/events). Reviewed August 13, 2026.
- Google, [Validate events](https://developers.google.com/analytics/devguides/collection/protocol/ga4/validating-events). Reviewed August 13, 2026.
- Google, [Measure ecommerce](https://developers.google.com/analytics/devguides/collection/ga4/ecommerce). Reviewed August 13, 2026.
- Google, [Consent signal](https://support.google.com/analytics/answer/12335634). Reviewed August 13, 2026.
- Google, [Attribution](https://support.google.com/analytics/answer/14547371). Reviewed August 13, 2026.
