# Workflows

## Simple Workflow

For single-concern, unambiguous changes under 15 minutes.

```
Read relevant code → Make edit(s) → Run tests → /commit
```

No plan files. No gates. Just do the thing.

## Pipeline Workflow

For multi-file, multi-step work that benefits from planning.

### Phases

1. **Research** — explore code, docs, tests, deps → `docs/work/<slug>/research.md`
2. **Plan** — milestones, gates, commit messages → `docs/work/<slug>/plan.md`
3. **⏸️ Gate** — present plan, wait for approval
4. **Execute** — work through milestones, committing after each
5. **Finalize** — test suite, propose learnings, extract ADRs, delete work
   dir, /pr

### Gate Modes

Set in the plan file's Config section:

- **continuous** (default) — status update after each milestone, keeps going
- **gated** — pauses after each milestone, waits for explicit go-ahead

Individual milestones can override the default gate mode.

### Plan Lifecycle

1. Created by /plan or /workflow (pipeline route)
2. Lives in docs/work/<slug>/ during execution
3. Updated during execution with progress and deviations
4. At finalize: relevant ADRs extracted to docs/decisions/
5. Plan and work directory deleted (last milestone)

### Learning at Finalize

Before cleaning up, Claude reviews the work for gotchas, non-obvious patterns,
or recurring mistakes. If found, proposes specific additions to the project's
CLAUDE.md. Changes are presented as a diff for approval — never auto-merged.
