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

    # If current branch is main, block unless pushing to a different
    # explicit refspec (e.g. git push origin main:other-branch)
    current = get_current_branch()
    if current != "main":
        return False

    # On main branch - check if an explicit non-main ref is specified
    # Strip flags and known tokens to find positional args
    positional = [p for p in parts if not p.startswith("-") and p not in ("git", "push")]

    # positional[0] = remote (if present), positional[1] = refspec (if present)
    if len(positional) >= 2:
        refspec = positional[1]
        # HEAD, main, or no colon all resolve to main when on main
        if refspec in ("HEAD", "main") or ":" not in refspec:
            return True
        # Explicit refspec like main:other-branch - pushing to other-branch
        return False

    # No explicit refspec while on main = pushing main
    return True


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
