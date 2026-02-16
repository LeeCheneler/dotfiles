---
name: coding
description: "Apply when writing, editing, or reviewing code in any language. Covers function design, abstraction decisions, error handling philosophy, module organization, naming, and file conventions."
---

# Coding

## Function Design

- **Small and focused.** Each function does one thing. If you need a
  comment to explain what a function does, split or rename it.
- **Favor pure functions.** Minimize side effects, but pragmatism wins
  over purity dogma.
- **More than 3 parameters? Use an options object.**

```typescript
// ✅ Good: options object for multiple params
function createUser(props: CreateUserProps): User {
  return { id: generateId(), name: props.name, email: props.email };
}

// ❌ Bad: too many positional params
function createUser(name: string, email: string, role: string, team: string): User {
  return { id: generateId(), name, email, role, team };
}
```

## Abstraction & Duplication

- **Rule of 3.** Don't extract until you've seen the same pattern 3
  times. Duplication is cheaper than the wrong abstraction.
- **Composition over inheritance** by default. Inheritance is fine for
  clear IS-A relationships.

```typescript
// ✅ Good: two similar handlers kept separate (only 2 occurrences)
async function handleUserCreated(event: UserCreatedEvent) {
  await sendWelcomeEmail(event.userId);
  await trackAnalytics("user_created", event.userId);
}

async function handleTeamCreated(event: TeamCreatedEvent) {
  await sendTeamWelcomeEmail(event.teamId);
  await trackAnalytics("team_created", event.teamId);
}

// ❌ Bad: premature generic handler after only 2 occurrences
async function handleEntityCreated<TEntity extends { id: string }>(
  config: EntityHandlerConfig<TEntity>,
) {
  await config.sendEmail(config.entityId);
  await trackAnalytics(config.eventName, config.entityId);
}
```

## Error Handling

- **Let errors bubble.** Single high-level error boundary. Don't
  try/catch at every call site.
- **Never swallow errors silently.** Handle meaningfully or let propagate.
- **Log with context.** What was being attempted, what input caused it.

```typescript
// ✅ Good: single high-level handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  logger.error({ err, path: req.path, method: req.method }, "unhandled error");
  res.status(500).json({ error: "Internal server error" });
});

// ❌ Bad: try/catch at every endpoint
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

## Module Organization

- **Feature-based modules.** A module can do several related things if
  they belong to the same feature.
- **Barrel files sparingly.** Only at package or feature boundaries.
- **Import order** is the linter's job — don't hand-enforce it.

## Naming & Files

- **File naming:** kebab-case unless the project uses a different
  convention. Check existing files first and match. Well-known files
  (README.md, Dockerfile) keep their standard names.
- **Match the project.** Before creating any file, check how existing
  files are named and structured. Follow that pattern exactly.
- **Variables/functions:** camelCase.
- **Types/interfaces/classes:** PascalCase.
- **Constants:** UPPER_SNAKE_CASE.
- **Booleans:** prefix with `is`, `has`, `can`, `should`, `will`.

## Comments & Documentation

- **Comments are for commentary.** They explain _why_, not _what_.
- **Exception: complex algorithms** should have commentary explaining
  both what and why.
- **JSDoc on public interfaces.** Exported functions get JSDoc with
  parameter descriptions unless trivially obvious (e.g., comparator's
  `a` and `b`).
- **No TODOs in code.** Create a ticket or report to the user instead.
  Never leave `TODO` or `FIXME` comments in committed code.

## Immutability

- **`const` by default.** Use `let` only when reassignment is needed.
- **Pragmatic mutation.** Mutate when it's clearer — building up arrays
  in loops, accumulating state in a reducer. Don't contort code to
  avoid all mutation.
