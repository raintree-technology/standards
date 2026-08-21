---
id: FND-EVIDENCE
title: Evidence and claims
description: Requires decisions and completion claims to match the strength and limits of available evidence.
type: foundation
status: stable
governance_status: active
owners: [standards]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [all-work]
tags: [evidence, research, verification]
generated: { by: codex/gpt-5, at: "2026-08-13T19:35:12Z" }
sources:
  - id: nist-engineering-statistics
    resource: https://www.nist.gov/programs-projects/nistsematech-engineering-statistics-handbook
    title: NIST/SEMATECH Engineering Statistics Handbook
    author: organization:nist
  - id: nist-tn-1297
    resource: https://www.nist.gov/pml/nist-technical-note-1297
    title: Guidelines for Evaluating and Expressing the Uncertainty of NIST Measurement Results
    author: organization:nist
  - id: anthropic-agent-evals
    resource: https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
    title: Demystifying evals for AI agents
    author: organization:anthropic
  - id: openai-evaluation
    resource: https://developers.openai.com/api/docs/guides/evaluation-best-practices
    title: Evaluation best practices
    author: organization:openai
  - id: scale-swe-bench-pro
    resource: https://scale.com/blog/swe-bench-pro
    title: SWE-Bench Pro - Raising the Bar for Agentic Coding
    author: organization:scale-ai
---

# Evidence and claims

Decisions and completion claims must match the strength, scope, and freshness of the available evidence. This foundation applies to research, analysis, diagnosis, measurement, reviews, and reports of completed work.

## Rules

### FND-EVIDENCE-001 — Separate observation, inference, and recommendation

**Level:** required  
**Applies when:** Reporting research, analysis, diagnosis, or results.

Label or phrase material statements so readers can distinguish what was directly observed, what was inferred from those observations, and what action is recommended.

**Why:** A reader cannot judge risk when interpretation is presented as a measured or inspected fact.

**Verify:**

- Trace consequential factual claims to an artifact, output, measurement, or source.
- Identify assumptions used to connect the evidence to an inference or recommendation.

**Exceptions:** Common background facts do not need labels when they are stable, uncontested, and immaterial to the decision.

### FND-EVIDENCE-002 — Use current primary sources for volatile claims

**Level:** required  
**Applies when:** A claim depends on current law, platform behavior, vendor limits, pricing, security advice, search behavior, or an active standard.

Verify the claim against a current primary or authoritative source and place the source close enough that a reviewer can identify what it supports. Record the publication, version, or review date when freshness affects the decision.

**Why:** Secondary summaries and remembered behavior can remain plausible after the underlying rule or product changes.

**Verify:**

- Open each cited source and confirm that it directly supports the claim.
- Check the source date, version, jurisdiction, and product scope.
- Revalidate rather than relying only on a prior `last_reviewed` date.

**Exceptions:** If no primary source is available, cite the strongest available evidence, explain the limitation, and avoid stronger certainty than that evidence supports.

### FND-EVIDENCE-003 — Do not claim unperformed verification

**Level:** prohibited  
**Applies when:** Describing tests, reviews, deployments, measurements, user behavior, or completion.

Never state or imply that a check ran, passed, covered a condition, or proved an outcome when it did not.

**Why:** False verification hides uncertainty and can cause another person to accept risk they would otherwise investigate.

**Verify:**

- Match every completion statement to actual output, an inspected artifact, or a clearly labeled manual observation.
- Use precise status such as “not run,” “failed,” “partially inspected,” or “not available” where applicable.

**Exceptions:** None.

### FND-EVIDENCE-004 — Match confidence to evidence quality

**Level:** required  
**Applies when:** Drawing conclusions from analytics, experiments, interviews, incidents, simulations, or partial inspection.

State limitations that could materially change the conclusion, including sample size, selection bias, missing data, confounding, instrumentation gaps, environmental differences, and uninspected scope.

**Why:** A result can be accurate for the observed sample while failing to generalize to the decision population or operating environment.

**Verify:**

- Record the population, period, environment, sample, exclusions, and missing scope relevant to the conclusion.
- Confirm that words such as “caused,” “proves,” “all,” and “safe” are supported by the study or inspection design.

**Exceptions:** None.

### FND-EVIDENCE-005 — Preserve evidence provenance

**Level:** required  
**Applies when:** Evidence affects a decision, release, exception, or material claim.

Record enough provenance for another reviewer to locate and interpret the evidence: source, version or commit, query or method, time period, environment, and relevant parameters.

**Why:** A screenshot, number, or statement without origin cannot be reproduced or distinguished from stale evidence.

**Verify:**

- Follow the recorded reference to the underlying artifact or repeatable method.
- Confirm that copied values retain units, filters, and time boundaries.

**Exceptions:** Do not include secrets or personal data in the record; use a protected reference or redacted summary instead.

### FND-EVIDENCE-006 — Resolve material conflicting evidence

**Level:** required  
**Applies when:** Credible sources or checks support different conclusions.

Report the conflict, compare source authority, freshness, scope, and method, and state why one interpretation is preferred or why the decision remains unresolved.

**Why:** Silently selecting convenient evidence creates confirmation bias and hides decision risk.

**Verify:**

- Include the material conflicting result in the decision record.
- Document the comparison or the additional check used to resolve it.

**Exceptions:** Clearly irrelevant results can be excluded when the reason is recorded.

### FND-EVIDENCE-007 — Define quantitative results and their uncertainty

**Level:** required  
**Applies when:** A measured value, estimate, rate, comparison, or threshold materially affects a decision.

