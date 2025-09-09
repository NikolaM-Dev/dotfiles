function add_to_path() {
	if [ -z "$1" ]; then
		echo "Error: Path cannot be empty"
		return 1
	fi

	export PATH="$PATH:$1"
}

# Binaries
add_to_path "$HOME/.local/bin"

if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
	export XDG_CACHE_HOME="$HOME/.cache"
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
export OLLAMA_ORIGINS="app://obsidian.md*"

# ZSH
export ZSH="/home/nikola/.oh-my-zsh"

## Plugins

### vi-mode plugin
export KEYTIMEOUT=20
export VI_MODE_SET_CURSOR=true

# Starship
if [[ "$TERM" != "dumb" ]]; then
	export STARSHIP_CONFIG=~/.config/starship/starship.toml
	eval "$(starship init zsh)"
fi

# Golang
export PATH="$PATH:$HOME/go/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/env"
. "$HOME/.cargo/env"

# Bun
export BUN_INSTALL="/home/nikola/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

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
--color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--pointer='' \
--prompt='  ' \
--reverse \
"
# --border rounded \

# GTK
export GTK_THEME="Qogir-Round-Dark"

# Second Brain
export SECOND_BRAIN_PATH="$HOME/w/2-areas/second-brain.md"

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

# ------------------------------------------------------------------------------
# asdf, The Multiple Runtime Version Manager
# ------------------------------------------------------------------------------
# . "$HOME/.local/share/applications/asdf-vm/src/asdf-0.15.0/asdf.sh"

zstyle ':omz:update' mode auto

# ------------------------------------------------------------------------------
# [fabric](https://github.com/danielmiessler/Fabric)
# ------------------------------------------------------------------------------
# fablic CLI autocomplete
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

# fabric patterns autocomplete
for pattern_file in $HOME/.config/fabric/patterns/*; do
	# Get the base name of the file (i.e., remove the directory path)
	pattern_name=$(basename "$pattern_file")

	# Create an alias in the form: alias pattern_name="fabric --pattern pattern_name"
	alias_command="alias f_$pattern_name='fabric --pattern $pattern_name'"

	# Evaluate the alias command to add it to the current shell
	eval "$alias_command"
done

# fabric custom patterns autocomplete
for pattern_file in $HOME/.config/fabric/custom-patterns/*; do
	# Get the base name of the file (i.e., remove the directory path)
	pattern_name=$(basename "$pattern_file")

	# Create an alias in the form: alias pattern_name="fabric --pattern pattern_name"
	alias_command="alias f_$pattern_name='fabric --pattern $pattern_name'"

	# Evaluate the alias command to add it to the current shell
	eval "$alias_command"
done
