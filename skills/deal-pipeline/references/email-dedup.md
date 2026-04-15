# Email Dedup & Prior-Contact Check

> **Purpose**: Before GPilot adds a sourced company to the deal pipeline or drafts a
> founder outreach email, check whether the firm has prior correspondence with that
> company or founder. This prevents embarrassing "cold outreach" to founders the user
> has already emailed, already passed on, or is currently in dialogue with.
>
> **Inspiration**: `anthropics/financial-services-plugins/private-equity/skills/deal-sourcing/SKILL.md`
> Step 2 (CRM Check). Adapted to use Gmail MCP + GPilot's state layer instead of a
> dedicated CRM (most sub-institutional VCs don't run Affinity/Pipedrive).
>
> **Used by**: `agents/deal-sourcer.md` (during Step 1 deduplication), `commands/source-deals.md`
> (as part of Step 1 context load), `commands/founder-outreach.md` (mandatory pre-check before
> drafting).

## Why This Matters

Without dedup, the deal-sourcer agent will happily surface a company the GP already
emailed 3 months ago and passed on. Cold-emailing a founder you previously said "no" to
— or worse, ghosted — is a reputation hit in a small ecosystem.

State-file dedup (checking `deals.json`, `portfolio.json`, `watchlist.json`) catches
companies that made it INTO the formal pipeline. Email dedup catches everything BEFORE
the pipeline: cold outreach, warm intros that went nowhere, passed deals that were
never formally filed.

## Three-State Classification

Every sourced company must be classified into one of three states:

| State | Criteria | Action |
|-------|---------|--------|
| 🟢 **New** | No prior correspondence found in Gmail or state files | Proceed with outreach |
| 🟡 **Existing** | Prior email thread found OR entry in state files | Summarize thread context, let user decide whether to re-engage |
| 🔴 **Previously Passed** | Explicit pass in prior email OR `status: "Passed"` in deals.json | Block auto-outreach, escalate to user |

## Check Sequence

Run these in order. Short-circuit as soon as a "Existing" or "Previously Passed"
classification is confirmed.

### 1. State File Check (cheapest, always first)

Search across all GPilot state files for the company name and any known founder names:

- `data/state/deals.json` — exact match on `company`, or fuzzy match on company name
- `data/state/portfolio.json` — same
- `data/state/watchlist.json` — same
- `data/state/public_holdings.json` — same
- `data/state/archived-jobs.json` (if exists) — for prior DCF/screen jobs

Flag a match if:
- Exact company name match
- Fuzzy match (Levenshtein distance ≤ 3, e.g., "Acme Inc" vs "Acme Robotics Inc")
- Founder name appears in any `notes`, `sourcing_context`, or `assignee` field

**If a match is found**: classify as `Existing`, note the state file and entry ID. If
the matched entry has `status: "Passed"` or `"Archived"` in deals.json → escalate to
`Previously Passed`.

### 2. Gmail Search (Gmail MCP required)

Use the Gmail MCP `gmail_search_messages` tool with these queries, in order:

```
# Query 1: exact company name in any field
"{company name}"

# Query 2: company domain (if known) from any field
from:@{company.com} OR to:@{company.com}

# Query 3: founder name (if known)
"{founder name}" AND ({company name} OR {company.com})
```

Parse results. For each matched thread:

- Extract: date of last message, thread ID, subject, sender
- Read the thread via `gmail_read_thread` to classify intent:
  - Inbound pitch received → `Existing` (warm lead status)
  - Outbound cold email sent, no reply → `Existing` (dormant)
  - Outbound cold email sent, positive reply → `Existing` (in dialogue)
  - Explicit "not a fit" / "pass" response from user → `Previously Passed`
  - Investor intro / warm intro → `Existing` (warm intro status)
  - Newsletter / marketing email only → not counted as prior correspondence

**Search cost discipline**: cap at 3 Gmail API calls per company. If cap hits without
clear signal, return `Unknown` and ask user rather than making more calls.

### 3. Folder Scan (optional, cheap fallback)

If Gmail MCP is unavailable or returns Unknown, grep local state:

- `deals/*/notes.md` — grep for company name
- `wiki/companies/{slug}.md` — grep for company name
- `raw/meetings/*` — grep for company name in meeting transcripts
- `raw/deals/*` — grep for company name in saved materials

### 4. User Prompt (last resort)

If all programmatic checks are inconclusive, ask the user:

> "I couldn't find prior correspondence or state-file records for {company}. Have you
> had any prior contact with them or the founder {name}? (yes-passed / yes-active /
> no-new / skip)"

## Thread Summary Format

When a prior thread is found, summarize it in 2-3 bullets for the user. Include:

- **Date range**: first message → last message
- **Direction**: inbound / outbound / warm intro
- **Outcome**: what status did the thread end in? (pass, ghosted, in dialogue, invested)
- **Owner**: which GPilot user was on the thread
- **Link**: Gmail thread URL (if available)

Example output:

```markdown
🟡 Existing — Acme Robotics

Prior thread found:
- **Dates**: 2026-01-12 → 2026-01-18 (3 messages)
- **Direction**: Inbound (founder reached out)
- **Outcome**: Ghosted — GP replied with questions, no response from founder
- **Owner**: YN
- **Thread**: gmail.com/threads/abc123

**Recommendation**: Before re-engaging, acknowledge the prior thread in the new email
("Following up on our conversation in January..."). Do not send a cold-template email.
```

## Anti-Patterns

- **Never** auto-send a cold email to a company flagged `Existing` or
  `Previously Passed`. User must explicitly approve.
- **Never** surface a `Previously Passed` company in `/source-deals` results without
  the "previously passed" flag visible in the summary table.
- **Never** batch Gmail searches for >10 companies at once — it will blow the per-minute
  rate limit. Throttle to 3-5 per minute.
- **Never** include the full email body in a public research output — even summaries
  go to user-only internal notes.
- **Never** store raw Gmail content in `wiki/` — only metadata (date, direction, outcome).
  Prior email content stays in Gmail; GPilot only stores the classification.

## Confidentiality

- Email content is SENSITIVE. Summaries go to `deals/{slug}/contact-history.md` (which is
  gitignored under `deals/`).
- Do not copy email bodies into commit-tracked files.
- Do not use email content as training data for wiki articles — only as dedup signal.

## Output Structure

When used as a sub-step within `/source-deals` or `/founder-outreach`, the email-dedup
check produces this structured output per company:

```json
{
  "company": "Acme Robotics",
  "contact_status": "Existing",  // or "New" or "Previously Passed" or "Unknown"
  "state_file_matches": [
    {"file": "data/state/watchlist.json", "entry_id": "watch-acme-20260110"}
  ],
  "gmail_threads": [
    {
      "thread_id": "abc123",
      "subject": "Series B intro — Acme Robotics",
      "first_message_date": "2026-01-12",
      "last_message_date": "2026-01-18",
      "direction": "inbound",
      "outcome": "ghosted",
      "owner": "YN"
    }
  ],
  "recommendation": "Do NOT cold-email. Acknowledge prior thread in any re-engagement.",
  "block_auto_outreach": true
}
```

## Integration Points

### Used by `agents/deal-sourcer.md`

In Step 1 (Deduplication), after loading state-file dedup list, also run email dedup
on any remaining companies that passed state-file dedup. Annotate each company result
with `contact_status`.

### Used by `commands/source-deals.md`

Step 1 (Load Context) extended: after loading state files, for each discovered company
that isn't in state, run email dedup. Any company flagged `Existing` or
`Previously Passed` is shown to the user with the flag before any action is taken.

### Used by `commands/founder-outreach.md` (mandatory pre-check)

Step 1 of founder-outreach MUST run this dedup check. If the classification is
`Previously Passed`, the command halts and reports the prior thread — user must
explicitly override to proceed.

## See also

- `agents/deal-sourcer.md` — calls this during sourcing dedup
- `commands/source-deals.md` — parent sourcing workflow
- `commands/founder-outreach.md` — mandatory pre-check before drafting
- Gmail MCP docs — `gmail_search_messages`, `gmail_read_thread`
