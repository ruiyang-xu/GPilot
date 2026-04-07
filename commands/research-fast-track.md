# research-fast-track

**Name**: research-fast-track
**Description**: Fast-track workflow for routine publications (Market Note, GP Letter) — skips outline approval gate for pre-approved monthly topics.

---

## Overview

`research-fast-track` is a streamlined version of the full `/research` command. It bypasses the outline approval step, enabling rapid publication of routine Market Notes and GP Letters while maintaining quality and the GP's final approval authority.

**Key Difference from `/research`**: No outline pause. Pre-approved topics act as outline pre-approval.

**When to Use**:
- Weekly/monthly Market Notes on approved themes
- Monthly GP Letters on approved topics
- Routine publications with well-defined scope

**When NOT to Use**:
- Sector Deep Dives (use full `/research` — complex, requires outline review)
- Company Teardowns (use full `/research` — deep research, outline critical)
- New research types not yet pre-approved by the GP

---

## Prerequisites

1. **Topic Pre-Approval**: the GP has pre-approved a monthly list of topics (Market Note themes, GP Letter subjects).
   - Stored in: `/Fund/data/research-tracker.xlsx` or Notion Research Pipeline database
   - Format: Topic name, Type (Market Note / GP Letter), Approved Y/N

2. **Topic Must Be on Approved List**: Before starting, verify that your topic is listed and marked "Approved: Y".

3. **Quality Standards Match Full `/research`**: Editorial review, translation, and final the GP approval all have the same rigor as full research.

---

## Workflow (6 Steps)

### Step 1: Research Brief (Auto-Generated)

**Input**: Approved topic from research-tracker
**Action**: Claude Code generates a research brief
- Topic scope and key questions
- Data sources to consult
- Outline structure (pre-approved via topic)
- Tone and style guidelines (market notes: professional + concise; GP letters: strategic + narrative)

**Output**: Research brief (markdown or text)
**Update Notion**: Research Pipeline database → Status = "Researching"

**Duration**: 15–30 minutes (mostly auto-generated)

### Step 2: Deep Research

**Input**: Research brief, approved topic outline
**Action**: Execute deep research using the deep-researcher skill
- Perplexity deep research for market notes (current data, trends)
- Multi-source research for GP letters (strategic insights, long-form thinking)
- Source tracking and citations

**Output**: Research findings (structured notes, data, quotes)
**Update Notion**: Status = "Researching" (still in progress)

**Duration**: 1–3 hours (depends on topic complexity)

### Step 3: Draft EN + CN (In Sequence, No Pause)

**Input**: Research findings, approved outline
**Action**:
1. Write English draft (based on approved outline, research findings)
   - Market Note: 800–1200 words, 3–4 sections
   - GP Letter: 1500–2500 words, 5–7 sections
   - Include citations and source attribution

2. Immediately translate to Chinese (no outline approval pause here)
   - Maintain tone and structure
   - Adapt cultural references as needed
   - Keep EN/CN parity

**Output**:
- EN draft (file path: `/Fund/research/drafts/{topic}-en.md`)
- CN draft (file path: `/Fund/research/drafts/{topic}-cn.md`)

**Update Notion**:
- Status = "Drafting" → "Review"
- EN Draft Path, CN Draft Path populated
- Assigned Surface = "Claude Code"

**Duration**: 2–4 hours (including translation)

### Step 4: Editorial Review (Editor Skill)

**Input**: EN draft, CN draft
**Action**: Run editor skill on both drafts
- **EN Review**: Grammar, flow, clarity, tone, fact-check (target score: 4.5/5+)
- **CN Review**: Grammar, clarity, tone consistency with EN, cultural appropriateness (target score: 4.5/5+)
- If either score < 4.0/5: Fallback to full `/research` workflow (see below)

**Output**: Editor feedback and score
**Update Notion**:
- If score ≥ 4.5/5: Status = "Final Review", Assigned Surface = "Claude Code"
- If score 4.0–4.4/5: Status = "Review", Context notes feedback, Assigned Surface = "Cowork" (manual revision)
- If score < 4.0/5: Status = "Revision Needed", fallback to full `/research`

**Duration**: 30–60 minutes

