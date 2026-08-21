---
id: ENGINEERING-JS-QUALITY
title: JavaScript and TypeScript quality with Biome, Trellis, and anti-slop
description: Requires Raintree JavaScript and TypeScript repositories to enforce shared code-quality and type-evidence policy through Biome, Trellis, Oxlint, and anti-slop.
type: standard
status: draft
governance_status: draft
owners: [engineering, security]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [javascript-change, typescript-change, javascript-repository, typescript-repository]
tags: [engineering, javascript, typescript, biome, trellis, oxlint, anti-slop, linting, formatting]
depends_on: [ENGINEERING-QUALITY]
generated: { by: codex/gpt-5, at: "2026-08-17T16:57:33Z" }
sources:
  - id: biome-getting-started
    resource: https://biomejs.dev/guides/getting-started/
    title: Getting Started with Biome
    author: organization:biomejs
  - id: biome-configure
    resource: https://biomejs.dev/guides/configure-biome/
    title: Configure Biome
    author: organization:biomejs
  - id: biome-big-projects
    resource: https://biomejs.dev/guides/big-projects/
    title: Use Biome in big projects
    author: organization:biomejs
  - id: biome-vcs
    resource: https://biomejs.dev/guides/integrate-in-vcs/
    title: Integrate Biome with your VCS
    author: organization:biomejs
  - id: biome-ci
    resource: https://biomejs.dev/recipes/continuous-integration/
    title: Continuous Integration with Biome
    author: organization:biomejs
  - id: biome-cli
    resource: https://biomejs.dev/reference/cli/
    title: Biome CLI reference
    author: organization:biomejs
  - id: biome-formatter
    resource: https://biomejs.dev/formatter/
    title: Biome formatter
    author: organization:biomejs
  - id: biome-linter
    resource: https://biomejs.dev/linter/
    title: Biome linter
    author: organization:biomejs
  - id: biome-assist
    resource: https://biomejs.dev/assist/
    title: Biome Assist
    author: organization:biomejs
  - id: biome-suppressions
    resource: https://biomejs.dev/analyzer/suppressions/
    title: Biome suppressions
    author: organization:biomejs
  - id: biome-editors
    resource: https://biomejs.dev/editors/first-party-extensions/
    title: Biome first-party editor extensions
    author: organization:biomejs
  - id: biome-migration
    resource: https://biomejs.dev/guides/migrate-eslint-prettier/
    title: Migrate from ESLint and Prettier
    author: organization:biomejs
  - id: typescript-no-emit
    resource: https://www.typescriptlang.org/tsconfig/noEmit.html
    title: TypeScript noEmit option
    author: organization:microsoft
  - id: anti-slop-010
    resource: https://github.com/dmmulroy/anti-slop/blob/446268e5d15baa968eaec669ff65358d36ae6259/README.md
    title: anti-slop 0.1.0 README
    author: person:dmmulroy
  - id: oxlint-js-plugins
    resource: https://oxc.rs/docs/guide/usage/linter/js-plugins.html
    title: Oxlint JavaScript plugins
    author: organization:oxc-project
  - id: oxlint-configuration
    resource: https://oxc.rs/docs/guide/usage/linter/config.html
    title: Oxlint configuration
    author: organization:oxc-project
  - id: oxlint-ignore-files
    resource: https://oxc.rs/docs/guide/usage/linter/ignore-files.html
    title: Oxlint ignore files
    author: organization:oxc-project
  - id: oxlint-ignore-comments
    resource: https://oxc.rs/docs/guide/usage/linter/ignore-comments.html
    title: Oxlint inline ignore comments
    author: organization:oxc-project
  - id: oxlint-ci
    resource: https://oxc.rs/docs/guide/usage/linter/ci.html
    title: Oxlint CI and integrations
    author: organization:oxc-project
  - id: oxlint-versioning
    resource: https://oxc.rs/docs/guide/usage/linter/versioning.html
    title: Oxlint versioning policy
    author: organization:oxc-project
  - id: oxlint-automatic-fixes
    resource: https://oxc.rs/docs/guide/usage/linter/automatic-fixes.html
    title: Oxlint automatic fixes
    author: organization:oxc-project
  - id: trellis-030
    resource: https://github.com/raintree-technology/trellis/blob/d2b0f37abce4319c329f363b4cdb541d83d18db9/README.md
    title: Trellis 0.3.0 README
    author: organization:raintree-technology
---

# JavaScript and TypeScript quality with Biome, Trellis, and anti-slop

Raintree-owned JavaScript and TypeScript repositories use Biome as the required formatting and baseline static-analysis entry point and inherit the shared Trellis policy. Repositories with maintained TypeScript also vendor and enforce anti-slop through Oxlint to preserve type evidence and reject low-signal implementation patterns. Repository-specific architecture, framework, accessibility, file-scope, type, and behavior checks remain with the repository that owns them.

## Rules

### ENGINEERING-JS-QUALITY-001 — Inherit the shared Trellis policy

**Level:** required  
**Applies when:** A Raintree-owned repository contains maintained JavaScript or TypeScript source.

Install `@biomejs/biome` and `@raintree-technology/trellis` as exact development dependencies at the repository root. Extend `@raintree-technology/trellis/biome` from the root Biome configuration. Do not copy Trellis configuration or plugins into the consuming repository.

