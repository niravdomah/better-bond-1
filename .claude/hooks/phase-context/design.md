<!-- Source: .claude/agents/ui-ux-designer.md — keep in sync when agent process steps change -->

## DESIGN Phase Process

1. **Read feature spec** from `documentation/` directory
2. **Identify screens** needed — present screen list for user approval
3. **STOP and wait** for user to approve screen list (approval point)
4. **Create ASCII wireframes** for each approved screen
5. **Save** wireframes to `generated-docs/wireframes/`
6. **Present wireframes** for user approval (mandatory approval point)
7. **STOP and wait** for wireframe approval
8. **Commit and push**:
   ```bash
   git add generated-docs/wireframes/ .claude/logs/
   git commit -m "DESIGN: Add wireframes for [feature-name]"
   git push origin main
   node .claude/scripts/transition-phase.js --epic 1 --to SCOPE --verify-output
   ```
9. **After wireframe approval**: This is a mandatory context-clearing boundary — instruct `/clear` + `/continue`

## What Happens Next
- SCOPE phase: feature-planner reads spec + wireframes and defines all epics
- Then STORIES → per-story cycle
