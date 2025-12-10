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

1. Checks Memory MCP for relevant context (if configured)
2. Reads docs, READMEs, ADRs, plans, vision files
3. Checks GitHub for issue/PR context (if referenced)
4. Finds relevant code for the task
5. Identifies patterns to follow
6. Documents constraints and considerations
7. Suggests an approach

## Memory Integration

Before spawning the researcher agent, briefly check Memory MCP for task-relevant context:

```
Use `search_nodes` with keywords from the task description.
Pass any relevant memories to the researcher agent in the prompt.
```

This primes the researcher with prior knowledge without requiring a full memory scan.

## After Research

```
Research complete: docs/plans/<slug>/research.md

Run /plan to create implementation plan, or /begin to run full workflow.
```

## Rules

- Use the researcher agent - don't do manual research
- Output must go to a plan directory
- Ask clarifying questions if scope is genuinely unclear
