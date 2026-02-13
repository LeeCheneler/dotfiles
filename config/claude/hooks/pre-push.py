#!/usr/bin/env python3
"""Pre-push hook for Claude Code.

Blocks pushes to protected branches (main, master):
- If pushing to a protected branch: requires explicit user confirmation
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


PROTECTED_BRANCHES = {"main", "master"}


def is_pushing_to_protected(command: str) -> bool:
    parts = command.split()

    # Check if a protected branch is explicitly in the push command
    # Patterns like: git push origin main, git push -u origin master
    if PROTECTED_BRANCHES & set(parts):
        return True

    # If current branch is protected, block unless pushing to a different
    # explicit refspec (e.g. git push origin main:other-branch)
    current = get_current_branch()
    if current not in PROTECTED_BRANCHES:
        return False

    # On protected branch - check if an explicit non-protected ref is specified
    # Strip flags and known tokens to find positional args
    positional = [p for p in parts if not p.startswith("-") and p not in ("git", "push")]

    # positional[0] = remote (if present), positional[1] = refspec (if present)
    if len(positional) >= 2:
        refspec = positional[1]
        # HEAD or a protected branch name or no colon all resolve to current branch
        if refspec == "HEAD" or refspec in PROTECTED_BRANCHES or ":" not in refspec:
            return True
        # Explicit refspec like main:other-branch - pushing to other-branch
        return False

    # No explicit refspec while on protected branch = pushing protected
    return True


def main() -> None:
    input_data = json.load(sys.stdin)
    tool_input = input_data.get("tool_input", {})
    command = tool_input.get("command", "")

    if is_pushing_to_protected(command):
        branch = get_current_branch()
        print(
            f"BLOCKED: You are about to push to a protected branch ({branch}).\n\n"
            "You MUST ask the user:\n"
            f"'You're pushing to {branch}. Is this intended, or should I push to a different branch?'\n\n"
            "Only proceed after explicit user confirmation.",
            file=sys.stderr,
        )
        sys.exit(2)

    # Allow push to non-protected branches
    sys.exit(0)


if __name__ == "__main__":
    main()
