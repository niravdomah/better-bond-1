#!/usr/bin/env node
/**
 * generate-todo-list.js
 * Reads workflow-state.json and outputs a TodoWrite-compatible JSON array.
 *
 * Usage:
 *   node .claude/scripts/generate-todo-list.js
 *
 * Output: JSON array of { content, status, activeForm } objects to stdout.
 *
 * The list uses "smart expansion":
 *   - Completed epics → single collapsed item each
 *   - Current epic → expanded with per-story items
 *   - Current story → expanded with sub-phase items (REALIGN, WRITE-TESTS, IMPLEMENT, QA)
 *   - Future stories in current epic → collapsed into one "Stories N-M: Remaining stories" item
 *   - Future epics → collapsed into one "Epics N-M: Remaining epics" item
 *   - Single remaining epic/story → shown individually by name
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..', '..');
const STATE_FILE = path.join(ROOT, 'generated-docs/context/workflow-state.json');
const STORIES_DIR = path.join(ROOT, 'generated-docs/stories');

// Sub-phase order for per-story TDD cycle
const STORY_SUB_PHASES = ['REALIGN', 'WRITE-TESTS', 'IMPLEMENT', 'QA'];

// Human-readable labels for sub-phases
const SUB_PHASE_LABELS = {
  'REALIGN': { content: 'Review impacts (REALIGN)', activeForm: 'Reviewing impacts' },
  'WRITE-TESTS': { content: 'Write failing tests (WRITE-TESTS)', activeForm: 'Writing tests' },
  'IMPLEMENT': { content: 'Implement code (no suppressions, tests must pass)', activeForm: 'Implementing code' },
  'QA': { content: 'Code review & QA (all gates must exit 0)', activeForm: 'Reviewing & running QA' }
};

// =============================================================================
// HELPERS
// =============================================================================

function readState() {
  if (!fs.existsSync(STATE_FILE)) return null;
  try {
    return JSON.parse(fs.readFileSync(STATE_FILE, 'utf-8'));
  } catch {
    return null;
  }
}

function getEpicDisplayName(epicNum) {
  if (!fs.existsSync(STORIES_DIR)) return `Epic ${epicNum}`;
  try {
    const dirs = fs.readdirSync(STORIES_DIR).filter(d => d.match(new RegExp(`^epic-${epicNum}-`)));
    if (dirs.length > 0) {
      return dirs[0].replace(/^epic-\d+-/, '').replace(/-/g, ' ');
    }
  } catch { /* ignore */ }
  return `Epic ${epicNum}`;
}

function getStoryDisplayName(epicNum, storyNum) {
  if (!fs.existsSync(STORIES_DIR)) return `Story ${storyNum}`;
  try {
    const epicDirs = fs.readdirSync(STORIES_DIR).filter(d => d.match(new RegExp(`^epic-${epicNum}`)));
    if (epicDirs.length === 0) return `Story ${storyNum}`;
    const epicDir = path.join(STORIES_DIR, epicDirs[0]);
    const storyFiles = fs.readdirSync(epicDir).filter(f => f.match(new RegExp(`^story-${storyNum}-`)));
    if (storyFiles.length > 0) {
      return storyFiles[0].replace('.md', '').replace(/^story-\d+-/, '').replace(/-/g, ' ');
    }
  } catch { /* ignore */ }
  return `Story ${storyNum}`;
}

/**
 * Determine the status of a sub-phase for the current story.
 * Phase order: REALIGN -> WRITE-TESTS -> IMPLEMENT -> QA -> COMPLETE
 */
function getSubPhaseStatus(subPhase, currentPhase, phaseStatus) {
  const order = [...STORY_SUB_PHASES, 'COMPLETE'];
  const currentIdx = order.indexOf(currentPhase);
  const targetIdx = order.indexOf(subPhase);

  if (targetIdx < 0 || currentIdx < 0) return 'pending';

  if (targetIdx < currentIdx) return 'completed';
  if (targetIdx === currentIdx) {
    return phaseStatus === 'in_progress' ? 'in_progress' : 'pending';
  }
  return 'pending';
}

/**
 * Check if the workflow included a DESIGN phase by looking at history.
 */
function hadDesignPhase(state) {
  if (!state.history) return false;
  return state.history.some(h => h.to === 'DESIGN' || h.from === 'DESIGN');
}

