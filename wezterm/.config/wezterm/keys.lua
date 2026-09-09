local wezterm = require('wezterm') --[[@as Wezterm]]
local act = wezterm.action

local M = {}

---@alias Modifier
---|"ALT"
---|"ALT|SHIFT"
---|"CTRL"
---|"CTRL|ALT"
---|"CTRL|ALT|SHIFT"
---|"CTRL|SHIFT"
---|"ENHANCED_KEY"
---|"LEADER"
---|"LEADER|ALT"
---|"LEADER|CTRL"
---|"LEADER|SHIFT"
---|"LEFT_ALT"
---|"LEFT_CTRL"
---|"LEFT_SHIFT"
---|"NONE"
---|"RIGHT_ALT"
---|"RIGHT_CTRL"
---|"RIGHT_SHIFT"
---|"SHIFT"
---|"SUPER"

---@class SwitchToWorkspaceOpts
---@field name string Human-friendly workspace label
---@field spawn { args: string[]?, cwd: string? }? Spawn options for the workspace

---@param mods Modifier
---@param key Key|string
---@param action Action
---@param desc string
---@return Key
function M.map(mods, key, action, desc)
	return { key = key, mods = mods, action = action, desc = desc }
end

---Resolve the pane’s current working directory, falling back to `$HOME`
---@param pane Pane
---@return string cwd
local function get_cwd(pane)
	local cwd = pane:get_current_working_dir()
	if cwd and cwd.file_path then
		return cwd.file_path
	end

	return wezterm.home_dir
end

---Creates an action that switches to the requested workspace and tracks the previous one.
---@param opts SwitchToWorkspaceOpts
---@return ActionClass|ActionFuncClass
function M.switch_to_workspace(opts)
	return wezterm.action_callback(function(win, pane)
		local current_workspace = win:active_workspace()
		if current_workspace == opts.name then
			return
		end

		win:perform_action(act.SwitchToWorkspace({ name = opts.name, spawn = opts.spawn or {} }), pane)

		---@diagnostic disable-next-line: inject-field
		wezterm.GLOBAL.previous_workspace = current_workspace
	end)
end

---Creates an action that switches back to the most recently active workspace.
---Skips switching when no previous workspace is recorded or when already there.
---@return ActionClass|ActionFuncClass
function M.switch_to_previous_workspace()
	return wezterm.action_callback(function(win, pane)
		local current_workspace = win:active_workspace()
		local previous_workspace = wezterm.GLOBAL.previous_workspace
		if current_workspace == previous_workspace or previous_workspace == nil then
			return
		end

		win:perform_action(M.switch_to_workspace({ name = previous_workspace }), pane)
	end)
end

