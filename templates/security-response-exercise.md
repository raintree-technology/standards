---
type: Template
title: Security response exercise template
description: Evidence record for exercising vulnerability and incident response without exposing protected details.
tags: [template, security, incident, exercise]
generated: { by: codex/gpt-5, at: "2026-08-17T17:22:48Z" }
---

# Security response exercise template

Use this record to verify `SECURITY-APPLICATION-016`. Keep secrets, exploit details, reporter identities, and protected incident evidence in the approved restricted system.

## Authority and targets

| Field | Value |
|---|---|
| Exercise owner | `<identity and role>` |
| Reporting route tested | `<private route>` |
| Severity model | `<reference>` |
| Acknowledgement and triage targets | `<approved targets>` |
| Containment and recovery authority | `<roles>` |
| Notification and disclosure authority | `<roles>` |
| Evidence location and access class | `<protected reference>` |

## Scenario and results

| Stage | Expected action | Observed result | Evidence | Gap and owner |
|---|---|---|---|---|
| Intake and triage | `<action>` | `<result>` | `<protected reference>` | `<gap, owner, date>` |
| Containment | `<action>` | `<result>` | `<protected reference>` | `<gap, owner, date>` |
| Credential or session revocation | `<action or not applicable>` | `<result>` | `<protected reference>` | `<gap, owner, date>` |
| Evidence preservation | `<action>` | `<result>` | `<protected reference>` | `<gap, owner, date>` |
| Cause correction and retest | `<action>` | `<result>` | `<protected reference>` | `<gap, owner, date>` |
| Safe restore | `<action>` | `<result>` | `<protected reference>` | `<gap, owner, date>` |
| Communication decision | `<action>` | `<result>` | `<protected reference>` | `<gap, owner, date>` |
| Post-recovery checks | `<action>` | `<result>` | `<protected reference>` | `<gap, owner, date>` |

## Closure

- Outcome: `<passed | gaps require correction | blocked>`
- Requirements or threat models updated: `<references>`
- Monitoring or detection updated: `<references>`
- Retest and next exercise: `<owner and date>`

