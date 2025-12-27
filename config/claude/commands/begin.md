---
description: Start new work - research, plan, and signoff
argument-hint: <task-description>
---

# Begin New Work

Task: $ARGUMENTS

## Step 0: Safety Checks

Before starting new work, verify git state:

```bash
git status
```

**If uncommitted changes:**

```
Warning: Uncommitted changes detected.
Commit, stash, or discard before starting new work? (y/n)
```

Wait for user to resolve before proceeding.

**If not on main:**

```
Warning: Currently on branch '<branch-name>', not main.
Switch to main before starting new work? (y/n)
```

## Step 1: Generate Task Slug

Generate a kebab-case slug from the task description.

- Remove common words (the, a, an, to, for, etc.)
- Lowercase and hyphenate
- Keep it short but descriptive (aim for 3-5 words)
- **Validate:** only lowercase alphanumeric and hyphens, max 50 chars
- **Reject:** any path separators (/, \, ..)

Inform user of the chosen slug (no approval needed):

```
Creating plan directory: docs/plans/<slug>/
```

## Step 2: Create Directory

Check if directory already exists:

```bash
ls docs/plans/<slug> 2>/dev/null
```

**If directory exists:**

```
Plan directory 'docs/plans/<slug>/' already exists.
Options:
1. Use a different slug
2. Resume existing plan (/resume)
```

Do not overwrite existing plans.

**If directory doesn't exist:**

```bash
mkdir -p docs/plans/<slug>
```

## Step 3: Research Phase

Use the `researcher` agent to explore the codebase.

Provide the agent with:

- The task description
- Output path: `docs/plans/<slug>/research.md`

The researcher will:

- Read docs, ADRs, plans, vision files
- Find relevant code
- Identify patterns to follow
- Document findings in research.md

## Step 4: Planning Phase

Use the `planner` agent to create the implementation plan.

Provide the agent with:

- The task description
- Path to research.md
- Output path: `docs/plans/<slug>/plan.md`

The planner will:

- Break work into atomic commits
- Define goals and files for each commit
- Create trackable checklists

## Step 5: ADR Suggestions

After planning, analyze the research and plan for decisions that warrant ADRs.

**Suggest ADRs when:**

- Choosing a framework, library, or significant tool
- Making architectural decisions (patterns, state management, etc.)
- Infrastructure choices (database, hosting, etc.)
- Breaking from established project conventions
- Making decisions that would be hard to reverse

**Skip silently when:**

- No significant architectural decisions
- Following existing patterns
- Routine implementation work

If ADRs are warranted:

```
## Suggested ADRs

Based on the research and plan, these decisions may warrant ADRs:

1. **ADR: <decision title>**
   Context: <why this decision matters>

Add these to the plan? (y/n, or specify which ones)
```

If approved, add ADR commits to the beginning of the plan.

## Step 6: Signoff

Present a summary to the user:

```markdown
## Research Complete

<key findings from research.md>

## Plan Summary

<number> commits planned:

1. <commit 1 title>
2. <commit 2 title>
3. ...

**Approve?** (y/go, or provide feedback)
```

**STOP and wait for explicit user approval.**

Do NOT proceed without signoff.

## Step 7: Create Branch

After signoff:

```bash
git checkout -b feat/<slug>
```

Inform user:

```
Created branch: feat/<slug>
Plan is ready. Run /next to start the first commit.
```

## Rules

- NEVER skip research or planning phases
- NEVER proceed past signoff without explicit approval
- If research or planning raises questions, ask them before signoff

## Tracking

- **plan.md checkboxes**: Track cross-session progress (persistent)
- **TodoWrite**: Track in-session sub-tasks (ephemeral, for complex phases)
