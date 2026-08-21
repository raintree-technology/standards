---
id: SECURITY-SECRETS
title: Secrets management with Infisical
description: Defines Infisical as the system of record for product secrets and governs scoping, identity, delivery, rotation, detection, recovery, control-plane operation, and repository adoption.
type: standard
status: draft
governance_status: draft
owners: [security, platform, engineering, operations]
last_reviewed: 2026-08-16
review_by: 2026-11-16
stale_after: 2026-11-16
applies_to: [software-change, service-change, repository-change, deployment-change, incident-response]
tags: [security, secrets, credentials, infisical, identity, rotation]
depends_on: [FND-CHANGE, FND-EVIDENCE, AGENT-VERIFICATION]
generated: { by: codex/gpt-5, at: "2026-08-17T06:11:16Z" }
sources:
  - id: infisical-secrets-management
    resource: https://infisical.com/docs/documentation/platform/secrets-mgmt/overview
    title: Infisical Secrets Management
    author: organization:infisical
  - id: infisical-organization-structure
    resource: https://infisical.com/docs/documentation/guides/organization-structure
    title: Infisical Organizational Structure Blueprint
    author: organization:infisical
  - id: infisical-identities-overview
    resource: https://infisical.com/docs/documentation/platform/identities/overview
    title: Infisical User and Machine Identities
    author: organization:infisical
  - id: infisical-machine-identities
    resource: https://infisical.com/docs/documentation/platform/identities/machine-identities
    title: Infisical Machine Identities
    author: organization:infisical
  - id: infisical-rbac
    resource: https://infisical.com/docs/documentation/platform/access-controls/role-based-access-controls
    title: Infisical Role-based Access Controls
    author: organization:infisical
  - id: infisical-additional-privileges
    resource: https://infisical.com/docs/documentation/platform/access-controls/additional-privileges
    title: Infisical Additional Privileges
    author: organization:infisical
  - id: infisical-access-requests
    resource: https://infisical.com/docs/documentation/platform/access-controls/access-requests
    title: Infisical Access Requests
    author: organization:infisical
  - id: infisical-change-approvals
    resource: https://infisical.com/docs/documentation/platform/pr-workflows
    title: Infisical Approval Workflows
    author: organization:infisical
  - id: infisical-github-actions
    resource: https://infisical.com/docs/integrations/cicd/githubactions
    title: Infisical GitHub Actions
    author: organization:infisical
  - id: infisical-kubernetes-auth
    resource: https://infisical.com/docs/documentation/platform/identities/kubernetes-auth
    title: Infisical Kubernetes Auth
    author: organization:infisical
  - id: infisical-secret-delivery
    resource: https://infisical.com/docs/documentation/platform/secrets-mgmt/concepts/secrets-delivery
    title: Infisical Fetching Secrets
    author: organization:infisical
  - id: infisical-local-development
    resource: https://infisical.com/docs/documentation/guides/local-development
    title: Infisical Secret Management in Development Environments
    author: organization:infisical
  - id: infisical-project-config
    resource: https://infisical.com/docs/cli/project-config
    title: Infisical Project Config File
    author: organization:infisical
  - id: infisical-secret-reference
    resource: https://infisical.com/docs/documentation/platform/secret-reference
    title: Infisical Secret Referencing and Importing
    author: organization:infisical
  - id: infisical-secret-syncs
    resource: https://infisical.com/docs/integrations/secret-syncs/overview
    title: Infisical Secret Syncs
    author: organization:infisical
  - id: infisical-secret-rotation
    resource: https://infisical.com/docs/documentation/platform/secret-rotation/overview
    title: Infisical Secret Rotation
    author: organization:infisical
  - id: infisical-dynamic-secrets
    resource: https://infisical.com/docs/documentation/platform/secrets-mgmt/concepts/dynamic-secrets
    title: Infisical Dynamic Secrets
    author: organization:infisical
  - id: infisical-secret-versioning
    resource: https://infisical.com/docs/documentation/platform/secret-versioning
    title: Infisical Secret Versioning
    author: organization:infisical
  - id: infisical-pit-recovery
    resource: https://infisical.com/docs/documentation/platform/pit-recovery
    title: Infisical Point-in-Time Recovery
    author: organization:infisical
  - id: infisical-secret-scanning
    resource: https://infisical.com/docs/documentation/platform/secret-scanning/overview
    title: Infisical Secret Scanning
    author: organization:infisical
  - id: infisical-audit-logs
    resource: https://infisical.com/docs/documentation/getting-started/concepts/audit-logs
    title: Infisical Audit Logs
    author: organization:infisical
  - id: infisical-audit-streams
    resource: https://infisical.com/docs/documentation/platform/audit-log-streams/audit-log-streams
    title: Infisical Audit Log Streams
    author: organization:infisical
  - id: infisical-organization
    resource: https://infisical.com/docs/documentation/platform/organization
    title: Infisical Organization
    author: organization:infisical
  - id: infisical-sso
    resource: https://infisical.com/docs/documentation/platform/sso/overview
    title: Infisical SSO Overview
    author: organization:infisical
  - id: infisical-production-hardening
    resource: https://infisical.com/docs/self-hosting/guides/production-hardening
    title: Infisical Production Hardening
    author: organization:infisical
