#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
SSH_KEY="$HOME/.ssh/id_ed25519"
GPG_EMAIL="leecheneler@users.noreply.github.com"

# shellcheck source=lib/helpers.sh
source "$DOTFILES_DIR/scripts/lib/helpers.sh"

echo "==> Setting up git"

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
if (ssh -T git@github.com 2>&1 || true) | grep -q "successfully authenticated"; then
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
