---
name: do-spec
description: "Execute an approved spec. Reads the spec file, creates a branch, and does the work. For specs with milestones, executes one milestone at a time with approval gates. Opens a PR when done."
disable-model-invocation: true
---

# Do Spec

Execute an approved spec file.

## Inputs

`$ARGUMENTS` — Path to a spec file, or a slug to find in `.wip/`.
If empty, list available specs.

## Process

### Step 0: Find the spec

1. If `$ARGUMENTS` is empty, list all specs in `.wip/`:

   ```
   Available specs:
   - 2026-02-17-health-check (quick, approved)
   - 2026-02-17-auth-migration (slow, approved)
   ```

   **⏸ STOP — Ask which spec to execute.**

2. If `$ARGUMENTS` is a path, read that file.

3. If `$ARGUMENTS` is a slug or partial match, find the spec in
   `.wip/`.

4. Read `spec.md` frontmatter. Verify status is `approved`.
   - If `draft` → tell the user and stop.
   - If `done` → tell the user it's already completed.

### Step 1: Set up

1. Create the branch from the spec frontmatter (if not already on it).
2. Update spec status to `in-progress`.

### Step 2: Execute

**If the spec has `## Milestones`** (slow spec):

**CRITICAL: Execute ONE milestone at a time. After each milestone you MUST
stop and wait for the user to approve before continuing. Do NOT proceed to
the next milestone without explicit user approval. Do NOT batch milestones.
Each milestone is a separate approve-then-commit cycle.**

For each milestone:

1. Announce:

   ```
   ## Starting M[N]: [description]
   ```

2. Execute the work described.

3. Run relevant tests.

4. Present a summary using `AskUserQuestion` with options to approve,
   request changes, or abort:

   ```
   ## Completed M[N]: [description]

   **Changes:**
   - [file]: [what changed]

   **Tests:** [pass/fail summary]

   **Next:** M[N+1]: [description] (or "Final milestone" if last)
   ```

   Options:
   - **Approve & commit** — Commit this milestone and continue
   - **Request changes** — Describe what needs fixing
   - **Abort** — Stop execution, leave spec in-progress

5. **⏸ HARD STOP — You MUST use `AskUserQuestion` and wait for
   the user's response. Do NOT continue until the user selects
   an option. This is NOT optional.**

6. If approved, commit using `/commit` with the commit
   message from the milestone.

7. Update the spec file: change the completed milestone's
   `- [ ]` to `- [x]` and commit the spec update.

8. **Only after the commit succeeds and the user approved,**
   continue to the next milestone. Go back to step 1.

**If the spec has `## Approach`** (quick spec):

1. Execute the work described.

2. Run relevant tests.

3. Present a summary using `AskUserQuestion` with options to approve,
   request changes, or abort:

   ```
   ## Done: [Title]

   **Changes:**
   - [file]: [what changed]

   **Tests:** [pass/fail summary]

   **Acceptance Criteria:**
   - [x] Met
   - [ ] Not met (explain)
   ```

   Options:
   - **Approve & commit** — Commit and continue to PR
   - **Request changes** — Describe what needs fixing
   - **Abort** — Stop execution, leave spec in-progress

4. **⏸ HARD STOP — You MUST use `AskUserQuestion` and wait for
   the user's response. Do NOT continue until the user selects
   an option. This is NOT optional.**

5. If approved, commit using `/commit`.

6. Update the spec file: check off completed approach items
   (`- [ ]` → `- [x]`) and commit the spec update.

### Step 3: Finalize

1. Update spec status to `done`.
2. Commit the spec status update.
3. Open a PR using `/pr`.
   - Reference the spec file in the PR description.
   - For slow specs, summarize milestones completed.
