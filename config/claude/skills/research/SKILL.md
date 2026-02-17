---
name: research
description: "Research a topic via codebase exploration, web search, or both. Auto-loads when exploring unfamiliar code or evaluating external tools. Invoke with /research to write a research document."
---

# Researching

You will be given a research task and a markdown filepath to write your
findings to. Determine whether the task needs codebase exploration, web
research, or both, and follow the relevant sections below.

## Process

### 1. Determine research scope

Read the task description and decide which sources are needed:

- **Codebase** — architecture questions, existing patterns, dependencies,
  blast radius, test coverage.
- **Web** — technology choices, library APIs, migration paths, external
  docs, version compatibility.
- **Both** — most non-trivial research benefits from understanding the
  current codebase _and_ checking external sources.

### 2. Codebase exploration (when relevant)

Build context highest-density first:

1. **Project CLAUDE.md** — read if it exists. Architecture, conventions,
   gotchas, key decisions.
2. **ADRs and docs** — check `docs/decisions/`, `docs/adrs/`, `docs/` for
   architectural decisions and domain context.
3. **README and CONTRIBUTING** — project intent, setup, contribution rules.
4. **Config files** — package.json, tsconfig, eslint/biome, terraform,
   docker, CI/CD workflows. Stack and tooling constraints.
5. **Directory structure** — get the lay of the land before reading files.

Then explore the specific areas:

1. Identify the files and modules relevant to the task.
2. Read full files, not just snippets — understand the complete context.
3. Trace code paths: entrypoints, data flow, dependencies.
4. Note existing patterns and conventions in the affected areas.
5. Read callers and dependents of the code you'll be changing.
6. Identify tests that cover the affected areas.

Assess risks:

1. Look for tightly coupled code and shared state.
2. Identify edge cases and potential breakage points.
3. Note any gaps in test coverage for the affected areas.

### 3. Web research (when relevant)

1. Clarify what needs researching: technology choice, API usage, design
   pattern, migration path, etc.
2. Search for current, authoritative sources: official docs, release notes,
   well-regarded blog posts, GitHub repos.
3. Cross-reference multiple sources to validate findings.
4. If relevant, check the current codebase for context (existing stack,
   constraints, patterns) to make recommendations practical.

## Output

Write your findings to the provided filepath. Include whichever sections
are relevant:

- **Answer:** Direct answer to the research question.
- **Architecture:** Overview of the relevant codebase area.
- **Key files:** Files and their roles.
- **Existing patterns:** Conventions that must be followed.
- **Dependencies and blast radius:** What's affected.
- **Options:** If comparing approaches, short pros/cons for each.
- **Recommendation:** Your pick and why, given the project context.
- **Risks:** Things to watch out for, test coverage gaps.
- **Sources:** Links to key references (for web research).
- **Caveats:** Anything uncertain, version-dependent, or worth verifying.

Be specific and factual. Reference file paths. Don't pad with generic advice.
Be opinionated. Don't hedge without saying what it depends on.

## Arguments

$ARGUMENTS
