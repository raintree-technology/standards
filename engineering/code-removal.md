---
id: ENGINEERING-CODE-REMOVAL
title: Safe code removal
description: Requirements for finding and removing unused code and dependencies with Knip, Ruff, deptry, and contextual Vulture evidence without breaking supported behavior.
type: standard
status: draft
governance_status: draft
release_target: post-v1
owners: [engineering]
last_reviewed: 2026-08-17
review_by: 2026-11-17
stale_after: 2026-11-17
applies_to: [code-removal, dead-code-removal, dependency-cleanup]
tags: [engineering, cleanup, dead-code, dependencies, knip, ruff, deptry, vulture]
depends_on: [FND-EVIDENCE, FND-CHANGE, ENGINEERING-QUALITY, AGENT-VERIFICATION, ENGINEERING-JS-QUALITY]
generated: { by: codex/gpt-5, at: "2026-08-17T08:39:18Z" }
sources:
  - id: knip-first-cleanup
    resource: https://knip.dev/overview/first-cleanup
    title: Your First Cleanup
    author: organization:knip
  - id: knip-configuring-project-files
    resource: https://knip.dev/guides/configuring-project-files
    title: Configuring Project Files
    author: organization:knip
  - id: knip-production-mode
    resource: https://knip.dev/features/production-mode
    title: Production Mode
    author: organization:knip
  - id: knip-handling-issues
    resource: https://knip.dev/guides/handling-issues
    title: Resolve reported issues
    author: organization:knip
  - id: knip-monorepos
    resource: https://knip.dev/features/monorepos-and-workspaces
    title: Monorepos and Workspaces
    author: organization:knip
  - id: knip-auto-fix
    resource: https://knip.dev/features/auto-fix
    title: Auto-fix
    author: organization:knip
  - id: knip-ci
    resource: https://knip.dev/guides/using-knip-in-ci
    title: Using Knip in CI
    author: organization:knip
  - id: ruff-configuration
    resource: https://docs.astral.sh/ruff/configuration/
    title: Configuring Ruff
    author: organization:astral
  - id: ruff-linter
    resource: https://docs.astral.sh/ruff/linter/
    title: The Ruff Linter
    author: organization:astral
  - id: ruff-unused-import
    resource: https://docs.astral.sh/ruff/rules/unused-import/
    title: unused-import (F401)
    author: organization:astral
  - id: ruff-unused-variable
    resource: https://docs.astral.sh/ruff/rules/unused-variable/
    title: unused-variable (F841)
    author: organization:astral
  - id: python-import-system
    resource: https://docs.python.org/3/reference/import.html
    title: The import system
    author: organization:python-software-foundation
  - id: pypa-entry-points
    resource: https://packaging.python.org/en/latest/specifications/entry-points/
    title: Entry points specification
    author: organization:python-packaging-authority
  - id: deptry-rules
    resource: https://deptry.com/rules-violations/
    title: Rules and Violations
    author: organization:deptry
  - id: deptry-usage
    resource: https://deptry.com/usage/
    title: Usage and Configuration
    author: organization:deptry
  - id: vulture-216
    resource: https://github.com/jendrikseipp/vulture/blob/v2.16/README.md
    title: Vulture 2.16 README
    author: person:jendrik-seipp
---

# Safe code removal

Unused code and dependencies should be removed only after static findings are reconciled with the repository's real entry points, public contracts, runtime loading, side effects, and final verification.

## Rules

### ENGINEERING-CODE-REMOVAL-001 — Define the reachable surface before deleting

**Level:** required  
**Applies when:** A cleanup may remove a file, export, symbol, import, dependency, script, command, or registration.

Identify the repository scope, runtime and development entry points, published package surfaces, package-manager workspaces, generated sources, tests, scripts, framework conventions, plugins, dynamic imports, reflection, configuration references, environment-selected implementations, import-time registrations, and side-effect imports that can make code reachable. Include non-code consumers such as deployment definitions, templates, documentation examples that are tested or supported, and external callers. Configure the analysis tools to represent that surface before accepting their findings.

**Why:** Static analysis produces unsafe removal candidates when its project graph omits real consumers or implicit entry points.

