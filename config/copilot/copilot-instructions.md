# Copilot Instructions

## Code Style

- TypeScript strict mode, no `any`
- Files: `kebab-case`, variables: `camelCase`, components: `PascalCase`
- Functional React components with hooks
- Zod for runtime validation at API boundaries
- Biome for formatting (not Prettier/ESLint)

## Testing

- Test behavior, not implementation
- Mock only boundaries (network, external services), never code modules
- Descriptive names: `should {behavior} when {condition}`
- Arrange-Act-Assert pattern
- Realistic test data (no "foo", "bar")

## Patterns

### React Component

```tsx
interface ButtonProps {
  label: string;
  onClick: () => void;
  disabled?: boolean;
}

export function Button({ label, onClick, disabled = false }: ButtonProps) {
  return (
    <button onClick={onClick} disabled={disabled}>
      {label}
    </button>
  );
}
```

### API Route (Next.js)

```ts
import { z } from "zod";

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
});

export async function POST(req: Request) {
  const body = await req.json();
  const data = CreateUserSchema.parse(body);
  // ... handle request
}
```

### Test

```ts
describe("calculateTotal", () => {
  it("should include tax when items in cart", () => {
    // Arrange
    const cart = createCart({ items: [{ price: 100 }], taxRate: 0.1 });

    // Act
    const total = cart.calculateTotal();

    // Assert
    expect(total).toBe(110);
  });
});
```

## Don't

- Add features beyond the request
- Create abstractions prematurely
- Mock internal modules
- Use `any` type
- Over-engineer

## Project Context

<!-- Add project-specific details below -->
