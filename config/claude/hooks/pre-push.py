#!/usr/bin/env python3
"""Pre-push hook for Claude Code.

Blocks pushes to main branch:
- If pushing to main: requires explicit user confirmation
- If pushing to other branches: allows without blocking
"""

import json
import subprocess
import sys


def get_current_branch() -> str:
    result = subprocess.run(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def is_pushing_to_main(command: str) -> bool:
    parts = command.split()

    # Check if 'main' is explicitly in the push command
    # Patterns like: git push origin main, git push -u origin main
    if "main" in parts:
        return True

    # If no explicit branch specified, check current branch
    # e.g., "git push" or "git push origin" or "git push -u origin"
    has_explicit_branch = False
    for i, part in enumerate(parts):
        if part.startswith("-"):
            continue
        if part in ("git", "push"):
            continue
        # This might be remote name, check if next non-flag is a branch
        remaining = [p for p in parts[i + 1 :] if not p.startswith("-")]
        if remaining:
            has_explicit_branch = True
            break

    if not has_explicit_branch:
        return get_current_branch() == "main"

    return False


def main() -> None:
    input_data = json.load(sys.stdin)
    tool_input = input_data.get("tool_input", {})
    command = tool_input.get("command", "")

    if is_pushing_to_main(command):
        print(
            "BLOCKED: You are about to push to the main branch.\n\n"
            "You MUST ask the user:\n"
            "'You're pushing to main. Is this intended, or should I push to a different branch?'\n\n"
            "Only proceed after explicit user confirmation.",
            file=sys.stderr,
        )
        sys.exit(2)

    # Allow push to non-main branches
    sys.exit(0)


if __name__ == "__main__":
    main()
