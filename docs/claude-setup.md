# Claude Code Setup

Configuration for Claude Code CLI tool.

## Directory Structure

```
~/.dotfiles/config/claude/
├── agents/           # Specialized task agents
├── hooks/            # Operation enforcement hooks
├── skills/           # Slash commands
├── CLAUDE.md         # Global instructions
└── settings.json     # Permissions, hooks, MCP servers
```

Symlinked to `~/.claude/` via `apply.sh`.

## Hooks

### PreToolUse (block before execution)

| Hook               | Trigger        | Behavior                                                |
| ------------------ | -------------- | ------------------------------------------------------- |
| `protect-files.py` | `Bash`         | Asks permission before deleting files outside git repos |
| `pre-commit.py`    | `git commit`   | Blocks commits on main; allows feature branches through |
| `pre-pr.py`        | `gh pr create` | Blocks until PR description approved by user            |
| `pre-push.py`      | `git push`     | Blocks push to main; allows feature branches            |

### PostToolUse (run after execution)

| Hook             | Trigger       | Behavior                                                    |
| ---------------- | ------------- | ----------------------------------------------------------- |
| `auto-format.py` | `Edit\|Write` | Auto-formats files with Biome/Prettier/dprint after editing |

### Notification

macOS notification when Claude needs attention.

All blocking hooks exit code 2, with instructions in stderr.

## Agents

| Agent            | Model  | Purpose                                     |
| ---------------- | ------ | ------------------------------------------- |
| `code-reviewer`  | sonnet | Review implementation, design, tests        |
| `test-writer`    | sonnet | Generate tests following black-box approach |
| `test-runner`    | haiku  | Run tests, return concise pass/fail summary |
| `commit-message` | haiku  | Generate conventional commit messages       |
| `pr-description` | sonnet | Generate PR titles and descriptions         |

`code-reviewer` has project-scoped memory enabled to learn codebase patterns over time.

## Skills

| Command   | Purpose                              |
| --------- | ------------------------------------ |
| `/commit` | Generate commit from staged changes  |
| `/review` | Run code review on current changes   |
| `/pr`     | Open pull request for current branch |

## MCP Servers

| Server     | Purpose                                   |
| ---------- | ----------------------------------------- |
| `context7` | Up-to-date library documentation for LLMs |

## Plugins

| Plugin                   | Purpose                    |
| ------------------------ | -------------------------- |
| `vtsls@claude-code-lsps` | TypeScript LSP integration |

## Settings Overview

Key configuration in `settings.json`:

- **Permissions**: Auto-allow Read, Edit, Write, Glob, Grep, common CLI tools, git, gh, npm/pnpm/bun/deno, docker, terraform
- **Denied Bash**: `cat`, `head`, `tail`, `find` removed to enforce use of dedicated Read/Glob tools
- **Extended thinking**: Always enabled
- **Additional directories**: `~/projects`

## GitHub Integration

Agents use the `gh` CLI (installed via Brewfile) for GitHub access. Authenticate with:

```bash
gh auth login
```

## Troubleshooting

**Commands not appearing:**

- Start new Claude Code session (skills load at startup)

**Hook not triggering:**

- Check `~/.claude/settings.json` symlink exists
- Verify hook scripts are executable (`chmod +x`)

**Auto-format not working:**

- Ensure project has a formatter config (biome.json, .prettierrc, dprint.json)
- Check hook output for warnings (formatter exit code is now logged)
