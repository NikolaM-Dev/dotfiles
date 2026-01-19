local wezterm = require('wezterm') --[[@as Wezterm]]

local colors = require('themes.dicom').colors
local map = require('keys').map

local M = {}

---@param config Config
function M.setup(config)
	local workspace_switcher = wezterm.plugin.require('https://github.com/MLFlexer/smart_workspace_switcher.wezterm')
	workspace_switcher.workspace_formatter = function(label)
		return wezterm.format({
			{ Background = { Color = colors.bg } },
			{ Foreground = { Color = colors.blue } },
			{ Text = ' ' .. label },
		})
	end

	config.default_workspace = '󱂵 home'
	table.insert(config.keys, map('LEADER', 'j', workspace_switcher.switch_workspace(), ' Switch Workspace'))
end

return M
