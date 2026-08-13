---
id: DATA-DATABASE
title: Database changes
description: Protects correctness, availability, recoverability, and ownership during database changes.
type: standard
status: stable
governance_status: active
owners: [data, engineering]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [database-change, product-feature]
tags: [database, schema, migrations, queries, recovery]
depends_on: [FND-CHANGE, FND-EVIDENCE]
generated: { by: codex/gpt-5, at: "2026-08-13T18:58:53Z" }
sources:
  - id: postgresql-locking
    resource: https://www.postgresql.org/docs/current/explicit-locking.html
    title: PostgreSQL Explicit Locking
    author: organization:postgresql
  - id: postgresql-create-index
    resource: https://www.postgresql.org/docs/current/sql-createindex.html
    title: PostgreSQL CREATE INDEX
    author: organization:postgresql
  - id: postgresql-backup
    resource: https://www.postgresql.org/docs/current/backup.html
    title: PostgreSQL Backup and Restore
    author: organization:postgresql
  - id: mysql-backup-recovery
    resource: https://dev.mysql.com/doc/refman/8.4/en/backup-and-recovery.html
    title: MySQL Backup and Recovery
    author: organization:mysql
---

# Database changes

Database work must preserve correctness, availability, recoverability, and clear ownership throughout schema, data, query, retention, backup, and restore changes. Engine-specific behavior must be verified against the deployed engine and version.

## Rules

### DATA-DATABASE-001 — Encode important invariants at the strongest practical layer

**Level:** required
**Applies when:** The database can enforce an invariant without preventing a legitimate workflow.

Use constraints, types, foreign keys, uniqueness, or transactional checks for invariants whose violation would corrupt meaning. Application validation alone is insufficient when concurrent writers or alternate write paths can bypass it.

**Why:** Checks performed before a write can race, drift between services, or be omitted by jobs and administrative tools.

**Verify:**

- Map each material invariant to its enforcement layer and all write paths.
- Exercise valid, invalid, null, duplicate, and concurrent cases relevant to the invariant.

**Exceptions:** Keep an invariant outside the database only when the engine cannot express it safely or the rule depends on unavailable external state; document the alternate enforcement and reconciliation path.

### DATA-DATABASE-002 — Keep mixed application and schema versions compatible

**Level:** required
**Applies when:** Application instances, workers, jobs, or clients can overlap during deployment.

Use an expand–migrate–contract sequence. Add compatible schema first, migrate reads and writes, backfill and verify data, remove old callers, then contract in a separate controlled step.

**Why:** Deployments are rarely instantaneous; an incompatible migration can break old code before the new version is fully available.

**Verify:**

- Document the version compatibility matrix, deployment order, backfill, and contraction trigger.
- Exercise old and new application behavior against the expanded schema.
- Confirm old instances and scheduled jobs are gone before contraction.

**Exceptions:** A coordinated outage can replace mixed-version operation when downtime is explicitly approved and every writer is stopped and verified.

### DATA-DATABASE-003 — Bound locks and resource consumption

**Level:** required
**Applies when:** A migration, backfill, index build, validation, or query runs against production-sized data.

Estimate or measure lock mode and duration, rows and bytes scanned, transaction duration, memory, temporary space, write-ahead or transaction log growth, replication lag, and downstream load. Batch, throttle, or use an online operation when one operation can exceed the system's safe budget.

**Why:** A logically correct operation can still block production traffic, exhaust storage, or overwhelm replicas.

**Verify:**

- Inspect the engine-specific execution and lock behavior for the deployed version.
- Run against representative volume and data distribution or explain the scaling model.
- Record abort thresholds and the mechanism that enforces them.

**Exceptions:** Small, isolated datasets can use bounded estimates when their maximum size is proven.

### DATA-DATABASE-004 — Prove access-path changes with representative plans

**Level:** required
**Applies when:** Adding or removing an index, rewriting a query for performance, or changing access patterns.

Compare query plans and timings using representative parameters, cardinality, distribution, concurrency, and cache conditions. Account for write amplification, storage, maintenance, and selectivity.

**Why:** A plan that is faster for one parameter or warm cache can regress common or worst-case production workloads.

