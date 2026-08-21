---
id: API-CONTRACTS
title: API design and contracts
description: Requirements for usable, compatible, bounded, observable, and recoverable programmatic interfaces.
type: standard
status: draft
governance_status: draft
owners: [engineering, platform, security]
last_reviewed: 2026-08-16
review_by: 2027-02-16
stale_after: 2027-02-16
applies_to: [api-change, service-change, library-api-change]
tags: [api, design, contracts, compatibility]
depends_on: [FND-EVIDENCE, FND-CHANGE, SECURITY-APPLICATION, CONTENT-ERRORS]
generated: { by: codex/gpt-5, at: "2026-08-16T23:36:18Z" }
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
  - id: rfc-9111
    resource: https://www.rfc-editor.org/rfc/rfc9111.html
    title: HTTP Caching
    author: organization:ietf
  - id: rfc-8594
    resource: https://www.rfc-editor.org/rfc/rfc8594.html
    title: The Sunset HTTP Header Field
    author: organization:ietf
  - id: rfc-9745
    resource: https://www.rfc-editor.org/rfc/rfc9745.html
    title: The Deprecation HTTP Response Header Field
    author: organization:ietf
  - id: openapi-32
    resource: https://spec.openapis.org/oas/v3.2.0.html
    title: OpenAPI Specification 3.2.0
    author: organization:openapi-initiative
  - id: google-aip-151
    resource: https://google.aip.dev/151
    title: Long-running operations
    author: organization:google
  - id: google-aip-154
    resource: https://google.aip.dev/154
    title: Resource freshness validation
    author: organization:google
  - id: google-aip-158
    resource: https://google.aip.dev/158
    title: Pagination
    author: organization:google
  - id: google-aip-180
    resource: https://google.aip.dev/180
    title: Backwards compatibility
    author: organization:google
  - id: google-aip-132
    resource: https://google.aip.dev/132
    title: Standard methods - List
    author: organization:google
  - id: google-aip-141
    resource: https://google.aip.dev/141
    title: Quantities
    author: organization:google
  - id: google-aip-142
    resource: https://google.aip.dev/142
    title: Time and duration
    author: organization:google
  - id: google-aip-149
    resource: https://google.aip.dev/149
    title: Unset field values
    author: organization:google
  - id: google-aip-155
    resource: https://google.aip.dev/155
    title: Request identification
    author: organization:google
  - id: google-aip-160
    resource: https://google.aip.dev/160
    title: Filtering
    author: organization:google
  - id: google-aip-161
    resource: https://google.aip.dev/161
    title: Field masks
    author: organization:google
  - id: google-aip-203
    resource: https://google.aip.dev/203
    title: Field behavior documentation
    author: organization:google
  - id: google-aip-216
    resource: https://google.aip.dev/216
    title: States
    author: organization:google
  - id: google-aip-231
    resource: https://google.aip.dev/231
    title: Batch methods - Get
    author: organization:google
  - id: microsoft-api-guidelines
    resource: https://github.com/microsoft/api-guidelines
    title: Microsoft REST API Guidelines
    author: organization:microsoft
  - id: json-schema-2020-12
    resource: https://json-schema.org/draft/2020-12
    title: JSON Schema Draft 2020-12
    author: organization:json-schema
  - id: protobuf-proto3
    resource: https://protobuf.dev/programming-guides/proto3/
    title: Protocol Buffers proto3 language guide
    author: organization:google
  - id: w3c-trace-context
    resource: https://www.w3.org/TR/trace-context/
    title: Trace Context
    author: organization:w3c
  - id: cloudevents-102
    resource: https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md
    title: CloudEvents Specification 1.0.2
    author: organization:cloud-native-computing-foundation
  - id: owasp-api-security-2023
    resource: https://owasp.org/API-Security/editions/2023/en/0x11-t10/
    title: OWASP Top 10 API Security Risks 2023
    author: organization:owasp
  - id: goedecke-api-design
    resource: https://www.seangoedecke.com/good-api-design/
    title: Everything I know about good API design
    author: person:sean-goedecke
  - id: bloch-api-design
    resource: https://research.google/pubs/how-to-design-a-good-api-and-why-it-matters/
    title: How to design a good API and why it matters
    author: person:joshua-bloch
---

# API design and contracts

APIs must preserve defined meaning across clients, versions, retries, failures, and changing load. This standard applies to HTTP, RPC, event, library, SDK, command, and comparable programmatic contracts. Use the map below for orientation. A rule's `Applies when` statement determines whether it governs a specific change, and protocol- or language-specific behavior must be verified against its authoritative specification.

## Applicability map

