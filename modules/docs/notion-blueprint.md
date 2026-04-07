# Notion Orchestration Layer Blueprint

This document specifies the Notion database schema and handoff protocol for the VC Fund OS. **the GP must execute this setup manually in Notion.**

---

## Overview

The Notion orchestration layer enables seamless task handoff between three surfaces:
- **Claude Code**: Scheduled tasks, bulk operations, research scripts
- **Cowork**: Real-time collaboration, edits, reviews
- **the GP**: Final decision maker, approvals, strategic input

The three databases below use status fields as the primary handoff signal — no polling of files needed.

---

## Database 1: Research Pipeline

**Purpose**: Track all research publications through their lifecycle (Idea → Published).

**Location**: Notion workspace, visible to Claude Code, Cowork, and the GP.

### Schema

| Property | Type | Description |
|----------|------|-------------|
| **Title** | Title | Research piece name (e.g., "AI Infrastructure Landscape Q2 2026") |
| **Type** | Select | Publication category: `Sector Deep Dive`, `Company Teardown`, `Thematic Research`, `Market Note`, `GP Letter` |
| **Status** | Select | Workflow state (see table below) |
| **Priority** | Select | `P1` (urgent), `P2` (normal), `P3` (backlog) |
| **Target Publish Date** | Date | Planned publication date |
| **Actual Publish Date** | Date | When published (empty until Status = Published) |
| **EN Draft Path** | Text | File path to English draft (e.g., `/Fund/research/drafts/ai-infrastructure-en.md`) |
| **CN Draft Path** | Text | File path to Chinese draft (e.g., `/Fund/research/drafts/ai-infrastructure-cn.md`) |
| **WeChat URL** | URL | Link to WeChat 公众号 article (populated after publication) |
| **LinkedIn URL** | URL | Link to LinkedIn post (populated after publication) |
| **Assigned Surface** | Select | Which surface owns current step: `Claude Code`, `Cowork`, `the GP` |
| **Last Updated By** | Select | Which surface made the last change: `Claude Code`, `Cowork`, `the GP` |
| **WeChat Reads** | Number | Read count from WeChat (populated by engagement-tracker task) |
| **LinkedIn Impressions** | Number | Impression count from LinkedIn (populated by engagement-tracker task) |
| **Notes** | Text | Status notes, blockers, feedback from reviews |

### Status Workflow

```
Idea → Researching → Outlining → Awaiting the GP (Outline)
  ↓ (the GP approves) ↓
  → Drafting → Review → Translating → CN Review → Final Review
  ↓ (Fallback from review) ↓
  ← Revision Needed ← (Editor score < 4/5)
  ↓ (Resubmit) ↓
  → Awaiting the GP (Final) → Ready → Published
```

**Status Meanings**:
- **Idea**: Topic identified, not yet started
- **Researching**: Claude Code executing research (deep-researcher skill)
- **Outlining**: Claude Code creating outline for review
- **Awaiting the GP (Outline)**: Outline complete; the GP reviews and approves or requests changes
- **Drafting**: Claude Code writing English and Chinese drafts
- **Review**: Editor skill reviewing English draft
- **Translating**: Translator (Claude Code) translating EN→CN
- **CN Review**: Editor reviewing Chinese draft
- **Final Review**: Final editorial pass (English + Chinese consistency check)
- **Revision Needed**: Editor score < 4/5 on EN or CN; feedback in Notes
- **Awaiting the GP (Final)**: Final drafts ready; the GP does final review and approves for publication
- **Ready**: Approved, awaiting distribution (format, schedule)
- **Published**: Distributed to WeChat + LinkedIn

**Assigned Surface Logic**:
- Claude Code owns: Researching, Drafting, Translating, Review (first pass), Final Review (mechanical check)
- the GP owns: Outlining gate (approves outline), Final gate (approves publication)
- Cowork owns: Manual edits, feedback incorporation, ad-hoc collaboration

---

## Database 2: Task Queue

**Purpose**: Central task backlog for all work across the fund (research, deals, portfolio, LP, compliance, admin).

**Location**: Notion workspace, visible to Claude Code, Cowork, and the GP.

### Schema

| Property | Type | Description |
|----------|------|-------------|
| **Task** | Title | Task name (e.g., "Quarterly portfolio review: healthtech sector") |
| **Type** | Select | `Research`, `Deal`, `Portfolio`, `LP`, `Compliance`, `Admin` |
| **Status** | Select | `Queued`, `In Progress`, `Awaiting the GP`, `Done` |
| **Source Surface** | Select | Where task originated: `Claude Code` (scheduled), `Cowork` (manual), `Scheduled` (automated) |
| **Target Surface** | Select | Which surface should execute: `Claude Code`, `Cowork`, `the GP` |
| **Priority** | Select | `Urgent`, `High`, `Normal`, `Low` |
| **Due Date** | Date | When task is due |
| **Context** | Text | What was done, what's needed next, any blockers (e.g., "Waiting for Q1 financials from portfolio; need to format into tracker by EOW") |
| **File Paths** | Text | Relevant file paths (comma-separated, e.g., `/Fund/deals/company-x/model.xlsx, /Fund/output/memos/q1-review.md`) |
| **Owner** | Select | Primary owner: `the GP`, `Claude Code`, `Cowork`, `Unassigned` |
| **Created** | Date | When task was created (auto-populated) |
| **Last Updated** | Date | When task was last modified (auto-populated) |