**Verify:**

- Record the analyzed workspaces, entry and project patterns, enabled plugins and rules, generated prerequisites, public package surfaces, and known implicit or external consumers.
- Resolve configuration hints and unexpected unresolved imports before treating downstream unused findings as evidence.

**Exceptions:** An intentionally bounded local cleanup may document the excluded surfaces and prove that the removed item cannot be reached from them.

### ENGINEERING-CODE-REMOVAL-002 — Treat unused findings as candidates, not proof

**Level:** required  
**Applies when:** Knip, Ruff, or another static tool reports an item as unused.

Inspect the reported item and its consumers before deletion. Check public exports, package manifests and entry-point metadata, command and script references, string-based lookup, dependency injection, decorators, registration hooks, import-time effects, optional and platform-specific integrations, type-only consumers, serialized names, migrations and rollback paths, and external callers that the tool may not observe. Distinguish an unused implementation from a required interface placeholder, compatibility shim, feature-flag fallback, or emergency recovery path.

**Why:** Absence from a static graph does not prove absence from runtime behavior or a supported contract.

**Verify:**

- Trace the candidate through source search, manifests, lockfiles, configuration, generated artifacts, release packages, and supported public interfaces.
- Record why the finding is removable, a configuration gap, or an intentional exception.

**Exceptions:** None.

### ENGINEERING-CODE-REMOVAL-003 — Use Knip for TypeScript and JavaScript reachability

**Level:** recommended  
**Applies when:** Cleanup includes TypeScript or JavaScript files, exports, types, dependencies, binaries, or workspace packages.

Use Knip as the default repository-level unused-code analyzer. Start without custom configuration to inspect detected defaults and plugins, then make targeted `entry` and `project` corrections. In a workspace repository, validate every package and the root workspace; root-level `entry` and `project` settings do not configure the workspace named `.`. Generate required artifacts before analysis and account for path aliases, scripts, non-standard file compilers, and dynamic imports.

Run the ordinary analysis and a separate production analysis when shipped code differs from tests or tooling. Use strict production mode for a workspace or published package when direct dependency isolation, peer dependencies, and consumer-facing types are in scope; generate the declaration outputs that strict analysis needs. Exercise or represent relevant configuration modes when environment-dependent configuration loads optional tools or dependencies. Do not use entry-export analysis to remove a published export solely because the repository does not consume it; `includeEntryExports` is suitable only when the repository is self-contained or private, or when an approved compatibility decision covers the export. Address findings in dependency order, starting with configuration hints and unused files, then unresolved imports, exports and types, binaries, and dependencies. Use trace output for surprising results and narrow ignore settings only after documenting why the real usage cannot be represented.

**Why:** Knip models files, exports, types, dependencies, binaries, and workspace entry points together; configuration and analysis order determine whether that graph matches the project.

**Verify:**

- Preserve the pinned Knip version, configuration, workspace scope, generated prerequisites, and exact commands used in the cleanup evidence.
- Record ordinary, production, and applicable strict results separately; a test or story import must not be presented as proof of production reachability.
- Rerun uncached final analysis after manifest, workspace, or ignore-file changes when cached or watch results may be stale.

**Exceptions:** Use an equivalent repository-level analyzer when Knip cannot support the project's language, module system, or framework. Record the coverage difference and reason.

### ENGINEERING-CODE-REMOVAL-004 — Use Ruff only for the Python findings it can prove

**Level:** recommended  
**Applies when:** Cleanup includes Python imports, local variables, arguments, loop bindings, or suppression comments.

Use the repository's pinned Ruff version and repository-owned configuration; do not allow an unrecorded user-level configuration to determine the result. Confirm the analyzed file scope, exclusions, target Python version, preview setting, selected rules, per-file ignores, and dummy-variable convention. At minimum, assess `F401` for unused imports and `F841` for unused local variables. Include stable rules such as `F811`, `F842`, `B007`, the `ARG` family, and `RUF100` when their semantics match the project; consider `RUF059` only when the selected Ruff version treats it as appropriate for the project.

