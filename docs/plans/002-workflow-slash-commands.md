# Plan: Development Workflow Framework

## Status: DRAFT

## Objective

Create a complete development workflow framework with persistent state, clear phases, and slash command orchestration.

## Decisions

| Decision | Choice |
|----------|--------|
| Plan directory | `docs/plans/<task-slug>/` |
| Task slug | Auto-generated, user can override |
| Resume behavior | `/resume` lists plans, user selects by number |
| CLAUDE.md | Update with minimal reference to framework |
| Clarifying questions | Agents ask when genuinely uncertain, don't force |

## Workflow Overview

```
1. RESEARCH ──► 2. PLAN ──► 3. SIGNOFF ──► 4. EXECUTE ──► 5. PR
     │              │            │              │
     ▼              ▼            ▼              ▼
 research.md    plan.md      approval      per-commit
                             gate          loop
```

**Execute loop (per commit):**
```
DEV ──► REVIEW ◄──► (fix) ──► PRESENT ◄──► (fix) ──► COMMIT
```

## New Agents

### 1. researcher.md

**Purpose:** Deep codebase exploration for a given task.

**Behavior:**
- Read docs/, README*, ADR*, plans/, vision* files
- Find relevant code for the task
- Identify existing patterns to follow
- Output structured research.md
- Ask clarifying questions if genuinely uncertain about scope

**Output format:**
```markdown
# Research: <Task>

## Task
<original description>

## Codebase Overview
<structure, tech stack, key directories>

## Relevant Files
<files that will be affected or referenced>

## Existing Patterns
<patterns found that should be followed>

## Documentation Found
- Vision: <if exists>
- ADRs: <relevant ADRs>
- READMEs: <relevant READMEs>
- Existing plans: <related plans>

## Key Considerations
<architectural decisions, constraints, gotchas>

## Recommended Approach
<suggested implementation strategy>

## Open Questions
<questions for user if any, or "None">
```

### 2. planner.md

**Purpose:** Create structured implementation plan with commit breakdown.

**Behavior:**
- Take research.md + task description as input
- Break work into logical, atomic commits
- Each commit should be independently reviewable
- Consider dependencies between commits
- Ask clarifying questions if approach is ambiguous

**Output format:**
```markdown
# Plan: <Feature Name>

## Metadata
- Task: <original description>
- Branch: feat/<task-slug>
- Status: READY
- Created: <date>

## Summary
<2-3 sentence overview of what we're building>

## Commits

### 1. <Commit title>
**Goal:** <what this commit achieves>
**Files:**
- Create: <new files>
- Modify: <existing files>
- Delete: <files to remove>

**Checklist:**
- [ ] Dev
- [ ] Review
- [ ] Present
- [ ] Commit

**SHA:** <filled after commit>

### 2. <Commit title>
**Goal:** ...
**Files:** ...
**Checklist:**
- [ ] Dev
- [ ] Review
- [ ] Present
- [ ] Commit

**SHA:** <filled after commit>

## Notes
<any additional context, risks, or considerations>
```

## Slash Commands

### Orchestration Commands

#### /begin
```markdown
---
description: Start new work - research, plan, and signoff
argument-hint: <task-description>
---
```
1. Generate task slug from description, confirm with user
2. Create `docs/plans/<slug>/` directory
3. Run `researcher` agent → outputs `research.md`
4. Run `planner` agent → outputs `plan.md`
5. Present summary and wait for signoff
6. After signoff, create branch `feat/<slug>`

#### /next
```markdown
---
description: Execute next commit cycle in current plan
---
```
1. Find current plan (error if none active)
2. Find next incomplete commit
3. Run execute loop: DEV → REVIEW → PRESENT → COMMIT
4. Update plan.md checklist and SHA
5. If more commits remain, inform user

#### /resume
```markdown
---
description: Resume an existing plan
---
```
1. Scan `docs/plans/*/plan.md` for active plans
2. Display numbered list with status
3. Wait for user selection
4. Load plan context, show current position
5. Ready for `/next`

#### /pr
```markdown
---
description: Open pull request for current plan
---
```
1. Verify all commits in plan are complete
2. Run `pr-description` agent
3. Present PR title/description for approval
4. Create PR after approval

### Standalone Phase Commands

