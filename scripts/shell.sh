#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles-backup"

echo "==> Setting up shell"

# =============================================================================
# Backup Helper
# =============================================================================

backup_and_link() {
	local source="$1"
	local target="$2"

	# Create parent directory if needed
	mkdir -p "$(dirname "$target")"

	# If target exists and is not a symlink to our source
	if [[ -e "$target" || -L "$target" ]]; then
		# Check if it's already our symlink
		if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
			echo "    Already linked: $target"
			return
		fi

		# Backup existing file
		mkdir -p "$BACKUP_DIR"
		local backup_name
		backup_name="$(basename "$target").$(date +%Y%m%d-%H%M%S)"
		echo "    Backing up: $target -> $BACKUP_DIR/$backup_name"
		mv "$target" "$BACKUP_DIR/$backup_name"
	fi

	# Create symlink
	echo "    Linking: $target -> $source"
	ln -sf "$source" "$target"
}

# =============================================================================
# Zsh Configuration
# =============================================================================

echo "==> Configuring zsh"
backup_and_link "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc"

# =============================================================================
# Kitty Configuration
# =============================================================================

echo "==> Configuring kitty"
backup_and_link "$DOTFILES_DIR/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# =============================================================================
# Starship Configuration
# =============================================================================

echo "==> Configuring starship"
backup_and_link "$DOTFILES_DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"

# =============================================================================
# Done
# =============================================================================

echo "==> Shell setup complete"
echo ""
echo "NOTE: Restart your terminal or run 'source ~/.zshrc' to apply changes."
echo "      Zinit plugins will be installed on first shell launch."
