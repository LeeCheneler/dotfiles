---
name: coding
description: "Apply when writing, editing, or reviewing code. Covers function design, abstraction, error handling, naming, TypeScript type system, React component patterns, and testing conventions. Auto-loads on any source file (.ts, .tsx, .js, .jsx, .py, etc). Use when user says 'write code', 'refactor', 'review', 'write tests', or is working on any source file."
---

# Coding

For ✅/❌ examples of every rule, see `references/examples.md`.

## Function Design

- **Small and focused.** Each function does one thing.
- **Favor pure functions.** Minimize side effects. Pragmatism wins.
- **More than 3 parameters? Use an options object.**

## Abstraction & Duplication

- **Rule of 3.** Don't extract until you've seen the same pattern 3
  times. Duplication is cheaper than the wrong abstraction.
- **Composition over inheritance** by default.

## Error Handling

- **Let errors bubble.** Single high-level error boundary. Don't
  try/catch at every call site.
- **Never swallow errors silently.**
- **Log with context.** What was being attempted, what input caused it.

## Module Organization

- **Feature-based modules.** Group by feature, not by type.
- **Barrel files sparingly.** Only at package or feature boundaries.
- **Import order** is the linter's job.

## Naming & Files

- **File naming:** kebab-case unless the project uses something else.
  Check existing files first and match.
- **Match the project.** Always check existing patterns before creating
  new files.
- **Variables/functions:** camelCase. **Types/classes:** PascalCase.
  **Constants:** UPPER_SNAKE_CASE.
- **Booleans:** prefix with `is`, `has`, `can`, `should`, `will`.

## Comments & Documentation

- **Comments explain why, not what.** Exception: complex algorithms.
- **JSDoc on public interfaces.** Exported functions get param docs
  unless trivially obvious.
- **No TODOs in code.** Create a ticket or report to the user.

## Immutability

- **`const` by default.** Mutate when it's clearer (loops, accumulators).

---

## TypeScript

- **`type` by default.** `interface` only for declaration merging.
- **Discriminated unions for complex state.** Booleans fine for simple
  on/off.
- **Enums are fine.**
- **Never `any`.** Always `unknown` with type narrowing.
- **Avoid type assertions (`as`).** Use type guards or schema parsing.
- **Utility types liberally.** `Pick`, `Omit`, `Partial`, `Record`, etc.
- **Don't destructure function parameters.** Use `props.name` not
  `({ name })`. Preserves the type name.
- **Annotate return types on exported functions.** Infer on internal.
- **Prefer union parameters over overloads.**
- **Extend `Error` for domain errors.** Keep hierarchy shallow.
- **Null semantics:** `null` for intentional absence, `undefined` for
  unset. Always `strictNullChecks`.
- **Zod at API boundaries.** Validate and infer types from schemas at
  edges only.
- **Named exports only.** No default exports except framework
  requirements (Next.js pages).
- **Descriptive generic names.** `TData`, `TError` — not `T`, `E`.

---

## React & Next.js

- **Feature folders.** Group by feature, not by type.
- **Function declarations** for components, not arrow functions.
- **Props types:** `ComponentNameProps` (e.g., `UserCardProps`).
- **Server by default.** Only `"use client"` for interactivity, browser
  APIs, or hooks.
- **Clear client boundary components.** Don't sprinkle `"use client"`.
- **React built-ins first** for state. Libraries only when genuinely
  needed.
- **Derive, don't synchronize.** Calculate during render. No `useEffect`
  to sync state.
- **Custom hooks for reuse or clarity.** Even if only used once.
- **`useEffect` is a last resort.** Most "effects" should be event
  handlers or derived state.
- **Trust the linter on dependency arrays.** No exceptions.

### Anti-patterns

- Prop drilling >2 levels — use context or composition.
- `useEffect` for state sync — derive instead.
- Data fetching in `useEffect` — use server components or React Query.
- God components >200 lines — split by responsibility.
- `index` as `key` in dynamic lists — use stable identifiers.
- Business logic in components — extract to functions or hooks.

---

## Testing

- **Test behavior, not implementation.** Never test internal state.
- **Soft coverage target:** 80%+ on business logic. Don't mandate on UI.
- **Write tests for every new feature/module.**
- **Co-locate tests.** `user-service.test.ts` next to `user-service.ts`.
- **Describe per function, it per behavior.** Nest
  `describe("when ...")` for scenarios. No top-level describe wrapper.
- **Test names:** `it("should [behavior] when [condition]")`.
- **AAA pattern:** Arrange, Act, Assert with blank lines between.
- **Mock at boundaries only.** APIs, databases, file system, time.
- **Prefer real implementations.** In-memory databases, test containers.
- **MSW for external HTTP.** Intercept at the network level.
- **Dependency injection over `vi.mock()`.** Pass dependencies as params.
- **Fake timers** with `vi.useFakeTimers()` for time-dependent tests.
- **Vitest** unless the project already uses something else.
- **React Testing Library** for component tests.
- **Playwright** for E2E.
- **No snapshot tests.**
- **RTL query priority:** `getByRole` > `getByLabelText` > `getByText`
  > `getByTestId` (last resort).

### What NOT to test

- Implementation details, private methods, specific DOM structure
- Third-party library behavior
- Framework plumbing (React rendering, Next.js routing)
- Simple getters/setters with no logic
- CSS/styling (unless functional like visibility)
