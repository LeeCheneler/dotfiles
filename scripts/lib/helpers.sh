#!/bin/bash
# Shared helper functions for dotfiles scripts
# Source this file: source "$DOTFILES_DIR/scripts/lib/helpers.sh"

BACKUP_DIR="$HOME/.dotfiles-backup"

# =============================================================================
# backup_and_link - Safely symlink a file with backup
# =============================================================================
# Usage: backup_and_link <source> <target>
#
# - Creates parent directories if needed
# - Backs up existing files to ~/.dotfiles-backup/ with timestamp
# - Skips if already correctly linked (idempotent)
# - Creates symlink from target -> source

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

# =============================================================================
# backup_and_link_dir - Safely symlink a directory with backup
# =============================================================================
# Usage: backup_and_link_dir <source> <target>
#
# Same as backup_and_link but for directories

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
