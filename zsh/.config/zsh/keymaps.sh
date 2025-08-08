#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# _open_with_nvim, Open with nvim and launch telescope with smart open
# ------------------------------------------------------------------------------
function _open_with_nvim() {
	nvim
}

# zle -N _open_with_nvim
# bindkey '^V' _open_with_nvim

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
function _open_zoxide() {
	__zoxide_zi
	zle reset-prompt
}
zle -N _open_zoxide
bindkey '^S' _open_zoxide
