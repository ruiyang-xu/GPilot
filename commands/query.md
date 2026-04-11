---
name: query
description: Research a question against the wiki — synthesize answer from compiled knowledge, file output back
---

Research question: $ARGUMENTS

## Process

### Step 1: Index scan
Read `wiki/_index.md` and `wiki/_summaries.md` to understand what's available.

### Step 2: Identify relevant articles
Based on the query, select the 5-10 most relevant wiki articles. Consider:
- Direct matches (company name, sector, concept)
- Related topics (linked articles, same sector)
- Cross-cutting themes (e.g., "valuation trends" spans multiple companies)

### Step 3: Deep read
Read the selected wiki articles fully. Extract relevant facts.

### Step 4: Raw source check
If wiki is insufficient for a thorough answer:
- Check `raw/` for primary source documents
- Check `deals/` for detailed analysis
- Check `data/comps/` for sector-level data
- Check `feishu-index.md` for Feishu cloud documents

### Step 5: Web supplement
If the question involves current market data, news, or public information:
- Use Perplexity MCP (`perplexity_search`, `perplexity_ask`) for real-time data
- Use Daloopa MCP for public company fundamentals
- Flag which parts of the answer come from wiki vs. web

### Step 6: Synthesize
Write the answer as a markdown file: `output/queries/YYYY-MM-DD-{slug}.md`

Format:
```markdown
---
query: "original question"
date: YYYY-MM-DD
sources_wiki: [list of wiki articles used]
sources_raw: [list of raw files used]
sources_web: [list of web sources]
---

# Answer

[Structured answer with headers, bullets, tables as appropriate]

## Sources
[Citation list]

## Knowledge Gaps
[What data would improve this answer? Suggest raw/ additions or wiki updates.]
```

### Step 7: Feedback loop
If the answer reveals new connections or insights:
- Suggest wiki updates (new cross-links, new articles, corrections)
- If the answer is substantial enough to be reusable, suggest filing it into `wiki/concepts/` or `wiki/sectors/`

### Step 7b: Learnings capture
If the query process revealed a reusable technique or workaround:
- Append to `learnings/deep-researcher.md` (or the appropriate agent's learnings file)
- Examples: specific Perplexity query structures that yielded better results, search strategies that improved coverage, data source quirks discovered
- Format: date, context, learning, impact, tags

### Step 8: Output
Print the answer to the terminal. Save to `output/queries/`.
