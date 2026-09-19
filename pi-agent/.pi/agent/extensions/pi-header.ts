/**
 * Pi header - logo and tagline above the default header.
 *
 * Static, no commands. The gradient art is styled once per theme and
 * reused on every render. The block below it mirrors the built-in
 * header exactly, including the expand toggle.
 */

import { VERSION, keyHint, keyText, rawKeyHint } from "@earendil-works/pi-coding-agent";
import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";

const PI_LOGO_LINES = [
  "████████████╗",
  "████████████║",
  "████╔═══████║",
  "████║   ████║",
  "████████╬═══████╗",
  "████████║   ████║ ",
  "████╔═══╝   ████║",
  "████║       ████║",
  "╚═══╝       ╚═══╝",
] as const;

const FALLBACK_ACCENT = { r: 234, g: 152, b: 117 };

type Rgb = { r: number; g: number; b: number };

function clamp(n: number): number {
  return Math.max(0, Math.min(255, Math.round(n)));
}

// Minimal ANSI to RGB. Handles truecolor, basic colors, else fallback.
function parseAccentAnsi(ansi: string): Rgb {
  const tc = /38;2;(\d+);(\d+);(\d+)/.exec(ansi);
  if (tc) return { r: Number(tc[1]), g: Number(tc[2]), b: Number(tc[3]) };

  const basic: Record<number, Rgb> = {
    30: { r: 0, g: 0, b: 0 },
    31: { r: 205, g: 49, b: 49 },
    32: { r: 13, g: 188, b: 121 },
    33: { r: 229, g: 192, b: 123 },
    34: { r: 36, g: 114, b: 200 },
    35: { r: 188, g: 63, b: 188 },
    36: { r: 17, g: 168, b: 205 },
    37: { r: 229, g: 229, b: 229 },
    90: { r: 102, g: 102, b: 102 },
    91: { r: 241, g: 76, b: 76 },
    92: { r: 35, g: 209, b: 139 },
    93: { r: 245, g: 193, b: 80 },
    94: { r: 59, g: 142, b: 214 },
    95: { r: 201, g: 123, b: 192 },
    96: { r: 32, g: 178, b: 171 },
    97: { r: 230, g: 230, b: 230 },
  };
  const is256 = /38;5;\d+/.test(ansi);
  if (is256) return FALLBACK_ACCENT;
  const single = /\x1b\[(\d+)m/.exec(ansi);
  if (single && basic[Number(single[1])]) return basic[Number(single[1])]!;
  return FALLBACK_ACCENT;
}

function darken(c: Rgb, amt: number): Rgb {
  return { r: clamp(c.r * (1 - amt)), g: clamp(c.g * (1 - amt)), b: clamp(c.b * (1 - amt)) };
}

function lighten(c: Rgb, amt: number): Rgb {
  return {
    r: clamp(c.r + (255 - c.r) * amt),
    g: clamp(c.g + (255 - c.g) * amt),
    b: clamp(c.b + (255 - c.b) * amt),
  };
}

function buildPalette(accent: Rgb): Rgb[] {
  const steps = 24;
  const out: Rgb[] = [];
  for (let i = 0; i < steps; i++) {
    const wave = -Math.cos((i / steps) * Math.PI * 2);
    out.push(wave < 0 ? darken(accent, 0.18 * -wave) : lighten(accent, 0.18 * wave));
  }
  return out;
}

function visibleWidth(s: string): number {
  return [...s.replace(/\x1b\[[0-9;]*m/g, "")].length;
}

let cacheKey: string | undefined;
let cacheLines: string[] | undefined;

function logoLines(theme: Theme): string[] {
  const mode = theme.getColorMode?.() ?? "truecolor";
  const accentAnsi = theme.getFgAnsi?.("accent" as never) ?? "";
  const key = `${mode}|${accentAnsi}`;
  if (key === cacheKey && cacheLines) return cacheLines;

  // 256color terminals cannot show a smooth gradient, use flat accent.
  if (mode !== "truecolor") {
    cacheLines = PI_LOGO_LINES.map((line) => theme.fg("accent" as never, line));
    cacheKey = key;
    return cacheLines;
  }

  const accent = accentAnsi ? parseAccentAnsi(accentAnsi) : FALLBACK_ACCENT;
  const palette = buildPalette(accent);
  cacheLines = PI_LOGO_LINES.map((line, row) => {
    const chars = [...line];
    const span = Math.max(chars.length - 1, 1);
    let out = "";
    for (let i = 0; i < chars.length; i++) {
      const ch = chars[i]!;
      if (ch === " ") {
        out += " ";
        continue;
      }
      // Walk the palette diagonally so rows feel continuous.
      const pos = (((i / span + row * 0.12) % 1) + 1) % 1;
      const scaled = pos * palette.length;
      const base = Math.floor(scaled) % palette.length;
      const next = (base + 1) % palette.length;
      const f = scaled - Math.floor(scaled);
      const a = palette[base]!;
      const b = palette[next]!;
      const r = clamp(a.r + (b.r - a.r) * f);
      const g = clamp(a.g + (b.g - a.g) * f);
      const bl = clamp(a.b + (b.b - a.b) * f);
      out += `\x1b[38;2;${r};${g};${bl}m${ch}\x1b[39m`;
    }
    return out;
  });
  cacheKey = key;
  return cacheLines;
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    ctx.ui.setHeader((ui, theme) => {
      const t = theme as Theme;
      let expanded = false;
      return {
        invalidate() { },
        setExpanded(next: boolean) {
          expanded = next;
          (ui as { requestRender?: () => void }).requestRender?.();
        },
        render(_width: number): string[] {
          const width = Math.max(1, _width);
          const rawArt = logoLines(t);
          const artWidth = Math.max(...rawArt.map(visibleWidth));
          let artPad = Math.floor((width - artWidth) / 2);
          if (artPad < 1) artPad = 1;
          const art = rawArt.map((l) => `${" ".repeat(artPad)}${l}`);
          const tagPlain = "There are many agent harnesses but this one is yours";
          let tagPad = Math.floor((width - [...tagPlain].length) / 2);
          if (tagPad < 1) tagPad = 1;
          const tagline = t.italic(
            " ".repeat(tagPad) +
            t.fg("muted" as never, "There are many agent harnesses but this one is ") +
            t.bold(t.fg("accent" as never, "yours")),
          );
          return [...art, "", tagline];
        },
      };
    });
  });
}
