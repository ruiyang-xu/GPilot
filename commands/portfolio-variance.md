---
name: portfolio-variance
description: Per-company variance analysis — revenue/EBITDA vs budget, covenant compliance, KPI trends with red/yellow/green triage
---

Run a per-company variance analysis for $ARGUMENTS.

## Input

Accept one positional argument:
- **Company name** (required) — must exist in `data/state/portfolio.json`

Examples:
- `/portfolio-variance "Quantum Labs"` — analyze Q1 2026 against plan
- `/portfolio-variance "Nexus Health" Q4-2025` — specific period
- `/portfolio-variance` — asks user which company

Optional second argument: **reporting period** (e.g., "Q1-2026", "Mar-2026", "YTD"). Defaults
to most recent complete quarter.

## Process

### Step 0: Register Job

Add entry to `data/state/running-jobs.json`:
```json
{
  "job_id": "job-variance-{slug}-{YYYYMMDD}",
  "type": "portfolio-review",
  "title": "Variance analysis: {company} {period}",
  "agent": "portfolio-monitor",
  "status": "in_progress",
  "started_date": "{ISO 8601}",
  "last_activity": "{ISO 8601}",
  "progress_pct": 0,
  "current_step": "Step 1: Load portfolio context",
  "output_path": "output/portfolio/{slug}-variance-{date}.md"
}
```

### Step 1: Load Portfolio Context

Read from `data/state/portfolio.json`:
- Portfolio entry for `{company}` (verify it exists — fail if not)
- Sector, stage, initial investment date, current valuation, valuation source
- Any existing `credit_agreement_path`, `budget_path`, or prior variance reports
- Last KPI update date and health score

Also load:
- `wiki/companies/{slug}.md` if it exists (for business context)
- `deals/{slug}/` folder for any pre-existing monitoring notes
- `data/fund/{company}-dcf-*.xlsx` if a recent DCF exists (to compare actuals vs DCF projections)

### Step 2: Gather Financial Package

Ask the user (or auto-detect from folder):
1. **Where is the financial package?** Options:
   - Path to `.xlsx` monthly/quarterly package
   - Path to board deck PDF
   - Paste data inline
2. **What period does it cover?** (quarter, month, YTD)
3. **Is there a budget/plan?** If not in the package, ask for a separate file or inline data.
   **Do NOT invent a plan if one isn't provided.** Halt and escalate if missing.
4. **Credit agreement terms** (if portfolio entry has debt but no stored agreement):
   - Max leverage ratio, min interest coverage, min liquidity, other covenants

### Step 3: Load Skill and Extract Data

Load `skills/portfolio-ops/references/variance-analysis.md` and follow its Steps 1-5:

1. Ingest the financial package (xlsx skill for Excel, pdf skill for PDF)
2. Extract key line items into internal representation (actuals / budget / prior_period)
3. Compute financial KPIs (revenue, EBITDA, margins, leverage, interest coverage, FCF)
4. Load sector KPIs from `skills/portfolio-ops/references/kpi-frameworks.md`
5. Apply 3-color flags (Green 5%, Yellow 5-15%, Red >15% or special cases)
6. Check covenant compliance if applicable
7. Run trend analysis if 3+ periods available

**Bilingual handling**: If the package is in Chinese, use the label mapping in
`variance-analysis.md` § Step 1 to normalize to English keys before analysis.

### Step 4: Launch `portfolio-monitor` Agent

Hand off the structured data to the **portfolio-monitor** agent with instruction to:

1. Follow Step 6 of `variance-analysis.md` to generate the report
2. Write board-ready executive summary (1 paragraph)
3. Populate the KPI dashboard table with flags
4. Write red/yellow flag sections with root cause + action
5. Write 3-5 specific questions for management
6. Apply the agent's Reflection Protocol (watch for signal-to-noise issues)

### Step 5: Save Output

**Markdown report**: `output/portfolio/{slug}-variance-{YYYY-MM-DD}.md`

Structure from `variance-analysis.md` Output Template.

### Step 6: Update State

**Update `data/state/portfolio.json`** for the company entry:

```json
{
  "last_variance_date": "{today}",
  "last_variance_status": "Green|Yellow|Red",
  "last_variance_summary": "{1-2 sentence summary}",
  "last_variance_report_path": "output/portfolio/{slug}-variance-{date}.md",
  "health_score": <1-10>,
  "key_risks": "{updated pipe-separated list}"
}
```

**Auto-trigger DCF refresh** if ANY of these are true:
- Variance flag is Red
- EBITDA variance is >20% adverse
- Covenant headroom < 10%
- Material business change noted (new customer concentration, regulatory event)

Auto-trigger means: add a new job to `running-jobs.json` with `title: "DCF refresh: {company}"`
and suggest to user: "Variance analysis flagged material issues. Run `/dcf {company}` to
refresh the valuation?"

### Step 7: Wiki Update (if new facts)

Append to `wiki/companies/{slug}.md` under `## Updates`:

```markdown
### {date} — {Period} variance review
- Revenue: ${X}M ({+/-}{Y}% vs plan) — {Green|Yellow|Red}
- EBITDA: ${X}M ({+/-}{Y}% vs plan)
- Key flag: {description}
- Report: `{path}`
```

### Step 8: Report to User

Print the executive summary + flag list to the terminal. Include:

- File paths written
- State changes made
- Whether DCF refresh was auto-triggered
- Next recommended action

### Step 9: Mark Job Complete + Reflection

Update `running-jobs.json`: status → completed, progress_pct → 100.

Apply `portfolio-monitor` agent's Reflection Protocol — if new insights about data
extraction, budget handling, or covenant patterns, append to
`learnings/portfolio-monitor.md`.

Log the event to `data/state/evolution-log.json` if a new learning was captured.

## Safety Rules

1. **Confidentiality**: variance reports contain sensitive portfolio financials. Never
   expose outside fund context. Never copy to public research outputs.
2. **No fabricated data**: if budget, plan, or covenant terms are missing, ask — do not
   assume "reasonable" values.
3. **User confirmation before state writes**: show the proposed portfolio.json diff
   before writing.
4. **No auto-distribution**: the variance report is GP-internal by default. Explicit
   user approval required for any sharing.
5. **Respect the anonymization rule**: if any variance output is referenced in external
   research, anonymize company names per CLAUDE.md § Safety Rules.

## Triggered automatically by

- `/portfolio-review` Step 2 — drill-down on Yellow/Red flagged companies from fund-level
  scan (when the user says "show me variance on {X}" or clicks through from the fund review)

## See also

- `skills/portfolio-ops/references/variance-analysis.md` — full methodology (mandatory read)
- `skills/portfolio-ops/references/kpi-frameworks.md` — sector KPI tables
- `commands/portfolio-review.md` — parent fund-level review (calls this as drill-down)
- `commands/dcf.md` — auto-invoked when variance triggers valuation refresh
- `agents/portfolio-monitor.md` — the agent that produces the final report
