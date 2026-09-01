/**
 * Pi Notify Extension — cwd as title + contextual body
 *
 * Title: compact cwd (~/... with ellipsis for long paths)
 * Body:  short summary of what the agent just did (assistant snippet + tool stats)
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { existsSync } from "node:fs";
import { homedir } from "node:os";
import { basename, join } from "node:path";

// ── sanitizers / formatters ─────────────────────────────────────────────

function sanitizeOSC(s: string): string {
  return s.replace(/[\x00-\x1f\x7f;]/g, " ").replace(/\s+/g, " ").trim();
}

function sanitizeNotifySend(s: string): string {
  return s.replace(/\0/g, "").trim();
}

function formatCwdTitle(cwd: string): string {
  if (!cwd) return "Pi";
  const home = homedir();
  let display = cwd;
  if (home && cwd === home) display = "~";
  else if (home && cwd.startsWith(home + "/")) display = "~" + cwd.slice(home.length);

  // Ellipsize very long paths but keep last 2 segments visible.
  const MAX = 48;
  if (display.length <= MAX) return display;
  const parts = display.split("/");
  // keep ~/ or leading empty
  if (parts.length <= 3) return display.slice(0, MAX - 1) + "…";
  const tail = parts.slice(-2).join("/");
  const head = parts[0] === "~" ? "~" : parts[0] || "/";
  const compact = `${head}/…/${tail}`;
  return compact.length <= MAX ? compact : `…/${tail}`;
}

function extractTextBlocks(content: unknown): string[] {
  if (typeof content === "string") return content.trim() ? [content.trim()] : [];
  if (!Array.isArray(content)) return [];
  const out: string[] = [];
  for (const p of content as Array<Record<string, unknown>>) {
    if (!p || typeof p !== "object") continue;
    if (p.type === "text" && typeof p.text === "string" && p.text.trim()) out.push(p.text as string);
  }
  return out;
}

function extractToolStats(content: unknown): { calls: number; names: string[] } {
  if (!Array.isArray(content)) return { calls: 0, names: [] };
  const names: string[] = [];
  for (const p of content as Array<Record<string, unknown>>) {
    if (p?.type === "toolCall" && typeof p.name === "string") names.push(p.name as string);
  }
  return { calls: names.length, names };
}

function firstSentence(text: string, maxLen = 140): string {
  let t = text
    .replace(/^#+\s*/gm, "") // headings
    .replace(/[*_`~]+/g, "") // markdown inline
    .replace(/\s+/g, " ")
    .trim();
  if (!t) return "";
  // Prefer first sentence if reasonably short
  const m = t.match(/^(.{20,}?[.!?])\s/);
  if (m && m[1].length < maxLen) t = m[1];
  if (t.length > maxLen) t = t.slice(0, maxLen - 1).trim() + "…";
  return t;
}

function buildBody(ctx: Parameters<Parameters<ExtensionAPI["on"]>[1]>[1]): string {
  try {
    const entries = ctx.sessionManager.buildContextEntries();
    if (entries.length === 0) return "Ready for input";

    // Find last user index to scope recent activity
    let lastUserIdx = -1;
    for (let i = entries.length - 1; i >= 0; i--) {
      const e = entries[i] as { type: string; message?: { role?: string } };
      if (e.type === "message" && e.message?.role === "user") {
        lastUserIdx = i;
        break;
      }
    }
    const recent = lastUserIdx >= 0 ? entries.slice(lastUserIdx) : entries.slice(-12);

    // Reverse-scan for last assistant text
    let assistantText = "";
    let toolNames: string[] = [];
    let totalCalls = 0;
    let errorCount = 0;

    for (let i = recent.length - 1; i >= 0; i--) {
      const e = recent[i] as {
        type: string;
        message?: { role?: string; content?: unknown; isError?: boolean };
      };
      if (e.type !== "message" || !e.message) continue;
      const { role, content, isError } = e.message;
      if (role === "assistant") {
        const texts = extractTextBlocks(content);
        if (!assistantText && texts.length > 0) {
          // join paragraphs, take first meaningful
          const joined = texts.join("\n\n").trim();
          assistantText = firstSentence(joined);
        }
        const st = extractToolStats(content);
        totalCalls += st.calls;
        toolNames.push(...st.names);
      } else if (role === "toolResult" || (role as string) === "tool_result") {
        if (isError) errorCount++;
      }
    }

    // Also count toolResult entries explicitly if available (broader scan)
    if (errorCount === 0) {
      for (const e of recent) {
        const m = (e as { message?: { role?: string; isError?: boolean } }).message;
        if (m?.role === "toolResult" && m.isError) errorCount++;
      }
    }

    const parts: string[] = [];

    // Error / success prefix
    if (errorCount > 0) parts.push(` ${errorCount} error${errorCount > 1 ? "s" : ""}`);
    else if (totalCalls > 0) parts.push(`󰗠 ${totalCalls} tool${totalCalls > 1 ? "s" : ""}`);

    //compact tool breakdown e.g. "2 edits · 1 bash"
    if (toolNames.length > 0) {
      const counts = new Map<string, number>();
      for (const n of toolNames) counts.set(n, (counts.get(n) ?? 0) + 1);
      const summary = [...counts.entries()]
        .map(([k, v]) => (v > 1 ? `${v} ${k}` : k))
        .slice(0, 3)
        .join(" · ");
      if (summary) {
        // avoid duplicating raw counts already in prefix - keep as detail
        if (parts.length === 0) parts.push(summary);
        else parts[parts.length - 1] += ` · ${summary}`;
      }
    }

    if (assistantText) {
      if (parts.length > 0) return `${parts.join(" — ")} — ${assistantText}`;
      return assistantText;
    }

    if (parts.length > 0) return `${parts.join(" — ")} — Ready for input`;

    return "Ready for input — awaiting your next prompt";
  } catch {
    return "Ready for input";
  }
}

// ── notifiers ───────────────────────────────────────────────────────────

function windowsToastScript(title: string, body: string): string {
  const type = "Windows.UI.Notifications";
  const mgr = `[${type}.ToastNotificationManager, ${type}, ContentType = WindowsRuntime]`;
  const template = `[${type}.ToastTemplateType]::ToastText01`;
  const toast = `[${type}.ToastNotification]::new($xml)`;
  // Escape single quotes for PowerShell
  const esc = (s: string) => s.replace(/'/g, "''");
  return [
    `${mgr} > $null`,
    `$xml = [${type}.ToastNotificationManager]::GetTemplateContent(${template})`,
    `$xml.GetElementsByTagName('text')[0].AppendChild($xml.CreateTextNode('${esc(body)}')) > $null`,
    `[${type}.ToastNotificationManager]::CreateToastNotifier('${esc(title)}').Show(${toast})`,
  ].join("; ");
}

function notifyOSC777(title: string, body: string): void {
  process.stdout.write(`\x1b]777;notify;${sanitizeOSC(title)};${sanitizeOSC(body)}\x07`);
}

function notifyOSC99(title: string, body: string): void {
  process.stdout.write(`\x1b]99;i=1:d=0;${sanitizeOSC(title)}\x1b\\`);
  process.stdout.write(`\x1b]99;i=1:p=body;${sanitizeOSC(body)}\x1b\\`);
}

function notifyWindows(title: string, body: string): void {
  const { execFile } = require("child_process");
  execFile("powershell.exe", ["-NoProfile", "-Command", windowsToastScript(title, body)]);
}

function notifyLinux(title: string, body: string): void {
  const { execFile } = require("child_process");
  execFile("notify-send", [sanitizeNotifySend(title), sanitizeNotifySend(body)], () => { });
}

const TUTURU_CANDIDATES = [
  join(homedir(), ".pi/agent/sounds/tuturu.wav"),
  join(homedir(), "dotfiles/pi-agent/.pi/agent/sounds/tuturu.wav"),
  join(homedir(), "Downloads/sounds_tuturu.wav"),
];

function getTuturuPath(): string | undefined {
  for (const p of TUTURU_CANDIDATES) if (existsSync(p)) return p;
  return undefined;
}

function playTuturu(): void {
  const soundPath = getTuturuPath();
  if (!soundPath) return;
  const { execFile } = require("child_process");
  const players: Array<[string, string[]]> = [
    ["paplay", [soundPath]],
    ["pw-play", [soundPath]],
    ["aplay", [soundPath]],
    ["ffplay", ["-nodisp", "-autoexit", "-loglevel", "quiet", soundPath]],
    ["mpv", ["--no-video", soundPath]],
  ];
  const tryPlayer = (idx: number) => {
    if (idx >= players.length) return;
    const [cmd, args] = players[idx];
    execFile(cmd, args, (err: unknown) => {
      if (err) tryPlayer(idx + 1);
    });
  };
  tryPlayer(0);
}

function notify(title: string, body: string): void {
  if (process.env.WT_SESSION) {
    notifyWindows(title, body);
  } else if (process.env.KITTY_WINDOW_ID) {
    notifyOSC99(title, body);
  } else {
    notifyOSC777(title, body);
  }
  if (process.platform === "linux") {
    notifyLinux(title, body);
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("agent_settled", async (_event, ctx) => {
    // Prefer ctx.cwd (live), fallback to session cwd / process.cwd()
    const rawCwd =
      (ctx.cwd as string | undefined) ??
      (ctx.sessionManager.getCwd() as string | undefined) ??
      process.cwd();

    const title = `  ${formatCwdTitle(rawCwd)}`;
    const body = buildBody(ctx as unknown as Parameters<Parameters<ExtensionAPI["on"]>[1]>[1]);

    notify(title, body);
    playTuturu();
  });
}
