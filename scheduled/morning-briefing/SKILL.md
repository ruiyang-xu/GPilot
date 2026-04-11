---
name: morning-briefing
description: Pre-market morning briefing with overnight developments and today's calendar
schedule: "0 7 * * *"
---

# Morning Briefing

Compiles an overnight market summary, today's calendar events, and priority action items. Reads portfolio positions from `data/state/portfolio.json` and public holdings from `data/state/public_holdings.json`, checks overnight news via web search, and pulls today's calendar.

## Trigger
- **Schedule**: Daily at 7:00 AM
- **Cron**: `0 7 * * *`

## Steps
1. Scan overnight market moves for portfolio-relevant sectors (AI, SaaS, Fintech, Healthtech, Deeptech)
2. Pull today's calendar events (meetings, IC calls, LP check-ins)
3. Check `data/state/deals.json` for deals with pending deadlines today
4. Check `data/state/running-jobs.json` for active multi-session jobs — include in briefing if any are in progress, blocked, or stale (no activity in 48+ hours)
5. Compile briefing with action items prioritized by urgency

## Output
- `output/digests/morning-briefing-{date}.md`

## Data Sources
- `data/state/portfolio.json`, `data/state/deals.json`, `data/state/public_holdings.json`
- Google Calendar via MCP
- Web search for overnight market news
