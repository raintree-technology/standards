---
type: Guide
title: Documentation accessibility and reader review
description: Accessibility target, supported environments, and review evidence for repository-controlled documentation.
tags: [documentation, accessibility, review, evidence]
generated: { by: codex/gpt-5, at: "2026-08-17T17:22:48Z" }
---

# Documentation accessibility and reader review

This policy applies to Markdown and other public writing controlled by this repository. GitHub owns the rendered site and interface. Repository maintainers own the source structure, wording, text alternatives, link purpose, and any embedded media or tables.

## Accessibility target

Repository-controlled content targets WCAG 2.2 Level AA. The supported reading environments are the GitHub web interface and plain Markdown source in the current stable releases of Chrome, Firefox, and Safari on desktop, plus a narrow mobile viewport. Supported input and access methods are keyboard, pointer, touch where GitHub exposes it, browser zoom through 400%, increased text spacing, high-contrast settings, and VoiceOver on macOS or iOS.

The intended audience includes practitioners and agents who may be unfamiliar with the library. Reviews must include readers near the least-informed intended audience. A qualified accessibility reviewer owns conformance decisions. Repository maintainers own corrections to repository-controlled content.

This target is a test scope, not a conformance claim. GitHub behavior outside repository-controlled content is an external dependency and must be recorded as a limitation when it affects a material task.

## Author checks

Before requesting review:

- Use a logical heading order and descriptive link text.
- Give informative images a text alternative and mark decorative images accordingly.
- Give tables header cells and keep their meaning understandable in linear reading order.
- Do not use color, position, or formatting as the only carrier of meaning.
- Keep instructions usable without a pointer and avoid instructions that depend only on visual location.
- Check the changed page at 400% zoom or an equivalent narrow reflow width.
- Check the source and rendered page for clipped text, unreadable tables, broken links, and lost context.

## Acceptance evidence

For a material public-documentation change, record:

- the exact revision and pages reviewed;
- browsers, viewport, input methods, zoom or text-spacing settings, and assistive technology used;
- keyboard reading and navigation results;
- screen-reader reading order, headings, links, tables, and text-alternative results;
- automated findings and the manual decision for each material result;
- reader tasks, observed misunderstandings, changes, and any retest;
- external platform limits, residual risk, reviewer identity, role, and approval scope.

Use the [comprehension review](../templates/comprehension-review.md) and [independent review](../templates/independent-review.md) templates. Do not mark accessibility or comprehension checks complete from author review alone.

