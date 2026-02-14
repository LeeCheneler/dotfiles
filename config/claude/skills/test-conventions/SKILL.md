---
description: "Apply when writing, generating, or reviewing tests in any
  language. Covers test philosophy, structure, naming, and quality standards."
---

# Test Conventions

## Philosophy

- **Test behavior, not implementation.** Tests should verify what the code
  does from the consumer's perspective, not how it does it internally.
  If you refactor the internals and the behavior hasn't changed, tests
  should still pass.
- **Treat mocking with disdain.** Mock only at boundaries: network calls
  (use MSW or equivalent), filesystem, external services. Never mock
  internal modules or functions — if you need to mock an internal thing
  to test another internal thing, your design probably needs work.
- **No premature test abstraction.** Don't extract shared test helpers or
  fixtures until you've seen the same pattern 5 times (rule of 5). Test
  code is allowed to be a bit repetitive if it makes each test clear and
  independent.
- **Write tests, don't obsess about order.** Test coverage matters.
  Whether you write tests before or after the implementation is a per-task
  judgement call, not a religious rule.

## Structure

- Favour `*.test.ts(x)` over `*.spec.ts(x)` unless the project already
  uses spec files — then match the project.
- Group tests by behavior or feature, not by function name.
- Each test should be independent — no shared mutable state between tests.
- Use descriptive test names that read as plain English:
  "should return 404 when user not found" not "test getUserById error case".

## Quality Checks

- Every test should have a clear given/when/then structure (even if not
  formally labelled).
- Prefer realistic test data over contrived minimal examples.
- Cover: happy path, edge cases, error handling.
- If a test needs extensive setup, that might indicate the code under test
  is doing too much.
