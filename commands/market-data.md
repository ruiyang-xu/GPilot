---
name: market-data
description: Pull and update latest market data for public holdings and watchlist companies
---

You are updating market data for tracked public companies.

## Input
- `/market-data all` — Update all holdings and watchlist tickers
- `/market-data AAPL` — Update a single ticker
- `/market-data AAPL MSFT NVDA` — Update specific tickers

## Step 1: Load Tickers

Read `data/state/public_holdings.json` (or `data/fund/public-companies.xlsx` for human review) → "Holdings & Watchlist" sheet.

- If `all`: get every row with a Ticker
- If specific tickers: validate they exist in the sheet (if not, offer to add)

## Step 2: Fetch Data

Launch `public-market-data` agent for each ticker (batch if >5):

For each ticker, retrieve:
- Current price, market cap, volume
- Day change ($ and %)
- 52-week high/low
- Latest quarterly revenue and EPS (if earnings reported in last 30 days)

## Step 3: Update Workbook

**Holdings & Watchlist sheet** — update per ticker:
- Current Price
- Market Cap
- Position Value (= Current Price × Shares/Units)
- Weight % (= Position Value / Total Portfolio Value)
- Last Updated → today's date

**Price History sheet** — append new row per ticker:
- Ticker, Date (today), Open, High, Low, Close, Volume, Change %

## Step 4: Alerts

Flag and present any of:
- **Big Movers**: >5% daily change (up or down)
- **52-Week Extremes**: New 52-week high or low
- **Volume Spikes**: Volume >2x 20-day average
- **Valuation Shifts**: If position MOIC moved >10% from last update

## Step 5: Output

```
## Market Data Update — {date}

**Tickers Updated**: {count}

### Portfolio Summary
| Ticker | Price | Day Chg | Mkt Cap | Position Value | MOIC |
|--------|-------|---------|---------|---------------|------|

**Total Public Portfolio Value**: ${X}

### Alerts
{Only if flags triggered — otherwise "No alerts"}

### Stale Data
{Tickers where data could not be retrieved — suggest fallback action}
```

## Notes
- If Perplexity returns stale prices (market closed, weekend), note "as of {date}" and don't overwrite more recent data
- Weekend/holiday runs should skip price updates but can still update fundamentals
- Always log the data source in the Notes column of Price History
