/**
 * pi-engram-session-end — close the Engram session on /quit and /new.
 *
 * gentle-engram already ends the Engram session on `session_shutdown`, but
 * only with an empty summary and only when its own startup succeeded. This
 * extension is an explicit, duplicate-safe guarantee: whenever you leave the
 * current Pi session via quit (/quit, /exit) or via session replacement
 * (/new, /resume, /fork), POST `/sessions/{id}/end` to the Engram server
 * best-effort so the session never stays open.
 *
 * - Hooks: `session_shutdown` (quit/new/resume/fork), `session_before_switch`
 *   (new/resume), and `input` (/quit, /exit, /new) as an eager fire-and-forget.
 * - Duplicate-safe: Engram's end endpoint is idempotent, plus we dedupe
 *   in-process so input + before_switch + shutdown don't triple-POST.
 * - Never blocks quit: short timeout, all errors swallowed to stderr.
 * - Ends both the Pi runtime session id and any gentle-engram effective
 *   session ids recorded on the branch (resume-chain aliases).
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const END_TIMEOUT_MS = 2500;

function engramBaseUrl(): string {
  const configured = process.env.ENGRAM_URL?.trim();
  if (configured) return configured.replace(/\/+$/, "");
  const port = Number.parseInt(process.env.ENGRAM_PORT?.trim() || "7437", 10) || 7437;
  return `http://127.0.0.1:${port}`;
}

// Sessions already ended in this process — avoids triple-POST when
// input + session_before_switch + session_shutdown all fire for one leave.
const ended = new Set<string>();
const inFlight = new Map<string, Promise<void>>();

async function endOne(sessionId: string): Promise<void> {
  if (!sessionId || ended.has(sessionId)) return;
  const ongoing = inFlight.get(sessionId);
  if (ongoing) {
    await ongoing;
    return;
  }
  const work = (async () => {
    try {
      const res = await fetch(`${engramBaseUrl()}/sessions/${encodeURIComponent(sessionId)}/end`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ summary: "" }),
        signal: AbortSignal.timeout(END_TIMEOUT_MS),
      });
      // 404/409 = already ended or unknown session — treat as done.
      if (res.ok || res.status === 404 || res.status === 409) {
        ended.add(sessionId);
      } else {
        process.stderr.write(`[pi-engram-session-end] end ${sessionId} -> HTTP ${res.status}\n`);
      }
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      try {
        process.stderr.write(`[pi-engram-session-end] end ${sessionId} failed: ${message}\n`);
      } catch {
        // Diagnostics must never break quit.
      }
    } finally {
      inFlight.delete(sessionId);
    }
  })();
  inFlight.set(sessionId, work);
  await work;
}

/** Pi runtime id + any gentle-engram effective-session aliases on the branch. */
function collectSessionIds(ctx: {
  sessionManager: {
    getSessionId?: () => string | undefined;
    getBranch?: () => Array<{ type?: string; customType?: string; data?: unknown }>;
  };
}): string[] {
  const ids: string[] = [];
  let runtimeID = "";
  try {
    runtimeID = ctx.sessionManager.getSessionId?.() || "";
  } catch {
    runtimeID = "";
  }
  if (runtimeID) ids.push(runtimeID);
  try {
    const branch = ctx.sessionManager.getBranch?.() || [];
    for (const entry of branch) {
      if (entry?.type !== "custom" || entry.customType !== "engram-effective-session") continue;
      const data = entry.data as { runtimeID?: string; effectiveID?: string } | undefined;
      if (
        typeof data?.effectiveID === "string" &&
        data.effectiveID &&
        data.effectiveID !== runtimeID &&
        (data.runtimeID === runtimeID || !data.runtimeID)
      ) {
        ids.push(data.effectiveID);
      }
    }
  } catch {
    // Branch read is best-effort; runtime id alone is enough.
  }
  return [...new Set(ids)];
}

async function endCurrentSession(
  ctx: Parameters<Parameters<ExtensionAPI["on"]>[1]>[1],
): Promise<void> {
  const ids = collectSessionIds(ctx as never);
  if (ids.length === 0) return;
  await Promise.all(ids.map((id) => endOne(id)));
}

const QUIT_NEW_INPUT = /^\/(quit|exit|q|new)(\s|$)/i;

export default function (pi: ExtensionAPI) {
  // Guaranteed hook: fires for quit, new, resume, fork (skip reload — the
  // runtime session stays alive across reloads).
  pi.on("session_shutdown", async (event, ctx) => {
    if (event.reason === "reload") return;
    await endCurrentSession(ctx);
  });

  // Earlier hook for /new and /resume: end before the switch starts.
  pi.on("session_before_switch", async (_event, ctx) => {
    await endCurrentSession(ctx);
  });

  // Eager signal for typed /quit, /exit, /new: fire-and-forget so the end
  // is already in flight before shutdown tears the runtime down.
  // Returning void (not "handled") lets the command run normally.
  pi.on("input", async (event, ctx) => {
    if (event.source !== "interactive" && event.source !== "rpc") return;
    if (!QUIT_NEW_INPUT.test(event.text.trim())) return;
    void endCurrentSession(ctx);
  });
}
