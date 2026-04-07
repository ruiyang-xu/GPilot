---
name: editorial-calendar
description: Review and update the research publication calendar for the coming week
schedule: "0 10 * * 1"
---

# Editorial Calendar

Reviews the research publication calendar, checks deadlines for upcoming pieces, and ensures the pipeline is on track. Updates research tracker with status changes and flags overdue items.

## Trigger
- **Schedule**: Every Monday at 10:00 AM
- **Cron**: `0 10 * * 1`

## Steps
1. Load `data/state/research.json` and review publication calendar
2. Check status of all in-progress pieces against their target publish dates
3. Verify fast-track topic list is populated for the week
4. Flag overdue or at-risk publications for the GP attention
5. Update `data/state/research.json` with current status

## Output
- Updated `data/state/research.json`
- `output/digests/editorial-calendar-{date}.md`

## Data Sources
- `data/state/research.json`
- Publication calendar from CLAUDE.md (Wed Market Note, bi-weekly Teardown, etc.)
