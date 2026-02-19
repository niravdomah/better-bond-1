# Screen: Payment Management

## Purpose
Operational hub for viewing, managing, parking, and initiating commission payments for a selected agency.

## Wireframe

```
+-----------------------------------------------------------------------------------+
|  BetterBond Commission Payments                             [Agency Dropdown v]   |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|  < Back to Dashboard    PAYMENT MANAGEMENT - ABC Bond Originators                 |
|  ─────────────────────────────────────────────────────────────────────────────── |
|                                                                                   |
|  PAYMENTS READY FOR PAYMENT                                                       |
|                                                                                   |
|  [Search by Claim Date, Agency Name, or Status...]         [Park Selected]       |
|                                                                                   |
|  +──┬────────────────┬──────────┬────────────┬──────────────────┬──────────────+ |
|  |[ ]| Agency Name   | Batch ID | Claim Date | Agent Name       | Bond Amount  | |
|  +──┼────────────────┼──────────┼────────────┼──────────────────┼──────────────+ |
|  |[ ]| ABC Bond Orig | B-10041  | 2026-01-15 | John Smith       | R 2 000 000  | |
|  |  | Comm Type: Bond Comm | Comm %: 0.945% | Grant: 2026-01-20 | Reg: 2026-01-25 ||
|  |  | Bank: ABSA | Comm Amt: R 18 900 | VAT: R 2 835 | Status: REG | [Park]      | |
|  +──┼────────────────┼──────────┼────────────┼──────────────────┼──────────────+ |
|  |[ ]| ABC Bond Orig | B-10042  | 2026-01-16 | Sarah Johnson    | R 1 500 000  | |
|  |  | Comm Type: Manual Pay | Comm %: 1.000% | Grant: 2026-01-22 | Reg: 2026-01-27||
|  |  | Bank: FNB | Comm Amt: R 15 000 | VAT: R 2 250 | Status: MAN-PAY | [Park]  | |
|  +──┼────────────────┼──────────┼────────────┼──────────────────┼──────────────+ |
|  |[ ]| ABC Bond Orig | B-10043  | 2026-01-17 | Mike van der Berg | R 3 200 000 | |
|  |  | Comm Type: Bond Comm | Comm %: 0.945% | Grant: 2026-01-23 | Reg: 2026-01-28||
|  |  | Bank: STD | Comm Amt: R 30 240 | VAT: R 4 536 | Status: REG | [Park]      | |
|  +──┴────────────────┴──────────┴────────────┴──────────────────┴──────────────+ |
|                                                                                   |
|                                    [Initiate Payment for All (42) - R 198 340,00]|
|                                                                                   |
|  ─────────────────────────────────────────────────────────────────────────────── |
|  PARKED PAYMENTS                                                                  |
|                                                                                   |
|  [Search parked payments...]                               [Unpark Selected]     |
|                                                                                   |
|  +──┬────────────────┬──────────┬────────────┬──────────────────┬──────────────+ |
|  |[ ]| Agency Name   | Batch ID | Claim Date | Agent Name       | Bond Amount  | |
|  +──┼────────────────┼──────────┼────────────┼──────────────────┼──────────────+ |
|  |[ ]| ABC Bond Orig | B-10038  | 2026-01-10 | Linda Pretorius  | R 850 000    | |
|  |  | Comm Type: Bond Comm | Comm %: 0.945% | Grant: 2026-01-15 | Reg: 2026-01-18||
|  |  | Bank: NED | Comm Amt: R 8 033 | VAT: R 1 205 | Status: REG | [Unpark]    | |
|  +──┼────────────────┼──────────┼────────────┼──────────────────┼──────────────+ |
|  |[ ]| ABC Bond Orig | B-10039  | 2026-01-11 | David Coetzee    | R 1 100 000  | |
|  |  | Comm Type: Manual Pay | Comm %: 1.000% | Grant: 2026-01-16 | Reg: 2026-01-20||
|  |  | Bank: ABSA | Comm Amt: R 11 000 | VAT: R 1 650 | Status: MAN-PAY | [Unpark]|| |
|  +──┴────────────────┴──────────┴────────────┴──────────────────┴──────────────+ |
|                                                                                   |
+-----------------------------------------------------------------------------------+


── MODAL: Park Single Payment ───────────────────────────────────────────────────────
|                                                                                    |
|  Park Payment                                                    [x]              |
|  ──────────────────────────────────────────────────────────────────              |
|  Are you sure you want to park this payment?                                     |
|                                                                                    |
|  Agent:       John Smith                                                          |
|  Claim Date:  2026-01-15                                                          |
|  Amount:      R 18 900,00                                                         |
|                                                                                    |
|                                    [Cancel]  [Yes, Park Payment]                 |
|                                                                                    |
────────────────────────────────────────────────────────────────────────────────────


── MODAL: Park Multiple Payments ────────────────────────────────────────────────────
|                                                                                    |
|  Park Selected Payments                                          [x]              |
|  ──────────────────────────────────────────────────────────────────              |
|  You are about to park 3 payments.                                               |
|                                                                                    |
|  Total combined amount:  R 64 140,00                                             |
|                                                                                    |
|                                    [Cancel]  [Yes, Park Payments]                |
|                                                                                    |
────────────────────────────────────────────────────────────────────────────────────


── MODAL: Unpark Payment(s) ─────────────────────────────────────────────────────────
|                                                                                    |
|  Unpark Payment(s)                                               [x]              |
|  ──────────────────────────────────────────────────────────────────              |
|  You are about to unpark 1 payment.                                              |
|                                                                                    |
|  Agent:       Linda Pretorius                                                     |
|  Claim Date:  2026-01-10                                                          |
|  Amount:      R 8 033,00                                                          |
|                                                                                    |
|                                    [Cancel]  [Yes, Unpark Payment]               |
|                                                                                    |
────────────────────────────────────────────────────────────────────────────────────


── MODAL: Initiate Payment Confirmation ─────────────────────────────────────────────
|                                                                                    |
|  Initiate Payment                                                [x]              |
|  ──────────────────────────────────────────────────────────────────              |
|  You are about to initiate payment for:                                          |
|                                                                                    |
|  Agency:            ABC Bond Originators                                          |
|  Number of payments: 42                                                           |
|  Total value:       R 198 340,00                                                  |
|                                                                                    |
|  An invoice will be generated automatically for this batch.                      |
|                                                                                    |
|                                    [Cancel]  [Yes, Initiate Payment]             |
|                                                                                    |
────────────────────────────────────────────────────────────────────────────────────


── MODAL: Payment Processed Success ─────────────────────────────────────────────────
|                                                                                    |
|  Payment Processed                                               [x]              |
|  ──────────────────────────────────────────────────────────────────              |
|  Payment has been successfully processed.                                        |
|                                                                                    |
|  Agency:    ABC Bond Originators                                                  |
|  Payments:  42                                                                    |
|  Total:     R 198 340,00                                                          |
|  Invoice:   Generated and available in Payments Made                             |
|                                                                                    |
|                                                        [View Payments Made]      |
|                                                                                    |
────────────────────────────────────────────────────────────────────────────────────
```

