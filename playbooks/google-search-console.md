---
id: PLAYBOOK-GSC
title: Google Search Console operations
description: Versioned procedure and capability router for controlled Search Console ownership, diagnosis, monitoring, external actions, and release evidence.
type: playbook
status: draft
governance_status: draft
owners: [seo, web, analytics]
last_reviewed: 2026-08-13
review_by: 2026-09-13
stale_after: 2026-09-13
applies_to: [public-web-page, seo-monitoring]
tags: [playbook, google, search-console, seo]
depends_on: [SEO-FOUNDATIONS, ANALYTICS-MEASUREMENT, FND-EVIDENCE]
generated: { by: codex/gpt-5, at: "2026-08-13T22:55:07Z" }
sources:
  - id: google-search-docs
    resource: https://developers.google.com/search/docs
    title: Google Search documentation
    author: organization:google
  - id: gsc-start
    resource: https://developers.google.com/search/docs/monitor-debug/search-console-start
    title: Get started with Search Console
    author: organization:google
  - id: gsc-reports
    resource: https://support.google.com/webmasters/answer/9133276
    title: Reports at a glance
    author: organization:google
  - id: gsc-recommendations
    resource: https://support.google.com/webmasters/answer/15107108
    title: Recommendations in Search Console
    author: organization:google
  - id: gsc-generative-ai-control
    resource: https://support.google.com/webmasters/answer/16908024
    title: Search generative AI control
    author: organization:google
  - id: gsc-generative-ai-search
    resource: https://support.google.com/webmasters/answer/16984139
    title: Generative AI performance report for Search
    author: organization:google
  - id: gsc-generative-ai-discover
    resource: https://support.google.com/webmasters/answer/16983858
    title: Generative AI performance report for Discover
    author: organization:google
  - id: gsc-platform-properties
    resource: https://support.google.com/webmasters/answer/17148418
    title: About platform properties in Search Console
    author: organization:google
  - id: gsc-achievements
    resource: https://support.google.com/webmasters/answer/16543604
    title: Achievements in Search Console
    author: organization:google
  - id: gsc-shopping
    resource: https://support.google.com/webmasters/answer/12660034
    title: Shopping reports and tools
    author: organization:google
  - id: gsc-api
    resource: https://developers.google.com/webmaster-tools/v1/api_reference_index
    title: Search Console API reference
    author: organization:google
  - id: gsc-auth
    resource: https://developers.google.com/webmaster-tools/v1/how-tos/authorizing
    title: Authorize Search Console API requests
    author: organization:google
  - id: gsc-limits
    resource: https://developers.google.com/webmaster-tools/limits
    title: Search Console API usage limits
    author: organization:google
  - id: gsc-data
    resource: https://support.google.com/webmasters/answer/96568
    title: About Search Console data
    author: organization:google
  - id: gsc-url-inspection
    resource: https://support.google.com/webmasters/answer/9012289
    title: URL Inspection tool
    author: organization:google
  - id: gsc-sitemaps
    resource: https://support.google.com/webmasters/answer/7451001
    title: Sitemaps report
    author: organization:google
  - id: gsc-traffic-drops
    resource: https://developers.google.com/search/docs/monitor-debug/debugging-search-traffic-drops
    title: Debugging drops in Google Search traffic
    author: organization:google
  - id: gsc-bulk-export
    resource: https://support.google.com/webmasters/answer/12918484
    title: About bulk data export to BigQuery
    author: organization:google
  - id: google-indexing-api
    resource: https://developers.google.com/search/apis/indexing-api/v3/using-api
    title: How to use the Indexing API
    author: organization:google
---

# Google Search Console operations

Use this playbook to operate Google Search Console as vendor-specific evidence for `SEO-FOUNDATIONS`. Search Console describes what Google observed, processed, indexed, or served. It does not replace live HTTP and rendered inspection, origin evidence, other search engines, analytics, commerce data, or user outcomes.

The supporting [Google Search Console capability bundle](../integrations/google-search-console/) is the executable contract for this playbook. Its source ledger, capability map, data semantics, workflows, and offline evaluations are validated separately from the governed-document catalog.

## Preconditions

- Name the production site owner, SEO owner, security and incident contacts, supported hosts and protocols, and intended indexable URL families.
- Record the exact domain or URL-prefix property, verified owners, delegated users, inherited access, associations, and review date without storing credentials or verification tokens here.
- Define the release, migration, investigation, or monitoring decision; its baseline; affected URL cohorts; materiality; evidence window; and recovery owner.
- Use read-only OAuth and the least Search Console role by default. Treat browser actions as observational unless the capability map explicitly classifies and authorizes a mutation.
- Read the current official source linked from the capability before relying on volatile permissions, quotas, fields, report availability, or platform behavior.

## Authority boundaries