Review every unsafe fix and every change to `__init__.py`, `__all__`, import-time behavior, intentional re-exports, abstract or protocol signatures, framework callbacks, fixtures, dependency-injection hooks, and positional or keyword compatibility. A leading underscore records intentional non-use; it does not prove an argument can be removed. Do not present Ruff as proof that a module, class, function, method, command entry point, plugin, or dependency is unreachable across the repository.

**Why:** Ruff can prove specific unused bindings, but Python imports and public surfaces may execute behavior or serve consumers outside Ruff's local analysis.

**Verify:**

- Record the Ruff version, configuration path and resolution, selected and ignored rules, file scope, command, and diagnostics before and after the cleanup.
- Inspect retained `noqa`, per-file ignores, dummy-variable conventions, re-exports, interface-required arguments, preview rules, and safe or unsafe fix decisions.

**Exceptions:** Use the project's existing Python analyzer when it provides equivalent diagnostics and recorded configuration. State which Ruff rule coverage is absent.

### ENGINEERING-CODE-REMOVAL-005 — Remove in bounded changes and verify the final graph

**Level:** required  
**Applies when:** One or more removal candidates have been classified as removable.

Delete the smallest coherent set, update direct references, documentation, configuration, permissions, telemetry, manifests, and ownership records, and preserve supported public behavior unless an approved compatibility process governs its removal. Remove package dependencies with the repository's package manager so manifests, catalogs, and lockfiles agree. Do not remove retained data, schema, credentials, feature flags, fallback paths, or operational signals merely because their current code reader was deleted; route those lifecycle changes through their applicable standards.

Treat automatic fixes as proposed edits. For Knip, inspect a trustworthy report before `--fix`, limit `--fix-type` to the approved category, and require exact approval before `--allow-remove-files`. Inspect CommonJS and export assignments for right-hand-side effects. For Ruff, review a diff before writing and do not apply unsafe fixes in bulk; even safe fixes require final behavior checks. Run the affected tests, type checks, builds, package or application startup checks, import smoke tests, and repository-specific validation against the final diff. Rerun the unused-code analysis after each material group because removing one node can expose another.

**Why:** Removal failures often appear only during packaging, startup, plugin discovery, import execution, or a later stage of the dependency graph.

**Verify:**

- Inspect the final diff for unintended edits, orphaned configuration, stale documentation, package and lockfile consistency, software bills of materials and third-party notices, altered public surfaces, lost comments, and removed side effects.
- Record final tool output, behavior checks, remaining findings, intentional suppressions, compatibility decisions, and recovery path.

**Exceptions:** A check that cannot run requires a recorded reason, affected claim, risk owner, and alternate evidence. Do not claim the unrun check passed.

### ENGINEERING-CODE-REMOVAL-006 — Keep exceptions narrow and attributable

**Level:** required  
**Applies when:** A reported item is retained or an analysis result is suppressed.

Use the narrowest supported configuration or inline exception. Record the hidden finding, reason, affected scope, owner, and condition or date for review. Do not disable an issue category for the whole repository to hide one unexplained result.

**Why:** Broad suppressions turn later regressions into invisible debt and make a clean report misleading.

**Verify:**

- Review ignore patterns, per-file exclusions, inline suppressions, entry overrides, and allowlists for scope and rationale.
- Confirm the final report distinguishes resolved findings from accepted exceptions.

**Exceptions:** Generated or vendor-owned files may use pattern-level exclusions when their boundary and regeneration source are explicit.

### ENGINEERING-CODE-REMOVAL-007 — Ratchet a trustworthy baseline

**Level:** recommended  
**Applies when:** A repository will continue to use Knip, Ruff, deptry, Vulture, or an equivalent analyzer after the cleanup, or an existing backlog prevents a clean first run.

After the analysis graph and rule scope are trustworthy, enforce the cleaned scope in continuous integration. A legacy backlog may be adopted by issue type, workspace, production scope, or a non-increasing issue budget. Keep unresolved categories visible as warnings or recorded backlog; do not report a passing non-zero budget or `--no-exit-code` run as a clean result. Tighten the gate as findings are resolved, and make configuration hints blocking once the configuration is owned and stable.

