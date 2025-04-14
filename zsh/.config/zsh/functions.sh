#!/usr/bin/env bash

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
