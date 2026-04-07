# Fair Value Methodology — ASC 820 Compliant

## Fair Value Hierarchy

### Level 1: Quoted Prices in Active Markets
- Public company stock prices
- Used for: publicly traded portfolio companies
- Most reliable; rarely applicable to VC portfolios

### Level 2: Observable Inputs
- Recent transaction pricing (financing rounds within 12 months)
- Secondary market transactions
- Comparable public company multiples
- Used for: companies with recent arms-length transactions

### Level 3: Unobservable Inputs
- DCF models with management projections
- Comparable company multiples applied to private company financials
- Option pricing models for complex capital structures
- Used for: most VC portfolio companies without recent transactions

## Preferred Valuation Approach by Stage

| Stage | Primary Method | Secondary Method | Notes |
|-------|---------------|-----------------|-------|
| Pre-seed/Seed | Last round pricing | Scorecard comparable | Limited financial data |
| Series A | Last round pricing | Revenue multiple | If round <12 months old |
| Series B | Revenue multiple (comps) | Last round + adjustment | Apply public comps with discount |
| Growth | Revenue/EBITDA multiples | DCF | More financial data available |
| Pre-IPO | Public comp multiples | DCF + IPO scenarios | Apply liquidity discount |

## Revenue Multiple Approach

1. Select peer group of 5-10 comparable public companies
2. Calculate median EV/Revenue or EV/ARR multiple
3. Apply **illiquidity discount** of 20-30% (private company)
4. Apply to target company's TTM or NTM revenue
5. Adjust for growth rate differential (faster growth = premium)

**Example**: Target has $5M ARR growing 100%. Public SaaS comps trade at 15x ARR median. Apply 25% illiquidity discount → 11.25x. But target grows 2x faster than comps → apply 1.3x premium → 14.6x. Implied value: $73M.

## Markup / Markdown Triggers

### Markup Triggers
- New financing round at higher valuation (strongest signal)
- Revenue exceeding plan by >30%
- Major customer/partnership win
- Regulatory approval
- Material improvement in unit economics

### Markdown Triggers
- Down round or flat round (must reflect)
- Revenue significantly below plan (>30% miss)
- Loss of major customer (>10% of revenue)
- Key executive departure
- Regulatory setback
- Runway <6 months without clear funding path
- Going concern risk

### When NOT to Change Valuation
- Macro market movements alone (unless affecting sector multiples significantly)
- Minor positive/negative press
- Small customer wins/losses
- Operational noise within normal variance

## Documentation Requirements

For each valuation, document:
1. **Method used** and rationale for selection
2. **Key inputs** (comparable set, multiples, discount rates)
3. **Adjustments** applied (illiquidity discount, growth premium)
4. **Conclusion**: fair value and confidence level (High/Medium/Low)
5. **Date of assessment**
6. **Comparison to prior quarter**: change amount and driver

This documentation supports annual audit and LP reporting.

## Quarterly Valuation Process
1. Review each position against markup/markdown triggers
2. Update comparable company multiples (public market data)
3. Incorporate any new financials from portfolio companies
4. Apply methodology and document
5. Update `data/portfolio-dashboard.xlsx` Current Valuation and MOIC
6. Flag material changes (>20%) for GP review before LP reporting
