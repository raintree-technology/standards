---
type: Guide
title: Contributing
description: Process and requirements for contributing to raintree.standards.
tags: [contributing, governance]
generated: { by: codex/gpt-5, at: "2026-08-16T23:26:21Z" }
---

# Contributing

raintree.standards accepts corrections, clarifications, and proposals for recurring requirements. Read the [standards contribution requirements](governance/contributing.md) before preparing a change.

## Propose a change

1. Search existing issues and standards for the same concern.
2. Open an issue that describes the recurring decision or risk, affected readers, and expected outcome.
3. For a new standard, start with [`templates/standard.md`](templates/standard.md). For a new task profile, start with [`templates/profile.md`](templates/profile.md).
4. Update [`catalog.yaml`](catalog.yaml) when you add, move, or retire a governed document or profile.
5. Run the checks below from the repository root.
6. Before a versioned release, run `ruby scripts/validate_catalog.rb --release` and resolve every draft, verification, and dependency blocker. The library is pre-v1, so this command currently reports blockers by design.
7. Open a pull request that explains what changed, why it is needed, and what you verified.

## Run the checks

The validators use only the Ruby standard library. There is no bundle to install.

```
ruby scripts/validate_catalog.rb
ruby scripts/validate_integrations.rb
ruby scripts/test_schema_drift.rb
ruby scripts/test_workflows.rb
ruby scripts/test_standards_lib.rb
ruby scripts/test_validate_catalog.rb
ruby scripts/test_validate_integrations.rb
```

Continuous integration runs exactly this list, in this order. Each command exits 0 when it passes, 1 when it finds a problem, and 2 when it is invoked incorrectly. Unrecognised options are rejected rather than ignored.

## Changing the workflow

This repository restricts GitHub Actions to an allowlist and requires every action to be pinned to a full commit SHA. An action outside the allowlist does not fail a step: the whole run ends in `startup_failure` with no logs, which is easy to mistake for an unrelated outage. Local linting cannot detect it, because the policy lives on the repository rather than in the workflow file.

Before adding an action, check the policy and add the action to `ALLOWED_NON_GITHUB_ACTIONS` in [`scripts/test_workflows.rb`](scripts/test_workflows.rb):

```
gh api repos/raintree-technology/raintree.standards/actions/permissions/selected-actions
```

`ruby scripts/test_workflows.rb` also checks that the commands listed above match the ones the workflow runs, so a new suite cannot be added to one without the other.

## Ruby version

The supported interpreter is pinned in [`.ruby-version`](.ruby-version) and [`.tool-versions`](.tool-versions). Both name the same version: `.ruby-version` for rbenv, chruby, and other tools following the Ruby convention, and `.tool-versions` for mise, which is what CI installs from. `ruby scripts/test_standards_lib.rb` fails if the two disagree.

The validators require Ruby 3.1 or newer and refuse to run on anything older; the macOS system Ruby is too old. Install the pinned version with `mise install` from the repository root, or with the version manager you already use.

Keep changes focused. Preserve existing rule IDs and unknown YAML front-matter fields. Do not include confidential information, personal data, credentials, or material that you do not have permission to publish.

By contributing, you agree that your contribution may be distributed under the licenses described in [LICENSE.md](LICENSE.md).

## Review

Maintainers review proposals for technical correctness, operational feasibility, unintended incentives, and conflicts with existing rules. A qualified human owner must review high-impact security, legal, privacy, financial, or regulatory standards.

All participation must follow the [Code of Conduct](CODE_OF_CONDUCT.md).
