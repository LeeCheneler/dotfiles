# Conventions

## Commits

Format: `<type>(<scope>): <description>`

Types: feat, fix, refactor, test, docs, chore, perf, ci, style, build

Rules:

- Imperative mood, lowercase, no period, under 72 chars
- Never mention Claude, AI, or any AI tool
- Each commit is atomic and independently reversible
- Body for complex changes: bullet points on what and why

## Pull Requests

- Follow the repo's PR template if one exists
- If no template: What / Why / Where / Testing / Notes
- Never mention Claude, AI, or any AI tool
- Keep PRs focused — split large changes

## Code

- KISS: small functions, simple modules
- Match the project's existing conventions always
- Favour pure functions, minimize side effects
- Don't abstract until pattern seen 3 times
- Don't destructure function params in TypeScript
- Let errors bubble to high-level handlers
- File naming: kebab-case unless project uses otherwise

## Tests

- Test behavior, not implementation
- Mock only at boundaries (network, filesystem, external services)
- Favour *.test.ts(x) unless project uses *.spec.ts(x)
- Don't extract helpers until pattern seen 5 times
- Descriptive test names in plain English
- Each test independent, no shared mutable state
