# Qtile Config File
# http://www.qtile.org/

# Antonio Sarosi
# https://youtube.com/c/antoniosarosi
# https://github.com/antoniosarosi/dotfiles
from libqtile import hook

from settings.keys import mod, keys
from settings.groups import groups
from settings.layouts import layouts, floating_layout
from settings.widgets import widget_defaults, extension_defaults
from settings.screens import screens
from settings.mouse import mouse
from settings.path import qtile_path

from os import path
import subprocess
import os


@hook.subscribe.startup_once
def autostart():
    subprocess.call([path.join(qtile_path, "autostart.sh")])
    # os.system("xrandr --output eDP1 --primary --mode 1366x768 --pos 277x1080 --rotate normal --output DP1 --off --output HDMI1 --off --output HDMI2 --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off & feh --no-fehbg --bg-scale /home/nikola/Downloads/wallpaperbetter.com_7680x4320.jpg &").layout.restart()


main = None
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = "urgent"
wmname = "Nikola"
