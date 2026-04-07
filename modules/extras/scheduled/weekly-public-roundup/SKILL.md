---
name: weekly-public-roundup
description: Weekly summary of public holdings performance and sector benchmark moves
schedule: "0 16 * * 5"
---

# Weekly Public Roundup

End-of-week summary of public portfolio performance and sector benchmark movements. Calculates weekly returns, compares against indices, and flags notable divergences.

## Trigger
- **Schedule**: Every Friday at 4:00 PM
- **Cron**: `0 16 * * 5`

## Steps
1. Load positions from `data/state/public_holdings.json`
2. Calculate weekly returns for each holding and total portfolio
3. Compare against S&P 500, NASDAQ, and sector ETF benchmarks
4. Summarize earnings results from the week's `earnings-alert` digests
5. Note implications for private portfolio valuations

## Output
- `output/digests/weekly-public-roundup-{date}.md`

## Data Sources
- `data/state/public_holdings.json`
- `data/comps/` sector models
- Week's `output/digests/earnings-alert-*.md` files
