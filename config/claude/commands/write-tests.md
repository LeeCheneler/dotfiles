Generate tests for the specified code.

## Philosophy

- Test units of behavior, not units of code
- Each test should read as: given X, when Y, then Z
- Test names should describe the expected behavior in plain English
- Prefer realistic test data over contrived examples
- Treat mocking with general disdain — mock only at boundaries (network
  with MSW, filesystem, external services). Never mock internal modules
- Don't extract shared test helpers until you've seen the same pattern
  5 times (rule of 5 in tests)
- Favour *.test.ts(x) over *.spec.ts(x) unless the project already uses spec

## Process

1. Identify what to test:
   - If $ARGUMENTS specifies a file or function, test that
   - If not, look at recent changes and suggest what needs tests

2. Analyze the code:
   - Public API surface (what consumers/callers use)
   - Edge cases and error paths
   - Integration points and boundaries
   - Existing test patterns in the project

3. Detect project test conventions:
   - Test file location (co-located vs **tests** vs test/)
   - Test framework and assertion style
   - Mocking patterns already in use
   - Naming conventions

4. Generate tests following project conventions:
   - Group by behavior/feature, not by function
   - Cover: happy path, edge cases, error handling
   - Use descriptive names: "should return 404 when user not found"
   - Keep each test independent and focused
   - Match the project's existing patterns exactly

5. Run the new tests to verify they pass.

## Arguments

$ARGUMENTS
