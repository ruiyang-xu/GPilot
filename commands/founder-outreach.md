---
name: founder-outreach
description: Draft a personalized cold email to a founder with voice-matching and mandatory email dedup check — Gmail drafts only, never auto-sends
---

Draft a personalized founder outreach email for $ARGUMENTS.

## Input

Accept one positional argument:
- **Company name** (required) — either a sourced company (in `data/state/watchlist.json`),
  a pipeline deal (in `data/state/deals.json` with `status: "Sourced"`), or a new company
  not yet in state.

Examples:
- `/founder-outreach "Acme Robotics"` — draft email to founder of a sourced company
- `/founder-outreach` — asks user which company

Optional second argument: **angle** — "partnership" / "investment" / "warm intro requested"
/ "follow-up on ghosted thread". Defaults to "investment".

## Safety First

This command produces a **Gmail draft** — it NEVER sends. The user must:

1. Review the draft in Gmail
2. Make any final edits
3. Click Send themselves

GPilot's `Email: drafts only` safety rule applies — see CLAUDE.md § Safety Rules.

## Process

### Step 0: Register Job

Add entry to `data/state/running-jobs.json`:
```json
{
  "job_id": "job-outreach-{slug}-{YYYYMMDD}",
  "type": "custom",
  "title": "Founder outreach: {company}",
  "agent": "deal-sourcer",
  "status": "in_progress",
  "started_date": "{ISO 8601}",
  "current_step": "Step 1: Email dedup check"
}
```

### Step 1: MANDATORY — Email Dedup Check

Load `skills/deal-pipeline/references/email-dedup.md` and run the full 4-step classification:

1. State file check (`deals.json`, `watchlist.json`, `portfolio.json`)
2. Gmail MCP search (3 queries max per company)
3. Folder scan fallback
4. User prompt if still Unknown

**Halting rules**:

- `Previously Passed` → HALT. Display the prior thread summary and the reason. Require
  explicit user override ("proceed anyway" / "pass") to continue.
- `Existing` → Pause. Display the prior thread summary. Ask the user: "This is not a
  cold outreach. Do you want to: (a) draft a follow-up that acknowledges the prior
  thread, (b) draft a new angle, (c) skip this contact?"
- `New` → Proceed to Step 2 immediately.
- `Unknown` → Ask user to confirm "truly new" before proceeding.

### Step 2: Gather Context

For cold outreach, gather enough context to personalize the email:

1. **Company info**:
   - From `data/state/watchlist.json` or `deals.json` entry (sourcing_signals)
   - Company website (short read for product + positioning)
   - Recent news via Perplexity (funding, product launches, customer wins in last 90 days)
   - GitHub activity if repo is known (star trajectory, recent releases)

2. **Founder info**:
   - Name (from sourcing signals or company "about" page)
   - LinkedIn profile (via web search — do NOT scrape, just the public-facing info)
   - Prior companies / notable background
   - Recent public writing (blog posts, podcast appearances, tweets — flag if found)

3. **Why now**: One specific, concrete, verifiable reason this company is interesting
   RIGHT NOW. Not "AI is hot" — something like "You just shipped v2 with multi-agent
   orchestration and published benchmarks showing 3x improvement over CrewAI." Grounded
   in Step 2 findings.

### Step 3: Voice Matching

If the user has a Gmail `Sent` folder accessible via Gmail MCP, study their voice:

1. Search sent emails with outreach-like subjects/body:
   ```
   in:sent (subject:"reaching out" OR subject:"introduction" OR subject:"quick intro"
            OR subject:"partnership")
   ```
2. Read 3-5 representative examples
3. Extract voice markers:
   - **Greeting style**: "Hi {name}" vs "{name}," vs "Hey {name}"
   - **Opening**: how do they introduce themselves?
   - **Signature tone**: formal vs casual
   - **Length**: typical word count of their outreach
   - **CTA style**: "15 min chat?" vs "Would love to learn more" vs "Happy to jump on a call"
   - **Sign-off**: "Best," / "Thanks," / "Cheers," / first name only

Store voice markers in `learnings/preferences.md` under a new section if not already
present, so future outreach drafts match without re-searching.

If Gmail MCP is unavailable, use the default professional-but-warm style described in
`skills/deal-pipeline/references/email-dedup.md` and the FSP deal-sourcing SKILL.

### Step 4: Draft the Email

**Structure** (4-6 sentences, < 150 words):

1. **Personalized opener**: Reference something concrete about the company or founder's
   recent work. Show you've done homework.
