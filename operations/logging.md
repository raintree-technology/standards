---
id: OPERATIONS-LOGGING
title: TypeScript logging with Pino
description: Defines Pino as the server-side TypeScript logger and governs structured events, client observations, context, errors, sensitive data, levels, lifecycle, and delivery.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [engineering, platform, operations, security, privacy]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [typescript-service, typescript-client, node-service, service-change, service-operation]
tags: [operations, logging, observability, typescript, nodejs, browser, pino]
depends_on: [ENGINEERING-QUALITY, OPERATIONS-RELIABILITY, SECURITY-APPLICATION, PRIVACY-DATA, API-CONTRACTS]
generated: { by: codex/gpt-5, at: "2026-08-17T08:28:28Z" }
sources:
  - id: pino-readme
    resource: https://github.com/pinojs/pino/tree/v10.3.1
    title: Pino 10.3.1
    author: organization:pinojs
  - id: pino-api
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/api.md
    title: Pino API
    author: organization:pinojs
  - id: pino-redaction
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/redaction.md
    title: Pino redaction
    author: organization:pinojs
  - id: pino-transports
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/transports.md
    title: Pino transports
    author: organization:pinojs
  - id: pino-asynchronous
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/asynchronous.md
    title: Pino asynchronous logging
    author: organization:pinojs
  - id: pino-browser
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/browser.md
    title: Pino browser API
    author: organization:pinojs
  - id: pino-bundling
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/bundling.md
    title: Pino bundling
    author: organization:pinojs
  - id: pino-child-loggers
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/child-loggers.md
    title: Pino child loggers
    author: organization:pinojs
  - id: pino-lts
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/lts.md
    title: Pino long-term support policy
    author: organization:pinojs
  - id: pino-web-frameworks
    resource: https://github.com/pinojs/pino/blob/v10.3.1/docs/web.md
    title: Pino web frameworks
    author: organization:pinojs
  - id: node-async-context
    resource: https://nodejs.org/api/async_context.html
    title: Node.js asynchronous context tracking
    author: organization:openjs-foundation
  - id: node-process
    resource: https://nodejs.org/api/process.html
    title: Node.js process
    author: organization:openjs-foundation
  - id: node-stream
    resource: https://nodejs.org/api/stream.html
    title: Node.js streams
    author: organization:openjs-foundation
  - id: otel-logs-data-model
    resource: https://opentelemetry.io/docs/specs/otel/logs/data-model/
    title: OpenTelemetry logs data model
    author: organization:open-telemetry
  - id: otel-service-conventions
    resource: https://opentelemetry.io/docs/specs/semconv/resource/service/
    title: OpenTelemetry service semantic conventions
    author: organization:open-telemetry
  - id: owasp-logging-cheat-sheet
    resource: https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html
    title: OWASP Logging Cheat Sheet
    author: organization:owasp
  - id: w3c-trace-context
    resource: https://www.w3.org/TR/trace-context/
    title: Trace Context
    author: organization:w3c
---

# TypeScript logging with Pino

Server-side TypeScript services must emit protected, machine-readable events that operators can correlate and query without reconstructing meaning from free text. Pino is the standard logger for Node.js TypeScript services.

## Rules

### OPERATIONS-LOGGING-001 — Use Pino behind one application logging boundary

**Level:** required  
**Applies when:** A server-side TypeScript application or service runs on Node.js or a Pino-supported server runtime.

Use a supported Pino major through one application-owned logger module. Application code, shared libraries, framework hooks, and background jobs must use that boundary rather than `console`, ad hoc stdout writes, or competing logging packages. Lock the resolved version, keep its Node.js release line compatible with Pino's support policy, and review upgrades and transports under `ENGINEERING-QUALITY-004`.

When a framework provides an official Pino integration, inject or reuse the application logger and its request child logger. Do not let the framework create a separately configured logger or emit a second access event for the same boundary.

**Why:** One logger and configuration boundary keeps event shape, levels, redaction, context, and delivery behavior consistent across the service.

**Verify:**

- Inspect imports and output calls for bypasses and competing loggers.
- Start the built artifact and confirm representative code paths emit Pino JSON through the configured boundary.
- Compare the resolved Pino major, Node.js runtime, framework adapter, transports, and bundler integration with their maintained compatibility ranges and release notes.

