---
name: earnings-alert
description: Track earnings dates and analyze results for public holdings and sector comps
schedule: "0 6 * * 1-5"
---

# Earnings Alert

Monitors upcoming earnings dates for public holdings and key sector comparables. When earnings are reported, pulls results and flags beats/misses against consensus estimates.

## Trigger
- **Schedule**: Weekdays at 6:00 AM (pre-market)
- **Cron**: `0 6 * * 1-5`

## Steps
1. Check earnings calendar for public holdings in `data/state/public_holdings.json`
2. For companies reporting today/yesterday, fetch results via Daloopa MCP
3. Compare actuals vs. consensus: revenue, EPS, guidance
4. Flag material beats/misses and guidance changes
5. Note implications for private portfolio valuations

## Output
- `output/digests/earnings-alert-{date}.md` (only when earnings reported)

## Data Sources
- `data/state/public_holdings.json`
- Daloopa MCP for fundamentals and estimates
- Web search for earnings call highlights
