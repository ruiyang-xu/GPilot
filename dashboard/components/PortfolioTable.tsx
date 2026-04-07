'use client';
import { useState, useCallback } from 'react';
import Link from 'next/link';
import { PortfolioCompany, SECTOR_OPTIONS, STAGE_OPTIONS } from '@/lib/types';

type SortKey = keyof PortfolioCompany;
type SortDir = 'asc' | 'desc';

function fmtMoney(v: number | null) {
  if (v === null || v === undefined) return null;
  if (v >= 1000) return `$${(v / 1000).toFixed(1)}B`;
  return `$${v.toFixed(2)}M`;
}

function shortenInstrument(t: string | null) {
  if (!t) return '-';
  if (t.includes('SAFE') || t.includes('Single Agreement')) return 'SAFE';
  if (t.includes('Secondary')) return 'Secondary';
  if (t.includes('Convertible') && t.includes('Bond')) return 'Conv. Bond';
  if (t.includes('Convertible')) return 'Conv. Equity';
  if (t.includes('Partnership')) return 'LP Interest';
  if (t.includes('Private equity')) return 'PE';
  const m = t.match(/Series\s+(\S+)/);
  if (m) return `Series ${m[1]}`;
  return t.slice(0, 15);
}

interface EditingCell {
  id: string;
  field: string;
}

