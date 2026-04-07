# Getting Started

Step-by-step guide to set up your GPilot.

---

## Prerequisites

| Requirement | Version | Required? |
|-------------|---------|-----------|
| [Claude Code](https://claude.ai/claude-code) | Latest | Yes |
| [Node.js](https://nodejs.org) | 18+ | For dashboard only |
| [Git](https://git-scm.com) | Any | Yes |
| Bash / Zsh | Any | For setup scripts |

### API Keys

| Service | Purpose | How to Get |
|---------|---------|-----------|
| **Perplexity AI** | Deep research agent | [perplexity.ai/settings/api](https://perplexity.ai/settings/api) |
| Google Calendar (MCP) | Calendar integration | Configure in Claude Code MCP settings |
| Gmail (MCP) | Email drafting | Configure in Claude Code MCP settings |
| Feishu / Lark | Chinese collaboration | [open.feishu.cn](https://open.feishu.cn) |

Only Perplexity is required. Other services are optional and unlock additional features.

---

## Step 1: Fork & Clone

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR_USERNAME/solo-gp-os.git
cd solo-gp-os
```

---

## Step 2: Configure Your Environment

```bash
cp .env.example .env
```

Open `.env` and fill in at minimum:

```bash
USER_NAME="Jane Smith"
USER_INITIALS="JS"
ORG_NAME="Horizon Capital"
PERPLEXITY_API_KEY="your-perplexity-api-key"
```

---

## Step 3: Run Customization

```bash
bash scripts/customize.sh
```

This replaces all placeholder values across the workspace with your fund details. It edits:
- `CLAUDE.md` (system brain)
- `config/feishu-link.md` (Feishu integration)
- `config/mcp.json` (API keys)
- `dashboard/` (fund names in UI)
- `scripts/refresh-projects.sh` (cloud paths)

---

## Step 4: Link Global Config

```bash
bash scripts/setup.sh
```

This creates symlinks from `config/global/` to your `~/.claude/` directory, so Claude Code loads the fund's global rules in every session.

---

## Step 5: Open in Claude Code

Launch Claude Code and open the workspace directory. CLAUDE.md is automatically loaded as the system configuration.

### Try Your First Commands

**Ask a question:**
```
/query "What are the key trends in AI infrastructure for 2026?"
```

**Screen a new deal:**
```
/deal-screen
```
The system will ask you for deal details and run a structured screening.

**Start a research piece:**
```
/research
```
Choose a research type (Market Note, Company Teardown, GP Letter, etc.) and the agents will guide you through the full workflow.

**Generate a weekly digest:**
```
/weekly-digest
```

---

## Step 6: Launch Dashboard (Optional)

```bash
cd dashboard
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to see your portfolio dashboard. It reads from `data/state/portfolio.json` (sample data is included).

---

## Understanding the Knowledge Base

The system uses a wiki-based knowledge graph pattern:

### Adding Knowledge
1. Drop files into `raw/` (term sheets, articles, transcripts, etc.)
2. Run `/ingest` — the LLM reads and compiles them into `wiki/` articles
3. Run `/query "question"` — research against the wiki, answers are saved

### The Compounding Effect
- Week 1: 5 company articles
- Month 1: Cross-sector comparisons emerge
- Month 3: Automatic pattern recognition across your deal flow history

### Maintenance
- `/lint-wiki` — Weekly health check (stale data, broken links)
- `/compile` — Full rebuild (expensive, use sparingly)

---

## Setting Up Scheduled Tasks

The system includes 26 pre-built scheduled tasks. To enable them:

1. Open Claude Code
2. Each task is defined in `scheduled/{task-name}/SKILL.md`
3. Use Claude Code's scheduling feature to activate them

### Recommended Starting Set

| Task | Schedule | What it Does |
|------|----------|-------------|
| `morning-briefing` | Daily 8:00 AM | Market news + calendar + tasks summary |
| `daily-email-summary` | Daily 9:00 AM | Gmail inbox highlights |
| `weekly-pipeline` | Monday 9:00 AM | Deal pipeline status review |
| `weekly-portfolio` | Friday 4:00 PM | Portfolio company news check |
| `market-pulse-research` | Monday 10:00 AM | Start weekly market note research |

---

## MCP Configuration

Model Context Protocol (MCP) servers extend Claude Code's capabilities. Configure them in Claude Code's settings:

### Required MCP

```json
{
  "perplexity": {
    "command": "npx",
    "args": ["-y", "@perplexity-ai/mcp-server"],
    "env": {
      "PERPLEXITY_API_KEY": "your-key-here"
    }
  }
}
```

### Optional MCPs

| MCP | What it Enables |
|-----|----------------|
| Google Calendar | Meeting scheduling, availability checks, agenda queries |
| Gmail | Email search, thread reading, draft creation |
| Google Drive | Access cloud-stored deal documents |
| Notion | Cross-surface task routing, research pipeline tracking |
| Box | Alternative cloud document storage |
| Vercel | Deploy and manage the fund dashboard |

---

## Platform-Specific Notes

### macOS (recommended)
- Full symlink support for cloud storage integration
- Run `scripts/refresh-projects.sh` to link OneDrive/GDrive folders
- Weekly cron: `crontab -e` → `43 7 * * 1 /path/to/scripts/refresh-projects.sh`

### Linux
- Symlinks to cloud storage are not available
- Use Google Drive MCP or Box MCP to access cloud files
- All other features work normally

### Windows
- Use WSL (Windows Subsystem for Linux) or Git Bash for scripts
- No native symlink support — use MCP tools for cloud access
- Dashboard works natively: `cd dashboard && npm run dev`

---

## Troubleshooting

### "Command not found" when running slash commands
Make sure you're inside the workspace directory in Claude Code. CLAUDE.md must be in the root for commands to be recognized.

### Dashboard shows empty data
Check that `data/state/portfolio.json` exists and contains valid JSON. The sample data should work out of the box.

### Perplexity research agent fails
Verify your API key in `config/mcp.json` (or `.env` if you haven't run `customize.sh` yet). Test with: `/query "test"`

### Scheduled tasks not running
Tasks must be explicitly enabled in Claude Code's scheduling interface. Check `scheduled/{task}/SKILL.md` for the cron expression and verify it's set up correctly.

### Symlinks broken on fresh machine
Run `bash scripts/refresh-projects.sh` after configuring cloud storage paths in `.env`.

---

## Next Steps

1. **Customize `CLAUDE.md`** — Fill in your fund parameters, sectors, and investment terms
2. **Populate `raw/`** — Drop your first source files and run `/ingest`
3. **Screen a deal** — Try `/deal-screen` with a real opportunity
4. **Publish research** — Use `/research` to write your first market note
5. **Set up scheduled tasks** — Enable morning briefings and weekly digests
