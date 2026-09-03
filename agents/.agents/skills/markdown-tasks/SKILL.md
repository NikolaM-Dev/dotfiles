---
name: markdown-tasks
description: Create, update, schedule, and cancel tasks in any markdown file using the Tasks emoji convention (➕ ⏳ 🛫 📅 ✅ ❌ 🔁). Use when working with checklists, TODOs, ROADMAPs, or task lists in any markdown file, repo, or notes folder.
---

# Markdown Tasks

Manage tasks in any markdown file using the Tasks emoji convention (sourced from the Obsidian Tasks plugin, but vault-agnostic). Works in any repo, docs folder, `TODO.md`, daily note, or ad-hoc markdown file. Covers creation, scheduling, updates, and cancellation with the mandatory Why? sub-list for canceled tasks.

## Emoji convention (canonical)

Copy this table exactly. Do not invent emojis.

### Status (checkbox)

| Mark    | Meaning                        |
| ------- | ------------------------------ |
| `- [ ]` | Todo / open                    |
| `- [x]` | Done                           |
| `- [-]` | Canceled                       |
| `- [/]` | In progress (if vault uses it) |

Only use `- [-]` for canceled tasks. Never use strikethrough or plain text `CANCELED`.

### Dates - all `YYYY-MM-DD`

| Emoji | Field     | Meaning                                                                   |
| ----- | --------- | ------------------------------------------------------------------------- |
| `➕`  | Created   | When the task was created. Always set on creation.                        |
| `⏳`  | Scheduled | When the task is scheduled to be available/worked on. Use for scheduling. |
| `🛫`  | Start     | When work can start. Task hides before this date in queries.              |
| `📅`  | Due       | When the task is due. Deadline.                                           |
| `✅`  | Done      | When completed. Added only when marking `[x]`.                            |
| `❌`  | Cancelled | When canceled. Added only when marking `[-]`.                             |

### Priority

| Emoji    | Priority |
| -------- | -------- |
| `🔺`     | Highest  |
| `⏫`     | High     |
| `🔼`     | Medium   |
| _(none)_ | Normal   |
| `🔽`     | Low      |
| `⏬`     | Lowest   |

### Other signifiers

| Emoji  | Field                 | Example                                                     |
| ------ | --------------------- | ----------------------------------------------------------- |
| `🔁`   | Recurrence            | `🔁 every day`, `🔁 every week`, `🔁 every month when done` |
| `🏁`   | On completion         | `🏁 keep` or `🏁 delete`                                    |
| `🆔`   | ID (for dependencies) | `🆔 abc123`                                                 |
| `⛔`   | Depends on            | `⛔ abc123,def456`                                          |
| `#tag` | Tags                  | `#task` `#project/work`                                     |

### Canonical order on one line

Keep emojis in this order after the description:

```
- [ ] Description #tags ➕ YYYY-MM-DD ⏳ YYYY-MM-DD 🛫 YYYY-MM-DD 📅 YYYY-MM-DD 🔁 ... ⏫/🔼/🔽/⏬ 🏁 ... 🆔 ... ⛔ ... ✅/❌ YYYY-MM-DD
```

Only include fields that apply. Dates not needed are omitted, never blank. Use a single space between each signifier. Do not reorder.

## Creating tasks

1. Use `- [ ]` as prefix.
2. Write description as imperative, specific. Start with verb. Include context if needed.
3. Add tags immediately after description (e.g. `#task`).
4. Always add `➕ YYYY-MM-DD` with today's date (or provided creation date).
5. Add scheduling/priority/recurrence only if requested.
6. Never add `✅` or `❌` on creation.

Example:

```md
- [ ] Write interview question about state machine #task ➕ 2026-07-30 📅 2026-08-05 ⏫
- [ ] Review vault daily notes query 🔁 every day ➕ 2026-07-30
```

When creating many tasks, one per line, no bullet sub-lists unless the task itself needs detail.

## Scheduling tasks

Distinguish the three date types:

- `⏳ Scheduled` - "show me this on this day" / planned work day. Use for `schedule` requests.
- `🛫 Start` - "cannot start before this" - task hidden until this date.
- `📅 Due` - hard deadline.

Rules:

