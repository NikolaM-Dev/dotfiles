---
name: skill-creator
description: "Trigger: /skill-creation, skill creation, skill creator, create skill, new skill, update skill. Create and improve reusable skills with valid frontmatter, progressive disclosure, and trigger testing."
---

## Activation Contract

Use when creating or updating a reusable skill.

Create when:

- workflow repeats across sessions;
- project constraints differ from generic defaults;
- a decision tree prevents repeated mistakes;
- templates or local references improve repeatability.

Do not use for one-off tasks, generic docs, or rules that belong in code, tests,
or linters.

## Hard Rules

- A skill is a runtime instruction contract, not human docs.
- Keep `SKILL.md` concise: target 180-450 tokens, hard max 1000.
- Write imperative instructions. No tutorials, no background prose.
- Name is kebab-case and matches its directory: 1-64 chars, `a-z 0-9 -` only,
  no leading/trailing/double hyphen.
- Frontmatter requires only `name` and `description`. Add `license` or
  `metadata` only if the project mandates it.
- `description` is one quoted line, trigger words first, what + when to use,
  slightly pushy, 1-1024 chars.
- No `Keywords` section.
- Progressive disclosure: metadata always (~100 tokens), body on trigger
  (<500 lines), resources on demand.
- Reference bundled files with relative paths from skill root, one level deep.
  Use absolute paths in tool calls.
- Move templates, schemas, and examples to `assets/`. Move long rationale to
  `references/`.

## Decision Gates

| Situation                           | Action                      |
| ----------------------------------- | --------------------------- |
| Small reusable behavior             | Create `SKILL.md` only      |
| Templates, schemas, fixtures needed | Add `assets/`               |
| Long rationale or edge cases        | Add `references/`           |
| Verifiable output (files, data)     | Add 2-3 test prompts        |
| Subjective output (style, taste)    | Skip evals, ask user        |
| Existing skill covers it            | Update it, do not duplicate |
| Domain policy unclear               | Ask, do not invent          |

## Execution Steps

1. Inspect existing skills (`fffind`/`ffgrep`). Confirm no duplicate.
2. Interview intent: what it enables, trigger phrases, output format, edge
   cases, dependencies. Wait for answers before drafting.
3. Choose a kebab-case name matching the trigger.
4. Create structure:

```text
skills/{skill-name}/
├── SKILL.md
├── assets/       # optional
└── references/   # optional
```

5. Write minimal frontmatter:

```yaml
---
name: { skill-name }
description: "Trigger: {phrases}. {What it does and when to use it}."
---
```

6. Write sections in order: Activation Contract, Hard Rules, Decision Gates,
   Execution Steps, Output Contract, References.
7. Verify: frontmatter parses, name matches dir and constraints, `description`
   stays on one line and under limit.
8. Test: run 2-3 realistic prompts with paths, context, typos. Try in fresh Pi
   turns with skill on, then with skill dir renamed (skill off). Pass means it
   triggers when it should, skips near-misses, and output follows instructions.
9. Iterate once: generalize fixes (no overfit patches), cut dead weight, explain
   why over `ALWAYS/NEVER`. If every run reinvents the same helper, bundle it
   in `scripts/` with `--help` and non-interactive flags.

## Output Contract

Return:

- Files created or modified.
- New skill or update.
- Supporting `assets/` or `references/` added.
- Test prompts and trigger results.
- Unresolved ambiguities.
- Verification run, if any.

## References

- None required. This skill is self-contained. If you need a style example,
  read `markdown-tasks/SKILL.md`. Do not copy third-party or legacy skills
