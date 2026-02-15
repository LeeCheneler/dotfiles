# Plan: Rework Claude Code Config

## Context

This plan reworks the Claude Code dotfiles config at `config/claude/` based
on a clearer understanding of how Claude Code's extension mechanisms work:

- **CLAUDE.md** — always loaded, survives compaction. Principles and rules.
- **Skills** — auto-discovered by description, loaded on demand into main
  context. Detailed guidance with examples. Also serve as slash commands.
- **Agents (subagents)** — run in isolated context windows. Only for tasks
  that produce lots of intermediate noise but return concise summaries.
  They do NOT inherit CLAUDE.md or skills.
- **Slash commands** — merged into skills. Existing commands/ files still work.

### Design principles

1. **Main context is for primary work.** Coding, test writing, planning,
   and interactive tasks stay on main context where they have CLAUDE.md,
   skills, conversation history, and can iterate with the user.
2. **Agents are for context-expensive summarization.** Tasks that read many
   files or produce verbose output but return a concise result. The main
   context never sees the intermediate noise.
3. **Skills carry the detailed guidance with examples.** They auto-load when
   relevant and are the canonical source of conventions.
4. **CLAUDE.md carries concise principles that survive compaction.** Intentional
   overlap with skills is fine — CLAUDE.md is the compaction-resilient layer.
5. **Agents must be self-contained.** Since they don't inherit CLAUDE.md or
   skills, they must contain (or preload via `skills:` frontmatter) everything
   they need. Verify `skills:` frontmatter works before relying on it.

## Milestones

### Milestone 1: Add examples to coding-standards skill

**File:** `config/claude/skills/coding-standards/SKILL.md`

Add short good/bad examples (3-5 lines TypeScript each) inline after each
principle. These examples anchor Claude's understanding far more reliably
than prose descriptions alone.

Examples to add:

**KISS — small functions:**

```typescript
// ✅ Good: each function does one thing
function validateEmail(input: string): boolean {
  return emailRegex.test(input);
}

function normalizeEmail(input: string): string {
  return input.trim().toLowerCase();
}

// ❌ Bad: function does validation, normalization, and persistence
function processEmail(input: string): Promise<User> {
  if (!emailRegex.test(input)) throw new Error("invalid");
  const normalized = input.trim().toLowerCase();
  return db.users.updateEmail(normalized);
}
```

**Don't destructure function parameters:**

```typescript
// ✅ Good: preserves type name, easy to refactor
function createUser(props: CreateUserProps): User {
  return { id: generateId(), name: props.name, email: props.email };
}

// ❌ Bad: loses type context, harder to refactor with many params
function createUser({ name, email }: CreateUserProps): User {
  return { id: generateId(), name, email };
}
```

**Let errors bubble:**

```typescript
// ✅ Good: single high-level handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  logger.error({ err, path: req.path }, "unhandled error");
  res.status(500).json({ error: "Internal server error" });
});

// ❌ Bad: try/catch at every endpoint
router.get("/users/:id", async (req, res) => {
  try {
    const user = await getUser(req.params.id);
    res.json(user);
  } catch (err) {
    logger.error(err);
    res.status(500).json({ error: "Something went wrong" });
  }
});
```

**No premature abstraction:**

```typescript
// ✅ Good: two similar handlers, kept separate (only 2 occurrences)
async function handleUserCreated(event: UserCreatedEvent) {
  await sendWelcomeEmail(event.userId);
  await trackAnalytics("user_created", event.userId);
}

async function handleTeamCreated(event: TeamCreatedEvent) {
  await sendTeamWelcomeEmail(event.teamId);
  await trackAnalytics("team_created", event.teamId);
}

// ❌ Bad: premature generic handler after only 2 occurrences
async function handleEntityCreated<T extends { id: string }>(
  config: EntityHandlerConfig<T>,
) {
  await config.sendEmail(config.entityId);
  await trackAnalytics(config.eventName, config.entityId);
}
```

**Discriminated unions over boolean flags:**

```typescript
// ✅ Good: invalid states are unrepresentable
type RequestState =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: User }
  | { status: "error"; error: Error };

// ❌ Bad: multiple booleans allow impossible states (loading AND error)
type RequestState = {
  isLoading: boolean;
  isError: boolean;
  data: User | null;
  error: Error | null;
};
```

**Gate:** Skill file updated with all examples, reads clearly.
**Commit:** `docs(claude): add good/bad examples to coding-standards skill`

