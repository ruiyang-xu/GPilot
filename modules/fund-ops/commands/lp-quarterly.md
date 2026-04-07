---
name: lp-quarterly
description: Generate the quarterly LP report with fund performance and portfolio updates
---

You are generating the quarterly LP report. This is the fund's primary communication to investors.

## Input
Ask for the **quarter** (e.g., "Q1 2026"). If not specified, use the most recently completed quarter.

## Process

### Step 1: Gather All Data
Read these workbooks using the xlsx skill:
- `data/fund-model.xlsx` — Fund Terms, Capital Calls, Distributions, Performance sheets
- `data/state/portfolio.json` (or `data/fund/portfolio-dashboard.xlsx` for human review) — all portfolio company data
- `data/fee-schedule.xlsx` — management fees and expenses
- `data/lp-database.xlsx` — LP list for distribution

### Step 2: Financial Analysis (Agent)

Launch **financial-analyst agent**:
- Calculate fund performance for the quarter:
  - Gross and net IRR
  - TVPI, DPI, RVPI
  - Management fees and expenses for the period
- Generate fee waterfall for the quarter
- Capital account statement per LP (pro-rata based on commitments)
- Compare performance to relevant benchmarks (Cambridge Associates, etc.)

### Step 3: Portfolio Updates (Agent)

Launch **portfolio-monitor agent** for each active company:
- Latest KPIs and financial highlights
- Key milestones achieved this quarter
- Outlook and upcoming milestones
- Any valuation changes with methodology notes

### Step 4: Write the Report (Agent)

Launch **memo-writer agent** with all data. Report follows `templates/quarterly-report.md` and ILPA standards (`skills/lp-reporting/references/ilpa-standards.md`):

1. **GP Letter** (1 page)
   - Market commentary relevant to portfolio
   - Portfolio highlights and lowlights (be transparent)
   - New investments and exits this quarter
   - Outlook

2. **Fund Summary Table**
   - Total commitments, called, distributed, NAV, unfunded

3. **Performance Metrics**
   - IRR (gross and net), TVPI, DPI, RVPI
   - Since inception and quarterly

4. **Portfolio Company Updates** (per company)
   - Description, sector, investment date
   - Cost basis, fair value, MOIC
   - Key metrics and milestones
   - Outlook

5. **New Investments** (if any this quarter)

6. **Realizations** (if any this quarter)

7. **Fee & Expense Summary**

8. **Capital Account Statement** (individualized per LP)

### Step 5: Output
- Generate report as PDF → `output/reports/{quarter}-quarterly.pdf`
- Draft individual LP emails with report attached (Gmail DRAFTS only)
- Update `data/lp-database.xlsx` "Last Communication" for each LP
- Update `data/fund-model.xlsx` Performance sheet

## Safety
- All LP emails are DRAFTS only. NEVER auto-send.
- Capital account statements contain confidential LP-specific data — never cross-share.
- All performance numbers must be verifiable from the underlying data.
- ILPA guideline: deliver within 60 days of quarter-end.
