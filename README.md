# 🏠 Dotfiles

Personal machine provisioning and configuration management.

## 🚀 Usage

```bash
curl -fsSL https://raw.githubusercontent.com/leecheneler/dotfiles/main/apply.sh | bash
```

Same command for fresh machines and updates - it's idempotent.

## 📦 What's Installed

### CLI Tools

| Tool              | Purpose                              |
| ----------------- | ------------------------------------ |
| git, curl, jq     | Core utilities                       |
| ripgrep, fd, fzf  | Fast search                          |
| bat, eza, tree    | Better cat/ls/tree                   |
| zoxide            | Smarter cd                           |
| mise              | Runtime manager (Node, Deno, Python) |
| gh                | GitHub CLI                           |
| starship          | Cross-shell prompt                   |
| shfmt, shellcheck | Shell formatting and linting         |
| dprint, lefthook  | Formatting and git hooks             |

### 🖥️ GUI Apps

Google Chrome, VS Code, Docker Desktop, Kitty, Rectangle, 1Password, 1Password CLI, Slack, Raycast, Claude, Claude Code, SuperWhisper

### 🐚 Shell Setup

- **zsh + zinit** - Fast plugin manager with lazy loading
- **Plugins** - autosuggestions, syntax-highlighting, completions, history-substring-search
- **Starship prompt** - Git status, language versions, command duration
- **Kitty terminal** - GPU-accelerated, Tokyo Night theme

### 🆚 VSCode

Declarative extension management - extensions not in the list are removed.

| Category       | Extensions                                        |
| -------------- | ------------------------------------------------- |
| Formatting     | Biome                                             |
| TypeScript     | Pretty TS Errors, TS Error Translator             |
| React/Styling  | Auto Rename Tag, Tailwind CSS, UnoCSS             |
| Testing        | Vitest, Playwright, Jest                          |
| Git/GitHub     | GitLens, Git Graph, GitHub Actions                |
| AI             | GitHub Copilot, Copilot Chat                      |
| Infrastructure | Terraform, HCL                                    |
| DX             | Error Lens, Path Intellisense, dotenv, YAML, etc. |
| Theme          | Tokyo Night, Material Icon Theme                  |

## 📁 Structure

```
dotfiles/
├── apply.sh                 # Entry point (curl target)
├── Brewfile                 # Homebrew packages
├── scripts/
│   ├── lib/helpers.sh       # Shared helper functions
│   ├── packages.sh          # Homebrew install + bundle
│   ├── shell.sh             # Shell config symlinks
│   ├── vscode.sh            # VSCode settings + extensions
│   ├── git.sh               # Git config + SSH keys
│   └── ai.sh                # AI tooling config
├── bin/
│   ├── init-claude          # Bootstrap Claude project instructions
│   └── init-copilot         # Bootstrap copilot instructions
└── config/
    ├── zsh/.zshrc           # Zsh + zinit config
    ├── kitty/kitty.conf     # Kitty terminal config
    ├── starship/starship.toml
    ├── git/.gitconfig       # Git configuration
    ├── vscode/              # VSCode settings + extensions
    ├── claude/              # Claude Code config
    └── copilot/             # Copilot instructions template
```

## ⚙️ How It Works

1. Installs Xcode CLI tools (if missing)
2. Clones/updates this repo to `~/.dotfiles`
3. Installs Homebrew (if missing) and all packages
4. Backs up existing configs to `~/.dotfiles-backup/`
5. Symlinks config files
6. Installs VSCode extensions (removes unlisted ones)

## 🔄 Runtime Version Management

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

## 🔧 Local Overrides

Create `~/.zshrc.local` for machine-specific config (not tracked in git):

```bash
# Example: work-specific paths
export PATH="/work/tools:$PATH"
```

## 🤖 AI Tooling

### Claude Code

Global Claude Code configuration is symlinked to `~/.claude/`:

- `CLAUDE.md` - Global instructions
- `settings.json` - Auto-approve rules and preferences
- `commands/` - Slash commands for structured workflows
- `hooks/` - Custom hooks (file protection, git operations)
- `agents/` - Specialized agents for development tasks

#### Agents

| Agent              | Purpose                                                         |
| ------------------ | --------------------------------------------------------------- |
| `researcher`       | Deep codebase exploration, outputs research.md                  |
| `planner`          | Create implementation plans with commit breakdown               |
| `code-reviewer`    | Review code changes for quality, patterns, security             |
| `test-writer`      | Generate tests following black-box, behavior-focused philosophy |
| `test-runner`      | Run tests, return concise pass/fail summary                     |
| `security-auditor` | Audit for OWASP Top 10, dependency vulnerabilities, secrets     |
| `commit-message`   | Generate conventional commit messages                           |
| `pr-description`   | Generate comprehensive PR descriptions                          |

#### Project Setup

Bootstrap project-specific Claude instructions:

```bash
cd your-project
init-claude
```

This prints a prompt to paste into Claude, which will analyze your codebase and generate a `.claude/CLAUDE.md` tailored to the project.

### Copilot Instructions

Bootstrap `.github/copilot-instructions.md` into any repo:

```bash
cd your-project
init-copilot
```

This copies the template from `config/copilot/` - edit it to add project-specific context.

## 🔐 Secrets

Uses [1Password CLI](https://1password.com/) for secrets management. Tokens are loaded on-demand to avoid authentication popups at shell startup:

```bash
load-secrets  # Loads GITHUB_TOKEN and GITHUB_PACKAGES_TOKEN
```

Never commit API keys or tokens.

## 🔄 Updating Apps

Update all Homebrew packages, casks, and Brewfile entries in one command:

```bash
update-apps
```

This runs `brew update`, installs any new Brewfile entries, upgrades all formulae and casks, and cleans up old versions.

## 🎨 Design

**Stateless and idempotent.** Removing something from config doesn't uninstall it - just stops managing it. Manual cleanup when needed (`brew uninstall X`).
