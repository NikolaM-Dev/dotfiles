# Roles

Pigments keep one job each. Do not reassign.

- brass `#fcba81`: functions, methods, calls. Also shadcn accent.
- ember `#ea9875`: params, fields, properties, interactive UI. Also shadcn primary and ring.
- sap `#99af6b`: every literal, strings, numbers. Also success-adjacent code, never status.
- cinder `#d1766e`: keywords, control flow, storage. Never error.
- frost `#4e89a2`: types, classes, constructors. Also links.
- potassium `#9480ba`: ANSI slot 5 only. Use for chart 6 or extra series, never tokens.

Semantic family carries more chroma than any pigment. Use only for status.

- error `#d25780`, warn `#f4a21c`, ok `#43b16a`, hint `#20c9cb`, info `#58bdff`

Grounds by depth. Ink is shared across depths.

- bg_deep: floats, sidebars, card. bg0: editor, background. bg1: cursorline, muted. bg2: statusline, secondary. bg3: borders, splits. bg4: hover, input. bg5: float edges.
- fg: text. fg_dim: delimiters, muted-foreground. comment: quiet on purpose at 3.32:1, use for placeholder and blockquote. gutter: line numbers.

Tints lift selections off the ground equally at any depth. vis for selection, add and del for diff backgrounds with ok and error for the foreground.
