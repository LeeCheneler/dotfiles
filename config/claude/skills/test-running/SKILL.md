---
name: test-running
description: "Run tests and report results concisely. Auto-loads when running test suites. Invoke with /test-running to run and summarize tests."
---

# Test Running

## Process

1. Detect the test framework and runner from project configuration
2. Run the specified tests (or the full suite if no scope given)
3. Summarize the results — never dump raw test output

## Output

On pass:

    X passed in Ys

On fail:

    X passed, Y failed in Zs

    Failed:
    - <file> > <test name>
      Expected: <expected>
      Received: <actual>
      (repeat for each failure, max 5 — summarize remainder)

The whole point of this skill is to keep the main context clean.

## Arguments

$ARGUMENTS
