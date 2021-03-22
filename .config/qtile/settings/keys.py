# Antonio Sarosi
# Nikola-Dev
# https://youtube.com/c/antoniosarosi
# https://github.com/antoniosarosi/dotfiles

# Qtile keybindings

from libqtile.config import Key
from libqtile.command import lazy


mod = "mod4"

keys = [Key(key[0], key[1], *key[2:]) for key in [
    # ------------ Window Configs ------------

    # Switch between windows in current stack pane
    ([mod], "j", lazy.layout.down()),
    ([mod], "k", lazy.layout.up()),
    ([mod], "h", lazy.layout.left()),
    ([mod], "l", lazy.layout.right()),

    # Change window sizes (MonadTall)
    ([mod, "shift"], "l", lazy.layout.grow()),
    ([mod, "shift"], "h", lazy.layout.shrink()),

    # Toggle floating
    ([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Move windows up or down in current stack
    ([mod, "shift"], "j", lazy.layout.shuffle_down()),
    ([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Toggle between different layouts as defined below
    ([mod], "Tab", lazy.next_layout()),
    ([mod, "shift"], "Tab", lazy.prev_layout()),

    # Kill window
    ([mod], "w", lazy.window.kill()),

    # Switch focus of monitors
    ([mod], "comma", lazy.next_screen()),
    ([mod], "comma", lazy.prev_screen()),

    # Restart Qtile
    ([mod, "control"], "r", lazy.restart()),

    # Shutdown Qtile
    ([mod, "control"], "q", lazy.shutdown()),

    # ------------ App Configs ------------

    # Menu
    ([mod], "m", lazy.spawn("rofi -show drun")),

    # Window Nav
    ([mod, "shift"], "m", lazy.spawn("rofi -show")),

    # Browsers
    ([mod], "b", lazy.spawn("firefox")),
    ([mod], "g", lazy.spawn("google-chrome-stable")),

    # Shutdown PC
    ([mod], "a", lazy.spawn("shutdown now")),

    # Terminal + Tmux
    ([mod], "v", lazy.spawn("alacritty -e tmux")),

    # Trello
    ([mod], "t", lazy.spawn("trello")),

    # Notion
    ([mod], "n", lazy.spawn("notion-app")),

    # Figma
    ([mod], "f", lazy.spawn("figma-linux")),

    # Discord
    ([mod], "d", lazy.spawn("discord")),

    # File Explorer
    ([mod], "e", lazy.spawn("pcmanfm")),

    # Terminal
    ([mod], "Return", lazy.spawn("alacritty")),

    # Editor
    ([mod], "i", lazy.spawn("code")),

    # Redshift
    ([mod], "r", lazy.spawn("redshift -O 6000")),
    ([mod, "shift"], "r", lazy.spawn("redshift -x")),

    # Screenshot
    ([mod], "s", lazy.spawn("flameshot gui")),
    ([mod, "shift"], "s", lazy.spawn("scrot -d 3")),

    # ------------ hardware configs ------------

    # Volume
    ([], "XF86AudioLowerVolume", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ -2%"
    )),
    ([mod], "o", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ -2%"
    )),
    ([], "XF86AudioRaiseVolume", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ +2%"
    )),
    ([mod], "p", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ +2%"
    )),
    ([], "XF86AudioMute", lazy.spawn(
        "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    )),

    # Brightness
    ([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +2%")),
    ([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 2%-")),
]]
