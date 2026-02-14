---
description: "Apply when writing, editing, or reviewing code in any language.
  Covers naming, structure, error handling, and code quality standards."
---

# Coding Standards

## General Principles

- **KISS.** Keep functions small and focused. Each function does one thing.
  If a function needs a comment explaining what it does, it should probably
  be split or renamed.
- **Purity.** Favour pure functions and minimize side effects. But don't
  over-abstract to achieve purity — pragmatism wins.
- **No premature abstraction.** Don't extract a shared function or component
  until you've seen the same pattern 3 times (rule of 3). Duplication is
  cheaper than the wrong abstraction.
- **Simple modules.** Each module should have a clear, single responsibility.
  Avoid god modules that do everything.

## TypeScript Specific

- **Leverage the type system.** Use types to make invalid states
  unrepresentable. Prefer discriminated unions over boolean flags.
- **Don't destructure function parameters.** Use `(props: Props) => ...`
  not `({ id }: Props) => ...`. This preserves the type name in signatures,
  makes refactoring easier, and is clearer when functions have many params.
- **Let errors bubble.** In APIs, prefer a single high-level error boundary
  over catching at every call site. Catch at the top, let errors propagate
  naturally. This keeps the coding surface simpler and error handling
  consistent.

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