- **Autonomous observation and diagnosis:** Read reports, APIs, export tables, settings, and notifications within an approved property and data boundary.
- **Bounded mutation:** Submit an already-approved sitemap only within a named property, sitemap scope, and retry limit.
- **Exact approval:** Require the final target, action, scope, consequence, recovery, and verification for property changes, service associations, indexing requests, validation starts, removals, Change of Address, shipping or return configuration, Search generative AI eligibility, and bulk export configuration.
- **Human-only representation:** Only a qualified human owner may establish verified ownership, change sensitive access, submit reconsideration, or attest security remediation to Google.
- Never infer authority from credential availability, owner role, a broad cleanup request, or an agent's confidence.

## Operational routes

Choose every route whose trigger applies. The machine-readable steps and stop conditions are in [`workflows.yaml`](../integrations/google-search-console/workflows.yaml).

### Access onboarding and review

Inventory exact domain, URL-prefix, and gradually available platform properties; verification methods; owners; roles; inherited access; unused tokens; associations; downstream recipients; Search generative AI control inheritance; and review dates. Maintain an organization-controlled verified owner. Platform login and connection remain human-only. Reconcile the final state from a second authorized account after any human-approved change.

### Monthly health review

Freeze a mature comparison window. Review messages, recommendations, achievements, merchant opportunities, manual actions, security issues, the effective Search generative AI control, eligible Search and Discover generative AI performance, export status, performance, page indexing, sitemaps, enhancements, and Core Web Vitals by important URL family. Treat recommendations, achievements, and merchant opportunities as context rather than instructions or ranking evidence. Correlate material changes with releases, server evidence, analytics, conversions, and external demand before assigning cause.

### Search-sensitive release monitoring

Record release time, affected patterns, expected Search effect, baseline, risk, and correction owner. Inspect live status, access, robots, noindex, canonicals, rendered meaning, internal links, sitemaps, and structured data before using Search Console. Compare representative live and indexed observations over defined crawl and processing windows.

### Traffic-drop investigation

Confirm property, surface, data maturity, anomaly status, baseline, seasonality, and materiality. Determine whether clicks, impressions, CTR, or position changed, then segment by page, query, country, device, appearance, directory, template, and release cohort. Check technical, security, manual-action, migration, algorithmic, demand, and reporting hypotheses. Record supporting and conflicting evidence; do not diagnose a penalty by elimination.

### Indexing diagnosis

State intended public, crawlable, canonical, and indexable behavior first. Compare HTTP status, access, robots, noindex, declared canonical, Google-selected canonical, sitemap membership, internal discovery, rendered content, duplicate variants, indexed observation, and live test. Correct durable source signals before a bounded indexing request and never promise indexing or ranking.

### Sitemap audit

Inventory every sitemap, index, generator, owner, property, format, and URL family. Fetch and validate files, then reconcile their URLs with successful, canonical, intended destinations. Treat submission, successful parsing, discovery, crawling, indexing, and performance as separate states. Deleting a submission does not remove its URLs from Google.

### Site migration

Freeze old and new URL inventories, one-to-one redirects, canonicals, sitemaps, content parity, baselines, and recovery authority. Use Change of Address only for an eligible domain or subdomain move after exact approval and successful prechecks. It is not for HTTP-to-HTTPS, path-only, or hosting-only changes. Monitor both properties and retain redirects and domain control for the approved duration.

### API and BigQuery reconciliation

Approve project, dataset, region, billing, IAM, retention, purpose, and cost controls before configuring export. Monitor settings, partitions, ExportLog, and Cloud logs. Query with partition filters and explicit grain, aggregate measures, and preserve anonymized-query, truncation, time-zone, latency, and canonicalization differences. Do not force Search Console, analytics, server, or commerce totals to agree.

### Shopping and commerce configuration

Confirm merchant eligibility and the authoritative commerce, legal, localization, and support owners. Reconcile Merchant opportunities, product and merchant rich-result reports, Merchant Center association, visible policies, structured data, feeds, checkout behavior, and Search Console shipping and return settings. Treat recommendations as optional evidence. Require exact market, policy, precedence, propagation, and rollback approval before changing settings.

### Critical escalation

Preserve manual actions, security notices, and removal requests exactly. Route security issues through incident response and manual actions through qualified SEO, policy, legal, and security review as applicable. Implement durable access, status, deletion, or noindex changes for urgent exposure. Temporary removal is not permanent remediation. Human owners alone submit reconsideration or security-review representations.

## Data interpretation

