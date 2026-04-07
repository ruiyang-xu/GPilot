---
name: compliance-check
description: Review compliance calendar — flag upcoming deadlines and overdue items
---

You are reviewing the fund's compliance calendar to ensure nothing is missed.

## Process

### Step 1: Load Compliance Data
Read `data/state/compliance.json` (or `data/fund/compliance-calendar.xlsx` for human review) using the xlsx skill.

### Step 2: Categorize Items

**Overdue** (Due Date < today, Status ≠ "Complete"):
- Flag with urgency level based on how overdue:
  - <7 days: Warning
  - 7-30 days: Urgent
  - 30+ days: Critical

**Due Soon** (Due Date within next 30 days):
- List with days remaining
- Required action steps
- Responsible party

**Upcoming** (Due Date 30-90 days):
- Preview for planning purposes

**Current** (Status = "Complete"):
- Confirmation count

### Step 3: Action Items
For each overdue or due-soon item, provide:
- What needs to be done (specific steps)
- Who is responsible (GP, legal counsel, auditor, fund admin)
- Estimated time to complete
- Dependencies or prerequisites

### Step 4: External Communications
For items involving external parties (counsel, auditor, administrator):
- Draft reminder emails (Gmail DRAFTS only)
- Include: item description, deadline, current status, action needed

### Step 5: Output

```markdown
## Compliance Check — {date}

### Status Summary
- ✅ Current: {X} items
- ⚠️ Due within 30 days: {X} items
- 🔴 Overdue: {X} items

### Overdue Items (Requires Immediate Attention)
| Item | Category | Due Date | Days Overdue | Owner | Action Needed |
|------|----------|----------|-------------|-------|---------------|

### Due Within 30 Days
| Item | Category | Due Date | Days Left | Owner | Action Needed |
|------|----------|----------|----------|-------|---------------|

### Upcoming (30-90 Days)
| Item | Category | Due Date | Owner |
|------|----------|----------|-------|

### Drafts Created
{List of reminder emails drafted}

### Recommended Actions
{Prioritized list of next steps}
```

### Step 6: Update Calendar
Update `data/state/compliance.json` (or `data/fund/compliance-calendar.xlsx` for human review) Status field for any items confirmed complete during this review.

## Safety
- Compliance deadlines are non-negotiable — treat overdue items as urgent.
- All reminder emails are DRAFTS only.
- When in doubt about a compliance requirement, flag for legal counsel review.
- This is an automated check — it does not replace professional compliance advice.