### Step 5: Final Check + Format for Distribution

**Input**: Editor-approved EN and CN drafts
**Action**:
1. Final mechanical check (formatting, links, metadata)
2. Prepare publication assets:
   - EN version for LinkedIn (LinkedIn format)
   - CN version for WeChat (WeChat format: title, byline, body, CTA)
3. Stage files for distribution

**Output**:
- Publication-ready drafts
- Distribution package (markdown + formatted versions)

**Update Notion**:
- Status = "Ready"
- Assigned Surface = "the GP"

**Duration**: 15–30 minutes

### Step 6: the GP Final Approval

**Input**: Ready-to-publish EN and CN drafts
**Action**: the GP reviews and approves (or requests changes)
- the GP reads both EN and CN drafts
- Checks alignment with strategy, tone, messaging
- Approves or requests revision (updated via Notion)

**Output**: Approval signal
**Update Notion**:
- If approved: Status = "Published", Actual Publish Date set, URLs populated after distribution
- If revision needed: Status = "Revision Needed", Context notes feedback

**Duration**: 30–60 minutes (the GP turnaround)

---

## Fallback to Full Workflow

If editorial review **fails** (score < 4.0/5 on either EN or CN draft):

1. **Auto-Trigger**: Notion status changes to "Revision Needed"
2. **Escalation**: Move to full `/research` workflow:
   - Go back to step 1 and add an outline approval gate
   - Route to the GP for outline review before proceeding
   - Full editorial review cycle with multiple passes
   - Slower but higher quality

**Rationale**: Fast-track assumes pre-approved topics are well-scoped and translatable. If editorial quality is compromised, revert to full rigor.

---

## Quality Assurance

### English Draft Checklist

- [ ] Follows pre-approved outline structure
- [ ] Tone matches publication type (Market Note: professional/concise; GP Letter: strategic/narrative)
- [ ] All sources cited with URLs or reference format
- [ ] No unsubstantiated claims (especially on competitive/portfolio topics)
- [ ] Links functional and point to stable URLs
- [ ] Facts checked against primary sources (especially financial data)

### Chinese Draft Checklist

- [ ] Accurate translation of EN content (not paraphrasing to different meaning)
- [ ] Tone and cultural tone appropriate for WeChat audience
- [ ] Terminology consistent with previous publications (use glossary if exists)
- [ ] No mistranslations of company names, proper nouns, financial metrics
- [ ] Formatting compatible with WeChat layout

### Editor Feedback Interpretation

| Score | Action |
|-------|--------|
| 4.5–5.0 | Approve for publication |
| 4.0–4.4 | Minor revisions needed; route to Cowork for edits; re-run editor before publishing |
| 3.5–3.9 | Significant issues; fallback to full `/research` workflow |
| < 3.5 | Reject; start over with full workflow |

---

## File Naming Convention

- **EN Draft**: `/Fund/research/drafts/{publication-type}-{topic-slug}-{YYYY-MM-DD}-en.md`
  - Example: `/Fund/research/drafts/market-note-ai-infrastructure-2026-04-03-en.md`

- **CN Draft**: `/Fund/research/drafts/{publication-type}-{topic-slug}-{YYYY-MM-DD}-cn.md`
  - Example: `/Fund/research/drafts/market-note-ai-infrastructure-2026-04-03-cn.md`

- **Research Brief**: `/Fund/research/briefs/{publication-type}-{topic-slug}-{YYYY-MM-DD}-brief.md`
  - Example: `/Fund/research/briefs/market-note-ai-infrastructure-2026-04-03-brief.md`

---

## Notion Integration

### Query: Approved Topics for This Month

```python
# At start of research-fast-track command
approved_topics = notion_query(
  database_id="research-tracker-db",
  filter={
    "and": [
      {"property": "Type", "select": {"is_any_of": ["Market Note", "GP Letter"]}},
      {"property": "Approved for Fast-Track", "checkbox": {"equals": True}},
      {"property": "Target Publish Date", "date": {"on_or_after": "2026-04-01", "on_or_before": "2026-04-30"}}
    ]
  }
)
# Display options to user; user selects topic
```

### Update: Status Transitions

