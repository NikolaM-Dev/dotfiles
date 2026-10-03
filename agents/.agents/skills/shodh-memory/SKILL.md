---
name: shodh-memory
description: "Trigger: remember this, do you remember, recall, shodh memory. Persist decisions and learnings across sessions — recall context at session start, store with remember, search with recall."
---

# Shodh Memory

## Activation Contract

Use when the user says remember, recall, forget, or "do you remember",
when substantive work starts, or when a decision, preference, error fix,
or reusable learning appears. Run step 1 at session start before answering
from base knowledge alone.

## Hard Rules

- Call `proactive_context` once per session with the opening message, not
  once per user message. (The `pi-shodh-memory` extension already does this
  on the first run — check the injected `Remembered context` block before
  re-calling.) Use surfaced memories in the reply or proceed without them.
- Only these MCP tools exist (prefix `mcp__shodh_memory__` in Pi):
  `proactive_context`, `remember`, `recall`, `lineage_trace`,
  `lineage_link`, `lineage_confirm`, `lineage_reject`, `lineage_stats`.
  Never call `recall_by_tags`, `forget`, `memory_stats`,
  `context_summary`, or `verify_index` — they do not exist on this server.
- Store with `remember(content, type, tags)`: specific content plus
  reasoning, never one-liners. See `assets/memory-template.md`.
  Pick the type from `references/memory-types.md`.
- Search with `recall(query, mode)` defaulting to `hybrid`. Never claim
  nothing is remembered without calling `recall` first.
- If `proactive_context` returns nothing despite stored memories, retry
  with `semantic_threshold: 0.0` — the 0.2.0 default quality gate
  over-filters, dropping even near-verbatim matches.
- If the server is unreachable, read `references/setup.md` and report.
  Do not invent workarounds.

## Decision Gates

| Signal                                       | Action                                                                            |
| -------------------------------------------- | --------------------------------------------------------------------------------- |
| Session start or new topic                   | `proactive_context`, then answer with surfaced context                            |
| Decision, preference, fix, reusable learning | `remember` immediately, with tags                                                 |
| "Do you remember" or past-context question   | `recall` (hybrid), then synthesize                                                |
| "Why did we" or recurring issue              | `recall`, then `lineage_trace` on the best hit                                    |
| Wrong or stale memory surfaced               | State the correction and `remember` it; link with `lineage_link` (`SupersededBy`) |

## Execution Steps

1. Send the opening message to `proactive_context` (`max_results: 5`).
   Skip if the extension already injected a `Remembered context` block.
2. For questions about the past, `recall` before answering.
3. After each durable outcome, `remember` it with type and tags.
   (Session exit is captured automatically — add only high-value items.)
4. For cause-and-effect pairs (error to fix, decision to outcome),
   connect them with `lineage_link`.
5. Keep working; do not narrate memory calls unless asked.

## Output Contract

- Replies incorporate remembered context without exposing raw IDs.
- Corrections to past memories are confirmed in one line.
- Memory tool failures are reported, never hidden.

## References

- `references/memory-types.md` — types, tags, recall modes.
- `references/setup.md` — server setup and troubleshooting.
- `assets/memory-template.md` — store format.