---@param config Config
function M.setup(config)
	config.leader = { mods = 'CTRL', key = 'z', timeout_milliseconds = 800 }
	config.keys = {
		-- Config
		M.map('CTRL|SHIFT', 'r', act.ReloadConfiguration, '  Reload Config'),

		-- Copy/Paste
		M.map('NONE', 'Copy', act.CopyTo('Clipboard'), '  Copy'),
		M.map('CTRL|SHIFT', 'c', act.CopyTo('Clipboard'), '  Copy'),
		M.map('NONE', 'Paste', act.PasteFrom('Clipboard'), '  Paste'),
		M.map('CTRL|SHIFT', 'v', act.PasteFrom('Clipboard'), '  Paste'),

		-- Font sizing
		M.map('CTRL', '=', act.IncreaseFontSize, '  Increate Font Size'),
		M.map('CTRL', '-', act.DecreaseFontSize, '  Decrease Font Size'),
		M.map('CTRL', '0', act.ResetFontSize, '  Reset Font Size'),

		-- Tmux
		M.map('LEADER', '1', act.ActivateTab(0), ' Go to Tab 1'),
		M.map('LEADER', '2', act.ActivateTab(1), ' Go to Tab 2'),
		M.map('LEADER', '3', act.ActivateTab(2), ' Go to Tab 3'),
		M.map('LEADER', '4', act.ActivateTab(3), ' Go to Tab 4'),
		M.map('LEADER', '5', act.ActivateTab(4), ' Go to Tab 5'),
		M.map('LEADER', '6', act.ActivateTab(5), ' Go to Tab 6'),
		M.map('LEADER', '7', act.ActivateTab(6), ' Go to Tab 7'),
		M.map('LEADER', '8', act.ActivateTab(7), ' Go to Tab 8'),
		M.map('LEADER', '9', act.ActivateTab(-1), ' Go to Tab 9'),
		M.map('LEADER', 'c', act.SpawnTab('CurrentPaneDomain'), ' Create a New Tab'),
		M.map('LEADER', 'x', act.CloseCurrentTab({ confirm = false }), ' Close Current Tab'),
		M.map('LEADER', 'z', act.TogglePaneZoomState, '  Zoom'),

		-- Personal
		M.map('LEADER', 's', act.ActivateCopyMode, ' Copy/Scroll Mode'),
		M.map('LEADER|CTRL', 'p', act.ActivateCommandPalette, ' Command Palette'),

		M.map('LEADER', 'd', act.SplitVertical({ domain = 'CurrentPaneDomain' }), '  Vertical Split'),
		M.map('LEADER', 'k', act.SplitHorizontal({ domain = 'CurrentPaneDomain' }), '  Horizontal Split'),
		M.map('CTRL|SHIFT', 'j', act.ActivateTabRelative(1), ' Go to Next Tab'),
		M.map('CTRL|SHIFT', 'k', act.ActivateTabRelative(-1), ' Go to Previous Tab'),
		M.map(
			'LEADER',
			'u',
			act.QuickSelectArgs({
				label = 'open url',
				patterns = { 'https?://\\S+' },
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)
					local suspicious_chars = {
						{ char = ')', is_magic = true },
						{ char = ']', is_magic = true },
						{ char = '}', is_magic = false },
						{ char = ',', is_magic = false },
						{ char = '.', is_magic = true },
						{ char = ':', is_magic = false },
						{ char = ';', is_magic = false },
					}
					for _, v in ipairs(suspicious_chars) do
						if string.sub(url, -1) == v.char then
							wezterm.log_info('deleting trailing character ' .. v.char .. ' from url')
							if v.is_magic then
								url = string.gsub(url, '%' .. v.char .. '$', '')
							else
								url = string.gsub(url, v.char .. '$', '')
							end
							break
						end
					end
					wezterm.log_info('opening: ' .. url)
					wezterm.open_with(url)
				end),
			}),
			'  Open URL'
		),

		-- Applications
		M.map(
			'LEADER|SHIFT',
			'g',
			act.SpawnCommandInNewTab({ args = { 'lazygit' }, label = '  LazyGit' }),
			'  Launch LazyGit'
		),
		M.map(
			'LEADER|SHIFT',
			'd',
			act.SpawnCommandInNewTab({ args = { 'lazydocker' }, label = '  LazyDocker' }),
			'  Launch LazyDocker'
		),
		M.map(
			'LEADER|CTRL',
			'e',
			wezterm.action_callback(function(window, pane)
				window:perform_action(
					act.SpawnCommandInNewTab({
						args = { 'yazi', get_cwd(pane) },
					}),
					pane
				)
			end),
			'󰇥  Launch Yazi'
		),
		M.map('LEADER|CTRL', 't', act.SpawnCommandInNewTab({ args = { 'btop' }, label = ' Btop' }), ' Btop'),

		-- Workspaces
		M.map('LEADER', 't', act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }), ' Search Workspace'),
		M.map('LEADER|CTRL', 'b', M.switch_to_previous_workspace(), ' Switch to Previous Workspace'),
		M.map(
			'LEADER|CTRL',
			'd',
			M.switch_to_workspace({
				name = '󱁿 dotfiles',
				spawn = {
					args = { 'nvim' },
					cwd = wezterm.home_dir .. '/dotfiles',
				},
			}),
			' Go to Dotfiles Workspace'
		),
		M.map(
			'LEADER|CTRL',
			'v',
			M.switch_to_workspace({
				name = ' nvim',
				spawn = {
					args = { 'nvim' },
					cwd = wezterm.home_dir .. '/.config/nvim',
				},
			}),
			' Go to Nvim Workspace'
		),
		M.map(
			'LEADER',
			'e',
			M.switch_to_workspace({
				name = '󰊿 english',
				spawn = {
					cwd = wezterm.home_dir .. '/w/2-areas/english/language-learning__nkl',
				},
			}),
			' Go to English Workspace'
		),
		M.map(
			'LEADER|CTRL',
			'h',
			M.switch_to_workspace({
				name = '󱂵 home',
				spawn = {
					cwd = wezterm.home_dir,
				},
			}),
			' Go to Home Workspace'
		),
		M.map(
			'LEADER',
			'b',
			M.switch_to_workspace({
				name = ' second-brain',
				spawn = {
					args = { 'nvim' },
					cwd = os.getenv('SECOND_BRAIN_PATH') .. '/src',
				},
			}),
			' Go to Second Brain Workspace'
		),
		M.map(
			'LEADER',
			'm',
			M.switch_to_workspace({
				name = ' music',
				spawn = {
					args = { 'just' },
					cwd = wezterm.home_dir .. '/Music',
				},
			}),
			' Go to Second Brain Workspace'
		),
		-- TODO: What does this?
		-- { mods = L, key = 'Space', action = act.QuickSelect },
	}

	config.key_tables = {
		copy_mode = {
			{ key = 'Tab', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
			{ key = 'Tab', mods = 'SHIFT', action = act.CopyMode('MoveBackwardWord') },
			{ key = 'Enter', mods = 'NONE', action = act.CopyMode('MoveToStartOfNextLine') },
			{ key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
			{ key = 'Space', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
			{ key = '$', mods = 'NONE', action = act.CopyMode('MoveToEndOfLineContent') },
			{ key = '$', mods = 'SHIFT', action = act.CopyMode('MoveToEndOfLineContent') },
			{ key = ',', mods = 'NONE', action = act.CopyMode('JumpReverse') },
			{ key = '0', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
			{ key = ';', mods = 'NONE', action = act.CopyMode('JumpAgain') },
			{ key = 'F', mods = 'NONE', action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
			{ key = 'F', mods = 'SHIFT', action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
			{ key = 'G', mods = 'NONE', action = act.CopyMode('MoveToScrollbackBottom') },
			{ key = 'G', mods = 'SHIFT', action = act.CopyMode('MoveToScrollbackBottom') },
			{ key = 'H', mods = 'NONE', action = act.CopyMode('MoveToViewportTop') },
			{ key = 'H', mods = 'SHIFT', action = act.CopyMode('MoveToViewportTop') },
			{ key = 'L', mods = 'NONE', action = act.CopyMode('MoveToViewportBottom') },
			{ key = 'L', mods = 'SHIFT', action = act.CopyMode('MoveToViewportBottom') },
			{ key = 'M', mods = 'NONE', action = act.CopyMode('MoveToViewportMiddle') },
			{ key = 'M', mods = 'SHIFT', action = act.CopyMode('MoveToViewportMiddle') },
			{ key = 'O', mods = 'NONE', action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
			{ key = 'O', mods = 'SHIFT', action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
			{ key = 'T', mods = 'NONE', action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
			{ key = 'T', mods = 'SHIFT', action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
			{ key = 'V', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Line' }) },
			{ key = 'V', mods = 'SHIFT', action = act.CopyMode({ SetSelectionMode = 'Line' }) },
			{ key = '^', mods = 'NONE', action = act.CopyMode('MoveToStartOfLineContent') },
			{ key = '^', mods = 'SHIFT', action = act.CopyMode('MoveToStartOfLineContent') },
			{ key = 'b', mods = 'NONE', action = act.CopyMode('MoveBackwardWord') },
			{ key = 'b', mods = 'ALT', action = act.CopyMode('MoveBackwardWord') },
			{ key = 'b', mods = 'CTRL', action = act.CopyMode('PageUp') },
			{ key = 'c', mods = 'CTRL', action = act.CopyMode('Close') },
			{ key = 'd', mods = 'CTRL', action = act.CopyMode({ MoveByPage = 0.5 }) },
			{ key = 'e', mods = 'NONE', action = act.CopyMode('MoveForwardWordEnd') },
			{ key = 'f', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = false } }) },
			{ key = 'f', mods = 'ALT', action = act.CopyMode('MoveForwardWord') },
			{ key = 'f', mods = 'CTRL', action = act.CopyMode('PageDown') },
			{ key = 'g', mods = 'NONE', action = act.CopyMode('MoveToScrollbackTop') },
			{ key = 'g', mods = 'CTRL', action = act.CopyMode('Close') },
			{ key = 'h', mods = 'NONE', action = act.CopyMode('MoveLeft') },
			{ key = 'j', mods = 'NONE', action = act.CopyMode('MoveDown') },
			{ key = 'k', mods = 'NONE', action = act.CopyMode('MoveUp') },
			{ key = 'l', mods = 'NONE', action = act.CopyMode('MoveRight') },
			{ key = 'm', mods = 'ALT', action = act.CopyMode('MoveToStartOfLineContent') },
			{ key = 'o', mods = 'NONE', action = act.CopyMode('MoveToSelectionOtherEnd') },
			{ key = 'q', mods = 'NONE', action = act.CopyMode('Close') },
			{ key = 't', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = true } }) },
			{ key = 'u', mods = 'CTRL', action = act.CopyMode({ MoveByPage = -0.5 }) },
			{ key = 'v', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
			{ key = 'v', mods = 'CTRL', action = act.CopyMode({ SetSelectionMode = 'Block' }) },
			{ key = 'w', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
			{
				key = 'y',
				mods = 'NONE',
				action = act.Multiple({ { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } }),
			},
			{ key = 'PageUp', mods = 'NONE', action = act.CopyMode('PageUp') },
			{ key = 'PageDown', mods = 'NONE', action = act.CopyMode('PageDown') },
			{ key = 'End', mods = 'NONE', action = act.CopyMode('MoveToEndOfLineContent') },
			{ key = 'Home', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
			{ key = 'LeftArrow', mods = 'NONE', action = act.CopyMode('MoveLeft') },
			{ key = 'LeftArrow', mods = 'ALT', action = act.CopyMode('MoveBackwardWord') },
			{ key = 'RightArrow', mods = 'NONE', action = act.CopyMode('MoveRight') },
			{ key = 'RightArrow', mods = 'ALT', action = act.CopyMode('MoveForwardWord') },
			{ key = 'UpArrow', mods = 'NONE', action = act.CopyMode('MoveUp') },
			{ key = 'DownArrow', mods = 'NONE', action = act.CopyMode('MoveDown') },
		},
	}
end

return M
