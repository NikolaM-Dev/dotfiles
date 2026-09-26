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
bindkey -v # enable vi mode
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
bindkey '^Z' _crowbar

function _open_yazi() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"

	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true

	command rm -f -- "$tmp"
	zle reset-prompt
}
zle -N _open_yazi
bindkey '^O' _open_yazi # CONFIRMED exception: overrides emacs `open-line`

# _yupdate, To easy update the system packages using yay
function _yupdate() {
	LBUFFER="${LBUFFER}yupdate --noconfirm"
}
zle -N _yupdate
bindkey '^U' _yupdate # CONFIRMED exception: overrides emacs `universal-argument`

# _open_zoxide: jump directories with zoxide interactive picker (fzf)
function _open_zoxide() {
	local dir
	dir="$(zoxide query --interactive)" || return # ESC aborts, stay put
	[[ -n "$dir" ]] && builtin cd -- "$dir"
	zle reset-prompt
}
zle -N _open_zoxide
bindkey '^S' _open_zoxide

#───────────────────────────────────────────────────────────────────────────────
# EMACS-STYLE KEYS (insert mode). Standards kept; customs need confirmation.
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^N' undo

# ^K -> cut whole buffer to clipboard (deviates from emacs kill-line: whole buffer, not EOL)
function _cut-buffer {
	print -n -- "$BUFFER" | xclip -selection clipboard
	BUFFER=""
}
zle -N _cut-buffer
bindkey '^K' _cut-buffer
bindkey -M vicmd -s '^K' 'i^K' # make it work in normal mode as well

#───────────────────────────────────────────────────────────────────────────────
# EDIT COMMAND LINE
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^F' edit-command-line
bindkey -M vicmd v edit-command-line

# alt+arrows move between words
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

#───────────────────────────────────────────────────────────────────────────────
# VIM NORMAL-MODE BINDINGS
bindkey -M vicmd 'k' up-line               # disable accidentally searching history
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M vicmd 'H' vi-first-non-blank
bindkey -M vicmd -s ' ' 'ciw' # -s flag sends direct keystrokes and therefore allows for remappings
bindkey -M vicmd 'U' redo
bindkey -M vicmd 'm' vi-join
bindkey -M vicmd -s 'Y' 'y$'
bindkey -M viins '^?' backward-delete-char # fix backspace not being able to delete a line break

#───────────────────────────────────────────────────────────────────────────────
# YANK/DELETE TO SYSTEM CLIPBOARD (xclip)
function _vi_yank_clipboard { zle vi-yank; print -n -- "$CUTBUFFER" | xclip -selection clipboard; }
zle -N _vi_yank_clipboard
bindkey -M vicmd 'y' _vi_yank_clipboard

function _vi_kill_eol_clipboard { zle vi-kill-eol; print -n -- "$CUTBUFFER" | xclip -selection clipboard; }
zle -N _vi_kill_eol_clipboard
bindkey -M vicmd 'D' _vi_kill_eol_clipboard

function _vi_delete_clipboard { zle vi-delete; print -n -- "$CUTBUFFER" | xclip -selection clipboard; }
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
