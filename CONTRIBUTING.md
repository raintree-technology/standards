---
type: Guide
title: Contributing
description: Process and requirements for contributing to raintree.standards.
tags: [contributing, governance]
generated: { by: codex/gpt-5, at: "2026-08-17T17:22:48Z" }
---

# Contributing

Contribute a focused correction, clarification, or proposal for a recurring
requirement. Before you start, read the
[standards contribution requirements](governance/contributing.md) and confirm that an
existing standard does not already cover the concern.

## Propose a change

1. Search existing issues and standards for the same concern.
2. Open an issue that describes the recurring decision or risk, affected readers, and expected outcome.
3. For a new standard, start with [`templates/standard.md`](templates/standard.md). For a new task profile, start with [`templates/profile.md`](templates/profile.md).
4. Update [`catalog.yaml`](catalog.yaml) when you add, move, or retire a governed document or profile.
5. Run the checks below from the repository root.
6. Before a versioned release, run `ruby scripts/validate_catalog.rb --release` and resolve every draft, verification, and dependency blocker. Until version 1.0, this command reports known release blockers by design.
7. Open a pull request that explains what changed, why it is needed, and what you verified.

## Run the checks

The validators use only the Ruby standard library. You do not need to install a bundle.

```sh
ruby scripts/validate_catalog.rb
ruby scripts/validate_integrations.rb
ruby scripts/test_schema_drift.rb
ruby scripts/test_workflows.rb
ruby scripts/test_standards_lib.rb
ruby scripts/test_validate_catalog.rb
ruby scripts/test_validate_integrations.rb
```

Continuous integration runs this list in the order shown. Each command returns:

- `0` when it passes
- `1` when it finds a problem
- `2` when the command is invalid

The validators reject unrecognized options.

They also reject more than 2,048 Markdown, YAML, or JSON input files, any one input over 2 MiB, more than 32 MiB in total, escaped symlinks, YAML deeper than 100 levels, and YAML over 100,000 syntax nodes. These limits are well above the current repository baseline and bound pull-request-controlled work before parsing. Split an intentionally larger corpus or propose a reviewed limit change with measurements and tests.

## Changing the workflow

This repository restricts GitHub Actions to an allowlist. Every action must also be
pinned to a full commit SHA. An action outside the allowlist does not fail a step. The
whole run ends in `startup_failure` without logs, which can look like an unrelated
outage.

Local linting cannot detect this failure because the allowlist belongs to the GitHub
repository settings, not the workflow file.

Before adding an action, check the policy and add the action to `ALLOWED_NON_GITHUB_ACTIONS` in [`scripts/test_workflows.rb`](scripts/test_workflows.rb):

```
gh api repos/raintree-technology/raintree.standards/actions/permissions/selected-actions
```

`ruby scripts/test_workflows.rb` also checks that the commands listed above match the ones the workflow runs, so a new suite cannot be added to one without the other.

## Ruby version

The supported Ruby version is pinned in [`.ruby-version`](.ruby-version) and
[`.tool-versions`](.tool-versions). Both files must name the same version.
`.ruby-version` supports rbenv, chruby, and tools that follow the Ruby convention.
`.tool-versions` supports mise, which continuous integration uses to install Ruby.
`ruby scripts/test_standards_lib.rb` fails if the files disagree.

The validators require Ruby 3.1 or newer. The macOS system Ruby is too old. From the
repository root, run `mise install` or install the pinned version with another version
manager.

Keep changes focused. Preserve existing rule IDs and unknown YAML front-matter fields.
Do not include confidential information, personal data, credentials, or material that
you do not have permission to publish.

By contributing, you represent that you created the contribution or otherwise have the right to submit it. You agree that it may be distributed under the licenses described in [LICENSE.md](LICENSE.md).

## Review

Maintainers review proposals for technical correctness, operational feasibility, unintended incentives, and conflicts with existing rules. A qualified human owner must review high-impact security, legal, privacy, financial, or regulatory standards.

Material public-documentation changes must follow the [documentation accessibility and reader-review policy](governance/documentation-quality.md). Use the [comprehension review](templates/comprehension-review.md) and [independent review](templates/independent-review.md) records when their governing rules apply.

All participation must follow the [Code of Conduct](CODE_OF_CONDUCT.md).
