/**
 * pi-shodh-memory — lean automatic recall and capture.
 *
 * - before_agent_start, first run per session only. Fetches proactive_context
 *   once and reuses the cached block. No per-turn refetch.
 * - tool_result, bash errors only. Fire and forget store, never awaits.
 * - session_shutdown, switch, fork, compact. One extractive session-summary,
 *   fire and forget, no UI toast.
 * - session_start. Quiet auth probe, warns only when debug is on.
 * - shodh-status. Manual health check.
 *
 * Quiet by design. No stderr writes unless SHODH_DEBUG is set. Never blocks
 * the agent run, session switch, or quit, and never throws. Talks HTTP
 * directly to the supervised shodh server so it works even when MCP is off.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const RECALL_TIMEOUT_MS = 1500;
const REMEMBER_TIMEOUT_MS = 1500;
const AUTH_TIMEOUT_MS = 3000;
const MAX_MEMORIES = 5;
const MAX_BLOCK_CHARS = 2000;
const MAX_TEXT_CHARS = 400;
const CIRCUIT_BREAKER_THRESHOLD = 3;

function apiUrl(): string {
  const configured = process.env.SHODH_API_URL?.trim();
  return (configured || "http://127.0.0.1:3030").replace(/\/+$/, "");
}

type KeySource = "env" | "shared-key-file" | "none";

function resolveApiKey(): { key: string; source: KeySource } {
  const single = process.env.SHODH_API_KEY?.trim();
  if (single) return { key: single, source: "env" };
  const plural = process.env.SHODH_API_KEYS?.trim();
  const first = plural?.split(",")[0]?.trim();
  if (first) return { key: first, source: "env" };

  const roots: string[] = [];
  if (process.env.SHODH_MEMORY_PATH?.trim()) roots.push(process.env.SHODH_MEMORY_PATH.trim());
  const home = homedir();
  if (process.platform === "win32") {
    roots.push(join(process.env.APPDATA || join(home, "AppData", "Roaming"), "shodh-memory"));
  } else if (process.platform === "darwin") {
    roots.push(join(home, "Library", "Application Support", "shodh-memory"));
  } else {
    roots.push(join(process.env.XDG_DATA_HOME || join(home, ".local", "share"), "shodh-memory"));
  }
  for (const root of roots) {
    try {
      const raw = readFileSync(join(root, ".api-key"), "utf-8").trim();
      if (raw) return { key: raw, source: "shared-key-file" };
    } catch {
      // Absent or unreadable, try next.
    }
  }
  return { key: "", source: "none" };
}

function userId(): string {
  return process.env.SHODH_USER_ID?.trim() || "nikola";
}

function isDebug(): boolean {
  return process.env.SHODH_DEBUG?.trim() === "1";
}

function diag(message: string): void {
  if (!isDebug()) return;
  try {
    process.stderr.write(`[pi-shodh-memory] ${message}\n`);
  } catch {
    // Diagnostics must never break the session.
  }
}

let warnedNoKey = false;
function warnNoKeyOnce(source: KeySource): void {
  if (warnedNoKey) return;
  warnedNoKey = true;
  if (source === "none") diag("No API key found, recall and capture disabled.");
}

let consecutiveFailures = 0;

async function postJson<T>(path: string, body: unknown, timeoutMs: number): Promise<T | null> {
  if (consecutiveFailures >= CIRCUIT_BREAKER_THRESHOLD) return null;
  const { key, source } = resolveApiKey();
  if (!key) {
    warnNoKeyOnce(source);
    return null;
  }
  try {
    const res = await fetch(`${apiUrl()}${path}`, {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-API-Key": key },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(timeoutMs),
    });
    if (!res.ok) {
      consecutiveFailures++;
      diag(`POST ${path} -> HTTP ${res.status} via ${source}`);
      return null;
    }
    consecutiveFailures = 0;
    return (await res.json()) as T;
  } catch (error) {
    consecutiveFailures++;
    diag(`POST ${path} failed: ${error instanceof Error ? error.message : String(error)}`);
    return null;
  }
}

async function verifyServerAuth(): Promise<"ok" | "unauthorized" | "unreachable" | "no-key"> {
  const { key } = resolveApiKey();
  if (!key) return "no-key";
  try {
    const res = await fetch(`${apiUrl()}/api/users`, {
      headers: { "X-API-Key": key },
      signal: AbortSignal.timeout(AUTH_TIMEOUT_MS),
    });
    if (res.status === 401 || res.status === 403) return "unauthorized";
    return "ok";
  } catch {
    return "unreachable";
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

function memoryText(memory: unknown): { type: string; content: string } | null {
  if (typeof memory !== "object" || memory === null) return null;
  const m = memory as Record<string, unknown>;
  const nested = m["experience"] as Record<string, unknown> | undefined;
  const content = trimText(m["content"]) || (nested ? trimText(nested["content"]) : "");
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

function factText(item: unknown): string | null {
  if (typeof item !== "object" || item === null) return null;
  const o = item as Record<string, unknown>;
  const fact = trimText(o["fact"], 200);
  if (!fact) return null;
  const confidence = typeof o["confidence"] === "number" ? o["confidence"] : 0;
  if (confidence > 0) return `[Fact ${Math.round(confidence * 100)}%] ${fact}`;
  return `[Fact] ${fact}`;
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

  const facts = Array.isArray(d["relevant_facts"]) ? d["relevant_facts"] : [];
  for (const item of facts.slice(0, 3)) {
    const text = factText(item);
    if (text) lines.push(`- ${text}`);
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

function toolResultText(content: unknown): string {
  if (!Array.isArray(content)) return "";
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

function entryText(entry: Record<string, unknown>): string {
  const message = entry["message"] as Record<string, unknown> | undefined;
  if (!message || typeof message !== "object") return "";
  const content = message["content"] as unknown;
  if (typeof content === "string") return content;
  if (Array.isArray(content)) return toolResultText(content);
  return "";
}

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

function rememberMinimal(content: string, memoryType: string, tags: string[]): void {
  void postJson<{ id?: string }>("/api/remember", {
    user_id: userId(),
    content,
    memory_type: memoryType,
    tags,
  }, REMEMBER_TIMEOUT_MS).then(() => undefined, () => undefined);
}

export default function piShodhMemory(pi: ExtensionAPI) {
  const recalled = new Map<string, string | null>();
  const captured = new Set<string>();

  pi.on("session_start", async () => {
    const probe = await verifyServerAuth();
    if (probe === "unauthorized") diag("Server rejected API key.");
    else if (probe === "unreachable") diag("Memory server unreachable, will retry per event.");
    else if (probe === "no-key") warnNoKeyOnce("none");
  });

  pi.on("before_agent_start", async (event, ctx) => {
    const sid = sessionIdOf(ctx as SessionCtx);
    if (recalled.has(sid)) {
      const cached = recalled.get(sid);
      if (cached) return { systemPrompt: `${event.systemPrompt}\n\n${cached}` };
      return;
    }
    const prompt = typeof event.prompt === "string" ? event.prompt : "";
    if (prompt.trim().length < 10) {
      recalled.set(sid, null);
      return;
    }
    const data = await postJson<unknown>("/api/proactive_context", {
      user_id: userId(),
      context: prompt.slice(0, 2000),
      max_results: MAX_MEMORIES,
      auto_ingest: false,
      semantic_threshold: 0.0,
    }, RECALL_TIMEOUT_MS);
    const block = data ? formatRecallBlock(data) : null;
    recalled.set(sid, block);
    diag(block ? `recall ok, ${block.length} chars` : "recall empty");
    if (block) return { systemPrompt: `${event.systemPrompt}\n\n${block}` };
  });

  pi.on("tool_result", async (event) => {
    if (event.toolName.startsWith("mcp__shodh")) return;
    if (event.toolName !== "bash") return;
    if (!event.isError) return;
    const command = typeof event.input["command"] === "string" ? event.input["command"] : "";
    const output = toolResultText(event.content);
    rememberMinimal(
      `Command failed: ${command.slice(0, 100)} -> ${output.slice(0, 200)}`,
      "Error",
      ["tool:bash", "error"],
    );
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
    rememberMinimal(summary, "Context", ["session-summary", `project:${projectName(ctx.cwd)}`]);
    diag(`summary queued, ${summary.length} chars`);
  }

  pi.on("session_shutdown", async (_event, ctx) => {
    await capture(ctx as SessionCtx);
  });

  pi.on("session_before_switch", async (_event, ctx) => {
    await capture(ctx as SessionCtx);
  });

  pi.on("session_before_fork", async (_event, ctx) => {
    await capture(ctx as SessionCtx);
  });

  pi.on("session_before_compact", async (_event, ctx) => {
    await capture(ctx as SessionCtx);
  });

  pi.registerCommand("shodh-status", {
    description: "Check Shodh memory server health",
    handler: async (_args, ctx) => {
      try {
        const res = await fetch(`${apiUrl()}/health`, {
          signal: AbortSignal.timeout(AUTH_TIMEOUT_MS),
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
