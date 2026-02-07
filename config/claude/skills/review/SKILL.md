---
description: Run code review on current changes
---

# Review Changes

Run a code review on current uncommitted or branch changes.

## Instructions

Use `code-reviewer` agent to review changes:

- If on a feature branch: review changes vs main (`git diff main...HEAD`)
- If uncommitted changes: review those

### Handle Results

**Critical/High**: Fix immediately, re-run reviewer until clean.
**Medium**: Fix if straightforward, or note for user.
**Low**: Note for user, don't block.

### Report

```
Review complete.
- Critical: 0 | High: 0 | Medium: <N> | Low: <N>
```

If in an active plan, update plan.md checkbox.

## Rules

- Always run code-reviewer agent
- Never proceed with Critical or High issues unresolved
