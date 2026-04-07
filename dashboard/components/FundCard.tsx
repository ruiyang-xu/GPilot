'use client';
import Link from 'next/link';
import { FundSummary } from '@/lib/types';

function fmt(n: number) {
  if (n >= 1000) return `$${(n / 1000).toFixed(1)}B`;
  return `$${n.toFixed(1)}M`;
}

export default function FundCard({ fund }: { fund: FundSummary }) {
  const topSectors = Object.entries(fund.sectors)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 3);

  return (
    <Link
      href={`/fund/${fund.slug}`}
      className="block border border-zinc-200 rounded-xl p-6 hover:border-zinc-400 hover:shadow-md transition-all bg-white"
    >
      <h3 className="font-semibold text-lg text-zinc-900 mb-1">{fund.name}</h3>
      <p className="text-sm text-zinc-500 mb-4">{fund.companies} companies</p>
      <div className="grid grid-cols-3 gap-4 mb-4">
        <div>
          <p className="text-xs text-zinc-400 uppercase tracking-wider">Deployed</p>
          <p className="text-xl font-bold text-zinc-800">{fmt(fund.deployed)}</p>
        </div>
        <div>
          <p className="text-xs text-zinc-400 uppercase tracking-wider">Appraised</p>
          <p className="text-xl font-bold text-zinc-800">{fmt(fund.appraised)}</p>
        </div>
        <div>
          <p className="text-xs text-zinc-400 uppercase tracking-wider">MOIC</p>
          <p className={`text-xl font-bold ${fund.moic && fund.moic >= 1 ? 'text-emerald-600' : 'text-amber-600'}`}>
            {fund.moic ? `${fund.moic.toFixed(2)}x` : '-'}
          </p>
        </div>
      </div>
      <div className="flex gap-2 flex-wrap">
        {topSectors.map(([sector, count]) => (
          <span key={sector} className="text-xs px-2 py-0.5 bg-zinc-100 text-zinc-600 rounded-full">
            {sector} ({count})
          </span>
        ))}
      </div>
    </Link>
  );
}
