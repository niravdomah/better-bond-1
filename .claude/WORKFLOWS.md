# AI-Driven Development Workflows

Quick reference for common workflows in this template.

---

## Workflow 1: Starting a New Project

**Scenario:** You just created a new project from this GitHub template.

### Steps:

```bash
# 1. Create from template
Click "Use this template" on GitHub → Name your project → Create

# 2. Clone and open
git clone https://github.com/your-username/your-new-project.git
cd your-new-project
code .  # Opens in VSCode

# 3. Initialize (choose ONE):

# Option A - Automatic (recommended)
cd web
npm install
# Ready to code!

# Option B - Using Claude Code
# In Claude Code chat, type:
/start
# Runs npm install
# Verifies setup
# Displays next steps

# 4. Start your first feature
# In Claude Code chat, type:
/start
# Claude guides you through building your first feature
```

### Expected Timeline:
- **Setup:** 2-5 minutes
- **First feature:** Depends on complexity (simple feature ~15-30 min with AI assistance)

---

## Workflow 2: Adding Features to Existing Project

**Scenario:** Your project is already set up and you want to add a new feature.

### Steps:

```bash
# 1. Open your existing project
cd your-existing-project
code .  # Opens in VSCode

# 2. (Optional) Start dev server
cd web
npm run dev

# 3. Start new feature
# In Claude Code chat, type:
/start
# Claude detects existing project and guides you through adding the feature
```

### What Claude Will Do:

1. **Detect project state:**
   - Confirms project is initialized
   - Checks for in-progress features
   - Assesses project maturity

2. **Gather requirements:**
   - Asks what feature you want to build
   - Clarifies UI/API needs
   - Checks existing patterns

3. **Guide implementation:**
   - Invokes feature-planner agent for scoping
   - Uses test-generator for tests
   - Guides you through implementation
   - Validates with code-reviewer (QA phase)

4. **Commit and push:**
   - Runs quality checks
   - Commits to main branch
   - Pushes to remote

---

## Workflow 3: Resuming In-Progress Feature

**Scenario:** You started a feature but didn't finish it. Now you want to continue.

### Steps:

```bash
# In Claude Code chat, type:
/continue

# Claude will detect the in-progress feature and resume
```

### What Claude Will Say:

```
Claude: I see a feature in progress: "User Profile Page"

Status:
Planning complete (feature spec created)
UI components created (UserProfile.tsx, EditProfile.tsx)
API integration in progress
Tests not yet written

Would you like to:
1. Continue the API integration
2. Start a different feature
3. Review what's been done so far

What would you prefer?
```

---

## Workflow 4: Resume Interrupted TDD Workflow

**Scenario:** The `/start` workflow was interrupted (closed VSCode, lost connection, etc.) or you ran `/clear` at a context-clearing boundary and need to resume.

### Steps:

```bash
# In Claude Code chat, type:
/continue

# Claude will:
# 1. Validate workflow state from workflow-state.json
# 2. Auto-proceed on high confidence (no confirmation needed)
# 3. Resume with the appropriate agent
# 4. Use scoped calls for IMPLEMENT and QA phases
```

### What Claude Will Show:

```
📋 Analyzing project state...

✅ Feature spec found: documentation/BetterBond-Commission-Payments-POC-002.md
✅ Wireframes found: 8 wireframes in generated-docs/wireframes/

📊 Epic & Story Status:
┌────────┬──────────────────────────────────┬──────────┬────────────────────┐
│ Epic   │ Name                             │ Stories  │ Current Story      │
├────────┼──────────────────────────────────┼──────────┼────────────────────┤
│ Epic 1 │ Dashboard & Navigation           │ 3/3 ✅   │ -                  │
│ Epic 2 │ Payment Management Core          │ 2/5      │ story-3 (IMPLEMENT)│
│ Epic 3 │ Payment Forms                    │ 0/?      │ PENDING            │
│ Epic 4 │ Payment Allocation               │ 0/?      │ PENDING            │
└────────┴──────────────────────────────────┴──────────┴────────────────────┘

📍 Current Position: Epic 2, Story 3 (Parked Payments Grid)
   Phase: IMPLEMENT
   - Story 1-2: ✅ Complete (committed)
   - Story 3: 🔄 In Progress (IMPLEMENT phase)
   - Story 4-5: ⏳ Not started (PENDING)

🚀 Resuming workflow...

Launching developer agent for Epic 2, Story 3: Parked Payments Grid
```

### When to Use `/continue`:

- You closed VSCode and want to pick up where you left off
- The TDD workflow was interrupted (error, timeout, etc.)
- You want to see the current status and resume automatically
- You're not sure which epic/story to work on next

---

## Workflow 5: Complete Feature → Commit & Push

**Scenario:** You've finished building a feature and want to commit it.

### Steps:

```bash
# 1. Validate quality gates
# In Claude Code chat, type:
/quality-check

# 2. Claude runs all checks:
Gate 1: Functional (manual confirmation)
Gate 2: Security (npm audit, no secrets)
Gate 3: Code Quality (TypeScript, ESLint, build)
Gate 4: Testing (Vitest tests pass)
Gate 5: Performance (ready)

# 3. Commit and push to main
git add .
git commit -m "feat: add user profile page"
git push origin main
```

---

## TDD Workflow Execution (IMPORTANT)

**When using `/start` command for feature development:**

The TDD workflow has three stages:

### Stage 1: One-time Setup (DESIGN → SCOPE)

```
/start → [ui-ux-designer] → feature-planner
              DESIGN             SCOPE
```

