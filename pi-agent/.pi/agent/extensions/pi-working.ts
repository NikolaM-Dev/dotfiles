/**
 * pi-working — one-line working status above the input.
 *
 * No commands. Minimal. Shows the live phase while the agent runs
 * and keeps the last run visible when idle, so background runs
 * are not lost when you look back.
 *
 * Layout (single line, widget above editor):
 *   active: <spinner> Working... running bash (47s · +1.2k)
 *   idle:   ✓ Done in 47s · +1.2k · 3 tools · 14:32
 *
 * Skips everything pi-footer already covers (git, cwd, session
 * totals, cost, context %, model). Cycle tokens and tool names only.
 */

import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const WIDGET_KEY = "pi-working";
const TICK_MS = 120;
const STALL_MS = 20_000;
const ELAPSED_WARN_MS = 5 * 60_000;

const SPINNER = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"] as const;

type Phase = "requesting" | "thinking" | "responding" | "tool-use" | "waiting" | "compacting";

interface LastRun {
  durationMs: number;
  tokens: number;
  tools: number;
  errors: number;
  at: number;
}

const state = {
  active: false,
  phase: "requesting" as Phase,
  verb: "Working",
  startedAt: 0,
  lastProgressAt: 0,
  outputTokens: 0,
  toolTotal: 0,
  errorTotal: 0,
  tools: new Map<string, string>(),
  waiting: 0,
  compacting: false,
  last: undefined as LastRun | undefined,
};

let timer: ReturnType<typeof setInterval> | undefined;
let disposed = false;

function now(): number {
  return Date.now();
}

function formatTokens(n: number): string {
  if (n < 1000) return `${n}`;
  if (n < 10000) return `${(n / 1000).toFixed(1)}k`;
  if (n < 1000000) return `${Math.round(n / 1000)}k`;
  return `${(n / 1000000).toFixed(1)}M`;
}

function formatElapsed(ms: number): string {
  const s = Math.max(0, Math.floor(ms / 1000));
  if (s < 60) return `${s}s`;
  const m = Math.floor(s / 60);
  const rest = s % 60;
  if (m < 60) return `${m}m ${String(rest).padStart(2, "0")}s`;
  const h = Math.floor(m / 60);
  return `${h}h ${String(m % 60).padStart(2, "0")}m`;
}

function formatClock(at: number): string {
  try {
    return new Date(at).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
  } catch {
    return "";
  }
}

function cleanToolName(name: string): string {
  return name.replace(/[\x00-\x1f\x7f]/g, "").trim().slice(0, 24) || "tool";
}

function activityText(): string {
  if (state.waiting > 0) return "waiting for you";
  if (state.compacting) return "compacting";
  if (state.phase === "tool-use") {
    const names = [...state.tools.values()];
    if (names.length === 1) return `running ${names[0]}`;
    if (names.length > 1) return `running ${names[0]} +${names.length - 1}`;
    return "running tools";
  }
  if (state.phase === "thinking") return "thinking";
  if (state.phase === "responding") return "writing";
  return "thinking";
}

function stopTimer(): void {
  if (timer !== undefined) {
    clearInterval(timer);
    timer = undefined;
  }
}

