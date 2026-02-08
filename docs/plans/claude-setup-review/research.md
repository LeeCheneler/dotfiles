# Research: Claude Code Setup Review

## Task

Deeply review the Claude Code setup in the dotfiles repo. Understand the full CLAUDE.md configuration, custom skills/commands/agents, workflow system, MCP servers, hooks, settings, and the history of changes.

## Architecture Overview

The Claude Code configuration lives in `/Users/leecheneler/.dotfiles/config/claude/` and is symlinked into `~/.claude/` via the `apply.sh` > `scripts/ai.sh` setup script. This means the dotfiles repo is the source of truth, and `~/.claude/` contains symlinks pointing back to it.

### Directory Structure

```
~/.dotfiles/config/claude/
  CLAUDE.md              # Global instructions (symlinked to ~/.claude/CLAUDE.md)
  settings.json          # Permissions, hooks, MCP, plugins (symlinked to ~/.claude/settings.json)
  agents/                # 8 specialized sub-agents (symlinked to ~/.claude/agents/)
  skills/                # 7 skill-based workflow commands (symlinked to ~/.claude/skills/)
  hooks/                 # 5 Python hook scripts (symlinked to ~/.claude/hooks/)
```

### Symlink Status (Current State)

| Source                        | Target                    | Status                                          |
| ----------------------------- | ------------------------- | ----------------------------------------------- |
| `config/claude/CLAUDE.md`     | `~/.claude/CLAUDE.md`     | Working                                         |
| `config/claude/settings.json` | `~/.claude/settings.json` | Working                                         |
| `config/claude/agents/`       | `~/.claude/agents/`       | Working                                         |
| `config/claude/hooks/`        | `~/.claude/hooks/`        | Working                                         |
| `config/claude/skills/`       | `~/.claude/skills/`       | **MISSING** - symlink was never created         |
| `config/claude/commands/`     | `~/.claude/commands/`     | **BROKEN** - source dir was deleted in refactor |

**Issue**: The `commands` directory was deleted in commit `832cd40` when commands were migrated to skills. However, the old `~/.claude/commands` symlink (created Nov 27, 2025) still exists and now points to nothing. The new `~/.claude/skills` symlink has never been created because `apply.sh` / `ai.sh` has not been re-run since the skills migration. Running `apply.sh` would fix both issues -- it would create the skills symlink and the stale commands symlink would become irrelevant (Claude Code looks for skills, not commands).

## CLAUDE.md - Global Instructions

**File**: `/Users/leecheneler/.dotfiles/config/claude/CLAUDE.md` (101 lines)

This is the global instruction set applied to every Claude Code session. It covers:

### Philosophy

- Quality over speed
- Simple beats clever
- Security is non-negotiable
- DX matters

### Tech Stack

- **Frontend**: React, Next.js (App Router, server components default)
- **Backend**: Node.js, Next.js API routes
- **Infrastructure**: AWS (Lambda, ECS, SQS/EventBridge), Terraform
- **CI/CD**: GitHub Actions, Docker
- **Testing**: Vitest (preferred), Jest, Playwright (E2E)
- **Side projects**: Deno

### Code Style Rules

- TypeScript strict mode, no `any`, exhaustive switches, Zod at boundaries
- Naming: `kebab-case` files, `camelCase` vars, `PascalCase` types, `SCREAMING_SNAKE_CASE` constants, `is/has/should` boolean prefixes
- React: functional components only, `{ComponentName}Props` pattern, colocated code, server components default
- Formatting: check project first, use Biome for new projects

### Testing Philosophy

- Test behavior, not implementation
- Mock only at boundaries (network, filesystem, external services)
- Never mock code modules
- Realistic test data
- TDD when feasible
- 90% coverage minimum

### Workflow Guidance

Deliberately lightweight. Two modes:

1. **Quick fixes/small tasks**: Just do the work directly
2. **Non-trivial work**: Use `/begin <task>` for structured workflow with research, planning, signoff, then `/next` for commit-by-commit execution

### Context Compaction Guidance

When compacting, always preserve: modified files list, test command results, current plan state, active branch name and commit history summary.

### What NOT to Do

A list of anti-patterns: no scope creep, no unrelated refactoring, no unnecessary comments/abstractions/error handling, no TODOs without linked issues, no over-engineering.

## settings.json - Configuration

**File**: `/Users/leecheneler/.dotfiles/config/claude/settings.json`

