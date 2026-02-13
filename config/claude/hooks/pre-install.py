#!/usr/bin/env python3
"""Pre-install hook for Claude Code.

Blocks package install commands that add NEW dependencies. Bare installs
(from lockfile) are allowed. Adding a new package requires user awareness.
"""

import json
import re
import sys


# Patterns that ADD a new dependency (not install from lockfile)
ADD_PATTERNS = [
    # npm install <pkg>, npm i <pkg> (with at least one non-flag arg after install/i)
    r"\bnpm\s+(?:install|i|add)\s+(?!-)[^\s]",
    # pnpm add <pkg>
    r"\bpnpm\s+add\s+(?!-)[^\s]",
    # yarn add <pkg>
    r"\byarn\s+add\s+(?!-)[^\s]",
    # bun add <pkg>
    r"\bbun\s+add\s+(?!-)[^\s]",
    # pip install <pkg> (but not pip install -r requirements.txt)
    r"\bpip3?\s+install\s+(?!-r\b)(?!--requirement\b)(?!-e\b)(?!--editable\b)(?!\.)[^\s-]",
    # cargo add <pkg>
    r"\bcargo\s+add\s+(?!-)[^\s]",
]


def is_adding_dependency(command: str) -> bool:
    """Check if command adds a new dependency (not just installing from lockfile)."""
    return any(re.search(pattern, command) for pattern in ADD_PATTERNS)


def main() -> None:
    input_data = json.load(sys.stdin)
    tool_input = input_data.get("tool_input", {})
    command = tool_input.get("command", "")

    if is_adding_dependency(command):
        result = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "ask",
                "permissionDecisionReason": (
                    "This command adds a new dependency to the project.\n"
                    "Verify the package is intended before proceeding."
                ),
            }
        }
        print(json.dumps(result))
        sys.exit(0)

    sys.exit(0)


if __name__ == "__main__":
    main()
