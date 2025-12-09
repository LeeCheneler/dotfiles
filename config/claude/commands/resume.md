---
description: Resume an existing plan
---

# Resume Existing Plan

## Step 1: Scan for Plans

Search for plan files:
```bash
find docs/plans -name "plan.md" 2>/dev/null
```

For each plan.md found, extract:
- Plan name (directory name)
- Status (READY, IN_PROGRESS, COMPLETE)
- Current commit position
- Total commits

## Step 2: Display Options

If no plans found:
```
No plans found in docs/plans/
Run /begin to start new work.
```

If plans found, display numbered list:
```
Found <N> plan(s):

1. <plan-name> (IN_PROGRESS - Commit 2/4)
   Task: <task description from metadata>

2. <plan-name> (READY - not started)
   Task: <task description from metadata>

3. <plan-name> (COMPLETE)
   Task: <task description from metadata>

Enter number to resume (or 'q' to cancel):
```

## Step 3: Wait for Selection

**STOP and wait for user to enter a number.**

If user enters 'q' or cancels:
```
Cancelled.
```

## Step 4: Load Plan Context

For selected plan:

1. Read `docs/plans/<name>/research.md` - understand the research
2. Read `docs/plans/<name>/plan.md` - understand the plan and progress

Determine current position:
- Find first commit with unchecked `- [ ] Dev`
- Or if all Dev checked, find first with unchecked `- [ ] Review`
- Etc.

## Step 5: Switch Branch (if needed)

Check if the plan's branch exists:
```bash
git branch --list "feat/<plan-name>"
```

If exists and not current:
```bash
git checkout feat/<plan-name>
```

If doesn't exist:
```
Branch feat/<plan-name> not found.
Create it? (y/n)
```

## Step 6: Show Status

```markdown
## Resumed: <plan-name>

**Task:** <task description>
**Branch:** feat/<plan-name>
**Progress:** Commit <current> of <total>

### Current Commit
**Title:** <commit title>
**Goal:** <commit goal>

### Status
- [x] Dev (if complete)
- [ ] Review (if pending)
- [ ] Present
- [ ] Commit

### Key Context
<brief summary from research.md - relevant patterns, constraints>

---

Run /next to continue execution.
```

## Rules

- Always read both research.md and plan.md to restore context
- Ensure correct branch is checked out before continuing
- Show clear status so user knows where they left off
- COMPLETE plans should be noted but user can still select to view
