local c = require('config')
local f = require('fonts.maple-mono-nf')

local config = c.get_config()

f.setup_font(config)

config.adjust_window_size_when_changing_font_size = false
config.audible_bell = 'Disabled'
config.automatically_reload_config = true
config.color_scheme = 'Catppuccin Mocha'
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.enable_wayland = false
config.force_reverse_video_cursor = false
config.freetype_load_target = 'HorizontalLcd'
config.freetype_render_target = 'HorizontalLcd'
config.max_fps = 240
config.window_background_opacity = 0.95
config.window_close_confirmation = 'NeverPrompt'
config.window_padding = { bottom = 8, left = 8, right = 8, top = 8 }

-- PERF: Remove github call
local wezterm = require('wezterm')
local theme = wezterm.plugin.require('https://github.com/neapsix/wezterm').moon
config.colors = theme.colors()

return config
