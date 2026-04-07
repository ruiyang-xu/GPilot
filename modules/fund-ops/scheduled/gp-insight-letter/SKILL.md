---
name: gp-insight-letter
description: Draft monthly GP Letter with market thesis and portfolio highlights
schedule: "0 9 1-7 * 3"
---

# GP Insight Letter

Monthly GP Letter combining market thesis, portfolio highlights, and forward-looking perspective. Produced as a bilingual piece for WeChat (CN) and LinkedIn (EN) distribution.

## Trigger
- **Schedule**: 1st Wednesday of each month at 9:00 AM (week 1)
- **Cron**: `0 9 1-7 * 3`

## Steps
1. Check `data/state/research.json` for pre-approved GP Letter topic
2. Synthesize month's market trends from weekly Market Notes
3. Pull portfolio highlights (new investments, milestones, exits)
4. Draft English letter via `/research-fast-track` workflow
5. Stage for the GP review before translation and publication

## Output
- `research/wip/gp-letter-{date}-en.md`

## Data Sources
- `data/state/research.json`, `data/state/portfolio.json`
- Prior month's `output/digests/weekly-market-note-*.md`
- `wiki/companies/` for portfolio highlights
