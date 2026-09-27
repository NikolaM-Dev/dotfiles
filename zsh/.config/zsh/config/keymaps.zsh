# Vi mode hybrid with emacs insert keys. Vim normal mode, plus tmux-safe duplicates.
# DOCS https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
# INFO
# - use `ctrl-v` or `cat -v` and then a key combination to get the shell binding
# - `bindkey -M main` to show existing keybinds
# - some bindings with '^' are reserved (^M=enter, ^I=tab)
#───────────────────────────────────────────────────────────────────────────────
# TERMINAL
stty -ixon 2>/dev/null # disable XON/XOFF flow-control so ^S reaches zsh

#───────────────────────────────────────────────────────────────────────────────
# VI MODE (default). Insert mode keeps emacs-style keys (below),
# normal mode is vim. One default, both muscle memories.
bindkey -v          # enable vi mode
export KEYTIMEOUT=1 # no delay when pressing <Esc>

# CURSOR SHAPE depending on mode -> https://unix.stackexchange.com/a/614203
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
		echo -ne '\e[1 q'
	elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
		[[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
		echo -ne '\e[5 q'
	fi
}
zle -N zle-keymap-select
_fix_cursor() { echo -ne '\e[5 q'; }
precmd_functions+=(_fix_cursor)

#───────────────────────────────────────────────────────────────────────────────
# CUSTOM WIDGETS

# _crowbar, Toggle from a current process to the background
_crowbar() {
	if [[ $#BUFFER == 0 ]]; then
		fg >/dev/null 2>&1 && zle redisplay
	else
		zle push-input
	fi
}
zle -N _crowbar
# bindkey '^Z' _crowbar

function _open_yazi() {
	local tmp cwd
	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"

	IFS= read -r -d '' cwd <"$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true

	command rm -f -- "$tmp"
	zle reset-prompt
}
zle -N _open_yazi
bindkey '^O' _open_yazi # CONFIRMED exception: overrides emacs `accept-line-and-down-history`

# _eol_or_yazi, end-of-line when there is text, otherwise open yazi
function _eol_or_yazi {
	if [[ $#BUFFER == 0 ]]; then
		zle _open_yazi
	else
		zle end-of-line
	fi
}
zle -N _eol_or_yazi

# _yupdate, To easy update the system packages using yay
function _yupdate() {
	LBUFFER="${LBUFFER}yupdate --noconfirm"
}
zle -N _yupdate
# _undo_or_yupdate, undo when there is text, otherwise stage a system update
function _undo_or_yupdate {
	if [[ $#BUFFER == 0 ]]; then
		zle _yupdate
	else
		zle undo
	fi
}
zle -N _undo_or_yupdate
bindkey '^U' _undo_or_yupdate # CONFIRMED exception: overrides emacs `kill-whole-line` (^A^Q emulates it)

# _open_zoxide: jump directories with zoxide interactive picker (fzf)
function _open_zoxide() {
	local dir
	dir="$(zoxide query --interactive)" || return # ESC aborts, stay put
	[[ -n "$dir" ]] && builtin cd -- "$dir"
	zle reset-prompt
}
zle -N _open_zoxide
bindkey '^S' _open_zoxide # CONFIRMED exception: overrides emacs `history-incremental-search-forward` (use ^X^S)

#───────────────────────────────────────────────────────────────────────────────
# EMACS-STYLE KEYS (insert mode, `bindkey -v` hybrid).
# Standards kept; customs above need CONFIRMED exception.
# Reference stock emacs map with: `zsh -f -c 'bindkey -e; bindkey -M main'`

# -- movement ---------------------------------------------------------------
bindkey '^A' beginning-of-line
bindkey '^B' backward-char
bindkey '^E' _eol_or_yazi
bindkey '^F' forward-char
bindkey '^N' down-line
bindkey '^P' up-line
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# -- deletion ----------------------------------------------------------------
bindkey '^D' delete-char-or-list
bindkey '^Q' kill-line
bindkey '^W' backward-kill-word
bindkey '^[d' kill-word
bindkey '^[q' push-line

# -- history search ------------------------------------------------------------
bindkey '^R' history-incremental-search-backward
bindkey '^X^S' history-incremental-search-forward
bindkey '^[n' history-substring-search-down # from zsh-history-substring-search
bindkey '^[p' history-substring-search-up   # zsh-history-substring-search

# -- misc ----------------------------------------------------------------------
bindkey '^_' undo

#───────────────────────────────────────────────────────────────────────────────
# EDIT COMMAND LINE (readline C-x C-e standard)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M vicmd v edit-command-line

#───────────────────────────────────────────────────────────────────────────────
# VIM NORMAL-MODE BINDINGS
bindkey -M vicmd 'k' up-line # disable accidentally searching history
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M vicmd 'H' vi-first-non-blank
bindkey -M vicmd -s 'Y' 'y$' # yank to end of line

#───────────────────────────────────────────────────────────────────────────────
# YANK/DELETE TO SYSTEM CLIPBOARD (xclip)
function _vi_yank_clipboard {
	zle vi-yank
	print -n -- "$CUTBUFFER" | xclip -selection clipboard
}
zle -N _vi_yank_clipboard
bindkey -M vicmd 'y' _vi_yank_clipboard

function _vi_kill_eol_clipboard {
	zle vi-kill-eol
	print -n -- "$CUTBUFFER" | xclip -selection clipboard
}
zle -N _vi_kill_eol_clipboard
bindkey -M vicmd 'D' _vi_kill_eol_clipboard

function _vi_delete_clipboard {
	zle vi-delete
	print -n -- "$CUTBUFFER" | xclip -selection clipboard
}
zle -N _vi_delete_clipboard
bindkey -M vicmd 'd' _vi_delete_clipboard

#───────────────────────────────────────────────────────────────────────────────
# VIM TEXT OBJECTS
autoload -U select-bracketed && zle -N select-bracketed
# shellcheck disable=2296
for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
	bindkey -M viopp "$c" select-bracketed
done

autoload -U select-quoted && zle -N select-quoted
for c in {a,i}{\',\",\`}; do
	bindkey -M viopp "$c" select-quoted
done
