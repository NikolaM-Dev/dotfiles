# _ensure_plugin <dir> <repo-url> <entry-file>: shallow-clone once if missing
_ensure_plugin() {
	local dir="$ZDOTDIR/plugins/$1"
	if [[ ! -f "$dir/$3" ]]; then
		[[ -d "$dir" ]] && rmdir "$dir" 2>/dev/null
		git clone --depth 1 "$2" "$dir"
	fi
}

# zsh-autopair — https://github.com/hlissner/zsh-autopair
_ensure_plugin zsh-autopair https://github.com/hlissner/zsh-autopair autopair.zsh
if [[ -f "$ZDOTDIR/plugins/zsh-autopair/autopair.zsh" ]]; then
	source "$ZDOTDIR/plugins/zsh-autopair/autopair.zsh"
	(($+functions[autopair - init])) && autopair-init
fi

# zsh-autosuggestions — https://github.com/zsh-users/zsh-autosuggestions#configuration
_ensure_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions.zsh
if [[ -f "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
	source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
	export ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)" # ignores long history items
	export ZSH_AUTOSUGGEST_STRATEGY=(history)
	export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
	bindkey '^Y' autosuggest-execute
	# do not accept autosuggestion when using vim's `A`
	if ((${+ZSH_AUTOSUGGEST_ACCEPT_WIDGETS})); then
		ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#vi-add-eol})
	fi
fi

# zsh-history-substring-search — https://github.com/zsh-users/zsh-history-substring-search
_ensure_plugin zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search zsh-history-substring-search.zsh
[[ -f "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

# fast-syntax-highlighting — https://github.com/zdharma-continuum/fast-syntax-highlighting
_ensure_plugin fast-syntax-highlighting https://github.com/zdharma-continuum/fast-syntax-highlighting fast-syntax-highlighting.plugin.zsh
[[ -f "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]] && source "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
