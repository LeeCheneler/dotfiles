#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles-backup"

echo "==> Setting up AI tooling"

# =============================================================================
# Backup Helper
# =============================================================================

backup_and_link() {
	local source="$1"
	local target="$2"

	mkdir -p "$(dirname "$target")"

	if [[ -e "$target" || -L "$target" ]]; then
		if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
			echo "    Already linked: $target"
			return
		fi

		mkdir -p "$BACKUP_DIR"
		local backup_name
		backup_name="$(basename "$target").$(date +%Y%m%d-%H%M%S)"
		echo "    Backing up: $target -> $BACKUP_DIR/$backup_name"
		mv "$target" "$BACKUP_DIR/$backup_name"
	fi

	echo "    Linking: $target -> $source"
	ln -sf "$source" "$target"
}

backup_and_link_dir() {
	local source="$1"
	local target="$2"

	if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
		echo "    Already linked: $target"
		return
	fi

	if [[ -e "$target" || -L "$target" ]]; then
		mkdir -p "$BACKUP_DIR"
		local backup_name
		backup_name="$(basename "$target").$(date +%Y%m%d-%H%M%S)"
		echo "    Backing up: $target -> $BACKUP_DIR/$backup_name"
		mv "$target" "$BACKUP_DIR/$backup_name"
	fi

	echo "    Linking: $target -> $source"
	ln -sf "$source" "$target"
}

# =============================================================================
# Claude Code Configuration
# =============================================================================

echo "==> Configuring Claude Code"

# Ensure ~/.claude exists
mkdir -p "$HOME/.claude"

backup_and_link "$DOTFILES_DIR/config/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
backup_and_link "$DOTFILES_DIR/config/claude/settings.json" "$HOME/.claude/settings.json"
backup_and_link_dir "$DOTFILES_DIR/config/claude/hooks" "$HOME/.claude/hooks"
backup_and_link_dir "$DOTFILES_DIR/config/claude/agents" "$HOME/.claude/agents"

# =============================================================================
# Done
# =============================================================================

echo "==> AI tooling setup complete"
