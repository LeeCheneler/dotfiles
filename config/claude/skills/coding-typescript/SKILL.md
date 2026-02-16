---
name: coding-typescript
description: "Apply when writing, editing, or reviewing TypeScript code. Covers type system patterns, function conventions, error handling, null safety, and TS-specific idioms."
---

# Coding TypeScript

## Type System

- **`type` by default.** Use `interface` only when you need declaration
  merging or `extends` on an object shape.
- **Discriminated unions for complex state.** Booleans are fine for
  simple on/off flags. Use unions to model state machines and make
  invalid states unrepresentable.
- **Enums are fine.** Use them when you need a named set of constants.
- **Never `any`.** Always `unknown` with type narrowing.
- **Avoid type assertions (`as`).** Use type guards, narrowing, or
  schema parsing (e.g., Zod) to infer types instead.
- **Utility types liberally.** `Pick`, `Omit`, `Partial`, `Required`,
  `Record`, `Extract`, `Exclude` — derive types, don't duplicate shapes.

```typescript
// ✅ Good: discriminated union for complex state
type RequestState =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: User }
  | { status: "error"; error: Error };

// ✅ Fine: boolean for simple toggle
type ModalProps = { isOpen: boolean };

// ❌ Bad: multiple booleans allow impossible states
type RequestState = {
  isLoading: boolean;
  isError: boolean;
  data: User | null;
  error: Error | null;
};
```

## Function Conventions

- **Don't destructure function parameters.** Use `props.name` not
  `({ name })`. Preserves the type name in signatures, makes
  refactoring easier, and is clearer with many params.
- **Annotate return types on exported functions.** Let TypeScript infer
  return types on internal/private functions.
- **Prefer union parameters over overloads.** Overloads add complexity
  for marginal gains.

```typescript
// ✅ Good: preserves type name, easy to refactor
function createUser(props: CreateUserProps): User {
  return { id: generateId(), name: props.name, email: props.email };
}

// ❌ Bad: loses type context, harder to refactor
function createUser({ name, email }: CreateUserProps): User {
  return { id: generateId(), name, email };
}
```

## Error Handling

- **Extend `Error` for domain errors.** Keep the hierarchy shallow —
  one or two levels, not a taxonomy.
- **Null semantics:** `null` for intentional absence ("explicitly no
  value"), `undefined` for unset/missing ("not provided"). Always use
  `strictNullChecks`.

```typescript
// ✅ Good: shallow error hierarchy with useful context
class AppError extends Error {
  constructor(message: string, public code: string) {
    super(message);
  }
}
class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found`, "NOT_FOUND");
  }
}

// ❌ Bad: deep inheritance chain
class DatabaseError extends AppError {}
class PostgresError extends DatabaseError {}
class PostgresConnectionError extends PostgresError {}
```

## Runtime Validation

- **Zod at API boundaries.** Validate and infer types from schemas at
  the edges — API handlers, form inputs, environment variables. Don't
  validate internally between trusted modules.

```typescript
// ✅ Good: validate at the boundary, infer the type
const CreateUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});
type CreateUserInput = z.infer<typeof CreateUserSchema>;

export function handleCreateUser(raw: unknown): User {
  const input = CreateUserSchema.parse(raw);
  return createUser(input);
}
```

## Exports & Generics

- **Named exports only.** No default exports except where frameworks
  require them (e.g., Next.js page/layout components).
- **Descriptive generic names.** `TData`, `TError`, `TContext` — not
  single letters like `T`, `U`, `V`.

```typescript
// ✅ Good: descriptive generic
function useQuery<TData, TError>(
  options: QueryOptions<TData, TError>,
): QueryResult<TData, TError>

// ❌ Bad: opaque single-letter generics
function useQuery<T, E>(options: QueryOptions<T, E>): QueryResult<T, E>
```
