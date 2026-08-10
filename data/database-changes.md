---
id: DATA-DATABASE
title: Database changes
type: standard
status: active
owners: [data, engineering]
last_reviewed: 2026-08-10
review_by: 2027-02-10
applies_to: [database-change, product-feature]
tags: [database, schema, migrations, queries, recovery]
depends_on: [FND-CHANGE, FND-EVIDENCE]
---

# Database changes

Database work must preserve correctness, availability, recoverability, and understandable ownership throughout its lifecycle.

## Rules

### DATA-DATABASE-001 — Encode important invariants at the strongest practical layer

**Level:** required  
**Applies when:** The database can enforce an invariant without preventing a legitimate workflow.

Use constraints, types, foreign keys, uniqueness, or transactional checks for invariants whose violation would corrupt meaning. Application validation alone is not sufficient for concurrent writers.

**Verify:** The schema and write paths demonstrate where each material invariant is enforced.

### DATA-DATABASE-002 — Make production migrations safe during mixed-version operation

**Level:** required  
**Applies when:** Application and schema versions can overlap during deployment.

Use an expand–migrate–contract sequence. New schema must tolerate the old application until all old instances and jobs are gone; destructive contraction happens separately.

**Verify:** Migration order, compatibility window, backfill, and contraction trigger are documented and tested.

### DATA-DATABASE-003 — Bound locks and resource consumption

**Level:** required  
**Applies when:** A migration, backfill, index build, or query runs against production-sized data.

Estimate or measure lock behavior, scan volume, transaction duration, log growth, and replication impact. Batch or use online operations when a single operation can exceed the system's safe budget.

### DATA-DATABASE-004 — Prove performance changes with representative plans

**Level:** required  
**Applies when:** Adding an index, rewriting a query for performance, or changing access patterns.

Compare query plans and relevant timings using representative data and parameters. Account for write cost, storage, cache behavior, and selectivity; an index is not free.

### DATA-DATABASE-005 — Define recovery for destructive or semantic changes

**Level:** required  
**Applies when:** Data is deleted, transformed, merged, re-keyed, or reinterpreted.

Specify whether recovery uses rollback, backup restore, shadow data, replay, or a corrective migration. Test the recovery path in proportion to the risk.

### DATA-DATABASE-006 — Treat backup success and restore readiness separately

**Level:** required  
**Applies when:** The system owns durable or business-critical data.

Define recovery point and recovery time objectives, monitor backup completion, and conduct restore tests. A successful backup job alone does not prove recoverability.

### DATA-DATABASE-007 — Avoid unbounded access paths

**Level:** avoid  
**Applies when:** Query result size or work can grow with tenant or global data volume.

Avoid unbounded reads, writes, cascades, and offset pagination on large changing datasets. Add explicit limits, stable ordering, cursor-based continuation, or bounded batches.

## Change evidence

A production database change should include the forward migration, compatibility analysis, representative performance evidence, monitoring plan, recovery plan, and owner for any deferred contraction.

