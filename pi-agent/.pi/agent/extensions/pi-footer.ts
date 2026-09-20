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
	dirty: USE_NERD ? "󱀲 " : "*",
	conflict: USE_NERD ? " " : "!",
	added: USE_NERD ? " " : "+",
	removed: USE_NERD ? " " : "-",
	modified: USE_NERD ? " " : "~",
	untracked: USE_NERD ? " " : "?",
	stashed: USE_NERD ? " " : "s",
	model: USE_NERD ? "󰚩 " : "ai ",
	effort: USE_NERD ? " " : "",
	context: USE_NERD ? "󰅺 " : "ctx ",
	tokens: USE_NERD ? "󰄨 " : "tok ",
	// cost: USE_NERD ? "󰈸 " : "$",
	cost: USE_NERD ? "" : "$",
	cacheRead: USE_NERD ? "󰃨 " : "",
	cacheHit: USE_NERD ? "󰓾 " : "",
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
	return text
		.replace(/[\r\n\t]/g, " ")
		.replace(/ +/g, " ")
		.trim();
}

function thinkingToken(level: string): string {
	switch (level) {
		case "minimal":
			return "thinkingMinimal";
		case "low":
			return "thinkingLow";
		case "medium":
			return "thinkingMedium";
		case "high":
			return "thinkingHigh";
		case "xhigh":
			return "thinkingXhigh";
		case "max":
			return "thinkingMax";
		default:
			return "thinkingOff";
	}
}

// Highest effort level a model supports, mirroring pi core
// getSupportedThinkingLevels (null = unsupported, xhigh/max need an
// explicit non-null map entry). Undefined when the model has no reasoning.
const EFFORT_ORDER = ["minimal", "low", "medium", "high", "xhigh", "max"] as const;

function maxEffortFor(model: unknown): string | undefined {
	const m = model as
		| {
			reasoning?: boolean;
			thinkingLevelMap?: Record<string, string | null | undefined>;
		}
		| undefined;
	if (!m?.reasoning) return undefined;
	const supported = EFFORT_ORDER.filter((level) => {
		const mapped = m.thinkingLevelMap?.[level];
		if (mapped === null) return false;
		if ((level === "xhigh" || level === "max") && mapped === undefined) return false;
		return true;
	});
	return supported[supported.length - 1];
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
	ahead: 0,
	behind: 0,
	staged: 0,
	modified: 0,
	untracked: 0,
	conflict: 0,
	additions: 0,
	deletions: 0,
	stashed: 0,
	ok: false,
};

function run(cmd: string, args: string[], cwd: string): Promise<string> {
	return new Promise((resolvePromise) => {
		execFile(cmd, args, { cwd, timeout: 3000, maxBuffer: 1024 * 1024 }, (err, stdout) => {
			resolvePromise(err ? "" : stdout);
		});
	});
}