- Record property, surface, search type, dimensions, filters, time zone, data dates, observation time, and maturity with every result.
- Preserve Search Analytics `dataState`; do not compare fresh or partial hourly periods with finalized daily baselines without aligned maturity and an explicit requery plan.
- Search Analytics can omit anonymized queries, prioritize top rows, and expose at most 50,000 rows per day per search type. Pagination does not make it a complete warehouse.
- Missing date rows are not automatically zeros. Build a calendar spine and distinguish no activity, privacy suppression, immature data, API truncation, and export failure.
- Most performance page data is assigned to Google's canonical. Crawl Stats instead counts actual requested URLs, including requests within redirect chains.
- BigQuery export rows are not guaranteed unique by date, URL, site, query, or their combinations. Aggregate at an explicitly declared grain and never mix site-impression and URL-impression measures silently.
- In generative AI report downloads, do not interpret an exported numeric zero as measured zero when the UI displayed an unavailable or non-numeric sentinel.
- Indexed URL Inspection is stored Google state; live testing is a current test fetch. Neither guarantees future indexing or Search appearance.
- Report examples and link rows can be bounded or sampled. Absence from an example list is not proof of absence.

## Failure handling

- If ownership is lost or property scope is wrong, mark monitoring unavailable and restore organization-controlled access before making completion claims.
- If the capability bundle's source review is expired or a relevant change-watch item is unresolved, re-review the named primary sources before using the affected capability.
- If live and indexed evidence differ, preserve both timestamps and investigate crawl timing, response variation, canonical selection, rendering, resources, and release state.
- If data is immature, truncated, privacy-suppressed, sampled, or missing, narrow the claim and record the limitation rather than imputing certainty.
- If API quota is exceeded, record project, principal, property, resource, query shape, and retry time; reduce repeated wide queries and page-plus-query load before seeking more quota.
- If bulk export fails, inspect the latest settings error, expected partitions, ExportLog, Cloud logs, IAM, billing, region, retention, and schema. Do not alter Google's table schema.
- If a manual action, security issue, or ambiguous high-impact target appears, stop ordinary automation and escalate through the relevant workflow.

## Completion evidence

- Exact property, ownership, role, association, and access-review record.
- Named workflow, decision, baseline, filters, timestamps, URL cohorts, and data limitations.
- Direct HTTP and rendered evidence plus representative indexed and live observations.
- Sitemap, page-indexing, enhancement, manual-action, security, and performance reconciliation as applicable.
- Versioned API request or SQL evidence, export completeness, query cost, and cross-system explanation when data interfaces are used.
- Exact approvals and final-state verification for every mutation; qualified human submission evidence for human-only representations.
- Unresolved gaps, conflicting evidence, residual uncertainty, accountable owner, and next review date.
- Passing `ruby scripts/validate_integrations.rb` and `ruby scripts/test_validate_integrations.rb` results for any change to the supporting capability bundle or validator.

## Sources

- Google, [Google Search documentation](https://developers.google.com/search/docs). Reviewed August 13, 2026.
- Google, [Get started with Search Console](https://developers.google.com/search/docs/monitor-debug/search-console-start). Reviewed August 13, 2026.
- Google, [Reports at a glance](https://support.google.com/webmasters/answer/9133276). Reviewed August 13, 2026.
- Google, [Recommendations in Search Console](https://support.google.com/webmasters/answer/15107108). Reviewed August 13, 2026.
- Google, [Search generative AI control](https://support.google.com/webmasters/answer/16908024). Reviewed August 13, 2026.
- Google, [Generative AI performance report for Search](https://support.google.com/webmasters/answer/16984139). Reviewed August 13, 2026.
- Google, [Generative AI performance report for Discover](https://support.google.com/webmasters/answer/16983858). Reviewed August 13, 2026.
- Google, [About platform properties in Search Console](https://support.google.com/webmasters/answer/17148418). Reviewed August 13, 2026.
- Google, [Achievements in Search Console](https://support.google.com/webmasters/answer/16543604). Reviewed August 13, 2026.
- Google, [Shopping reports and tools](https://support.google.com/webmasters/answer/12660034). Reviewed August 13, 2026.
- Google, [Search Console API reference](https://developers.google.com/webmaster-tools/v1/api_reference_index). Reviewed August 13, 2026.
- Google, [Authorize Search Console API requests](https://developers.google.com/webmaster-tools/v1/how-tos/authorizing). Reviewed August 13, 2026.
- Google, [Search Console API usage limits](https://developers.google.com/webmaster-tools/limits). Reviewed August 13, 2026.
- Google, [About Search Console data](https://support.google.com/webmasters/answer/96568). Reviewed August 13, 2026.
- Google, [URL Inspection tool](https://support.google.com/webmasters/answer/9012289). Reviewed August 13, 2026.
- Google, [Sitemaps report](https://support.google.com/webmasters/answer/7451001). Reviewed August 13, 2026.
- Google, [Debugging drops in Google Search traffic](https://developers.google.com/search/docs/monitor-debug/debugging-search-traffic-drops). Reviewed August 13, 2026.
- Google, [About bulk data export to BigQuery](https://support.google.com/webmasters/answer/12918484). Reviewed August 13, 2026.
- Google, [How to use the Indexing API](https://developers.google.com/search/apis/indexing-api/v3/using-api). Reviewed August 13, 2026.
