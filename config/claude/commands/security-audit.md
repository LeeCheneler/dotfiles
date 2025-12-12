---
description: Run security audit on all branch changes before PR
---

# Security Audit

## Purpose

Comprehensive security audit of all changes on the current branch before opening a PR.
This runs once after all commits are complete, auditing the cumulative changeset.

## Prerequisites

- All commits complete (or uncommitted changes to audit)
- On a feature branch (not main)

## Instructions

### 1. Determine Scope

Audit all changes compared to main:

```bash
git diff main...HEAD --name-only
```

If no commits but uncommitted changes exist, audit those:

```bash
git diff --name-only
git diff --staged --name-only
```

### 2. Run Security Audit

Use `security-auditor` agent on the full changeset:

- OWASP Top 10 review
- Dependency audit
- Secret detection
- IAM/infrastructure review (if applicable)

### 3. Handle Issues

**Critical issues:**

- Must be fixed before PR
- Show specific file and line
- Provide fix recommendation

**High issues:**

- Should be fixed before PR
- Present to user for decision

**Medium/Low issues:**

- Note for awareness
- Can proceed with PR

### 4. Report

```markdown
## Security Audit Results

**Verdict**: [PASS | FAIL]
**Changes audited**: <N> files

### Critical Issues

[List or "None"]

### High Issues

[List or "None"]

### Medium/Low Issues

[List or "None"]

### Recommendations

[General security improvements]

---

**Next steps:**

- Fix critical/high issues, then re-run `/security-audit`
- Or run `/pr` to open pull request
```

## Re-audit

If issues were fixed, run `/security-audit` again to verify fixes.

## Rules

- NEVER skip critical issues
- Audit the full changeset, not individual commits
- Only flag issues in changed code (not pre-existing)
- Provide actionable fix recommendations
