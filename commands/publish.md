---
name: publish
description: Format finished research for WeChat and LinkedIn distribution
---

You are handling the last mile of research publication — formatting for distribution channels and preparing for publishing.

## Input
Ask for the **piece to publish**:
- List all pieces from `data/research-tracker.xlsx` with Status = "Ready" or "Final Review"
- Or accept a specific title/slug

## Step 1: Load the Piece
Read from `research/wip/{date}-{slug}/` or `research/published/{date}-{slug}/`:
- `draft-en.md` (English final)
- `draft-cn.md` (Chinese final)
- Any charts in `charts/` subdirectory

## Step 2: Format for WeChat 公众号

Following `skills/research-publication/references/wechat-formatting.md`:

### Chinese Version (Primary for WeChat)
1. **Title**: ≤22 Chinese characters, compelling, includes key topic
2. **Abstract**: ≤120 characters for subscription preview
3. **Cover image**: Suggest concept and dimensions (900×500px)
4. **Body formatting**:
   - Apply H2/H3 section headers
   - Highlight key insights in styled blockquotes (💡 核心观点)
   - Format data tables (convert to image if complex)
   - Ensure charts are 900px wide
   - Add source citations as footnotes
5. **Header**: Fund logo + series name + issue number + date
6. **Footer**: Author, fund description, QR code placeholder, disclaimer

Output: `output/research/wechat/{slug}-cn.md` (WeChat-ready formatted markdown)

### Engagement Elements
- Suggest 2-3 "pull quotes" for visual emphasis
- Add a "一句话总结" (one-line summary) box at the top
- Suggest 3-5 WeChat tags

## Step 3: Format for LinkedIn

Following `skills/research-publication/references/linkedin-formatting.md`:

### English Version (Primary for LinkedIn)
Determine format based on publication type:

**Market Note / GP Letter → Text Post**:
- Write a compelling hook (first 2 lines, before "See more" fold)
- Compress to 800-1,300 characters
- Add 3-5 hashtags
- Note: put the full report link in first comment, not in the post body

**Company Teardown → LinkedIn Article or Carousel**:
- If <2,000 words: format as LinkedIn Article with inline images
- If >2,000 words: create a 10-slide carousel summary (key insights only)
- Write accompanying text post (3-4 line hook)

**Thematic Research / Sector Deep Dive → Carousel**:
- Create 10-15 slide summary: 1 key finding + 1 visual per slide
- First slide: compelling cover with title
- Last slide: fund branding + "Follow for more"
- Write accompanying text post with the contrarian thesis

Output: `output/research/linkedin/{slug}-en.md` (LinkedIn-ready content)

### Chinese LinkedIn Post (Optional)
- Create a shorter Chinese adaptation for LinkedIn (not the full WeChat version)
- Or suggest posting the Chinese version 1-2 days after the English version

## Step 4: LP Distribution (Optional)
If the piece is appropriate for LP distribution:
- Draft a brief email to LPs with the piece attached (Gmail DRAFT only)
- Subject: "[Fund Name] Research — {Title}"
- Body: 3-4 sentence summary + "Full report attached"
- Attach both EN and CN versions
- Update `data/lp-database.xlsx` "Last Communication"

## Step 5: Finalize
1. Move WIP folder: `research/wip/{date}-{slug}/` → `research/published/{date}-{slug}/`
2. Copy final versions to published folder as `final-en.md` and `final-cn.md`
3. Update `data/research-tracker.xlsx`:
   - Status → "Published"
   - Actual Publish Date → today
   - Distribution → channels used

## Step 6: Summary
Present to the GP:
```
## Ready to Publish: {Title}

**WeChat**: {title} — formatted and ready to paste into editor
**LinkedIn**: {format type} — {character count} post + {attachment type}
**LP Email**: {Drafted / Not applicable}

Files ready at:
- WeChat: output/research/wechat/{slug}-cn.md
- LinkedIn: output/research/linkedin/{slug}-en.md

Next: Copy the WeChat content into the 公众号 editor and paste the LinkedIn post.
```

## Post-Publication (Future)
After publishing, the GP should update `research-tracker.xlsx` with:
- WeChat URL
- LinkedIn URL
- Engagement metrics (reads, shares, impressions) — update weekly

## Safety
- NEVER auto-publish to any platform. All output is formatted files for the GP to manually publish.
- LP emails are DRAFTS only.
- All content must have the GP's explicit approval before this command is invoked.
