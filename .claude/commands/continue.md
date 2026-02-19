---
description: Resume interrupted TDD workflow
---

You are helping a developer resume the TDD workflow from where it was interrupted.

## Workflow Reminder

The TDD workflow has three stages:

1. **One-time setup**: DESIGN (optional) → SCOPE (define all epics, no stories yet)
2. **Per-epic**: STORIES (define stories for the current epic only)
3. **Per-story iteration**: REALIGN → WRITE-TESTS → IMPLEMENT → QA → commit → (next story)

After QA passes for a story:
- If more stories in epic → REALIGN for next story
- If no more stories but more epics → STORIES for next epic
- If no more stories and no more epics → Feature complete!

## Step 1: Validate Workflow State

First, check if workflow state exists and is valid:

```bash
node .claude/scripts/transition-phase.js --show
```

### If `status: "no_state"` or state appears stale:

**Automatically attempt to repair the state first:**
```bash
node .claude/scripts/transition-phase.js --repair
```

If repair succeeds, show the user the detected state and ask them to confirm before proceeding.

If repair fails (no artifacts found), ask the user:
> "No workflow state or artifacts found. Would you like to start fresh with `/start`, or describe the current state so I can help you continue?"

**Important:** After repair, check the **confidence level** in the output:
- `"confidence": "high"` - State is reliable, show summary and proceed
- `"confidence": "medium"` - Show the `detected` and `assumed` arrays, ask user to confirm
- `"confidence": "low"` - **REQUIRE** user to verify before proceeding, show warning prominently

The repair output includes:
- `detected`: What was clearly found in artifacts
- `assumed`: What was inferred (may be wrong)
- `confidenceReason`: Explanation of confidence level

### If state exists (high confidence):

Display a brief summary and **proceed immediately** — no confirmation needed:
```
Resuming: Epic [N], Story [M], Phase: [phase]
```

### If state exists (medium/low confidence or user reports incorrect):

Ask the user to confirm. If wrong, use `--repair` or ask them to describe the correct state.

## Step 1.5: Reconstruct Progress Display

After validating workflow state, reconstruct the TodoWrite progress display:

```bash
node .claude/scripts/generate-todo-list.js
```

Parse the JSON output and call `TodoWrite` with the resulting array. This is essential because TodoWrite state is lost on `/clear` — the list must be rebuilt from `workflow-state.json` on every `/continue`.

**After the agent completes and returns**, re-run this script and update TodoWrite to reflect the new state.

## Step 2: Detect Detailed State (if needed)

For additional context, run the detection script:

```bash
node .claude/scripts/detect-workflow-state.js json
```

This provides:
- `spec`: Path to feature specification
- `epics[]`: Array with each epic's name, phase, story/test counts, acceptance test progress
- `resume.epic`: Which epic to resume
- `resume.phase`: Detected phase from artifacts

**Note:** The `workflow-state.json` file is authoritative. The detection script provides supplementary information but should not override the state file.

## Step 3: Resume with Appropriate Agent

Based on `workflow-state.json`, determine the agent and context:

| Phase | Agent | Context to Provide |
|-------|-------|-------------------|
| SCOPE | `feature-planner` | Spec path |
| DESIGN | `ui-ux-designer` | Spec path |
| STORIES | `feature-planner` | Epic number, spec path |
| REALIGN | `feature-planner` | Epic number, story number, discovered-impacts.md path |
| WRITE-TESTS | `test-generator` | Epic number, story number, story file path |
| IMPLEMENT | `developer` | Epic, story, test file path, failing tests (see below) |
| QA | `code-reviewer` | Epic number, story number, files changed |
| COMPLETE | — | Check next action from transition output |

Always provide: current epic number/name, current story number/name (from state), relevant file paths.

### For IMPLEMENT phase:

Before invoking `developer`, run `npm test` in `/web` to identify failing tests for the current story:
- Show the user which tests are failing
- Include the failing test output when handing off to the developer agent

### For COMPLETE phase:

The transition script determines what's next:
- More stories in epic → Proceed to REALIGN for next story
- No more stories but more epics → Proceed to STORIES for next epic
- No more stories and no more epics → Display success message - feature complete!

## Step 5: Remind Agent to Update State

**Critical:** Before handing off to an agent, remind them:

> "When you complete this phase, you MUST update the workflow state by running:
> ```bash
> # For epic-level phases (SCOPE, STORIES):
> node .claude/scripts/transition-phase.js --epic [N] --to [NEXT_PHASE]
>
> # For story-level phases (REALIGN, WRITE-TESTS, IMPLEMENT, QA):
> node .claude/scripts/transition-phase.js --epic [N] --story [M] --to [NEXT_PHASE]
> ```
> Do not proceed to the next phase without running this command."

## Error Handling

- **State file missing:** Use `--repair` to reconstruct from artifacts
- **State appears wrong:** Ask user to confirm or correct
- **Script fails:** Ask user to describe current state manually
- **Invalid transition:** Show allowed transitions and ask user what to do

## Script Execution Verification

**All transition scripts output JSON. Always verify the result before proceeding:**

1. `"status": "ok"` = Success, proceed to next step
2. `"status": "error"` = **STOP**, report the error to the user
3. `"status": "warning"` = Proceed with caution, inform user

**For repair operations**, check the confidence level (see Step 1 for details).

Example error handling:
```
# If script output shows:
{ "status": "error", "message": "Invalid transition..." }

# Then STOP and tell the user:
"The workflow transition failed: [message]. Please check the current state with /status."
```

## Context Management Policy

Context clearing happens at **4 mandatory boundaries**. The user must run `/clear` then `/continue` at each:

1. After wireframe approval (DESIGN complete) — orchestrator instructs
2. After epic list approval (SCOPE complete) — orchestrator instructs
3. After story QA complete — code-reviewer return message (display and stop)
4. After epic completion review — code-reviewer return message (display and stop)

**Boundaries #3-4:** The code-reviewer's return message contains the clearing instruction. Display it and **STOP** — do not launch the next agent.

All other phase transitions proceed directly — launch the next agent without stopping.

**Post-compaction safety net:** The `inject-phase-context.ps1` hook automatically restores workflow instructions after auto-compaction.

## Scoped Call Pattern

For longer phases, split agent work into focused calls:

- **IMPLEMENT:** 2 developer calls — (A) implement code, (B) run quality gates
- **QA:** 2 code-reviewer calls — (A) code review, (B) gates + verify + commit
- **After code-reviewer Call B returns:** Display its return message and **STOP**. The message contains the `/clear` + `/continue` instruction. Do not launch the next agent.

## DO

- Always validate state at the start of the session
- Auto-proceed on high confidence state (no confirmation needed)
- Commit work before handing off to the next agent
- Remind agents to use the transition script
- Use scoped calls for IMPLEMENT and QA phases

## DON'T

- Auto-approve anything on behalf of the user
- Skip state validation
- Trust artifact detection over the state file
- Proceed if the user says the state is wrong
- Stop for context clearing at non-boundary phase transitions

## Related Commands

- `/start` - Start TDD workflow from the beginning
- `/status` - Show current progress without resuming
- `/quality-check` - Validate all 5 quality gates
