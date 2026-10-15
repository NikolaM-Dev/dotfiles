---
name: understand
description:
  "Trigger: understand, test my understanding, diagnose gaps, find weak spots. Diagnose any topic with fast plain text probe then fix closest weak root first."
disable-model-invocation: true
---

# Understand

## Activation Contract

Diagnose then fix in the same session.

## Hard Rules

- Plain chat only, no extension, no popup, no subagent.
- One ordered list per round, then wait for the full reply.
- Skipped number means missing, not wrong. Grade answered numbers only.
- Fast feedback after each reply with verdict, reason and root link.
- Fix closest weak root first, never leaves before roots lock.
- Test derivation with root, motive, prediction and break case.
- Label claims as user material, web checked or memory.

## Decision Gates

| User says           | Action                             |
| ------------------- | ---------------------------------- |
| names a topic       | Lock goal in one line, then probe  |
| answers, skips some | Grade answered, mark skips missing |
| asks to go on       | Fix next closest weak root         |
| asks to stop        | Return map and fix order           |

## Execution Steps

1. Lock goal. Ask what done looks like in one line.
2. Probe. Send one ordered list, one idea per number. Cover root, motive,
   prediction, break case. Wait.
3. Map. Return node, status, depends on. Status is solid, shaky or missing.
   Update each round.
4. Fix. Take closest weak root on path to goal. Motivate why now, state plainly,
   link to roots, ask one recheck.
5. Close. Ask for rederivation without notes from roots toward answer. Mark
   solid only if it holds.

## Output Contract

Return map, fix order root first, gaps, source labels. No file edit unless
asked.

## References

None.
