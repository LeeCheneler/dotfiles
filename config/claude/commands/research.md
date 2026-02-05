---
description: Run research phase only
argument-hint: <task-description>
---

# Research Phase

Task: $ARGUMENTS

## Instructions

Run the `researcher` agent to explore the codebase for this task.

### If plan directory exists

Output to the existing plan directory's research.md.

### If no plan directory

Ask user for task slug or generate one, then create:

```bash
mkdir -p docs/plans/<slug>
```

Output to `docs/plans/<slug>/research.md`.

## What the Researcher Does

1. Reads docs, READMEs, ADRs, plans, vision files
2. Checks GitHub for issue/PR context (if referenced)
3. Finds relevant code for the task
4. Identifies patterns to follow
5. Documents constraints and considerations
6. Suggests an approach

## After Research

```
Research complete: docs/plans/<slug>/research.md

Run /plan to create implementation plan, or /begin to run full workflow.
```

## Rules

- Use the researcher agent - don't do manual research
- Output must go to a plan directory
- Ask clarifying questions if scope is genuinely unclear
