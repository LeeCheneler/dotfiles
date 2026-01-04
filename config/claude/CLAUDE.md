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
| Research        | `researcher`       | Deep codebase exploration for a task           |
| Planning        | `planner`          | Creating structured implementation plans       |
| Code review     | `code-reviewer`    | Reviewing PRs, branch changes, implementations |
| Writing tests   | `test-writer`      | Generating tests, improving coverage           |
| Running tests   | `test-runner`      | Run tests, return concise pass/fail summary    |
| Documentation   | `doc-writer`       | READMEs, API docs, ADRs, changelogs            |
| Refactoring     | `refactor-advisor` | Identifying smells, suggesting improvements    |
| Security audit  | `security-auditor` | Vulnerability scanning, dependency audits      |
| Commit messages | `commit-message`   | Generating conventional commits                |
| PR descriptions | `pr-description`   | Writing PR summaries                           |
| Git operations  | `git-summarizer`   | Summarize git output, minimize context usage   |

## Development Workflow

Use slash commands for structured development:

| Command           | Purpose                                    |
| ----------------- | ------------------------------------------ |
| `/begin <task>`   | Start new work: research, plan, signoff    |
| `/next`           | Execute next commit cycle                  |
| `/resume`         | Resume existing plan from another session  |
| `/status`         | Show current plan progress                 |
| `/abort`          | Abort current plan safely                  |
| `/security-audit` | Run security audit before PR (recommended) |
| `/pr`             | Open pull request                          |

Standalone phase commands (for manual control or recovery):

| Command     | Purpose                              |
| ----------- | ------------------------------------ |
| `/research` | Run research phase only              |
| `/plan`     | Run planning phase only              |
| `/signoff`  | Present and get approval             |
| `/dev`      | Run dev phase for current commit     |
| `/review`   | Run review phase for current changes |
| `/present`  | Present changes for user approval    |
| `/commit`   | Commit with approval                 |

### Workflow Phases

```
1. RESEARCH ──► 2. PLAN ──► 3. SIGNOFF ──► 4. EXECUTE ──► 5. SECURITY ──► 6. PR
```

**Execute loop (per commit):**

```
DEV ──► REVIEW (code only) ──► PRESENT ──► COMMIT
```

**Pre-PR (once, after all commits):**

```
/security-audit ──► /pr
```

Plans are stored in `docs/plans/<task-slug>/` with:

- `research.md` - Codebase research and findings
- `plan.md` - Commit breakdown with checklists

### Key Rules

- Never commit without explicit user approval
- Never skip research or planning for non-trivial work
- Fix Critical/High review issues before presenting
- Update plan.md checklists as work progresses

## What NOT to Do

- Don't add features beyond what's asked
- Don't refactor unrelated code
- Don't add comments to code you didn't change
- Don't create abstractions for single use cases
- Don't design for hypothetical future requirements
- Don't add error handling for impossible scenarios
- Don't use `// TODO` without a linked issue
- Don't over-engineer
