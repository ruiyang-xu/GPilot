---
name: research-publication
description: Domain knowledge for research publication — style guides, quality standards, editorial process, and bilingual distribution formatting for a GP-branded research platform
---

You are assisting with research publication for a solo GP VC fund. This research platform competes with Goldman Sachs, 晚点财经, 海外独角兽, and AllianceBernstein for mindshare among investors and the tech community.

## Publication Types

| Type | Cadence | Length | Benchmark |
|------|---------|--------|-----------|
| Sector Deep Dive | Quarterly | 15-25 pages | Goldman Sachs sector reports |
| Company Teardown | Bi-weekly | 8-15 pages | 海外独角兽 company profiles |
| Thematic Research | Monthly | 10-20 pages | AllianceBernstein thematic pieces |
| Market Note / Quick Take | Weekly | 2-5 pages | 晚点财经 quick analyses |
| GP Letter | Monthly | 3-5 pages | the GP's personal voice |

## Editorial Workflow (10 Steps)

1. **Topic Selection** → Check calendar gaps, market relevance, LP interest
2. **Research Brief** → Define scope, key questions, source strategy
3. **Deep Research** → Use `deep-researcher` agent with Perplexity MCP
4. **Outline Review** → the GP approves structure before drafting
5. **Draft (English)** → Write using appropriate template
6. **Internal Review** → `editor` agent quality gate
7. **Translation (Chinese)** → `translator` agent, not machine translation
8. **CN Review** → `editor` agent reviews Chinese version
9. **Format for Distribution** → WeChat + LinkedIn formatting via `/publish`
10. **Publish** → the GP's explicit approval required

## Quality Bar — What Makes This GP-Quality

Every piece must contain at least one of:
- **Original framework** — a proprietary way to analyze the topic
- **Non-consensus view** — a contrarian position with rigorous backing
- **Portfolio insight** — anonymized lessons from real investment experience
- **Data synthesis** — connecting data points others haven't connected

If a draft is merely summarizing publicly available information, it fails the quality bar.

## Bilingual Protocol
- Always draft English first (source material and frameworks are primarily English)
- Translate to Chinese via `translator` agent (not inline translation)
- Chinese version is cultural adaptation, not literal translation
- Technical terms: Chinese + English parenthetical on first use: "大语言模型 (LLM)"
- Both versions must convey identical analytical substance

## Research Tools
- `perplexity_research` — deep multi-source investigation (primary tool, 30s+)
- `perplexity_search` — specific facts, URLs, recent news
- `perplexity_reason` — complex analytical reasoning
- `perplexity_ask` — quick factual lookups
- `WebSearch` — supplementary sources

## Data
- Pipeline tracker: `data/research-tracker.xlsx`
- WIP pieces: `research/wip/{YYYY-MM-DD}-{slug}/`
- Published pieces: `research/published/{YYYY-MM-DD}-{slug}/`
- Distribution output: `output/research/wechat/` and `output/research/linkedin/`

## References
- `references/writing-style-guide.md` — EN + CN writing standards benchmarked to GS/AB/LatePost
- `references/visual-standards.md` — Chart, table, and framework design standards
- `references/wechat-formatting.md` — WeChat 公众号 formatting rules
- `references/linkedin-formatting.md` — LinkedIn post formatting best practices
- `references/editorial-checklist.md` — Quality gate checklist for editor agent

## Safety
- All publications require the GP's explicit approval before publishing
- Never auto-publish to WeChat or LinkedIn
- Anonymize portfolio company insights unless the GP explicitly approves attribution
- Cite all data sources — no fabricated statistics
