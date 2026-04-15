# Portfolio Company Variance Analysis

> **Source**: Adapted from `anthropics/financial-services-plugins/private-equity/skills/portfolio-monitoring/SKILL.md`
> (57 lines). Extended with GPilot's state-layer integration, bilingual notes, and cross-references
> to existing KPI frameworks and valuation reports.
>
> **When to use**: Per-company financial variance check against budget/plan, covenant compliance,
> and red-flag triage. Invoked by `/portfolio-variance` command, and from `/portfolio-review` Step 2
> as a drill-down on Yellow/Red-flagged companies.
>
> **Distinction from `/portfolio-review`**: `/portfolio-review` is fund-level (NAV, TVPI, IRR,
> concentration). Variance analysis is **per-company** (revenue/EBITDA vs budget, covenant ratios,
> KPI trend). The two are complementary — use both.

## Purpose

Answer the question: **"How is {company} tracking against its plan?"** in board-ready form,
with:

- Quantified variance to budget (green/yellow/red flags)
- Covenant compliance status (if applicable)
- KPI trends vs prior periods
- Questions for management

Output is saved to `output/portfolio/{company}-variance-{date}.md` and the key metrics are
written back to `data/state/portfolio.json` under the relevant portfolio entry.

## Input Requirements

1. **Company name** (required) — must exist in `data/state/portfolio.json`
2. **Financial package** (required) — one of:
   - Excel workbook path (`.xlsx` monthly/quarterly package from management)
   - PDF board report path
   - CSV extract
   - Inline data provided by user
3. **Reporting period** (required) — e.g., "Q1 2026", "Mar 2026", "YTD through Apr 2026"
4. **Budget/plan** (required if not in package) — either embedded in the financial package
   or provided separately. If neither, ASK the user — do not invent a plan.
5. **Credit agreement terms** (optional) — for covenant checks. If the portfolio entry has
   `credit_agreement_path`, load it. Otherwise ask.

## Workflow

### Step 1: Ingest Financial Package

- If Excel/CSV: use the `xlsx` skill to extract key line items
- If PDF: use the `pdf` skill to extract tables (focus on income statement, balance sheet, cash flow)
- Populate a structured internal representation:

```python
{
  "period": "Q1 2026",
  "period_end": "2026-03-31",
  "reporting_currency": "USD",  # or "CNY" — record explicitly
  "actuals": {
    "revenue": ...,
    "gross_profit": ...,
    "ebitda": ...,
    "net_income": ...,
    "cash_balance": ...,
    "total_debt": ...,
    "capex": ...,
    "working_capital": ...,
  },
  "budget": {
    # Same keys as actuals — required for variance
  },
  "prior_period": {
    # Same keys — used for trend analysis
  }
}
```

**Bilingual note**: If the package is in Chinese (常见于 China portfolio companies), the
extractor should map common Chinese labels to English keys:
- 营业收入 / 主营业务收入 → revenue
- 毛利 / 毛利润 → gross_profit
- 息税折旧摊销前利润 / EBITDA → ebitda
- 净利润 → net_income
- 货币资金 / 现金 → cash_balance
- 有息负债 / 借款总额 → total_debt

### Step 2: KPI Extraction & Variance Analysis

#### Financial KPIs (standard across sectors)

| KPI | Formula | Why it matters |
|-----|---------|---------------|
| Revenue vs Budget ($ and %) | `(Actual - Budget) / Budget` | Top-line health |
| EBITDA vs Budget ($ and %) | Same | Operating leverage check |
| EBITDA margin vs Budget | `EBITDA / Revenue` | Margin compression alert |
| Cash balance | Absolute | Runway indicator |
| Net debt | `Total Debt - Cash` | Leverage position |
| Leverage ratio | `Net Debt / LTM EBITDA` | Covenant risk |
| Interest coverage | `EBITDA / Interest Expense` | Debt service capacity |
| Capex vs Budget | Same | Investment discipline |
| Free cash flow | `EBITDA - Capex - ΔWC - Taxes` | Cash generation |

#### Sector-adjusted operational KPIs

