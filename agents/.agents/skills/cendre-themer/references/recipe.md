# Recipe

Use for any new tool port. Match the pattern in `extras/` under the lazy install.

1. Resolve depth. Default `hard`. Name output `cendre` for hard, `cendre-medium` or `cendre-soft` otherwise. Never collide two depths on one stored name.
2. Load tokens. Read `~/.local/share/nvim/lazy/cendre/lua/cendre/palette.lua` with `M.get(depth)`. Fall back to `assets/cendre-tokens.json` when nvim path is missing. Resync with `nvim --headless --noplugin -u NONE -c "set rtp+=." -c "luafile scripts/extras.lua" -c q` from the cendre repo.
3. Check existing ports first. List `~/.local/share/nvim/lazy/cendre/extras/<tool>/`. Copy structure and key names when present. Point user at install path instead of regenerating.
4. Map roles. Background to bg0, panel to bg_deep, elevated to bg1, border to bg3, text to fg, dim to fg_dim, accent to ember unless target calls it primary action, then ember for primary and brass for accent. Status to semantic family. Diff to tints plus ok and error. Syntax to pigments per roles file. Terminal slots per tokens file.
5. Emit. Use absolute output paths. For shadcn web, start from `assets/shadcn-theme.css` and swap grounds per depth. Keep radius at 0.5rem unless target defines its own.
6. Verify. Text at 12.89:1 on hard, dimmest pigment above 4.2:1, comment stays quiet. Flag any deviation in output.
