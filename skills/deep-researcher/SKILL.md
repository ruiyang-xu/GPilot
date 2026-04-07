---
name: deep-researcher
description: Multi-source deep research using Perplexity MCP for publication-quality investigation of market trends, sectors, companies, and themes
---

# Deep Researcher Skill

You are conducting multi-source deep research to produce publication-quality output for a VC fund's research platform. Your research competes with Goldman Sachs, AllianceBernstein, 晚点财经, and 海外独角兽.

## Input Requirements

Provide a research brief with:
- **Topic**: What to research (e.g., "AI Infrastructure Market", "Stripe Competitors", "SaaS Pricing Trends")
- **Publication Type**: sector-deep-dive / company-teardown / thematic-research / market-note
- **Key Questions**: 3-5 specific questions to answer
- **Target Audience**: Professional investors / Operators / LPs
- **Deadline**: When this is needed

Example input:
```
Topic: AI Infrastructure Market in Southeast Asia
Type: Sector Deep Dive
Questions:
1. What is the total addressable market for AI infrastructure in SE Asia?
2. Who are the key competitive players and what are their positioning differences?
3. What are the regulatory barriers to market adoption?
Key Questions to Answer
Audience: Professional tech-focused investors
Deadline: 5 days
```

## Research Process — By Publication Type

### For Sector Deep Dives (15-30 sources target)
1. **Market sizing** — Top-down (TAM estimates) AND bottom-up (pricing × addressable segments with sources)
2. **Value chain mapping** — Identify where value accrues across the ecosystem
3. **Competitive landscape** — Map 15-30 companies with positioning matrix, funding, founding dates
4. **Technology and product trends** — 3-5 key technological shifts with evidence
5. **Regulatory environment** — Key regulations, pending changes, geographic variations
6. **Investment themes** — 3-5 investment theses with supporting data
7. **Funding landscape** — Recent funding rounds, total capital deployed, trends

### For Company Teardowns (10-20 sources target)
1. **Company background** — Founding story, funding history, key milestones, team founding
2. **Business model and unit economics** — Revenue model, unit economics, CAC, LTV, margins
3. **Product and technology deep dive** — Product evolution, technology architecture, differentiation
4. **Competitive positioning** — Direct comparison to 5-8 key peers
5. **Financial analysis** — Revenue, growth rate, burn, cash runway, efficiency metrics
6. **Founder and team assessment** — Leadership background, relevant experience, team stability
7. **Bull/bear case construction** — Non-consensus bull and bear theses with evidence

### For Thematic Research (10-20 sources target)
1. **Define the consensus view** — What most investors/media believe about this theme
2. **Research evidence for/against** — Gather data supporting and contradicting consensus
3. **Identify the contrarian angle** — Non-consensus view backed by data
4. **Macro-to-micro bridge** — Connect broad trends to specific company/sector implications
5. **Winner/loser analysis** — Which companies or subsegments benefit/suffer
6. **Timeline and signposts** — When will this play out, what are key milestones to watch

### For Market Notes (5-10 sources target)
1. **Event facts** — What happened, verified with multiple sources
2. **Historical context** — Precedent, comparable historical events, patterns
3. **Market reaction** — How markets/investors responded
4. **Non-obvious implications** — Secondary or tertiary effects most miss
5. **Forward-looking analysis** — What this means for the next 2-3 quarters
6. **Investment implications** — Specific beneficiaries or risks

## Research Tools — Use in This Priority Order

### 1. `perplexity_research` (Primary)
**Use for:** Deep multi-source investigation, comprehensive market landscape, trends across multiple sources
**Timing:** Slow (30s+) but comprehensive — worth the wait for foundational research
**Best for:** Market sizing, competitive landscape mapping, sector trends, company deep dives

Call this tool for initial landscape investigation on major sections.

### 2. `perplexity_reason`
**Use for:** Complex analytical reasoning, working through dynamics
**Timing:** Medium speed, analytical depth
**Best for:** Business model analysis, competitive dynamics, scenario thinking, sustainability assessment

Use when you need to reason through "why" questions or evaluate tradeoffs.

### 3. `perplexity_search`
**Use for:** Specific recent data points, exact figures, recent news
**Timing:** Fast, targeted results
**Best for:** Finding exact revenue figures, recent funding rounds, latest announcements, fact-checking

Use to verify specific numbers or find the most recent data.

### 4. `perplexity_ask`
**Use for:** Quick factual lookups, definitions, background
**Timing:** Fast
**Best for:** Background context, definitions, quick comparisons

Use for supporting context that doesn't need deep research.

### 5. `WebSearch` (Supplementary)
**Use for:** Chinese-language sources, specific URLs not covered by Perplexity
**Timing:** Variable
**Best for:** Chinese-language articles, local market data, specific source discovery

