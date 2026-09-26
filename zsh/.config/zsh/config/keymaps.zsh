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
bindkey '^O' _open_yazi # CONFIRMED exception: overrides emacs `accept-line-and-down-history`

# _yupdate, To easy update the system packages using yay
function _yupdate() {
	LBUFFER="${LBUFFER}yupdate --noconfirm"
}
zle -N _yupdate
bindkey '^U' _yupdate # CONFIRMED exception: overrides emacs `kill-whole-line` (^A^K emulates it)

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
# Note: `^Y` yank lives here; plugins.zsh binds autosuggest to `^X^Y`
# so it does not clobber yank (plugins loads after keymaps).

# -- movement ---------------------------------------------------------------
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^B' backward-char
bindkey '^F' forward-char # was edit-command-line, now ^X^E (readline standard)
bindkey '^P' up-line # arrows own history
bindkey '^N' down-line # arrows own history
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# -- deletion ----------------------------------------------------------------
bindkey '^D' delete-char-or-list
bindkey '^H' backward-delete-char
bindkey -M viins '^?' backward-delete-char # fix backspace not being able to delete a line break
bindkey '^W' backward-kill-word # replaces viins default vi-backward-kill-word for emacs WORD behavior
bindkey '^[d' kill-word
bindkey '^[^?' backward-kill-word
bindkey '^[^H' backward-kill-word
bindkey '^K' kill-line # restored to emacs; buffer-cut moved to ^X^K below

# ^X^K -> cut whole buffer to clipboard (was ^K; matches emacs kill-buffer)
function _cut-buffer {
	print -n -- "$BUFFER" | xclip -selection clipboard
	BUFFER=""
}
zle -N _cut-buffer
bindkey '^X^K' _cut-buffer
bindkey -M vicmd '^K' _cut-buffer

# -- yank / transpose ---------------------------------------------------------
bindkey '^Y' yank # restored to emacs; autosuggest-execute moved to ^X^Y in plugins.zsh
bindkey '^[y' yank-pop
bindkey '^T' transpose-chars
bindkey '^[t' transpose-words

# -- history search ------------------------------------------------------------
bindkey '^R' history-incremental-search-backward # was redisplay in viins default
bindkey '^X^S' history-incremental-search-forward # ^S kept for zoxide above
bindkey '^[p' history-search-backward
bindkey '^[n' history-search-forward

# -- misc ----------------------------------------------------------------------
bindkey '^L' clear-screen
bindkey '^G' send-break # was list-expand in viins default (use ^Xg for that)
bindkey '^V' quoted-insert
bindkey '^Q' push-line # was vi-quoted-insert in viins default (^V covers quoting)
bindkey '^_' undo
bindkey '^X^U' undo
bindkey '^[q' push-line
bindkey '^[.' insert-last-word
bindkey '^[_' insert-last-word
bindkey '^[c' capitalize-word
bindkey '^[l' down-case-word # dead in tmux (M-l resize), use ^[L below
bindkey '^[L' down-case-word # tmux-safe duplicate (M-S-l distinct from M-l resize)
bindkey '^[u' up-case-word

#───────────────────────────────────────────────────────────────────────────────
# EDIT COMMAND LINE (readline C-x C-e standard)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M vicmd v edit-command-line
#───────────────────────────────────────────────────────────────────────────────
# TMUX COMPAT (prefix=C-z, nav=C-h/j/k/l, resize=M-h/j/k/l, all root/no-prefix).
# tmux intercepts those keys before zsh, so bare emacs binds are dead inside
# tmux. Duplicates below avoid C-h/j/k/l, C-z and M-h/j/k/l entirely
# (C-x + plain letter is safe: tmux only watches bare C-k/C-l/etc).
# Outside tmux the bare binds still work; inside tmux use the -tmux- ones.
bindkey '^Xk' kill-line # tmux-safe ^K
bindkey '^XK' _cut-buffer # tmux-safe ^X^K (C-k second key would nav pane)
bindkey -M vicmd '^XK' _cut-buffer
bindkey '^Xl' clear-screen # tmux-safe ^L
bindkey '^[z' _crowbar # tmux-safe ^Z (C-z is prefix, never reaches zsh)
bindkey '^Xz' _crowbar # tmux-safe ^Z alternative
# ^H backward-delete-char is dead in tmux, C-h moves left. Backspace, ^?, covers it.
# ^J accept-line: Enter (^M) covers it; bare C-j navs down in tmux.
# M-h/j/k/l: untouched in zsh (tmux resize owns them); only M-l clashed, see ^[L above.

#───────────────────────────────────────────────────────────────────────────────
# VIM NORMAL-MODE BINDINGS
bindkey -M vicmd 'k' up-line               # disable accidentally searching history
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M vicmd 'H' vi-first-non-blank
bindkey -M vicmd -s ' ' 'ciw' # -s flag sends direct keystrokes and therefore allows for remappings
bindkey -M vicmd 'U' redo
bindkey -M vicmd 'm' vi-join
bindkey -M vicmd -s 'Y' 'y$'

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
