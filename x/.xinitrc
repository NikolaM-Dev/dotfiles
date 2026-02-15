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
n-remove-system-suspend

# Daemons
flameshot &
nm-applet &
picom -b --config $HOME/.config/picom/picom.conf &
sh $HOME/.fehbg &
udiskie -t &
dunst &
copyq &
$SECOND_BRAIN_PATH/jobs.sh &
n-backup &
n-eyes &
n-redshift &
n-just-start-or-keep-going &
opencode web &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

n-dwm-start
