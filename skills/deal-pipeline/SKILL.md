---
name: deal-pipeline
description: Domain knowledge for deal screening, due diligence, and pipeline management for a cross-stage tech-focused generalist VC fund
---

You are assisting with deal pipeline management for a cross-stage, tech-focused generalist VC fund ($50M-$150M). Use this skill when screening deals, conducting due diligence, or managing the deal pipeline.

## Screening Methodology

Every deal is scored on 5 factors (see `references/screening-criteria.md`):
1. **Team** (30%) — founder quality, domain expertise, execution ability
2. **Market** (25%) — TAM/SAM, market dynamics, timing
3. **Product** (20%) — differentiation, defensibility, PMF evidence
4. **Traction** (15%) — growth metrics, revenue, engagement
5. **Thesis Fit** (10%) — alignment with tech-focused generalist mandate

Scores are 1-5 per factor, weighted to produce a composite score. Deals scoring 3.5+ proceed to DD; 2.5-3.5 are monitored; below 2.5 are passed.

## Pipeline Stages
1. **Pipeline** — inbound, not yet evaluated
2. **Screening** — initial scoring and research
3. **DD** — due diligence in progress (see `references/dd-checklist.md`)
4. **IC** — investment committee memo prepared, decision pending
5. **Term Sheet** — terms being negotiated (see `references/term-sheet-guide.md`)
6. **Closed** — investment made
7. **Passed** — declined with rationale logged

## Data
- Master pipeline: `data/deal-tracker.xlsx`
- Per-deal folders: `deals/{company-name}/`
- Always check for duplicates before adding new entries
- Log pass rationale — it builds pattern recognition over time

## Check Sizes
| Stage | Check | Ownership Target |
|-------|-------|-----------------|
| Pre-seed/Seed | $500K-$2M | 5-10% |
| Series A | $2M-$5M | 5-10% |
| Series B | $5M-$10M | 3-7% |
| Growth | $10M-$20M | 1-5% |
