# DCF Model Construction

> **Source**: Adapted from `anthropics/financial-services-plugins/financial-analysis/skills/dcf-model/SKILL.md`
> (1,263 lines, fetched 2026-04-15). Stripped Office JS specifics (GPilot uses Python/openpyxl
> via the `xlsx` skill exclusively), retained all formula-rigor discipline.
>
> **When to use**: Build an institutional-quality DCF model with sensitivity analysis,
> three-scenario blocks (Bear/Base/Bull), and full equity bridge. Triggered by `/dcf` command,
> `/ic-memo` Step 2 (for Series B+ deals with revenue), and `/portfolio-review` Step 3
> (for portfolio companies where last DCF >12 months old).
>
> **Output**: `deals/{company}/dcf-model.xlsx` (or `data/fund/{company}-dcf-{date}.xlsx`
> for portfolio companies). Updates `data/state/portfolio.json` with new valuation +
> `valuation_source: "DCF"` + `valuation_confidence: High|Medium|Low`.

## Critical Constraints — Read These First

These constraints are NON-NEGOTIABLE. Re-read before starting any DCF.

### 1. Formulas Over Hardcodes

**Every** projection, margin, discount factor, PV, and sensitivity cell MUST be a live
Excel formula — never a value computed in Python and written as a number.

```python
# CORRECT
ws["D20"] = "=D19*(1+$B$8)"

# WRONG — defeats the purpose of an Excel model
ws["D20"] = calculated_revenue
```

The **only** hardcoded numbers permitted are:

1. Raw historical inputs (revenue, EBITDA, shares from filings)
2. Assumption drivers (growth rates, WACC inputs, terminal g)
3. Current market data (share price, debt balance)

If you catch yourself computing something in Python and writing the result — STOP. The
model must flex when the user changes an assumption. A "DCF" that doesn't recalculate
when you change WACC is not a DCF, it's a screenshot.

### 2. Verify Step-by-Step With the User

**DO NOT build end-to-end and present at the end.** Stop at each gate for confirmation:

| Gate | Show user | Wait for confirmation before |
|------|-----------|-----------------------------|
| 1. Data retrieval | Raw inputs block (revenue, margins, shares, net debt) | Building projections |
| 2. Revenue projections | Projected top line + growth rates | Building margin/OpEx |
| 3. FCF schedule | Full unlevered FCF schedule | Computing WACC |
| 4. WACC | CAPM calculation + inputs | Discounting |
| 5. Terminal + PV | Equity bridge (EV → equity → per share) | Sensitivity tables |
| 6. Sensitivity tables | All three populated tables | Final delivery |

**Why**: A wrong margin assumption discovered after sensitivity tables are built means
rebuilding 75 sensitivity formulas. Catch errors at each stage.

### 3. Sensitivity Tables: ODD Dimensions, Center = Base Case

- Use **odd** number of rows AND columns (5×5 standard, 7×7 for high-stakes models)
- **Center cell = base case**. Build the axis values so the middle row header and middle
  column header **exactly equal** the model's actual base assumptions
- The center cell's output **must** equal the model's actual implied share price — this
  is the sanity check that the table is built correctly
- **Highlight the center cell** with medium-blue fill (`#BDD7EE`) + bold font
- Populate ALL cells (3 tables × 25 cells = 75 cells) with full DCF recalculation formulas
- Use Python loops to write formulas programmatically
- **NO** placeholder text, **NO** linear approximations, **NO** "user can fill in via Data Table feature"

### 4. Cell Comments AS You Create

Add cell comments **AS each hardcoded value is created**, not at the end.

Format: `Source: [System/Document], [Date], [Reference], [URL if applicable]`

Examples:
- `Source: 10-K FY2024, p.47, Note 12 (diluted shares)`
- `Source: Daloopa MCP, 2026-04-15, ticker AAPL, beta_5y_monthly`
- `Source: Management guidance Q1 2026 earnings call, slide 12`

