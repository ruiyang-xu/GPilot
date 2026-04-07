# Fund Operations Module

LP reporting, capital calls, compliance, and fund accounting for fund managers.

## What's Included

| Component | Files |
|-----------|-------|
| **Commands** | `/lp-quarterly`, `/capital-call`, `/compliance-check` |
| **Skills** | fund-accounting (fee calcs, NAV), lp-reporting (ILPA, waterfall) |
| **Templates** | Quarterly report, capital call notice, distribution notice |
| **Scheduled** | Fund compliance, monthly accounting, quarterly LP kickoff, quarterly KPI request, GP insight letter |
| **Agent** | legal-reviewer (term sheet + side letter analysis) |
| **Config** | Fund parameters (check sizes, ownership, terms) |
| **Scripts** | refresh-projects.sh (cloud symlink management, macOS) |

## How to Enable

Copy the module contents to the corresponding root directories:

```bash
# From the repo root:
cp -r modules/fund-ops/commands/* commands/
cp -r modules/fund-ops/skills/* skills/
cp -r modules/fund-ops/templates/* templates/
cp -r modules/fund-ops/scheduled/* scheduled/
cp -r modules/fund-ops/agents/* agents/
cp modules/fund-ops/config/* config/
cp modules/fund-ops/scripts/* scripts/
```

Then add the fund-ops commands and agents to your `CLAUDE.md` tables.

## Prerequisites

- Configured fund parameters in `config/fund-parameters.md`
- LP database in `data/state/lps.json` (see `data/state/schema.json` for structure)
- Compliance calendar in `data/state/compliance.json`
