---
name: deal-flow-triage
description: Screen new inbound deals and update pipeline status with scoring
schedule: "0 10 * * *"
---

# Deal Flow Triage

Reviews new deal flow from email, WeChat forwards, and broker channels. Scores each opportunity against fund parameters (check size, stage, sector fit) and updates the deal pipeline tracker.

## Trigger
- **Schedule**: Daily at 10:00 AM
- **Cron**: `0 10 * * *`

## Steps
1. Check `raw/deals/` for newly dropped files since last triage
2. Scan Gmail for inbound deal emails (term sheets, teasers, introductions)
3. Score each deal: sector fit, stage match, check size alignment, team quality signals
4. Update `data/state/deals.json` with new entries or status changes
5. Flag high-priority deals for immediate the GP review
6. **Watchlist nudge**: Check `data/state/watchlist.json` for:
   - Entries with `pre_screen_score >= 3.5` unactioned for >7 days → Flag: "High-score watchlist company {name} (score {score}) has been waiting {N} days — consider promoting to deal pipeline"
   - Entries with `signal_strength = High` added in the last 7 days → Include in triage digest as "Sourcing highlights"

## Output
- Updated `data/state/deals.json`
- `output/digests/deal-triage-{date}.md`

## Data Sources
- `raw/deals/`, Gmail via MCP
- `data/state/deals.json`, fund parameters from CLAUDE.md
- `wiki/sectors/` for sector thesis alignment
