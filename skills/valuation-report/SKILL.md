---
name: valuation-report
description: Generate quarterly valuation review reports for portfolio companies in the standard fund format (EY-auditable). Supports Fund Alpha, Fund Beta, and Fund Gamma fund templates.
---

# Valuation Report Skill

Generate quarterly portfolio company valuation reports in the standard format used across Fund Alpha, Fund Beta, and Fund Gamma.

## When to Use

Trigger this skill when:
- Preparing quarterly LP deliverables
- Running `/portfolio-review` or `/lp-quarterly`
- User asks to "write a valuation report" or "update the review report" for a portfolio company
- Updating valuations for audit (EY)

## Input Requirements

1. **Company name** (required)
2. **Fund** (required): "Fund Alpha" | "Fund Beta" | "Fund Gamma"
3. **Valuation date** (required): Quarter-end date (e.g., "31 December 2025")
4. **Business update** (optional): Recent news, KPIs, or developments
5. **Financial data** (optional): Income statement, balance sheet, cash flow — if available

## Report Structure (Standard Template)

Every valuation report follows this exact structure, derived from the fund's EY-auditable format:

### Cover Page
- Fund legal name (full)
- Quarter and year update label (e.g., "2025 December 31 Update")
- Project name (company name)
- Date
- Preparer: [author name]
- Reviewer: [reviewer name]
- Confidentiality disclaimer

### Section 1: TRANSACTION SUMMARY
- Narrative paragraph: investment amount, date, instrument type, conversion details if applicable
- **Summarized Deal Terms table**:

| Field | Description |
|-------|-------------|
| Investment Target | Legal entity name |
| Sector | Primary sector classification |
| Investment Type | SAFE / Convertible Note / Series X Preferred Shares / via SPV |
| Investment Size | Amount in USD |
| Investment Date | Date of investment |
| Price per Share | Per-share price (if equity) |
| No. of Shares | Shares held, with disposal history if any |
| Valuation Cap | For SAFEs: valuation cap amount |
| Qualified IPO / Redemption | IPO conditions, redemption terms, timelines |
| Other Rights or Special Terms | Liquidation preference, anti-dilution, board rights |
| Exit Strategy | Expected exit path |

### Section 2: COMPANY OVERVIEW AND BUSINESS UPDATE

#### 2.1 Introduction
- Founding story, mission, core product
- Key investors and shareholder base
- 2-3 paragraphs

#### 2.2 Business Overview
- Product/service description
- Market position and competitive advantages
- Key metrics (DAU, MAU, revenue run rate)
- 2-4 paragraphs organized by theme

#### 2.3 Business Update
- Latest quarter developments
- Material events: funding rounds, partnerships, regulatory changes, leadership changes
- Each update as a subsection with headline + 2-3 paragraph detail
- Most recent events first

### Section 3: FINANCIAL PERFORMANCE

#### 3.1 Financials
- Summary narrative of latest financial performance
- Revenue growth, margins, cash position commentary

#### 3.2 Income Statement
- Table format: multi-period comparison (Annual + Half-year if available)
- USD millions, unaudited
- Line items: Revenue, COGS, Gross Profit, S&M, G&A, R&D, Operating P&L, Net Income

#### 3.3 Balance Sheet
- Table format: multi-period
- Standard format: Non-current assets, Current assets, Total assets, Equity, Non-current liabilities, Current liabilities

#### 3.4 Statement of Cash Flow
- Table format: multi-period
- Operating, Investing, Financing cash flows

**For early-stage (Seed/Series A)**: Use simplified KPI table instead:

| Metric | Value |
|--------|-------|
| Monthly Revenue | $ X USD |
| Cash Balance | $ X USD |
| Monthly Operational Costs | $ X USD |
| Runway | X months |

### Section 4: VALUE ASSESSMENT

#### 4.1 Valuation based on recent transactions
- Secondary market offers, share repurchases, latest primary rounds
- Specific price points and dates

#### 4.2 Comparable valuation
- Peer group selection with rationale
- **Comps table**: Enterprise Value, Revenue (multi-year), EBITDA (multi-year), CAGR
- **Trading multiples table**: EV/Revenue, EV/EBITDA by year
- Average multiples and implied valuation
- Source and date for market data (Capital IQ)

#### 4.3 Valuation summary
- Methodology discussion: which approach weighted and why
- Final valuation conclusion with supporting rationale
- **Valuation summary table**:

