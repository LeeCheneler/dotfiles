---
name: commit-authoring
description: "Conventions for writing commits and creating clean, conventional
  commits for staged changes. Auto-loads when writing commit messages.
  Invoke with /commit-authoring to commit current changes."
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

# Commit Authoring

## Conventions

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

- **type:** feat, fix, refactor, test, docs, chore, perf, ci, style, build
- **scope:** the primary area of change (module name, feature area)
- **description:** imperative mood, lowercase, no period, under 72 chars
- **body:** concise bullet points on what and why (not how), when the change
  is complex enough to warrant it
- **footer:** reference issue/ticket numbers if relevant

### Rules

- NEVER mention Claude, AI, or any AI tool in commit messages.
- Each commit should be atomic — one logical change that leaves the
  codebase in a working state.
- If a change touches more than 10 files, consider splitting into
  multiple commits.
- Don't commit generated files, build artifacts, or debug code.
- Don't commit .env files, secrets, or credentials.

### Examples

```
Good:
  feat(auth): add password reset flow
  fix(api): handle null response from payment provider
  refactor(users): extract email validation to shared util
  test(checkout): add edge cases for expired discount codes

Bad:
  Updated files
  fix bug
  feat: Add New User Authentication Flow Using OAuth2
  refactor(users): refactored user service to extract email validation
    into a shared utility function
  fix(api): fixed the bug where payment provider returns null (AI-generated)
```

### Atomicity

A good commit should be:

- **Reviewable** in isolation — a reviewer can understand it without context
  from other commits
- **Reversible** cleanly — reverting it doesn't break other things
- **Describable** in under 72 characters — if you can't, it's doing too much

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
