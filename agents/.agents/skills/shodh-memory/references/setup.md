# Shodh Setup and Troubleshooting

## Server

Shodh runs as a systemd user service plus HTTP API on `127.0.0.1:3030`.

```bash
shodh status    # check server health
shodh doctor    # diagnose storage, ONNX, port, server
shodh tui       # dashboard
systemctl --user status shodh-memory.service   # service state
journalctl --user -u shodh-memory.service -f   # live logs
```

Do not start `shodh server` by hand — the service already owns port 3030
and a second instance will fail to bind.

## Pi MCP Wiring

`shodh serve` speaks MCP over stdio against the supervised server.
Pi config (`~/.pi/agent/mcp.json`, symlinked into dotfiles):

```json
{
  "mcpServers": {
    "shodh-memory": {
      "command": "/home/nikola/.local/bin/shodh",
      "args": ["serve"],
      "env": {
        "SHODH_API_URL": "http://127.0.0.1:3030",
        "SHODH_API_KEY": "${SHODH_API_KEY}",
        "SHODH_USER_ID": "nikola"
      },
      "exposure": "deferred"
    }
  }
}
```

`${SHODH_API_KEY}` resolves from the shell environment (exported via
`secrets.zsh`). In Pi the tools appear as `mcp__shodh_memory__remember`,
`mcp__shodh_memory__recall`, `mcp__shodh_memory__proactive_context`, and
the five `mcp__shodh_memory__lineage_*` tools. A companion extension
(`pi-shodh-memory`) auto-recalls into the system prompt on the first run
and stores a session summary on exit.

## Troubleshooting

1. `shodh status` says down: `systemctl --user restart shodh-memory.service`,
   then `journalctl --user -u shodh-memory.service` for the cause.
2. Port 3030 in use plus unhealthy: `shodh doctor`, then restart the service.
3. MCP tools missing in Pi: `/reload` or restart Pi (tools are `deferred`,
   load them with `tool_search`).
4. Empty `recall`/`proactive_context` on a fresh install is normal — store first.
   But if memories exist and `proactive_context` still returns nothing, pass
   `semantic_threshold: 0.0`: the 0.2.0 default quality gate over-filters,
   dropping even near-verbatim matches (verified against the live server).
5. `remember`/`recall` report an error but `proactive_context` works: the
   server returns `422` on explicit `null` optionals
   (verified: `"limit": null` → 422). Omit unset fields instead of sending
   null. The write usually succeeded anyway — verify with `recall` before
   retrying to avoid duplicates. There is no delete tool in the native
   bridge; tag accidents `test`.

## Corrections to Third-Party Docs

Some guides name an npm package, a `cargo install` target, and tools such as
`recall_by_tags`, `forget`, `memory_stats`, `context_summary`, or
`verify_index`. None of those apply to this setup (v0.2.0 native bridge).
Use the binary in `~/.local/bin` and the eight tools above.
