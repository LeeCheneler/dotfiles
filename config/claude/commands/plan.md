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
2. Checks Memory MCP for past decisions/constraints (if configured)
3. Checks GitHub issue details (if referenced)
4. Breaks work into atomic commits
5. Defines goals and files for each commit
6. Creates trackable checklists

## Memory Integration

Before spawning the planner agent, briefly check Memory MCP for planning-relevant context:

```
Use `search_nodes` with: architecture, decision, constraint, preference
Pass any relevant memories to the planner agent in the prompt.
```

This ensures past decisions inform the plan without requiring the planner to search.

## After Planning

```
Plan created: docs/plans/<slug>/plan.md

<N> commits planned:
1. <commit 1 title>
2. <commit 2 title>
...

Run /signoff to review and approve, or /begin for full workflow.
```

## ADR Suggestions

After the plan is created, analyze the research and plan for decisions that warrant ADRs:

**When to suggest ADRs:**

- Choosing a framework, library, or tool
- Architectural patterns (e.g., monolith vs microservices, state management approach)
- Infrastructure decisions (e.g., database choice, hosting platform)
- Breaking from established conventions (and why)
- Decisions that would be hard to reverse later
- Trade-offs that future developers should understand

**When NOT to suggest ADRs:**

- Implementation details that are obvious from the code
- Decisions that follow existing project patterns
- Minor library choices with no architectural impact

If ADRs are warranted, present them:

```
## Suggested ADRs

Based on the research and plan, these decisions may warrant ADRs:

1. **ADR: <decision title>**
   Context: <why this decision matters>

2. **ADR: <decision title>**
   Context: <why this decision matters>

Add these to the plan? (y/n, or specify which ones)
```

If user approves, add ADR commits to the plan (typically as the first commit(s) to document decisions before implementation).

If no ADRs are warranted, skip this step silently.

## Rules

- Use the planner agent - don't create plan manually
- Research must exist first
- Each commit should be atomic and reviewable
- Ask clarifying questions if approach is genuinely ambiguous
- Only suggest ADRs when genuinely warranted - most tasks won't need them
