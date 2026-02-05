# Claude Code Setup

Configuration for Claude Code CLI tool.

## Directory Structure

```
~/.dotfiles/config/claude/
├── agents/           # Specialized task agents
├── commands/         # Slash commands
├── hooks/            # Git operation hooks
├── CLAUDE.md         # Global instructions
└── settings.json     # Permissions and configuration
```

Symlinked to `~/.claude/` via `apply.sh`.

## Hooks

Operation enforcement via `PreToolUse` hooks.

| Hook               | Trigger        | Behavior                                                 |
| ------------------ | -------------- | -------------------------------------------------------- |
| `protect-files.py` | `Bash`         | Asks permission before deleting files outside ~/projects |
| `pre-commit.py`    | `git commit`   | Blocks until approval; on main asks about new branch     |
| `pre-pr.py`        | `gh pr create` | Blocks until PR description approved                     |
| `pre-push.py`      | `git push`     | Blocks push to main; allows feature branches             |

All hooks exit code 2 to block, with instructions in stderr.

## Agents

Specialized agents for delegated work.

| Agent              | Purpose                                           |
| ------------------ | ------------------------------------------------- |
| `researcher`       | Deep codebase exploration for a task              |
| `planner`          | Create implementation plans with commit breakdown |
| `code-reviewer`    | Review implementation, design, tests              |
| `security-auditor` | Security vulnerabilities and best practices       |
| `test-writer`      | Generate tests following black-box approach       |
| `test-runner`      | Run tests, return concise pass/fail summary       |
| `commit-message`   | Generate conventional commit messages             |
| `pr-description`   | Generate PR titles and descriptions               |

## Workflow

### Overview

```
/begin ─► RESEARCH ─► PLAN ─► SIGNOFF ─► EXECUTE ─► /pr
              │          │        │          │
              ▼          ▼        ▼          ▼
         research.md  plan.md  branch    per-commit
                                created      loop
```

### Execute Loop (per commit via /next)

```
DEV ─► REVIEW ─► PRESENT ─► COMMIT
 │        │          │
 ▼        ▼          ▼
tests  code-review  user
       & fix issues approval
```

### Commands

| Command           | Purpose                                         |
| ----------------- | ----------------------------------------------- |
| `/begin <task>`   | Start new work: research, plan, signoff, branch |
| `/next`           | Execute next commit cycle                       |
| `/status`         | Show current plan progress                      |
| `/review`         | Run code review on current changes              |
| `/abort`          | Abort current plan safely                       |
| `/security-audit` | Run security audit on all branch changes        |
| `/pr`             | Open pull request                               |

### Plan Files

Plans persist in `docs/plans/<task-slug>/`:

```
docs/plans/user-authentication/
├── research.md    # Codebase findings, patterns, recommendations
└── plan.md        # Commit breakdown with checklists
```

### Typical Usage

```bash
# Start new work
/begin add user authentication to the API

# Execute commits one at a time
/next

# Check progress
/status

# Security audit before PR
/security-audit

# Open PR
/pr
```

## GitHub Integration

Agents use the `gh` CLI (installed via Brewfile) for GitHub access. Authenticate with:

```bash
gh auth login
```

## Configuration

### settings.json

```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep", "Bash(git:*)", "Bash(gh:*)", ...],
    "deny": [],
    "defaultMode": "default"
  },
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": ["protect-files.py"] },
      { "matcher": "Bash(git commit:*)", "hooks": ["pre-commit.py"] },
      { "matcher": "Bash(gh pr create:*)", "hooks": ["pre-pr.py"] },
      { "matcher": "Bash(git push:*)", "hooks": ["pre-push.py"] }
    ]
  }
}
```

### CLAUDE.md

Global instructions covering:

- Philosophy (quality, simplicity, security)
- Tech stack (TypeScript, Next.js, AWS, Terraform)
- Code style (TypeScript, naming, React, formatting)
- Testing approach
- Git conventions
- Workflow guidance
- What not to do

## Troubleshooting

**Commands not appearing:**

- Start new Claude Code session (commands load at startup)

**Hook not triggering:**

- Check `~/.claude/settings.json` symlink exists
- Verify hook scripts are executable (`chmod +x`)

**Plan not found:**

- Ensure `docs/plans/` directory exists in project
- Check plan.md has correct Status field
