#!/usr/bin/env bash

# TODO: Add docs
function create_repo {
	# Check if a repository name is provided
	if [ -z "$1" ]; then
		echo "Error: Repository name is required."
		return 1
	fi

	# Check if the current directory is a Git repository
	if [ ! -d ".git" ]; then
		git init
	fi

	# Try to create the repository with GitHub CLI
	gh repo create "$1" --public --source=. --remote=origin
	if [ $? -ne 0 ]; then
		echo "Error: Failed to create the repository on GitHub."
		return 1
	fi

	echo "Repository '$1' created successfully and linked to the current directory."
}

# TODO: Add docs
function bk {
	mv --interactive $1 $1.bak
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
	curl https://ollama.ai/install.sh | sh
}

function rclone_serve() {
	port=":8080"
	echo "http://localhost$port"
	rclone serve http encrypted_google_drive: --addr "$port"
}

function yupdate() {
	if ! yay -Syu $@; then
		echo "\n  [ERROR] Update failed"
		return 1
	else
		yay -Sc --noconfirm
	fi

	n-packages
}

function _backup_data() {
	# Backup second brain
	cd $SECOND_BRAIN_PATH
	n-backup-commit --stage-all
	bun run format:fix
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

function ssn() {
	if pgrep -f "Minecraft" >/dev/null; then
		echo "Minecraft is running. Please stop it before shutting down the system."
		return 1
	fi

	_backup_data

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
	xdg-open https://mail.google.com/mail/u/0/#inbox
	xdg-open https://mail.google.com/mail/u/1/#inbox
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

function schange-date {
	if [ $# -eq 1 ]; then
		local hour=$(date +%H:%M:%S)
		sudo timedatectl set-ntp 0 && sudo timedatectl set-time "$1 $hour"
	else
		echo "Use: schange-date <yyyy-MM-dd>"
		exit 1
	fi
}
