#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles-backup"
SSH_KEY="$HOME/.ssh/id_ed25519"
GPG_EMAIL="leecheneler@users.noreply.github.com"

echo "==> Setting up git"

# =============================================================================
# Backup Helper (same as shell.sh)
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

# =============================================================================
# Git Config
# =============================================================================

echo "==> Configuring git"
backup_and_link "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig"

# =============================================================================
# SSH Key
# =============================================================================

echo "==> Configuring SSH"

if [[ -f "$SSH_KEY" ]]; then
	echo "    SSH key already exists: $SSH_KEY"
else
	echo "    Generating new SSH key..."
	ssh-keygen -t ed25519 -C "$GPG_EMAIL" -f "$SSH_KEY" -N ""
	echo "    SSH key generated: $SSH_KEY"
fi

# Start ssh-agent and add key
eval "$(ssh-agent -s)" >/dev/null
ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add "$SSH_KEY"

# Check if key is registered with GitHub
echo "    Testing GitHub SSH connection..."
if ssh -T git@github.com 2>&1 | grep -q "You've successfully authenticated"; then
	echo "    SSH key is registered with GitHub"
else
	echo ""
	echo "    ┌─────────────────────────────────────────────────────────────┐"
	echo "    │ SSH key not yet registered with GitHub                      │"
	echo "    │                                                             │"
	echo "    │ 1. Copy your public key (already in clipboard):             │"
	echo "    │    pbcopy < $SSH_KEY.pub"
	echo "    │                                                             │"
	echo "    │ 2. Add it to GitHub:                                        │"
	echo "    │    https://github.com/settings/ssh/new                      │"
	echo "    └─────────────────────────────────────────────────────────────┘"
	echo ""
	pbcopy <"$SSH_KEY.pub"
fi

# =============================================================================
# SSH Signing (allowed signers file)
# =============================================================================

echo "==> Configuring commit signing"

# Create allowed signers file for local verification
ALLOWED_SIGNERS="$HOME/.ssh/allowed_signers"
SSH_PUB_KEY=$(cat "$SSH_KEY.pub")
echo "$GPG_EMAIL $SSH_PUB_KEY" >"$ALLOWED_SIGNERS"
echo "    Created allowed_signers file"

# Instructions for GitHub
echo ""
echo "    ┌─────────────────────────────────────────────────────────────┐"
echo "    │ To enable verified commits on GitHub:                       │"
echo "    │                                                             │"
echo "    │ Add your SSH key as a SIGNING key (not just auth):          │"
echo "    │ https://github.com/settings/ssh/new                         │"
echo "    │                                                             │"
echo "    │ Select 'Signing Key' as the key type.                       │"
echo "    │ (You can use the same key for both auth and signing)        │"
echo "    └─────────────────────────────────────────────────────────────┘"
echo ""

echo "==> Git setup complete"
