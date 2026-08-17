---
id: PLAYBOOK-PLAID
title: Plaid integration review and release
description: Provider-specific procedure for Plaid Link, Items, financial data, consent, webhooks, update mode, deletion, and production launch.
type: playbook
status: draft
governance_status: draft
release_target: post-v1
owners: [financial-data, product, engineering, security, privacy, operations]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [plaid-integration, financial-data, account-linking, identity-verification]
tags: [playbook, plaid, financial-data, link, webhooks]
depends_on: [INTEGRATIONS-VENDOR, API-CONTRACTS, FND-TRUST, FND-CHANGE, OPERATIONS-RELIABILITY, PRIVACY-DATA, SECURITY-APPLICATION, SECURITY-SECRETS, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:28:10Z" }
sources:
  - id: plaid-launch
    resource: https://plaid.com/docs/launch-checklist/
    title: Plaid launch checklist
    author: organization:plaid
  - id: plaid-webhooks
    resource: https://plaid.com/docs/api/webhooks/
    title: Plaid webhooks
    author: organization:plaid
  - id: plaid-webhook-verification
    resource: https://plaid.com/docs/api/webhooks/webhook-verification/
    title: Plaid webhook verification
    author: organization:plaid
  - id: plaid-link
    resource: https://plaid.com/docs/link/
    title: Plaid Link
    author: organization:plaid
  - id: plaid-items
    resource: https://plaid.com/docs/link/troubleshooting/
    title: Plaid Link troubleshooting and Item recovery
    author: organization:plaid
  - id: plaid-security
    resource: https://plaid.com/docs/account/security/
    title: Plaid security practices
    author: organization:plaid
---

# Plaid integration review and release

Use this playbook for Plaid Link and every enabled Plaid product. Financial-data purpose, user authority, retention, sharing, and consequential decisions remain governed by privacy, legal, security, and product owners.

## Agent review route

No Plaid-specific skill is installed in the current agent skill set. Record `not available` and use the current Plaid Launch Center, product guides, API reference, webhook guidance, security documentation, and changelog. Adding a future skill requires source and behavior review before it becomes a mapped review aid.

Load `integrations/plaid/manifest.yaml`, classify every in-scope surface through `sources.yaml`, select the exact capabilities, execute the matching workflows, and run every applicable evaluation. An unclassified Plaid surface is a stop condition or recorded library gap.

## Procedure

1. **Define the authorized purpose.** Record people, countries, products, data fields, frequency, retention, recipients, decisions, consent or other authority, deletion, and support path. Request only the products and data needed for that purpose.
2. **Separate environments and identities.** Keep Sandbox, Development, and Production clients, secrets, templates, webhooks, Items, and access tokens separate. Keep access tokens server-side and out of logs, analytics, URLs, and client storage.
3. **Implement Link and Item lifecycle.** Bind Link tokens to the intended user and purpose. Handle success, exit, OAuth return, institution failure, invalid credentials, update mode, disconnected Items, changed accounts, revoked permissions, and user offboarding.
4. **Process and verify webhooks.** Verify the Plaid signature with a maintained JWT/JWK library and current key, enforce algorithm and key constraints, persist before acknowledging, and handle duplicates and out-of-order events. Recover missed events by querying the authoritative product endpoint.
5. **Keep data current.** Implement the product-specific cursor or pagination contract and restart behavior. For cursor feeds, commit page changes and the resulting cursor together, continue until the provider reports no more pages, and restart the documented mutation path without exposing a partial projection. Treat the webhook as a wake-up signal rather than the only record of change. Treat absence, stale data, `no_data`, and provider errors according to documented semantics rather than as a negative result.
6. **Exercise product flows.** Use Sandbox fixtures and webhook triggers for every enabled product, normal state, error, revocation, update, delayed completion, duplicate, reordering, pagination mutation, and recovery path.
7. **Complete production review.** Finish the current Launch Center requirements, organization and application profile, applicable security and regional review, production templates and callbacks, support access, observability, deletion, and incident response.

## Stop conditions

- The purpose, product scope, user authority, recipient, retention, or deletion path is undecided.
- Production access tokens or client secrets can reach a browser, mobile bundle, logs, analytics, or support artifact.
- The system cannot recover from missed, duplicate, or out-of-order webhooks.
- Revocation, update mode, Item deletion, or user offboarding is absent.
- A product-specific production or regional approval is incomplete.

## Completion evidence

- Purpose and data map, user authority, product inventory, official-source review, and recorded skill gap.
- Environment and secret boundary, Link and Item state-machine evidence, webhook signature negatives, duplicate and ordering results.
- Product-specific Sandbox fixtures, pagination or cursor recovery, revocation, update, deletion, and reconciliation.
- Production launch evidence, released artifact, monitoring, incident, recovery, and exit records.
- Passing Plaid integration bundle validation and no unresolved evaluation fixture.

## Sources

- Plaid, [Launch checklist](https://plaid.com/docs/launch-checklist/). Reviewed August 17, 2026.
- Plaid, [Webhooks](https://plaid.com/docs/api/webhooks/). Reviewed August 17, 2026.
- Plaid, [Webhook verification](https://plaid.com/docs/api/webhooks/webhook-verification/). Reviewed August 17, 2026.
- Plaid, [Link](https://plaid.com/docs/link/). Reviewed August 17, 2026.
- Plaid, [Link troubleshooting and Item recovery](https://plaid.com/docs/link/troubleshooting/). Reviewed August 17, 2026.
- Plaid, [Security practices](https://plaid.com/docs/account/security/). Reviewed August 17, 2026.
