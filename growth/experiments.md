---
id: GROWTH-EXPERIMENTS
title: Growth experiments
description: Requires growth experiments to produce trustworthy learning and durable user and business value.
type: standard
status: stable
governance_status: active
owners: [growth, product, analytics]
last_reviewed: 2026-08-13
review_by: 2027-02-13
stale_after: 2027-02-13
applies_to: [growth-experiment]
tags: [growth, experiments, conversion, retention]
depends_on: [FND-EVIDENCE, FND-TRUST, ANALYTICS-MEASUREMENT]
generated: { by: codex/gpt-5, at: "2026-08-13T18:58:53Z" }
sources:
  - id: nist-experimental-design
    resource: https://www.itl.nist.gov/div898/handbook/pri/section3/pri3.htm
    title: Choosing an experimental design
    author: organization:nist
  - id: nist-doe-terminology
    resource: https://www.itl.nist.gov/div898/handbook/pri/section7/pri7.htm
    title: A Glossary of DOE Terminology
    author: organization:nist
  - id: govuk-ab-testing
    resource: https://www.gov.uk/guidance/ab-testing-comparative-studies
    title: A/B testing comparative studies
    author: organization:uk-government
  - id: govuk-ab-testing-technical
    resource: https://docs.data-community.publishing.service.gov.uk/analysis/abmv/
    title: A/B and multivariate testing
    author: organization:uk-government
---

# Growth experiments

Growth experiments must produce trustworthy learning and durable customer and business value, not merely move a local metric. This standard applies to controlled experiments and other planned comparisons used for acquisition, activation, monetization, engagement, retention, referral, and lifecycle decisions.

## Rules

### GROWTH-EXPERIMENTS-001 — Write the hypothesis before exposure

**Level:** required
**Applies when:** Comparing a treatment with a baseline or changing a growth mechanism to learn from outcomes.

Before exposure, record the user problem, proposed mechanism, target population, treatment and control, expected direction, primary metric, guardrails, analysis method, and decision rule.

**Why:** Plans written after results are visible can conform to noise and obscure which question the experiment was meant to answer.

**Verify:**

- Check that the plan is timestamped before the first eligible exposure.
- Confirm each metric and decision threshold has a governed definition.

**Exceptions:** An exploratory pilot can omit a ship decision rule when it is labeled exploratory and cannot authorize broad release.

### GROWTH-EXPERIMENTS-002 — Define assignment, exposure, and contamination

**Level:** required
**Applies when:** Running a controlled experiment.

Specify eligibility, unit of randomization, allocation, persistence, exposure event, analysis population, concurrent experiments, and ways treatment can leak or interfere between groups.

**Why:** Misaligned assignment and analysis units, unstable treatment, and cross-group exposure weaken causal interpretation.

**Verify:**

- Exercise repeat visits, devices, accounts, shared entities, and enrollment changes.
- Check treatment allocation and exposure counts for unexpected imbalance.
- Document interference and concurrent-experiment risks.

**Exceptions:** A non-randomized comparison must be labeled as such and cannot inherit causal confidence from this standard.

### GROWTH-EXPERIMENTS-003 — Declare one primary decision metric

**Level:** required
**Applies when:** An experiment informs a ship, rollback, or expansion decision.

Choose one primary metric before exposure. Treat additional metrics, segments, and cuts as supporting or exploratory unless a multiple-testing method is declared in advance.

**Why:** Searching many outcomes for a favorable result increases the chance of mistaking noise for an effect.

**Verify:**

- Compare the final report with the preregistered primary metric and analysis population.
- Label analyses added after exposure as exploratory.

**Exceptions:** A true co-primary decision requires a predeclared joint decision rule and appropriate analysis.

### GROWTH-EXPERIMENTS-004 — Protect guardrails and user trust

**Level:** required
**Applies when:** Treatment can affect cost, comprehension, accessibility, cancellations, refunds, complaints, reliability, or long-term retention.

Define acceptable guardrail bounds and the action a breach triggers. Do not ship a primary-metric winner that breaches a material guardrail without accountable review and a recorded exception.

