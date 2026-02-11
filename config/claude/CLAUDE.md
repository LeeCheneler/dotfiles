# Claude Configuration

Global instructions for Claude Code.

## Philosophy

- Quality over speed
- Simple beats clever
- Security is non-negotiable
- DX matters

## Tech Stack

Primary: Full-stack TypeScript

- **Frontend**: React, Next.js (App Router, server components by default)
- **Backend**: Node.js, Next.js API routes
- **Infrastructure**: AWS (Lambda, ECS, SQS/EventBridge for EDA), Terraform
- **CI/CD**: GitHub Actions, Docker
- **Testing**: Vitest (preferred), Jest (existing projects), Playwright (E2E)
- **Side projects**: Deno

## Code Style

### TypeScript

- Strict mode always
- No `any` - use `unknown` and narrow
- Exhaustive switch statements with `never`
- Zod for runtime validation at boundaries

### Naming

- Files: `kebab-case`
- Variables/functions: `camelCase`
- Components/Classes/Types: `PascalCase`
- Constants: `SCREAMING_SNAKE_CASE`
- Booleans: `is`/`has`/`should` prefix

### React

- Colocate components, hooks, and tests
- Server components by default (Next.js)

### Formatting & Linting

- Always check what the project already uses first (scan package.json scripts, config files)
- If a project has a lint/format script, use that
- When bootstrapping a new project, default to Biome

## Testing

- Test behavior, not implementation
- Mock only at boundaries (network, filesystem, external services)
- Never mock code modules
- Realistic test data (no "foo", "bar", "test123")
- TDD when feasible - write the test first
- 90% coverage minimum

## Security

- Never commit secrets
- Validate all external input at boundaries
- Parameterized queries only (no string concatenation for SQL)
- Principle of least privilege (especially IAM)

## Git

- Conventional commits: `type(scope): description`
- Only commit when explicitly asked

## Workflow

For quick fixes and small tasks, just do the work directly.

For non-trivial work, use plan mode to research the codebase and design the approach. Once approved, implement with atomic conventional commits. Run tests and lint as you go.

Use judgement - if a task needs planning, plan it. If it doesn't, skip the ceremony.

## Context Compaction

When compacting, always preserve:

- Current task objective and progress
- The full list of modified files and their purposes
- Any test commands that have been run and their results
- Active branch name and commit history summary

## What NOT to Do

- Don't add features beyond what's asked
- Don't refactor unrelated code
- Don't create abstractions for single use cases
- Don't design for hypothetical future requirements
- Don't use `// TODO` without a linked issue
