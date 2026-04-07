---
name: fund-compliance
description: Monthly compliance calendar review and regulatory deadline check
schedule: "0 9 1 * *"
---

# Fund Compliance

Monthly review of the compliance calendar. Checks for upcoming regulatory filings, LP reporting deadlines, and fund administration requirements. Escalates overdue items with increasing urgency.

## Trigger
- **Schedule**: 1st of every month at 9:00 AM
- **Cron**: `0 9 1 * *`

## Steps
1. Load `data/state/compliance.json` for all tracked obligations
2. Check for items due in the current month and next 30 days
3. Flag overdue items with escalation level (warning / urgent / critical)
4. Verify LP reporting deadlines align with `data/state/lps.json` commitments
5. Generate compliance status report with action items

## Output
- `output/digests/compliance-review-{date}.md`
- Updated `data/state/compliance.json` (status flags)

## Data Sources
- `data/state/compliance.json`
- `data/state/lps.json`
- `wiki/concepts/` for regulatory frameworks
