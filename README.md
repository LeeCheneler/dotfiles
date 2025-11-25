# Dotfiles

Personal machine provisioning and configuration management.

## Quick Start

### Fresh Machine

```bash
curl -fsSL https://raw.githubusercontent.com/leecheneler/dotfiles/main/bootstrap.sh | bash
```

### Update Existing

```bash
cd ~/.dotfiles && git pull && ./bootstrap.sh
```

## What's Included

- **Package management** - Homebrew packages, casks, and taps via Brewfile
- **Shell** - zsh configuration with zinit plugins
- **Git** - Config, SSH keys, GPG signing
- **AI tooling** - Claude Code config, MCP servers, Copilot instructions

## Structure

```
dotfiles/
├── bootstrap.sh       # Entry point
├── Brewfile           # Homebrew packages
├── scripts/           # Setup scripts
├── config/            # Dotfiles and configs
└── bin/               # Custom scripts (added to PATH)
```

## Design

**Stateless and idempotent.** Run it as many times as you want - each run ensures the desired state without tracking what was previously installed.

See [PLAN.md](PLAN.md) for detailed implementation plan.
