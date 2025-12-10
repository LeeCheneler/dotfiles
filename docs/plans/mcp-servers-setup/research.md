# Research: Setting up useful MCP servers for Claude Code

## Task

Setting up useful MCP (Model Context Protocol) servers for Claude Code to enhance development workflows and agent capabilities.

## Codebase Overview

### Current State

This is a macOS dotfiles repository for machine provisioning and configuration management. It includes comprehensive Claude Code setup with:

- Custom agents (researcher, planner, code-reviewer, test-writer, doc-writer, refactor-advisor, security-auditor, commit-message, pr-description)
- Structured workflow commands (/begin, /next, /resume, /status, /abort, /pr)
- Git operation hooks (pre-commit, pre-push, pre-pr, file protection)
- Global configuration via CLAUDE.md
- Permissions system in settings.json

### Tech Stack

- Shell: zsh with zinit
- Runtime manager: mise (Node.js, Deno, Python)
- Package manager: Homebrew
- Tools: ripgrep, fd, fzf, bat, eza, tree, zoxide, gh
- AI: Claude Code, GitHub Copilot
- Terminal: Kitty with Tokyo Night theme

### Relevant Directories

- `/Users/leecheneler/.dotfiles/config/claude/` - Claude Code configuration (symlinked to ~/.claude/)
- `/Users/leecheneler/.dotfiles/config/claude/agents/` - Specialized agent definitions
- `/Users/leecheneler/.dotfiles/config/claude/commands/` - Workflow slash commands
- `/Users/leecheneler/.dotfiles/config/claude/hooks/` - Git operation hooks
- `/Users/leecheneler/.dotfiles/config/claude/settings.json` - Permissions and configuration

## Relevant Files

| File                                                       | Relevance                                                         |
| ---------------------------------------------------------- | ----------------------------------------------------------------- |
| `/Users/leecheneler/.dotfiles/config/claude/settings.json` | Core configuration file where MCP servers would be configured     |
| `/Users/leecheneler/.dotfiles/config/claude/CLAUDE.md`     | Global instructions that could reference MCP capabilities         |
| `/Users/leecheneler/.dotfiles/Brewfile`                    | Package definitions - MCP servers may need dependencies installed |
| `/Users/leecheneler/.dotfiles/scripts/ai.sh`               | AI tooling setup script - logical place for MCP installation      |
| `/Users/leecheneler/.dotfiles/config/claude/agents/*.md`   | Agents that could leverage MCP tools                              |

## MCP Server Ecosystem Research

### What is MCP?

Model Context Protocol (MCP) is Anthropic's standard for connecting LLMs to external tools and data sources. MCP servers expose capabilities that Claude Code can invoke, extending beyond built-in tools.

### Current MCP Configuration Status

**Finding: No existing MCP configuration found**

- No MCP server entries in settings.json
- No MCP-related files in dotfiles
- No mcpServers configuration block
- Claude Code has built-in tools (Read, Write, Grep, Glob, Bash, WebSearch, WebFetch) but no external MCP servers configured

## MCP Server Recommendations

### Category 1: File System & Workspace Tools

**1. @modelcontextprotocol/server-filesystem**

- **Purpose**: Enhanced file system operations beyond built-in tools
- **Use cases**: Bulk file operations, advanced file watching, directory analysis
- **Agent benefit**: researcher (deep codebase traversal), refactor-advisor (identifying unused files)
- **Trade-off**: Overlaps with built-in Read/Write/Glob - may be redundant

**Recommendation: SKIP** - Built-in tools are sufficient

**2. @modelcontextprotocol/server-everything**

- **Purpose**: macOS Spotlight-like search across file contents
- **Use cases**: Finding code patterns, searching documentation, locating examples
- **Agent benefit**: researcher (finding similar implementations), test-writer (finding test examples)
- **Trade-off**: Overlaps significantly with Grep tool

**Recommendation: LOW PRIORITY** - Grep already provides powerful search

### Category 2: Git & GitHub Integration

**3. @modelcontextprotocol/server-github**

- **Purpose**: Rich GitHub API access (issues, PRs, discussions, projects)
- **Use cases**: Reading issue details, analyzing PR comments, checking CI status
- **Agent benefit**:
  - planner (reading related issues for context)
  - code-reviewer (checking PR discussion history)
  - doc-writer (linking to issues/PRs in documentation)
  - security-auditor (checking for security issues/alerts)
- **Trade-off**: `gh` CLI already available via Bash tool, but MCP provides structured data

