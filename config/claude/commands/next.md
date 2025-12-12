---
description: Execute next commit cycle in current plan
---

# Execute Next Commit

## Step 1: Find Current Plan

Look for an active plan:

1. Check `docs/plans/*/plan.md` files
2. Find one with Status: `IN_PROGRESS` or `READY`
3. If multiple, show list and ask user to select
4. If none, error: "No active plan found. Run /begin to start new work or /resume to resume existing."

## Step 2: Find Next Commit

Parse the plan.md to find the next incomplete commit:

- Look for first commit where `- [ ] Dev` is unchecked
- Update plan.md Status to `IN_PROGRESS` if it was `READY`

Display:

```
Executing: Commit <N> of <total>
Title: <commit title>
Goal: <commit goal>
```

## Step 3: Dev Phase

Implement the commit:

1. For complex implementations, use TodoWrite to track sub-tasks
2. Write the implementation code
3. Use `test-writer` agent for tests (if applicable)
4. Use `doc-writer` agent for docs (if needed)
5. Run tests: ensure they pass
6. Run lint/type-check: ensure clean

Update plan.md: check `- [x] Dev`

**Auto-proceed to Review phase.**

## Step 4: Review Phase

Run review cycle:

1. Use `code-reviewer` agent on changes

**For Critical/High issues:**

- Fix immediately
- Re-run code-reviewer
- Repeat until clean

**For Medium issues:**

- Fix if straightforward
- Or note for user in Present phase

**For Low issues:**

- Note for user, don't block

Update plan.md: check `- [x] Review`

**Auto-proceed to Present phase.**

## Step 5: Present Phase

Present to user:

```markdown
## Commit <N>: <title>

### Summary

<what was implemented>

### Files Changed

| File | Change           | Lines |
| ---- | ---------------- | ----- |
| ...  | created/modified | +X/-Y |

### Tests

- Added: <N> tests
- Passing: Yes/No

### Review Results

- Critical: 0 (must be 0)
- High: <N>
- Medium: <N>
- Low: <N>

### Outstanding Items

<any issues noted for user attention>

---

**Approve?** (y/go, or provide feedback)
```

**STOP and wait for user approval.**

If user provides feedback:

- Implement changes
- Re-run review if significant changes
- Present again

Update plan.md: check `- [x] Present`

## Step 6: Commit Phase

After user approval:

1. Use `commit-message` agent to generate message
2. Present commit message to user
3. Wait for approval
4. Execute commit
5. Update plan.md:
   - Check `- [x] Commit`
   - Fill in `**SHA:** <actual-sha>`

## Step 7: Next Steps

After commit:

```
Commit <N> complete: <sha>

<remaining> commits remaining in plan.
Run /next to continue.
```

If this was the last commit:

```
All commits complete!

Next steps:
- /security-audit - Run security audit on all changes (recommended)
- /pr - Open pull request (skips security audit)
```

## Rules

- NEVER skip review phase
- NEVER commit without user approval at Present phase
- Fix Critical/High issues before presenting
- Update plan.md checkboxes as you complete each phase

## Tracking

- **plan.md checkboxes**: Track cross-session progress (persistent)
- **TodoWrite**: Track in-session sub-tasks during complex Dev phases (ephemeral)
