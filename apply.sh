#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/leecheneler/dotfiles.git"

echo "==> Applying dotfiles"

# Clone or update dotfiles repo
if [[ -d "$DOTFILES_DIR" ]]; then
	echo "==> Pulling latest changes"
	git -C "$DOTFILES_DIR" pull --rebase
else
	echo "==> Cloning dotfiles"
	git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

echo "==> Done!"
