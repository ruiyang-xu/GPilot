---
name: daily-market-data
description: Collect end-of-day prices and metrics for public holdings and comp benchmarks
schedule: "0 17 * * 1-5"
---

# Daily Market Data

Collects closing prices, volume, and key metrics for public holdings and sector benchmark companies. Updates public holdings state and flags significant moves (>5% daily change).

## Trigger
- **Schedule**: Weekdays at 5:00 PM (after US market close)
- **Cron**: `0 17 * * 1-5`

## Steps
1. Load positions from `data/state/public_holdings.json`
2. Fetch end-of-day prices and daily changes via Daloopa MCP and web search
3. Update `data/state/public_holdings.json` with latest prices
4. Flag significant movers (>5% daily, >10% weekly) for the GP review
5. Update relevant sector comp models in `data/comps/` if material

## Output
- Updated `data/state/public_holdings.json`
- `output/digests/market-data-{date}.md` (if significant moves)

## Data Sources
- `data/state/public_holdings.json`
- Daloopa MCP for fundamentals
- `data/comps/` sector models