**Exceptions:** A browser, edge, embedded, or non-Node runtime that Pino does not support may use another structured logger after recording the runtime constraint and proving the remaining rules. A third-party library may retain its logger when its output is adapted at the service boundary.

### OPERATIONS-LOGGING-002 — Emit a stable structured event contract

**Level:** required  
**Applies when:** The application emits an operational log event.

Emit one newline-delimited JSON object per event with the following application contract:

| Field | Type | Meaning |
|---|---|---|
| `time` | number | Event time as Unix epoch milliseconds from the emitting process |
| `level` | number | Unmodified Pino severity number |
| `msg` | string | Short human-readable summary whose wording is not an automation contract |
| `event` | string | Stable machine-readable event name |
| `schemaVersion` | integer | Version of the application log-event contract |
| `service` | string | Stable logical service name |
| `version` | string | Deployed build, image, or source version |
| `environment` | string | Deployment environment |

Map `service` and `version` to OpenTelemetry `service.name` and `service.version`, and map `environment` to the governed deployment resource attribute at collection when OpenTelemetry is used. Add operation, component, outcome, duration, dependency, tenant, region, or other fields only when they serve a defined diagnostic or operational query. Use explicit units in field names such as `durationMs` or map them to a current semantic convention. Keep field names and types stable across services; treat changes used by alerts, dashboards, retention, security detection, or support workflows as versioned contract changes.

Reserve `time`, `level`, `msg`, `event`, `schemaVersion`, `service`, `version`, `environment`, `pid`, `hostname`, `err`, `requestId`, `traceId`, and `spanId` for their defined meanings. Application types or Pino module augmentation must prevent callers from replacing application-owned base fields and must type shared context fields; runtime tests must protect the remaining Pino-reserved fields. Place necessary externally controlled values under application-owned keys after validation; keep them out of `msg` when structured representation is possible, and do not merge arbitrary request, payload, header, query, metadata, or user objects into the top level. Parent bindings, child bindings, mixins, serializers, formatters, and call-site objects must not emit duplicate JSON keys.

**Why:** Stable fields support reliable queries and automation, while controlled namespaces prevent untrusted keys from replacing fields such as `level`, `time`, or `msg`.

**Verify:**

- Parse representative output as newline-delimited JSON and validate required fields, types, event names, and timestamp behavior.
- Exercise missing, malformed, and attacker-controlled input and confirm it cannot replace reserved or application-owned fields.
- Exercise carriage returns, line feeds, Unicode controls, delimiters, format tokens, and multiline values and confirm each call remains one valid event through every formatter and destination.
- Inspect raw output before parsing and reject duplicate keys, because parsers can silently keep different values.
- Compare collected resource identity, time, severity, trace fields, and event names with the application contract and OpenTelemetry mapping when active.

**Exceptions:** A command-line tool whose output is solely for an interactive user may keep human-readable output separate, but diagnostic logs must still satisfy this contract when retained or collected.

### OPERATIONS-LOGGING-003 — Carry bounded operation context with child loggers

**Level:** contextual  
**Applies when:** Work crosses an asynchronous boundary or operators need to correlate events for a request, job, message, or distributed operation.

Create a Pino child logger at the owned boundary and bind validated context once. Pass that logger explicitly or retrieve it from an `AsyncLocalStorage` context established with `run`; do not use process-global mutable context or allow one concurrent operation's bindings to enter another. Include the applicable request, job, message, trace, and span identifiers and propagate standard trace context across service boundaries under `API-CONTRACTS-031`. When `spanId` is present, include its `traceId`. Do not use correlation identifiers as authentication, authorization, idempotency, secrecy, or proof of identity.

**Why:** Repeated manual context fields drift or disappear, while correlation values become dangerous when code treats them as authority.

**Verify:**

- Trace representative success and failure through concurrent requests, jobs, queues, dependencies, and retries.
- Exercise missing, malformed, oversized, duplicated, and spoofed identifiers and confirm validation, replacement, or rejection follows the interface contract.
- Run overlapping operations with distinct identities and trace context, including callback-based and custom asynchronous code, and confirm no context is lost or crosses between them.

**Exceptions:** A single-step local operation may omit distributed identifiers when its events remain unambiguous.

### OPERATIONS-LOGGING-004 — Serialize errors as structured errors

**Level:** required  
**Applies when:** Code records an exception or failure object.

