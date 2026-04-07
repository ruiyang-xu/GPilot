---
name: research
description: Start a new research piece or continue a work-in-progress — supports all 5 publication types
---

You are managing the research publication workflow. This command handles everything from topic selection through final draft.

## Input
Ask for:
1. **Publication type** (if not specified): Sector Deep Dive / Company Teardown / Thematic Research / Market Note / GP Letter
2. **Topic or company** (required)
3. **Or**: offer to continue a WIP piece if one exists

## Approval Tiers

Not all publication types need the same process. Use the tier system:

| Tier | Types | Outline Approval | Final Approval | Notes |
|------|-------|-----------------|----------------|-------|
| **Express** | Market Note, GP Letter | Skip (auto-proceed) | Required | Weekly/monthly cadence — outline gate kills velocity |
| **Standard** | Company Teardown, Thematic Research | Required | Required | Bi-weekly/monthly — outline shapes the narrative |
| **Deep** | Sector Deep Dive | Required + topic pre-approval | Required | Quarterly — significant research investment |

Express tier: Steps 1→2→3→4→5→6→7→8 (skip outline pause at Step 3)
Standard tier: Steps 1→2→3→**PAUSE**→4→5→6→7→8
Deep tier: Pre-approve topic list monthly → Steps 1→2→3→**PAUSE**→4→5→6→7→8

## Step 0: Check for Existing WIP
Read `data/state/research.json`. If a piece exists for this topic with status ≠ "Published":
- Show the existing entry (title, type, status, last updated)
- Ask: "Continue this piece from {current status}?" or "Start fresh?"
- If continuing, resume from the appropriate step below

## Step 1: Research Brief
Create `research/wip/{YYYY-MM-DD}-{slug}/brief.md`:
- Publication type
- Topic / company
- Key questions to answer (3-5)
- Source strategy (which tools, which sources)
- Target length and audience
- Competitive benchmark (which competitor's style to target)

Add entry to `data/state/research.json` with Status = "Researching"

## Step 2: Deep Research
Launch the **deep-researcher** agent with the brief:
- Uses Perplexity MCP tools (`perplexity_research`, `perplexity_search`, `perplexity_reason`)
- Uses `WebSearch` for supplementary and Chinese-language sources
- Output: `research/wip/{date}-{slug}/research-notes.md`

For Company Teardowns: also launch **financial-analyst** agent for financial analysis.
For Sector Deep Dives: also launch **market-researcher** agent for competitive mapping.

Update tracker Status = "Outlining"

## Step 3: Generate Outline
Using research notes, generate a structured outline following the appropriate template:
- `templates/research-sector-deep-dive.md`
- `templates/research-company-teardown.md`
- `templates/research-thematic.md`
- `templates/research-market-note.md`
- `templates/research-gp-letter.md`

Save to `research/wip/{date}-{slug}/outline.md`

**Tier check**:
- **Express tier** (Market Note, GP Letter): Log outline, proceed directly to Step 4. No pause needed.
- **Standard/Deep tier** (all others): **PAUSE** — present the outline to the GP for review. Ask:
  - "Is this structure right?"
  - "Any sections to add/remove/reorder?"
  - "Any specific angle or insight you want to emphasize?"
  Wait for approval before proceeding.

## Step 4: Write English Draft
Using the approved outline and research notes, write the full English draft.

Apply the writing style guide (`skills/research-publication/references/writing-style-guide.md`):
- For Sector Deep Dives: GS style — data-dense, framework-driven, actionable
- For Company Teardowns: 海外独角兽 style adapted to English — narrative + analytical
- For Thematic Research: AB style — contrarian framing, macro-to-micro
- For Market Notes: 晚点 style — sharp, opinionated, concise
- For GP Letters: the GP's personal voice

Launch **data-visualizer** agent for charts, tables, and frameworks.

Save to `research/wip/{date}-{slug}/draft-en.md`
Update tracker Status = "Review"

## Step 5: Editorial Review (English)
Launch the **editor** agent on the English draft.
- Reviews against `skills/research-publication/references/editorial-checklist.md`
- Produces structured review with Critical / Important / Suggestion items

If Critical issues found: revise and re-review.
Save review to `research/wip/{date}-{slug}/review-notes.md`
Update tracker Status = "Translating"

## Step 6: Chinese Translation
Launch the **translator** agent on the reviewed English draft.
- Cultural adaptation, not literal translation
- Follows Chinese writing standards from the style guide
- Technical terms with English parentheticals

Save to `research/wip/{date}-{slug}/draft-cn.md`

## Step 7: Chinese Editorial Review
Launch the **editor** agent on the Chinese draft.
- Focus on: native readability, analytical substance preservation, tone calibration
- Check bilingual consistency

If issues found: revise.
Update tracker Status = "Final Review"
Update tracker Language Status = "Both Ready"

## Step 8: Present to the GP
Show the GP:
- English draft summary (key thesis, 3 bullet points)
- Note any editorial concerns that were addressed
- Both drafts are ready at `research/wip/{date}-{slug}/`
- Ask: "Ready to publish via `/publish`? Or any final changes?"

Update tracker Status = "Ready" upon approval.

## Resumption Protocol
If GP returns mid-workflow:
- Check research-tracker.xlsx for the piece's current Status
- Offer to resume from the next incomplete step
- Load all existing artifacts from the WIP folder
- Brief the GP on where things left off

## Safety
- All research must be the GP's to publish — never auto-publish
- Anonymize portfolio company references unless GP explicitly approves
- Cite all data sources — no fabricated statistics
- Flag when research is based on limited or potentially unreliable sources
