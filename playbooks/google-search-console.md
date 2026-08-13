---
id: PLAYBOOK-GSC
title: Google Search Console operations
description: Versioned procedure for establishing Search Console ownership, monitoring discovery, and collecting release evidence.
type: playbook
status: draft
governance_status: draft
owners: [seo, web, analytics]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [public-web-page, seo-monitoring]
tags: [playbook, google, search-console, seo]
depends_on: [SEO-FOUNDATIONS, ANALYTICS-MEASUREMENT, FND-EVIDENCE]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
sources:
  - id: google-crawling-indexing
    resource: https://developers.google.com/search/docs/crawling-indexing
    title: Crawling and indexing topics
    author: organization:google
  - id: gsc-url-inspection
    resource: https://support.google.com/webmasters/answer/9012289
    title: URL Inspection tool
    author: organization:google
  - id: gsc-performance
    resource: https://support.google.com/webmasters/answer/10268906
    title: How are you performing on Google
    author: organization:google
  - id: gsc-data
    resource: https://support.google.com/webmasters/answer/96568
    title: About Search Console data
    author: organization:google
---

# Google Search Console operations

Use this playbook to operate Google Search Console as vendor-specific evidence for `SEO-FOUNDATIONS`. Search Console reports Google-observed behavior; they do not replace protocol inspection, server evidence, other search engines, or user outcomes.

## Preconditions

- Name the production site owner, SEO owner, incident contact, supported hosts and protocols, and intended indexable URL families.
- Record the Search Console property type, verified owners, delegated users, and review date without storing credentials in this repository.
- Define the release, migration, or monitoring decision and the evidence period it needs.

## Procedure

1. **Establish controlled ownership.** Verify the intended domain or URL-prefix property through an approved organization-controlled method. Remove stale owners and grant least privilege.
2. **Inventory discovery controls.** Record sitemap locations, robots rules, canonical policy, redirects, status behavior, authentication boundaries, `noindex` use, and important alternate-language relationships.
3. **Submit and monitor sitemaps.** Submit only canonical, intended URLs; reconcile submitted and indexed counts by meaningful URL family rather than treating total submission as success.
4. **Inspect representative URLs.** Use URL Inspection for new, changed, canonical, redirected, blocked, structured-data, media, and anomalous pages. Compare indexed and live observations with the delivered response.
5. **Review indexing and enhancement reports.** Triage changes by template, release, status, canonical, crawl access, and business importance. Validate fixes on representative URLs before broader closure.
6. **Monitor security and manual actions.** Route any security issue or manual action through the security and incident processes; preserve the notice, affected scope, remediation, review request, and outcome.
7. **Interpret performance cautiously.** Define query, page, country, device, appearance, and time filters; record Search Console sampling, aggregation, freshness, privacy, and comparison limitations; do not equate clicks with conversions or causal impact.
8. **Correlate with product evidence.** Compare Search Console discovery with server logs, page behavior, analytics, conversions, and release events. Explain material differences rather than forcing the systems to reconcile exactly.
9. **Close the decision.** Record what changed, representative inspection results, unresolved coverage, monitoring owner, and next review date.

## Failure handling

- If ownership is lost, treat monitoring coverage as unavailable and restore organization-controlled verification before making completion claims.
- If live and indexed results differ, record both timestamps and investigate crawl timing, canonical selection, rendering, response variation, and blocked resources.
- If reports contain no or partial data, do not infer absence of crawling, indexing, impressions, or user impact without corroborating evidence.

## Completion evidence

- Property and access review, with current accountable owners.
- Discovery-control inventory and sitemap reconciliation by URL family.
- Representative URL Inspection records tied to the release version.
- Indexing, enhancement, security, manual-action, and performance review notes.
- Cross-check with delivered HTTP behavior, server evidence, analytics, and conversions.
- Unresolved gaps, owner, and review date.

## Sources

- Google, [Crawling and indexing topics](https://developers.google.com/search/docs/crawling-indexing). Reviewed August 13, 2026.
- Google, [URL Inspection tool](https://support.google.com/webmasters/answer/9012289). Reviewed August 13, 2026.
- Google, [How are you performing on Google?](https://support.google.com/webmasters/answer/10268906). Reviewed August 13, 2026.
- Google, [About Search Console data](https://support.google.com/webmasters/answer/96568). Reviewed August 13, 2026.
