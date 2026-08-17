---
type: Template
title: Standards audit report template
description: Reusable report structure for a scoped Raintree standards conformance audit.
tags: [template, audit, evidence, conformance]
generated: { by: codex/gpt-5, at: "2026-08-17T06:08:51Z" }
---

# Standards audit report template

Use with [`PLAYBOOK-STANDARDS-AUDIT`](../playbooks/standards-audit.md). Replace every angle-bracketed value and remove instructional text before issuing a report. Keep protected evidence in its approved system and link to it through an access-controlled reference.

## Audit record

| Field | Value |
|---|---|
| Audit subject | `<system, repository, release, or decision>` |
| Purpose and decision | `<what this audit will inform>` |
| Intended audience | `<roles or named decision owners>` |
| Accountable owner | `<owner>` |
| Auditor or review team | `<reviewers and roles>` |
| System boundary | `<included components, sources, consumers, and data flows>` |
| Exclusions | `<explicitly uninspected scope>` |
| Version or commit | `<immutable identifier>` |
| Environment | `<production, staging, repository, or other>` |
| Audit period | `<start and end>` |
| Evidence cutoff | `<date and time>` |
| Report date | `<date>` |

## Applicable routes

| Profile or standard | Why it applies | Conditions or excluded routes |
|---|---|---|
| `<PROFILE-ID>` | `<observed task or system behavior>` | `<conditional decision and evidence>` |

Record library gaps and the external policy or qualified owner required to decide them.

## Provider records

Repeat this section for each material external platform. Use the exact named playbook when one exists. Use `not available` for a missing agent skill and keep the provider review in scope. Do not record secret values.

### `<provider>`

| Field | Record |
|---|---|
| Governed scope | `<account, project, environment, region, and products>` |
| Playbook and bundle | `<PLAYBOOK-ID and integrations/<provider>/manifest.yaml, or recorded gap>` |
| Selected capabilities | `<CAPABILITY-ID with applicability reason and authority class>` |
| Executed workflows and evaluations | `<WORKFLOW-ID and EVALUATION-ID with result or justified deferral>` |
| Agent review aid | `<skill package/version or not available>` |
| Normative provider sources | `<official documentation URLs and review date>` |
| Informative engineering sources | `<provider or third-party engineering URLs, source role, and review date>` |
| Guidance conflicts | `<skill, sample, or source conflict; precedence decision; current provider evidence>` |
| Negative and legacy paths | `<mapped, adjacent, legacy, excluded, deprecated, and prohibited surfaces>` |
| Released state | `<artifact, configuration, and EVIDENCE-ID>` |
| Boundaries | `<data, credentials, identities, roles, and environment isolation>` |
| Asynchronous behavior | `<authenticity, duplicates, ordering, retry, and reconciliation>` |
| Operations | `<limits, cost, quota, egress, signals, failure exercise, recovery, exit path, and owner>` |

Provider exercises and findings:

- `<scenario, evidence, result, limitation, and follow-up>`

## Rule findings

Use only `pass`, `fail`, `unknown`, `not applicable`, `approved exception`, or `stale evidence`. Apply the requirement-level meanings and overall-result rules in the playbook. Do not use `partial pass`, and never record an approved exception for a prohibited rule.

| Rule ID | Level | Applicability | Status | Evidence | Observation | Risk | Owner | Follow-up |
|---|---|---|---|---|---|---|---|---|
| `<RULE-ID>` | `<level>` | `<condition and decision>` | `<status>` | `<EVIDENCE-ID or protected reference>` | `<directly observed result>` | `<effect of failure or uncertainty>` | `<owner>` | `<action and date>` |

## Evidence register

| Evidence ID | Source and location | Version or commit | Method and parameters | Environment and period | Collected at | Access class | Valid until | Limits |
|---|---|---|---|---|---|---|---|---|
| `<EVIDENCE-ID>` | `<artifact or protected reference>` | `<version>` | `<test, query, inspection, or trace method>` | `<scope>` | `<timestamp>` | `<classification>` | `<expiry or review date>` | `<missing or uninspected scope>` |

## Exceptions

| Rule ID | Exception reference | Exact scope | Risk and compensating controls | Approver | Expires | Return-to-compliance work |
|---|---|---|---|---|---|---|
| `<RULE-ID>` | `<record>` | `<system, release, or period>` | `<risk and controls>` | `<accountable human>` | `<date>` | `<owner, work, and date>` |

## Conflicts and unresolved evidence

- **Conflicting evidence:** `<sources, authority, freshness, scope, and current interpretation>`
- **Unknown findings:** `<rule IDs and evidence needed>`
- **Stale evidence:** `<rule IDs, prior evidence, and revalidation owner>`
- **Untested areas:** `<scope and practical risk>`
- **External decisions:** `<law, policy, contract, or qualified owner decision still required>`

## Scoped conclusion

**Overall result:** `<conforming | non-conforming | indeterminate>`

State the result, subject, version, environment, evidence cutoff, controlling failures or uncertainties, approved exceptions, and decision this evidence supports. Do not imply certification, complete safety, or coverage outside the declared boundary.

## Handoff and review

- Final artifact and version: `<reference>`
- Checks and retests performed: `<references and results>`
- Open remediation: `<owners and dates>`
- Independent review: `<reviewer, scope, decision, and artifact version>`
- Qualified domain review: `<required roles, decision, and unresolved conditions>`
