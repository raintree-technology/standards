---
type: Guide
title: Contributing
description: Process and requirements for contributing to Raintree Standards.
tags: [contributing, governance]
generated: { by: codex/gpt-5, at: "2026-08-13T20:57:53Z" }
---

# Contributing

Raintree Standards accepts corrections, clarifications, and proposals for recurring requirements. Read the [standards contribution requirements](governance/contributing.md) before preparing a change.

## Propose a change

1. Search existing issues and standards for the same concern.
2. Open an issue that describes the recurring decision or risk, affected readers, and expected outcome.
3. For a new standard, start with [`templates/standard.md`](templates/standard.md). For a new task profile, start with [`templates/profile.md`](templates/profile.md).
4. Update [`catalog.yaml`](catalog.yaml) when you add, move, or retire a governed document or profile.
5. Run `ruby scripts/validate_catalog.rb` from the repository root.
6. Before a versioned release, run `ruby scripts/validate_catalog.rb --release` and resolve every draft, verification, and dependency blocker.
7. Open a pull request that explains what changed, why it is needed, and what you verified.

Keep changes focused. Preserve existing rule IDs and unknown YAML front-matter fields. Do not include confidential information, personal data, credentials, or material that you do not have permission to publish.

By contributing, you agree that your contribution may be distributed under the licenses described in [LICENSE.md](LICENSE.md).

## Review

Maintainers review proposals for technical correctness, operational feasibility, unintended incentives, and conflicts with existing rules. A qualified human owner must review high-impact security, legal, privacy, financial, or regulatory standards.

All participation must follow the [Code of Conduct](CODE_OF_CONDUCT.md).
