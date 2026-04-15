---
name: dcf
description: Build an institutional-quality DCF valuation model with Bear/Base/Bull scenarios and full sensitivity analysis
---

Build a DCF valuation model for $ARGUMENTS.

## Input

Accept one positional argument:
- **Company name or ticker** (required) — must exist in `data/state/portfolio.json`,
  `data/state/deals.json`, or be a public company resolvable via Daloopa/Perplexity.

Examples:
- `/dcf AAPL` — public company, fetch via Daloopa
- `/dcf "Quantum Labs"` — portfolio company from `data/state/portfolio.json`
- `/dcf "Acme Robotics"` — pipeline deal from `data/state/deals.json`

If no argument provided, ask: "Which company would you like to value via DCF?"

## Process

### Step 0: Register Job

Add an entry to `data/state/running-jobs.json`:

```json
{
  "job_id": "job-dcf-{slug}-{YYYYMMDD}",
  "type": "custom",
  "title": "DCF model: {company}",
  "agent": "financial-analyst",
  "status": "in_progress",
  "started_date": "{ISO 8601}",
  "last_activity": "{ISO 8601}",
  "progress_pct": 0,
  "current_step": "Step 1: Data retrieval",
  "output_path": "deals/{slug}/dcf-model.xlsx",
  "context_files": []
}
```

### Step 1: Resolve Company Context

Determine which type of company this is and load the relevant context:

**Case A — Portfolio company** (exists in `data/state/portfolio.json`):
- Read the portfolio entry: sector, stage, last valuation, methodology, last KPI date
- Load `wiki/companies/{slug}.md` for context if it exists
- Load `data/comps/{sector}.xlsx` for peer comparables
- Check if a previous DCF exists at `data/fund/{company}-dcf-*.xlsx` for prior assumptions
- Confidence baseline: High (Series C+), Medium (Series B), Low (earlier)

**Case B — Pipeline deal** (exists in `data/state/deals.json`):
- Read the deal entry: sector, stage, screening score, sourcing context
- Load `deals/{slug}/notes.md` and `deals/{slug}/model.xlsx` if they exist
- Load `data/comps/{sector}.xlsx` for peer comparables
- Confidence baseline: Medium for Series B+, Low for earlier

**Case C — Public company / new analysis** (not in any state file):
- Ask user to confirm ticker
- Use Daloopa MCP for historical financials (3-5 years)
- Use Perplexity for current stock price, beta, market cap, recent news
- Confidence baseline: High (sufficient public data)

In all cases, populate `context_files` in the running-jobs entry.

### Step 2: Load Skills and Launch Agent

Launch the **financial-analyst** agent with these skill loads:

1. `skills/valuation-report/references/dcf-construction.md` — the DCF methodology (PRIMARY)
2. `skills/valuation-report/SKILL.md` — for stage-based methodology context
3. `anthropic-skills:xlsx` — for openpyxl patterns and recalc.py

The agent must follow the `dcf-construction.md` Critical Constraints section verbatim:
- Formulas over hardcodes
- Step-by-step verification gates (Steps 1-10 with user confirmation)
- Cell comments AS created
- Layout planning before formulas
- Recalc validation before delivery

### Step 3: Verification Gates (Mandatory)

The financial-analyst agent MUST stop and confirm with the user at each of these gates
before proceeding. Do NOT batch them; each gate is its own message:

| Gate | Show | Wait for OK before |
|------|------|---------------------|
| 1 | Raw inputs block (revenue, margins, shares, net debt) with sources | Building projections |
| 2 | Revenue projections (Bear/Base/Bull) with growth rates and rationale | Building margin/OpEx |
| 3 | Full unlevered FCF schedule | Computing WACC |
| 4 | WACC calculation (CAPM components, weights, result) | Discounting |
| 5 | Equity bridge (EV → equity → per share) for Base case | Building sensitivity tables |
| 6 | All three sensitivity tables populated and center-cell verified | Final delivery |

If the user catches an error at gate N, fix it before progressing to N+1. Update the
running-jobs `current_step` and `progress_pct` after each gate clears.

### Step 4: Build the Excel Model

The model is built incrementally per the gate sequence above. Use `openpyxl` via the
xlsx skill. Key requirements (full detail in `dcf-construction.md`):

**Two sheets**: DCF (with sensitivity at bottom) + WACC

**Color scheme**:
- Blue font = hardcoded inputs
- Black font = formulas
- Green font = sheet links
- Dark blue fill `#1F4E79` for section headers
- Medium blue fill `#BDD7EE` for output rows + sensitivity center cells

**Formula discipline**:
- Use a **consolidation column** with `INDEX(scenario_block, 1, $case_selector_cell)`
  rather than scattered IF formulas
- All projections reference the consolidation column for clean, auditable formulas
- ALL hardcoded inputs get cell comments at creation time

