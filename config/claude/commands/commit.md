---
description: Commit current changes with approval
---

# Commit Phase

## Prerequisites

Requires:
- Active plan with current commit through Present phase
- User has approved in Present phase
- Changes staged or ready to stage

## Instructions

### 1. Pre-commit Checks

Verify before committing:
```bash
# Check for uncommitted changes
git status

# Verify tests pass
<project test command>

# Verify lint passes
<project lint command>
```

All must pass before proceeding.

### 2. Stage Changes

```bash
git add <relevant files>
```

Only stage files related to this commit's scope.

### 3. Generate Commit Message

Use `commit-message` agent:
- Analyzes staged changes
- Generates conventional commit message
- Explains the "why" not just "what"

### 4. Present for Approval

```markdown
## Commit Message

```
<generated commit message>
```

**Approve?** (y/go, or provide feedback)
```

**STOP and wait for user approval.**

### 5. Execute Commit

After approval:
```bash
git commit -m "<approved message>"
```

### 6. Update Plan

In plan.md for this commit:
- Check `- [x] Commit`
- Fill in `**SHA:** <actual-sha>`

## After Commit

```
Committed: <sha>
Message: <first line of commit message>

Commit <N> of <total> complete.

<if more commits>
Run /next to continue with Commit <N+1>.

<if last commit>
All commits complete! Run /pr to open pull request.
```

## Rules

- NEVER commit without user approval of the message
- NEVER commit if tests or lint fail
- Use commit-message agent for consistent messages
- Update plan.md with SHA after successful commit
- The pre-commit hook will also enforce approval workflow

## Note

The pre-commit hook will block and remind about this workflow.
Follow its instructions if triggered.
