# Claude Configuration

Global instructions for Claude Code.

## Philosophy

- Quality over speed
- Simple beats clever
- Security is non-negotiable
- DX matters
- Detect, then decide - scan the project before assuming anything

## Project Discovery

**Before writing any code, understand the project.** Read these if they exist:

- `CONTRIBUTING.md`, `README.md`, `.claude/CLAUDE.md` - project guidelines
- `package.json`, `deno.json`, `Cargo.toml`, `go.mod` - stack and scripts
- Lockfiles - which package manager is in use
- Config files - formatter, linter, bundler, ORM, IaC tool, test framework
- ADRs: `docs/adr/`, `docs/decisions/`, `adr/`, `docs/architecture/`
- Design docs: `docs/`, `ARCHITECTURE.md`, `DESIGN.md`
- Existing code - follow established patterns and conventions

When no convention exists and a choice is needed, present 2-3 options with a recommendation. Never silently pick a tool or library.

### ADRs and Design Docs

When working on architectural changes, new features, or reviewing design decisions:

- Scan for ADRs before proposing alternatives to established decisions
- Read relevant ADRs and design docs to understand prior context and constraints
- Flag when a change contradicts an existing ADR
- If the project uses ADRs, suggest creating one for new architectural decisions

### Command Discovery

**Never run build tools directly. Always use project scripts.**

Before running any build, test, lint, typecheck, or format command:

1. Read `package.json` scripts / `deno.json` tasks / `Makefile` targets / Python project config
2. Check for monorepo tooling (`turbo.json`, `nx.json`) — use the orchestrator, not raw tools
3. Check lockfiles to determine the right package manager

| Don't run directly | Check for script first                   |
| ------------------ | ---------------------------------------- |
| `tsc`              | `<pm> run typecheck` or `<pm> run build` |
| `eslint .`         | `<pm> run lint`                          |
| `prettier --write` | `<pm> run format`                        |
| `vitest run`       | `<pm> test`                              |
| `next build`       | `<pm> run build`                         |
| `cargo build`      | Check for `Makefile` or `just` tasks     |
| `terraform plan`   | Check for wrapper scripts or `Makefile`  |

`<pm>` = detected package manager (`npm`, `pnpm`, `yarn`, `bun`, `deno task`).

Projects configure flags, paths, and environment in their scripts. Running tools directly bypasses that.

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

### Formatting & Linting

- Detect formatter/linter from project config files
- If a project has a lint/format script, use that
- Never introduce a new formatter into a project that already has one

## Testing

- Test behavior, not implementation
- Mock only at boundaries (network, filesystem, external services)
- Never mock code modules
- Realistic test data (no "foo", "bar", "test123")
- TDD when feasible - write the test first
- Detect test framework from project config - don't assume

## Security

- Never commit secrets
- Validate all external input at boundaries
- Parameterized queries only (no string concatenation for SQL)
- Principle of least privilege
- Encrypt at rest and in transit by default
- Secrets in secret managers, never in env vars or code

## Git

- Conventional commits: `type(scope): description`
- Only commit when explicitly asked
- NEVER add Co-Authored-By, AI attribution, or generated-by markers to commits

## Workflow

For quick fixes and small tasks, just do the work directly.

For non-trivial work, use plan mode to research the codebase and design the approach. Once approved, implement with atomic conventional commits. Run tests and lint as you go.

Use judgement - if a task needs planning, plan it. If it doesn't, skip the ceremony.

## Agent Teams

Use agent teams when the task has **naturally parallel work** across different concerns. Don't use teams for sequential work that one agent can handle linearly.

### When to Use Teams

**Use a team when:**

