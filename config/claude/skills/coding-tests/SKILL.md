---
name: coding-tests
description: "Apply when writing, editing, or reviewing tests. Covers testing philosophy, test structure, mocking conventions, and framework patterns."
---

# Coding Tests

## Philosophy

- **Test behavior, not implementation.** What goes in, what comes out,
  what side effects occur. Don't test internal state or private methods.
- **Soft coverage target:** 80%+ on business logic. Don't mandate
  coverage on UI components.
- **Write tests for every new feature/module.** Don't worry about
  test-first vs test-after — just write good tests.

## What NOT to Test

- Implementation details (internal state, private methods, DOM structure)
- Third-party library behavior
- Framework plumbing (React rendering, Next.js routing)
- Simple getters/setters with no logic
- CSS/styling (unless functional, like visibility)

## Test Structure

- **Co-locate tests.** `user-service.ts` and `user-service.test.ts`
  in the same directory.
- **File naming:** match the project convention (`.test.ts` or `.spec.ts`).
- **Organization:** `describe` per function/method, `it` per behavior.
  Nest `describe("when ...")` for scenarios. No top-level `describe`
  wrapping the whole file — keep it flat, avoid the Christmas tree of
  indentation. Multiple top-level `describe` blocks are fine.
- **Test names:** `it("should [expected behavior] when [condition]")`.
- **AAA pattern:** Arrange, Act, Assert — with blank lines between sections.

```typescript
// ✅ Good: flat structure, AAA, descriptive names
describe("validateEmail", () => {
  it("should return true when email is valid", () => {
    const email = "user@example.com";

    const result = validateEmail(email);

    expect(result).toBe(true);
  });

  describe("when email is malformed", () => {
    it("should return false when missing @ symbol", () => {
      const email = "user-example.com";

      const result = validateEmail(email);

      expect(result).toBe(false);
    });
  });
});

// ❌ Bad: unnecessary top-level wrapper, deep nesting, no AAA
describe("email-utils", () => {
  describe("validateEmail", () => {
    describe("valid emails", () => {
      it("works", () => {
        expect(validateEmail("user@example.com")).toBe(true);
      });
    });
  });
});
```

## Mocking

- **Mock at boundaries only.** APIs, databases, file system, time.
  Never mock internal modules.
- **Prefer real implementations.** Use in-memory databases, test
  containers (e.g., Postgres via testcontainers). Only mock what you
  genuinely can't control.
- **MSW for external HTTP.** Use Mock Service Worker to intercept at
  the network level for APIs you don't own.
- **Dependency injection over `vi.mock()`.** Pass dependencies as
  function parameters rather than module-level mocking.
- **Fake timers for time.** Always use `vi.useFakeTimers()` /
  `vi.setSystemTime()` when tests depend on time.

```typescript
// ✅ Good: dependency injection, real-ish implementations
function createUserService(deps: { db: Database; emailer: Emailer }) {
  return {
    async register(input: RegisterInput) {
      const user = await deps.db.users.create(input);
      await deps.emailer.sendWelcome(user.email);
      return user;
    },
  };
}

// In test: inject test doubles
const service = createUserService({
  db: createTestDatabase(),          // in-memory or test container
  emailer: { sendWelcome: vi.fn() }, // spy at the boundary
});

// ❌ Bad: module-level mocking of internal modules
vi.mock("../db", () => ({ getDb: vi.fn() }));
vi.mock("../services/email", () => ({ sendEmail: vi.fn() }));
```

## Framework Conventions

- **Vitest** for all projects unless the project already has tests set
  up with a different framework — then match it.
- **React Testing Library** for component tests.
- **Playwright** for E2E tests.
- **No snapshot tests.** They're low-value, break on trivial changes,
  and get blindly updated.

## React Testing Patterns

- **Render, interact, assert.** Render the component, interact via user
  events, assert on visible output. Never test internal state.
- **Query priority:** `getByRole` > `getByLabelText` > `getByText` >
  `getByTestId` (last resort only).
- **Async elements:** `findBy*` for elements that appear asynchronously,
  `waitFor` for side effects.
- **API mocking:** MSW at the network level.

```tsx
// ✅ Good: user-centric, accessible queries
describe("LoginForm", () => {
  it("should show success message when credentials are valid", async () => {
    const user = userEvent.setup();
    render(<LoginForm />);

    await user.type(screen.getByLabelText("Email"), "user@test.com");
    await user.type(screen.getByLabelText("Password"), "password123");
    await user.click(screen.getByRole("button", { name: "Sign in" }));

    expect(await screen.findByText("Welcome back")).toBeInTheDocument();
  });
});

// ❌ Bad: testing implementation, data-testid, checking state
it("works", () => {
  const { container } = render(<LoginForm />);
  fireEvent.change(container.querySelector("[data-testid='email']"), {
    target: { value: "user@test.com" },
  });
  expect(component.state.email).toBe("user@test.com");
});
```

## Test Quality

- **Tests must be independent.** Shared setup in `beforeEach` is fine,
  but tests must never depend on execution order.
- **One reason to fail.** Each test should fail for exactly one reason.
  Many asserts may indicate a code smell.
