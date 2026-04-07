---
name: company-teardown
description: Bi-weekly deep-dive company teardown research for publication
schedule: "0 9 * * 4/14"
---

# Company Teardown

Bi-weekly deep-dive analysis of a notable private company (unicorn or high-growth). Produces a bilingual research piece covering business model, financials, competitive position, and investment thesis.

## Trigger
- **Schedule**: Every other Thursday at 9:00 AM
- **Cron**: `0 9 1-7,15-21 * 4` (approximation: 1st and 3rd Thursday)

## Steps
1. Select target company from `data/state/research.json` editorial queue
2. Deep research via `skills/deep-researcher/` skill (Perplexity MCP)
3. Build comp analysis using relevant `data/comps/` sector model
4. Draft English teardown via `/research` full-process workflow
5. Stage in `research/wip/` for the GP review before translation

## Output
- `research/wip/company-teardown-{company}-en.md`

## Data Sources
- `data/state/research.json` (topic queue)
- `skills/deep-researcher/`, `data/comps/`
- `wiki/companies/`, `wiki/sectors/`
