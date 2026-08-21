---
id: SECURITY-APPLICATION
title: Application security
description: Governs threat modeling, access control, input handling, secrets, dependencies, detection, and security verification.
type: standard
status: draft
governance_status: draft
owners: [security, engineering]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [product-feature, public-web-page]
tags: [security, application, authentication, authorization, secrets, verification]
depends_on: [SECURITY-SECRETS, FND-CHANGE, FND-EVIDENCE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T05:26:55Z" }
sources:
  - id: owasp-asvs-5
    resource: https://owasp.org/www-project-application-security-verification-standard/
    title: OWASP Application Security Verification Standard 5.0.0
    author: organization:owasp
  - id: owasp-top-10-2025
    resource: https://owasp.org/Top10/2025/
    title: OWASP Top 10:2025
    author: organization:owasp
  - id: nist-ssdf-1-1
    resource: https://csrc.nist.gov/pubs/sp/800/218/final
    title: Secure Software Development Framework Version 1.1
    author: organization:nist
  - id: nist-digital-identity-4
    resource: https://pages.nist.gov/800-63-4/
    title: NIST SP 800-63-4 Digital Identity Guidelines
    author: organization:nist
  - id: owasp-cheat-sheets
    resource: https://cheatsheetseries.owasp.org/
    title: OWASP Cheat Sheet Series
    author: organization:owasp
  - id: anthropic-prompt-injection
    resource: https://www.anthropic.com/research/prompt-injection-defenses
    title: Mitigating the risk of prompt injections in browser use
    author: organization:anthropic
  - id: anthropic-agent-containment
    resource: https://www.anthropic.com/engineering/how-we-contain-claude
    title: How we contain Claude across products
    author: organization:anthropic
  - id: openai-agent-safety
    resource: https://developers.openai.com/api/docs/guides/agent-builder-safety
    title: Safety in building agents
    author: organization:openai
---

# Application security

Applications must define their security boundary, enforce authorization on trusted systems, handle untrusted data safely, limit compromise, and produce evidence that controls work in the integrated system. This standard applies to application code, APIs, background jobs, administrative interfaces, deployment configuration, and supporting services that enforce application security.

This standard is a baseline, not a claim that one checklist covers every threat. Select a version-qualified OWASP ASVS 5.0.0 requirement set and any organization security requirements according to the system's exposure, data, users, privileges, and impact. High-impact or novel systems require a qualified security owner to decide the verification depth.

## Rules

### SECURITY-APPLICATION-001 — Define security requirements and trust boundaries

**Level:** required  
**Applies when:** Creating or materially changing an application, data flow, integration, privilege, externally reachable surface, or security control.

Before implementation, record protected assets, actors, privileges, entry points, trust boundaries, data flows, dependencies, assumptions, abuse cases, required controls, and owners. Threat-model material changes and map applicable, version-qualified ASVS requirements to implementation and verification evidence.

**Why:** Controls selected without the system boundary and attacker paths can protect the happy path while leaving alternate entry points exposed.

**Verify:**

- Compare the threat model with current routes, jobs, queues, stores, identities, third parties, and deployment topology.
- Trace each material threat and ASVS requirement to a control, owner, test or inspection, and residual-risk decision.
- Reopen the model after changes to exposure, data sensitivity, tenancy, identity, privilege, dependency, or architecture.

**Exceptions:** A bounded emergency fix can receive retrospective modeling through the governing incident process; record scope and deadline.

### SECURITY-APPLICATION-002 — Enforce authorization on every trusted operation

**Level:** required  
**Applies when:** A user, service, device, job, or administrator reads data or performs an action with access restrictions.

Enforce authorization in the trusted application or service for every request and object. Default to deny. Derive actor identity and tenant context from trusted authentication state, not client-supplied ownership fields. Check action, object, tenant, relationship, state, and field-level permissions as applicable, including indirect and bulk access.

**Why:** Hidden controls, guessed identifiers, and authenticated sessions do not prevent unauthorized object or function access.

**Verify:**

- Exercise unauthenticated, wrong-user, wrong-role, wrong-tenant, stale-membership, suspended, deleted, and direct-object requests.
- Test alternate routes, bulk endpoints, exports, search, background jobs, cached results, and nested object references.
- Inspect server-side policy and deny behavior; confirm client controls are not the enforcement boundary.

**Exceptions:** Public resources must be explicitly classified public and tested for unintended fields, drafts, tenant data, and state-changing behavior.

### SECURITY-APPLICATION-003 — Protect authentication and account recovery

**Level:** required  
**Applies when:** An application establishes, recovers, links, or changes a user or service identity.

Use an approved identity system and an authentication strength proportionate to risk. Protect enrollment, sign-in, recovery, factor changes, identifier changes, and account linking against enumeration, guessing, replay, automation, and takeover. Require phishing-resistant authentication where governing risk or policy calls for it, and notify or step up authentication for material account changes.

**Why:** Recovery and account-change paths often provide an easier takeover route than primary sign-in.

**Verify:**

- Test valid and invalid identifiers, repeated attempts, recovery, factor reset, account linking, email or phone change, and compromised-session scenarios.
- Confirm rate and abuse controls do not reveal account existence through content, status, timing, or side effects beyond the approved design.
- Compare implemented authenticator and recovery behavior with the selected NIST assurance guidance and organization policy.

**Exceptions:** Legacy or external identity constraints require an approved security exception with compensating controls and an owner.

### SECURITY-APPLICATION-004 — Manage sessions through their full life cycle

**Level:** required  
**Applies when:** An application creates or accepts a session, token, cookie, API credential, or delegated authorization grant.

Generate unpredictable credentials, transmit and store them safely, bind them to the intended client and audience where applicable, set the narrowest scope and lifetime, rotate identifiers after authentication or privilege change, and invalidate them on logout, revocation, account disablement, or material compromise. Protect browser sessions against cross-site request forgery and use restrictive cookie attributes.

**Why:** A secure sign-in does not protect a reusable, over-scoped, leaked, fixed, or non-revocable session.

**Verify:**

- Exercise creation, refresh, idle and absolute expiry, privilege change, logout, concurrent use, revocation, and password or factor reset.
- Inspect cookie, token, storage, transport, issuer, audience, scope, and replay behavior.
- Confirm state-changing browser requests reject missing or invalid anti-forgery protection where ambient credentials are used.

**Exceptions:** Stateless credentials that cannot be individually revoked need short lifetimes, key-rotation response, and a documented compromise model approved by security.

### SECURITY-APPLICATION-005 — Handle untrusted input by context

**Level:** required  
**Applies when:** Data crosses a trust boundary into commands, queries, templates, markup, headers, paths, files, parsers, interpreters, or downstream systems.

Validate allowed type, structure, range, length, and semantics at the trusted boundary. Use parameterized interfaces for queries and commands, and encode output for its exact destination context. Do not build executable syntax by concatenating untrusted data. Canonicalize only when the target comparison and normalization rules are defined.

**Why:** Generic escaping or client validation cannot safely cover SQL, shell, HTML, JavaScript, CSS, URLs, headers, templates, and other interpreters.

**Verify:**

- Test valid boundary values, malformed encodings, nested structures, duplicate parameters, type confusion, traversal, and interpreter metacharacters.
- Inspect every sink for a parameterized API or context-specific encoder and confirm transformations occur once in the correct order.
- Confirm validation runs on server, worker, and batch paths even when a trusted client normally supplies the data.

**Exceptions:** A reviewed parser or sandbox can accept a broader language only when its grammar, capabilities, resource limits, and escape boundary are explicit.

### SECURITY-APPLICATION-006 — Isolate files and active content

**Level:** required  
**Applies when:** Users or external systems upload, import, generate, transform, preview, or serve files or rich content.

Allow only needed formats and sizes, verify content rather than trusting names or declared types, generate server-side storage names, and store untrusted files outside executable application paths. Scan or safely transform content according to risk. Serve it with deliberate content type, disposition, origin, and permissions so it cannot execute with unintended authority.

**Why:** Uploaded content can exploit parsers, overwrite paths, consume resources, execute in a trusted origin, or expose one tenant's data to another.

**Verify:**

- Test double extensions, mismatched types, malformed archives, traversal names, active content, oversized and compressed inputs, duplicates, and parser failures.
- Confirm storage paths, object permissions, serving origin, response headers, and tenant authorization.
- Exercise quarantine, scan failure, transformation failure, deletion, and incident recall paths.

**Exceptions:** A required active-content workflow needs isolation, a threat model, explicit capabilities, and qualified security review.

### SECURITY-APPLICATION-007 — Restrict outbound requests and callbacks

**Level:** required  
**Applies when:** Untrusted or partially trusted data can influence a server-side URL, host, port, protocol, redirect, webhook, import, fetch, or callback.

Allow only needed protocols and destinations, resolve and validate the effective destination at the trusted boundary, restrict network egress, and block access to local, private, link-local, metadata, and control-plane services unless explicitly required. Revalidate redirects and defend against DNS rebinding and alternate address forms.

**Why:** Server-side request forgery can turn an application into a path to internal systems or privileged cloud metadata.

**Verify:**

- Test loopback, private and link-local ranges, IPv4 and IPv6 forms, encoded addresses, credentials in URLs, redirects, DNS changes, alternate ports, and unsupported protocols.
- Inspect effective egress policy and resolver behavior rather than only string validation.
- Confirm fetched content has size, time, type, and redirect limits and cannot reach privileged credentials.

**Exceptions:** A product whose purpose requires arbitrary destinations needs isolation, destination-risk controls, strict response limits, monitoring, and qualified security approval.

### SECURITY-APPLICATION-008 — Keep secrets out of code, clients, and evidence

**Level:** required  
**Applies when:** Creating, receiving, storing, using, rotating, or revoking credentials, signing keys, encryption keys, tokens, or other secrets.

Store secrets in an approved secret or key system. Never place them in source, client-delivered code, images, fixtures, tickets, logs, analytics, prompts, screenshots, or ordinary build output. Grant the minimum identity, scope, environment, and lifetime. Support rotation and prompt revocation, and treat exposure as an incident rather than merely deleting the visible value.

**Why:** A committed or logged secret may remain in history, caches, replicas, and external systems after its first copy is removed.

**Verify:**

- Inspect source history, build artifacts, client bundles, configuration, logs, telemetry, and support evidence with approved secret detection.
- Review effective secret access, scope, expiry, rotation, audit, and break-glass behavior.
- Exercise revocation or rotation and confirm dependent services recover without restoring the old secret.

**Exceptions:** A public identifier or publishable key is not a secret, but its public status and allowed powers must be documented to prevent false assumptions.

### SECURITY-APPLICATION-009 — Use approved cryptography and key management

**Level:** required  
**Applies when:** Protecting confidentiality, integrity, authenticity, password verifiers, signatures, random values, or data in transit or at rest.

Use organization-approved, current protocols, algorithms, modes, parameters, and maintained libraries. Do not design custom cryptography. Use cryptographically secure randomness, authenticated encryption where confidentiality and integrity are required, purpose-separated keys, and a key life cycle covering generation, storage, access, rotation, revocation, backup, destruction, and algorithm migration.

**Why:** Sound algorithms fail when modes, nonces, parameters, certificates, random sources, or keys are handled incorrectly.

**Verify:**

- Inventory protocols, algorithms, modes, parameters, certificates, hashes, password-verification settings, keys, and owning systems.
- Test transport downgrade, certificate validation, key rotation, corrupted ciphertext, replay where relevant, and failure behavior.
- Confirm source does not contain custom primitives, hard-coded keys, static nonces, or general hashes used as password verifiers.

**Exceptions:** Compatibility with a legacy external system requires a time-bounded security exception, isolated exposure, monitoring, and migration owner.

### SECURITY-APPLICATION-010 — Ship secure configuration and safe failure behavior

**Level:** required  
**Applies when:** Configuring an application, framework, service, runtime, container, proxy, cloud resource, or error path.

Start from deny-by-default configuration. Disable unused services, routes, accounts, methods, debug features, sample content, directory listing, and unsafe framework defaults. Set needed security headers and resource policies. Fail closed for authorization and integrity decisions, while preserving a controlled recovery path. Return users safe, useful errors without exposing secrets, stack traces, queries, internal paths, or security control details.

**Why:** A correct code path can be defeated by an exposed console, permissive cloud policy, verbose exception, unsafe default, or partial failure.

**Verify:**

- Compare effective development, preview, and production configuration with the approved baseline.
- Inspect externally reachable routes, methods, ports, storage, identities, headers, and debug behavior.
- Force dependency, timeout, parser, authorization, and partial-write failures and verify denial, consistency, recovery, and safe messages.

**Exceptions:** A diagnostic feature can exist only behind approved access, environment, expiration, and audit controls.

### SECURITY-APPLICATION-011 — Govern dependencies and build provenance

**Level:** required  
**Applies when:** Application behavior or security depends on a package, image, action, compiler, build service, external script, or downloaded artifact.

Maintain an inventory of direct and transitive components and their source. Pin or constrain versions according to the ecosystem's safe update model, verify artifact integrity and origin, restrict who and what can alter builds, and monitor disclosed vulnerabilities and compromised components. Remove unused dependencies and define an owned update and emergency replacement path.

**Why:** Vulnerable or replaced components and build systems can bypass controls without changing first-party source.

**Verify:**

- Reconcile the dependency or component inventory with lockfiles, images, build manifests, loaded scripts, and deployed artifacts.
- Inspect provenance, integrity checks, build identities, protected configuration, and release authorization.
- Review vulnerability findings for reachability, exposure, decision, deadline, fix or mitigation, and retest; do not treat scanner silence as proof of safety.

**Exceptions:** An unmaintained or unverifiable component requires qualified security acceptance, isolation, monitoring, and a replacement plan.

### SECURITY-APPLICATION-012 — Bound resource use and automated abuse

**Level:** required  
**Applies when:** An operation can consume material compute, memory, storage, bandwidth, money, messages, third-party quota, or human review capacity.

Set limits for input size, parsing, nesting, decompression, execution time, retries, concurrency, pagination, output, queued work, and cost. Apply actor-, tenant-, object-, and system-level controls where one identity or distributed traffic could cause harm. Make retries idempotent where repeated side effects are possible and degrade safely when limits are reached.

**Why:** Valid-looking requests can exhaust shared resources, multiply side effects, or create unbounded third-party cost.

**Verify:**

- Exercise boundary, sustained, burst, distributed, retry, cancellation, and dependency-slowdown cases.
- Confirm limits exist at the resource-owning layer and cannot be bypassed by alternate identities, routes, jobs, or payload forms.
- Inspect alerts, queues, spend controls, cleanup, user feedback, and recovery after throttling or exhaustion.

**Exceptions:** A trusted bulk operation needs explicit authorization, a separate bounded path, monitoring, stop controls, and an owner.

### SECURITY-APPLICATION-013 — Log and detect security-relevant behavior

**Level:** required  
**Applies when:** An application authenticates actors, enforces access, changes privilege or security configuration, handles protected data, or detects abuse.

Record enough context to investigate authentication, authorization denials, privilege and configuration changes, sensitive administrative actions, input rejection, control failure, and suspected abuse. Protect log integrity and access, use consistent time and correlation, alert on actionable conditions, and exclude secrets and unnecessary personal data. Define owners, retention, escalation, and expected response.

**Why:** Security controls can fail silently when events cannot be connected to an actor, resource, decision, and response.

**Verify:**

- Trigger representative success, denial, change, and abuse events and trace them through collection, storage, alert, and owner response.
- Confirm logs resist user-controlled injection and do not contain credentials, tokens, sensitive payloads, or unbounded free text.
- Test loss, delay, tampering, clock skew, duplicate events, and alert-routing failure where material.

**Exceptions:** A privacy or safety constraint can limit logged fields; preserve the minimum event, protected correlation, and alternate evidence needed for detection.

### SECURITY-APPLICATION-014 — Require extra controls for administrative and high-impact actions

**Level:** required  
**Applies when:** An action changes access, identity, security policy, money, publication, deletion, exports, production configuration, or many users or records.

Restrict the action to named roles and the narrowest scope. Require recent or stepped-up authentication according to risk, protect browser actions against forgery, present the exact target and effect before commitment, prevent unintended repetition, and create an attributable audit record. Separate request, approval, and execution when the governing risk requires it.

**Why:** A stolen session, confused operator, forged request, or broad role can turn one action into widespread or irreversible harm.

**Verify:**

- Test wrong-role, stale-authentication, forged, replayed, duplicate, partial-failure, and wrong-target cases.
- Inspect effective permissions, approval boundaries, confirmation content, idempotency, and audit evidence.
- Confirm emergency access expires, is monitored, and receives retrospective review.

**Exceptions:** An automated high-impact action requires equivalent service identity, policy, scope, approval, audit, stop, and recovery controls.

### SECURITY-APPLICATION-015 — Verify controls against the integrated system

**Level:** required  
**Applies when:** Releasing or materially changing an application or security-relevant behavior.

Execute the selected security verification plan against the integrated artifact and representative deployment. Cover applicable ASVS 5.0.0 requirements, threat-model abuse cases, authorization negatives, input and output boundaries, dependency and configuration review, secrets, logging, and recovery. Use independent qualified review for high-impact, novel, externally exposed, or materially privileged systems.

**Why:** Unit tests and automated scanners each see only part of the attack surface and can miss control interaction, configuration, and business logic.

**Verify:**

- Record the exact artifact, environment, ASVS version and requirements, tools or methods, inputs, results, limitations, findings, and reviewer.
- Reproduce material findings, fix their cause, and retest the released or release-candidate artifact.
- Map untested requirements and residual risks to an approved exception or block completion.

**Exceptions:** A check that would damage real systems or data can use the closest safe environment; document every material difference and the alternate evidence.

### SECURITY-APPLICATION-016 — Prepare vulnerability and incident response

**Level:** required  
**Applies when:** Operating an application or releasing a security-relevant component.

Maintain owned paths to receive vulnerability reports and security alerts, triage impact, contain exposure, revoke credentials and sessions, preserve protected evidence, correct the cause, restore safely, notify required parties, and verify recovery. Define severity, response timing, decision authority, communication boundaries, and lessons that feed requirements and threat models.

**Why:** Delayed ownership and improvised containment increase attacker time, evidence loss, user harm, and recurrence.

**Verify:**

- Confirm public or internal reporting routes reach monitored owners without requiring public disclosure of sensitive details.
- Exercise a representative application incident, including credential revocation, containment, evidence handling, restore, communication decision, and post-recovery checks.
- Trace past findings and incidents to remediation, retest, updated monitoring, and threat-model or control changes.

**Exceptions:** Response details can remain access-restricted, but owners, contact paths, and exercises must still be verifiable by authorized reviewers.

### SECURITY-APPLICATION-017 — Defend model workflows against prompt injection

**Level:** required  
**Applies when:** A model or agent receives untrusted user input, retrieved content, files, webpages, messages, tool results, or memory while it can access private context or tools.

Keep untrusted data out of high-authority instruction channels and executable templates. Preserve source and trust labels, extract only validated structured fields for privileged decisions, and enforce authorization, data release, recipients, and action policy outside the model. Treat direct and indirect prompt injection as an expected attack rather than a prompt-quality defect.

**Why:** A model can follow malicious instructions embedded in ordinary content and use its legitimate tools as a confused deputy.

**Verify:**

- Trace dynamic data into system and developer instructions, tool descriptions, policies, queries, commands, and inter-agent messages.
- Test encoded, quoted, multilingual, hidden, retrieved, tool-returned, and multi-step adaptive injection attempts.
- Confirm successful model manipulation still cannot cross environmental, permission, approval, or data-release boundaries.

**Exceptions:** A model with no untrusted input, private context, or action capability can use a narrower threat assessment when those boundaries are verified.

### SECURITY-APPLICATION-018 — Contain model-driven execution

**Level:** required  
**Applies when:** A model or agent can execute code, browse, manipulate files, call external services, access internal systems, or operate without per-step human review.

Constrain process, filesystem, credential, network, tool, data, tenant, time, memory, storage, and spend access independently of model behavior. Keep credentials outside the runtime unless needed, restrict egress and tool scopes, isolate runs, and reset mutable state. Do not rely on prompts, model training, or classifiers as the only barrier.

**Why:** Probabilistic safeguards reduce unsafe behavior but cannot create a hard boundary around a capable or compromised agent.

**Verify:**

- Attempt access to disallowed files, processes, credentials, network ranges, tools, tenants, data, and resources.
- Test poisoned dependencies, webpages, files, tool outputs, and environment artifacts against the boundary.
- Confirm operators can stop and isolate a run and that reset removes unauthorized durable state.

**Exceptions:** Local execution on a user-controlled device requires explicit scope, recoverable change, least privilege, protected credentials, and approval before material external or destructive effects.

### SECURITY-APPLICATION-019 — Approve the exact agent action

**Level:** required  
**Applies when:** A model-selected action can disclose data, communicate externally, spend money, change access, delete or publish content, run privileged code, or create another material side effect.

Require an approval or pre-authorized policy that binds the exact actor, action, target, data, scope, cost, and material consequence. Reopen approval when any bound value changes. Keep proposal, approval, and execution identities separate when risk requires it, and verify final state after execution.

**Why:** A generic approval can be reused for a different target or expanded payload after the person has reviewed it.

**Verify:**

- Test changed-after-approval, stale, replayed, wrong-target, partial, duplicate, and fallback-tool actions.
- Confirm denial, timeout, or unavailable approval prevents execution and does not broaden authority.
- Compare approved values, executed tool arguments, and final external state.

**Exceptions:** A low-impact recurring action can operate under a visible, bounded, time-limited policy with revocation, monitoring, and an accepted worst-case effect.

## Guidance

Use the threat model to select depth. A static public page, a tenant-aware API, an administrative console, and a financial workflow do not need identical controls or evidence. They all need an explicit boundary and an honest reason for what was selected.

Treat authentication, authorization, and tenancy as different questions. Authentication establishes an identity. Authorization decides whether that identity can perform this action on this object in this state. Tenant isolation prevents one customer boundary from becoming another's. Test all three independently.

Prefer maintained framework controls and typed, parameterized APIs over custom filters. Central controls reduce drift, but each caller still needs tests proving the intended policy applies to its route, job, and object.

Security evidence can itself be sensitive. Redact secrets and personal data, restrict exploit details and architecture maps, and keep only what is needed to reproduce the result and make the risk decision.

Reference ASVS requirements with the version, for example `v5.0.0-1.2.5`, because identifiers can change between releases. Record why a requirement applies or does not apply instead of claiming an ASVS level from a partial scan.

## Examples

### Tenant authorization

Non-compliant: The interface hides another tenant's projects, but the API accepts any project ID after checking only that the caller is signed in.

Compliant: The service derives tenant membership from trusted session state and checks action, tenant, project, and record state on every route and job. Tests swap user, role, tenant, object, and membership state and cover search, export, and bulk endpoints.

### Server-side fetch

Non-compliant: An import endpoint blocks URLs containing `localhost` but follows redirects and allows encoded or private IP addresses.

Compliant: The service permits required protocols, resolves and validates every effective destination, blocks local and metadata ranges, restricts egress, rechecks redirects, and limits time and response size. Tests cover IPv4, IPv6, DNS changes, redirects, and alternate encodings.

### Exposed credential

Non-compliant: A secret committed to source is removed in a later commit and considered fixed.

Compliant: The credential is revoked, dependent systems receive a new scoped value from the approved secret system, access logs are reviewed, exposure is handled through incident response, and history or caches are addressed according to the incident decision.

## Sources

- OWASP Foundation, [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/), version 5.0.0 released May 30, 2025. Reviewed August 13, 2026.
- OWASP Foundation, [OWASP Top 10:2025](https://owasp.org/Top10/2025/). Reviewed August 13, 2026. The Top 10 is an awareness document; this standard uses ASVS for verifiable control requirements.
- National Institute of Standards and Technology, [Secure Software Development Framework Version 1.1](https://csrc.nist.gov/pubs/sp/800/218/final), NIST SP 800-218, February 3, 2022. Reviewed August 13, 2026.
- National Institute of Standards and Technology, [NIST SP 800-63-4 Digital Identity Guidelines](https://pages.nist.gov/800-63-4/), final July 2025. Reviewed August 13, 2026. Apply its assurance requirements through the governing identity and security policy.
- OWASP Foundation, [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/). Reviewed August 13, 2026. Relevant implementation references include Authentication, Session Management, Authorization, Input Validation, Cross-Site Request Forgery Prevention, File Upload, Server-Side Request Forgery Prevention, Cryptographic Storage, Secrets Management, and Logging.
- Anthropic, [Mitigating the risk of prompt injections in browser use](https://www.anthropic.com/research/prompt-injection-defenses), November 24, 2025. Reviewed August 13, 2026.
- Anthropic, [How we contain Claude across products](https://www.anthropic.com/engineering/how-we-contain-claude). Reviewed August 13, 2026.
- OpenAI, [Safety in building agents](https://developers.openai.com/api/docs/guides/agent-builder-safety). Reviewed August 13, 2026.
