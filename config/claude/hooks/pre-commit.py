#!/usr/bin/env python3
"""Pre-commit hook for Claude Code.

Blocks commits to enforce workflow:
- On main branch: asks user about creating a new branch
- On other branches: requires commit-message agent and user approval
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

    if branch == "main":
        print(
            "BLOCKED: You are on the main branch.\n\n"
            "Before committing, you MUST:\n"
            "1. Ask the user: 'You're on main. Should I create a new branch for this commit?'\n"
            "2. If yes, create the branch and switch to it\n"
            "3. Then retry the commit following the standard commit protocol",
            file=sys.stderr,
        )
        sys.exit(2)

    print(
        "BLOCKED: Commit requires approval.\n\n"
        "Before committing, you MUST:\n"
        "1. Use the `commit-message` agent to generate the commit message\n"
        "2. Present the FULL commit message to the user\n"
        "3. Wait for explicit user approval\n"
        "4. Only after approval, retry the git commit command",
        file=sys.stderr,
    )
    sys.exit(2)


if __name__ == "__main__":
    main()
