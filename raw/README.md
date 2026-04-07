# raw/ — Source Ingestion Inbox

This is **your domain**. Drop source files here. The LLM never modifies anything in this directory.

Run `/ingest` (or ask Claude to "run the ingest command") to compile new files into the `wiki/`.

## Directory Structure

| Folder | What Goes Here | Examples |
|--------|---------------|----------|
| `deals/` | Term sheets, pitch decks, WeChat deal flow, broker quotes | `acme-robotics-termsheet.md`, `widget-ai-deck.pdf` |
| `research/` | Articles, papers, conference notes, analyst reports | `gtc-2026-notes.md`, `bci-sector-overview.pdf` |
| `market-intel/` | News clips, WeChat forwards, analyst notes, market data | `wechat-ai-funding-clip.md`, `morgan-stanley-bci-tam.pdf` |
| `lp-relations/` | LP communications, meeting notes, commitment letters | `asia-alt-q1-update.md`, `carta-admin-notes.md` |
| `legal/` | Contracts, side letters, SPV docs, regulatory filings | `spv-operating-agreement.docx`, `side-letter-draft.pdf` |
| `meetings/` | Transcripts, meeting notes, voice memo transcriptions | `founder-call-acme-2026-04-01.md` |
| `images/` | Screenshots, charts, diagrams referenced by other raw files | `acme-cap-table.png`, `sector-market-map.jpg` |

## How to Add Files

1. **Drop the file** into the appropriate subfolder
2. **Preferred format**: Markdown (`.md`) — the LLM reads these most easily
3. **Also supported**: `.pdf`, `.docx`, `.xlsx`, `.pptx`, `.png`, `.jpg`, `.csv`, `.txt`
4. **Run ingestion**: Ask Claude to "run ingest" or wait for the daily cron job

### Tips

- **Web articles**: Use the [Obsidian Web Clipper](https://obsidian.md/clipper) extension to save as `.md`
- **Images**: Download related images alongside clipped articles into `images/`
- **WeChat**: Screenshot or copy-paste deal flow messages into a `.md` file in `deals/`
- **Naming**: Use descriptive names: `{company}-{type}-{date}.md` (e.g., `acme-termsheet-2026-04.md`)
- **Chinese content**: Keep original Chinese text — the LLM handles bilingual ingestion

## What Happens Next

When you run `/ingest`, the LLM will:
1. Read each new/modified file
2. Extract key facts, entities, dates, numbers, deal terms
3. Create or update wiki articles in `wiki/`
4. Add backlinks between related articles
5. Update `wiki/_index.md` and `wiki/_summaries.md`
6. Report what changed and flag any contradictions

## Rules

- **Never delete files from raw/** — they are the source of truth
- **The LLM never modifies raw/** — this is a one-way data flow
- **Duplicates are OK** — the LLM deduplicates during compilation
- **Messy is OK** — raw notes, partial info, mixed languages are all fine
