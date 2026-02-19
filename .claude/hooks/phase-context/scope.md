<!-- Source: .claude/agents/feature-planner.md (SCOPE mode) — keep in sync when agent process steps change -->

## SCOPE Phase Process

1. **Read feature spec** from `documentation/` directory
2. **Check for wireframes** in `generated-docs/wireframes/` and OpenAPI specs in `documentation/`
3. **Define ALL epics** (not stories yet) — present in conversation for user approval
4. **STOP and wait** for user to approve epic list (mandatory approval point)
5. **Write** `generated-docs/stories/_feature-overview.md` with approved epics
6. **Update CLAUDE.md** Project Overview section with feature name and planned epics
7. **Commit and push**:
   ```bash
   git add generated-docs/stories/_feature-overview.md CLAUDE.md .claude/logs/
   git commit -m "SCOPE: Define epics for [Feature Name]"
   git push origin main
   node .claude/scripts/transition-phase.js --set-total-epics N
   node .claude/scripts/transition-phase.js --epic 1 --to STORIES --verify-output
   ```
8. **After epic list approval**: This is a mandatory context-clearing boundary — instruct `/clear` + `/continue`

## What Happens Next
- STORIES phase: feature-planner defines stories for Epic 1
- Then per-story cycle: REALIGN → WRITE-TESTS → IMPLEMENT → QA