**Why:** One inherited policy keeps objective correctness and security rules consistent while allowing Trellis updates to be reviewed as explicit dependency changes.

**Verify:**

- Inspect the resolved root dependencies and lockfile for exact Biome and Trellis versions.
- Resolve the root Biome configuration and confirm it extends the installed Trellis export.
- Confirm no copied Trellis rules or plugin files are maintained in the consumer.

**Exceptions:** A repository that cannot run Trellis because its supported package-manager layout lacks a physical root `node_modules` directory requires engineering and security owner approval for an equivalent enforced rule set, an owner, and a migration trigger.

### ENGINEERING-JS-QUALITY-002 — Keep Biome and Trellis compatible

**Level:** required  
**Applies when:** Installing or updating Biome or Trellis.

Use the exact Biome version declared by the selected Trellis release's peer dependency. Update the two packages together, review the effective rule and severity changes, and commit the resulting lockfile change.

**Why:** A mismatched analyzer can reject the configuration, interpret it differently, or silently change the diagnostics that policy depends on.

**Verify:**

- Compare the installed Biome version with Trellis's published peer dependency.
- Run the repository's blocking Biome command after a clean dependency install.
- Record new, removed, or severity-changed diagnostics in the dependency-change review.

**Exceptions:** None. A Trellis release that does not support the required Biome version must be upgraded or handled through the exception in `ENGINEERING-JS-QUALITY-001`.

### ENGINEERING-JS-QUALITY-003 — Keep one authoritative root configuration

**Level:** required  
**Applies when:** Configuring Biome in a repository or workspace.

Commit one root `biome.json` or `biome.jsonc` next to the root package manifest. Reference the installed Biome schema, inherit Trellis there, and put shared formatter, linter, assist, VCS, and file-scope settings in that file. Commands and supported editors must resolve the same root configuration.

**Why:** Configuration discovered from a different working directory, user profile, or editor override can produce conflicting results for the same source.

**Verify:**

- Run Biome from the documented repository root and representative package directories and inspect which configuration is resolved.
- Confirm the schema points to the installed Biome package rather than an unpinned web schema.
- Inspect checked editor settings for inline configuration or a conflicting configuration path.

**Exceptions:** A repository without a Node package manifest may keep the root Biome configuration beside its primary build manifest, provided every command and editor workspace resolves it explicitly.

### ENGINEERING-JS-QUALITY-004 — Define owned source and scanner scope

**Level:** required  
**Applies when:** Configuring Biome in a repository or workspace.

Start `files.includes` with a positive owned-scope pattern. Exclude build output, caches, vendored trees, generated artifacts, fixtures that intentionally violate policy, and other files the repository cannot fix at their source. Use ordinary exclusions when project or type rules still need to index an excluded file; use force-ignore exclusions for output or external trees that must not be scanned. Enable Git VCS integration and ignore-file support, but keep material ownership boundaries explicit in Biome configuration.

**Why:** An implicit scope can omit maintained code, scan large output trees, or flood checks with findings in files that must be changed at their source. Overbroad force-ignore rules can also remove type and module information needed to analyze owned code.

**Verify:**

- Compare the effective Biome file set with the repository's maintained source and configuration inventory.
- Sample every ordinary and force-ignore exclusion and trace it to a generator, upstream owner, fixture purpose, cache, or output directory.
- Exercise a project or type-aware rule when one is enabled and confirm required generated declarations and imported source remain indexable.
- Confirm `.gitignore` changes cannot silently remove maintained source from the blocking check without review of `biome.json` and the check output.

**Exceptions:** A generated file that is intentionally hand-maintained is owned source and cannot be excluded as generated.

### ENGINEERING-JS-QUALITY-005 — Inherit root policy in monorepos

**Level:** required  
**Applies when:** A repository contains nested workspaces or package-level Biome configurations.

Install Biome and Trellis at the repository root. Make every nested Biome configuration inherit the root with `"extends": ["//"]` and keep only package-specific scope or policy below it. Run the blocking full check from the root so all owned packages and nested configurations participate.

**Why:** Independent package roots can drift to different Trellis versions, miss shared plugins, or pass locally while the repository as a whole fails.

**Verify:**

- Resolve representative nested configurations and confirm they inherit the root and load Trellis plugins from the root installation.
- Search for nested configurations that behave as independent roots and trace each to an approved repository boundary.
- Run the root check across packages with different local overrides.

**Exceptions:** A vendored project or Git submodule with independent governance must be force-ignored from the parent scanner or governed as a separate repository; it cannot silently shadow the parent policy.

### ENGINEERING-JS-QUALITY-006 — Keep product policy local

**Level:** required  
**Applies when:** A repository has framework, architecture, accessibility, import-boundary, runtime, or file-scope requirements beyond Trellis.

Declare those requirements in the repository's Biome configuration or another checked repository policy. Do not add product-specific rules or exceptions to Trellis merely to share configuration within one product.

**Why:** Trellis can stay broadly applicable only when the repository that owns a contextual constraint also owns its enforcement and exceptions.

**Verify:**

- Trace each applicable repository requirement to an enforced local rule or a documented verification step.
- Confirm local overrides do not disable a Trellis error without an exception approved by engineering and, for a security rule, security.

