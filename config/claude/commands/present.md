---
description: Present changes for user approval
---

# Present Phase

## Prerequisites

Requires:
- Active plan with current commit Dev and Review complete
- Or changes ready for user review

## Instructions

Present implementation results to user:

```markdown
## Commit <N>: <title>

### Summary
<2-3 sentences describing what was implemented>

### Goal
<goal from plan.md>

### Files Changed

| File | Change | Lines |
|------|--------|-------|
| `path/to/file.ts` | created | +150 |
| `path/to/other.ts` | modified | +23/-5 |

### Tests

- Tests added: <N>
- All passing: Yes/No
- Coverage: <if measurable>

### Review Results

**Code Review:**
- Critical: 0
- High: 0
- Medium: <N>
- Low: <N>

**Security Audit:**
- Critical: 0
- High: 0
- Findings: <summary>

### Outstanding Items

<any Medium/Low issues noted during review>

- <item 1>
- <item 2>

Or: "None - clean review"

---

**Approve?** (y/go, or provide feedback)
```

**STOP and wait for user response.**

## Handle Feedback

If user provides feedback:
1. Implement requested changes
2. Re-run /review if changes are significant
3. Present again with updates

Repeat until user approves.

## After Approval

Update plan.md: check `- [x] Present`

```
Approved. Run /commit to finalize.
```

## Rules

- NEVER proceed to commit without explicit user approval
- Show all relevant information for informed decision
- Be honest about outstanding items
- If user has concerns, address them fully
- Update plan.md checkbox only after approval
