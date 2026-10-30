/**
 * Fancy Footer — a more colorful replacement for pi's built-in footer.
 *
 *  ❯ ~/path (branch) • session-name
 *  [██████░░░░░░░░] 74.5k/200k (37.2%)   model • high   in 1.2k out 340 cache 5.4k hit 82.3% $0.123
 *  <extension statuses set via ctx.ui.setStatus(), if any>
 *
 * - Enabled automatically on session start.
 * - `/fancy-footer` toggles it off (restores the default footer) / back on.
 * - Uses theme tokens, so it follows your active theme (dark/light).
 */
import { isAbsolute, relative, resolve, sep } from "node:path";
import type { ExtensionAPI, ExtensionContext, ThemeColor } from "@earendil-works/pi-coding-agent";
import type { Usage } from "@earendil-works/pi-ai";
import { truncateToWidth } from "@earendil-works/pi-tui";

const BAR_WIDTH = 14;
const LINE2_PAD = 1; // tiny left indent for the stats line

const THINKING_COLOR: Record<string, ThemeColor> = {
	off: "thinkingOff",
	minimal: "thinkingMinimal",
	low: "thinkingLow",
	medium: "thinkingMedium",
	high: "thinkingHigh",
	xhigh: "thinkingXhigh",
	max: "thinkingMax",
};

interface Totals {
	input: number;
	output: number;
	cacheRead: number;
	cacheWrite: number;
	cost: number;
	/** Cache-hit rate of the latest prompt, in percent. */
	cacheHit: number | undefined;
}