**Exceptions:** A rule proven objective across more than one repository, with one clear replacement, may be proposed to Trellis and removed locally after the released preset enforces it.

### ENGINEERING-JS-QUALITY-007 — Configure all three Biome tools explicitly

**Level:** required  
**Applies when:** A repository adopts or materially changes its Biome configuration.

Keep the formatter, linter, and assist enabled for their owned supported files. Configure formatting choices in the root file, inherit Trellis's recommended and explicit lint rules, and enable import organization through Assist. Use language or path overrides only where the repository has a concrete constraint.

**Why:** Biome enables these tools by default, but relying on defaults makes tool coverage harder to review and can change behavior when a migration or nested configuration replaces part of the effective configuration.

**Verify:**

- Inspect the effective root and nested configurations for formatter, linter, and assist enablement and scope.
- Change formatting, import order, and a Trellis error in disposable representative files and confirm the expected diagnostics.
- Confirm tool-specific includes do not attempt to re-include files excluded by global `files.includes`.

**Exceptions:** Disable a tool for an owned file type only when another checked tool owns that exact responsibility and the repository records the boundary.

### ENGINEERING-JS-QUALITY-008 — Use the Raintree formatting baseline

**Level:** recommended  
**Applies when:** Creating a repository or intentionally selecting or replacing its formatter conventions.

Use spaces with width 2, a line width of 100, double quotes for JavaScript and JSX, required semicolons, trailing commas where supported, and organized imports. Keep `formatWithErrors` disabled so malformed source is not silently rewritten.

**Why:** A declared baseline removes recurring style decisions and matches the Trellis repository's own maintained source without forcing unrelated format churn during every adoption.

**Verify:**

- Inspect the committed root configuration for the selected values.
- Run the write command on representative JavaScript, TypeScript, JSX, TSX, and JSON fixtures and review the result.

**Exceptions:** An existing repository may preserve established Biome-compatible conventions to avoid a repository-wide formatting diff. Record the deviation and keep it consistent; do not mix conventions by package without a source-format constraint.

### ENGINEERING-JS-QUALITY-009 — Separate read-only gates from write commands

**Level:** required  
**Applies when:** A JavaScript or TypeScript change is reviewed, merged, released, or handed off as complete.

Expose a documented developer gate that runs `biome check` over the full owned scope without writing changes and a continuous-integration gate that runs `biome ci` after a frozen install of the committed lockfile. Invoke the repository-local pinned binary and emit the complete actionable diagnostic set. Error diagnostics must fail; warning diagnostics must remain visible. Keep write mode in a separately named developer command and never run it in the gate.

**Why:** Editor feedback alone is inconsistent, a lint-only command can miss formatting or assist drift, and a floating CI binary can apply a different policy from local development.

**Verify:**

- Run both documented gates and record their exit status against the final revision.
- Introduce a disposable known error in a safe test context and confirm continuous integration or its local equivalent rejects it.
- Confirm the gates do not use `--write`, `--fix`, or otherwise mutate source.
- Confirm continuous integration installs Trellis and the exact Biome peer before resolving the shared configuration.

**Exceptions:** A short-lived adoption rollout may check only changed files when an engineering owner records the full backlog, deadline, blocking expansion stages, and non-regression control.

### ENGINEERING-JS-QUALITY-010 — Control automatic fixes

**Level:** required  
**Applies when:** Applying Biome or plugin fixes to maintained source.

Run safe write actions only from a developer command and inspect the resulting diff. Apply unsafe fixes only to an explicit path or finding set after reviewing the stated semantic change. Run type checks and behavior checks after either class of fix.

**Why:** A fix classification narrows expected risk but does not prove that the change preserves repository-specific behavior or that a plugin rewrite matches the surrounding design.

**Verify:**

- Inspect the exact command, paths, diagnostics, and resulting diff.
- Confirm `--unsafe` was not used across an unreviewed repository-wide scope.
- Run the applicable type, build, test, and final Biome gates after fixes.

**Exceptions:** None for unsafe fixes. A pure formatting-only change may use focused behavior checks when the final formatter and parser gates pass and the diff contains no semantic edits.

### ENGINEERING-JS-QUALITY-011 — Resolve or explain every diagnostic

**Level:** required  
**Applies when:** Biome reports a diagnostic in maintained source changed by the work.

Fix the underlying issue when the rule applies. If the rule does not apply, use the narrowest supported suppression, state the concrete reason beside it, and keep the affected code within ordinary review scope. Do not use blanket file, directory, or rule disablement to make a change pass.

**Why:** Broad or unexplained suppressions hide unrelated future defects and make reviewers guess whether risk was considered.

**Verify:**

- Inspect changed suppressions for a reason, minimum scope, and continued applicability.
- Search configuration changes for disabled Trellis rules and trace each one to an approved exception.
- Confirm fixes did not change behavior outside the reviewed diff.

**Exceptions:** Generated or vendored files are handled by owned-source scope under `ENGINEERING-JS-QUALITY-004`, not inline suppressions.

### ENGINEERING-JS-QUALITY-012 — Keep editor feedback aligned

**Level:** recommended  
**Applies when:** A team uses a supported editor for maintained JavaScript or TypeScript.

Use a Biome-maintained editor extension where available, require the repository configuration, select Biome as the formatter for supported files, and apply only safe fixes and configured Assist actions on save. Do not commit inline editor configuration that weakens repository rules.