### Environment Variables

- `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`: `"70"` -- triggers context compaction at 70% usage

### Permissions (Auto-Approved)

Broadly permissive for development workflows:

- All read/search tools: `Read`, `Glob`, `Grep`
- File system inspection: `basename`, `cat`, `diff`, `dirname`, `du`, `env`, `file`, `find`, `head`, `ls`, `pwd`, `realpath`, `stat`, `tail`, `tree`, `uname`, `wc`, `which`, `xargs`
- Full git access: `Bash(git:*)` (wildcard)
- Full GitHub CLI: `Bash(gh:*)`
- Full package manager access: `npm`, `npx`, `pnpm`, `bun`, `bunx`, `deno`, `node`
- Build/infra tools: `mise`, `cargo`, `docker`, `terraform`, `make`
- Web access: `WebSearch`, `WebFetch`

### Extended Thinking

- `alwaysThinkingEnabled`: `true`

### Additional Directories

- `~/projects` -- gives Claude visibility into other projects

### MCP Servers

- **Context7** (`@upstash/context7-mcp@latest`): Library documentation lookups via MCP

### Plugins

- **vtsls@claude-code-lsps**: TypeScript Language Server Protocol integration for type-aware code analysis

### settings.local.json (Project-Level Overrides)

**File**: `/Users/leecheneler/.dotfiles/.claude/settings.local.json`

Additional project-specific permissions for the dotfiles repo itself, including: `git commit`, `git push`, `git add`, `brew bundle`, various `mise` commands, `mkdir`, `chmod`, `shellcheck`, `grep`, and a specific `zsh -c 'source ~/.zshrc && update-apps'` command.

## Hooks System

Five Python hooks enforcing workflow discipline, configured in `settings.json` under the `hooks` key.

### PreToolUse Hooks

| Hook               | Matcher                | Purpose                                     | Behavior                                                                                                                                                                                              |
| ------------------ | ---------------------- | ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `protect-files.py` | `Bash` (all)           | Prevent deletion of files outside git repos | Intercepts `rm`, `rmdir`, `unlink` commands. If target path is outside any git repository, returns `permissionDecision: "ask"` to force user confirmation. Files inside git repos are allowed freely. |
| `pre-commit.py`    | `Bash(git commit:*)`   | Block commits on main                       | Exits with code 2 if on `main` branch, printing instructions to create a feature branch first. Feature branches pass through.                                                                         |
| `pre-pr.py`        | `Bash(gh pr create:*)` | Enforce PR description workflow             | Always exits with code 2 (blocks). Forces Claude to use the `pr-description` agent first, present the title/description, and get explicit user approval before retrying.                              |
| `pre-push.py`      | `Bash(git push:*)`     | Block push to main                          | Analyzes the push command to detect if pushing to main (including implicit push when on main branch). Blocks with instructions to ask user for confirmation. Allows feature branch pushes.            |

### PostToolUse Hooks

| Hook             | Matcher       | Purpose                         | Behavior                                                                                                                                                                                                                                                                  |
| ---------------- | ------------- | ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `auto-format.py` | `Edit\|Write` | Auto-format files after changes | Detects project formatter by walking up the directory tree looking for config files: Biome (`biome.json`/`biome.jsonc`), Prettier (various config files), or dprint (`dprint.json`). Runs the detected formatter on the changed file. Silent no-op if no formatter found. |

### Notification Hooks

| Hook               | Matcher    | Purpose                                                                                                         |
| ------------------ | ---------- | --------------------------------------------------------------------------------------------------------------- |
| macOS notification | `""` (all) | Sends macOS notification "Claude Code needs your attention" via `osascript` whenever Claude requires user input |

## Skills (Workflow Commands)

Skills replaced the previous `commands/` system in commit `832cd40`. They define the structured development workflow. Each skill is a `SKILL.md` file in its own directory under `config/claude/skills/`.

### /begin -- Start New Work

**File**: `/Users/leecheneler/.dotfiles/config/claude/skills/begin/SKILL.md`

The entry point for the structured workflow. Takes a task description as argument.

**Flow**:

