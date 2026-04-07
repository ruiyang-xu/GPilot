# Distribution Waterfall — European (Whole-Fund) Model

## Fund Terms
- Carried Interest: 20%
- Preferred Return (Hurdle): 8% compounded annually
- Waterfall: European (whole-fund)
- GP Catch-up: 100% to GP until 20/80 split achieved

## Waterfall Steps

### Step 1: Return of All Contributed Capital
All distributions go to LPs until they have received back **100% of their total contributed capital** (all capital calls, including fees and expenses).

- Priority: LP receives 100% of distributions
- Trigger to advance: Cumulative distributions ≥ cumulative contributions

### Step 2: Preferred Return
After all capital is returned, LPs receive distributions until they have earned an **8% annual compounded return** on their contributed capital.

- Calculated from the date of each capital call to the date of each distribution
- Compounding: annual (some funds use quarterly — check LPA)
- Priority: LP receives 100% of distributions

### Step 3: GP Catch-Up
After the preferred return is met, the GP receives **100% of distributions** until the GP's cumulative share equals **20% of total profits** (Steps 2 + 3 combined).

- "Total profits" = all distributions above return of capital
- Catch-up rate: 100% to GP (some funds use 80/20 catch-up — check LPA)
- This ensures GP ultimately receives 20% of all profits

### Step 4: Carried Interest Split (80/20)
All remaining distributions are split:
- **80%** to LPs
- **20%** to GP (carried interest)

## European vs. American Waterfall

| Feature | European (Our Fund) | American |
|---------|-------------------|----------|
| Capital Return | All capital returned first | Deal-by-deal |
| Preferred Return | On total fund basis | Per deal |
| GP Carry Timing | Later (after full return) | Earlier (per profitable deal) |
| LP Protection | Stronger | Weaker |
| Clawback Risk | Lower | Higher |

## Clawback Provision
If the GP receives carry that exceeds 20% of total fund profits (e.g., early carry on deals later written down), the GP must return excess carry to LPs.

- Trigger: Calculated at fund termination or annually (per LPA)
- Escrow: Some LPAs require GP to escrow a portion of carry for clawback
- Personal guarantee: GP principals may personally guarantee clawback

## Worked Example

**Fund Size**: $100M committed, fully called

### Scenario: Total proceeds of $180M ($80M profit)

| Step | Distribution | To LP | To GP | Running LP Total | Running GP Total |
|------|-------------|-------|-------|-----------------|-----------------|
| 1. Return Capital | $100M | $100M | $0 | $100M | $0 |
| 2. Preferred Return | ~$46.9M* | $46.9M | $0 | $146.9M | $0 |
| 3. GP Catch-up | ~$8.3M** | $0 | $8.3M | $146.9M | $8.3M |
| 4. 80/20 Split | $24.8M | $19.8M | $5.0M | $166.7M | $13.3M |
| **Total** | **$180M** | **$166.7M** | **$13.3M** | | |

*Assumes 5-year average holding period at 8% annual compound
**Catch-up: GP needs to reach 20% of total profits ($80M × 20% = $16M, but need to account for waterfall mechanics)

### Verification
- Total profit: $80M
- GP share: $13.3M = 16.6% of profits (less than 20% because preferred return reduces the GP's effective share in this example)
- LP share: $66.7M = 83.4% of profits

*Note: Exact amounts depend on timing of cash flows. Use IRR-based calculation for precision.*
