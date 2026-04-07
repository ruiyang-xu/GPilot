---
name: weekly-market-note
description: Compile weekly market intelligence note from daily digests and news
schedule: "0 8 * * 1"
---

# Weekly Market Note

Synthesizes the week's daily news briefings, market data, and sector developments into a consolidated weekly intelligence note. Serves as the foundation for Market Pulse research.

## Trigger
- **Schedule**: Every Monday at 8:00 AM
- **Cron**: `0 8 * * 1`

## Steps
1. Aggregate prior week's daily digests from `output/digests/news-briefing-*.md`
2. Consolidate market data moves from `output/digests/market-data-*.md`
3. Identify top 3-5 themes and trends across the week
4. Compile into structured weekly intelligence note

## Output
- `output/digests/weekly-market-note-{date}.md`

## Data Sources
- `output/digests/news-briefing-*.md` (prior 7 days)
- `output/digests/market-data-*.md` (prior 5 trading days)
- `data/state/public_holdings.json`
