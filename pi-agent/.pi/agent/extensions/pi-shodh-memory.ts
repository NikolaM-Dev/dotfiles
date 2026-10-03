/**
 * pi-shodh-memory — automatic Shodh memory recall and capture.
 *
 * - `before_agent_start` (first run per session): fetches `proactive_context`
 *   for the current prompt and appends a compact block to the system prompt.
 *   Later runs reuse the cached block (no refetch, no prompt-loop cost).
 * - `session_shutdown` + `session_before_switch` (quit/new/resume/fork):
 *   stores one extractive `session-summary` memory (first request, tools
 *   used, files touched, outcome). Duplicate-safe per session.
 * - `/shodh-status`: health check against the supervised server.
 *
 * Talks HTTP directly to the supervised `shodh server` so it works even when
 * the MCP server is disabled. Best-effort with short timeouts: it never
 * blocks the agent run, session switch, or quit, and never throws.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const FETCH_TIMEOUT_MS = 8000;
const MAX_MEMORIES = 5;
const MAX_BLOCK_CHARS = 2000;
const MAX_TEXT_CHARS = 400;

function apiUrl(): string {
  const configured = process.env.SHODH_API_URL?.trim();
  return (configured || "http://127.0.0.1:3030").replace(/\/+$/, "");
}

function apiKey(): string {
  const single = process.env.SHODH_API_KEY?.trim();
  if (single) return single;
  const plural = process.env.SHODH_API_KEYS?.trim();
  if (plural) return plural.split(",")[0]?.trim() || "";
  return "";
}

function userId(): string {
  return process.env.SHODH_USER_ID?.trim() || "nikola";
}

function diag(message: string): void {
  try {
    process.stderr.write(`[pi-shodh-memory] ${message}\n`);
  } catch {
    // Diagnostics must never break the session.
  }
}

let warnedNoKey = false;
function warnNoKeyOnce(): void {
  if (warnedNoKey) return;
  warnedNoKey = true;
  diag("SHODH_API_KEY is not set; memory recall/capture disabled for this process.");
}

async function postJson<T>(path: string, body: unknown): Promise<T | null> {
  const key = apiKey();
  if (!key) {
    warnNoKeyOnce();
    return null;
  }
  try {
    const res = await fetch(`${apiUrl()}${path}`, {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-API-Key": key },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(FETCH_TIMEOUT_MS),
    });
    if (!res.ok) {
      diag(`POST ${path} -> HTTP ${res.status}`);
      return null;
    }
    return (await res.json()) as T;
  } catch (error) {
    diag(`POST ${path} failed: ${error instanceof Error ? error.message : String(error)}`);
    return null;
  }
}

type SessionCtx = {
  cwd: string;
  sessionManager: {
    getSessionId?: () => string | undefined;
    getEntries?: () => Array<Record<string, unknown>>;
  };
};

function sessionIdOf(ctx: SessionCtx): string {
  try {
    return ctx.sessionManager.getSessionId?.() || ctx.cwd;
  } catch {
    return ctx.cwd;
  }
}

function projectName(cwd: string): string {
  const base = cwd.replace(/\\/g, "/").replace(/\/+$/, "").split("/").pop() || "unknown";
  return base.toLowerCase().replace(/[^a-z0-9_-]+/g, "-").slice(0, 40) || "unknown";
}

function trimText(value: unknown, max = MAX_TEXT_CHARS): string {
  if (typeof value !== "string") return "";
  const flat = value.replace(/\s+/g, " ").trim();
  return flat.length > max ? `${flat.slice(0, max)}…` : flat;
}

/** Accepts both proactive_context (flat) and recall (nested) memory shapes. */
function memoryText(memory: unknown): { type: string; content: string } | null {
  if (typeof memory !== "object" || memory === null) return null;
  const m = memory as Record<string, unknown>;
  const nested = m["experience"] as Record<string, unknown> | undefined;
  const content =
    trimText(m["content"]) || (nested ? trimText(nested["content"]) : "");
  if (!content) return null;
  const type =
    (typeof m["memory_type"] === "string" && m["memory_type"]) ||
    (nested && typeof nested["memory_type"] === "string" ? nested["memory_type"] : "") ||
    "Observation";
  return { type, content };
}

function itemText(item: unknown): string {
  if (typeof item !== "object" || item === null) return "";
  const o = item as Record<string, unknown>;
  return (
    trimText(o["text"]) ||
    trimText(o["content"]) ||
    trimText(o["title"]) ||
    trimText(o["message"])
  );
}

function formatRecallBlock(data: unknown): string | null {
  if (typeof data !== "object" || data === null) return null;
  const d = data as Record<string, unknown>;
  const lines: string[] = [];

  const memories = Array.isArray(d["memories"]) ? d["memories"] : [];
  for (const memory of memories.slice(0, MAX_MEMORIES)) {
    const parsed = memoryText(memory);
    if (parsed) lines.push(`- [${parsed.type}] ${parsed.content}`);
  }

  const reminders = [
    ...(Array.isArray(d["due_reminders"]) ? d["due_reminders"] : []),
    ...(Array.isArray(d["context_reminders"]) ? d["context_reminders"] : []),
  ];
  for (const reminder of reminders.slice(0, 3)) {
    const text = itemText(reminder);
    if (text) lines.push(`- [Reminder] ${text}`);
  }

  const todos = Array.isArray(d["relevant_todos"]) ? d["relevant_todos"] : [];
  for (const todo of todos.slice(0, 3)) {
    const text = itemText(todo);
    if (text) lines.push(`- [Todo] ${text}`);
  }

  if (lines.length === 0) return null;
  let block = `## Remembered context (Shodh)\n${lines.join("\n")}`;
  if (block.length > MAX_BLOCK_CHARS) block = `${block.slice(0, MAX_BLOCK_CHARS)}…`;
  return block;
}

