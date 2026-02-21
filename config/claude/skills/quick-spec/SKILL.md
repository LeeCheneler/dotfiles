---
name: quick-spec
description: "Write a spec for a simple task. Creates a spec file with context, scope, approach, and acceptance criteria. Does not execute — use /do-spec to execute."
disable-model-invocation: true
---

# Quick Spec

Write a specification for a simple, well-understood task.

## Inputs

`$ARGUMENTS` — A short description of the work.

## Process

### Step 1: Create the spec

1. Generate a short kebab-case slug from the description.
2. Create `.wip/YYYY-MM-DD-<slug>/`.
3. Write `spec.md` using the quick template (see below).
4. Fill in: title, context (from user's description), scope (inferred —
   state assumptions explicitly), approach (your proposed plan), and
   acceptance criteria.

### Step 2: Present for review

Present your understanding:

```
## Spec: [Title]

**Branch:** `feat/<slug>`
**Spec:** `.wip/YYYY-MM-DD-<slug>/spec.md`

**Understanding:** [1-2 sentences]

**Approach:**
[Brief plan]

**Acceptance Criteria:**
- [ ] ...

Approve this spec? Any changes?
```

**⏸ STOP — Wait for user approval.**

If changes requested, update the spec and present again.
When approved, update spec status to `approved`.

## Quick Spec Template

```markdown
---
title: [Title]
type: quick
status: draft
created: [YYYY-MM-DD]
branch: feat/[slug]
---

# [Title]

## Context

[Why this work exists]

## Scope

**In scope:** [what's included]
**Out of scope:** [what's excluded]

## Approach

- [ ] [Task/change description and what will be done]
- [ ] [Additional task if multiple discrete changes]

## Acceptance Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
```