**Recommendation: HIGH PRIORITY** - Complements existing gh CLI with structured API access

**4. Custom git-history MCP server**

- **Purpose**: Advanced git history analysis (blame, authorship, file evolution)
- **Use cases**: Understanding code context, identifying expertise, tracking changes
- **Agent benefit**: researcher (understanding why code exists), refactor-advisor (identifying legacy patterns)
- **Trade-off**: Would need custom implementation

**Recommendation: MEDIUM PRIORITY** - Useful but requires custom development

### Category 3: Database & Data Access

**5. @modelcontextprotocol/server-sqlite**

- **Purpose**: Query SQLite databases
- **Use cases**: Analyzing local databases, reading application data
- **Agent benefit**: test-writer (generating tests with realistic data), security-auditor (checking for SQL injection)
- **Trade-off**: Limited to SQLite; most projects use PostgreSQL/MySQL in production

**Recommendation: LOW PRIORITY** - Not universally applicable

**6. @modelcontextprotocol/server-postgres**

- **Purpose**: Query PostgreSQL databases
- **Use cases**: Schema inspection, data analysis, migration verification
- **Agent benefit**: test-writer (generating integration tests), doc-writer (documenting database schema)
- **Trade-off**: Requires connection credentials; security risk if misconfigured

**Recommendation: MEDIUM PRIORITY** - Useful for backend projects, but requires careful security setup

### Category 4: Web Browsing & Data Fetching

**7. @modelcontextprotocol/server-puppeteer**

- **Purpose**: Browser automation and web scraping
- **Use cases**: Testing web interfaces, capturing screenshots, extracting dynamic content
- **Agent benefit**: test-writer (E2E test generation), doc-writer (capturing UI examples)
- **Trade-off**: Heavy dependency (full Chrome browser), slow execution

**Recommendation: LOW PRIORITY** - Too heavy for typical development workflows

**8. Built-in WebSearch and WebFetch**

- **Status**: Already enabled in settings.json
- **Purpose**: Search the web and fetch webpage contents
- **Agent benefit**: researcher (looking up API documentation), security-auditor (checking CVE databases)

**Recommendation: ALREADY CONFIGURED** - Keep enabled

### Category 5: Memory & Context Persistence

**9. @modelcontextprotocol/server-memory**

- **Purpose**: Persistent key-value storage across sessions
- **Use cases**: Remembering user preferences, storing project context, tracking decisions
- **Agent benefit**:
  - All agents (remembering project-specific patterns)
  - planner (recalling previous architectural decisions)
  - researcher (caching codebase knowledge)
- **Trade-off**: Adds statefulness; could become stale if not managed

**Recommendation: HIGH PRIORITY** - Excellent for multi-session workflows

### Category 6: Code Analysis & Search

**10. @modelcontextprotocol/server-sequential-thinking**

- **Purpose**: Structured reasoning framework for complex problems
- **Use cases**: Breaking down complex tasks, systematic analysis
- **Agent benefit**: planner (structured planning), refactor-advisor (systematic code analysis)
- **Trade-off**: Adds reasoning overhead; may slow responses

**Recommendation: MEDIUM PRIORITY** - Could improve planning quality

**11. Tree-sitter MCP server (custom)**

- **Purpose**: Parse code into ASTs for structural analysis
- **Use cases**: Finding all functions, analyzing code structure, identifying patterns
- **Agent benefit**: refactor-advisor (finding similar code), test-writer (identifying untested functions)
- **Trade-off**: Requires custom implementation and tree-sitter grammars

**Recommendation: LOW PRIORITY** - High complexity, Grep handles most cases

### Category 7: Documentation Access

**12. @modelcontextprotocol/server-fetch**

- **Purpose**: Fetch and parse web content with various formats
- **Use cases**: Reading online API docs, fetching READMEs from other repos
- **Agent benefit**: researcher (checking similar projects), doc-writer (referencing official docs)
- **Trade-off**: Overlaps with WebFetch built-in tool

**Recommendation: SKIP** - WebFetch already enabled

### Category 8: Security Scanning

**13. npm-audit MCP server (custom)**

- **Purpose**: Run npm/pnpm/yarn audit and parse results
- **Use cases**: Dependency vulnerability scanning
- **Agent benefit**: security-auditor (comprehensive security analysis)
- **Trade-off**: Could be implemented as Bash commands instead

**Recommendation: LOW PRIORITY** - Bash tool can run audit commands directly

**14. OWASP ZAP MCP server (custom)**