function entryText(entry: Record<string, unknown>): string {
  const message = entry["message"] as Record<string, unknown> | undefined;
  if (!message || typeof message !== "object") return "";
  const content = message["content"] as unknown;
  if (typeof content === "string") return content;
  if (Array.isArray(content)) {
    return content
      .filter(
        (c): c is { type: "text"; text: string } =>
          typeof c === "object" &&
          c !== null &&
          (c as { type?: unknown }).type === "text" &&
          typeof (c as { text?: unknown }).text === "string",
      )
      .map((c) => c.text)
      .join("\n");
  }
  return "";
}

/** Extractive session summary. Returns null when the session did nothing worth storing. */
function buildSessionSummary(
  entries: Array<Record<string, unknown>>,
  cwd: string,
): string | null {
  let firstUser = "";
  let lastAssistant = "";
  let userTurns = 0;
  const tools = new Set<string>();

  for (const entry of entries) {
    if (entry["type"] !== "message") continue;
    const message = entry["message"] as Record<string, unknown> | undefined;
    if (!message || typeof message !== "object") continue;
    const role = message["role"];
    if (role === "user") {
      userTurns += 1;
      if (!firstUser) firstUser = entryText(entry);
    } else if (role === "assistant") {
      const text = entryText(entry);
      if (text) lastAssistant = text;
    } else if (role === "toolResult" || role === "toolCall") {
      const name = message["toolName"];
      if (typeof name === "string" && name && !name.startsWith("mcp__shodh")) {
        tools.add(name);
      }
    }
    // Nested tool calls surface on assistant messages in some transcripts.
    const nested = message["nestedCalls"];
    if (Array.isArray(nested)) {
      for (const call of nested) {
        const name =
          typeof call === "object" && call !== null
            ? (call as Record<string, unknown>)["name"]
            : undefined;
        if (typeof name === "string" && name && !name.startsWith("mcp__shodh")) {
          tools.add(name);
        }
      }
    }
  }

  if (userTurns === 0) return null;

  const parts = [
    `Session in ${cwd}: ${userTurns} user turn(s).`,
    firstUser ? `First request: ${trimText(firstUser, 500)}` : "",
    tools.size > 0 ? `Tools used: ${[...tools].slice(0, 12).join(", ")}` : "No tools used.",
    lastAssistant ? `Outcome: ${trimText(lastAssistant, 500)}` : "",
  ].filter(Boolean);
  return parts.join("\n");
}

export default function piShodhMemory(pi: ExtensionAPI) {
  // Recalled block per session id (null = recalled, nothing relevant).
  const recalled = new Map<string, string | null>();
  // Sessions already captured in this process (shutdown + before_switch converge).
  const captured = new Set<string>();

  pi.on("before_agent_start", async (event, ctx) => {
    const sid = sessionIdOf(ctx as SessionCtx);
    if (!recalled.has(sid)) {
      const prompt = typeof event.prompt === "string" ? event.prompt : "";
      if (!prompt.trim()) {
        recalled.set(sid, null);
        return;
      }
      const data = await postJson<unknown>("/api/proactive_context", {
        user_id: userId(),
        context: prompt.slice(0, 2000),
        max_results: MAX_MEMORIES,
        auto_ingest: false,
        // 0.2.0 quirk: the default quality gate (threshold 0.05) filters out
        // even near-verbatim matches, so disable it and rely on top-K
        // ranking plus the model's own judgment of the labeled block.
        semantic_threshold: 0.0,
      });
      recalled.set(sid, data ? formatRecallBlock(data) : null);
    }
    const block = recalled.get(sid);
    if (block) {
      return { systemPrompt: `${event.systemPrompt}\n\n${block}` };
    }
  });

  async function capture(ctx: SessionCtx): Promise<void> {
    const sid = sessionIdOf(ctx);
    if (captured.has(sid)) return;
    captured.add(sid);
    let entries: Array<Record<string, unknown>> = [];
    try {
      entries = ctx.sessionManager.getEntries?.() ?? [];
    } catch {
      return;
    }
    const summary = buildSessionSummary(entries, ctx.cwd);
    if (!summary) return;
    const saved = await postJson<{ id?: string }>("/api/remember", {
      user_id: userId(),
      content: summary,
      memory_type: "Context",
      tags: ["session-summary", `project:${projectName(ctx.cwd)}`],
    });
    if (saved && ctx.hasUI) {
      ctx.ui.notify("Session saved to Shodh memory.", "info");
    }
  }

  pi.on("session_shutdown", async (_event, ctx) => {
    await capture(ctx as SessionCtx);
  });

  pi.on("session_before_switch", async (_event, ctx) => {
    await capture(ctx as SessionCtx);
  });

  pi.registerCommand("shodh-status", {
    description: "Check Shodh memory server health",
    handler: async (_args, ctx) => {
      try {
        const res = await fetch(`${apiUrl()}/health`, {
          signal: AbortSignal.timeout(FETCH_TIMEOUT_MS),
        });
        if (!res.ok) {
          ctx.ui.notify(`Shodh server unhealthy: HTTP ${res.status}`, "error");
          return;
        }
        const health = (await res.json()) as {
          version?: string;
          users_count?: number;
        };
        ctx.ui.notify(
          `Shodh v${health.version ?? "?"} healthy (${health.users_count ?? "?"} user(s)).`,
          "info",
        );
      } catch (error) {
        ctx.ui.notify(
          `Shodh server unreachable: ${error instanceof Error ? error.message : String(error)}`,
          "error",
        );
      }
    },
  });
}
