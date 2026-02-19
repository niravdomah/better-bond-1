# Story: Dashboard Metrics and Charts

**Epic:** Dashboard | **Story:** 2 of 4 | **Wireframe:** `generated-docs/wireframes/screen-1-dashboard.md`

## Story Metadata

| Field | Value |
|-------|-------|
| **Route** | `/` |
| **Target File** | `app/page.tsx` |
| **Page Action** | `modify_existing` |

## User Story

**As a** BetterBond staff member
**I want** to see commission payment metrics and charts on the home page
**So that** I can quickly understand the current state of payments ready for processing, parked payments, and recently completed payments

## Acceptance Criteria

### Happy Path — Payments Ready for Payment (Bar Chart)

- [ ] Given I am on the home page, when the page loads, then I see a chart titled "Payments Ready for Payment"
- [ ] Given I am on the home page, when the page loads, then the "Payments Ready for Payment" chart shows two bars: one labelled "Bond Comm" and one labelled "Manual Payments"
- [ ] Given I am on the home page, when the page loads, then each bar in the "Payments Ready for Payment" chart displays a numeric count value

### Happy Path — Parked Payments (Bar Chart)

- [ ] Given I am on the home page, when the page loads, then I see a chart titled "Parked Payments"
- [ ] Given I am on the home page, when the page loads, then the "Parked Payments" chart shows two bars: one labelled "Bond Comm" and one labelled "Manual Payments"
- [ ] Given I am on the home page, when the page loads, then each bar in the "Parked Payments" chart displays a numeric count value

### Happy Path — Total Value Ready for Payment (Metric Card)

- [ ] Given I am on the home page, when the page loads, then I see a card titled "Total Value Ready for Payment"
- [ ] Given I am on the home page, when the page loads, then the "Total Value Ready for Payment" card displays a currency value formatted in South African Rand (e.g., "R 4 823 140,00")

### Happy Path — Total Value of Parked Payments (Metric Card)

- [ ] Given I am on the home page, when the page loads, then I see a card titled "Total Value of Parked Payments"
- [ ] Given I am on the home page, when the page loads, then the "Total Value of Parked Payments" card displays a currency value formatted in South African Rand

### Happy Path — Parked Payments Aging (Bar Chart)

- [ ] Given I am on the home page, when the page loads, then I see a chart titled "Parked Payments Aging"
- [ ] Given I am on the home page, when the page loads, then the "Parked Payments Aging" chart shows three bars with labels "1-3 Days", "4-7 Days", and ">7 Days"
- [ ] Given I am on the home page, when the page loads, then each bar in the "Parked Payments Aging" chart displays a numeric count value

### Happy Path — Total Value of Payments Made (Metric Card)

- [ ] Given I am on the home page, when the page loads, then I see a card titled "Total Value of Payments Made (Last 14 Days)"
- [ ] Given I am on the home page, when the page loads, then the "Total Value of Payments Made (Last 14 Days)" card displays a currency value formatted in South African Rand

### Loading State

- [ ] Given I am on the home page, when the dashboard data is being fetched, then I see a loading indicator in the metrics area
- [ ] Given I am on the home page, when the dashboard data finishes loading, then the loading indicator is replaced by the metric components

### Error State

- [ ] Given I am on the home page, when the API call to `GET /v1/payments/dashboard` fails, then I see an error message that the dashboard data could not be loaded
- [ ] Given I am on the home page, when the API call fails, then the error message is visible on screen (not just in the console)

## API Endpoints (from OpenAPI spec)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/payments/dashboard` | Fetch all dashboard metrics |

### Response Shape (`PaymentsDashboardRead`)

```typescript
{
  PaymentStatusReport: Array<{
    Status: string;           // e.g. "READY", "PARKED"
    PaymentCount: number;
    TotalPaymentAmount: number;
    CommissionType: string;   // "Bond Comm" | "Manual Payments"
    AgencyName: string;
  }>;
  ParkedPaymentsAgingReport: Array<{
    Range: string;            // "1-3", "4-7", ">7"
    AgencyName: string;
    PaymentCount: number;
  }>;
  TotalPaymentCountInLast14Days: number;
  PaymentsByAgency: Array<{
    AgencyName: string;
    PaymentCount: number;
    TotalCommissionCount: number;
    Vat: number;
  }>;
}
```

### Derived Metrics (computed from `PaymentStatusReport`)

- **Payments Ready for Payment chart:** Filter where `Status === "READY"`, group by `CommissionType`, sum `PaymentCount`
- **Parked Payments chart:** Filter where `Status === "PARKED"`, group by `CommissionType`, sum `PaymentCount`
- **Total Value Ready for Payment:** Filter where `Status === "READY"`, sum `TotalPaymentAmount`
- **Total Value of Parked Payments:** Filter where `Status === "PARKED"`, sum `TotalPaymentAmount`
- **Total Value of Payments Made (Last 14 Days):** Derived from `TotalPaymentCountInLast14Days` — note: the API returns a count, not a value. If a total value field is absent from the API response, display the count or flag this gap to the user.

## Implementation Notes

- API base URL: `http://localhost:8042` (defined in `documentation/Api Definition.yaml`)
- All API calls must go through `web/src/lib/api/client.ts` — never call `fetch()` directly
- Currency formatting must use South African locale (en-ZA): thousand separator is a non-breaking space, decimal separator is a comma. Example: `R 1 234 567,89`. Use `Intl.NumberFormat('en-ZA', { style: 'currency', currency: 'ZAR' })` or equivalent.
- **Charting library:** Recharts is NOT installed in `web/package.json`. Before implementing chart components, install Recharts: `npm install recharts` from the `web/` directory. Charts must be client-side — add `"use client"` to any component that uses Recharts.
- The six metric components are arranged in a 2-column grid per the wireframe (3 rows of 2). Insert this grid in `app/page.tsx` between the existing `<h1>DASHBOARD</h1>` heading and the existing `<section aria-labelledby="agency-summary-heading">` section.
- The agency dropdown filter (Story 4) will later pass a selected agency name to these components. Design the metric components to accept an optional `agencyName` prop — defaulting to "all agencies" (no filter) for this story.
- Data fetching should happen server-side where possible (page-level fetch) and passed as props to client components.
- Note: `TotalPaymentCountInLast14Days` is a count, not a monetary value. The spec says "Total Value of Payments Made (Last 14 Days)" — if the API only provides a count, display the count with appropriate label and flag the discrepancy in a code comment for future resolution.
