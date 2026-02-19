# Story: Home Page Setup

**Epic:** Dashboard | **Story:** 1 of 4 | **Wireframe:** `generated-docs/wireframes/screen-1-dashboard.md`

## Story Metadata

| Field | Value |
|-------|-------|
| **Route** | `/` |
| **Target File** | `app/page.tsx` |
| **Page Action** | `modify_existing` |

## User Story

**As a** BetterBond staff member
**I want** to see the Dashboard when I open the application
**So that** I can immediately access commission payment metrics without navigating elsewhere

## Acceptance Criteria

### Happy Path

- [ ] Given I visit `/`, when the page loads, then I see the heading "DASHBOARD" on the page (the template placeholder is replaced)
- [ ] Given I visit `/`, when the page loads, then I see the application header containing the text "BetterBond Commission Payments"
- [ ] Given I visit `/`, when the page loads, then the page does not show the text "Replace this with your feature implementation"
- [ ] Given I visit `/`, when the page loads, then I see a section labelled "AGENCY SUMMARY" on the page

### Layout

- [ ] Given I visit `/`, when the page loads, then the header spans the full width of the page at the top
- [ ] Given I visit `/`, when the page loads, then the dashboard content area is displayed below the header with appropriate padding

### Error Handling

- [ ] Given I visit `/`, when the page loads with a broken layout, then no JavaScript errors are thrown in the console (page renders without crashing)

## API Endpoints

None — this story establishes the page shell only. API calls are introduced in Story 2.

## Implementation Notes

- The Dashboard IS the home page at route `/`. There is no separate `/dashboard` route.
- Modify `app/page.tsx` to replace the placeholder content.
- The header ("BetterBond Commission Payments") is a top-level application header visible on every screen. Consider whether to place it in a shared layout component (`app/layout.tsx`) or directly in the page for now; the layout approach is preferred for consistency across subsequent epics.
- The agency dropdown in the header (top-right per wireframe) will be added in Story 4 — leave a placeholder slot or implement the static header now without the dropdown.
- Section headings ("DASHBOARD", "AGENCY SUMMARY") should be present in this story as structural placeholders even if the content beneath them is empty.
- Use Shadcn UI components where applicable (e.g., `<Card />` for the metric areas).
- No "use client" directive needed for the shell — keep as a server component.