export default function PortfolioTable({
  companies,
  fundName,
}: {
  companies: PortfolioCompany[];
  fundName: string;
}) {
  const [data, setData] = useState(companies);
  const [sortKey, setSortKey] = useState<SortKey>('company');
  const [sortDir, setSortDir] = useState<SortDir>('asc');
  const [editing, setEditing] = useState<EditingCell | null>(null);
  const [dirty, setDirty] = useState(false);
  const [saving, setSaving] = useState(false);
  const [filterSector, setFilterSector] = useState('');
  const [search, setSearch] = useState('');

  const handleSort = (key: SortKey) => {
    if (sortKey === key) {
      setSortDir(sortDir === 'asc' ? 'desc' : 'asc');
    } else {
      setSortKey(key);
      setSortDir('asc');
    }
  };

  const sorted = [...data].sort((a, b) => {
    const av = a[sortKey];
    const bv = b[sortKey];
    if (av === null || av === undefined) return 1;
    if (bv === null || bv === undefined) return -1;
    const cmp = typeof av === 'number' ? av - (bv as number) : String(av).localeCompare(String(bv));
    return sortDir === 'asc' ? cmp : -cmp;
  });

  const filtered = sorted.filter((c) => {
    if (filterSector && c.sector !== filterSector) return false;
    if (search && !c.company.toLowerCase().includes(search.toLowerCase())) return false;
    return true;
  });

  const updateCell = useCallback((id: string, field: string, value: string) => {
    setData((prev) =>
      prev.map((c) => {
        if (c.portfolio_id !== id) return c;
        const numFields = ['investment_cost_usd_mn', 'current_valuation_usd', 'appraised_value_usd_mn'];
        let parsed: string | number | null = value;
        if (numFields.includes(field)) {
          parsed = value === '' ? null : parseFloat(value);
        }
        if (value === '') parsed = null;
        return { ...c, [field]: parsed };
      })
    );
    setDirty(true);
    setEditing(null);
  }, []);

  const handleSave = async () => {
    setSaving(true);
    try {
      const allRes = await fetch('/api/portfolio');
      const allData: PortfolioCompany[] = await allRes.json();
      const merged = allData.map((c) => {
        const updated = data.find((d) => d.portfolio_id === c.portfolio_id);
        return updated || c;
      });
      await fetch('/api/portfolio', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(merged),
      });
      setDirty(false);
    } catch (e) {
      alert('Save failed: ' + e);
    } finally {
      setSaving(false);
    }
  };

  const MissingBadge = () => (
    <span className="inline-block bg-red-100 text-red-600 text-xs px-1.5 py-0.5 rounded font-medium">?</span>
  );

  const renderCell = (company: PortfolioCompany, field: string, display: string | null, isNumber = false) => {
    const isEditing = editing?.id === company.portfolio_id && editing?.field === field;

    if (isEditing) {
      return (
        <input
          autoFocus
          className="w-full border border-blue-400 rounded px-1 py-0.5 text-sm bg-blue-50 outline-none"
          defaultValue={display || ''}
          onBlur={(e) => updateCell(company.portfolio_id, field, e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') updateCell(company.portfolio_id, field, (e.target as HTMLInputElement).value);
            if (e.key === 'Escape') setEditing(null);
          }}
        />
      );
    }

    return (
      <span
        className={`cursor-pointer hover:bg-blue-50 px-1 py-0.5 rounded transition-colors block ${
          display === null ? '' : ''
        }`}
        onClick={() => setEditing({ id: company.portfolio_id, field })}
        title="Click to edit"
      >
        {display !== null ? (isNumber ? display : display) : <MissingBadge />}
      </span>
    );
  };

  const SortIcon = ({ field }: { field: SortKey }) => (
    <span className="ml-1 text-zinc-300">{sortKey === field ? (sortDir === 'asc' ? '\u25b2' : '\u25bc') : '\u25b4'}</span>
  );

  return (
    <div>
      <div className="flex items-center justify-between mb-4 gap-4">
        <div className="flex gap-3 items-center">
          <input
            type="text"
            placeholder="Search company..."
            className="border border-zinc-300 rounded-lg px-3 py-1.5 text-sm w-56"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          <select
            className="border border-zinc-300 rounded-lg px-3 py-1.5 text-sm"
            value={filterSector}
            onChange={(e) => setFilterSector(e.target.value)}
          >
            <option value="">All sectors</option>
            {SECTOR_OPTIONS.map((s) => (
              <option key={s} value={s}>{s}</option>
            ))}
          </select>
          <span className="text-sm text-zinc-400">{filtered.length} companies</span>
        </div>
        {dirty && (
          <button
            onClick={handleSave}
            disabled={saving}
            className="bg-blue-600 text-white px-4 py-1.5 rounded-lg text-sm font-medium hover:bg-blue-700 disabled:opacity-50"
          >
            {saving ? 'Saving...' : 'Save Changes'}
          </button>
        )}
      </div>

      <div className="overflow-x-auto border border-zinc-200 rounded-xl">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-zinc-50 text-left text-zinc-500 text-xs uppercase tracking-wider">
              <th className="px-3 py-3 cursor-pointer" onClick={() => handleSort('company')}>Company<SortIcon field="company" /></th>
              <th className="px-3 py-3">Entity</th>
              <th className="px-3 py-3 cursor-pointer" onClick={() => handleSort('sector')}>Sector<SortIcon field="sector" /></th>
              <th className="px-3 py-3">Stage</th>
              <th className="px-3 py-3">Instrument</th>
              <th className="px-3 py-3 cursor-pointer" onClick={() => handleSort('initial_investment_date')}>Date<SortIcon field="initial_investment_date" /></th>
              <th className="px-3 py-3 text-right cursor-pointer" onClick={() => handleSort('investment_cost_usd_mn')}>Cost ($M)<SortIcon field="investment_cost_usd_mn" /></th>
              <th className="px-3 py-3 text-right cursor-pointer" onClick={() => handleSort('current_valuation_usd')}>Val ($M)<SortIcon field="current_valuation_usd" /></th>
              <th className="px-3 py-3 text-right cursor-pointer" onClick={() => handleSort('appraised_value_usd_mn')}>Appraised ($M)<SortIcon field="appraised_value_usd_mn" /></th>
              <th className="px-3 py-3 text-right">Return</th>
            </tr>
          </thead>
          <tbody>
            {filtered.map((c, i) => (
              <tr key={c.portfolio_id} className={`border-t border-zinc-100 ${i % 2 === 0 ? 'bg-white' : 'bg-zinc-50/50'} hover:bg-blue-50/30`}>
                <td className="px-3 py-2 font-medium">
                  <Link href={`/company/${c.portfolio_id}`} className="text-blue-600 hover:underline">
                    {c.company}
                  </Link>
                </td>
                <td className="px-3 py-2 text-zinc-500 max-w-[200px] truncate">{renderCell(c, 'entity_name', c.entity_name)}</td>
                <td className="px-3 py-2">{renderCell(c, 'sector', c.sector)}</td>
                <td className="px-3 py-2">{renderCell(c, 'stage_at_investment', c.stage_at_investment)}</td>
                <td className="px-3 py-2 text-zinc-500">{shortenInstrument(c.investment_type)}</td>
                <td className="px-3 py-2">{renderCell(c, 'initial_investment_date', c.initial_investment_date)}</td>
                <td className="px-3 py-2 text-right font-mono">{renderCell(c, 'investment_cost_usd_mn', fmtMoney(c.investment_cost_usd_mn), true)}</td>
                <td className="px-3 py-2 text-right font-mono">{renderCell(c, 'current_valuation_usd', fmtMoney(c.current_valuation_usd), true)}</td>
                <td className="px-3 py-2 text-right font-mono">{renderCell(c, 'appraised_value_usd_mn', fmtMoney(c.appraised_value_usd_mn), true)}</td>
                <td className="px-3 py-2 text-right font-mono">{renderCell(c, 'return', c.return)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
