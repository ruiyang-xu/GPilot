import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import Link from "next/link";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "GPilot — Portfolio Dashboard",
  description: "Investment portfolio single source of truth",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex bg-zinc-50 text-zinc-900">
        <nav className="w-56 bg-white border-r border-zinc-200 p-4 flex-shrink-0 sticky top-0 h-screen">
          <Link href="/" className="block mb-6">
            <h1 className="text-lg font-bold text-zinc-800">GPilot</h1>
            <p className="text-xs text-zinc-400">Portfolio Dashboard</p>
          </Link>
          <div className="space-y-1">
            <Link href="/" className="block px-3 py-2 rounded-lg text-sm hover:bg-zinc-100 text-zinc-600 hover:text-zinc-900">
              Overview
            </Link>
            {/* Customize: add your fund links below. Slugs must match FUND_SLUGS in lib/types.ts */}
            <p className="px-3 pt-3 pb-1 text-xs text-zinc-400 uppercase tracking-wider">Portfolios</p>
            <Link href="/fund/portfolio-alpha" className="block px-3 py-2 rounded-lg text-sm hover:bg-zinc-100 text-zinc-600 hover:text-zinc-900">
              Portfolio Alpha
            </Link>
            <Link href="/fund/portfolio-beta" className="block px-3 py-2 rounded-lg text-sm hover:bg-zinc-100 text-zinc-600 hover:text-zinc-900">
              Portfolio Beta
            </Link>
          </div>
        </nav>
        <main className="flex-1 p-8 overflow-auto">{children}</main>
      </body>
    </html>
  );
}
