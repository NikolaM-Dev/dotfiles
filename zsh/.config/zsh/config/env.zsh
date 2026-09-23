function add_to_path() {
	if [ -z "$1" ]; then
		echo "Error: Path cannot be empty"
		return 1
	fi

	case ":$PATH:" in
	*":$1:"*) ;;
	*) export PATH="$PATH:$1" ;;
	esac
}

if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
	export XDG_CACHE_HOME="$HOME/.cache"
fi

# Binaries
add_to_path "$HOME/.local/bin"
add_to_path "$XDG_DATA_HOME/nvim/mason/bin"
# Bob - Neovim version manager (prepend to prioritize over system nvim)
if [ -d "$XDG_DATA_HOME/bob/nvim-bin" ]; then
	_bob_path="$XDG_DATA_HOME/bob/nvim-bin"
	# Remove any existing bob entries (zsh-safe via tr/grep) then prepend
	_clean_path=$(printf "%s" "$PATH" | tr ':' '\n' | grep -vxF "$_bob_path" | paste -sd: -)
	export PATH="$_bob_path${_clean_path:+:$_clean_path}"
	unset _bob_path _clean_path
fi

# Lang
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferences
export EDITOR="nvim"
export FILE="yazi"
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export READER="zathura"
export TERMINAL="ghostty"
export VISUAL="nvim"

# Starship
if [[ "$TERM" != "dumb" ]]; then
	export STARSHIP_CONFIG=~/.config/starship/starship.toml
	eval "$(starship init zsh)"
fi

# Golang
export PATH="$PATH:$HOME/go/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Bun
export BUN_INSTALL="/home/nikola/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Pnpm
export PNPM_HOME="/home/nikola/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

## Bun completions
[ -s "/home/nikola/.bun/_bun" ] && source "/home/nikola/.bun/_bun"

# GUM
export GUM_INPUT_CURSOR_FOREGROUND="#FF0"
export GUM_INPUT_PLACEHOLDER="What's up?"
export GUM_INPUT_PROMPT=" "
export GUM_INPUT_PROMPT_FOREGROUND="#0FF"
export GUM_INPUT_WIDTH=80

# ------------------------------------------------------------------------------
# fnm, Fast and simple Node.js version manager, built in Rust
# ------------------------------------------------------------------------------
FNM_PATH="/home/nikola/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
	export PATH="/home/nikola/.local/share/fnm:$PATH"
	eval "$(fnm env)"
fi

# zoxide
eval "$(zoxide init zsh)"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*,plugged/*,vscode/*}"'
export FZF_DEFAULT_OPTS=" \
--ansi \
--border rounded \
--pointer='' \
--prompt=' ' \
--reverse \
"

# GTK
export GTK_THEME="Qogir-Round-Dark"

# Second Brain
export SECOND_BRAIN_PATH="$HOME/w/a/second-brain.md"

# ------------------------------------------------------------------------------
# conda, Contents within this block are managed by 'conda init'
# ------------------------------------------------------------------------------
__conda_setup="$('/home/nikola/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/home/nikola/miniconda3/etc/profile.d/conda.sh" ]; then
		. "/home/nikola/miniconda3/etc/profile.d/conda.sh"
	else
		export PATH="/home/nikola/miniconda3/bin:$PATH"
	fi
fi
unset __conda_setup

# ------------------------------------------------------------------------------
# skim, Fuzzy Finder in rust
# ------------------------------------------------------------------------------
export SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS \
--cmd-prompt='  ' \
--color=current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc \
--color=fg:#cdd6f4,bg:-1,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4 \
--color=selected:#eba0ac,header:#94e2d5,border:#6c7086 \
--color=spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8 \
--prompt='  ' \
--reverse \
"

export PATH=/home/nikola/.opencode/bin:$PATH

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
