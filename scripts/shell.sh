#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# shellcheck source=lib/helpers.sh
source "$DOTFILES_DIR/scripts/lib/helpers.sh"

echo "==> Setting up shell"

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