Pass the `Error` to the logger under the configured error key, normally `err`, so Pino's error serializer can preserve its type, message, stack, code, and supported cause chain. Preserve the original `cause` when wrapping an error. Normalize thrown non-`Error` values into a bounded error representation. Add safe operation and outcome fields separately. Do not interpolate an error into the message, log only `error.message`, or record the same exception at every layer.

**Why:** String-only errors discard stack, type, cause, and correlation data needed to distinguish and diagnose failures.

**Verify:**

- Trigger ordinary, wrapped, caused, aggregate, system-code, circular, and non-`Error` failures and inspect the collected event.
- Confirm error serialization and redaction still work in the built artifact and framework integrations.

**Exceptions:** A stack or cause that contains sensitive data must be filtered or omitted under `OPERATIONS-LOGGING-005`, with alternate diagnostic evidence when needed.

### OPERATIONS-LOGGING-005 — Minimize and redact sensitive data before delivery

**Level:** required  
**Applies when:** Secrets, credentials, personal data, confidential content, or attacker-controlled text could reach a log call.

Log an allowlist of diagnostic fields instead of raw request, response, body, headers, cookies, query, session, user, token, database record, or third-party payload objects. Configure centrally owned Pino redaction paths at initialization as defense in depth, including nested, array, alternate-case, and framework-specific locations used by the application. Prefer explicit paths; use wildcards only when their coverage and cost are measured. Remove secrets instead of retaining a reversible, partial, or recognizable form. Never let external input define redaction paths. Keep production redaction in every destination, including debug, error, audit, transport, and support output.

Redaction is a final guard, not permission to construct a sensitive event. It does not protect data already copied into message text, stack traces, computed keys, unknown aliases, browser output, transport diagnostics, or a destination that bypasses the configured logger.

**Why:** Collection, replication, retention, and broad operator access make a logged secret or personal record harder to contain than the source request.

**Verify:**

- Run canary values through representative routes, failures, serializers, child loggers, framework hooks, and transports, then search every destination and support artifact.
- Test new, renamed, differently cased, interpolated, nested, and array fields against both the allowlist and redaction configuration.
- Confirm child loggers cannot override or disable parent redaction and that configuration cannot be influenced after trusted initialization.

**Exceptions:** Logging personal or confidential data requires the recorded purpose, authority, minimization, access, retention, and deletion controls from `PRIVACY-DATA`. Secrets remain prohibited under `SECURITY-APPLICATION-008`.

### OPERATIONS-LOGGING-006 — Give each level one operational meaning

**Level:** required  
**Applies when:** Defining or calling a log level.

Use `fatal` only immediately before process termination, `error` for a failed operation that needs investigation or response, `warn` for an abnormal condition the service handled but an owner should assess, `info` for bounded lifecycle and business-operation milestones, and `debug` or `trace` for temporary diagnostic detail. Keep Pino's numeric levels and define an explicit downstream severity mapping. Do not introduce custom levels unless every destination, alert, and OpenTelemetry mapping is tested with them.

Configure the minimum level by environment without code changes. Do not let request data or ordinary users change it. A production level change requires authorized control, actor and reason, affected scope, maximum duration, automatic reversion, and an audit event. The logger's level is the first filter; when multiple transport targets exist, configure and test each target's additional filter.

**Why:** Inconsistent levels create noisy alerts, duplicated incidents, hidden failures, and unpredictable storage cost.

**Verify:**

- Review representative events and alert queries against the level definitions.
- Trigger one failure through multiple layers and confirm one owned error event plus any distinct recovery event.
- Exercise every environment, runtime level change, single transport, and multiple-target configuration and confirm the intended methods and destinations receive each level.

**Exceptions:** A documented protocol or collector mapping may translate levels while preserving their operational meaning.

### OPERATIONS-LOGGING-007 — Bound log volume and field cardinality

**Level:** required  
**Applies when:** A code path can repeat with traffic, data size, retries, polling, batching, or attacker activity.

Set an event size limit below every process, runtime, collector, transport, network, and backend limit and bound repeated events, collections, object depth, strings, stack traces, and high-cardinality fields. Do not serialize entire domain objects merely because they are available. Check `isLevelEnabled` before constructing expensive diagnostic fields. Prefer metrics for aggregate counts and traces for sampled execution detail. Apply deterministic sampling or rate limits only after preserving errors, security-relevant and audit events, rare outcomes, and enough counts to measure what was suppressed.

