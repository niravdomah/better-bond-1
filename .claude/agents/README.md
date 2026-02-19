# Claude Code Agents

This directory contains specialized Claude Code agents that support a **Test-Driven Development (TDD)** workflow for building features in this template repository.

## TDD Workflow Overview

```
DESIGN (once) → SCOPE (epics only) → [STORIES → [REALIGN → WRITE-TESTS → IMPLEMENT → QA] per story] per epic
```

**Expanded view:**
```
[ui-ux-designer] → feature-planner → feature-planner → feature-planner → test-generator → developer → code-reviewer
     DESIGN            SCOPE             STORIES           REALIGN          WRITE-TESTS     IMPLEMENT      QA
                   (all epics)        (per epic)        (per story)       (per story)     (per story)   (per story)
```

| Phase | Agent | Description |
|-------|-------|-------------|
| **DESIGN** | ui-ux-designer | Create wireframes for UI features (optional, once) |
| **SCOPE** | feature-planner | Define ALL epics upfront (no stories yet) |
| **STORIES** | feature-planner | Define stories for the current epic only |
| **REALIGN** | feature-planner | Revise upcoming story based on discovered impacts (per story) |
| **WRITE-TESTS** | test-generator | Write failing tests before implementation (per story) |
| **IMPLEMENT** | developer | Implement code to make tests pass (per story) |
| **QA** | code-reviewer | Review code quality, run quality gates, commit (per story) |

---

## Available Agents

### 1. UI/UX Designer (Optional)

**File:** [ui-ux-designer.md](ui-ux-designer.md)

**Purpose:** Generates simple text-based wireframes from feature specifications. Creates ASCII/markdown layouts for each screen before story planning begins.

**When to use:**
- Before feature-planner when the feature involves UI
- When you want visual clarity before breaking down stories
- Optional - feature-planner works without wireframes

**Invocation:**
```
Create wireframes for the user settings feature
```

**Key outputs:**
- `generated-docs/wireframes/_overview.md`
- `generated-docs/wireframes/screen-N-[name].md`

---

### 2. Feature Planner

**File:** [feature-planner.md](feature-planner.md)

**Purpose:** Transforms feature specifications into structured implementation plans through collaborative refinement. Creates epics, user stories, and acceptance criteria. Automatically references wireframes if available.

**When to use:**
- Starting a new feature from a specification
- Breaking down complex requirements into implementable stories
- After ui-ux-designer (optional) or as first step in TDD workflow

**Invocation:**
```
Plan the user authentication feature based on the spec
```

**Key outputs:**
- `generated-docs/stories/_feature-overview.md`
- `generated-docs/stories/epic-N-[name]/story-N-[name].md`

---

### 3. Test Generator

**File:** [test-generator.md](test-generator.md)

**Purpose:** Generates comprehensive Vitest + React Testing Library tests BEFORE implementation. Creates failing tests that define acceptance criteria as executable code.

**When to use:**
- Immediately after feature-planner completes an epic
- Before ANY implementation code is written
- When defining what a component/feature should do

**Invocation:**
```
Generate tests for Epic 1: Basic Auth
```

**Key outputs:**
- `web/src/__tests__/integration/[feature].test.tsx`
- `generated-docs/context/test-coverage.json`

---

### 4. Developer

**File:** [developer.md](developer.md)

**Purpose:** Implements user stories from project plans one at a time, ensuring each story is properly completed and reviewed before moving to the next. Follows a main branch workflow with review gates.

**When to use:**
- After test-generator has created failing tests (ready for IMPLEMENT phase)
- When implementing stories from a project plan
- When you want controlled, incremental feature implementation with review checkpoints

**Invocation:**
```
Implement the next story from the plan
```
or
```
Start implementing the user authentication stories
```

**Key behaviors:**
- Implements exactly ONE story at a time
- Locates and makes failing tests pass
- Runs all 4 quality gates before transitioning to QA
- Follows project patterns (App Router, Shadcn UI, API client)

---

### 5. Code Reviewer

**File:** [code-reviewer.md](code-reviewer.md)

**Purpose:** Reviews code changes for quality, security, and adherence to project patterns. Prompts user for manual verification in the web app. Routes issues by severity for resolution.

**When to use:**
- After implementing a feature (IMPLEMENT phase complete)
- Before creating a PR
- As part of the QA phase

**Invocation:**
```
Review the code changes for the portfolio dashboard
```

**What it checks:**
- TypeScript & React quality
- Next.js 16 patterns
- Security (XSS, secrets, RBAC)
- Project patterns (API client, types, Shadcn UI)
- Testing coverage
- Accessibility
- Manual verification (user tests in browser)