---

### Milestone 2: Add examples to test-conventions skill

**File:** `config/claude/skills/test-conventions/SKILL.md`

**Test behavior, not implementation:**

```typescript
// ✅ Good: tests the observable behavior
test("should return user by email", async () => {
  await createUser({ email: "lee@test.com", name: "Lee" });
  const user = await getUserByEmail("lee@test.com");
  expect(user.name).toBe("Lee");
});

// ❌ Bad: tests internal implementation details
test("should call findOne with email filter", async () => {
  const spy = vi.spyOn(db.users, "findOne");
  await getUserByEmail("lee@test.com");
  expect(spy).toHaveBeenCalledWith({ where: { email: "lee@test.com" } });
});
```

**Mock only at boundaries:**

```typescript
// ✅ Good: mock the network boundary with MSW
const server = setupServer(
  http.get("/api/users/:id", () => HttpResponse.json({ name: "Lee" })),
);

// ❌ Bad: mocking an internal module
vi.mock("../services/user-service", () => ({
  getUser: vi.fn().mockResolvedValue({ name: "Lee" }),
}));
```

**Descriptive test names:**

```typescript
// ✅ Good: reads as a behavior specification
test("should return 404 when user does not exist", ...);
test("should hash password before storing", ...);
test("should send welcome email after signup", ...);

// ❌ Bad: describes implementation, not behavior
test("test getUserById error", ...);
test("password hashing", ...);
test("email function", ...);
```

**Gate:** Skill file updated, examples are realistic.
**Commit:** `docs(claude): add good/bad examples to test-conventions skill`

---

### Milestone 3: Add examples to commit-conventions skill

**File:** `config/claude/skills/commit-conventions/SKILL.md`

```
✅ Good:
  feat(auth): add password reset flow
  fix(api): handle null response from payment provider
  refactor(users): extract email validation to shared util
  test(checkout): add edge cases for expired discount codes

❌ Bad:
  Updated files
  fix bug
  feat: Add New User Authentication Flow Using OAuth2
  refactor(users): refactored user service to extract email validation
    into a shared utility function
  fix(api): fixed the bug where payment provider returns null (AI-generated)
```

**Gate:** Skill file updated with commit message examples.
**Commit:** `docs(claude): add good/bad examples to commit-conventions skill`

---

### Milestone 4: Restructure agents — keep only context-expensive summarizers

Remove agents that should run on main context. Keep only agents whose job
is to consume a lot of context and return a concise summary.

**Delete these agents (their work happens on main context now):**

- `agents/coder.md` — coding is primary work, needs full conversation
  context, CLAUDE.md, and skills
- `agents/test-writer.md` — writing tests is creative coding work, needs
  the same context as coding
- `agents/planner.md` — planning benefits from interactive iteration with
  the user; research (the context-expensive part) is already a separate agent

**Keep and refine these agents:**

- `agents/researcher.md` — reads dozens of files, returns a focused summary.
  Classic context-expensive task. Already well-scoped.
- `agents/reviewer.md` — reads diffs and surrounding code, returns structured
  findings. Already well-scoped.
- `agents/test-runner.md` — runs tests, captures verbose output, returns
  concise results. Refine to be more specific about output format:

**Refined test-runner.md:**

```markdown
---
name: test-runner
description: "Run tests and report results concisely. Use when tests need
  to be run and results reported without cluttering the main context with
  verbose test output."
tools:
  - Bash
  - Read
model: sonnet
---

You are a test runner. Run tests and report results concisely so the main
context stays clean.

## Process

1. Detect the test framework and runner from project configuration
2. Run the specified tests (or the full suite if no scope given)
3. Report results in this exact format:

On pass:
✅ <count> passed in <time>

On fail:
❌ <pass_count> passed, <fail_count> failed in <time>

    Failed:
    - <file> > <test name>
      Expected: <expected>
      Received: <actual>
      (repeat for each failure, max 5 — summarize remainder)

Never dump raw test output. The whole point of this agent is to keep the
main context clean.
```

**For researcher and reviewer:** Since these run in isolated context, they
need their conventions included. Two approaches (try in this order):

1. **Try `skills:` frontmatter** to preload relevant skills into the agent
   context. If this works, agents stay lean and reference skills:
   ```yaml
   skills:
     - coding-standards
   ```
   Test this with one agent before applying to all.

