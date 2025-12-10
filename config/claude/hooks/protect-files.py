#!/usr/bin/env python3
"""Protect files outside ~/projects from deletion.

Blocks file removal operations outside the allowed directory unless
explicitly approved by the user.
"""

import json
import os
import re
import sys

ALLOWED_DIR = os.path.expanduser("~/projects")


def is_path_allowed(path: str) -> bool:
    """Check if path is within the allowed directory."""
    if not path:
        return True

    resolved = os.path.realpath(os.path.expanduser(path))
    allowed_resolved = os.path.realpath(ALLOWED_DIR)

    return resolved.startswith(allowed_resolved + os.sep) or resolved == allowed_resolved


def check_bash_for_rm(command: str) -> str | None:
    """Check if bash command contains rm and extract target paths.

    Returns the problematic path if found outside allowed dir, None otherwise.
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
        if not is_path_allowed(path):
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
                    f"This command will delete files outside ~/projects: {blocked_path}\n"
                    "Only files in ~/projects can be deleted without approval."
                ),
            }
        }
        print(json.dumps(result))
        sys.exit(0)

    sys.exit(0)


if __name__ == "__main__":
    main()
