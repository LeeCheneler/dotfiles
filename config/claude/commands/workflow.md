---
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Edit
  - Bash(git:*)
  - Bash(gh:*)
  - Bash(npm:*)
  - Bash(npx:*)
  - Bash(yarn:*)
  - Bash(pnpm:*)
  - Bash(make:*)
  - Bash(ls:*)
  - Bash(tree:*)
  - Bash(cargo:*)
  - Bash(go:*)
  - Bash(pytest:*)
---

Evaluate the task and route it to the most appropriate workflow.

## Routing Criteria

### SIMPLE — Use when ALL of these are true:

- Single concern (one file, one function, one doc, one config change)
- No ambiguity about what needs to change
- No cross-cutting concerns across multiple modules
- Estimated effort: under 15 minutes

**Flow:** Read the relevant code → make the edit(s) → run tests if they
exist for the affected area → /commit.

### PIPELINE — Use when ANY of these are true:

- Multiple files need coordinated changes
- Requires exploring the codebase first to understand the landscape
- Has clear milestones (e.g., "add API endpoint + tests + docs")
- Involves refactoring, migration, or feature implementation
- Estimated effort: 15 minutes to 2 hours, or 3-20 files affected

**Flow:**

1. Research: use the **researcher agent** to explore relevant code, docs,
   tests, dependencies. It writes findings to `docs/work/<slug>/research.md`.
2. Plan (main context): break into numbered milestones, each = one atomic
   commit. Include gate criteria, commit messages, risks. Penultimate
   milestone: extract ADRs. Final milestone: delete the work directory.
   Write to `docs/work/<slug>/plan.md`. Ask what gate mode to use
   (continuous or gated).
3. Present plan. Wait for approval before executing.
4. Execute milestones sequentially on main context. After each milestone:
   use the **test-runner agent** to verify tests, update plan.md, /commit.
   Check-in behavior depends on the gate mode:
   - **continuous**: report status and continue unless stopped
   - **gated**: report status and wait for explicit go-ahead
     Individual milestones can override the default gate mode.
5. Finalize: use **test-runner agent** for full test suite, propose any
   CLAUDE.md learnings (present diff for approval), extract ADRs, delete
   work directory, /pr.

## After routing, announce:

"**Routing to [SIMPLE|PIPELINE] because:** <one-line reason>"

The user can override: "No, use pipeline for this." Always respect overrides.

## Task:

$ARGUMENTS
