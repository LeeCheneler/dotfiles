# Dotfiles Project Plan

Personal machine provisioning and configuration management.

## Goals

1. Provision tools on any machine (node, brew, zsh, git, ssh, gpg, etc.)
2. Keep tools up to date
3. Single curl command to apply configuration to any machine
4. Stateless and idempotent - run it 100 times, get the same result
5. AI development tooling (Claude config, Copilot instructions, MCP servers)

## Design Decisions

### Stateless Over Stateful

Each run ensures desired state without tracking what was previously installed. Removing something from config does NOT remove it from the machine - manual uninstall when needed.

Why:

- You rarely remove tools in practice
- State sync across machines is a nightmare
- Manual removal is trivial (`brew uninstall X`)
- No state file to corrupt or lose

### Tool Choices

| Concern            | Choice          | Why                                    |
| ------------------ | --------------- | -------------------------------------- |
| Package management | Homebrew Bundle | Native, idempotent, handles casks/taps |
| Node versions      | fnm             | Faster than nvm, Rust-based            |
| Shell              | zsh + zinit     | Fast plugin manager, lazy loading      |
| Terminal           | Kitty           | GPU-accelerated, fast, extensible      |
| Prompt             | Starship        | Cross-shell, fast, sensible defaults   |
| Dotfile management | Shell scripts   | Simple, no extra dependencies          |

### Config File Backup Strategy

Before symlinking any config file, the script checks if the target exists and is not already our symlink. If it exists, it's backed up to `~/.dotfiles-backup/` with a timestamp before creating the symlink.

```
~/.zshrc (exists) → ~/.dotfiles-backup/.zshrc.20250525-143022
~/.zshrc → ~/.dotfiles/config/zsh/.zshrc (symlink created)
```

Why:

- Never destroys existing configuration
- Idempotent - re-running doesn't re-backup already-symlinked files
- Easy recovery - backups are timestamped and in one place

## Directory Structure

```
dotfiles/
├── apply.sh               # curl target, idempotent entry point
├── Brewfile               # homebrew packages
├── scripts/
│   ├── packages.sh        # brew bundle + non-brew packages
│   ├── shell.sh           # zsh, zinit, kitty, starship
│   ├── git.sh             # config, gpg signing, ssh keys
│   ├── macos.sh           # system preferences
│   └── ai.sh              # claude, copilot, mcp servers
├── config/
│   ├── zsh/
│   │   └── .zshrc         # zsh config with zinit plugins
│   ├── kitty/
│   │   └── kitty.conf     # kitty terminal config
│   ├── starship/
│   │   └── starship.toml  # starship prompt config
│   ├── git/
│   ├── claude/
│   └── copilot/
├── bin/
│   └── init-copilot       # bootstrap copilot instructions into a repo
├── .env.example           # template for secrets (actual .env gitignored)
├── PLAN.md
└── README.md
```

---

## Backlog

### Phase 1: Foundation

- [x] 1.1 Initialize git repo
- [x] 1.2 Create directory structure
- [x] 1.3 Write minimal `apply.sh` (clones repo, nothing else yet)
- [x] 1.4 Write README with usage instructions
- [x] 1.5 Add pre-commit formatting (shfmt, dprint, lefthook)
- [x] 1.6 Push to GitHub

### Phase 2: Package Management

- [x] 2.1 Create `Brewfile` with initial packages (brew, casks, taps)
- [x] 2.2 Write `scripts/packages.sh` - installs Homebrew if missing, runs bundle
- [x] 2.3 Update `apply.sh` to install Xcode CLI tools and call packages script
- [x] 2.4 Test: curl apply on fresh-ish terminal

### Phase 3: Shell Configuration

- [x] 3.1 Add starship and kitty to Brewfile
- [x] 3.2 Create `config/zsh/.zshrc` with zinit + plugins (autosuggestions, syntax-highlighting, completions)
- [x] 3.3 Create `config/kitty/kitty.conf` with sensible defaults
- [x] 3.4 Create `config/starship/starship.toml` with prompt config
- [x] 3.5 Write `scripts/shell.sh` - backup existing configs, symlink new ones, install zinit
- [x] 3.6 Update `apply.sh` to call shell.sh
- [x] 3.7 Test: new terminal session has full shell setup

### Phase 4: Git & GitHub

- [ ] 4.1 Add git config template to `config/git/`
- [ ] 4.2 Write `scripts/git.sh` - applies git config
- [ ] 4.3 Add SSH key generation (if not exists) + instructions to add to GitHub
- [ ] 4.4 Add GPG key setup for commit signing
- [ ] 4.5 Test: can clone private repos, commits are signed

### Phase 5: AI Development Tooling

- [ ] 5.1 Add Claude config to `config/claude/` (CLAUDE.md, settings)
- [ ] 5.2 Write `scripts/ai.sh` - symlinks Claude config
- [ ] 5.3 Add MCP server installation to `scripts/ai.sh`
- [ ] 5.4 Write `bin/init-copilot` - bootstraps `.github/copilot-instructions.md` into target repo
- [ ] 5.5 Add default copilot instructions template to `config/copilot/`
- [ ] 5.6 Document AI tooling in README

### Phase 6: Polish & Extras

- [ ] 6.1 Write `scripts/macos.sh` - sensible macOS defaults
- [ ] 6.2 Decide secrets strategy (Keychain? 1Password CLI? Prompt on first run?)
- [ ] 6.3 Add `.env.example` with required environment variables
- [ ] 6.4 Test full flow on fresh VM (UTM/Parallels)
- [ ] 6.5 Add shellcheck CI via GitHub Actions
- [ ] 6.6 Final README polish

---

## Usage (Target State)

```bash
curl -fsSL https://raw.githubusercontent.com/leecheneler/dotfiles/main/apply.sh | bash
```

Same command for fresh machines and updates - it's idempotent.

### Initialize Copilot Instructions in a Repo

```bash
~/.dotfiles/bin/init-copilot
# or if added to PATH:
init-copilot
```

---

## Notes

- **Secrets**: Never commit API keys or tokens. Use `.env` files (gitignored) or system keychain.
- **Testing**: Always test changes on a secondary machine or VM before relying on them.
- **Idempotency**: Every script must be safe to run multiple times.
