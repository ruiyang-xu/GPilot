<p align="center">
  <h1 align="center">GPilot</h1>
  <p align="center"><strong>AI-Powered Financial Intelligence</strong></p>
  <p align="center">Research, analyze, and invest — with 9 AI agents, 16 commands, and a knowledge base that gets smarter every day.</p>
  <p align="center">
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
    <a href="https://claude.ai/claude-code"><img src="https://img.shields.io/badge/built%20with-Claude%20Code-blueviolet" alt="Claude Code"></a>
    <img src="https://img.shields.io/badge/agents-9-green" alt="9 Agents">
    <img src="https://img.shields.io/badge/commands-16-green" alt="16 Commands">
    <img src="https://img.shields.io/badge/bilingual-EN%20%2B%20CN-orange" alt="Bilingual">
  </p>
</p>

<!-- TODO: Add demo GIF here after recording
<p align="center">
  <img src="docs/assets/demo.gif" width="720" alt="GPilot demo — deal screening to investment memo in 10 minutes">
</p>
-->

---

## 30-Second Quickstart

```bash
git clone https://github.com/YOUR_USERNAME/gpilot.git && cd gpilot
bash scripts/quickstart.sh        # Interactive setup — name, org, API key
# Open in Claude Code, then:
/source-deals                      # Discover investment opportunities
/research                          # Write a bilingual research report
/query "What is the state of AI infrastructure in 2026?"
```

Or try **demo mode** first (no API key needed):

```bash
bash scripts/demo.sh               # Pre-populates wiki, deals, portfolio
# Open in Claude Code, then:
/query "Tell me about Quantum Labs"
/deal-screen                        # Screen a sample deal
```

---

## Why GPilot?

The AI finance space has 50K-star repos for **public equity trading**. Nobody has built the tool for **the other side of finance** — private markets, deal sourcing, investment memos, research publication, portfolio monitoring.

| What You Need | Traditional Tools | GPilot |
|---------------|-------------------|--------|
| Deal sourcing | Affinity ($500/mo), manual scanning | `/source-deals` — AI-powered, daily triage, free |
| Investment memos | Associate + 2 days | `/ic-memo` — structured, 10 minutes |
| Research reports | Analyst team + 1 week | `/research` — same day, bilingual EN + CN |
| Portfolio monitoring | Google Alerts + spreadsheets | `portfolio-news` — automated, daily |
| Company intelligence | Hours of manual research | `/company-intel` — multi-source, 5 minutes |
| Market analysis | Bloomberg ($24K/yr) | `/market-data` + `/earnings-watch` — free |

**GPilot is the first open-source Agentic OS for finance.** Not another chatbot — a complete operating system with agents, workflows, scheduled automation, and a knowledge base that compounds over time.

---

## What's Inside

```
9 AI Agents          Research, analysis, sourcing, writing, translation, editing
16 Slash Commands    Deal flow, research pipeline, knowledge base, portfolio ops
10 Scheduled Tasks   Daily briefings, weekly market notes, deal flow triage
8 Templates          Investment memo, 5 research formats, board deck, agreements
7 Skill Domains      Deep research, deal pipeline, valuation, publication, translation
1 Dashboard          Next.js portfolio visualization with sample data
1 Knowledge Base     LLM-compiled wiki (Karpathy pattern) — gets smarter every day
3 Modules            Fund-ops (LP/compliance), extras (11 more tasks), Feishu integration
```

---

## Hero Features

### 1. Deal Sourcing Pipeline

From discovery to investment memo — the full private market workflow:

```
/source-deals    →  Scan GitHub trending, funding rounds, industry reports
                    Output: Ranked opportunities with match scores
                    Runs: Weekly (scheduled) + on-demand

/deal-screen     →  Structured evaluation (market, team, product, terms)
                    Output: Screening report with go/no-go recommendation
                    Data: Saved to deals.json pipeline tracker

/ic-memo         →  Generate investment memo with comps, model, risks
                    Output: Professional .docx ready for IC presentation

/company-intel   →  Deep brief: financials, competitive landscape, news
                    Output: Dossier saved to deals/{company}/dossier.md
```

**Example output** — see [`examples/deal-sourcing-output.md`](examples/deal-sourcing-output.md) for a complete sourcing run.

