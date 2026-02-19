# Wireframes: BetterBond Commission Payments POC

## Summary
Three-screen UI for managing commission payment workflows: a dashboard with metrics and agency summary, an operational payment management screen with parking and initiation controls, and a historical payments-made screen with invoice access.

## Screens

| # | Screen | Description | File |
|---|--------|-------------|------|
| 1 | Dashboard | At-a-glance metrics (charts, value cards, aging report) and clickable agency summary grid | `screen-1-dashboard.md` |
| 2 | Payment Management | Per-agency grid of ready payments, bulk/single parking, parked payments grid with unpark, and initiate payment flow | `screen-2-payment-management.md` |
| 3 | Payments Made | Historical record of processed payments per agency with invoice download links | `screen-3-payments-made.md` |

## Screen Flow

```
[Dashboard] ──[Manage button on agency row]──> [Payment Management]
                                                       |
                                         [Initiate Payment confirmed]
                                                       |
                                               [Payments Made]
                                                       |
                                           [PDF link] --> Invoice (new tab)
```

## Modals (part of Screen 2)

| Modal | Trigger | Action on Confirm |
|-------|---------|-------------------|
| Park Single Payment | [Park] button on a row | Moves payment to Parked Grid |
| Park Multiple Payments | [Park Selected] with checkboxes | Moves selected payments to Parked Grid |
| Unpark Payment(s) | [Unpark] or [Unpark Selected] | Returns payments to Main Grid |
| Initiate Payment Confirmation | [Initiate Payment for All] button | Processes payments, generates invoice, clears Main Grid |
| Payment Processed Success | After initiate payment confirms | Shows success; links to Screen 3 |

## Design Notes

- **Agency context is persistent:** An agency dropdown in the header lets users switch context without returning to Dashboard. Dashboard charts and grids update dynamically on agency selection.
- **Main Grid columns:** Agency Name, Batch ID, Claim Date, Agent Name, Bond Amount, Commission Type, Commission %, Grant Date, Reg Date, Bank, Commission Amount, VAT, Status.
- **Commission Types:** "Bond Comm" and "Manual Payments".
- **Banks:** ABSA, FNB, STD, NED.
- **Status values:** REG, MAN-PAY.
- **Parked Grid** has identical columns to Main Grid, with [Unpark] replacing [Park].
- **Pagination** is required on Screen 3 (Payments Made) as records accumulate over time.
- **Invoice PDF** is auto-generated on payment initiation and accessible from Screen 3; invoice includes agency details, full payment list, commission % breakdown, VAT, and total.
- **Responsive considerations:** Grids will require horizontal scrolling on smaller viewports given the number of columns.
