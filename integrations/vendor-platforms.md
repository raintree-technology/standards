---
id: INTEGRATIONS-VENDOR
title: External platform integrations
description: Governs inventory, authority, callbacks, side effects, release evidence, observability, and recovery for external platform dependencies.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [engineering, platform, security, privacy, operations]
last_reviewed: 2026-08-17
review_by: 2027-02-17
stale_after: 2027-02-17
applies_to: [product-feature, service-change, api-change, database-change, deployment, vendor-change, standards-audit]
tags: [integrations, vendors, platforms, callbacks, recovery]
depends_on: [FND-EVIDENCE, FND-CHANGE, API-CONTRACTS, OPERATIONS-RELIABILITY, PRIVACY-DATA, SECURITY-APPLICATION, SECURITY-SECRETS, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:28:10Z" }
---

# External platform integrations

External platforms must be integrated through explicit contracts, narrow authority, repeat-safe effects, current provider guidance, exercised failure handling, and evidence from the released environment. Provider playbooks add current platform procedures without turning volatile vendor defaults into universal policy.

This draft requires independent engineering, platform, security, privacy, and operations review before becoming stable.

## Rules

### INTEGRATIONS-VENDOR-001 — Inventory the effective vendor contract

**Level:** required
**Applies when:** Adding, changing, operating, or auditing an external platform dependency.

Record the provider, products and capabilities used, account and project boundary, environments, regions, data categories, recipients, credentials and roles, API and SDK versions, callbacks, limits, billing owner, support route, service objectives, retention, deletion, recovery, and exit path. Trace actual code, configuration, control-plane settings, and network flow rather than relying only on intended architecture.

**Why:** A provider name does not reveal the authority, data, cost, or failure behavior of the features actually enabled.

**Verify:**

- Reconcile the inventory with dependency manifests, environment names without values, deployed configuration, provider settings, network observations, callback registrations, data stores, and billing records.
- Identify unused credentials, stale callbacks, orphaned projects, and undocumented downstream recipients.

**Exceptions:** A time-bounded experiment may use a shorter record but must still name authority, data, cost, owner, deletion, and shutdown.

### INTEGRATIONS-VENDOR-002 — Revalidate provider guidance and review aids

**Level:** required
**Applies when:** Designing, changing, or auditing a provider integration.

Load the active provider playbook. When the executing environment supplies a mapped agent skill, record its logical name and installed package version and use it to locate provider-specific checks. Verify every volatile claim, API shape, security control, limit, default, deprecation, and release instruction against current official provider documentation. Treat skills as routing and review aids, not evidence that the deployed system conforms.

If a mapped skill is unavailable, record the gap and continue with current official documentation. Do not omit the provider review or invent skill-derived requirements.

**Why:** Review aids make specialist work repeatable, but both the aids and platforms can change independently.

**Verify:**

- Record the playbook, skill name and version or `not available`, official sources, review date, product scope, and conflicts between guidance, code, and deployed behavior.
- Re-run applicable provider evaluations after material integration or platform changes.

**Exceptions:** A human-only audit may omit the skill record but must use the provider playbook, current official sources, and the same evidence requirements.

### INTEGRATIONS-VENDOR-003 — Separate environments and minimize provider authority

**Level:** required
**Applies when:** A provider exposes credentials, roles, projects, accounts, branches, datasets, domains, or environment-specific configuration.

Separate production from development, test, and preview resources. Use a distinct workload identity or credential per service and environment, grant only required permissions, keep secrets out of source and client bundles, and prevent non-production workloads from reaching production data or mutation authority by default. Prefer short-lived workload identity and provider bindings over broad static keys when supported.

**Why:** Shared credentials and resources turn a low-trust preview or test failure into production data, financial, and availability impact.

**Verify:**

- Exercise positive and negative access from every environment and identity class.
- Inspect built client artifacts, logs, error responses, environment metadata, and secret scans for exposed credentials.
- Demonstrate rotation, revocation, and departed-user removal for representative credentials and roles.

**Exceptions:** Shared read-only test data requires documented necessity, non-sensitive contents, bounded access, and an owner. Production mutation authority in previews requires a qualified security exception.

### INTEGRATIONS-VENDOR-004 — Make callbacks authentic, repeat-safe, and recoverable

**Level:** required
**Applies when:** Receiving webhooks, event destinations, drains, callbacks, or other provider-initiated requests.

Verify authenticity over the raw body using the current provider method before processing. Persist or enqueue accepted events before acknowledging when durable processing matters. Handle duplicates, delay, retry, replay, and out-of-order delivery without duplicating side effects or regressing state. Reconcile from the provider's authoritative API or export after missed-delivery windows and outages.

**Why:** Provider callbacks are asynchronous, retryable, and exposed to spoofing and delivery gaps.

**Verify:**

- Reject missing, invalid, expired, wrong-environment, and wrong-secret signatures.
- Replay the same event, reverse event order, delay delivery, interrupt processing before and after persistence, and recover after the provider retry window.
- Compare derived state with the provider's authoritative object or event history.

**Exceptions:** An unsigned provider callback requires a qualified security decision, compensating authenticated boundary or allowlist, reconciliation, and replacement owner.

### INTEGRATIONS-VENDOR-005 — Bound retries and durable side effects

**Level:** required
**Applies when:** A provider request creates, updates, sends, transfers, bills, refunds, deletes, publishes, or otherwise causes a durable side effect.

Use provider-supported idempotency where available and an application operation key tied to the business action. Persist attempt and result state, distinguish safe retry from reconciliation, and prevent concurrent or delayed workers from repeating the effect. Do not treat a timeout as proof of failure.

**Why:** Network ambiguity and job retries can duplicate money movement, messages, accounts, deployments, or destructive operations.

**Verify:**

- Repeat identical and conflicting requests, inject timeouts before and after provider acceptance, and run concurrent attempts.
- Reconcile local records with provider request IDs, object IDs, events, and final state.

**Exceptions:** A provider operation without idempotency support requires a guarded read-before-write or reconciliation design and an approved residual-risk record.

### INTEGRATIONS-VENDOR-006 — Release the tested artifact with its effective configuration

**Level:** required
**Applies when:** Provider code, infrastructure, environment values, rules, bindings, schemas, domains, or credentials change.

Bind tests to the exact build and effective environment configuration that will receive traffic. Use staged or preview release where supported, define promotion and stop conditions, and verify rollback or compensation including state that a code rollback cannot undo. Rebuild or redeploy when provider configuration changes do not apply to existing artifacts.

**Why:** A tested source revision can behave differently after environment substitution, control-plane changes, migrations, or alias promotion.

**Verify:**

- Record immutable build or deployment identity, configuration version, migration state, provider project, and environment.
- Exercise promotion, rollback, credential failure, provider degradation, and post-release error detection.

**Exceptions:** Immediate incident containment may precede the full release record; preserve the action log and complete final-state verification before closure.

### INTEGRATIONS-VENDOR-007 — Observe outcomes without leaking provider data

**Level:** required
**Applies when:** A provider affects user-visible, financial, security, data, or availability outcomes.

Capture structured operation, latency, outcome, retry, reconciliation, and provider-correlation signals with bounded cardinality. Exclude credentials, raw financial data, full callback payloads, message bodies, and unnecessary personal data. Alert on actionable failure and verify telemetry delivery, authenticity, retention, access, deletion, and outage behavior.

**Why:** Missing telemetry hides dependency failures, while indiscriminate payload logging creates a second sensitive data store.

**Verify:**

- Trace successful, failed, retried, and reconciled operations through logs, metrics, traces, alerts, and support lookup.
- Inspect telemetry at source, drain or export, destination, archive, and deletion path for prohibited fields and gaps.

**Exceptions:** Time-bounded diagnostic capture requires qualified approval, minimized scope, protected storage, expiry, and verified deletion.

### INTEGRATIONS-VENDOR-008 — Resolve guidance conflicts by source role and specificity

**Level:** required
**Applies when:** Provider documentation, an agent skill, an engineering article, a sample, or another standard gives different advice for the same integration decision.

Classify each source before applying it. Current provider documentation is normative for provider behavior. A provider-specific skill may route the review but cannot override current provider documentation. A cross-provider skill cannot override the dedicated provider playbook or provider-specific skill. Provider and third-party engineering articles may explain failure modes and design tradeoffs but cannot be the sole authority for an API shape, default, limit, security control, or release action. Record the conflict, versions or dates, chosen rule, and evidence.

**Why:** Examples and skills are often optimized for a narrow workflow and can lag the provider they invoke.

**Verify:**

- Trace each requirement to at least one current normative source and label informative sources separately.
- Re-run the conflict decision when either source, skill package, SDK, API version, or provider behavior changes.
- Confirm that copied samples do not reintroduce a lower-precedence or deprecated path.

**Exceptions:** None.

### INTEGRATIONS-VENDOR-009 — Inventory deprecated, legacy, adjacent, and negative paths

**Level:** required
**Applies when:** A provider offers more than one API generation, integration mode, runtime, account type, storage product, or release path.

Maintain a zero-gap surface ledger that marks each discovered surface as mapped, adjacent, legacy, or excluded. Name deprecated and unsafe patterns that an audit must detect, including old SDKs, retired products, insecure samples, broad credentials, and control-plane-only configuration. Do not infer safety from the absence of a capability in the local bundle.

**Why:** Audits that describe only the preferred path miss the legacy path most likely to exist in an older system.

**Verify:**

- Compare the ledger with dependencies, imports, routes, infrastructure, environment names, provider settings, and provider deprecation notices.
- Add a failing evaluation fixture for each in-scope legacy or prohibited path that can be detected mechanically.

**Exceptions:** An excluded surface may omit detailed controls when its rationale and evidence prove it cannot be reached.

### INTEGRATIONS-VENDOR-010 — Reconcile cross-system state explicitly

**Level:** required
**Applies when:** Local state and provider state can change in separate transactions.

Define the local source of intent, the provider source of outcome, the operation identity, state transitions, and reconciliation owner. Use an outbox, durable job, or equivalent handoff when a local commit must cause a provider side effect. Treat callbacks as notifications to reconcile, not as the only durable record of provider truth. Prevent stale or out-of-order observations from moving state backward.

**Why:** A database transaction cannot atomically commit with a remote provider request, callback, deployment, or control-plane change.

**Verify:**

- Interrupt execution before and after the local commit, provider acceptance, response receipt, callback persistence, and local projection update.
- Compare local intent, attempts, provider objects, callbacks, and final projections by stable operation and provider identifiers.

**Exceptions:** A read-only integration may omit the outbox but still needs freshness, ownership, and mismatch handling.

### INTEGRATIONS-VENDOR-011 — Test concurrency, reordering, replay, and ambiguous outcomes

**Level:** required
**Applies when:** Provider operations or callbacks can overlap, retry, arrive late, or time out.

Test more than the success path. Cover concurrent identical and conflicting requests, response loss after provider acceptance, duplicate and delayed callbacks, reversed event order, partial batches, retry exhaustion, and recovery after the provider retention or retry window. Assert business invariants and final converged state, not only HTTP status or job completion.

**Why:** Distributed failures occur between observable steps and rarely match a clean request failure.

**Verify:**

- Run deterministic fixtures with controlled clocks, fault injection, and provider sandbox or test-mode evidence where available.
- Prove that retries are bounded, jittered where many workers can synchronize, and stopped or reconciled on permanent errors.

**Exceptions:** None for durable side effects. Low-impact read-only calls may use contract tests plus a documented degraded-state exercise.

### INTEGRATIONS-VENDOR-012 — Detect control-plane and effective-state drift

**Level:** required
**Applies when:** Provider behavior depends on dashboard settings, DNS, domains, roles, environment values, callbacks, rules, branches, aliases, or other state outside the application artifact.

Keep desired configuration in a reviewable record where supported and compare it with effective provider state. Identify which changes require a rebuild, redeploy, migration, propagation wait, or manual publication. Record who can change each control and how emergency changes return to the managed baseline.

**Why:** Source control can be unchanged while the running integration changes materially.

**Verify:**

- Diff desired and effective state for each environment and account boundary.
- Exercise detection of an out-of-band credential, callback, DNS, firewall, domain, branch, or alias change.

**Exceptions:** A provider surface without an API or export requires dated screenshots or an equivalent two-person evidence record until automation exists.

### INTEGRATIONS-VENDOR-013 — Bound quota, cost, egress, and cardinality

**Level:** required
**Applies when:** Provider use is metered, rate limited, regionally multiplied, data-volume sensitive, or able to create unbounded resources or telemetry dimensions.

Model cost and quota by operation, payload size, region, retry, fan-out, cache behavior, retained resource, and telemetry cardinality. Set application budgets, concurrency and batch bounds, pagination, payload limits, and stop conditions before provider hard limits. Attribute usage to a tenant, workflow, deployment, or other accountable unit without exposing sensitive data.

**Why:** A correct integration can still fail through retry storms, cache misses, unbounded reads, regional counters, stale branches, messages, logs, or resource creation.

**Verify:**

- Test representative peak, retry, cache-cold, provider-degraded, and abusive traffic against the cost and quota model.
- Alert before hard limits and prove that shedding, queuing, disabling, or degrading work preserves critical invariants.

**Exceptions:** An unmetered feature still requires resource and abuse bounds when it can affect availability.

### INTEGRATIONS-VENDOR-014 — Exercise provider failure, compromise, and exit

**Level:** required
**Applies when:** A vendor can affect critical function, data, security, compliance, cost, or recovery.

Maintain and exercise response for provider outage and degradation, quota or cost exhaustion, credential compromise, callback failure, account suspension, breaking change, data export, deletion, and replacement or shutdown. Name user, financial, and data effects that switching code or providers cannot reverse.

**Why:** Provider incidents and commercial changes occur outside the application's release cycle and can outlast ordinary retry windows.

**Verify:**

- Run a tabletop or bounded technical exercise for outage, credential rotation, reconciliation, and exit proportional to impact.
- Verify current support contacts, account ownership, status subscriptions, data export, deletion, DNS and domain control, and fallback communication.

**Exceptions:** A replaceable low-impact provider may use a documented shutdown-and-disable exercise instead of a migration rehearsal.

## Guidance

Activate every provider playbook whose platform is present. More than one playbook can apply to the same flow; for example, a Vercel service using Neon, Stripe, and Resend activates all four. The provider playbook supplies product routing, stop conditions, current skill mappings, workflow fixtures, and completion evidence. Cross-cutting standards remain additive.

Use the generic integration bundle contract for machine-readable sources, skill routes, workflows, and evaluation fixtures. A bundle can add capability and semantic maps when provider operations are broad enough to justify them. Passing bundle validation proves structural consistency and freshness only; it does not prove a live system conforms.

## Examples

Non-compliant: A preview deployment shares production payment and database credentials, its callback handler trusts parsed JSON without signature verification, and a passing unit test is reported as production readiness.

Compliant: Preview uses isolated provider resources and credentials. Released handlers reject invalid raw-body signatures, deduplicate and reconcile events, and the audit binds live provider settings and failure exercises to the released artifact.

## Sources

Provider-specific factual sources and freshness schedules are owned by the applicable playbooks and supporting integration bundles. This standard depends on the source and verification rules in `FND-EVIDENCE`, `FND-CHANGE`, `API-CONTRACTS`, `OPERATIONS-RELIABILITY`, `PRIVACY-DATA`, `SECURITY-APPLICATION`, `SECURITY-SECRETS`, and `AGENT-VERIFICATION`.
