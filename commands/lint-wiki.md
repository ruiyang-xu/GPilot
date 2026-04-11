---
name: lint-wiki
description: Health check the wiki — find stale data, broken links, orphans, contradictions, gaps
---

Run a comprehensive health check on `wiki/`.

## Checks

### 1. Staleness
Find articles where `updated` in frontmatter is > 30 days ago. For each:
- Is the underlying data still current?
- Use web search to check for updates on the entity
- Flag for manual review or auto-update if confident

### 2. Broken Wikilinks
Scan all `[[wikilinks]]` across wiki articles. Flag any that point to non-existent articles. Suggest:
- Create the missing article (if enough data exists in raw/)
- Remove the broken link (if the reference is trivial)

### 3. Missing Entities
Compare entities mentioned in `raw/` and `deals/` against existing wiki articles. Flag entities that appear in sources but have no wiki article.

### 4. Orphan Articles
Find wiki articles with zero incoming backlinks from other articles. These are disconnected — suggest connections.

### 5. Contradictions
Cross-check key facts (valuations, dates, ownership %, deal terms) across articles. Flag where two articles disagree on the same fact. Reference the source documents.

### 6. Completeness
For company articles, check that key sections exist:
- Key Facts (founded, HQ, sector, stage, valuation, investors)
- Analysis or Deal History
- Related links

### 7. Index Integrity
Verify `wiki/_index.md` and `wiki/_summaries.md` are complete:
- Every wiki article has an index entry
- Every wiki article has a summary
- No index entries point to deleted articles

### 8. Suggestions
Based on the data patterns:
- Suggest new concept articles worth creating
- Suggest cross-links worth adding
- Suggest questions worth researching (via `/query`)
- Identify sectors with many companies but no sector article

### 9. Learnings-Wiki Coherence
Cross-check learnings against wiki:
- Check if any active learnings in `learnings/*.md` reference wiki articles that no longer exist
- Check if learnings suggest wiki articles that should exist but don't
- Flag learnings that could be "graduated" into wiki content (if a learning captures objective domain knowledge rather than processing experience)

## Output

Save report to `output/digests/YYYY-MM-DD-wiki-health.md`:

```markdown
# Wiki Health Check — YYYY-MM-DD

## Stats
- Total articles: N
- Average age: N days
- Total wikilinks: N
- Broken links: N

## Issues Found
### Critical (contradictions, broken data)
...
### Important (stale, missing entities)
...
### Suggestions (new articles, connections)
...

## Action Items
1. [specific actionable items]
```