Every blue input must have a comment **before** moving to the next section. Never write
"TODO: add source" — that becomes "TODO: forever".

### 5. Layout Planning Before Formulas

```
Step 1: Define ALL section row positions (header, market data, assumptions, IS, FCF, WACC bridge, valuation, sensitivity)
Step 2: Write ALL labels and headers using locked positions
Step 3: Write ALL section dividers and blank rows
Step 4: THEN write formulas using the locked row positions
Step 5: Test formulas immediately after creation
```

Construction analogy: pour foundation → build walls. Not the other way.

### 6. Recalc Validation Before Delivery

After the model is built, **always** run the xlsx skill's `recalc.py`:

```bash
python recalc.py deals/{company}/dcf-model.xlsx 30
```

Expected: `{"status": "success", "total_errors": 0, "total_formulas": N}`

If errors found (`#REF!`, `#DIV/0!`, `#VALUE!`, `#NAME?`, `#NULL!`, `#NUM!`, `#N/A`),
fix and re-run until status is success. Zero formula errors required.

---

## DCF Process Workflow

### Step 1: Data Retrieval and Validation

**Data sources priority**:

1. **MCP servers** (Daloopa for public companies, Perplexity for context)
2. **GPilot local data**:
   - `data/state/portfolio.json` for portfolio companies
   - `deals/{company}/model.xlsx` for in-pipeline deals
   - `data/comps/{sector}.xlsx` for peer comparables
   - `wiki/companies/{company}.md` for context
3. **User-provided data** if MCP/local missing
4. **Web search/fetch** for current stock prices, beta, recent debt balances

**Validation checklist**:

- [ ] Verify net debt vs net cash (critical — sign error breaks valuation)
- [ ] Confirm diluted shares outstanding (check for recent buybacks/issuances)
- [ ] Validate historical margins are consistent with business model
- [ ] Cross-check revenue growth rates vs industry benchmarks (use `data/comps/`)
- [ ] Verify tax rate (typically 21-28% for US, 25% China, 19% UK, 30% Japan)

**Bilingual note**: For China-domiciled companies, explicitly note CNY ↔ USD FX rate
and conversion date. Hardcode the rate as a separate input cell with a comment.

### Step 2: Historical Analysis (3-5 years)

Document and analyze:

- **Revenue growth trends**: CAGR, identify drivers
- **Margin progression**: gross margin, EBIT margin, FCF margin
- **Capital intensity**: D&A and CapEx as % of revenue
- **Working capital efficiency**: NWC changes as % of revenue growth
- **Return metrics**: ROIC, ROE trends

Build summary table showing LTM and 3-year history:

```
Historical Metrics (LTM):
  Revenue:           $XXX million
  Revenue growth:    XX% (vs Y/Y), XX% (3Y CAGR)
  Gross margin:      XX%
  EBIT margin:       XX%
  D&A % of revenue:  X.X%
  CapEx % of revenue: X.X%
  FCF margin:        XX%
```

### Step 3: Build Revenue Projections

**Methodology**:

1. Start with latest actual revenue (LTM or most recent fiscal year)
2. Apply growth rates per scenario for each projection year
3. Show both dollar amounts AND calculated growth %

**Growth rate framework**:

| Period | Approach |
|--------|----------|
| Year 1-2 | Higher growth reflecting near-term visibility (consensus or management guidance) |
| Year 3-4 | Gradual moderation toward industry average |
| Year 5+  | Approaching terminal growth rate |

**Three-scenario approach**:

```
Bear Case:  Conservative growth (e.g., 8-12%)
Base Case:  Most likely scenario (e.g., 12-16%)
Bull Case:  Optimistic growth (e.g., 16-20%)
```

**Formula pattern** (locked rows assumed):

```
Revenue(Year N) = Revenue(Year N-1) × (1 + Growth Rate from consolidation column)
Growth %(Year N) = Revenue(Year N) / Revenue(Year N-1) - 1
```

