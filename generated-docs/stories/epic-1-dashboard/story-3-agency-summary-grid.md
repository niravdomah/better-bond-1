# Story: Agency Summary Grid

**Epic:** Dashboard | **Story:** 3 of 4 | **Wireframe:** `generated-docs/wireframes/screen-1-dashboard.md`

## Story Metadata

| Field | Value |
|-------|-------|
| **Route** | `/` |
| **Target File** | `app/page.tsx` |
| **Page Action** | `modify_existing` |

## User Story

**As a** BetterBond staff member
**I want** to see a summary table of all agencies with their payment counts and commission totals on the home page
**So that** I can compare agency performance at a glance and navigate to a specific agency's payments

## Acceptance Criteria

### Happy Path — Grid Display

- [ ] Given I am on the home page, when the page loads, then I see a table under the "AGENCY SUMMARY" heading
- [ ] Given I am on the home page, when the page loads, then the table has columns: "Agency Name", "# Payments", "Total Commission Amount", "VAT", and "Action"
- [ ] Given I am on the home page, when the page loads, then each row in the table shows the agency's name, payment count, total commission amount, and VAT
- [ ] Given I am on the home page, when the page loads, then the "Total Commission Amount" and "VAT" values are formatted in South African Rand (e.g., "R 198 340,00")
- [ ] Given I am on the home page, when the page loads, then each row has a "Manage" button in the "Action" column
- [ ] Given I am on the home page, when multiple agencies have data, then all agencies are shown as separate rows in the grid

### Happy Path — Navigation

- [ ] Given I am on the home page, when I click the "Manage" button for an agency, then I am navigated to the Payment Management screen for that agency
- [ ] Given I am on the home page, when I click the "Manage" button for "RE/MAX", then the Payment Management screen shows "RE/MAX" as the active agency context

### Edge Cases

- [ ] Given I am on the home page, when no agencies have ready payments, then the Agency Summary table is empty (shows no rows, or a "No agencies with ready payments" message)
- [ ] Given I am on the home page, when an agency name is long, then it is displayed without truncation or wraps cleanly within its column

### Loading State

- [ ] Given I am on the home page, when the agency data is being fetched, then I see a loading state in the Agency Summary section

### Error State

- [ ] Given I am on the home page, when the API call for agency data fails, then I see an error message in the Agency Summary section

## API Endpoints (from OpenAPI spec)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/payments/dashboard` | Fetch agency summary data (same call as Story 2) |

### Data Source

The agency grid is populated from `PaymentsDashboardRead.PaymentsByAgency`:

```typescript
Array<{
  AgencyName: string;
  PaymentCount: number;         // # Payments (ready for payment, not parked)
  TotalCommissionCount: number; // Total Commission Amount (note: field name is "Count" but contains a monetary value)
  Vat: number;                  // VAT
}>
```

Note: `TotalCommissionCount` is a monetary value despite the field name containing "Count" — display it formatted as currency.

## Implementation Notes

- This story reuses the same `GET /v1/payments/dashboard` API response already fetched in Story 2. Do not make a second API call — pass `PaymentsByAgency` down from the shared data fetch.
- The "Manage" button navigates to Screen 2 (Payment Management). The route for Screen 2 will be `/payment-management` with a query parameter for the selected agency: `/payment-management?agency=RE%2FMAX`. The exact route will be confirmed in Epic 2; for now, use a placeholder route or a relative path that can be updated.
- The grid is read-only in this story. The agency filter interaction (Story 4) may change which rows are visible — design the component to accept a filtered list of agencies as a prop.
- Use Shadcn `<Table />` component for the grid.
- Currency formatting: South African Rand, en-ZA locale (same as Story 2).
- The spec says the grid shows agencies with payments "ready for payment, not parked" — this matches the `PaymentsByAgency` data from the dashboard endpoint.
- Clicking the "Manage" button on a row also pre-selects that agency in the dashboard filter (Story 4 behaviour). In this story, only navigation is required; filter update will be wired in Story 4.
