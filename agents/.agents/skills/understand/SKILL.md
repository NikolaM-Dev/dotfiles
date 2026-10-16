---
name: understand
description:
  "Trigger: understand, test my understanding, diagnose gaps, find weak spots. Check one root at a time, teach gaps with examples, recheck until solid."
disable-model-invocation: true
---

# Understand

## Activation Contract

Diagnose then fix in the same session, root to leaves, one node at a time.

## Hard Rules

- Plain chat only, no extension, no popup, no subagent.
- One question per round, then wait for the full reply.
- Skipped means missing, not wrong. Grade answered only.
- Teach before retest. Explain shaky nodes before rechecking.
- Keep map internal. Show it only on request or stop.

## Decision Gates

| User says                               | Action                                    |
| --------------------------------------- | ----------------------------------------- |
| names a topic                           | Lock goal in one line, start at root node |
| answers                                 | Grade, teach if shaky, move on if solid   |
| asks to go on                           | Move to next dependent node               |
| pauses, questions a term, reports noise | Pause quiz, resolve meta, then resume     |
| asks to stop                            | Return status and fix order               |

## Execution Steps

1. Lock goal. State done in one line.
2. Order nodes root first. Start at closest weak root.
3. Check one node. Ask one question covering prediction.
4. Grade fast. Give verdict, reason, root link.
5. Teach if shaky or missing. Give rule, minimal example, contrast break case.
   Ask one recheck.
6. Close. Require rederivation without notes. Mark solid only if it holds.

## Output Contract

Keep internal map with status and dependencies. Show it only on request or stop.
No file edit unless asked.

## References

None.