2. **Brief intro**: One sentence on who you are and your firm (e.g., "I'm YN at Acme
   Ventures — we invest in early-stage AI infrastructure"). Pull fund context from
   `config/global/CLAUDE.md` Identity section.
3. **Why now / why them**: What specifically caught your attention. Make it specific
   enough that it couldn't have been a template.
4. **Soft ask / CTA**: "Would you be open to a brief conversation?" — not "schedule a
   meeting". Low pressure.
5. **Sign-off**: Match the voice-matched style.

**Subject line rules**:

- Specific, not generic (NOT "Investment opportunity", "Funding inquiry")
- Reference company or product (e.g., "Re: Acme's v2 release — quick question")
- Keep under 50 characters
- Avoid exclamation points, all-caps, and emoji

**Do NOT**:

- Attach anything on first touch
- Include a pitch deck link
- Use the word "quickly" more than once (a cliché)
- Claim you're "impressed" in the first sentence (lazy)
- Copy-paste from the sourcing summary — rewrite for human voice

### Step 5: Create Gmail Draft

Use `gmail_create_draft` MCP tool:

```
to: founder@company.com  (if known; else use the user's research findings)
cc: (empty unless user adds)
bcc: (empty)
subject: {from Step 4}
body: {text/plain from Step 4}
contentType: text/plain
```

**Important**: The `to` address must be validated. If the founder's email is uncertain,
draft with a placeholder `[VERIFY: founder-email@company.com]` and instruct the user
to fill it in before sending. Do NOT send to a guessed address.

### Step 6: Present Draft for Review

Show the user:

1. **Context summary**: What prior contact was found (from Step 1)
2. **Personalization rationale**: Which specific details from Step 2 were used
3. **Voice matching**: Which tone markers were applied (from Step 3)
4. **The draft** itself (subject + body)
5. **Validation flags**: Any `[VERIFY:]` placeholders
6. **Draft URL**: Direct link to open the draft in Gmail

End with: "Review in Gmail, make any final edits, and send when ready. I will NOT send
this automatically."

### Step 7: Update State

**Update `data/state/watchlist.json`** (or `deals.json` if the company is a sourced deal):

```json
{
  "outreach_status": "draft_created",
  "outreach_draft_date": "{today}",
  "outreach_draft_gmail_id": "{draft id}",
  "last_checked_date": "{today}"
}
```

**Do NOT** mark the entry as "contacted" until the user confirms they sent the email.

### Step 8: Reflection

Apply `deal-sourcer` agent's Reflection Protocol. Watch for:

- Voice matching effectiveness (did the draft match the user's real tone?)
- Gmail MCP quirks or rate limits
- Personalization quality (was "why now" actually concrete or generic?)
- User corrections — if the user rewrites the draft significantly, capture the pattern
  for `learnings/preferences.md`

Log the event to `data/state/evolution-log.json`.

### Step 9: Mark Job Complete

Update `running-jobs.json`:
- `status`: `waiting_input` (because the user must approve + send)
- `blocking_on`: "User review of draft in Gmail"
- `progress_pct`: 90

The job stays in `waiting_input` until the user either confirms "sent" (then we set
outreach_status in state to "contacted") or "cancel" (status becomes "abandoned").

## Safety Rules

1. **Gmail is drafts-only** — this command creates drafts. **Never** include `send: true`
   or invoke any "send" API.
2. **Email dedup is mandatory** — Step 1 is not skippable. Cold-emailing a ghosted or
   passed founder is reputation damage.
3. **Voice matching is opt-in** — if the user says "don't voice-match, use default tone",
   respect that preference and record it in `learnings/preferences.md`.
4. **Never auto-populate recipient list** — each draft is one company, one founder. No
   batch sends.
5. **No attachments on first touch** — even if the user says "attach the deck". Push
   back: "Best practice is no attachments on cold outreach. Want to offer to share
   materials after they reply?"
6. **Anonymize portfolio details** — never name portfolio companies in outreach unless
   the user explicitly approves.
7. **Confidentiality**: do NOT use prior private email content (from dedup Step 2) as
   quoted material in the new draft. Only use it as signal.

## Triggered by

- `/founder-outreach {company}` — direct user invocation
- `/source-deals` Step 4 — the "Screen" action in source-deals can optionally chain to
  `/founder-outreach` as a follow-up if the user selects "draft outreach" alongside Screen

## See also

- `skills/deal-pipeline/references/email-dedup.md` — mandatory pre-check (Step 1)
- `agents/deal-sourcer.md` — parent agent; handles voice-matching learnings
- `commands/source-deals.md` — parent sourcing workflow; can chain to this command
- Gmail MCP docs — `gmail_create_draft`, `gmail_search_messages`, `gmail_read_thread`
- `learnings/preferences.md` — voice markers stored here
