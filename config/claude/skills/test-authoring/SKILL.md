---
name: test-authoring
description: "Conventions for writing tests and generating test suites. Auto-loads when writing, reviewing, or generating tests. Invoke with /test-authoring to generate tests for specified code."
---

# Test Authoring

## Conventions

### Philosophy

- **Test behavior, not implementation.** Tests should verify what the code
  does from the consumer's perspective, not how it does it internally.
  If you refactor the internals and the behavior hasn't changed, tests
  should still pass.

  ```typescript
  // Good: tests the observable behavior
  test("should return user by email", async () => {
    await createUser({ email: "lee@test.com", name: "Lee" });
    const user = await getUserByEmail("lee@test.com");
    expect(user.name).toBe("Lee");
  });

  // Bad: tests internal implementation details
  test("should call findOne with email filter", async () => {
    const spy = vi.spyOn(db.users, "findOne");
    await getUserByEmail("lee@test.com");
    expect(spy).toHaveBeenCalledWith({ where: { email: "lee@test.com" } });
  });
  ```

- **Treat mocking with disdain.** Mock only at boundaries: network calls
  (use MSW or equivalent), filesystem, external services. Never mock
  internal modules or functions — if you need to mock an internal thing
  to test another internal thing, your design probably needs work.

  ```typescript
  // Good: mock the network boundary with MSW
  const server = setupServer(
    http.get("/api/users/:id", () => HttpResponse.json({ name: "Lee" })),
  );

  // Bad: mocking an internal module
  vi.mock("../services/user-service", () => ({
    getUser: vi.fn().mockResolvedValue({ name: "Lee" }),
  }));
  ```

- **No premature test abstraction.** Don't extract shared test helpers or
  fixtures until you've seen the same pattern 5 times (rule of 5). Test
  code is allowed to be a bit repetitive if it makes each test clear and
  independent.
- **Write tests, don't obsess about order.** Test coverage matters.
  Whether you write tests before or after the implementation is a per-task
  judgement call, not a religious rule.

### Structure

- Favour `*.test.ts(x)` over `*.spec.ts(x)` unless the project already
  uses spec files — then match the project.
- Group tests by behavior or feature, not by function name.
- Each test should be independent — no shared mutable state between tests.
- Use descriptive test names that read as plain English:
  "should return 404 when user not found" not "test getUserById error case".

  ```typescript
  // Good: reads as a behavior specification
  test("should return 404 when user does not exist", ...);
  test("should hash password before storing", ...);
  test("should send welcome email after signup", ...);

  // Bad: describes implementation, not behavior
  test("test getUserById error", ...);
  test("password hashing", ...);
  test("email function", ...);
  ```

### Quality Checks

- Every test should have a clear given/when/then structure (even if not
  formally labelled).
- Prefer realistic test data over contrived minimal examples.
- Cover: happy path, edge cases, error handling.
- If a test needs extensive setup, that might indicate the code under test
  is doing too much.

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
