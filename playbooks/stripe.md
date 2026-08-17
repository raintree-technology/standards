---
id: PLAYBOOK-STRIPE
title: Stripe integration review and release
description: Provider-specific procedure for Stripe payments, Billing, Connect, Tax, credentials, webhooks, reconciliation, and launch evidence.
type: playbook
status: draft
governance_status: draft
release_target: post-v1
owners: [payments, finance, engineering, security, privacy, operations]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [stripe-integration, payments, billing, marketplace, tax]
tags: [playbook, stripe, payments, billing, connect, tax]
depends_on: [INTEGRATIONS-VENDOR, API-CONTRACTS, FND-TRUST, FND-CHANGE, OPERATIONS-RELIABILITY, PRIVACY-DATA, SECURITY-APPLICATION, SECURITY-SECRETS, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:28:10Z" }
sources:
  - id: stripe-integration-options
    resource: https://docs.stripe.com/payments/payment-methods/integration-options
    title: Stripe integration options
    author: organization:stripe
  - id: stripe-keys
    resource: https://docs.stripe.com/keys-best-practices
    title: Stripe secret API key management
    author: organization:stripe
  - id: stripe-idempotency
    resource: https://docs.stripe.com/api/idempotent_requests
    title: Stripe idempotent requests
    author: organization:stripe
  - id: stripe-webhooks
    resource: https://docs.stripe.com/webhooks
    title: Stripe webhooks
    author: organization:stripe
  - id: stripe-connect
    resource: https://docs.stripe.com/connect/design-an-integration
    title: Design a Stripe Connect integration
    author: organization:stripe
  - id: stripe-billing
    resource: https://docs.stripe.com/billing/subscriptions/design-an-integration
    title: Design a Stripe Billing integration
    author: organization:stripe
  - id: stripe-tax
    resource: https://docs.stripe.com/tax/set-up
    title: Set up Stripe Tax
    author: organization:stripe
  - id: stripe-go-live
    resource: https://docs.stripe.com/get-started/checklist/go-live
    title: Stripe go-live checklist
    author: organization:stripe
---

# Stripe integration review and release

Use this playbook for any Stripe integration. It adds provider procedures to `INTEGRATIONS-VENDOR`; it does not decide merchant-of-record, tax, legal, or financial responsibility for the organization.

## Agent review route

Load `stripe:stripe-best-practices` for the core API, `stripe:connect-recommend` for connected accounts or platform money movement, and `stripe:upgrade-stripe` for API or SDK changes. Load `vercel:payments` only when the Vercel Marketplace or deployment path is also in scope. Record installed package versions and read the reference matching each enabled product. Revalidate API versions, supported surfaces, capability paths, tax behavior, and deprecated APIs against current Stripe documentation before making a claim or change.

The dedicated Stripe route wins when a Vercel payments example differs from current Stripe guidance. In particular, do not copy a pinned API version or explicit payment-method list from a cross-provider sample without checking the current Stripe API version and dynamic payment-method guidance. Record the conflict and the official Stripe source used to resolve it under `INTEGRATIONS-VENDOR-008`.

Load `integrations/stripe/manifest.yaml`, classify every in-scope surface through `sources.yaml`, select the exact capabilities, execute the matching workflows, and run every applicable evaluation. An unclassified Stripe surface is a stop condition or recorded library gap.

## Procedure

1. **Fix the business and account boundary.** Record account, mode, products, currencies, countries, payment methods, customer relationship, merchant of record, fees, losses, disputes, refunds, payouts, tax responsibility, owners, and support path.
2. **Select the current supported route.** Prefer the current higher-level Stripe surface that fits the flow. Record why a lower-level or legacy route is necessary. Keep sandbox and live objects, keys, prices, products, endpoints, and connected accounts separate.
3. **Constrain authority.** Use one restricted key per service and purpose where supported, add stable-egress restrictions when operationally safe, keep secrets server-side, and exercise rotation and revocation. Review Dashboard roles, strong authentication, and automated offboarding.
4. **Protect every mutation.** Attach a business-operation idempotency key to retryable creates and updates. Persist request, provider request ID, object ID, attempt, result, and reconciliation state. Never infer failure from a timeout.
5. **Process asynchronous truth.** Verify webhook signatures over the raw body, persist before acknowledging, deduplicate, handle reordering, and reconcile from Stripe objects and events. Do not rely on a browser redirect or synchronous response as final payment state.
6. **Validate product-specific obligations.** For Connect, record responsibility dimensions and verify current account capabilities before charges or transfers. For Billing, exercise renewal, retry, dunning, proration, cancellation, and portal behavior. For Tax, confirm active registrations and qualified tax-code decisions before relying on automatic collection.
7. **Exercise money movement.** Test success, authentication, decline, duplicate submission, timeout, refund, partial refund, dispute, reversal, failed payout, negative balance, delayed event, and reconciliation in sandbox. Verify live configuration without an unapproved live financial effect.
8. **Launch and monitor.** Complete the current go-live route, bind evidence to the released artifact and live account configuration, monitor failures and reconciliation gaps without logging sensitive data, and exercise key compromise, provider outage, and exit.

## Stop conditions

- Merchant-of-record, fee, loss, dispute, refund, payout, or tax responsibility is undecided.
- A live secret key is exposed to a client, shared across environments, or broader than the service needs.
- Webhook authenticity, duplicate handling, or reconciliation has not been exercised.
- A connected account lacks the current required capability state.
- Automatic tax is expected to collect in a jurisdiction without confirmed active registration and a qualified tax decision.

## Completion evidence

- Stripe account and product inventory, responsibility decision, current skill/version or gap, and dated official-source review.
- Restricted-key and environment matrix, rotation exercise, webhook registration, signature negatives, idempotency and concurrency results.
- Product-specific sandbox scenarios and ledger-to-Stripe reconciliation.
- Live configuration inspection, released artifact identity, monitoring, incident, recovery, and exit evidence.
- Passing Stripe integration bundle validation and no unresolved evaluation fixture.

## Sources

- Stripe, [Integration options](https://docs.stripe.com/payments/payment-methods/integration-options). Reviewed August 17, 2026.
- Stripe, [Secret API key management](https://docs.stripe.com/keys-best-practices). Reviewed August 17, 2026.
- Stripe, [Idempotent requests](https://docs.stripe.com/api/idempotent_requests). Reviewed August 17, 2026.
- Stripe, [Webhooks](https://docs.stripe.com/webhooks). Reviewed August 17, 2026.
- Stripe, [Design a Connect integration](https://docs.stripe.com/connect/design-an-integration). Reviewed August 17, 2026.
- Stripe, [Design a Billing integration](https://docs.stripe.com/billing/subscriptions/design-an-integration). Reviewed August 17, 2026.
- Stripe, [Set up Stripe Tax](https://docs.stripe.com/tax/set-up). Reviewed August 17, 2026.
- Stripe, [Go-live checklist](https://docs.stripe.com/get-started/checklist/go-live). Reviewed August 17, 2026.
