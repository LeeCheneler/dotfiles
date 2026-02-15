---
name: web-researching
description: "Research technologies, libraries, APIs, and approaches using
  web search. Auto-loads when evaluating external tools or checking docs.
  Invoke with /web-researching to write a research document."
allowed-tools:
  - WebSearch
  - WebFetch
  - Read
  - Glob
  - Grep
---

# Web Researching

You will be given a research question and a markdown filepath to write your
findings to.

## Process

1. Clarify what needs researching: technology choice, API usage, design
   pattern, migration path, etc.
2. Search for current, authoritative sources: official docs, release notes,
   well-regarded blog posts, GitHub repos
3. Cross-reference multiple sources to validate findings
4. If relevant, check the current codebase for context (existing stack,
   constraints, patterns) to make recommendations practical

## Output

Write your findings to the provided filepath with:

- **Answer:** Direct answer to the research question
- **Options:** If comparing approaches, short pros/cons for each
- **Recommendation:** Your pick and why, given the project context
- **Sources:** Links to key references
- **Caveats:** Anything uncertain, version-dependent, or worth verifying

Be specific and opinionated. Don't hedge without saying what it depends on.

## Arguments

$ARGUMENTS
