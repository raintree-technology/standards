---
id: PLAYBOOK-CLOUDFLARE
title: Cloudflare platform and Workers review
description: Provider-specific procedure for Cloudflare product selection, Workers configuration, bindings, secrets, streaming, lifecycle, testing, and observability.
type: playbook
status: draft
governance_status: draft
release_target: post-v1
owners: [platform, edge, engineering, security, privacy, operations]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [cloudflare-integration, workers, pages-functions, edge-platform]
tags: [playbook, cloudflare, workers, bindings, edge]
depends_on: [INTEGRATIONS-VENDOR, API-CONTRACTS, FND-CHANGE, WEB-QUALITY, OPERATIONS-RELIABILITY, OPERATIONS-LOGGING, PRIVACY-DATA, SECURITY-APPLICATION, SECURITY-SECRETS, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:28:10Z" }
sources:
  - id: cloudflare-workers
    resource: https://developers.cloudflare.com/workers/best-practices/workers-best-practices/
    title: Cloudflare Workers best practices
    author: organization:cloudflare
  - id: cloudflare-bindings
    resource: https://developers.cloudflare.com/workers/runtime-apis/bindings/
    title: Cloudflare Workers bindings
    author: organization:cloudflare
  - id: cloudflare-service-bindings
    resource: https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/
    title: Cloudflare service bindings
    author: organization:cloudflare
  - id: cloudflare-secrets
    resource: https://developers.cloudflare.com/workers/configuration/secrets/
    title: Cloudflare Workers secrets
    author: organization:cloudflare
  - id: cloudflare-configuration
    resource: https://developers.cloudflare.com/workers/wrangler/configuration/
    title: Wrangler configuration
    author: organization:cloudflare
---

# Cloudflare platform and Workers review

Use this playbook when Cloudflare compute, storage, networking, security, AI, or observability products are part of the system. Product-specific playbooks or standards remain additive when their risk warrants them.

## Agent review route

Load `cloudflare:cloudflare` to select the current product route and `cloudflare:workers-best-practices` for Workers code or configuration. Add `cloudflare:wrangler` for CLI or `wrangler.jsonc` work and `cloudflare:durable-objects` for stateful coordination, SQLite storage, alarms, RPC, WebSockets, or migrations. Record installed package versions. Retrieve current official documentation, Workers types, Wrangler schema, and changelog before relying on API shapes, configuration fields, compatibility flags, or limits.

Load `integrations/cloudflare/manifest.yaml`, classify every in-scope surface through `sources.yaml`, select the exact capabilities, execute the matching workflows, and run every applicable evaluation. An unclassified Cloudflare surface is a stop condition or recorded library gap.

The Workers best-practices route and current Wrangler schema win when an older Durable Objects example hand-writes `Env`, uses `wrangler.toml`, or shows a stale class pattern. Generate bindings from effective configuration and verify current base-class and RPC signatures instead of copying that sample unchanged. Record the conflict under `INTEGRATIONS-VENDOR-008`.

## Procedure

1. **Select and inventory products.** Record account, zones, Workers, Pages, routes, custom domains, environments, bindings, storage, queues, Durable Objects, AI services, network paths, regions, owners, billing, and support route.
2. **Validate configuration.** Check Wrangler configuration against the installed schema, set and review compatibility dates and flags deliberately, generate binding types, and reconcile declared bindings with code and deployed resources.
3. **Protect authority.** Store secrets through Workers or account secret facilities, keep local secret files untracked, separate environments and resources, and prefer Cloudflare bindings over API tokens and public REST calls for Cloudflare resources.
4. **Respect runtime lifecycle.** Stream large or unknown bodies with explicit bounds, keep request-scoped state out of module globals, await promises or attach approved background work to the execution context, and use cryptographic randomness for security values.
5. **Use internal boundaries.** Prefer service bindings for Worker-to-Worker calls, queues or workflows for durable background work, and the documented database connector for external databases when applicable. Authenticate and bound any public fallback.
6. **Test in the actual runtime.** Use current Workers types and a Workers-runtime test harness with representative bindings. Exercise concurrent requests, large streams, abandoned work, secret rotation, binding change, downstream failure, retry, and serialization boundaries.
7. **Review stateful primitives.** When Durable Objects apply, shard by the coordination atom, persist before updating in-memory caches, keep schema migrations explicit, keep external I/O outside concurrency blocks, and make alarms and RPC effects repeat-safe. Test eviction, concurrent calls, alarm replay, one-alarm replacement, migration, and hot-key concentration.
8. **Observe and release.** Enable structured logs and traces with an owned sampling, cost, privacy, and retention policy. Use a dry run and staged traffic where supported. Deploy dependencies in compatible order, inspect final routes and bindings, and exercise rollback, provider outage, quota exhaustion, and exit.

## Stop conditions

- Wrangler configuration, generated binding types, code, and deployed bindings disagree.
- Secrets appear in source, configuration values, client output, or tracked local files.
- Unbounded bodies are buffered, request state is global, or promises can be abandoned.
- A Worker calls a Cloudflare resource through a public API where a supported binding should enforce the boundary without a documented exception.
- Production logs and traces are absent or collect unapproved data.

## Completion evidence

- Account, product, route, resource, environment, owner, skill/version or gap, and dated official-source inventory.
- Wrangler schema validation, generated binding types, secret and environment negatives, runtime tests, and deployed binding reconciliation.
- Streaming, concurrency, promise lifecycle, security, observability, release, rollback, outage, and exit evidence.
- Passing Cloudflare integration bundle validation and no unresolved evaluation fixture.

## Sources

- Cloudflare, [Workers best practices](https://developers.cloudflare.com/workers/best-practices/workers-best-practices/). Reviewed August 17, 2026.
- Cloudflare, [Workers bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/). Reviewed August 17, 2026.
- Cloudflare, [Service bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/). Reviewed August 17, 2026.
- Cloudflare, [Workers secrets](https://developers.cloudflare.com/workers/configuration/secrets/). Reviewed August 17, 2026.
- Cloudflare, [Wrangler configuration](https://developers.cloudflare.com/workers/wrangler/configuration/). Reviewed August 17, 2026.