1. **Safety checks**: Verify git state (warn if uncommitted changes or not on main)
2. **Resume check**: Look for existing plans in `docs/plans/*/plan.md` with status `IN_PROGRESS` or `READY`. Offer to resume if found.
3. **Generate task slug**: Create kebab-case directory `docs/plans/<slug>/`
4. **Research**: Delegate to `researcher` agent, output to `research.md`
5. **Plan**: Delegate to `planner` agent using research output, output to `plan.md`. Suggest ADRs if architectural decisions are made.
6. **Signoff**: Present summary of research findings and planned commits. **Stop and wait for explicit user approval.**
7. **Create branch**: `git checkout -b feat/<slug>` after approval
8. Prompt user to run `/next`

### /next -- Execute Next Commit Cycle

**File**: `/Users/leecheneler/.dotfiles/config/claude/skills/next/SKILL.md`

The execution loop. Each invocation handles one commit from the plan.

**Flow**:

1. **Find plan**: Locate active `plan.md` with `IN_PROGRESS` or `READY` status
2. **Find next commit**: First commit with unchecked `- [ ] Dev`
3. **Dev phase**: Implement code, use `test-writer` and `test-runner` agents, run lint/type-check. Check `- [x] Dev`.
4. **Review phase**: Use `code-reviewer` agent. Fix Critical/High immediately, note Medium/Low. Check `- [x] Review`.
5. **Present phase**: Show summary table (files changed, tests, review results) to user. **Stop and wait for approval.** Check `- [x] Present`.
6. **Commit phase**: Use `commit-message` agent to generate message. Present for approval. Execute commit. Record SHA in plan.md. Check `- [x] Commit`.
7. **After commit**: If more commits remain, prompt for `/next`. If last commit, suggest `/security-audit` then `/pr`.

### /status -- Show Plan Progress

Read-only display of active plan progress. Shows task, branch, current commit number, phase checklist status, and a table of all commits with their completion status. Always suggests next action.

### /review -- Run Code Review

Delegates to `code-reviewer` agent. Reviews changes vs main (if on feature branch) or uncommitted changes. Handles severity levels: fix Critical/High immediately, note Medium/Low. Updates plan.md if in active plan.

### /security-audit -- Security Audit

Delegates to `security-auditor` agent on all changes compared to main. Critical issues must be fixed before PR. High issues presented to user for decision. Outputs PASS/FAIL verdict.

### /pr -- Open Pull Request

**Flow**:

1. Verify all commits have `- [x] Commit` in plan
2. Recommend `/security-audit` if not already run
3. Push branch: `git push -u origin <branch>`
4. Generate PR description via `pr-description` agent
5. Present PR preview for approval. **Wait for approval.**
6. Create PR via `gh pr create`
7. Clean up: remove `docs/plans/<slug>/` directory
8. Report PR URL

### /abort -- Abort Plan

Safe abort with multiple confirmation steps:

1. Show current state (task, branch, progress, uncommitted changes)
2. Require user to type "abort" explicitly
3. Offer cleanup options: keep everything (default/safest), discard uncommitted only, delete branch and changes
4. Update plan.md status to `ABORTED`

## Agents (Sub-Agents)

Eight specialized agents for delegated work. Each has a YAML frontmatter header specifying name, description, allowed tools, and model.

### Agent Summary

| Agent              | Model  | Tools                               | Purpose                                                                                                                                                                         |
| ------------------ | ------ | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `researcher`       | opus   | Read, Grep, Glob, Bash, Task, Write | Deep codebase exploration. Reads docs, ADRs, plans, vision files. Checks GitHub issues/PRs via `gh`. Outputs structured `research.md`.                                          |
| `planner`          | opus   | Read, Grep, Glob, Write             | Creates `plan.md` with atomic commits, checklists, file lists, dependencies, risks, and out-of-scope items.                                                                     |
| `code-reviewer`    | sonnet | Read, Grep, Glob, Bash              | Adaptive-depth code review (quick scan / standard / deep). Severity classification (Critical/High/Medium/Low). Can recommend delegating to `security-auditor` or `test-writer`. |
| `security-auditor` | opus   | Read, Grep, Glob, Bash              | OWASP Top 10 audit, dependency audits, secret detection, AWS IAM review, Terraform security checks. Only reports Critical and High issues.                                      |
| `test-writer`      | sonnet | Read, Grep, Glob, Write, Edit, Bash | Generates tests following black-box, behavior-focused philosophy. Supports Vitest, Jest, Playwright, Deno.test. Includes test factory patterns.                                 |
| `test-runner`      | haiku  | Bash, Read, Glob                    | Runs tests and returns minimal structured output (pass/fail/count/coverage). Designed to minimize context consumption.                                                          |
| `commit-message`   | haiku  | Bash, Read, Grep, Glob              | Generates conventional commit messages. Explains "why" not "what". Suggests splitting large commits. Explicitly does NOT add AI attribution.                                    |
| `pr-description`   | sonnet | Bash, Read, Grep, Glob              | Generates PR descriptions adapted to PR size (small/medium/large). Includes summary, changes, context, testing, screenshots, migration sections as appropriate.                 |