/**
 * Determine if SCOPE is completed based on the current workflow position.
 * SCOPE is complete once we've moved past it (to STORIES or any per-story phase).
 */
function isScopeComplete(state) {
  const pastScopePhases = ['STORIES', 'REALIGN', 'WRITE-TESTS', 'IMPLEMENT', 'QA', 'COMPLETE'];
  if (pastScopePhases.includes(state.currentPhase)) return true;
  // Also check if any epic has moved past SCOPE
  if (state.epics) {
    for (const epic of Object.values(state.epics)) {
      if (epic.phase && epic.phase !== 'SCOPE' && epic.phase !== 'DESIGN') return true;
    }
  }
  return false;
}

/**
 * Determine if DESIGN is completed.
 */
function isDesignComplete(state) {
  if (state.currentPhase !== 'DESIGN') {
    // If we had a design phase and are now past it, it's complete
    if (hadDesignPhase(state)) return true;
  }
  return false;
}

/**
 * Get the total number of epics (known or estimated).
 */
function getTotalEpics(state) {
  if (state.totalEpics) return state.totalEpics;
  if (state.epics) return Math.max(...Object.keys(state.epics).map(Number), 0);
  return 0;
}

/**
 * Get total stories for an epic.
 */
function getTotalStories(epicState) {
  if (!epicState) return 0;
  if (epicState.totalStories) return epicState.totalStories;
  if (epicState.stories) return Object.keys(epicState.stories).length;
  return 0;
}

/**
 * Check if an epic is fully complete.
 */
function isEpicComplete(epicState) {
  if (!epicState) return false;
  if (epicState.phase === 'COMPLETE') return true;
  // Check if all stories are complete
  const totalStories = getTotalStories(epicState);
  if (totalStories === 0) return false;
  const completedStories = Object.values(epicState.stories || {})
    .filter(s => s.phase === 'COMPLETE').length;
  return completedStories >= totalStories;
}

// =============================================================================
// MAIN LIST BUILDER
// =============================================================================

