---
type: Template
title: Open-source documentation patterns
description: Reusable structures for repository, package, example, evidence, and maintainer documentation.
tags: [template, documentation, open-source, readme]
generated: { by: codex/gpt-5, at: "2026-08-20T20:00:00Z" }
---

# Open-source documentation patterns

Choose one pattern before writing. Keep the required information, but use headings
specific to the project.

## Repository landing page

1. Project name, lifecycle, audience, and outcome
2. Install or try it
3. Expected result and one accessible proof visual
4. Three to five reasons to use it
5. How it works
6. Supported surfaces and compatibility
7. Limits, security, and evidence boundary
8. Deeper documentation
9. Raintree open-source relationship
10. Contributing, security, changelog, and license

## Published package or plugin

1. Package name and its role in the parent project
2. Install
3. Smallest useful example
4. Public API or tools
5. Runtime and compatibility
6. Limits and failure behavior
7. Parent-project documentation, changelog, and license

## Example or study

Record the scenario and source revision, expected behavior, prerequisites, reproduction
command, observed result, interpretation, non-claims, artifacts, and provenance.

## Benchmark or evidence artifact

Record evidence status and date, the bounded claim, method, reproduction or verification
command, results, unavailable systems, integrity manifest, and limitations. Never rewrite
a signed or hash-verified artifact in place; publish a presentation referencing its digest.

## Internal maintainer guide

State the internal status and owner, purpose and boundary, maintenance commands,
generated and hand-maintained files, failure recovery, and the related public surface.
