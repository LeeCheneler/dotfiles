# =============================================================================
# Zinit Installation
# =============================================================================

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install zinit if not present
if [[ ! -d "$ZINIT_HOME" ]]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# =============================================================================
# Plugins (loaded with turbo mode for fast startup)
# =============================================================================

# Syntax highlighting - must be loaded before autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Autosuggestions (fish-like suggestions as you type)
zinit light zsh-users/zsh-autosuggestions

# Additional completions
zinit light zsh-users/zsh-completions

# Better history search with up/down arrows
zinit light zsh-users/zsh-history-substring-search

# =============================================================================
# Completion System
# =============================================================================

autoload -Uz compinit
compinit

zinit cdreplay -q

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Completion menu with selection
zstyle ':completion:*' menu select

# Colors in completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# =============================================================================
# History Configuration
# =============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_ALL_DUPS  # Don't record duplicates
setopt HIST_FIND_NO_DUPS     # Don't show duplicates when searching
setopt HIST_SAVE_NO_DUPS     # Don't save duplicates
setopt SHARE_HISTORY         # Share history between sessions
setopt APPEND_HISTORY        # Append to history file
setopt INC_APPEND_HISTORY    # Write immediately, not on exit

# =============================================================================
# Key Bindings
# =============================================================================

# Use emacs-style key bindings
bindkey -e

# History substring search with up/down arrows
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# =============================================================================
# Tool Initialization
# =============================================================================

# Starship prompt
eval "$(starship init zsh)"

# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

# mise (polyglot runtime manager - Node, Deno, Python, etc.)
# Automatically installs and switches versions based on .node-version, .nvmrc,
# .tool-versions, or mise.toml when changing directories
eval "$(mise activate zsh)"

# fzf key bindings and completion
source <(fzf --zsh)

# =============================================================================
# Aliases
# =============================================================================

# Use modern replacements
alias ls='eza'
alias ll='eza -la'
alias la='eza -a'
alias lt='eza --tree'
alias cat='bat'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# =============================================================================
# Environment Variables
# =============================================================================

export EDITOR='code --wait'
export VISUAL='code --wait'

# Add dotfiles bin to PATH
export PATH="$HOME/.dotfiles/bin:$PATH"

# Claude Code CLI
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# =============================================================================
# Secrets (loaded from 1Password)
# =============================================================================

if command -v op &>/dev/null; then
	export GITHUB_PACKAGES_TOKEN="$(op read 'op://Private/GitHub PAT/credential')"
fi

# =============================================================================
# Local Overrides (machine-specific, not in repo)
# =============================================================================

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
