# DOCS
# official docs https://zsh.sourceforge.io/Guide/zshguide06.html
# zstyle        https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Standard-Styles
# good guide    https://thevaluable.dev/zsh-completion-guide-examples/
#───────────────────────────────────────────────────────────────────────────────

# INIT (must run before any `compdef` consumers like just below)
export ZSH_COMPDUMP="$HOME/.local/share/zsh/zcompdump" # outside the repo
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}" # compinit won't create parents
autoload -Uz compinit && compinit -d "$ZSH_COMPDUMP"

#───────────────────────────────────────────────────────────────────────────────
# FORMAT / COLOR
# color completion groups with purple-gray background
zstyle ':completion:*:descriptions' format $'\e[7;38;5;103m %d \e[0;38;5;103m \e[0m'

# color items in specific groups (here: aliases in magenta)
zstyle ':completion:*:aliases' list-colors '=*=35'

# 1. option descriptions in gray (`38;5;245` is visible in dark and light mode)
# 2. apply LS_COLORS to files/directories
# 3. selected item (styled via `ma=`)
zstyle ':completion:*:default' list-colors \
	'=(#b)*(-- *)=39=38;5;245' \
	"$LS_COLORS" \
	"ma=7;38;5;68"

# silent warning if there are no completions
zstyle ':completion:*:warnings' format ""

# print help messages in blue instead of red (e.g., `just` recipe-descriptions)
zstyle ':completion:*:messages' format $'\e[3;34m%d\e[0m'

#───────────────────────────────────────────────────────────────────────────────
# SORT
zstyle ':completion:*' file-sort modification follow # "follow" makes it follow symlinks

zstyle ':completion:*' group-order \
	path-directories local-directories directories \
	all-expansions expansions options \
	aliases suffix-aliases functions reserved-words builtins commands executables \
	remotes hosts recent-branches commits

#────────────────────────────────────────────────────────────────────────────
# IGNORE
zstyle ':completion:*' completer \
	_expand _complete _correct _approximate _complete:-fuzzy _prefix

zstyle ':completion:*' ignored-patterns \
	".git" ".DS_Store" ".localized" "node_modules" "__pycache__"

#───────────────────────────────────────────────────────────────────────────────
# JUST — dynamic recipe completion (needs compinit above)
if (( $+commands[just] )); then
	source <(JUST_COMPLETE=zsh just)
fi
