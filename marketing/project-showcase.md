---
id: MARKETING-PROJECT-SHOWCASE
title: Public project showcase
description: Defines the minimum truthful, useful record for presenting public products and open-source projects across owned surfaces.
type: standard
status: draft
governance_status: draft
owners: [marketing, web, open-source]
last_reviewed: 2026-08-20
review_by: 2027-02-20
stale_after: 2027-02-20
applies_to: [project-portfolio, project-page, repository-readme, public-profile]
tags: [marketing, open-source, portfolio, evidence]
depends_on: [FND-EVIDENCE, FND-TRUST, WRITING-FUNCTIONAL, WEB-QUALITY]
generated: { by: codex/gpt-5, at: "2026-08-20T18:19:31Z" }
---

# Public project showcase

A public project record must let a visitor understand what the project does, who it
helps, whether it is active, why its claims are credible, and what to do next. This
standard applies when Raintree presents a product or open-source project on a company
site, personal site, repository README, public profile, or generated catalog.

The goal is a consistent factual record, not identical page layouts. Each surface can
adapt its depth and visual treatment to its audience.

## Rules

### MARKETING-PROJECT-SHOWCASE-001 — Maintain one canonical project record

**Level:** required
**Applies when:** The same project appears on more than one owned public surface.

Maintain one canonical record for project identity, classification, status, source
repository, primary destination, distribution links, and evidence sources. Generate
or derive repeated listings from that record where practical. When a surface must
keep a local projection, verify it against the canonical record before release.

**Why:** Hand-maintained copies drift into wrong links, inconsistent names, outdated
status, and conflicting claims.

**Verify:**

- Identify the canonical record and every public projection in the release scope.
- Compare names, classifications, status, URLs, and evidence-source identifiers.
- Run link and structured-data checks against the rendered destinations.

**Exceptions:** A one-time external profile can keep a reviewed snapshot when the
platform cannot consume the canonical record. Record the snapshot date and owner.

### MARKETING-PROJECT-SHOWCASE-002 — State the project outcome and audience

**Level:** required
**Applies when:** A project is named or promoted on a public surface.

Pair the project name with a plain description of the outcome it creates and the
audience or problem it serves. Prefer a concrete capability over an internal category,
technology list, or slogan. A compact index can use one sentence; a dedicated project
page or README must add enough detail to distinguish the project from alternatives.

**Why:** A name and category do not tell a visitor whether the project is relevant.

**Verify:**

- Read the record without surrounding company context and identify its outcome and
  intended user or problem.
- Compare the summary with current behavior and repository documentation.

**Exceptions:** None.

### MARKETING-PROJECT-SHOWCASE-003 — Provide a direct next action

**Level:** required
**Applies when:** A visitor can inspect, install, try, read about, or contribute to the
project.

Provide at least one direct, working action appropriate to the project: use the
product, inspect source, install a package, read the documentation, view evidence, or
follow the contribution path. A detailed portfolio record for distributable software
must expose the source repository and its primary install or use path when both exist.

**Why:** A showcase that stops at description creates interest without a usable path.

**Verify:**

- Follow every primary and supporting action from the rendered surface.
- Confirm the destination matches the action label and does not rely on a redirect to
  repair a known stale URL.

**Exceptions:** A historical or archived project can replace an install or use action
with a clearly labeled archive or retrospective destination.

### MARKETING-PROJECT-SHOWCASE-004 — Label project class and lifecycle truthfully

**Level:** required
**Applies when:** A portfolio mixes products, open-source projects, research, archives,
experiments, or internal systems.

Classify the project and disclose lifecycle state when omission could imply active
support, public availability, open-source licensing, or production readiness. Do not
place private or source-available software under an open-source heading.

**Why:** Visitors use classification and status to infer access, support, licensing,
and maintenance expectations.

**Verify:**

- Compare the public label with licensing, repository visibility, release state, and
  the current maintenance decision.
- Confirm archived, experimental, or unsupported work is not presented as active.

**Exceptions:** A compact active-project list can omit repeated `active` labels when
the section explicitly defines that all included projects are active.

### MARKETING-PROJECT-SHOWCASE-005 — Attach evidence to adoption and quality claims

**Level:** required
**Applies when:** Publishing downloads, installs, stars, users, benchmark results,
coverage counts, performance claims, or comparisons.

Define the metric, source it from an inspectable system, preserve its unit, and state
the measurement period or freshness policy where the value is not self-dating. Keep
unlike measures separate. Do not turn a combined total into evidence for an individual
project.

**Why:** Unqualified totals and stale counters look precise while hiding what they
measure.

**Verify:**

- Trace each value to its source query or generated evidence record.
- Confirm aggregation rules, units, fallback behavior, and refresh timing.
- Check the rendered label at narrow and wide layouts.

**Exceptions:** A non-numeric qualitative statement can omit measurement metadata when
it does not imply measured adoption, performance, or comparative superiority.

### MARKETING-PROJECT-SHOWCASE-006 — Show the maintained ecosystem as a system

**Level:** required
**Applies when:** An organization maintains multiple public projects that serve
related parts of one workflow.

