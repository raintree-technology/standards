---
id: SEO-FOUNDATIONS
title: Search foundations
description: Makes useful public content discoverable and understandable without misleading users or crawlers.
type: standard
status: stable
governance_status: active
owners: [seo, content, engineering]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [public-web-page, seo-migration, content-program]
tags: [seo, crawling, indexing, content]
depends_on: [FND-EVIDENCE, FND-TRUST]
generated: { by: codex/gpt-5, at: "2026-08-13T18:58:53Z" }
sources:
  - id: google-crawling-indexing
    resource: https://developers.google.com/search/docs/crawling-indexing
    title: Crawling and indexing
    author: organization:google
  - id: google-canonicalization
    resource: https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls
    title: How to specify a canonical URL
    author: organization:google
  - id: google-redirects
    resource: https://developers.google.com/search/docs/crawling-indexing/301-redirects
    title: Redirects and Google Search
    author: organization:google
  - id: ietf-http-semantics
    resource: https://www.rfc-editor.org/rfc/rfc9110.html
    title: HTTP Semantics
    author: organization:ietf
  - id: ietf-robots
    resource: https://www.rfc-editor.org/rfc/rfc9309.html
    title: Robots Exclusion Protocol
    author: organization:ietf
  - id: google-helpful-content
    resource: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
    title: Creating helpful reliable people-first content
    author: organization:google
  - id: google-javascript-seo
    resource: https://developers.google.com/search/docs/crawling-indexing/javascript/javascript-seo-basics
    title: Understand the JavaScript SEO basics
    author: organization:google
  - id: google-localized-versions
    resource: https://developers.google.com/search/docs/specialty/international/localized-versions
    title: Tell Google about localized versions of your page
    author: organization:google
  - id: google-structured-data
    resource: https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data
    title: Introduction to structured data markup in Google Search
    author: organization:google
  - id: bing-robots
    resource: https://www.bing.com/webmasters/help/robots-meta-tags-and-attributes-that-bing-supports-5198d240
    title: Robots meta tags and attributes that Bing supports
    author: organization:microsoft
---

# Search foundations

Search work must make useful public content easier to discover and understand without misleading users or crawlers. It governs content purpose, crawl and index controls, canonicalization, rendering, structured data, internal discovery, and migrations.

Search platform behavior changes frequently. Revalidate implementation details against current primary documentation before shipping.

## Rules

### SEO-FOUNDATIONS-001 — Give every indexable URL a distinct purpose

**Level:** required  
**Applies when:** A URL is intended to appear in organic search.

Define the audience need, intended query or discovery context, and action or understanding the page supports. Provide substantive, accurate content not better represented by another canonical URL.

**Why:** Near-duplicate or empty pages consume crawl and maintenance effort while giving users no distinct destination.

**Verify:**

- Compare the page with other indexable URLs targeting the same need.
- Confirm the primary content answers the defined need without relying on hidden or unavailable material.

**Exceptions:** Locale and format variants can share purpose when their alternate and canonical relationships are intentional.

### SEO-FOUNDATIONS-002 — Make indexability intentional

**Level:** required  
**Applies when:** Publishing, staging, duplicating, migrating, personalizing, or retiring public content.

Set a deliberate combination of access control, HTTP status, robots directives, canonical target, sitemap inclusion, and internal links. Do not use crawl controls as access control or as the sole method for removing an indexed URL.

**Why:** Crawl, indexing, canonicalization, and authorization solve different problems and can produce contradictory signals.

**Verify:**

- Fetch the URL as a client and crawler where available, and inspect status, headers, HTML directives, canonical, links, and rendered content.
- Confirm staging and private material require real authorization.

**Exceptions:** Temporary emergency removal can use a platform removal tool while the durable status, directive, or access fix is deployed.

### SEO-FOUNDATIONS-003 — Return truthful HTTP status codes

**Level:** required  
**Applies when:** Content is missing, moved, unavailable, restricted, deleted, or temporarily offline.

Return the status that describes the resource and use a redirect only when an appropriate destination exists. Avoid soft 404s, redirect chains, loops, blanket redirects, and error pages returning success.

**Why:** Users, crawlers, caches, monitoring, and link checkers use status semantics to decide what happened and what to do next.

**Verify:**

- Inspect headers for representative success, redirect, missing, gone, restricted, throttled, and outage cases.
- Follow redirects to the final relevant destination and confirm the chain is intentional.

**Exceptions:** Security-sensitive resources can use a less revealing client response when required by policy, while internal monitoring records the actual condition.

### SEO-FOUNDATIONS-004 — Keep canonical signals consistent

**Level:** required  
**Applies when:** Multiple URLs can expose identical or near-identical content.

Choose the intended canonical URL and align redirects, canonical annotations, sitemap inclusion, internal links, alternate-language annotations, and structured data with it.

