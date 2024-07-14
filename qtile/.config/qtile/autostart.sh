#!/bin/sh

# envs
export QT_STYLE_OVERRIDE=kvantum

# Remove suspend
xset -dpms
xset s noblank
xset s off

# Daemons
# n-backup-second-brain &
# rclone mount google-drive: ~/Documents/drive &
flameshot &
nm-applet &
picom -b --config ~/.config/picom/picom.conf &
sh .fehbg &
udiskie -t &

# systray battery icon
# cbatticon -u 5 &
# systray volume
# volumeicon &