function fmt(n: number): string {
	if (n < 1000) return n.toString();
	if (n < 10_000) return `${(n / 1000).toFixed(1)}k`;
	if (n < 1_000_000) return `${Math.round(n / 1000)}k`;
	if (n < 10_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
	return `${Math.round(n / 1_000_000)}M`;
}

function shortCwd(cwd: string, home: string): string {
	if (!home) return cwd;
	const rel = relative(resolve(home), resolve(cwd));
	const inside = rel === "" || (rel !== ".." && !rel.startsWith(`..${sep}`) && !isAbsolute(rel));
	if (!inside) return cwd;
	return rel === "" ? "~" : `~${sep}${rel}`;
}

function sanitize(text: string): string {
	return text.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim();
}

export default function (pi: ExtensionAPI) {
	let active = true;

	const installFooter = (ctx: ExtensionContext) => {
		let cacheKey = "";
		let cacheTotals: Totals | undefined;

		// Cumulative usage over the whole session (same entries the default footer scans).
		const totals = (): Totals => {
			const sm = ctx.sessionManager;
			const key = `${sm.getSessionId()}:${sm.getLeafId()}:${sm.getEntryCount()}:${ctx.model?.id ?? ""}`;
			if (cacheKey === key && cacheTotals) return cacheTotals;

			const t: Totals = { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0, cacheHit: undefined };
			for (const entry of sm.getEntries()) {
				let usage: Usage | undefined;
				if (entry.type === "usage") usage = entry.usage;
				else if (entry.type === "message") {
					if (entry.message.role === "assistant" || entry.message.role === "toolResult") usage = entry.message.usage;
				} else if (entry.type === "branch_summary" || entry.type === "compaction") usage = entry.usage;
				if (!usage) continue;

				t.input += usage.input ?? 0;
				t.output += usage.output ?? 0;
				t.cacheRead += usage.cacheRead ?? 0;
				t.cacheWrite += usage.cacheWrite ?? 0;
				t.cost += usage.cost?.total ?? 0;

				if (entry.type === "message" && entry.message.role === "assistant") {
					const prompt = usage.input + usage.cacheRead + usage.cacheWrite;
					t.cacheHit = prompt > 0 ? (usage.cacheRead / prompt) * 100 : undefined;
				}
			}
			cacheKey = key;
			cacheTotals = t;
			return t;
		};

		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsubscribe = footerData.onBranchChange(() => tui.requestRender());

			const render = (width: number): string[] => {
				const sm = ctx.sessionManager;
				const home = process.env.HOME ?? process.env.USERPROFILE ?? "";
				const cwd = shortCwd(sm.getCwd(), home);
				const branch = footerData.getGitBranch();
				const sessionName = sm.getSessionName();

				// Line 1: path (branch) • session name
				const l1: string[] = [theme.fg("accent", "❯ "), theme.fg("muted", cwd)];
				if (branch) l1.push(`(${theme.fg("accent", branch)})`);
				if (sessionName) l1.push(`${theme.fg("dim", " • ")}${theme.fg("dim", sessionName)}`);
				const line1 = truncateToWidth(l1.join(""), width, theme.fg("dim", "…"));

				// Line 2: context bar + model first, labeled usage stats at the end
				const t = totals();
				const stats: string[] = [];
				if (t.input > 0) stats.push(`${theme.fg("dim", "in ")}${theme.fg("muted", fmt(t.input))}`);
				if (t.output > 0) stats.push(`${theme.fg("dim", "out ")}${theme.fg("muted", fmt(t.output))}`);
				if (t.cacheRead > 0 || t.cacheWrite > 0) {
					const read = t.cacheRead > 0 ? fmt(t.cacheRead) : "0";
					const written = t.cacheWrite > 0 ? theme.fg("dim", `+${fmt(t.cacheWrite)}w`) : "";
					stats.push(`${theme.fg("dim", "cache ")}${theme.fg("muted", read)}${written}`);
				}
				if (t.cacheHit !== undefined && (t.cacheRead > 0 || t.cacheWrite > 0))
					stats.push(`${theme.fg("dim", "hit ")}${theme.fg("muted", `${t.cacheHit.toFixed(1)}%`)}`);
				if (t.cost > 0) stats.push(theme.fg("muted", `$${t.cost.toFixed(3)}`));

				const cu = ctx.getContextUsage();
				const window = cu?.contextWindow ?? ctx.model?.contextWindow ?? 0;
				const pct = cu?.percent ?? null;
				const tokens = cu?.tokens ?? null;
				const barColor: ThemeColor = pct === null ? "muted" : pct > 90 ? "error" : pct > 70 ? "warning" : "success";
				const filled = pct === null ? 0 : Math.round((Math.min(100, Math.max(0, pct)) / 100) * BAR_WIDTH);
				const bar = "█".repeat(filled) + "░".repeat(BAR_WIDTH - filled);
				const usedStr = tokens === null ? "?" : fmt(tokens);
				const pctStr = pct === null ? "?" : `${pct.toFixed(1)}%`;
				const ctxChunk =
					theme.fg(barColor, bar) +
					theme.fg("muted", ` ${usedStr}/${fmt(window)}`) +
					theme.fg(barColor, ` (${pctStr})`);

				let modelChunk = theme.fg("text", ctx.model?.id ?? "no model");
				if (ctx.model?.reasoning) {
					const level = ctx.thinkingLevel ?? "off";
					modelChunk += theme.fg("dim", " • ") + theme.fg(THINKING_COLOR[level] ?? "muted", level);
				}
				if (footerData.getAvailableProviderCount() > 1 && ctx.model) {
					modelChunk = theme.fg("dim", `(${ctx.model.provider}) `) + modelChunk;
				}

				// Everything left-aligned; truncate the tail (least important) if the line overflows.
				const chunks = [ctxChunk, modelChunk, stats.join(" ")].filter((c) => c !== "");
				const line2 =
					" ".repeat(LINE2_PAD) +
					truncateToWidth(chunks.join("  "), Math.max(0, width - LINE2_PAD), theme.fg("dim", "…"));

				const lines = [line1, line2];

				// Line 3: extension statuses (same behavior as the default footer)
				const statuses = footerData.getExtensionStatuses();
				if (statuses.size > 0) {
					const s = Array.from(statuses.entries())
						.sort((a, b) => a[0].localeCompare(b[0]))
						.map(([, text]) => sanitize(text))
						.join(" ");
					lines.push(truncateToWidth(theme.fg("dim", s), width, theme.fg("dim", "…")));
				}
				return lines;
			};

			return {
				render,
				invalidate() {},
				dispose: unsubscribe,
			};
		});
	};

	pi.on("session_start", (_event, ctx) => {
		if (active) installFooter(ctx);
	});

	pi.registerCommand("fancy-footer", {
		description: "Toggle the fancy footer (restores the default when off)",
		handler: async (_args, ctx) => {
			active = !active;
			if (active) installFooter(ctx);
			else ctx.ui.setFooter(undefined);
			ctx.ui.notify(active ? "Fancy footer enabled" : "Default footer restored", "info");
		},
	});
};
