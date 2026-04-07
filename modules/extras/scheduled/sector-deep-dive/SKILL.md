---
name: sector-deep-dive
description: Quarterly sector deep-dive research with full comp model refresh
schedule: "0 9 * 3,6,9,12 5L"
---

# Sector Deep Dive

Quarterly comprehensive sector analysis covering market sizing, competitive landscape, valuation trends, and investment implications. Refreshes sector comp models and produces a bilingual research report.

## Trigger
- **Schedule**: Last Friday of each quarter (Mar, Jun, Sep, Dec)
- **Cron**: `0 9 25-31 3,6,9,12 5` (approximation: last Fri of quarter months)

## Steps
1. Select sector from `data/state/research.json` quarterly plan
2. Refresh sector comp model in `data/comps/` with latest data
3. Deep research via `skills/deep-researcher/` on TAM/SAM, trends, key players
4. Draft English report via `/research` full-process workflow
5. Stage for the GP review, then translate for bilingual publication

## Output
- `research/wip/sector-deep-dive-{sector}-en.md`
- Updated `data/comps/{sector}.xlsx`

## Data Sources
- `data/comps/` (62 sector models), Daloopa MCP
- `skills/deep-researcher/`, `wiki/sectors/`
