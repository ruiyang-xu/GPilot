---
name: reflect
description: Agent self-reflection — review recent work, capture learnings, update evolution log
---

Trigger agent self-reflection on recent work and capture reusable learnings.

## Input
- `agent`: Agent name (optional) — if specified, reflect for just that agent. If omitted, reflect across all agents.
- `period`: Time period (optional) — default last 7 days. Format: "7d", "30d", "3d".

## Process

### Step 1: Gather Recent Activity

Read `output/` for recent outputs from the target agent(s):
- `output/queries/` — recent query answers
- `output/digests/` — recent digests and reports
- `output/research/` — recent research outputs
- `research/wip/` — work in progress

Also check `data/state/running-jobs.json` for recently completed jobs.

### Step 2: Read Current Learnings

Read `learnings/{agent}.md` for each target agent. Count active vs. superseded entries.

### Step 3: Self-Assessment

For each recent output, evaluate:
1. Were there any tool errors, retries, or workarounds?
2. Were data gaps encountered that could have been avoided?
3. Were there search strategies or tool patterns that worked especially well?
4. Did the user make corrections to the output?
5. Were there unexpected behaviors from MCP tools (Perplexity, Daloopa, Gmail, etc.)?

### Step 4: Capture New Learnings

If new insights found:
- Append to `learnings/{agent}.md` under "## Active Learnings" with:
  - `### YYYY-MM-DD — {short title}`
  - `- **Context**: What happened`
  - `- **Learning**: The reusable insight`
  - `- **Impact**: Expected improvement`
  - `- **Tags**: #relevant-tags`

### Step 5: Check for Superseded Learnings

Compare new learnings against existing ones. If a newer learning contradicts or replaces an older one:
- Move the old entry to "## Superseded Learnings"
- Add note: `Superseded by: {new learning title} on {date}`

### Step 6: Update Index

Update `learnings/_index.md` with new counts and last-updated dates.

### Step 7: Log Evolution Event

Append entries to `data/state/evolution-log.json` for each new learning captured:
```json
{
  "date": "YYYY-MM-DD",
  "agent": "{agent}",
  "event": "learning_added",
  "learning_id": "{short-kebab-id}",
  "description": "{one-line description}",
  "measured_impact": "{if measurable}"
}
```

### Step 8: Report

Print summary:
- Agents reflected on: N
- New learnings captured: N
- Superseded learnings: N
- Active learning count per agent

Save to `output/digests/reflection-{date}.md`
