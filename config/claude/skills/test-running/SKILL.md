---
name: test-running
description: "Run tests and report results concisely. Runs in isolated
  context to keep verbose test output out of the main conversation."
context: fork
agent: test-runner
allowed-tools:
  - Bash
  - Read
---

Run the following tests and report results concisely.

$ARGUMENTS
