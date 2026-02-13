#!/usr/bin/env python3
"""Pre-commit hook for Claude Code.

Blocks commits on protected branches (main, master). Feature branches
are allowed through without friction.
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


def main() -> None:
    # Read input from stdin (required by hook interface)
    json.load(sys.stdin)

    branch = get_current_branch()

    if branch in ("main", "master"):
        print(
            f"BLOCKED: You are on the {branch} branch.\n\n"
            "Before committing, you MUST:\n"
            f"1. Ask the user: 'You're on {branch}. Should I create a new branch for this commit?'\n"
            "2. If yes, create the branch and switch to it\n"
            "3. Then retry the commit",
            file=sys.stderr,
        )
        sys.exit(2)

    # Feature branches: allow through
    sys.exit(0)


if __name__ == "__main__":
    main()
