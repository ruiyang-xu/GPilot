# Solo GP VC Fund Setup Plan — Cowork-Integrated Operating System

**Fund Profile**: Cross-stage generalist | $50–150M target | Institutional LPs | Solo GP
**Date**: March 30, 2026
**Status**: Pre-execution plan — awaiting GP approval

---

## Executive Summary

This plan builds a full-stack operating system for a solo GP venture fund, with Claude Cowork embedded across every major workflow: deal sourcing, due diligence, portfolio monitoring, LP reporting, and fund operations. The goal is to give a single GP the operational capacity of a 5-person team by automating repeatable work and keeping Claude as a persistent co-pilot across all pillars.

The plan is organized into **6 phases**, designed to be executed roughly in sequence, though some workstreams can run in parallel.

---

## Phase 1: Fund Formation & Legal Structure

**Timeline**: Weeks 1–8
**Goal**: Establish the legal entities, engage service providers, and finalize fund terms.

### 1.1 Entity Setup

| Entity | Jurisdiction | Purpose |
|--------|-------------|---------|
| **Fund LP** (e.g., [Fund Name] Ventures I, LP) | Delaware | Main investment vehicle |
| **GP Entity** (e.g., [Fund Name] Capital Management, LLC) | Delaware | General partner; earns carry + mgmt fee |
| **Management Company** (optional, e.g., [Fund Name] Advisors, LLC) | GP's home state | Employs GP; receives management fee; signs service agreements |

### 1.2 Key Legal Documents

1. **Limited Partnership Agreement (LPA)** — Core governing doc. Defines economics (2/20 or negotiated), investment period (typically 3–5 yrs), fund term (10 yrs + extensions), key person clause (critical for solo GP — needs carve-out or insurance), concentration limits, recycling provisions, GP removal/no-fault divorce.
2. **Private Placement Memorandum (PPM)** — Disclosure doc for LPs. Risk factors, strategy description, fee structure, conflicts of interest.
3. **Subscription Agreement + Side Letters** — LP onboarding. Institutional LPs (endowments, FoFs) will negotiate side letters for MFN, co-invest rights, reporting cadence, advisory committee seats.
4. **Investment Management Agreement** — If using a separate management company entity.

### 1.3 Service Provider Selection

| Role | Recommended Providers | Cowork Integration |
|------|----------------------|-------------------|
| **Fund Counsel** | Cooley, Gunderson Dettmer, Goodwin, Lowenstein Sandler | Cowork drafts term comparison memos, reviews redlines using `legal:review-contract` skill |
| **Fund Administrator** | Juniper Square, Carta Fund Admin, Ocorian | Cowork reconciles fund admin reports, flags discrepancies |
| **Auditor** | Big 4 or mid-tier (Deloitte, EY, RSM, Armanino) | Cowork prepares audit support packages |
| **Tax Advisor** | Andersen, Eisner Advisory, fund counsel's tax group | Cowork assists with K-1 timeline coordination |
| **Bank / Custody** | SVB (now First Citizens), JPM Private Bank, Mercury (for ops account) | — |

### 1.4 Regulatory & Compliance Filings

| Filing | Trigger | Timeline |
|--------|---------|----------|
| **Form D** (SEC) | First close | Within 15 days of first sale |
| **Blue Sky filings** | State-level Reg D notice | Varies by state; typically within 15 days |
| **Form ADV (ERA)** | Managing private fund | File within 60 days of becoming an ERA |
| **FinCEN AML/KYC program** | All advisers (delayed to Jan 2028) | Build program now, compliance required by 1/1/2028 |
| **13F** (if applicable) | >$100M in 13F securities | Quarterly, within 45 days of quarter-end |

> **Cowork role**: Build a compliance calendar as a scheduled task. Cowork sends reminders via email draft before each filing deadline. Use `schedule` skill to create recurring compliance check-ins.

---

## Phase 2: Deal Sourcing & Pipeline Management

**Timeline**: Weeks 4–12 (overlaps with fund formation)
**Goal**: Build a repeatable, data-driven deal sourcing engine with Cowork as the analytical backbone.