**Why:** Fast editor feedback reduces rework, but editor-only overrides can hide failures that reappear in the authoritative command-line gate.

**Verify:**

- Open representative files and compare editor diagnostics and formatting with the repository-local CLI.
- Inspect checked workspace settings for the default formatter, configuration requirement, save actions, and binary or configuration path.
- Confirm no inline editor configuration disables Trellis or repository rules.

**Exceptions:** Unsupported editors may rely on the documented developer gate. Editor setup is never completion evidence by itself.

### ENGINEERING-JS-QUALITY-013 — Preserve coverage during migration

**Level:** required  
**Applies when:** Replacing ESLint, Prettier, import sorting, or another static-analysis or formatting tool with Biome.

Inventory existing rules, plugins, ignores, overrides, scripts, editor settings, and continuous-integration gates before migration. Use Biome migration commands only as a starting artifact, review their output, and retain any check for which Biome and local rules do not provide equivalent coverage. Delete the former configuration only after the new full-scope gates pass and every lost or changed check has a recorded decision.

**Why:** Automated migration can translate settings without reproducing every plugin, option, ignore, or semantic check.

**Verify:**

- Compare the before-and-after rule and scope inventory, including inspired rules and unsupported configuration formats.
- Run the old and new checks on representative valid and invalid fixtures where practical and reconcile differing results.
- Review large formatting changes separately from behavioral changes.
- Confirm package scripts, editor settings, hooks, documentation, and continuous integration no longer invoke a removed tool.

**Exceptions:** A redundant formatter may be removed without fixture comparison when the final source has been formatted and the selected Biome conventions are recorded. Lint or security coverage cannot be dropped without an engineering-owner risk decision.

### ENGINEERING-JS-QUALITY-014 — Keep type and behavior verification separate

**Level:** required  
**Applies when:** A repository contains TypeScript or executable JavaScript behavior.

Do not treat Biome or Trellis as a replacement for the repository's compiler, type check, build, tests, or risk-matched behavior verification. TypeScript repositories must expose and run a no-emit type-check or an equivalent framework compiler check. Run the applicable build and tests independently of the Biome gate.

**Why:** Biome formats and analyzes source and can infer types for selected lint rules, but those diagnostics do not establish full compiler acceptance or runtime behavior.

**Verify:**

- Trace the documented check set to separate Biome, type or compiler, build, and test results.
- Introduce a disposable representative type error that is outside Trellis's rule set and confirm the type gate rejects it.
- Confirm the final handoff does not describe a passing Biome command as proof that behavior tests passed.

**Exceptions:** A JavaScript-only package with no compile step may omit a type gate when its contract and behavior checks cover the supported interface. It cannot omit behavior verification merely because Biome passes.

### ENGINEERING-JS-QUALITY-015 — Use deterministic Trellis handoffs

**Level:** contextual  
**Applies when:** Active Trellis findings are assigned to a coding agent or transferred between reviewers or teams.

Generate a Trellis JSON todo report for the agreed paths and preserve its durable IDs in the work record. Use the repository's blocking Biome command, not report generation, to decide whether the completed change passes policy.

**Why:** A deterministic report makes the active findings explicit and diffable without confusing work tracking with enforcement.

**Verify:**

- Run `trellis todo` for the recorded scope and inspect the report's scope, summary, source locations, rules, and durable IDs.
- Re-run the blocking Biome command after the assigned findings are resolved.
- Reconcile remaining IDs as resolved, accepted through an exception, or still open.

**Exceptions:** An interactive fix by one author with no handoff does not require a todo report.

### ENGINEERING-JS-QUALITY-016 — Vendor anti-slop for TypeScript

**Level:** required  
**Applies when:** A Raintree-owned repository contains maintained TypeScript source.

Copy the anti-slop plugin source into a repository-owned tooling directory, register it as an Oxlint JavaScript plugin, and enable every upstream anti-slop rule at error severity. Record the upstream version or commit and license. Do not depend on anti-slop as a fixed npm package or load it from an unreviewed remote location.

**Why:** anti-slop is designed to be read, adapted, and maintained with the repository. Vendoring makes the exact policy implementation reviewable and prevents an unpublished or moving package from silently changing the gate.

**Verify:**

- Trace the vendored entry point and rule files to the recorded upstream commit.
- Print or resolve the effective Oxlint configuration and confirm all vendored rules are enabled at error severity.
- Confirm the plugin source and its license are committed and the configured path resolves from the root Oxlint configuration.

**Exceptions:** A repository may use an organization-maintained package only after engineering records its source provenance, immutable version, update process, and behavior equivalence to the vendored policy. Omitting anti-slop requires an engineering-owner exception with an equivalent type-evidence gate and a migration trigger.

### ENGINEERING-JS-QUALITY-017 — Pin and qualify the Oxlint plugin runtime

**Level:** required  
**Applies when:** Installing or updating anti-slop, Oxlint, or `@oxlint/plugins`.

Install exact matching versions of `oxlint` and `@oxlint/plugins` as development dependencies and commit the lockfile. Because Oxlint JavaScript plugins are alpha and outside its semantic-versioning guarantees, exercise anti-slop's representative valid and invalid fixtures on every runtime update before accepting the new pair.

