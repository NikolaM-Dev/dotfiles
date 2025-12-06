#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# _open_with_nvim, Open with nvim and launch telescope with smart open
# ------------------------------------------------------------------------------
function _open_with_nvim() {
	nvim
}

zle -N _open_with_nvim
bindkey '\ev' _open_with_nvim

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
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

	yazi "$@" --cwd-file="$tmp"

	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
		zoxide add $PWD
	fi

	rm -f -- "$tmp"
}
zle -N _open_yazi
bindkey '^E' _open_yazi

function _open_zoxide() {
	__zoxide_zi
	zle reset-prompt
}
zle -N _open_zoxide
bindkey '^S' _open_zoxide

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