async function pollGit(cwd: string): Promise<GitStats> {
	const status = await run(
		"git",
		[
			"-c",
			"core.quotepath=off",
			"status",
			"--porcelain=v1",
			"--branch",
			"--untracked-files=normal",
		],
		cwd,
	);
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
		if (x === "?" && y === "?") {
			stats.untracked++;
			continue;
		}
		if (
			(x === "U" && y === "U") ||
			(x === "A" && y === "A") ||
			(x === "D" && y === "D") ||
			(x === "A" && y === "U") ||
			(x === "U" && y === "A") ||
			(x === "D" && y === "U") ||
			(x === "U" && y === "D")
		) {
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

interface Totals {
	input: number;
	output: number;
	cacheRead: number;
	cacheWrite: number;
	cost: number;
}

interface SessionStats {
	totals: Totals;
	cacheHitRate: number | undefined;
}

// single pass over session entries: usage totals plus the last assistant
// message's cache-hit rate (mirrors default footer R/CH)
function computeSessionStats(entries: readonly unknown[]): SessionStats {
	const totals: Totals = { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 };
	let cacheHitRate: number | undefined;
	for (const e of entries as Array<{
		type?: string;
		message?: {
			role?: string;
			usage?: {
				input?: number;
				output?: number;
				cacheRead?: number;
				cacheWrite?: number;
				cost?: { total?: number };
			};
		};
		usage?: {
			input?: number;
			output?: number;
			cacheRead?: number;
			cacheWrite?: number;
			cost?: { total?: number };
		};
	}>) {
		const u = e.type === "message" ? e.message?.usage : undefined;
		const u2 = e.type === "branch_summary" || e.type === "compaction" ? e.usage : undefined;
		const usage = u ?? u2;
		if (usage) {
			totals.input += usage.input ?? 0;
			totals.output += usage.output ?? 0;
			totals.cacheRead += usage.cacheRead ?? 0;
			totals.cacheWrite += usage.cacheWrite ?? 0;
			totals.cost += usage.cost?.total ?? 0;
		}
		if (e.type === "message" && e.message?.role === "assistant" && e.message.usage) {
			const au = e.message.usage;
			const promptTokens = (au.input ?? 0) + (au.cacheRead ?? 0) + (au.cacheWrite ?? 0);
			cacheHitRate = promptTokens > 0 ? ((au.cacheRead ?? 0) / promptTokens) * 100 : undefined;
		}
	}
	return { totals, cacheHitRate };
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
			let cachedEntries: readonly unknown[] | undefined;
			let cachedEntriesLength = -1;
			let cachedLastEntry: unknown;
			let cachedStats: SessionStats = {
				totals: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 },
				cacheHitRate: undefined,
			};
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
			function voidTick(): void {
				void tick();
			}

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

					const cwdStyled = t.bold(t.fg("mdLink", `${ICON.folder}${cwd}`));
					let l1 = getCapabilities().hyperlinks
						? hyperlink(cwdStyled, pathToFileURL(rawCwd).href)
						: cwdStyled;
					if (branch) {
						l1 += ` ${t.bold(t.fg("customMessageLabel" as never, `${ICON.branch}${branch}`))}`;
						if (stats.ok && stats.ahead > 0)
							l1 += ` ${t.fg("warning" as never, `${ICON.ahead}${stats.ahead}`)}`;
						if (stats.ok && stats.behind > 0)
							l1 += ` ${t.fg("warning" as never, `${ICON.behind}${stats.behind}`)}`;
						// order: ahead/behind, conflict, dirty details, stash
						if (stats.ok && stats.conflict > 0) {
							l1 += ` ${t.fg("error" as never, `${ICON.conflict}${stats.conflict}`)}`;
						} else if (
							stats.ok &&
							(stats.staged > 0 || stats.modified > 0 || stats.untracked > 0)
						) {
							const files = stats.staged + stats.modified + stats.untracked;
							l1 += ` ${t.fg("muted" as never, `${ICON.dirty}${files}`)}`;
							if (stats.modified > 0)
								l1 += ` ${t.fg("syntaxType" as never, `${ICON.modified}${stats.modified}`)}`;
							if (stats.untracked > 0)
								l1 += ` ${t.fg("dim" as never, `${ICON.untracked}${stats.untracked}`)}`;
							if (stats.additions > 0)
								l1 += ` ${t.fg("toolDiffAdded" as never, `${ICON.added}${stats.additions}`)}`;
							if (stats.deletions > 0)
								l1 += ` ${t.fg("toolDiffRemoved" as never, `${ICON.removed}${stats.deletions}`)}`;
						}
						if (stats.ok && stats.stashed > 0)
							l1 += ` ${t.fg("muted" as never, `${ICON.stashed}${stats.stashed}`)}`;
					}
					if (sessionName) l1 += t.fg("dim", ` • ${sessionName}`);
					const line1 = truncateToWidth(l1, w, t.fg("dim", "..."));

					// ---- L2: stats left + model right ----
					// fixed segments with placeholders so the layout never jumps
					// entries change far less often than renders: recompute only when the log moves
					const entries = ctx.sessionManager.getEntries() as readonly unknown[];
					if (
						entries !== cachedEntries ||
						entries.length !== cachedEntriesLength ||
						entries[entries.length - 1] !== cachedLastEntry
					) {
						cachedEntries = entries;
						cachedEntriesLength = entries.length;
						cachedLastEntry = entries[entries.length - 1];
						cachedStats = computeSessionStats(entries);
					}
					const { totals, cacheHitRate } = cachedStats;

					const inputStr = totals.input > 0 ? formatTokens(totals.input) : "__k";
					const outputStr = totals.output > 0 ? formatTokens(totals.output) : "__k";
					const cacheReadStr = totals.cacheRead > 0 ? formatTokens(totals.cacheRead) : "__";
					const cacheHitStr =
						(totals.cacheRead > 0 || totals.cacheWrite > 0) && cacheHitRate !== undefined
							? `${cacheHitRate.toFixed(1)}%`
							: "__";
					const costStr = totals.cost > 0 ? `$${totals.cost.toFixed(3)}` : "$_.__";

					const usage = ctx.getContextUsage();
					const win =
						usage?.contextWindow ??
						(ctx.model as { contextWindow?: number } | undefined)?.contextWindow ??
						0;
					const pct = usage?.percent ?? null;
					const contextStr =
						pct === null || pct === undefined
							? "__/___"
							: `${pct.toFixed(1)}%/${formatTokens(win)}`;

					let statsLeft = t.fg(
						"dim",
						`${ICON.tokens}↑${inputStr} ↓${outputStr} ${ICON.cacheRead}${cacheReadStr} ${ICON.cacheHit}${cacheHitStr} ${ICON.cost}${costStr} ${ICON.context}${contextStr}`,
					);
					let statsLeftWidth = visibleWidth(statsLeft);
					if (statsLeftWidth > w) {
						statsLeft = truncateToWidth(statsLeft, w, "...");
						statsLeftWidth = visibleWidth(statsLeft);
					}
					const modelId = ctx.model?.id ?? "no-model";
					const provider = (ctx.model as { provider?: string } | undefined)?.provider;
					const thinking = ctx.thinkingLevel ?? "off";
					let rightSide = provider
						? `${ICON.model}${provider}/${modelId} ${ICON.effort}${thinking}`
						: `${ICON.model}${modelId} ${ICON.effort}${thinking}`;

					// color the effort icon + word with its level color (self-highlight),
					// bold when at the model's max available effort
					let rightColored = t.fg("muted" as never, rightSide);
					if (thinking !== "off" && rightSide.includes(thinking)) {
						const effortColored = t.fg(
							thinkingToken(thinking) as never,
							`${ICON.effort}${thinking}`,
						);
						const effortStyled =
							thinking === maxEffortFor(ctx.model) ? t.bold(effortColored) : effortColored;
						rightColored = t.fg(
							"muted" as never,
							rightSide.replace(`${ICON.effort}${thinking}`, effortStyled),
						);
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

					// ---- L3: extension statuses, always rendered (no jumps), right-aligned ----
					const statuses = footerData.getExtensionStatuses();
					const text =
						statuses.size > 0
							? Array.from(statuses.entries())
								.sort((a: [string, string], b: [string, string]) => a[0].localeCompare(b[0]))
								.map(([, v]: [string, string]) => sanitize(v))
								.filter(Boolean)
								.join(" ")
							: "";
					if (text) {
						const statusLine = truncateToWidth(t.fg("dim", text), w, t.fg("dim", "..."));
						const pad = " ".repeat(Math.max(0, w - visibleWidth(statusLine)));
						lines.push(t.fg("dim", pad) + statusLine);
					} else {
						lines.push("");
					}
					return lines;
				},
			};
		});
	});
}
