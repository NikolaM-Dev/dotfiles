---
name: cendre-themer
description: "Trigger: cendre theme, port to cendre, shadcn cendre, make theme. Port any tool or shadcn CSS to Cendre using palette.lua as source."
---

# Cendre themer

## Activation Contract

Use when user asks for cendre, port a theme, style a tool, or make shadcn CSS. Ignore for generic color picks with no cendre context.

## Hard Rules

- Read `~/.local/share/nvim/lazy/cendre/lua/cendre/palette.lua` first. Fall back to `assets/cendre-tokens.json`. Never invent hex.
- Default depth is `hard`. Ask before using `medium` or `soft`.
- Qualify stored names per depth: `cendre`, `cendre-medium`, `cendre-soft`.
- Keep role map in `references/roles.md`. Error never uses cinder. Charts use pigments only.
- Dark only. Do not invent a light variant unless asked.
- Use absolute paths in tool calls.

## Decision Gates

| Situation | Action |
| --- | --- |
| Tool exists in `extras/` | Reuse that port, give install path, stop |
| New tool or shadcn web | Follow `references/recipe.md` and emit new file |
| Depth unclear | Ship `hard`, note how to switch |
| Light theme asked | Confirm explicitly, then invert grounds manually |

## Execution Steps

1. Resolve depth, target format, and absolute output path.
2. Load tokens for that depth and map roles per recipe. For web start from `assets/shadcn-theme.css`.
3. Emit file, check contrast, report install path.

## Output Contract

Return files created, depth used, any role deviation, and target install path.

## References

- `assets/cendre-tokens.json` for snapshot values.
- `assets/shadcn-theme.css` for shadcn hard template.
- `references/roles.md` for pigment and semantic jobs.
- `references/recipe.md` for port procedure.