---

# Secrets management with Infisical

Products and repositories governed by this standard use Infisical as the sole system of record for application secrets. They keep values out of public and ordinary operational artifacts and deliver only what each named human or bounded workload needs, for the environment and time it needs it.

This standard is designed for public reuse. It intentionally omits adopter names, tenant and instance URLs, project and identity identifiers, account details, private topology, and real secret names. Each adopter binds those details in a protected deployment inventory outside this library.

This standard covers passwords, tokens, private keys, signing material, webhook secrets, connection credentials, and sensitive configuration that grants access or would cause material harm if disclosed. A value is public configuration only when its issuer and powers support that classification.

Infisical features differ by deployment and edition. Where this standard requires a control outcome and the native feature is unavailable, use a protected equivalent workflow, record the limitation and evidence, and reassess it at the next review. Feature absence never authorizes a weaker outcome or a shadow secret store.

## Rules

### SECURITY-SECRETS-001 — Make Infisical the sole system of record

**Level:** required  
**Applies when:** A product, service, job, repository, deployment, test harness, or automation creates, stores, receives, or uses an application secret.

Create and maintain the secret in the adopter's approved Infisical instance. Do not make source control, local environment files, CI variables, deployment-platform settings, password managers, tickets, chat, or personal notes authoritative. A destination may hold a controlled replica only when direct delivery is unavailable and `SECURITY-SECRETS-008` and `SECURITY-SECRETS-011` are satisfied.

Do not create new Infisical service tokens; Infisical deprecates them in favor of machine identities. Do not preserve an unmanaged fallback or a second writable source during ordinary operation.

**Why:** Multiple sources and deprecated credentials create unclear ownership, stale values, inconsistent rotation, and incomplete revocation.

**Verify:**

- Trace every runtime secret from its authoritative issuer through its Infisical project, environment, and path to each authorized consumer.
- Compare CI, hosting, orchestration, local-development, password-manager, and support configuration with the private inventory and explain every copy.
- Confirm no new or active deprecated service token remains and every allowed replica has an owner, purpose, lifetime, and removal path.

**Exceptions:** A platform that cannot integrate with Infisical requires a time-bounded security exception naming the alternate protected store, owner, rotation and revocation process, and migration trigger. Emergency values must enter Infisical or be revoked when the emergency ends.

### SECURITY-SECRETS-002 — Align Infisical hierarchy with security boundaries

**Level:** required  
**Applies when:** Creating or changing an Infisical organization, project, environment, folder, secret, or consumer mapping.

Use a separate project for a product or platform domain whose ownership, trust, access population, lifecycle, incident response, and compliance obligations can be governed together. Use distinct environments for deployment and trust boundaries, and paths for consumer permission sets. Keep production values independently issued and separate from development, test, preview, and demonstration values.

Grant and fetch named environments and paths only. Do not use the root path, wildcards, cross-environment access, or shared projects as convenience defaults. Use project templates or reviewed infrastructure-as-code for repeated environments, roles, groups, identities, approval policies, and settings; review the resulting effective configuration before use.

**Why:** A flat or manually inconsistent hierarchy turns one compromised account, workload, or configuration error into access across unrelated systems.

**Verify:**

- Compare organization, project, environment, and path boundaries with current ownership, deployment, data, and threat boundaries.
- Inspect root, wildcard, cross-environment, unused, inherited, template-created, and manually added access.
- Start each consumer with only its documented environment and paths and confirm it works without unrelated values.