**Why:** A one-time cleanup decays, while an unexplained baseline can normalize false positives or let new dead code hide in existing debt.

**Verify:**

- Record the blocking command, pinned tool version, gated scopes and issue types, current budget or warning set, owner, and next tightening milestone.
- Seed or identify a safe known finding and confirm the gate rejects a new issue in a cleaned scope.
- Confirm final reports distinguish tool failure from findings and clean results from accepted backlog.

**Exceptions:** A repository that does not retain the analyzer must assign an equivalent recurring check or record why recurrence risk is accepted and by whom.

### ENGINEERING-CODE-REMOVAL-008 — Use deptry for Python dependency classification

**Level:** recommended  
**Applies when:** Python cleanup may add, remove, retain, or reclassify a runtime, optional, development, or transitive dependency.

Use a pinned deptry version in the project's own environment to compare imported modules with the repository's authoritative dependency declarations. Configure the correct source roots, dependency file, regular and development groups, optional groups, notebooks, and per-rule exceptions. Assess `DEP001` missing dependencies, `DEP002` unused runtime dependencies, `DEP003` transitive dependencies used directly, `DEP004` development dependencies used by runtime code, and `DEP005` packages that duplicate the standard library.

Treat every result as a classification task. An undeclared or transitive dependency usually needs to be declared directly, not removed. A package with no ordinary import may still be required by an entry point, plugin loader, binary, data file, environment marker, optional feature, build backend, or import-name mapping that deptry cannot infer. Development dependencies are outside `DEP002`, so a clean result does not prove that development tooling is used.

**Why:** Ruff does not reconcile imports with dependency metadata, and a source import alone cannot distinguish missing, transitive, misplaced, optional, or dynamically loaded packages.

**Verify:**

- Record the deptry version, environment, dependency source, source roots, group classification, notebook scope, configuration, exceptions, and results.
- Trace every proposed removal through entry points, plugin and binary configuration, build metadata, optional features, environment markers, import-to-distribution mapping, manifests, and lockfiles.
- After a dependency change, rebuild or synchronize the environment and run clean installation, import, packaging, startup, and affected behavior checks.

**Exceptions:** Use an equivalent dependency analyzer when it covers the repository's package manager and dependency groups. Record missing deptry rule coverage and alternate evidence.

### ENGINEERING-CODE-REMOVAL-009 — Use Vulture only as contextual Python discovery

**Level:** contextual  
**Applies when:** A cleanup seeks repository-level candidates among Python functions, methods, classes, properties, attributes, variables, or unreachable blocks that Ruff does not report.

Run a pinned Vulture version across the intended application, library, and test scope. Start with the highest useful confidence threshold and lower it only to expand a manually reviewed candidate queue. Never authorize deletion from Vulture's confidence score alone, including a 100 percent result. Trace implicit use through decorators, descriptors, dataclasses, serialization, dependency injection, callbacks, framework and test discovery, command and plugin entry points, reflection, name-based dispatch, inheritance, overrides, protocols, and external consumers.

Prefer a checked Python whitelist for intentional implicit uses over broad name, decorator, file, or directory ignores. Keep the whitelist in ordinary review, include it in Vulture's analyzed paths, and verify that its references still resolve. Do not automatically delete Vulture findings.

**Why:** Vulture extends Python discovery beyond local bindings, but its name-based static analysis can report implicitly invoked code as unused and can miss dead code in dynamic programs.

**Verify:**

- Record the Vulture version, configuration, analyzed application and test paths, confidence threshold, exclusions, whitelist, findings, and classification decisions.
- Import or type-check the whitelist where practical and inspect it for stale references after every cleanup.
- Re-run Vulture after each material deletion because one removal can expose another candidate.

**Exceptions:** Do not add Vulture when the repository has no owner for manual triage or when dynamic behavior makes its signal unactionable. Record that limitation; do not claim repository-wide Python dead-code coverage.

### ENGINEERING-CODE-REMOVAL-010 — Test analyzer configuration with positive and negative canaries

