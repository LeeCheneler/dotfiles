---
name: help
description: "List all available skills and what they do."
disable-model-invocation: true
---

# Help

List all available skills.

## Process

1. Find all SKILL.md files in `~/.claude/skills/` and `.claude/skills/`.

2. Read the `name`, `description`, and `disable-model-invocation` fields
   from each SKILL.md frontmatter.

3. Output two tables:

   **Workflow Commands** (skills with `disable-model-invocation: true`):

   | Command | Description |
   | ------- | ----------- |

   **Reference Skills** (auto-loaded by Claude when relevant):

   | Skill | Description |
   | ----- | ----------- |

4. If `$ARGUMENTS` contains a skill name, show the full SKILL.md content
   for that skill instead of the table.
