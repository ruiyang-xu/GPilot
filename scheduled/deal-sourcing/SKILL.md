---
name: deal-sourcing
description: Weekly automated deal sourcing scan from GitHub, funding rounds, and industry reports
schedule: "0 8 * * 3"
---

# Deal Sourcing — Weekly Scan

Automated weekly scan of public sources (GitHub trending, funding rounds, accelerator batches, industry reports) to discover potential investment targets. Runs every Wednesday at 8:00 AM.

## Trigger
- **Schedule**: Every Wednesday at 8:00 AM
- **Cron**: `0 8 * * 3`

## Steps

1. **Load dedup context**: Read `data/state/deals.json`, `data/state/watchlist.json`, `data/state/portfolio.json`, and `data/state/public_holdings.json`. Build flat list of all tracked company names.

2. **Run sourcing agent**: Launch **deal-sourcer** agent with:
   - `sector_focus`: all
   - `source_type`: all
   - `lookback_days`: 7
   - `max_results`: 30
   - `existing_companies`: dedup list

3. **Auto-triage results**:
   - **Signal strength = High** (any score): Add to watchlist AND flag for the GP review
   - **Signal strength = Medium AND pre_screen_score >= 3.0**: Add to watchlist
   - **Signal strength = Medium AND pre_screen_score < 3.0**: Log in report only
   - **Signal strength = Low**: Log in report only, do not add to watchlist

4. **Update watchlist**: For each company auto-added, write to `data/state/watchlist.json` with:
   - Full `sourcing_signals` from the agent
   - `source_type` matching discovery module
   - `pre_screen_score` from the agent
   - `reason`: mapped from primary signal (GitHub trending, Recent funding, Accelerator graduate, Proactive sourcing)

5. **Watchlist aging check**: Scan existing watchlist entries for:
   - Items with `pre_screen_score >= 3.5` sitting unactioned for >7 days → Flag for the GP review
   - Items added >30 days ago with no `last_checked_date` update → Mark for re-evaluation or removal

6. **Generate report**: Save to `output/digests/deal-sourcing-{date}.md`:
   - Scan date and parameters
   - New companies discovered (table)
   - Companies auto-added to watchlist
   - High-priority flags for the GP review
   - Watchlist aging alerts
   - Sector and source breakdown
   - Total watchlist size after update

## Output
- Updated `data/state/watchlist.json`
- `output/digests/deal-sourcing-{date}.md`
- High-priority flags in digest for the GP review

## Data Sources
- `data/state/deals.json`, `data/state/watchlist.json`, `data/state/portfolio.json`
- Perplexity MCP (primary research tool)
- `agents/references/sourcing-keywords.md` (sector search terms)
- Fund parameters from `CLAUDE.md`

## Constraints
- **NEVER** add companies to `deals.json` — only to `watchlist.json` (deal promotion requires the GP review)
- **NEVER** send emails or external communications
- Quality over quantity: prefer fewer high-confidence entries over many low-quality ones
