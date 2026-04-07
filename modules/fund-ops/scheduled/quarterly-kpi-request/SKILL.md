---
name: quarterly-kpi-request
description: Send KPI data requests to portfolio companies for quarterly reporting
schedule: "0 9 25-31 3,6,9,12 1-5"
---

# Quarterly KPI Request

Drafts KPI data request emails to portfolio companies at quarter-end. Generates company-specific requests based on each company's reporting template and outstanding data gaps.

## Trigger
- **Schedule**: Last business day of each quarter (Mar, Jun, Sep, Dec) at 9:00 AM
- **Cron**: `0 9 25-31 3,6,9,12 1-5` (task checks if actually last biz day of quarter)

## Steps
1. Load portfolio companies from `data/state/portfolio.json`
2. Identify required KPIs per company (revenue, burn, headcount, key metrics)
3. Check which data points are already current vs. stale
4. Draft personalized Gmail requests per company (DRAFTS ONLY, never auto-send)
5. Generate tracking checklist for follow-up

## Output
- Gmail drafts (one per portfolio company)
- `output/digests/quarterly-kpi-request-{date}.md`

## Data Sources
- `data/state/portfolio.json`
- `data/fund/portfolio-dashboard.xlsx` (via xlsx skill)
- Gmail via MCP (draft creation only)