**Exceptions:** A shared project or path is allowed only when its owner, access population, rotation event, incident boundary, and lifecycle are genuinely shared and recorded.

### SECURITY-SECRETS-003 — Govern human access by effective privilege

**Level:** required  
**Applies when:** A person receives organization, project, environment, path, secret-value, approval, or administration access.

Use named human accounts, enforced organization identity, strong authentication, bounded sessions, and group or role assignment. Prefer the organization and project `No Access` roles plus scoped custom roles. Minimize organization and project administrators, because built-in roles can span broad resources and administrators can bypass ordinary project boundaries.

Calculate access as the union of every built-in role, custom role, group role, additional privilege, and temporary grant; Infisical permissions are additive. Repeated additional privileges must become an owned custom role. Production reads and changes require temporary access, recorded business need, independent approval, no self-approval, expiration, and immediate removal. Use native access and change approvals when available; otherwise preserve equivalent requests, approvers, scope, duration, decision, and revocation evidence outside Infisical.

Use SSO, MFA, group mapping, and automated provisioning or deprovisioning when supported. Directly remove urgent access in Infisical and the identity provider; do not wait for login-time group synchronization.

**Why:** Broad built-in roles, additive grants, stale group state, and standing production access can silently exceed the intended permission boundary.

**Verify:**

- Reconcile active users, groups, roles, additional privileges, approvals, sessions, and administrators with current owners and duties.
- Test that development users cannot read production, metadata-only roles cannot read values, and read-only roles cannot create, edit, delete, approve, or administer.
- Exercise joining, role change, departure, urgent removal, temporary access expiry, request revocation, and administrator break-glass recovery.

**Exceptions:** Break-glass access must be time-bounded, independently approved when circumstances permit, logged, reviewed after use, and removed immediately after recovery.

### SECURITY-SECRETS-004 — Bound machine identities by permission set and blast radius

**Level:** required  
**Applies when:** CI, a deployed service, a job, an agent, an operator, or another automated consumer authenticates to Infisical.

Create a machine identity for each distinct combination of project, environment, paths, actions, tenant boundary, and compromise impact. Replicas of the same application may share an identity when their permissions and security boundary are identical. Separate identities when environments, tenants, trust, deployment ownership, or required permissions differ.

Use cloud-native, Kubernetes, OIDC, or SPIFFE authentication when supported. Use Universal Auth only when workload identity is unavailable. Use Token Auth only as a governed last resort. Never use a developer account or deprecated service token for a workload.

Bind OIDC to exact issuer, audience, subject, repository, workflow, branch or protected environment, and other required claims; do not use a wildcard when a stable exact value exists. Bind Kubernetes Auth to allowed service-account names, namespaces, audience, and reviewer design. Explicitly set access-token TTL, maximum TTL, use limit, and trusted network ranges to the job or runtime need instead of accepting broad defaults.

**Why:** Identity boundaries based on host count are noisy, while shared, wildcard, or long-lived authentication can expose every secret reachable by a permission set.

**Verify:**

- Reconcile identities with distinct effective permission sets and document every shared identity's replicas and common security boundary.
- Attempt authentication from an unapproved repository, workflow, branch, environment, audience, claim, namespace, service account, network, expired token, and exhausted token.
- Confirm every fallback authentication method has an owner, protected bootstrap credential, rotation, revocation test, and recorded platform limitation.

**Exceptions:** A platform without supported workload identity may use a dedicated Universal Auth or Token Auth configuration under the controls above and a dated reassessment.

### SECURITY-SECRETS-005 — Choose and bound the secret delivery path

**Level:** required  
**Applies when:** Fetching, injecting, exporting, caching, synchronizing, building with, or exposing an Infisical-managed secret.

Choose delivery according to the consumer and refresh contract: CLI process injection for local development; maintained SDK or API for deliberate in-memory runtime fetching; Infisical Agent for VM or container preload; Operator, External Secrets Operator, Agent, or SDK for Kubernetes; and Secret Sync only when the destination cannot fetch directly. Authenticate as the named human or workload and request only the selected environment and paths.

Define startup, refresh, cache, maximum staleness, token-expiry, denied-access, restart, revocation-delay, and cleanup behavior. Do not silently fall back from Infisical or an SDK cache to a legacy environment value. Do not automatically restart production on every remote change without rollout, health, stop, and recovery controls.

