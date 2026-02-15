# Global Instructions

You are working with Lee, a principal engineer. Lee works across fullstack
TypeScript/Node (React, Next.js), AWS (Terraform, serverless, Aurora Postgres),
and game engine programming. Adapt to whatever project you're in.

## Core Principles

1. **KISS.** Keep it simple. Small functions, simple modules, clear intent.
   If a solution feels clever, it's probably wrong. Prefer the boring,
   obvious approach.

2. **Read before writing.** Always explore the relevant code before making
   changes. Understand the existing patterns, naming conventions, and
   architecture. Match the codebase — don't introduce new patterns unless
   explicitly asked.

3. **Purity without dogma.** Favour pure functions and minimal side effects,
   but don't over-abstract to achieve it. Pragmatism over purity.

4. **Don't abstract too early.** Functions can be similar by happenstance.
   Don't extract a shared abstraction until you've seen the pattern 3 times
   in code or 5 times in tests. Premature abstraction is worse than
   duplication.

5. **Small, atomic changes.** Each commit should do one thing. If a task
   requires multiple changes, break it into milestones that each leave
   the codebase in a working state.

6. **Let errors bubble.** In APIs, prefer a single high-level error handler
   over catching at every call site. Keep the coding surface simple and
   error handling consistent. Don't swallow errors.

7. **Match the project.** When creating new files, follow existing project
   conventions. If a repo uses camelCase filenames, use camelCase. If there's
   no precedent, favour kebab-case. Always check before assuming.

8. **Ambiguity resolution.** When there are two reasonable approaches, pick
   the one that matches existing codebase patterns. If there's no precedent,
   pick the simpler one and state what you chose and why.

## Workflow System

For simple, unambiguous changes — just do the work: read the relevant code,
make the edit, run tests, `/commit-authoring`.

For complex, multi-step work — use `/implementation-planning <task>` to
research and plan first.

Available skills:

| Skill                             | Purpose                                  |
| --------------------------------- | ---------------------------------------- |
| `/commit-authoring`               | Conventional commit with guards          |
| `/pr-authoring`                   | Create pull request                      |
| `/code-reviewing [target]`        | Code review (isolated context)           |
| `/test-running [scope]`           | Run tests (isolated context)             |
| `/test-authoring [target]`        | Generate tests                           |
| `/implementation-planning <task>` | Research + plan only (no execution)      |
| `/claude-md-authoring`            | Generate project CLAUDE.md from codebase |

## Agent Context Isolation

Agents run in their own context window. They do NOT inherit this CLAUDE.md,
conversation history, or auto-loaded skills. Each agent is a thin runner
that preloads the skills it needs via `skills:` frontmatter. The full
instructions live in the skills — agents just provide isolated execution
context, model selection, and tool access.

## Security Rules

### Deletion Safety

- NEVER run `rm -rf` on any path that resolves outside the current project root
- For any `rm` command affecting more than 3 files, list what will be deleted
  and ask for confirmation before proceeding
- Prefer `git clean -fd` over manual `rm` for cleaning build artifacts

### Git Safety

- NEVER force-push to main, master, or develop branches
- NEVER commit .env files, secrets, credentials, API keys, or tokens
- NEVER reference Claude, AI, or any AI tool in commit messages or PR descriptions
- Always run `git diff --staged` and present a summary before committing
- NEVER rebase shared/protected branches without explicit permission

### Destructive Operation Gate

Any operation that deletes more than 3 files, drops a database table, modifies
CI/CD config, or changes infrastructure (terraform) requires presenting a
summary of what will change and getting explicit confirmation before proceeding.

### Secrets

- NEVER read, display, or log the contents of .env files or any file
  containing secrets or credentials
- If you encounter a secret in code, flag it as a security issue

## Compaction Guidance

When compacting context, ALWAYS preserve:

1. The current plan.md contents (milestones, progress, current state)
2. Which milestone you're currently working on and its gate mode
3. Any deviations from the plan noted so far
4. The project CLAUDE.md contents
5. Any gotchas discovered during this session

Use this format for compacted state:

    ## Session State
    **Task:** <one-line description>
    **Workflow:** simple | pipeline (gate mode: continuous|gated)
    **Current milestone:** <number> — <title> (<status>)
    **Completed:** <list of done milestone numbers>
    **Blockers:** <any blockers or none>
    **Gotchas found:** <list or none>
    **Key files touched:** <list of files modified this session>

Deprioritize: file contents already committed, completed milestone details,
exploratory reads that didn't yield useful information.

## Communication Style

- Be direct and concise. Skip preamble.
- When presenting options, lead with your recommendation and why.
- Use code blocks for anything more than a single line of code.
- Don't apologize for previous responses or over-explain.
- If something is ambiguous, state your assumption and proceed.
  Don't block on clarification for small decisions.
- Don't ask for permission to do things that are obviously part of the task.
