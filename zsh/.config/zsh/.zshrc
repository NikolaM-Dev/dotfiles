# Startup profiler — silent unless ZSH_PROFILE=1 (see bottom of file)
if [[ -n "$ZSH_PROFILE" ]]; then
	start=$(date +%s.%N)
fi

CONFIG_FILES=(
	env
	keymaps
	# keymaps2 # loaded before starship, so vi-prompt is set correctly
	plugins
	# cli_settings
	#
	# options
	# navigation
	# completion
	# terminal_utils
	aliases
	# docs_man
	# ai_help
	#
	# git_github
	# homebrew
	# python
	functions
)

for filename in "${CONFIG_FILES[@]}"; do
	source "$ZDOTDIR/config/$filename.zsh"
done

if [[ -n $ZMX_SESSION ]]; then
	export PS1="[$ZMX_SESSION] ${PS1}"
fi

if [[ -n "$ZSH_PROFILE" ]]; then
	end=$(date +%s.%N)
	echo "[DEBUG] zsh startup: $(echo "$end - $start" | bc)s"
fi

# bun completions
[ -s "/home/nikola/.bun/_bun" ] && source "/home/nikola/.bun/_bun"

# pnpm
export PNPM_HOME="/home/nikola/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