**Verify:**

- Preserve before-and-after plans with actual row counts and relevant timings where safe.
- Check common, sparse, dense, and pathological parameter values.
- Measure or estimate the added write and storage cost.

**Exceptions:** Emergency mitigation can use partial evidence when scope is bounded and follow-up validation has an owner and deadline.

### DATA-DATABASE-005 — Define recovery for destructive or semantic changes

**Level:** required
**Applies when:** Data is deleted, transformed, merged, re-keyed, deduplicated, or reinterpreted.

Specify whether recovery uses rollback, backup restore, shadow data, event replay, compensation, or a corrective migration. Define the last reversible point and what cannot be restored automatically.

**Why:** Reverting code does not reverse data already changed or side effects already sent elsewhere.

**Verify:**

- Exercise recovery with representative data and verify counts, relationships, and business meaning afterward.
- Confirm recovery artifacts remain available for the required period.

**Exceptions:** Irreversible work requires explicit approval from the data owner and a documented containment plan.

### DATA-DATABASE-006 — Prove restore readiness separately from backup success

**Level:** required
**Applies when:** The system owns durable or business-critical data.

Define recovery point and recovery time objectives, monitor backup completion and retention, and conduct restore exercises that verify usable data and dependent service recovery.

**Why:** A completed backup job can still produce incomplete, corrupt, inaccessible, or too-slow recovery material.

**Verify:**

- Restore into an isolated environment and run integrity and application-level checks.
- Record achieved recovery point, elapsed recovery time, missing dependencies, and owner.

**Exceptions:** None for production systems with durable user or business data.

### DATA-DATABASE-007 — Bound every growing access path

**Level:** avoid
**Applies when:** Query result size or work can grow with tenant or global data volume.

Avoid unbounded reads, writes, cascades, scans, and offset pagination on large changing datasets. Use explicit limits, stable ordering, cursor-based continuation, partitions, or bounded batches.

**Why:** Work that scales with total history eventually exceeds request, lock, memory, or maintenance budgets.

**Verify:**

- Identify the maximum work per request, transaction, or batch.
- Exercise continuation and retry behavior while rows are inserted, updated, or deleted.

**Exceptions:** An offline operation can be unbounded only within a measured maintenance budget and with a safe interruption path.

### DATA-DATABASE-008 — Make backfills resumable and observable

**Level:** required
**Applies when:** Updating existing rows or rebuilding derived state outside one small transaction.

Use deterministic selection, idempotent or checkpointed batches, bounded transactions, progress measurement, error capture, and a safe restart procedure. Prevent the backfill from overwriting newer valid writes.

**Why:** Long-running work will be interrupted and may race with live traffic.

**Verify:**

- Stop and restart the backfill without duplicates, omissions, or regression of newer values.
- Reconcile eligible, processed, skipped, failed, and remaining records.

**Exceptions:** A single atomic transaction is acceptable when production-scale evidence shows it stays inside the lock and resource budget.

### DATA-DATABASE-009 — Verify data meaning after migration

**Level:** required
**Applies when:** A change transforms, maps, aggregates, or reclassifies data.

Validate business invariants and representative records, not only row counts. Define treatment of nulls, duplicates, invalid legacy values, time zones, rounding, and partial failures.

**Why:** A migration can preserve the number of rows while changing their meaning incorrectly.

**Verify:**

- Compare source and destination aggregates, invariants, and sampled records.
- Account explicitly for every rejected, defaulted, merged, or unmatched record.

**Exceptions:** None for semantic changes.

### DATA-DATABASE-010 — Assign lifecycle ownership

**Level:** required
**Applies when:** A change creates temporary columns, dual writes, compatibility code, shadow tables, indexes, or deferred cleanup.

Assign an owner, completion condition, and due date for each temporary state. Monitor it until contraction or intentional adoption is complete.

**Why:** Temporary compatibility structures become permanent complexity and cost when no one owns removal.

**Verify:**

- Inspect the change record for named follow-up work and acceptance criteria.
- Confirm cleanup occurs only after dependent readers, writers, jobs, and recovery windows no longer need the old state.

