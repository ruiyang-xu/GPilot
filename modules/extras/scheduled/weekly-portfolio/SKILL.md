---
name: weekly-portfolio
description: Weekly portfolio health check with KPI tracking and valuation updates
schedule: "0 14 * * 5"
---

# Weekly Portfolio

End-of-week portfolio health check. Reviews KPI updates, flags companies trending below plan, updates valuations for any material events, and prepares the portfolio status summary.

## Trigger
- **Schedule**: Every Friday at 2:00 PM
- **Cron**: `0 14 * * 5`

## Steps
1. Load portfolio from `data/state/portfolio.json`
2. Check for KPI updates received during the week (email, Feishu)
3. Review news alerts from daily `portfolio-news` digests
4. Flag companies with valuation-impacting events (new rounds, down-rounds, pivots)
5. Generate portfolio summary with traffic-light status per company

## Output
- `output/digests/weekly-portfolio-{date}.md`

## Data Sources
- `data/state/portfolio.json`
- `wiki/companies/` for company context
- Week's `output/digests/portfolio-news-*.md` files