Publish at least one owned overview that explains how the maintained projects relate.
Each maintained repository must link either to that overview or to a concise ecosystem
map in its README. Keep the relationship factual: name the responsibility of each
project without implying integration, compatibility, or shared adoption that has not
been verified.

**Why:** Separate repository listings hide the larger system and force visitors to
infer relationships from names and organization ownership.

**Verify:**

- Start from each maintained repository and reach the owned ecosystem overview or map.
- Confirm every named responsibility matches the project's current public contract.
- Confirm private projects and unrelated archives are not implied to be open source.

**Exceptions:** A standalone project with no maintained sibling projects can omit an
ecosystem link.

### MARKETING-PROJECT-SHOWCASE-007 — Verify the final public record

**Level:** required
**Applies when:** Publishing or materially changing a project showcase.

Inspect the rendered record in its intended medium. Verify hierarchy, readable
descriptions, accessible link names, keyboard access, responsive reflow, destination
health, structured data, and consistency with agent-readable or plain-text versions.

**Why:** Correct source data can still become incomplete, clipped, ambiguous, or
inconsistent after rendering and export.

**Verify:**

- Capture representative desktop and narrow layouts.
- Operate project actions with a keyboard and inspect accessible names.
- Compare HTML, structured data, `llms.txt`, generated Markdown, and social-profile
  exports that represent the same projects.
- Record checks, failures, deferred environments, and known evidence limits.

**Exceptions:** When a required environment is unavailable, verify the closest
substitute and record the untested behavior and owner.

### MARKETING-PROJECT-SHOWCASE-008 — Match the document to its job

**Level:** required
**Applies when:** Writing or restructuring repository documentation.

Classify each document before editing it. Use the matching pattern from
[`templates/open-source-documentation.md`](../templates/open-source-documentation.md):

- a repository landing page helps a developer reach one useful result;
- a published package or plugin page documents the independently installed surface;
- an example or study preserves its scenario, method, result, and limitations;
- a benchmark or evidence artifact preserves status, provenance, reproduction, and claim boundaries; and
- an internal maintainer guide states that it is internal and names its maintenance task.

Do not keep a `README.md` only because a directory exists. Reserve that filename for
an independently consumed entrypoint or a self-contained evidence bundle. Give other
documents names that describe their purpose.

**Why:** One universal README template either overwhelms new users or strips evidence
and package documentation of necessary detail.

**Verify:** Inventory every README in scope, confirm package registries and integrity
manifests retain required files, and confirm moved content remains reachable from a
maintained index.

**Exceptions:** A third-party platform may require a README filename. Record the
platform requirement and apply the closest matching pattern.

### MARKETING-PROJECT-SHOWCASE-009 — Lead repository pages with first use

**Level:** required
**Applies when:** The document is a repository landing page for distributable software.

Order the page around a first successful use: identity and lifecycle, outcome and
audience, install or trial action, expected result, proof, reasons to use it, operating
model, compatibility, limits, deeper documentation, ecosystem, and project policies.
Put installation before commands that require the installed tool. Choose one primary
path and route alternative interfaces after it.

**Why:** A feature inventory does not help a new visitor decide what to run first.

**Verify:** Follow the primary path in a clean environment and ask a representative
reader to identify the audience, first action, expected result, and main limit.

**Exceptions:** A non-executable library can replace the install-and-run path with a
worked application example.

## Minimum project record

| Field | Compact index | Detailed portfolio or README |
| --- | --- | --- |
| Name | Required | Required |
| Outcome and audience | Required | Required |
| Project class | Section label can supply it | Required when ambiguous |
| Lifecycle state | Required when not uniformly active | Required |
| Primary action | Required | Required |
| Source repository | Required for open source | Required for open source |
| Install or use path | When available | Required for distributable software |
| Evidence | Optional | Required for material adoption or quality claims |
| Limit or support boundary | When material | Required when omission could mislead |
| Ecosystem relationship | Overview can supply it | Link to overview or concise map |

## Guidance

Use one shared factual catalog and let each surface choose its depth. A company
portfolio can lead with outcomes, evidence, and multiple actions. A personal site can
use a compact index while linking to the richer company record. A repository README
should remain focused on that project, then provide a short ecosystem map after the
project's own quick start and boundaries.

Do not rank projects only by the easiest metric to collect. Put active, relevant work
first, explain the selection rule, and separate maintained tools from archives.

The canonical machine-readable record uses
[`schema/project-showcase-record.schema.json`](../schema/project-showcase-record.schema.json).
Keep volatile traction in a separate record so a stale counter cannot change project
identity, lifecycle, or support boundaries.

## Examples

Compliant compact record:

> **DocPull** — Versions cited web context for teams building AI agents. Inspect the
> source on GitHub or install it from PyPI.

Non-compliant compact record:

> **DocPull** — Agent context. 22,522 downloads.

The second record does not identify the user outcome, provides no action, and leaves
the metric source and meaning implicit.

## Approval status

The [implementation review](project-showcase-review-2026-08-20.md) records two
representative-reader tasks and their corrections. Independent writing review and
the published-render accessibility checks remain open, so this standard stays in
draft.

## Sources

This standard defines Raintree's internal public-project presentation contract. Its
evidence, trust, writing, and web-delivery dependencies provide the governing source
basis for the individual requirements.