```python
# After research brief generated
notion_update_page(page_id, {"Status": "Researching"})

# After drafts written
notion_update_page(page_id, {
  "Status": "Review",
  "EN Draft Path": "/Fund/research/drafts/...-en.md",
  "CN Draft Path": "/Fund/research/drafts/...-cn.md"
})

# After editorial review passes
notion_update_page(page_id, {"Status": "Ready", "Assigned Surface": "the GP"})
```

---

## Timeline Expectations

| Step | Time | Owner |
|------|------|-------|
| 1. Research Brief | 15–30 min | Claude Code |
| 2. Deep Research | 1–3 hr | Claude Code |
| 3. Draft EN + CN | 2–4 hr | Claude Code |
| 4. Editorial Review | 30–60 min | Claude Code (editor skill) |
| 5. Format & Stage | 15–30 min | Claude Code |
| 6. the GP Approval | 30–60 min | the GP |
| **Total** | **5–10 hours** (mostly async) | — |

**Typical Cycle**: Start research → Drafts ready by EOD → the GP reviews next morning → Published by EOW.

---

## Safety Rules

1. **Never Skip Editorial Review**: Even with pre-approved topics, editorial review (step 4) is mandatory. Do not publish without editor score ≥ 4.0/5.

2. **the GP Final Approval Required**: Even fast-track publishes must have the GP's explicit approval (Status = "Ready" → the GP approval). No exceptions.

3. **Topic Must Be Pre-Approved**: Do not use fast-track for new topics. If topic is not on the approved monthly list, use full `/research` workflow instead.

4. **Quality Over Speed**: If editorial review reveals significant issues, fallback to full workflow. Speed should not compromise quality.

5. **Confidentiality**: Do not reference specific portfolio companies or LP details by name. Anonymize or use generic references.

---

## Troubleshooting

| Issue | Resolution |
|-------|-----------|
| Topic not on approved list | Use full `/research` workflow instead; coordinate with the GP to add to monthly approval list |
| EN draft has factual errors | Editor will flag in review; fix and re-run editor before step 5 |
| Editorial score < 4.0/5 | Automatic fallback to full `/research` workflow; Notion status = "Revision Needed" |
| the GP requests major changes | Can request revision without starting over; Notion status = "Awaiting the GP (Final)", Context notes changes; update drafts and re-run editor |
| WeChat/LinkedIn distribution fails | Manual fix needed; reach out to the GP or Cowork to debug; update distribution paths in Notion |

---

## Examples

### Example 1: Market Note on AI Infrastructure

**Topic**: "Commodity Hardware, Specialization Wins" (pre-approved monthly topic)

1. Research Brief: Key market trends in GPU commoditization, emerging accelerator architectures (3 sources: Nvidia earnings, startup funding data, analyst reports)
2. Deep Research: Perplexity research on GPU market dynamics, 5–10 key data points
3. Draft EN+CN: 1000 words, 3 sections (Market snapshot, Investment implications, Recommendation)
4. Editorial Review: Score 4.6/5 (one citation cleaned up)
5. Format: WeChat + LinkedIn versions ready
6. the GP Approval: ✓ Approved Monday morning → Published Monday afternoon

**Duration**: ~6 hours work, 24-hour calendar time.

### Example 2: GP Letter on Fund Strategy

**Topic**: "2026 Thesis: Consolidation in Deeptech" (pre-approved)

1. Research Brief: Portfolio context, industry trends, strategic narrative
2. Deep Research: Multi-source research on consolidation trends, portfolio company positioning
3. Draft EN+CN: 2000 words, 6 sections (Context, Thesis, Data, Our bets, Implications, CTA)
4. Editorial Review: Score 4.4/5 (tone adjusted, one section restructured by Cowork)
5. Format: LinkedIn + internal distribution
6. the GP Approval: ✓ Approved → Published

**Duration**: ~8 hours work, 2-day calendar time.

---

## Related Commands

- **`/research`**: Full research workflow with outline approval gate; use for Sector Deep Dives and Company Teardowns
- **`/publish`**: Distribution and promotion workflow (post-publication)
- **`/engagement-tracker`**: Monthly engagement metrics collection
