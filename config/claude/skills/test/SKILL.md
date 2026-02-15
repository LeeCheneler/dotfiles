---
description: "Run tests intelligently based on the project and context."
model: sonnet
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(npm test:*)
  - Bash(npx:*)
  - Bash(yarn:*)
  - Bash(pnpm:*)
  - Bash(cargo test:*)
  - Bash(go test:*)
  - Bash(pytest:*)
  - Bash(make test:*)
---

Run tests intelligently based on the project and context.

## Process

1. Detect test framework and runner:
   - Check package.json scripts (test, test:unit, test:e2e, test:integration)
   - Check for vitest.config, jest.config, playwright.config, pytest.ini, etc.
   - Check for Makefile test targets, cargo test, go test, etc.

2. Determine scope:
   - If $ARGUMENTS specifies files or patterns, run those
   - If there are uncommitted changes, run tests related to changed files
   - Otherwise, run the full suite

3. Run tests and present results:
   - On pass: concise summary (X passed in Ys)
   - On fail: for each failure show test name, assertion, and relevant
     code context
   - Never dump entire raw test output unless explicitly asked — summarize

## Arguments

$ARGUMENTS