Never bake secrets into source, generated code, packages, images, caches, client bundles, mobile applications, source maps, snapshots, command arguments visible to other users, or ordinary logs. Export to a file only when the consumer requires it, using restrictive permissions, an ephemeral protected location, cleanup on success and failure, and exclusion from artifacts, backups, support bundles, and telemetry.

**Why:** A protected source does not help when delivery creates durable copies, stale authorization, hidden fallback, or broad process inheritance.

**Verify:**

- Match each consumer to its documented delivery and refresh method and exercise first fetch, refresh, expiry, denial, outage, stale cache, restart, and revocation.
- Inspect final images, packages, clients, workspaces, files, process arguments, child processes, caches, artifacts, logs, crash reports, and cleanup.
- Confirm unrelated build steps, jobs, containers, and child processes do not inherit the values.

**Exceptions:** A platform-mandated file or synchronized destination must satisfy `SECURITY-SECRETS-008` and `SECURITY-SECRETS-011`.

### SECURITY-SECRETS-006 — Rotate, revoke, and restore at the authoritative issuer

**Level:** required  
**Applies when:** Issuing, changing, rotating, expiring, revoking, restoring, or retiring a secret or consumer.

Assign every secret family an owner, issuer, purpose, consumers, rotation or expiry policy, refresh behavior, and compromise response. Prefer dynamic credentials, then automated dual-phase rotation. During dual-phase rotation, monitor and update consumers before inactive credentials reach revocation. For a continuity-sensitive provider limited to single-phase rotation, disable unattended rotation and use a coordinated maintenance window with immediate consumer refresh and authentication-failure monitoring.

Change or revoke the credential at its authoritative issuer, update Infisical, roll consumers, verify the new value, and prove the old value fails. Editing, deleting, restoring, or rolling back an Infisical value does not change issuer state. Secret versioning and point-in-time recovery may restore stored configuration but cannot reactivate an issuer-revoked credential; validate issuer acceptance before promoting restored state.

**Why:** Store-only rotation and blind rollback can leave exposed credentials valid, restore unusable values, or interrupt consumers.

**Verify:**

- Inspect ownership, age, issuer state, consumer inventory, refresh design, expiry, last rotation, and overdue exceptions without recording values.
- Exercise dynamic expiry or representative dual-phase, single-phase, emergency, and rollback flows through issuer state, delivery, health checks, monitoring, and recovery.
- Confirm retired consumers and identities cannot authenticate or retrieve values and restored values match current issuer state.

**Exceptions:** A non-rotatable credential requires qualified security acceptance, compensating scope and monitoring, and a replacement or vendor-escalation owner.

### SECURITY-SECRETS-007 — Detect exposure before and after publication

**Level:** required  
**Applies when:** Maintaining a repository, pipeline, artifact, or connected source, or when a secret may have entered an unintended location.

Run approved detection on staged changes before commit or merge and on the governed history or release scope in CI. Enable connected-repository monitoring and new-push scans when the available Infisical edition and source platform support them; otherwise run an equivalent owned recurring scan. Protect findings because they may contain live values.

Treat a match as exposed until triage proves it is a false positive or non-secret. Suppress only the narrow finding or path with classification evidence, owner, and review condition. For real exposure, revoke or rotate at the issuer, replace the Infisical value, identify affected consumers and access, preserve protected evidence, review audit events, and follow incident response. Removing visible text or rewriting history alone is not remediation.

**Why:** Copies can survive in clones, caches, forks, artifacts, logs, prompts, and support systems after source is edited.

**Verify:**

- Record scanner and rule versions, staged, history, connected-source, artifact, and release scopes, results, suppressions, and protected finding references.
- Seed a safe test signature to confirm local, CI, and connected-source enforcement detect it without printing a value.
- For an incident, verify issuer-side old-value rejection, consumer recovery, audit review, and disposition of known copies.

**Exceptions:** An unavailable connected-source feature may use equivalent scheduled scanning; scanner limitations never authorize committing a secret.

### SECURITY-SECRETS-008 — Design availability, audit, and recovery

**Level:** required  
**Applies when:** Secret access supports a material service or Infisical, identity, network, cache, or audit availability can affect operation.

Define behavior for unavailable, slow, denied, expired-token, stale-cache, partial, and recovered states. Decide when startup and refresh fail closed, whether a running process may continue with an in-memory value, the maximum stale lifetime, and how operators recover without bypassing controls. Test break-glass access without creating a standing alternate store.

