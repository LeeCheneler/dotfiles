---
name: code-reviewing
description: "Review code changes for quality, security, performance, and
  conventions. Auto-loads when reviewing diffs or PRs. Invoke with
  /code-reviewing to run a full review."
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(git diff:*)
  - Bash(gh pr diff:*)
  - Bash(gh pr view:*)
---

# Code Reviewing

Accept one of: a PR number, a branch name, a diff range, or "current changes".
Default to uncommitted changes if nothing specified.

## Process

### 1. Build context (highest density first)

Before reviewing the diff, understand the codebase top-down:

1. **Project CLAUDE.md** — read if it exists. This contains the project's
   architecture, conventions, gotchas, and key decisions.
2. **ADRs and docs** — check `docs/decisions/`, `docs/adrs/`, `docs/` for
   architectural decisions and domain context relevant to the changed areas.
3. **README and CONTRIBUTING** — project intent, setup, contribution rules.
4. **The diff itself** — read the full diff. Understand what changed and why.
5. **Surrounding code** — for each changed file, read the full file (not just
   the diff hunk) to understand the change in context.
6. **Related files** — trace imports, callers, and dependents of changed code.
   Understand what else might be affected.
7. **Existing tests** — read tests for the changed areas. Understand what's
   covered and what's missing.
8. **Config and CI** — if the change touches build, deploy, or config files,
   read the relevant pipeline and infrastructure context.

### 2. Review the changes

With full context, review against these dimensions (skip anything covered
by automated linting/formatting):

- **Correctness:** Logic errors, edge cases, off-by-one, null handling,
  race conditions
- **Security:** Injection, auth bypass, secrets in code, unsafe
  deserialization, exposed internals
- **Performance:** N+1 queries, unnecessary allocations, missing indexes,
  redundant re-renders, expensive operations in hot paths
- **Simplicity:** Over-abstraction, premature generalization, unnecessary
  complexity, functions doing too much
- **Tests:** Behavior-focused? Mocking only at boundaries? Missing cases?
  Descriptive names? Independent tests?
- **Conventions:** Does it match the project's established patterns and
  any documented ADRs?

Do not review style preferences that aren't established project conventions.

## Output

For each finding:

- Severity: 🔴 Must fix | 🟡 Should fix | 🟢 Suggestion | 💭 Nitpick
- File and line reference
- What the issue is
- Suggested fix (with code if non-trivial)

End with a summary: overall assessment, finding counts, and what's done well.

## Arguments

$ARGUMENTS
