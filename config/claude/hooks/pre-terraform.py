#!/usr/bin/env python3
"""Pre-terraform hook for Claude Code.

Blocks destructive terraform commands (apply, destroy) and requires
explicit user confirmation before proceeding. Non-destructive commands
like plan, init, fmt, and validate pass through without friction.
"""

import json
import sys

DESTRUCTIVE_SUBCOMMANDS = {"apply", "destroy"}


def is_destructive(command: str) -> str | None:
    """Check if terraform command is destructive. Returns subcommand if so."""
    parts = command.split()

    for part in parts:
        if part in DESTRUCTIVE_SUBCOMMANDS:
            return part

    return None


def main() -> None:
    input_data = json.load(sys.stdin)
    tool_input = input_data.get("tool_input", {})
    command = tool_input.get("command", "")

    subcommand = is_destructive(command)
    if subcommand:
        print(
            f"BLOCKED: `terraform {subcommand}` is a destructive operation.\n\n"
            "You MUST ask the user:\n"
            f"'About to run `terraform {subcommand}`. Have you reviewed the plan? Should I proceed?'\n\n"
            "Only proceed after explicit user confirmation.",
            file=sys.stderr,
        )
        sys.exit(2)

    sys.exit(0)


if __name__ == "__main__":
    main()
