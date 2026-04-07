---
name: sync
description: Unified data sync — extract portfolio from reports, sync with projects, regenerate SSOT and dashboard
---

Run the complete data sync pipeline. This is the single command to keep all portfolio data in sync.

## Pipeline Steps

### Step 1: Reconcile portfolio data
Read `data/state/portfolio.json` and reconcile with any new data from:
- Valuation reports in `raw/lp-relations/Valuation Reports/` (if present)
- Deal files in `raw/deals/`
- Cloud project folders in `projects/Invested/`

Update `data/state/portfolio.json` with any new or changed entries.

### Step 2: Copy to dashboard
The scripts already sync `dashboard/public/portfolio.json` automatically. Verify it matches:

```bash
diff data/state/portfolio.json dashboard/public/portfolio.json
```

### Step 3: Report
Print summary:
- Total companies by portfolio
- Data completeness (fields with <80% coverage)
- Companies added/removed since last sync
- Any data quality warnings

## When to Run

- After dropping new valuation reports into `raw/lp-relations/Valuation Reports/`
- After adding new project folders to `projects/Invested/`
- Before deploying the dashboard to Vercel
- Weekly as part of data hygiene

## Notes

- The pipeline is idempotent — safe to run multiple times
- Deduplication is handled during reconciliation
