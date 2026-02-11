---
description: Open pull request for current branch
---

# Open Pull Request

## Verify Ready

1. Check no uncommitted changes
2. Verify branch has commits ahead of main
3. If not ready, show what needs to be done

## Push Branch

```bash
git push -u origin <branch-name>
```

## Generate PR Description

Use `pr-description` agent with:

- Branch diff vs main
- All commit titles and messages
- Summary of what was built

## Present for Approval

```markdown
## Pull Request Preview

**Title:** <generated title>

**Description:**
<generated description>

---

**Approve?** (y/go, or provide feedback)
```

**Wait for approval.**

## Create PR

```bash
gh pr create --title "<title>" --body "<description>"
```

Report PR URL.

## Rules

- Never create PR without user approval
- Always push branch before creating PR