### 2.1 Sourcing Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    DEAL SOURCING ENGINE                  │
├─────────────┬──────────────┬──────────────┬─────────────┤
│  Inbound    │  Outbound    │  Network     │  Secondary  │
│             │              │              │  Market     │
│ - Website   │ - Thesis     │ - Co-invest  │ - SPV       │
│   form      │   outreach   │   partners   │   allocs    │
│ - Email     │ - Conference │ - Founder    │ - Direct    │
│   intro     │   follow-up  │   referrals  │   secondaries│
│ - Twitter/  │ - Community  │ - Angel      │ - WeChat    │
│   LinkedIn  │   content    │   networks   │   deal flow │
│   DMs       │              │              │             │
└──────┬──────┴──────┬───────┴──────┬───────┴──────┬──────┘
       │             │              │              │
       └─────────────┴──────┬───────┴──────────────┘
                            │
                   ┌────────▼────────┐
                   │  DEAL TRACKER   │
                   │  (Spreadsheet)  │
                   └────────┬────────┘
                            │
              ┌─────────────▼─────────────┐
              │   COWORK ANALYSIS LAYER   │
              │                           │
              │  • SPV DD skill (secondary)│
              │  • Company research        │
              │  • Comparable analysis     │
              │  • IC memo generation      │
              │  • Market sizing           │
              └───────────────────────────┘
