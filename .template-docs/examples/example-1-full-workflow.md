# Example 1: Full Workflow - Building a New Dashboard Widget

This example walks through the complete TDD workflow from start to finish, demonstrating all six phases as we build a portfolio value widget for a financial dashboard.

> **Note:** This is a detailed, step-by-step walkthrough. For a quick overview, see the [Agent Workflow Guide](../agent-workflow-guide.md#example-workflows).

---

## Scenario Setup

**What We're Building:**
A real-time portfolio value widget that displays:
- Total portfolio value with currency formatting
- Daily change (amount and percentage)
- A mini sparkline chart showing 7-day trend
- Loading and error states
- Accessibility support for screen readers

**Why This Example:**
This scenario is ideal for demonstrating the full workflow because it:
- Involves both UI design and data integration
- Requires multiple components (widget, chart, value displays)
- Has clear acceptance criteria that translate well to tests
- Includes edge cases (loading, errors, empty data)
- Touches multiple layers (API, state management, presentation)

## Prerequisites

Before starting this workflow, ensure you have:

**1. Feature Specification**

Create the spec file at `documentation/portfolio-widget.md`:

```markdown
# Portfolio Value Widget

## Overview
Display a summary widget showing the user's total portfolio value with daily
change indicators and a 7-day trend visualization.

## Requirements

### Functional Requirements
- Display total portfolio value formatted as currency (e.g., "$125,432.50")
- Show daily change in dollars (e.g., "+$1,234.56" or "-$567.89")
- Show daily change as percentage (e.g., "+0.99%" or "-0.45%")
- Display a mini sparkline chart showing the last 7 days of values
- Positive changes shown in green, negative in red
- Handle loading state while fetching data
- Handle error state if API call fails
- Handle empty state if user has no portfolio

### Non-Functional Requirements
- Widget should load in under 500ms
- Chart should be responsive and resize with container
- Must be accessible (WCAG 2.1 AA compliant)
- Must work on mobile viewports (min 320px width)

## API Endpoints

### GET /api/portfolios/:id/summary
Returns portfolio summary data.

**Response:**
```json
{
  "totalValue": 125432.50,
  "dailyChange": 1234.56,
  "dailyChangePercent": 0.99,
  "trend": [
    { "date": "2025-12-11", "value": 124000 },
    { "date": "2025-12-12", "value": 124500 },
    { "date": "2025-12-13", "value": 123800 },
    { "date": "2025-12-14", "value": 124200 },
    { "date": "2025-12-15", "value": 124800 },
    { "date": "2025-12-16", "value": 125100 },
    { "date": "2025-12-17", "value": 125432.50 }
  ],
  "currency": "USD",
  "lastUpdated": "2025-12-17T10:30:00Z"
}
```

## User Stories (High-Level)
1. As an investor, I want to see my total portfolio value so I can track my wealth
2. As an investor, I want to see daily changes so I can monitor performance
3. As an investor, I want to see a trend chart so I can visualize recent performance
4. As a user, I want clear feedback during loading so I know data is being fetched
5. As a user, I want helpful error messages so I can take action when something fails
```

**2. Development Environment**

Ensure your development environment is ready:

```bash
# Navigate to web directory
cd web

# Install dependencies
npm install

# Verify dev server works
npm run dev
# → Should start on http://localhost:3000

# Verify tests work
npm test
# → Should run existing tests (may be 0 tests initially)

# Verify build works
npm run build
# → Should complete without errors
```

**3. API Availability (Optional)**

If you have a live API:
- Ensure the `/api/portfolios/:id/summary` endpoint is accessible
- Have test data available for at least one portfolio

If you don't have a live API:
- The workflow will use mocked responses in tests
- You can implement a mock API route in Next.js for development

**4. Git Repository**

Ensure your git repository is clean:

```bash
# Check status
git status
# → Should show clean working directory or only untracked spec file

# Commit the spec file
git add documentation/portfolio-widget.md
git commit -m "docs: add portfolio widget specification"
```

## File Structure After Setup

Your project should have this structure before starting:

```
project-root/
├── documentation/
│   └── portfolio-widget.md          # ← Feature spec (just created)
├── web/
│   ├── src/
│   │   ├── app/
│   │   ├── components/
│   │   ├── lib/
│   │   │   └── api/
│   │   │       └── client.ts        # ← Existing API client
│   │   └── __tests__/
│   │       └── integration/         # ← Tests will go here
│   ├── package.json
│   └── ...
├── generated-docs/                   # ← Will be populated by agents
│   ├── wireframes/                   # ← (empty, will contain wireframes)
│   └── stories/                      # ← (empty, will contain stories)
└── .claude/
    └── context/                      # ← (empty, will contain context files)
```

## Starting the Workflow

With prerequisites complete, you're ready to begin. Start the workflow with:

```
/start
```

Or use natural language:

```
I have a feature spec at documentation/portfolio-widget.md for a portfolio value
widget. Please help me implement it using the full TDD workflow.
```

**What Happens Next:**

Claude will:
1. Read the feature specification
2. Detect that this feature involves UI
3. Ask if you want wireframes first
4. Begin the DESIGN phase (if you choose wireframes) or PLAN phase

**Expected Response:**

```
I found a feature specification at documentation/portfolio-widget.md for a
Portfolio Value Widget.

This feature involves user interface elements:
- Widget display with value formatting
- Mini sparkline chart
- Loading and error states

Would you like me to:
1. Create wireframes first using the ui-ux-designer agent (recommended for UI features)
2. Proceed directly to planning with feature-planner

What would you prefer?
```

Choose option 1 to see the full workflow, or option 2 to skip wireframes.

---

## Step 1: DESIGN Phase (ui-ux-designer)

**Duration:** 5-15 minutes

After choosing option 1 (create wireframes), the ui-ux-designer agent takes over.

**Your Input:**
```
Yes, let's create wireframes first
```

**What the Agent Does:**

1. **Reads the feature specification** to understand UI requirements
2. **Identifies screens and components** needed for the feature
3. **Creates ASCII wireframes** for each screen/state
4. **Documents element interactions** and user flows
5. **Saves wireframes** to `generated-docs/wireframes/`

**Sample Agent Output:**

```
## Creating Wireframes for Portfolio Value Widget

I'll create wireframes for the portfolio value widget based on the specification.
This widget has multiple states that need to be designed:

### Screens Identified:
1. Main widget view (with data)
2. Loading state
3. Error state
4. Empty state (no portfolio data)

Let me create wireframes for each state...
```

**Generated Wireframe Files:**

The agent creates the following files:

**`generated-docs/wireframes/_overview.md`:**
```markdown
# Portfolio Value Widget - Wireframes Overview

## Screens

| # | Screen Name | Description | File |
|---|-------------|-------------|------|
| 1 | Main Widget | Portfolio value with trend chart | screen-1-main-widget.md |
| 2 | Loading State | Skeleton loader during data fetch | screen-2-loading.md |
| 3 | Error State | Error message with retry option | screen-3-error.md |
| 4 | Empty State | No portfolio data message | screen-4-empty.md |

## User Flow

```
[Page Load] → [Loading State] → [Main Widget]
                    ↓
              [Error State] ←→ [Retry]
```

## Design Decisions
- Widget uses card layout for visual separation
- Sparkline chart is minimal (no axes) to save space
- Color coding: green for positive, red for negative changes
- Loading uses skeleton animation matching final layout
```

**`generated-docs/wireframes/screen-1-main-widget.md`:**
```markdown
# Screen 1: Main Widget View

## Wireframe

```
┌─────────────────────────────────────────────────┐
│  Portfolio Value                            ⟳   │
├─────────────────────────────────────────────────┤
│                                                 │
│  $125,432.50                                    │
│  ═══════════════                                │
│                                                 │
│  +$1,234.56 (+0.99%)  ▲                        │
│  Today's change                                 │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │    ╱╲                                   │   │
│  │   ╱  ╲    ╱╲  ╱╲                       │   │
│  │  ╱    ╲  ╱  ╲╱  ╲  ╱                   │   │
│  │ ╱      ╲╱        ╲╱                    │   │
│  └─────────────────────────────────────────┘   │
│  7-day trend                                    │
│                                                 │
│  Last updated: Dec 17, 2025 10:30 AM           │
└─────────────────────────────────────────────────┘
```

## Elements

| Element | Type | Description |
|---------|------|-------------|
| Header | Text + Icon | "Portfolio Value" title with refresh icon |
| Total Value | Large Text | Currency-formatted portfolio total |
| Daily Change | Text | Dollar amount with +/- prefix |
| Percentage | Badge | Percentage with up/down arrow |
| Sparkline | Chart | 7-day mini line chart |
| Timestamp | Small Text | Last data refresh time |

## Interactions

- **Refresh Icon (⟳)**: Click to manually refresh data
- **Widget**: Click anywhere to navigate to full portfolio view
- **Sparkline**: Hover shows tooltip with date/value (optional enhancement)

## Responsive Behavior

- **Desktop (>768px)**: Full layout as shown
- **Tablet (480-768px)**: Same layout, slightly smaller text
- **Mobile (<480px)**: Stack elements vertically, chart spans full width

## Accessibility

- Total value announced as "Portfolio value: one hundred twenty-five thousand..."
- Change announced as "Up one thousand two hundred thirty-four dollars, zero point nine nine percent"
- Chart has aria-label describing trend direction
```

**`generated-docs/wireframes/screen-2-loading.md`:**
```markdown
# Screen 2: Loading State

## Wireframe

```
┌─────────────────────────────────────────────────┐
│  Portfolio Value                            ◌   │
├─────────────────────────────────────────────────┤
│                                                 │
│  ████████████████                               │
│  ═══════════════                                │
│                                                 │
│  ████████  ██████                               │
│  ████████████████                               │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │                                         │   │
│  │  ████████████████████████████████████   │   │
│  │                                         │   │
│  └─────────────────────────────────────────┘   │
│                                                 │
│  ████████████████████████                       │
└─────────────────────────────────────────────────┘
```

## Elements

| Element | Type | Description |
|---------|------|-------------|
| Spinner | Animated Icon | Rotating indicator (◌) |
| Skeleton Blocks | Animated | Pulse animation on gray rectangles |

## Behavior

- Skeleton layout matches final widget structure
- Pulse animation (opacity 0.5 → 1.0) every 1.5s
- Spinner rotates continuously
- aria-live="polite" announces "Loading portfolio data"

## Duration

- Show loading state immediately on mount
- Transition to main widget or error after API response
- Minimum display time: 300ms (prevents flash)
```

**`generated-docs/wireframes/screen-3-error.md`:**
```markdown
# Screen 3: Error State

## Wireframe

```
┌─────────────────────────────────────────────────┐
│  Portfolio Value                                │
├─────────────────────────────────────────────────┤
│                                                 │
│              ⚠                                  │
│                                                 │
│     Unable to load portfolio data               │
│                                                 │
│     Please check your connection and            │
│     try again.                                  │
│                                                 │
│         ┌─────────────────┐                     │
│         │    Try Again    │                     │
│         └─────────────────┘                     │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Elements

| Element | Type | Description |
|---------|------|-------------|
| Warning Icon | Icon | Yellow/orange warning triangle |
| Error Title | Text | Brief error description |
| Help Text | Text | Guidance for user |
| Retry Button | Button | Triggers data refetch |

## Error Messages

| Error Type | Title | Help Text |
|------------|-------|-----------|
| Network | "Unable to load portfolio data" | "Please check your connection and try again." |
| Server | "Something went wrong" | "Our servers are having issues. Please try again later." |
| Not Found | "Portfolio not found" | "The requested portfolio could not be found." |

## Accessibility

- Error icon has aria-hidden="true" (decorative)
- Error message has role="alert" for screen reader announcement
- Retry button is focusable and labeled
```

**`generated-docs/wireframes/screen-4-empty.md`:**
```markdown
# Screen 4: Empty State

## Wireframe

```
┌─────────────────────────────────────────────────┐
│  Portfolio Value                                │
├─────────────────────────────────────────────────┤
│                                                 │
│              📊                                 │
│                                                 │
│     No portfolio data yet                       │
│                                                 │
│     Add holdings to your portfolio to           │
│     see your total value here.                  │
│                                                 │
│         ┌─────────────────┐                     │
│         │  Add Holdings   │                     │
│         └─────────────────┘                     │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Elements

| Element | Type | Description |
|---------|------|-------------|
| Chart Icon | Icon | Empty chart/graph icon |
| Empty Title | Text | Clear statement of empty state |
| Help Text | Text | Guidance for next action |
| CTA Button | Button | Links to add holdings flow |

## Behavior

- Only shown when API returns empty portfolio (no holdings)
- CTA navigates to portfolio management page
- Different from error state (no retry, different messaging)
```

**Handoff Message:**

After creating all wireframes, the agent provides:

```
## Wireframes Complete ✓

All 4 screens have been wireframed and saved to `generated-docs/wireframes/`.

### Files Created
- generated-docs/wireframes/_overview.md
- generated-docs/wireframes/screen-1-main-widget.md
- generated-docs/wireframes/screen-2-loading.md
- generated-docs/wireframes/screen-3-error.md
- generated-docs/wireframes/screen-4-empty.md

### Design Summary
- Card-based widget layout
- Skeleton loading matching final structure
- Clear error and empty states with CTAs
- Responsive considerations documented
- Accessibility requirements noted

### Next Step

Use the **feature-planner** agent to create epics and stories based on these wireframes:

    Plan the portfolio widget feature based on documentation/portfolio-widget.md

The feature-planner will automatically reference these wireframes when creating stories.
```

**Your Response:**

Review the wireframes. If they look good:
```
These wireframes look good. Let's proceed to planning.
```

If you want changes:
```
Can you update the main widget wireframe to include a percentage badge instead of inline text?
```

**What Gets Committed:**

```bash
# Agent commits wireframes before handoff
git add generated-docs/wireframes/
git commit -m "DESIGN: Add wireframes for portfolio value widget"
```

**Files Created in This Phase:**

```
generated-docs/
└── wireframes/
    ├── _overview.md
    ├── screen-1-main-widget.md
    ├── screen-2-loading.md
    ├── screen-3-error.md
    └── screen-4-empty.md
```

**Skipping This Phase:**

If you chose option 2 (skip wireframes) at the start, or if you're continuing a workflow where wireframes aren't needed:

```
No wireframes needed for this feature. Let's go straight to planning.
```

The workflow proceeds directly to the PLAN phase with feature-planner.

---

## Step 2: PLAN Phase (feature-planner)

**Duration:** 15-30 minutes

After approving wireframes (or skipping the DESIGN phase), you invoke the feature-planner agent.

**Your Input:**
```
These wireframes look good. Let's proceed to planning.
```

Or directly:
```
Plan the portfolio widget feature based on documentation/portfolio-widget.md
```

**What the Agent Does:**

1. **Reads the feature specification** and wireframes (if they exist)
2. **Proposes epics** - high-level groupings of related work
3. **Waits for your approval** of the epic structure
4. **Creates stories** for the first epic only
5. **Writes acceptance criteria** in Given/When/Then format
6. **Saves story files** to `generated-docs/stories/`
7. **Commits and hands off** to test-generator

**Sample Agent Output - Epic Proposal:**

```
## Planning Portfolio Value Widget

I've reviewed the feature specification and wireframes. Here's my proposed epic breakdown:

### Proposed Epics

| Epic | Name | Description | Stories (Est.) |
|------|------|-------------|----------------|
| 1 | Core Widget Display | Basic widget with value display and change indicators | 3-4 |
| 2 | Trend Chart | Sparkline visualization of 7-day data | 2-3 |
| 3 | State Handling | Loading, error, and empty states | 3 |
| 4 | Interactivity | Refresh, navigation, and accessibility | 2-3 |

### Recommended Order
1. **Epic 1** first - establishes the component structure and API integration
2. **Epic 3** second - ensures robust error handling early
3. **Epic 2** third - adds visualization once data flow is solid
4. **Epic 4** last - polish and enhancements

Do you approve this epic structure, or would you like to modify it?
```

**Your Response:**
```
This looks good. Let's proceed with Epic 1.
```

**Sample Agent Output - Story Creation:**

```
## Epic 1: Core Widget Display

Creating stories for Epic 1...

### Story 1.1: Display Portfolio Total Value

**User Story:**
As an investor, I want to see my total portfolio value displayed prominently,
so that I can quickly check my wealth at a glance.

**Acceptance Criteria:**

```gherkin
Feature: Portfolio Total Value Display

  Scenario: Display formatted portfolio value
    Given the user has a portfolio with total value of 125432.50
    When the portfolio widget loads successfully
    Then the total value is displayed as "$125,432.50"
    And the value uses large, prominent typography

  Scenario: Handle different currency formats
    Given the user has a portfolio with currency "USD"
    When the portfolio widget displays the value
    Then the appropriate currency symbol "$" is shown
    And thousand separators are used correctly

  Scenario: Handle large values
    Given the user has a portfolio worth 1234567.89
    When the portfolio widget loads
    Then the value displays as "$1,234,567.89"
    And the layout accommodates the longer number
```

**Technical Notes:**
- Use Intl.NumberFormat for currency formatting
- Component: `PortfolioValueWidget` in `components/dashboard/`
- API endpoint: GET /api/portfolios/:id/summary
- Reference wireframe: screen-1-main-widget.md

---

### Story 1.2: Display Daily Change Amount

**User Story:**
As an investor, I want to see how much my portfolio changed today in dollars,
so that I can understand the absolute impact of market movements.

**Acceptance Criteria:**

```gherkin
Feature: Daily Change Amount Display

  Scenario: Display positive daily change
    Given the portfolio has a daily change of +1234.56
    When the portfolio widget loads
    Then the change displays as "+$1,234.56"
    And the text color is green

  Scenario: Display negative daily change
    Given the portfolio has a daily change of -567.89
    When the portfolio widget loads
    Then the change displays as "-$567.89"
    And the text color is red

  Scenario: Display zero change
    Given the portfolio has a daily change of 0
    When the portfolio widget loads
    Then the change displays as "$0.00"
    And the text color is neutral (not green or red)
```

**Technical Notes:**
- Positive values: green (#22c55e), prefix with "+"
- Negative values: red (#ef4444), prefix with "-"
- Zero: neutral gray, no prefix
- Use same currency formatter as total value

---

### Story 1.3: Display Daily Change Percentage

**User Story:**
As an investor, I want to see my daily change as a percentage,
so that I can understand the relative performance of my portfolio.

**Acceptance Criteria:**

```gherkin
Feature: Daily Change Percentage Display

  Scenario: Display positive percentage with indicator
    Given the portfolio has a daily change of +0.99%
    When the portfolio widget loads
    Then the percentage displays as "+0.99%"
    And an upward arrow indicator (▲) is shown
    And the indicator is green

  Scenario: Display negative percentage with indicator
    Given the portfolio has a daily change of -0.45%
    When the portfolio widget loads
    Then the percentage displays as "-0.45%"
    And a downward arrow indicator (▼) is shown
    And the indicator is red

  Scenario: Round percentage to two decimal places
    Given the portfolio has a daily change of 0.987654%
    When the portfolio widget loads
    Then the percentage displays as "+0.99%"
```

**Technical Notes:**
- Always show 2 decimal places
- Arrow indicators: ▲ (U+25B2) for up, ▼ (U+25BC) for down
- Same color scheme as dollar change
- Consider using a Badge component from Shadcn UI

---

### Story 1.4: Integrate with Portfolio API

**User Story:**
As a developer, I want the widget to fetch data from the portfolio API,
so that users see their real portfolio information.

**Acceptance Criteria:**

```gherkin
Feature: Portfolio API Integration

  Scenario: Fetch portfolio summary on mount
    Given the widget is mounted with portfolioId "123"
    When the component initializes
    Then a GET request is made to /api/portfolios/123/summary
    And the response data populates the widget

  Scenario: Display last updated timestamp
    Given the API returns lastUpdated "2025-12-17T10:30:00Z"
    When the data loads successfully
    Then the widget shows "Last updated: Dec 17, 2025 10:30 AM"
    And the timestamp uses the user's locale

  Scenario: Handle API response structure
    Given the API returns valid portfolio data
    When the response is processed
    Then totalValue maps to the main display
    And dailyChange maps to the change amount
    And dailyChangePercent maps to the percentage
    And currency is used for formatting
```

**Technical Notes:**
- Create `getPortfolioSummary(id)` in `lib/api/portfolio.ts`
- Use the existing API client from `lib/api/client.ts`
- Add TypeScript types in `types/portfolio.ts`
- Handle timezone conversion for lastUpdated

---

Do you approve these stories for Epic 1, or would you like to modify any of them?
```

**Your Response:**
```
These stories look complete. Please save them and proceed.
```

**Generated Story Files:**

The agent creates the following files:

**`generated-docs/stories/_feature-overview.md`:**
```markdown
# Portfolio Value Widget - Feature Overview

## Feature Summary
Display a summary widget showing the user's total portfolio value with daily
change indicators and a 7-day trend visualization.

## Epics

| # | Epic | Status | Stories |
|---|------|--------|---------|
| 1 | Core Widget Display | 🔄 In Progress | 4 |
| 2 | Trend Chart | ⏳ Planned | TBD |
| 3 | State Handling | ⏳ Planned | TBD |
| 4 | Interactivity | ⏳ Planned | TBD |

## Wireframes
- [Overview](../wireframes/_overview.md)
- [Main Widget](../wireframes/screen-1-main-widget.md)
- [Loading State](../wireframes/screen-2-loading.md)
- [Error State](../wireframes/screen-3-error.md)
- [Empty State](../wireframes/screen-4-empty.md)

## Specification
- [Original Spec](../../documentation/portfolio-widget.md)

## Progress
- [ ] Epic 1: Core Widget Display
- [ ] Epic 2: Trend Chart
- [ ] Epic 3: State Handling
- [ ] Epic 4: Interactivity
```

**`generated-docs/stories/epic-1-core-widget-display/story-1-display-total-value.md`:**
```markdown
# Story 1.1: Display Portfolio Total Value

## User Story
As an investor, I want to see my total portfolio value displayed prominently,
so that I can quickly check my wealth at a glance.

## Acceptance Criteria

### AC1: Display formatted portfolio value
- **Given** the user has a portfolio with total value of 125432.50
- **When** the portfolio widget loads successfully
- **Then** the total value is displayed as "$125,432.50"
- **And** the value uses large, prominent typography

### AC2: Handle different currency formats
- **Given** the user has a portfolio with currency "USD"
- **When** the portfolio widget displays the value
- **Then** the appropriate currency symbol "$" is shown
- **And** thousand separators are used correctly

### AC3: Handle large values
- **Given** the user has a portfolio worth 1234567.89
- **When** the portfolio widget loads
- **Then** the value displays as "$1,234,567.89"
- **And** the layout accommodates the longer number

## Technical Notes
- Use `Intl.NumberFormat` for currency formatting
- Component: `PortfolioValueWidget` in `components/dashboard/`
- API endpoint: `GET /api/portfolios/:id/summary`
- Reference wireframe: [screen-1-main-widget.md](../../wireframes/screen-1-main-widget.md)

## Acceptance Tests
- [ ] AC1: Formatted value display
- [ ] AC2: Currency formatting
- [ ] AC3: Large value handling

## Dependencies
- None (first story)

## Story Points
2
```

*(Similar files created for stories 1.2, 1.3, and 1.4)*

**Context File Created:**

**`generated-docs/context/feature-spec.json`:**
```json
{
  "featureName": "Portfolio Value Widget",
  "epicNumber": 1,
  "epicName": "Core Widget Display",
  "stories": [
    {
      "id": "1.1",
      "name": "Display Portfolio Total Value",
      "file": "generated-docs/stories/epic-1-core-widget-display/story-1-display-total-value.md"
    },
    {
      "id": "1.2",
      "name": "Display Daily Change Amount",
      "file": "generated-docs/stories/epic-1-core-widget-display/story-2-display-daily-change.md"
    },
    {
      "id": "1.3",
      "name": "Display Daily Change Percentage",
      "file": "generated-docs/stories/epic-1-core-widget-display/story-3-display-percentage.md"
    },
    {
      "id": "1.4",
      "name": "Integrate with Portfolio API",
      "file": "generated-docs/stories/epic-1-core-widget-display/story-4-api-integration.md"
    }
  ],
  "acceptanceTests": [
    "Given a portfolio with value 125432.50, when widget loads, then displays $125,432.50",
    "Given positive daily change +1234.56, when widget loads, then displays +$1,234.56 in green",
    "Given negative daily change -567.89, when widget loads, then displays -$567.89 in red",
    "Given daily change +0.99%, when widget loads, then displays +0.99% with ▲",
    "Given portfolioId 123, when mounted, then fetches /api/portfolios/123/summary"
  ],
  "components": [
    "PortfolioValueWidget",
    "PortfolioValue",
    "DailyChange",
    "ChangePercentage"
  ],
  "apiEndpoints": [
    "GET /api/portfolios/:id/summary"
  ],
  "wireframeReference": "generated-docs/wireframes/screen-1-main-widget.md"
}
```

**Handoff Message:**

```
## Epic 1: Core Widget Display - Planning Complete ✓

All 4 stories have been created with acceptance criteria and saved to
`generated-docs/stories/epic-1-core-widget-display/`.

### Stories Created
1. Story 1.1: Display Portfolio Total Value
2. Story 1.2: Display Daily Change Amount
3. Story 1.3: Display Daily Change Percentage
4. Story 1.4: Integrate with Portfolio API

### Files Created
- generated-docs/stories/_feature-overview.md
- generated-docs/stories/epic-1-core-widget-display/story-1-display-total-value.md
- generated-docs/stories/epic-1-core-widget-display/story-2-display-daily-change.md
- generated-docs/stories/epic-1-core-widget-display/story-3-display-percentage.md
- generated-docs/stories/epic-1-core-widget-display/story-4-api-integration.md
- generated-docs/context/feature-spec.json

### Next Step

Use the **test-generator** agent to create failing tests for these stories:

    Generate tests for Epic 1: Core Widget Display

⚠️ **Important:** Do NOT plan Epic 2 until Epic 1 is fully implemented and verified.
The TDD workflow completes one epic at a time.
```

**What Gets Committed:**

```bash
# Agent commits stories before handoff
git add generated-docs/stories/
git commit -m "PLAN: Add stories for Epic 1 - Core Widget Display"
```

**Files Created in This Phase:**

```
generated-docs/
└── stories/
    ├── _feature-overview.md
    └── epic-1-core-widget-display/
        ├── story-1-display-total-value.md
        ├── story-2-display-daily-change.md
        ├── story-3-display-percentage.md
        └── story-4-api-integration.md

.claude/
└── context/
    └── feature-spec.json
```

**Key Points About the PLAN Phase:**

1. **One Epic at a Time:** The agent plans only one epic before handing off. This ensures focused implementation and prevents scope creep.

2. **Approval Gates:** The agent pauses twice for approval:
   - After proposing epics (before creating stories)
   - After creating stories (before committing)

3. **Acceptance Criteria Format:** Stories use Given/When/Then format which translates directly to test scenarios.

4. **Context File:** The `feature-spec.json` provides structured data for the test-generator agent.

5. **Cross-References:** Stories link back to wireframes and forward to components that will be created.

---

## Step 3: WRITE-TESTS Phase (test-generator)

**Duration:** 10-20 minutes

After the PLAN phase completes, you invoke the test-generator agent to create executable tests from the acceptance criteria.

**Your Input:**
```
Generate tests for Epic 1: Core Widget Display
```

**What the Agent Does:**

1. **Reads story files** from `generated-docs/stories/epic-1-*/`
2. **Reads context file** from `generated-docs/context/feature-spec.json`
3. **Generates test files** using Vitest + React Testing Library
4. **Imports components that don't exist yet** (this is intentional - TDD)
5. **Runs tests to verify they FAIL** (required for TDD)
6. **Commits test files** and hands off to developer

**Sample Agent Output:**

```
## Generating Tests for Epic 1: Core Widget Display

I'll create failing tests based on the acceptance criteria from the 4 stories.
These tests will import the PortfolioValueWidget component which doesn't exist yet -
this is expected in TDD.

### Test Strategy

| Story | Test File | Test Cases |
|-------|-----------|------------|
| 1.1 Display Total Value | portfolio-widget.test.tsx | 3 |
| 1.2 Display Daily Change | portfolio-widget.test.tsx | 3 |
| 1.3 Display Percentage | portfolio-widget.test.tsx | 3 |
| 1.4 API Integration | portfolio-widget.test.tsx | 3 |

Total: 12 test cases in 1 file

Creating tests...
```

**Generated Test File:**

**`web/src/__tests__/integration/portfolio-widget.test.tsx`:**

```typescript
/**
 * Portfolio Value Widget - Integration Tests
 *
 * These tests are generated from acceptance criteria in:
 * - generated-docs/stories/epic-1-core-widget-display/
 *
 * TDD Note: These tests are designed to FAIL initially.
 * The developer agent will implement code to make them pass.
 */

import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { axe, toHaveNoViolations } from 'jest-axe';

// Component import - this file doesn't exist yet (TDD)
import { PortfolioValueWidget } from '@/components/dashboard/PortfolioValueWidget';

// API mock
import * as portfolioApi from '@/lib/api/portfolio';

expect.extend(toHaveNoViolations);

// Mock the API module
vi.mock('@/lib/api/portfolio');

const mockPortfolioData = {
  totalValue: 125432.5,
  dailyChange: 1234.56,
  dailyChangePercent: 0.99,
  trend: [
    { date: '2025-12-11', value: 124000 },
    { date: '2025-12-12', value: 124500 },
    { date: '2025-12-13', value: 123800 },
    { date: '2025-12-14', value: 124200 },
    { date: '2025-12-15', value: 124800 },
    { date: '2025-12-16', value: 125100 },
    { date: '2025-12-17', value: 125432.5 },
  ],
  currency: 'USD',
  lastUpdated: '2025-12-17T10:30:00Z',
};

describe('Feature: Portfolio Value Widget', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  // ============================================================
  // Story 1.1: Display Portfolio Total Value
  // ============================================================
  describe('Story 1.1: Display Portfolio Total Value', () => {
    describe('AC1: Display formatted portfolio value', () => {
      it('should display total value as formatted currency', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue(mockPortfolioData);

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          expect(screen.getByText('$125,432.50')).toBeInTheDocument();
        });
      });

      it('should display the value with prominent typography', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue(mockPortfolioData);

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          const valueElement = screen.getByText('$125,432.50');
          // Check for large text styling (text-3xl or similar)
          expect(valueElement).toHaveClass(/text-(2xl|3xl|4xl)/);
        });
      });
    });

    describe('AC2: Handle different currency formats', () => {
      it('should display USD currency symbol correctly', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue({
          ...mockPortfolioData,
          currency: 'USD',
        });

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          expect(screen.getByText(/\$125,432\.50/)).toBeInTheDocument();
        });
      });
    });

    describe('AC3: Handle large values', () => {
      it('should display large values with proper formatting', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue({
          ...mockPortfolioData,
          totalValue: 1234567.89,
        });

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          expect(screen.getByText('$1,234,567.89')).toBeInTheDocument();
        });
      });
    });
  });

  // ============================================================
  // Story 1.2: Display Daily Change Amount
  // ============================================================
  describe('Story 1.2: Display Daily Change Amount', () => {
    describe('AC1: Display positive daily change', () => {
      it('should display positive change with + prefix and green color', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue({
          ...mockPortfolioData,
          dailyChange: 1234.56,
        });

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          const changeElement = screen.getByText('+$1,234.56');
          expect(changeElement).toBeInTheDocument();
          expect(changeElement).toHaveClass(/text-green/);
        });
      });
    });

    describe('AC2: Display negative daily change', () => {
      it('should display negative change with - prefix and red color', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue({
          ...mockPortfolioData,
          dailyChange: -567.89,
        });

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          const changeElement = screen.getByText('-$567.89');
          expect(changeElement).toBeInTheDocument();
          expect(changeElement).toHaveClass(/text-red/);
        });
      });
    });

    describe('AC3: Display zero change', () => {
      it('should display zero change with neutral color', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue({
          ...mockPortfolioData,
          dailyChange: 0,
        });

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          const changeElement = screen.getByText('$0.00');
          expect(changeElement).toBeInTheDocument();
          expect(changeElement).not.toHaveClass(/text-green/);
          expect(changeElement).not.toHaveClass(/text-red/);
        });
      });
    });
  });

  // ============================================================
  // Story 1.3: Display Daily Change Percentage
  // ============================================================
  describe('Story 1.3: Display Daily Change Percentage', () => {
    describe('AC1: Display positive percentage with indicator', () => {
      it('should display positive percentage with up arrow', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue({
          ...mockPortfolioData,
          dailyChangePercent: 0.99,
        });

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          expect(screen.getByText(/\+0\.99%/)).toBeInTheDocument();
          expect(screen.getByText('▲')).toBeInTheDocument();
        });
      });
    });

    describe('AC2: Display negative percentage with indicator', () => {
      it('should display negative percentage with down arrow', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue({
          ...mockPortfolioData,
          dailyChangePercent: -0.45,
        });

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          expect(screen.getByText(/-0\.45%/)).toBeInTheDocument();
          expect(screen.getByText('▼')).toBeInTheDocument();
        });
      });
    });

    describe('AC3: Round percentage to two decimal places', () => {
      it('should round percentage correctly', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue({
          ...mockPortfolioData,
          dailyChangePercent: 0.987654,
        });

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          expect(screen.getByText(/\+0\.99%/)).toBeInTheDocument();
        });
      });
    });
  });

  // ============================================================
  // Story 1.4: Integrate with Portfolio API
  // ============================================================
  describe('Story 1.4: Integrate with Portfolio API', () => {
    describe('AC1: Fetch portfolio summary on mount', () => {
      it('should call API with correct portfolio ID', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue(mockPortfolioData);

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          expect(portfolioApi.getPortfolioSummary).toHaveBeenCalledWith('123');
        });
      });
    });

    describe('AC2: Display last updated timestamp', () => {
      it('should display formatted timestamp', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue(mockPortfolioData);

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          // Expect locale-formatted date (exact format may vary)
          expect(screen.getByText(/Last updated:/i)).toBeInTheDocument();
          expect(screen.getByText(/Dec 17, 2025/i)).toBeInTheDocument();
        });
      });
    });

    describe('AC3: Handle API response structure', () => {
      it('should map all API fields to widget display', async () => {
        // Arrange
        vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue(mockPortfolioData);

        // Act
        render(<PortfolioValueWidget portfolioId="123" />);

        // Assert
        await waitFor(() => {
          // Total value displayed
          expect(screen.getByText('$125,432.50')).toBeInTheDocument();
          // Daily change displayed
          expect(screen.getByText('+$1,234.56')).toBeInTheDocument();
          // Percentage displayed
          expect(screen.getByText(/\+0\.99%/)).toBeInTheDocument();
        });
      });
    });
  });

  // ============================================================
  // Accessibility Tests
  // ============================================================
  describe('Accessibility', () => {
    it('should have no accessibility violations', async () => {
      // Arrange
      vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue(mockPortfolioData);

      // Act
      const { container } = render(<PortfolioValueWidget portfolioId="123" />);

      // Wait for data to load
      await waitFor(() => {
        expect(screen.getByText('$125,432.50')).toBeInTheDocument();
      });

      // Assert
      const results = await axe(container);
      expect(results).toHaveNoViolations();
    });

    it('should have accessible labels for screen readers', async () => {
      // Arrange
      vi.mocked(portfolioApi.getPortfolioSummary).mockResolvedValue(mockPortfolioData);

      // Act
      render(<PortfolioValueWidget portfolioId="123" />);

      // Assert
      await waitFor(() => {
        // Widget should have a label
        expect(screen.getByRole('region', { name: /portfolio/i })).toBeInTheDocument();
      });
    });
  });
});
```

**Test Verification Output:**

After creating the tests, the agent runs them to verify they fail:

```
## Running Tests to Verify Failure

$ npm test -- --testPathPattern="portfolio-widget"

Running tests...

 FAIL  src/__tests__/integration/portfolio-widget.test.tsx
  ● Test suite failed to run

    Cannot find module '@/components/dashboard/PortfolioValueWidget' from
    'src/__tests__/integration/portfolio-widget.test.tsx'

      1 | import { render, screen, waitFor } from '@testing-library/react';
      2 | import userEvent from '@testing-library/user-event';
    > 3 | import { PortfolioValueWidget } from '@/components/dashboard/PortfolioValueWidget';
        | ^

Test Suites: 1 failed, 1 total
Tests:       0 passed, 0 total

---

✓ Tests fail as expected (TDD requirement met)

The tests fail because the PortfolioValueWidget component doesn't exist yet.
This is correct behavior for TDD - the developer agent will now implement
the component to make these tests pass.
```

**Acceptable Test Failures:**

| Failure Type | Example | Why It's Acceptable |
|--------------|---------|---------------------|
| Module not found | `Cannot find module '@/components/...'` | Component doesn't exist yet |
| Element not found | `Unable to find element with text: $125,432.50` | Component renders nothing/wrong |
| Assertion failed | `Expected element to have class 'text-green'` | Component doesn't style correctly |

**Unacceptable Test Results:**

| Result | Why It's Wrong |
|--------|----------------|
| Tests pass | Component already exists (not TDD) or tests don't assert anything |
| Tests skipped | Tests are incomplete or using `.skip()` |
| Syntax errors | Tests have bugs - need to be fixed |

**Context File Created:**

**`generated-docs/context/test-coverage.json`:**
```json
{
  "featureName": "Portfolio Value Widget",
  "epicNumber": 1,
  "epicName": "Core Widget Display",
  "timestamp": "2025-12-17T11:00:00Z",
  "testFile": "web/src/__tests__/integration/portfolio-widget.test.tsx",
  "testsGenerated": {
    "total": 14,
    "byStory": {
      "story-1.1": 3,
      "story-1.2": 3,
      "story-1.3": 3,
      "story-1.4": 3,
      "accessibility": 2
    }
  },
  "status": "FAILING",
  "failureReason": "Cannot find module '@/components/dashboard/PortfolioValueWidget'",
  "note": "Tests expected to FAIL until implementation complete (TDD)",
  "acceptanceCriteriaCovered": [
    "AC1.1.1: Display formatted portfolio value",
    "AC1.1.2: Handle currency formats",
    "AC1.1.3: Handle large values",
    "AC1.2.1: Display positive daily change",
    "AC1.2.2: Display negative daily change",
    "AC1.2.3: Display zero change",
    "AC1.3.1: Display positive percentage with indicator",
    "AC1.3.2: Display negative percentage with indicator",
    "AC1.3.3: Round percentage to two decimal places",
    "AC1.4.1: Fetch portfolio summary on mount",
    "AC1.4.2: Display last updated timestamp",
    "AC1.4.3: Handle API response structure"
  ]
}
```

**Handoff Message:**

```
## Tests Generated for Epic 1 ✓

Failing tests have been created and verified.

### Test Summary
- **File:** web/src/__tests__/integration/portfolio-widget.test.tsx
- **Total Tests:** 14 (12 acceptance criteria + 2 accessibility)
- **Status:** FAILING ✓ (as expected for TDD)
- **Failure Reason:** Component doesn't exist yet

### Stories Covered
| Story | Tests | Status |
|-------|-------|--------|
| 1.1 Display Total Value | 3 | ❌ Failing |
| 1.2 Display Daily Change | 3 | ❌ Failing |
| 1.3 Display Percentage | 3 | ❌ Failing |
| 1.4 API Integration | 3 | ❌ Failing |
| Accessibility | 2 | ❌ Failing |

### Files Created
- web/src/__tests__/integration/portfolio-widget.test.tsx
- generated-docs/context/test-coverage.json

### Next Step

Use the **developer** agent to implement code that makes these tests pass:

    Implement the stories for Epic 1: Core Widget Display

The developer will:
1. Create the PortfolioValueWidget component
2. Add the API integration
3. Make all 14 tests pass
4. Commit and push to main after approval
```

**What Gets Committed:**

Tests are NOT committed during the WRITE-TESTS phase. They remain uncommitted so that quality gates don't fail due to intentionally failing tests. The developer agent will commit tests alongside implementation during the IMPLEMENT phase.

**Files Created in This Phase:**

```
web/
└── src/
    └── __tests__/
        └── integration/
            └── portfolio-widget.test.tsx

.claude/
└── context/
    ├── feature-spec.json (from PLAN)
    └── test-coverage.json (new)
```

**Key Points About the WRITE-TESTS Phase:**

1. **Tests MUST Fail:** If tests pass immediately, something is wrong—either the implementation already exists or the tests don't assert anything meaningful.

2. **Real Imports:** Tests import real component paths that don't exist yet. This creates clear "module not found" errors that guide implementation.

3. **Structured Test Organization:** Tests are organized by story and acceptance criterion, making it easy to track which requirements are covered.

4. **Mocking Strategy:** Only the HTTP client/API layer is mocked. Components are tested with real rendering.

5. **Accessibility Included:** Tests include accessibility checks using jest-axe to catch a11y issues early.

6. **Context File:** The `test-coverage.json` tracks what tests exist and their status, helping the code-reviewer during QA later.

---

## Step 4: IMPLEMENT Phase (developer)

**Duration:** Varies (typically 30-60 minutes per story)

After the WRITE-TESTS phase creates failing tests, you invoke the developer agent to implement code that makes those tests pass.

**Your Input:**
```
Implement the stories for Epic 1: Core Widget Display
```

**What the Agent Does:**

1. **Ensures on main branch** and up to date
2. **Reads failing tests** to understand what needs to be implemented
3. **Implements code** to make tests pass (one story at a time)
4. **Runs tests** after each implementation step
5. **Offers a preview opportunity** (localhost)
6. **STOPS and waits** for your approval before committing
7. **Commits and pushes to main** after approval

**Sample Agent Output - Starting Implementation:**

```
## Implementing Epic 1: Core Widget Display

I'll implement the code to make all 14 tests pass. Let me start by ensuring
we're on main and up to date, then analyze what needs to be built.

### Ensuring Main Branch is Up to Date

$ git checkout main
$ git pull origin main
Already on 'main' and up to date.

### Implementation Plan

Based on the failing tests, I need to create:

| File | Purpose |
|------|---------|
| `types/portfolio.ts` | TypeScript types for API response |
| `lib/api/portfolio.ts` | API client function |
| `components/dashboard/PortfolioValueWidget.tsx` | Main widget component |

Let me start implementing...
```

**Sample Implementation - Types:**

```
### Creating TypeScript Types

Creating `web/src/types/portfolio.ts`:
```

**`web/src/types/portfolio.ts`:**
```typescript
/**
 * Portfolio API Types
 * Generated for Epic 1: Core Widget Display
 */

export interface PortfolioTrendPoint {
  date: string;
  value: number;
}

export interface PortfolioSummary {
  totalValue: number;
  dailyChange: number;
  dailyChangePercent: number;
  trend: PortfolioTrendPoint[];
  currency: string;
  lastUpdated: string;
}
```

**Sample Implementation - API Client:**

```
### Creating API Client Function

Creating `web/src/lib/api/portfolio.ts`:
```

**`web/src/lib/api/portfolio.ts`:**
```typescript
/**
 * Portfolio API Client
 * Generated for Epic 1: Core Widget Display
 */

import { get } from './client';
import type { PortfolioSummary } from '@/types/portfolio';

/**
 * Fetch portfolio summary data
 * @param portfolioId - The ID of the portfolio to fetch
 * @returns Portfolio summary including value, changes, and trend data
 */
export async function getPortfolioSummary(
  portfolioId: string
): Promise<PortfolioSummary> {
  return get<PortfolioSummary>(`/api/portfolios/${portfolioId}/summary`);
}
```

**Sample Implementation - Component:**

```
### Creating PortfolioValueWidget Component

Creating `web/src/components/dashboard/PortfolioValueWidget.tsx`:
```

**`web/src/components/dashboard/PortfolioValueWidget.tsx`:**
```typescript
'use client';

/**
 * Portfolio Value Widget
 * Displays total portfolio value with daily change indicators
 *
 * Stories covered:
 * - 1.1: Display Portfolio Total Value
 * - 1.2: Display Daily Change Amount
 * - 1.3: Display Daily Change Percentage
 * - 1.4: Integrate with Portfolio API
 */

import { useEffect, useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { getPortfolioSummary } from '@/lib/api/portfolio';
import type { PortfolioSummary } from '@/types/portfolio';

interface PortfolioValueWidgetProps {
  portfolioId: string;
}

export function PortfolioValueWidget({ portfolioId }: PortfolioValueWidgetProps) {
  const [data, setData] = useState<PortfolioSummary | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchData() {
      try {
        setIsLoading(true);
        const summary = await getPortfolioSummary(portfolioId);
        setData(summary);
        setError(null);
      } catch (err) {
        setError('Failed to load portfolio data');
      } finally {
        setIsLoading(false);
      }
    }

    fetchData();
  }, [portfolioId]);

  // Format currency value
  const formatCurrency = (value: number, currency: string = 'USD') => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value);
  };

  // Format change with sign
  const formatChange = (value: number, currency: string = 'USD') => {
    const formatted = formatCurrency(Math.abs(value), currency);
    if (value > 0) return `+${formatted}`;
    if (value < 0) return `-${formatted.replace('-', '')}`;
    return formatted;
  };

  // Format percentage
  const formatPercent = (value: number) => {
    const rounded = Math.round(value * 100) / 100;
    const sign = rounded > 0 ? '+' : '';
    return `${sign}${rounded.toFixed(2)}%`;
  };

  // Get color class based on value
  const getChangeColor = (value: number) => {
    if (value > 0) return 'text-green-500';
    if (value < 0) return 'text-red-500';
    return 'text-gray-500';
  };

  // Format timestamp
  const formatTimestamp = (isoString: string) => {
    const date = new Date(isoString);
    return date.toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: 'numeric',
      minute: '2-digit',
    });
  };

  if (isLoading) {
    return (
      <Card aria-busy="true" aria-label="Loading portfolio data">
        <CardHeader>
          <CardTitle>Portfolio Value</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="animate-pulse space-y-4">
            <div className="h-8 bg-gray-200 rounded w-48" />
            <div className="h-4 bg-gray-200 rounded w-32" />
          </div>
        </CardContent>
      </Card>
    );
  }

  if (error || !data) {
    return (
      <Card role="alert" aria-label="Portfolio error">
        <CardHeader>
          <CardTitle>Portfolio Value</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-red-500">{error || 'Unable to load data'}</p>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card role="region" aria-label="Portfolio value summary">
      <CardHeader>
        <CardTitle>Portfolio Value</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        {/* Total Value - Story 1.1 */}
        <div>
          <p className="text-3xl font-bold">
            {formatCurrency(data.totalValue, data.currency)}
          </p>
        </div>

        {/* Daily Change - Stories 1.2 & 1.3 */}
        <div className="flex items-center gap-2">
          <span className={getChangeColor(data.dailyChange)}>
            {formatChange(data.dailyChange, data.currency)}
          </span>
          <span className={`flex items-center ${getChangeColor(data.dailyChangePercent)}`}>
            <span>{data.dailyChangePercent > 0 ? '▲' : data.dailyChangePercent < 0 ? '▼' : ''}</span>
            <span>{formatPercent(data.dailyChangePercent)}</span>
          </span>
        </div>

        {/* Last Updated - Story 1.4 */}
        <p className="text-sm text-gray-500">
          Last updated: {formatTimestamp(data.lastUpdated)}
        </p>
      </CardContent>
    </Card>
  );
}
```

**Running Tests After Implementation:**

```
### Running Tests

$ npm test -- --testPathPattern="portfolio-widget"

 PASS  src/__tests__/integration/portfolio-widget.test.tsx
  Feature: Portfolio Value Widget
    Story 1.1: Display Portfolio Total Value
      AC1: Display formatted portfolio value
        ✓ should display total value as formatted currency (45 ms)
        ✓ should display the value with prominent typography (23 ms)
      AC2: Handle different currency formats
        ✓ should display USD currency symbol correctly (18 ms)
      AC3: Handle large values
        ✓ should display large values with proper formatting (21 ms)
    Story 1.2: Display Daily Change Amount
      AC1: Display positive daily change
        ✓ should display positive change with + prefix and green color (19 ms)
      AC2: Display negative daily change
        ✓ should display negative change with - prefix and red color (17 ms)
      AC3: Display zero change
        ✓ should display zero change with neutral color (16 ms)
    Story 1.3: Display Daily Change Percentage
      AC1: Display positive percentage with indicator
        ✓ should display positive percentage with up arrow (18 ms)
      AC2: Display negative percentage with indicator
        ✓ should display negative percentage with down arrow (17 ms)
      AC3: Round percentage to two decimal places
        ✓ should round percentage correctly (16 ms)
    Story 1.4: Integrate with Portfolio API
      AC1: Fetch portfolio summary on mount
        ✓ should call API with correct portfolio ID (15 ms)
      AC2: Display last updated timestamp
        ✓ should display formatted timestamp (19 ms)
      AC3: Handle API response structure
        ✓ should map all API fields to widget display (18 ms)
    Accessibility
      ✓ should have no accessibility violations (156 ms)
      ✓ should have accessible labels for screen readers (17 ms)

Test Suites: 1 passed, 1 total
Tests:       14 passed, 14 total
Snapshots:   0 total
Time:        2.847 s

---

✓ All 14 tests pass!
```

**Preview Opportunity:**

```
### Preview Available

The implementation is complete. You can preview the widget at:

    http://localhost:3000

To see the widget in action, you'll need to:
1. Ensure the dev server is running: `npm run dev`
2. Add the widget to a page (or I can create a demo page)
3. Configure mock API data or connect to a live API

Would you like me to:
1. Create a demo page to preview the widget?
2. Proceed directly to committing?
```

**Your Response:**
```
Proceed to committing
```

**Awaiting Approval:**

```
### Implementation Complete - Awaiting Approval

All tests pass and quality gates are green. Here's a summary:

## Implementation Summary

**Stories Implemented:**
- **Story 1.1:** Display Portfolio Total Value
- **Story 1.2:** Display Daily Change Amount
- **Story 1.3:** Display Daily Change Percentage
- **Story 1.4:** Integrate with Portfolio API

**Files Created:**
- \`types/portfolio.ts\` - TypeScript types for API response
- \`lib/api/portfolio.ts\` - API client function
- \`components/dashboard/PortfolioValueWidget.tsx\` - Main widget component

**Test Results:**
All 14 tests passing:
- 12 acceptance criteria tests
- 2 accessibility tests

---

## ⏸️ WAITING FOR YOUR APPROVAL

Please review the implementation:

1. **Test locally** at http://localhost:3000 (if dev server running)
2. **Review the code** for any issues or improvements

When you're satisfied, respond with one of:
- **"Approved"** - I'll commit and push to main
- **"Changes needed: [description]"** - I'll make the requested changes

What would you like to do?
```

**Approval and Next Steps:**

**Your Response:**
```
Approved. The implementation looks good.
```

**Agent Response:**

```
## Approved ✓

Committing and pushing to main...

$ git add .
$ git commit -m "feat(dashboard): implement portfolio value widget

- Add PortfolioSummary types
- Add getPortfolioSummary API function
- Create PortfolioValueWidget component
- Display formatted currency values
- Show daily change with color coding
- Display percentage with arrow indicators
- Include loading and error states
- Add accessibility labels

Stories: 1.1, 1.2, 1.3, 1.4
Tests: 14 passing"

$ git push origin main

### Summary for Epic 1, Story Set 1

| Item | Status |
|------|--------|
| Stories Implemented | 4/4 |
| Tests Passing | 14/14 |
| Committed to main | ✓ |

### Next Steps

Epic 1 implementation is complete. You have several options:

1. **Get a code review** - Use the code-reviewer agent:
   ```
   Review the code changes for the portfolio widget
   ```

2. **Run quality gates** - Check readiness:
   ```
   /quality-check
   ```

3. **Plan the next epic**:
   ```
   Plan stories for Epic 2: Trend Chart
   ```

What would you like to do next?
```

**What Gets Committed:**

```bash
# Agent commits implementation
git add web/src/types/ web/src/lib/api/ web/src/components/
git commit -m "feat(dashboard): implement portfolio value widget"
git push origin main
```

**Files Created in This Phase:**

```
web/
└── src/
    ├── types/
    │   └── portfolio.ts
    ├── lib/
    │   └── api/
    │       └── portfolio.ts
    └── components/
        └── dashboard/
            └── PortfolioValueWidget.tsx
```

**Key Points About the IMPLEMENT Phase:**

1. **One Story at a Time:** Although multiple stories were implemented here (because they're tightly coupled), the developer typically implements one story, waits for approval, then commits before the next.

2. **Tests Guide Implementation:** The developer reads failing tests to understand requirements, not just the story documents.

3. **No New Tests:** The developer does NOT write new tests—they only make existing tests pass.

4. **Mandatory Stop:** Before committing, the agent STOPS and waits for approval. It will not commit without explicit confirmation.

5. **Preview Opportunity:** The agent offers a chance to preview the implementation before committing.

6. **Direct to Main:** All work is committed directly to the main branch after approval.

7. **Clear Next Steps:** After approval and commit, the agent provides clear options for what to do next (review, quality gates, or next story).

---

## Step 5: QA Phase - Code Review (code-reviewer)

**Duration:** 5-15 minutes

After the implementation is complete and committed, you can invoke the code-reviewer agent to evaluate code quality before running quality gates.

**Your Input:**
```
Review the code changes for the portfolio widget
```

**What the Agent Does:**

1. **Reads the code changes** (recent commits on main)
2. **Checks against project patterns** (from CLAUDE.md)
3. **Evaluates multiple categories** (TypeScript, React, security, accessibility)
4. **Categorizes findings** by severity (Critical, High, Suggestions)
5. **Writes review findings** to context file
6. **Does NOT modify code** - only reports findings

**Sample Agent Output:**

```
## Code Review: Portfolio Value Widget

Reviewing changes in PR #42 against project standards...

### Files Reviewed
- web/src/types/portfolio.ts (18 lines)
- web/src/lib/api/portfolio.ts (15 lines)
- web/src/components/dashboard/PortfolioValueWidget.tsx (142 lines)

### Review Checklist

| Category | Status | Notes |
|----------|--------|-------|
| TypeScript & Types | ✅ Pass | Proper typing, no `any` |
| React Patterns | ✅ Pass | Hooks used correctly |
| Next.js Patterns | ✅ Pass | 'use client' directive present |
| Security | ✅ Pass | No XSS risks, no hardcoded secrets |
| Project Patterns | ✅ Pass | Uses API client, types in correct location |
| Error Handling | ✅ Pass | Loading and error states implemented |
| Accessibility | ✅ Pass | ARIA labels, semantic HTML |

---

## Review Findings

### Critical Issues (Must Fix)
None found ✓

### High Priority Issues
None found ✓

### Suggestions (Nice to Have)

## 1. Consider extracting formatting utilities
**Location:** `components/dashboard/PortfolioValueWidget.tsx:45-67`
**Issue:** Currency and percentage formatting functions are defined inline
**Impact:** Low - works correctly but reduces reusability
**Suggestion:** Consider moving `formatCurrency`, `formatChange`, and `formatPercent`
to a shared utilities file for reuse across other components.

```typescript
// Potential refactor to: lib/utils/formatting.ts
export function formatCurrency(value: number, currency: string = 'USD') { ... }
export function formatChange(value: number, currency: string = 'USD') { ... }
export function formatPercent(value: number) { ... }
```

**Priority:** Low - not blocking

## 2. Add error boundary for production resilience
**Location:** `components/dashboard/PortfolioValueWidget.tsx`
**Issue:** Component catches API errors but not render errors
**Impact:** Low - unlikely to cause issues but good practice
**Suggestion:** Consider wrapping with an error boundary in the parent component
or adding a try-catch in the render logic for edge cases.

**Priority:** Low - enhancement for future

## 3. Consider memoizing expensive calculations
**Location:** `components/dashboard/PortfolioValueWidget.tsx:45-67`
**Issue:** Formatting functions are recreated on every render
**Impact:** Negligible for this component, but good habit
**Suggestion:** Use `useCallback` for formatting functions or move them outside
the component since they don't depend on component state.

**Priority:** Low - micro-optimization

---

## Review Summary

| Severity | Count |
|----------|-------|
| Critical | 0 |
| High | 0 |
| Suggestions | 3 |

### Verdict: ✅ APPROVED

The code is well-structured, follows project patterns, and has no blocking issues.
The suggestions above are optional improvements that can be addressed in future
iterations if desired.

### Recommendation
Proceed to quality gates. No changes required before merge.
```

**Context File Created:**

**`generated-docs/context/review-findings.json`:**
```json
{
  "featureName": "Portfolio Value Widget",
  "epicNumber": 1,
  "timestamp": "2025-12-17T12:00:00Z",
  "reviewStatus": "approved",
  "prNumber": 42,
  "filesReviewed": [
    "web/src/types/portfolio.ts",
    "web/src/lib/api/portfolio.ts",
    "web/src/components/dashboard/PortfolioValueWidget.tsx"
  ],
  "summary": "Code is well-structured with minor suggestions for improvement",
  "findings": {
    "critical": [],
    "high": [],
    "suggestions": [
      {
        "id": 1,
        "title": "Consider extracting formatting utilities",
        "file": "components/dashboard/PortfolioValueWidget.tsx",
        "lines": "45-67",
        "description": "Currency and percentage formatting functions could be moved to shared utilities",
        "priority": "low"
      },
      {
        "id": 2,
        "title": "Add error boundary for production resilience",
        "file": "components/dashboard/PortfolioValueWidget.tsx",
        "description": "Consider wrapping with error boundary for edge cases",
        "priority": "low"
      },
      {
        "id": 3,
        "title": "Consider memoizing expensive calculations",
        "file": "components/dashboard/PortfolioValueWidget.tsx",
        "lines": "45-67",
        "description": "Formatting functions recreated on every render",
        "priority": "low"
      }
    ]
  },
  "checksPerformed": {
    "typescript": { "status": "pass", "errors": 0 },
    "react": { "status": "pass", "issues": 0 },
    "nextjs": { "status": "pass", "issues": 0 },
    "security": { "status": "pass", "vulnerabilities": 0 },
    "projectPatterns": { "status": "pass", "violations": 0 },
    "errorHandling": { "status": "pass", "coverage": "complete" },
    "accessibility": { "status": "pass", "violations": 0 }
  },
  "recommendation": "Proceed to quality gates"
}
```

**Handling Critical Issues:**

If the code-reviewer finds critical issues, the output looks different:

```
## Review Findings

### Critical Issues (Must Fix)

## 1. Potential XSS Vulnerability
**Location:** `components/dashboard/PortfolioValueWidget.tsx:85`
**Issue:** Using `dangerouslySetInnerHTML` with unsanitized API data
**Impact:** HIGH - Could allow script injection attacks
**Fix Required:**

```typescript
// ❌ Current (unsafe)
<div dangerouslySetInnerHTML={{ __html: data.description }} />

// ✅ Fixed (sanitized)
import { sanitizeHtml } from '@/lib/validation/schemas';
<div dangerouslySetInnerHTML={{ __html: sanitizeHtml(data.description) }} />
```

**This must be fixed before proceeding.**

---

## Review Summary

| Severity | Count |
|----------|-------|
| Critical | 1 |
| High | 0 |
| Suggestions | 2 |

### Verdict: ❌ CHANGES REQUIRED

Critical issues must be addressed before this code can be merged.

### Next Steps
1. Fix the XSS vulnerability identified above
2. Run the review again to verify the fix
3. Then proceed to quality gates
```

**Your Response After Review:**

```
Thanks for the review. The suggestions make sense but I'll address them later.
Let's proceed to quality gates.
```

---

## Step 6: QA Phase - Quality Gates (code-reviewer)

**Duration:** 5-10 minutes

After the code review, the code-reviewer runs all 5 quality gates and generates a PR-ready report.

**Your Input:**
```
/quality-check
```

Or:
```
Check if the feature is ready for PR
```

**What the Agent Does:**

1. **Runs automated checks** (npm audit, TypeScript, ESLint, build, tests)
2. **Prompts for manual verification** (functional testing, performance)
3. **Reads review findings** from context (if available)
4. **Generates a markdown report** for the PR description
5. **Provides clear recommendation** (Ready / Not Ready)

**Sample Agent Output:**

```
## Running Quality Gates

Checking all 5 quality gates...

---

### Gate 1: Functional Completeness ⏳

This gate requires manual verification.

**Acceptance Criteria from Stories:**
- [ ] Portfolio value displays as formatted currency ($125,432.50)
- [ ] Positive changes show green with + prefix
- [ ] Negative changes show red with - prefix
- [ ] Percentage displays with arrow indicators (▲/▼)
- [ ] Last updated timestamp displays correctly
- [ ] Loading state shows skeleton
- [ ] Error state shows message with context

**Question:** Have you tested all acceptance criteria and confirmed they work?

> Please respond: yes / no
```

**Your Response:**
```
yes
```

**Agent Continues:**

```
✅ Gate 1: Functional Completeness - PASSED (verified by developer)

---

### Gate 2: Security Review 🔍

Running automated security checks...

$ npm audit
found 0 vulnerabilities

$ Checking for hardcoded secrets...
No secrets detected ✓

$ Checking for security patterns...
- XSS prevention: ✓ No dangerouslySetInnerHTML
- Input validation: ✓ API responses typed
- RBAC usage: N/A (no auth required for this component)

✅ Gate 2: Security Review - PASSED

---

### Gate 3: Code Quality 🔍

Running code quality checks...

$ npx tsc --noEmit
No TypeScript errors ✓

$ npm run lint
No ESLint errors ✓

$ npm run build
Build completed successfully ✓

✅ Gate 3: Code Quality - PASSED

---

### Gate 4: Testing 🔍

Running test suite...

$ npm test -- --coverage --testPathPattern="portfolio-widget"

 PASS  src/__tests__/integration/portfolio-widget.test.tsx

Test Suites: 1 passed, 1 total
Tests:       14 passed, 14 total
Coverage:    87% statements, 82% branches

✅ Gate 4: Testing - PASSED (14/14 tests, 87% coverage)

---

### Gate 5: Performance ⏳

This gate requires manual verification.

**Performance Checklist:**
- [ ] Page loads in under 3 seconds
- [ ] No UI freezing during interactions
- [ ] No excessive re-renders (check React DevTools)
- [ ] Network requests complete reasonably fast

**Question:** Have you verified the performance criteria?

> Please respond: yes / no
```

**Your Response:**
```
yes
```

**Agent Generates Final Report:**

```
✅ Gate 5: Performance - PASSED (verified by developer)

---

## Quality Gate Summary

| Gate | Name | Type | Status |
|------|------|------|--------|
| 1 | Functional Completeness | Manual | ✅ PASSED |
| 2 | Security Review | Automated | ✅ PASSED |
| 3 | Code Quality | Automated | ✅ PASSED |
| 4 | Testing | Automated | ✅ PASSED |
| 5 | Performance | Manual | ✅ PASSED |

---

## 🎉 All Quality Gates Passed!

**Recommendation:** Code is verified and ready for the next epic.

---

## Quality Report

Here's a summary of the quality gate results:

| Gate | Status |
|------|--------|
| Functional Completeness | ✅ Verified |
| Security Review | ✅ 0 vulnerabilities |
| Code Quality | ✅ No errors |
| Testing | ✅ 14/14 passing (87% coverage) |
| Performance | ✅ Verified |

**Code Review:** Approved with 3 minor suggestions (non-blocking)

---

### Next Steps

1. **Start the next epic** (if applicable):
   ```
   Plan stories for Epic 2: Trend Chart
   ```

The TDD cycle for Epic 1: Core Widget Display is now complete! 🎉
```

**Context File Created:**

**`generated-docs/context/quality-gate-status.json`:**
```json
{
  "featureName": "Portfolio Value Widget",
  "epicNumber": 1,
  "timestamp": "2025-12-17T12:30:00Z",
  "overallStatus": "pass",
  "recommendation": "Ready for next epic",
  "gates": {
    "gate1_functional": {
      "name": "Functional Completeness",
      "status": "pass",
      "type": "manual",
      "verifiedBy": "developer",
      "acceptanceCriteria": 7,
      "criteriaVerified": 7
    },
    "gate2_security": {
      "name": "Security Review",
      "status": "pass",
      "type": "automated",
      "checks": {
        "npmAudit": { "vulnerabilities": 0 },
        "secretScan": { "secretsFound": 0 },
        "xssPrevention": { "issues": 0 },
        "inputValidation": { "status": "typed" }
      }
    },
    "gate3_codeQuality": {
      "name": "Code Quality",
      "status": "pass",
      "type": "automated",
      "checks": {
        "typescript": { "errors": 0 },
        "eslint": { "errors": 0, "warnings": 0 },
        "build": { "success": true, "time": "12.3s" }
      }
    },
    "gate4_testing": {
      "name": "Testing",
      "status": "pass",
      "type": "automated",
      "checks": {
        "testsPassed": 14,
        "testsFailed": 0,
        "coverage": {
          "statements": 87,
          "branches": 82,
          "functions": 90,
          "lines": 87
        }
      }
    },
    "gate5_performance": {
      "name": "Performance",
      "status": "pass",
      "type": "manual",
      "verifiedBy": "developer",
      "criteria": ["pageLoad", "noFreezing", "noExcessiveRenders", "networkSpeed"]
    }
  },
  "codeReviewSummary": {
    "status": "approved",
    "critical": 0,
    "high": 0,
    "suggestions": 3
  }
}
```

**Handling Failed Gates:**

If any gate fails, the output shows remediation steps:

```
## Quality Gate Summary

| Gate | Name | Type | Status |
|------|------|------|--------|
| 1 | Functional Completeness | Manual | ✅ PASSED |
| 2 | Security Review | Automated | ❌ FAILED |
| 3 | Code Quality | Automated | ✅ PASSED |
| 4 | Testing | Automated | ⚠️ WARNING |
| 5 | Performance | Manual | ✅ PASSED |

---

## ❌ Quality Gates Not Passed

### Gate 2: Security Review - FAILED

**Issue:** npm audit found vulnerabilities

```
found 2 vulnerabilities (1 moderate, 1 high)
  - lodash: Prototype Pollution (high)
  - minimist: Prototype Pollution (moderate)
```

**Remediation:**
```bash
npm audit fix
# or for breaking changes:
npm audit fix --force
```

### Gate 4: Testing - WARNING

**Issue:** Coverage below threshold

```
Coverage: 72% statements (threshold: 80%)
Missing coverage in:
- formatCurrency function (lines 45-52)
- error handling branch (line 68)
```

**Remediation:**
Add tests for uncovered code paths or adjust coverage threshold if justified.

---

## Recommendation: NOT READY FOR MERGE

Please address the failed gates above and run `/quality-check` again.
```

**Key Points About the QA Phase:**

1. **Review is Part of QA:** The code-reviewer agent handles both code review and quality gates in the QA phase.

2. **Code-Reviewer Doesn't Modify Code:** It only reports findings. You decide what to address.

3. **Quality Gates are Final Check:** All 5 gates must pass before the code is considered verified.

4. **Manual Gates Require Your Input:** Gates 1 (Functional) and 5 (Performance) need you to confirm you've tested.

5. **Automated Gates Run Commands:** Gates 2, 3, and 4 run actual npm/build commands.

6. **Context Files Track Status:** Both agents write to `generated-docs/context/` for traceability.

---

## Step 7: Workflow Completion

After all quality gates pass, the epic is complete and you're ready for the next one.

**Summary:**

Epic 1: Core Widget Display has been implemented:

- **Story 1.1:** Display Portfolio Total Value
- **Story 1.2:** Display Daily Change Amount
- **Story 1.3:** Display Daily Change Percentage
- **Story 1.4:** Integrate with Portfolio API

**Files Created:**

| File | Description |
|------|-------------|
| `types/portfolio.ts` | TypeScript types for API response |
| `lib/api/portfolio.ts` | API client function |
| `components/dashboard/PortfolioValueWidget.tsx` | Main widget component |

**Quality Gate Results:**

| Gate | Status |
|------|--------|
| Functional Completeness | ✅ Verified |
| Security Review | ✅ 0 vulnerabilities |
| Code Quality | ✅ No errors |
| Testing | ✅ 14/14 passing (87% coverage) |
| Performance | ✅ Verified |

**Code Review:** Approved with 3 minor suggestions (non-blocking)

**Verification:**

- [x] Verified all acceptance criteria manually
- [x] Ran full test suite
- [x] Checked accessibility with screen reader
- [x] Tested loading and error states

---

**Post-Epic Cleanup (Optional):**

```bash
# Clean up context files (optional - for fresh start before next epic)
rm -rf generated-docs/context/*.json

# Verify context directory structure preserved
ls generated-docs/context/
# Should show: .gitkeep
```

---

## Workflow Complete: Summary

Congratulations! You've completed a full TDD cycle for Epic 1. Here's what was accomplished:

**Artifacts Created:**

```
project-root/
├── documentation/
│   └── portfolio-widget.md              # Feature specification
├── generated-docs/
│   ├── wireframes/
│   │   ├── _overview.md                 # Wireframe summary
│   │   ├── screen-1-main-widget.md      # Main widget wireframe
│   │   ├── screen-2-loading.md          # Loading state
│   │   ├── screen-3-error.md            # Error state
│   │   └── screen-4-empty.md            # Empty state
│   └── stories/
│       ├── _feature-overview.md         # Epic summary
│       └── epic-1-core-widget-display/
│           ├── story-1-display-total-value.md
│           ├── story-2-display-daily-change.md
│           ├── story-3-display-percentage.md
│           └── story-4-api-integration.md
├── web/src/
│   ├── __tests__/integration/
│   │   └── portfolio-widget.test.tsx    # 14 integration tests
│   ├── types/
│   │   └── portfolio.ts                 # TypeScript types
│   ├── lib/api/
│   │   └── portfolio.ts                 # API client
│   └── components/dashboard/
│       └── PortfolioValueWidget.tsx     # React component
└── generated-docs/context/                      # (cleared after merge)
```

**Workflow Timeline:**

| Phase | Agent | Duration | Output |
|-------|-------|----------|--------|
| DESIGN | ui-ux-designer | ~10 min | 5 wireframe files |
| PLAN | feature-planner | ~20 min | 5 story files |
| WRITE-TESTS | test-generator | ~15 min | 1 test file (14 tests) |
| IMPLEMENT | developer | ~45 min | 3 source files |
| QA | code-reviewer | ~20 min | Review findings + Quality report |
| **Total** | | **~2 hours** | **Epic complete** |

**Git History:**

```
* abc1234 (HEAD -> main) IMPLEMENT: Story 3 - Portfolio value formatting
* def5678 IMPLEMENT: Story 2 - Portfolio data fetching
* ghi9012 IMPLEMENT: Story 1 - Core widget layout (includes tests from WRITE-TESTS phase)
* jkl3456 PLAN: Add stories for Epic 1 - Core Widget Display
* mno7890 DESIGN: Add wireframes for portfolio value widget
* pqr1234 docs: add portfolio widget specification
```

---

## Continuing to Epic 2

After merging Epic 1, you can continue with Epic 2 (Trend Chart):

**Your Input:**
```
Plan stories for Epic 2: Trend Chart
```

**What Happens:**

1. feature-planner reads the existing `_feature-overview.md`
2. Creates stories for Epic 2 in `generated-docs/stories/epic-2-trend-chart/`
3. The cycle repeats: PLAN → WRITE-TESTS → IMPLEMENT → QA

**Epic 2 Stories (Example):**

```
Epic 2: Trend Chart
├── Story 2.1: Display 7-Day Sparkline Chart
├── Story 2.2: Handle Empty Trend Data
└── Story 2.3: Add Trend Direction Indicator
```

---

## Full Feature Completion

After completing all 4 epics:

```
Epic 1: Core Widget Display ✅ Complete
Epic 2: Trend Chart ✅ Complete
Epic 3: State Handling ✅ Complete
Epic 4: Interactivity ✅ Complete
```

**Final Feature State:**

- All wireframes implemented
- All stories complete with acceptance tests
- Full test coverage across all components
- All epics committed to main
- Feature documentation in `generated-docs/`

---

## Example 1 Summary

This example demonstrated the complete TDD workflow:

| Step | What Happened |
|------|---------------|
| **Setup** | Created feature spec, verified environment |
| **DESIGN** | ui-ux-designer created wireframes for 4 states |
| **PLAN** | feature-planner broke down feature into 4 epics, created 4 stories for Epic 1 |
| **WRITE-TESTS** | test-generator created 14 failing tests |
| **IMPLEMENT** | developer wrote code to pass all tests, committed to main |
| **QA** | code-reviewer evaluated code, ran all 5 quality gates, all passed |
| **Complete** | Epic committed, ready for Epic 2 |

**Key Takeaways:**

1. **Tests First:** Tests were written before implementation, ensuring clear requirements
2. **One Epic at a Time:** Focus on completing one epic fully before starting the next
3. **Approval Gates:** Human approval required at key points (stories, commits, gates)
4. **Automated + Manual:** Mix of automated checks and human verification
5. **Artifacts Preserved:** All planning documents saved for reference
6. **Direct to Main:** All work committed directly to main branch after approval

---

*This completes Example 1. For other workflow scenarios, see:*
- [Example 2: Mid-Chain Entry](./example-2-mid-chain-entry.md) - Starting from an existing plan
- [Example 3: Bug Fix Workflow](./example-3-bug-fix.md) - Alternative workflow for bug fixes
