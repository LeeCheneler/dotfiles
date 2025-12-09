---
description: Run planning phase only (requires research.md)
---

# Planning Phase

## Prerequisites

Requires existing research.md. If not found:
```
No research.md found.
Run /research first, or /begin for full workflow.
```

## Instructions

Find the current plan directory (one with research.md but no plan.md, or most recent).

Run the `planner` agent to create the implementation plan:
- Input: research.md + task description
- Output: `docs/plans/<slug>/plan.md`

## What the Planner Does

1. Reads research.md to understand context
2. Breaks work into atomic commits
3. Defines goals and files for each commit
4. Creates trackable checklists

## After Planning

```
Plan created: docs/plans/<slug>/plan.md

<N> commits planned:
1. <commit 1 title>
2. <commit 2 title>
...

Run /signoff to review and approve, or /begin for full workflow.
```

## Rules

- Use the planner agent - don't create plan manually
- Research must exist first
- Each commit should be atomic and reviewable
- Ask clarifying questions if approach is genuinely ambiguous
