---
name: daily-briefing
description: End-of-day summary of deal flow activity, portfolio updates, and open tasks
schedule: "0 18 * * *"
---

# Daily Briefing

End-of-day wrap-up covering deal pipeline movement, portfolio company updates, completed tasks, and items requiring follow-up. Synthesizes the day's activity into an actionable summary for the GP.

## Trigger
- **Schedule**: Daily at 6:00 PM
- **Cron**: `0 18 * * *`

## Steps
1. Review deal pipeline changes in `data/state/deals.json` since morning
2. Check portfolio news alerts collected during the day
3. Summarize email activity and pending responses from Gmail
4. List open action items and upcoming deadlines for tomorrow

## Output
- `output/digests/daily-briefing-{date}.md`

## Data Sources
- `data/state/deals.json`, `data/state/portfolio.json`
- Gmail via MCP (flagged/starred items)
- `wiki/deals/active-pipeline.md`
