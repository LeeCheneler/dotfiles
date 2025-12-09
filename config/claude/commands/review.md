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

### 2. Security Audit
Use `security-auditor` agent:
- Checks for vulnerabilities
- Reviews authentication/authorization
- Checks for secrets/credentials

### 3. Handle Issues

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

### 4. Re-review Loop
After fixing Critical/High issues:
- Re-run the reviewer that found the issue
- Repeat until no Critical/High issues remain

### 5. Update Plan
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

- ALWAYS run both code-reviewer and security-auditor
- NEVER proceed with Critical or High issues unresolved
- Fix and re-review until clean
- Document remaining Medium/Low for user visibility
- Update plan.md checkbox when complete
