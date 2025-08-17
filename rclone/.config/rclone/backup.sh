#!/usr/bin/env bash

DEST="encrypted_google_drive:"
FILTER_FILER="$HOME/.config/rclone/filter.conf"
SOURCE="$HOME"

function main() {
	rclone sync --update --verbose --transfers 30 --checkers 8 \
		--contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 \
		--stats 30s --filter-from "$FILTER_FILER" \
		--delete-excluded "$SOURCE" "$DEST"
}

main