## Elements

| Element | Type | Description |
|---------|------|-------------|
| Back to Dashboard link | Link | Returns user to Screen 1 (Dashboard) |
| Agency Dropdown | Dropdown | Switch to a different agency without returning to dashboard |
| Search bar (Main Grid) | Input | Filter main grid by Claim Date, Agency Name, or Status |
| Row checkbox | Checkbox | Select individual payments for bulk actions |
| [Park] button (per row) | Button | Triggers single-payment park confirmation modal |
| [Park Selected] button | Button | Triggers bulk park confirmation modal; disabled when no rows selected |
| [Initiate Payment for All] button | Button | Triggers initiate payment confirmation modal; shows count and total value |
| Search bar (Parked Grid) | Input | Filter parked grid |
| [Unpark] button (per row) | Button | Triggers single unpark confirmation modal |
| [Unpark Selected] button | Button | Triggers bulk unpark confirmation modal; disabled when no rows selected |
| Park Single Modal | Modal | Confirms single payment parking with agent name, date, amount |
| Park Multiple Modal | Modal | Confirms bulk parking with count and total |
| Unpark Modal | Modal | Confirms unparking with payment details |
| Initiate Payment Modal | Modal | Summarises agency, count, total before processing |
| Payment Processed Modal | Modal | Success confirmation with link to Payments Made screen |

## User Actions

- Search main grid: Grid filters in real time by Claim Date, Agency Name, or Status
- Check single row checkbox: Row is selected; [Park Selected] becomes active
- Click [Park]: Park modal appears for that specific row
- Confirm Park: Payment moves from Main Grid to Parked Grid
- Click [Park Selected]: Bulk park modal appears with count and combined total
- Confirm bulk park: All selected payments move to Parked Grid
- Click [Unpark] on parked row: Unpark modal appears
- Confirm Unpark: Payment moves from Parked Grid back to Main Grid
- Click [Initiate Payment for All]: Initiate payment modal appears with summary
- Confirm Initiate Payment: Payments are processed, invoice is generated, Main Grid is cleared, success modal appears
- Click [View Payments Made] in success modal: Navigates to Screen 3

## Navigation

- **From:** Screen 1 (Dashboard) via [Manage] button on agency row
- **To:** Screen 1 (Dashboard) via Back link; Screen 3 (Payments Made) via success modal link
