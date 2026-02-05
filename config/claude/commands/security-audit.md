---
description: Run security audit on all branch changes before PR
---

# Security Audit

Comprehensive security audit of all changes on the current branch before opening a PR.

## Instructions

### 1. Determine Scope

Audit all changes compared to main:

```bash
git diff main...HEAD --name-only
```

If no commits but uncommitted changes exist, audit those.

### 2. Run Audit

Use `security-auditor` agent on the full changeset.

### 3. Handle Results

**Critical**: Must be fixed before PR.
**High**: Should be fixed before PR. Present to user for decision.
**Medium/Low**: Note for awareness. Can proceed.

### 4. Report

```markdown
## Security Audit Results

**Verdict**: [PASS | FAIL]
**Changes audited**: <N> files

### Critical Issues

[List or "None"]

### High Issues

[List or "None"]

### Recommendations

[General improvements]

---

**Next:** Fix issues and re-run, or `/pr` to open pull request.
```

## Rules

- Never skip critical issues
- Audit the full changeset, not individual commits
- Only flag issues in changed code
