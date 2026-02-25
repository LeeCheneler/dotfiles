---
name: do-spec
description: "Execute an approved spec. Reads the spec file, creates a branch, and does the work. For specs with milestones, executes one milestone at a time with approval gates. Opens a PR when done."
disable-model-invocation: true
---

# Do Spec

Execute an approved spec file.

**CRITICAL RULES — read these before doing anything:**

1. **ONE milestone at a time.** Complete one milestone, present it for
   review, get explicit user approval, commit it, then move to the next.
   NEVER start the next milestone until the current one is approved and
   committed.
2. **Always commit.** Every approved milestone gets committed via `/commit`
   before moving on. No batching. No skipping commits.
3. **Always wait.** Use `AskUserQuestion` after every milestone and
   STOP. Do not continue until the user responds. This is non-negotiable.

## Inputs

`$ARGUMENTS` — Path to a spec file, or a slug to find in `.wip/`.
If empty, list available specs and ask the user to choose.

## Process

### Step 0: Find the spec

1. If `$ARGUMENTS` is empty, scan `.wip/` for all spec directories.
   Read each `spec.md` frontmatter and filter to specs with status
   `approved` or `in-progress`. Exclude specs with status `done` or
   `draft`.

   If no eligible specs exist, tell the user and stop.

   If exactly one eligible spec exists, confirm it with the user:
   ```
   Found one spec: [title] ([type], [status])
   Proceed with this spec?
   ```
   **⏸ STOP — Wait for user confirmation.**

   If multiple eligible specs exist, present them and ask the user
   to choose using `AskUserQuestion`:
   ```
   Available specs:
   - 2026-02-17-health-check (quick, approved)
   - 2026-02-17-auth-migration (slow, in-progress — M2 pending)
   ```
   **⏸ STOP — Ask which spec to execute.**

2. If `$ARGUMENTS` is a path, read that file.

3. If `$ARGUMENTS` is a slug or partial match, find the spec in
   `.wip/`.

4. Read `spec.md` frontmatter. Verify status is `approved` or
   `in-progress`.
   - If `draft` → tell the user and stop.
   - If `done` → tell the user it's already completed.

### Step 1: Set up

1. Create the branch from the spec frontmatter (if not already on it).
2. Update spec status to `in-progress`.

### Step 2: Execute

**If the spec has `## Milestones`** (slow spec):

For specs that are `in-progress`, check which milestones are already
marked `[x]` and resume from the first unchecked milestone.

Execute milestones one at a time using this loop. **Do NOT skip steps.
Do NOT combine milestones. Do NOT proceed without user approval.**

**For each milestone:**

1. **Announce** what you're about to work on:
   ```
   ## Starting M[N]: [description]
   ```

2. **Execute** only the work described in this single milestone.
   Do NOT touch files or make changes belonging to later milestones.

3. **Run** relevant tests.

4. **Present results** using `AskUserQuestion` — you MUST use this
   tool, not just print text:

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

5. **⏸ HARD STOP.** Your message MUST end with the `AskUserQuestion`
   tool call. Do NOT include any text or tool calls after it. Do NOT
   continue working. Do NOT start the next milestone. WAIT for the
   user to respond. **This is the most important rule in this skill.**

6. **If approved:** commit using `/commit` with the commit message
   from the milestone. Then update the spec file: change the completed
   milestone's `- [ ]` to `- [x]` and include this in the commit.

7. **If changes requested:** make the requested changes, re-run tests,
   and present again (go back to step 4).

8. **If aborted:** stop immediately. Leave the spec as `in-progress`.

9. **Only after the commit succeeds,** go back to step 1 for the
   next milestone.

**If the spec has `## Approach`** (quick spec):

1. **Execute** the work described.

2. **Run** relevant tests.

3. **Present results** using `AskUserQuestion` — you MUST use this
   tool, not just print text:

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

4. **⏸ HARD STOP.** Your message MUST end with the `AskUserQuestion`
   tool call. Do NOT include any text or tool calls after it. Do NOT
   continue working. WAIT for the user to respond.

5. **If approved:** commit using `/commit`.

6. **If changes requested:** make the requested changes, re-run tests,
   and present again (go back to step 3).

7. Update the spec file: check off completed approach items
   (`- [ ]` → `- [x]`) and include this in the commit.

### Step 3: Finalize

1. Update spec status to `done`.
2. Commit the spec status update.
3. Open a PR using `/pr`.
   - Reference the spec file in the PR description.
   - For slow specs, summarize milestones completed.
