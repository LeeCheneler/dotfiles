---
description: Generate commit from staged changes
---

# Commit Changes

## Check State

1. Run `git diff --staged --stat` to check staged changes
2. If nothing staged, run `git status` and ask the user what to stage
3. Once changes are staged, proceed

## Generate Message

Use `commit-message` agent with the staged diff to generate the commit message.

## Present for Approval

```markdown
## Commit Preview

**Message:**
```

<generated message>
```

**Staged files:**
<file list>

---

**Approve?** (y/go, or provide feedback)

````
**Wait for approval.**

## Commit

```bash
git commit -m "<approved message>"
````

Report success.

## Rules

- Never commit without user approval of the message
- Never stage files without user awareness
- Always use the commit-message agent for generation
