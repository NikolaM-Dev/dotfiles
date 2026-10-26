# Project helpers for repos, archives, docker, backups and timers. Sourced last.
# DOCS https://zsh.sourceforge.io/Doc/Release/Functions.html
# @description Scaffold local repo plus GitHub remote via gh.
# @arg $1 repo name (default: current dir name)
# @example `create_repo my-proj`
function create_repo {
	local repo_name="${1:-${PWD:t}}"

	# Check if the current directory is a Git repository
	if [ ! -d ".git" ]; then
		git init
	fi

	# Try to create the repository with GitHub CLI
	gh repo create "$repo_name" --public --source=. --remote=origin
	if [ $? -ne 0 ]; then
		echo "Error: Failed to create the repository on GitHub."
		return 1
	fi

	echo "Repository '$repo_name' created successfully and linked to the current directory."
}

# @description Back up a file to <file>.bak (interactive mv).
# @arg $1 file to back up
# @example `bk .zshrc`
function bk {
	if [[ $# -ne 1 ]]; then
		printf 'Usage: bk <file>\n' >&2
		return 1
	fi
	mv --interactive "$1" "$1.bak"
}

# @description Start Open WebUI container (detached, host network, Ollama backend).
# @example `start_open_webui`
function start_open_webui() {
	docker run \
		-d \
		-e PORT=48080 \
		-e WEBUI_AUTH=False \
		--network=host \
		-e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
		-v open-webui:/app/backend/data \
		--name open-webui \
		--restart always \
		ghcr.io/open-webui/open-webui:main
}

# TODO: Add docs
function update_open_webui() {
	docker rm -f open-webui
	docker pull ghcr.io/open-webui/open-webui:main

	start_open_webui
}

function update_ollama() {
	curl -fsSL https://ollama.com/install.sh | sh
}

function rclone_serve() {
	port=":8080"
	echo "http://localhost$port"
	rclone serve http encrypted_google_drive: --addr "$port"
}

function yupdate() {
	if ! yay -Syu $@; then
		echo "\n [ERROR] Update failed"
		return 1
	else
		echo "\n [TRACE] Removing download-* dirs"
		sudo rm -rf /var/cache/pacman/pkg/download-*
		echo "\n [TRACE] Using yay -Sc"
		yay -Sc --noconfirm
	fi

	n-packages
}

function _backup_data() {
	# Backup second brain
	cd $SECOND_BRAIN_PATH
	bun run format:fix
	n-backup-commit --stage-all
	git push origin HEAD

	# Backup data
	$HOME/.config/rclone/backup.sh
}

function cd() {
	if command -v zoxide >/dev/null 2>&1; then
		z "$@"
	else
		builtin cd "$@"
	fi
}

function _backup_rss_data() {
	cd ~/backups/
	./miniflux_pg_backup.sh
}

function ssn() {
	if pgrep -f "Minecraft" >/dev/null; then
		echo "Minecraft is running. Please stop it before shutting down the system."
		return 1
	fi

	_backup_data
	n-zen-backup
	# _backup_rss_data

	sudo shutdown now
}

function sr() {
	if pgrep -f "Minecraft" >/dev/null; then
		echo "Minecraft is running. Please stop it before restart the system."
		return 1
	fi

	_backup_data

	sudo reboot
}

function review_email() {
	xdg-open "https://mail.google.com/mail/u/0/#inbox"
	xdg-open "https://mail.google.com/mail/u/1/#inbox"
}

function x_journey {
	echo "Toggl Track Timer, $(date -d 'yesterday' +%F) Report

Day $((($(date +%s) - $(date -d "2026-01-27" +%s)) / 86400)): From Unlucky → Undeniable

✗…
✓0k/5k steps

#BuildInPublic #LearningInPublic" | add_to_clipboard
	zen-browser "https://x.com/nikolam_dev"
	zen-browser "https://www.figma.com/design/dWJoAcPQLm7Em48y3QMAEF/Learning-in-Public?node-id=0-1&p=f&t=ThU2l0kd5xsLT3iu-0"
}

function ttimer() {
	local duration description sound

	duration="$1"
	description="${2:-Timer}"
	sound="$HOME/backups/20251008T141746--pomodoro.mp3"

	if [[ -z "$duration" ]]; then
		printf 'Error: missing duration argument\n' >&2
		return 1
	fi

	if timer "$duration" --format 24h -n "$description"; then
		notify-send -t 600000 "󰀠  $description is Done"
		mpv "$sound"
	fi
}

function deep_work() {
	local description
	description="${1:-Deep Work}"
	ttimer 1h $description
}

function react-devtools() {
	# Find index.html in current directory
	local index_file
	index_file=$(find . -maxdepth 2 -name "index.html" -type f 2>/dev/null | head -n 1)

	if [[ -z "$index_file" ]]; then
		echo "[ERROR] index.html not found"
		return 1
	fi

	echo "[TRACE] Found index.html at: $index_file"

	local script_tag='<script src="http://localhost:8097"></script>'

	# Check if script is already added
	if grep -q "localhost:8097" "$index_file"; then
		echo "[TRACE] React DevTools script already present"
	else
		# Add script before </body>
		if grep -q "</body>" "$index_file"; then
			sed -i "s|</body>|$script_tag</body>|" "$index_file"
			echo "[TRACE] Added React DevTools script to $index_file"
		else
			# If no </body>, append to end of file
			echo "$script_tag" >>"$index_file"
			echo "[TRACE] Added React DevTools script to end of $index_file"
		fi
	fi

	# Run react-devtools
	bunx react-devtools

	# Remove the script from index.html
	sed -i 's|<script src="http://localhost:8097"></script>||' "$index_file"
	echo "[TRACE] Removed React DevTools script from $index_file"
}

function schange-date {
	if [ $# -ne 1 ]; then
		printf 'Usage: schange-date <yyyy-MM-dd>\n' >&2
		return 1
	fi

	if ! date -d "$1" >/dev/null 2>&1; then
		printf 'Error: "%s" is not a valid date. Use yyyy-MM-dd.\n' "$1" >&2
		return 1
	fi

	local hour
	hour=$(date +%H:%M:%S)

	if ! sudo timedatectl set-ntp 0; then
		return 1
	fi

	if ! sudo timedatectl set-time "$1 $hour"; then
		echo "Error: failed to set the system clock."
		return 1
	fi
}

function open_nvim {
	if [ $# -eq 0 ]; then
		nvim .
	else
		nvim $1
	fi
}

function setup-work-user {
	printf '[user]\nname = juan.merchan\nemail = juan.merchan@parqco.com\n' >>.git/config
}

function c {
	if [ $# -eq 0 ]; then
		code .
	elif [ $# -eq 2 ]; then
		code $1 $2
	else
		code $1
	fi
}

function gbp {
	for branch in $(git branch --merged develop | egrep -v "(^\*| main| develop| qa| release)"); do
		git branch -d $branch
	done
}

function gbp2 {
	for branch in $(git branch --merged main | egrep -v "(^\*| main| develop| qa| release)"); do
		git branch -d $branch
	done
}

function gd {
	git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
	# | delta --side-by-side
}

# @description Switch git origin remote to SSH form for a GitHub repo.
# @arg $1 GitHub repo name (owner is NikolaM-Dev)
# @example `change-remote-to-ssh dotfiles`
function change-remote-to-ssh {
	if [[ $# -ne 1 ]]; then
		echo "Usage: $0 <project_name_in_github>"

		return 1
	fi

	git remote remove origin
	git remote add origin git@github.com:NikolaM-Dev/$1.git
}

function cdir {
	if [ $# -eq 1 ]; then
		mkdir $1 && cd $1
	else
		echo "Use: cdir <file_name>"
	fi
}

# @description Create a file and open it in nvim (replaces the old broken `to` alias).
# @arg $1 file to create and open
# @example `to notes.md`
function to {
	if [[ $# -ne 1 ]]; then
		printf 'Usage: to <file>\n' >&2
		return 1
	fi
	touch "$1" && nvim "$1"
}

function gundo {
	if [ $# -gt 1 ]; then
		echo "Use: gundo || gundo <number_of_commits>"
	elif [ $# -eq 1 ]; then
		git reset --soft HEAD~$1
	else
		git reset --soft HEAD~1
	fi
}

function backup-system {
	time_stamp=$(date '+%Y-%m-%d %H:%M:%S')
	sudo timeshift --create --comments "Backup $time_stamp"
}

function nvims {
	items=("default" $(ls "$XDG_CONFIG_HOME/nvim-configs" 2>/dev/null))
	config=$(printf "%s\n" "${items[@]}" | fzf --prompt="Neovim Config   " --height=~50% --layout=reverse --border --exit-0)

	if [[ -z $config ]]; then
		echo "Nothing selected"

		return 0
	elif [[ $config == "default" ]]; then
		config=""
	fi

	echo "$XDG_CONFIG_HOME/nvim-configs/$config"

	NVIM_APPNAME="$XDG_CONFIG_HOME/nvim-configs/$config" nvim "$@"
}

# @description EXtractor for archives (tar/zip/rar/7z/deb/...).
# @arg $1 archive file to extract
# @example `ex release.tar.gz`
function ex {
	if [ -f $1 ]; then
		case $1 in
		*.tar.bz2) tar xjf $1 ;;
		*.tar.gz) tar xzf $1 ;;
		*.bz2) bunzip2 $1 ;;
		*.rar) unrar x $1 ;;
		*.gz) gunzip $1 ;;
		*.tar) tar xf $1 ;;
		*.tbz2) tar xjf $1 ;;
		*.tgz) tar xzf $1 ;;
		*.zip) unzip $1 ;;
		*.Z) uncompress $1 ;;
		*.7z) 7z x $1 ;;
		*.deb) ar x $1 ;;
		*.tar.xz) tar xf $1 ;;
		*.tar.zst) tar xf $1 ;;
		*) echo "'$1' cannot be extracted via ex()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

