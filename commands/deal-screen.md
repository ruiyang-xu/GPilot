---
name: deal-screen
description: Screen a new deal — research, score, and add to pipeline
---

You are screening a new investment opportunity. Follow these steps precisely.

## Input
Ask the user for:
1. **Company name** (required)
2. **Context** (optional): URL, pitch deck path, intro email, or any background
3. **`--from-watchlist`** (optional): If provided, pre-load sourcing context from `data/state/watchlist.json`

## Process

### Step 0: Load Watchlist Context (if applicable)
If `--from-watchlist` flag is set, or if the company name matches an entry in `data/state/watchlist.json`:
- Load the watchlist entry's `sourcing_signals` and `pre_screen_score`
- Pre-populate research context with GitHub data, funding history, and report sources
- Display: "Pre-loaded sourcing context: {signal summary}"
- Set `source` field to the appropriate sourcing type (e.g., "GitHub sourcing", "Funding scanner")
- Set `sourcing_context` on the deal entry with a summary of signals

### Step 1: Check for Duplicates
Read `data/state/deals.json` (or `data/fund/deal-tracker.xlsx` for human review) using the xlsx skill. Search for the company name. If it exists, show the existing entry and ask whether to update or create a new screening.

### Step 2: Research (Parallel Agents)
Launch these agents in parallel:

**market-researcher agent**:
- Research the company: what they do, founding date, team, funding history
- Market sizing (TAM/SAM/SOM)
- Competitive landscape (3-5 key competitors)
- Industry trends and "why now"

**financial-analyst agent** (if financials or pitch deck provided):
- Quick financial assessment
- Stage-appropriate valuation benchmarks
- Comparable recent rounds in the sector

### Step 3: Score the Deal
Using the research output, score against the 5 screening criteria (see `skills/deal-pipeline/references/screening-criteria.md`):

| Factor | Weight | Score (1-5) | Rationale |
|--------|--------|-------------|-----------|
| Team | 30% | | |
| Market | 25% | | |
| Product | 20% | | |
| Traction | 15% | | |
| Thesis Fit | 10% | | |
| **Composite** | | **{weighted score}** | |

### Step 4: Create Deal Folder
Create `deals/{company-name}/notes.md` with:
- Screening date
- Source / introducer
- Company overview (from research)
- Scoring table with rationale
- Key strengths and concerns
- Recommendation

### Step 5: Update Deal Tracker
Add a row to `data/state/deals.json` (or `data/fund/deal-tracker.xlsx` for human review):
- Company, Stage, Sector, Source, Date Added (today), Score, Status, Lead Contact, Check Size (estimated), Valuation (if known), Notes, Next Action, Next Action Date

### Step 6: Recommendation
Based on composite score:
- **3.5+**: "Recommend: Proceed to DD" — suggest next steps and timeline
- **2.5-3.4**: "Recommend: Monitor" — add to watchlist, suggest follow-up in 3-6 months
- **<2.5**: "Recommend: Pass" — log rationale, draft polite pass email (Gmail DRAFT only)

## Safety
- NEVER auto-send emails. All email responses are Gmail DRAFTS only.
- NEVER disclose investment terms, other deal details, or LP information to external parties.