- **Purpose**: Automated security testing for web applications
- **Use cases**: Penetration testing, vulnerability scanning
- **Agent benefit**: security-auditor (automated security checks)
- **Trade-off**: Complex setup, requires running service

**Recommendation: LOW PRIORITY** - Overkill for most projects

### Category 9: Development Tools

**15. @modelcontextprotocol/server-brave-search**

- **Purpose**: Search via Brave Search API (privacy-focused alternative to Google)
- **Use cases**: Web research, finding code examples, checking documentation
- **Agent benefit**: researcher (privacy-conscious web search)
- **Trade-off**: Requires API key, overlaps with WebSearch

**Recommendation: LOW PRIORITY** - WebSearch already available

**16. @modelcontextprotocol/server-slack**

- **Purpose**: Read and send Slack messages
- **Use cases**: Notifying team of completions, reading team discussions
- **Agent benefit**: pr-description (notifying team of PRs), researcher (understanding team context)
- **Trade-off**: Requires OAuth setup, potential privacy concerns

**Recommendation: LOW PRIORITY** - Better done manually

## Existing Patterns

### Configuration Pattern

Claude Code uses a centralized settings.json for all configuration:

```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep", "Bash(git:*)", "WebSearch", "WebFetch"],
    "deny": [],
    "ask": [],
    "defaultMode": "default"
  },
  "hooks": {
    "PreToolUse": [...]
  }
}
```

MCP servers would be added in a new `mcpServers` section:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "<from-1password>"
      }
    }
  }
}
```

### Security Pattern

Based on existing security practices:

- Never commit secrets (CLAUDE.md line 50)
- Use 1Password for secret storage (README.md line 174)
- Principle of least privilege (CLAUDE.md line 54)

MCP server credentials should:

1. Be stored in 1Password
2. Be injected via environment variables
3. Never be committed to git

### Installation Pattern

Based on existing dotfiles structure:

- Package installation via Brewfile
- Configuration symlinked from config/ directory
- Setup scripts in scripts/ directory
- Documentation in docs/

MCP setup should follow same pattern:

1. Install Node.js via mise (already configured)
2. Define MCP servers in settings.json
3. Document in docs/claude-setup.md
4. Add setup script if needed (scripts/mcp.sh)

## Documentation Found

### Vision

No explicit vision document found, but philosophy is clear from CLAUDE.md:

- Quality over speed
- Simple beats clever
- Security is non-negotiable
- DX matters

This suggests MCP servers should:

- Enhance quality without sacrificing simplicity
- Not introduce security risks
- Improve developer experience tangibly

### ADRs

No formal ADR directory found. Project uses inline documentation in markdown files.

### READMEs

**README.md** - Main dotfiles documentation

- Documents all tools, configuration, workflow
- Shows preference for simple, proven tools
- Emphasizes idempotency and reproducibility

**docs/claude-setup.md** - Claude Code documentation

- Comprehensive documentation of agents, commands, workflow
- Shows sophisticated agent system with clear responsibilities
- Documents hooks for safety (protect-files, pre-commit, pre-push, pre-pr)

### Existing Plans

Directory `/Users/leecheneler/.dotfiles/docs/plans/` exists with this task's plan.

## Key Considerations

### 1. Tool Overlap

Built-in Claude Code tools are already powerful:

- **Read/Write/Glob** - File operations
- **Grep** - Content search
- **Bash** - Shell commands (git, gh, npm, etc.)
- **WebSearch/WebFetch** - Web access

MCP servers should complement, not duplicate these capabilities.

### 2. Security Implications

Adding MCP servers increases attack surface:

- MCP servers run arbitrary code
- Servers may require API credentials
- Credential leakage could compromise accounts

Mitigation:

- Only install MCP servers from trusted sources
- Store credentials in 1Password
- Use environment variable injection
- Review MCP server code before installing

### 3. Complexity vs Value

Each MCP server adds:

- Installation complexity
- Configuration overhead
- Potential failure points
- Maintenance burden

Only add MCP servers with clear, high-value use cases.

### 4. Agent Enhancement Opportunities

**Most valuable for existing agents:**

| Agent            | MCP Servers                         | Benefits                                                  |
| ---------------- | ----------------------------------- | --------------------------------------------------------- |
| researcher       | GitHub, Memory                      | Read issues/PRs for context; remember project patterns    |
| planner          | GitHub, Memory, Sequential-thinking | Read issue details; recall decisions; structured planning |
| security-auditor | GitHub                              | Check security advisories and issues                      |
| code-reviewer    | GitHub                              | Read PR comments and history                              |
| doc-writer       | GitHub, Memory                      | Link to issues/PRs; remember documentation style          |

**GitHub MCP server** is the clear winner - benefits 5 out of 9 agents significantly.

**Memory MCP server** is second - benefits all agents by persisting knowledge across sessions.

### 5. Implementation Approach

**Phase 1: High-value, low-risk**

1. Install GitHub MCP server
2. Configure with GITHUB_TOKEN from 1Password
3. Document usage patterns for agents
4. Test with researcher and planner agents

**Phase 2: Experiment with memory**

1. Install Memory MCP server
2. Test persistence across sessions
3. Document key-value schema for different agents
4. Evaluate stale data management

**Phase 3: Evaluate others**

1. Monitor agent workflows for pain points
2. Identify specific tool gaps
3. Add targeted MCP servers only when clear need emerges

### 6. Configuration Location

MCP servers should be configured in:

```
/Users/leecheneler/.dotfiles/config/claude/settings.json
```

This file is already symlinked to `~/.claude/settings.json` via the apply.sh script.

### 7. Secret Management

GitHub token acquisition:

```bash
# Create token via gh CLI
gh auth token

