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
export TERMINAL="wezterm"
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

# Bun
export BUN_INSTALL="/home/nikola/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

## Bun completions
[ -s "/home/nikola/.bun/_bun" ] && source "/home/nikola/.bun/_bun"
