# Changelog

All notable changes to GPilot are documented in this file. Format follows
[Keep a Changelog](https://keepachangelog.com/) and the project adheres to
[Semantic Versioning](https://semver.org/).

## [0.2.0] — 2026-04-15 — Self-Evolving Framework + DCF

> **Theme**: GPilot moves from "stateless harness" to "self-evolving system".
> Agents now learn from every session, multi-session jobs survive restarts, and
> GPilot can construct (not just report) institutional-quality DCF models.

### Highlights

- 🧠 **Three-tier memory system** (`learnings/preferences.md` + `wiki/` + `learnings/{agent}.md`) — agents read past experience on startup and reflect after every task
- 🪝 **Stop hook auto-capture** — every Claude Code session is automatically logged to `learnings/_daily-log.md` with zero manual discipline; `/review-learnings` rolls up daily logs into per-agent insights weekly
- 📊 **DCF construction skill** — port of `anthropics/financial-services-plugins` DCF model (1,263 lines), adapted for GPilot's directory conventions, bilingual context, and SSOT state layer
- ⚙️ **Cross-session job tracking** — `data/state/running-jobs.json` + `/jobs` command lets long-running tasks (`/research`, `/dcf`, `/source-deals`) survive session restarts
- 📝 **IC memo guardrails** — `memo-writer` now enforces factual+balanced + math-must-tie + unambiguous recommendation rules at draft time

### Added

#### Agent Evolution Framework (new top-level concept)

- **`learnings/` directory** (new top-level, 12 files):
  - `_index.md` — master index of accumulated learnings per agent
  - `_daily-log.md` — auto-captured by Stop hook, processed by `/review-learnings`
  - `preferences.md` — user preferences captured from repeated corrections
  - `system.md` — cross-cutting learnings (MCP quirks, tool tips, workflow patterns)
  - `deal-sourcer.md`, `deep-researcher.md`, `financial-analyst.md`, `market-researcher.md`, `portfolio-monitor.md`, `memo-writer.md`, `editor.md`, `translator.md`, `data-visualizer.md` — per-agent learning files

- **State layer extensions** (`data/state/`):
  - `running-jobs.json` — multi-session job tracker
  - `evolution-log.json` — agent learning audit trail
  - `schema.json` extended with `running_job_object` and `evolution_log_entry` definitions

- **Hook integration**:
  - `.claude/settings.json` — registers `Stop` hook for auto-reflection
  - `scripts/hooks/auto-reflect.sh` — POSIX bash script that captures session metadata to daily log; cross-platform (macOS/Linux/Git Bash on Windows), with recursive-loop protection and silent fail outside GPilot directory

#### New commands (3)

- **`/reflect`** — manually trigger agent self-reflection on recent work; scans `output/`, captures insights, updates `learnings/{agent}.md` and `evolution-log.json`
- **`/review-learnings`** — weekly/monthly curation: process pending daily-log entries, prune stale learnings (>90 days), promote cross-cutting insights to `learnings/system.md`, generate evolution trend report
- **`/jobs`** — list, resume, abandon, or clean up multi-session jobs from `running-jobs.json`
- **`/dcf`** — build institutional-quality DCF model with 6 user-verification gates, Bear/Base/Bull scenario blocks, full WACC sheet, 75 sensitivity formulas, equity bridge, and recalc.py validation

#### New skill reference

- **`skills/valuation-report/references/dcf-construction.md`** (712 lines) — full DCF methodology adapted from `anthropics/financial-services-plugins/financial-analysis/skills/dcf-model/SKILL.md`. Stripped Office JS specifics (GPilot uses Python/openpyxl exclusively), retained all formula-rigor discipline. Added bilingual notes for China-domiciled companies (CGB risk-free rate, long-run China GDP, FX rate documentation).

#### CLAUDE.md additions

- New section: **"Agent Evolution Framework"** with three-tier memory table, session startup protocol, reflection protocol, running jobs tracking, and the evolution loop diagram
- New subsection in Knowledge Base: **"Learnings vs. Wiki"** — distinguishes objective domain knowledge (wiki) from processing experience (learnings)
- Working Conventions updated with `Learnings`, `Running Jobs`, and `Preferences` lines
- Directory map updated with `learnings/` entry
- Commands table updated: 16 → 20 commands

### Changed

#### Existing agents (9 files updated)

Every agent in `agents/` now has:

- **Startup Context section** (after frontmatter): reads `learnings/{agent-name}.md`, `learnings/preferences.md`, and `data/state/running-jobs.json` before any task
- **Reflection Protocol section** (at end of file): self-assess → capture → update preferences → update jobs, with agent-specific "Watch for" prompts:
  - `deal-sourcer`: search keyword effectiveness, China coverage gaps, scoring drift
  - `deep-researcher`: source diversity, Perplexity query patterns, citation quality
  - `financial-analyst`: comp selection, Daloopa quirks, valuation methodology fit
  - `portfolio-monitor`: signal-to-noise ratio, event classification accuracy
  - `memo-writer`: template fit, GP feedback patterns
  - `editor`: score calibration vs GP overrides
  - `translator`: term consistency, tone calibration
  - `market-researcher`: TAM methodology, landscape completeness
  - `data-visualizer`: mobile readability, chart selection

#### `agents/memo-writer.md` — IC Memo Quality Guardrails (new section)

Added 5 non-negotiable rules applied at draft time:

1. **Factual + balanced**: steelman bear case as hard as bull case
2. **No hedging without numbers**: replace "potentially significant" with quantified ranges or `[unquantified — require GP judgment]`
3. **Math must tie**: EBITDA bridges, S&U balance, returns math, cap table dilution all reconcile before submission
4. **Risk ranking discipline**: rank by `severity × likelihood`, not by "easiest to mitigate"
5. **Recommendation must be unambiguous**: Proceed / Pass / Conditional Proceed (no "lean toward")

#### Existing commands updated (5 files)

- **`commands/query.md`** — Step 7b added: capture reusable techniques to `learnings/deep-researcher.md`
- **`commands/ingest.md`** — "Ingestion Learning Capture" section added: write entity-extraction patterns to `learnings/system.md`
- **`commands/lint-wiki.md`** — Check 9 added: learnings-wiki coherence (orphaned references, missing wiki articles suggested by learnings)
- **`commands/ic-memo.md`** — Step 2 financial-analyst now auto-invokes `/dcf` for Series B+ deals with revenue
- **`commands/portfolio-review.md`** — Step 3 valuation update auto-refreshes DCF when `last_valuation_date > 12 months`, `valuation_source ≠ DCF` and stage ≥ Series C, `valuation_confidence = Low` with revenue, OR a recent material event has occurred
- **`commands/review-learnings.md`** — Step 0 added: drain `learnings/_daily-log.md` (Stop hook captures) before reviewing static learnings; processed entries marked and pruned after 30 days

#### `scheduled/morning-briefing/SKILL.md`

- Step 4 added: check `data/state/running-jobs.json` for active multi-session jobs; flag jobs with no activity in 48+ hours

### Documentation

- **`README.md`** — comprehensive update:
  - Tagline: "AI-Powered Financial Intelligence" → "Self-Evolving Financial Intelligence"
  - Badges: 16 commands → 20 commands; added `self-evolving` badge
  - "Why GPilot?" table: added DCF row and institutional memory row
  - "What's Inside" updated for 20 commands + learning system
  - Hero Feature 1 expanded to show the deal sourcing → IC → DCF pipeline
  - **New Hero Feature 4: Self-Evolving Agent Framework** with three-tier memory table, evolution loop diagram, hook integration explanation, and credit to Karpathy / Hermes / Anthropic Harness inspirations
  - Architecture diagram updated to show learnings/ tier and Stop hook flow
  - "Start Here by Role" updated with `/dcf` for analysts and a new "I'm a System Operator" persona
  - Footer link to CHANGELOG added

- **`output/digests/2026-04-15-fsp-gap-analysis.md`** (new, 16KB) — comprehensive gap analysis comparing GPilot to `anthropics/financial-services-plugins` (4 SKILL.md files + 4 commands), with corrections to earlier framing assumptions
- **`output/digests/_fsp-cache/`** — 10 cached FSP source files for offline reference

### Inspiration sources

This iteration synthesizes patterns from four sources, applied for the first time to investment intelligence:

| Source | What we borrowed |
|--------|------------------|
| **GPilot v0.1** (this project) | Existing agents + skills + wiki + CLAUDE.md scaffolding |
| **Andrej Karpathy — LLM Knowledge Base** | The wiki layer + index/summaries pattern |
| **Nous Research — Hermes** | Agent self-reflection mechanism (learnings layer) |
| **Anthropic Harness blog** | State-as-discipline (`running-jobs.json` for cross-session continuity) |
| **`coleam00/claude-memory-compiler`** | Stop hook pattern for auto-capture (we adapted this for GPilot) |
| **`anthropics/financial-services-plugins`** | DCF skill source material (1,263-line port) |

### Migration notes for existing GPilot users

If you have an existing `.env` and customized installation, no migration steps are required. The new files are additive:

1. Pull the latest changes
2. Restart your Claude Code session — the `Stop` hook will activate automatically on session end
3. Optional: run `/reflect` manually to capture insights from recent work
4. Optional: try `/dcf {company}` on a portfolio company to test the new DCF skill
5. Optional: review `learnings/_daily-log.md` after a few sessions to see the auto-capture in action

The `learnings/` directory and `data/state/{running-jobs,evolution-log}.json` are version-controlled (committed to git) — they represent institutional memory and should sync across machines via your normal git workflow. They contain no sensitive deal data.

### File-level summary

**New files (17)**:
- `learnings/_index.md`, `learnings/_daily-log.md`, `learnings/preferences.md`, `learnings/system.md`, `learnings/deal-sourcer.md`, `learnings/deep-researcher.md`, `learnings/financial-analyst.md`, `learnings/market-researcher.md`, `learnings/portfolio-monitor.md`, `learnings/memo-writer.md`, `learnings/editor.md`, `learnings/translator.md`, `learnings/data-visualizer.md`
- `data/state/running-jobs.json`, `data/state/evolution-log.json`
- `commands/reflect.md`, `commands/review-learnings.md`, `commands/jobs.md`, `commands/dcf.md`
- `skills/valuation-report/references/dcf-construction.md`
- `.claude/settings.json`, `scripts/hooks/auto-reflect.sh`
- `output/digests/2026-04-15-fsp-gap-analysis.md`, `output/digests/_fsp-cache/` (10 cached files)
- `CHANGELOG.md` (this file)

**Modified files (16)**:
- `CLAUDE.md` — Agent Evolution Framework section, directory map, commands table
- `README.md` — comprehensive update for self-evolving framework + DCF
- `data/state/schema.json` — added `running_job_object` and `evolution_log_entry`
- `agents/deal-sourcer.md`, `agents/deep-researcher.md`, `agents/financial-analyst.md`, `agents/market-researcher.md`, `agents/portfolio-monitor.md`, `agents/memo-writer.md`, `agents/editor.md`, `agents/translator.md`, `agents/data-visualizer.md` — Startup Context + Reflection Protocol
- `commands/query.md`, `commands/ingest.md`, `commands/lint-wiki.md`, `commands/ic-memo.md`, `commands/portfolio-review.md` — learnings hooks + DCF wiring
- `scheduled/morning-briefing/SKILL.md` — running-jobs awareness

**Total**: 33 files touched, ~2,500 lines added, ~50 lines modified.

---

## [0.1.0] — Initial release

The original GPilot release with:

- 9 AI agents (deep-researcher, market-researcher, financial-analyst, deal-sourcer, portfolio-monitor, memo-writer, editor, translator, data-visualizer)
- 16 slash commands (research pipeline, deal flow, knowledge base, portfolio ops)
- 7 skill domains (deep research, deal pipeline, editor, portfolio ops, research publication, translator, valuation report)
- 10 scheduled tasks (daily briefings, weekly market notes, deal-flow triage)
- 8 document templates (investment memo, 5 research formats, board deck, agreement)
- Karpathy-pattern wiki knowledge base (`raw/` → `/ingest` → `wiki/` → `/query`)
- JSON SSOT state layer (`data/state/`) with xlsx counterparts
- Bilingual EN↔CN research pipeline
- Next.js portfolio dashboard
- Modules: fund-ops (LP/compliance), extras (11 more scheduled tasks), Feishu integration
