# NAV Calculation Methodology

## NAV Formula

```
NAV = Fair Value of Investments
    + Cash and Cash Equivalents
    + Receivables (if any)
    - Payables and Accrued Expenses
    - Accrued Management Fees
    - Accrued Carried Interest (if in carry position)
```

## Components

### Fair Value of Investments
- Sum of all portfolio company fair values
- Valued per ASC 820 hierarchy (see `skills/portfolio-ops/references/valuation-methods.md`)
- Updated quarterly at minimum

### Cash and Cash Equivalents
- Fund bank account balances
- Money market or short-term investment balances
- Capital called but not yet deployed

### Receivables
- Interest receivable on bridge loans (if applicable)
- Escrow amounts from exits pending release

### Payables and Accrued Expenses
- Outstanding invoices (legal, audit, admin)
- Accrued but unpaid fund expenses

### Accrued Management Fees
- Fees earned but not yet charged to LPs via capital call

### Accrued Carried Interest
- Calculate using the full waterfall model
- Only accrue if fund is in "carry position" (i.e., all capital returned and preferred return met)
- European waterfall: carry typically doesn't accrue until late in fund life
- Reserve for clawback if applicable

## NAV Per Unit

```
NAV Per Unit = NAV / Total Units Outstanding
```

Where units = each LP's commitment as a proportion of total fund size.

**Per LP NAV**:
```
LP NAV = NAV Per Unit × LP's Units
       = NAV × (LP Commitment / Total Commitments)
```

## Calculation Frequency
- **Quarterly**: Required for LP reporting
- **Monthly**: Recommended for internal tracking
- **Ad hoc**: For capital calls, distributions, or significant events

## Cash Management

### Reserve Policy
Maintain adequate reserves for:
- Management fees (next 12 months)
- Anticipated fund expenses (next 12 months)
- Follow-on investment reserves (per fund strategy)
- Distribution of realized gains (if in carry position)

### Typical Cash Allocation
- Operating reserve: 2-3% of committed capital
- Follow-on reserves: per deal-by-deal reserve strategy
- Remaining: available for new investments

## Quarterly NAV Process
1. Collect latest portfolio company financials and data
2. Update fair values (see valuation methodology)
3. Reconcile fund bank statements
4. Calculate accrued fees and expenses
5. Calculate accrued carry (if applicable)
6. Compute NAV and NAV per unit
7. Prepare capital account statements per LP
8. Document any material changes from prior quarter
9. Review with fund administrator (if applicable)
10. Include in quarterly LP report