function buildTodoList(state) {
  const items = [];

  // --- DESIGN phase (only if workflow included it) ---
  if (hadDesignPhase(state)) {
    const designComplete = isDesignComplete(state);
    const isDesignActive = state.currentPhase === 'DESIGN';

    items.push({
      content: 'Create wireframes (DESIGN)',
      status: designComplete ? 'completed' : (isDesignActive ?
        (state.phaseStatus === 'in_progress' ? 'in_progress' : 'pending') : 'pending'),
      activeForm: 'Creating wireframes'
    });
  }

  // --- SCOPE phase ---
  const scopeComplete = isScopeComplete(state);
  const isScopeActive = state.currentPhase === 'SCOPE';
  const totalEpics = getTotalEpics(state);
  const scopeSuffix = scopeComplete && totalEpics > 0 ? ` (${totalEpics} epic${totalEpics !== 1 ? 's' : ''})` : '';

  items.push({
    content: `Define epics (SCOPE)${scopeSuffix}`,
    status: scopeComplete ? 'completed' : (isScopeActive ?
      (state.phaseStatus === 'in_progress' ? 'in_progress' : 'pending') : 'pending'),
    activeForm: 'Defining epics'
  });

  // If still in DESIGN or SCOPE, no epic items to show yet
  if (['DESIGN', 'SCOPE'].includes(state.currentPhase) && !scopeComplete) {
    return items;
  }

  // --- PER-EPIC ITEMS ---
  // First pass: separate completed, current, and future epics
  const futureEpics = [];

  for (let e = 1; e <= totalEpics; e++) {
    const epicState = state.epics?.[e];
    const isCurrentEpic = (e === state.currentEpic) && !state.featureComplete;
    const epicName = getEpicDisplayName(e);
    const epicComplete = isEpicComplete(epicState);

    if (epicComplete && !isCurrentEpic) {
      // COLLAPSED: completed epic
      const totalStories = getTotalStories(epicState);
      const storySuffix = totalStories > 0 ? ` - ${totalStories} stories` : '';
      items.push({
        content: `Epic ${e}: ${epicName} (complete${storySuffix})`,
        status: 'completed',
        activeForm: `Completing Epic ${e}`
      });
      continue;
    }

    if (!isCurrentEpic) {
      // Collect future epics to collapse into a single item
      futureEpics.push(e);
      continue;
    }

    // EXPANDED: current epic
    // --- STORIES phase item for this epic ---
    const storiesPhaseComplete = epicState && epicState.phase !== 'STORIES' &&
      getTotalStories(epicState) > 0;
    const isStoriesActive = state.currentPhase === 'STORIES' && isCurrentEpic;
    const totalStories = getTotalStories(epicState);
    const storiesSuffix = storiesPhaseComplete && totalStories > 0 ?
      ` (${totalStories} stor${totalStories !== 1 ? 'ies' : 'y'})` : '';

    items.push({
      content: `Epic ${e}: Define stories (STORIES)${storiesSuffix}`,
      status: storiesPhaseComplete ? 'completed' : (isStoriesActive ?
        (state.phaseStatus === 'in_progress' ? 'in_progress' : 'pending') : 'pending'),
      activeForm: `Defining stories for Epic ${e}`
    });

    // If still in STORIES phase for this epic, don't show story items yet
    if (isStoriesActive || (!storiesPhaseComplete && !isStoriesActive)) {
      continue;
    }

    // --- PER-STORY ITEMS for current epic ---
    const futureStories = [];

    for (let s = 1; s <= totalStories; s++) {
      const storyState = epicState?.stories?.[s];
      const isCurrentStory = isCurrentEpic && s === state.currentStory;
      const storyName = getStoryDisplayName(e, s);
      const storyComplete = storyState?.phase === 'COMPLETE';

      if (storyComplete) {
        // Completed story - single collapsed item
        items.push({
          content: `  Story ${s}: ${storyName} (complete)`,
          status: 'completed',
          activeForm: `Completing Story ${s}`
        });
        continue;
      }

      if (!isCurrentStory) {
        // Collect future stories to collapse into a single item
        futureStories.push(s);
        continue;
      }

      // EXPANDED: current story - show sub-phase items
      for (const sp of STORY_SUB_PHASES) {
        const labels = SUB_PHASE_LABELS[sp];
        const spStatus = getSubPhaseStatus(sp, state.currentPhase, state.phaseStatus);

        items.push({
          content: `  Story ${s}: ${labels.content}`,
          status: spStatus,
          activeForm: `${labels.activeForm} for Story ${s}`
        });
      }
    }

    // COLLAPSED: remaining stories in current epic
    if (futureStories.length === 1) {
      const s = futureStories[0];
      const storyName = getStoryDisplayName(e, s);
      items.push({
        content: `  Story ${s}: ${storyName}`,
        status: 'pending',
        activeForm: `Working on Story ${s}`
      });
    } else if (futureStories.length > 1) {
      const first = futureStories[0];
      const last = futureStories[futureStories.length - 1];
      items.push({
        content: `  Stories ${first}-${last}: Remaining stories`,
        status: 'pending',
        activeForm: `Working on remaining stories`
      });
    }
  }

  // COLLAPSED: remaining epics (future, not completed, not current)
  if (futureEpics.length === 1) {
    const e = futureEpics[0];
    const epicName = getEpicDisplayName(e);
    items.push({
      content: `Epic ${e}: ${epicName}`,
      status: 'pending',
      activeForm: `Working on Epic ${e}`
    });
  } else if (futureEpics.length > 1) {
    const first = futureEpics[0];
    const last = futureEpics[futureEpics.length - 1];
    items.push({
      content: `Epics ${first}-${last}: Remaining epics`,
      status: 'pending',
      activeForm: `Working on remaining epics`
    });
  }

  return items;
}

// =============================================================================
// MAIN
// =============================================================================

function main() {
  const state = readState();

  if (!state) {
    console.log(JSON.stringify([
      { content: 'Start workflow with /start', status: 'pending', activeForm: 'Starting workflow' }
    ]));
    return;
  }

  // Handle feature complete
  if (state.featureComplete || state.phaseStatus === 'complete') {
    const items = buildTodoList(state);
    // Ensure all items show as completed
    const completedItems = items.map(item => ({ ...item, status: 'completed' }));
    console.log(JSON.stringify(completedItems));
    return;
  }

  const items = buildTodoList(state);
  console.log(JSON.stringify(items));
}

main();
