#!/bin/bash
# GPilot — Demo Mode
# Pre-populates the workspace with sample data so you can explore
# without configuring API keys or real fund data.
# Usage: bash scripts/demo.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║      GPilot — Demo Mode Setup        ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# --- 1. Initialize state files from .example ---
echo "Initializing sample data..."
for f in "$ROOT"/data/state/*.json.example; do
  [ -f "$f" ] || continue
  target="${f%.example}"
  cp "$f" "$target"
  echo "  [ok] $(basename "$target")"
done

for f in "$ROOT"/dashboard/public/*.json.example; do
  [ -f "$f" ] || continue
  target="${f%.example}"
  cp "$f" "$target"
  echo "  [ok] dashboard/public/$(basename "$target")"
done

# --- 2. Create sample wiki articles ---
echo ""
echo "Creating sample wiki articles..."

mkdir -p "$ROOT/wiki/companies" "$ROOT/wiki/sectors" "$ROOT/wiki/deals"

cat > "$ROOT/wiki/companies/quantum-labs.md" <<'WIKI'
---
title: Quantum Labs
tags: [ai, ml, seed, us, portfolio]
updated: 2026-04-07
sources: [data/state/portfolio.json, raw/deals/quantum-labs-termsheet.md]
---

# Quantum Labs

AI model training platform that democratizes access to large-scale compute. Founded 2024 in San Francisco.

## Key Facts
- Founded: 2024
- HQ: San Francisco, CA
- Sector: AI/ML
- Stage: Seed (Portfolio Alpha)
- Last valuation: $30M
- Initial check: $1.5M
- Current MOIC: 2.0x

## Analysis
Quantum Labs addresses the $50B+ AI training compute market. Their distributed training platform reduces costs by 60% vs. hyperscaler pricing. Key risk: competition from Lambda Labs, Together AI, and hyperscaler price cuts.

## Key Metrics
- MRR: $180K (growing 25% MoM)
- Customers: 45 (up from 12 at investment)
- Gross margin: 62%
- Burn rate: $250K/month

## Related
- [[stellarml]] — Similar SaaS AI play in Portfolio Beta
- [[ai-infrastructure]] — Sector analysis
WIKI

cat > "$ROOT/wiki/companies/nexus-health.md" <<'WIKI'
---
title: Nexus Health
tags: [healthtech, series-a, us, portfolio]
updated: 2026-04-07
sources: [data/state/portfolio.json]
---

# Nexus Health

AI-powered clinical decision support for oncology. Series A backed by Portfolio Alpha.

## Key Facts
- Founded: 2023
- HQ: Boston, MA
- Sector: Healthtech
- Stage: Series A (Portfolio Alpha)
- Last valuation: $50M
- Initial check: $3M
- Current MOIC: 1.5x

## Analysis
Nexus Health's platform reduces diagnostic errors by 35% in clinical trials. FDA 510(k) clearance expected Q3 2026. TAM: $12B clinical decision support market. Key risk: regulatory timeline and reimbursement uncertainty.

## Related
- [[quantum-labs]] — Fellow Portfolio Alpha company
WIKI

cat > "$ROOT/wiki/companies/stellarml.md" <<'WIKI'
---
title: StellarML
tags: [saas, series-b, us, portfolio]
updated: 2026-04-07
sources: [data/state/portfolio.json]
---

# StellarML

Enterprise MLOps platform for deploying and monitoring production ML models.

## Key Facts
- Founded: 2022
- HQ: New York, NY
- Sector: SaaS / MLOps
- Stage: Series B (Portfolio Beta)
- Last valuation: $120M
- Initial check: $5M
- Current MOIC: 1.2x

## Analysis
StellarML competes in the $8B MLOps market against Weights & Biases, MLflow, and Datadog ML Monitoring. Key differentiator: unified deployment + monitoring in one platform. ARR: $8.5M, growing 120% YoY. Gross margin: 78%.

## Related
- [[quantum-labs]] — AI infrastructure peer
- [[software]] — Sector analysis
WIKI

cat > "$ROOT/wiki/companies/acme-robotics.md" <<'WIKI'
---
title: Acme Robotics
tags: [ai, ml, series-a, pipeline]
updated: 2026-04-07
sources: [data/state/deals.json]
---

# Acme Robotics

Autonomous warehouse robotics platform combining computer vision with reinforcement learning.

## Key Facts
- Founded: 2023
- HQ: Austin, TX
- Sector: AI/ML (Robotics)
- Stage: Series A (Pipeline — Active DD)
- Asking valuation: $40M
- Proposed check: $3M for 7.5%
- Screening score: 78/100

## Deal Status
- **Status**: Active DD
- **Next action**: Financial model review (due 2026-04-15)
- **Source**: Referral — met at AI conference

## Analysis
Strong founding team (ex-Amazon Robotics). Pilot with 3 Fortune 500 logistics companies. Revenue: $2.1M ARR. TAM: $35B warehouse automation. Key risk: long enterprise sales cycles, competition from established players (Locus, 6 River Systems).

## Related
- [[ai-infrastructure]] — Sector context
WIKI

cat > "$ROOT/wiki/sectors/ai-infrastructure.md" <<'WIKI'
---
title: AI Infrastructure
tags: [sector, ai, compute, infrastructure]
updated: 2026-04-07
sources: [data/comps/Cloud_SaaS_Comps.xlsx]
---

# AI Infrastructure

Sector covering compute, training platforms, inference optimization, and MLOps tooling.

## Market Size
- TAM: $150B by 2027 (Gartner)
- Growth: 35% CAGR
- Key drivers: Enterprise AI adoption, model scaling laws, inference cost reduction

## Portfolio Exposure
- **Quantum Labs** (Seed) — Distributed training compute
- **StellarML** (Series B) — Enterprise MLOps

## Pipeline
- **Acme Robotics** (Series A DD) — Applied AI in logistics

## Key Trends (2026)
1. Inference cost declining 10x/year — enabling new applications
2. Small model fine-tuning replacing large model training
3. Edge AI deployment accelerating in manufacturing and logistics
4. Regulatory frameworks emerging (EU AI Act, US executive orders)

## Comp Models
- See `data/comps/Cloud_SaaS_Comps.xlsx` for public peer multiples
- See `data/comps/AI_ML_Comps.xlsx` for AI-specific comparables

## Related
- [[quantum-labs]] — Portfolio company
- [[stellarml]] — Portfolio company
- [[acme-robotics]] — Pipeline deal
WIKI

cat > "$ROOT/wiki/deals/active-pipeline.md" <<'WIKI'
---
title: Active Pipeline
tags: [pipeline, deals]
updated: 2026-04-07
sources: [data/state/deals.json]
---

# Active Deal Pipeline

## Active DD (1)
| Company | Sector | Stage | Score | Next Action |
|---------|--------|-------|-------|-------------|
| [[acme-robotics]] | AI/ML | Series A | 78 | Financial model review (Apr 15) |

## Screening (1)
| Company | Sector | Stage | Score | Next Action |
|---------|--------|-------|-------|-------------|
| Widget AI | SaaS | Seed | 65 | First call with founders (Apr 10) |

## Passed (1)
| Company | Sector | Stage | Score | Reason |
|---------|--------|-------|-------|--------|
| DataFlow Systems | Infrastructure | Series B | 45 | Valuation too high for growth metrics |
WIKI

# --- 3. Update wiki index ---
cat > "$ROOT/wiki/_index.md" <<'WIKI'
# Wiki Index

> LLM-compiled knowledge graph. Auto-maintained by `/ingest`.
> Demo mode: 4 company articles, 1 sector article, 1 pipeline overview.

## Companies (4)

| Company | Sector | Status | Updated |
|---------|--------|--------|---------|
| [[quantum-labs]] | AI/ML | Portfolio (Seed) | 2026-04-07 |
| [[nexus-health]] | Healthtech | Portfolio (Series A) | 2026-04-07 |
| [[stellarml]] | SaaS | Portfolio (Series B) | 2026-04-07 |
| [[acme-robotics]] | AI/ML | Pipeline (Active DD) | 2026-04-07 |

## Sectors (1)

- [[ai-infrastructure]] — Compute, training, MLOps ($150B TAM)

## Deals

- [[active-pipeline]] — 1 active DD, 1 screening, 1 passed
WIKI

cat > "$ROOT/wiki/_summaries.md" <<'WIKI'
# Document Summaries

> 2-3 line summary of every wiki article.

## companies/quantum-labs.md
AI model training platform, Seed stage in Portfolio Alpha. $30M valuation, 2.0x MOIC. $180K MRR growing 25% MoM.

## companies/nexus-health.md
AI clinical decision support for oncology, Series A in Portfolio Alpha. $50M valuation, 1.5x MOIC. FDA clearance expected Q3 2026.

## companies/stellarml.md
Enterprise MLOps platform, Series B in Portfolio Beta. $120M valuation, 1.2x MOIC. $8.5M ARR growing 120% YoY.

## companies/acme-robotics.md
Autonomous warehouse robotics, Series A pipeline (Active DD). Asking $40M, proposed $3M check. Score: 78/100.

## sectors/ai-infrastructure.md
AI compute, training, and MLOps sector. $150B TAM by 2027, 35% CAGR. Portfolio has 2 companies + 1 pipeline deal.

## deals/active-pipeline.md
3 deals: 1 active DD (Acme Robotics), 1 screening (Widget AI), 1 passed (DataFlow Systems).
WIKI

# --- 4. Create sample deal folder ---
echo "Creating sample deal folder..."
mkdir -p "$ROOT/deals/acme-robotics"
cat > "$ROOT/deals/acme-robotics/notes.md" <<'NOTES'
# Acme Robotics — Deal Notes

## Meeting Notes (2026-04-01)
- Met founders at AI Infrastructure Conference
- CEO: ex-Amazon Robotics (8 years), CTO: ex-Google Brain
- Piloting with 3 Fortune 500 logistics companies
- Revenue: $2.1M ARR, growing 180% YoY
- Asking $40M pre-money, $10M round, lead needed

## Key Questions for DD
- [ ] Unit economics per warehouse deployment
- [ ] Customer pipeline beyond current 3 pilots
- [ ] IP defensibility vs. open-source robotics frameworks
- [ ] Founder reference checks
- [ ] Financial model review (due April 15)

## GP Notes
Good founding team. Valuation feels rich for Seed-to-A, but the Fortune 500 pilots are strong signals. Need to validate unit economics before IC.
NOTES

echo "  [ok] deals/acme-robotics/"

# --- 5. Create sample raw file ---
echo "Creating sample source file..."
mkdir -p "$ROOT/raw/deals"
cat > "$ROOT/raw/deals/acme-robotics-termsheet.md" <<'RAW'
# Acme Robotics — Series A Term Sheet Summary

**Date**: March 28, 2026
**Company**: Acme Robotics, Inc. (Delaware C-Corp)
**Round**: Series A
**Pre-money valuation**: $40,000,000
**Round size**: $10,000,000
**Lead investor**: TBD (seeking)
**Structure**: Series A Preferred Stock

## Key Terms
- 1x non-participating liquidation preference
- Pro-rata rights for investors >$1M
- Board: 2 founders + 1 lead investor + 1 independent
- Standard protective provisions
- Full ratchet anti-dilution (NOTE: non-standard — typical is weighted average)

## Use of Proceeds
- 60% R&D (expand robotics team from 8 to 20)
- 25% Sales (hire 3 enterprise sales reps)
- 15% G&A
RAW

echo "  [ok] raw/deals/acme-robotics-termsheet.md"

# --- Done ---
echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║         Demo Mode Ready!             ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  Sample data loaded:"
echo "    - 3 portfolio companies (wiki + JSON)"
echo "    - 1 pipeline deal with notes + term sheet"
echo "    - 1 sector analysis article"
echo "    - Deal pipeline overview"
echo ""
echo "  Try these in Claude Code:"
echo ""
echo "    /query \"Tell me about Quantum Labs\""
echo "    /query \"Compare our AI portfolio companies\""
echo "    /deal-screen     (screen Acme Robotics)"
echo "    /ingest           (process the sample term sheet)"
echo "    /lint-wiki        (check wiki health)"
echo ""
echo "  Dashboard:"
echo "    cd dashboard && npm install && npm run dev"
echo ""