**Why:** A patch or minor Oxlint release may change the JavaScript plugin API or behavior without being classified as breaking, even when the core command follows semantic versioning.

**Verify:**

- Compare the two resolved versions and confirm they match exactly.
- Run the vendored plugin's rule fixtures and the repository's full Oxlint gate after a frozen clean install.
- Review new, missing, or changed diagnostics and record the accepted runtime pair.

**Exceptions:** A temporary mismatch requires evidence that the pair is compatible, an owner, and a deadline to restore matching versions. Floating ranges and `latest` are not allowed in the committed dependency manifest or continuous-integration setup.

### ENGINEERING-JS-QUALITY-018 — Keep Oxlint configuration and scope explicit

**Level:** required  
**Applies when:** Configuring anti-slop in a TypeScript repository.

Register the vendored plugin under the stable name `anti-slop` in the root Oxlint or Vite+ configuration. Merge existing ignores and add explicit patterns for dependencies, generated outputs, the vendored plugin, and installed or generated agent-tooling directories. Do not replace existing ignores or ignore every hidden directory. When Vite+ owns the gate, apply the relevant exclusions to both linting and formatting.

**Why:** Linting vendored policy or generated agent assets creates noise, while a broad dot-directory exclusion can hide owned hooks, configuration, tests, or source.

**Verify:**

- Inspect `jsPlugins`, all 15 anti-slop rule severities, `ignorePatterns`, and any Vite+ lint and format sections.
- Use Oxlint's file-debug output or an equivalent inventory to confirm maintained TypeScript is included and only justified tooling paths are excluded.
- In a monorepo, run the root gate and representative nested packages and confirm they resolve the same vendored plugin.

**Exceptions:** A repository with a different established tooling directory may use it when the path is stable and documented. Owned agent hooks or tests remain in scope even when nearby generated assets are ignored.

### ENGINEERING-JS-QUALITY-019 — Gate anti-slop independently

**Level:** required  
**Applies when:** A TypeScript change is reviewed, merged, released, or handed off as complete.

Expose a read-only repository command that runs the pinned Oxlint binary over the full owned TypeScript scope, fails on every anti-slop diagnostic, and reports unused disable directives as errors. Run it after a frozen install in continuous integration and alongside, not instead of, the Biome, type, build, and behavior gates.

**Why:** Biome does not execute Oxlint JavaScript plugins, and a passing anti-slop run cannot establish formatting, full type correctness, or behavior.

**Verify:**

- Run the documented command against the final revision and record its exit status.
- Introduce a disposable known anti-slop violation and an unused disable directive and confirm each makes the gate fail.
- Confirm the gate does not use `--fix`, `--fix-suggestions`, `--fix-dangerously`, rule-severity overrides, or `--no-ignore`.

**Exceptions:** A short-lived adoption rollout may bound the checked source when an engineering owner records the complete finding baseline, non-regression control, expansion stages, and deadline.

### ENGINEERING-JS-QUALITY-020 — Preserve type evidence when resolving findings

**Level:** required  
**Applies when:** anti-slop reports a finding in maintained source.

Resolve findings by preserving inference, using `as const` or `satisfies`, defining named owner contracts, parsing untrusted values at I/O boundaries, and replacing module mocks or reflective access with explicit dependency seams and typed interfaces. Do not silence a finding by widening a value, adding `any`, `unknown`, `object`, `{}`, a chained assertion, an unchecked cast, or an alias that conceals the same uncertainty.

**Why:** Mechanical type laundering changes the syntax that the rule sees without adding evidence that the value satisfies the claimed contract.

**Verify:**

- Trace each changed assertion or boundary conversion to a parser, validator, constructor, invariant, or owner-provided contract.
- Confirm `SAFETY:` comments name the checked invariant rather than restating the asserted type.
- Review test changes for real dependency injection or test seams instead of hidden module replacement.
- Run type, behavior, Biome, and Oxlint gates after the remediation.

**Exceptions:** A real dynamic boundary that cannot be expressed within an upstream rule requires the narrowest Oxlint directive, an adjacent concrete explanation, and an engineering-owner decision. Schema-free projects may enable `allowInTypeGuards` for `no-runtime-typeof`; if the guard itself needs an `unknown` input, document the paired narrow exception rather than weakening either rule globally.

### ENGINEERING-JS-QUALITY-021 — Maintain the vendored policy as owned code

**Level:** required  
**Applies when:** Updating or changing vendored anti-slop source.

Compare the current vendored source, local modifications, and candidate upstream revision before replacement. Preserve intentional local behavior, add focused rule tests for semantic changes, keep product-specific rules in a separate plugin, and update provenance only after the final vendored artifact passes its tests and repository gates.

**Why:** Blindly recopying upstream can erase local policy or introduce new diagnostics, while untested local edits turn a release gate into unverified application code.

**Verify:**

- Review a three-way comparison or equivalent record of current upstream, local policy, and candidate upstream source.
- Run every vendored rule's valid and invalid fixtures plus focused tests for local changes.
- Confirm the configuration, rule inventory, documentation, provenance record, and vendored implementation agree.

**Exceptions:** A byte-for-byte upstream refresh needs no new local test when the upstream suite is present and passes against the pinned runtime; it still requires diagnostic review and provenance update.

