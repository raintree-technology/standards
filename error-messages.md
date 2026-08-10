---
id: CONTENT-ERRORS
title: Error messages
type: standard
status: active
owners: [content, product, design]
last_reviewed: 2026-08-10
review_by: 2027-02-10
applies_to: [product-feature, public-web-page, support-experience]
tags: [content, errors, interface-copy]
depends_on: [FND-TRUST]
---

# Error Message Spec

**Purpose:** A repeatable standard for writing, reviewing, and shipping user-facing error messages.

**Scope:** Every surface where a failure is shown to a user — inline validation, toasts, banners, modals, full-page errors, and empty states caused by a failure.

**How to use:** Pick the surface (§3), draft with the required components (§2) and templates (§6), then run the ship checklist (§8). A message ships only when every check passes.

*Adapted from Wix UX's error-message overhaul (Jenni Nadler, "When life gives you lemons, write better error messages," 2022). Full-page and downtime guidance draws on the Website Spec's resilience section (Joost de Valk and contributors, CC BY 4.0).*

---

## 1. The standard

An error message must leave the user knowing three things: **what happened, why, and what to do next.**

Two failure modes are equally unacceptable:

- **Generic** — tells the user nothing. *"Something went wrong."*
- **Unclear** — attempts specificity, but in language the user can't act on. *"Make sure permissions are configured correctly and retry."*

If the system knows the cause and the message doesn't say it, the message fails this spec.

And the best error message is the one that never appears: validate as users type, disable actions until they can succeed, autosave work, and confirm destructive steps. This spec governs what happens when prevention isn't enough.

---

## 2. Required components

Include these, in this order:

| # | Component | Requirement |
|---|---|---|
| 1 | **What happened** | Always. State plainly what did or didn't occur. |
| 2 | **Why** | Whenever known. If the cause is internal or unknown, own it: "a technical issue on our end." |
| 3 | **What's safe** | Whenever true. Say what was preserved: "Your changes were saved as a draft." |
| 4 | **What to do** | Always. One concrete next step — or a descriptive help link ("How do I fix this?") when space is short. |
| 5 | **A way out** | Whenever the fix can fail or the error can recur. Route to support. |

A space-constrained message may drop 2, 3, or 5 — never 1 or 4.

---

## 3. Choosing the surface

Severity picks the surface. The message and its placement are one decision, not two.

| Situation | Surface |
|---|---|
| One field's input needs fixing | Inline, at the field, the moment it can be fixed |
| A non-blocking action failed and no response is required | Toast — only if the user needs to do nothing, or the retry is also available elsewhere |
| An ongoing condition affects the page or app (offline, degraded service, expired plan) | Persistent banner that stays until the condition clears |
| The flow can't continue without the user fixing or deciding something | Modal — interrupt once, with the fix as the primary button |
| The destination itself can't load — not found, no access, server down, or planned maintenance | Full-page error (§5) |

Two rules:

- Match interruption to severity. A blocking failure buried in a toast strands the user; a modal for a typo is hostile.
- Anything that requires action must persist until acted on or dismissed. A self-dismissing toast can never be the only notice.

---

## 4. Rules

### Tone

- Match the stakes. An error interrupts someone's work — sometimes their livelihood. Write like it matters.
- **Never** open with "Oops," "Whoops," "Yikes," "Uh oh," or any playful interjection. No humor in failure states.
- Don't over-apologize. Reserve "please" for situations that are genuinely dire or that the user can't solve — where it adds real empathy, not filler.
- Voice check: a calm, capable person explaining the situation to a friend.

### Blame

- Describe the problem, never the user's mistake. *"This file type isn't supported"* — not *"You uploaded the wrong file type."*
- Own internal failures explicitly when space allows: "an issue on our end."
- Never throw third parties under the bus, even when accurate — it reads as unprofessional. Acceptable: *"We're having trouble connecting to [Service]."* Not acceptable: *"[Service] isn't responding."*

### Language

- Plain words only. Users don't need the mechanism; they need the meaning.
- Error codes, exception names, and request IDs never headline a message. If support needs them, put them in fine print.
- Link text is descriptive: "How do I fix this?" — never "Click here" or a bare "Learn more."
- Common jargon swaps:

| Instead of | Write |
|---|---|
| "Failed to fetch data" | "We couldn't load your data" |
| "Invalid credentials" | "That email or password doesn't match our records" |
| "Authentication required" | "Sign in to continue" |
| "Request timed out" | "This is taking longer than expected" |
| "Unsupported file format" | "This file type isn't supported. Use JPG, PNG, or PDF." |
| "Error 403: Forbidden" | "You don't have access to this page" |

### Specificity

- One distinct cause → one distinct message. A single string reused across unrelated failures is a generic error in disguise.
- Generic copy is a placeholder, not a destination. It's allowed only when the system truly can't know the cause — and it creates a follow-up task (§9).

### Security — the exception to specificity

