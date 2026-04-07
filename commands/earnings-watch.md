---
name: earnings-watch
description: Earnings season management — pre-earnings prep, post-earnings analysis, and tracker updates
---

You are managing earnings season for the fund's public company coverage.

## Input
- `/earnings-watch` — Show upcoming earnings for all tracked companies
- `/earnings-watch Q1 2026` — Focus on a specific quarter
- `/earnings-watch AAPL` — Single company earnings deep dive
- `/earnings-watch post NVDA` — Post-earnings analysis for a specific company

## Step 1: Load Earnings Calendar

Read `data/state/public_holdings.json` (or `data/fund/public-companies.xlsx` for human review):
- "Holdings & Watchlist" sheet for the company list
- "Earnings Tracker" sheet for known earnings dates

Launch `public-market-data` agent to:
- Verify/update earnings dates for all tracked tickers
- Fill in any missing dates for the current quarter

## Step 2: Determine Mode

### Calendar Mode (no specific ticker)
Present the earnings calendar:

```
## Earnings Calendar — {Quarter}

### This Week
| Day | Ticker | Company | Time | EPS Est. | Rev Est. | Status |
|-----|--------|---------|------|----------|----------|--------|

### Next 2 Weeks
| Date | Ticker | Company | Time | EPS Est. | Rev Est. |
|------|--------|---------|------|----------|----------|

### Already Reported This Quarter
| Ticker | Date | EPS Surprise | Rev Surprise | Reaction |
|--------|------|-------------|-------------|----------|
```

### Pre-Earnings Mode (specific ticker, >1 day before earnings)
Launch `public-market-data` + `market-researcher` agents in parallel:

1. **Consensus Estimates**
   - EPS estimate (mean, range)
   - Revenue estimate (mean, range)
   - Key segment estimates if applicable

2. **Key Metrics to Watch**
   Based on sector (reference `skills/portfolio-ops/references/kpi-frameworks.md`):
   - SaaS: ARR, NRR, RPO, customers >$100K
   - Fintech: TPV, take rate, active accounts
   - Hardware/Semi: data center revenue, gross margin, backlog

3. **Analyst Sentiment**
   - Recent rating changes pre-earnings
   - Buy/hold/sell distribution
   - Key bear and bull arguments

4. **Our Questions**
   - What matters for our fund thesis?
   - How does this affect portfolio company valuations?
   - What outcome would change our view?

Output:
```
## Earnings Preview: {Company} ({Ticker})
**Reports**: {date} {time}
**Consensus**: EPS ${X} | Revenue ${X}B

### What to Watch
{Top 3-5 metrics with context}

### Analyst Positioning
{Sentiment summary}

### Fund Relevance
{How this earnings report matters to us — portfolio comps, sector signal, direct holding}
```

### Post-Earnings Mode (specific ticker, <3 days after earnings OR explicit "post")
Launch `public-market-data` agent:

1. **Results vs. Estimates**
   | Metric | Estimate | Actual | Surprise |
   |--------|----------|--------|----------|

2. **Earnings Call Takeaways**
   - Top 3-5 key points from the call (via Perplexity)
   - Guidance: raised / maintained / lowered / withdrawn
   - Management tone and key quotes

3. **Market Reaction**
   - Stock price change on earnings day (and next day)
   - Volume vs. average
   - After-hours reaction if applicable

4. **Thesis Impact**
   - Does this change our view on {company}?
   - Implications for portfolio companies in same sector
   - Valuation adjustment needed?

## Step 3: Update Earnings Tracker

Write results to `data/state/public_holdings.json` (or `data/fund/public-companies.xlsx` for human review) "Earnings Tracker" sheet:
- Quarter, Earnings Date, Time
- EPS Estimate, EPS Actual, Revenue Estimate, Revenue Actual
- Surprise %, Guidance, Stock Reaction %, Key Takeaways

## Step 4: Cross-Reference

If the reporting company is a peer or competitor to a portfolio company:
- Note the read-through for the portfolio company
- Suggest updating the portfolio company's dossier if material
- Flag if peer comps need refreshing in the Peer Comps sheet

## Safety
- All analysis based on publicly available information only
- Earnings dates can shift — always verify before presenting as confirmed
