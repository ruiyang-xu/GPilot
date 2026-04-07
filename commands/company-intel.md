---
name: company-intel
description: On-demand deep intelligence brief on any company (public or private, portfolio or not)
---

You are generating a comprehensive intelligence dossier on a company.

## Input
Accept: company name, ticker symbol, or URL. Examples:
- `/company-intel NVDA`
- `/company-intel Stripe`
- `/company-intel Quantum Labs`

## Step 1: Identify Company Type

Check these sources to determine context:
- `data/state/deals.json` (or `data/fund/deal-tracker.xlsx` for human review) — Is this a pipeline deal?
- `data/state/portfolio.json` (or `data/fund/portfolio-dashboard.xlsx` for human review) — Is this a portfolio company?
- `data/state/public_holdings.json` (or `data/fund/public-companies.xlsx` for human review) — Is this a tracked public company?
- If none: new company, determine if public or private via web search

Classification:
- **Public + Tracked**: Full treatment (market data + portfolio/watchlist context)
- **Public + New**: Market data + competitive landscape
- **Private + Tracked**: Known KPIs + competitive landscape
- **Private + New**: Web research + competitive landscape

## Step 2: Launch Agents in Parallel

Based on classification:

**If Public**:
- Launch `public-market-data` agent: current price, market cap, financials (TTM), valuation multiples, analyst consensus, upcoming earnings, recent SEC filings
- Launch `market-researcher` agent: competitive landscape, recent news (30 days), market positioning, TAM/SAM context

**If Private**:
- Launch `market-researcher` agent: company info, funding history, competitive landscape, recent news, estimated market size

**If Portfolio Company** (either public or private):
- Also launch `portfolio-monitor` agent: latest KPIs from portfolio-dashboard.xlsx, board context, any alerts

## Step 3: Generate Dossier

Create or update `deals/{company-slug}/dossier.md` with this structure:

```markdown
# {Company Name} — Intelligence Dossier
**Last Updated**: {date}
**Type**: {Public Holding / Private Portfolio / Public Watchlist / Private Pipeline / New}
**Ticker**: {if public}

## Company Overview
- **Description**: {1-2 sentence description}
- **Founded**: {year} | **HQ**: {location}
- **Employees**: {count or estimate}
- **CEO/Founder**: {name}
- **Sector**: {sector} | **Sub-sector**: {sub-sector}

## Financial Snapshot
{If public: revenue, EBITDA, margins, growth rates, cash position}
{If private: last known revenue/ARR, burn rate, runway, last round details}

| Metric | Value | YoY Change |
|--------|-------|-----------|
| Revenue (TTM) | | |
| Growth Rate | | |
| Gross Margin | | |
| EBITDA / Burn Rate | | |
| Cash / Runway | | |

## Valuation
{If public: current market cap, EV, trading multiples, vs. peer median}
{If private: last round valuation, date, investors, implied multiples}

## Recent Developments (Last 30 Days)
- {date}: {event}
- {date}: {event}

## Competitive Position
| Competitor | Differentiation | Est. Revenue | Funding/Market Cap |
|-----------|----------------|-------------|-------------------|

**Competitive Advantages**: {moats, IP, network effects}
**Competitive Risks**: {emerging threats, commoditization}

## Key Risks
1. {Risk 1}
2. {Risk 2}
3. {Risk 3}

---

## GP Notes
{This section is preserved across auto-updates — manual notes by GP}
```

**Important**: If `dossier.md` already exists, preserve the "GP Notes" section. Update all other sections with fresh data.

## Step 4: Update Data Files

- If public and not in `data/state/public_holdings.json` (or `data/fund/public-companies.xlsx` for human review) → add to watchlist (Type = "Watchlist" unless user specifies otherwise)
- If tracked in portfolio → update `data/state/portfolio.json` (or `data/fund/portfolio-dashboard.xlsx` for human review) with any new KPI data
- If in deal pipeline → update `data/state/deals.json` (or `data/fund/deal-tracker.xlsx` for human review) Notes column with key findings

## Step 5: Present Summary

```
## Intelligence Brief: {Company Name}
**Type**: {classification} | **Sector**: {sector}

### Key Numbers
{3-5 most important metrics in a compact table}

### What's Changed (Last 30 Days)
{Top 2-3 developments}

### Our View
{1 paragraph synthesis: how does this company relate to our investment thesis?}

**Dossier saved**: deals/{company-slug}/dossier.md
**Next suggested action**: {e.g., "Schedule founder call", "Add to watchlist", "Update portfolio valuation", "No action needed"}
```

## Safety
- Create `deals/{company-slug}/` directory if it doesn't exist
- Never overwrite GP Notes section in existing dossiers
- All data sourced from public information only
