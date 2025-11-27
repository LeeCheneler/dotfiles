# Claude Configuration

Global instructions for Claude Code.

## Philosophy

- Quality over speed
- Simple beats clever
- Security is non-negotiable
- DX matters

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

- Functional components only
- Props interface: `{ComponentName}Props`
- Colocate components, hooks, and tests
- Server components by default (Next.js)

### Formatting

- Biome for formatting and linting
- No Prettier, no ESLint

## Testing

- Test behavior, not implementation
- Mock only at boundaries (network, filesystem, external services)
- Never mock code modules
- Realistic test data (no "foo", "bar", "test123")
- 90% coverage minimum

## Security

- Never commit secrets
- Validate all external input at boundaries
- Parameterized queries only (no string concatenation for SQL)
- Principle of least privilege (especially IAM)

## Git

- Conventional commits: `type(scope): description`
- Atomic commits (one logical change)
- Only commit when explicitly asked
- Never force push to main/master

## Communication

- Concise and direct
- No fluff or filler
- No emojis unless asked
- Say what's wrong clearly

## Agent Delegation

Delegate to specialized agents for deep work:

| Task            | Agent              | When                                           |
| --------------- | ------------------ | ---------------------------------------------- |
| Code review     | `code-reviewer`    | Reviewing PRs, branch changes, implementations |
| Writing tests   | `test-writer`      | Generating tests, improving coverage           |
| Documentation   | `doc-writer`       | READMEs, API docs, ADRs, changelogs            |
| Refactoring     | `refactor-advisor` | Identifying smells, suggesting improvements    |
| Security audit  | `security-auditor` | Vulnerability scanning, dependency audits      |
| Commit messages | `commit-message`   | Generating conventional commits                |
| PR descriptions | `pr-description`   | Writing PR summaries                           |

## What NOT to Do

- Don't add features beyond what's asked
- Don't refactor unrelated code
- Don't add comments to code you didn't change
- Don't create abstractions for single use cases
- Don't design for hypothetical future requirements
- Don't add error handling for impossible scenarios
- Don't use `// TODO` without a linked issue
- Don't over-engineer
