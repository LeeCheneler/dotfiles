# Dotfiles Project Plan

Personal machine provisioning and configuration management.

## Goals

1. Provision tools on any machine (node, brew, zsh, git, ssh, gpg, etc.)
2. Keep tools up to date
3. Single curl command to bootstrap a fresh machine
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
| Dotfile management | Shell scripts   | Simple, no extra dependencies          |

## Directory Structure

```
dotfiles/
├── bootstrap.sh           # curl target, pure shell, minimal
├── Brewfile               # homebrew packages
├── scripts/
│   ├── packages.sh        # brew bundle + non-brew packages
│   ├── shell.sh           # zsh, plugins, config
│   ├── git.sh             # config, gpg signing, ssh keys
│   ├── macos.sh           # system preferences
│   └── ai.sh              # claude, copilot, mcp servers
├── config/
│   ├── zsh/
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
- [x] 1.3 Write minimal `bootstrap.sh` (clones repo, nothing else yet)
- [x] 1.4 Write README with usage instructions
- [x] 1.5 Add pre-commit formatting (shfmt, dprint, lefthook)
- [x] 1.6 Push to GitHub

### Phase 2: Package Management

- [ ] 2.1 Create `Brewfile` with initial packages (brew, casks, taps)
- [ ] 2.2 Write `scripts/packages.sh` - installs Homebrew if missing, runs bundle
- [ ] 2.3 Update `bootstrap.sh` to install Xcode CLI tools and call packages script
- [ ] 2.4 Test: curl bootstrap on fresh-ish terminal

### Phase 3: Shell Configuration

- [ ] 3.1 Add zsh config files to `config/zsh/`
- [ ] 3.2 Write `scripts/shell.sh` - symlinks configs, installs zinit + plugins
- [ ] 3.3 Define plugin list (syntax highlighting, autosuggestions, completions, etc.)
- [ ] 3.4 Test: new terminal session has full shell setup

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

### Fresh Machine Setup

```bash
curl -fsSL https://raw.githubusercontent.com/leecheneler/dotfiles/main/bootstrap.sh | bash
```

### Update Existing Machine

```bash
cd ~/.dotfiles && git pull && ./bootstrap.sh
```

### Bootstrap Copilot Instructions in a Repo

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
