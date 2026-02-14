# Claude Code Setup

Configuration for Claude Code CLI tool.

## Directory Structure

```
~/.dotfiles/config/claude/
├── CLAUDE.md             # Global instructions
├── settings.json         # Permissions, hooks
├── commands/             # Slash commands (explicit invocation)
│   ├── workflow.md       # Auto-route to Simple or Pipeline
│   ├── commit.md         # Conventional commit with guards
│   ├── pr.md             # Create pull request
│   ├── review.md         # Code review
│   ├── test.md           # Run tests
│   ├── write-tests.md    # Generate tests
│   ├── plan.md           # Research + plan (no execution)
│   ├── init-project.md   # Generate project CLAUDE.md
│   └── refresh-project.md # Update project CLAUDE.md
├── skills/               # Auto-discovered conventions
│   ├── coding-standards/
│   ├── test-conventions/
│   └── commit-conventions/
├── agents/               # Sub-agents for pipeline delegation
│   ├── researcher.md
│   ├── planner.md
│   ├── coder.md
│   ├── reviewer.md
│   ├── test-writer.md
│   └── test-runner.md
└── docs/                 # Architecture and workflow documentation
    ├── ARCHITECTURE.md
    ├── WORKFLOWS.md
    └── CONVENTIONS.md
```

Symlinked to `~/.claude/` via `scripts/ai.sh`.

## Commands

| Command            | Purpose                                   |
| ------------------ | ----------------------------------------- |
| `/workflow <task>` | Auto-route to Simple or Pipeline workflow |
| `/commit`          | Conventional commit with guards           |
| `/pr`              | Create pull request                       |
| `/review [target]` | Code review                               |
| `/test [scope]`    | Run tests                                 |
| `/write-tests`     | Generate tests                            |
| `/plan <task>`     | Research + plan only (no execution)       |
| `/init-project`    | Generate project CLAUDE.md from codebase  |
| `/refresh-project` | Update existing project CLAUDE.md         |

## Agents

| Agent         | Purpose                                           |
| ------------- | ------------------------------------------------- |
| `researcher`  | Deep codebase exploration for pipeline research   |
| `planner`     | Milestone-based implementation planning           |
| `coder`       | Focused code changes during pipeline execution    |
| `reviewer`    | Code review for correctness, security, simplicity |
| `test-writer` | Generate behavior-focused tests                   |
| `test-runner` | Run tests, return concise pass/fail summary       |

## Skills

Auto-applied based on context — no explicit invocation needed.

| Skill                | Applied when...                            |
| -------------------- | ------------------------------------------ |
| `coding-standards`   | Writing, editing, or reviewing code        |
| `test-conventions`   | Writing, generating, or reviewing tests    |
| `commit-conventions` | Creating commits or planning commit splits |

## Hooks

### PreToolUse

| Matcher | Type   | Behavior                                                                |
| ------- | ------ | ----------------------------------------------------------------------- |
| `Bash`  | prompt | Evaluates commands for dangerous operations (rm outside project, force  |
|         |        | push to protected branches, terraform destroy, dropping tables). Blocks |
|         |        | if dangerous, approves if safe.                                         |

### Stop

| Matcher | Type    | Behavior                               |
| ------- | ------- | -------------------------------------- |
| (all)   | command | macOS notification when task completes |

## Security Model

Three independent layers — if one fails, the others still protect:

1. **Permissions** (`settings.json`) — declarative deny/ask/allow rules
2. **Hooks** (`settings.json`) — prompt-based PreToolUse evaluation
3. **CLAUDE.md directives** — behavioral rules (deletion safety, git safety, secrets)

### Permissions Summary

- **Denied:** Reading .env/secrets/credentials files, `rm -rf /`, `rm -rf ~`
- **Ask:** Force push, rebase, hard reset, `rm -rf`, terraform apply/destroy, AWS CLI
- **Allowed:** Git operations, package managers, common CLI tools, `gh`

## Workflows

Two workflows, routed by `/workflow`:

- **Simple** — single-concern changes. Read → edit → test → commit.
- **Pipeline** — multi-step work. Research → plan → gate → execute → finalize.

Pipeline uses gate modes (continuous or gated) and working docs in `docs/work/<slug>/`.

See `config/claude/docs/WORKFLOWS.md` for full documentation.

## Project Setup

Run `/init-project` inside a Claude Code session to generate a project-specific `CLAUDE.md` at the project root. This analyzes the repo deeply — stack, conventions, architecture, testing patterns, gotchas.

Run `/refresh-project` to update it later without losing manual additions.

## Plugins

| Plugin                   | Purpose                    |
| ------------------------ | -------------------------- |
| `vtsls@claude-code-lsps` | TypeScript LSP integration |

## GitHub Integration

Uses the `gh` CLI (installed via Brewfile) for GitHub access. Authenticate with:

```bash
gh auth login
```

## Troubleshooting

**Commands not appearing:**

- Start a new Claude Code session (commands/skills load at startup)

**Hook not triggering:**

- Check `~/.claude/settings.json` symlink exists and points to `~/.dotfiles/config/claude/settings.json`

**Skills not applying:**

- Verify `~/.claude/skills` symlink exists
- Skills are auto-discovered from SKILL.md frontmatter `description` field
