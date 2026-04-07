# VC Publications Templates

Two production-quality HTML templates for institutional-grade venture research publications, optimized for WeChat distribution and mobile consumption.

## Files

### 1. Sector Deep Dive Template
**File**: `sector_deep_dive_template.html`  
**Size**: 38KB | **Lines**: 1,128  
**Style**: Goldman Sachs "Top of Mind" research report  

**Structure**:
- Header with brand, sector title, thesis statement, metadata
- Executive Summary (blue accent box, 3-4 key findings)
- Thesis Statement (contrarian claim + context)
- Market Map (3x3 CSS grid of company/category cards)
- Why Now - Catalyst Analysis (3 numbered catalysts with data callouts)
- Value Chain Analysis (horizontal flow diagram, margin indicators)
- Key Company Profiles (cards + comparison table)
- Investment Implications (conviction levels, looking for/avoiding)
- Data Appendix (funding trends, valuation comps, market sizing)
- Sources & Methodology

**Design**: 
- Max-width: 677px (WeChat-optimized)
- Body font: 17px Georgia/Noto Serif SC
- Headings: Helvetica Neue/PingFang SC
- Color system: Navy (#1a1a2e), Blue (#4361ee), Gold (#f4a261), Coral (#e76f51), BG (#fafafa)
- Fully responsive (mobile-first)
- No external dependencies (inline CSS)

---

### 2. GP Insight Letter Template
**File**: `gp_insight_letter_template.html`  
**Size**: 20KB | **Lines**: 584  
**Style**: AB Bernstein / Howard Marks memo  

**Structure**:
- Header with brand, title, author, date, issue number
- Opening Provocation (bold claim + decorative line)
- The Conventional Wisdom (2-3 paragraphs setting up consensus)
- Why It's Wrong (evidence + pullquote callout)
- The Framework (named concept with 2x2 grid visualization)
- Implications (for Founders / for Investors)
- What We're Doing About It (anonymized portfolio references)
- Closing (call-to-action + sign-off)
- Footer with disclaimer

**Design**:
- Same design system as Sector Deep Dive
- More minimal, text-heavy, intellectual tone
- Increased line-height (1.72) for reading comfort
- Elegant typography with italics and pullquotes
- Sophisticated frameworking UI (boxes, grids)
- Mobile-responsive

---

## Design System (Both Templates)

**Typography**:
- Headings: Helvetica Neue, PingFang SC (sans-serif, 700 weight)
- Body: Georgia, Noto Serif SC (serif, 400 weight)
- Base font size: 17px body text, 16px base HTML
- Line height: 1.65-1.72 for optimal readability

**Color Palette**:
- Navy: #1a1a2e (primary text, strong emphasis)
- Blue: #4361ee (accent, hyperlinks, positive callouts)
- Gold: #f4a261 (secondary accent, section dividers)
- Coral: #e76f51 (warnings, implications, negative callouts)
- Background: #fafafa (off-white, subtle contrast)
- White: #ffffff (content containers)

**Components**:
- Blue accent boxes: Executive summaries, framework context
- Gold borders: Section dividers, thesis statements
- Coral borders: Investment implications, warnings
- Data callouts: Styled metric boxes with values + labels
- Stage badges: Color-coded pill buttons (Seed, Series A, Series B, Growth)
- Pullquotes: Italic text in colored boxes (blue or coral)
- Comparison tables: Dark header row, alternating row hover

**Layout**:
- Max-width: 677px (optimal for WeChat reading on mobile)
- Padding: 40px horizontal on desktop, 16-20px on mobile
- Grid systems: CSS Grid for market maps, framework boxes, profile details
- Mobile breakpoint: 600px with adaptive font sizes and column counts

---

## Technical Specifications

**Compatibility**:
- No external fonts or CSS frameworks
- Pure inline CSS (single-file, no dependencies)
- No JavaScript
- Pure HTML5 semantic structure
- Meta viewport tag for mobile responsiveness
- UTF-8 character encoding for Chinese text support

**WeChat Optimization**:
- Responsive images (all CSS, no external image dependencies)
- Mobile-first breakpoints
- Touch-friendly spacing and tap targets
- Maximum width ensures proper reading on narrowest devices
- No external resources (faster load times in WeChat)

**Browser Support**:
- Modern browsers (Chrome, Safari, Edge, Firefox)
- IE11+ compatible (with graceful degradation)
- Mobile browsers (iOS Safari, Chrome Mobile)

---

## Usage

### Sector Deep Dive
1. Replace `[SECTOR NAME]` with your sector (e.g., "AI Infrastructure")
2. Replace all placeholder text in brackets with actual content
3. Populate market map with 9 companies (or adjust grid)
4. Add 3 catalysts with data points
5. Profile 3-5 key companies
6. Fill data tables with actual funding/valuation data
7. Add sources and methodology

### GP Insight Letter
1. Replace `[GP Name]` with author name
2. Replace title placeholder with your provocative thesis
3. Write conventional wisdom section (2-3 paragraphs)
4. Write why it's wrong section with evidence
5. Create a named framework with 2x2 or 2x3 grid
6. Add implications for founders and investors
7. Include 1-2 anonymized portfolio examples
8. Update fund name and disclaimer

---

## Quality Checklist

- [ ] Inline CSS properly formatted
- [ ] All placeholder text replaced
- [ ] Color system applied consistently
- [ ] Typography hierarchy respected
- [ ] Mobile responsiveness tested
- [ ] Tables properly formatted
- [ ] Links styled correctly
- [ ] Proper HTML semantic structure
- [ ] Meta tags complete
- [ ] Footer disclaimer included
- [ ] Publication date accurate
- [ ] Issue number assigned

