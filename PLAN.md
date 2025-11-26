# Dotfiles Enhancement Plan

## Overview

Enhance the dotfiles repository with VSCode management, Claude Code agents, and world-class AI instruction files.

## Goals

1. **VSCode Management** - Declarative extension list and symlinked settings
2. **Claude Code Agents** - 7 specialized agents for common development tasks
3. **World-class CLAUDE.md** - Comprehensive global instructions reflecting testing philosophy and code standards
4. **Copilot Instructions Template** - Concise, pattern-focused template for per-project use

---

## Phase 1: VSCode Management

### Files to Create

```
config/vscode/
├── settings.json      # VSCode settings (symlinked to ~/Library/Application Support/Code/User/)
└── extensions.txt     # One extension ID per line
```

### Script: `scripts/vscode.sh`

```bash
# Symlink settings.json to VSCode user settings location
# Install extensions from extensions.txt via: code --install-extension <id>
```

### Proposed Extensions

**Core:**

- `esbenp.prettier-vscode` - Code formatting
- `dbaeumer.vscode-eslint` - Linting
- `bradlc.vscode-tailwindcss` - Tailwind IntelliSense

**TypeScript/React:**

- `ms-vscode.vscode-typescript-next` - Latest TS features
- `dsznajder.es7-react-js-snippets` - React snippets
- `formulahendry.auto-rename-tag` - Auto rename HTML/JSX tags

**Testing:**

- `vitest.explorer` - Vitest integration
- `ms-playwright.playwright` - Playwright test runner

**Git:**

- `eamodio.gitlens` - Git supercharged
- `mhutchie.git-graph` - Visual git history

**AI:**

- `github.copilot` - GitHub Copilot
- `github.copilot-chat` - Copilot Chat

**DX:**

- `usernamehw.errorlens` - Inline error display
- `christian-kohler.path-intellisense` - Path autocomplete
- `mikestead.dotenv` - .env syntax highlighting
- `redhat.vscode-yaml` - YAML support
- `hashicorp.terraform` - Terraform support
- `denoland.vscode-deno` - Deno support

**Theme/UI:**

- `enkia.tokyo-night` - Tokyo Night theme (matches Kitty)
- `pkief.material-icon-theme` - File icons

### Update `apply.sh`

Add `scripts/vscode.sh` to the execution sequence (after packages.sh, since VSCode must be installed first).

---

## Phase 2: Claude Code Agents

### Agent Definitions

Create 7 agents in `config/claude/agents/`:

#### 1. `code-reviewer.md`

**Purpose:** Review code changes for quality, patterns, and potential issues
**Focus:**

- Adherence to project patterns
- TypeScript best practices (no `any`, proper types)
- Security concerns (OWASP awareness)
- Simplicity and readability
- Unnecessary complexity or over-engineering

#### 2. `test-writer.md`

**Purpose:** Generate tests following the testing philosophy
**Focus:**

- Black-box testing approach
- Test behavior, not implementation
- Mock only at boundaries (network, external services)
- Never mock code modules
- Realistic test data
- Integration tests over unit tests where appropriate
- Arrange-Act-Assert pattern

#### 3. `doc-writer.md`

**Purpose:** Generate clear, useful documentation
**Focus:**

- README structure for projects
- API documentation
- Architecture decision records (ADRs)
- Inline JSDoc only where genuinely helpful
- Avoid redundant comments

#### 4. `refactor-advisor.md`

**Purpose:** Suggest refactoring opportunities
**Focus:**

- Identify code smells
- Suggest simplifications
- Find opportunities to reduce duplication
- Propose better abstractions (only when warranted)
- Performance improvements
- Never suggest refactoring for its own sake

#### 5. `security-auditor.md`

**Purpose:** Audit code for security vulnerabilities
**Focus:**

- OWASP Top 10 awareness
- Input validation (Zod boundaries)
- SQL injection (parameterized queries)
- XSS prevention
- Secrets in code
- Dependency vulnerabilities
- AWS IAM least privilege

#### 6. `commit-message.md`

**Purpose:** Generate conventional commit messages
**Focus:**

- Conventional commits format
- Clear, concise descriptions
- Focus on "why" not "what"
- Scope when appropriate
- Breaking change notation

#### 7. `pr-description.md`

**Purpose:** Generate comprehensive PR descriptions
**Focus:**

- Summary of changes
- Motivation/context
- Testing performed
- Screenshots if UI changes
- Migration steps if needed
- Checklist for reviewers

---

## Phase 3: World-Class CLAUDE.md

### Structure

