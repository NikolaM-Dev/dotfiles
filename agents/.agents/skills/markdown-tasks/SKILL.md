---
name: markdown-tasks
description:
  "Trigger: task list, list tasks, TODO, checklist, ROADMAP, schedule task, mark done, cancel task, session recap, what did we do, summarize tasks. Create, update, schedule, cancel, and list tasks in markdown files using the Tasks emoji convention."
---

# Markdown Tasks

## Activation Contract

Use when the user works with tasks in any markdown file (`TODO.md`,
`ROADMAP.md`, daily note, repo docs, ad-hoc file). Also use when the user asks
to list, recap, or summarize tasks from the session or from files ("list tasks",
"what did we do", "session recap"). Operate on the file the user points to. Ask
if ambiguous. Read `references/convention.md` before the first
create/update/cancel/list in a session.

## Hard Rules

- Copy emojis exactly: `➕ ⏳ 🛫 📅 ✅ ❌ 🔁 ⏫ 🔼 🔽 ⏬ 🔺`. Never invent,
  never use `:x:` style or `~~strikethrough~~`.
- Use `YYYY-MM-DD` after the emoji, single spaces, canonical order:
  `Description ➕ … ⏳ … 🛫 … 📅 … 🔁 … priority 🏁 … 🆔 … ⛔ … ✅/❌ …`. Omit
  unused fields, never leave blank, never append a duplicate emoji.
- Always set `➕ <today>` on creation using the real current date (`date +%F`).
  Never add `✅`/`❌` on creation.
- Preserve `➕` and untouched fields on every edit. Replace date values in
  place.
- Mark done only as `- [x]` + trailing `✅ <today>`. Never add a `Why?` to done
  tasks.
- Cancel only as `- [-]` + trailing `❌ <today>` + mandatory checked sub-task
  below. A canceled task without it is invalid.
- Cancel sub-task format (2-space indent, `✅` date matches `❌` date):
  `  - [x] **Why?:** <full sentence reason> ✅ YYYY-MM-DD`

## Decision Gates

| User says                                              | Action                                       |
| ------------------------------------------------------ | -------------------------------------------- |
| schedule / show me on X                                | Set `⏳ X`                                   |
| due / deadline X                                       | Set `📅 X`                                   |
| start / cannot start before X                          | Set `🛫 X`                                   |
| done / finished                                        | `- [x]` + `✅`                               |
| cancel / drop / no longer doing                        | `- [-]` + `❌` + `Why?` sub-task             |
| priority high/medium/low                               | Swap `⏫/🔼/🔽/⏬/🔺`, remove for Normal     |
| repeat / every …                                       | Add `🔁 <rule>` after dates, before priority |
| list / show / recap / what did we do / summarize tasks | List tasks, do not edit files unless asked   |

## Execution Steps

1. Parse the target file first. Do not duplicate emojis or dates.
2. Create: `- [ ] <imperative description> ➕ <today>` plus only requested
   scheduling/priority/recurrence. One task per line.
3. Reschedule/update: edit in place, keep `➕`, replace the date value.
4. Done: flip to `- [x]`, append `✅ <today>` at end.
5. Cancel:
   1. Flip to `- [-]`, keep `➕/⏳/🛫/📅/🔁` intact, append `❌ <today>`.
   2. Append
      `  - [x] **Why?:** <specific sentence: scope change, duplicate of X, blocked by Y, replaced by Z> ✅ <today>`.
   3. If no reason given, ask for it. Propose a specific draft, confirm, never
      invent a vague reason. Never delete the parent line.
6. Keep one task per line, preserve surrounding markdown.
7. List/recap: collect tasks created, updated, done, and canceled in this
   session plus matching lines from target files if given. Output grouped as
   Open / Done / Canceled (keep `Why?` line with its parent), in canonical emoji
   format. Do not edit files unless the user asks to write the list down.

## Output Contract

Return: file edited, lines added/updated, open questions (e.g. missing cancel
reason or ambiguous date). For list/recap: grouped task list, no file edit
unless requested.

## References

- Full emoji tables, order, examples, anti-patterns:
  [convention.md](references/convention.md)