- The task spans 2+ independent streams of work (e.g., API + tests, frontend + backend)
- Multiple files/modules can be worked on in parallel without conflicts
- The task benefits from separation of concerns (implementer doesn't review their own code)

**Stay solo when:**

- The task is sequential by nature (each step depends on the last)
- It's a bug fix, small feature, or refactor touching a few files
- The overhead of coordination exceeds the parallelism benefit

### Team Composition

Keep teams small. 2-3 teammates maximum. More agents means more coordination overhead, more context consumed, and more potential for conflicts.

**Standard compositions:**

| Task Type               | Team Shape                       |
| ----------------------- | -------------------------------- |
| Feature implementation  | 1 implementer + 1 test-writer    |
| Full-stack feature      | 1 frontend + 1 backend           |
| Large refactor          | 2 implementers (split by module) |
| Implementation + review | 1 implementer + 1 reviewer       |

**Agent type selection:**

- Implementation work → `general-purpose` (needs full tool access)
- Writing tests → `test-writer` (specialized, writes better tests)
- Code review → `code-reviewer` (specialized, read-only is fine)
- Research/exploration → `Explore` (fast, read-only)

### Team Lead Responsibilities

The team lead (you, the main session) does NOT implement. The lead:

1. **Plans** — break the task into atomic, well-defined subtasks
2. **Creates the branch** — one feature branch, all teammates work on it
3. **Creates the task list** — with clear dependencies using `blockedBy`
4. **Spawns teammates** — minimum viable team for the task
5. **Assigns initial tasks** — give each teammate their first task
6. **Monitors and unblocks** — reassign if someone's stuck, resolve conflicts
7. **Coordinates merges** — if teammates edit overlapping files, resolve conflicts
8. **Reviews and closes** — verify quality before shutting down the team

### Task Decomposition

Each task in the list should be:

- **Atomic** — one logical unit of work, completable independently
- **Well-scoped** — clear description of what "done" looks like
- **Ordered by dependency** — use `blockedBy` to enforce prerequisite ordering
- **Assignable** — any teammate with the right skills could pick it up

**Good task breakdown:**

```
Task 1: Create user schema and database migration
Task 2: Implement GET /users and GET /users/:id (blocked by 1)
Task 3: Implement POST /users with validation (blocked by 1)
Task 4: Implement PUT /users/:id and DELETE /users/:id (blocked by 1)
Task 5: Write integration tests for user endpoints (blocked by 2, 3, 4)
Task 6: Review implementation and tests (blocked by 5)
```

**Bad task breakdown:**

```
Task 1: Build the user API
Task 2: Write tests
```

### Branch Strategy

- The lead creates one feature branch before spawning teammates
- All teammates commit to the same branch
- Teammates work on **different files** to avoid merge conflicts
- If file overlap is unavoidable, sequence those tasks with `blockedBy`

### Quality Gates

These are enforced automatically by hooks:

- `task-completed` hook blocks completion if there are uncommitted code changes
- `teammate-idle` hook nudges teammates to commit before going idle
- `pre-commit` hook prevents commits to main/master
- `auto-format` hook formats code after every edit

Teammates must: run tests → commit with conventional message → then mark task complete.

### Communication

- Teammates message the lead when blocked, when they find issues, or when scope changes
- The lead messages teammates to reassign, unblock, or adjust scope
- Use `broadcast` sparingly — only for team-wide blockers
- Don't micromanage — trust teammates to work autonomously within their task scope

### Shutdown

When all tasks are complete:

1. Verify all tests pass on the branch
2. Run a final review if not already done
3. Send `shutdown_request` to each teammate
4. Clean up with `TeamDelete`
5. Report results to the user

## Context Compaction

When compacting, always preserve:

- Current task objective and progress
- The full list of modified files and their purposes
- Any test commands that have been run and their results
- Active branch name and commit history summary
- Team state: team name, active teammates, task list status, who's working on what

## What NOT to Do

- Don't add features beyond what's asked
- Don't refactor unrelated code
- Don't create abstractions for single use cases
- Don't design for hypothetical future requirements
- Don't use `// TODO` without a linked issue
- Don't assume tools or libraries - detect or ask