Load `skills/portfolio-ops/references/kpi-frameworks.md` to find the KPI table for the
company's sector. Key per-sector must-haves:

| Sector | Must-track KPIs |
|--------|----------------|
| SaaS | ARR, NDR, Gross Churn, CAC Payback, Magic Number, Rule of 40, Burn Multiple |
| Fintech | TPV, Take Rate, NIM (if lending), Default/Loss Rate |
| Healthtech | Patients served, Revenue per patient, Clinical outcomes, Payer contracts |
| Marketplace | GMV, Take Rate, Liquidity, Active buyers/sellers |
| AI/ML infra | Compute cost per inference, Model accuracy benchmarks, Customer concentration |
| Deeptech/Semis | Yield rate, Unit cost trajectory, Tape-out milestones |

**Do not assume sector-specific KPIs** — if the company is unusual, ASK what matters
rather than guessing.

### Step 3: Flag with 3-Color Traffic Light

Apply these thresholds to each tracked metric:

| Flag | Threshold | Meaning |
|------|-----------|---------|
| 🟢 Green | Within 5% of plan (favorable or slightly unfavorable) | On track |
| 🟡 Yellow | 5-15% below plan | Flag for management discussion |
| 🔴 Red | >15% below plan OR covenant breach risk | Immediate attention |

**Special cases that always trigger Red regardless of variance %**:

- Cash runway < 6 months
- Covenant headroom < 10% (leverage ratio within 10% of limit)
- Interest coverage < 1.25x
- Working capital deterioration accelerating for 2+ consecutive periods
- Revenue concentration: top customer > 30% of revenue
- Material audit findings or going-concern language in financials

### Step 4: Covenant Compliance Check

If the portfolio entry has associated debt:

1. Load credit agreement terms from `credit_agreement_path` or ask user for:
   - Maximum leverage ratio (e.g., Net Debt / LTM EBITDA ≤ 4.0x)
   - Minimum interest coverage (e.g., EBITDA / Interest ≥ 2.5x)
   - Minimum liquidity (e.g., Cash ≥ $10M)
   - Any other financial covenants (CapEx cap, debt service reserve)

2. Compute actual values from Step 2

3. Report:
   - **Compliance**: Actual value, covenant limit, headroom %
   - **Trend**: Improving / Stable / Deteriorating over last 3 periods
   - **Cure period**: If in breach, how many days/periods to cure

4. If in breach or <10% headroom: escalate to Red flag and add to "Questions for Management"

### Step 5: Trend Analysis (if multiple periods provided)

If the financial package includes 3+ periods of data:

- **Chart key metrics over time**: revenue, EBITDA, cash, leverage
- **Identify direction**: accelerating / decelerating / stable / inflecting
- **Compare vs underwriting case**: reference the original investment memo's base case

Save a simple trend table in the output:

```markdown
| Metric | 3 Periods Ago | 2 Periods Ago | Prior Period | Current | Trend |
|--------|---------------|---------------|-------------|---------|-------|
| Revenue | $X | $Y | $Z | $W | ↗ (accelerating) |
| EBITDA margin | X% | Y% | Z% | W% | ↘ (compressing) |
```

### Step 6: Generate Summary

**One-paragraph executive summary** (board-ready):

> "{Company} is tracking [ahead of / behind / on] plan for {period}. Revenue of ${X}M
> is {+/-}{Y}% vs budget of ${Z}M, and EBITDA margin of {A}% is {+/-}{B} pp vs plan.
> Cash position is {healthy/concerning/critical} at ${C}M with {D} months of runway.
> {1-2 sentences on the most critical yellow/red flag and recommended action.}"

**KPI table** — actual vs budget vs prior period, one row per metric, with flag column.

**Red/Yellow flags section** — each with:
- The flag (e.g., "Revenue −18% vs plan")
- Root cause (as far as can be determined from the data)
- Recommended action
- Questions for management

**Covenant compliance section** (if applicable) — actual vs limit with headroom %.

**Questions for management** — 3-5 specific questions to address at next board meeting or
check-in call.

### Step 7: Save Output and Update State

**Markdown report**: `output/portfolio/{company-slug}-variance-{YYYY-MM-DD}.md`

