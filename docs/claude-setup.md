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
| `doc-writer`       | READMEs, API docs, ADRs, changelogs               |
| `commit-message`   | Generate conventional commit messages             |
| `pr-description`   | Generate PR titles and descriptions               |
| `refactor-advisor` | Identify refactoring opportunities                |

## Workflow Framework

Structured development with persistent state.

### Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         WORKFLOW                                │
│                                                                 │
│  /begin ─► RESEARCH ─► PLAN ─► SIGNOFF ─► EXECUTE ─► /pr       │
│                │          │        │          │                 │
│                ▼          ▼        ▼          ▼                 │
│           research.md  plan.md  branch    per-commit            │
│                                 created      loop               │
└─────────────────────────────────────────────────────────────────┘
```

### Execute Loop (per commit)

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│    /next ─► DEV ─► REVIEW ─► PRESENT ─► COMMIT                │
│              │        │          │                             │
│              │        ▼          ▼                             │
│              │    fix issues   user                            │
│              │    & re-review  approval                        │
│              ▼                                                 │
│         test-writer                                            │
│         doc-writer                                             │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### Commands

**Orchestration:**

| Command         | Purpose                                            |
| --------------- | -------------------------------------------------- |
| `/begin <task>` | Start new work: research → plan → signoff → branch |
| `/next`         | Execute next commit cycle                          |
| `/resume`       | Resume existing plan from another session          |
| `/status`       | Show current plan progress                         |
| `/abort`        | Abort current plan safely                          |
| `/pr`           | Open pull request                                  |

**Standalone phases:**

| Command            | Purpose                          |
| ------------------ | -------------------------------- |
| `/research <task>` | Run research phase only          |
| `/plan`            | Run planning phase only          |
| `/signoff`         | Present and get approval         |
| `/dev`             | Run dev phase for current commit |
| `/review`          | Run review phase                 |
| `/present`         | Present changes for approval     |
| `/commit`          | Commit with approval             |

### Plan Files

Plans persist in `docs/plans/<task-slug>/`:

```
docs/plans/user-authentication/
├── research.md    # Codebase findings, patterns, recommendations
└── plan.md        # Commit breakdown with checklists
```

**research.md** contains:

- Task description
- Codebase overview
- Relevant files
- Existing patterns
- Documentation found (ADRs, READMEs, vision)
- Recommended approach

**plan.md** contains:

- Metadata (task, branch, status)
- Summary
- Commits with:
  - Goal
  - Files to create/modify
  - Checklist (Dev, Review, Present, Commit)
  - SHA after completion

### Typical Usage

**Start new work:**

```
/begin add user authentication to the API
```

Claude will:

1. Generate task slug, confirm with you
2. Run researcher agent → research.md
3. Run planner agent → plan.md
4. Present summary, wait for signoff
5. Create branch after approval

**Execute commits:**

```
/next
```

Runs one commit cycle: dev → review → present → commit.
Repeat until all commits done.

**Open PR:**

```
/pr
```

Generates PR description, creates PR after approval.

**Resume in new session:**

```
/resume
```

Lists active plans, lets you select one to continue.

**Check progress:**

```
/status
```

Shows current commit, remaining work.

## MCP Servers

Model Context Protocol servers extend Claude's capabilities.

### Configured Servers

| Server | Purpose                      | Requires                  |
| ------ | ---------------------------- | ------------------------- |
| Memory | Cross-session persistence    | Nothing (auto-configured) |
| GitHub | Structured GitHub API access | `GITHUB_TOKEN` env var    |

### Memory Server

Stores knowledge in `~/.claude-memory/memory.json` (global, outside dotfiles so it's not version controlled).

Uses: `@modelcontextprotocol/server-memory`

No setup required - works automatically.

### GitHub Server

Provides structured GitHub API access (issues, PRs, repos, users).

Uses: `@modelcontextprotocol/server-github`

**Setup:**

```bash
# Option 1: Use gh CLI token (easiest)
export GITHUB_TOKEN=$(gh auth token)

# Option 2: Use 1Password
export GITHUB_TOKEN=$(op read "op://Private/GitHub Token/token")

# Option 3: Manual (create at github.com/settings/tokens)
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

Add to `~/.zshrc` for persistence:

```bash
# GitHub token for Claude MCP
export GITHUB_TOKEN=$(gh auth token)
```

**Required scopes:** `repo`, `read:org`, `read:user`, `read:project`

### Agent Benefits

| Agent            | MCP Usage                           |
| ---------------- | ----------------------------------- |
| researcher       | Query GitHub issues/PRs for context |
| planner          | Read issue details for requirements |
| security-auditor | Check security advisories           |
| code-reviewer    | Read PR discussion history          |
| doc-writer       | Link to issues/PRs in documentation |

## Configuration

### settings.json

```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep", "Bash(git:*)", ...],
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
- Code style (TypeScript, naming, React)
- Testing approach
- Git conventions
- Agent delegation table
- Workflow reference
- What not to do

## Quick Reference

```
# Start new structured work
/begin <task description>

# Continue executing plan
/next

# Check where you are
/status

# Resume after session break
/resume

# Abort if needed
/abort

# Open PR when done
/pr
```

## Troubleshooting

**Commands not appearing:**

- Start new Claude Code session (commands load at startup)

**Hook not triggering:**

- Check `~/.claude/settings.json` symlink exists
- Verify hook scripts are executable (`chmod +x`)

**Plan not found:**

- Ensure `docs/plans/` directory exists in project
- Check plan.md has correct Status field

**Context getting long:**

- Use `/status` to check progress
- Standalone commands (`/review`, `/present`) re-inject fresh instructions