**Issue resolution:**
- Critical issues → pause, user fixes (with optional Claude assistance), re-review
- High/Medium issues → logged for fix epic (via REALIGN)

---

---

## Workflow Recommendations

### Starting a New Feature

1. **DESIGN (Optional):** Invoke `ui-ux-designer` if the feature has UI
   - Approve screen list → approve wireframes → **mandatory /clear + /continue**

2. **SCOPE:** Invoke `feature-planner` with your feature spec
   - Agent checks for wireframes, defines all epics
   - Approve epic list → **mandatory /clear + /continue**

3. **STORIES:** Invoke `feature-planner` for current epic
   - Agent defines stories for THIS epic only
   - Approve story list → proceeds directly to REALIGN

4. **Per-story cycle:** REALIGN → WRITE-TESTS → IMPLEMENT → QA
   - Transitions between these phases happen automatically (no stops)
   - IMPLEMENT uses 2 scoped developer calls (implement, then quality gates)
   - QA uses 2 scoped code-reviewer calls (review, then gates + verify + commit)
   - After QA manual verification → **mandatory /clear + /continue**

5. **Epic completion:** After last story's QA, code-reviewer presents epic review
   - **Mandatory /clear + /continue** before starting next epic

6. **Repeat:** Next epic's STORIES phase, or feature complete

### Context Management

Context clearing happens at 4 mandatory boundaries (wireframe approval, epic list approval, story QA completion, epic completion). Between these boundaries, phases transition automatically. A post-compaction hook (`inject-phase-context.ps1`) restores workflow instructions if auto-compaction fires mid-workflow.

### Quick Quality Check

Before committing:
```
/quality-check
```

### Reviewing Existing Code

For code review without full TDD workflow:
```
Review the authentication module for security issues
```

---

## Context Directory

The `generated-docs/context/` directory is used for agent-to-agent communication. Files here are temporary and gitignored.

| File | Created By | Used By |
|------|------------|---------|
| `workflow-state.json` | transition scripts | all agents |
| `feature-spec.json` | feature-planner | test-generator |
| `test-coverage.json` | test-generator | code-reviewer |
| `review-findings.json` | code-reviewer | code-reviewer (QA phase) |
| `quality-gate-status.json` | code-reviewer | (final output) |

---

## Workflow State Management

### Transition Scripts

The workflow uses scripts to track and validate state:

| Script | Purpose |
|--------|---------|
| `transition-phase.js` | Manages phase transitions with validation |
| `validate-phase-output.js` | Validates artifacts exist for a phase |
| `detect-workflow-state.js` | Detects state from artifacts (read-only) |

### Script Execution Verification (CRITICAL)

**Agents MUST verify script execution succeeded before proceeding.**

When running transition scripts, always check the JSON output:

```bash
# Run the transition
node .claude/scripts/transition-phase.js --current --to WRITE-TESTS

# Expected success output:
# { "status": "ok", "message": "Transitioned Epic 1 from PLAN to WRITE-TESTS", ... }

# Error output (DO NOT PROCEED):
# { "status": "error", "message": "Invalid transition...", ... }
```

**Verification rules:**
1. `"status": "ok"` = Success, proceed to next step
2. `"status": "error"` = **STOP** and report the error to the user
3. `"status": "warning"` = Proceed with caution, inform user of the warning

### Validation Flags

Use these flags for additional safety:

```bash
# Check prerequisites before transitioning
node .claude/scripts/transition-phase.js --epic 1 --to WRITE-TESTS --validate

# Verify the FROM phase created expected outputs
node .claude/scripts/transition-phase.js --current --to IMPLEMENT --verify-output
```

### Repair Function

If workflow state is lost or corrupted:

```bash
node .claude/scripts/transition-phase.js --repair
```

The repair function provides a **confidence level** (high/medium/low):
- **High confidence:** Artifacts clearly indicate state
- **Medium confidence:** Some assumptions made - verify with user
- **Low confidence:** Many assumptions - require user confirmation before proceeding

---

## Creating Custom Agents

Use the template file [_agent-template.md](_agent-template.md) to create new agents.

Key requirements:
1. Add YAML frontmatter with `name`, `description`, `model`, and `tools`
2. Document clear purpose and when to use
3. Define step-by-step workflow
4. Include DO/DON'T guidelines
5. Provide example prompts

---

## Related Documentation

- [Agent Workflow Guide](../../.template-docs/agent-workflow-guide.md) - Complete workflow documentation with examples
- [Project README](../../README.md) - Project overview and setup
- [CLAUDE.md](../../CLAUDE.md) - Claude Code configuration for this project
- [Testing Strategy](../../CLAUDE.md#testing-strategy) - Testing patterns and conventions
