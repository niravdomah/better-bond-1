# Screen: Payments Made

## Purpose
Displays all successfully processed payments grouped by agency, with invoice download links and search functionality.

## Wireframe

```
+-----------------------------------------------------------------------------------+
|  BetterBond Commission Payments                             [Agency Dropdown v]   |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|  PAYMENTS MADE                                                                    |
|  ─────────────────────────────────────────────────────────────────────────────── |
|                                                                                   |
|  [Search by Agency Name or Batch ID...]                                          |
|                                                                                   |
|  +────────────────────────┬──────────────┬────────────────────┬──────┬─────────+ |
|  | Agency Name            | # Payments   | Total Commission   | VAT  | Invoice | |
|  +────────────────────────┼──────────────┼────────────────────┼──────┼─────────+ |
|  | ABC Bond Originators   | 42           | R 198 340,00       | R 27 768 | [PDF] | |
|  +────────────────────────┼──────────────┼────────────────────┼──────┼─────────+ |
|  | ABC Bond Originators   | 38           | R 182 100,00       | R 25 494 | [PDF] | |
|  +────────────────────────┼──────────────┼────────────────────┼──────┼─────────+ |
|  | Cape Home Loans        | 31           | R 154 200,00       | R 21 588 | [PDF] | |
|  +────────────────────────┼──────────────┼────────────────────┼──────┼─────────+ |
|  | First Bond Services    | 27           | R 132 890,00       | R 18 605 | [PDF] | |
|  +────────────────────────┼──────────────┼────────────────────┼──────┼─────────+ |
|  | National Bond Co       | 22           | R 112 440,00       | R 15 742 | [PDF] | |
|  +────────────────────────┼──────────────┼────────────────────┼──────┼─────────+ |
|  | Pinelands Bonds        | 18           | R 91 220,00        | R 12 771 | [PDF] | |
|  +────────────────────────┴──────────────┴────────────────────┴──────┴─────────+ |
|                                                                                   |
|  Showing 6 of 24 records                            [< Prev]  Page 1  [Next >]  |
|                                                                                   |
+-----------------------------------------------------------------------------------+


── INVOICE PDF (opens in new tab or downloads) ──────────────────────────────────────
|                                                                                    |
|  BETTERBOND COMMISSION INVOICE                                                   |
|  ──────────────────────────────────────────────────────────────────             |
|  Invoice #:   INV-2026-10041          Date: 2026-02-19                           |
|  Agency:      ABC Bond Originators                                               |
|  Batch ID:    B-10041                                                            |
|                                                                                    |
|  +─────────────────────────┬──────────────┬───────────┬──────────┬────────────+ |
|  | Agent Name              | Bond Amount  | Comm %    | Comm Amt | VAT        | |
|  +─────────────────────────┼──────────────┼───────────┼──────────┼────────────+ |
|  | John Smith              | R 2 000 000  | 0.945%    | R 18 900 | R 2 835    | |
|  | Sarah Johnson           | R 1 500 000  | 1.000%    | R 15 000 | R 2 250    | |
|  | Mike van der Berg       | R 3 200 000  | 0.945%    | R 30 240 | R 4 536    | |
|  | ...                                                                          | |
|  +─────────────────────────┴──────────────┴───────────┴──────────┴────────────+ |
|                                                                                    |
|  Subtotal (Commission):   R 198 340,00                                           |
|  VAT (15%):               R 27 768,00                                            |
|  ──────────────────────────────────────                                          |
|  TOTAL:                   R 226 108,00                                           |
|                                                                                    |
────────────────────────────────────────────────────────────────────────────────────
```

## Elements

| Element | Type | Description |
|---------|------|-------------|
| Agency Dropdown | Dropdown | Filter the grid to show only records for a specific agency |
| Search bar | Input | Filter records by Agency Name or Batch ID in real time |
| Payments Made Grid | Data Grid | One row per processed batch; shows agency, payment count, commission total, VAT, and invoice link |
| [PDF] button | Button/Link | Opens or downloads the generated PDF invoice for that batch |
| Pagination controls | Navigation | Previous/Next page navigation; shows current page and total record count |

## User Actions

- Type in search bar: Grid filters to matching agency names or batch IDs
- Select from agency dropdown: Grid narrows to that agency's payment history
- Click [PDF]: Invoice PDF opens in a new browser tab or triggers a file download
- Click [< Prev] / [Next >]: Navigate between pages of results

## Navigation

- **From:** Screen 2 (Payment Management) via "View Payments Made" link in payment processed success modal; also accessible from top navigation
- **To:** Invoice PDF (new tab/download); no other screen navigation from this screen