**Sensitivity tables** (3 tables × 25 cells = 75 formulas):
- Table 1: WACC × Terminal Growth (5×5)
- Table 2: Revenue Growth × EBIT Margin (5×5)
- Table 3: Beta × Risk-Free Rate (5×5)
- Center cell of each = base case implied price (medium blue fill, bold)
- Populated programmatically via Python loop, NOT linear approximations

### Step 5: Recalc Validation

Run the xlsx skill's recalc:

```bash
python recalc.py deals/{slug}/dcf-model.xlsx 30
```

Expected: `{"status": "success", "total_errors": 0}`.

If any errors (`#REF!`, `#DIV/0!`, `#VALUE!`, `#NAME?`, `#NULL!`, `#NUM!`, `#N/A`),
fix the underlying formula and re-run. Zero errors required before delivery.

### Step 6: Save Outputs

**Excel model**:
- Pipeline deal: `deals/{slug}/dcf-model.xlsx`
- Portfolio company: `data/fund/{company}-dcf-{YYYY}Q{Q}.xlsx`
- Public-only analysis: `output/research/dcf-{ticker}-{date}.xlsx`

**State updates**:

For portfolio company → update `data/state/portfolio.json`:
```json
{
  "current_valuation_usd": <implied equity value>,
  "valuation_source": "DCF",
  "valuation_confidence": "High|Medium|Low",
  "last_valuation_date": "{today}"
}
```

For pipeline deal → update `data/state/deals.json`:
```json
{
  "entry_valuation_usd": <base case implied EV>
}
```
And append a summary block to `deals/{slug}/notes.md`:
```markdown
## DCF Valuation — {date}

| Scenario | Implied Price | EV | Upside vs Current |
|----------|--------------|-----|---------------------|
| Bear     | $X.XX        | $Y  | -XX%                |
| Base     | $X.XX        | $Y  | +XX%                |
| Bull     | $X.XX        | $Y  | +XX%                |

Key assumptions:
- WACC: X.X% | Terminal g: X.X% | Projection period: X years
- Terminal value as % of EV: XX%

Output: `deals/{slug}/dcf-model.xlsx`
```

**Wiki update** (optional but encouraged):
Append to `wiki/companies/{slug}.md` under `## Updates`:
```markdown
### {date} — DCF valuation update
- Base case implied price: $X.XX (Source: deals/{slug}/dcf-model.xlsx)
- WACC: X.X% | Terminal g: X.X%
- Methodology: DCF (perpetuity growth)
```

### Step 7: Deliver Summary

Print a concise summary to the user:

```
## DCF Summary — {Company}

**Valuation range** (from sensitivity center ± 2 steps):
- Bear:  $X.XX   ({-XX%} vs current)
- Base:  $X.XX   ({+XX%} vs current)
- Bull:  $X.XX   ({+XX%} vs current)

**Key assumptions**:
- WACC:           X.X%
- Terminal growth: X.X%
- Projection period: X years
- Terminal value:  XX% of EV  ({within | outside} 50-70% range)

**Sanity checks**:
- ✅ Terminal growth < WACC
- ✅ OpEx referenced to revenue (not gross profit)
- ✅ All 75 sensitivity formulas populated
- ✅ Recalc.py status: success ({N} formulas, 0 errors)
- ✅ Net debt sign: {positive subtracts | negative adds}

**Files written**:
- {model path}
- {state file paths updated}
```

### Step 8: Mark Job Complete + Reflection

Update `data/state/running-jobs.json`:
- `status`: `completed`
- `progress_pct`: 100
- `last_activity`: now

Add to `data/state/evolution-log.json` if any new insights were captured.

The financial-analyst agent's Reflection Protocol applies — if any unusual data, tool
quirks, or methodology decisions came up, append to `learnings/financial-analyst.md`.

## Safety Rules

1. **Verification gates are non-negotiable** — never batch all 6 gates into a single
   confirmation. Each is a separate user-approval step.
2. **Recalc must pass** — never deliver a model with formula errors.
3. **Confidence flag** — always set `valuation_confidence` honestly. Low confidence is
   acceptable; mislabeled confidence is not.
4. **Portfolio updates require user confirmation** — show the proposed `portfolio.json`
   change before writing.
5. **No fabricated data** — if a required input is missing, ask the user. Never
   assume "reasonable" values for risk-free rate, beta, or shares outstanding.

## Triggered automatically by

- `/ic-memo` Step 2 — when deal stage ≥ Series B and revenue exists
- `/portfolio-review` Step 3 — when `last_valuation_date` > 12 months OR
  `valuation_source` ≠ "DCF" for Series C+ companies

## See also

- `skills/valuation-report/references/dcf-construction.md` — full methodology (mandatory read)
- `skills/valuation-report/SKILL.md` — stage-based methodology context
- `commands/ic-memo.md` — calls `/dcf` from Step 2
- `commands/portfolio-review.md` — calls `/dcf` from Step 3
