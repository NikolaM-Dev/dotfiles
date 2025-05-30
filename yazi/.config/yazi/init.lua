---@diagnostic disable: undefined-global
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= 'unix' then
		return ''
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg('yellow'),
		ui.Span(':'),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg('yellow'),
		ui.Span(' '),
		ui.Span(tostring(ya.readable_size(h:size() or h.cha.len))):fg('green'),
		ui.Span(' '),
	})
end, 500, Status.RIGHT)