```

### 2.2 Deal Tracker (Excel Workbook)

Build a master deal tracker spreadsheet with the following tabs:

| Tab | Contents | Cowork Role |
|-----|----------|-------------|
| **Pipeline** | Company, stage, sector, source, date, status (Pass/Active/IC/Closed), lead contact, next action, notes | Cowork updates status, generates weekly pipeline digest |
| **Active DD** | DD checklist per company, data room status, reference checks, legal review status | Cowork runs DD checklists, flags gaps |
| **IC Log** | Date, company, decision (invest/pass), amount, pre-money, ownership %, rationale | Cowork drafts IC memos from deal notes |
| **Closed Deals** | All executed investments, terms, docs status | Auto-populated from Pipeline tab |
| **Comparables** | Public comps, private round data, multiples | Cowork pulls and refreshes market data |
| **Sources** | Track which channels/people produce the best deals; conversion metrics | Cowork analyzes source quality quarterly |

> **Execution**: Build with `xlsx` skill. Design for Cowork to read/write programmatically in future sessions.

### 2.3 Deal Screening Workflow (Cowork-Powered)

**Step 1 — Initial Screen** (< 5 min per deal)
- GP pastes deal info (email, WeChat message, pitch deck summary) into Cowork
- Cowork extracts: company name, sector, stage, round size, valuation, lead investor, source
- Cowork runs quick web research on company + founders
- Output: 1-paragraph verdict with Pass / Dig Deeper / Fast Track recommendation

**Step 2 — Deep Dive** (Cowork-assisted, 30–60 min)
- Cowork generates a structured DD memo template tailored to the company's sector
- Pulls public data: funding history, team backgrounds, competitor landscape, TAM estimates
- For secondary deals: triggers `spv-secondary-dd` skill for fee analysis, structure assessment, risk flags
- GP fills in proprietary insights (founder meetings, reference calls)

**Step 3 — IC Memo** (Cowork drafts, GP edits)
- Cowork generates a 2–3 page investment memo covering:
  - Company overview & thesis fit
  - Market opportunity & TAM/SAM/SOM
  - Team assessment
  - Product/traction metrics
  - Competitive landscape
  - Deal terms & valuation benchmarking
  - Key risks & mitigants
  - Recommendation
- Output as `.docx` using the `docx` skill for archival

**Step 4 — Decision & Logging**
- GP makes invest/pass decision
- Cowork logs to IC Log tab with full rationale
- If pass: Cowork drafts a courteous pass email for GP review

### 2.4 Secondary Market Deal Flow

Leverage the existing `spv-secondary-dd` skill for:
- Parsing unstructured deal terms from WeChat, email, or screenshots (Chinese + English)
- Calculating all-in implied valuation across fee structures
- Comparing multiple tranches side-by-side
- Flagging red/yellow/green risk signals
- Generating standardized deal summaries for IC review

---

## Phase 3: Investment Execution & Legal

**Timeline**: Ongoing post-first-close
**Goal**: Streamline the investment execution process from term sheet to wire.

### 3.1 Investment Process Checklist

For each investment, Cowork generates and tracks:

```
□ Term sheet negotiated and signed
□ Legal DD completed (cap table, IP assignment, corporate docs)
□ Side letter negotiated (if applicable — pro-rata, info rights, board observer)
□ Subscription docs / SPA executed
□ KYC/AML on target company completed
□ Wire instructions verified (dual-authorization)
□ Capital call notice issued to LPs
□ Funds wired
□ Stock certificate / LP interest confirmation received
□ Deal logged in portfolio tracker
□ LP notification sent (new investment letter)
```

### 3.2 Cowork Integration Points

| Task | Skill/Tool | What Cowork Does |
|------|-----------|-----------------|
| Review term sheets | `legal:review-contract` | Flag non-standard terms, compare to market |
| NDA triage | `legal:triage-nda` | GREEN/YELLOW/RED classification |
| Capital call notices | `docx` skill | Draft capital call notice from template |
| Side letter review | `legal:review-contract` | Compare against fund's standard positions |
| Risk assessment | `legal:legal-risk-assessment` | Severity × likelihood matrix for deal risks |

---

## Phase 4: Portfolio Monitoring & Post-Investment Management

**Timeline**: Ongoing post-first-investment
**Goal**: Track portfolio company performance, support founders, and make informed follow-on decisions.

### 4.1 Portfolio Dashboard (Excel Workbook)

Build a master portfolio tracker with:

| Tab | Contents | Update Cadence |
|-----|----------|---------------|
| **Summary** | All portfolio companies, investment date, amount, ownership %, current valuation, MOIC, sector, status | Quarterly |
| **KPI Tracker** | Revenue/ARR, burn rate, runway, headcount, key metrics by company | Quarterly (monthly for high-touch) |
| **Valuation Marks** | Cost basis, latest round price, fair value mark, methodology notes | Quarterly |
| **Follow-on Analysis** | Pro-rata rights, follow-on budget, priority ranking, scenario modeling | As needed |
| **Cap Table Summary** | Ownership %, dilution tracking, waterfall analysis per company | After each round |
| **Board Calendar** | Board meeting dates, prep deadlines, materials due dates | Rolling |

> **Execution**: Build with `xlsx` skill. Cowork reads portfolio company updates and flags material changes.

### 4.2 Quarterly Portfolio Review Workflow

Every quarter, Cowork assists with:

1. **Data Collection** — GP forwards portfolio company update emails/reports to Cowork. Cowork extracts KPIs and updates the tracker.
2. **Variance Analysis** — Cowork compares current quarter vs. prior quarter and vs. plan. Flags companies with >20% negative variance on key metrics.
3. **Follow-on Decision Support** — For companies raising new rounds, Cowork models follow-on scenarios (pro-rata vs. super pro-rata vs. pass) and shows dilution impact.
4. **Board Prep** — Before each board meeting, Cowork generates a prep brief: recent metrics, competitive developments, key questions to ask, suggested talking points.

### 4.3 Portfolio Support Playbook

As a solo GP, Cowork amplifies your ability to add value:

| Founder Request | Cowork Capability |
|----------------|-------------------|
| "Can you intro me to [company]?" | `sales:account-research` for intel before warm intro |
| "We need to review our enterprise contract template" | `legal:review-contract` for redline suggestions |
| "Help us think through pricing" | Cowork builds pricing analysis models |
| "We're preparing for our Series B" | Cowork generates investor targeting list, drafts outreach |
| "Can you review our board deck?" | Cowork reviews for completeness, benchmarks metrics vs. peers |

---

## Phase 5: LP Relations & Reporting

**Timeline**: Quarterly cadence post-first-close
**Goal**: Deliver institutional-grade LP reporting and maintain strong LP relationships.

### 5.1 Reporting Calendar

| Deliverable | Frequency | Deadline | Cowork Role |
|------------|-----------|----------|-------------|
| **Quarterly Letter** | Quarterly | T+45 days | Cowork drafts narrative from portfolio data |
| **Capital Account Statement** | Quarterly | T+45 days | Cowork reconciles with fund admin output |
| **Portfolio Company Updates** | Quarterly | T+45 days | Cowork aggregates and summarizes portco reports |
| **Annual Financial Statements** (audited) | Annual | T+90 days | Cowork prepares audit support package |
| **K-1s** | Annual | T+75 days (target) | Cowork tracks preparation timeline |
| **ILPA Template** | Quarterly/Annual | Per ILPA 2.0 (Jan 2025 update) | Cowork populates ILPA-compliant template |
| **ESG / DEI Report** | Annual | With annual report | Cowork drafts from portfolio data |
| **Annual Meeting Deck** | Annual | Before LPAC meeting | Cowork builds deck using `pptx` skill |
| **Capital Call Notices** | Per investment | 10 business days prior | Cowork generates from template |
| **Distribution Notices** | Per exit/distribution | 5 business days prior | Cowork generates from template |

### 5.2 Quarterly Letter Template (Cowork-Generated)

Structure for each quarterly letter:

```
1. GP Letter (1–2 pages)
   - Market commentary & portfolio themes
   - New investments this quarter (brief thesis for each)
   - Notable portfolio events (fundraises, milestones, exits)
   - Follow-on investment activity
   - Pipeline & outlook

