---
name: source-deals
description: Proactive deal sourcing from public sources — GitHub, funding rounds, accelerators, reports
---

You are running a proactive deal sourcing scan. This command discovers new investment opportunities from public information before they appear in inbound deal flow.

## Input

Accept parameters (all optional, defaults shown):
1. **Sector** (default: `all`): Configured focus sectors (see CLAUDE.md or .env FOCUS_SECTORS), or `all`
2. **Source type** (default: `all`): One of [github, funding, reports, all]
3. **Lookback days** (default: `7`): How far back to search
4. **Max results** (default: `20`): Maximum companies to return

Examples:
- `/source-deals` — Full scan, all configured focus sectors, all sources, last 7 days
- `/source-deals AI/ML` — AI/ML sector only, all sources
- `/source-deals AI/ML github 14` — AI/ML sector, GitHub signals only, last 14 days
- `/source-deals all funding 30` — All configured focus sectors, funding rounds only, last 30 days

## Process

### Step 1: Load Context (Deduplication)

Read these files to build the exclusion list:
- `data/state/deals.json` — existing pipeline companies
- `data/state/watchlist.json` — existing watchlist companies
- `data/state/portfolio.json` — portfolio companies (invested)
- `data/state/public_holdings.json` — public positions

Extract all company names into a flat dedup list. Pass to the sourcing agent.

### Step 2: Launch Deal Sourcer Agent

Launch the **deal-sourcer** agent with:
- `sector_focus`: from user input
- `source_type`: from user input
- `lookback_days`: from user input
- `max_results`: from user input
- `existing_companies`: dedup list from Step 1

Wait for agent to return structured results.

### Step 3: Present Results

Display ranked results to the user as a table:

```
## Sourcing Results — {date}

Sector: {sector} | Source: {source_type} | Lookback: {lookback_days}d | Found: {N} companies

| # | Company | Sector | Stage | Score | Signal | Source | Action |
|---|---------|--------|-------|-------|--------|--------|--------|
| 1 | CompanyA | AI/ML | Series A | 4.5 | High | GitHub + Funding | Screen |
| 2 | CompanyB | SaaS | Seed | 3.8 | Medium | Funding | Screen |
| ... | | | | | | | |
```

Then show per-company detail cards for top results (score >= 3.0):

```
### CompanyA (Score: 4.5 — Screen)
- **What**: One-line description
- **Signals**: GitHub 12.5K stars (+3.2K/mo) | Series A $15M (Sequoia, a16z) | YC W26
- **Why interesting**: Rationale from agent
- **Website**: https://...
```

### Step 4: User Actions

For each company, offer four actions:
- **Screen** → Hand off to `/deal-screen {company}` with pre-loaded sourcing context
- **Outreach** → Hand off to `/founder-outreach {company}` to draft a cold email (mandatory
  email dedup check runs first; `Previously Passed` companies will be blocked)
- **Watch** → Add to `data/state/watchlist.json` with full sourcing signals
- **Skip** → Do not track

Ask the user: "Which companies would you like to Screen, Outreach, Watch, or Skip?
(e.g., 'Screen 1,3 Outreach 2 Watch 4,5 Skip rest')"

**Contact status display**: In the results table from Step 3, always show `contact_status`
as a column. Companies flagged `Existing` get a 🟡 icon in the table header column; they
can still be actioned but the user is clearly informed of the prior thread.

### Step 5: Execute Actions

**For Screen**:
- Add entry to `data/state/deals.json` with status "Sourced", source field set to the appropriate sourcing type, and `sourcing_context` populated
- Suggest: "Run `/deal-screen {company}` to proceed with full evaluation"

**For Outreach**:
- Verify `contact_status` is not `Previously Passed` (if it is, halt and escalate)
- Add entry to `data/state/watchlist.json` first (same fields as Watch below)
- Then chain to `/founder-outreach {company}` — the outreach command will run its own
  mandatory email dedup + draft flow and produce a Gmail draft for user review
- The watchlist entry's `outreach_status` field will be updated to `draft_created` by
  the founder-outreach command

**For Watch**:
- Add entry to `data/state/watchlist.json` with:
  - `watchlist_id`: `watch-{company-slug}-{date}`
  - `source_type`: matching the sourcing module that found it
  - `sourcing_signals`: full signal data from the agent
  - `contact_status`: from the agent's email dedup check
  - `pre_screen_score`: from the agent
  - `reason`: matching the primary signal type (e.g., "GitHub trending", "Recent funding")
  - `key_metrics_tracked`: based on signal type (e.g., "GitHub stars, funding rounds" for GitHub-sourced)

**For Skip**:
- No state changes. Log in the sourcing report only.

### Step 6: Save Report

Save a sourcing digest to `output/digests/sourcing-{date}.md` with:
- Scan parameters (sector, source, lookback, date)
- Full results table
- Actions taken (which companies screened, watched, skipped)
- Sector distribution breakdown
- Source distribution breakdown

## Safety

- NEVER auto-send emails or external communications
- NEVER add companies to `deals.json` without user confirmation (watchlist auto-add is OK for scheduled runs)
- NEVER disclose investment terms, LP information, or portfolio positions to external sources
- All sourcing is from public information only — no scraping behind paywalls or authentication
