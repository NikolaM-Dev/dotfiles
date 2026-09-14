---
name: skill-creator
description: "Trigger: /skill-creation, skill creation, skill creator, create skill, new skill. Create LLM-first skills with valid frontmatter."
---

## Activation Contract

Use when creating or updating a reusable skill.

Create when:

- workflow repeats across sessions;
- project constraints differ from generic defaults;
- a decision tree prevents repeated mistakes;
- templates or local references improve repeatability.

Do not use for one-off tasks, generic docs, or rules that belong in code, tests, or linters.

## Hard Rules

- A skill is a runtime instruction contract, not human docs.
- Keep `SKILL.md` concise: target 180-450 tokens, hard max 1000.
- Write imperative instructions. No tutorials, no background prose.
- Name is kebab-case and matches its directory.
- Frontmatter requires only `name` and `description`. Add `license` or `metadata` only if the project mandates it.
- `description` is one quoted line, trigger words first.
- No `Keywords` section.
- Move templates, schemas, and examples to `assets/`. Move long rationale to `references/`.

## Decision Gates

| Situation                           | Action                      |
| ----------------------------------- | --------------------------- |
| Small reusable behavior             | Create `SKILL.md` only      |
| Templates, schemas, fixtures needed | Add `assets/`               |
| Long rationale or edge cases        | Add `references/`           |
| Existing skill covers it            | Update it, do not duplicate |
| Domain policy unclear               | Ask, do not invent          |

## Execution Steps

1. Inspect existing skills. Confirm no duplicate.
2. Choose a kebab-case name matching the trigger.
3. Create structure:

```text
skills/{skill-name}/
├── SKILL.md
├── assets/       # optional
└── references/   # optional
```

4. Write minimal frontmatter:

```yaml
---
name: { skill-name }
description: "Trigger: {phrases users or agents will say}. {What this skill does}."
---
```

5. Write sections in order: Activation Contract, Hard Rules, Decision Gates, Execution Steps, Output Contract, References.
6. Verify frontmatter parses and `description` stays on one line.

## Output Contract

Return:

- Files created or modified.
- New skill or update.
- Supporting `assets/` or `references/` added.
- Unresolved ambiguities.
- Verification run, if any.

## References

- None required. This skill is self-contained. Use existing `skills/*` as style examples when available.