**Why:** Unbounded logs can raise latency and cost, exhaust storage or ingestion limits, and obscure the event that matters.

**Verify:**

- Load-test success, failure, retry, abuse, cardinality, circular input, deep objects, and large-input paths and measure emitted bytes, events, CPU, memory, event-loop delay, latency, dropped events, and collector behavior.
- Confirm suppression is observable and does not hide alerts, security evidence, or rare failures.

**Exceptions:** A time-bounded diagnostic increase requires an owner, expiry, cost and data review, and rollback path.

### OPERATIONS-LOGGING-008 — Separate service emission from log delivery

**Level:** required  
**Applies when:** Logs leave the process or require formatting, transformation, routing, or remote transmission.

Emit production JSON to the runtime's managed stdout or approved local destination. Perform pretty printing only in local development. Run transformation and remote transmission outside the request hot path through a Pino transport worker, sidecar, runtime collector, or platform collector. Custom writable streams and transports must honor backpressure, surface errors, close their destination, and flush before completing close.

Define startup readiness, buffer size, backpressure, destination outage, retry, ordering, duplication, disk or memory bounds, loss, shutdown deadline, and flush behavior. Record the accepted loss window for asynchronous logging. Prefer setting `process.exitCode` and allowing graceful completion; do not call `process.exit()` while stdout, stderr, a destination, or a transport may still hold required events. Handle orchestrator termination signals within the shutdown budget. A crash handler may make a bounded final write, but must not keep an application running after an uncaught fatal failure merely because it was logged. In serverless or another runtime that replaces stdout, use the platform-supported mode and wait for required flush completion at the end of each invocation.

When bundling an application that uses Pino transports, include and resolve Pino, `thread-stream`, file, and configured transport worker artifacts in the final package. Do not infer transport readiness from logger construction alone.

**Why:** Synchronous remote delivery and in-process formatting can turn an observability failure into service latency or data loss, while an untested asynchronous path can silently drop terminal events.

**Verify:**

- Exercise startup, sustained load, backpressure, collector outage, recovery, graceful shutdown, uncaught failure, and forced termination.
- Trace a canary event from the process through collection, indexing, access control, retention, query, and deletion, and reconcile emitted, accepted, rejected, and dropped counts.
- Run the packaged artifact in each deployment runtime and verify worker resolution, transport readiness, multi-target level routing, serverless invocation completion when applicable, signal handling, exit status, close, and flush.

**Exceptions:** A short-lived local tool may use a synchronous destination when measured volume is small and completion waits for the final write.

### OPERATIONS-LOGGING-009 — Define the events the service must produce

**Level:** required  
**Applies when:** A service, job, consumer, or scheduled function has behavior that operators, security responders, support, or dependent teams must detect or reconstruct.

Maintain a reviewed event catalog that names the event, triggering condition, owner, level, required fields, data classification, expected volume, retention class, consumer, and alert or query when applicable. Cover at least process and worker start, readiness, draining, and stop; deployment or configuration identity; owned operation success and failure; dependency timeout and circuit state; retry exhaustion; queue or job terminal state; data-integrity or reconciliation failure; and the security-relevant behavior required by `SECURITY-APPLICATION-013`.

Record outcomes at the boundary that owns them. Do not log routine internal steps, every successful read, or both receipt and completion without a defined consumer. Metrics, traces, and logs may describe the same operation, but each signal must have a distinct purpose and compatible identity.

**Why:** Logging added opportunistically produces high volume yet omits the exact lifecycle and failure evidence needed during an incident.

**Verify:**

- Trace each catalog event to its code path, data classification, example output, operational consumer, and owner.
- Exercise success, rejection, cancellation, timeout, retry, partial failure, terminal failure, recovery, startup, and shutdown and reconcile emitted events with the catalog.
- Inspect unused, duplicate, unreachable, and high-volume events and either remove them or record their consumer.

**Exceptions:** A library that does not own a runtime lifecycle may define only the events it exposes to its host and must not create a hidden destination.

### OPERATIONS-LOGGING-010 — Keep serializers and logger hooks deterministic and safe

**Level:** required  
**Applies when:** Configuring a serializer, formatter, mixin, hook, timestamp function, custom transport transform, or logger wrapper.

