#!/usr/bin/env bash

# Colors are available thankfully to [status2d DWM patch](https://dwm.suckless.org/patches/status2d)
# Load the colorscheme
. ~/.config/dwm/status-bar/themes/dicom

# Returns 0 if is connected, and 2 if isn't connected
function _has_connection() {
	ping -c 1 -W 1 google.com >/dev/null 2>&1
	return $?
}

function _packages_updates() {
	if ! _has_connection; then
		return
	fi

	local updates=$(checkupdates | wc -l) # `pacman-contrib` is required
	if [[ $updates -gt 0 ]]; then
		printf ""
	fi

}

function _connection() {
	if ! _has_connection; then
		printf "󰖪"
	fi
}

function _volume() {
	is_mute=$(pamixer --get-mute)

	if [ "$is_mute" = "true" ]; then
		printf "^c$palette0^󰖁 --%%"
	else
		vol=$(pamixer --get-volume)
		printf "^c$palette0^󰕾 %02d%%" "$vol"
	fi
}

function _cpu() {
	cpu=$(top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2)}')
	printf "^c$palette1^ %s" "$cpu"
}

function _memory() {
	memory=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
	printf "^c$palette2^ %s" "$memory"
}

function _disk() {
	disk=$(df -h | awk '$NF=="/"{printf "%s", $5}')
	printf "^c$palette3^󰋊 %s" "$disk"
}

function _date_time() {
	printf "^c$palette4^󱛡 %s ^c$palette5^%s:^c$palette4^%s " "$(date '+W%V %a %Y-%m-%d')" "$(date -u '+%H')" "$(date '+%H:%M:%S')"
}

function _test() {
	while true; do
		sleep 1 && echo "$packages_updates$connection  $(_volume) $(_cpu) $(_memory) $(_disk)  $(_date_time)"
	done
}

function main() {
	INTERVAL=0

	while true; do
		[ $INTERVAL = 0 ] || [ $((INTERVAL % 60)) = 0 ] && packages_updates=$(_packages_updates)
		[ $INTERVAL = 0 ] || [ $((INTERVAL % 60)) = 0 ] && connection=$(_connection)
		INTERVAL=$((INTERVAL + 1))

		sleep 1 && xsetroot -name "$packages_updates$connection  $(_volume) $(_cpu) $(_memory) $(_disk)  $(_date_time)"
	done
}

main
