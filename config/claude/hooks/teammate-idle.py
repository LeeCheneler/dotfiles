#!/usr/bin/env python3
"""TeammateIdle hook for Claude Code agent teams.

When a teammate is about to go idle, checks for uncommitted code changes
that may have been left behind. If found, nudges the teammate to commit
or clean up before idling.
"""

import json
import subprocess
import sys

CODE_EXTENSIONS = {
    ".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs",
    ".py", ".pyw",
    ".rs",
    ".go",
    ".java", ".kt", ".kts",
    ".c", ".cpp", ".h", ".hpp",
    ".rb",
    ".swift",
    ".cs",
    ".php",
    ".vue", ".svelte",
}


def has_uncommitted_code() -> bool:
    """Check if there are uncommitted code files."""
    result = subprocess.run(
        ["git", "status", "--porcelain"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return False

    for line in result.stdout.strip().splitlines():
        if not line or len(line) < 4:
            continue
        filepath = line[3:].strip().strip('"')
        if any(filepath.endswith(ext) for ext in CODE_EXTENSIONS):
            return True

    return False


def main() -> None:
    try:
        json.load(sys.stdin)
    except (json.JSONDecodeError, EOFError):
        pass

    if has_uncommitted_code():
        print(
            "You have uncommitted code changes. Before idling:\n"
            "1. Run tests to verify your changes work\n"
            "2. Commit your changes with a conventional commit message\n"
            "3. Mark any completed tasks as done",
            file=sys.stderr,
        )
        sys.exit(2)

    sys.exit(0)


if __name__ == "__main__":
    main()