- If user says "schedule for 2026-08-01" with no qualifier, use `⏳ 2026-08-01`.
- If user says "due 2026-08-01", use `📅 2026-08-01`.
- If user says "start 2026-08-01", use `🛫 2026-08-01`.
- User may set multiple dates: `- [ ] Draft post #task ➕ 2026-07-30 🛫 2026-08-01 ⏳ 2026-08-02 📅 2026-08-05`
- Always keep `➕` (created) unchanged when rescheduling.
- When rescheduling, replace the old date value, do not append a second `⏳`/`📅`/`🛫`.

## Updating tasks

- Keep the same line, edit in place.
- Preserve `➕` and other unchanged emojis.
- Priority change: swap emoji (or remove for Normal).
- Date change: replace `YYYY-MM-DD` after the same emoji.
- Marking done: change `- [ ]` to `- [x]` and append `✅ YYYY-MM-DD` at end.
- Never add a Why? sub-list for done tasks.

Example update (reschedule):

```md
# before

- [ ] Write blog post #task ➕ 2026-07-30 ⏳ 2026-08-01

# after - moved to 2026-08-03

- [ ] Write blog post #task ➕ 2026-07-30 ⏳ 2026-08-03
```

Example done:

```md
- [x] Write blog post #task ➕ 2026-07-30 ⏳ 2026-08-03 ✅ 2026-08-03
```

## Canceling tasks - strict rule

This is mandatory. A canceled task without a reason is invalid.

1. Change `- [ ]` or `- [/]` to `- [-]`.
2. Append `❌ YYYY-MM-DD` (cancellation date, today unless specified).
3. Immediately below, add a sub-list item with the reason:

```md
- [-] Tell me about a time you solved a difficult problem ➕ 2026-07-30 ❌ 2026-07-31
  - **Why?** Because was too broad, I need to focus on the problem and not the solution.
```

Rules:

- Sub-list must be `- **Why?** <reason>` indented by 2 spaces.
- Reason must be a full sentence, explaining why it was canceled, not just "no longer needed". Push for specifics: scope change, duplicate, blocked, deprioritized, replaced by X.
- Keep original emojis (`➕`, `⏳`, `📅`, etc.) intact. Only add `❌`.
- Never delete the canceled task line. Keep it for history.
- If task had sub-bullets before cancellation, keep them and add the Why? as the last sub-bullet.

Additional examples:

```md
- [-] Migrate vault to Dataview queries #task ➕ 2026-07-28 ⏳ 2026-08-01 ❌ 2026-07-30
  - **Why?** Decided to stay on Tasks plugin, Dataview migration adds no value for current queries.

- [-] Schedule weekly review 🔁 every Monday ➕ 2026-07-30 ❌ 2026-07-31
  - **Why?** Duplicate of existing recurring task `🆔 abc123`.
```

When user asks to cancel without giving a reason, ask for the reason. Do not invent a vague reason. Propose a draft if needed and confirm.

## Recurrence

- Format: `🔁 <rule>` e.g. `🔁 every day`, `🔁 every week`, `🔁 every 2 weeks`, `🔁 every month when done`, `🔁 every weekday`
- Place right after dates, before priority.
- Do not add `✅`/`❌` to recurring templates; those are added to instances when completed/canceled.

## Querying and maintenance

- The emoji format is designed to be queryable (e.g. by Obsidian Tasks, Dataview, or scripts). A missing `➕` or wrong emoji breaks parsing, so treat the convention as a contract even outside Obsidian.
- When reading a file, parse existing tasks before editing to avoid duplicate emoji or date.
- Batch edits: keep one task per line, preserve surrounding markdown.
- Works with any markdown file path — do not assume a vault structure, daily notes folder, or specific file name. Operate on the file the user points to, or ask if ambiguous.

## Anti-patterns - never do

- Never use `:x:` style or unicode alternatives for emojis. Copy exactly: `➕ ⏳ 🛫 📅 ✅ ❌ 🔁 ⏫ 🔼 🔽 ⏬ 🔺`.
- Never put dates as `(2026-07-30)` or `[due:: 2026-07-30]`. Only `📅 2026-07-30`.
- Never use `~~strikethrough~~` to cancel.
- Never create a canceled task without `❌` and the `**Why?**` sub-list.
- Never drop `➕` when rescheduling.
