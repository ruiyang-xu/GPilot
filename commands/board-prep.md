---
name: board-prep
description: Prepare board meeting materials for a portfolio company
---

You are preparing board meeting materials for a portfolio company.

## Input
Ask for:
1. **Company name** (required — must be in portfolio-dashboard.xlsx)
2. **Board date** (optional — check portfolio-dashboard.xlsx "Next Board Date" if not provided)

## Process

### Step 1: Gather Context
- Read `data/state/portfolio.json` (or `data/fund/portfolio-dashboard.xlsx` for human review) entry for the company
- Read `deals/{company-name}/notes.md` for investment context
- Read any existing board materials in `deals/{company-name}/`
- Check for the latest financial model at `deals/{company-name}/model.xlsx`

### Step 2: Research (Parallel)

**market-researcher agent**:
- Latest competitive moves and market developments (last 30 days)
- Relevant industry news and trends
- Any analyst coverage or reports

**financial-analyst agent**:
- Update financial model with any new data
- Compare actuals vs. projections from last board meeting
- Identify variance drivers
- Updated runway calculation

### Step 3: Generate Board Materials

Using `templates/board-deck.md`, create:

1. **Agenda** — time-boxed items
2. **KPI Dashboard** — key metrics with MoM/QoQ trends and plan vs. actual
3. **Financial Overview** — P&L summary, cash position, burn rate, runway
4. **Product Update** — recent releases, roadmap progress, upcoming milestones
5. **GTM Update** — pipeline, revenue, customer wins/losses
6. **Team Update** — hires, departures, open roles
7. **Strategic Discussion Topics** — 2-3 items where board input adds value
8. **Asks from the Board** — specific help needed (intros, advice, decisions)

### Step 4: Prepare GP Notes
Create a private GP notes file (not shared with the company):
- Key questions to ask
- Concerns to raise
- Follow-up items from last meeting
- Valuation assessment update

### Step 5: Output
- Save board deck outline to `deals/{company-name}/board-{date}/deck-outline.md`
- Save GP notes to `deals/{company-name}/board-{date}/gp-notes.md`
- Draft pre-read email to board members (Gmail DRAFT only)
- Create calendar event reminder if not already set

## Safety
- Board materials are CONFIDENTIAL to that company's board
- Pre-read emails are DRAFTS only — never auto-send
- GP notes stay in the deal folder — never shared externally