Keep logger extension code synchronous where Pino requires it, bounded, deterministic, and free of network, filesystem, database, cryptographic, or other blocking work. It must return JSON-serializable data, never throw into application behavior, never mutate caller-owned or shared objects, and preserve required fields, numeric severity, redaction, and error handling. Do not use a mixin or hook to recover ambient mutable context when an explicit child logger or bounded asynchronous context can provide it.

Treat extension failures as observable logging-pipeline failures without recursively logging through the failing path. Pin and review third-party serializers, formatters, and transports as runtime dependencies.

**Why:** Logger customization runs on common and failure paths; blocking, throwing, mutation, or recursion can change application behavior exactly when diagnostic evidence is needed.

**Verify:**

- Property-test supported values including `undefined`, `bigint`, circular objects, getters that throw, deep arrays, long strings, errors, and attacker-controlled keys.
- Inject extension and transport failures and confirm the application policy, fallback signal, and recursion bound.
- Benchmark enabled and disabled levels with the final serializers, formatters, hooks, and transports.

**Exceptions:** None for code executed on the application thread. A transport worker may perform delivery I/O under the bounded delivery contract in `OPERATIONS-LOGGING-008`.

### OPERATIONS-LOGGING-011 — Protect logs throughout their lifecycle

**Level:** required  
**Applies when:** Logs are buffered, transmitted, collected, indexed, searched, exported, copied, backed up, or deleted.

Classify each stream and destination from the most sensitive event it can receive. Encrypt protected logs across untrusted networks and at rest where required; restrict producer, reader, exporter, administrator, and deletion permissions separately; record and monitor access; and prevent application workloads from altering retained records. Define retention and deletion by purpose, incident need, privacy obligation, contract, and cost, including debug streams, dead-letter data, archives, backups, exports, and support bundles.

Keep tenant and environment boundaries through collection and query. Do not send logs to a new provider, region, account, or training or support feature until its authority, data terms, access, retention, deletion, outage behavior, and exit path are approved under the active privacy, security, and vendor rules.

**Why:** Source redaction does not protect logs from excessive access, unauthorized alteration, indefinite retention, or an ungoverned downstream copy.

**Verify:**

- Trace representative events and canary data through buffers, networks, accounts, indexes, replicas, archives, exports, backups, support paths, retention, legal holds, and deletion.
- Test cross-tenant, cross-environment, producer-write, reader-export, administrator, revoked-user, and expired-record access boundaries.
- Review access and configuration change history and verify tamper detection or protected immutability where the stream's purpose requires it.

**Exceptions:** Local development logs may use a shorter, local lifecycle but must contain no production data or credentials and must be removed when no longer needed.

### OPERATIONS-LOGGING-012 — Monitor the logging pipeline as a dependency

**Level:** required  
**Applies when:** Operational decisions, alerts, investigations, support, security detection, or audit evidence depend on collected logs.

Measure emission, accepted and rejected records, parse failures, queue depth, backpressure, retries, drops, duplicate delivery, ingestion delay, indexing delay, storage use, query availability, clock skew, and cost at the boundaries the platform exposes. Alert an owner on material loss, delay, corruption, access failure, or unexpected volume without depending solely on the failing log path. Synchronize process clocks and preserve both event time and collector-observed time when delay or offline delivery can be material.

Use a bounded synthetic canary or reconciliation record to prove end-to-end delivery. Never put a secret or real person's data in that record.

**Why:** A service can appear healthy while its logging path silently drops, delays, misparses, or misroutes the evidence used to operate it.

**Verify:**

- Break each observable pipeline stage and confirm detection, routing, runbook action, recovery, and reconciliation.
- Compare emitted, buffered, transported, accepted, indexed, queried, retained, and deleted counts across normal load, overload, outage, and recovery.
- Skew an allowed test clock and delay delivery to confirm event and observed time remain distinguishable.

**Exceptions:** A low-impact local tool may verify its explicit result artifact instead of operating a continuous pipeline.

### OPERATIONS-LOGGING-013 — Govern browser and other untrusted-client logs separately

**Level:** contextual  
**Applies when:** TypeScript runs in a browser, mobile shell, edge client, desktop client, or another user-controlled runtime and sends logs off the device.

