---
id: WRITING-FUNCTIONAL
title: Functional writing
description: Defines clear, consistent, actionable writing for documentation, explanations, summaries, change records, interface text, reports, and messages.
type: standard
status: stable
governance_status: active
owners: [content, standards]
last_reviewed: 2026-08-12
review_by: 2027-02-12
stale_after: 2027-02-12
applies_to: [functional-writing]
tags: [writing, documentation, communication, content]
depends_on: [FND-EVIDENCE, FND-TRUST]
generated: { by: codex/gpt-5, at: "2026-08-12T00:00:00Z" }
sources:
  - id: asd-ste100
    resource: https://asd-ste100.org/
    title: ASD-STE100 Simplified Technical English
    author: organization:asd-stemg
  - id: google-developer-style
    resource: https://developers.google.com/style
    title: Google developer documentation style guide
    author: organization:google
  - id: tim-pope-git-commit
    resource: https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
    title: A Note About Git Commit Messages
    author: human:tim-pope
  - id: chris-beams-git-commit
    resource: https://cbea.ms/git-commit/
    title: How to Write a Git Commit Message
    author: human:chris-beams
---

# Functional writing

Functional writing must help its intended reader understand or act correctly after one read. This standard covers documentation, explanations, answers, summaries, change records, interface text, reports, and messages. It does not govern fiction or marketing copy unless the task adopts it explicitly.

When rules compete, protect accuracy first, then clarity, consistency, and brevity. Record an exception instead of publishing text that is false or harder to understand.

## Rules

### WRITING-FUNCTIONAL-001 — Define the reader and purpose

**Level:** required  
**Applies when:** Creating or materially revising functional writing.

Write for a named or reasonably inferable reader and one primary purpose. Include the context that the least-informed intended reader needs to understand or act.

**Why:** Text that assumes hidden context causes errors and cannot serve newcomers or later readers.

**Verify:**

- Identify the intended reader and the action, decision, or understanding the artifact must support.
- Confirm that the artifact defines necessary terms, prerequisites, and consequences.

**Exceptions:** Space-constrained interface text can rely on context that is visible on the same screen.

### WRITING-FUNCTIONAL-002 — Preserve accuracy over style

**Level:** required  
**Applies when:** Any writing rule would remove a necessary qualification, change meaning, or make the text misleading.

Keep the accurate meaning. Mark material uncertainty as an assumption, limitation, or unknown. Do not claim certainty, simplicity, safety, or completion beyond the available evidence.

**Why:** Clear prose that states the wrong thing creates more risk than awkward but accurate prose.

**Verify:**

- Compare factual claims, requirements, and completion statements with their source evidence.
- Confirm that edits for length or tone did not remove a condition, exception, or risk.

**Exceptions:** None.

### WRITING-FUNCTIONAL-003 — Use consistent, concrete terms

**Level:** required  
**Applies when:** An artifact names a concept, control, command, path, value, or measurement more than once.

Use one term for each concept. Use exact names and concrete values where they affect interpretation or action. Define an acronym or specialized term before its first use unless the intended reader can be expected to know it.

**Why:** Synonyms, vague quantities, and unexplained terms make readers infer whether two phrases mean the same thing.

**Verify:**

- Search for alternate names for key concepts and reconcile unintended variation.
- Check names, values, paths, and labels against the artifact or system they describe.

**Exceptions:** Preserve an exact quotation, external name, or interface label when changing it would be inaccurate.

### WRITING-FUNCTIONAL-004 — Put the outcome before supporting detail

**Level:** required  
**Applies when:** Writing an answer, explanation, report, summary, document, or message with supporting detail.

State the result, decision, request, or main claim first. Start each paragraph with its topic, and keep each paragraph focused on one topic.

**Why:** Readers can determine relevance before spending time on background or detail.

**Verify:**

- Read only the opening sentence and headings; confirm that they convey the artifact's purpose and outline.
- Confirm that each paragraph supports one identifiable topic.

**Exceptions:** A required legal, safety, or operational warning must appear before the action it affects.

### WRITING-FUNCTIONAL-005 — Write direct, complete sentences

**Level:** recommended  
**Applies when:** Writing explanatory prose or instructions.

Prefer short, common words, active voice, present tense, and explicit subjects. Keep one main instruction or claim in each sentence. Remove filler, unexplained idioms, figurative language, and unnecessary noun forms.

**Why:** Direct sentence structures reduce ambiguity for global readers and people reading under time pressure.

**Verify:**

- Review sentences longer than about 25 words and paragraphs longer than six sentences; split them when that improves clarity.
- Search for filler, avoidable passive voice, stacked noun phrases, and terms that carry more than one intended meaning.

**Exceptions:** Use passive voice when the actor is unknown, irrelevant, or intentionally withheld. Keep a longer sentence when splitting it would obscure the relationship between its parts.

### WRITING-FUNCTIONAL-006 — Make procedures executable

**Level:** required  
**Applies when:** Writing instructions that a reader must follow.

State the goal and prerequisites before the steps. Put a condition or warning before the action it governs. Address the reader as “you” or use the imperative. Give one action per step, and state a non-obvious expected result.

**Why:** Readers must know whether a step applies, how to perform it, and whether it succeeded before they continue.

**Verify:**

