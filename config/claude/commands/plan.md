---
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Bash(git log:*)
  - Bash(git diff:*)
  - Bash(ls:*)
  - Bash(tree:*)
---

Research the codebase and create an implementation plan. This is phases 1-2
of the Pipeline workflow, extracted as a standalone command for when you want
to plan without immediately executing.

## Process

1. **Research** using the **researcher agent** to explore the relevant areas:
   - Find related code, tests, docs, config files
   - Understand the current architecture and patterns
   - Identify dependencies and blast radius
   - Writes findings to `docs/work/<slug>/research.md`

2. **Plan** the implementation:
   - Break into numbered milestones (each = one atomic, testable commit)
   - For each milestone: steps, gate criteria, conventional commit message
   - Penultimate milestone: extract relevant ADRs to docs/decisions/
   - Final milestone: delete docs/work/<slug>/
   - Note risks, open questions, and alternatives considered
   - Write plan to `docs/work/<slug>/plan.md`

3. **Ask** the user what gate mode to use:
   - **continuous** (default): status update after each milestone, keep going
   - **gated**: pause after each milestone, wait for go-ahead
   - Individual milestones can override the default (useful for risky steps)

4. **Present** the plan for review.

The slug is derived from $ARGUMENTS (kebab-cased, e.g., "add-user-auth").

## Plan File Format

```
<!-- Working document. Will be deleted after ADRs are extracted. -->

# Plan: <title>

## Config
**Gate mode:** continuous|gated

## Context
<1-2 paragraphs: what we're doing and why>

## Research Summary
<Key findings — link to research.md for full detail>

## Milestones

### Milestone 1: <title>
- [ ] Step 1.1: <description>
- [ ] Step 1.2: <description>
**Gate:** <what must be true before proceeding>
**Commit:** `<type>(<scope>): <description>`

### Milestone N-1: Extract ADRs
- [ ] Review work for architectural decisions worth documenting
- [ ] Write ADRs to docs/decisions/ following project's ADR format
**Gate:** ADRs written and make sense standalone
**Commit:** `docs: add ADRs for <feature>`

### Milestone N: Clean up
- [ ] Delete docs/work/<slug>/
**Commit:** `chore: remove working docs for <slug>`

## Risks & Open Questions
- <risk or question>

## Deviations Log
<Updated during execution — what changed from the original plan and why>
```

## Arguments

$ARGUMENTS