| Field | Value |
|-------|-------|
| Entry equity value (USD bn/mn) | X |
| Year Start | YYYY/M/D |
| Valuation Date | YYYY/M/D |
| Valuation (USD bn/mn) | X |
| Implied price per share (USD) | X |
| Number of shares owned | X |
| Investment Cost (USD mn) | X |
| Appraised Investment Value (USD mn) | X |
| Appraised Investment Value and Proceeds from disposal (USD mn) | X |
| Return | X% |

## Data Sources

### Internal
- Previous quarter's report: `raw/lp-relations/Valuation Reports/`
- Portfolio state: `data/state/portfolio.json`
- Financial models: `deals/{company}/` or `data/fund/`
- Comp models: `data/comps/` (62 sector models)

### External
- **Daloopa MCP**: For public company comps (revenue, EBITDA, enterprise value)
- **Perplexity MCP**: For latest news, funding rounds, market developments
- **Capital IQ data**: Referenced in comps tables (provide date of data pull)

## Generation Workflow

### Step 1: Load Previous Report
Find the most recent valuation report for this company in `raw/lp-relations/Valuation Reports/`. Read it using the `docx` skill to understand the existing template, deal terms, and historical context.

### Step 2: Gather Updates
- Check wiki for company article: `wiki/companies/{company}.md`
- Search web for latest news (Perplexity)
- Check for any updated financials in `deals/{company}/`
- If public comps needed, use Daloopa for latest multiples

### Step 3: Update Sections
- **Section 1**: Usually unchanged unless new share transactions occurred
- **Section 2.3**: Add new business update subsections for the quarter
- **Section 3**: Update financial tables with latest available data
- **Section 4**: Recalculate valuation using latest comps and transaction data

### Step 4: Generate Document
Use the `docx` skill to create the .docx file. Match the formatting of existing reports:
- Font: Calibri or Times New Roman (match existing)
- Tables: bordered, with header row shading
- Section headers: numbered (1, 2, 2.1, 2.2, etc.)
- Page breaks between major sections

### Step 5: Save and Update State
- Save to: `raw/lp-relations/Valuation Reports/{YYYY}Q{Q}/{Fund}_{Company}_Review Report of {YYYY}Q{Q}.docx`
- Update `data/state/portfolio.json` with new valuation data

## Fund-Specific Naming Conventions

| Fund | Filename Prefix | Example |
|------|----------------|---------|
| Fund Alpha | `AI_` | `ALPHA_ExampleCo_Review Report of 2024Q4.docx` |
| Fund Beta | `ICT_` | `BETA_ExampleCo_Review Report of 2024Q4.docx` |
| Fund Gamma | `FUND_` or `Fund Gamma_` | `GAMMA_ExampleCo_2025Q4_v1.docx` |
| No fund prefix (legacy) | Company name only | `ExampleCo_Review Report of 24Q4.docx` |

## Valuation Methodologies by Stage

| Stage | Primary Method | Secondary Method |
|-------|---------------|-----------------|
| **Pre-seed / Seed** | Valuation cap (SAFE) | Comparable early-stage rounds |
| **Series A-B** | Recent round pricing | DCF (if revenue), comparable transactions |
| **Series C+** | Comparable public multiples | Recent secondary transactions, DCF |
| **Pre-IPO** | Secondary market pricing | Share repurchase price, comparable public multiples |
| **Public** | Market price | DCF, Sum-of-parts |

## Safety Rules

1. **Valuation changes require methodology flag**: Always state the methodology and confidence level
2. **Numbers must be traceable**: Every financial figure must reference its source (financial statements, Cap IQ, management data)
3. **Confidentiality**: Reports are LP-private — never expose outside the fund context
4. **No auto-distribution**: Generated reports require the GP review before sending to LPs
5. **Audit trail**: Note any estimation or interpolation explicitly

## Example Usage

```
User: Generate a Q4 2025 valuation report for ExampleCo under Fund Beta

Skill actions:
1. Read previous report: raw/lp-relations/Valuation Reports/2025Q3/BETA_ExampleCo_Review Report of 2025Q3.docx
2. Check wiki: wiki/companies/exampleco.md (if exists)
3. Search Perplexity for latest ExampleCo news
4. Update Section 2.3 with Q4 developments
5. Update Section 3 financials if new data available
6. Recalculate Section 4 valuation
7. Generate docx: raw/lp-relations/Valuation Reports/2025Q4/BETA_ExampleCo_Review Report of 2025Q4.docx
8. Update portfolio.json
```
