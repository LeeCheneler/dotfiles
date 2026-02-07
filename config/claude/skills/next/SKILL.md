---
description: Execute next commit cycle in current plan
---

# Execute Next Commit

## Find Current Plan

1. Check `docs/plans/*/plan.md` for Status: `IN_PROGRESS` or `READY`
2. If multiple, ask user to select
3. If none: "No active plan. Run /begin to start new work."

## Find Next Commit

Find first commit where `- [ ] Dev` is unchecked. Display:

```
Executing: Commit <N> of <total>
Title: <commit title>
Goal: <commit goal>
```

## Dev Phase

1. Implement the code following patterns from research.md
2. Use `test-writer` agent for tests if applicable
3. Use `test-runner` agent to verify tests pass
4. Run project lint/type-check
5. Check `- [x] Dev` in plan.md

## Review Phase

1. Use `code-reviewer` agent on changes
2. Fix Critical/High issues immediately, re-run reviewer until clean
3. Fix Medium if straightforward, note Low for user
4. Check `- [x] Review` in plan.md

## Present Phase

Present to user:

```markdown
## Commit <N>: <title>

### Summary

<what was implemented>

### Files Changed

| File | Change | Lines |
| ---- | ------ | ----- |

### Tests

- Added: <N> | Passing: Yes/No

### Review Results

- Critical: 0 | High: 0 | Medium: <N> | Low: <N>

### Outstanding Items

<any Medium/Low notes, or "None - clean review">

---

**Approve?** (y/go, or provide feedback)
```

**STOP and wait for user approval.** If feedback, implement changes, re-review if significant, present again.

Check `- [x] Present` in plan.md.

## Commit Phase

1. Use `commit-message` agent to generate message
2. Present commit message, wait for approval
3. Execute commit
4. Check `- [x] Commit` and fill in SHA in plan.md

## After Commit

If more commits remain:

```
Commit <N> complete. <remaining> remaining.
Next: <commit N+1 title>
Run /next to continue.
```

If last commit:

```
All commits complete!
Next: /security-audit then /pr
```

## Rules

- Never skip review phase
- Never commit without user approval
- Fix Critical/High issues before presenting
- Update plan.md checkboxes as you complete each phase