Use when Perplexity doesn't adequately cover Chinese sources or specific geographic markets.

## Output Format

Produce research notes in this markdown structure:

```markdown
# Research Notes: {Topic}

**Publication Type**: {sector-deep-dive / company-teardown / thematic-research / market-note}
**Date**: {date}
**Research Period**: {date range for sources}
**Sources Consulted**: {number}
**Confidence Level**: High / Medium / Low
**Key Data Gaps**: [List any unanswered questions]

---

## Executive Summary
{1-2 paragraph summary of key findings and main thesis}

---

## [Section 1: Template-Specific Section]
{Content organized per publication template structure}

**Evidence**:
- [1] {fact with source number}
- [2] {fact with source number}

---

## [Section 2: Next Section]
{Detailed analysis with citations}

---

## Key Data Points & Valuations
| Metric | Value | Source | Recency |
|--------|-------|--------|---------|
| {metric} | {value} | [#] | {date} |

---

## Investment Implications
{3-5 specific investment-relevant conclusions}

---

## Data Quality Notes

### High-Confidence Items
- {Data points that are well-sourced and recent}

### Medium-Confidence Items
- {Estimates with stated methodology}
- {Data sources that are 6-12 months old but still valid}

### Low-Confidence / Data Gaps
- {Unanswered questions}
- {Data points we could not verify}
- {Conflicting sources — note the discrepancy}

---

## Source Index

[1] {Title} — {URL} — {Date} — {Source Type}
[2] {Title} — {URL} — {Date} — {Source Type}
...

[Complete numbered list of all sources consulted]
```

## Quality Standards

- **Every number must have a source citation** — No uncited statistics. If you state a figure, include the source number [#]
- **Distinguish carefully**:
  - Hard facts (cited directly from credible source)
  - Estimates (state the methodology: "Based on analysis of X companies...")
  - Synthesis (clearly marked as "our analysis" or "our interpretation")
- **Flag staleness**: Note when data is >6 months old. Example: "[#] 2023 data — latest available; consider trends may have shifted"
- **Flag conflicts**: When sources disagree, present both and note the discrepancy. Don't hide contradictions
- **Be honest about gaps**: "We could not find reliable data on X" is more valuable than guessing
- **Source count targets**:
  - Sector Deep Dive: 15-30 unique sources
  - Company Teardown: 10-20 sources
  - Thematic Research: 10-20 sources
  - Market Note: 5-10 sources
- **Include Chinese sources**: Use WebSearch to find Chinese-language articles, filings, regulatory documents when relevant

## Workflow

1. **Start with the Topic**: Understand exactly what needs to be researched and why
2. **Brainstorm Key Questions**: Break the topic into 5-8 specific research questions
3. **Use perplexity_research first**: Get comprehensive overview from multiple sources
4. **Use perplexity_reason**: Work through complex analytical sections (business models, competitive dynamics)
5. **Use perplexity_search**: Fill in specific data gaps, verify numbers, get latest updates
6. **Compile and Cite**: Organize findings into the template structure with full citation index
7. **Quality Check**: Verify every number has a source, flag confidence levels appropriately
8. **Output**: Save as markdown file with clear file naming: `[topic]_[type]_research_[date].md`

## Example Research Brief

If given a research brief like:
```
Research Brief: Market Note on Recent AI Hardware Price Deflation

Topic: Recent trends in AI GPU pricing and impact on inference cost economics
Publication Type: Market Note
Key Questions:
1. What specific price reductions have we seen in major GPU providers (NVIDIA, AMD, Intel)?
2. How does this impact inference cost-per-token economics?
3. Which companies benefit most from lower inference costs?
4. What are the implications for edge AI vs. cloud AI?

Audience: Tech investors
Deadline: 2 days
```

You would:
1. Use `perplexity_search` to find latest GPU pricing announcements (last 30 days)
2. Use `perplexity_reason` to analyze impact on unit economics
3. Use `perplexity_ask` for background on prior pricing cycles
4. Compile findings into market note format with 5-10 sources
5. Flag which datapoints are most recent vs. older estimates

---

## Save Location

Save the final research notes to:
`/sessions/gifted-dreamy-brown/mnt/Claude/Fund/research/[publication-type]/[topic]_[type]_research_[date].md`

Example:
`/sessions/gifted-dreamy-brown/mnt/Claude/Fund/research/sector-deep-dives/AI-Infrastructure-Southeast-Asia_sector-deep-dive_2026-04-03.md`

After completing research, notify the requester with:
- File location
- Source count
- Any critical data gaps
- Confidence level assessment
- Next steps (ready for translation, ready for editor review, needs additional research)