| Work | Start with |
|---|---|
| New or changed public interface | `API-CONTRACTS-001`, `API-CONTRACTS-009`, `API-CONTRACTS-017` through `API-CONTRACTS-023` |
| Protocol responses, errors, and caching | `API-CONTRACTS-002`, `API-CONTRACTS-003`, `API-CONTRACTS-013` |
| Collections, queries, expansions, or bulk work | `API-CONTRACTS-004`, `API-CONTRACTS-011`, `API-CONTRACTS-026`, `API-CONTRACTS-028` |
| Mutations, retries, or concurrent writes | `API-CONTRACTS-005`, `API-CONTRACTS-012`, `API-CONTRACTS-020`, `API-CONTRACTS-023`, `API-CONTRACTS-030` |
| Compatibility, lifecycle, or retirement | `API-CONTRACTS-006`, `API-CONTRACTS-016`, `API-CONTRACTS-024`, `API-CONTRACTS-025`, `API-CONTRACTS-029` |
| Capacity, authorization, or distributed operation | `API-CONTRACTS-007`, `API-CONTRACTS-008`, `API-CONTRACTS-010`, `API-CONTRACTS-030`, `API-CONTRACTS-031` |
| Asynchronous operations, events, or webhooks | `API-CONTRACTS-014`, `API-CONTRACTS-015` |
| Libraries and SDKs | `API-CONTRACTS-018` through `API-CONTRACTS-022`, `API-CONTRACTS-027`, `API-CONTRACTS-029`, `API-CONTRACTS-032` |

## Rules

### API-CONTRACTS-001 — Define the contract before implementation

**Level:** required  
**Applies when:** Adding or materially changing a programmatic interface.

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

Return a stable machine-readable error identifier, safe human detail, affected field or operation where appropriate, trace reference, and retry or remediation guidance without exposing secrets. For HTTP APIs, meet `CONTENT-ERRORS-011`: use RFC 9457 problem details or an equally stable documented contract.

**Why:** Parsing prose or guessing from one status code creates fragile callers and unsafe diagnostics.

**Verify:**

- Validate error responses against the published schema.
- Confirm sensitive inputs, internal stack details, credentials, and tenant data are absent.

**Exceptions:** Security-sensitive failures may intentionally collapse distinctions when the generic response is documented and observable internally.

### API-CONTRACTS-004 — Bound collections and work

**Level:** required  
**Applies when:** A response or operation can grow with stored data, fan-out, or caller input.

Set enforceable limits on request size, response size, page size, processing time, concurrency, and fan-out. Use stable continuation semantics for changing collections. Prefer cursor or continuation-token pagination when a collection can become large or change during traversal; do not expose an offset contract that cannot meet expected deep-page cost and consistency needs. Keep continuation tokens opaque, bind them to the applicable query state, and never treat possession of a token as authorization.

**Why:** Unbounded work causes resource exhaustion, latency spikes, duplicate processing, and incomplete traversal.

**Verify:**

- Exercise maximum, over-limit, empty, changing, and final-page cases.
- Confirm continuation does not silently omit or duplicate records under the documented consistency model.
- Exercise tampered, expired, cross-tenant, and parameter-mismatched continuation tokens.

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

Classify compatibility before implementation and prefer additive evolution. Do not remove, rename, relocate, narrow, or change the meaning or type of published behavior while supported callers depend on it. When a breaking change is justified, preserve old and new callers through an explicit version or migration window, publish deprecation and removal dates, and measure remaining use before removal. Internal ownership does not make a break safe unless every affected caller can be identified, coordinated, and verified.

**Why:** A syntactically small change can break stored clients, generated code, integrations, and delayed jobs.

**Verify:**

- Run contract and integration checks for supported client versions.
- Inspect production usage and owner approval before removing behavior.

**Exceptions:** An emergency security removal may shorten notice when the risk, affected callers, communication, and recovery path are recorded.

### API-CONTRACTS-007 — Make throttling fair and observable

**Level:** required  
**Applies when:** Capacity, abuse, cost, or contractual limits require rate control.

Define the counted identity, window or algorithm, shared-resource boundary, response semantics, retry guidance, exemptions, and operator visibility. Do not let one tenant consume another tenant's protected allocation without an explicit policy. Provide an owned way to reduce or suspend one abusive or malfunctioning caller without disabling healthy callers.

**Why:** Ambiguous rate limits produce retry storms, unfairness, and unexplained customer failures.

**Verify:**

- Exercise sustained, burst, distributed, and boundary traffic for separate tenants and credentials.
- Confirm limit responses, retry metadata, metrics, and alerts agree.

**Exceptions:** None for externally enforced limits; undisclosed defensive limits may omit exact thresholds but must retain actionable responses and internal ownership.

### API-CONTRACTS-008 — Verify authorization at the resource boundary

**Level:** required  
**Applies when:** An operation reads or changes protected resources.

