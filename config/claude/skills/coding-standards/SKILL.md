---
description: "Apply when writing, editing, or reviewing code in any language.
  Covers naming, structure, error handling, and code quality standards."
---

# Coding Standards

## General Principles

- **KISS.** Keep functions small and focused. Each function does one thing.
  If a function needs a comment explaining what it does, it should probably
  be split or renamed.

  ```typescript
  // Good: each function does one thing
  function validateEmail(input: string): boolean {
    return emailRegex.test(input);
  }

  function normalizeEmail(input: string): string {
    return input.trim().toLowerCase();
  }

  // Bad: function does validation, normalization, and persistence
  function processEmail(input: string): Promise<User> {
    if (!emailRegex.test(input)) throw new Error("invalid");
    const normalized = input.trim().toLowerCase();
    return db.users.updateEmail(normalized);
  }
  ```

- **Purity.** Favour pure functions and minimize side effects. But don't
  over-abstract to achieve purity — pragmatism wins.
- **No premature abstraction.** Don't extract a shared function or component
  until you've seen the same pattern 3 times (rule of 3). Duplication is
  cheaper than the wrong abstraction.

  ```typescript
  // Good: two similar handlers, kept separate (only 2 occurrences)
  async function handleUserCreated(event: UserCreatedEvent) {
    await sendWelcomeEmail(event.userId);
    await trackAnalytics("user_created", event.userId);
  }

  async function handleTeamCreated(event: TeamCreatedEvent) {
    await sendTeamWelcomeEmail(event.teamId);
    await trackAnalytics("team_created", event.teamId);
  }

  // Bad: premature generic handler after only 2 occurrences
  async function handleEntityCreated<T extends { id: string }>(
    config: EntityHandlerConfig<T>,
  ) {
    await config.sendEmail(config.entityId);
    await trackAnalytics(config.eventName, config.entityId);
  }
  ```

- **Simple modules.** Each module should have a clear, single responsibility.
  Avoid god modules that do everything.

## TypeScript Specific

- **Leverage the type system.** Use types to make invalid states
  unrepresentable. Prefer discriminated unions over boolean flags.

  ```typescript
  // Good: invalid states are unrepresentable
  type RequestState =
    | { status: "idle" }
    | { status: "loading" }
    | { status: "success"; data: User }
    | { status: "error"; error: Error };

  // Bad: multiple booleans allow impossible states (loading AND error)
  type RequestState = {
    isLoading: boolean;
    isError: boolean;
    data: User | null;
    error: Error | null;
  };
  ```

- **Don't destructure function parameters.** Use `(props: Props) => ...`
  not `({ id }: Props) => ...`. This preserves the type name in signatures,
  makes refactoring easier, and is clearer when functions have many params.

  ```typescript
  // Good: preserves type name, easy to refactor
  function createUser(props: CreateUserProps): User {
    return { id: generateId(), name: props.name, email: props.email };
  }

  // Bad: loses type context, harder to refactor with many params
  function createUser({ name, email }: CreateUserProps): User {
    return { id: generateId(), name, email };
  }
  ```

- **Let errors bubble.** In APIs, prefer a single high-level error boundary
  over catching at every call site. Catch at the top, let errors propagate
  naturally. This keeps the coding surface simpler and error handling
  consistent.

  ```typescript
  // Good: single high-level handler
  app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
    logger.error({ err, path: req.path }, "unhandled error");
    res.status(500).json({ error: "Internal server error" });
  });

  // Bad: try/catch at every endpoint
  router.get("/users/:id", async (req, res) => {
    try {
      const user = await getUser(req.params.id);
      res.json(user);
    } catch (err) {
      logger.error(err);
      res.status(500).json({ error: "Something went wrong" });
    }
  });
  ```

## Naming & Files

- **File naming:** kebab-case for all files unless the project uses a
  different convention. Always check existing files first and match.
  Well-known files (README.md, CONTRIBUTING.md, Dockerfile) keep their
  standard names.
- **Match the project.** Before creating any new file, check how existing
  files are named, structured, and organized. Follow the established pattern
  exactly, even if you'd prefer a different approach.

## Error Handling

- Don't swallow errors silently. Either handle them meaningfully or let
  them propagate.
- In API layers, use a centralized error handler rather than try/catch at
  every endpoint.
- Log errors with enough context to debug them (what was being attempted,
  what input caused it).
