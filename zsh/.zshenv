# [XDG Base Directory - ArchWiki](https://wiki.archlinux.org/title/XDG_Base_Directory)
#
# Where user-specific configurations should be written (analogous to `/etc`).
export XDG_CACHE_HOME="$HOME/.cache"
# Where user-specific non-essential (cached) data should be written (analogous
# to `/var/cache`)
export XDG_CONFIG_HOME="$HOME/.config"
# Where user-specific data files should be written (analogous to `/usr/share`).
export XDG_DATA_HOME="$HOME/.local/share"
# Where user-specific state files should be written (analogous to `/var/lib`).
export XDG_STATE_HOME="$HOME/.local/state"

# ──────────────────────────────────────────────────────────────────────────────

export ZDOTDIR="$XDG_CONFIG_HOME/zsh" # Custom ZSH config location
