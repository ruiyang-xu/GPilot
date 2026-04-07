import fs from 'fs';
import path from 'path';
import { PortfolioCompany, FundSummary, DataCompleteness, FUND_SLUGS } from './types';

// In dev: read from parent repo's data/state/portfolio.json (live edits)
// On Vercel: read from public/portfolio.json (bundled at deploy time)
function getPortfolioPath(): string {
  const repoPath = path.join(process.cwd(), '..', 'data', 'state', 'portfolio.json');
  if (fs.existsSync(repoPath)) return repoPath;
  return path.join(process.cwd(), 'public', 'portfolio.json');
}

export function readPortfolio(): PortfolioCompany[] {
  const raw = fs.readFileSync(getPortfolioPath(), 'utf-8');
  return JSON.parse(raw);
}

export function writePortfolio(data: PortfolioCompany[]): void {
  const repoPath = path.join(process.cwd(), '..', 'data', 'state', 'portfolio.json');
  // Write to repo source (only works locally, not on Vercel)
  if (fs.existsSync(path.dirname(repoPath))) {
    fs.writeFileSync(repoPath, JSON.stringify(data, null, 2), 'utf-8');
  }
  // Also update the bundled copy
  const publicPath = path.join(process.cwd(), 'public', 'portfolio.json');
  fs.writeFileSync(publicPath, JSON.stringify(data, null, 2), 'utf-8');
}

export function getFundSummaries(data: PortfolioCompany[]): FundSummary[] {
  const funds = new Map<string, PortfolioCompany[]>();
  for (const c of data) {
    const arr = funds.get(c.fund) || [];
    arr.push(c);
    funds.set(c.fund, arr);
  }

  return Array.from(funds.entries()).map(([name, companies]) => {
    const deployed = companies.reduce((s, c) => s + (c.investment_cost_usd_mn || 0), 0);
    const appraised = companies.reduce((s, c) => s + (c.appraised_value_usd_mn || 0), 0);
    const sectors: Record<string, number> = {};
    for (const c of companies) {
      sectors[c.sector] = (sectors[c.sector] || 0) + 1;
    }
    return {
      name,
      slug: FUND_SLUGS[name] || name.toLowerCase().replace(/\s+/g, '-'),
      companies: companies.length,
      deployed,
      appraised,
      moic: deployed > 0 ? appraised / deployed : null,
      sectors,
    };
  });
}

export function getCompleteness(data: PortfolioCompany[]): DataCompleteness[] {
  const checks: [keyof PortfolioCompany, string][] = [
    ['entity_name', 'Legal Entity'],
    ['initial_investment_date', 'Investment Date'],
    ['investment_cost_usd_mn', 'Cost Basis'],
    ['current_valuation_usd', 'Company Valuation'],
    ['appraised_value_usd_mn', 'Appraised Value'],
    ['return', 'Return %'],
  ];

  return checks.map(([field, label]) => {
    const filled = data.filter(p => p[field] !== null && p[field] !== '' && p[field] !== 0).length;
    return { field, label, filled, total: data.length, pct: Math.round((filled / data.length) * 100) };
  });
}