Apply `SECURITY-APPLICATION-002`, which owns the enforcement requirement, at the interface contract: authorize the authenticated principal for the exact operation, tenant, object, fields, and current state on the trusted side of the interface.

**Why:** Endpoint-level authentication alone does not prevent cross-tenant or object-level access.

**Verify:**

- Run the `SECURITY-APPLICATION-002` verification against the published contract: allowed and denied cases across tenants, roles, object identifiers, field selection, and state transitions.
- Confirm bulk, nested, export, and error paths enforce the same boundary.

**Exceptions:** Explicitly public resources require classification and tests for unintended fields or state changes.

### API-CONTRACTS-009 — Model caller-visible product concepts

**Level:** required  
**Applies when:** Designing a new resource, operation, or material contract shape.

Represent stable product concepts and caller workflows with familiar protocol patterns. Do not expose storage links, service boundaries, job mechanics, or other implementation structure unless callers need that concept to use or control the product correctly.

**Why:** An interface coupled to internal structure transfers system complexity to every caller and becomes difficult to evolve without breaking them.

**Verify:**

- Trace representative caller goals through the contract without relying on undocumented implementation knowledge.
- Review whether each exposed resource, relationship, and state remains meaningful if storage or service topology changes.

**Exceptions:** Operational and administrative APIs may expose implementation concepts when those concepts are the intended subject of control and are documented as such.

### API-CONTRACTS-010 — Make secure adoption direct

**Level:** required  
**Applies when:** An API is intended for independent adoption by external or cross-team callers.

Provide the least complex authentication and first-request path allowed by the threat model. Document a runnable minimal request, credential scope, storage expectations, expiration, rotation, revocation, and the path to stronger delegated access when needed. Do not require an interactive delegated flow for a server-to-server use case unless the security model requires it.

**Why:** Callers often begin with a small integration, and unnecessary setup complexity causes unsafe workarounds or prevents adoption.

**Verify:**

- Complete credential creation, one useful request, rotation, and revocation from the published instructions in a clean environment.
- Confirm the simplest supported path retains required least-privilege, audit, tenant, and secret-handling controls.

**Exceptions:** High-risk or user-delegated access may require short-lived credentials, interactive authorization, device binding, or administrator approval.

### API-CONTRACTS-011 — Keep costly expansions explicit

**Level:** required  
**Applies when:** A field, relationship, computation, or downstream call materially increases response cost, latency, fan-out, or failure risk.

Keep the baseline response bounded and make costly expansions explicit and off by default. Define allowed expansions, nesting and size limits, authorization, partial-failure behavior, and cost or throttling semantics in the contract.

**Why:** Hidden work makes ordinary reads slow and lets a small request trigger unpredictable load across dependent systems.

**Verify:**

- Compare baseline and expanded requests for returned fields, authorization, queries or downstream calls, latency, and enforced bounds.
- Exercise unsupported, nested, over-limit, partially unavailable, and repeated expansion requests.

**Exceptions:** A field may remain in the baseline when callers almost always require it and measured cost stays within the interface objective at the enforced limits.

### API-CONTRACTS-012 — Prevent lost concurrent updates

**Level:** required  
**Applies when:** More than one actor can update or delete a resource based on previously read state and an unnoticed overwrite could cause harm.

Expose a resource version or validator and support a conditional mutation that rejects stale state. Define the conflict or precondition response, whether a missing precondition is allowed, and how callers can refetch, merge, or retry without silently discarding another actor's change.

**Why:** Read-modify-write races can return success while erasing a concurrent change.

**Verify:**

- Exercise simultaneous mutations with matching, stale, missing, malformed, and cross-resource validators.
- Confirm a rejected stale mutation leaves the newer state unchanged and returns enough information for the documented recovery path.

**Exceptions:** Append-only, commutative, or server-owned mutations may omit caller preconditions when their concurrency behavior cannot overwrite another actor's state and is documented.

### API-CONTRACTS-013 — Define caching and freshness behavior

**Level:** required  
**Applies when:** A response can pass through a browser, shared cache, gateway, client cache, or other component that may reuse it.

Declare whether the response can be stored and reused, its cache-key dimensions, freshness lifetime, revalidation behavior, and allowed stale behavior. Protect authenticated, tenant-specific, personal, and otherwise sensitive responses from shared or cross-context reuse. Use protocol cache controls and validators consistently with the documented semantics.

**Why:** Implicit cache behavior can leak one caller's data, serve stale state as current, or defeat expected performance.

**Verify:**

- Exercise fresh, stale, revalidated, changed, and invalidated responses through each material cache layer.
- Vary identity, tenant, authorization, locale, encoding, and other representation dimensions and confirm cache isolation and keys are correct.

**Exceptions:** An interface may disable storage and reuse explicitly when caching has no material value or cannot be made safe.

### API-CONTRACTS-014 — Define asynchronous operation lifecycle

