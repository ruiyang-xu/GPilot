---
name: daily-email-summary
description: Scan Gmail for deal flow, LP comms, and portfolio updates requiring attention
schedule: "0 9 * * *"
---

# Daily Email Summary

Scans Gmail inbox for unread messages related to deal flow, LP communications, portfolio company updates, and legal/compliance matters. Categorizes and prioritizes emails by urgency and topic.

## Trigger
- **Schedule**: Daily at 9:00 AM
- **Cron**: `0 9 * * *`

## Steps
1. Search Gmail for unread messages since last summary
2. Categorize into: Deal Flow, LP Relations, Portfolio, Legal/Compliance, Other
3. Flag high-priority items (LP responses, term sheet updates, compliance deadlines)
4. Generate prioritized summary with recommended actions

## Output
- `output/digests/email-summary-{date}.md`

## Data Sources
- Gmail via MCP (unread inbox, labeled messages)
- `data/state/lps.json` for LP name matching
- `data/state/deals.json` for deal name matching
