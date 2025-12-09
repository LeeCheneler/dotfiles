---
description: Open pull request for current plan
---

# Open Pull Request

## Step 1: Verify Plan Complete

Find the current active plan and verify all commits are complete:

1. Read `docs/plans/*/plan.md` for active plan
2. Check all commits have `- [x] Commit` checked
3. Verify all SHAs are filled in

If incomplete:
```
Plan is not complete.

Remaining commits:
- Commit <N>: <title> (needs: Dev, Review, Present, Commit)
- Commit <M>: <title> (needs: Present, Commit)

Run /next to continue.
```

## Step 2: Verify Branch State

```bash
git status
git log main..HEAD --oneline
```

Ensure:
- No uncommitted changes
- Branch has commits ahead of main
- All planned commits are present

If uncommitted changes:
```
Warning: Uncommitted changes detected.
Commit or stash before opening PR? (y/n)
```

## Step 3: Push Branch

If not already pushed:
```bash
git push -u origin <branch-name>
```

## Step 4: Generate PR Description

Use `pr-description` agent with context:
- Task description from plan metadata
- All commit titles and goals
- Summary of what was built

## Step 5: Present for Approval

```markdown
## Pull Request Preview

**Title:** <generated title>

**Description:**
<generated description>

---

**Approve?** (y/go, or provide feedback)
```

**STOP and wait for user approval.**

If user provides feedback:
- Adjust title/description
- Present again

## Step 6: Create PR

After approval:
```bash
gh pr create --title "<title>" --body "<description>"
```

## Step 7: Update Plan

Update plan.md:
- Set Status to `COMPLETE`
- Add PR link if desired

## Step 8: Report

```
PR created: <url>

Plan '<plan-name>' is now complete.
```

## Rules

- NEVER create PR with incomplete commits
- NEVER create PR without user approval of title/description
- Always push branch before creating PR
- Use pr-description agent for consistent formatting
