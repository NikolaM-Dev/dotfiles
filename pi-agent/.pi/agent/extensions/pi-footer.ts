/**
 * pi-footer — personalized footer, v1.
 *
 * Same 3-line layout as the default pi footer, no editor, no interactivity:
 *   L1: cwd + git (gitmux/tmux style)
 *   L2: stats left, model right (right-aligned)
 *   L3: extension statuses (single dim line, truncated)
 *
 * Ideas taken from pi-glance: quiet by default (clean git = branch only,
 * hide zero cost, hide thinking-off, provider only when >1), context
 * thresholds 70/85. Colors follow the tmux status line, mapped onto the
 * active pi theme so `cendre` hot-reload keeps working. Nerd Font icons.
 */

import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { basename, resolve } from "node:path";
import { pathToFileURL } from "node:url";
import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";
import { getCapabilities, hyperlink, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

// ---------------------------------------------------------------------------
// config (v1: constants, no settings pane)
// ---------------------------------------------------------------------------

const POLL_MS = 5000;
const USE_NERD = true;

const ICON = {
	folder: USE_NERD ? " " : "",
	branch: USE_NERD ? " " : "",
	ahead: USE_NERD ? " " : "↑",
	behind: USE_NERD ? " " : "↓",
	dirty: USE_NERD ? "●" : "*",
	conflict: USE_NERD ? "⚠" : "!",
	added: USE_NERD ? " " : "+",
	removed: USE_NERD ? " " : "-",
	modified: USE_NERD ? " " : "~",
	untracked: USE_NERD ? " " : "?",
	stashed: USE_NERD ? " " : "s",
	model: USE_NERD ? "󰚩 " : "ai ",
	context: USE_NERD ? "󰍛 " : "ctx ",
	tokens: USE_NERD ? "󰄨 " : "tok ",
	cost: USE_NERD ? "󰈸 " : "$",
} as const;

// ---------------------------------------------------------------------------
// helpers (same semantics as default footer)
// ---------------------------------------------------------------------------

function formatTokens(count: number): string {
	if (count < 1000) return `${count}`;
	if (count < 10000) return `${(count / 1000).toFixed(1)}k`;
	if (count < 1000000) return `${Math.round(count / 1000)}k`;
	if (count < 10000000) return `${(count / 1000000).toFixed(1)}M`;
	return `${Math.round(count / 1000000)}M`;
}

function formatCwd(cwd: string): string {
	const normalized = resolve(cwd);
	if (normalized === resolve(homedir())) return "~";
	return basename(normalized) || normalized;
}

function sanitize(text: string): string {
	return text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim();
}

function thinkingToken(level: string): string {
	switch (level) {
		case "minimal": return "thinkingMinimal";
		case "low": return "thinkingLow";
		case "medium": return "thinkingMedium";
		case "high": return "thinkingHigh";
		case "xhigh": return "thinkingXhigh";
		case "max": return "thinkingMax";
		default: return "thinkingOff";
	}
}

// ---------------------------------------------------------------------------
// git polling (branch comes free via footerData; stats need git)
// ---------------------------------------------------------------------------

interface GitStats {
	ahead: number;
	behind: number;
	staged: number;
	modified: number;
	untracked: number;
	conflict: number;
	additions: number;
	deletions: number;
	stashed: number;
	ok: boolean;
}

const EMPTY_STATS: GitStats = {
	ahead: 0, behind: 0, staged: 0, modified: 0,
	untracked: 0, conflict: 0, additions: 0, deletions: 0, stashed: 0, ok: false,
};

function run(cmd: string, args: string[], cwd: string): Promise<string> {
	return new Promise((resolvePromise) => {
		execFile(cmd, args, { cwd, timeout: 3000, maxBuffer: 1024 * 1024 }, (err, stdout) => {
			resolvePromise(err ? "" : stdout);
		});
	});
}

async function pollGit(cwd: string): Promise<GitStats> {
	const status = await run("git", ["-c", "core.quotepath=off", "status", "--porcelain=v1", "--branch", "--untracked-files=normal"], cwd);
	if (!status) return EMPTY_STATS;
	const stats: GitStats = { ...EMPTY_STATS, ok: true };
	for (const line of status.split("\n")) {
		if (line.startsWith("## ")) {
			const m = /\[ahead (\d+)(?:,.*)?\]/.exec(line);
			if (m) stats.ahead = Number(m[1]);
			const b = /\[.*behind (\d+).*\]/.exec(line);
			if (b) stats.behind = Number(b[1]);
			// "[ahead 2, behind 1]" handled: check both independently
			const a2 = /ahead (\d+)/.exec(line);
			if (a2) stats.ahead = Number(a2[1]);
			const b2 = /behind (\d+)/.exec(line);
			if (b2) stats.behind = Number(b2[1]);
			continue;
		}
		if (line.length < 2) continue;
		const x = line[0]!;
		const y = line[1]!;
		if (x === "?" && y === "?") { stats.untracked++; continue; }
		if ((x === "U" && y === "U") || (x === "A" && y === "A") || (x === "D" && y === "D") ||
			(x === "A" && y === "U") || (x === "U" && y === "A") || (x === "D" && y === "U") || (x === "U" && y === "D")) {
			stats.conflict++;
			continue;
		}
		if (x !== " " && x !== "?") stats.staged++;
		if (y === "M") stats.modified++;
	}
	// insertions/deletions (best effort, HEAD may not exist in fresh repos)
	const numstat = await run("git", ["diff", "HEAD", "--numstat"], cwd);
	if (numstat) {
		for (const line of numstat.split("\n")) {
			const parts = line.split("\t");
			if (parts.length < 2) continue;
			const a = Number(parts[0]);
			const d = Number(parts[1]);
			if (Number.isFinite(a)) stats.additions += a;
			if (Number.isFinite(d)) stats.deletions += d;
		}
	}
	const stash = await run("git", ["stash", "list", "--format=%gd"], cwd);
	if (stash.trim()) stats.stashed = stash.trim().split("\n").length;
	return stats;
}

// ---------------------------------------------------------------------------
// token totals (mirrors default footer: all entries, incl. tools/summaries)
// ---------------------------------------------------------------------------

interface Totals { input: number; output: number; cacheRead: number; cacheWrite: number; cost: number; }

function totalsOf(entries: readonly unknown[]): Totals {
	const t: Totals = { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 };
	for (const e of entries as Array<{
		type?: string;
		message?: { role?: string; usage?: { input: number; output: number; cacheRead: number; cacheWrite: number; cost: { total: number } } };
		usage?: { input: number; output: number; cacheRead: number; cacheWrite: number; cost: { total: number } };
	}>) {
		const u = e.type === "message" ? e.message?.usage : undefined;
		const u2 = (e.type === "branch_summary" || e.type === "compaction") ? e.usage : undefined;
		const usage = u ?? u2;
		if (!usage) continue;
		t.input += usage.input ?? 0;
		t.output += usage.output ?? 0;
		t.cacheRead += usage.cacheRead ?? 0;
		t.cacheWrite += usage.cacheWrite ?? 0;
		t.cost += usage.cost?.total ?? 0;
	}
	return t;
}

// ---------------------------------------------------------------------------
// extension
// ---------------------------------------------------------------------------

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;

		ctx.ui.setFooter((tui, theme, footerData) => {
			const t = theme as Theme;
			let stats: GitStats = EMPTY_STATS;
			let polling = false;
			let disposed = false;

			const unsubBranch = footerData.onBranchChange(() => tui.requestRender());

			const tick = async () => {
				if (disposed || polling) return;
				polling = true;
				try {
					const cwd = ctx.sessionManager.getCwd();
					const next = await pollGit(cwd);
					if (JSON.stringify(next) !== JSON.stringify(stats)) {
						stats = next;
						tui.requestRender();
					}
				} finally {
					polling = false;
				}
			};
			void tick();
			const timer = setInterval(voidTick, POLL_MS);
			function voidTick(): void { void tick(); }

			return {
				dispose() {
					disposed = true;
					clearInterval(timer);
					unsubBranch?.();
				},
				invalidate() {
					// colors resolve at render time -> theme hot-reload just works
				},
				render(width: number): string[] {
					const w = Math.max(1, width);

					// ---- L1: cwd + git ----
					const rawCwd = ctx.sessionManager.getCwd();
					const cwd = formatCwd(rawCwd);
					const branch = footerData.getGitBranch();
					const sessionName = ctx.sessionManager.getSessionName();

					const cwdStyled = t.fg("mdLink", `${ICON.folder}${cwd}`);
					let l1 = getCapabilities().hyperlinks
						? hyperlink(cwdStyled, pathToFileURL(rawCwd).href)
						: cwdStyled;
					if (branch) {
						l1 += ` ${t.bold(t.fg("customMessageLabel" as never, `${ICON.branch}${branch}`))}`;
						// conflict always shouts; dirty details only when dirty (glance rule)
						if (stats.ok && stats.conflict > 0) {
							l1 += ` ${t.fg("error" as never, `${ICON.conflict}${stats.conflict}`)}`;
						} else if (stats.ok && (stats.staged > 0 || stats.modified > 0 || stats.untracked > 0)) {
							const files = stats.staged + stats.modified + stats.untracked;
							l1 += ` ${t.fg("syntaxType" as never, `${ICON.dirty}${files}`)}`;
							if (stats.modified > 0) l1 += ` ${t.fg("syntaxType" as never, `${ICON.modified}${stats.modified}`)}`;
							if (stats.untracked > 0) l1 += ` ${t.fg("dim" as never, `${ICON.untracked}${stats.untracked}`)}`;
							if (stats.additions > 0) l1 += ` ${t.fg("toolDiffAdded" as never, `${ICON.added}+${stats.additions}`)}`;
							if (stats.deletions > 0) l1 += ` ${t.fg("toolDiffRemoved" as never, `${ICON.removed}−${stats.deletions}`)}`;
						}
						if (stats.ok && stats.ahead > 0) l1 += ` ${t.fg("warning" as never, `${ICON.ahead}${stats.ahead}`)}`;
						if (stats.ok && stats.behind > 0) l1 += ` ${t.fg("warning" as never, `${ICON.behind}${stats.behind}`)}`;
						if (stats.ok && stats.stashed > 0) l1 += ` ${t.fg("muted" as never, `${ICON.stashed}${stats.stashed}`)}`;
					}
					if (sessionName) l1 += t.fg("dim", ` • ${sessionName}`);
					const line1 = truncateToWidth(l1, w, t.fg("dim", "..."));

					// ---- L2: stats left + model right ----
					const totals = totalsOf(ctx.sessionManager.getEntries() as readonly unknown[]);
					const leftParts: string[] = [];
					if (totals.input > 0 || totals.output > 0) {
						leftParts.push(t.fg("dim", `${ICON.tokens}↑${formatTokens(totals.input)} ↓${formatTokens(totals.output)}`));
					}
					if (totals.cacheRead > 0) leftParts.push(t.fg("muted" as never, `R${formatTokens(totals.cacheRead)}`));
					if (totals.cacheWrite > 0) leftParts.push(t.fg("muted" as never, `W${formatTokens(totals.cacheWrite)}`));
					if (totals.cost > 0) leftParts.push(t.fg("dim", `${ICON.cost}$${totals.cost.toFixed(3)}`));

					const usage = ctx.getContextUsage();
					const win = usage?.contextWindow ?? (ctx.model as { contextWindow?: number } | undefined)?.contextWindow ?? 0;
					const pct = usage?.percent ?? null;
					if (pct === null || pct === undefined) {
						leftParts.push(t.fg("dim", `${ICON.context}?/${formatTokens(win)}`));
					} else {
						const label = `${ICON.context}${pct.toFixed(1)}%/${formatTokens(win)}`;
						if (pct >= 85) leftParts.push(t.fg("error" as never, label));
						else if (pct >= 70) leftParts.push(t.fg("warning" as never, label));
						else leftParts.push(t.fg("dim", label));
					}

					let statsLeft = leftParts.join(" ");
					let statsLeftWidth = visibleWidth(statsLeft);
					if (statsLeftWidth > w) {
						statsLeft = truncateToWidth(statsLeft, w, "...");
						statsLeftWidth = visibleWidth(statsLeft);
					}

					const modelId = ctx.model?.id ?? "no-model";
					let rightSide = `${ICON.model}${modelId}`;
					const thinking = ctx.thinkingLevel ?? "off";
					const modelReasoning = (ctx.model as { reasoning?: boolean } | undefined)?.reasoning ?? false;
					if (modelReasoning && thinking !== "off") {
						rightSide += ` • ${thinking}`;
					} else if (!modelReasoning && thinking !== "off") {
						rightSide += ` • ${thinking}`;
					}
					if ((footerData.getAvailableProviderCount?.() ?? 1) > 1 && ctx.model) {
						const withProvider = `(${(ctx.model as { provider?: string }).provider}) ${rightSide}`;
						if (statsLeftWidth + 2 + visibleWidth(withProvider) <= w) rightSide = withProvider;
					}

					// color the thinking word with its own level color (self-highlight)
					let rightColored = t.fg("muted" as never, rightSide);
					if (thinking !== "off" && rightSide.includes(thinking)) {
						rightColored = t.fg("muted" as never, rightSide.replace(thinking, t.fg(thinkingToken(thinking) as never, thinking)));
					}

					const rightWidth = visibleWidth(rightSide);
					let statsLine: string;
					const minPad = 2;
					if (statsLeftWidth + minPad + rightWidth <= w) {
						const pad = " ".repeat(w - statsLeftWidth - rightWidth);
						statsLine = statsLeft + t.fg("dim", pad) + rightColored;
					} else {
						const avail = w - statsLeftWidth - minPad;
						if (avail > 0) {
							const trunc = truncateToWidth(rightColored, avail, "");
							const truncW = visibleWidth(trunc);
							const pad = " ".repeat(Math.max(0, w - statsLeftWidth - truncW));
							statsLine = statsLeft + t.fg("dim", pad) + trunc;
						} else {
							statsLine = statsLeft;
						}
					}

					const lines = [line1, statsLine];

					// ---- L3: extension statuses, one dim line max (noise control) ----
					const statuses = footerData.getExtensionStatuses();
					if (statuses.size > 0) {
						const text = Array.from(statuses.entries())
							.sort((a: [string, string], b: [string, string]) => a[0].localeCompare(b[0]))
							.map(([, v]: [string, string]) => sanitize(v))
							.filter(Boolean)
							.join(" ");
						if (text) lines.push(truncateToWidth(t.fg("dim", text), w, t.fg("dim", "...")));
					}
					return lines;
				},
			};
		});
	});
}
