# Story: Agency Filter

**Epic:** Dashboard | **Story:** 4 of 4 | **Wireframe:** `generated-docs/wireframes/screen-1-dashboard.md`

## Story Metadata

| Field | Value |
|-------|-------|
| **Route** | `/` |
| **Target File** | `app/page.tsx` |
| **Page Action** | `modify_existing` |

## User Story

**As a** BetterBond staff member
**I want** to filter the dashboard metrics and charts by selecting an agency from a dropdown
**So that** I can focus on the payment activity of a single agency without leaving the dashboard

## Acceptance Criteria

### Happy Path — Dropdown Presence and Default

- [ ] Given I am on the home page, when the page loads, then I see a dropdown in the header area labelled or defaulting to "All Agencies"
- [ ] Given I am on the home page, when I open the agency dropdown, then I see an option for "All Agencies" at the top of the list
- [ ] Given I am on the home page, when I open the agency dropdown, then I see one option per agency that has dashboard data (agency names from `PaymentsByAgency`)
- [ ] Given I am on the home page, when the page first loads, then all dashboard metric components show data for all agencies combined (the "All Agencies" default)

### Happy Path — Filtering Metrics

- [ ] Given I am on the home page with "All Agencies" selected, when I select a specific agency (e.g., "RE/MAX") from the dropdown, then the "Payments Ready for Payment" bar chart updates to show only RE/MAX's data
- [ ] Given I am on the home page with "All Agencies" selected, when I select a specific agency from the dropdown, then the "Parked Payments" bar chart updates to show only that agency's data
- [ ] Given I am on the home page with "All Agencies" selected, when I select a specific agency from the dropdown, then the "Total Value Ready for Payment" card updates to show only that agency's value
- [ ] Given I am on the home page with "All Agencies" selected, when I select a specific agency from the dropdown, then the "Total Value of Parked Payments" card updates to show only that agency's value
- [ ] Given I am on the home page with "All Agencies" selected, when I select a specific agency from the dropdown, then the "Parked Payments Aging" chart updates to show only that agency's aging data
- [ ] Given I am on the home page with "All Agencies" selected, when I select a specific agency from the dropdown, then the "Total Value of Payments Made (Last 14 Days)" card updates to show only that agency's value

### Happy Path — Filtering the Agency Grid

- [ ] Given I am on the home page with a specific agency selected, when I view the Agency Summary grid, then only the selected agency's row is shown in the grid
- [ ] Given I am on the home page with "All Agencies" selected, when I view the Agency Summary grid, then all agency rows are shown

### Happy Path — Manage Button Integration

- [ ] Given I am on the home page, when I click the "Manage" button for "Seeff" in the Agency Summary grid, then the agency dropdown updates to show "Seeff" as the selected agency
- [ ] Given I am on the home page, when I click the "Manage" button for any agency, then I am navigated to the Payment Management screen with that agency pre-selected

### Reset

- [ ] Given I am on the home page with a specific agency selected, when I select "All Agencies" from the dropdown, then all metric components revert to showing combined data for all agencies
- [ ] Given I am on the home page with a specific agency selected, when I select "All Agencies" from the dropdown, then the Agency Summary grid shows all agency rows again

### Edge Cases

- [ ] Given I am on the home page, when I select an agency that has parked payments but no ready payments, then the "Payments Ready for Payment" chart shows zero counts (not an error)
- [ ] Given I am on the home page, when I select an agency that has no aging report data, then the "Parked Payments Aging" chart shows zero counts (not an error)

## API Endpoints (from OpenAPI spec)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/payments/dashboard` | Fetch dashboard data (already fetched in Story 2; filtering is client-side) |

### Filtering Strategy

Filtering is performed **client-side** on the already-fetched `PaymentsDashboardRead` response:

- `PaymentStatusReport` items have an `AgencyName` field — filter by this when an agency is selected
- `ParkedPaymentsAgingReport` items have an `AgencyName` field — filter by this when an agency is selected
- `PaymentsByAgency` items have an `AgencyName` field — filter by this when an agency is selected
- When "All Agencies" is selected, no filter is applied (all items are included)

No additional API calls are needed for this story.

## Implementation Notes

- This is a client-side feature. The page (or a wrapper component) needs `"use client"` to manage the selected agency state.
- The dropdown should be placed in the top-right of the page header per the wireframe.
- Use Shadcn `<Select />` component for the dropdown.
- The agency list in the dropdown is derived from the unique `AgencyName` values in `PaymentsByAgency` from the dashboard response. Sort alphabetically.
- The selected agency state should be lifted to a level that allows both the metric components (Story 2) and the agency grid (Story 3) to receive the filtered data as props.
- Clicking a "Manage" button (Story 3) should: (1) set the selected agency in the dropdown, and (2) navigate to the Payment Management screen. Both happen together.
- Consider using React `useState` for the selected agency. Since filtering is client-side, no additional API calls are triggered on agency change.
- The data fetch can remain as a server component fetch (at build/request time). The client component receives the full `PaymentsDashboardRead` data and performs filtering in-memory.
- When an agency is selected via the dropdown, the Agency Summary grid should filter to show only that agency's row. This ties the dropdown selection to all six metric components AND the grid simultaneously.
