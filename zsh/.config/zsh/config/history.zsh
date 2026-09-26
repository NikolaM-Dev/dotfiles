# Shared, immediate, de-duplicated history. Lives in ~/backups, not the repo.
# DOCS https://zsh.sourceforge.io/Doc/Release/Options.html#History
# History lives in ~/backups (not the repo): per-machine, rides along with backups.
export HISTFILE="$HOME/backups/zsh/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}" # zsh won't create parents

export HISTSIZE=20000
export SAVEHIST=$HISTSIZE

setopt INC_APPEND_HISTORY # write each command immediately, don't wait for exit
setopt SHARE_HISTORY      # all sessions read and write live, one shared history
setopt HIST_IGNORE_DUPS   # no consecutive duplicates
setopt HIST_REDUCE_BLANKS # trim extra whitespace
setopt HIST_NO_STORE      # `history`/`fc` itself isn't saved
setopt HIST_IGNORE_SPACE  # leading-space commands stay out (secrets)
