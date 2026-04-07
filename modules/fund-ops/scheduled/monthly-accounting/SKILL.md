---
name: monthly-accounting
description: End-of-month fund accounting reconciliation and NAV preparation
schedule: "0 9 28-31 * 1-5"
---

# Monthly Accounting

End-of-month fund accounting reconciliation. Prepares data for NAV calculation, reconciles capital calls and distributions, and flags discrepancies for fund admin review.

## Trigger
- **Schedule**: Last business day of each month at 9:00 AM
- **Cron**: `0 9 28-31 * 1-5` (runs last weekdays, task checks if actually last biz day)

## Steps
1. Load portfolio valuations from `data/state/portfolio.json`
2. Reconcile capital calls and distributions against `data/fund/` workbooks
3. Check public holdings mark-to-market from `data/state/public_holdings.json`
4. Compile NAV inputs: cost basis, fair value, unrealized gains/losses
5. Generate accounting package for fund admin and the GP review

## Output
- `output/digests/monthly-accounting-{date}.md`

## Data Sources
- `data/state/portfolio.json`, `data/state/public_holdings.json`
- `data/fund/` workbooks (via xlsx skill)
- Feishu fund valuation summary