**Level:** required  
**Applies when:** A repository adopts, materially reconfigures, upgrades, or relies on an unused-code or dependency analyzer as completion evidence.

Maintain isolated repository-owned canaries for the applicable scenarios below. Each positive canary represents code or a dependency that must remain reachable; each negative canary represents an item the analyzer must report. Keep canaries outside shipped artifacts and ordinary finding budgets. Run them after tool, plugin, compiler, framework, packaging, entry-point, or analyzer-configuration changes.

**Why:** A clean report cannot show that missing entries, broad exclusions, stale caches, or unsupported dynamic behavior made the analyzer blind.

**Verify:**

- Record the applicable scenario IDs, fixture paths, commands, expected diagnostics or non-diagnostics, and actual results.
- Confirm each negative canary fails the relevant gate and each positive canary survives analysis and its runtime or packaging check.
- Review scenarios marked not applicable with the repository owner and record why their reachability mechanism is absent.

**Exceptions:** A repository may generate disposable canaries during tests instead of committing fixture files when the generated inputs and expected results are deterministic and reviewable.

## Guidance

Use tool output to build a review queue. For Knip, fix the project graph before deleting from it; tests can make production code appear reachable, so ordinary and production runs answer different questions. Knip exit `1` means findings and exit `2` means the tool failed; preserve that distinction in automation. For Ruff, prefer explicit re-exports through `__all__` or redundant aliases where they express a public interface. Never use an underscore, `noqa`, Knip ignore, dummy reference, or synthetic import only to make a report green without explaining the intended behavior.

The expected TypeScript and JavaScript stack is Knip for repository reachability and dependencies, the active `ENGINEERING-JS-QUALITY` analyzer for bindings inside files, and the TypeScript compiler plus builds and tests for semantic behavior. The expected Python stack is Ruff for supported local bindings, deptry for dependency metadata, contextual Vulture for broader candidates when its signal is actionable, and the repository's type, import, packaging, startup, and behavior checks. No single clean report replaces another layer. Do not add Knip, Ruff, deptry, Vulture, or another dependency to a project without the authority required by that project's dependency policy.

Classify findings by meaning. A Knip unlisted dependency is usually evidence that code relies on an undeclared transitive package, not a request to delete the import. A Ruff unused argument may be required by a callback, protocol, fixture, override, or compatibility contract. If notebooks are in Ruff's scope, analyze each notebook as a whole so cross-cell usage is visible.

## Conformance scenarios

The repository must implement every applicable scenario as a positive or negative canary under `ENGINEERING-CODE-REMOVAL-010`.

| ID | Scenario | Expected evidence |
|---|---|---|
| `scenario-ts-001` | A TypeScript file is reached only through a literal dynamic import or framework route. | Knip retains it after the entry, plugin, or generated route is represented; a runtime check loads it. |
| `scenario-ts-002` | A published package export has no in-repository consumer. | Analysis does not authorize removal without external-usage and compatibility evidence. |
| `scenario-ts-003` | A CommonJS or export assignment has a right-hand-side effect. | Any proposed fix preserves the effect or blocks automatic removal. |
| `scenario-ts-004` | A generated entry file reaches otherwise unused source. | Generation runs before analysis and Knip retains the reached source. |
| `scenario-ts-005` | A monorepo root and a child workspace each own entry points. | Both workspace graphs are analyzed with their effective configuration. |
| `scenario-ts-006` | An unused local binding exists inside an otherwise reachable file. | The active JavaScript or TypeScript analyzer reports it even though Knip retains the file. |
| `scenario-py-001` | A Python object is exposed only through `console_scripts`, `gui_scripts`, or plugin entry-point metadata. | Dependency and dead-code analysis retain it; an installed-package check loads or invokes it. |
| `scenario-py-002` | A package `__init__.py` intentionally re-exports a public name. | Ruff retains the explicit alias or `__all__` export and public import tests pass. |
| `scenario-py-003` | A decorator, fixture, callback, protocol method, or dependency-injection hook invokes code implicitly. | Ruff or Vulture output is classified as implicit use and the framework-level check exercises it. |
| `scenario-py-004` | Application code imports a package available only transitively. | deptry reports `DEP003`; the fix declares the direct dependency instead of deleting valid use. |
| `scenario-py-005` | A runtime dependency is declared but unused in all represented modes. | deptry reports `DEP002`; removal is followed by environment synchronization and packaging, import, startup, and behavior checks. |
| `scenario-py-006` | A development-only tool is declared but never imported by application code. | The evidence states that `DEP002` does not assess development dependencies and uses separate tooling evidence. |
| `scenario-py-007` | A method is reached through reflection or name-based dispatch. | Vulture may report a candidate, but a whitelist or equivalent explicit reachability evidence retains it. |
| `scenario-x-001` | An optional dependency or implementation is selected only in one environment. | Every supported selection mode is represented or the dependency has a narrow, reviewed exception. |
| `scenario-x-002` | A known-dead file, binding, or dependency is inserted into the isolated fixture. | The intended analyzer returns the expected finding and the blocking gate rejects it. |
| `scenario-x-003` | An analyzer cache or watch run precedes a manifest or ignore-file change. | Final evidence comes from a fresh complete run, not the potentially stale incremental result. |

