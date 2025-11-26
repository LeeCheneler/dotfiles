# Dotfiles

Personal machine provisioning and configuration management.

## Usage

```bash
curl -fsSL https://raw.githubusercontent.com/leecheneler/dotfiles/main/apply.sh | bash
```

Same command for fresh machines and updates - it's idempotent.

## What's Installed

### CLI Tools

| Tool             | Purpose                              |
| ---------------- | ------------------------------------ |
| git, curl, jq    | Core utilities                       |
| ripgrep, fd, fzf | Fast search                          |
| bat, eza, tree   | Better cat/ls/tree                   |
| zoxide           | Smarter cd                           |
| mise             | Runtime manager (Node, Deno, Python) |
| gh               | GitHub CLI                           |
| starship         | Cross-shell prompt                   |

### GUI Apps

Google Chrome, VS Code, Docker Desktop, Kitty, Rectangle, 1Password, Slack, Raycast, Claude, Claude Code

### Shell Setup

- **zsh + zinit** - Fast plugin manager with lazy loading
- **Plugins** - autosuggestions, syntax-highlighting, completions, history-substring-search
- **Starship prompt** - Git status, language versions, command duration
- **Kitty terminal** - GPU-accelerated, Tokyo Night theme

## Structure

```
dotfiles/
├── apply.sh                 # Entry point
├── Brewfile                 # Homebrew packages
├── scripts/
│   ├── packages.sh          # Homebrew install + bundle
│   ├── shell.sh             # Shell config symlinks
│   ├── git.sh               # Git config + SSH keys
│   └── ai.sh                # AI tooling config
├── bin/
│   └── init-copilot         # Bootstrap copilot instructions
└── config/
    ├── zsh/.zshrc           # Zsh + zinit config
    ├── kitty/kitty.conf     # Kitty terminal config
    ├── starship/starship.toml
    ├── git/.gitconfig       # Git configuration
    ├── claude/              # Claude Code config
    └── copilot/             # Copilot instructions template
```

## How It Works

1. Installs Xcode CLI tools (if missing)
2. Clones/updates this repo to `~/.dotfiles`
3. Installs Homebrew (if missing) and all packages
4. Backs up existing configs to `~/.dotfiles-backup/`
5. Symlinks config files

## Runtime Version Management

Uses [mise](https://mise.jdx.dev/) for automatic version switching. When you `cd` into a directory with a version file, mise automatically installs (if needed) and activates the correct version.

**Supported version files:**

| Runtime | Files                                       |
| ------- | ------------------------------------------- |
| Node.js | `.node-version`, `.nvmrc`, `.tool-versions` |
| Deno    | `.deno-version`, `.tool-versions`           |
| Python  | `.python-version`, `.tool-versions`         |

**Quick start:**

```bash
# Install a runtime
mise use node@22
mise use deno@2

# In a project, create a version file
echo "22" > .node-version
# or use mise
mise use node@22  # creates .tool-versions
```

## Local Overrides

Create `~/.zshrc.local` for machine-specific config (not tracked in git):

```bash
# Example: work-specific paths
export PATH="/work/tools:$PATH"
```

## AI Tooling

### Claude Code

Global Claude Code configuration is symlinked to `~/.claude/`:

- `CLAUDE.md` - Global instructions
- `settings.json` - Auto-approve rules and preferences
- `hooks/` - Custom hooks (empty by default)
- `agents/` - Custom agents (empty by default)

### Copilot Instructions

Bootstrap `.github/copilot-instructions.md` into any repo:

```bash
cd your-project
init-copilot
```

This copies the template from `config/copilot/` - edit it to add project-specific context.

## Design

**Stateless and idempotent.** Removing something from config doesn't uninstall it - just stops managing it. Manual cleanup when needed.

See [PLAN.md](PLAN.md) for implementation details and roadmap.
