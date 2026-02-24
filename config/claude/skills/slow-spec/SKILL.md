---
name: slow-spec
description: "Research and write a detailed spec for complex work. Produces a spec with milestones and a research/ folder with per-topic research docs. Does not execute — use /do-spec to execute."
disable-model-invocation: true
---

# Slow Spec

Research the codebase and write a detailed specification with milestones
for complex, multi-step work.

## Inputs

`$ARGUMENTS` — A description of the work.

## Process

### Phase 1: Research

1. Generate a short kebab-case slug from the description.
2. Create `.wip/YYYY-MM-DD-<slug>/` and `.wip/YYYY-MM-DD-<slug>/research/`.
3. Identify the distinct research questions or areas to investigate.
4. For each area, kick off a **researcher agent**. Each agent
   writes its own file in `research/` using a kebab-case slug:
   - e.g. `research/auth-patterns.md`, `research/database-schema.md`
   - Each file follows the research template (see below).
   - Agents can run in parallel — separate files prevent conflicts.
5. After all research agents complete, read the research files and
   synthesize findings for Phase 2.

### Phase 2: Write the spec

1. Write `spec.md` using the slow template (see below).
2. Include a research summary referencing files in `research/`.
3. Break the work into milestones. Each milestone:
   - Is a single logical unit resulting in one commit.
   - Is small enough to review meaningfully.
   - Builds on the previous milestone.
   - Includes: files affected, approach, gate criteria, commit message.
   - Includes a progress checklist: `Dev done`, `Reviewed & approved`, `Committed`.
     These track the lifecycle of each milestone — do not skip them.

### Phase 3: Present for review

```
## Spec: [Title]

**Branch:** `feat/<slug>`
**Spec:** `.wip/YYYY-MM-DD-<slug>/spec.md`

**Research Summary:**
[Key findings in 3-5 bullets]

**Milestones:**
- [ ] M1: [description] — `type(scope): message`
- [ ] M2: [description] — `type(scope): message`
- [ ] M3: [description] — `type(scope): message`

**Risks:**
- [Risk and mitigation]

Approve this spec? Any changes?
```

**⏸ STOP — Wait for user approval.**

If changes requested, update and present again.
When approved, update spec status to `approved`.

## Slow Spec Template

```markdown
---
title: [Title]
type: slow
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

## Research Summary

[Key findings. See .wip/YYYY-MM-DD-<slug>/research/ for detail.]

## Milestones

- [ ] **M1: [Short description]**

  **Files:** [list]
  **Approach:** [what and how]
  **Gate:** [what must be true before commit]
  **Commit:** `type(scope): message`

  - [ ] Dev done
  - [ ] Reviewed & approved
  - [ ] Committed

- [ ] **M2: [Short description]**

  **Files:** [list]
  **Approach:** [what and how]
  **Gate:** [what must be true before commit]
  **Commit:** `type(scope): message`

  - [ ] Dev done
  - [ ] Reviewed & approved
  - [ ] Committed

## Risks

- [Risk and mitigation]

## Acceptance Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
```

## Research Template

Each research file lives at `research/<topic-slug>.md`:

```markdown
# Research: [Topic]

## Questions

[What we needed to find out]

## Findings

[Code references, patterns, existing implementations]

## Constraints

[Technical constraints, dependencies, blockers]

## Recommendations

[What research suggests]
```