# Or create via 1Password
# Store in 1Password as "GitHub Personal Access Token (Claude MCP)"
# Scopes needed: repo, read:org, read:user, read:project
```

Token should NOT be in settings.json directly. Options:

1. Environment variable: `GITHUB_TOKEN=xxx claude-code`
2. Script wrapper that injects from 1Password
3. .env file (local only, gitignored)

## Recommended Approach

### Step 1: Baseline MCP Configuration

Add mcpServers section to settings.json with GitHub server:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### Step 2: Secret Injection Strategy

Create wrapper script or document manual process:

**Option A: Environment variable (simple)**

```bash
export GITHUB_TOKEN=$(gh auth token)
claude-code
```

**Option B: 1Password CLI (secure)**

```bash
export GITHUB_TOKEN=$(op read "op://Private/GitHub Claude MCP/token")
claude-code
```

**Option C: Shell integration (seamless)**
Add to ~/.zshrc:

```bash
# Claude Code with secrets from 1Password
alias claude-code-full='GITHUB_TOKEN=$(op read "op://Private/GitHub Claude MCP/token") claude-code'
```

### Step 3: Documentation Updates

Update docs/claude-setup.md with:

- MCP servers section
- Configuration instructions
- Secret management approach
- Usage examples for each agent

### Step 4: Test with Agents

Test GitHub MCP integration:

1. Use researcher agent to read issue details from a GitHub project
2. Use planner agent to incorporate issue requirements
3. Use security-auditor to check GitHub security advisories
4. Use code-reviewer to read PR discussion

### Step 5: Memory Server (Phase 2)

If GitHub MCP proves valuable, add Memory server:

```json
{
  "mcpServers": {
    "github": { ... },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

Document memory schema:

- `project:<name>:patterns` - Code patterns for project
- `project:<name>:decisions` - Architectural decisions
- `agent:<agent>:preferences` - Agent-specific learned preferences

## Priority Ranking

| Priority | MCP Server                                       | Rationale                                                  |
| -------- | ------------------------------------------------ | ---------------------------------------------------------- |
| 1        | @modelcontextprotocol/server-github              | High value for 5+ agents, relatively safe, trusted source  |
| 2        | @modelcontextprotocol/server-memory              | Improves all agents, low risk, trusted source              |
| 3        | @modelcontextprotocol/server-sequential-thinking | Could improve planner, low risk, trusted source            |
| 4        | @modelcontextprotocol/server-postgres            | Useful for backend work, moderate security risk            |
| 5        | Custom git-history server                        | Good for researcher/refactor-advisor, requires development |

## Open Questions

None - research is sufficient to proceed.

## Security Checklist

Before installing any MCP server:

- [ ] Verify source is trusted (official @modelcontextprotocol namespace or vetted author)
- [ ] Review package code/README for security practices
- [ ] Identify what credentials are required
- [ ] Determine credential storage approach (1Password)
- [ ] Document secret injection method
- [ ] Test in isolated environment first
- [ ] Document rollback procedure
- [ ] Add to settings.local.json first (not committed), then promote to settings.json only after verification

## Next Steps

1. Create plan with commit breakdown for implementing MCP server configuration
2. Set up GitHub MCP server with secure credential management
3. Update documentation with MCP configuration and usage
4. Test with researcher and planner agents
5. Document learnings and iterate