Do not assume the server Pino configuration applies in a client runtime. Pino browser output uses console methods by default and does not support Pino redaction. Construct an allowlisted event that contains no secret, credential, session value, raw URL query, form value, page content, personal data without authority, or trusted security conclusion before calling the logger or transmitter.

Treat client identity, time, level, event fields, and error detail as untrusted observations. Authenticate the receiving endpoint where appropriate, authorize only event submission, enforce origin and schema checks, bound size and rate, prevent log injection and tenant selection, and apply server-side enrichment and redaction before protected storage. Define offline buffering, user choice or notice when required, transmission failure, retention, and deletion. Disable client transmission by default when it has no recorded operational or product purpose.

**Why:** Client code and data are visible and alterable, and browser logging can expose sensitive content or create false operational and security evidence.

**Verify:**

- Inspect the shipped client artifact and runtime configuration for serializers, console output, transmission, endpoints, and disabled states.
- Submit forged identity, tenant, time, severity, event names, multiline content, oversized data, high volume, expired sessions, and offline replay and confirm safe handling.
- Search device buffers, browser consoles, network traces, collectors, support tools, and retained destinations for canary values.

**Exceptions:** Console-only local development output may remain on the developer's device when it contains synthetic data and cannot be collected or shipped.

### OPERATIONS-LOGGING-014 — Separate diagnostic, security, and audit evidence

**Level:** required  
**Applies when:** A log event supports security detection, privileged-action review, financial or compliance evidence, or reconstruction of who changed consequential state.

Label the event purpose and route it to controls appropriate to that purpose. A security event must record the bounded action, outcome, protected actor reference, target reference, service identity, trusted server time, correlation, and control or reason code needed for detection without storing credentials or unnecessary payloads. An audit record additionally requires defined completeness, ordering, durable write behavior, access history, retention, integrity protection, and correction semantics. Ordinary diagnostic logs are not an authoritative audit ledger.

Do not claim non-repudiation, exact ordering, completeness, or actor identity from caller-supplied IDs, asynchronous best-effort output, mutable indexes, or clocks that have not been verified for that property. If a required audit write fails, follow the owning transaction's explicit fail-open or fail-closed policy and emit an independent failure signal.

**Why:** Treating convenient application logs as audit proof can create false attribution, missing records, and compliance or incident conclusions the system cannot support.

**Verify:**

- Exercise allowed, denied, failed, retried, concurrent, privileged, and break-glass actions and reconcile authoritative state changes with security and audit records.
- Attempt caller spoofing, record alteration, deletion, reordering, duplicate delivery, destination outage, and audit-write failure.
- Confirm every claim made from the stream is supported by its identity, time, durability, integrity, access, and completeness controls.

**Exceptions:** A system with no authoritative audit requirement may use protected security events for detection and investigation, but must state that they are not a complete ledger.

## Guidance

Keep the application logger wrapper small. It should own base fields, schema types, redaction, level configuration, serializers, and logger construction without hiding Pino's structured call shape. Prefer framework adapters that accept the same Pino instance instead of creating a second logger. Use a supported direct Pino release; add `pino-http` or another adapter only when the framework needs it and its request lifecycle is verified.

Define event names as stable machine identifiers such as `http.request.completed`, `job.delivery.failed`, or `dependency.call.retried`. Keep `msg` short and useful to a person; do not make parsers depend on message text. Prefer an `outcome` such as `success`, `failure`, `cancelled`, or `unknown` over encoding the outcome only in the event name when consumers compare outcomes. Use TypeScript discriminated unions for cataloged event shapes and Pino module augmentation or wrapper types to ban base-field overrides. Do not make request, user, or trace fields globally required when they cannot apply to every event.

Pino defaults are a sound starting point: numeric levels, Unix epoch millisecond time, newline-delimited JSON, the `err` serializer, and stdout. Transform to a backend's field names after Pino routing rather than changing the source contract. In particular, keep numeric `level` when multiple targets route by it. Add ISO display time in the collector or query layer unless a measured consumer requires a second source field; in-process time formatting adds work to every enabled event.

Explicitly passing a child logger is the clearest context model. Use `AsyncLocalStorage` when framework and application boundaries make explicit passing impractical, initialize context with `run`, keep the store immutable or operation-owned, and test any callback library or custom thenable that can lose context. Never place the current user or request in a module-global variable.

