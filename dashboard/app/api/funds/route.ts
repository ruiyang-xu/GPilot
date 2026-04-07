import { NextResponse } from 'next/server';
import { readPortfolio, getFundSummaries, getCompleteness } from '@/lib/data';

export async function GET() {
  const data = readPortfolio();
  return NextResponse.json({
    funds: getFundSummaries(data),
    completeness: getCompleteness(data),
    totalCompanies: data.length,
    totalDeployed: data.reduce((s, c) => s + (c.investment_cost_usd_mn || 0), 0),
    totalAppraised: data.reduce((s, c) => s + (c.appraised_value_usd_mn || 0), 0),
  });
}