### Step 4: Operating Expense Modeling

**Critical rule**: ALL operating expense percentages based on **REVENUE**, not gross profit.

```python
# CORRECT
ws["E36"] = "=E29*0.15"  # E29 = Revenue, S&M = 15% of revenue

# WRONG — produces unrealistic margin progression
ws["E36"] = "=E33*0.15"  # E33 = Gross Profit
```

**Typical OpEx ranges**:

| Line item | Range | Notes |
|-----------|-------|-------|
| Sales & Marketing | 15-40% of revenue | Higher for SaaS (CAC payback), lower for enterprise |
| Research & Development | 10-30% | Higher for tech/biotech |
| General & Administrative | 8-15% | Should show leverage as company scales |

**Margin expansion framework**:

```
Current State → Target State (Year 5)
  Gross Margin: X% → Y% (justify based on scale, mix shift, efficiency)
  EBIT Margin:  X% → Y% (result of revenue growth + opex leverage)
```

### Step 5: Free Cash Flow Calculation

**Build FCF in proper sequence**:

```
EBIT
(-) Taxes (EBIT × Tax Rate)
= NOPAT (Net Operating Profit After Tax)
(+) D&A (non-cash expense, % of revenue)
(-) CapEx (% of revenue, typically 4-8%)
(-) Δ NWC (change in working capital)
= Unlevered Free Cash Flow
```

**Working Capital Modeling**:

- Calculate as % of revenue **change** (delta revenue)
- Typical range: -2% to +2% of revenue change
- Negative number = source of cash (working capital release)
- Positive number = use of cash (working capital build)

**Maintenance vs Growth CapEx**:

- Maintenance CapEx: ~2-3% of revenue (sustains operations)
- Growth CapEx: additional 2-5% of revenue (supports expansion)
- Total CapEx should align with company's growth strategy

### Step 6: Cost of Capital (WACC) Research

**CAPM Methodology for Cost of Equity**:

```
Cost of Equity = Risk-Free Rate + Beta × Equity Risk Premium

Where:
  Risk-Free Rate    = Current 10-Year Treasury Yield (use 10Y CGB for China)
  Beta              = 5-year monthly stock beta vs market index
  Equity Risk Premium = 5.0-6.0% (market standard, higher for emerging markets)
```

**Cost of Debt**:

```
After-Tax Cost of Debt = Pre-Tax Cost of Debt × (1 - Tax Rate)

Pre-Tax Cost of Debt from:
  - Credit rating (if available)
  - Current yield on company bonds
  - Interest expense / Total Debt from financials
```

**Capital Structure Weights**:

```
Market Value Equity = Current Stock Price × Shares Outstanding
Net Debt = Total Debt - Cash & Equivalents
Enterprise Value = Market Cap + Net Debt

Equity Weight = Market Cap / Enterprise Value
Debt Weight = Net Debt / Enterprise Value

WACC = (Cost of Equity × Equity Weight) + (After-Tax Cost of Debt × Debt Weight)
```

**Special cases**:

- **Net cash position**: If Cash > Debt, Net Debt is negative → Debt Weight may be negative → WACC adjusts
- **No debt**: WACC = Cost of Equity
- **Pre-IPO companies**: Use peer beta (unlevered beta from public comps, re-levered with target capital structure)

**Typical WACC ranges**:

| Profile | WACC |
|---------|------|
| Large cap, stable | 7-9% |
| Growth companies | 9-12% |
| High growth / risk | 12-15% |
| Pre-IPO / venture | 15-25% |

### Step 7: Discount Rate Application

**Mid-Year Convention** (preferred for most analyses):

- Cash flows assumed to occur mid-year
- Discount Period: 0.5, 1.5, 2.5, 3.5, 4.5, etc.
- Discount Factor = 1 / (1 + WACC)^Period

**Example (Year 1 with WACC = 10%)**:

