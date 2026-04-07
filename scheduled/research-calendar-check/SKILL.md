---
name: research-calendar-check
description: Verify research pipeline deadlines and flag at-risk publications
schedule: "0 8 * * 1"
---

# Research Calendar Check

Cross-checks the research publication calendar against actual pipeline status. Ensures upcoming publications have drafts in progress and flags any that risk missing their target date.

## Trigger
- **Schedule**: Every Monday at 8:00 AM
- **Cron**: `0 8 * * 1`

## Steps
1. Load `data/state/research.json` for all in-progress and scheduled pieces
2. Check publication calendar: Wed Market Notes, bi-weekly Teardowns, monthly GP Letters
3. Verify each upcoming piece has a draft in `research/wip/` at appropriate stage
4. Flag at-risk items (no draft started within 3 days of target)
5. Send summary of research pipeline health

## Output
- `output/digests/research-calendar-{date}.md`

## Data Sources
- `data/state/research.json`
- `research/wip/` directory listing
- Publication calendar from CLAUDE.md
