#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# envs
# export QT_STYLE_OVERRIDE=kvantum
export QT_STYLE_OVERRIDE=""

# Remove suspend
n-remove-system-suspend &

# Daemons
flameshot &
nm-applet &
picom -b --config $HOME/.config/picom/picom.conf &
sh $HOME/.fehbg &
udiskie -t &
dunst &
copyq &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

## Custom scripts
n-backup &
# "${SECOND_BRAIN_PATH}/backup/linux/backup.sh" &
n-eyes &
n-redshift &
n-just-start-or-keep-going &
n-boogie-woogie &

# stagger heavy Electron/AppImage apps (avoids startup storm that freezes dwm)
(sleep 2 && vesktop) &
(sleep 4 && zen-browser) &
(sleep 6 && obsidian) &
(sleep 8 && handy) &
(sleep 10 && stayfree) &

exec n-dwm-start
