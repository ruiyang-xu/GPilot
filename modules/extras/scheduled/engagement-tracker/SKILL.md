---
name: engagement-tracker
description: Scrape WeChat and LinkedIn metrics and generate content performance report
schedule: "0 10 1-7 * 1"
---

# Engagement Tracker

Monthly content performance tracker. Scrapes WeChat and LinkedIn engagement metrics for published research, generates a performance report, and identifies top-performing content themes.

## Trigger
- **Schedule**: 1st Monday of each month at 10:00 AM
- **Cron**: `0 10 1-7 * 1`

## Steps
1. Collect WeChat article metrics (reads, shares, comments) via Chrome MCP
2. Collect LinkedIn post metrics (impressions, engagement, followers) via Chrome MCP
3. Match metrics to published pieces in `data/state/research.json`
4. Calculate engagement rates and trend vs. prior month
5. Identify top 3 performing themes and format recommendations

## Output
- `output/digests/engagement-tracker-{date}.md`
- Updated `data/state/research.json` (engagement metrics)

## Data Sources
- WeChat backend via Chrome MCP
- LinkedIn analytics via Chrome MCP
- `data/state/research.json`