### Status Workflow

```
Queued → In Progress → Awaiting the GP → Done
  ↑                          ↓
  └──────── (Revision) ──────┘
```

**Status Meanings**:
- **Queued**: Task waiting to be picked up
- **In Progress**: Active work (Claude Code, Cowork)
- **Awaiting the GP**: Task complete; needs the GP's decision or approval
- **Done**: Task completed and approved

---

## Database 3: Deal Pipeline

**Purpose**: Track all deal flow across stages (Pipeline → Invested or Passed).

**Location**: Notion workspace, visible to Claude Code, Cowork, and the GP.

### Schema

| Property | Type | Description |
|----------|------|-------------|
| **Company** | Title | Company name |
| **Stage** | Select | Deal stage: `Pipeline`, `Screening`, `DD`, `IC`, `Term Sheet`, `Closing`, `Invested`, `Passed`, `Monitoring` |
| **Score** | Number | Internal score (1-5), where 5 = strong fit |
| **Sector** | Select | Business sector: `AI/ML`, `SaaS`, `Fintech`, `Healthtech`, `Deeptech`, `Other` |
| **Source** | Text | Deal source (e.g., "Intro from LP XYZ", "Warm intro from founder ABC") |
| **Check Size** | Text | Target check size (e.g., "$500K-$1M") |
| **Next Action** | Text | Next step (e.g., "Schedule founder call", "Request financials") |
| **Owner** | Select | Who is leading diligence: `the GP`, `Claude Code` |
| **Last Updated** | Date | Last modification date (auto-populated) |
| **Notes Path** | Text | Path to deal notes (e.g., `/Fund/deals/company-y/notes.md`) |
| **Dossier Path** | Text | Path to deal dossier (e.g., `/Fund/deals/company-y/dossier.md`) |

### Stage Definitions

- **Pipeline**: New inbound, not yet screened
- **Screening**: Initial screening underway (the GP or Claude Code review)
- **DD**: Diligence in progress (financial, technical, legal)
- **IC**: Investment committee materials being prepared; awaiting IC vote
- **Term Sheet**: Term sheet drafted and under negotiation
- **Closing**: Final docs being executed; closing in progress
- **Invested**: Fully closed; company added to portfolio
- **Passed**: Declined to invest (reason in Notes Path)
- **Monitoring**: Invested company under ongoing monitoring

---

## Handoff Protocol

### 1. Status Field as Signal

Each database uses the **Status** field as the primary handoff signal. Claude Code, Cowork, and the GP monitor status changes via Notion; no separate polling of files is needed.

**Claude Code → the GP**:
```
Research Pipeline: Status = "Awaiting the GP (Outline)" or "Awaiting the GP (Final)"
Task Queue: Status = "Awaiting the GP"
→ the GP reviews Notion and makes decision → updates Status (approves/revision needed)
```

**the GP → Claude Code**:
```
the GP updates Status → "Drafting" or "In Progress" or "Ready"
→ Claude Code queries Notion for items with Status matching next step
→ Executes work → updates Status to next stage
```

**Cowork ↔ Claude Code**:
```
Cowork makes edits to EN/CN drafts → updates Status (e.g., "Revision Needed" → "Drafting")
Claude Code queries Notion for items assigned to Cowork → picks up and executes
```

### 2. Notion MCP Integration

**Claude Code scheduled tasks** (via `notion-update` MCP tool):

```python
# After research is complete
notion_update_page(
  page_id="research-db-entry-id",
  properties={
    "Status": "Awaiting the GP (Outline)",
    "EN Draft Path": "/Fund/research/drafts/ai-landscape-en.md",
    "Assigned Surface": "the GP",
    "Last Updated By": "Claude Code"
  }
)

# the GP approves outline
# → the GP manually updates Status to "Drafting"

# Claude Code drafting complete
notion_update_page(
  page_id="research-db-entry-id",
  properties={
    "Status": "Review",
    "Assigned Surface": "Claude Code",
    "Last Updated By": "Claude Code"
  }
)
```

**Cowork queries** (via `notion-query` MCP tool):

```python
# At session start, fetch all research awaiting Cowork review
results = notion_query(
  database_id="research-pipeline-db-id",
  filter={
    "and": [
      {"property": "Status", "select": {"equals": "Review"}},
      {"property": "Assigned Surface", "select": {"equals": "Cowork"}}
    ]
  }
)
# Process each item, update status as work progresses
```

### 3. Workflow Example: Market Note (Fast-Track)

**Workflow**: Approved topic → Researching → Drafting → Review → Final Review → Published

