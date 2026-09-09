local wezterm = require('wezterm') --[[@as Wezterm]]
local config = require('config')
local font = require('fonts.maple-mono-nf')
local tabs = require('tabs')
local theme = require('themes')

font.setup(config)
theme.setup(config, 'dicom')
tabs.setup(config)
require('keys').setup(config)

---@diagnostic disable-next-line: undefined-field
require('plugins.smart_splits').setup(config)
require('plugins.smart_workspace_switcher').setup(config)

config.adjust_window_size_when_changing_font_size = false
config.audible_bell = 'Disabled'
config.automatically_reload_config = true
config.disable_default_key_bindings = true
config.enable_scroll_bar = false
config.enable_wayland = false
config.force_reverse_video_cursor = false
config.freetype_load_target = 'HorizontalLcd'
config.freetype_render_target = 'HorizontalLcd'
config.max_fps = 240
config.warn_about_missing_glyphs = false
config.window_background_opacity = 1
config.window_close_confirmation = 'NeverPrompt'
config.window_padding = { bottom = 8, left = 8, right = 8, top = 8 }
config.window_decorations = 'RESIZE'
config.scrollback_lines = 1000000
config.term = 'wezterm'

-- config.keys = {
-- { key = 't', mods = 'SUPER', action = act.DisableDefaultAssignment },
-- { key = 'y', mods = 'SUPER|CTRL', action = act.QuickSelect },
-- {
-- 	key = 'y',
-- 	mods = 'SUPER|SHIFT',
-- 	action = act.QuickSelectArgs({
-- 		label = 'open url',
-- 		patterns = {
-- 			'https?://\\S+',
-- 		},
-- 		action = wezterm.action_callback(function(window, pane)
-- 			local url = window:get_selection_text_for_pane(pane)
-- 			-- Remove any suspicious-looking trailing punctuation character from the
-- 			-- URL, because 99.99% of the time, this is just carried over from the
-- 			-- surrounding text and is not actually part of the URL. We have to escape
-- 			-- some characters with a percent sign (%) because they are considered
-- 			-- magic characters in Lua.
-- 			local suspicious_chars = {
-- 				{ char = ')', is_magic = true },
-- 				{ char = ']', is_magic = true },
-- 				{ char = '}', is_magic = false },
-- 				{ char = ',', is_magic = false },
-- 				{ char = '.', is_magic = true },
-- 				{ char = ':', is_magic = false },
-- 				{ char = ';', is_magic = false },
-- 			}
-- 			for _, v in ipairs(suspicious_chars) do
-- 				if string.sub(url, -1) == v.char then
-- 					wezterm.log_info('deleting trailing character ' .. v.char .. ' from url')
-- 					if v.is_magic then
-- 						url = string.gsub(url, '%' .. v.char .. '$', '')
-- 					else
-- 						url = string.gsub(url, v.char .. '$', '')
-- 					end
-- 					break
-- 				end
-- 			end
-- 			wezterm.log_info('opening: ' .. url)
-- 			wezterm.open_with(url)
-- 		end),
-- 	}),
-- },
--

local colors = require('themes.dicom').colors
wezterm.on('update-right-status', function(window, _pane)
	window:set_right_status(wezterm.format({
		---@diagnostic disable-next-line: missing-fields
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = colors.blue } },
		{ Text = window:active_workspace() .. ' ' },
	}))
end)

-- local function get_current_working_dir(tab)
-- 	local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = '' }
-- 	local HOME_DIR = string.format('file://%s', os.getenv('HOME'))
--
-- 	return current_dir == HOME_DIR and '.' or string.gsub(current_dir.file_path, '(.*[/\\])(.*)', '%2')
-- end
--
-- wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
-- 	local has_unseen_output = false
-- 	if not tab.is_active then
-- 		for _, pane in ipairs(tab.panes) do
-- 			if pane.has_unseen_output then
-- 				has_unseen_output = true
-- 				break
-- 			end
-- 		end
-- 	end
--
-- 	local cwd = wezterm.format({
-- 		{ Attribute = { Intensity = 'Bold' } },
-- 		{ Text = get_current_working_dir(tab) },
-- 	})
--
-- 	local title = string.format(' [%s] %s', tab.tab_index + 1, cwd)
--
-- 	if has_unseen_output then
-- 		return {
-- 			{ Foreground = { Color = '#8866bb' } },
-- 			{ Text = title },
-- 		}
-- 	end
--
-- 	return {
-- 		{ Text = title },
-- 	}
-- end)

config.command_palette_bg_color = colors.bg
config.command_palette_fg_color = colors.fg

return config