**Why:** A treatment can improve conversion by shifting harm or cost to users, support, or later lifecycle stages.

**Verify:**

- Confirm guardrails cover plausible user and operational harm.
- Inspect the decision record for every breached or inconclusive guardrail.

**Exceptions:** A guardrail can be monitored after launch only when delayed measurement is unavoidable, exposure remains bounded, and stop conditions are defined.

### GROWTH-EXPERIMENTS-005 — Do not stop opportunistically

**Level:** prohibited
**Applies when:** Repeatedly observing experiment results.

Do not end an experiment merely when a desired threshold or favorable interval appears. Use a predeclared fixed horizon or a valid sequential method with its decision boundaries.

**Why:** Repeated unplanned looks create more opportunities for random fluctuation to appear decisive.

**Verify:**

- Compare actual stop time and decision logic with the pre-exposure plan.
- Record operational or safety stops separately from statistical success.

**Exceptions:** Stop immediately for user harm, security, legal, privacy, or severe reliability concerns; do not treat the truncated result as a planned success.

### GROWTH-EXPERIMENTS-006 — Preserve every result and decision

**Level:** required
**Applies when:** An experiment concludes or is stopped.

Record implementation, dates, eligibility, exposure, metric results, uncertainty, guardrails, data-quality checks, limitations, decision, and reusable learning, including negative and inconclusive outcomes.

**Why:** Missing null and negative results cause teams to repeat failed ideas and overestimate the success rate of prior work.

**Verify:**

- Locate the durable experiment record and its link to implementation and analysis.
- Confirm the report distinguishes observed results from explanations proposed afterward.

**Exceptions:** Sensitive results can use restricted storage, but their existence and owner must remain discoverable.

### GROWTH-EXPERIMENTS-007 — Plan for decision sensitivity

**Level:** required
**Applies when:** A controlled experiment is expected to support a consequential decision.

Before exposure, define the smallest effect worth acting on, expected baseline and variance, planned horizon or information requirement, and practical limits on sample or duration.

**Why:** An experiment can be too small to distinguish useful effects or so large that trivial effects appear important.

**Verify:**

- Review the sizing assumptions and their source.
- Compare observed eligibility, exposure, variance, and attrition with the plan before interpreting the result.

**Exceptions:** Exploratory estimation can proceed without a ship threshold when conclusions remain explicitly exploratory.

### GROWTH-EXPERIMENTS-008 — Check experiment integrity before outcomes

**Level:** required
**Applies when:** Analyzing a controlled experiment.

Check allocation balance, eligibility, exposure logging, treatment delivery, missing data, duplicate units, crossovers, and material pre-treatment differences before interpreting outcome metrics.

**Why:** An apparent treatment effect can originate in broken assignment, instrumentation, or analysis populations.

**Verify:**

- Preserve integrity-check results with the analysis.
- Resolve or bound anomalies before making a ship decision.

**Exceptions:** None for causal claims.

### GROWTH-EXPERIMENTS-009 — Evaluate persistence and heterogeneous harm

**Level:** required
**Applies when:** Novelty, learning, delayed cost, repeated exposure, or materially different user groups could change the result.

Inspect the effect over time and across predeclared high-risk or decision-relevant groups. Plan follow-up measurement when the experimental window cannot observe the expected downstream outcome.

**Why:** An aggregate short-term gain can decay, reverse, or conceal harm concentrated in a smaller population.

**Verify:**

- Compare early and later intervals when the mechanism predicts adaptation or fatigue.
- Report group results with uncertainty and without data-mined claims.

**Exceptions:** Skip subgroup analysis when sample and risk do not support it; report the coverage limitation.

### GROWTH-EXPERIMENTS-010 — Separate practical value from statistical evidence

**Level:** required
**Applies when:** Interpreting an experiment for a product or business decision.

Report effect size and uncertainty in natural units, compare them with the predeclared smallest effect worth acting on, and include implementation, user, and operational costs. Do not equate crossing a statistical threshold with a worthwhile change.

