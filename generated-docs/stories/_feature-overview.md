# Feature: BetterBond Commission Payments POC

## Summary

A three-screen frontend application that allows BetterBond staff to view commission payment metrics by agency, manage payments (park, unpark, and initiate payment batches), and review historical payment batches with downloadable invoices.

The application connects to a live REST API defined in `documentation/Api Definition.yaml` (base URL: `http://localhost:8042`).

## Epics

1. **Epic 1: Dashboard** - At-a-glance commission payment metrics and agency summary grid with dynamic chart filtering by selected agency | Status: In Progress | Dir: `epic-1-dashboard/`
2. **Epic 2: Payment Management** - Per-agency operational screen for viewing ready payments, parking/unparking individual or bulk payments, and initiating payment batches with invoice generation | Status: Pending | Dir: `epic-2-payment-management/`
3. **Epic 3: Payments Made** - Historical view of processed payment batches per agency with search/filter and invoice PDF download | Status: Pending | Dir: `epic-3-payments-made/`

## Epic 1 Stories

| # | Title | File | Status |
|---|-------|------|--------|
| 1 | Home Page Setup | `epic-1-dashboard/story-1-home-page-setup.md` | Pending |
| 2 | Dashboard Metrics and Charts | `epic-1-dashboard/story-2-dashboard-metrics-and-charts.md` | Pending |
| 3 | Agency Summary Grid | `epic-1-dashboard/story-3-agency-summary-grid.md` | Pending |
| 4 | Agency Filter | `epic-1-dashboard/story-4-agency-filter.md` | Pending |