#### /research
```markdown
---
description: Run research phase only
argument-hint: <task-description>
---
```
Run `researcher` agent, output to research.md.

#### /plan
```markdown
---
description: Run planning phase only (requires research.md)
---
```
Run `planner` agent using existing research.md.

#### /signoff
```markdown
---
description: Present research and plan for approval
---
```
Present summary, wait for explicit approval, create branch.

### Standalone Execute Commands

#### /dev
```markdown
---
description: Run dev phase for current commit
---
```
Implement current commit. Use `test-writer` for tests, `doc-writer` if needed.

#### /review
```markdown
---
description: Run review phase for current changes
---
```
Run `code-reviewer` + `security-auditor`. Fix P0/P1 issues, re-review until clean.

#### /present
```markdown
---
description: Present changes for user approval
---
```
Show summary, files changed, review results. Wait for approval.

#### /commit
```markdown
---
description: Commit current changes with approval
---
```
Run `commit-message` agent, present message, commit after approval.

## File Structure After Implementation

```
~/.dotfiles/config/claude/
├── agents/
│   ├── researcher.md       # NEW
│   ├── planner.md          # NEW
│   ├── code-reviewer.md
│   ├── commit-message.md
│   ├── doc-writer.md
│   ├── pr-description.md
│   ├── refactor-advisor.md
│   ├── security-auditor.md
│   └── test-writer.md
├── commands/
│   ├── begin.md            # NEW
│   ├── next.md             # NEW
│   ├── resume.md           # NEW
│   ├── pr.md               # NEW
│   ├── research.md         # NEW
│   ├── plan.md             # NEW
│   ├── signoff.md          # NEW
│   ├── dev.md              # NEW
│   ├── review.md           # NEW
│   ├── present.md          # NEW
│   └── commit.md           # NEW
├── hooks/
│   ├── pre-commit.py
│   ├── pre-pr.py
│   └── pre-push.py
├── CLAUDE.md               # UPDATE
└── settings.json
```

## Implementation Steps

### Phase 1: Agents
- [ ] 1. Create researcher.md agent
- [ ] 2. Create planner.md agent

### Phase 2: Orchestration Commands
- [ ] 3. Create /begin command
- [ ] 4. Create /next command
- [ ] 5. Create /resume command
- [ ] 6. Create /pr command

### Phase 3: Standalone Commands
- [ ] 7. Create /research command
- [ ] 8. Create /plan command
- [ ] 9. Create /signoff command
- [ ] 10. Create /dev command
- [ ] 11. Create /review command
- [ ] 12. Create /present command
- [ ] 13. Create /commit command

### Phase 4: Documentation
- [ ] 14. Update CLAUDE.md with framework reference

### Phase 5: Finalize
- [ ] 15. Test commands
- [ ] 16. Open PR

## Success Criteria

- [ ] `/begin <task>` creates plan directory, runs research + planning, gets signoff
- [ ] `/next` executes one commit cycle with all review gates
- [ ] `/resume` finds and resumes existing plans
- [ ] `/pr` opens PR with proper description
- [ ] Standalone commands work independently
- [ ] Agents ask clarifying questions when genuinely needed
- [ ] Plan files track progress across sessions
- [ ] CLAUDE.md references the framework

## Example Usage

### Full workflow
```
User: /begin add user authentication to the API

Claude: Creating plan directory: docs/plans/user-authentication/
        Is this name ok? (enter to confirm, or type different name)

User: y

Claude: [runs researcher agent]
        [runs planner agent]

        ## Summary
        Research complete. Plan has 4 commits:
        1. Add user model and migration
        2. Implement auth service
        3. Add login/register endpoints
        4. Add auth middleware

        Ready to proceed? (signoff)

User: looks good, go ahead

Claude: Created branch: feat/user-authentication
        Ready. Run /next to start first commit.

User: /next

Claude: [executes commit 1 cycle]
        ...

User: /next

Claude: [executes commit 2 cycle]
        ...
```

### Resume in new session
```
User: /resume

Claude: Found 2 active plans:
        1. user-authentication (IN_PROGRESS - Commit 2/4)
        2. rate-limiting (READY - not started)

        Enter number:

User: 1

Claude: Resumed: user-authentication
        Current: Commit 2 of 4 (Implement auth service)
        Status: Dev complete, needs review

        Run /next to continue.
```