**Why:** A precisely estimated trivial effect can be uneconomic or harmful, while an uncertain estimate can still rule out the value needed to justify rollout.

**Verify:**

- Confirm the report includes absolute and relevant relative effects, uncertainty, baseline, and decision threshold.
- Recalculate the decision under plausible implementation and downstream costs.
- Check that “no statistically significant difference” is not presented as proof of equivalence or no effect.

**Exceptions:** Exploratory experiments can omit a ship threshold but must still report effect size, uncertainty, and the absence of a confirmatory decision rule.

### GROWTH-EXPERIMENTS-011 — Do not experiment on known obligations or harm

**Level:** prohibited
**Applies when:** A treatment would withhold a legal, safety, accessibility, privacy, security, or contractual requirement, or expose users to a condition already known to be materially harmful.

Do not randomize whether users receive a required protection or known necessary correction. Use experiments to compare compliant and acceptably safe implementations, not to decide whether to honor the obligation.

**Why:** Uncertainty about conversion or engagement does not justify withholding a known duty or exposing a control group to avoidable harm.

**Verify:**

- Review the treatment and control against governing policies and known incident, complaint, and research evidence before exposure.
- Confirm each arm meets the minimum safety, accessibility, privacy, and contractual baseline.

**Exceptions:** None. A qualified owner must resolve uncertainty about whether an obligation applies before experimentation.

### GROWTH-EXPERIMENTS-012 — Qualify treatment delivery before ramping exposure

**Level:** required
**Applies when:** Launching a controlled experiment in a user-facing environment.

Before interpreting outcomes or expanding exposure, verify assignment, persistence, treatment rendering, event collection, exclusion logic, guardrail alerts, and stop controls across representative browsers, devices, account states, and repeat visits.

**Why:** A statistically sound plan cannot recover from a treatment that users did not receive consistently or instrumentation that labels the wrong population.

**Verify:**

- Complete a documented quality review in every material variant and state.
- Start with bounded exposure, inspect allocation and delivery, then record the decision to expand.
- Confirm operators can disable treatment without corrupting assignment or analysis records.

**Exceptions:** A non-user-facing offline experiment can substitute representative input and pipeline verification for browser and device coverage.

## Guidance

Randomize at the level where treatment can be kept stable and interference is acceptably low. For collaborative products, account or workspace assignment may be safer than person assignment. Match analysis to the assignment design.

Statistical significance is not a business or user-value threshold. Report effect size and uncertainty in the metric's natural units, then apply the predeclared decision rule. Investigate data quality before inventing a behavioral explanation.

Use an experiment only when exposing uncertainty is ethical and operationally safe. Some questions require usability research, staged rollout, simulation, or direct correction rather than withholding a known benefit or exposing a suspected harm.

## Examples

### Primary metric

Non-compliant: The plan lists six “key metrics,” and the report declares success because one segment improved one metric.

Compliant: The plan names activated-workspace rate as primary, refund rate and complaints as guardrails, and revenue per eligible workspace as supporting. The unexpected segment result is labeled exploratory.

### Early stopping

Non-compliant: A dashboard is checked daily and the experiment ends on the first favorable day.

Compliant: The plan uses a fixed two-week horizon covering two weekly cycles. A reliability alert can stop exposure immediately but cannot declare the hypothesis confirmed.

## Sources

- National Institute of Standards and Technology, [Choosing an experimental design](https://www.itl.nist.gov/div898/handbook/pri/section3/pri3.htm), NIST/SEMATECH Engineering Statistics Handbook. Reviewed August 13, 2026.
- National Institute of Standards and Technology, [A Glossary of DOE Terminology](https://www.itl.nist.gov/div898/handbook/pri/section7/pri7.htm), NIST/SEMATECH Engineering Statistics Handbook. Reviewed August 13, 2026.
- UK Government, [A/B testing: comparative studies](https://www.gov.uk/guidance/ab-testing-comparative-studies). Reviewed August 13, 2026.
- UK Government Data Community, [A/B and multivariate testing](https://docs.data-community.publishing.service.gov.uk/analysis/abmv/). Reviewed August 13, 2026.