- **DESIGN** (optional): Create wireframes for UI features
- **SCOPE**: Define ALL epics (no stories yet). User approves the epic list.

### Stage 2: Per-Epic (STORIES)

```
For each epic:
  feature-planner (STORIES) → Define stories for THIS epic → user approves
```

- **STORIES**: Define stories and acceptance criteria for the current epic only (not all epics upfront)

### Stage 3: Per-Story Iteration (REALIGN → WRITE-TESTS → IMPLEMENT → QA)

```
For each story in the epic:
  feature-planner → test-generator → developer → code-reviewer → commit & push
      REALIGN          WRITE-TESTS        IMPLEMENT      QA

(repeat for each story, then move to next epic's STORIES phase...)
```

**REALIGN Phase:**
- Runs **before each story** (before WRITE-TESTS)
- Feature-planner checks `generated-docs/discovered-impacts.md` for impacts affecting the upcoming story
- If impacts exist: revises the story and gets user approval before proceeding
- If no impacts for this story (file empty, missing, or only has impacts for other stories): **auto-completes immediately** — no user approval needed, no commit, transitions straight to WRITE-TESTS
- Clears processed impacts from the log after handling

**❌ Don't do this:**
- Define stories for ALL epics upfront → then implement ALL stories

**✅ Do this instead:**
- Define epics upfront (SCOPE phase)
- For each epic: Define stories (STORIES phase)
- For each story: REALIGN → Generate tests → Implement → QA → Commit

**Why this matters:**
- ✅ Epic scope visibility before story implementation begins
- ✅ Stories defined per-epic for flexibility to pivot
- ✅ Tests written immediately before each story (true TDD)
- ✅ Quality gates always pass (no skipped tests)
- ✅ One commit per story after QA passes
- ✅ Early feedback through per-story review
- ✅ Faster pivots - discover issues per-story, not per-epic
- ✅ Implementation learnings feed back into future story planning via REALIGN

### Discovered Impacts

During implementation (WRITE-TESTS, IMPLEMENT phases), agents may discover that future stories need changes. When this happens:

1. **Agent flags the impact** by appending to `generated-docs/discovered-impacts.md`
2. **Impact is processed** during REALIGN phase before the affected story starts
3. **User approves** any story revisions before proceeding

See `_feature-overview.md` in `generated-docs/stories/` for the lightweight index of epics, and `_epic-overview.md` in each epic directory for stories.

### Context Management

Context clearing happens at **4 mandatory boundaries** during the workflow:

| # | Boundary | When |
|---|----------|------|
| 1 | Wireframe approval | DESIGN complete → before SCOPE |
| 2 | Epic list approval | SCOPE complete → before STORIES |
| 3 | Manual verification after QA | Each story's QA complete → before next REALIGN |
| 4 | Epic completion review | Epic complete → before next STORIES |

At these points, run `/clear` then `/continue`. All other phase transitions happen automatically.

**Post-compaction hooks** (`inject-phase-context.ps1`, `inject-agent-context.ps1`) automatically restore workflow state and instructions if auto-compaction fires mid-workflow. This provides a safety net against instruction loss in long sessions.

**Scoped calls** reduce context accumulation: IMPLEMENT uses 2 developer calls (implement, then quality gates) and QA uses 2 code-reviewer calls (review, then gates + verify + commit).

---

## Command Reference

| Command | When to Use | What It Does |
|---------|-------------|--------------|
| `/start` | Begin TDD workflow for a feature | Reads spec from documentation/, guides through scoping and implementation |
| `/continue` | Resume interrupted TDD workflow | Detects current phase and resumes with appropriate agent |
| `/status` | Check workflow progress | Shows which phase you're in and what's completed |
| `/quality-check` | Before committing | Validates all 5 quality gates |
| `/setup` | First time setup, or re-verify setup | Runs npm install + verification |

---

## Pro Tips

### For New Projects:
- Use `/setup` once to initialize (or just run `npm install`)
- Use `/start` for each new feature
- Run `/quality-check` before every commit

### For Existing Projects:
- Use `/start` to add features
- Claude detects project state automatically
- No need to run `/setup` again

### For Collaboration:
- Team members clone existing project
- They run `npm install` (or `/setup`)
- Use `/start` to add features
- All quality gates enforced for everyone

### For Context Switching:
- Claude remembers in-progress features
- Workflow state stored in `generated-docs/context/`
- Safe to close and reopen VSCode
- Type `/continue` to resume

---

## Troubleshooting

### "I ran `/start` but nothing happened"
- Check that Claude Code extension is active
- Look for the command prompt response
- Try running `npm install` manually

### "I want to start over with a feature"
- Delete `generated-docs/context/` contents
- Type `/start` to begin fresh

### "Claude doesn't remember my in-progress feature"
- Context files may have been deleted
- Just describe what you were building
- Claude can help pick up from where you left off

### "Quality gates are failing"
- Type `/quality-check` to see specific failures
- Claude provides fix suggestions
- Re-run after fixes applied

---

## Decision Tree

```
Are you starting a NEW project from template?
├─ YES → Run `/setup` once, then `/start` for first feature
└─ NO → Continue below

Is the project already initialized (node_modules exists)?
├─ YES → Use `/start` to add features
└─ NO → Run `/setup` first

Do you have a feature in progress?
├─ YES → Type `/continue` and Claude will detect and resume it
└─ NO → Type `/start` to begin a new one

Is your feature complete?
├─ YES → Type `/quality-check` then commit and push to main
└─ NO → Continue building with Claude's guidance
```

---

**Questions?** Type `/help` or just ask Claude directly!
