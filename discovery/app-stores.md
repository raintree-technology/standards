---
id: DISCOVERY-APP-STORES
title: App-store discovery and submission
description: Requirements for accurate store metadata, platform policy, privacy declarations, review readiness, localization, and release monitoring.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [product, marketing, mobile, privacy, legal]
last_reviewed: 2026-08-13
review_by: 2026-11-13
stale_after: 2026-11-13
applies_to: [app-store-submission, app-store-optimization]
tags: [discovery, app-store, aso, mobile]
depends_on: [MARKETING-LIFECYCLE, PRODUCT-DELIVERY, FND-EVIDENCE, PRIVACY-DATA]
generated: { by: codex/gpt-5, at: "2026-08-13T23:20:00Z" }
sources:
  - id: apple-review-guidelines
    resource: https://developer.apple.com/app-store/review/guidelines/
    title: App Review Guidelines
    author: organization:apple
  - id: apple-app-information
    resource: https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/
    title: App information
    author: organization:apple
  - id: google-play-listing
    resource: https://support.google.com/googleplay/android-developer/answer/13393723
    title: Best practices for your store listing
    author: organization:google
  - id: google-play-data-safety
    resource: https://support.google.com/googleplay/android-developer/answer/10787469
    title: Provide information for Google Play Data safety section
    author: organization:google
---

# App-store discovery and submission

App-store listings and submissions must represent the released application accurately, meet current platform and jurisdiction rules, disclose data and purchase behavior, support review, and remain synchronized after release.

## Rules

### DISCOVERY-APP-STORES-001 — Pin the applicable store policy and account

**Level:** required  
**Applies when:** Preparing, changing, or submitting an app, product page, event, purchase, or store experiment.

Record store, territories, account owner, agreements, policy version or review date, app identifier, build, product-page variant, reviewers, and submission authority.

**Why:** Store policies and account terms change independently of application code.

**Verify:**

- Reopen current official policy before submission and compare the exact build and metadata.
- Inspect account roles, agreements, banking, tax, signing, and emergency access.

**Exceptions:** None for a production submission.

### DISCOVERY-APP-STORES-002 — Keep metadata truthful and build-specific

**Level:** required  
**Applies when:** Publishing names, descriptions, keywords, categories, screenshots, previews, pricing, availability, awards, or claims.

Represent functionality available in the submitted build and territory, including purchases and limitations; avoid irrelevant keywords, imitation, unverifiable claims, hidden functionality, real personal data, and misleading device imagery.

**Why:** Store metadata is a product claim and often precedes installation or permission decisions.

**Verify:**

- Trace every screenshot, preview, claim, price, and feature to the submitted build and configured products.
- Inspect all localized and experimental variants for equivalent accuracy.

**Exceptions:** Clearly labeled upcoming pre-order behavior must follow current store rules and release controls.

### DISCOVERY-APP-STORES-003 — Reconcile privacy and data declarations

**Level:** required  
**Applies when:** The app, SDKs, services, advertising, analytics, or accounts collect, share, retain, or infer data.

Derive store privacy declarations from the released data map, including third-party SDK behavior, purposes, linking, tracking, security, retention, deletion, and territory differences. Keep store, in-app notice, permissions, and observed traffic consistent.

**Why:** Self-reported store declarations can drift from runtime data behavior and vendor SDK changes.

**Verify:**

- Inspect source and binary dependencies, permissions, network and storage behavior, backend paths, and store answers for the final build.
- Exercise consent, denial, withdrawal, account deletion, child or age-restricted paths, and SDK-disabled states.

**Exceptions:** None for required declarations; uncertainty must block the declaration rather than be guessed.

### DISCOVERY-APP-STORES-004 — Make the build reviewable

**Level:** required  
**Applies when:** A platform reviewer needs access to evaluate the submitted behavior.

Provide complete review notes, stable backend availability, safe demo access or approved demo mode, required hardware or sample inputs, purchase visibility, non-obvious feature explanation, and a responsive contact without exposing real user data or production secrets.

**Why:** An incomplete review path delays approval and can encourage unsafe credential sharing or hidden behavior.

**Verify:**

- Have a non-author follow the review instructions from a clean supported device and account.
- Confirm credentials are bounded, monitored, revocable, and excluded from public metadata.

**Exceptions:** Security or legal limits on demo access require the platform-approved alternative and documented rationale.

### DISCOVERY-APP-STORES-005 — Localize complete store meaning

**Level:** required  
**Applies when:** A listing, purchase, event, privacy statement, or support path is available in multiple locales or territories.

Localize complete messages, search terms, screenshots, captions, prices, eligibility, legal and privacy meaning, support, and cultural context; do not machine-publish unreviewed high-impact translations.

**Why:** Store discovery and commitment happen before users can inspect in-app context.

**Verify:**

- Review every active locale with the territory configuration and corresponding build behavior.
- Test text expansion, right-to-left layout, media text, fallback, and unavailable product states.

**Exceptions:** An untranslated locale must use an intentional supported fallback and must not imply localized support.

### DISCOVERY-APP-STORES-006 — Govern reviews, ratings, and store experiments

**Level:** required  
**Applies when:** Requesting reviews, responding publicly, testing listings, or using ratings and awards in claims.

Use platform-supported prompts and honest selection, do not manipulate sentiment or suppress eligible negative users, protect reviewer privacy, substantiate rating claims with scope and date, and predefine experiment decisions and guardrails.

**Why:** Manipulated review populations and selected results distort store trust and product learning.

**Verify:**

- Inspect prompt eligibility, timing, frequency, incentives, response process, experiment assignment, and reported outcomes.
- Confirm support resolution is not conditioned on rating change or removal.

**Exceptions:** None for fake, purchased, or sentiment-conditioned reviews.

### DISCOVERY-APP-STORES-007 — Monitor submission and post-release state

**Level:** required  
**Applies when:** A submission is in review, released, rejected, removed, phased, or rolled back.

Track review communication, status, phased availability, crashes, store health, policy notices, reviews, purchases, privacy changes, support, and actual build adoption. Preserve rejection and appeal evidence and correct invalid metadata promptly.

**Why:** Approval does not prove continuing compliance or successful availability across storefronts.

**Verify:**

- Inspect representative live storefronts, install and update paths, purchases, links, privacy disclosures, and rollback behavior.
- Reconcile store status with release, support, analytics, and incident records.

**Exceptions:** None for active listings.

## Guidance

Treat store optimization as truthful discovery, not keyword or review manipulation. Use official store documentation as the current authority and keep Apple and Google requirements separate where their interfaces and rules differ.

## Examples

### Subscription screenshot

Non-compliant: Show a premium feature as included, omit that it requires a recurring purchase, and reuse the screenshot in territories where the product is unavailable.

Compliant: Match the submitted build and storefront, identify the purchase context, localize terms, reconcile configured products, and test the install-to-purchase path.

## Sources

- Apple, [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/). Reviewed August 13, 2026.
- Apple, [App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/). Reviewed August 13, 2026.
- Google, [Best practices for your store listing](https://support.google.com/googleplay/android-developer/answer/13393723). Reviewed August 13, 2026.
- Google, [Provide information for Google Play's Data safety section](https://support.google.com/googleplay/android-developer/answer/10787469). Reviewed August 13, 2026.
