import { readPortfolio } from '@/lib/data';
import Link from 'next/link';
import { FUND_SLUGS } from '@/lib/types';

export const dynamic = 'force-dynamic';

function Row({ label, value, warn }: { label: string; value: string | number | null | undefined; warn?: boolean }) {
  const missing = value === null || value === undefined || value === '';
  return (
    <div className="flex border-b border-zinc-100 py-3">
      <dt className="w-56 text-sm text-zinc-500 flex-shrink-0">{label}</dt>
      <dd className={`text-sm flex-1 ${missing ? 'text-red-500' : 'text-zinc-900'}`}>
        {missing ? (
          <span className="bg-red-100 text-red-600 px-2 py-0.5 rounded text-xs font-medium">Missing</span>
        ) : (
          typeof value === 'number' ? (
            value >= 1000 ? `$${(value / 1000).toFixed(1)}B` : `$${value.toFixed(2)}M`
          ) : String(value)
        )}
        {warn && !missing && <span className="ml-2 text-xs text-amber-500">needs verification</span>}
      </dd>
    </div>
  );
}

export default async function CompanyPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const data = readPortfolio();
  const company = data.find(c => c.portfolio_id === id);

  if (!company) {
    return <div className="text-red-500">Company not found: {id}</div>;
  }

  const fundSlug = FUND_SLUGS[company.fund] || '';

  return (
    <div className="max-w-3xl">
      <Link href={fundSlug ? `/fund/${fundSlug}` : '/'} className="text-sm text-zinc-400 hover:text-zinc-600 mb-2 block">
        &larr; Back to {company.fund}
      </Link>

      <div className="mb-6">
        <h2 className="text-2xl font-bold text-zinc-900">{company.company}</h2>
        <p className="text-sm text-zinc-500">{company.entity_name || 'Entity name missing'}</p>
      </div>

      <div className="bg-white border border-zinc-200 rounded-xl p-6 mb-6">
        <h3 className="font-semibold text-zinc-800 mb-4">Investment Details</h3>
        <dl>
          <Row label="Fund" value={company.fund} />
          <Row label="Sector" value={company.sector} />
          <Row label="Stage at Investment" value={company.stage_at_investment} />
          <Row label="Investment Type" value={company.investment_type} />
          <Row label="Investment Date" value={company.initial_investment_date} />
          {company.initial_investment_date_raw && company.initial_investment_date_raw !== company.initial_investment_date && (
            <Row label="Date (raw from report)" value={company.initial_investment_date_raw} />
          )}
          <Row label="Status" value={company.status} />
        </dl>
      </div>

      <div className="bg-white border border-zinc-200 rounded-xl p-6 mb-6">
        <h3 className="font-semibold text-zinc-800 mb-4">Valuation</h3>
        <dl>
          <Row label="Investment Cost" value={company.investment_cost_usd_mn} />
          <Row label="Company Valuation (post-money)" value={company.current_valuation_usd} />
          <Row label="Appraised Value" value={company.appraised_value_usd_mn} />
          <Row label="Return" value={company.return} />
          <Row label="Valuation Source" value={company.valuation_source} />
          <Row label="Valuation Confidence" value={company.valuation_confidence} />
          <Row label="Last Valuation Date" value={company.last_valuation_date} />
        </dl>
      </div>

      <div className="bg-white border border-zinc-200 rounded-xl p-6">
        <h3 className="font-semibold text-zinc-800 mb-4">Source</h3>
        <dl>
          <Row label="Report Path" value={company.report_path} />
          <Row label="Portfolio ID" value={company.portfolio_id} />
          <Row label="Last Updated" value={company.last_updated} />
        </dl>
      </div>
    </div>
  );
}
