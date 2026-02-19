export default function HomePage() {
  return (
    <div>
      <header className="w-full bg-background border-b px-6 py-4">
        <span className="text-lg font-semibold">
          BetterBond Commission Payments
        </span>
      </header>
      <main className="px-6 py-8">
        <h1 className="text-2xl font-bold tracking-widest mb-6">DASHBOARD</h1>
        <section aria-labelledby="agency-summary-heading" className="mt-8">
          <h2
            id="agency-summary-heading"
            className="text-xl font-bold tracking-widest mb-4"
          >
            AGENCY SUMMARY
          </h2>
        </section>
      </main>
    </div>
  );
}