```
1. Claude Code scheduled task (research-fast-track):
   - Creates or updates task in Task Queue: Status = "In Progress"
   - Researches topic → updates Research Pipeline: Status = "Researching"
   - Writes EN + CN drafts → Status = "Drafting"

2. Claude Code editor review:
   - Runs editor skill → Status = "Review"
   - If score < 4/5 → Status = "Revision Needed", Context notes feedback
   - Else → Status = "Final Review"

3. If revision needed:
   - Cowork session picks up item with Status = "Revision Needed"
   - Cowork edits drafts → Status = "Drafting"
   - Claude Code re-runs editor → Status = "Review"

4. Final review passes:
   - Claude Code updates Status → "Ready"
   - Updates Assigned Surface → "the GP"

5. the GP approves:
   - Updates Status → "Published"
   - Updates Actual Publish Date, WeChat URL, LinkedIn URL

6. Distribution task runs:
   - Publishes to WeChat, LinkedIn
   - Updates Status → "Published"

7. engagement-tracker runs monthly:
   - Queries all items with Status = "Published"
   - Scrapes WeChat/LinkedIn metrics → updates WeChat Reads, LinkedIn Impressions
```

### 4. Queries and Views

**Claude Code Queries** (in scheduled tasks):

```python
# Find all research items awaiting outline approval from the GP
items = notion_query(
  database_id="research-pipeline-db",
  filter={"property": "Status", "select": {"equals": "Awaiting the GP (Outline)"}}
)

# Find urgent tasks for Cowork
items = notion_query(
  database_id="task-queue-db",
  filter={
    "and": [
      {"property": "Target Surface", "select": {"equals": "Cowork"}},
      {"property": "Priority", "select": {"equals": "Urgent"}},
      {"property": "Status", "select": {"does_not_equal": "Done"}}
    ]
  }
)
```

**Cowork Saved Filters** (in Notion UI):

- "My Research Items": Status = Review, Assigned Surface = Cowork
- "My Tasks": Status = In Progress, Target Surface = Cowork
- "Awaiting My Approval": Status = Awaiting the GP, Owner = the GP

**the GP Dashboard** (in Notion UI):

- "Outline Approvals": Status = "Awaiting the GP (Outline)"
- "Final Approvals": Status = "Awaiting the GP (Final)"
- "Urgent Items": Priority = Urgent, Status != Done

---

## Implementation Checklist

- [ ] Create Notion workspace (if not exists)
- [ ] Create Research Pipeline database with schema above
- [ ] Create Task Queue database with schema above
- [ ] Create Deal Pipeline database with schema above
- [ ] Share all three databases with Claude Code (read/write), Cowork (read/write), the GP (owner)
- [ ] Create views in Research Pipeline:
  - [ ] "By Status" (group by Status)
  - [ ] "This Week" (filter Target Publish Date = this week)
  - [ ] "Awaiting the GP" (filter Status = Awaiting the GP)
  - [ ] "Published" (filter Status = Published)
- [ ] Create views in Task Queue:
  - [ ] "By Status" (group by Status)
  - [ ] "My Tasks" (filter Target Surface = current user)
  - [ ] "Urgent" (filter Priority = Urgent, Status != Done)
- [ ] Create views in Deal Pipeline:
  - [ ] "By Stage" (group by Stage)
  - [ ] "Active Screening" (filter Stage = Screening, DD, IC)
  - [ ] "My Leads" (filter Owner = current user)
- [ ] Test integration: Claude Code updates a research item, verify Notion reflects change
- [ ] Document Notion workspace URL in `/Fund/config/integrations.md`

---

## Integration Points

### Claude Code

Claude Code scheduled tasks and commands query and update these databases:
- `/scheduled/research-tracker/SKILL.md`: Updates Research Pipeline status
- `/scheduled/task-manager/SKILL.md`: Manages Task Queue (create, update, query)
- `/commands/research-fast-track.md`: Updates Research Pipeline as it executes

### Cowork

Cowork sessions query Notion at session start to find assigned work:
```
At start of session:
→ Read research-tracker Notion database
→ Filter: Status = Review, Assigned Surface = Cowork
→ Load relevant files (EN Draft Path, CN Draft Path)
→ Begin editing
→ Update Status in Notion as work progresses
```

### the GP

the GP uses Notion as decision interface:
1. Opens Research Pipeline → "Awaiting the GP (Outline)" view
2. Reviews outline in Notes + EN Draft Path
3. Approves or requests changes → updates Status
4. Similarly for Final approvals and Task Queue decisions

---

## Notes

- **Soft Deletes Only**: Never delete research or task records. Set Status = "Archived" if you want to hide from active views.
- **Real-Time Sync**: Notion MCP tool updates are immediate; no polling delays.
- **File Paths**: Always use absolute paths in draft paths (e.g., `/Fund/research/drafts/` not `~/Claude/Fund/research/drafts/`).
- **Metadata Freshness**: "Last Updated By" and "Last Updated Date" should auto-populate via database formulas; coordinate with Notion formula setup.
- **Confidentiality**: Do not expose LP names or commitment amounts in Notion (use generic references); LP details stay in fund Feishu only.