### Model Selection Rationale

The model choices reflect a cost/capability tradeoff:

- **opus**: Used for high-stakes analysis (research, planning, security audit) where depth matters
- **sonnet**: Used for medium-complexity tasks (code review, test writing, PR descriptions)
- **haiku**: Used for simple, structured tasks (test running, commit messages) where speed and low cost matter

## Plan File Format

Plans are stored in `docs/plans/<task-slug>/` with two files:

### research.md

Output of the `researcher` agent. Contains: task description, codebase overview, relevant files table, existing patterns with code examples, documentation found (vision, ADRs, READMEs), key considerations, recommended approach, and open questions.

### plan.md

Output of the `planner` agent. Structure:

```markdown
# Plan: <Feature Name>

## Metadata

- **Task:** <description>
- **Branch:** feat/<slug>
- **Status:** READY | IN_PROGRESS | COMPLETE | ABORTED
- **Created:** <date>

## Summary

<overview>

## Commits

### 1. <Commit title>

**Goal:** <what this achieves>
**Files:**

- Create: `path/to/file.ts`
- Modify: `path/to/file.ts`

**Checklist:**

- [ ] Dev
- [ ] Review
- [ ] Present
- [ ] Commit

**SHA:** _pending_

## Dependencies / Risks / Out of Scope / Notes
```

Each commit has a 4-phase checklist (Dev, Review, Present, Commit) that `/next` checks off as it progresses. The SHA field is filled in after the commit is created.

## Workflow Lifecycle (Complete Flow)

```
/begin <task>
  |
  +--> Safety checks (git status, branch)
  +--> Resume check (existing plans?)
  +--> researcher agent --> docs/plans/<slug>/research.md
  +--> planner agent --> docs/plans/<slug>/plan.md
  +--> User signoff (STOP)
  +--> git checkout -b feat/<slug>
  |
/next (repeat for each commit)
  |
  +--> Find next unchecked commit in plan.md
  +--> Dev: implement + test-writer + test-runner + lint
  +--> Review: code-reviewer agent (fix Critical/High)
  +--> Present: summary to user (STOP)
  +--> Commit: commit-message agent --> git commit (STOP)
  |
/security-audit (optional but recommended)
  |
  +--> security-auditor agent on full changeset
  +--> Fix Critical issues
  |
/pr
  |
  +--> Verify all commits complete
  +--> git push -u origin <branch>
  +--> pr-description agent
  +--> User approval (STOP)
  +--> gh pr create
  +--> Cleanup plan files
```

There are 4 explicit user approval gates:

1. Plan signoff in `/begin`
2. Implementation approval in `/next` (present phase)
3. Commit message approval in `/next` (commit phase)
4. PR description approval in `/pr`

## Git History - Evolution of the Setup

### Phase 1: Initial Hooks (Nov 2025)

- **877963c**: First Claude hooks added for workflow enforcement
- **b4384a3**: Workflow framework with research and planning agents
- Plan/research/signoff commands were individual commands

### Phase 2: MCP Servers (Dec 2025)

- **7e5caf9**: Added Memory MCP server and GitHub MCP server
- **b605ddd**: Added `/remember` command and memory integration
- **6bf3e55**: Added `/recollect` command

### Phase 3: MCP Cleanup (Jan 2026)

- **f8a1b00**: Removed Memory MCP server and memory commands (not useful enough)
- **d30fe92**: Removed GitHub MCP server, replaced with `gh` CLI (simpler, more reliable)

### Phase 4: Major Streamline (Feb 5, 2026)

- **f9e8b06**: Massive refactor (-2584 lines). Rewrote CLAUDE.md. Consolidated 14 commands down to 7 by absorbing phase commands (`/research`, `/plan`, `/signoff`, `/dev`, `/present`, `/commit`, `/resume`) into `/begin` and `/next`. Removed 3 agents (`doc-writer`, `refactor-advisor`, `git-summarizer`).

