#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# shellcheck source=lib/helpers.sh
source "$DOTFILES_DIR/scripts/lib/helpers.sh"

echo "==> Setting up AI tooling"

# =============================================================================
# Claude Code Configuration
# =============================================================================

echo "==> Configuring Claude Code"

# Ensure ~/.claude exists
mkdir -p "$HOME/.claude"

backup_and_link "$DOTFILES_DIR/config/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
backup_and_link "$DOTFILES_DIR/config/claude/settings.json" "$HOME/.claude/settings.json"
backup_and_link_dir "$DOTFILES_DIR/config/claude/commands" "$HOME/.claude/commands"
backup_and_link_dir "$DOTFILES_DIR/config/claude/hooks" "$HOME/.claude/hooks"
backup_and_link_dir "$DOTFILES_DIR/config/claude/agents" "$HOME/.claude/agents"

# =============================================================================
# Done
# =============================================================================

echo "==> AI tooling setup complete"
