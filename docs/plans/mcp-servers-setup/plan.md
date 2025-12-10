# Plan: MCP Servers Setup

## Metadata

- **Task:** Set up Memory and GitHub MCP servers for Claude Code
- **Branch:** feat/mcp-servers-setup
- **Status:** IN_PROGRESS
- **Created:** 2025-12-10

## Summary

Configure two MCP servers to enhance Claude Code capabilities: Memory server for cross-session persistence, and GitHub server for structured GitHub API access. Both will use environment variables for secrets, with npx for zero-install convenience.

## Commits

### 1. Add MCP servers configuration to settings.json

**Goal:** Configure Memory and GitHub MCP servers with environment variable-based secret injection

**Files:**

- Modify: `/Users/leecheneler/.dotfiles/config/claude/settings.json`

**Checklist:**

- [x] Dev
- [x] Review
- [x] Present
- [x] Commit

**SHA:** 7e5caf9

---

### 2. Document MCP server setup and usage

**Goal:** Add comprehensive documentation for MCP server configuration, secret management, and agent usage patterns

**Files:**

- Modify: `/Users/leecheneler/.dotfiles/docs/claude-setup.md`

**Checklist:**

- [x] Dev
- [x] Review
- [ ] Present
- [ ] Commit

**SHA:** _pending_

---

## Dependencies

- Node.js (already configured via mise)
- GitHub CLI (`gh`) for token generation (already installed)
- 1Password CLI (`op`) for secure secret storage (optional, user can use `gh auth token` or manual export)

## Risks

- **Token security** - GITHUB_TOKEN must not be committed
  - Mitigation: Environment variable only, documented in .gitignore context
- **Memory file location** - Could be accidentally committed if inside dotfiles
  - Mitigation: Use `~/.claude-memory/` (outside dotfiles), document in setup guide
- **npx execution time** - First run may be slower while fetching packages
  - Mitigation: Accept tradeoff for zero-install convenience

## Out of Scope

- Automated secret injection wrapper scripts
- 1Password-specific integration
- Other MCP servers (sequential-thinking, postgres, etc.)
- Memory schema documentation (will evolve with usage)
- Agent instruction updates (agents will discover MCP tools naturally)

## Notes

- Memory server uses simple JSON file storage at configurable path via MEMORY_FILE_PATH
- GitHub server requires GITHUB_TOKEN with scopes: repo, read:org, read:user, read:project
- npx will use cached packages after first run, so performance impact is minimal
- Users can set environment variables via their preferred method (shell export, .env file, 1Password, etc.)
- Documentation should show multiple approaches without prescribing one
