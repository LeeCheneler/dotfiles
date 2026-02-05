---
description: Start new work - research, plan, and signoff
argument-hint: <task-description>
---

# Begin New Work

Task: $ARGUMENTS

## Safety Checks

Before starting, verify git state:

```bash
git status
```

- If uncommitted changes: warn and wait for user to resolve
- If not on main: warn and ask if they want to switch

## If Resuming Existing Work

Check `docs/plans/*/plan.md` for active plans (Status: `IN_PROGRESS` or `READY`).

If found, show the list and ask if user wants to resume one or start fresh.

To resume: read research.md and plan.md, switch to the plan's branch, show current progress, and prompt to run `/next`.

## New Work

### 1. Generate Task Slug

Create a kebab-case slug from the task description (3-5 words, lowercase alphanumeric and hyphens only).

```
Creating plan directory: docs/plans/<slug>/
```

If directory already exists, ask user to pick a different slug or resume.

### 2. Research

Use the `researcher` agent:

- Provide task description
- Output to `docs/plans/<slug>/research.md`

### 3. Plan

Use the `planner` agent:

- Provide task description and path to research.md
- Output to `docs/plans/<slug>/plan.md`

After planning, check if any decisions warrant ADRs (framework choices, architectural patterns, infrastructure decisions). If so, suggest them. Skip silently if not warranted.

### 4. Signoff

Present summary to user:

```markdown
## Research Summary

<key findings>

## Plan Summary

<N> commits planned:

1. <commit title>
2. <commit title>

**Approve?** (y/go, or provide feedback)
```

**STOP and wait for explicit approval.**

### 5. Create Branch

After approval:

```bash
git checkout -b feat/<slug>
```

```
Plan is ready. Run /next to start the first commit.
```

## Rules

- Never skip research or planning
- Never proceed past signoff without explicit approval