2. **If `skills:` doesn't work**, include a concise conventions section
   directly in the agent file. This is the current approach and it works —
   keep it as fallback.

**Gate:** coder, test-writer, and planner agents deleted. test-runner refined.
researcher and reviewer updated (with skills: preload or self-contained
conventions). Verify nothing references the deleted agents.
**Commit:** `refactor(claude): restructure agents for context-efficient summarization`

---

### Milestone 5: Convert commands to skills where appropriate

Commands and skills now share the same mechanism (commands are just skills
without the extra features). Your existing `commands/` directory works fine.
No need to migrate files.

However, review each command to verify it's set up correctly for the new
agent architecture:

- `/workflow` — update to remove references to the coder and planner agents.
  Pipeline workflow should: use researcher agent for research phase, do
  planning and implementation on main context, use test-runner agent for
  test verification.
- `/test` — consider whether this should just invoke the test-runner agent
  directly rather than running tests on main context.
- `/review` — consider whether this should invoke the reviewer agent.
- `/commit`, `/pr` — no changes needed (already work on main context).
- `/plan` — update to use researcher agent for the research phase, then
  plan on main context.
- `/write-tests` — no changes needed (stays on main context).
- `/init-project` — keep for now. Test against Claude's built-in `/init`
  on a real project. If yours produces meaningfully better results, keep it.
  If not, drop it and save the maintenance. Same for `/refresh-project`.

**Gate:** Commands updated to reference the correct agents. `/workflow` and
`/plan` updated for new architecture.
**Commit:** `refactor(claude): update commands for new agent architecture`

---

### Milestone 6: Improve compaction guidance in CLAUDE.md

**File:** `config/claude/CLAUDE.md`

Add a structured format for compacted state so output is predictable:

```markdown
## Compaction Guidance

When compacting context, ALWAYS preserve:

1. The current plan.md contents (milestones, progress, current state)
2. Which milestone you're currently working on and its gate mode
3. Any deviations from the plan noted so far
4. The project CLAUDE.md contents
5. Any gotchas discovered during this session

Use this format for compacted state:

    ## Session State
    **Task:** <one-line description>
    **Workflow:** simple | pipeline (gate mode: continuous|gated)
    **Current milestone:** <number> — <title> (<status>)
    **Completed:** <list of done milestone numbers>
    **Blockers:** <any blockers or none>
    **Gotchas found:** <list or none>
    **Key files touched:** <list of files modified this session>

Deprioritize: file contents already committed, completed milestone details,
exploratory reads that didn't yield useful information.
```

**Gate:** Compaction guidance updated.
**Commit:** `docs(claude): add structured format to compaction guidance`

---

### Milestone 7: Update docs to reflect new architecture

Update the documentation files to reflect the restructured setup:

**`docs/ARCHITECTURE.md`:**

- Update the "Layers" section to clarify: agents are for context-expensive
  summarization only, not for primary work
- Update the "Commands vs Skills vs Agents" table to reflect the new roles
- Add a section on "what goes where" decision criteria

**`docs/WORKFLOWS.md`:**

- Update pipeline workflow to reflect: researcher agent for research,
  main context for planning and implementation, test-runner agent for
  verification

**`docs/CONVENTIONS.md`:**

- No changes needed (already a good concise reference)

**Gate:** Docs accurately describe the new architecture.
**Commit:** `docs(claude): update architecture docs for new agent model`

---

## Risks & Open Questions

- **`skills:` frontmatter in agents:** This is the key unknown. If subagents
  can preload skills via frontmatter, agents stay lean. If not, agents need
  self-contained conventions (which is what you already have for researcher
  and reviewer, so the fallback is safe).
- **Deleting coder/planner agents:** If any commands or the workflow skill
  reference these agents by name, those references need updating. Grep for
  "coder", "planner", "test-writer" across all config files before deleting.
- **init-project vs built-in /init:** Worth a comparison test but not
  blocking. Can be done any time after this plan completes.
- **Skill auto-loading reliability:** Some users report Claude doesn't
  always auto-load skills reliably. If this becomes an issue, you can list
  available skills in CLAUDE.md as a hint (described by some as a "hack"
  but it works). Monitor and add if needed.

## Out of Scope

- Changing permissions or hooks in settings.json (already good)
- Adding new skills or agents beyond what's described
- Plugin/marketplace setup
- Agent teams (experimental feature, evaluate separately)
