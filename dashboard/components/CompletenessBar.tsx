'use client';
import { DataCompleteness } from '@/lib/types';

export default function CompletenessBar({ items }: { items: DataCompleteness[] }) {
  return (
    <div className="border border-zinc-200 rounded-xl p-6 bg-white">
      <h3 className="font-semibold text-lg text-zinc-900 mb-4">Data Completeness</h3>
      <div className="space-y-3">
        {items.map((item) => (
          <div key={item.field}>
            <div className="flex justify-between text-sm mb-1">
              <span className="text-zinc-600">{item.label}</span>
              <span className={item.pct < 80 ? 'text-red-500 font-medium' : 'text-zinc-500'}>
                {item.filled}/{item.total} ({item.pct}%)
              </span>
            </div>
            <div className="h-2 bg-zinc-100 rounded-full overflow-hidden">
              <div
                className={`h-full rounded-full transition-all ${
                  item.pct >= 90 ? 'bg-emerald-500' : item.pct >= 80 ? 'bg-amber-400' : 'bg-red-400'
                }`}
                style={{ width: `${item.pct}%` }}
              />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
