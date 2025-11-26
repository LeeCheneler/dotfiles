#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/leecheneler/dotfiles.git"

echo "==> Applying dotfiles"

# Install Xcode Command Line Tools if not present
if ! xcode-select -p &>/dev/null; then
	echo "==> Installing Xcode Command Line Tools"
	xcode-select --install
	echo "==> Waiting for Xcode CLI tools installation..."
	echo "    Please complete the installation prompt, then re-run this script."
	exit 0
fi

# Clone or update dotfiles repo
if [[ -d "$DOTFILES_DIR" ]]; then
	echo "==> Pulling latest changes"
	git -C "$DOTFILES_DIR" pull --rebase
else
	echo "==> Cloning dotfiles"
	git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Run setup scripts
export DOTFILES_DIR
"$DOTFILES_DIR/scripts/packages.sh"
"$DOTFILES_DIR/scripts/shell.sh"
"$DOTFILES_DIR/scripts/vscode.sh"
"$DOTFILES_DIR/scripts/git.sh"
"$DOTFILES_DIR/scripts/ai.sh"

echo "==> Done!"
