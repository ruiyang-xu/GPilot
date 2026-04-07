---
name: weekly-digest
description: Generate weekly intelligence digest — new data, wiki changes, pipeline status, market moves
---

Generate a weekly intelligence digest covering the past 7 days.

## Sections

### 1. New Ingestion
What's new in `raw/` this week? List files added/modified with brief descriptions.

### 2. Wiki Changes
What wiki articles were created or updated? Summarize the key changes.

### 3. Deal Pipeline
Read `data/state/deals.json` and `wiki/deals/` for current pipeline:
- Active deals and their status
- Next actions due this week
- Any deals that need attention (stale, overdue)

### 4. Portfolio Monitor
Read `data/state/portfolio.json` and `data/state/public_holdings.json`:
- Check web (Perplexity) for news on portfolio companies
- Flag material events (funding rounds, leadership changes, M&A, regulatory)
- Public holdings: price movements, upcoming earnings

### 5. Market Intelligence
Use Perplexity to scan for:
- Major investment deals in configured focus sectors
- Secondary market trends
- Regulatory changes affecting cross-border deals
- Notable research or reports

### 6. Research Pipeline
Read `data/state/research.json`:
- What's in progress? What's due this week?
- Editorial calendar check against `CLAUDE.md` publication schedule

### 7. Open Tasks
Check for any pending items across the system:
- Overdue compliance items (`data/state/compliance.json`)
- Stale deal actions
- Research deadlines

## Output

Save to `output/digests/YYYY-MM-DD-weekly.md`

Format as a scannable briefing — headers, bullets, tables. Lead with "action required" items, then "FYI" items. Keep it under 2,000 words.

Also: if the digest reveals facts worth preserving, suggest filing them into `raw/market-intel/` for the next `/ingest` cycle.
