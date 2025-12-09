---
description: Present research and plan for approval
---

# Signoff Phase

## Prerequisites

Requires both research.md and plan.md. If missing:
```
Missing required files.
- research.md: <found/not found>
- plan.md: <found/not found>

Run /research and /plan first, or /begin for full workflow.
```

## Instructions

Read both files and present summary:

```markdown
## Research Summary

**Task:** <task description>

### Key Findings
<3-5 bullet points from research>

### Approach
<recommended approach from research>

---

## Plan Summary

**Commits:** <N> planned

1. **<commit 1 title>**
   <goal>

2. **<commit 2 title>**
   <goal>

...

### Risks
<from plan, if any>

### Out of Scope
<from plan>

---

**Approve?** (y/go, or provide feedback)
```

**STOP and wait for explicit approval.**

## After Approval

Create the feature branch:
```bash
git checkout -b feat/<slug>
```

Update plan.md Status to `IN_PROGRESS`.

```
Created branch: feat/<slug>
Run /next to start the first commit.
```

## Rules

- NEVER proceed without explicit user approval
- Present both research findings and plan summary
- If user has concerns, address them before proceeding
- Branch is only created after signoff
