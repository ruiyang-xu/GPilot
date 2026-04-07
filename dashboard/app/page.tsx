import { readPortfolio, getFundSummaries, getCompleteness } from '@/lib/data';
import FundCard from '@/components/FundCard';
import CompletenessBar from '@/components/CompletenessBar';

export const dynamic = 'force-dynamic';

export default function Home() {
  const data = readPortfolio();
  const funds = getFundSummaries(data);
  const completeness = getCompleteness(data);
  const totalDeployed = data.reduce((s, c) => s + (c.investment_cost_usd_mn || 0), 0);
  const totalAppraised = data.reduce((s, c) => s + (c.appraised_value_usd_mn || 0), 0);
  const missingCount = data.filter(c =>
    !c.investment_cost_usd_mn || !c.appraised_value_usd_mn || !c.initial_investment_date || !c.entity_name
  ).length;

  return (
    <div>
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-zinc-900 mb-1">Portfolio Overview</h2>
        <p className="text-sm text-zinc-500">Single source of truth for all fund portfolio data</p>
      </div>

      <div className="grid grid-cols-4 gap-4 mb-8">
        <div className="bg-white border border-zinc-200 rounded-xl p-5">
          <p className="text-xs text-zinc-400 uppercase tracking-wider mb-1">Companies</p>
          <p className="text-3xl font-bold text-zinc-800">{data.length}</p>
        </div>
        <div className="bg-white border border-zinc-200 rounded-xl p-5">
          <p className="text-xs text-zinc-400 uppercase tracking-wider mb-1">Total Deployed</p>
          <p className="text-3xl font-bold text-zinc-800">${totalDeployed.toFixed(1)}M</p>
        </div>
        <div className="bg-white border border-zinc-200 rounded-xl p-5">
          <p className="text-xs text-zinc-400 uppercase tracking-wider mb-1">Total Appraised</p>
          <p className="text-3xl font-bold text-zinc-800">${totalAppraised.toFixed(1)}M</p>
        </div>
        <div className="bg-white border border-zinc-200 rounded-xl p-5">
          <p className="text-xs text-zinc-400 uppercase tracking-wider mb-1">Needs Attention</p>
          <p className={`text-3xl font-bold ${missingCount > 0 ? 'text-red-500' : 'text-emerald-600'}`}>{missingCount}</p>
          <p className="text-xs text-zinc-400 mt-1">companies with missing data</p>
        </div>
      </div>

      <div className="grid grid-cols-3 gap-6 mb-8">
        {funds.filter(f => f.name !== 'Unknown').map((fund) => (
          <FundCard key={fund.slug} fund={fund} />
        ))}
      </div>

      <CompletenessBar items={completeness} />
    </div>
  );
}
