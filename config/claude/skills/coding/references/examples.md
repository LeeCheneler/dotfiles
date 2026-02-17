# Coding Examples

✅/❌ examples for every rule in the coding skill.

---

## Function Design

### Options object for multiple params

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

---

## Abstraction & Duplication

### Rule of 3

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

---

## Error Handling

### Let errors bubble

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

---

## TypeScript

### Discriminated unions vs booleans

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

### Don't destructure function parameters

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

### Shallow error hierarchy

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

### Zod at boundaries

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

### Descriptive generics

```typescript
// ✅ Good: descriptive generic
function useQuery<TData, TError>(
  options: QueryOptions<TData, TError>,
): QueryResult<TData, TError>

// ❌ Bad: opaque single-letter generics
function useQuery<T, E>(options: QueryOptions<T, E>): QueryResult<T, E>
```

---

## React & Next.js

### Component structure

```tsx
// ✅ Good: function declaration, named props type
type UserCardProps = {
  user: User;
  onSelect: (id: string) => void;
};

export function UserCard(props: UserCardProps) {
  return (
    <button onClick={() => props.onSelect(props.user.id)}>
      {props.user.name}
    </button>
  );
}

// ❌ Bad: arrow function, destructured props, generic name
export const UserCard = ({ user, onSelect }: Props) => (
  <button onClick={() => onSelect(user.id)}>{user.name}</button>
);
```

### Server/client boundaries

```tsx
// ✅ Good: explicit client boundary
// components/interactive-chart.tsx
"use client";
export function InteractiveChart(props: InteractiveChartProps) {
  const [zoom, setZoom] = useState(1);
  return <canvas /* ... */ />;
}

// page.tsx (server component)
export default async function DashboardPage() {
  const data = await fetchChartData();
  return <InteractiveChart data={data} />;
}
```

### Derive, don't synchronize

```tsx
// ✅ Good: derive during render
function FilteredList(props: FilteredListProps) {
  const filtered = props.items.filter((item) =>
    item.name.includes(props.query),
  );
  return <ul>{filtered.map(/* ... */)}</ul>;
}

// ❌ Bad: useEffect to sync derived state
function FilteredList(props: FilteredListProps) {
  const [filtered, setFiltered] = useState(props.items);
  useEffect(() => {
    setFiltered(props.items.filter((item) =>
      item.name.includes(props.query),
    ));
  }, [props.items, props.query]);
  return <ul>{filtered.map(/* ... */)}</ul>;
}
```

---

## Testing

### Test structure (AAA, flat describe)

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

### Mocking (dependency injection vs vi.mock)

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

### React Testing Library

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