**Exceptions:** A temporary structure can become permanent through an explicit design decision that updates its ownership and documentation.

### DATA-DATABASE-011 — Preserve transactional and concurrency semantics

**Level:** required
**Applies when:** A change modifies read-modify-write behavior, transaction boundaries, isolation, retries, deduplication, ordering, or concurrent access to shared records.

Define the required atomicity, isolation, ordering, and conflict behavior. Handle retries and concurrent writers without lost updates, duplicate side effects, write skew, or reliance on timing that the database does not guarantee.

**Why:** Behavior that is correct in a single session can corrupt state when transactions overlap, retry, or observe different snapshots.

**Verify:**

- Exercise concurrent success, conflict, retry, timeout, and partial-failure cases against the deployed engine and isolation level.
- Inspect locks, constraints, compare-and-set conditions, idempotency keys, or serialization mechanisms that enforce the intended outcome.
- Confirm external side effects do not occur inside a retryable transaction without deduplication or compensation.

**Exceptions:** Truly immutable or single-writer data can use simpler controls when the single-writer boundary is enforced and documented.

### DATA-DATABASE-012 — Use least privilege for database changes

**Level:** required
**Applies when:** An application, migration, backfill, operator, or automation receives database credentials or elevated rights.

Grant only the operations, objects, environments, and duration required. Separate routine application access from schema administration and recovery access, and record use of elevated or emergency credentials.

**Why:** Broad, long-lived database privileges increase the effect of application compromise, operator error, and unintended migration behavior.

**Verify:**

- Inspect effective privileges for application, migration, read-only, backup, and recovery identities.
- Attempt an out-of-scope operation and confirm it is denied.
- Confirm temporary privileges and credentials expire or are revoked after the change.

**Exceptions:** An engine or managed service can require a broader built-in role; document the unavailable granularity and add compensating approval, network, or audit controls.

## Guidance

Treat migrations as distributed-system changes, even when they are expressed as one SQL file. Application versions, workers, replicas, caches, and external consumers can observe different states at different times.

Prefer small, restartable transitions. Avoid combining a blocking schema operation, a large backfill, and destructive cleanup in one release. Set short lock timeouts where supported so a migration fails safely instead of waiting behind production traffic and then blocking it.

Use the database engine's own documentation for lock modes, transactional behavior, online index operations, constraint validation, replication, and backup semantics. Similar syntax across engines does not imply similar operational behavior.

After a large backfill or material distribution change, evaluate whether engine statistics, maintenance, replicas, caches, and downstream extracts need refresh or verification. Do not assume the query planner immediately understands the new distribution.

## Examples

### Required column

Non-compliant: Add a non-null column with a computed default, update all rows, and deploy code that requires the column in one production step.

Compliant: Add the compatible nullable column, deploy dual-compatible code, backfill in resumable batches, validate missing values, add the constraint using the engine's safe path, switch reads, then remove compatibility code later.

### Backfill checkpoint

Non-compliant: “Update every account where `status` is null” in one retryable job with no stable order.

Compliant: Process stable primary-key ranges, commit each bounded batch, record the high-water mark and failures, and update only rows that still meet the original predicate.

## Change evidence

A production database change must identify affected invariants, compatibility stages, representative lock and performance evidence, monitoring, stop conditions, recovery, semantic reconciliation, and ownership of deferred contraction.

## Sources

- PostgreSQL Global Development Group, [Explicit Locking](https://www.postgresql.org/docs/current/explicit-locking.html), PostgreSQL documentation. Reviewed August 13, 2026.
- PostgreSQL Global Development Group, [CREATE INDEX](https://www.postgresql.org/docs/current/sql-createindex.html), PostgreSQL documentation. Reviewed August 13, 2026.
- PostgreSQL Global Development Group, [Backup and Restore](https://www.postgresql.org/docs/current/backup.html), PostgreSQL documentation. Reviewed August 13, 2026.
- Oracle, [MySQL Backup and Recovery](https://dev.mysql.com/doc/refman/8.4/en/backup-and-recovery.html), MySQL 8.4 Reference Manual. Reviewed August 13, 2026.