Collect security-relevant Infisical authentication, read, write, permission, identity, approval, rotation, sync, and administration events. Define retention, alert ownership, escalation, and response for unexpected reads, repeated authentication failure, privilege change, break-glass use, overdue rotation, sync drift, and audit-stream loss. Use native immutable logs and external streaming when available; otherwise preserve equivalent protected export and retention evidence.

**Why:** A central manager can become a service dependency, and security-relevant failure becomes invisible without owned audit and alert paths.

**Verify:**

- Exercise outage, latency, denial, token expiry, stale cache, audit-stream interruption, lost alert route, break-glass use, recovery, and post-recovery revocation.
- Trace representative access and administration events through collection, retention, alerting, investigation, and owner response.
- Confirm recovery does not reintroduce a legacy value, broad identity, expired exception, or untracked replica.

**Exceptions:** A disconnected or safety-critical runtime may keep an encrypted, bounded-lifetime replica when its threat model, update channel, revocation delay, and security approval are recorded.

### SECURITY-SECRETS-009 — Migrate without preserving shadow stores

**Level:** required  
**Applies when:** Adopting Infisical in an existing repository, product, service, or environment.

Inventory secret names, issuers, owners, environments, consumers, current stores, copies, authentication methods, and rotation capability without copying values into the record. Create the target Infisical hierarchy and identities, move one bounded consumer group at a time, exercise delivery and failure behavior, then revoke old credentials or remove old store values as appropriate.

Do not retain silent fallback or indefinite dual delivery. A temporary dual path must have an owner, deadline, observable selection behavior, stop condition, and tested removal. Complete migration only when consumers use Infisical, deprecated service tokens and legacy copies are removed or governed by dated exceptions, detection passes, and the private inventory records final state.

**Why:** A migration that leaves active credentials and fallback stores adds dependencies without reducing exposure.

**Verify:**

- Reconcile before-and-after state across source, CI, hosting, orchestration, developer instructions, runtime configuration, password managers, and support systems.
- Confirm each consumer uses its intended identity, environment, paths, delivery method, and failure behavior.
- Verify old-value rejection or deletion, fallback removal, detection results, exception expiry, and owner sign-off.

**Exceptions:** A phased migration may leave explicitly inventoried consumers on the old system until their dated step; each remains governed by a `SECURITY-SECRETS-001` exception.

### SECURITY-SECRETS-010 — Govern the Infisical control plane

**Level:** required  
**Applies when:** Creating, configuring, operating, upgrading, or self-hosting an Infisical organization or instance.

Assign separate accountable owners for security policy, platform operation, recovery, and application-secret content. Govern default organization role, domain verification, SSO enforcement, MFA, session duration, groups, provisioning, project templates, approval policy, audit retention, and administrators as reviewed configuration. Capability-aware substitutes must preserve the same access, approval, expiry, attribution, and retention outcomes.

For self-hosting, require TLS, correct public site configuration, default-deny network access, protected and separated encryption keys, encrypted database backups, tested restore, database availability, capacity monitoring, centralized security logs, owned upgrade cadence, and prompt user and administrator offboarding. Review whether an external KMS is required by the system's threat, recovery, or compliance model. Do not store the Infisical root encryption or authentication keys inside the Infisical secret store they unlock.

**Why:** Strong application-level policy can be bypassed by a weak organization default, privileged administrator, lost encryption key, stale deployment, or untested backup.

**Verify:**

- Compare effective organization and instance configuration with the approved template or infrastructure definition and explain drift.
- Exercise SSO and MFA enforcement, session expiry, provisioning, urgent deprovisioning, administrator recovery, backup restoration, key availability, and upgrade rollback.
- Confirm monitoring covers capacity, database health, authentication, audit delivery, backup age, restore status, certificate expiry, and security updates.

**Exceptions:** Infisical Cloud owns underlying service operation; the customer remains responsible for organization policy, identities, projects, audit use, data classification, and recovery of dependent applications.

### SECURITY-SECRETS-011 — Control resolution, overrides, imports, and sync precedence

**Level:** required  
**Applies when:** Using personal overrides, secret references, imports, inherited values, or Secret Sync.

Restrict personal overrides to named humans in local development. Prohibit them in CI, shared development, test, preview, staging, and production. Document them during troubleshooting and review them separately because ordinary secret reminders may not cover them.

