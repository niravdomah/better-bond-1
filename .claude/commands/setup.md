---
description: Initialize project - creates CLAUDE.md, installs dependencies, verifies setup
model: haiku
---

You are helping a developer set up this AI-driven development template.

## Step 1: Check for CLAUDE.md

First, check if CLAUDE.md exists in the project root:

1. **If CLAUDE.md exists:**
   - Skip to Step 2
   - Mention: "CLAUDE.md already exists, skipping initialization."

2. **If CLAUDE.md does NOT exist:**
   - Create a CLAUDE.md file with project documentation
   - Include sections for: Project Overview, Tech Stack, Key Commands, Architecture
   - Base it on the project structure you observe (package.json, folder structure, etc.)
   - Mention: "Created CLAUDE.md with project documentation."

## Step 2: Install Dependencies

Check if node_modules exists:

1. **If node_modules exists and has packages:**
   - Skip npm install
   - Mention: "Dependencies already installed."

2. **If node_modules is missing:**
   - Run `npm install` in the `/web` directory
   - Wait for completion

## Step 3: Verify Setup

Run these checks in parallel:

```bash
# In /web directory
npx tsc --noEmit      # TypeScript compiles
npm run lint          # ESLint works (warnings are OK)
npm run build         # Build succeeds
```

## Step 4: Display Status

Show a summary:

```
Project Setup Complete!

[x] CLAUDE.md exists
[x] Dependencies installed
[x] TypeScript configured
[x] ESLint configured
[x] Build successful

Next Steps:
  npm run dev    → Start development server
  /start         → Start building a feature
  /quality-check → Run quality gates before PR
```

## Step 5: Suggest Next Action

Ask the user what they'd like to do:
- Start the development server
- Learn about the project structure
- Begin working on a feature

## Error Handling

- **npm install fails:** Check Node version, network, suggest fixes
- **TypeScript errors:** Note them but don't block - user may need to fix code
- **Build fails:** Show the error, offer to help diagnose
- **Missing /web directory:** This template requires the /web folder - check if they're in the right directory

## Notes

- Be concise and friendly
- Don't overwhelm with information
- Focus on getting them productive quickly
