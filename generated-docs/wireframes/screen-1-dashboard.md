# Screen: Dashboard

## Purpose
Provides an at-a-glance summary of commission payment activity segmented by agency, including charts, value metrics, and a clickable agency summary grid.

## Wireframe

```
+-----------------------------------------------------------------------------------+
|  BetterBond Commission Payments                             [Agency Dropdown v]   |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|  DASHBOARD                                                                        |
|  ─────────────────────────────────────────────────────────────────────────────── |
|                                                                                   |
|  +──────────────────────────────+  +──────────────────────────────+              |
|  | Payments Ready for Payment   |  | Parked Payments              |              |
|  | (Bar Chart)                  |  | (Bar Chart)                  |              |
|  |                              |  |                              |              |
|  |  Bond Comm  ████████ 142     |  |  Bond Comm  █████ 54        |              |
|  |  Manual Pay ████ 38          |  |  Manual Pay ██ 21           |              |
|  |                              |  |                              |              |
|  +──────────────────────────────+  +──────────────────────────────+              |
|                                                                                   |
|  +──────────────────────────────+  +──────────────────────────────+              |
|  | Total Value Ready            |  | Total Value Parked           |              |
|  | for Payment                  |  | Payments                     |              |
|  |                              |  |                              |              |
|  |   R 4 823 140,00             |  |   R 1 204 880,00             |              |
|  |                              |  |                              |              |
|  +──────────────────────────────+  +──────────────────────────────+              |
|                                                                                   |
|  +──────────────────────────────+  +──────────────────────────────+              |
|  | Parked Payments Aging        |  | Total Value of Payments Made |              |
|  | (Bar Chart)                  |  | (Last 14 Days)               |              |
|  |                              |  |                              |              |
|  |  1-3 Days  ███████ 32        |  |   R 12 440 200,00            |              |
|  |  4-7 Days  ████ 28           |  |                              |              |
|  |  >7 Days   ██ 15             |  |                              |              |
|  |                              |  |                              |              |
|  +──────────────────────────────+  +──────────────────────────────+              |
|                                                                                   |
|  AGENCY SUMMARY                                                                   |
|  ─────────────────────────────────────────────────────────────────────────────── |
|                                                                                   |
|  +───────────────────────┬──────────────┬────────────────────┬──────┬──────────+ |
|  | Agency Name           | # Payments   | Total Commission   | VAT  | Action   | |
|  +───────────────────────┼──────────────┼────────────────────┼──────┼──────────+ |
|  | ABC Bond Originators  | 42           | R 198 340,00       | R 27 | [Manage] | |
|  +───────────────────────┼──────────────┼────────────────────┼──────┼──────────+ |
|  | Cape Home Loans       | 31           | R 154 200,00       | R 21 | [Manage] | |
|  +───────────────────────┼──────────────┼────────────────────┼──────┼──────────+ |
|  | First Bond Services   | 27           | R 132 890,00       | R 18 | [Manage] | |
|  +───────────────────────┼──────────────┼────────────────────┼──────┼──────────+ |
|  | National Bond Co      | 22           | R 112 440,00       | R 15 | [Manage] | |
|  +───────────────────────┼──────────────┼────────────────────┼──────┼──────────+ |
|  | Pinelands Bonds       | 18           | R 91 220,00        | R 12 | [Manage] | |
|  +───────────────────────┴──────────────┴────────────────────┴──────┴──────────+ |
|                                                                                   |
+-----------------------------------------------------------------------------------+
```

## Elements

| Element | Type | Description |
|---------|------|-------------|
| Agency Dropdown | Dropdown | Filters all dashboard components to a specific agency; defaults to "All Agencies" |
| Payments Ready for Payment | Bar Chart | Shows count of ready payments split by Bond Comm vs Manual Payments |
| Parked Payments | Bar Chart | Shows count of parked payments split by Bond Comm vs Manual Payments |
| Total Value Ready for Payment | Metric Card | Sum of commission amounts for payments awaiting processing |
| Total Value Parked Payments | Metric Card | Aggregated value of all parked payments |
| Parked Payments Aging | Bar Chart | How long payments have been parked, grouped into 1-3, 4-7, >7 days |
| Total Value of Payments Made (Last 14 Days) | Metric Card | Aggregate of all payments processed in the past 14 days |
| Agency Summary Grid | Data Grid | One row per agency with payment counts and commission totals |
| [Manage] Button | Button | Navigates to Payment Management Screen (Screen 2) for that agency; also updates dashboard charts |

## User Actions

- Select agency from dropdown: All dashboard charts and metric cards update dynamically to reflect that agency's data
- Click row in agency grid (or [Manage] button): Charts update to reflect selected agency AND user navigates to Screen 2 (Payment Management) for that agency
- View charts: Read-only; no interaction beyond agency selection

## Navigation

- **From:** Top-level navigation / application entry point
- **To:** Screen 2 (Payment Management) when a [Manage] button is clicked