export default function (pi: ExtensionAPI) {
  const renderLine = (t: Theme, width: number): string[] => {
    const w = Math.max(1, width);

    if (!state.active && !state.last) return [];

    if (!state.active && state.last) {
      const l = state.last;
      const ok = l.errors === 0;
      const icon = t.fg((ok ? "success" : "warning") as never, ok ? "✓ " : "✓ ");
      const head = t.fg("muted" as never, `Done in ${formatElapsed(l.durationMs)}`);
      const parts: string[] = [head];
      if (l.tokens > 0) parts.push(t.fg("dim" as never, `+${formatTokens(l.tokens)}`));
      if (l.tools > 0) parts.push(t.fg("dim" as never, `${l.tools} tool${l.tools === 1 ? "" : "s"}`));
      if (l.errors > 0) parts.push(t.fg("error" as never, `${l.errors} error${l.errors === 1 ? "" : "s"}`));
      const clock = formatClock(l.at);
      if (clock) parts.push(t.fg("dim" as never, clock));
      const line = icon + parts.join(t.fg("dim" as never, " · "));
      if (visibleWidth(line) <= w) return [line];
      return [truncateToWidth(line, w, t.fg("dim" as never, "…"))];
    }

    // active
    const elapsed = now() - state.startedAt;
    const frame = SPINNER[Math.floor(elapsed / TICK_MS) % SPINNER.length]!;
    const stalled = now() - state.lastProgressAt > STALL_MS && state.waiting === 0;
    const spinner = t.fg((stalled ? "warning" : "accent") as never, `${frame} `);
    const verb = t.bold(t.fg("text" as never, `${state.verb}… `));
    const activity = t.fg("dim" as never, activityText());

    const details: string[] = [];
    if (state.outputTokens > 0) details.push(`+${formatTokens(state.outputTokens)}`);
    const elapsedTone = elapsed >= ELAPSED_WARN_MS ? "warning" : "dim";
    details.push(formatElapsed(elapsed));
    const detailStr = t.fg("dim" as never, " (") + details.map((d) => t.fg(elapsedTone as never, d)).join(t.fg("dim" as never, " · ")) + t.fg("dim" as never, ")");

    const line = spinner + verb + activity + detailStr;
    if (visibleWidth(line) <= w) return [line];

    // narrow: drop verb, keep activity + elapsed
    const compact = spinner + activity + detailStr;
    if (visibleWidth(compact) <= w) return [compact];
    return [truncateToWidth(compact, w, t.fg("dim" as never, "…"))];
  };

  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    disposed = false;

    ctx.ui.setWidget(
      WIDGET_KEY,
      ((tui: unknown, theme: unknown) => {
        const tuiTyped = tui as { requestRender: () => void };
        stopTimer();
        timer = setInterval(() => {
          if (disposed) return;
          // only tick while something is visible
          if (!state.active && !state.last) return;
          tuiTyped.requestRender();
        }, TICK_MS);

        return {
          dispose() {
            stopTimer();
          },
          invalidate() {},
          render(width: number): string[] {
            return renderLine(theme as Theme, width);
          },
        };
      }) as never,
    );
  });

  pi.on("session_shutdown", async () => {
    disposed = true;
    stopTimer();
  });

  pi.on("agent_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    const t = now();
    state.active = true;
    state.phase = "requesting";
    state.verb = "Working";
    state.startedAt = t;
    state.lastProgressAt = t;
    state.outputTokens = 0;
    state.toolTotal = 0;
    state.errorTotal = 0;
    state.tools.clear();
    state.waiting = 0;
    state.compacting = false;
  });

  pi.on("turn_start", async (_event, ctx) => {
    if (!state.active || ctx.mode !== "tui") return;
    if (state.tools.size === 0 && state.waiting === 0) state.phase = "requesting";
    state.lastProgressAt = now();
  });

  pi.on("message_update", async (event: unknown, ctx) => {
    if (!state.active || ctx.mode !== "tui") return;
    const e = event as { assistantMessageEvent?: { type?: string } };
    const type = e.assistantMessageEvent?.type ?? "";
    if (type === "thinking_start" || type === "thinking_delta") state.phase = "thinking";
    else if (type === "text_start" || type === "text_delta" || type === "text_end") state.phase = "responding";
    else if (type === "toolcall_start" || type === "toolcall_delta") state.phase = "tool-use";
    state.lastProgressAt = now();
  });

  pi.on("tool_execution_start", async (event: unknown, ctx) => {
    if (!state.active || ctx.mode !== "tui") return;
    const e = event as { toolCallId: string; toolName: string };
    state.tools.set(e.toolCallId, cleanToolName(e.toolName));
    state.toolTotal += 1;
    state.phase = "tool-use";
    state.lastProgressAt = now();
  });

  pi.on("tool_execution_end", async (event: unknown, ctx) => {
    if (ctx.mode !== "tui") return;
    const e = event as { toolCallId: string; isError?: boolean };
    state.tools.delete(e.toolCallId);
    if (e.isError) state.errorTotal += 1;
    if (!state.active) return;
    if (state.tools.size === 0 && state.waiting === 0) state.phase = "requesting";
    state.lastProgressAt = now();
  });

  pi.on("message_end", async (event: unknown, ctx) => {
    if (ctx.mode !== "tui") return;
    const e = event as { message?: { role?: string; usage?: { output?: number } } };
    if (e.message?.role === "assistant" && typeof e.message.usage?.output === "number") {
      state.outputTokens += Math.max(0, Math.floor(e.message.usage.output));
    }
    if (state.active) state.lastProgressAt = now();
  });

  // ui_prompt_start/end only exist on newer Pi; subscribe loosely.
  const promptEvents = pi as unknown as {
    on(event: "ui_prompt_start" | "ui_prompt_end", handler: (event: unknown, ctx: never) => void): void;
  };
  promptEvents.on("ui_prompt_start", (() => {
    if (!state.active) return;
    state.waiting += 1;
    state.phase = "waiting";
    state.lastProgressAt = now();
  }) as never);
  promptEvents.on("ui_prompt_end", (() => {
    if (!state.active) return;
    state.waiting = Math.max(0, state.waiting - 1);
    if (state.waiting === 0) state.phase = state.tools.size > 0 ? "tool-use" : "requesting";
    state.lastProgressAt = now();
  }) as never);

  pi.on("session_before_compact", async () => {
    if (!state.active) return;
    state.compacting = true;
    state.phase = "compacting";
  });

  pi.on("agent_settled", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    if (!state.active) return;
    const t = now();
    state.last = {
      durationMs: Math.max(0, t - state.startedAt),
      tokens: state.outputTokens,
      tools: state.toolTotal,
      errors: state.errorTotal,
      at: t,
    };
    state.active = false;
    state.tools.clear();
    state.waiting = 0;
    state.compacting = false;
  });
}