Prefer the runtime or platform collector over direct remote transports when it already provides buffering, retry, encryption, identity, and backpressure. If a direct Pino transport is necessary, keep its options serializable for the worker boundary, wait for readiness when early termination is possible, and implement close. Asynchronous logging trades lower request overhead for a bounded window in which recent buffered events can be lost during abrupt system failure; the service owner must choose that tradeoff deliberately.

Production should never depend on pretty output. Keep `pino-pretty` in local development tooling, and verify that production configuration cannot enable it accidentally. Custom transports written in TypeScript should be compiled for the production runtime unless the chosen Node.js release and deployment path explicitly support the source form.

## Examples

### Request-scoped event and error

Compliant:

```ts
import pino from "pino";

declare module "pino" {
  interface LogFnFields {
    service?: never;
    version?: never;
    environment?: never;
    schemaVersion?: never;
    requestId?: string;
    traceId?: string;
    spanId?: string;
  }
}

function requiredEnv(name: "APP_VERSION" | "NODE_ENV"): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required configuration: ${name}`);
  return value;
}

export const logger = pino({
  base: {
    service: "orders-api",
    version: requiredEnv("APP_VERSION"),
    environment: requiredEnv("NODE_ENV"),
    schemaVersion: 1,
  },
  redact: {
    paths: [
      "authorization",
      "headers.authorization",
      "headers.cookie",
      "user.email",
    ],
    remove: true,
  },
});

const requestLog = logger.child({ requestId, traceId });

try {
  await submitOrder();
  requestLog.info(
    { event: "order.submit.completed", outcome: "success", durationMs },
    "Order submitted",
  );
} catch (err) {
  requestLog.error(
    { event: "order.submit.failed", outcome: "failure", durationMs, err },
    "Order submission failed",
  );
}
```

Non-compliant:

```ts
console.log("request", request);
logger.error(`Order failed for ${user.email}: ${error.message}`);
```

The non-compliant form bypasses the shared configuration, exposes broad objects and personal data, and discards structured error evidence.

## Sources

- Pino project, [Pino 10.3.1](https://github.com/pinojs/pino/tree/v10.3.1). Reviewed August 17, 2026.
- Pino project, [Pino API](https://github.com/pinojs/pino/blob/v10.3.1/docs/api.md). Reviewed August 17, 2026.
- Pino project, [Pino redaction](https://github.com/pinojs/pino/blob/v10.3.1/docs/redaction.md). Reviewed August 17, 2026.
- Pino project, [Pino transports](https://github.com/pinojs/pino/blob/v10.3.1/docs/transports.md). Reviewed August 17, 2026.
- Pino project, [Pino asynchronous logging](https://github.com/pinojs/pino/blob/v10.3.1/docs/asynchronous.md). Reviewed August 17, 2026.
- Pino project, [Pino browser API](https://github.com/pinojs/pino/blob/v10.3.1/docs/browser.md). Reviewed August 17, 2026.
- Pino project, [Pino bundling](https://github.com/pinojs/pino/blob/v10.3.1/docs/bundling.md). Reviewed August 17, 2026.
- Pino project, [Pino child loggers](https://github.com/pinojs/pino/blob/v10.3.1/docs/child-loggers.md). Reviewed August 17, 2026.
- Pino project, [Pino long-term support policy](https://github.com/pinojs/pino/blob/v10.3.1/docs/lts.md). Reviewed August 17, 2026.
- Pino project, [Pino web frameworks](https://github.com/pinojs/pino/blob/v10.3.1/docs/web.md). Reviewed August 17, 2026.
- OpenJS Foundation, [Node.js asynchronous context tracking](https://nodejs.org/api/async_context.html). Reviewed August 17, 2026.
- OpenJS Foundation, [Node.js process](https://nodejs.org/api/process.html). Reviewed August 17, 2026.
- OpenJS Foundation, [Node.js streams](https://nodejs.org/api/stream.html). Reviewed August 17, 2026.
- OpenTelemetry, [Logs data model](https://opentelemetry.io/docs/specs/otel/logs/data-model/). Reviewed August 17, 2026.
- OpenTelemetry, [Service semantic conventions](https://opentelemetry.io/docs/specs/semconv/resource/service/). Reviewed August 17, 2026.
- OWASP Foundation, [Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html). Reviewed August 17, 2026.
- World Wide Web Consortium, [Trace Context](https://www.w3.org/TR/trace-context/). Reviewed August 17, 2026.