- When accuracy would help an attacker, withhold it deliberately. Sign-in: "That email or password doesn't match our records" — never confirming which is wrong, or whether the account exists. Password reset: "If an account exists for this email, we've sent a reset link."
- Anti-fraud, abuse, and rate-limit errors state that the action didn't work and what to do next — never how the detection works.
- Never expose stack traces, file paths, queries, or internal service names in user-facing copy.
- These messages still owe the user components 1 and 4: what happened, and what to do.

### Actions

- The primary button is the fix, labeled with its verb: "Try Again," "Reconnect Account," "Update Payment Method." "OK" and "Got It" are only for messages where there is truly nothing to do.
- When the error is likely to recur, the way out ("Contact Support") is a visible secondary action, not a link buried in body copy.
- Recovery costs nothing extra: after a failed submit, the user's input is still there. An error never destroys work.

### Accessibility

- Never color alone. Pair the red with an icon and words.
- Announce dynamic errors to assistive tech (`role="alert"` / `aria-live`), and tie inline errors to their fields (`aria-invalid` + `aria-describedby`) so screen readers read them together.
- On a failed submit, move focus to the error summary or the first invalid field.
- Error text meets your normal contrast standards — failure states get no exemption.

### Localization

- No idioms, puns, or cultural references — they don't survive translation.
- Give translators whole sentences with named placeholders. Never assemble messages from concatenated fragments.
- Leave layout room: translations often run ~30% longer than English.
- Full-page errors render in the visitor's locale — the URL prefix already tells the server which — with a matching `lang` attribute and search, home, and support links that stay in that locale.

---

## 5. Full-page errors: the status code is part of the message

A full-page error is two messages in one response: the copy a human reads, and the HTTP status code that crawlers, link checkers, and monitoring tools read. The honesty rules apply to both — a well-written "page not found" that returns `200 OK` is a generic error told to machines.

- **Return the real code.** `404` for a missing page, `500` for a failure on our end. Same principle for `403` (no access) and `410` (gone for good). Planned downtime and throttling have their own codes, below.
- **No soft 404s.** Serving a not-found message with a `200` status — or blanket-redirecting unknown URLs to the homepage — makes search engines index the failure, blinds link checkers, and counts errors as normal traffic in analytics.
- **Survive the outage.** Configure 404, 500, and 503 pages at the server or edge layer (nginx `error_page`, Apache `ErrorDocument`, CDN rules) so they render even when the application is down — and give them zero external dependencies. Analytics, chat widgets, and CDN fonts can fail for the same reason the page is showing.
- **404s get exits, not dead ends.** Keep the site's header, navigation, and footer; offer search, a link home, and the most-visited sections so the user can carry on.
- **500s get a request ID.** Log the underlying error server-side and print the same ID in the page's fine print, so a support conversation can find the log line. This is the one place an ID belongs in front of users.
- **Planned downtime is a `503` with an ETA.** The maintenance page returns `503 Service Unavailable` plus a `Retry-After` header — an integer of seconds for a rough estimate, an HTTP date when you've committed to a window. A `200` "back soon" page becomes the indexed content of every URL on the domain. Serve it from the edge (the application is the thing being taken down), let an admin IP through so you can verify before lifting the block, and make lifting the flag part of the deploy — a forgotten flag keeps the site "down" for hours.
- **Throttling is a `429`, not a `503`.** When one client sends too much, `429 Too Many Requests` with its own `Retry-After` says "you specifically — slow down and come back." A `503`, a silent drop, or a `200` with an error body teaches bots and agents that the site is down, or that the throttle page was real content. The human copy still follows the security rule (§4): what's paused and when to retry, never how the limit works.
- **Prove it.** `curl -I` a nonsense URL and expect `404`; force a `500` in staging and confirm the code with nothing internal leaking; during a maintenance window, `curl -I` the homepage and expect `503` with `Retry-After` while the page renders with the backend off; confirm a throttled client receives `429`, not a silent drop; watch Search Console for soft-404 flags; run a link checker and confirm breaks surface as 404s, not 200s.

---

## 6. Templates

Fill-in patterns for the common cases. Scale length to the surface (inline < toast < modal < full page).

**Internal failure, retry possible**

> Couldn't [do the thing]. [What was preserved.] This was due to a technical issue on our end. [Try again / specific step]. If it keeps happening, contact [Support].

*"Couldn't publish your site. Your changes were saved, but publishing failed due to a technical issue on our end. Try publishing again. If it keeps happening, contact Customer Care."*

**Third-party connection**

> We're having trouble connecting to [Service]. [What this means for the user.] [Next step.]

*"We're having trouble connecting to your Instagram account. Existing posts aren't affected, but new posts can't sync right now. Try reconnecting in a few minutes."*

**Invalid input (inline validation)**

> [Field] must [requirement].

*"Password must be at least 12 characters."* · *"Enter the date as MM/DD/YYYY."*