### Phase 5: Skills + Features (Feb 7-8, 2026)

- **832cd40**: Migrated commands to skills format. Added auto-format hook, Context7 MCP server, TypeScript LSP plugin, macOS notifications, context compaction settings, statusline.
- **67d3384**: Removed statusline (most recent commit).

### Removed Features (historical)

- Memory MCP server and `/remember`/`/recollect` commands
- GitHub MCP server (replaced by `gh` CLI)
- `doc-writer` agent (functionality handled inline)
- `refactor-advisor` agent (functionality handled inline)
- `git-summarizer` agent (functionality handled inline)
- Individual phase commands (`/research`, `/plan`, `/signoff`, `/dev`, `/present`, `/commit`, `/resume`)
- Statusline script

## Project Bootstrapping

### init-claude Script

**File**: `/Users/leecheneler/.dotfiles/bin/init-claude`

A shell script that creates `.claude/` in the current project directory and prints a prompt for the user to paste into Claude Code. The prompt instructs Claude to analyze the codebase and generate a project-specific `.claude/CLAUDE.md` that complements (not duplicates) the global config.

### ai.sh Setup Script

**File**: `/Users/leecheneler/.dotfiles/scripts/ai.sh`

Run as part of `apply.sh`. Creates `~/.claude/` directory and symlinks:

- `CLAUDE.md`
- `settings.json`
- `statusline.sh` (currently dead reference -- file was deleted in `67d3384`)
- `skills/` directory
- `hooks/` directory
- `agents/` directory

Also installs TypeScript LSP server globally (`@vtsls/language-server` + `typescript`) and prints instructions for manual plugin installation.

## Known Issues

### 1. Broken `commands` Symlink

`~/.claude/commands` is a symlink to `/Users/leecheneler/.dotfiles/config/claude/commands` which no longer exists. The commands directory was deleted when migrating to skills. This is cosmetic -- Claude Code uses skills now, not commands.

### 2. Missing `skills` Symlink

`~/.claude/skills` does not exist. The `ai.sh` script creates this symlink, but it hasn't been re-run since the skills were added in commit `832cd40`. The skills exist in the dotfiles source at `config/claude/skills/` but are not accessible to Claude Code because the symlink is missing.

**Impact**: The `/begin`, `/next`, `/status`, `/review`, `/security-audit`, `/pr`, and `/abort` skills are currently not available in Claude Code sessions. Running `apply.sh` (or just `scripts/ai.sh`) would fix this.

### 3. Dead `statusline.sh` Reference in `ai.sh`

The `ai.sh` script has a `backup_and_link` call for `statusline.sh` and a `chmod +x` on it, but the file was deleted in commit `67d3384`. This would cause an error if `ai.sh` is re-run.

## Key Considerations

- The setup is heavily symlink-based. All source files live in the dotfiles repo; `~/.claude/` is just symlinks. This means changes to the dotfiles repo are immediately reflected in Claude Code sessions (for working symlinks).

- The workflow system has multiple explicit user gates. Claude cannot commit, push to main, create PRs, or skip plan approval without user input. This is enforced both by skill instructions (soft) and by hooks (hard).

- The hook system uses Python scripts that receive JSON on stdin and communicate back via exit codes (0 = allow, 2 = block) and stderr messages. The `protect-files.py` hook uses a different mechanism -- it outputs JSON with `permissionDecision: "ask"` to trigger a user prompt.

- Model selection across agents is deliberate: opus for deep analysis, sonnet for medium tasks, haiku for simple structured output.

- The system has gone through significant consolidation. Starting from 14 commands + 11 agents, it's now at 7 skills + 8 agents. The trend is toward simplification.

- Plan files (`docs/plans/<slug>/`) are ephemeral -- they're created during `/begin`, tracked during `/next`, and deleted after `/pr`. No plans currently exist in the repo.

## Recommended Next Steps

1. **Run `apply.sh`** (or just `scripts/ai.sh`) to create the missing `skills` symlink and fix the broken state.

2. **Fix `ai.sh`** to remove the dead `statusline.sh` references before running it, or the script will error on the backup_and_link call for the deleted file.

3. **Clean up the stale `~/.claude/commands` symlink** -- either remove it manually or add cleanup logic to `ai.sh`.

## Open Questions

None -- research is sufficient for understanding the current state.
