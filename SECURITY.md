---
type: Policy
title: Security policy
description: Process for reporting security concerns in raintree.standards.
tags: [security, reporting]
generated: { by: codex/gpt-5, at: "2026-08-17T17:22:48Z" }
---

# Security policy

Report security concerns privately when they contain sensitive information or could put
users at risk. Concerns can include unsafe guidance, exposed sensitive information,
malicious content, or vulnerabilities in repository automation.

## Report a vulnerability

Do not open a public issue for a sensitive security concern.

1. Email [hello@raintree.technology](mailto:hello@raintree.technology) with the subject `raintree.standards security report`.
2. Identify the affected file or workflow and explain the risk.
3. Include reproduction details when applicable and a safe way to confirm the issue.

You can instead use the repository's **Security** tab when private vulnerability
reporting is available.

Use a public GitHub issue for non-sensitive corrections and documentation problems.

## Response

Repository maintainers own intake and triage. They assess severity and affected scope,
limit further exposure when necessary, preserve protected evidence, correct the cause,
verify recovery, and decide what can be shared without increasing risk. The repository
owner decides containment, release, and public-notification actions or assigns those
decisions to a named security owner.

Response targets require owner approval and are not yet published. Until they are
approved, the project does not guarantee a response time. This is a release blocker,
not an exception to maintaining the private reporting path.

Use the [security response exercise template](templates/security-response-exercise.md)
to record an exercise or real response. Keep reporter identities, credentials, exploit
details, and other protected evidence out of this public repository.
