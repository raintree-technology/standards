---
type: Guide
title: Changelog
description: Release-note policy for material changes to governed requirements and repository contracts.
tags: [governance, releases, compatibility]
generated: { by: codex/gpt-5, at: "2026-08-20T23:30:49Z" }
---

# Changelog

This file records material changes to governed requirements, profiles, schemas, playbooks, lifecycle status, and compatibility.

## Unreleased

- The library remains pre-1.0 and approval-pending.
- `governance/contributing.md` now states the release-gate lifecycle directly: a document may be `stable` while independent verification is pending, and the `--release` gate blocks a versioned release until `verified` is recorded. This removes a contradiction with the gate design described in the same document and in `governance/authority.md`.
- `governance/v1-readiness.md` records the five stable documents that depend on drafts as known release blockers.
- `DATA-DATABASE-007` level corrected from `avoid` to `required`; the rule requires bounding growing access paths.
- `WEB-QUALITY-017`, `AI-AGENTS-008`, and `API-CONTRACTS-008` now delegate to their owning rules (`CONTENT-ERRORS-012`, `PRIVACY-DATA-016`, `SECURITY-APPLICATION-002`) instead of restating them; `API-CONTRACTS-003` now cites `CONTENT-ERRORS-011` for HTTP error formats; the `WEB-QUALITY` accessibility section names the `FND-ACCESSIBILITY` rules it specializes.
- Declared previously implicit `depends_on` edges: `WEB-QUALITY` and `API-CONTRACTS` → `CONTENT-ERRORS`; `AI-AGENTS` → `PRIVACY-DATA`; `KNOWLEDGE-SYSTEMS` → `AI-AGENTS`; `OPERATIONS-LOGGING` → `API-CONTRACTS`; `ENGINEERING-CODE-REMOVAL` → `ENGINEERING-JS-QUALITY`; `WRITING-FUNCTIONAL` → `AGENT-VERIFICATION`.
- `PROFILE-SPECIALIST-MARKETING` completion evidence now cites rule IDs.
- Every rule's `Level` line now uses the standard template's hard line break so `Level` and `Applies when` render on separate lines.
- Catalog and index reconciliation: `governance/documentation-quality.md` added to `catalog.yaml`; `MARKETING-PROJECT-SHOWCASE` added to the root index; `OPERATIONS-LOGGING` and `MARKETING-PROJECT-SHOWCASE` added to the coverage matrix; duplicate entries removed from the foundations and data indexes; the browse list is alphabetized; the standards-audit playbook names the Google Search Console playbook in its provider route.

Each release entry should name affected stable IDs, applicability or requirement-level changes, migration work, independent verification status, and any unresolved release blockers. Catalog structure changes alone do not imply content approval.
