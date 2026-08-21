---
id: DATA-REDIS
title: Redis design and operation
description: Requirements for safe Redis workload design, memory control, client behavior, availability, recovery, and messaging semantics.
type: standard
status: draft
governance_status: draft
owners: [data, engineering, operations, security]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [redis-change, redis-operation, cache-change, session-store-change, redis-stream-change]
tags: [redis, cache, database, reliability, security, messaging]
depends_on: [FND-CHANGE, FND-EVIDENCE, OPERATIONS-RELIABILITY, SECURITY-APPLICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:27:22Z" }
sources:
  - id: redis-memory-optimization
    resource: https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/
    title: Memory optimization
    author: organization:redis
  - id: redis-key-eviction
    resource: https://redis.io/docs/latest/develop/reference/eviction/
    title: Key eviction
    author: organization:redis
  - id: redis-keyspace
    resource: https://redis.io/docs/latest/develop/use/keyspace/
    title: Keys and values
    author: organization:redis
  - id: redis-cache-aside
    resource: https://redis.io/docs/latest/develop/use-cases/cache-aside/
    title: Redis cache-aside
    author: organization:redis
  - id: redis-client-connections
    resource: https://redis.io/docs/latest/develop/clients/pools-and-muxing/
    title: Connection pools and multiplexing
    author: organization:redis
  - id: redis-client-errors
    resource: https://redis.io/docs/latest/develop/clients/error-handling/
    title: Error handling
    author: organization:redis
  - id: redis-pipelining
    resource: https://redis.io/docs/latest/develop/using-commands/pipelining/
    title: Redis pipelining
    author: organization:redis
  - id: redis-transactions
    resource: https://redis.io/docs/latest/develop/using-commands/transactions/
    title: Transactions
    author: organization:redis
  - id: redis-cluster-scaling
    resource: https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/
    title: Scale with Redis Cluster
    author: organization:redis
  - id: redis-replication
    resource: https://redis.io/docs/latest/operate/oss_and_stack/management/replication/
    title: Redis replication
    author: organization:redis
  - id: redis-persistence
    resource: https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/
    title: Redis persistence
    author: organization:redis
  - id: redis-security-practices
    resource: https://redis.io/docs/latest/operate/rs/security/recommended-security-practices/
    title: Recommended security practices
    author: organization:redis
  - id: redis-observability
    resource: https://redis.io/docs/latest/operate/rs/monitoring/observability/
    title: Redis Software observability and monitoring guidance
    author: organization:redis
  - id: redis-pubsub
    resource: https://redis.io/docs/latest/develop/pubsub/
    title: Redis Pub/Sub
    author: organization:redis
  - id: redis-streams
    resource: https://redis.io/docs/latest/develop/data-types/streams/
    title: Redis Streams
    author: organization:redis
  - id: redis-distributed-locks
    resource: https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/
    title: Distributed locks with Redis
    author: organization:redis
---

# Redis design and operation

Redis workloads must have explicit data-loss, staleness, eviction, availability, and recovery behavior. Configuration and client behavior must preserve those decisions when Redis is healthy, slow, full, partitioned, failed over, or recovering.

This standard adds Redis-specific requirements to the general database, security, reliability, evidence, and safe-change standards. Verify vendor behavior against the deployed Redis product, version, topology, and client library because Redis Open Source, Redis Software, Redis Cloud, and compatible services can differ.

## Rules

### DATA-REDIS-001 — Classify each workload and its failure contract

**Level:** required  
**Applies when:** Redis stores or transports application data.

Record whether each workload is a rebuildable cache, session store, rate limiter, coordination mechanism, message transport, derived store, or authoritative store. Define its source of truth, permitted staleness and data loss, eviction behavior, behavior when Redis is slow or unavailable, and recovery owner.

Do not share one Redis eviction and persistence boundary between workloads whose recorded contracts conflict.

**Why:** A cache can discard data and fall back to a source, while sessions, queues, or authoritative data may require rejection, persistence, or recovery. An implicit contract turns capacity and failover events into uncontrolled data loss or dependency overload.

**Verify:**

- Trace representative reads, writes, expiry, eviction, unavailability, failover, and recovery for every workload class.
- Compare each workload contract with the effective Redis topology, persistence, eviction, and application fallback configuration.
- Confirm shared deployments contain only workloads with compatible contracts or enforce separate resource and policy boundaries.

**Exceptions:** A temporary shared deployment requires a recorded owner, expiry date, capacity bound, isolation analysis, and tested separation or shutdown plan.

### DATA-REDIS-002 — Bound memory and choose eviction deliberately

**Level:** required  
**Applies when:** Redis runs outside a disposable local environment.

Set an explicit memory limit and an eviction policy that matches `DATA-REDIS-001`. Size the host and limit using representative key footprints and peak behavior, including allocator fragmentation, client and replication buffers, persistence work, modules, and copy-on-write growth outside the logical dataset.

Use `noeviction` when silent removal is not permitted. When eviction is permitted, prove that every evictable key can be reconstructed and that the selected policy preserves the expected working set under representative access skew.

**Why:** Redis can exhaust host memory without a limit, while a poorly selected eviction policy can remove state the application treats as durable or leave non-expiring keys outside the eligible eviction set.

**Verify:**

- Inspect effective memory, eviction, persistence, and reserved-memory configuration rather than only deployment templates.
- Measure representative key size, dataset growth, resident memory, fragmentation, buffer use, and copy-on-write growth under peak reads and writes.
- Drive the deployment to its warning and limit thresholds and verify eviction or write-rejection behavior, application response, alerts, and recovery.

**Exceptions:** A short-lived isolated test can use a host-enforced memory boundary when its destruction and non-production network boundary are automatic.

### DATA-REDIS-003 — Bound keys, values, collections, and slot concentration

**Level:** required  
**Applies when:** A Redis data model is created or materially changed.

Define a stable key schema, ownership, maximum value size, maximum collection cardinality, retention or expiry, and maximum work for every access path. Select data types from required operations and command complexity. In Redis Cluster, use hash tags only for recorded same-slot operations and prove they do not create unacceptable hot-slot concentration.

**Why:** Large values, unbounded collections, global scans, and concentrated hash slots can block command processing, increase replication and recovery cost, and prevent horizontal scaling.

**Verify:**

- Exercise common and maximum-size values and collections with the deployed command paths.
- Inspect key-size, cardinality, hot-key, and cluster-slot distributions using bounded production-safe sampling or representative load data.
- Confirm multi-key commands, transactions, pipelines, and scripts behave correctly in the deployed cluster topology.

**Exceptions:** An offline administrative operation may exceed an online bound only within an approved maintenance budget, with interruption and recovery steps.

### DATA-REDIS-004 — Make expiration and cache invalidation correct under concurrency

**Level:** required  
**Applies when:** Data expires, is cached from another source, or is invalidated after a source write.

Create a cache value and its expiry atomically. Define the maximum stale interval, invalidation order, miss behavior, negative-cache policy, and protection against concurrent regeneration. Exercise races between a cache miss, source read, source commit, invalidation, refill, expiry, and retry.

**Why:** Separate value and expiry writes can create persistent keys. Cache-aside races and synchronized hot-key expiry can serve stale data or overload the source system precisely when the cache is degraded.

**Verify:**

- Inspect write paths for an atomic TTL-bearing write or an equivalent atomic operation.
- Run concurrent read/write tests that cover refill after invalidation, delayed readers, repeated misses, and source failure.
- Expire or flush a representative hot working set under load and confirm source concurrency limits, request coalescing, degradation, and recovery.

**Exceptions:** Data may be intentionally persistent when its lifecycle owner, deletion path, capacity bound, and correctness semantics are recorded.

### DATA-REDIS-005 — Bound connections, deadlines, and retries

**Level:** required  
**Applies when:** An application or job connects to Redis.

Use a maintained client compatible with the deployed topology. Configure bounded connection reuse, connection establishment, command execution, pool acquisition, and retry behavior within the caller's latency and retry budgets. Classify retried operations by idempotency and handle an interrupted response as an unknown outcome when the command may have executed.

Use dedicated connections where Pub/Sub, blocking commands, or client behavior can stall or change the protocol mode of a shared connection.

**Why:** Unbounded waits consume caller capacity, reconnect storms amplify an outage, and blind retries of mutations such as increments or appends can duplicate effects.

**Verify:**

- Inspect effective client timeouts, pool or multiplexer limits, topology handling, backoff, jitter, retry count, and circuit or load-shedding behavior.
- Interrupt connections before, during, and after representative reads and mutations; verify returned errors, duplicates, reconciliation, and total elapsed time.
- Exercise failover and resharding through the supported client, including relevant redirect and topology-refresh behavior.

**Exceptions:** A one-shot administrative client can omit pooling but must retain bounded deadlines and operation-specific retry behavior.

### DATA-REDIS-006 — Keep online command work bounded

**Level:** prohibited  
**Applies when:** A command runs against a production Redis deployment.

Do not use `KEYS`, an unbounded collection read or mutation, an unbounded pipeline, or a long-running script on an online production path.

Use cursor scans for operational key iteration, bounded command variants and batches, and short server-side scripts whose maximum work is established from input and collection bounds. A transaction or script supplies atomic execution, not rollback of arbitrary completed effects.

**Why:** Redis command execution and atomic scripts can block unrelated clients. Large pipelines also retain queued replies in server memory.

**Verify:**

- Inspect application commands, scripts, operational procedures, ACL command restrictions, slow logs, and latency events.
- Exercise maximum-size inputs and record command execution time, queued response memory, interruption behavior, and effect on unrelated requests.
- Confirm production-safe replacements exist for key discovery and large collection processing.

**Exceptions:** None for an online production path. An isolated restored copy may run offline analysis when it cannot affect production resources.

### DATA-REDIS-007 — Restrict Redis network and command authority

**Level:** required  
**Applies when:** Redis contains non-public data or supports a non-local environment.

Keep Redis off the public internet, restrict network paths to approved clients and operators, encrypt traffic across untrusted or policy-required boundaries, and authenticate clients with separate least-privilege identities. Disable unauthenticated default access and deny administrative, destructive, debugging, and key-discovery commands to application identities unless the workload requires a reviewed subset.

**Why:** Redis exposes direct data and administrative operations. One shared broad credential expands the effect of application compromise, operator error, and credential leakage.

**Verify:**

- Test network denial from an unauthorized source and authenticated access from each approved client path.
- Inspect effective ACLs and attempt representative out-of-scope commands with application, migration, monitoring, backup, and operator identities.
- Exercise certificate and credential rotation without relying on undocumented access or exposing secret material in evidence.

**Exceptions:** Plaintext loopback or equivalently isolated local communication may be accepted when the boundary is enforced and documented. Public unauthenticated access is prohibited.

### DATA-REDIS-008 — Match persistence and failover to acknowledged data-loss bounds

**Level:** required  
**Applies when:** Loss of acknowledged Redis writes has a material effect.

Define the recovery point, recovery time, availability, and consistency requirements, then select persistence, replication, replica placement, write-admission, and acknowledgment behavior that meets them. Record that asynchronous replication, Sentinel, Redis Cluster, and `WAIT` do not by themselves provide strong consistency or guarantee retention of every acknowledged write.

**Why:** Automatic failover can improve availability while still losing recent acknowledged writes. A topology diagram or successful replica health check does not prove the application's required durability.

**Verify:**

- Inspect effective RDB, AOF, fsync, replication, replica-placement, minimum-replica, and client acknowledgment configuration.
- Kill or isolate a primary during controlled writes and reconcile acknowledged, durable, replicated, lost, duplicated, and rejected operations.
- Measure failover, client recovery, replica lag, and return-to-normal against the recorded objectives.

**Exceptions:** A rebuildable cache may accept total Redis data loss when source protection and refill behavior pass `DATA-REDIS-004` and `DATA-REDIS-011`.

### DATA-REDIS-009 — Prove restore and reconstruction separately from replication

**Level:** required  
**Applies when:** Redis data or stream state cannot be safely regenerated inside the recovery objective.

Maintain protected recovery material independent of the active replication path and exercise restoration into an isolated environment. Verify application meaning, expirations, scripts or functions, stream and consumer-group state, credentials, dependencies, and client reconnection after restore.

**Why:** Replication can copy accidental deletion or corrupt application writes. A completed backup does not prove that the service can recover usable state within its objective.

**Verify:**

- Restore a selected recovery point without depending on the failed deployment.
- Reconcile key counts and representative business invariants, pending work, retained history, expirations, and application behavior.
- Record achieved recovery point and time, missing state, manual work, and the owner of each unresolved gap.

**Exceptions:** A rebuildable workload may use a tested reconstruction procedure instead of backup when the source, capacity, ordering, and completion reconciliation are proven.

### DATA-REDIS-010 — Observe Redis and caller outcomes

**Level:** required  
**Applies when:** Redis supports production traffic or business processing.

Monitor caller-visible latency and errors together with Redis command latency, memory and resident memory, fragmentation, CPU, network, connections and buffers, hit and miss rate where applicable, evictions, expirations, rejected writes, persistence health, replication state, hot keys, large keys, and slow commands. For streams, also monitor lag, pending work, idle consumers, redelivery, and retention.

Alerts must connect a threshold or trend to the workload contract, an owned response, and a tested runbook.

**Why:** Redis can report fast commands while callers wait for a connection or miss the cache and overload another system. Aggregate health can also hide one hot key, shard, tenant, or consumer.

**Verify:**

- Trigger representative latency, memory, eviction or rejection, connection, replication, persistence, hot-key, and consumer-lag conditions.
- Trace each condition through metrics, logs, alerts, ownership, diagnosis, containment, and recovery.
- Confirm telemetry does not expose credentials, sensitive values, or unrestricted key contents.

**Exceptions:** A low-impact internal deployment may use a reduced signal set when every omitted failure is outside its recorded contract and the rationale is approved by the service owner.

### DATA-REDIS-011 — Exercise dependency failure and refill behavior

**Level:** required  
**Applies when:** Redis is on a production request or processing path.

Exercise Redis unavailable, slow, full, partitioned, failed over, flushed or restored, and recovering under representative traffic. Bound fallback traffic, concurrency, queues, retries, and refill rate so Redis failure does not cause a wider dependency collapse.

**Why:** A cache fallback that works for one request can overwhelm the source database when the whole working set misses. Recovery can cause a second overload as clients reconnect and refill together.

**Verify:**

- Record application correctness, latency, throughput, dependency load, rejected work, user-visible behavior, and recovery time for each applicable condition.
- Confirm circuit breakers, request coalescing, admission control, backpressure, or intentional failure behavior activates within the recorded bounds.
- Exercise a cold start and full refill at the largest supported scale or with a justified capacity model.

**Exceptions:** None for a critical production workload; an unexercised path remains unresolved risk under `OPERATIONS-RELIABILITY-006`.

### DATA-REDIS-012 — Choose messaging semantics explicitly

**Level:** required  
**Applies when:** Redis Pub/Sub, Streams, or list operations transport events or work.

Use Pub/Sub only when permanent loss during disconnect is acceptable or a separate durable source supports reconciliation. For Streams or other redeliverable work, define acknowledgment, idempotent processing, pending-entry recovery, poison-message handling, ordering scope, retention, trimming, and backpressure.

**Why:** Redis Pub/Sub is at-most-once. Streams support retained and redelivered work, but a consumer can perform a side effect and fail before acknowledgment, causing duplicate processing.

**Verify:**

- Disconnect subscribers and consumers, crash a consumer before and after its side effect and acknowledgment, and exercise duplicate and out-of-order delivery.
- Inspect retention and trimming against the slowest supported consumer and recovery window.
- Reconcile produced, delivered, acknowledged, retried, dead-lettered, expired or trimmed, and remaining work.

**Exceptions:** Disposable presence, live-view, or invalidation notifications may use Pub/Sub when loss and reconnect reconciliation are documented and tested.

### DATA-REDIS-013 — Treat distributed locks as expiring leases

**Level:** contextual  
**Applies when:** Redis coordinates exclusive work or protects an external resource.

Acquire a lock atomically with a unique ownership token and finite lifetime, release it only when the token still matches, and bound acquisition and renewal. When an expired or partitioned holder could still modify the protected resource, enforce a fencing token or a stronger authority at that resource.

Do not use a Redis lease as the sole correctness control when duplicate or concurrent execution can cause unrecoverable financial, security, integrity, or safety harm.

**Why:** A process can pause beyond its lease, clocks can shift, and failover can lose lock state. Process liveness does not prove continued ownership.

**Verify:**

- Pause a holder past expiry, partition it from Redis, permit another holder to acquire, then resume the first holder and confirm stale work is rejected or harmless.
- Exercise token mismatch, renewal failure, failover, retry, and cleanup.
- Inspect the protected resource for fencing, uniqueness, idempotency, or another enforcement mechanism proportionate to impact.

**Exceptions:** A lock may coordinate harmless duplicate work without fencing when duplicate execution is detected, bounded, and recoverable.

## Guidance

Prefer the simplest topology that satisfies the recorded workload contract. A standalone node, Sentinel deployment, Redis Cluster, and managed Redis service solve different availability and scaling problems; none removes the need to define application behavior during ambiguous results and failover.

Set measurable limits from representative evidence rather than copying universal key-size, pool-size, memory-headroom, or timeout numbers. Treat managed-service defaults as inputs to review, not proof that the workload contract is met.

Use client-side caching only for frequently read and infrequently changed data. Flush local cached state when the invalidation connection is lost, and measure invalidation traffic and local memory.

## Examples

### Cache and sessions sharing one eviction boundary

Non-compliant: API response cache keys and login sessions share an `allkeys-lru` instance. The team has not defined whether session eviction is acceptable, and a cache fill can log out users.

Compliant: The cache and session contracts are recorded. They use separate policy and capacity boundaries, or the session design proves that every session has the required expiry, eviction behavior, persistence, fallback, and recovery.

### Cache-aside invalidation

Non-compliant: A writer updates the source and assumes a five-minute TTL makes all races harmless. A delayed reader can refill an invalidated key with an older version.

Compliant: The source commit precedes invalidation, the maximum stale interval is accepted, concurrent miss loading is bounded, and a version check, versioned key, or equivalent mechanism prevents a delayed old read from replacing newer cache state where the risk requires it.

### Stream consumer crash

Non-compliant: A consumer charges an account and then crashes before `XACK`; the redelivered entry charges the account again.

Compliant: The charge uses the stream entry's stable idempotency key at the payment authority. The consumer acknowledges only after the authority records the outcome, and pending, repeated, and poison entries have recovery and reconciliation paths.

## Sources

- Redis, [Memory optimization](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/) and [Key eviction](https://redis.io/docs/latest/develop/reference/eviction/). Reviewed August 17, 2026.
- Redis, [Keys and values](https://redis.io/docs/latest/develop/use/keyspace/), [Redis cache-aside](https://redis.io/docs/latest/develop/use-cases/cache-aside/), and [Scale with Redis Cluster](https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/). Reviewed August 17, 2026.
- Redis, [Connection pools and multiplexing](https://redis.io/docs/latest/develop/clients/pools-and-muxing/), [Error handling](https://redis.io/docs/latest/develop/clients/error-handling/), [Redis pipelining](https://redis.io/docs/latest/develop/using-commands/pipelining/), and [Transactions](https://redis.io/docs/latest/develop/using-commands/transactions/). Reviewed August 17, 2026.
- Redis, [Redis replication](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/) and [Redis persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/). Reviewed August 17, 2026.
- Redis, [Recommended security practices](https://redis.io/docs/latest/operate/rs/security/recommended-security-practices/) and [Redis Software observability and monitoring guidance](https://redis.io/docs/latest/operate/rs/monitoring/observability/). Reviewed August 17, 2026.
- Redis, [Redis Pub/Sub](https://redis.io/docs/latest/develop/pubsub/), [Redis Streams](https://redis.io/docs/latest/develop/data-types/streams/), and [Distributed locks with Redis](https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/). Reviewed August 17, 2026.
