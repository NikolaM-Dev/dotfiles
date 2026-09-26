# TODO: Add docs
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

# TODO: Add docs
function bk {
	if [[ $# -ne 1 ]]; then
		printf 'Usage: bk <file>\n' >&2
		return 1
	fi
	mv --interactive "$1" "$1.bak"
}

# TODO: Add docs
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
	git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock" | delta --side-by-side
}

## Change remote to ssh
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

# to <file>: create and open in nvim (replaces the old broken `to` alias)
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

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
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
