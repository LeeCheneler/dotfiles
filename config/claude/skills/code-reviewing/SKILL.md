---
name: code-reviewing
description: "Review code changes for quality, security, performance, and
  conventions. Runs in isolated context to avoid cluttering the main
  conversation with intermediate file reads."
context: fork
agent: reviewer
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(git diff:*)
  - Bash(gh pr diff:*)
  - Bash(gh pr view:*)
---

Review the following code changes thoroughly.

Accept one of: a PR number, a branch name, a diff range, or "current changes".
Default to uncommitted changes if nothing specified.

$ARGUMENTS
