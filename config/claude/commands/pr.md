---
model: sonnet
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(git log:*)
  - Bash(git fetch:*)
  - Bash(git diff:*)
  - Bash(git status)
  - Bash(gh pr:*)
---

Create a pull request for the current branch.

## Process

1. Determine target branch:
   - Default: main or master (whichever exists)
   - If the branch was created from develop, target develop
   - Ask if ambiguous

2. Pre-flight checks:
   - `git log <target>..HEAD --oneline` to see commits in this PR
   - Run the project's test suite
   - `git fetch && git log HEAD..<target>` to check if behind target

3. Check if a PR template exists in the repo:
   - Look for `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE.md`
   - If a template exists, follow its structure exactly
   - If no template exists, generate a PR description with:
     - **Title:** derive from branch name or commit history, imperative mood
     - **What:** what changed, grouped by area (not a raw file list)
     - **Why:** the context and motivation for the change
     - **Where:** key areas of the codebase affected
     - **Testing:** what was tested, how to verify, manual steps if needed
     - **Notes:** breaking changes, migration steps, deployment considerations
   - If `docs/work/<slug>/plan.md` exists, reference relevant context from it

4. NEVER mention Claude, AI, or any AI tool in the PR description.

5. Create PR: `gh pr create --title "..." --body "..." --base <target>`

6. Present the PR URL.

## Guards

- REFUSE to create PR if tests are failing (unless explicitly overridden)
- WARN if PR is very large (more than 500 lines changed) — suggest splitting
- WARN if branch is behind target — suggest rebasing first
- WARN if there are uncommitted changes — suggest committing or stashing