**Level:** required  
**Applies when:** Work can exceed the synchronous request deadline, continue after disconnection, or finish outside the initiating request.

Return a durable operation handle or equivalent status resource. Define identity, states and transitions, status retrieval, result and error shape, progress semantics when present, cancellation behavior, retry and duplicate-submission behavior, authorization, retention, and expiration. Terminal results must remain distinguishable from an unknown or expired operation.

**Why:** A bare acceptance response leaves callers unable to determine whether work is queued, running, failed, duplicated, canceled, or complete.

**Verify:**

- Exercise lost submission responses, duplicate submissions, polling, worker restart, partial failure, cancellation races, terminal results, retention expiry, and unauthorized status access.
- Confirm each accepted operation reaches a documented terminal or recoverable state and remains reconcilable for the stated retention period.

**Exceptions:** A streaming operation may use stream completion as its lifecycle when disconnect behavior, resumption, final status, and side effects are explicit.

### API-CONTRACTS-015 — Define event and webhook delivery

**Level:** required  
**Applies when:** A service publishes events or calls a consumer-controlled endpoint.

Define stable event identity, source, type and schema version, occurrence time, subject, payload semantics, authentication or integrity protection, acknowledgement deadline, retry and backoff behavior, duplicate and ordering behavior, delivery horizon, replay or recovery path, and subscription and secret lifecycle. Consumers must be able to distinguish a redelivery of one event from a separate occurrence.

**Why:** Network and consumer failures make duplicate, delayed, missing, and out-of-order delivery normal conditions that callers must handle deliberately.

**Verify:**

- Exercise valid, forged, duplicated, delayed, out-of-order, malformed, timed-out, and repeatedly failing deliveries.
- Confirm endpoint validation, secret rotation, subscription suspension or deletion, replay, retention, and exhausted-delivery handling match the contract.

**Exceptions:** An explicitly at-most-once channel may omit redelivery and replay when the accepted loss behavior and recovery limits are documented.

### API-CONTRACTS-016 — Inventory and retire deployed surfaces

**Level:** required  
**Applies when:** An API or version is deployed to any production or non-production environment.

Maintain an owned inventory of hosts, environments, routes or methods, versions, exposure, authentication, data classification, lifecycle state, and intended consumers. Reconcile the inventory and published contract with the routes that gateways and applications actually serve. Signal deprecation and sunset through documented machine-readable protocol mechanisms where available, then remove the route, credentials, documentation, monitoring, and network exposure when retirement completes.

**Why:** Forgotten versions, debug routes, and undocumented environments remain reachable without current controls, ownership, or patching.

**Verify:**

- Compare contracts and inventory with DNS, gateways, load balancers, application routes, service discovery, and externally observable endpoints.
- Exercise deprecation and sunset signals, migration links, removal dates, post-retirement denial, and cleanup of credentials and exposure.

**Exceptions:** A short-lived isolated test surface may use an automatically expiring inventory record when it has no production data, public exposure, or durable consumers.

### API-CONTRACTS-017 — Design from representative use cases

**Level:** required  
**Applies when:** Adding a new API or materially expanding its caller-visible concepts.

Identify representative simple, complex, failure, and misuse cases before fixing the contract. Draft the smallest interface that supports them, write realistic calling code or requests, review it with intended callers and implementers, and retain accepted examples as contract or compatibility checks.

**Why:** An interface can look tidy in isolation while forcing awkward, unsafe, or impossible caller workflows.

**Verify:**

- Trace each selected use case through concrete caller code or requests, responses, errors, and cleanup.
- Confirm the implemented contract still supports the reviewed examples without undocumented steps or privileged implementation knowledge.

**Exceptions:** A narrow internal experiment may use a smaller provisional set when its callers and compatibility limits are explicit.

### API-CONTRACTS-018 — Keep vocabulary and shapes consistent

**Level:** required  
**Applies when:** Naming or shaping operations, resources, parameters, fields, results, or failures.

Use intelligible, customary, and unambiguous names; one term must keep one meaning across the interface. Use types that represent the domain value directly, and keep parameter order, defaults, nullability, units, identifiers, and result shapes consistent across similar operations. Operations with materially different behavior must not rely on a shared name or overload that hides the difference.

**Why:** Every inconsistency becomes a special case callers must remember and often discover through failure.

**Verify:**

- Compare related operations and generated or handwritten caller code for vocabulary, types, order, defaults, units, and empty-state behavior.
- Ask representative callers to predict an unfamiliar operation from established patterns and investigate material surprises.

**Exceptions:** A protocol or platform convention may require an established inconsistency; document it and avoid inventing an additional variation.

### API-CONTRACTS-019 — Minimize public surface and mutability

**Level:** required  
**Applies when:** Deciding whether a capability, type, field, state transition, extension point, or implementation detail is caller-visible.

