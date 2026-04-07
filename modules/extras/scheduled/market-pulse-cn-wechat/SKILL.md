---
name: market-pulse-cn-wechat
description: Translate and format Market Note for WeChat publication
schedule: "0 9 * * 2"
---

# Market Pulse CN (WeChat)

Translates the approved English Market Note into Chinese and formats it for WeChat publication. Applies cultural adaptation for the Chinese audience, not just literal translation.

## Trigger
- **Schedule**: Every Tuesday at 9:00 AM
- **Cron**: `0 9 * * 2`

## Steps
1. Load approved English Market Note from `research/wip/` or `research/published/`
2. Translate EN to CN using `skills/translator/` skill with cultural adaptation
3. Format for WeChat layout (headers, callouts, inline formatting)
4. Run through `skills/editor/` skill for quality check
5. Stage for the GP final review before publishing

## Output
- `research/wip/market-note-{date}-cn.md` (for the GP review)

## Data Sources
- Latest approved Market Note from `research/wip/` or `research/published/`
- `skills/translator/`, `skills/editor/`
