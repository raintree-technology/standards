---
id: API-CONTRACTS
title: API contracts
description: Requirements for compatible, bounded, observable, and recoverable service interfaces.
type: standard
status: draft
governance_status: draft
owners: [engineering, platform, security]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [api-change, service-change]
tags: [api, contracts, compatibility]
depends_on: [FND-EVIDENCE, FND-CHANGE, SECURITY-APPLICATION]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: rfc-9110
    resource: https://www.rfc-editor.org/rfc/rfc9110.html
    title: HTTP Semantics
    author: organization:ietf
  - id: rfc-9457
    resource: https://www.rfc-editor.org/rfc/rfc9457.html
    title: Problem Details for HTTP APIs
    author: organization:ietf
  - id: rfc-6585
    resource: https://www.rfc-editor.org/rfc/rfc6585.html
    title: Additional HTTP Status Codes
    author: organization:ietf
  - id: openapi-31
    resource: https://spec.openapis.org/oas/v3.1.1.html
    title: OpenAPI Specification 3.1.1
    author: organization:openapi-initiative
---

# API contracts

APIs must preserve defined meaning across clients, versions, retries, failures, and changing load. This standard applies to HTTP and comparable service contracts; protocol-specific behavior must be verified against its authoritative specification.

## Rules

### API-CONTRACTS-001 — Define the contract before implementation

**Level:** required
**Applies when:** Adding or materially changing a service interface.

Specify operations, authentication, authorization, inputs, outputs, errors, side effects, limits, compatibility, and lifecycle in a reviewable contract before release.

**Why:** An implicit contract drifts across clients and makes failure and migration behavior unpredictable.

**Verify:**

- Compare implementation and representative traffic with the versioned contract.
- Confirm every exposed field and operation has ownership and intended semantics.

**Exceptions:** An internal experiment may use a provisional contract when access is bounded and no compatibility promise is made.

### API-CONTRACTS-002 — Use truthful protocol semantics

**Level:** required
**Applies when:** A protocol defines methods, status, headers, or media types.

Return protocol signals that match the actual outcome, including success, validation failure, missing access, absence, conflict, throttling, and temporary unavailability.

**Why:** Clients, intermediaries, monitoring, and operators make decisions from protocol semantics.

**Verify:**

- Exercise success and each material failure class and inspect the complete response.
- Confirm caches, retries, and monitoring interpret the result as intended.

**Exceptions:** Legacy behavior requires a versioned compatibility plan and an expiration owner.

### API-CONTRACTS-003 — Make errors stable and actionable

**Level:** required
**Applies when:** A request can fail in a way callers need to handle.

Return a stable machine-readable error identifier, safe human detail, affected field or operation where appropriate, trace reference, and retry or remediation guidance without exposing secrets.

**Why:** Parsing prose or guessing from one status code creates fragile callers and unsafe diagnostics.

**Verify:**

- Validate error responses against the published schema.
- Confirm sensitive inputs, internal stack details, credentials, and tenant data are absent.

**Exceptions:** Security-sensitive failures may intentionally collapse distinctions when the generic response is documented and observable internally.

### API-CONTRACTS-004 — Bound collections and work

**Level:** required
**Applies when:** A response or operation can grow with stored data, fan-out, or caller input.

Set enforceable limits on request size, response size, page size, processing time, concurrency, and fan-out. Use stable continuation semantics for changing collections.

**Why:** Unbounded work causes resource exhaustion, latency spikes, duplicate processing, and incomplete traversal.

**Verify:**

- Exercise maximum, over-limit, empty, changing, and final-page cases.
- Confirm continuation does not silently omit or duplicate records under the documented consistency model.

**Exceptions:** Offline bulk interfaces may use larger bounds with separate authorization, quotas, interruption, and recovery controls.

### API-CONTRACTS-005 — Define retry and idempotency behavior

**Level:** required
**Applies when:** Requests can be retried after timeout, disconnection, or partial failure.

Declare which operations are safe to retry and protect non-idempotent effects with a bounded idempotency, deduplication, or reconciliation mechanism.

**Why:** Callers cannot distinguish a lost response from a failed effect and may repeat durable actions.

**Verify:**

- Repeat requests before, during, and after interruption using the same and different request keys.
- Confirm the final state and returned result match the published retry contract.

**Exceptions:** A non-repeatable operation must require explicit caller acknowledgment and provide a status or reconciliation path.

### API-CONTRACTS-006 — Evolve contracts compatibly

**Level:** required
**Applies when:** Existing callers may use the interface during or after a change.

Classify compatibility, preserve old and new callers through the migration window, publish deprecation and removal dates, and measure remaining use before removal.

**Why:** A syntactically small change can break stored clients, generated code, integrations, and delayed jobs.

**Verify:**

- Run contract and integration checks for supported client versions.
- Inspect production usage and owner approval before removing behavior.

**Exceptions:** An emergency security removal may shorten notice when the risk, affected callers, communication, and recovery path are recorded.

### API-CONTRACTS-007 — Make throttling fair and observable

**Level:** required
**Applies when:** Capacity, abuse, cost, or contractual limits require rate control.

Define the counted identity, window or algorithm, shared-resource boundary, response semantics, retry guidance, exemptions, and operator visibility. Do not let one tenant consume another tenant's protected allocation without an explicit policy.

**Why:** Ambiguous rate limits produce retry storms, unfairness, and unexplained customer failures.

**Verify:**

- Exercise sustained, burst, distributed, and boundary traffic for separate tenants and credentials.
- Confirm limit responses, retry metadata, metrics, and alerts agree.

**Exceptions:** None for externally enforced limits; undisclosed defensive limits may omit exact thresholds but must retain actionable responses and internal ownership.

### API-CONTRACTS-008 — Verify authorization at the resource boundary

**Level:** required
**Applies when:** An operation reads or changes protected resources.

Authorize the authenticated principal for the exact operation, tenant, object, fields, and current state on the trusted side of the interface.

**Why:** Endpoint-level authentication alone does not prevent cross-tenant or object-level access.

**Verify:**

- Exercise allowed and denied cases across tenants, roles, object identifiers, field selection, and state transitions.
- Confirm bulk, nested, export, and error paths enforce the same boundary.

**Exceptions:** Explicitly public resources require classification and tests for unintended fields or state changes.

## Guidance

Prefer additive changes and generated contract checks, but do not mistake schema compatibility for semantic compatibility. Record consistency, ordering, time, money, identifiers, nullability, and partial success explicitly when they affect callers.

## Examples

### Retried payment request

Non-compliant: A timed-out create request can charge again when the caller retries.

Compliant: The caller supplies an idempotency key scoped to the account and operation; repeated matching requests return the original result, conflicting reuse is rejected, and the caller can query final status.

## Sources

- Internet Engineering Task Force, [HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), RFC 9110. Reviewed August 13, 2026.
- Internet Engineering Task Force, [Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html), RFC 9457. Reviewed August 13, 2026.
- Internet Engineering Task Force, [Additional HTTP Status Codes](https://www.rfc-editor.org/rfc/rfc6585.html), RFC 6585. Reviewed August 13, 2026.
- OpenAPI Initiative, [OpenAPI Specification 3.1.1](https://spec.openapis.org/oas/v3.1.1.html). Reviewed August 13, 2026.