For references and imports, record every source environment and path, effective read expansion, API version, relative-resolution behavior, collision order, unresolved-value behavior, and import depth. The consuming identity must have deliberate access to every referenced value. Do not use cross-environment references to bypass environment separation or rely on implicit collision precedence.

For Secret Sync, approve source, destination, identity, environment, path, initial conflict behavior, key schema, auto-sync, deletion propagation, destination editing policy, removal behavior, and recovery before enabling it. Inventory the destination as a controlled replica. Reconcile immediately after initial and material syncs, detect direct-edit drift, and keep Infisical authoritative.

**Why:** Client-side resolution, last-wins imports, personal branches, and destructive sync options can select an unexpected value or widen access without changing application code.

**Verify:**

- Exercise personal, shared, imported, referenced, missing, duplicate, reordered, cross-environment, unauthorized, and supported API-version cases.
- Preview or safely stage initial sync behavior and test create, update, delete, destination drift, disabled deletion, failure, removal, and recovery.
- Reconcile effective consumer values and permissions without exposing secret contents in ordinary evidence.

**Exceptions:** None for production precedence or destination behavior; every such path must be explicit and tested.

## Guidance

### Repository contract

Each consuming repository should state, without values or private topology:

- the safe Infisical project reference, environments, paths, required names, and owners;
- which commands need secrets and which delivery method they use;
- how developers authenticate and run locally without a `.env` file;
- the permission-set identity used by CI and each deployment class;
- cache, refresh, outage, restart, sync, and revocation behavior; and
- where authorized operators find the private inventory, rotation, recovery, and incident procedures.

An inspected `.infisical.json` may be committed when it contains safe project configuration only. Prefer an explicit development default. Treat branch-to-environment mapping as a convenience, not authorization; never let an ordinary branch select production access without an independently protected workload identity and deployment approval.

### Delivery decision

Prefer the delivery path with the fewest durable copies that meets refresh and availability needs. Runtime fetching improves freshness but adds an online dependency. Agent, Operator, External Secrets Operator, and sync delivery can isolate that dependency but create caches or replicas requiring explicit lifetime and revocation behavior. Select based on the consumer contract, not framework fashion.

### Capability-aware controls

Record the Infisical deployment and edition capabilities used by each production project. When SSO, groups, SCIM, access requests, change approvals, audit streaming, point-in-time recovery, dynamic credentials, automated rotation, or connected-source scanning is unavailable, name the alternate control, evidence location, owner, and review trigger. Do not claim the native feature ran when evidence comes from a substitute.

### Secret or configuration

Classify by capability and harm, not by variable name. A database password and webhook signing key are secrets. A public API origin, project identifier, or identity identifier is normally configuration after inspection. A key labeled publishable is public only if its issuer documents that status and privileged operations are enforced elsewhere.

## Examples

### Additive human access

Non-compliant: A developer's custom role blocks production, so the reviewer assumes a temporary additional privilege cannot grant production reads.

Compliant: The reviewer calculates the union of group roles, custom roles, and additional privileges, finds the production grant, confirms its approved purpose and expiry, and removes it when the task ends.

### Replicas and GitHub OIDC

Non-compliant: Every pod receives a separate identity while all GitHub workflows share one wildcard-bound production identity.

Compliant: Identical replicas share one permission-set identity. Staging and production remain separate. The production GitHub identity binds exact issuer, audience, repository, workflow, and protected environment claims and receives a short-lived token.

### Import collision and personal override

Non-compliant: A production folder imports two folders with the same name and relies on order, while a developer personal override is copied into shared CI to make the build pass.

Compliant: The team removes the collision or gives it explicit tested precedence, verifies every reference permission and API behavior, and confines the documented personal override to the developer's local process.

### SDK cache outage

Non-compliant: The application silently falls back to an old process environment value after its SDK cache expires.

Compliant: The service defines its maximum cache age, continues or fails according to the approved risk decision, alerts on refresh failure, never selects a legacy value, and proves revoked credentials stop working within the declared delay.

### Destructive initial sync

Non-compliant: A new sync overwrites destination secrets and propagates deletion without an inventory or recovery procedure.

Compliant: The owner inventories both sides, selects and reviews initial conflict and deletion behavior, applies a key schema and bounded destination, stages the change safely, reconciles it, detects drift, and tests sync removal.

### Single-phase rotation

Non-compliant: Automatic single-phase rotation invalidates a credential while long-running consumers still cache it.

