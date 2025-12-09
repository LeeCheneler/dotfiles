---
description: Run dev phase for current commit
---

# Dev Phase

## Prerequisites

Requires active plan with a commit ready for dev:
- Plan exists with Status: `IN_PROGRESS`
- Current commit has `- [ ] Dev` unchecked

## Instructions

Implement the current commit:

### 1. Understand the Commit
Read the plan.md to understand:
- Commit goal
- Files to create/modify/delete
- Context from previous commits

### 2. Implement
Write the implementation code following:
- Patterns identified in research.md
- Existing codebase conventions
- CLAUDE.md standards

### 3. Write Tests
Use `test-writer` agent for tests if applicable:
- Unit tests for new functions
- Integration tests for new endpoints
- Follow black-box, behavior-focused testing

### 4. Documentation
Use `doc-writer` agent if needed:
- Update README if public API changes
- Add JSDoc for complex functions
- Update ADRs if architectural decisions made

### 5. Verify
```bash
# Run tests
<project test command>

# Run lint/type-check
<project lint command>
```

Fix any failures before completing.

### 6. Update Plan
Check `- [x] Dev` in plan.md for this commit.

## After Dev

```
Dev complete for Commit <N>: <title>

Files changed:
- <file list>

Tests: <passing/failing>
Lint: <clean/issues>

Run /review to continue, or the dev phase will auto-proceed if run from /next.
```

## Rules

- Stay within scope of the current commit
- Don't implement future commits
- Tests and lint must pass before completing
- Use test-writer agent for tests, not manual test writing
- Update plan.md checkbox when complete
