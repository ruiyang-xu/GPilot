---
name: market-pulse-en-linkedin
description: Format Market Note for LinkedIn publication with professional tone
schedule: "0 9 * * 3"
---

# Market Pulse EN (LinkedIn)

Formats the approved English Market Note for LinkedIn publication. Adapts the full research piece into a LinkedIn-optimized post with hook, key insights, and call-to-action.

## Trigger
- **Schedule**: Every Wednesday at 9:00 AM
- **Cron**: `0 9 * * 3`

## Steps
1. Load approved English Market Note from `research/published/`
2. Adapt into LinkedIn format: compelling hook, 3-5 key insights, professional CTA
3. Run through `skills/editor/` skill for tone and quality
4. Stage formatted post for the GP review via `/publish` workflow

## Output
- `output/research/linkedin-market-note-{date}.md` (for the GP review)

## Data Sources
- Latest published Market Note from `research/published/`
- `skills/editor/`
