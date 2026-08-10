# Raintree Standards

An authoritative quality system for humans and agents building products, software, data systems, content, growth programs, and operations.

This is not a general collection of tips. It defines what acceptable work looks like, which requirements are non-negotiable, how compliance is verified, and how exceptions are handled.

## Format

Markdown is the source of truth. Every governed document starts with YAML front matter containing machine-readable metadata. `schema/standard.schema.json` defines the standard contract, while `catalog.yaml` provides a fast index for agents and tooling.

This hybrid has three advantages:

- Markdown remains easy to read, review, diff, and cite.
- YAML metadata supports discovery and task routing without duplicating the body.
- JSON Schema allows automated validation without making JSON the authoring format.

## Library model

| Type | Purpose |
|---|---|
| Foundation | Cross-cutting constraints such as security, privacy, accessibility, reliability, trust, and evidence quality |
| Standard | Testable requirements for a domain |
| Pattern | A preferred implementation approach with known tradeoffs |
| Playbook | An ordered procedure for recurring work |
| Profile | A task-oriented bundle of applicable standards |
| Decision | A durable record explaining an important choice |

## Using the library

1. Start with the closest document in `profiles/`.
2. Read the standards it activates.
3. Determine which individual rules apply to the actual risk and context.
4. Collect the verification evidence requested by each rule.
5. Report compliance, exceptions, and unresolved gaps using stable rule IDs.

Start with:

- [Authority and requirement levels](governance/authority.md)
- [How to contribute](governance/contributing.md)
- [Database change profile](profiles/database-change.md)
- [Product feature profile](profiles/product-feature.md)
- [Growth experiment profile](profiles/growth-experiment.md)
- [Public web page profile](profiles/public-web-page.md)

## Coverage

The initial library establishes standards for database changes, product delivery, growth experiments, analytics, SEO, public web quality, agent verification, and cross-cutting foundations. `roadmap.md` records domains that still need authoritative treatment.

## Important distinction

“Read-only for agents” is a behavioral and governance rule, not merely a filesystem permission. Agents are instructed by `AGENTS.md` not to modify this repository unless the user explicitly assigns standards maintenance. Filesystem permissions may be added in deployment environments, but Git review and repository ownership remain the durable enforcement mechanism.