2. Fund Performance Summary (1 page)
   - Fund-level metrics: Net IRR, Gross IRR, TVPI, DPI, RVPI
   - Committed / Called / Distributed / NAV
   - Investment pacing vs. plan
   - Fee & expense summary

3. Portfolio Company Updates (1 page per company)
   - Key metrics (revenue, burn, runway, headcount)
   - Material events since last report
   - Valuation methodology & current mark
   - GP assessment (Green / Yellow / Red)

4. Capital Account Statement (per LP, generated by fund admin)

5. Appendix
   - Fund terms summary
   - Contact information
   - Legal disclaimers
```

> **Execution**: Cowork drafts sections 1–3 as a `.docx` file each quarter. GP reviews, edits narrative, and sends. Capital account statements come from fund admin.

### 5.3 LP Communication Automation

| Trigger | Action | Tool |
|---------|--------|------|
| New investment closed | Draft "New Investment" email to LPs | `gmail_create_draft` |
| Material portco event (up or down round, M&A, IPO) | Draft LP update email | `gmail_create_draft` |
| Capital call | Generate notice + email draft | `docx` + `gmail_create_draft` |
| Quarterly report ready | Draft distribution email with report attached | `gmail_create_draft` |
| LP meeting prep | Generate briefing doc | `legal:meeting-briefing` or custom |

### 5.4 LP Metrics Calculation

Cowork calculates and validates:

| Metric | Formula | Notes |
|--------|---------|-------|
| **Gross IRR** | Time-weighted return on invested capital before fees | Standard ILPA methodology |
| **Net IRR** | After management fees + carry | What LPs care about most |
| **TVPI** | (NAV + Distributions) / Paid-In Capital | Total value multiple |
| **DPI** | Distributions / Paid-In Capital | Cash-on-cash return |
| **RVPI** | NAV / Paid-In Capital | Unrealized value |
| **PIC** | Paid-In Capital / Committed Capital | Deployment pace |

> Cowork cross-checks these against fund admin calculations each quarter and flags any discrepancies >0.5%.

---

## Phase 6: Fund Operations & Infrastructure

**Timeline**: Weeks 1–6 (parallel with Phase 1)
**Goal**: Set up the operational backbone — accounts, tools, workflows, templates.

### 6.1 Tool Stack Recommendation

| Category | Tool | Purpose | Priority |
|----------|------|---------|----------|
| **CRM** | Affinity | Relationship intelligence, deal tracking, pipeline | P0 |
| **Fund Admin** | Juniper Square or Carta | NAV, capital calls, LP portal, K-1 coordination | P0 |
| **Data Room** | Google Drive (connected via Cowork) | DD documents, legal docs, portfolio company files | P0 |
| **Email** | Gmail (connected via Cowork) | LP comms, deal flow, founder comms | P0 |
| **Calendar** | Google Calendar (connected via Cowork) | Board meetings, LP meetings, DD timelines | P0 |
| **Documents** | Cowork (docx/xlsx/pptx/pdf skills) | All document generation and analysis | P0 |
| **Cap Table** | Carta | Portfolio company cap tables and ownership tracking | P1 |
| **Portfolio Monitoring** | Custom Excel + Cowork | KPI tracking, valuation marks | P0 |
| **Banking** | SVB / JPM + Mercury (ops) | Fund account + operating account | P0 |
| **E-Signature** | DocuSign or Ironclad | Subscription docs, side letters | P1 |
| **Website** | Simple landing page (Vercel) | Fund presence, contact form for inbound | P2 |

### 6.2 Cowork-Connected Services (Already Available)

| Service | MCP Connection | Use Case |
|---------|---------------|----------|
| **Gmail** | `gmail_*` tools | Draft LP emails, search deal correspondence |
| **Google Calendar** | `gcal_*` tools | Schedule board meetings, set DD deadlines, compliance reminders |
| **Google Drive** | `google_drive_*` tools | Access shared docs, data rooms, portfolio files |
| **Vercel** | `deploy_to_vercel` | Fund website, LP portal (if custom-built) |

### 6.3 Template Library (To Build)

Cowork will generate and maintain these templates in the workspace:

| Template | Format | Skill |
|----------|--------|-------|
| IC Memo | `.docx` | `docx` |
| Quarterly LP Letter | `.docx` | `docx` |
| Capital Call Notice | `.docx` | `docx` |
| Distribution Notice | `.docx` | `docx` |
| New Investment LP Email | Gmail draft | `gmail_create_draft` |
| Deal Tracker | `.xlsx` | `xlsx` |
| Portfolio Dashboard | `.xlsx` | `xlsx` |
| Annual Meeting Deck | `.pptx` | `pptx` |
| DD Checklist | `.xlsx` | `xlsx` |
| Board Prep Brief | `.docx` | `docx` |
| Fund Compliance Calendar | `.xlsx` + scheduled tasks | `xlsx` + `schedule` |
| SPV Deal Summary | Inline (existing skill) | `spv-secondary-dd` |

### 6.4 Scheduled Automations

| Task | Frequency | Implementation |
|------|-----------|----------------|
| Compliance deadline reminders | Weekly scan | `schedule` skill — checks calendar against compliance dates |
| LP reporting deadline tracker | Monthly | `schedule` skill — T-30, T-15, T-7 reminders |
| Portfolio KPI collection reminder | Quarterly | `schedule` skill — emails to portcos requesting updates |
| Pipeline digest | Weekly | Cowork summarizes pipeline activity from deal tracker |

---

## Execution Roadmap

| Phase | Weeks | Key Deliverables | Dependencies |
|-------|-------|-----------------|--------------|
| **1. Fund Formation** | 1–8 | Entities formed, LPA drafted, service providers engaged | Fund counsel engaged |
| **2. Deal Sourcing** | 4–12 | Deal tracker built, screening workflow active, sourcing channels live | Phase 1 partially complete |
| **3. Investment Execution** | Post-first-close | Checklists operational, capital call process tested | Phase 1 complete, first LP commitment |
| **4. Portfolio Monitoring** | Post-first-investment | Portfolio dashboard built, quarterly review cadence set | At least 1 investment made |
| **5. LP Reporting** | Post-first-close | Template library built, first quarterly letter drafted | Phase 1 complete, fund admin onboarded |
| **6. Fund Operations** | 1–6 (parallel) | Tool stack set up, templates created, automations configured | — |

---

## Immediate Next Steps (What to Build First)

Once this plan is approved, I recommend executing in this order:

1. **Deal Tracker spreadsheet** (Phase 2.2) — You need this immediately to capture pipeline
2. **Compliance Calendar** (Phase 1.4 + 6.4) — Critical deadlines from day one
3. **IC Memo template** (Phase 2.3) — Ready for first deal evaluation
4. **Portfolio Dashboard** (Phase 4.1) — Ready before first investment
5. **Quarterly LP Letter template** (Phase 5.2) — Ready before first quarterly reporting cycle
6. **Capital Call Notice template** (Phase 3.1) — Ready before first investment
7. **Scheduled automations** (Phase 6.4) — Set up compliance and reporting reminders
8. **Fund website** (Phase 6.1) — Professional presence for LP and founder outreach

---

## What Cowork Cannot Do (External Action Required)

| Task | Who | Notes |
|------|-----|-------|
| Engage fund counsel | GP | Cowork can research firms and draft engagement letters |
| Negotiate LPA terms | GP + counsel | Cowork can review drafts and flag issues |
| Open bank accounts | GP | Requires in-person or direct bank relationship |
| Register entities in Delaware | GP + counsel | Cowork can prepare filing information |
| SEC/state filings | GP + counsel | Cowork can draft and review before filing |
| LP meetings and fundraising | GP | Cowork preps materials and follow-up |
| Board participation | GP | Cowork generates prep briefs |
| Final investment decisions | GP | Cowork provides analysis, never decides |
| Sign legal documents | GP | Cowork reviews, GP signs |

---

*This plan is a living document. As each phase is executed, Cowork will update progress and adapt the plan based on actual fund parameters (final fund size, LP mix, investment pace).*
