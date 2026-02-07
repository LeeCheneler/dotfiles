---
description: Open pull request for current plan
---

# Open Pull Request

## Verify Ready

1. If active plan: check all commits have `- [x] Commit`
2. Check no uncommitted changes
3. Verify branch has commits ahead of main

If incomplete, show remaining work and suggest `/next`.

## Recommend Security Audit

If `/security-audit` hasn't been run on this branch, suggest it:

```
Security audit not detected for this branch.
Run /security-audit first? (recommended, or skip)
```

## Push Branch

```bash
git push -u origin <branch-name>
```

## Generate PR Description

Use `pr-description` agent with:

- Task description from plan metadata
- All commit titles and goals
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

## Clean Up

Remove ephemeral plan files:

```bash
rm -rf docs/plans/<slug>/
```

Report PR URL.

## Rules

- Never create PR with incomplete commits
- Never create PR without user approval
- Always push branch before creating PR