**Why:** Conflicting signals leave search platforms to choose a representative URL and can split reporting or discovery across variants.

**Verify:**

- Compare every duplicate or variant with the declared canonical map.
- Confirm canonical targets return an indexable success response and do not redirect elsewhere.

**Exceptions:** Syndicated or cross-domain content can follow an approved distribution policy when the preferred source cannot control every signal.

### SEO-FOUNDATIONS-005 — Deliver essential meaning without interaction

**Level:** required  
**Applies when:** A page is intended for search discovery, sharing previews, feeds, or agent consumption.

Include primary content, document title, description, canonical information, headings, links, and essential structured meaning in delivered HTML or a reliably rendered equivalent. Do not require a click, scroll, consent to nonessential tracking, or client-only state change to reveal the main subject.

**Why:** Crawlers and other consumers may not execute every interaction or client behavior a user can.

**Verify:**

- Inspect the initial response and rendered result with scripts delayed or unavailable.
- Confirm the visible primary content and machine-readable metadata describe the same page.

**Exceptions:** Authenticated application content is outside indexable scope unless an intentional public representation exists.

### SEO-FOUNDATIONS-006 — Mark up only visible, accurate content

**Level:** required  
**Applies when:** Publishing schema.org or search-platform structured data.

Use the most specific truthful type supported by the visible page. Keep names, prices, availability, dates, ratings, authorship, and relationships consistent with what users can verify.

**Why:** Hidden or exaggerated markup misleads machine consumers and can produce incorrect search features.

**Verify:**

- Compare every material structured property with visible content and source data.
- Run syntax and platform validation, then inspect the rendered page; validator success alone is insufficient.

**Exceptions:** Machine-readable identifiers and technical relationships can be non-visible when they accurately describe visible content and platform rules allow them.

### SEO-FOUNDATIONS-007 — Preserve discovery during migrations

**Level:** required  
**Applies when:** URLs, domains, protocols, paths, rendering systems, templates, or information architecture change.

Inventory valuable URLs, map equivalent destinations one to one, preserve important content and internal paths, update canonical and alternate signals, and monitor crawl, indexing, traffic, and errors after launch.

**Why:** A migration can remove valid entry points or redirect users to irrelevant destinations even when the new site works in isolation.

**Verify:**

- Compare prelaunch inventory with the redirect and content map.
- Crawl old and new URL sets, inspect representative rendered pages, and track postlaunch status and discovery changes.
- Assign an owner and duration for monitoring and redirect retention.

**Exceptions:** Retired content with no relevant replacement should return its truthful terminal status instead of redirecting to a generic page.

### SEO-FOUNDATIONS-008 — Make titles, descriptions, headings, and links descriptive

**Level:** required  
**Applies when:** Publishing an indexable page or a page that links to one.

Use a distinct descriptive document title, an accurate summary, one clear page topic, semantic heading structure, and link text that explains the destination. Keep important pages reachable through ordinary crawlable links.

**Why:** These elements help users and machines understand a page before and after navigation.

**Verify:**

- Scan titles, headings, summaries, and links without surrounding layout.
- Crawl from expected entry points and confirm important destinations are discoverable without internal search or scripted interaction.

**Exceptions:** Repeated navigation labels can rely on their shared navigation context when the destination remains clear.

### SEO-FOUNDATIONS-009 — Control URL proliferation

**Level:** required  
**Applies when:** Filters, sorting, search, tracking parameters, pagination, calendars, or generated combinations can create many URLs.

Define which combinations deserve stable indexable URLs and how all others are linked, canonicalized, redirected, or excluded from crawl and indexing. Keep parameter behavior deterministic.

**Why:** Unbounded URL spaces waste crawl effort, duplicate content, and make canonical signals harder to maintain.

**Verify:**

- Enumerate or sample parameter combinations and inspect their status, canonical, robots behavior, and links.
- Confirm application navigation does not continuously generate new crawlable states.

**Exceptions:** Large deliberate catalogs can expose many URLs when each satisfies a distinct need and crawl capacity is monitored.

### SEO-FOUNDATIONS-010 — Measure qualified discovery and user value

**Level:** required  
**Applies when:** Evaluating search work or declaring a search migration complete.

Use qualified organic outcomes and user value alongside crawl and indexing signals. Segment material sources of demand, annotate releases, and account for seasonality, reporting latency, and brand demand where relevant.

**Why:** Rankings or impressions alone can rise while useful visits, conversions, or retained discovery decline.

**Verify:**

- Record baseline, release date, measurement window, affected URL set, and known reporting limitations.
- Connect technical indicators with representative landing-page and outcome behavior.

**Exceptions:** A new property without a baseline can use indexed coverage and qualified landing behavior while a comparison period develops.

