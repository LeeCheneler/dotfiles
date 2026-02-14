Update the existing project CLAUDE.md without regenerating from scratch.
Preserves manual additions while updating sections where the project has
drifted.

## Process

1. Read the current CLAUDE.md and note the generation date from the comment
   at the top.

2. Scan the project for changes that might affect the CLAUDE.md:
   - New or removed dependencies (package.json, lock files)
   - New modules, directories, or significant files
   - Changed config files (tsconfig, eslint, CI/CD)
   - New ADRs or documentation
   - Changed test setup or patterns
   - Changed build/dev/deploy commands

3. Compare current project state against what's documented in CLAUDE.md.

4. Propose targeted updates as a diff — show what would change and why.
   Clearly distinguish between auto-generated sections being updated and
   manually-added content being preserved.

5. Present the diff for approval before writing.

6. If approved, update the CLAUDE.md and refresh the generation date comment.

## Key rule

Never remove or modify content that appears to have been manually added
(i.e., content not matching the /init-project template structure). When in
doubt, ask.

## Arguments

$ARGUMENTS
