---
name: coding-react
description: "Apply when writing, editing, or reviewing React or Next.js code. Covers component patterns, server/client boundaries, hooks, state management, and common anti-patterns."
---

# Coding React

## Component Structure

- **Feature folders.** Group by feature, not by type. Co-locate
  components, hooks, utils, and types that belong to the same feature.
- **Function declarations** for components — not arrow functions.
- **Props types** use `ComponentNameProps` naming (e.g., `UserCardProps`).

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

## Server & Client Components

- **Server by default.** Only add `"use client"` when you need
  interactivity, browser APIs, or hooks.
- **Clear boundary components.** Create explicit client wrapper
  components rather than sprinkling `"use client"` across many files.

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

## State & Derived Data

- **React built-ins first.** `useState`, `useReducer`, `useContext` —
  only reach for external libraries when genuinely needed.
- **Derive, don't synchronize.** Calculate during render. If it can be
  computed from existing state or props, compute it. No `useEffect`
  to sync state.

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

## Hooks

- **Custom hooks for reuse or clarity.** Extract when logic is reused
  OR when it makes a component clearer — even if only used once.
- **`useEffect` is a last resort.** Most "effects" should be event
  handlers or derived state. Reserve `useEffect` for synchronization
  with external systems only.
- **Trust the linter on dependency arrays.** Never suppress
  `react-hooks/exhaustive-deps`. No exceptions.

## Anti-patterns

Avoid these patterns:

- **Prop drilling** more than 2 levels — use context or composition.
- **`useEffect` for state sync** — derive instead.
- **Data fetching in `useEffect`** — use server components or a data
  fetching library (React Query, SWR).
- **God components** over 200 lines — split by responsibility.
- **`index` as `key`** in dynamic lists — use stable identifiers.
- **Direct DOM manipulation** — use refs.
- **Business logic in components** — extract to pure functions or hooks.
- **Inline function definitions in JSX** causing unnecessary re-renders
  when performance matters — extract or memoise.