Expose only what demonstrated caller use cases require and default the rest to private. Prefer immutable values and constrained state transitions. Do not expose storage, subclassing, inheritance, override, or other implementation extension points unless their supported behavior, invariants, compatibility, concurrency, and lifecycle are part of the contract.

**Why:** Public surface and mutation paths create permanent compatibility, testing, security, and support obligations.

**Verify:**

- Trace every exported element and mutation path to a current use case, owner, documentation, and compatibility test.
- Attempt unsupported mutation, extension, subclassing, and implementation substitution and confirm the boundary fails safely or is explicitly supported.

**Exceptions:** Framework and plugin APIs may intentionally expose extension points when their invariants, isolation, versioning, and failure behavior are documented and tested.

### API-CONTRACTS-020 — Reject invalid use before effects

**Level:** required  
**Applies when:** Invalid input, state, authorization, or preconditions can be detected before a durable or external side effect.

Validate the complete request at the earliest trusted boundary and return the documented failure before committing effects. When validation or authorization can fail only after work begins, define atomicity, partial success, compensation, status, and reconciliation behavior.

**Why:** Late failure wastes work and can leave callers with partial state that is difficult to detect or repair.

**Verify:**

- Exercise malformed, out-of-range, unauthorized, conflicting, and invalid-state requests and inspect all durable and external effects.
- Inject failure at each stage and confirm the final state and response match the documented atomicity or partial-success contract.

**Exceptions:** Streaming and incremental operations may validate progressively when future input is unavailable; prior accepted effects and stop behavior must remain explicit.

### API-CONTRACTS-021 — Return structured values and ordinary empty states

**Level:** required  
**Applies when:** Callers need to inspect, branch on, calculate with, or persist returned information.

Return structured fields with appropriate types instead of requiring callers to parse display strings or undocumented encodings. Represent ordinary absence with the contract's normal empty or optional form, and reserve errors or exceptional control flow for conditions that prevent the operation from fulfilling its contract.

**Why:** String parsing, magic sentinels, and exceptional normal states create fragile callers and hide type, localization, and compatibility errors.

**Verify:**

- Implement representative caller decisions using documented fields and types without parsing human text.
- Exercise zero, empty, absent, unknown, malformed, and failed results and confirm each has one stable meaning.

**Exceptions:** A text-format API may return strings as its primary domain value, but machine-significant components still require a defined grammar and versioning policy.

### API-CONTRACTS-022 — Document every exported contract element

**Level:** required  
**Applies when:** An element is available to callers outside its owning implementation.

Document purpose, inputs, outputs, side effects, errors, limits, units, defaults, nullability, concurrency, security, lifecycle, and examples wherever they affect correct use. Keep a runnable minimal example and representative advanced and failure examples synchronized with the released contract.

**Why:** Self-consistent naming reduces lookup cost but cannot communicate every behavioral, operational, and security obligation.

**Verify:**

- Reconcile exported elements with generated or written reference documentation and fail the documentation check on missing public elements.
- Run maintained examples against the final supported interface and verify their expected outcomes.

**Exceptions:** Obvious language-generated accessors may inherit type-level documentation when they add no independent behavior or constraints.

### API-CONTRACTS-023 — Define field presence and update ownership

**Level:** required  
**Applies when:** A request or response contains optional, nullable, immutable, input-only, output-only, defaulted, or partially updated fields.

Define each field's presence and ownership semantics, including whether it is required, optional, nullable, immutable, caller-set, or server-set. Distinguish omitted, null, empty, zero, false, and default values wherever they have different effects. Partial updates must identify the fields being changed and define whether omission preserves, clears, resets, or ignores each value.

**Why:** Ambiguous presence can erase data, overwrite server values, or make a newly added field break old update clients.

**Verify:**

- Exercise every meaningful combination of omitted, null, empty, zero, false, default, immutable, output-only, and explicitly selected fields.
- Read, partially update, and reread a resource; confirm unselected fields and unauthorized fields remain unchanged.

**Exceptions:** A replace operation may require a complete representation when replacement, defaults, and omitted-field behavior are explicit.

### API-CONTRACTS-024 — Specify consistency guarantees

**Level:** required  
**Applies when:** Callers can observe replicated, cached, asynchronous, or concurrently changing data.

Define read-after-write, read-after-delete, snapshot, monotonic-read, ordering, and replication-lag behavior where callers can observe a difference. State the scope of each guarantee, including resource, collection, tenant, region, replica, session, and time bounds as applicable.

**Why:** A successful write is misleading when callers cannot predict what later reads, lists, searches, or replicas may observe.

**Verify:**

- Exercise immediate and delayed reads after create, update, and delete across replicas, regions, caches, and supported client paths.
- Confirm observed staleness, ordering, snapshots, and convergence stay within the documented scope and bounds.

