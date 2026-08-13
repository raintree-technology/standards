# Google Search Console capability bundle

This supporting bundle makes the governed Google Search Console operations playbook (`PLAYBOOK-GSC`) executable for agents without storing credentials or granting authority.

* [`sources.yaml`](sources.yaml) defines the official-source inventory, freshness triggers, active change watch, and zero-gap coverage ledger.
* [`capabilities.yaml`](capabilities.yaml) maps access, effects, approvals, limits, limitations, and verification.
* [`data-semantics.yaml`](data-semantics.yaml) defines interpretation boundaries for Google-observed data.
* [`workflows.yaml`](workflows.yaml) defines repeatable operational routes.
* [`evaluations.yaml`](evaluations.yaml) defines offline decision fixtures.

The files are implementation evidence for `PLAYBOOK-GSC`; they are not credentials, an OAuth client, an MCP server, or a mirror of Google documentation.

## Agent loading protocol

1. Read `sources.yaml` first. Stop or narrow the task when its freshness deadline has passed, an applicable change-watch entry is unresolved, or the requested surface is not classified in the coverage ledger.
2. Select capabilities from `capabilities.yaml` by exact interface and availability. Never infer an API from a UI capability or substitute the adjacent Indexing API for ordinary pages.
3. Apply every referenced limit dimension and the relevant concepts in `data-semantics.yaml`. Preserve Google-observed evidence separately from live site, source-system, analytics, commerce, security, and user-outcome evidence.
4. Execute the matching route in `workflows.yaml`, including its stop conditions. A capability's effect and approval class override convenience, credential availability, and broad task wording.
5. Use `evaluations.yaml` as decision regression tests when changing a capability, workflow, or agent implementation. A passing fixture is evidence of the named decision only, not permission for a live mutation.

## Consumer contract

- Reads and diagnosis require an exact property or external asset, observation time, data dates, filters, grain, maturity, and declared limitations.
- `bounded` permits only the already-approved property, cohort, action, and retry ceiling. `exact` requires the final target and consequential fields immediately before execution. `human_only` cannot be delegated to an agent.
- Agents must verify every mutation from the resulting external state and apply the declared rollback or irreversibility procedure. They must not equate an accepted request with crawling, indexing, ranking, display, delivery, or business success.
- Unknown surfaces, roles, OAuth scopes, fields, enums, quotas, and report states are source-review events—not invitations to guess.