function working-directories {
	mkdir -p ~/Documents/second-brain.md
	mkdir -p ~/go/src/github.com/NikolaM-Dev
	mkdir -p ~/library
	mkdir -p ~/Pictures
	mkdir -p ~/Videos
	mkdir -p ~/workspace/open-source
	mkdir -p ~/workspace/work
}

function gh() {
	if [[ "$1 $2" == "repo clone" ]]; then
		command gh "$@" && cd "$(basename "$3")"
	else
		command gh "$@"
	fi
}

function react_testing {
	cd tmp
	bun create vite testing --template react-ts --no-interactive
	cd tmp/testing
	git init
	bun i
	sesh connect .
}

# @description Update engram from source (beta path).
# @example `engram_update`
# Stable installs should use `gentle-ai update --engram` (checksummed release
# asset). This builds `@latest` via `go install` (upstream module is v2:
# `.../engram/v2/cmd/engram`), resolves the output with
# `go env GOBIN/GOPATH` (not hardcoded `~/go/bin`), backs the current binary
# up to `engram.bak`, and publishes with an atomic `cp -> chmod 755 -> mv` so
# a running engram MCP server never sees a truncated binary. No-op when source
# and dest are the same file. Verifies the installed file directly (`dest
# version`) and warns when PATH resolves `engram` elsewhere (brew,
# /usr/local/bin).
function engram_update {
	emulate -L zsh
	setopt nounset pipefail

	# 1. Build from source.
	if ! command -v go >/dev/null; then
		print -u2 "engram_update: go not found"
		return 1
	fi

	local module="github.com/Gentleman-Programming/engram/v3"
	local pkg="$module/cmd/engram@latest"

	if ! GOPRIVATE="$module" \
		GONOSUMDB="$module" \
		GONOPROXY="$module" \
		go install "$pkg"; then
		print -u2 "engram_update: go install $pkg failed"
		return 1
	fi

	# 2. Locate the built binary (honors `go env -w GOBIN`).
	local gobin gopath src
	gobin="$(go env GOBIN)"
	gopath="$(go env GOPATH)"
	src="${gobin:-$gopath/bin}/engram"

	if [[ ! -x "$src" ]]; then
		print -u2 "engram_update: missing $src"
		return 1
	fi

	# 3. Publish atomically so a running MCP server is never truncated.
	local dest="$HOME/.local/bin/engram"
	mkdir -p "${dest:h}"

	if [[ -e "$dest" ]] && [[ "$src" -ef "$dest" ]]; then
		"$dest" version
		return 0
	fi

	if [[ -e "$dest" ]] && ! cp -p "$dest" "${dest}.bak"; then
		print -u2 "engram_update: backup to ${dest}.bak failed"
		return 1
	fi

	local tmp="${dest}.$$.tmp"
	if ! cp -p "$src" "$tmp"; then
		rm -f "$tmp"
		print -u2 "engram_update: copy to $tmp failed"
		return 1
	fi
	if ! chmod 755 "$tmp"; then
		rm -f "$tmp"
		print -u2 "engram_update: chmod $tmp failed"
		return 1
	fi
	if ! mv -f "$tmp" "$dest"; then
		rm -f "$tmp"
		print -u2 "engram_update: move to $dest failed (backup at ${dest}.bak)"
		return 1
	fi

	# 4. Verify the installed file, not whatever PATH resolves.
	"$dest" version

	local resolved
	resolved="$(command -v engram)"
	if [[ "$resolved" != "$dest" ]]; then
		print -u2 "engram_update: warning: PATH resolves engram to $resolved, not $dest"
	fi
}

