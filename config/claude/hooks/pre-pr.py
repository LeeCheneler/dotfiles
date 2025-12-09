#!/usr/bin/env python3
"""Pre-PR hook for Claude Code.

Blocks PR creation to enforce workflow:
- Requires pr-description agent to generate title and description
- Requires user approval before creating PR
"""

import json
import sys


def main() -> None:
    # Read input from stdin (required by hook interface)
    json.load(sys.stdin)

    print(
        "BLOCKED: PR creation requires approval.\n\n"
        "Before creating the PR, you MUST:\n"
        "1. Use the `pr-description` agent to generate the PR title and description\n"
        "2. Present the FULL PR title and description to the user\n"
        "3. Wait for explicit user approval\n"
        "4. Only after approval, retry the gh pr create command",
        file=sys.stderr,
    )
    sys.exit(2)


if __name__ == "__main__":
    main()
