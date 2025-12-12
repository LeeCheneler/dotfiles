---
description: Run review phase for current changes
---

# Review Phase

## Prerequisites

Requires changes to review:

- Active plan with current commit Dev complete
- Or uncommitted/unstaged changes to review

## Instructions

Run review cycle on current changes:

### 1. Code Review

Use `code-reviewer` agent:

- Reviews implementation, design, tests
- Classifies issues by severity
- Suggests fixes

**Critical (must fix):**

- Security vulnerabilities
- Data loss risks
- Breaking changes without migration

→ Fix immediately, re-run reviewer

**High (should fix):**

- Bugs causing incorrect behavior
- Missing error handling
- Architectural violations

→ Fix immediately, re-run reviewer

**Medium (address):**

- Code smells
- Missing edge case tests
- Minor performance concerns

→ Fix if straightforward, or note for Present

**Low (optional):**

- Style preferences
- Minor improvements

→ Note for user, don't block

### 2. Re-review Loop

After fixing Critical/High issues:

- Re-run code-reviewer
- Repeat until no Critical/High issues remain

### 3. Update Plan

Check `- [x] Review` in plan.md for this commit.

## After Review

```
Review complete for Commit <N>: <title>

Results:
- Critical: 0
- High: 0
- Medium: <N> (noted for Present)
- Low: <N> (noted for Present)

Run /present to continue.
```

## Rules

- ALWAYS run code-reviewer
- NEVER proceed with Critical or High issues unresolved
- Fix and re-review until clean
- Document remaining Medium/Low for user visibility
- Update plan.md checkbox when complete

## Note

Security audit (`security-auditor` agent) runs separately before PR via `/security-audit`.
This keeps per-commit reviews fast while ensuring comprehensive security review of all changes.