### 2. Research & Publication Pipeline

Five bilingual research formats with editorial quality gates:

| Type | Cadence | Workflow |
|------|---------|---------|
| Market Note 市场脉搏 | Weekly | `/research-fast-track` → translate → edit → format |
| Company Teardown 独角兽拆解 | Bi-weekly | `/research` → outline review → draft → translate → edit |
| Insight Letter 洞见 | Monthly | `/research-fast-track` → translate → edit → format |
| Thematic Research 主题研究 | Monthly | `/research` → full 8-step pipeline |
| Sector Deep Dive 赛道纵深 | Quarterly | `/research` → full 8-step pipeline |

```
/research            →  Full 8-step: research → draft → translate → edit → publish
/research-fast-track →  Streamlined 6-step for pre-approved weekly topics
/publish             →  Format for WeChat (HTML) + LinkedIn (Markdown)
```

**Example output** — see [`examples/research-sample-en.md`](examples/research-sample-en.md) and [`examples/research-sample-cn.md`](examples/research-sample-cn.md) for a complete bilingual Market Note.

### 3. Compounding Knowledge Base

Every query makes the system smarter. Built on the [Karpathy pattern](https://karpathy.ai) for LLM-compiled knowledge management:

```
Week 1:  Drop 5 term sheets → /ingest → 5 company articles in wiki/
Week 4:  /query "Compare Series A terms across AI companies"
         → Answer synthesized from 20 articles, saved back to wiki
Month 3: Cross-cutting insights emerge automatically
         → The wiki knows your deal flow history, market patterns, counterparty track records
Month 6: Your personal Bloomberg, trained on YOUR data
```

```
/ingest       →  Drop files in raw/, auto-compile into structured wiki
/query "..."  →  Research against wiki + web, answers saved back
/lint-wiki    →  Health check: stale data, broken links, contradictions
```

---

## Architecture

```
You (Analyst / Investor / Fund Manager)
  │
  ▼
┌─────────────────────────────────────────────────────────────────┐
│  raw/              Source ingestion inbox (your files)           │
│  ├── deals/        Term sheets, pitch decks, broker quotes      │
│  ├── research/     Articles, papers, conference notes            │
│  └── market-intel/ News clips, analyst notes                    │
└──────────────────────────┬──────────────────────────────────────┘
                           │ /ingest
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│  wiki/             LLM-compiled knowledge graph                 │
│  ├── companies/    Per-company articles (auto-maintained)       │
│  ├── sectors/      Sector analysis with comp model refs         │
│  └── deals/        Pipeline status + deal history               │
└────────┬──────────────────────────────┬─────────────────────────┘
         │ /query, /company-intel       │ /research, /source-deals
         ▼                              ▼
┌────────────────────┐    ┌──────────────────────────────────────┐
│  output/           │    │  9 AI Agents working in parallel     │
│  ├── queries/      │    │  ├── deep-researcher (Perplexity)    │
│  ├── research/     │    │  ├── financial-analyst (comps+models) │
│  └── memos/        │    │  ├── deal-sourcer (opportunity scan)  │
└────────────────────┘    │  ├── memo-writer (IC documents)       │
                          │  ├── translator (EN↔CN)               │
         │ /publish       │  └── editor (quality gate)            │
         ▼                └──────────────────────────────────────┘
┌────────────────────┐
│  WeChat + LinkedIn │    data/state/*.json  ← Machine-readable SSOT
│  Bilingual distro  │    dashboard/         ← Next.js portfolio UI
└────────────────────┘
```

---

## Getting Started

### Option A: Full Setup (with your data)

```bash
git clone https://github.com/YOUR_USERNAME/gpilot.git && cd gpilot
bash scripts/quickstart.sh
```

The interactive setup will ask for your name, organization, Perplexity API key, and configure everything. See [docs/getting-started.md](docs/getting-started.md) for detailed instructions.

### Option B: Demo Mode (try it first)

```bash
git clone https://github.com/YOUR_USERNAME/gpilot.git && cd gpilot
bash scripts/demo.sh
```

Pre-populates the system with sample companies, deals, and wiki articles. No API key needed for local exploration.

### Option C: Manual Setup

```bash
cp .env.example .env              # Edit with your details
bash scripts/customize.sh         # Apply config across workspace
bash scripts/setup.sh             # Link global Claude Code config
cd dashboard && npm install       # Optional: portfolio dashboard
```

---

## Start Here (By Role)

### "I'm a Financial Analyst"
```
/company-intel NVIDIA              # Deep company brief
/market-data AAPL                  # Public market data lookup
/earnings-watch MSFT               # Earnings analysis
/query "Compare cloud infrastructure margins across hyperscalers"
```

### "I'm a Researcher"
```
/research                          # Start a bilingual research piece
/query "What are the key trends in AI infrastructure?"
/ingest                            # Process new source files into wiki
/publish                           # Format for WeChat + LinkedIn
```

### "I'm an Investor"
```
/source-deals                      # Discover opportunities
/deal-screen                       # Evaluate a specific deal
/portfolio-review                  # Portfolio health check
/weekly-digest                     # Weekly intelligence summary
```

### "I'm a Fund Manager"
```bash
cp -r modules/fund-ops/commands/* commands/    # Enable fund-ops
/lp-quarterly                      # Generate LP report
/capital-call                      # Capital call notice
/compliance-check                  # Compliance calendar review
```

---

## Modules

Core functionality lives in the root. Specialized features are in `modules/`:

| Module | For | What's Inside |
|--------|-----|---------------|
| **fund-ops/** | Fund managers | `/lp-quarterly`, `/capital-call`, `/compliance-check`, fund accounting, legal review, ILPA templates |
| **extras/** | Power users | 11 additional scheduled tasks: earnings alerts, sector deep dives, engagement tracking, market pulse distribution |
| **integrations/** | Feishu users | Feishu/Lark workspace configuration and CLI shortcuts |

Enable a module: `cp -r modules/fund-ops/commands/* commands/` — see [modules/README.md](modules/README.md).

---

## Scheduled Automation (10 core)

| Schedule | Task | What It Does |
|----------|------|-------------|
| Daily | `morning-briefing` | Market news + calendar + task summary |
| Daily | `daily-email-summary` | Gmail inbox highlights |
| Daily | `news-briefing` | Financial markets and focus sector news |
| Daily | `deal-flow-triage` | Triage new inbound opportunities |
| Daily | `portfolio-news` | Portfolio company news monitoring |
| Weekly | `deal-sourcing` | Proactive opportunity discovery scan |
| Weekly | `weekly-pipeline` | Deal pipeline status review |
| Weekly | `weekly-market-note` | Trigger weekly Market Note research |
| Weekly | `research-calendar-check` | Editorial schedule compliance |
| Weekly | `editorial-calendar` | Publication planning |

> 16 more tasks available in `modules/extras/` and `modules/fund-ops/`.

---

## Configuration

| Required | Where to Get |
|----------|-------------|
| **Claude Code** | [claude.ai/claude-code](https://claude.ai/claude-code) |
| **Perplexity API Key** | [perplexity.ai/settings/api](https://perplexity.ai/settings/api) |

| Optional | Unlocks |
|----------|---------|
| Google Calendar MCP | Calendar integration |
| Gmail MCP | Email search + draft generation |
| Google Drive MCP | Cloud document access |
| Notion MCP | Cross-surface task routing |
| Feishu / Lark | Chinese collaboration (see `modules/integrations/`) |

---

## Contributing

Contributions welcome! Areas where help is most needed:

- **Agents**: New specialized agents (e.g., ESG analyst, crypto researcher)
- **Comp models**: Additional sector models in `data/comps/`
- **Templates**: New research formats and document templates
- **Platform**: Windows/Linux compatibility improvements
- **Integrations**: Additional MCP server integrations
- **Translations**: Documentation in other languages

## License

MIT License. See [LICENSE](LICENSE).

---

<p align="center">
  <strong>The first Agentic OS for finance.</strong><br>
  金融领域的第一个 AI 智能体操作系统。<br><br>
  <a href="docs/getting-started.md">Getting Started</a> · <a href="CLAUDE.md">System Config</a> · <a href="modules/README.md">Modules</a> · <a href="examples/">Examples</a>
</p>