- Follow the procedure in order using only the information in the artifact.
- Confirm that a sequence of more than two steps uses a numbered list and that each step has one primary action.

**Exceptions:** A compact reference can omit goals or results that are explicit in the surrounding context.

### WRITING-FUNCTIONAL-007 — Match structure to meaning

**Level:** required  
**Applies when:** Organizing headings, paragraphs, lists, warnings, or links.

Use numbered lists for sequences and bulleted lists for unordered sets. Keep list items grammatically parallel. Use headings that describe their sections and link text that describes its destination.

**Why:** Predictable structure lets readers scan without losing relationships or sequence.

**Verify:**

- Confirm that list type preserves whether order matters.
- Scan only headings and links; confirm that each remains meaningful out of surrounding prose.

**Exceptions:** Follow a required product or publishing template when its structure differs.

### WRITING-FUNCTIONAL-008 — Format names and alternatives accessibly

**Level:** required  
**Applies when:** Referring to interface controls, commands, filenames, paths, literal values, links, or meaningful images.

Copy interface labels exactly and format them according to the publishing system. Distinguish commands, filenames, paths, and literal values from prose. Give every meaningful image an equivalent text alternative.

**Why:** Exact labels and semantic formatting help readers find controls, distinguish literals, and access non-text content.

**Verify:**

- Compare labels and literals with the source interface or artifact.
- Inspect meaningful images for useful alternative text and decorative images for appropriate omission from assistive output.

**Exceptions:** Plain-text media can use unambiguous quotation or delimiters when semantic formatting is unavailable.

### WRITING-FUNCTIONAL-009 — Write change summaries for scanning

**Level:** required  
**Applies when:** Writing a commit subject, pull request title, change-log title, or another summary that describes a proposed or completed change.

Use a short imperative summary that names the outcome of the change. Capitalize its first word and omit a trailing period. Separate a body from its summary with a blank line. Use the body for context, rationale, effects, risks, or rejected alternatives that the artifact itself does not show.

**Why:** A consistent summary works in history, review lists, release notes, and automation without requiring the body.

**Verify:**

- Confirm that “If applied, this change will [summary]” forms a grammatical sentence.
- For Git commits, review subjects over about 50 characters and wrap plain-text body lines at 72 characters when repository conventions do not specify another format.

**Exceptions:** Follow an established repository or platform convention when it conflicts with capitalization, length, prefix, or punctuation rules. A trivial change can omit the body.

### WRITING-FUNCTIONAL-010 — Review the final text in context

**Level:** required  
**Applies when:** Functional writing is ready for delivery or publication.

Inspect the final rendered or plain-text artifact in its intended medium. Check accuracy, terminology, opening summary, structure, brevity, accessibility, and the reader's ability to act.

This rule specializes `AGENT-VERIFICATION-002` for functional writing. Use this rule's writing checks as part of that required final-artifact inspection, and report the result under `AGENT-VERIFICATION-005` rather than creating a second review record.

**Why:** Source text alone does not reveal broken wrapping, hidden context, inaccessible alternatives, or formatting that changes meaning.

**Verify:**

- Review the artifact in its delivery format and run any available spelling, link, terminology, or style checks.
- Confirm that a reader with the intended minimum context can understand or act after one read.

**Exceptions:** If the intended medium is unavailable, inspect the closest available representation and report the limitation.

## Guidance

Use about 20 words as a review trigger for an instruction and about 25 words for a descriptive sentence. These are diagnostic thresholds, not correctness tests. A six-sentence paragraph and a noun phrase with more than three nouns also deserve review.

Prefer verbs over noun forms: “Install the package,” not “Perform the installation of the package.” Remove words that do not change meaning, including “simply,” “just,” “easily,” “basically,” “actually,” “very,” and “really.” Never describe a task as easy or obvious.

Write dates as `2026-08-12` or “August 12, 2026.” Avoid relative terms such as “currently,” “recently,” and “soon” when a version, state, or date would remain accurate longer. Use requirement words precisely: required behavior uses “must”; permission or capability uses “can”; uncertainty uses “might.”

Use sentence case for titles and headings, the serial comma, and simple contractions in conversational documentation and messages. Avoid contractions in formal specifications when they could weaken precision. Spell out zero through nine and use numerals for 10 and above unless an interface, specification, or domain convention differs.

## Examples

### Consistent terms

Non-compliant: “Sign in to the console. If you cannot log in, reset your password.”

Compliant: “Sign in to the console. If you cannot sign in, reset your password.”

### Executable instruction

Non-compliant: “Please make sure permissions are configured correctly and try importing again.”

Compliant: “To import contacts, allow contact access in **Settings**. Then try the import again.”

### Change summary

Non-compliant: “Added rate limiting to login.”

Compliant: “Add rate limits to sign-in attempts”

## Sources

- ASD Simplified Technical English Maintenance Group, [ASD-STE100 Simplified Technical English](https://asd-ste100.org/), Issue 9, January 15, 2025. Reviewed August 12, 2026.
- Google, [Google developer documentation style guide](https://developers.google.com/style). Reviewed August 12, 2026.
- Tim Pope, [A Note About Git Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html), April 19, 2008. Reviewed August 12, 2026.
- Chris Beams, [How to Write a Git Commit Message](https://cbea.ms/git-commit/). Reviewed August 12, 2026.
