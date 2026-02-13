#!/usr/bin/env python3
"""TaskCompleted hook for Claude Code agent teams.

Blocks task completion when there are uncommitted changes in the working
tree, ensuring teammates run tests and commit before marking done.
Non-code tasks (no modified files) pass through without friction.
"""

import json
import subprocess
import sys

# Extensions that indicate code was written (not just docs/config)
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


def get_uncommitted_code_files() -> list[str]:
    """Return list of uncommitted code files (staged or unstaged)."""
    result = subprocess.run(
        ["git", "status", "--porcelain"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return []

    code_files = []
    for line in result.stdout.strip().splitlines():
        if not line or len(line) < 4:
            continue
        # porcelain format: XY filename
        filepath = line[3:].strip().strip('"')
        if any(filepath.endswith(ext) for ext in CODE_EXTENSIONS):
            code_files.append(filepath)

    return code_files


def main() -> None:
    try:
        json.load(sys.stdin)
    except (json.JSONDecodeError, EOFError):
        pass

    code_files = get_uncommitted_code_files()
    if not code_files:
        # No uncommitted code files — allow completion
        sys.exit(0)

    file_list = "\n".join(f"  - {f}" for f in code_files[:10])
    extra = f"\n  ... and {len(code_files) - 10} more" if len(code_files) > 10 else ""

    print(
        "BLOCKED: You have uncommitted code changes.\n\n"
        f"Uncommitted files:\n{file_list}{extra}\n\n"
        "Before marking this task complete, you MUST:\n"
        "1. Run the project's test suite and confirm tests pass\n"
        "2. Run the project's linter/formatter if available\n"
        "3. Commit your changes with a conventional commit message\n"
        "4. Then mark the task complete again",
        file=sys.stderr,
    )
    sys.exit(2)


if __name__ == "__main__":
    main()
