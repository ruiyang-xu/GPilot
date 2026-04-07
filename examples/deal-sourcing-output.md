# Example Output: `/source-deals`

> This is a sample output from the deal sourcing command. All companies and data are fictional.

---

## Deal Sourcing Report — Week of April 7, 2026

**Focus sectors**: AI/ML, SaaS, Healthtech
**Sources scanned**: GitHub trending (7d), Crunchbase (14d), ArXiv papers (7d), TechCrunch, The Information

---

### Top Opportunities (3 matches)

#### 1. NeuralForge AI — Series A

| Metric | Detail |
|--------|--------|
| **Match Score** | **92/100** |
| **Sector** | AI/ML — Model fine-tuning infrastructure |
| **Stage** | Series A ($8M target) |
| **Signal** | GitHub: 4,200 stars in 3 months; Crunchbase: Seed raised $2.5M (Sequoia scout) |
| **Why it fits** | Directly in AI infrastructure focus. Open-source traction mirrors successful pattern (Hugging Face, LangChain). |
| **Risk flags** | Crowded space (50+ fine-tuning tools). Monetization unclear — OSS-to-enterprise conversion unproven. |
| **Next action** | Cold outreach to CEO (LinkedIn). Request deck and metrics. |

#### 2. MediScan Health — Seed

| Metric | Detail |
|--------|--------|
| **Match Score** | **78/100** |
| **Sector** | Healthtech — Diagnostic imaging AI |
| **Stage** | Seed ($3M target) |
| **Signal** | ArXiv paper: novel chest X-ray model, 98.2% accuracy (top 1% on benchmark). TechCrunch mention in "startups to watch" list. |
| **Why it fits** | Healthtech focus. Founders from Stanford Medical AI Lab + Google Health. Strong technical moat. |
| **Risk flags** | FDA pathway adds 18-24 months before revenue. Regulatory risk. |
| **Next action** | Request intro via Stanford network. Schedule 30-min discovery call. |

#### 3. DataBridge Analytics — Series A

| Metric | Detail |
|--------|--------|
| **Match Score** | **71/100** |
| **Sector** | SaaS — Data integration platform |
| **Stage** | Series A ($12M target, rumored $60M pre) |
| **Signal** | Crunchbase: $4M Seed closed Q4 2025. GitHub: 1,800 stars. LinkedIn: hiring aggressively (12 open roles). |
| **Why it fits** | SaaS infrastructure play. Enterprise data integration is a $30B+ market. |
| **Risk flags** | Valuation feels stretched for stage. Competition from Fivetran, Airbyte. Differentiation unclear from public info. |
| **Next action** | Monitor. Request deck if valuation comes down or if strong reference emerges. |

---

### Passed (below threshold)

| Company | Sector | Score | Reason |
|---------|--------|-------|--------|
| CryptoGuard | Fintech/Crypto | 35 | Outside current focus sectors |
| FarmTech AI | AgTech | 42 | Interesting but no sector expertise |
| ChatBot Pro | SaaS | 28 | Commoditized space, no defensibility |

---

### Pipeline Updated

- `data/state/deals.json`: 2 new entries added (NeuralForge AI, MediScan Health)
- `wiki/companies/`: 2 new draft articles created
- `deals/neuralforge-ai/notes.md`: Initial research saved
- `deals/mediscan-health/notes.md`: Initial research saved

### Sourcing Stats

| Metric | This Week | Last 4 Weeks |
|--------|-----------|--------------|
| Sources scanned | 5 | 5 |
| Companies identified | 6 | 24 |
| Above threshold (>70) | 3 | 8 |
| Outreach initiated | 2 | 5 |
| Calls scheduled | 0 | 3 |
