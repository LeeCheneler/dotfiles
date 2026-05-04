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

# =============================================================================
# Claude Desktop BPP Wrapper App
# =============================================================================

echo "==> Installing Claude BPP desktop app"

APP_TARGET="/Applications/Claude BPP.app"

if [[ -d "/Applications/Claude.app" ]]; then
	rm -rf "$APP_TARGET"

	# Build a signed macOS applet via osacompile
	# shellcheck disable=SC2016
	osacompile -o "$APP_TARGET" -e '
do shell script "/Applications/Claude.app/Contents/MacOS/Claude --user-data-dir=\"$HOME/Library/Application Support/Claude-BPP\" &> /dev/null &"
'

	# Copy icon from the real Claude app
	cp "/Applications/Claude.app/Contents/Resources/electron.icns" "$APP_TARGET/Contents/Resources/AppIcon.icns"

	echo "    Installed Claude BPP.app"
else
	echo "    Skipping: Claude.app not found"
fi

# =============================================================================
# Tomo Configuration
# =============================================================================

echo "==> Configuring Tomo"

mkdir -p "$HOME/.tomo"

backup_and_link "$DOTFILES_DIR/config/tomo/config.yaml" "$HOME/.tomo/config.yaml"

# =============================================================================
# TypeScript LSP for Claude Code
# =============================================================================

echo "==> Installing TypeScript LSP server"
npm install -g typescript-language-server typescript

# =============================================================================
# Done
# =============================================================================

echo "==> AI tooling setup complete"
echo ""
echo "==> Manual steps remaining:"
echo "    Run these commands in a Claude Code session to enable LSP support:"
echo "      /plugin marketplace add Piebald-AI/claude-code-lsps"
echo "      /plugin install vtsls@claude-code-lsps"
