---
name: news-briefing
description: Sector news scan across AI, SaaS, Fintech, Healthtech, and Deeptech
schedule: "0 8 * * *"
---

# News Briefing

Scans tech and venture news sources for developments relevant to fund sectors. Covers funding rounds, M&A, regulatory changes, and market trends across AI/ML, SaaS, Fintech, Healthtech, and Deeptech.

## Trigger
- **Schedule**: Daily at 8:00 AM
- **Cron**: `0 8 * * *`

## Steps
1. Search web for latest funding rounds, acquisitions, and IPOs in target sectors
2. Check for regulatory or policy changes affecting portfolio sectors
3. Cross-reference with portfolio companies and active pipeline in `data/state/portfolio.json`
4. Flag items relevant to active deals or portfolio companies

## Output
- `output/digests/news-briefing-{date}.md`

## Data Sources
- Web search via Perplexity MCP (primary)
- `data/state/portfolio.json`, `data/state/watchlist.json`
- `wiki/sectors/` for sector context
