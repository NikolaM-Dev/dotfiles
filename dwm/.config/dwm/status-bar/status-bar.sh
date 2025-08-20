#!/usr/bin/env bash

# Colors are available thankfully to [status2d DWM patch](https://dwm.suckless.org/patches/status2d)
# Load the colorscheme
. ~/.config/dwm/status-bar/themes/rose-pine

INTERVAL=0

function _packages_updates() {
	if ping -c 1 google.com &>/dev/null; then
		packages_updates=$(checkupdates | wc -l) # `pacman-contrib` is required
		printf " %02d" $packages_updates
	else
		printf " --"
	fi
}

function _volume() {
	is_mute=$(pamixer --get-mute)

	if [ "$is_mute" = "true" ]; then
		printf "^c$love^  --"
	else
		vol=$(pamixer --get-volume)
		printf "^c$love^  %02d%%" "$vol"
	fi
}

function _cpu() {
	cpu=$(top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2)}')
	printf "^c$gold^  %s" "$cpu"
}

function _memory() {
	memory=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
	printf "^c$iris^  %s" "$memory"
}

function _disk() {
	disk=$(df -h | awk '$NF=="/"{printf "%s", $5}')
	printf "^c$rose^ 󰋊 %s" "$disk"
}

function _date_time() {
	printf "^c$foam^ 󱛡 %s " "$(date '+W%V %a %Y-%m-%d %H:%M:%S')"
}

function main() {
	while true; do
		[ $INTERVAL = 0 ] || [ $((INTERVAL % 60)) = 0 ] && packages_updates=$(_packages_updates)
		INTERVAL=$((INTERVAL + 1))

		sleep 1 && xsetroot -name "$packages_updates $(_volume) $(_cpu) $(_memory) $(_disk) $(_date_time)"
	done
}

main
