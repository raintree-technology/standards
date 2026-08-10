---
id: SEO-FOUNDATIONS
title: Search foundations
description: Makes useful public content discoverable and understandable without misleading users or crawlers.
type: standard
status: stable
governance_status: active
owners: [seo, content, engineering]
last_reviewed: 2026-08-10
review_by: 2026-11-10
stale_after: 2026-11-10
applies_to: [public-web-page, seo-migration, content-program]
tags: [seo, crawling, indexing, content]
depends_on: [FND-EVIDENCE, FND-TRUST]
generated: { by: codex/gpt-5, at: "2026-08-10T16:00:00Z" }
---

# Search foundations

Search optimization must make useful content easier to discover and understand without misleading users or crawlers.

Search platform behavior changes frequently. Revalidate implementation details against current primary documentation before shipping.

## Rules

### SEO-FOUNDATIONS-001 — Give every indexable URL a distinct purpose

**Level:** required  
**Applies when:** A URL is intended to appear in organic search.

The page must satisfy a defined audience need with substantive, accurate content not better represented by another canonical URL.

### SEO-FOUNDATIONS-002 — Make indexability intentional

**Level:** required  
**Applies when:** Publishing, staging, migrating, duplicating, or retiring public content.

Set a deliberate combination of status code, robots directives, canonical target, sitemap inclusion, and internal links. Do not rely on `robots.txt` to remove an already indexed URL or protect private information.

### SEO-FOUNDATIONS-003 — Return truthful HTTP status codes

**Level:** required  
**Applies when:** Content is missing, moved, unavailable, or deleted.

Return the status that describes the resource. Avoid soft 404s, redirect chains, irrelevant redirects, and error pages returning success.

### SEO-FOUNDATIONS-004 — Keep canonical signals consistent

**Level:** required  
**Applies when:** Multiple URLs can expose identical or near-identical content.

Align canonical tags, redirects, sitemaps, internal links, alternate-language annotations, and structured data around the intended canonical URL.

### SEO-FOUNDATIONS-005 — Render essential meaning without interaction

**Level:** required  
**Applies when:** A page is intended for search discovery, sharing previews, or agent consumption.

Include primary content, title, description, canonical information, and essential structured meaning in the delivered HTML or a reliably rendered equivalent. Do not require a click, scroll, or client-only state transition to reveal the page's main subject.

### SEO-FOUNDATIONS-006 — Use structured data only for visible, accurate content

**Level:** required  
**Applies when:** Publishing schema.org or search-platform structured data.

Markup must describe the page users can see, use the most specific truthful type, and remain consistent with visible claims.

### SEO-FOUNDATIONS-007 — Preserve equity during migrations

**Level:** required  
**Applies when:** URLs, domains, protocols, paths, rendering systems, or information architecture change.

Inventory valuable URLs, define one-to-one redirects where equivalents exist, preserve important content and internal links, update canonical signals, and monitor crawl, indexation, traffic, and errors after launch.

## Measurement

Evaluate search work using qualified organic outcomes and user value, not rankings alone. Segment brand and non-brand demand where useful, annotate releases, and account for seasonality and reporting latency.
