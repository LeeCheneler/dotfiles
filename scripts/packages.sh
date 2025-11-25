#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

echo "==> Setting up packages"

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
	echo "==> Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add brew to PATH for this session (Apple Silicon vs Intel)
	if [[ -f "/opt/homebrew/bin/brew" ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [[ -f "/usr/local/bin/brew" ]]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
else
	echo "==> Homebrew already installed"
fi

# Update Homebrew
echo "==> Updating Homebrew"
brew update

# Install packages from Brewfile
echo "==> Installing packages from Brewfile"
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Packages complete"