Show it at the field, the moment it can be fixed. State the rule, not the mistake.

**Missing permission or access**

> [What's blocked] requires [what's needed]. [How to get it.]

*"Editing this doc requires edit access. Request access from the owner below."*

**Nothing the user can do**

> [What happened]. [Why]. We're working on it — [when to check back / status link]. Need [X] sooner? Contact [Support].

*"Payouts are delayed due to an issue on our end. We're working on it — check the status page for updates. If you need help sooner, contact Support."*

**Offline**

> You're offline. [What's preserved.] [What reconnecting restores.]

*"You're offline. Your edits are saved on this device and will sync when you reconnect."*

**Page not found (full page, status 404)**

> We couldn't find that page. [Likely reason, if known.] [Search + home + popular sections, with site navigation intact.]

*"We couldn't find that page. It may have moved, or the link may be out of date. Try a search, or start again from the homepage."*

**Server failure (full page, status 500)**

> [What didn't load] due to a technical issue on our end. [Retry guidance.] If it keeps happening, contact [Support] and mention request ID [ID].

*"We couldn't load this page due to a technical issue on our end. Try refreshing in a minute. If it keeps happening, contact Support and mention request ID 8F3K2."*

**Maintenance (full page, status 503 + Retry-After)**

> We're offline for scheduled maintenance — [what's happening, briefly]. We expect to be back by [time, with timezone]. [Where to follow updates.]

*"We're offline for scheduled maintenance while we upgrade our database. Back by 3:00 PM UTC — follow progress on our status page."*

**Too many attempts (rate limited, status 429 + Retry-After)**

> [What's paused]. Try again in [interval].

*"Too many sign-in attempts. Wait a minute, then try again."*

---

## 7. Rewrites: before → after

| Before | What's wrong | After |
|---|---|---|
| "Whoops! Something went wrong. Try again later." | Playful tone, no cause, vague action | "We couldn't load your reports due to an issue on our end. Refresh to try again. If it keeps happening, contact Support." |
| "Error 500: Internal Server Error" | Jargon headline, no next step | "We couldn't save your changes due to a technical issue on our end. Your last saved version is safe. Try again in a few minutes." |
| "You entered an invalid email." | Blames the user, doesn't state the rule | "Enter an email address in the format name@example.com." |
| "PayFlow isn't responding, so your payment didn't go through." | Blames a third party | "We're having trouble processing payments right now. You haven't been charged. Try again in a few minutes." |
| "Make sure permissions are configured correctly and retry." | Specific-ish but unclear — which permissions, configured where? | "To import contacts, allow contact access: Settings → Privacy → Contacts. Then try importing again." |

---

## 8. Ship checklist

Run every message through this before it ships. Any unchecked box means revise.

- [ ] Says plainly what did or didn't happen
- [ ] Gives the cause — or owns it as an issue on our end
- [ ] States what was preserved or lost, when relevant
- [ ] Gives one concrete next step (or an honest "nothing to do yet" with a time or status link)
- [ ] Offers a support path if the fix can fail or the error can recur
- [ ] No playful openers; tone matches the stakes
- [ ] No jargon; any code or ID demoted to fine print
- [ ] Blames no one — not the user, not a third party
- [ ] Written for this specific trigger, not shared across unrelated failures
- [ ] Leaks nothing sensitive — no stack traces, internal names, or account-existence hints
- [ ] Appears on the right surface for its severity, and persists if it needs action
- [ ] Full-page errors return the true HTTP status — no soft 404s, blanket redirects home, or 200 "back soon" pages — with `Retry-After` on 503s and 429s
- [ ] Accessible: icon and words (never color alone), announced to assistive tech, focus handled on failed submits
- [ ] Clear on first read to a stressed person mid-task

---

## 9. Process rules

Bad error messages are usually a product and engineering problem wearing a content costume. The spec covers the workflow too:

1. **No writing blind.** Before drafting, get answers from engineering: What triggers this message? How often does it fire? Does it block the user's flow? What does the system know at that moment? Writers can and should refuse a "just add a generic error here" request until these are answered.
2. **Map before you write.** Every message maps to the code path(s) that trigger it. If one string serves five different failures, split it into five messages.
3. **Instrument every message.** Each error string gets a stable ID and logs an event when shown. You can't prioritize, review, or retire what you can't see firing. Log 404s too — they're a live map of broken inbound links.
4. **Prioritize by pain.** Fix first the errors that (a) fire most often and (b) block users from completing their task.
5. **Fallbacks expire.** New launches may ship with placeholder errors, but schedule a review of real error logs about a month after launch and replace the top offenders with specific copy.
6. **Review on a cycle.** Error content is never finished — revisit it regularly, including recently rewritten messages.
7. **Own it together.** PMs spec edge cases, not just happy paths. Engineers document triggers and IDs. Designers make room in layouts for real explanations. Writers challenge generic strings.
