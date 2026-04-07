# Deal Sourcing — Sector Keyword Reference

Maps each fund sector to search terms for GitHub trending, funding round scanning, and report harvesting.

## GitHub Topic Keywords

| Sector | Primary Keywords | GitHub Topics/Languages |
|--------|-----------------|------------------------|
| **Software/SaaS** | saas, developer tools, devops, cloud platform, workflow automation | `saas`, `devtools`, `developer-tools`, `low-code`, `no-code`, `workflow` |
| **AI/ML** | machine learning, large language model, LLM, generative AI, computer vision, NLP, AI agent, MLOps | `llm`, `generative-ai`, `machine-learning`, `transformers`, `ai-agent`, `rag`, `vector-database` |
| **Fintech** | payments, banking API, crypto infrastructure, DeFi, compliance tech, embedded finance | `fintech`, `payments`, `blockchain`, `defi`, `banking` |
| **Healthtech** | digital health, biotech platform, clinical trials, health AI, medical imaging, EHR | `health`, `biotech`, `medical`, `clinical`, `genomics` |
| **Deeptech** | robotics, quantum computing, semiconductor, advanced materials, space tech, BCI, energy storage | `robotics`, `quantum`, `semiconductor`, `hardware`, `iot`, `edge-computing` |

## Funding Round Search Queries

For each sector, use these Perplexity search templates:

```
"{sector} startup funding round {year}" site:techcrunch.com OR site:crunchbase.com
"{sector} series A B seed funding {quarter} {year}"
"venture capital {sector} investment {month} {year}"
"{sector} startup raised million {year}"
```

### Sector-Specific Funding Queries

| Sector | Search Queries |
|--------|---------------|
| **Software/SaaS** | "SaaS startup funding 2026", "developer tools series A 2026", "cloud infrastructure startup raised" |
| **AI/ML** | "AI startup funding 2026", "LLM company series A B 2026", "generative AI raised million", "AI agent startup funding" |
| **Fintech** | "fintech startup funding 2026", "payments company series A 2026", "embedded finance raised" |
| **Healthtech** | "healthtech startup funding 2026", "digital health series A 2026", "biotech AI raised" |
| **Deeptech** | "deeptech startup funding 2026", "robotics company series A 2026", "quantum computing raised", "semiconductor startup funding" |

## Report & Accelerator Sources

| Source | Check Frequency | What to Look For |
|--------|----------------|-----------------|
| **Y Combinator** | Batch launches (W26, S26) | YC Demo Day companies, batch lists |
| **ProductHunt** | Weekly | Trending #1 products in dev tools, AI, SaaS |
| **TechCrunch** | Weekly | Funding announcements, startup profiles |
| **36Kr (36氪)** | Weekly | China-origin startups, cross-border deals |
| **a16z blog** | Monthly | Portfolio announcements, market maps |
| **Sequoia Arc/Spark** | Monthly | Early-stage portfolio, market perspectives |
| **Benchmark** | Quarterly | Portfolio additions |
| **Founders Fund** | Quarterly | Deeptech investments |
| **Lightspeed** | Monthly | Enterprise/SaaS portfolio additions |
| **Index Ventures** | Monthly | European + US cross-border deals |
| **GitHub Trending** | Weekly | Language-filtered trending repos (Python, TypeScript, Rust, Go) |
| **HuggingFace Trending** | Weekly | Trending models and spaces — AI/ML signal |
| **PitchBook (via Perplexity)** | Weekly | "PitchBook {sector} deals {date}" — secondary source |
| **Crunchbase (via Perplexity)** | Weekly | "Crunchbase {sector} funding {date}" — secondary source |

## Pre-Screen Score Rubric (0–5)

Quick-filter score before full deal-screen. Applied by the deal-sourcer agent:

| Score | Meaning | Criteria |
|-------|---------|----------|
| **5** | Strong fit | Multiple strong signals + exact sector/stage match + notable investors |
| **4** | Good fit | 2+ signals + sector match + reasonable stage |
| **3** | Worth watching | 1-2 signals + adjacent sector or early stage |
| **2** | Marginal | Weak signals or poor sector fit, but interesting tech |
| **1** | Low priority | Tangential relevance, monitor only |
| **0** | No fit | Outside fund scope entirely |

## Signal Strength Classification

| Strength | Definition | Example |
|----------|-----------|---------|
| **High** | Multiple corroborating signals + fits fund thesis perfectly | AI startup with 10K+ GitHub stars growing +2K/month, just raised Series A from top-tier VC |
| **Medium** | At least one strong signal + plausible thesis fit | SaaS tool trending on ProductHunt with 1K+ upvotes, pre-seed/seed stage |
| **Low** | Single weak signal or tangential fit | Mentioned in industry report, no funding data, unclear product-market fit |

## Geographic Filters

Primary focus markets (weight higher):
- **US**: Silicon Valley, NYC, Austin, Boston, Seattle
- **China**: Beijing, Shanghai, Shenzhen, Hangzhou
- **Europe**: London, Berlin, Paris, Amsterdam
- **Israel**: Tel Aviv

Secondary (include but don't prioritize):
- Southeast Asia, India, Canada, Japan, South Korea
