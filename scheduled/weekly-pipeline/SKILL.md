---
name: weekly-pipeline
description: Weekly deal pipeline review with stage progression and stale deal cleanup
schedule: "0 9 * * 1"
---

# Weekly Pipeline

Comprehensive weekly review of the deal pipeline. Tracks stage progression, flags stale deals, calculates pipeline velocity metrics, and identifies deals needing immediate action.

## Trigger
- **Schedule**: Every Monday at 9:00 AM
- **Cron**: `0 9 * * 1`

## Steps
1. Load full pipeline from `data/state/deals.json`
2. Calculate stage-by-stage metrics: count, avg days in stage, conversion rates
3. Flag stale deals (no activity >14 days) for pass/continue decision
4. Cross-reference with Feishu project tracker for IC status
5. Generate pipeline summary with recommended actions

## Output
- `output/digests/weekly-pipeline-{date}.md`

## Data Sources
- `data/state/deals.json`
- `wiki/deals/active-pipeline.md`
- Feishu IC pipeline tracker
