---
name: portfolio-news
description: Monitor portfolio companies for news, fundraises, exec changes, and risk signals
schedule: "0 11 * * *"
---

# Portfolio News

Monitors all portfolio companies for material news events including new fundraising rounds, executive departures, product launches, competitive threats, and negative press. Flags early warning signals.

## Trigger
- **Schedule**: Daily at 11:00 AM
- **Cron**: `0 11 * * *`

## Steps
1. Load portfolio company list from `data/state/portfolio.json`
2. Search web for each company's recent news (last 24 hours)
3. Classify findings: Positive / Neutral / Negative / Risk Alert
4. Update relevant `wiki/companies/` articles with new developments
5. Flag risk alerts for immediate the GP attention

## Output
- `output/digests/portfolio-news-{date}.md`
- Updated `wiki/companies/` articles

## Data Sources
- `data/state/portfolio.json`
- Web search via Perplexity MCP
- `wiki/companies/` for company context