**Exceptions:** A single-process immutable interface may rely on its language memory model when no distributed consistency behavior is exposed.

### API-CONTRACTS-025 — Define lifecycle states and transitions

**Level:** required  
**Applies when:** A caller-visible resource or operation moves through states over time.

Model lifecycle states and allowed transitions explicitly. Distinguish transient, stable, terminal, failed, canceled, deleted, expired, and unknown states where applicable. Expose actions rather than allowing arbitrary state assignment when transitions have side effects, authorization, or preconditions.

**Why:** A state label without transition rules leaves callers unable to know which actions are valid or whether progress requires intervention.

**Verify:**

- Exercise every allowed and denied transition, including repeated, concurrent, stale, terminal, cancellation, and recovery attempts.
- Confirm each transient state reaches a documented next state or exposes the intervention and timeout behavior.

**Exceptions:** A value with no lifecycle or transition behavior may use an ordinary field instead of a state model.

### API-CONTRACTS-026 — Make collection queries deterministic

**Level:** required  
**Applies when:** A collection supports filtering, searching, sorting, pagination, counts, or caller-selected projections.

Define the query grammar, supported fields and operators, type coercion, case and locale behavior, null and missing-value handling, default and requested ordering, deterministic tie-breaking, authorization scope, and invalid-query response. Define whether counts are exact or estimated and bind continuation state to the filter, sort, projection, and consistency context that produced it.

**Why:** Underspecified queries produce missing or duplicated pages, unstable results, cross-tenant leaks, and client behavior tied to database accidents.

**Verify:**

- Exercise equal sort keys, concurrent inserts and deletes, nulls, unsupported fields and operators, malformed grammar, locale-sensitive text, and changed parameters between pages.
- Confirm filtering, counting, projection, and ordering occur within the authorized resource set and remain stable under the documented consistency model.

**Exceptions:** A collection with one fixed, documented order and no query controls may omit a query grammar.

### API-CONTRACTS-027 — Represent identifiers and quantities precisely

**Level:** required  
**Applies when:** A contract carries identifiers, time, dates, durations, money, measurements, counts, percentages, offsets, or other values whose representation affects meaning.

Use stable types and document format, unit, scale, precision, range, timezone or calendar basis, rounding, overflow, and comparison semantics as applicable. Treat opaque identifiers as opaque and preserve leading zeros and case rules. Money must identify currency and avoid binary floating-point assumptions where exact decimal value matters.

**Why:** Ambiguous scalars cause unit conversion errors, rounding loss, timezone shifts, identifier corruption, and incompatible generated clients.

**Verify:**

- Round-trip minimum, maximum, zero, negative where allowed, fractional, high-precision, timezone-boundary, daylight-saving, leap-day, leading-zero, and non-ASCII cases.
- Compare representations across every supported language, serializer, database boundary, and documentation example.

**Exceptions:** A domain standard may prescribe another representation when its version and semantics are part of the contract.

### API-CONTRACTS-028 — Define bulk and partial-result semantics

**Level:** required  
**Applies when:** One request reads or changes multiple independently identifiable items or sub-operations.

Define batch limits, ordering, atomicity, isolation, authorization, idempotency, and whether one failure rejects all work or returns partial results. For partial results, correlate every item with a success, failure, or unattempted state and make retrying only unresolved items safe.

**Why:** A single top-level success or failure cannot tell callers which durable effects occurred in a mixed batch.

**Verify:**

- Exercise all-success, first-failure, middle-failure, last-failure, timeout, duplicate item, unauthorized item, concurrent batch, and over-limit cases.
- Reconcile per-item results with final state and retry failed or unknown items without repeating successful effects.

**Exceptions:** A transactional batch may return one result when all items commit or none do and that atomicity is verified at every dependency boundary.

### API-CONTRACTS-029 — Preserve forward compatibility with unknown data

**Level:** required  
**Applies when:** Fields, variants, enum values, event types, union members, or schema extensions may be added during the supported lifetime.

Define how clients handle unknown response data and how servers handle unknown request data. Clients must not fail solely because a compatible response adds an unknown field or open value. Preserve reserved names, numeric tags, discriminators, and retired identifiers so they cannot be reused with a different meaning.

**Why:** Additive schema evolution is not compatible when generated clients, exhaustive switches, validators, or reused identifiers reject or reinterpret new data.

**Verify:**

- Run supported clients against responses containing unknown fields, enum values, event types, and union variants.
- Send unknown request members under each supported media type and confirm the documented reject, ignore, or preserve behavior without mass assignment.

**Exceptions:** A deliberately closed schema may reject unknown data when closure is required for safety or correctness and version negotiation protects future changes.

### API-CONTRACTS-030 — Define deadlines and cancellation