### ENGINEERING-JS-QUALITY-022 — Expose one layered quality workflow

**Level:** required  
**Applies when:** A repository configures its developer and continuous-integration commands.

Expose one read-only developer command that runs the applicable Biome with Trellis, anti-slop, type, and focused behavior checks. Keep each layer available as a directly runnable named command. Expose a full continuous-integration command or equivalent separately reported jobs that run the final Biome CI gate, anti-slop, type checking, full tests, and the production build when the repository has one. Keep the write command separate and limit it to reviewed Biome formatting and safe fixes.

**Why:** One entry point makes the required path easy to remember, while named layers preserve clear failures, focused reruns, and ownership. A write action inside the shared gate would make results depend on an unreviewed mutation.

**Verify:**

- Run the developer entry point and confirm every applicable named layer executes without changing the worktree.
- Fail each layer with a disposable representative defect and confirm the output identifies the responsible command.
- Run the continuous-integration entry point or inspect its jobs and confirm it adds full tests and the production build where applicable.
- Run the write command on a disposable formatting defect and confirm it does not apply unsafe Biome or Oxlint fixes.

**Exceptions:** JavaScript-only repositories omit anti-slop and TypeScript compiler stages. Repositories with slow behavior suites may keep focused tests out of the fast local command when continuous integration runs the full suite and the local command names the deferred check.

### ENGINEERING-JS-QUALITY-023 — Give overlapping diagnostics one owner

**Level:** required  
**Applies when:** Two configured tools report the same underlying defect or policy concern.

Compare the tools' scope, semantics, severity, diagnostic quality, fix safety, and stability. Keep one authoritative diagnostic when the checks are materially equivalent; keep both only when each detects distinct cases or supplies necessary evidence. Record the ownership decision beside the affected configuration. Do not disable a required Trellis or anti-slop rule merely to remove duplicate output unless the remaining gate has documented equivalent or stronger coverage and the applicable exception is approved.

**Why:** Permanent duplicate diagnostics add noise without adding evidence, but removing a superficially similar rule can create a coverage gap when its actual matching behavior differs.

**Verify:**

- Exercise representative shared and tool-specific fixtures before changing either rule.
- Compare the effective configurations and resulting diagnostics after the change.
- Confirm the retained owner runs in both the developer workflow and continuous integration.
- Review disabled rules and severity changes against their recorded equivalence evidence and exception.

**Exceptions:** Duplicate diagnostics may remain during a time-bounded migration when the owner, removal condition, and deadline are recorded.

## Guidance

For Trellis 0.3.0, install `@raintree-technology/trellis@0.3.0` with its exact `@biomejs/biome@2.5.6` peer. Do not substitute the newest Biome release until Trellis declares it compatible.

```sh
bun add --dev --exact @raintree-technology/trellis@0.3.0 @biomejs/biome@2.5.6
```

Start a new single-package repository with an explicit root configuration:

```json
{
  "$schema": "./node_modules/@biomejs/biome/configuration_schema.json",
  "extends": ["@raintree-technology/trellis/biome"],
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true,
    "defaultBranch": "main"
  },
  "files": {
    "ignoreUnknown": true,
    "includes": ["**", "!!**/dist", "!!**/build", "!!**/coverage"]
  },
  "formatter": {
    "enabled": true,
    "formatWithErrors": false,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 100
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "double",
      "jsxQuoteStyle": "double",
      "semicolons": "always",
      "trailingCommas": "all"
    }
  },
  "linter": {
    "enabled": true
  },
  "assist": {
    "enabled": true,
    "actions": {
      "source": {
        "organizeImports": "on"
      }
    }
  }
}
```

Replace the example output exclusions with the repository's actual outputs. Add ordinary exclusions for generated source that type-aware or project rules still need to index. Do not copy an example exclusion without confirming the path is unowned.

Keep the layers directly runnable and provide one read-only developer entry point. Replace the package-manager spelling and test or build commands with the repository's established equivalents:

```json
{
  "scripts": {
    "check:biome": "biome check --max-diagnostics=none .",
    "check:biome:ci": "biome ci --max-diagnostics=none .",
    "check:anti-slop": "oxlint --report-unused-disable-directives-severity error .",
    "check:types": "tsc --noEmit",
    "check:tests": "test-runner --changed",
    "check:tests:ci": "test-runner",
    "check:build": "build-command",
    "check": "pnpm run check:biome && pnpm run check:anti-slop && pnpm run check:types && pnpm run check:tests",
    "check:ci": "pnpm run check:biome:ci && pnpm run check:anti-slop && pnpm run check:types && pnpm run check:tests:ci && pnpm run check:build",
    "check:write": "biome check . --write"
  }
}
```

The type-check command may instead call the framework or workspace compiler that owns the complete TypeScript project. JavaScript-only repositories omit the anti-slop and type layers. If the test runner has no safe changed-test mode, use the repository's normal focused suite or name the omitted full-suite command in local output. Continuous integration may invoke the named leaf commands as separate jobs instead of chaining `check:ci`; this is preferred when it preserves all results after one layer fails.

For anti-slop commit `446268e5d15baa968eaec669ff65358d36ae6259`, copy the canonical `src/` tree to `tools/oxlint/anti-slop/`. At the August 17, 2026 review, the current matching runtime pair was `oxlint@1.78.0` and `@oxlint/plugins@1.78.0`. Query the registry again at adoption or update time, then pin the reviewed pair exactly.

