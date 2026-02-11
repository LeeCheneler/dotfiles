#!/usr/bin/env python3
"""PostToolUse hook: auto-format files after Edit/Write."""

import json
import os
import subprocess
import sys


def find_config_upward(start_dir: str, names: list[str]) -> str | None:
    """Walk up from start_dir looking for any file matching names."""
    current = start_dir
    while True:
        for name in names:
            if os.path.exists(os.path.join(current, name)):
                return current
        parent = os.path.dirname(current)
        if parent == current:
            return None
        current = parent


def detect_formatter(file_path: str) -> list[str] | None:
    """Detect project formatter and return command to format the file."""
    start_dir = os.path.dirname(os.path.abspath(file_path))

    # Biome
    if find_config_upward(start_dir, ["biome.json", "biome.jsonc"]):
        return ["npx", "@biomejs/biome", "format", "--write", file_path]

    # Prettier
    prettier_configs = [
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.toml",
        ".prettierrc.js",
        ".prettierrc.cjs",
        ".prettierrc.mjs",
        "prettier.config.js",
        "prettier.config.cjs",
        "prettier.config.mjs",
    ]
    if find_config_upward(start_dir, prettier_configs):
        return ["npx", "prettier", "--write", file_path]

    # dprint
    if find_config_upward(start_dir, ["dprint.json"]):
        return ["dprint", "fmt", file_path]

    return None


def main() -> None:
    try:
        event = json.loads(sys.stdin.read())
    except (json.JSONDecodeError, EOFError):
        return

    tool_input = event.get("tool_input", {})
    file_path = tool_input.get("file_path")

    if not file_path or not os.path.isfile(file_path):
        return

    cmd = detect_formatter(file_path)
    if not cmd:
        return

    result = subprocess.run(cmd, capture_output=True, timeout=30)
    if result.returncode != 0:
        stderr = result.stderr.decode().strip() if result.stderr else "unknown error"
        print(
            json.dumps({
                "hookSpecificOutput": {
                    "message": f"Auto-format warning: {cmd[0]} exited {result.returncode}: {stderr[:200]}"
                }
            })
        )


if __name__ == "__main__":
    main()
