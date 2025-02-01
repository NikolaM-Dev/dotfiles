# Binaries
export PATH="$HOME/.local/bin:$PATH"

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

# ZSH
export ZSH="/home/nikola/.oh-my-zsh"

## Plugins

### vi-mode plugin
export KEYTIMEOUT=20
export VI_MODE_SET_CURSOR=true

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

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
  eval "`fnm env`"
fi

# zoxide
eval "$(zoxide init zsh)"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*,plugged/*,vscode/*}"'
export FZF_DEFAULT_OPTS=" \
--ansi \
--border rounded \
--color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--pointer='' \
--prompt='  ' \
--reverse \
"
source <(fzf --zsh)

# GTK
export GTK_THEME="Qogir-Dark"

# Second Brain
export SECOND_BRAIN_PATH="$HOME/Documents/second-brain.md"

# ------------------------------------------------------------------------------
# conda, Contents within this block are managed by 'conda init'
# ------------------------------------------------------------------------------
__conda_setup="$('/home/nikola/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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