```sh
pnpm add --save-dev --save-exact oxlint@1.78.0 @oxlint/plugins@1.78.0
```

Merge anti-slop into the repository's existing Oxlint configuration rather than replacing it:

```ts
import { defineConfig } from "oxlint";

export default defineConfig({
  ignorePatterns: [
    "node_modules/**",
    "dist/**",
    "build/**",
    "coverage/**",
    ".agent/**",
    ".agents/**",
    ".claude/**",
    ".codex/**",
    ".continue/**",
    ".cursor/**",
    ".gemini/**",
    ".opencode/**",
    ".pi/**",
    ".roo/**",
    ".windsurf/**",
    "tools/oxlint/anti-slop/**",
  ],
  jsPlugins: [
    { name: "anti-slop", specifier: "./tools/oxlint/anti-slop/index.ts" },
  ],
  options: {
    reportUnusedDisableDirectives: "error",
  },
  rules: {
    "anti-slop/no-chained-type-assertions": "error",
    "anti-slop/no-conditional-empty-object-spread": "error",
    "anti-slop/no-known-value-widening": "error",
    "anti-slop/no-module-mocking": "error",
    "anti-slop/no-object-parameters": "error",
    "anti-slop/no-reflect-apply": "error",
    "anti-slop/no-reflect-get": "error",
    "anti-slop/no-runtime-typeof": "error",
    "anti-slop/no-shape-in-symbol-names": "error",
    "anti-slop/no-unknown-parameters": "error",
    "anti-slop/no-unknown-returns": "error",
    "anti-slop/no-unknown-type-aliases": "error",
    "anti-slop/no-unsafe-dictionary-type": "error",
    "anti-slop/no-widen-then-assert": "error",
    "anti-slop/require-safety-comment-for-type-assertion": "error",
  },
});
```

Replace the example output exclusions with the repository's actual dependency and generated-output paths. Add other agent-tooling paths only when they exist and are not maintained application source. A TypeScript Oxlint configuration requires the Node-based package and a supported Node runtime; use the repository's established JSON configuration when that runtime boundary cannot be met. In Vite+, merge the same plugin and rules into `lint`, and merge the relevant tooling exclusions into both `lint.ignorePatterns` and `fmt.ignorePatterns`.

anti-slop 0.1.0 has this policy surface:

| Rule | Required direction |
|---|---|
| `no-chained-type-assertions` | Preserve the precise type or parse the boundary value once. |
| `no-conditional-empty-object-spread` | Construct optional fields without an empty-object branch. |
| `no-known-value-widening` | Keep inference, use `satisfies`, or use a named owner contract. |
| `no-module-mocking` | Replace dependencies through real interfaces and injected seams. |
| `no-object-parameters` | Accept a named input type after boundary parsing. |
| `no-reflect-apply` | Call a typed function or model dispatch behind an interface. |
| `no-reflect-get` | Use typed property access or parse dynamic input. |
| `no-runtime-typeof` | Decode external values at the I/O boundary; use the type-guard option only for a reviewed schema-free boundary. |
| `no-shape-in-symbol-names` | Name the domain concept rather than its incidental structural shape. |
| `no-unknown-parameters` | Parse before calling owned functions; `cause` is the upstream named exception. |
| `no-unknown-returns` | Return a parsed named domain type. |
| `no-unknown-type-aliases` | Keep uncertainty visible at the boundary rather than hiding it behind an alias. |
| `no-unsafe-dictionary-type` | Use a schema- or owner-derived dictionary value type. |
| `no-widen-then-assert` | Preserve known evidence from initialization through use. |
| `require-safety-comment-for-type-assertion` | State the checked invariant in a nearby `SAFETY:` comment. |

Oxlint JavaScript plugins do not currently support rules that rely on TypeScript type awareness. anti-slop therefore detects its documented syntax and local-flow patterns; it does not prove that all values satisfy their declared types. Keep the independent TypeScript compiler and behavior gates required by `ENGINEERING-JS-QUALITY-014`.

Trellis 0.3.0 has this effective policy surface:

| Policy | Severity |
|---|---|
| Biome recommended correctness and security rules | Biome defaults, including blocking `noGlobalEval` |
| Explicit `any` and parameter reassignment | Error |
| TLS verification disabled through covered Node.js forms (`RT006`) | Error |
| Implied dynamic execution through `Function` or string timers (`RT005`) | Warning while the nursery rule is audited |
| Non-null assertions | Warning |
| Cognitive complexity above 25 | Warning |
| More than 150 nonblank lines per function | Warning |
| More than 500 nonblank lines per file | Warning |
| More than 5 function parameters | Warning |

Trellis errors cover objective shortcuts with direct replacements. Its warnings point to structural debt that needs judgment. A warning is not proof that code must be split, but it is evidence to inspect before adding more complexity. Do not turn warnings off globally because one instance is reasonable. A repository may promote a warning after triaging its existing scope. Do not use `--error-on-warnings` as a substitute for choosing and reviewing rule severities.

By default, `trellis todo` reports only Trellis diagnostics. Use `--all` only when the handoff is intended to include local Biome rules too. Report generation exits successfully even when error-level todos exist; only the blocking Biome command decides conformance.