**Level:** required  
**Applies when:** Work can block, call dependencies, consume scarce resources, or continue after the caller stops waiting.

Define client and server deadlines, timeout signals, downstream budget propagation, cancellation acknowledgement, and whether cancellation stops pending work, interrupts active work, compensates completed work, or only stops waiting. A timeout or disconnect must not be presented as proof that no side effect occurred.

**Why:** Unbounded or misunderstood work wastes capacity and causes callers to retry operations whose original effects are still running or already complete.

**Verify:**

- Exercise deadlines before dispatch, during dependency calls, during commit, after commit but before response, and during cancellation races.
- Confirm downstream work, final status, resource cleanup, and retry guidance match the contract after timeout, disconnect, and cancellation.

**Exceptions:** A bounded local operation may rely on synchronous language cancellation semantics when it performs no external or durable effects.

### API-CONTRACTS-031 — Separate correlation from authority and deduplication

**Level:** required  
**Applies when:** Requests cross process boundaries or callers and operators need to trace an operation.

Accept or generate a safe correlation identifier and propagate standard trace context across participating boundaries where supported. Document which identifiers are caller-supplied, returned, logged, and propagated. Never treat correlation or trace identifiers as authentication, authorization, secrecy, freshness, or idempotency unless a separate contract explicitly grants that role.

**Why:** Conflating diagnostic identifiers with security or retry controls creates spoofing, data exposure, and duplicate-effect risks.

**Verify:**

- Trace one request through gateways, services, queues, callbacks, and errors while preserving tenant and privacy boundaries.
- Exercise missing, malformed, duplicated, spoofed, oversized, and conflicting correlation and trace identifiers.

**Exceptions:** A single-process library may omit distributed trace propagation while retaining a diagnostic context appropriate to its platform.

### API-CONTRACTS-032 — Treat SDK behavior as part of the contract

**Level:** required  
**Applies when:** The API owner publishes or endorses generated or handwritten client libraries, command tools, or language bindings.

Version each client against supported service contracts and define authentication, configuration, defaults, retries, idempotency, pagination, long-running operations, errors, cancellation, timeouts, unknown values, and thread or task safety. Follow language conventions without changing wire or semantic meaning, and publish support and deprecation policy for each runtime.

**Why:** Callers experience the SDK surface, and a correct wire endpoint does not compensate for a client that retries unsafely, hides pages, loses errors, or cannot represent new values.

**Verify:**

- Run the same contract scenarios through raw protocol and every supported client version and compare outcomes.
- Exercise installation, authentication, pagination, retries, cancellation, unknown values, deprecation, upgrade, and mixed client-service version combinations.

**Exceptions:** Community clients not published or endorsed by the API owner are outside the release gate but should receive a stable public contract to implement.

## Guidance

Prefer additive changes and generated contract checks, but do not mistake schema compatibility for semantic compatibility. Clients should ignore unknown response fields unless the contract explicitly defines a closed shape. Record consistency, ordering, time, money, identifiers, nullability, and partial success explicitly when they affect callers.

Choose an interface style because it fits caller tasks and operational constraints, not to satisfy architectural fashion. A flexible query interface can reduce over-fetching, but it also expands the authorization, cost-control, caching, and testing surface. Use it only when that tradeoff is justified and bounded.

Do not copy capacity accidents into permanent identifiers, types, or unchangeable client assumptions. Service limits are still required by `API-CONTRACTS-004`; choose them from measured capacity and risk, publish relevant behavior, and retain a compatible way to adjust them.

When many callers repeat the same mechanical sequence, consider moving it behind the API if the API can do so unambiguously without hiding authority, cost, network work, or failure. Keep the primitive operations when callers need control.

For library APIs, document whether types are safe to share across threads or tasks. Permit inheritance, subclassing, overriding, or implementation by callers only when it is a deliberate extension contract; code reuse alone is not a reason to expose inheritance. Choose checked, unchecked, result-value, or protocol error mechanisms according to whether callers can realistically recover and the conventions of the language or platform.

API design requires judgment. Prefer the smallest coherent contract supported by evidence, and record a concrete reason when a use case requires violating an established convention.

## Examples

### Retried payment request

Non-compliant: A timed-out create request can charge again when the caller retries.

Compliant: The caller supplies an idempotency key scoped to the account and operation; repeated matching requests return the original result, conflicting reuse is rejected, and the caller can query final status.

### Expensive relationship

Non-compliant: Every `GET /customers/{id}` request calls a billing provider and returns an unbounded history because some callers need subscription details.

Compliant: The baseline customer response stays local and bounded. Callers request `subscription` explicitly; the contract defines its authorization, timeout, partial-failure response, and history limit.

### Concurrent profile update

Non-compliant: Two administrators read version 7 of a customer profile, submit different edits, and both receive success while the second write silently removes the first.

