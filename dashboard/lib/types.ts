export interface PortfolioCompany {
  portfolio_id: string;
  company: string;
  entity_name: string | null;
  fund: string;
  sector: string;
  stage_at_investment: string;
  investment_type: string | null;
  initial_investment_date: string | null;
  initial_investment_date_raw: string | null;
  initial_check_usd: number | null;
  current_valuation_usd: number | null;
  valuation_source: string;
  valuation_confidence: string;
  investment_cost_usd_mn: number | null;
  appraised_value_usd_mn: number | null;
  return: string | null;
  status: string;
  last_valuation_date: string;
  report_path: string;
  created_date: string;
  last_updated: string;
}

export interface FundSummary {
  name: string;
  slug: string;
  companies: number;
  deployed: number;
  appraised: number;
  moic: number | null;
  sectors: Record<string, number>;
}

export interface DataCompleteness {
  field: string;
  label: string;
  filled: number;
  total: number;
  pct: number;
}

// Customize: map your portfolio/fund names to URL-safe slugs
export const FUND_SLUGS: Record<string, string> = {
  'Portfolio Alpha': 'portfolio-alpha',
  'Portfolio Beta': 'portfolio-beta',
};

export const SLUG_TO_FUND: Record<string, string> = Object.fromEntries(
  Object.entries(FUND_SLUGS).map(([k, v]) => [v, k])
);

export const EDITABLE_FIELDS: (keyof PortfolioCompany)[] = [
  'company', 'entity_name', 'sector', 'stage_at_investment',
  'investment_type', 'initial_investment_date',
  'investment_cost_usd_mn', 'current_valuation_usd',
  'appraised_value_usd_mn', 'return', 'status',
];

export const SECTOR_OPTIONS = [
  'SaaS', 'AI/ML', 'Fintech', 'Healthtech', 'Deeptech',
  'Infrastructure', 'Semiconductors', 'Other',
];

export const STAGE_OPTIONS = [
  'Pre-seed', 'Seed', 'Series A', 'Series B', 'Series C',
  'Series D', 'Series E+', 'Growth',
];
