---
name: jobs
description: List, resume, or clean up multi-session running jobs
---

Manage jobs that span multiple sessions. $ARGUMENTS

## Usage

- `/jobs` — List all running jobs with status
- `/jobs resume {job_id}` — Resume a specific job from where it left off
- `/jobs abandon {job_id}` — Mark a job as abandoned
- `/jobs clean` — Archive completed/abandoned jobs older than 7 days

## Process

### List (default)

Read `data/state/running-jobs.json` and display:

| # | Job ID | Title | Agent | Status | Progress | Last Activity | Blocking |
|---|--------|-------|-------|--------|----------|--------------|----------|

Highlight:
- Jobs with no activity in 48+ hours (may be stale)
- Jobs in "blocked" or "waiting_input" status (need attention)
- Jobs at 90%+ progress (close to completion)

### Resume

1. Load the specified job from `data/state/running-jobs.json`
2. Read its `context_files` to restore context
3. Display the job's `current_step` and `notes`
4. Resume execution from `current_step`
5. Update `last_activity` timestamp

### Abandon

1. Set job status to "abandoned"
2. Add `abandoned_date` and `abandoned_reason` (ask user for reason)
3. Update `data/state/running-jobs.json`

### Clean

1. Find jobs with status "completed" or "abandoned" that are older than 7 days
2. Move them to `data/state/archived-jobs.json` (create if doesn't exist)
3. Remove from `data/state/running-jobs.json`
4. Report: N jobs archived, N remaining active

## Job Registration

Commands that may span sessions should register a job when they start:

```json
{
  "job_id": "job-{type}-{slug}-{YYYYMMDD}",
  "type": "{research|deal-screen|sourcing|...}",
  "title": "{human-readable title}",
  "agent": "{primary agent}",
  "status": "in_progress",
  "started_date": "{ISO 8601}",
  "last_activity": "{ISO 8601}",
  "progress_pct": 0,
  "current_step": "Step 1: ...",
  "output_path": "{where outputs go}",
  "blocking_on": null,
  "notes": "",
  "context_files": []
}
```

Multi-step commands that should register jobs: `/research`, `/research-fast-track`, `/source-deals`, `/deal-screen`, `/ic-memo`, `/portfolio-review`, `/ingest --full`.
