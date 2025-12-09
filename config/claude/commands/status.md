---
description: Show current plan status and progress
---

# Plan Status

Show the current state of the active plan without executing anything.

## Instructions

### 1. Find Active Plan

Search for plans with Status: `IN_PROGRESS` or `READY`:
```bash
find docs/plans -name "plan.md" 2>/dev/null
```

If no plans found:
```
No plans found.
Run /begin to start new work.
```

If no active plans (all COMPLETE or ABORTED):
```
No active plans.

Completed plans:
- <plan-name> (COMPLETE)

Run /begin to start new work, or /resume to view completed plans.
```

### 2. Parse Current Plan

Read plan.md and extract:
- Plan name (directory name)
- Task description
- Branch name
- Status
- Total commits
- Current commit (first with incomplete checklist)
- Progress per commit

### 3. Display Status

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
- [ ] Present  ← current phase
- [ ] Commit

### All Commits
| # | Title | Status |
|---|-------|--------|
| 1 | <title> | Done (abc123) |
| 2 | <title> | In Progress |
| 3 | <title> | Pending |
| 4 | <title> | Pending |

### Next Action
Run `/next` to continue with <current phase> phase.
```

## Multiple Plans

If multiple active plans found, list them:
```
Multiple active plans found:

1. <plan-name> (IN_PROGRESS - Commit 2/4)
2. <plan-name> (READY - not started)

Run /resume to select a plan, or /next to continue most recent.
```

## Rules

- This command is read-only - it never modifies anything
- Always show clear next action
- If plan state is unclear, suggest /resume to reset context
