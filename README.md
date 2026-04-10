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
│   └── init-copilot         # Bootstrap copilot instructions
└── config/
    ├── zsh/.zshrc           # Zsh + zinit config
    ├── kitty/kitty.conf     # Kitty terminal config
    ├── starship/starship.toml
    ├── git/.gitconfig       # Git configuration
    ├── vscode/              # VSCode settings + extensions
    ├── claude/              # Claude Code config (skills, agents)
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

- `CLAUDE.md` - Global instructions (principles, security rules, workflow)
- `settings.json` - Permissions (deny/ask/allow), hooks, notifications
- `skills/` - Fat skills with full instructions, auto-loaded by context
- `agents/` - Thin agent runners for isolated execution contexts

#### Skills

| Skill                | Purpose                                  |
| -------------------- | ---------------------------------------- |
| `/commit`            | Conventional commit with guards          |
| `/pr`                | Create pull request                      |
| `/review [target]`   | Code review (isolated context)           |
| `/test [scope]`      | Run tests (isolated context)             |
| `/research <topic>`  | Research codebase, web, or both          |
| `/claude-md`         | Generate project CLAUDE.md from codebase |
| `/quick-spec <task>` | Spec for simple work                     |
| `/slow-spec <task>`  | Research + detailed spec with milestones |
| `/do-spec [slug]`    | Execute an approved spec                 |

Auto-loaded reference skills: `coding` (TypeScript, React, testing conventions).

#### Agents

| Agent         | Purpose                             |
| ------------- | ----------------------------------- |
| `researcher`  | Codebase and web research           |
| `reviewer`    | Code review                         |
| `test-runner` | Run tests, return pass/fail summary |
| `committer`   | Create commits                      |
| `pr-creator`  | Create pull requests                |

#### Project Setup

Generate a project-specific CLAUDE.md by running `/claude-md` inside a Claude Code session. This analyzes the repo and creates a `CLAUDE.md` at the project root with stack, conventions, architecture, and gotchas.

### Copilot Instructions

Bootstrap `.github/copilot-instructions.md` into any repo:

```bash
cd your-project
init-copilot
```

This copies the template from `config/copilot/` - edit it to add project-specific context.

### Local LLMs

Two options for running models locally:

- **Ollama** (`ollama-app`) - easy model management with a curated library
- **MLX + Hugging Face** (`mlx-lm`, `hf`) - run any HF model natively on Apple Silicon

#### Ollama

```bash
ollama pull llama3.2          # Pull a model
ollama run llama3.2           # Interactive chat
ollama list                   # List installed models
ollama rm llama3.2            # Remove a model
```

Browse models at [ollama.com/library](https://ollama.com/library).

#### Hugging Face + MLX

```bash
hf auth login                             # Authenticate (needed for gated models)
hf download mlx-community/Llama-3.2-3B-Instruct-4bit
mlx_lm.generate --model mlx-community/Llama-3.2-3B-Instruct-4bit \
  --prompt "Explain MLX in one sentence"
```

The `mlx-community` org on HF hosts pre-quantized models optimized for Apple Silicon. Models are cached under `~/.cache/huggingface/`.

#### MLX Server (Ollama-style API)

Run `mlx_lm.server` in the background and hit it with OpenAI-compatible requests. Model is selected per-request via the `model` field — no need to restart the server to switch models.

```bash
mlx-server start    # Start in background
mlx-server status   # Show pid and URL
mlx-server logs     # Tail the log
mlx-server stop     # Stop
mlx-server restart  # Restart
```

Default bind: `http://127.0.0.1:8080`. Override with `MLX_SERVER_HOST` / `MLX_SERVER_PORT`. Logs live at `~/.local/state/mlx-server/mlx-server.log`.

Example request:

```bash
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Llama-3.2-3B-Instruct-4bit",
    "messages": [{"role": "user", "content": "hello"}]
  }'
```

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
