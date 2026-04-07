---
name: market-pulse-research
description: Research and draft the weekly Market Note bilingual report
schedule: "0 9 * * 1"
---

# Market Pulse Research

Kicks off the weekly Market Note research cycle. Gathers macro trends, sector developments, and notable deals from the past week to produce the draft bilingual research piece.

## Trigger
- **Schedule**: Every Monday at 9:00 AM
- **Cron**: `0 9 * * 1`

## Steps
1. Check `data/state/research.json` for this week's pre-approved Market Note topic
2. Collect week's market data: macro indicators, sector moves, notable rounds
3. Draft English research piece via `/research-fast-track` workflow
4. Stage draft in `research/wip/` for the GP review

## Output
- `research/wip/market-note-{date}-en.md`

## Data Sources
- `data/state/research.json` (topic list)
- Web search via Perplexity MCP
- `wiki/sectors/`, `data/comps/`