Define the quantity, unit, population, method, time basis, aggregation, rounding, and uncertainty or variability needed to interpret the result. When reporting an interval or confidence statement, identify how it was calculated and what it represents.

**Why:** A number without its measurement definition and uncertainty can appear more precise, comparable, or general than the method supports.

**Verify:**

- Reproduce the reported value from the recorded method, inputs, filters, units, and time period.
- Confirm repeated measurements, sampling variation, model uncertainty, and systematic limitations are represented where material.
- Check that rounded values and comparisons do not imply unsupported precision.

**Exceptions:** Exact deterministic counts can omit statistical uncertainty when completeness and counting logic are verified; they must still define scope, unit, and time.

### FND-EVIDENCE-008 — Measure variable systems with repeated trials

**Level:** required  
**Applies when:** A stochastic model, agent, heuristic, human-review process, or nondeterministic environment materially affects an outcome.

Run enough independent trials to characterize variability and report the aggregation that matches real use. Distinguish typical per-attempt performance, success after retries or candidate selection, consistent success across repeated use, worst material failures, latency, and cost. Do not present a selected successful run as representative.

**Why:** A system can look reliable in one demonstration while failing often, inconsistently, or expensively across repeated use.

**Verify:**

- Record trial count, sampling settings, environment reset, retry or selection policy, aggregation, and uncertainty.
- Inspect per-task and segment distributions, not only the overall mean or best result.
- Confirm the reported measure matches how many attempts and failures a real user or system will experience.

**Exceptions:** A deterministic operation can use one run when determinism and environment stability are themselves verified.

### FND-EVIDENCE-009 — Protect evaluation validity

**Level:** required  
**Applies when:** A benchmark, evaluation set, rubric, grader, simulation, or test environment supports a capability or release claim.

Use tasks and environments that represent the target work, including important edge and failure cases. Separate development from held-out evaluation, track exposure and contamination risk, freeze material task and grader versions for comparisons, and confirm a reference solution can pass without hidden expectations.

**Why:** Memorized tasks, changing environments, one-sided samples, and invalid graders can improve a score without improving real performance.

**Verify:**

- Record task provenance, population coverage, partitions, exposure history, environment, dependencies, rubric, and grader versions.
- Test both when a behavior should occur and when it should not, plus valid alternative solutions.
- Reproduce a sample of passes and failures and inspect for leakage, flakiness, impossible tasks, and implementation-specific grading.

**Exceptions:** An exploratory public benchmark can guide investigation when its contamination and representativeness limits are stated and no deployment claim rests on it alone.

### FND-EVIDENCE-010 — Validate judgment-based graders

**Level:** required  
**Applies when:** A person, model, rubric, proxy metric, or composite score judges quality that cannot be checked directly.

Define each criterion independently, identify the evidence available to the grader, and calibrate grader decisions against qualified human review or an authoritative outcome. Measure disagreement and material false acceptance and rejection. Keep final-state correctness, required process, policy compliance, style, latency, and cost separate unless the decision explicitly defines a justified combination.

**Why:** A plausible grader can reward verbosity, expected wording, or a preferred path while missing incorrect state or rejecting a valid alternative.

**Verify:**

- Review representative clear, borderline, adversarial, and disagreement cases with qualified raters.
- Test sensitivity to irrelevant wording, ordering, identity, formatting, and reference-answer phrasing.
- Trace composite weights and pass thresholds to the decision they are intended to support.

**Exceptions:** Exact deterministic criteria can omit human calibration when they directly inspect the required outcome.

## Guidance

Use the narrowest claim supported by the evidence. A passing check supports the behavior, inputs, and environment it exercised; it does not prove the entire system correct. A metric movement is an observation until the design supports a causal interpretation.

Prefer inspectable evidence over confidence language. “The staging migration processed 8.2 million rows in 41 minutes with no lock wait above 200 ms” is more useful than “The migration looks safe.” Preserve failed checks and null results when they affect interpretation.

For quantitative evidence, distinguish repeatability under the same conditions from reproducibility under changed conditions. Report which conditions changed when using a result to predict another environment.

When evidence is expensive or unavailable, narrow the decision, limit exposure, or seek an approved exception. Do not replace missing evidence with stronger prose.

## Examples

### Diagnosis

Non-compliant: “The cache caused the latency spike.”

Compliant: “Request latency rose after cache hit rate fell from 91% to 54%. The timing supports the cache as the leading hypothesis, but no trace links the misses to the slow requests.”

### Verification

Non-compliant: “The page is accessible.”

Compliant: “Keyboard navigation and 400% reflow passed on the checkout flow. Screen-reader announcements were not checked because the test device was unavailable.”

## Sources

- National Institute of Standards and Technology, [NIST/SEMATECH Engineering Statistics Handbook](https://www.nist.gov/programs-projects/nistsematech-engineering-statistics-handbook). Reviewed August 13, 2026.
- National Institute of Standards and Technology, [Guidelines for Evaluating and Expressing the Uncertainty of NIST Measurement Results](https://www.nist.gov/pml/nist-technical-note-1297), Technical Note 1297. Reviewed August 13, 2026.
- Anthropic, [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents), January 9, 2026. Reviewed August 13, 2026.
- OpenAI, [Evaluation best practices](https://developers.openai.com/api/docs/guides/evaluation-best-practices). Reviewed August 13, 2026.
- Scale AI, [SWE-Bench Pro: Raising the Bar for Agentic Coding](https://scale.com/blog/swe-bench-pro), September 19, 2025. Reviewed August 13, 2026.
