import { readPortfolio } from '@/lib/data';
import { SLUG_TO_FUND } from '@/lib/types';
import PortfolioTable from '@/components/PortfolioTable';
import Link from 'next/link';

export const dynamic = 'force-dynamic';

export default async function FundPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const fundName = SLUG_TO_FUND[slug];
  if (!fundName) {
    return <div className="text-red-500">Fund not found: {slug}</div>;
  }

  const data = readPortfolio();
  const companies = data.filter(c => c.fund === fundName);
  const deployed = companies.reduce((s, c) => s + (c.investment_cost_usd_mn || 0), 0);
  const appraised = companies.reduce((s, c) => s + (c.appraised_value_usd_mn || 0), 0);
  const moic = deployed > 0 ? appraised / deployed : null;

  return (
    <div>
      <div className="mb-6">
        <Link href="/" className="text-sm text-zinc-400 hover:text-zinc-600 mb-2 block">&larr; Back to overview</Link>
        <h2 className="text-2xl font-bold text-zinc-900 mb-1">{fundName}</h2>
        <div className="flex gap-6 text-sm text-zinc-500">
          <span>{companies.length} companies</span>
          <span>Deployed: <span className="font-medium text-zinc-700">${deployed.toFixed(1)}M</span></span>
          <span>Appraised: <span className="font-medium text-zinc-700">${appraised.toFixed(1)}M</span></span>
          {moic && <span>MOIC: <span className={`font-medium ${moic >= 1 ? 'text-emerald-600' : 'text-amber-600'}`}>{moic.toFixed(2)}x</span></span>}
        </div>
      </div>

      <p className="text-xs text-zinc-400 mb-4">Click any cell to edit. Press Enter to confirm, Escape to cancel. Save changes with the blue button.</p>

      <PortfolioTable companies={companies} fundName={fundName} />
    </div>
  );
}
