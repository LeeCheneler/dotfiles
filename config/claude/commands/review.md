---
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(git diff:*)
  - Bash(gh pr diff:*)
  - Bash(gh pr view:*)
---

Review code changes for quality, patterns, and potential issues.

## Input

Accept one of: a PR number, a branch name, a diff range, or "current changes".
Default to uncommitted changes if nothing is specified.

## Process

1. Get the diff:
   - PR number: `gh pr diff <number>`
   - Branch: `git diff main...<branch>`
   - Current: `git diff`

2. Review against these dimensions (skip anything covered by automated
   linting/formatting — don't review what tooling should catch):

   - **Correctness:** Logic errors, edge cases, off-by-one errors,
     null/undefined handling, race conditions
   - **Security:** Injection risks, auth bypass, secrets in code,
     unsafe deserialization, exposed internals
   - **Performance:** N+1 queries, unnecessary allocations, missing indexes,
     redundant re-renders, expensive operations in hot paths
   - **Simplicity:** Over-abstraction, premature generalization, unnecessary
     complexity, functions doing too much
   - **Tests:** Are changes covered by tests? Are tests testing behavior
     (not implementation)? Are mocks used only at boundaries? Any missing
     edge cases? Do test names describe expected behavior?
   - **Conventions:** Does it match the project's established patterns?

3. For each finding:
   - Severity: 🔴 Must fix | 🟡 Should fix | 🟢 Suggestion | 💭 Nitpick
   - File and line reference
   - What the issue is
   - Suggested fix (with code if non-trivial)

4. Summary:
   - Overall assessment: Approve / Request changes / Needs discussion
   - Count of findings by severity
   - Highlight what's done well (not just problems)

## Arguments

$ARGUMENTS