Compliant: The owner schedules a maintenance window, coordinates refresh, monitors authentication failures, verifies the replacement, and proves the old credential fails before closure.

### Restoring a revoked value

Non-compliant: Point-in-time recovery restores an older Infisical value and the team assumes the external provider accepts it.

Compliant: The team checks issuer state, issues a new credential when the restored value is revoked, updates Infisical, rolls consumers, and verifies both new acceptance and old rejection.

## Sources

Infisical documents secrets by project, environment, and path; additive access control for humans and machine identities; multiple delivery and workload-authentication methods; references, imports, overrides, and syncs; rotation and recovery; scanning and audit; and Cloud or self-hosted operation. Feature availability can differ by edition and deployment, so capability and licensing must be revalidated before relying on a native workflow.

- Infisical, [Secrets Management](https://infisical.com/docs/documentation/platform/secrets-mgmt/overview). Reviewed August 16, 2026.
- Infisical, [Organizational Structure Blueprint](https://infisical.com/docs/documentation/guides/organization-structure). Reviewed August 16, 2026.
- Infisical, [User and Machine Identities](https://infisical.com/docs/documentation/platform/identities/overview). Reviewed August 16, 2026.
- Infisical, [Machine Identities](https://infisical.com/docs/documentation/platform/identities/machine-identities). Reviewed August 16, 2026.
- Infisical, [Role-based Access Controls](https://infisical.com/docs/documentation/platform/access-controls/role-based-access-controls). Reviewed August 16, 2026.
- Infisical, [Additional Privileges](https://infisical.com/docs/documentation/platform/access-controls/additional-privileges). Reviewed August 16, 2026.
- Infisical, [Access Requests](https://infisical.com/docs/documentation/platform/access-controls/access-requests). Reviewed August 16, 2026.
- Infisical, [Approval Workflows](https://infisical.com/docs/documentation/platform/pr-workflows). Reviewed August 16, 2026.
- Infisical, [GitHub Actions](https://infisical.com/docs/integrations/cicd/githubactions). Reviewed August 16, 2026.
- Infisical, [Kubernetes Auth](https://infisical.com/docs/documentation/platform/identities/kubernetes-auth). Reviewed August 16, 2026.
- Infisical, [Fetching Secrets](https://infisical.com/docs/documentation/platform/secrets-mgmt/concepts/secrets-delivery). Reviewed August 16, 2026.
- Infisical, [Secret Management in Development Environments](https://infisical.com/docs/documentation/guides/local-development). Reviewed August 16, 2026.
- Infisical, [Project Config File](https://infisical.com/docs/cli/project-config). Reviewed August 16, 2026.
- Infisical, [Secret Referencing and Importing](https://infisical.com/docs/documentation/platform/secret-reference). Reviewed August 16, 2026.
- Infisical, [Secret Syncs](https://infisical.com/docs/integrations/secret-syncs/overview). Reviewed August 16, 2026.
- Infisical, [Secret Rotation](https://infisical.com/docs/documentation/platform/secret-rotation/overview). Reviewed August 16, 2026.
- Infisical, [Dynamic Secrets](https://infisical.com/docs/documentation/platform/secrets-mgmt/concepts/dynamic-secrets). Reviewed August 16, 2026.
- Infisical, [Secret Versioning](https://infisical.com/docs/documentation/platform/secret-versioning). Reviewed August 16, 2026.
- Infisical, [Point-in-Time Recovery](https://infisical.com/docs/documentation/platform/pit-recovery). Reviewed August 16, 2026.
- Infisical, [Secret Scanning](https://infisical.com/docs/documentation/platform/secret-scanning/overview). Reviewed August 16, 2026.
- Infisical, [Audit Logs](https://infisical.com/docs/documentation/getting-started/concepts/audit-logs). Reviewed August 16, 2026.
- Infisical, [Audit Log Streams](https://infisical.com/docs/documentation/platform/audit-log-streams/audit-log-streams). Reviewed August 16, 2026.
- Infisical, [Organization](https://infisical.com/docs/documentation/platform/organization). Reviewed August 16, 2026.
- Infisical, [SSO Overview](https://infisical.com/docs/documentation/platform/sso/overview). Reviewed August 16, 2026.
- Infisical, [Production Hardening](https://infisical.com/docs/self-hosting/guides/production-hardening). Reviewed August 16, 2026.

The source set was reviewed on 2026-08-16. Freshness ownership and the next review date are recorded in `source-register.yaml`.
