# Convention Reference — Tasks Emoji Format

Vault-agnostic. Sourced from the Obsidian Tasks plugin. Treat as a parsing
contract: a missing `➕` or wrong emoji breaks queries (Tasks, Dataview,
scripts).

## Status (checkbox)

| Mark    | Meaning                        |
| ------- | ------------------------------ |
| `- [ ]` | Todo / open                    |
| `- [x]` | Done                           |
| `- [-]` | Canceled                       |
| `- [/]` | In progress (if vault uses it) |

Only `- [-]` cancels. Never strikethrough or plain-text `CANCELED`.

## Dates — all `YYYY-MM-DD`

| Emoji | Field     | Meaning                                                  |
| ----- | --------- | -------------------------------------------------------- |
| `➕`  | Created   | When created. Always set, never dropped on reschedule.   |
| `⏳`  | Scheduled | Planned work day. Use for bare "schedule for X".         |
| `🛫`  | Start     | Cannot start before this. Hidden before this in queries. |
| `📅`  | Due       | Hard deadline.                                           |
| `✅`  | Done      | Added only with `[x]`.                                   |
| `❌`  | Cancelled | Added only with `[-]`.                                   |

## Priority

| Emoji    | Priority |
| -------- | -------- |
| `🔺`     | Highest  |
| `⏫`     | High     |
| `🔼`     | Medium   |
| _(none)_ | Normal   |
| `🔽`     | Low      |
| `⏬`     | Lowest   |

## Other signifiers

| Emoji | Field           | Example                                                     |
| ----- | --------------- | ----------------------------------------------------------- |
| `🔁`  | Recurrence      | `🔁 every day`, `🔁 every week`, `🔁 every month when done` |
| `🏁`  | On completion   | `🏁 keep` or `🏁 delete`                                    |
| `🆔`  | ID (dependency) | `🆔 abc123`                                                 |
| `⛔`  | Depends on      | `⛔ abc123,def456`                                          |

## Canonical order on one line

```
- [ ] Description ➕ YYYY-MM-DD ⏳ YYYY-MM-DD 🛫 YYYY-MM-DD 📅 YYYY-MM-DD 🔁 ... ⏫/🔼/🔽/⏬ 🏁 ... 🆔 ... ⛔ ... ✅/❌ YYYY-MM-DD
```

Only include fields that apply.

## Examples

Create:

```md
- [ ] Write interview question about state machine ➕ 2026-07-30 📅 2026-08-05 ⏫
- [ ] Review vault daily notes query ➕ 2026-07-30 🔁 every day
```

Multiple dates:

```md
- [ ] Draft post ➕ 2026-07-30 🛫 2026-08-01 ⏳ 2026-08-02 📅 2026-08-05
```

Reschedule (replace, do not append):

```md
# before

- [ ] Write blog post ➕ 2026-07-30 ⏳ 2026-08-01

# after — moved to 2026-08-03

- [ ] Write blog post ➕ 2026-07-30 ⏳ 2026-08-03
```

Done:

```md
- [x] Write blog post ➕ 2026-07-30 ⏳ 2026-08-03 ✅ 2026-08-03
```

Cancel — parent keeps its emojis, `Why?` is last sub-bullet if others exist:

```md
- [-] Tell me about a time you solved a difficult problem ➕ 2026-07-30 ❌ 2026-07-31
  - [x] **Why?:** Because was too broad, I need to focus on the problem and not the solution. ✅ 2026-07-31

- [-] How to train martial arts ➕ 2026-09-02 ❌ 2026-09-03
  - [x] **Why?:** This is a whole new area, right now it's not my priority. ✅ 2026-09-03

- [-] Migrate vault to Dataview queries ➕ 2026-07-28 ⏳ 2026-08-01 ❌ 2026-07-30
  - [x] **Why?:** Decided to stay on Tasks plugin, Dataview migration adds no value for current queries. ✅ 2026-07-30

- [-] Schedule weekly review ➕ 2026-07-30 🔁 every Monday ❌ 2026-07-31
  - [x] **Why?:** Duplicate of existing recurring task `🆔 abc123`. ✅ 2026-07-31
```

Recurrence: `🔁 every day`, `🔁 every week`, `🔁 every 2 weeks`,
`🔁 every month when done`, `🔁 every weekday`. No `✅`/`❌` on the template
itself.

## Anti-patterns — never do

- Never use `:x:` style or unicode lookalikes. Copy exactly.
- Never write dates as `(2026-07-30)` or `[due:: 2026-07-30]`. Only
  `📅 2026-07-30`.
- Never use `~~strikethrough~~` to cancel.
- Never create a canceled task without `❌` and
  `  - [x] **Why?:** <reason> ✅ YYYY-MM-DD`.
- Never drop `➕` when rescheduling.
- Never add `Why?` to done tasks.