For an existing repository with a large backlog, first capture the baseline, prevent new violations in changed source, and publish staged expansion to the full owned scope. The temporary boundary must not become an unowned permanent exclusion.

## Examples

### Shared and local policy

Non-compliant: Copy the Trellis rule object into `biome.json`, delete rules that create migration work, and let each package install a different Biome version.

Compliant: Pin the root Trellis release and its exact Biome peer, extend the package export once, define generated-file exclusions and framework import boundaries locally, and let nested packages inherit the root configuration.

### Narrow suppression

Non-compliant: Disable `noImpliedEval` for the repository because one reviewed sandbox adapter constructs a function.

Compliant: Keep the shared rule active and place a reasoned `biome-ignore` suppression on the one reviewed expression after confirming the sandbox boundary and safer replacements.

### Migration coverage

Non-compliant: Run the ESLint and Prettier migration commands, delete both old configurations, and accept the new passing Biome check without comparing plugin coverage or ignored files.

Compliant: Inventory old rules and scope, review the generated Biome configuration, retain checks without an equivalent, compare representative findings, isolate the formatting diff, and remove old commands only after local and continuous-integration gates use the pinned repository binary.

### Type evidence

Non-compliant: Change a known value to `unknown`, pass it through an `unknown` alias, and cast it back to the desired type so a local diagnostic disappears.

Compliant: Keep the inferred type when the value is owned, use `satisfies` to check a declared contract without widening, and parse untrusted input into a named domain type at the boundary.

### Test seams

Non-compliant: Replace a module at runtime or use reflective access to make a test reach private behavior.

Compliant: Pass the dependency through a typed interface, test observable behavior, and keep the real implementation selectable through normal construction.

### Vendored updates

Non-compliant: Replace the anti-slop directory from the upstream default branch and update provenance without reviewing changed diagnostics.

Compliant: Compare the recorded upstream revision, local modifications, and candidate revision; run all valid and invalid rule fixtures with the pinned Oxlint pair; review diagnostic changes; then update the vendored source and provenance together.

### Layered commands

Non-compliant: Require contributors to remember unrelated tool commands, let the editor apply fixes during verification, and collapse CI output into one unlabeled failure.

Compliant: Make `check` a read-only composition of named fast layers, keep `check:write` explicit, and run the full named layers as separately reported CI jobs or through `check:ci`.

### Overlap ownership

Non-compliant: Disable one of two similarly named rules after seeing a duplicate diagnostic in a single file.

Compliant: Exercise shared and tool-specific fixtures, compare actual matching behavior, retain one owner only when coverage is equivalent, and record the decision beside the configuration.

## Sources

- Biome, [Getting Started](https://biomejs.dev/guides/getting-started/), [Configure Biome](https://biomejs.dev/guides/configure-biome/), and [Use Biome in big projects](https://biomejs.dev/guides/big-projects/). Reviewed August 17, 2026 against website commit `033bb7a1bc4d8f0623cc6e9bf72cde2ff7bdfb92`.
- Biome, [VCS integration](https://biomejs.dev/guides/integrate-in-vcs/), [Continuous Integration](https://biomejs.dev/recipes/continuous-integration/), and [CLI reference](https://biomejs.dev/reference/cli/). Reviewed August 17, 2026.
- Biome, [Formatter](https://biomejs.dev/formatter/), [Linter](https://biomejs.dev/linter/), [Assist](https://biomejs.dev/assist/), and [Suppressions](https://biomejs.dev/analyzer/suppressions/). Reviewed August 17, 2026.
- Biome, [First-party editor extensions](https://biomejs.dev/editors/first-party-extensions/) and [Migrate from ESLint and Prettier](https://biomejs.dev/guides/migrate-eslint-prettier/). Reviewed August 17, 2026.
- Microsoft, [TypeScript `noEmit`](https://www.typescriptlang.org/tsconfig/noEmit.html). Reviewed August 17, 2026.
- Raintree Technology, [Trellis 0.3.0 README](https://github.com/raintree-technology/trellis/blob/d2b0f37abce4319c329f363b4cdb541d83d18db9/README.md), commit `d2b0f37abce4319c329f363b4cdb541d83d18db9`. Reviewed August 17, 2026.
- Dylan Mulroy, [anti-slop 0.1.0 README](https://github.com/dmmulroy/anti-slop/blob/446268e5d15baa968eaec669ff65358d36ae6259/README.md), commit `446268e5d15baa968eaec669ff65358d36ae6259`. Reviewed August 17, 2026.
- Oxc, [JavaScript plugins](https://oxc.rs/docs/guide/usage/linter/js-plugins.html), [configuration](https://oxc.rs/docs/guide/usage/linter/config.html), and [ignored files](https://oxc.rs/docs/guide/usage/linter/ignore-files.html). Reviewed August 17, 2026.
- Oxc, [inline ignore comments](https://oxc.rs/docs/guide/usage/linter/ignore-comments.html), [continuous integration](https://oxc.rs/docs/guide/usage/linter/ci.html), [versioning](https://oxc.rs/docs/guide/usage/linter/versioning.html), and [automatic fixes](https://oxc.rs/docs/guide/usage/linter/automatic-fixes.html). Reviewed August 17, 2026.
