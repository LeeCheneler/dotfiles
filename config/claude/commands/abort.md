---
description: Abort current plan safely
---

# Abort Plan

Abandon the current plan. Use when work needs to be cancelled or restarted.

## Warning

This is a destructive operation. Always confirm with user.

## Instructions

### 1. Find Active Plan

Identify the current active plan (IN_PROGRESS or READY status).

If no active plan:
```
No active plan to abort.
```

### 2. Show Current State

```markdown
## About to abort: <plan-name>

**Task:** <task description>
**Branch:** feat/<slug>
**Progress:** Commit <N> of <total>

### Work that will be affected:
- Commits completed: <N>
- Current commit: <phase> phase
- Uncommitted changes: <yes/no>
```

### 3. Ask for Reason

```
Why are you aborting? (optional, for documentation)
>
```

Record the reason if provided.

### 4. Confirm Abort

```
To abort this plan, type 'abort' exactly:
>
```

**STOP and wait for user to type 'abort'.**

If user types anything else:
```
Abort cancelled. Plan remains active.
```

### 5. Cleanup Options

After user confirms abort:

```
Cleanup options:

1. Keep everything (branch + changes) - can resume later
2. Discard uncommitted changes only
3. Delete branch and all uncommitted changes

Enter number (default: 1):
```

**Option 1 - Keep everything:**
- Update plan.md Status to `ABORTED`
- Add abort reason and timestamp to Notes section
- Leave branch and changes intact

**Option 2 - Discard uncommitted:**
```bash
git checkout -- .
git clean -fd
```
- Update plan.md Status to `ABORTED`

**Option 3 - Delete branch:**
```bash
git checkout main
git branch -D feat/<slug>
```
- Update plan.md Status to `ABORTED`
- Note: Committed work is preserved in git reflog for 30 days

### 6. Update Plan

Add to plan.md:
```markdown
## Aborted

- **Date:** <timestamp>
- **Reason:** <user provided reason or "No reason provided">
- **Cleanup:** <option chosen>
- **Commits preserved:** <list of completed commit SHAs>
```

Update Status to `ABORTED`.

### 7. Confirm

```
Plan '<plan-name>' has been aborted.

<if option 1>
Branch and changes preserved. Run /resume to continue later.

<if option 2>
Uncommitted changes discarded. Branch preserved.

<if option 3>
Branch deleted. Committed work in reflog for 30 days.

Run /begin to start fresh work.
```

## Rules

- NEVER abort without user typing 'abort' exactly
- ALWAYS offer cleanup options - don't assume
- ALWAYS preserve committed work (it's in git history)
- ALWAYS document the abort in plan.md
- Default to safest option (keep everything)