```
FCF              = $1,000
WACC             = 10%
Period           = 0.5
Discount Factor  = 1 / (1.10)^0.5 = 0.9535
PV               = $1,000 × 0.9535 = $954
```

**Projection period selection**:

| Company profile | Period |
|-----------------|--------|
| Standard | 5 years |
| High growth (longer runway) | 7-10 years |
| Mature, stable | 3 years |

### Step 8: Terminal Value Calculation

**Perpetuity Growth Method (Preferred)**:

```
Terminal FCF = Final Year FCF × (1 + Terminal Growth Rate)
Terminal Value = Terminal FCF / (WACC - Terminal Growth Rate)

Critical Constraint: Terminal Growth < WACC (otherwise infinite value)
```

**Terminal growth rate selection**:

| Profile | Range |
|---------|-------|
| Conservative | 2.0-2.5% (≈ GDP growth) |
| Moderate | 2.5-3.5% |
| Aggressive | 3.5-5.0% (only for market leaders with structural advantages) |

**Hard limits**: Do not exceed risk-free rate or long-term GDP growth.

**Exit Multiple Method (Alternative / Cross-check)**:

```
Terminal Value = Final Year EBITDA × Exit Multiple

Exit Multiple from:
  - Industry comparable trading multiples (data/comps/)
  - Precedent transaction multiples
  - Typical range: 8-15x EBITDA
```

**Present Value of Terminal Value**:

```
PV of Terminal Value = Terminal Value / (1 + WACC)^Final Period

Where Final Period accounts for mid-year convention timing:
5-year model with mid-year convention: Period = 4.5
```

**Terminal Value Sanity Check**:

- Should represent **50-70% of Enterprise Value**
- If >75%: model may be over-reliant on terminal assumptions — flag and re-examine
- If <40%: terminal assumptions may be too conservative — check

### Step 9: Enterprise to Equity Value Bridge

```
(+) Sum of PV of Projected FCFs    = $X million
(+) PV of Terminal Value           = $Y million
=   Enterprise Value               = $Z million

(-) Net Debt [or + Net Cash]       = $A million
=   Equity Value                   = $B million

÷   Diluted Shares Outstanding     = C million shares
=   Implied Price per Share        = $XX.XX

Current Stock Price                = $YY.YY
Implied Return                     = (Implied / Current) - 1 = XX%
```

**Critical adjustments**:

- **Net Debt = Total Debt − Cash & Equivalents**
  - Positive: subtract from EV (reduces equity value)
  - Negative (net cash): ADD to EV (increases equity value)
- **Use Diluted Shares**: includes options, RSUs, convertible securities
- **Other adjustments** (if applicable):
  - Minority interests
  - Pension liabilities
  - Operating lease obligations (if not already in debt)

### Step 10: Sensitivity Analysis

**Three sensitivity tables** at the bottom of the DCF sheet showing how valuation changes
with different assumptions:

1. **WACC vs Terminal Growth** — discount rate × perpetuity growth
2. **Revenue Growth vs EBIT Margin** — top-line growth × operating leverage
3. **Beta vs Risk-Free Rate** — cost of equity components

