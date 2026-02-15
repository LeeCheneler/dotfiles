---
description: "Apply when creating commits, reviewing commit messages, or
  planning commit breakdowns. Covers conventional commit format and atomicity."
---

# Commit Conventions

## Format

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

## Rules

- NEVER mention Claude, AI, or any AI tool in commit messages.
- Each commit should be atomic — one logical change that leaves the
  codebase in a working state.
- If a change touches more than 10 files, consider splitting into
  multiple commits.
- Don't commit generated files, build artifacts, or debug code.
- Don't commit .env files, secrets, or credentials.

## Examples

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

## Atomicity

A good commit should be:

- **Reviewable** in isolation — a reviewer can understand it without context
  from other commits
- **Reversible** cleanly — reverting it doesn't break other things
- **Describable** in under 72 characters — if you can't, it's doing too much