**State update** to `data/state/portfolio.json`:

```json
{
  "last_variance_date": "{today}",
  "last_variance_status": "Green|Yellow|Red",
  "last_variance_summary": "1-2 sentence summary",
  "last_variance_report_path": "output/portfolio/{slug}-variance-{date}.md",
  "health_score": <recalculated 1-10 based on flags>,
  "key_risks": "<updated pipe-separated list if new risks surfaced>"
}
```

**If variance triggers auto-refresh conditions** (Red flag + significant business change),
append a trigger to running-jobs.json to run `/dcf {company}` to update valuation.

**Wiki update** (optional):
Append to `wiki/companies/{slug}.md` under `## Updates`:
```markdown
### {date} — {Period} variance review
- Revenue: ${X}M ({+/-}{Y}% vs plan) — {Green|Yellow|Red}
- EBITDA: ${X}M ({+/-}{Y}% vs plan)
- Key flag: {description}
- Report: {path}
```

## Output Template

```markdown
# {Company} — {Period} Variance Review
**Date**: {report date} | **Reporting period**: {period} | **Currency**: {USD|CNY}

## Executive Summary
{One paragraph per Step 6}

## KPI Dashboard

### Financial Metrics
| Metric | Budget | Actual | Variance ($) | Variance (%) | Flag |
|--------|--------|--------|--------------|--------------|------|
| Revenue | $X | $Y | $Z | X% | 🟡 |
| Gross profit | ... | ... | ... | ... | 🟢 |
| EBITDA | ... | ... | ... | ... | 🔴 |
| EBITDA margin | X% | Y% | pp | | 🟡 |
| Operating cash flow | ... | ... | ... | ... | 🟢 |
| Cash balance | $X | $Y | | | 🟢 |
| Total debt | $X | $Y | | | 🟢 |
| Capex | $X | $Y | | | 🟢 |

### Sector KPIs ({sector})
| KPI | Budget | Actual | Variance | Flag |
|-----|--------|--------|----------|------|
| {sector-specific} | ... | ... | ... | ... |

## Trend Analysis
{Optional, if 3+ periods available}

## Covenant Compliance
{Only if debt exists}
| Covenant | Limit | Actual | Headroom | Trend | Status |
|----------|-------|--------|----------|-------|--------|
| Leverage ≤ 4.0x | 4.0x | 3.2x | 20% | Stable | ✅ |
| Interest cover ≥ 2.5x | 2.5x | 3.8x | 52% | Improving | ✅ |

## Red/Yellow Flags
### 🔴 {Flag headline}
- **Observation**: ...
- **Root cause**: ...
- **Recommended action**: ...

### 🟡 {Flag headline}
- **Observation**: ...
- **Root cause**: ...
- **Recommended action**: ...

## Questions for Management
1. ...
2. ...
3. ...

## Next Steps
- [ ] {action item} — {owner}
- [ ] {action item} — {owner}
```

## Important Notes

- **Always ask for budget/plan** if not in the package. Never invent a plan.
- **Don't assume sector-specific KPIs** — ask what matters for this company
- **Output must be board-ready** — concise, factual, no fluff, numbers tied
- **If covenant levels aren't known**, ask the user for the credit agreement terms
- **Flag data gaps explicitly** — missing data is itself a signal
- **Respect confidentiality** — variance reports contain sensitive portfolio data, never
  expose outside the fund context
- **Follow GPilot safety rules**: this reads state files but never sends external
  communications without explicit user approval

## Triggered by

- `/portfolio-variance {company}` — direct user invocation
- `/portfolio-review` Step 2 — as drill-down on Yellow/Red flagged companies (auto-invoked)

## See also

- `skills/portfolio-ops/SKILL.md` — parent skill
- `skills/portfolio-ops/references/kpi-frameworks.md` — sector-specific KPI tables
- `skills/portfolio-ops/references/valuation-methods.md` — for any DCF refresh needed
- `skills/valuation-report/references/dcf-construction.md` — auto-invoked when variance triggers DCF refresh
- `commands/portfolio-review.md` — calls this skill from Step 2
- `commands/portfolio-variance.md` — the command wrapper
