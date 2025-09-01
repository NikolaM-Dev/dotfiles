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
	if ! yay -Syu; then
		echo "\n  [ERROR] Update failed"
		return 1
	else
		yay -Sc --noconfirm
	fi
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
	xdg-open https://keep.google.com/u/0/#home
}

function ttimer() {
	timer $1 --format 24h -n $2 && notify-send "⏰ $2 is Done" && mpv --loop --volume=200 ~/backups/20250724T085024--iphone-radar-alarm__phone.mp3
}
