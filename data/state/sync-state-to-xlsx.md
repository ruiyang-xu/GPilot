# sync-state-to-xlsx — JSON to Excel State Export

## Purpose

This command regenerates Excel workbooks in `../data/` from the canonical JSON state files in `./`. It creates human-readable, updatable Excel views that stay synchronized with the machine-readable JSON source.

## Scope

- **Input**: JSON state files (`state/*.json`)
- **Output**: Excel workbooks (`data/*.xlsx`)
- **Triggers**: On-demand command, scheduled daily, or after major state updates
- **Scope**: Full file generation (not incremental updates)

## File Mappings

### 1. deals.json → data/deal-tracker.xlsx

**Sheet**: "Deal Pipeline"

| Column | Source Field | Type | Notes |
|--------|--------------|------|-------|
| Deal ID | deal_id | String | Unique identifier |
| Company | company | String | Company name |
| Sector | sector | String | Enum: SaaS, AI/ML, Fintech, Healthtech, Deeptech, Infrastructure, Semiconductors, Other |
| Stage | stage | String | Enum: Pre-seed, Seed, Series A/B/C/D, Series E+, Growth, Public |
| Status | status | String | Enum: Sourced, Screening, DD, Term Sheet, Invested, Passed, Archived |
| Score | score | Number | 0-100 |
| Entry Valuation (USD M) | entry_valuation_usd | Number | Millions USD |
| Check Size (USD M) | check_size_usd | Number | Millions USD |
| Ownership % | check_size_pct_ownership | Percentage | Target ownership % |
| Source | source | String | Enum: Outbound, Inbound, Warm intro, Accelerator, Secondary, Other |
| Assignee | assignee | String | Team member |
| Screened Date | screened_date | Date | YYYY-MM-DD |
| Next Action | next_action | String | Free text |
| Next Action Date | next_action_date | Date | YYYY-MM-DD |
| Notes Path | notes_path | String | Path to markdown notes |
| Created Date | created_date | Date | YYYY-MM-DD |
| Last Updated | last_updated | DateTime | ISO 8601 |

**Sorting**: Default by Status (Sourced first), then by Last Updated (newest first)
**Filtering**: Auto-filter enabled on all columns
**Formulas**: None (display only)

### 2. portfolio.json → data/portfolio-dashboard.xlsx

**Sheet 1: "Portfolio Companies"**

| Column | Source Field | Type | Notes |
|--------|--------------|------|-------|
| Portfolio ID | portfolio_id | String | Unique identifier |
| Company | company | String | Company name |
| Entity Name | entity_name | String | Legal name |
| Sector | sector | String | Enum |
| Stage at Investment | stage_at_investment | String | Enum |
| Initial Investment Date | initial_investment_date | Date | YYYY-MM-DD |
| Initial Check (USD M) | initial_check_usd | Number | Millions |
| Initial Ownership % | initial_ownership_pct | Percentage | % |
| Current Valuation (USD M) | current_valuation_usd | Number | Post-money millions |
| Valuation Source | valuation_source | String | DCF, Comps, 409A, Recent round, etc. |
| Valuation Confidence | valuation_confidence | String | High, Medium, Low |
| Last Valuation Date | last_valuation_date | Date | YYYY-MM-DD |
| Last KPI Update Date | last_kpi_update_date | Date | YYYY-MM-DD |
| Board Seat | board_seat | Boolean | Yes/No |
| Next Board Date | next_board_date | Date | YYYY-MM-DD |
| Runway (Months) | runway_months | Number | Months |
| Status | status | String | Active, Follow-on, Monitoring, Exiting, Exited |
| Health Score | health_score | Integer | 1-10 |
| Key Risks | key_risks | String | Pipe-separated list |
| Notes Path | notes_path | String | Path |
| Last Updated | last_updated | DateTime | ISO 8601 |

**Sheet 2: "Portfolio Summary"**

Summary statistics calculated from portfolio.json:
- Total companies
- By stage (breakdown)
- By sector (breakdown)
- By status (Active, Follow-on, Monitoring, Exiting, Exited)
- Average health score
- Number with board seats
- Total follow-on commitment needed (if tracked)

