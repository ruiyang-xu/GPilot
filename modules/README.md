# Modules

GPilot uses a modular architecture. Core functionality (research, deal sourcing, portfolio analysis, valuations) lives in the root directories. Specialized functionality lives here in `modules/`.

## Available Modules

### fund-ops/
**For fund managers**: LP reporting, capital calls, compliance, fund accounting.

Enable by copying contents to the corresponding root directories:
```bash
# Enable fund-ops module
cp -r modules/fund-ops/commands/* commands/
cp -r modules/fund-ops/skills/* skills/
cp -r modules/fund-ops/templates/* templates/
cp -r modules/fund-ops/scheduled/* scheduled/
cp -r modules/fund-ops/agents/* agents/
cp modules/fund-ops/scripts/* scripts/
```

Includes:
- **Commands**: `/lp-quarterly`, `/capital-call`, `/compliance-check`
- **Skills**: fund-accounting (fee calcs, NAV), lp-reporting (ILPA standards)
- **Templates**: quarterly report, capital call notice, distribution notice
- **Scheduled tasks**: fund compliance, monthly accounting, quarterly LP kickoff/KPI
- **Agent**: legal-reviewer (term sheet and side letter analysis)
- **Config**: fund parameters (check sizes, ownership targets, terms)

### extras/
**Optional scheduled tasks**: Additional automation for power users.

- daily-briefing, daily-market-data, earnings-alert
- market-pulse-cn-wechat, market-pulse-en-linkedin, weekly-public-roundup
- company-teardown, sector-deep-dive, weekly-portfolio
- engagement-tracker, market-pulse-research

### integrations/
**Platform-specific integrations**: Feishu/Lark configuration.

### docs/
**Planning documents**: Fund setup plans, research platform architecture, Notion orchestration blueprint.
