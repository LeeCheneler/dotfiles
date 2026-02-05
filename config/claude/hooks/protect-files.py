#!/usr/bin/env python3
"""Protect files outside git-managed directories from deletion.

Blocks file removal operations unless the target path is inside a git
repository. This allows Claude to freely manage files within projects
while preventing accidental deletion of system or personal files.
"""

import json
import os
import re
import sys


def is_inside_git_repo(path: str) -> bool:
    """Check if path is within a git-managed directory."""
    if not path:
        return True

    resolved = os.path.realpath(os.path.expanduser(path))

    # Walk up from the resolved path looking for a .git directory
    current = resolved if os.path.isdir(resolved) else os.path.dirname(resolved)
    while current != os.path.dirname(current):  # stop at filesystem root
        if os.path.isdir(os.path.join(current, ".git")):
            return True
        current = os.path.dirname(current)

    return False


def check_bash_for_rm(command: str) -> str | None:
    """Check if bash command contains rm and extract target paths.

    Returns the problematic path if found outside a git repo, None otherwise.
    """
    if not command:
        return None

    rm_patterns = [
        r"\brm\s+",
        r"\brmdir\s+",
        r"\bunlink\s+",
        r">\s*/dev/null.*&&.*rm\b",
    ]

    has_rm = any(re.search(pattern, command) for pattern in rm_patterns)
    if not has_rm:
        return None

    path_pattern = r'(?:rm|rmdir|unlink)\s+(?:-[rfiv]+\s+)*["\']?([^"\'\s;|&]+)'
    matches = re.findall(path_pattern, command)

    for path in matches:
        if path.startswith("-"):
            continue
        if not is_inside_git_repo(path):
            return path

    return None


def main() -> None:
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)

    tool_name = input_data.get("tool_name", "")
    tool_input = input_data.get("tool_input", {})

    blocked_path = None

    if tool_name == "Bash":
        command = tool_input.get("command", "")
        blocked_path = check_bash_for_rm(command)

    if blocked_path:
        result = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "ask",
                "permissionDecisionReason": (
                    f"This command will delete files outside any git repository: {blocked_path}\n"
                    "Deletions are only allowed within git-managed directories."
                ),
            }
        }
        print(json.dumps(result))
        sys.exit(0)

    sys.exit(0)


if __name__ == "__main__":
    main()
