---
name: ic-memo
description: Generate a full investment committee memo for a deal in DD
---

You are generating an investment memo. This is the organization's core decision document.

## Input
Ask for the **company name**. It must already exist in `data/state/deals.json` (or `data/fund/deal-tracker.xlsx` for human review) (typically at Screening or DD status).

## Process

### Step 1: Gather Existing Context
- Read `deals/{company-name}/notes.md` for screening notes
- Read `deals/{company-name}/model.xlsx` if it exists
- Read the deal-tracker entry for current status and metadata
- Check `deals/{company-name}/materials/` for any pitch decks or data room docs

### Step 2: Deep Research (3 Agents in Parallel)

Launch all three agents simultaneously:

**market-researcher agent**:
- Deep market map with segmentation
- Detailed competitive landscape with feature comparison
- TAM/SAM/SOM with multiple methodologies
- Industry expert perspectives and analyst reports
- Regulatory landscape and risks

**financial-analyst agent**:
- Build or refine financial model (3-5 year projections)
- Unit economics deep dive
- Scenario analysis (bull/base/bear) with key assumptions
- Return sensitivity: MOIC and IRR at various exit multiples and timelines
- Comparable valuations (public comps, private comps, precedent transactions)
- Cap table analysis and dilution modeling

**legal-reviewer agent** (if term sheet available):
- Term sheet review against market standards
- Flag non-standard or concerning provisions
- Identify negotiation leverage points
- Recommend terms to push back on

### Step 3: Synthesize into Investment Memo

Launch the **memo-writer agent** with all research outputs. The memo follows `templates/investment-memo.md`:

1. **Executive Summary** (1 page) — company, ask, our recommendation, key thesis points
2. **Company Overview** — what, who, where, when, how
3. **Market Analysis** — TAM, competitive landscape, trends, "why now"
4. **Product & Technology** — product, differentiation, technical moat, roadmap
5. **Team Assessment** — founders, key hires, gaps, references
6. **Financial Analysis** — historicals, projections, unit economics, scenarios
7. **Valuation & Deal Terms** — proposed terms, comp analysis, return scenarios
8. **Key Risks & Mitigants** — top 5 risks, each with mitigation strategy
9. **Portfolio Fit** — thesis alignment, synergies, co-investment potential
10. **Recommendation** — Invest / Pass, with conditions and follow-up items

### Step 4: Output
- Generate memo as docx → `output/memos/{company}-memo.docx`
- Update `data/state/deals.json` (or `data/fund/deal-tracker.xlsx` for human review) status to "IC"
- Update `deals/{company-name}/notes.md` with memo generation date

### Step 5: Summary
Present a 1-page executive summary to the GP with:
- Recommendation (Invest / Pass)
- Key conviction points (top 3)
- Key concerns (top 3)
- Proposed terms and check size
- Return analysis (base case MOIC/IRR)
