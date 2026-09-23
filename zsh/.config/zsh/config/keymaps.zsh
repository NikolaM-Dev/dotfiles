# ------------------------------------------------------------------------------
# _crowbar, Toggle from a current process to the background
# ------------------------------------------------------------------------------
_crowbar() {
	if [[ $#BUFFER == 0 ]]; then
		fg >/dev/null 2>&1 && zle redisplay
	else
		zle push-input
	fi
}

zle -N _crowbar
bindkey '^Z' _crowbar

function _open_yazi() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"

	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true

	command rm -f -- "$tmp"
}
zle -N _open_yazi
bindkey '^E' _open_yazi

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# ------------------------------------------------------------------------------
# _yupdate, To easy update the system packages using yay
# ------------------------------------------------------------------------------
function _yupdate() {
	LBUFFER="${LBUFFER}yupdate --noconfirm"
}

zle -N _yupdate
bindkey '^U' _yupdate
