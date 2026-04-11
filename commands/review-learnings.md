---
name: review-learnings
description: Curate accumulated agent learnings — prune stale entries, validate relevance, promote cross-cutting patterns
---

Review and curate accumulated learnings across all agents. Run monthly or when learnings count exceeds 50 total.

## Process

### Step 1: Load All Learnings

Read `learnings/_index.md` and all per-agent learning files:
- `learnings/deal-sourcer.md`
- `learnings/deep-researcher.md`
- `learnings/financial-analyst.md`
- `learnings/market-researcher.md`
- `learnings/portfolio-monitor.md`
- `learnings/memo-writer.md`
- `learnings/editor.md`
- `learnings/translator.md`
- `learnings/data-visualizer.md`
- `learnings/system.md`
- `learnings/preferences.md`

### Step 2: Statistics

Report:
- Total active learnings per agent
- Total superseded learnings
- Oldest active learning (date) — flag if > 90 days old
- Most tagged themes across all agents
- Learning velocity: learnings per week over the last month

### Step 3: Validation

For each active learning, assess:

1. **Still relevant?** Has the underlying tool/behavior/API changed since this was captured?
2. **Actionable?** Does it actually change agent behavior, or is it too vague to apply?
3. **Cross-cutting?** Does the same insight apply to multiple agents? If so, promote to `learnings/system.md`.
4. **Duplicated?** Are two learnings saying the same thing? Merge them.
5. **Stale?** Is it older than 90 days without being validated?

### Step 4: Curation Recommendations

Present the user with recommendations:
- **Archive**: Learnings no longer relevant (move to Superseded)
- **Promote**: Learnings that apply across agents (move to system.md)
- **Merge**: Duplicate learnings (combine into one)
- **Validate**: User preferences that need confirmation
- **Keep**: Learnings confirmed still relevant

### Step 5: Execute

After user approval:
- Move archived learnings to "## Superseded Learnings" with reason
- Move cross-cutting learnings to `learnings/system.md`
- Merge duplicates (keep the more detailed version)
- Update `learnings/_index.md` with new counts
- Log events to `data/state/evolution-log.json`

### Step 6: Evolution Report

Read `data/state/evolution-log.json` and produce:
- Learning velocity trend: learnings per week
- Agent improvement distribution: which agents learn fastest
- Most active learning areas (by tag)
- Supersession rate: how often old learnings get replaced

Save to `output/digests/learnings-review-{date}.md`
