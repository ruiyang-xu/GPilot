---
name: quarterly-lp-kickoff
description: Initiate quarterly LP report preparation with data collection
schedule: "0 9 15 3,6,9,12 *"
---

# Quarterly LP Kickoff

Kicks off the quarterly LP report preparation process. Collects portfolio KPIs, valuations, and fund metrics needed for the LP quarterly report. Starts data gathering 2 weeks before quarter-end.

## Trigger
- **Schedule**: 15th of quarter-end months (Mar, Jun, Sep, Dec) at 9:00 AM
- **Cron**: `0 9 15 3,6,9,12 *`

## Steps
1. Load LP list and reporting requirements from `data/state/lps.json`
2. Compile portfolio company KPIs from `data/state/portfolio.json`
3. Calculate fund-level metrics: IRR, TVPI, DPI, RVPI
4. Draft LP quarterly report skeleton via `/lp-quarterly` command
5. Flag missing data points and generate data request list

## Output
- `output/digests/quarterly-lp-kickoff-{date}.md`
- Draft LP report skeleton in `output/reports/`

## Data Sources
- `data/state/lps.json`, `data/state/portfolio.json`
- `data/fund/` workbooks (via xlsx skill)
- Feishu portfolio info wiki