**Sorting**: By Status (Active first), then by Health Score (highest first)
**Formulas**: Allowed in Summary sheet only

### 3. research.json → data/research-tracker.xlsx

**Sheet 1: "Research Pipeline"**

| Column | Source Field | Type | Notes |
|--------|--------------|------|-------|
| Research ID | research_id | String | Unique identifier |
| Slug | slug | String | URL slug |
| Type | type | String | Market Note, Company Teardown, GP Letter, Thematic Research, Sector Deep Dive |
| Title EN | title_en | String | English title |
| Title CN | title_cn | String | Chinese title |
| Status | status | String | Idea, Researching, Outlining, Drafting, Review, Translating, FinalReview, Ready, Published |
| Priority | priority | String | Low, Medium, High |
| Assigned To | assigned_to | String | Author |
| EN Path | en_path | String | Path to English draft |
| CN Path | cn_path | String | Path to Chinese version |
| WeChat URL | wechat_url | Hyperlink | Published WeChat link |
| LinkedIn URL | linkedin_url | Hyperlink | Published LinkedIn link |
| Target Publish Date | target_publish_date | Date | YYYY-MM-DD |
| Idea Date | idea_date | Date | When idea created |
| Published Date | published_date | Date | When published |
| Published By | published_by | String | Approver |
| Notes | notes | String | Internal notes |
| Last Updated | last_updated | DateTime | ISO 8601 |

**Sheet 2: "Engagement Metrics"**

| Column | Source Field | Type | Notes |
|--------|--------------|------|-------|
| Research ID | research_id | String | Link to Pipeline |
| Title | title_en | String | For reference |
| Type | type | String | For reference |
| Published Date | published_date | Date | For reference |
| WeChat Views | engagement_wechat_views | Number | Count |
| WeChat Likes | engagement_wechat_likes | Number | Count |
| LinkedIn Views | engagement_linkedin_views | Number | Count |
| LinkedIn Likes | engagement_linkedin_likes | Number | Count |
| LinkedIn Shares | engagement_linkedin_shares | Number | Count |

**Sheet 3: "Calendar"**

Calendar view of publication dates. Display type depends on Excel version:
- **Modern Excel**: Table with columns [Date, Type, Title, Status]
- **Fallback**: Formatted list sorted by target_publish_date

**Sorting**: By Status (Draft first to flag urgent), then by Target Publish Date
**Formulas**: In Engagement Metrics sheet only (sums, averages)

### 4. lps.json → data/lp-database.xlsx

**Sheet 1: "LP Directory"**

| Column | Source Field | Type | Notes |
|--------|--------------|------|-------|
| LP ID | lp_id | String | Unique ID |
| Name | name | String | LP name (anonymized if needed) |
| Entity Type | entity_type | String | Individual, Fund, Family Office, Corporate, University, Other |
| Commitment (USD M) | commitment_usd | Number | Total commitment |
| Called to Date (USD M) | called_usd | Number | Amount called |
| Called % | called_pct | Percentage | % called |
| Last Communication Date | last_communication_date | Date | YYYY-MM-DD |
| Last Communication Type | last_communication_type | String | Email, Call, Board meeting, etc. |
| Email | email | String | Primary contact |
| Phone | phone | String | Contact phone |
| Secondary Contact Name | secondary_contact_name | String | Backup contact |
| Secondary Contact Email | secondary_contact_email | String | Backup email |
| Status | status | String | Active, Inactive, Under review |
| Location | location_country | String | Country |
| Notes | notes | String | Internal notes |
| Last Updated | last_updated | DateTime | ISO 8601 |

**Sheet 2: "LP Summary"**

Summary statistics:
- Total committed capital (USD M)
- Total called capital (USD M)
- Average called %
- By entity type (breakdown)
- By status (Active, Inactive, etc.)
- Number of active LPs

**Sorting**: By Commitment descending (largest LPs first)
**Formulas**: In Summary sheet only (sums, percentages)

### 5. compliance.json → data/compliance-calendar.xlsx

**Sheet 1: "Compliance Calendar"**

