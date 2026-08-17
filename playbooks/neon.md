---
id: PLAYBOOK-NEON
title: Neon Postgres integration review
description: Provider-specific procedure for Neon connection methods, pooling, branches, network access, migrations, monitoring, and restore.
type: playbook
status: draft
governance_status: draft
release_target: post-v1
owners: [data, database, engineering, security, privacy, operations]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [neon-integration, postgres, database-change, preview-database]
tags: [playbook, neon, postgres, pooling, branching, restore]
depends_on: [INTEGRATIONS-VENDOR, DATA-DATABASE, DATA-QUALITY, FND-CHANGE, OPERATIONS-RELIABILITY, PRIVACY-DATA, SECURITY-APPLICATION, SECURITY-SECRETS, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:28:10Z" }
sources:
  - id: neon-connection-methods
    resource: https://neon.com/docs/connect/connect-from-any-app
    title: Connect applications to Neon
    author: organization:neon
  - id: neon-pooling
    resource: https://neon.com/docs/connect/connection-pooling
    title: Neon connection pooling
    author: organization:neon
  - id: neon-serverless
    resource: https://neon.com/docs/serverless/serverless-driver
    title: Neon serverless driver
    author: organization:neon
  - id: neon-branching
    resource: https://neon.com/docs/introduction/branching
    title: Neon branching
    author: organization:neon
  - id: neon-restore
    resource: https://neon.com/docs/introduction/branch-restore
    title: Neon instant restore
    author: organization:neon
  - id: neon-ip-allow
    resource: https://neon.com/docs/introduction/ip-allow
    title: Neon IP allow
    author: organization:neon
---

# Neon Postgres integration review

Use this playbook when Neon hosts Postgres or when Neon branches, APIs, authentication, or data interfaces are part of a change.

## Agent review route

Load `neon-postgres:neon-postgres` when available and add `neon-postgres:neon-postgres-egress-optimizer` when query volume, response shape, network transfer, or database cost is in scope. Record installed package versions. Follow each route to current Neon documentation for the selected connection method and feature. Do not rely on remembered plan limits, suspend behavior, or API shapes.

Load `integrations/neon/manifest.yaml`, classify every in-scope surface through `sources.yaml`, select the exact capabilities, execute the matching workflows, and run every applicable evaluation. An unclassified Neon surface is a stop condition or recorded library gap.

## Procedure

1. **Inventory data and resources.** Record organization, project, branches, endpoints, databases, roles, regions, protected branches, data classes, retention, restore window, owners, billing, and support route.
2. **Choose the connection contract.** Select HTTP, WebSocket, pooled, or direct TCP for runtime and transaction needs. Use pooled connections for bursty serverless workloads unless an operation needs a direct session. Keep migrations and administrative work on an explicitly authorized route.
3. **Bound connection lifecycle.** Keep request-bounded clients within the request where the runtime cannot preserve sockets, close clients, cap application concurrency and deadlines, and measure client and server pool waits rather than treating the advertised client ceiling as database throughput.
4. **Separate branches and credentials.** Give production, preview, development, migrations, and reporting distinct roles and connection strings. Prevent previews from reaching the production branch. Expire preview branches and apply non-production personal-data controls to copied data.
5. **Protect network and privilege.** Use least-privilege Postgres roles, protected branches, and approved network restrictions where compatible with workload egress. Exercise credential rotation and emergency revocation.
6. **Apply database-change controls.** Test schema and data changes on a representative branch, preserve expansion and contraction compatibility, inspect locks and query plans, and bind migrations to the application release and recovery plan.
7. **Observe capacity and failure.** Monitor connections, pool waits, compute state, working set, storage, query latency, errors, and cost. Exercise cold start or scale behavior, connection exhaustion, long transactions, provider degradation, and branch cleanup.
8. **Bound transfer and read scaling.** Measure high-row, wide-row, frequent, and application-aggregated queries. Select needed columns, require bounded pagination, avoid wide parent duplication, and push safe aggregation into Postgres. Route read replicas deliberately, account for replica freshness, and compare network transfer and response shape before and after a change.
9. **Exercise restore.** Restore to an isolated branch, reconcile invariants and application behavior, record recovery time and retained history, and remove exercise resources. Do not treat branch creation alone as recovery proof.

## Stop conditions

- A preview or development deployment can reach production data or credentials without an approved exception.
- The selected connection method conflicts with transaction, session, runtime, or migration behavior.
- Connection concurrency, timeouts, and pool waits have not been measured under representative load.
- Restore has not been exercised against the retained data and application invariants.

## Completion evidence

- Project, branch, endpoint, database, role, data, retention, and owner inventory plus skill/version or gap and dated official-source review.
- Connection-method decision, concurrency and pool evidence, environment and privilege negatives, branch expiry and cleanup.
- Migration, query, monitoring, failure, restore, reconciliation, recovery-time, and exit evidence.
- Passing Neon integration bundle validation and no unresolved evaluation fixture.

## Sources

- Neon, [Connect applications to Neon](https://neon.com/docs/connect/connect-from-any-app). Reviewed August 17, 2026.
- Neon, [Connection pooling](https://neon.com/docs/connect/connection-pooling). Reviewed August 17, 2026.
- Neon, [Serverless driver](https://neon.com/docs/serverless/serverless-driver). Reviewed August 17, 2026.
- Neon, [Branching](https://neon.com/docs/introduction/branching). Reviewed August 17, 2026.
- Neon, [Instant restore](https://neon.com/docs/introduction/branch-restore). Reviewed August 17, 2026.
- Neon, [IP Allow](https://neon.com/docs/introduction/ip-allow). Reviewed August 17, 2026.
