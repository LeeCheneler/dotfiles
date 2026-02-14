---
model: sonnet
allowed-tools:
  - Bash(git diff:*)
  - Bash(git add:*)
  - Bash(git commit:*)
  - Bash(git status)
  - Bash(git log:*)
  - Bash(git stash:*)
  - Read
---

Create a clean, conventional commit for the current changes.

## Process

1. Run `git diff --staged`. If nothing is staged, run `git diff` and stage
   the relevant files. Ask if it's ambiguous which files to include.

2. Analyze the diff:
   - What changed and why
   - How many files affected
   - Red flags: secrets, .env files, debug code (console.log, debugger
     statements), large binaries, generated files, TODO/FIXME additions

3. If red flags found, report them and STOP. Do not proceed without explicit
   confirmation.

4. Generate a conventional commit message:
   - Format: `<type>(<scope>): <description>`
   - Types: feat, fix, refactor, test, docs, chore, perf, ci, style, build
   - Scope: derive from the primary area of change
   - Description: imperative mood, lowercase, no period, under 72 chars
   - Body (if the change is complex): concise bullet points on what and why
   - Footer: reference ticket/issue numbers if mentioned in the conversation
   - NEVER mention Claude, AI, or any AI tool anywhere in the commit

5. Commit immediately. Do not ask for confirmation — the user invoked this
   command because they want a commit, not a review.

## Guards

- REFUSE to commit if .env, credentials, secrets, or API keys are staged
- WARN if committing generated/build files (dist/, build/, node_modules/)
- WARN if commit is unusually large (more than 10 files) — suggest splitting
- WARN if tests are failing in the affected area (flag it, don't block)
