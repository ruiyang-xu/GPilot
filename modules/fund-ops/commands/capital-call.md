---
name: capital-call
description: Prepare capital call notices with pro-rata calculations per LP
---

You are preparing a capital call for the fund.

## Input
Ask for:
1. **Total amount** to be called (required)
2. **Purpose** (required): New investment (company name), management fees, follow-on investment, fund expenses, or combination
3. **Due date** (optional, default: 10 business days from today)

## Process

### Step 1: Load Fund Data
- Read `data/lp-database.xlsx` — LP commitments, called %, side letter flags
- Read `data/fund-model.xlsx` Capital Calls sheet — cumulative called to date
- Read `data/fund-model.xlsx` Fund Terms — total commitments, fee rates

### Step 2: Calculate Pro-Rata Amounts
For each LP:
- Pro-rata share = LP commitment / total fund commitments
- Call amount = total call × pro-rata share
- Verify: cumulative called + this call ≤ LP commitment
- Account for any side letter adjustments (fee offsets, co-invest credits)

Generate a summary table:
| LP Name | Commitment | Pro-Rata % | Call Amount | Cumulative Called | Remaining |
|---------|-----------|-----------|-------------|-------------------|-----------|

### Step 3: Validate
- Total of all LP call amounts = total call amount (must balance exactly)
- No LP exceeds their remaining unfunded commitment
- Purpose is clearly documented

### Step 4: Generate Notices
For each LP, generate a capital call notice using `templates/capital-call-notice.md`:
- Fund name, call date, call number
- Purpose description
- LP-specific amount
- Wire instructions: [PLACEHOLDER — the GP to fill in]
- Due date
- Running totals (cumulative called, remaining commitment)

Output individual notices as PDF to `output/notices/capital-call-{date}-{lp-name}.pdf`

### Step 5: Draft Emails
For each LP, draft an individual email (Gmail DRAFT only):
- Subject: "[Fund Name] — Capital Call Notice #{X}"
- Body: Brief description of purpose, amount, due date
- Attachment: their specific notice PDF
- Tone: professional, clear, concise

### Step 6: Update Records
- Add row to `data/fund-model.xlsx` Capital Calls sheet
- Update `data/lp-database.xlsx` Called % for each LP
- Update `data/fee-schedule.xlsx` if call is for fees

### Step 7: Summary
Present to the GP:
- Total called: ${amount}
- Purpose: {description}
- Due date: {date}
- LPs notified: {count}
- Drafts created: {count}
- Post-call fund utilization: {cumulative called / total commitments}%

## Safety
- All emails are DRAFTS only. NEVER auto-send capital calls.
- Wire instructions are PLACEHOLDER — the GP must fill in actual banking details.
- Double-check all math — capital call errors damage LP trust.
- Capital calls are legal obligations — ensure accuracy before the GP sends.
