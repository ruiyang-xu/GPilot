---
name: portfolio-review
description: Portfolio health check — valuations, KPIs, news, and fund-level metrics
---

You are conducting an investment portfolio review. This can be run monthly or on-demand.

## Process

### Step 1: Load Portfolio Data
Read `data/state/portfolio.json` (or `data/fund/portfolio-dashboard.xlsx` for human review) using the xlsx skill. Get all companies with Status = "Active" or "Marked Up" or "Written Down".

### Step 2: Portfolio Company Monitoring (Parallel)
For each active company, launch the **portfolio-monitor agent** (batch in groups of 3-5 for efficiency):
- Recent news and press (last 30 days)
- Competitor activity
- Hiring signals (LinkedIn job postings trend)
- Customer reviews and sentiment
- Flag any material events

### Step 3: Valuation Update
Launch the **financial-analyst agent**:
- For each company, assess current fair value:
  - Last round pricing (if within 12 months)
  - Public comparable multiples applied to latest financials
  - Any material events affecting valuation (up or down)
- **DCF refresh trigger** (auto-invoke `/dcf {company}` if ANY of these are true):
  - `last_valuation_date` > 12 months ago
  - `valuation_source` ≠ "DCF" AND stage ≥ Series C
  - `valuation_confidence` = "Low" AND company has revenue
  - Recent material event (funding round, exec change, customer win/loss) since last valuation
- Calculate MOIC for each position
- Document valuation methodology and confidence level (per `valuation-report` skill)

### Step 4: Portfolio-Level Metrics
Calculate:
- **Total NAV**: Sum of all position fair values + cash
- **TVPI**: (NAV + Distributions) / Called Capital
- **DPI**: Distributions / Called Capital
- **RVPI**: NAV / Called Capital
- **IRR**: Time-weighted return (if sufficient data)
- **Concentration**: Top 5 positions as % of NAV, sector allocation, stage allocation

### Step 5: Generate Review

```markdown
## Portfolio Review — {date}

### Fund Summary
| Metric | Value |
|--------|-------|
| Active Companies | X |
| Total Invested (at cost) | $X |
| Current NAV | $X |
| TVPI | X.Xx |
| DPI | X.Xx |

### Portfolio Heat Map
| Company | MOIC | Trend | Status | Key Update |
|---------|------|-------|--------|------------|
{for each company}

### Attention Required
- **Runway Alerts**: Companies with <6 months cash
- **Valuation Concerns**: MOIC <1.0x positions
- **Stale Data**: Companies with KPI update >30 days old
- **Upcoming Boards**: Next 30 days

### Sector & Stage Allocation
{concentration analysis}

### Recommended Actions
{Specific items for the GP to act on}
```

### Step 6: Update Data
Update `data/state/portfolio.json` (or `data/fund/portfolio-dashboard.xlsx` for human review) with latest valuations and MOIC calculations.
