---
description: Abort current plan safely
---

# Abort Plan

Abandon the current plan. Always confirm with user first.

## Instructions

### 1. Find Active Plan

If no active plan: "No active plan to abort."

### 2. Show Current State

```markdown
## About to abort: <plan-name>

**Task:** <task description>
**Branch:** feat/<slug>
**Progress:** Commit <N> of <total>
**Uncommitted changes:** yes/no
```

### 3. Confirm

```
To abort, type 'abort':
```

**Wait for user to type 'abort'.** Anything else cancels.

### 4. Cleanup Options

```
1. Keep everything (branch + changes) - can resume later
2. Discard uncommitted changes only
3. Delete branch and all uncommitted changes
```

Default to option 1 (safest).

### 5. Update Plan

Set plan.md Status to `ABORTED` with date and reason.

## Rules

- Never abort without user typing 'abort'
- Always offer cleanup options
- Default to safest option (keep everything)
