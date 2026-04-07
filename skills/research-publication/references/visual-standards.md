# Visual Standards — Research Publications

## Design Principles
- **Clarity over decoration**: Every visual element must convey information, not just fill space
- **Consistent styling**: Same color palette, fonts, and formatting across all publications
- **Mobile-first**: WeChat is mobile — all visuals must be readable on phone screens
- **Self-explanatory**: Charts should be understandable without reading surrounding text

## Color Palette
- Primary: Deep navy (#1A365D) — headers, primary data
- Secondary: Teal (#2C7A7B) — secondary data, accents
- Positive: Green (#38A169) — growth, outperformance
- Negative: Red (#E53E3E) — decline, underperformance
- Neutral: Gray (#718096) — benchmarks, context
- Background: White (#FFFFFF) or Light gray (#F7FAFC)

## Chart Types by Use Case

### Comparison
- **Bar charts**: Comparing 3-10 items on a single metric
- **Grouped bars**: Comparing items across 2-3 metrics
- **Radar charts**: Multi-dimensional comparison (e.g., company scoring)

### Trend
- **Line charts**: Time series (revenue growth, market size over time)
- **Area charts**: Stacked composition over time (market share evolution)

### Composition
- **Stacked bar**: Component breakdown (revenue by segment)
- **Treemap**: Hierarchical composition (market landscape by category)
- **Pie/donut**: Only for 2-4 segments with clear dominant share

### Relationship
- **Scatter plots**: Two-variable analysis (growth vs. valuation)
- **Bubble charts**: Three-variable analysis (growth × margin × size)

### Framework Visualizations
- **2×2 Matrix**: Positioning analysis (e.g., growth vs. profitability quadrants)
- **Value chain diagram**: Horizontal flow showing industry layers
- **Market map**: Categorized grid of companies by segment
- **Funnel**: Conversion or market sizing waterfall

## Table Standards

### Data Tables
```
| Company | Revenue ($M) | Growth (%) | Margin (%) | Valuation ($B) |
|---------|-------------|-----------|-----------|----------------|
| Co A    | 245.3       | 67%       | 72%       | 8.2            |
```
- Right-align numbers, left-align text
- Include units in header, not in cells
- Sort by the most relevant metric (usually primary ranking factor)
- Bold the row of the subject company (if applicable)
- Limit to 10-15 rows max; move extras to appendix

### Comparison Tables (Competitive Analysis)
- Use ✓/✗ or ●/○ for feature presence
- Color-code strengths (green) and weaknesses (red)
- Always include the subject company and 4-6 competitors

## Framework Templates

### 2×2 Matrix
```
                    HIGH [Metric B]
                         |
            Quadrant 2   |   Quadrant 1
            (Watch)       |   (Winners)
    ─────────────────────┼────────────────────
            Quadrant 3   |   Quadrant 4
            (Avoid)       |   (Optimize)
                         |
                    LOW [Metric B]
    LOW [Metric A]               HIGH [Metric A]
```

### Market Map
```
┌─────────────────────────────────────────────┐
│              [SECTOR NAME]                   │
├─────────────┬──────────────┬────────────────┤
│  Segment A  │  Segment B   │  Segment C     │
├─────────────┼──────────────┼────────────────┤
│ Company 1   │ Company 4    │ Company 7      │
│ Company 2   │ Company 5    │ Company 8      │
│ Company 3   │ Company 6    │                │
└─────────────┴──────────────┴────────────────┘
```

## Image Specifications

### WeChat
- Inline images: 900px wide, variable height
- Cover image: 900×500px (16:9 ratio recommended)
- File format: PNG for charts/diagrams, JPG for photos
- Max file size: 5MB per image

### LinkedIn
- Post images: 1200×627px (1.91:1 ratio)
- Carousel/document: PDF format, standard letter size
- Profile banner: 1584×396px

## Chart Generation Approach
1. Use the `web-artifacts-builder` skill to create HTML/SVG visualizations
2. For simple tables and frameworks: use markdown formatting
3. For complex charts: generate HTML, render via Claude Preview, screenshot
4. For final publication: export as PNG at 2x resolution for retina displays
