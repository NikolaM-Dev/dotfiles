/**
 * pi-working — one-line working status above the input.
 *
 * No commands. Minimal. Shows the live phase while the agent runs
 * and keeps the last run visible when idle, so background runs
 * are not lost when you look back.
 *
 * Layout (single line, widget above editor):
 *   active: <icon> Running bash (+1.2k · 1 file · 47s)
 *   idle:   ✓ Done in 47s · +1.2k · 3 tools · 2 files · 2:32 PM
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

const USE_NERD = true;

const ICON = {
  requesting: USE_NERD ? " " : "",
  thinking: USE_NERD ? " " : "",
  responding: USE_NERD ? " " : "",
  "tool-use": USE_NERD ? " " : "",
  waiting: USE_NERD ? " " : "",
  compacting: USE_NERD ? "󰆼 " : "",
} as const;

type Phase = "requesting" | "thinking" | "responding" | "tool-use" | "waiting" | "compacting";

interface LastRun {
  durationMs: number;
  tokens: number;
  tools: number;
  files: number;
  errors: number;
  at: number;
  clock: string;
}

const state = {
  active: false,
  phase: "requesting" as Phase,
  startedAt: 0,
  lastProgressAt: 0,
  outputTokens: 0,
  toolTotal: 0,
  files: new Set<string>(),
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
    return new Date(at).toLocaleTimeString([], {
      hour: "numeric",
      minute: "2-digit",
      hourCycle: "h12",
    });
  } catch {
    return "";
  }
}

function capitalize(text: string): string {
  return text.length > 0 ? text[0]!.toUpperCase() + text.slice(1) : text;
}

type SegmenterInstance = {
  segment(_s: string): Iterable<{ segment: string }>;
};

let cachedSegmenter: SegmenterInstance | null | undefined;

function splitGraphemes(text: string): string[] {
  if (cachedSegmenter === undefined) {
    const Segmenter = (
      Intl as unknown as {
        Segmenter?: new (_l: unknown, _o: unknown) => SegmenterInstance;
      }
    ).Segmenter;
    cachedSegmenter =
      typeof Segmenter === "function"
        ? new Segmenter(undefined, { granularity: "grapheme" })
        : null;
  }
  if (cachedSegmenter) {
    return [...cachedSegmenter.segment(text)].map((part) => part.segment);
  }
  return Array.from(text);
}

// Traveling highlight band over icon + activity. Dim base with fg (text)
// highlight, warning tones when stalled.
function renderShimmer(t: Theme, text: string, tick: number, stalled: boolean): string {
  const graphemes = splitGraphemes(text);
  const widths = graphemes.map((g) => Math.max(1, visibleWidth(g)));
  const total = widths.reduce((a, b) => a + b, 0);
  const edge = 6;
  const travel = total + edge * 2;
  const center = (tick % Math.max(1, travel)) - edge;
  let cursor = 0;
  const highlight = stalled ? "warning" : "text";
  return graphemes
    .map((g, i) => {
      const start = cursor;
      cursor += widths[i]!;
      // Uniform 3-wide band: center cell + 2 trailing cells share one style.
      if (cursor > center - 1 && start < center + 2) return t.bold(t.fg(highlight as never, g));
      return t.bold(t.fg("dim" as never, g));
    })
    .join("");
}

function cleanToolName(name: string): string {
  return (
    name
      .replace(/[\x00-\x1f\x7f]/g, "")
      .trim()
      .slice(0, 24) || "tool"
  );
}

// Single source for icon + text so they can never drift apart.
function currentActivity(): { icon: string; text: string } {
  if (state.waiting > 0) return { icon: ICON.waiting, text: "waiting for you" };
  if (state.compacting) return { icon: ICON.compacting, text: "compacting" };
  if (state.phase === "tool-use") {
    const count = state.tools.size;
    if (count === 0) return { icon: ICON["tool-use"], text: "running tools" };
    const first = state.tools.values().next().value as string;
    if (count === 1) return { icon: ICON["tool-use"], text: `running ${first}` };
    return { icon: ICON["tool-use"], text: `running ${first} +${count - 1}` };
  }
  if (state.phase === "thinking") return { icon: ICON.thinking, text: "thinking" };
  if (state.phase === "responding") return { icon: ICON.responding, text: "writing" };
  return { icon: ICON.requesting, text: "requesting" };
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
      const icon = t.fg((ok ? "success" : "warning") as never, " ");
      const head = t.fg("muted" as never, `Done in ${formatElapsed(l.durationMs)}`);
      const parts: string[] = [head];
      if (l.tokens > 0) parts.push(t.fg("dim" as never, `+${formatTokens(l.tokens)}`));
      if (l.tools > 0)
        parts.push(t.fg("dim" as never, `${l.tools} tool${l.tools === 1 ? "" : "s"}`));
      if (l.files > 0)
        parts.push(t.fg("dim" as never, `${l.files} file${l.files === 1 ? "" : "s"}`));
      if (l.errors > 0)
        parts.push(t.fg("error" as never, `${l.errors} error${l.errors === 1 ? "" : "s"}`));
      if (l.clock) parts.push(t.fg("dim" as never, l.clock));
      const line = icon + parts.join(t.fg("dim" as never, " · "));
      if (visibleWidth(line) <= w) return [line];
      return [truncateToWidth(line, w, t.fg("dim" as never, "…"))];
    }

    // active: shimmering "<icon> <Activity>" plus dim details
    const tNow = now();
    const elapsed = tNow - state.startedAt;
    const tick = Math.floor(elapsed / TICK_MS);
    const stalled = tNow - state.lastProgressAt > STALL_MS && state.waiting === 0;
    const { icon, text } = currentActivity();
    const activity = renderShimmer(t, `${icon}${capitalize(text)}`, tick, stalled);

    const details: string[] = [];
    if (state.outputTokens > 0) details.push(`+${formatTokens(state.outputTokens)}`);
    if (state.files.size > 0)
      details.push(`${state.files.size} file${state.files.size === 1 ? "" : "s"}`);
    const elapsedTone = elapsed >= ELAPSED_WARN_MS ? "warning" : "dim";
    details.push(formatElapsed(elapsed));
    const detailStr =
      t.fg("dim" as never, " (") +
      details.map((d) => t.fg(elapsedTone as never, d)).join(t.fg("dim" as never, " · ")) +
      t.fg("dim" as never, ")");

    const line = activity + detailStr;
    if (visibleWidth(line) <= w) return [line];
    return [truncateToWidth(line, w, t.fg("dim" as never, "\u2026"))];
  };

  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    disposed = false;

    // Hide the built-in working row inside the editor top border.
    // pi-working replaces it with the widget above the input.
    ctx.ui.setWorkingVisible(false);

    ctx.ui.setWidget(WIDGET_KEY, ((tui: unknown, theme: unknown) => {
      const tuiTyped = tui as { requestRender: () => void };
      stopTimer();
      timer = setInterval(() => {
        if (disposed) return;
        // Idle line is static (clock cached at settle) — only animate while active.
        if (!state.active) return;
        tuiTyped.requestRender();
      }, TICK_MS);

      return {
        dispose() {
          stopTimer();
        },
        invalidate() { },
        render(width: number): string[] {
          return renderLine(theme as Theme, width);
        },
      };
    }) as never);
  });

  pi.on("session_shutdown", async (_event, ctx) => {
    disposed = true;
    stopTimer();
    if (ctx.mode === "tui") ctx.ui.setWorkingVisible(true);
  });

  pi.on("agent_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    const t = now();
    state.active = true;
    state.phase = "requesting";
    state.startedAt = t;
    state.lastProgressAt = t;
    state.outputTokens = 0;
    state.toolTotal = 0;
    state.files.clear();
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
    else if (type === "text_start" || type === "text_delta" || type === "text_end")
      state.phase = "responding";
    else if (type === "toolcall_start" || type === "toolcall_delta") state.phase = "tool-use";
    state.lastProgressAt = now();
  });

  pi.on("tool_execution_start", async (event: unknown, ctx) => {
    if (!state.active || ctx.mode !== "tui") return;
    const e = event as { toolCallId: string; toolName: string; args?: { path?: unknown } };
    state.tools.set(e.toolCallId, cleanToolName(e.toolName));
    state.toolTotal += 1;
    if ((e.toolName === "edit" || e.toolName === "write") && typeof e.args?.path === "string") {
      state.files.add(e.args.path);
    }
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
    on(
      event: "ui_prompt_start" | "ui_prompt_end",
      handler: (event: unknown, ctx: never) => void,
    ): void;
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
      files: state.files.size,
      errors: state.errorTotal,
      at: t,
      clock: formatClock(t),
    };
    state.active = false;
    state.tools.clear();
    state.waiting = 0;
    state.compacting = false;
  });
}