**Implementation**: simple 2D grids (NOT Excel's "Data Table" feature) with formulas in
each cell. Each cell must contain a full DCF recalculation for that specific assumption
combination.

**Example layout** (5×5 grid for WACC × Terminal Growth, base WACC=9.0%, base g=3.0%):

```
WACC \ TermG    2.0%   2.5%   3.0%   3.5%   4.0%
       8.0%    [fml]  [fml]  [fml]  [fml]  [fml]
       8.5%    [fml]  [fml]  [fml]  [fml]  [fml]
       9.0%    [fml]  [fml]  [★  ]  [fml]  [fml]   ← middle row = base WACC
       9.5%    [fml]  [fml]  [fml]  [fml]  [fml]
      10.0%    [fml]  [fml]  [fml]  [fml]  [fml]
                              ↑
                       middle col = base terminal g
```

**★ = the center cell.** Output MUST equal model's actual implied share price. Apply
medium-blue fill (`#BDD7EE`) + bold font.

**Axis values rule**: `axis = [base - 2*step, base - step, base, base + step, base + 2*step]`
— symmetric around base, odd count guarantees center.

**Python loop for population**:

```python
# Pseudocode
for row_idx, wacc_value in enumerate(wacc_range):
    for col_idx, term_growth_value in enumerate(term_growth_range):
        cell = ws.cell(row=start_row + row_idx, column=start_col + col_idx)
        # Build formula that recalculates full DCF using these axis values
        cell.value = (
            f"=(<SUM of PV FCFs using {wacc_value} as discount rate>"
            f"+<Terminal Value using {term_growth_value} as g and {wacc_value} as WACC>"
            f"-<Net Debt>)/<Shares>"
        )
```

**Total formulas to write across 3 tables**: 75. This is required, not optional.

---

## Excel Model Structure

### Sheet Architecture

Create **two sheets**:

1. **DCF** — Main valuation model with sensitivity analysis at the BOTTOM
2. **WACC** — Cost of capital calculation

**CRITICAL**: Sensitivity tables go at the BOTTOM of the DCF sheet, NOT on a separate
sheet. This keeps all valuation outputs together for easy review.

### Color Scheme (Two Layers)

**Layer 1 — Font colors** (mandatory, from xlsx skill):

- **Blue text** (RGB 0,0,255): ALL hardcoded inputs (stock price, shares, historicals, assumptions)
- **Black text** (RGB 0,0,0): ALL formulas and calculations
- **Green text** (RGB 0,128,0): Links to other sheets (WACC sheet references)

**Layer 2 — Fill colors** (professional blue/grey palette):

| Element | Fill | Font |
|---------|------|------|
| Section headers | Dark blue `#1F4E79` | White bold |
| Sub-headers / column headers | Light blue `#D9E1F2` | Black bold |
| Input cells | Light grey `#F2F2F2` (or white) | Blue |
| Calculated cells | White | Black |
| Output rows (per-share value, EV) | Medium blue `#BDD7EE` | Black bold |

**Rule**: 3 blues + 1 grey + white. Resist the urge to add more colors. User-provided
templates ALWAYS override these defaults.

### Border Standards

- **Thick** (1.5pt) around major sections: KEY INPUTS, ASSUMPTIONS, CASH FLOW, TERMINAL VALUE, VALUATION SUMMARY, each SENSITIVITY table
- **Medium** (1pt) between sub-sections within a major section
- **Thin** (0.5pt) around data tables (scenario blocks, historical vs projected)
- **No borders**: individual cells within tables (keep clean)

### Number Formats

- **Years**: text strings ("2024" not "2,024")
- **Percentages**: `0.0%` (one decimal)
- **Currency**: `$#,##0` for millions; `$#,##0.00` for per-share — ALWAYS specify units in headers ("Revenue ($mm)")
- **Zeros as dash**: `$#,##0;($#,##0);-`
- **Negatives in parentheses**: `(#,##0)` not minus sign

---

## DCF Sheet Layout (Reference Skeleton)

```
Section 1: Header (rows 1-5)
  Row 1: [Company Name] DCF Model
  Row 2: Ticker | Date | FYE
  Row 4: Case Selector (1=Bear, 2=Base, 3=Bull)
  Row 5: Case Name Display formula

Section 2: Market Data (rows 7-12)
  Current Stock Price, Shares Outstanding, Market Cap, Net Debt

Section 3: Scenario Assumption Blocks (rows 14-25)
  BEAR CASE block (header, year columns FY1-FY5, 8 assumption rows)
  BASE CASE block (header, year columns, 8 assumption rows)
  BULL CASE block (header, year columns, 8 assumption rows)
  Consolidation column (INDEX formulas pulling from selected block)

Section 4: Income Statement (rows 27-50)
  Historical (4 years actual)
  Projected (5 years using consolidation column)
  Revenue, %growth, GP, GM%, S&M, R&D, G&A, OpEx, EBIT, EBIT%, Tax, NOPAT

Section 5: Free Cash Flow Build (rows 52-65)
  NOPAT, +D&A, -CapEx, -ΔNWC = Unlevered FCF

Section 6: Discounting & Terminal Value (rows 67-80)
  Period, Discount Factor, PV of FCF, Terminal FCF, Terminal Value, PV Terminal

Section 7: Valuation Summary (rows 82-95)
  Sum PV FCFs, PV Terminal, EV, -Net Debt, Equity Value, Shares, Implied Price, Current Price, Upside

Section 8: Sensitivity Tables (rows 97+)
  Table 1: WACC × Terminal Growth (rows 97-110)
  Table 2: Revenue Growth × EBIT Margin (rows 112-125)
  Table 3: Beta × Risk-Free Rate (rows 127-140)
```

**Adjust row numbers as needed for your specific company. Lock the layout BEFORE writing formulas.**

---

## WACC Sheet Layout

```
COST OF EQUITY CALCULATION
  Risk-Free Rate (10Y Treasury)    [Yellow input]
  Beta (5Y monthly)                [Yellow input]
  Equity Risk Premium              [Yellow input]
  Cost of Equity = Rf + Beta × ERP [Calculated]

COST OF DEBT CALCULATION
  Credit Rating                    [Yellow input]
  Pre-Tax Cost of Debt             [Yellow input]
  Tax Rate                         [Link to DCF sheet]
  After-Tax Cost of Debt           [Calculated]

CAPITAL STRUCTURE
  Stock Price                      [Link to DCF]
  Shares Outstanding               [Link to DCF]
  Market Cap                       [Calculated]
  Total Debt                       [Yellow input]
  Cash & Equivalents               [Yellow input]
  Net Debt                         [Calculated]
  Enterprise Value                 [Calculated]

WACC CALCULATION                   Weight   Cost   Contribution
  Equity                           XX.X%    X.X%   X.XX%
  Debt                             XX.X%    X.X%   X.XX%

WEIGHTED AVERAGE COST OF CAPITAL                   X.XX%   [Green output]
```

---

## Common Mistakes to Avoid

### Top 5 Errors

1. **Formula row references off** → Lock ALL row positions BEFORE writing formulas
2. **Missing cell comments** → Add comments AS cells are created, not at end
3. **Simplified sensitivity tables** → Populate all 75 cells with full DCF recalc, not approximations
4. **Scenario block references wrong** → Use consolidation column with INDEX, not scattered IF formulas
5. **No borders** → Add professional section borders for client-ready appearance

### Scenario Selection Anti-Pattern

```python
# WRONG — scattered IF formulas in every projection cell
ws["E29"] = "=D29*(1+IF($B$6=1,$B$10,IF($B$6=2,$C$10,$D$10)))"

# CORRECT — consolidation column with INDEX, then clean reference
ws["E10"] = "=INDEX(B10:D10, 1, $B$6)"  # consolidation column
ws["E29"] = "=D29*(1+$E$10)"             # clean projection
```

### WACC Calculation Errors

- Mixing book and market values in capital structure
- Using levered beta without adjusting for target capital structure
- Wrong tax rate application to cost of debt
- Incorrect risk-free rate (must use **current** 10Y Treasury, not historical avg)
- Failure to adjust for net cash position (negative net debt)

### Growth Assumption Flaws

- Terminal growth > WACC (creates infinite value — automatic fail)
- Projection growth rates inconsistent with historical performance without justification
- Ignoring industry growth constraints (peer median in `data/comps/`)
- Revenue growth not aligned with unit economics
- Margin expansion without operational justification ("magic margin growth")

### Terminal Value Mistakes

- Using wrong growth method without cross-check (always check perpetuity vs exit multiple)
- Terminal value > 75% of enterprise value (suggests model is over-reliant on terminal)
- Inconsistent terminal margins with steady state assumptions
- Wrong discount period for terminal value (must match mid-year convention if using)

### Cash Flow Projection Errors

- Operating expenses based on gross profit instead of revenue
- D&A/CapEx percentages misaligned with business model
- Working capital changes calculated against revenue level instead of revenue change
- Tax rate inconsistency between years
- NOPAT calculation errors (using EBT instead of EBIT × (1-tax))

---

## Final Output Checklist

Before delivering DCF model:

**Required**:

- [ ] Run `python recalc.py deals/{company}/dcf-model.xlsx 30` until status="success"
- [ ] Two sheets: DCF (with sensitivity at bottom), WACC
- [ ] Font colors: Blue=inputs, Black=formulas, Green=sheet links
- [ ] Cell comments on ALL hardcoded inputs
- [ ] Sensitivity tables fully populated with 75 formulas total (3 tables × 25 cells)
- [ ] Professional borders around major sections

**Validation**:

- [ ] OpEx based on revenue (not gross profit)
- [ ] Terminal value 50-70% of EV
- [ ] Terminal growth < WACC
- [ ] Center cell of each sensitivity table = base case implied price
- [ ] Net debt sign correct (positive subtracts from EV)
- [ ] Diluted shares used (not basic)

**State updates**:

- [ ] If portfolio company: update `data/state/portfolio.json`:
  - `current_valuation_usd` = implied equity value
  - `valuation_source` = `"DCF"`
  - `valuation_confidence` = `"High"` (Series C+ with revenue), `"Medium"` (Series B), `"Low"` (earlier)
  - `last_valuation_date` = today
- [ ] If pipeline deal: update `data/state/deals.json`:
  - `entry_valuation_usd` = base case implied EV
  - Append note in `deals/{company}/notes.md` with DCF base/bull/bear summary

**Wiki update** (optional but encouraged):

- [ ] Append valuation update to `wiki/companies/{company}.md` under `## Updates`

---

## Workflow Integration

### Triggered from `/dcf` command

User invokes `/dcf {company}`. The command:
1. Loads company context (state files, deal folder, comps)
2. Calls financial-analyst agent with this skill loaded
3. Walks through Steps 1-10 with verification gates
4. Saves model to `deals/{company}/dcf-model.xlsx`
5. Updates state JSON and runs recalc.py
6. Reports summary to user

### Triggered from `/ic-memo` Step 2

When `/ic-memo` runs and the company is Series B+ with revenue, the financial-analyst
agent automatically loads this skill and builds a DCF as part of the parallel research
phase. Output flows into the IC memo's Section VII (Returns Analysis).

### Triggered from `/portfolio-review` Step 3

When `/portfolio-review` runs and a portfolio company's `last_valuation_date` is more
than 12 months old (or `valuation_source` ≠ "DCF" for Series C+ companies), the
financial-analyst agent rebuilds the DCF and updates `portfolio.json`.

---

## Bilingual notes (GPilot-specific)

When the company is China-based or the audience is the Chinese LP base:

- Add a top-row note in the DCF sheet stating the FX rate used (CNY/USD) and the reference date
- For terminal growth, use long-run China GDP growth (not US GDP) — typically 3.5-4.5%
- For risk-free rate, use 10Y CGB yield (Chinese government bond), not US Treasury
- Consider higher equity risk premium for emerging-market exposure (6-8% vs 5-6% US)
- When the report is translated by the `translator` skill, the Chinese version of the
  valuation summary should preserve the implied share price in BOTH currencies

## References

- FSP source: `output/digests/_fsp-cache/fa-dcf-model.md` (1,263 lines, full original)
- Parent skill: `skills/valuation-report/SKILL.md`
- Related skill: `anthropic-skills:xlsx` (for openpyxl patterns and recalc.py)
- Comps data: `data/comps/{sector}.xlsx` (62 sector models)
- Stage-based methodology: `skills/valuation-report/SKILL.md` § "Valuation Methodologies by Stage"