Compliant: The profile exposes a validator. The first conditional update creates version 8; the stale second update is rejected without changing state and tells the caller to refetch and reconcile.

### Accepted export

Non-compliant: `POST /exports` returns `202 Accepted` with no identifier, leaving the caller unable to tell whether a timeout created an export.

Compliant: The request supports duplicate protection and returns an authorized operation URL whose states, result, error, cancellation, and expiration behavior are documented.

### Partial profile update

Non-compliant: An omitted `phone_number` in a patch request sometimes means “leave unchanged” and sometimes clears the field depending on which client serialized it.

Compliant: The update selects fields explicitly. Omitted unselected fields are preserved, an explicitly selected null follows the documented clear rule, and output-only fields cannot be changed.

### Bulk invitation

Non-compliant: A request to invite 100 members returns one timeout after 63 invitations were sent, with no per-member status or safe retry path.

Compliant: Each member has a stable sub-operation key and result. The caller retries only failed or unknown members, while repeated successful keys return their original outcomes.

## Sources

- Internet Engineering Task Force, [HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), RFC 9110. Reviewed August 13, 2026.
- Internet Engineering Task Force, [Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html), RFC 9457. Reviewed August 13, 2026.
- Internet Engineering Task Force, [Additional HTTP Status Codes](https://www.rfc-editor.org/rfc/rfc6585.html), RFC 6585. Reviewed August 13, 2026.
- Internet Engineering Task Force, [HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html), RFC 9111. Reviewed August 16, 2026.
- Internet Engineering Task Force, [The Sunset HTTP Header Field](https://www.rfc-editor.org/rfc/rfc8594.html), RFC 8594. Reviewed August 16, 2026.
- Internet Engineering Task Force, [The Deprecation HTTP Response Header Field](https://www.rfc-editor.org/rfc/rfc9745.html), RFC 9745. Reviewed August 16, 2026.
- OpenAPI Initiative, [OpenAPI Specification 3.2.0](https://spec.openapis.org/oas/v3.2.0.html). Reviewed August 16, 2026.
- Google, [AIP-151: Long-running operations](https://google.aip.dev/151). Reviewed August 16, 2026.
- Google, [AIP-154: Resource freshness validation](https://google.aip.dev/154). Reviewed August 16, 2026.
- Google, [AIP-158: Pagination](https://google.aip.dev/158). Reviewed August 16, 2026.
- Google, [AIP-180: Backwards compatibility](https://google.aip.dev/180). Reviewed August 16, 2026.
- Google, [AIP-132: Standard methods — List](https://google.aip.dev/132). Reviewed August 16, 2026.
- Google, [AIP-141: Quantities](https://google.aip.dev/141). Reviewed August 16, 2026.
- Google, [AIP-142: Time and duration](https://google.aip.dev/142). Reviewed August 16, 2026.
- Google, [AIP-149: Unset field values](https://google.aip.dev/149). Reviewed August 16, 2026.
- Google, [AIP-155: Request identification](https://google.aip.dev/155). Reviewed August 16, 2026.
- Google, [AIP-160: Filtering](https://google.aip.dev/160). Reviewed August 16, 2026.
- Google, [AIP-161: Field masks](https://google.aip.dev/161). Reviewed August 16, 2026.
- Google, [AIP-203: Field behavior documentation](https://google.aip.dev/203). Reviewed August 16, 2026.
- Google, [AIP-216: States](https://google.aip.dev/216). Reviewed August 16, 2026.
- Google, [AIP-231: Batch methods — Get](https://google.aip.dev/231). Reviewed August 16, 2026.
- Microsoft, [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines). Reviewed August 16, 2026.
- JSON Schema, [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12). Reviewed August 16, 2026.
- Google, [Protocol Buffers proto3 language guide](https://protobuf.dev/programming-guides/proto3/). Reviewed August 16, 2026.
- World Wide Web Consortium, [Trace Context](https://www.w3.org/TR/trace-context/), W3C Recommendation. Reviewed August 16, 2026.
- Cloud Native Computing Foundation, [CloudEvents Specification 1.0.2](https://github.com/cloudevents/spec/blob/v1.0.2/cloudevents/spec.md). Reviewed August 16, 2026.
- OWASP, [OWASP Top 10 API Security Risks 2023](https://owasp.org/API-Security/editions/2023/en/0x11-t10/). Reviewed August 16, 2026.
- Sean Goedecke, [Everything I know about good API design](https://www.seangoedecke.com/good-api-design/), August 24, 2025. Reviewed August 16, 2026.
- Joshua Bloch, [How to design a good API and why it matters](https://research.google/pubs/how-to-design-a-good-api-and-why-it-matters/), OOPSLA 2006, pages 506–507. Reviewed August 16, 2026.
