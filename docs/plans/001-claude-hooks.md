# Plan: Claude Code Hooks Setup

## Status: COMPLETE

## Objective

Configure Claude Code hooks to enforce workflow discipline around commits, PRs, and pushes.

## Decisions

| Decision | Choice |
|----------|--------|
| Protected branches | `main` only |
| Block mode | Hard block (exit 2), no bypass |
| Agent enforcement | Remind only, trust Claude to comply |
| Hook scope | Global only (`~/.dotfiles/config/claude/`) |

## Hook Interface Summary

Based on Claude Code docs:

- **Input**: JSON via stdin with `tool_name`, `tool_input`, `cwd`, etc.
- **Output**: Exit 2 = block, stderr message shown to Claude
- **Matcher**: Regex pattern matching tool name, e.g., `Bash(git commit:*)`

## Hooks to Implement

### 1. Pre-Commit Hook

**Trigger:** `PreToolUse` on `Bash(git commit:*)`

**Behavior:**
1. Parse stdin JSON to get the git commit command
2. Check current branch via `git rev-parse --abbrev-ref HEAD`
3. If on `main`:
   - Exit 2 with message instructing Claude to ask user about creating a new branch
4. If not on `main`:
   - Exit 2 with message instructing Claude to:
     - Use `commit-message` agent to generate commit message
     - Present full commit message to user
     - Wait for explicit approval before retrying

**Script:** `~/.dotfiles/config/claude/hooks/pre-commit.py`

```python
#!/usr/bin/env python3
import json
import subprocess
import sys

def get_current_branch():
    result = subprocess.run(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        capture_output=True, text=True
    )
    return result.stdout.strip()

def main():
    input_data = json.load(sys.stdin)
    branch = get_current_branch()

    if branch == "main":
        print(
            "BLOCKED: You are on the main branch.\n\n"
            "Before committing, you MUST:\n"
            "1. Ask the user: 'You're on main. Should I create a new branch for this commit?'\n"
            "2. If yes, create the branch and switch to it\n"
            "3. Then retry the commit following the standard commit protocol",
            file=sys.stderr
        )
        sys.exit(2)

    print(
        "BLOCKED: Commit requires approval.\n\n"
        "Before committing, you MUST:\n"
        "1. Use the `commit-message` agent to generate the commit message\n"
        "2. Present the FULL commit message to the user\n"
        "3. Wait for explicit user approval\n"
        "4. Only after approval, retry the git commit command",
        file=sys.stderr
    )
    sys.exit(2)

if __name__ == "__main__":
    main()
```

### 2. Pre-PR Hook

**Trigger:** `PreToolUse` on `Bash(gh pr create:*)`

**Behavior:**
1. Exit 2 with message instructing Claude to:
   - Use `pr-description` agent to generate title and description
   - Present full PR title and body to user
   - Wait for explicit approval before retrying

**Script:** `~/.dotfiles/config/claude/hooks/pre-pr.py`

```python
#!/usr/bin/env python3
import json
import sys

def main():
    input_data = json.load(sys.stdin)

    print(
        "BLOCKED: PR creation requires approval.\n\n"
        "Before creating the PR, you MUST:\n"
        "1. Use the `pr-description` agent to generate the PR title and description\n"
        "2. Present the FULL PR title and description to the user\n"
        "3. Wait for explicit user approval\n"
        "4. Only after approval, retry the gh pr create command",
        file=sys.stderr
    )
    sys.exit(2)

if __name__ == "__main__":
    main()
```

### 3. Pre-Push Hook

**Trigger:** `PreToolUse` on `Bash(git push:*)`

**Behavior:**
1. Parse stdin JSON to get the git push command
2. Detect if pushing to `main` by checking:
   - Explicit remote/branch in command (e.g., `git push origin main`)
   - Current branch if no explicit target
3. If pushing to `main`:
   - Exit 2 with message asking Claude to confirm with user
4. If not pushing to `main`:
   - Exit 0 (allow)

**Script:** `~/.dotfiles/config/claude/hooks/pre-push.py`

```python
#!/usr/bin/env python3
import json
import subprocess
import sys

def get_current_branch():
    result = subprocess.run(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        capture_output=True, text=True
    )
    return result.stdout.strip()

def is_pushing_to_main(command: str) -> bool:
    # Check if 'main' is explicitly in the push command
    parts = command.split()

    # Patterns like: git push origin main, git push -u origin main
    if "main" in parts:
        return True

    # If no explicit branch, check current branch
    # e.g., "git push" or "git push origin" or "git push -u origin"
    has_explicit_branch = False
    for i, part in enumerate(parts):
        if part.startswith("-"):
            continue
        if part in ("git", "push"):
            continue
        # This might be remote name, check if next non-flag is a branch
        remaining = [p for p in parts[i+1:] if not p.startswith("-")]
        if remaining:
            has_explicit_branch = True
            break

    if not has_explicit_branch:
        return get_current_branch() == "main"

    return False

def main():
    input_data = json.load(sys.stdin)
    tool_input = input_data.get("tool_input", {})
    command = tool_input.get("command", "")

    if is_pushing_to_main(command):
        print(
            "BLOCKED: You are about to push to the main branch.\n\n"
            "You MUST ask the user:\n"
            "'You're pushing to main. Is this intended, or should I push to a different branch?'\n\n"
            "Only proceed after explicit user confirmation.",
            file=sys.stderr
        )
        sys.exit(2)

    # Allow push to non-main branches
    sys.exit(0)

if __name__ == "__main__":
    main()
```

## Configuration

Update `~/.dotfiles/config/claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash(git commit:*)",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.dotfiles/config/claude/hooks/pre-commit.py"
          }
        ]
      },
      {
        "matcher": "Bash(gh pr create:*)",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.dotfiles/config/claude/hooks/pre-pr.py"
          }
        ]
      },
      {
        "matcher": "Bash(git push:*)",
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.dotfiles/config/claude/hooks/pre-push.py"
          }
        ]
      }
    ]
  }
}
```

## Implementation Steps

- [ ] 1. Create `pre-commit.py` script
- [ ] 2. Create `pre-pr.py` script
- [ ] 3. Create `pre-push.py` script
- [ ] 4. Make scripts executable (`chmod +x`)
- [ ] 5. Update `settings.json` with hook configuration
- [ ] 6. Test: attempt commit on main branch
- [ ] 7. Test: attempt commit on feature branch
- [ ] 8. Test: attempt PR creation
- [ ] 9. Test: attempt push to main
- [ ] 10. Test: attempt push to feature branch

## Success Criteria

- [ ] Commits on main prompt for branch creation
- [ ] Commits on feature branches require approval + commit-message agent
- [ ] PR creation requires approval + pr-description agent
- [ ] Push to main requires explicit confirmation
- [ ] Push to feature branches proceeds without blocking

## File Structure After Implementation

```
~/.dotfiles/config/claude/
├── agents/
│   ├── code-reviewer.md
│   ├── commit-message.md
│   ├── doc-writer.md
│   ├── pr-description.md
│   ├── refactor-advisor.md
│   ├── security-auditor.md
│   └── test-writer.md
├── hooks/
│   ├── pre-commit.py
│   ├── pre-pr.py
│   └── pre-push.py
├── CLAUDE.md
└── settings.json
```
