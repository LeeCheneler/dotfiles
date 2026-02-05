---
description: Show current plan status and progress
---

# Plan Status

Read-only view of active plan progress.

## Instructions

### 1. Find Active Plans

Search `docs/plans/*/plan.md` for plans with Status: `IN_PROGRESS` or `READY`.

If none found:

```
No active plans. Run /begin to start new work.
```

### 2. Display Status

```markdown
## Plan: <plan-name>

**Task:** <task description>
**Branch:** feat/<slug>
**Status:** <IN_PROGRESS|READY>

### Progress: Commit <current> of <total>

### Current Commit

**<N>. <commit title>**

- [x] Dev
- [x] Review
- [ ] Present <- current phase
- [ ] Commit

### All Commits

| # | Title   | Status        |
| - | ------- | ------------- |
| 1 | <title> | Done (abc123) |
| 2 | <title> | In Progress   |
| 3 | <title> | Pending       |

### Next Action

Run `/next` to continue.
```

## Rules

- Read-only - never modifies anything
- Always show clear next action
