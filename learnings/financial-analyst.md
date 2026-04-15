# Learnings: financial-analyst

> Processing experience accumulated by the financial-analyst agent.
> Read on startup. Append after each task. Never delete — only mark superseded.

## Active Learnings

### 2026-04-15 — DCF terminal value dominates for growth-stage SaaS (Series B+)
- **Context**: Built first end-to-end DCF via `/dcf StellarML` (P1.1 smoke test). Series B SaaS, $18M LTM ARR, 75% growth, still burning at -15% EBIT.
- **Learning**: The FSP skill target of "terminal value 50-70% of EV" is too tight for growth-stage private companies. Near-term FCFs are often negative (investing mode), so explicit-period PV is small or negative, and terminal value ends up 85-95% of EV. In StellarML base case, terminal was 87.7% of EV across all three scenarios (bear 91%, base 88%, bull 90%).
- **Impact**: For Series B-C companies, DCF should be used as a SECONDARY methodology alongside last-round comp or public comps. Flag it explicitly when the GP reads the output — never present as sole methodology. Set `valuation_confidence: Medium` (not High) when running pure DCF for pre-profitable growth-stage.
- **Tags**: #dcf #growth-stage #methodology #terminal-value

### 2026-04-15 — Python/openpyxl not universally available
- **Context**: Tried to run `/dcf` end-to-end on Windows without Python installed. The `xlsx` skill (via openpyxl) requires Python.
- **Learning**: Need a graceful CSV + markdown fallback for environments without Python. Both formats must preserve scenario blocks, FCF build, valuation summary, and sensitivity tables so the user can paste into Excel manually. Document this in `commands/dcf.md` and `skills/valuation-report/references/dcf-construction.md` as "environment fallback" path.
- **Impact**: StellarML test ran successfully end-to-end via Write tool + CSV output. Full state updates worked. Future DCF runs should detect Python availability and route accordingly.
- **Tags**: #tooling #xlsx #windows #fallback

### 2026-04-15 — data/comps/ directory is empty by default
- **Context**: `dcf-construction.md` references `data/comps/{sector}.xlsx` for peer-based validation of growth rates, margins, and exit multiples. In the StellarML test, this directory was empty.
- **Learning**: The DCF skill needs to either (a) ship with seed comp templates for GPilot's 5 focus sectors (SaaS, AI/ML, Fintech, Healthtech, Deeptech), or (b) handle missing comps gracefully by pulling live peer data via Daloopa/Perplexity MCP and asking user to confirm the peer set. For now, the skill should warn "comps directory empty — using synthesized peer benchmarks" rather than silently fabricating.
- **Impact**: Test used synthesized SaaS benchmarks (beta 1.3, EV/Revenue 5-8x) from memory instead of real comps. Production runs should flag this.
- **Tags**: #comps #data-gap #gpilot-config

<!-- New entries appended below with date, context, learning, impact, tags -->

## Superseded Learnings

<!-- Old entries moved here when replaced by newer insights -->
