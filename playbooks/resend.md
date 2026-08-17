---
id: PLAYBOOK-RESEND
title: Resend email integration review and release
description: Provider-specific procedure for Resend domains, credentials, templates, idempotency, webhooks, delivery outcomes, and suppression.
type: playbook
status: draft
governance_status: draft
release_target: post-v1
owners: [messaging, engineering, marketing, privacy, security, operations]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [resend-integration, transactional-email, marketing-email]
tags: [playbook, resend, email, deliverability, suppression]
depends_on: [INTEGRATIONS-VENDOR, API-CONTRACTS, CONTENT-INTERFACE, FND-TRUST, OPERATIONS-RELIABILITY, PRIVACY-DATA, SECURITY-APPLICATION, SECURITY-SECRETS, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:28:10Z" }
sources:
  - id: resend-domains
    resource: https://resend.com/docs/dashboard/domains/introduction
    title: Resend domain management
    author: organization:resend
  - id: resend-idempotency
    resource: https://resend.com/docs/dashboard/emails/idempotency-keys
    title: Resend idempotency keys
    author: organization:resend
  - id: resend-webhooks
    resource: https://resend.com/docs/webhooks/introduction
    title: Resend webhooks
    author: organization:resend
  - id: resend-verify-webhooks
    resource: https://resend.com/docs/webhooks/verify-webhooks-requests
    title: Verify Resend webhooks
    author: organization:resend
  - id: react-email
    resource: https://react.email/docs/introduction
    title: React Email documentation
    author: organization:resend
---

# Resend email integration review and release

Use this playbook for transactional and marketing mail sent through Resend. Marketing authority, unsubscribe duties, and jurisdiction rules remain additive.

## Agent review route

Load `vercel:email` when available and record its installed package version. Treat its SDK versions and examples as volatile; verify current Resend and React Email documentation before implementation or audit.

Load `integrations/resend/manifest.yaml`, classify every in-scope surface through `sources.yaml`, select the exact capabilities, execute the matching workflows, and run every applicable evaluation. An unclassified Resend surface is a stop condition or recorded library gap.

## Procedure

1. **Classify every message.** Record purpose, trigger, recipient authority, sender identity, reply path, urgency, retention, suppression behavior, and owner. Separate transactional and marketing messages and activate marketing rules when applicable.
2. **Authenticate sending.** Use an organization-controlled domain or subdomain, verify current SPF and DKIM requirements, record the DMARC decision, and separate reputations when purpose or risk differs.
3. **Protect credentials and inputs.** Keep API and webhook secrets server-side and environment-specific. Authorize the send operation; do not expose a general recipient, subject, or HTML relay to untrusted callers.
4. **Make sends repeat-safe.** Derive deterministic idempotency from the business message, persist attempt and provider ID, and reconcile ambiguous outcomes before retrying after the provider window.
5. **Process delivery events.** Verify webhook signatures over the raw body, persist and deduplicate by provider event identity, tolerate reordering, and handle delivered, delayed, bounced, complained, suppressed, and replayed outcomes.
6. **Inspect messages.** Render HTML and text forms with realistic data; test supported clients, narrow layouts, dark and high-contrast settings, blocked images, links, localization, accessible structure, and error fallback.
7. **Close the lifecycle.** Reconcile provider state, honor unsubscribe and suppression before future sends, monitor delivery and complaint signals without logging message bodies or unnecessary addresses, and exercise credential compromise and provider outage.

## Stop conditions

- Message purpose, recipient authority, sender, or suppression behavior is undefined.
- A production sender domain is unverified or credentials can reach client code.
- Retry can produce duplicate consequential messages.
- Webhook signatures, duplicate delivery, complaint, bounce, and suppression have not been exercised.

## Completion evidence

- Message inventory, authority, domain authentication, DMARC decision, skill/version or gap, and dated official-source review.
- Environment and authorization checks, deterministic idempotency, webhook signature negatives, deduplication, reordering, and reconciliation.
- Rendered HTML and text inspections plus delivery, bounce, complaint, unsubscribe, and suppression results.
- Released artifact, monitoring, incident, recovery, and exit evidence.
- Passing Resend integration bundle validation and no unresolved evaluation fixture.

## Sources

- Resend, [Domain management](https://resend.com/docs/dashboard/domains/introduction). Reviewed August 17, 2026.
- Resend, [Idempotency keys](https://resend.com/docs/dashboard/emails/idempotency-keys). Reviewed August 17, 2026.
- Resend, [Webhooks](https://resend.com/docs/webhooks/introduction). Reviewed August 17, 2026.
- Resend, [Verify webhook requests](https://resend.com/docs/webhooks/verify-webhooks-requests). Reviewed August 17, 2026.
- React Email, [Documentation](https://react.email/docs/introduction). Reviewed August 17, 2026.
