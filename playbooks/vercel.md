---
id: PLAYBOOK-VERCEL
title: Vercel deployment and platform review
description: Provider-specific procedure for Vercel environments, builds, promotion, rollback, firewall controls, observability, and drains.
type: playbook
status: draft
governance_status: draft
release_target: post-v1
owners: [platform, web, engineering, security, privacy, operations]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [vercel-deployment, vercel-hosting, vercel-firewall, vercel-observability]
tags: [playbook, vercel, deployment, firewall, observability]
depends_on: [INTEGRATIONS-VENDOR, FND-CHANGE, WEB-QUALITY, OPERATIONS-RELIABILITY, OPERATIONS-LOGGING, PRIVACY-DATA, SECURITY-APPLICATION, SECURITY-SECRETS, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T17:28:10Z" }
sources:
  - id: vercel-deployments
    resource: https://vercel.com/docs/deployments/promoting-a-deployment
    title: Vercel promoting deployments
    author: organization:vercel
  - id: vercel-environment
    resource: https://vercel.com/docs/environment-variables
    title: Vercel environment variables
    author: organization:vercel
  - id: vercel-sensitive-environment
    resource: https://vercel.com/docs/environment-variables/sensitive-environment-variables
    title: Vercel sensitive environment variables
    author: organization:vercel
  - id: vercel-firewall
    resource: https://vercel.com/docs/vercel-firewall
    title: Vercel Firewall
    author: organization:vercel
  - id: vercel-drains
    resource: https://vercel.com/docs/drains/security
    title: Vercel Drains security
    author: organization:vercel
  - id: vercel-runtime-logs
    resource: https://vercel.com/docs/logs/runtime
    title: Vercel runtime logs
    author: organization:vercel
---

# Vercel deployment and platform review

Use this playbook when Vercel builds, deploys, hosts, protects, or exports telemetry for an application. Framework-specific standards remain additive.

## Agent review route

Load `vercel:deployments-cicd`, `vercel:env-vars`, `vercel:observability`, and `vercel:vercel-firewall` when their scopes apply. Add `vercel:vercel-functions`, `vercel:routing-middleware`, `vercel:cdn-caching`, `vercel:cron-jobs`, `vercel:vercel-storage`, or `vercel:marketplace` when those surfaces are present. Record installed package versions and verify current CLI behavior, plan availability, limits, fields, and platform defaults against Vercel documentation.

Vercel payment and email routes do not replace the Stripe and Resend playbooks. Activate both provider bundles and let the dedicated provider source resolve API-level conflicts.

Load `integrations/vercel/manifest.yaml`, classify every in-scope surface through `sources.yaml`, select the exact capabilities, execute the matching workflows, and run every applicable evaluation. An unclassified Vercel surface is a stop condition or recorded library gap.

## Procedure

1. **Fix the project boundary.** Record team, project, domains, environments, branch rules, root directory, regions, functions, integrations, storage, owners, billing, and incident contacts.
2. **Separate configuration.** Scope production, preview, development, custom, and branch values intentionally. Mark secrets sensitive where supported, keep them out of client-prefixed variables and source, prevent previews from reaching production data, and use workload identity for runtime backend access where supported.
3. **Bind build and configuration.** Pin deployment tooling, obtain the intended environment before build, run tests against the production-intended artifact, and record deployment ID, source commit, build configuration, migrations, and effective environment names without values.
4. **Stage and promote.** Prefer an immutable tested production-intended deployment or an explicitly understood preview promotion path. Define promotion, stop, rollback, and compensation conditions. Confirm environment differences and stateful migrations before changing production aliases.
5. **Review runtime and routing.** Match each function to its runtime, duration, region, concurrency, streaming, and background-work contract. Treat routing middleware as a security and cache boundary: keep authentication and authorization in the protected handler too, bound matcher scope, and test rewrites, redirects, prefetches, old clients, and version skew.
6. **Review cache and scheduled work.** Separate CDN, ISR, runtime, and backend caches. Test tenant and authorization partitioning, stale-on-error, invalidation blast radius, request collapse, and cache-cold load. Make cron handlers authenticated and repeat-safe, bound overlap and catch-up, and prove the schedule invokes an owned endpoint in the intended environment.
7. **Establish observability.** Emit governed structured logs, correlate requests and deployments, verify runtime error access, and configure plan-appropriate logs, traces, analytics, performance signals, alerts, or drains. Authenticate drain payloads over the raw body and minimize exported personal data.
8. **Stage firewall changes.** Inventory route and method exposure. Start new rules and rate limits in log-only mode, inspect representative legitimate and abusive traffic, enforce in preview, then publish production enforcement with rollback. Review priority, bypasses, reverse proxies, and regional counting semantics.
9. **Keep severe controls human-owned.** Attack-mode changes, platform-mitigation pauses, broad bypasses, and production firewall publication require explicit incident or production authority. Agents may prepare diffs and evidence but cannot assume that authority.
10. **Verify after release.** Inspect current deployment, domains, environment scope, functions, logs, drains, firewall events, caches, cron outcomes, user flows, and error signals. Exercise rollback, credential failure, provider degradation, drain failure, cache stampede, overlapping scheduled runs, and project exit.

## Stop conditions

- Preview or development has production secrets, databases, payment authority, or other production mutation access without an approved exception.
- The tested artifact or effective production configuration cannot be identified.
- Firewall enforcement has not passed log-only and preview evidence, outside documented emergency authority.
- A telemetry drain is unauthenticated or exports unapproved personal data.
- Rollback would leave an unaddressed schema, financial, or external side effect.

## Completion evidence

- Team, project, domain, environment, integration, and authority inventory plus skill versions and dated official-source review.
- Environment-scope negatives, immutable build and deployment identity, pre-promotion checks, promotion and rollback evidence.
- Runtime logs and alerts, drain authenticity and privacy checks, staged firewall match and enforcement evidence.
- Post-release inspection, incident, recovery, and exit exercise.
- Passing Vercel integration bundle validation and no unresolved evaluation fixture.

## Sources

- Vercel, [Promoting deployments](https://vercel.com/docs/deployments/promoting-a-deployment). Reviewed August 17, 2026.
- Vercel, [Environment variables](https://vercel.com/docs/environment-variables). Reviewed August 17, 2026.
- Vercel, [Sensitive environment variables](https://vercel.com/docs/environment-variables/sensitive-environment-variables). Reviewed August 17, 2026.
- Vercel, [Firewall](https://vercel.com/docs/vercel-firewall). Reviewed August 17, 2026.
- Vercel, [Drains security](https://vercel.com/docs/drains/security). Reviewed August 17, 2026.
- Vercel, [Runtime logs](https://vercel.com/docs/logs/runtime). Reviewed August 17, 2026.
