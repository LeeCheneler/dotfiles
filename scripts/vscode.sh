#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# shellcheck source=lib/helpers.sh
source "$DOTFILES_DIR/scripts/lib/helpers.sh"

echo "==> Setting up VS Code"

# =============================================================================
# Check VS Code is installed
# =============================================================================

if ! command -v code &>/dev/null; then
	echo "    VS Code CLI not found. Ensure VS Code is installed and 'code' is in PATH."
	echo "    You can add it via: VS Code > Command Palette > 'Shell Command: Install code command in PATH'"
	exit 1
fi

# =============================================================================
# Settings
# =============================================================================

echo "==> Configuring VS Code settings"

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"

backup_and_link "$DOTFILES_DIR/config/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"

# =============================================================================
# Extensions
# =============================================================================

echo "==> Managing VS Code extensions"

EXTENSIONS_FILE="$DOTFILES_DIR/config/vscode/extensions.txt"

if [[ ! -f "$EXTENSIONS_FILE" ]]; then
	echo "    Extensions file not found: $EXTENSIONS_FILE"
	exit 1
fi

# Build list of desired extensions (lowercase for comparison)
declare -a desired_extensions=()
while IFS= read -r line || [[ -n "$line" ]]; do
	[[ -z "$line" || "$line" =~ ^# ]] && continue
	desired_extensions+=("$(echo "$line" | tr '[:upper:]' '[:lower:]')")
done <"$EXTENSIONS_FILE"

# Install missing extensions
echo "==> Installing extensions"
for ext in "${desired_extensions[@]}"; do
	if code --list-extensions | tr '[:upper:]' '[:lower:]' | grep -q "^${ext}$"; then
		echo "    [skip] $ext (already installed)"
	else
		echo "    [install] $ext"
		code --install-extension "$ext" --force >/dev/null 2>&1 || {
			echo "    [warn] Failed to install $ext"
		}
	fi
done

# Remove extensions not in the list
echo "==> Removing unlisted extensions"
while IFS= read -r installed; do
	installed_lower="$(echo "$installed" | tr '[:upper:]' '[:lower:]')"
	found=false
	for ext in "${desired_extensions[@]}"; do
		if [[ "$ext" == "$installed_lower" ]]; then
			found=true
			break
		fi
	done
	if [[ "$found" == false ]]; then
		echo "    [remove] $installed"
		code --uninstall-extension "$installed" >/dev/null 2>&1 || {
			echo "    [warn] Failed to remove $installed"
		}
	fi
done < <(code --list-extensions)

# =============================================================================
# Done
# =============================================================================

echo "==> VS Code setup complete"
echo ""
echo "NOTE: Restart VS Code to ensure all extensions are loaded."
