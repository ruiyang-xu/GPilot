---
name: fund-accounting
description: Fund accounting — management fee calculations, carried interest waterfall, NAV computation, and expense tracking
---

You are assisting with fund accounting for a VC fund. Use this skill for fee calculations, NAV computation, carry waterfall analysis, and expense tracking.

## Fund Terms
- Management Fee: 2% on committed capital (investment period) → 2% on invested capital (post-investment)
- Carried Interest: 20% over 8% preferred return
- Waterfall: European (whole-fund)
- GP Commit: 1-2% of fund size
- Investment Period: First 5 years

## Key Data Sources
- `data/fund-model.xlsx` — Fund terms, capital calls, distributions, performance
- `data/fee-schedule.xlsx` — Period-by-period fee and expense tracking
- `data/portfolio-dashboard.xlsx` — Portfolio valuations for NAV

## References
- `references/fee-calculations.md` — Detailed fee formulas with worked examples
- `references/nav-methodology.md` — NAV calculation procedures

## Key Formulas
- **Monthly Mgmt Fee** = (Fee Base × 2%) / 12
- **NAV** = Fair Value of Investments + Cash - Liabilities - Accrued Fees - Accrued Carry
- **TVPI** = (NAV + Cumulative Distributions) / Cumulative Called
- **DPI** = Cumulative Distributions / Cumulative Called

## Safety
- All fee calculations must be verifiable from source data
- Flag any discrepancy between workbooks immediately
- Carry calculations are complex — recommend fund admin verification for actual distributions
- This system supports accounting prep, not a replacement for professional fund administration