# @description Run npm, ask to use vp instead for install, run, exec, dlx.
# @example `npm install`
function npm {
	case "${1:-}" in
	install | i | run | exec | dlx)
		if [[ -o interactive && -t 0 && -t 1 ]] && command -v vp >/dev/null 2>&1; then
			local ans
			read -r "ans?Use vp instead? [y/N] "
			if [[ "$ans" == [Yy]* ]]; then
				command vp "$@"
				return $?
			fi
		fi
		;;
	esac
	command npm "$@"
}

# @description Run npx, ask to use vpx instead.
# @example `npx prettier --check .`
function npx {
	if [[ -o interactive && -t 0 && -t 1 ]] && command -v vpx >/dev/null 2>&1; then
		local ans
		read -r "ans?Use vpx instead? [y/N] "
		if [[ "$ans" == [Yy]* ]]; then
			command vpx "$@"
			return $?
		fi
	fi
	command npx "$@"
}

# @description Index ~/w projects into zoxide so `z <name>` works without visiting first.
# Indexes group/project dirs (depth <= 2) plus nested git repos at depth 3.
# Only adds dirs missing from the db, so ranks of visited dirs never inflate.
# @example `zindex-w` or `zindex-w ~/w`
function zindex-w {
	emulate -L zsh
	local root="${1:-$HOME/w}"
	[[ -d "$root" ]] || return 0
	command -v zoxide >/dev/null 2>&1 || return 0

	local -A seen
	local line
	while IFS= read -r line; do
		[[ -n "$line" ]] && seen[${line%/}]=1
	done < <(zoxide query -l 2>/dev/null)

	local -a candidates
	if command -v fd >/dev/null 2>&1; then
		local -a top
		top=(${(f)"$(fd -t d --max-depth 2 -E node_modules -E .git -E target -E __pycache__ -E .venv -E venv . "$root" 2>/dev/null)"}")
		candidates+=("${top[@]}")
		local dir
		local -a nested
		nested=(${(f)"$(fd -t d --exact-depth 3 -E node_modules -E .git -E target -E __pycache__ -E .venv -E venv . "$root" 2>/dev/null)"}")
		for dir in "${nested[@]}"; do
			[[ -e "${dir%/}/.git" ]] && candidates+=("$dir")
		done
	else
		while IFS= read -r line; do
			candidates+=("$line")
		done < <(find "$root" -maxdepth 2 -type d \
			-not -path '*/node_modules*' \
			-not -path '*/.git*' \
			-not -path '*/target*' \
			-not -path '*/__pycache__*' \
			-not -path '*/.venv*' 2>/dev/null)
		while IFS= read -r line; do
			[[ -e "${line%/}/.git" ]] && candidates+=("$line")
		done < <(find "$root" -mindepth 3 -maxdepth 3 -type d \
			-not -path '*/node_modules*' \
			-not -path '*/.git*' \
			-not -path '*/target*' \
			-not -path '*/__pycache__*' \
			-not -path '*/.venv*' 2>/dev/null)
	fi

	local -a missing
	local dir
	for dir in "${candidates[@]}"; do
		dir=${dir%/}
		[[ -n "$dir" && -z "${seen[$dir]}" ]] && missing+=("$dir")
	done

	if (( ${#missing[@]} )); then
		zoxide add "${missing[@]}"
	fi
}

# Keep ~/w indexed for zoxide. Async so shell start never blocks.
# Manual refresh: `zindex-w`.
zindex-w >/dev/null 2>&1 &!
