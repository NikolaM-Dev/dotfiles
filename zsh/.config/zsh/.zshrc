# Startup profiler — silent unless ZSH_PROFILE=1 (see bottom of file)
if [[ -n "$ZSH_PROFILE" ]]; then
	start=$(date +%s.%N)
fi

CONFIG_FILES=(
	env
	options
	history
	keymaps
	plugins
	aliases
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