## Examples

### TypeScript workspace cleanup

Non-compliant: Run Knip with default discovery, delete every reported file and dependency at once, and add a broad ignore when a framework-generated route breaks.

Compliant: Confirm root and package workspace entry points, public package exports, and framework entries; generate required route artifacts; resolve Knip configuration hints; compare ordinary, production, and applicable strict reports; trace each candidate; use a targeted fix only after review; remove one coherent group; update the lockfile with the package manager; and rerun the configured analyzer, type checks, tests, builds, startup checks, and uncached Knip analysis.

### Python import cleanup

Non-compliant: Apply every Ruff fix, including unsafe fixes, and delete a package because no Python file now imports it.

Compliant: Resolve and record Ruff's repository configuration, review `F401` and `F841` findings, preserve intentional `__init__.py` re-exports, interface-required arguments, and import-time registrations, inspect every proposed unsafe fix, use separate evidence for module and package reachability, and rerun Ruff plus type, import, packaging, test, and startup checks.

### Python dependency and definition cleanup

Non-compliant: Delete every `DEP002` and Vulture finding, treat a 100 percent confidence score as proof, and ignore console scripts because no source file imports them.

Compliant: Configure deptry's runtime, development, and optional groups; inspect package entry points and supported environments; use Vulture only to build a manually classified queue; preserve implicit uses with a checked whitelist; remove one bounded group; rebuild the environment; and rerun Ruff, deptry, Vulture, type, import, package-install, plugin, command, startup, and behavior checks.

## Sources

- Knip, [Your First Cleanup](https://knip.dev/overview/first-cleanup), [Configuring Project Files](https://knip.dev/guides/configuring-project-files), [Production Mode](https://knip.dev/features/production-mode), [Monorepos and Workspaces](https://knip.dev/features/monorepos-and-workspaces), [Resolve reported issues](https://knip.dev/guides/handling-issues), [Auto-fix](https://knip.dev/features/auto-fix), and [Using Knip in CI](https://knip.dev/guides/using-knip-in-ci). Reviewed August 17, 2026.
- Astral, [Configuring Ruff](https://docs.astral.sh/ruff/configuration/), [The Ruff Linter](https://docs.astral.sh/ruff/linter/), [`F401` unused import](https://docs.astral.sh/ruff/rules/unused-import/), and [`F841` unused variable](https://docs.astral.sh/ruff/rules/unused-variable/). Reviewed August 17, 2026.
- Python Software Foundation, [The import system](https://docs.python.org/3/reference/import.html). Reviewed August 17, 2026.
- Python Packaging Authority, [Entry points specification](https://packaging.python.org/en/latest/specifications/entry-points/). Reviewed August 17, 2026.
- deptry, [Rules and Violations](https://deptry.com/rules-violations/) and [Usage and Configuration](https://deptry.com/usage/). Reviewed August 17, 2026.
- Jendrik Seipp, [Vulture 2.16 README](https://github.com/jendrikseipp/vulture/blob/v2.16/README.md). Reviewed August 17, 2026.