```markdown
# Claude Configuration

## Identity

Brief context about the developer and their preferences.

## Core Principles

- Quality over speed
- Simple beats clever
- Security is non-negotiable
- DX matters

## Code Style

### General

- Explicit over implicit
- Composition over inheritance
- Fail fast with clear errors

### TypeScript

- Strict mode always
- No `any` - use `unknown` and narrow
- Prefer interfaces for objects, types for unions/primitives
- Use `as const` for literal types
- Exhaustive switch statements with `never`

### Naming

- Files: kebab-case
- Variables/functions: camelCase
- Components/Classes/Types: PascalCase
- Constants: SCREAMING_SNAKE_CASE
- Boolean variables: is/has/should prefix

### React

- Functional components only
- Custom hooks for shared logic
- Colocate related code
- Props interfaces named `{Component}Props`

## Testing Philosophy

### Core Beliefs

- Test behavior, not implementation
- Tests are documentation
- If it's hard to test, the design needs work

### Rules

1. **Black-box testing** - test inputs and outputs, not internals
2. **Units of behavior** - a "unit" is a behavior, not a function/class
3. **Mock only at boundaries** - network, filesystem, external services
4. **Never mock code modules** - if you need to mock internal code, redesign it
5. **Realistic test data** - no "foo", "bar", "test123"
6. **Prefer integration tests** - exercise real code paths
7. **Test-first when possible** - write the test, then the code

### Patterns

- Arrange-Act-Assert structure
- One assertion per test (conceptually)
- Descriptive test names: "should {behavior} when {condition}"
- Use test factories for complex data

## Architecture Preferences

### General

- Feature-based folder structure
- Dependency injection for testability
- Validate at boundaries with Zod
- Errors are values, not exceptions (where practical)

### React/Next.js

- Server components by default
- Client components only when needed
- Colocate components, hooks, and tests
- API routes as thin controllers

### AWS/Infrastructure

- Infrastructure as code (Terraform)
- Least privilege IAM
- Prefer managed services
- Design for failure

## Tech Stack Context

### Primary Languages

- TypeScript (strict mode)
- SQL (PostgreSQL)

### Frameworks & Libraries

- React, Next.js
- Node.js, Deno
- Zod (validation)
- Vitest/Jest (testing)
- Testing Library (React testing)
- Playwright (E2E)

### Infrastructure

- AWS: ECS, Lambda, SQS, RDS Aurora (PostgreSQL), DynamoDB
- Terraform
- Docker

## Security Rules

1. Never commit secrets (use environment variables)
2. Validate all external input at boundaries
3. Use parameterized queries (never string concatenation for SQL)
4. Sanitize output to prevent XSS
5. HTTPS everywhere
6. Principle of least privilege
7. Keep dependencies updated
8. Audit npm packages before adding

## Git Practices

1. Conventional commits: `type(scope): description`
2. Atomic commits (one logical change)
3. Clear, descriptive PR descriptions
4. Only commit when explicitly asked
5. Never force push to main/master

## What NOT to Do

- Don't add features beyond what's asked
- Don't refactor unrelated code
- Don't add comments to code you didn't change
- Don't add types/interfaces "just in case"
- Don't create abstractions for single use cases
- Don't design for hypothetical future requirements
- Don't add error handling for impossible scenarios
- Don't use `// TODO` without a linked issue
```

---

## Phase 4: Copilot Instructions Template

### Structure

More concise, pattern-focused for inline completions:

```markdown
# Copilot Instructions

## Code Style

- TypeScript strict mode, no `any`
- kebab-case files, camelCase variables, PascalCase components
- Functional React components with hooks
- Zod for runtime validation at boundaries

## Testing

- Black-box tests: test behavior, not implementation
- Mock only network/external boundaries, never code modules
- Descriptive names: "should {behavior} when {condition}"
- Arrange-Act-Assert pattern

## Patterns

### React Component

- Props interface: `{ComponentName}Props`
- Export named, not default
- Colocate styles and tests

### API Handler

- Validate input with Zod schema
- Return typed responses
- Handle errors explicitly

### Test

- Use Testing Library queries
- Avoid implementation details
- Test user interactions

## Don't

- Add features beyond the request
- Create abstractions prematurely
- Mock internal modules
- Use `any` type
```

---

## Phase 5: Integration

### Update `scripts/ai.sh`

Ensure all new files are symlinked:

- `~/.claude/CLAUDE.md`
- `~/.claude/settings.json`
- `~/.claude/agents/` (directory)
- `~/.claude/hooks/` (directory)

### Update `bin/init-copilot`

Already exists - no changes needed.

### Consider: `bin/init-claude`

New command to bootstrap per-project Claude configuration:

- Creates `.claude/` directory
- Copies template from `config/claude/templates/project.md`
- Similar pattern to `init-copilot`

---

## Implementation Order

1. [ ] Phase 1: VSCode Management

   - [ ] Create `config/vscode/settings.json`
   - [ ] Create `config/vscode/extensions.txt`
   - [ ] Create `scripts/vscode.sh`
   - [ ] Update `apply.sh`

2. [ ] Phase 2: Claude Code Agents

   - [ ] Create `config/claude/agents/code-reviewer.md`
   - [ ] Create `config/claude/agents/test-writer.md`
   - [ ] Create `config/claude/agents/doc-writer.md`
   - [ ] Create `config/claude/agents/refactor-advisor.md`
   - [ ] Create `config/claude/agents/security-auditor.md`
   - [ ] Create `config/claude/agents/commit-message.md`
   - [ ] Create `config/claude/agents/pr-description.md`

3. [ ] Phase 3: World-Class CLAUDE.md

   - [ ] Rewrite `config/claude/CLAUDE.md`
   - [ ] Create `config/claude/templates/project.md`

4. [ ] Phase 4: Copilot Instructions

   - [ ] Rewrite `config/copilot/copilot-instructions.md`

5. [ ] Phase 5: Integration
   - [ ] Verify `scripts/ai.sh` handles new structure
   - [ ] Create `bin/init-claude` command
   - [ ] Test full `apply.sh` run

---

## Open Questions

1. **VSCode settings sync**: Do you use VSCode's built-in Settings Sync? If so, we may want to disable it to avoid conflicts with symlinked settings.

2. **Extension categories**: Should we split extensions into required vs optional? Some may not apply to all machines.

3. **Agent invocation**: How do you want to invoke agents? Via Claude Code's Task tool, or as slash commands?

4. **Per-project templates**: What additional context should the project templates include? (Architecture diagrams, API conventions, etc.)

---

## Notes

- All new scripts will follow existing patterns (set -euo pipefail, helpers.sh, idempotent)
- Pre-commit hooks will automatically format new markdown/json files
- Agents are markdown files that Claude Code reads to understand specialized tasks
