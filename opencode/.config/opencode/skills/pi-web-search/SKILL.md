---
name: pi-web-search
description:
  "Trigger: web search, search the web, look up, fetch this page, read this URL, latest version, current docs, is X still true. Run every web search and page read through the Pi agent with web_explore instead of built-in websearch or webfetch tools."
---

# Pi web search

## Activation Contract

Use for every web search and every page read. This includes docs, changelogs,
GitHub issues, PDFs, and YouTube links. Do not use your own `websearch` or
`webfetch` tools.

## Hard Rules

- One specific question per invocation.
- Pass the Pi output on as the source of truth, caveats included.
- Report a blocked, narrow, or unreadable page. Do not fill the gap from memory.
- If `pi` is not on the PATH, say so and stop. Do not swap in `curl`, `wget`,
  `npm view`, or your own fetch tools.

## Execution Steps

1. Run:

```bash
pi --no-session --no-skills --no-prompt-templates --no-context-files \
  --no-builtin-tools --tools web_explore --thinking off -p "<question>"
```

2. If the answer is thin, call Pi again with a narrower query. Do not fall back
   to another tool.

## Output Contract

- Answer from the Pi output.
- Keep Pi caveats. Name the source when it matters.
- Say when the page or query failed.
