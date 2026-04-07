---
name: ingest
description: Process new raw/ files into the wiki — extract facts, update articles, maintain indices
---

Scan `raw/` for files modified since the last ingest (check `wiki/_summaries.md` for the last ingest timestamp at the bottom). If no timestamp, process everything.

## For each new or updated file in raw/:

1. **Read and extract**: Key facts, entities (companies, people, funds), dates, numbers, deal terms, Chinese business terms
2. **Classify**: Which wiki category? (companies, sectors, deals, people, concepts)
3. **Update or create wiki articles**:
   - If a `wiki/companies/{company}.md` exists → append new facts under a dated `## Updates` section
   - If not → create a new article with YAML frontmatter
   - Do the same for sectors, people, concepts as relevant
4. **Backlinks**: Add `[[wikilinks]]` between related articles. Every article should link to at least 2 others.
5. **Update indices**:
   - `wiki/_index.md` — add/update the entry
   - `wiki/_summaries.md` — add/update the 2-3 line summary

## Wiki Article Format

```markdown
---
title: Company Name
tags: [ai, llm, series-c, us]
updated: 2026-04-03
sources: [raw/deals/company-termsheet.md, raw/research/sector-report.md]
---

# Company Name (中文名)

Brief 2-3 sentence description.

## Key Facts
- Founded: YYYY
- HQ: City, Country
- Sector: AI/ML
- Stage: Series C
- Last valuation: $X.XB
- Key investors: [list]

## Analysis
...

## Deal History
...

## Updates
### 2026-04-03
- New term sheet received (source: [[raw/deals/...]])

## Related
- [[sector-article]]
- [[related-company]]
- [[concept-article]]
```

## After Processing

Report to the user:
- Files processed: N
- Wiki articles created: N
- Wiki articles updated: N
- New entities discovered: [list]
- Conflicts or contradictions found: [list]
- Update the ingest timestamp at the bottom of `wiki/_summaries.md`

## Data Paths

- Read from: `raw/` (never modify these files)
- Write to: `wiki/`, `wiki/_index.md`, `wiki/_summaries.md`
- State: `data/state/` JSON files should also be updated if deal/portfolio data changes

## Important

- **Never modify files in raw/**. They are source documents.
- Preserve Chinese business terms inline: "估值 (valuation)", "赛道 (sector)", etc.
- If a raw file is a screenshot or image, describe its content in the wiki article and reference the image path.
- For deal term sheets: always extract valuation, round size, lead investor, structure (SAFE/equity/SPV), and fee terms.

## Full Rebuild Mode (`/ingest --full`)

**WARNING**: Expensive — reads everything. Only run when raw/ has changed substantially, or when wiki quality has degraded.

### Process
1. **Inventory**: Read ALL files in `raw/`, `deals/`, `data/state/*.json`, `data/comps/*.xlsx` headers, `feishu-index.md`
2. **Entity Extraction**: Identify all unique entities — companies, people, sectors, concepts, deals
3. **Wiki Generation**: Create a wiki article for each entity following the format above
4. **Cross-linking**: Add `[[wikilinks]]` between all related articles (minimum 2 links per article)
5. **Index Rebuild**: Regenerate `wiki/_index.md` and `wiki/_summaries.md` from scratch
6. **Diff Report**: Compare new wiki with existing, report additions/removals/contradictions. Save to `output/digests/YYYY-MM-DD-compile-report.md`