| Column | Source Field | Type | Notes |
|--------|--------------|------|-------|
| Compliance ID | compliance_id | String | Unique ID |
| Item | item | String | Compliance item name |
| Category | category | String | SEC, State, Fund, Tax, LP, Other |
| Deadline | deadline | Date | YYYY-MM-DD |
| Days Until Due | days_until_due | Number | Auto-calculated (deadline - today) |
| Status | status | String | Not started, In progress, Complete, Overdue |
| Owner | owner | String | Responsible party |
| Filing Ref | filing_ref | String | Reference document |
| Notes | notes | String | Details or escalation |
| Completed Date | completed_date | Date | YYYY-MM-DD (if done) |
| Last Updated | last_updated | DateTime | ISO 8601 |

**Sheet 2: "Overdue Alert"**

Auto-populated view of items where:
- Status = "Overdue" (deadline < today)
- OR Status = "In progress" AND days_until_due < 7

Columns: Item, Category, Deadline, Days Overdue, Owner, Notes

**Conditional Formatting**:
- Overdue items (Days Until Due < 0): Red background
- Due within 7 days: Yellow background
- Status = "Complete": Green background

**Sorting**: By Days Until Due ascending (most urgent first)

### 6. public_holdings.json → data/public-companies.xlsx

**Sheet 1: "Holdings"**

| Column | Source Field | Type | Notes |
|--------|--------------|------|-------|
| Position ID | position_id | String | Unique ID |
| Ticker | ticker | String | Stock symbol |
| Company | company | String | Company name |
| Sector | sector | String | Enum |
| Position Type | position_type | String | Held, Monitored, Peer comp |
| Shares Held | shares_held | Number | Count (if held) |
| Cost Basis / Share | cost_basis_per_share | Currency | USD |
| Current Price | current_price | Currency | USD |
| Price Update Date | price_update_date | Date | YYYY-MM-DD |
| Market Cap (USD B) | market_cap_usd | Number | Billions |
| Earnings Date | earnings_date | Date | Next announcement |
| Latest EPS | latest_eps | Currency | USD |
| P/E Ratio | pe_ratio | Number | Ratio |
| Dividend Yield % | dividend_yield_pct | Percentage | % |
| Notes | notes | String | Research notes |
| Last Updated | last_updated | DateTime | ISO 8601 |

**Sheet 2: "Peer Comps"**

Filtered view showing only position_type = "Peer comp":
Columns: Ticker, Company, Sector, Market Cap, P/E Ratio, Dividend Yield %, Latest EPS

**Sheet 3: "Price History" (optional)**

If enhanced tracking desired:
- Columns: Ticker, Date, Price
- Data: Time-series of price updates
- Can be created manually or with scheduled data pulls

**Sorting**: By Position Type (Held first), then by Market Cap descending
**Formulas**: Gains/losses calculated in Holdings sheet if shares_held populated

### 7. watchlist.json → data/watchlist.xlsx

**Sheet 1: "Company Watchlist"**

| Column | Source Field | Type | Notes |
|--------|--------------|------|-------|
| Watchlist ID | watchlist_id | String | Unique ID |
| Company | company | String | Company name |
| Website | website | Hyperlink | URL |
| Sector | sector | String | Enum |
| Stage Estimated | stage_estimated | String | Enum + Unknown |
| Reason | reason | String | Sector peer, Pipeline target, Competitor, Market trend, Portfolio monitoring, Other |
| Added Date | added_date | Date | YYYY-MM-DD |
| Last Checked Date | last_checked_date | Date | YYYY-MM-DD |
| Days Since Check | [calculated] | Number | today - last_checked_date |
| Key Metrics Tracked | key_metrics_tracked | String | Comma-separated |
| Notes | notes | String | Latest observations |
| Last Updated | last_updated | DateTime | ISO 8601 |

**Sheet 2: "By Reason"**

Pivot-style breakdown:
- Sector peer: Count + list of companies
- Pipeline target: Count + list
- Competitive threat: Count + list
- Market trend: Count + list
- Portfolio monitoring: Count + list

**Sheet 3: "Stale Checks"**

View showing watchlist items where last_checked_date > 30 days ago (flagged for review)
Columns: Company, Sector, Last Checked Date, Days Since Check, Notes

**Sorting**: By Added Date descending (newest first), or by Reason then Last Checked (in Stale Checks)
**Formulas**: In summary sheets only