### SEO-FOUNDATIONS-011 — Publish for a real audience, not ranking manipulation

**Level:** required  
**Applies when:** Creating, generating, consolidating, or materially revising indexable content.

Publish content because it serves an identified audience and site purpose. Add original knowledge, evidence, experience, tools, or synthesis appropriate to the topic. Do not mass-produce, paraphrase, cloak, expire, or refresh content primarily to capture queries or manipulate ranking systems.

**Why:** Search-oriented volume without distinct user value creates misleading or duplicative destinations and can violate search-platform spam policies.

**Verify:**

- Identify the intended audience, owner, purpose, source evidence, and distinct value for the page or page family.
- Compare generated and templated pages for substantive differences beyond keywords, locations, or reordered source material.
- Confirm visible content and crawler-visible content have the same material meaning.

**Exceptions:** Programmatically generated pages are allowed when each one accurately presents distinct data or functionality that satisfies a real user need and has quality controls at scale.

### SEO-FOUNDATIONS-012 — Map multilingual and regional variants explicitly

**Level:** required  
**Applies when:** Equivalent or closely related pages target different languages, scripts, or regions.

Give each variant a stable URL, correct document language, locale-appropriate content, self-consistent canonical signals, and reciprocal alternate relationships. Provide a useful fallback for unmatched locales and do not redirect users solely from an inferred location or language without a choice.

**Why:** Language and regional variants can be mistaken for duplicates or send users to the wrong currency, terms, language, or availability when their relationships are incomplete.

**Verify:**

- Crawl every variant set and confirm reciprocal `hreflang` or equivalent annotations, valid language and region codes, success responses, and self-canonical behavior.
- Compare translated primary content, navigation, structured data, and locale-specific claims.
- Test direct visits, shared links, and locale switching without relying on prior cookies.

**Exceptions:** A single language-neutral selector can act as the fallback when it is accessible, indexable as intended, and does not replace substantive localized destinations.

## Guidance

Design for users first, then expose the same truthful meaning to machines. Do not create pages solely to vary keywords, locations, or parameters when the underlying user need and content are unchanged.

Treat canonical annotations as consolidation signals, not redirects or access controls. Keep sitemaps limited to preferred indexable URLs. Use permanent redirects for durable moves and temporary redirects only for genuinely temporary destinations.

Serve `robots.txt` according to RFC 9309 and test its successful, unavailable, unreachable, and redirect behavior. A crawler directive is a request to conforming automated clients, not authorization or confidentiality.

Monitor by page type and URL cohort. Sitewide averages can hide a failed template, locale, directory, or migration segment.

## Examples

### Retired page

Non-compliant: Every removed article redirects to the homepage and the homepage returns `200`.

Compliant: An article with a direct replacement redirects once to that replacement. An article with no relevant replacement returns `410` or `404` with useful navigation.

### Filtered URLs

Non-compliant: Every combination of color, size, sort order, tracking code, and view mode is crawlable and self-canonical.

Compliant: Only curated category combinations with distinct demand and content are indexable; sort and tracking variants resolve to the intended canonical state and are not linked as separate destinations.

## Sources

- Google, [Crawling and indexing](https://developers.google.com/search/docs/crawling-indexing), Search Central documentation. Last updated December 10, 2025; reviewed August 13, 2026.
- Google, [How to specify a canonical URL](https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls), Search Central documentation. Reviewed August 13, 2026.
- Google, [Redirects and Google Search](https://developers.google.com/search/docs/crawling-indexing/301-redirects), Search Central documentation. Reviewed August 13, 2026.
- Internet Engineering Task Force, [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), June 2022. Reviewed August 13, 2026.
- Internet Engineering Task Force, [RFC 9309: Robots Exclusion Protocol](https://www.rfc-editor.org/rfc/rfc9309.html), September 2022. Reviewed August 13, 2026.
- Google, [Creating helpful, reliable, people-first content](https://developers.google.com/search/docs/fundamentals/creating-helpful-content), Search Central documentation. Reviewed August 13, 2026.
- Google, [Understand the JavaScript SEO basics](https://developers.google.com/search/docs/crawling-indexing/javascript/javascript-seo-basics), Search Central documentation. Reviewed August 13, 2026.
- Google, [Tell Google about localized versions of your page](https://developers.google.com/search/docs/specialty/international/localized-versions), Search Central documentation, last updated December 22, 2025. Reviewed August 13, 2026.
- Google, [Introduction to structured data markup in Google Search](https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data), Search Central documentation. Reviewed August 13, 2026.
- Microsoft, [Robots meta tags and attributes that Bing supports](https://www.bing.com/webmasters/help/robots-meta-tags-and-attributes-that-bing-supports-5198d240), Bing Webmaster Tools. Reviewed August 13, 2026.