## Implementation Notes

### Excel Format Specifications
- **Sheet tabs**: Use names exactly as specified above
- **Font**: Calibri, 11pt (default)
- **Header row**: Bold, light gray background (#D3D3D3)
- **Column width**: Auto-fit to content, minimum 12 characters
- **Date format**: MM/DD/YYYY (US locale) or YYYY-MM-DD (ISO, user preference)
- **Currency format**: USD with 2 decimals, thousands separator
- **Percentages**: Display as XX.X%

### Hyperlinks
- `wechat_url`, `linkedin_url`, `website`: Convert to blue underlined hyperlinks
- Preserve original URLs in cell content

### Auto-Filters
- Enable auto-filter on header rows in:
  - Deal Pipeline (all columns)
  - Portfolio Companies (all columns)
  - Research Pipeline (all columns)
  - LP Directory (all columns)
  - Compliance Calendar (all columns)
  - Holdings (all columns)
  - Company Watchlist (all columns)

### Data Validation
- **Status columns**: Dropdown lists matching enum values
- **Date columns**: Date picker or format enforcement
- **Percentage columns**: Constrain to 0-100% range

### Summary Sheets
- Use formulas sparingly (COUNTIF, SUM, AVERAGE only)
- Keep calculations simple and auditable
- Do not reference external workbooks

### Formulas Not Allowed
- No complex calculations
- No VLOOKUP or INDEX/MATCH across sheets
- No external data pulls (use state.json as input only)

## Workflow

### Trigger Points

1. **On-demand**: User runs `/sync-state-to-xlsx` command
2. **Scheduled**: Daily sync at 11:00 PM (after end-of-day updates)
3. **Post-command**: After major data-changing commands (e.g., `/portfolio-review`, `/deal-screen`)

### Process

1. **Validate JSON**: Check all state/*.json files against schema.json
   - If validation fails, abort and report errors
2. **Load JSON**: Read all state files into memory
3. **Generate workbooks**: Create/overwrite each xlsx file in data/
4. **Apply formatting**: Apply fonts, colors, column widths, auto-filters
5. **Save workbooks**: Write to disk, preserve file timestamps if unchanged
6. **Log and report**: Summary of what was synced (e.g., "50 deals, 8 portfolio, 12 research pieces")
7. **Optional commit**: Git commit with message "Sync state to xlsx" (if user approves)

### Excel Library

Recommend using Python with `openpyxl` library:
```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill
import json

# Load state.json
with open('state/deals.json') as f:
    deals = json.load(f)

# Create workbook
wb = Workbook()
ws = wb.active
ws.title = "Deal Pipeline"

# Write headers
headers = ["Deal ID", "Company", "Sector", ...]
ws.append(headers)

# Apply formatting
for cell in ws[1]:
    cell.font = Font(bold=True)
    cell.fill = PatternFill(start_color="D3D3D3", fill_type="solid")

# Write data rows
for deal in deals:
    ws.append([deal['deal_id'], deal['company'], deal['sector'], ...])

# Save
wb.save('data/deal-tracker.xlsx')
```

## Error Handling

| Scenario | Action |
|----------|--------|
| JSON file missing | Log warning, skip that file |
| JSON validation error | Log error, stop sync, report which file/fields |
| Duplicate IDs in JSON | Log warning, use first occurrence |
| Invalid date format | Coerce to YYYY-MM-DD or log error |
| NULL values in JSON | Display as blank in Excel |
| Formula errors | Do not write formula, display raw value instead |

## Rollback

If xlsx workbooks become corrupted or out-of-sync:
1. Delete corrupted .xlsx file(s)
2. Run `/sync-state-to-xlsx` command to regenerate from JSON
3. JSON is the source of truth; xlsx can always be recreated

## Future Enhancements

- [ ] Add pivot tables to summary sheets (Excel 2016+)
- [ ] Color-code rows by status or health score
- [ ] Add chart/graph dashboards (portfolio mix, research cadence)
- [ ] Enable two-way sync (detect Excel changes, merge back to JSON with diff)
- [ ] Scheduled data refreshes (e.g., public market prices daily at 9 AM)
- [ ] Export to CSV for versioning in git (more git-friendly than xlsx binary)
