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
    ([mod], "q", lazy.window.kill()),

    # Switch focus of monitors
    ([mod], "period", lazy.next_screen()),
    ([mod], "comma", lazy.prev_screen()),

    # Restart Qtile
    ([mod, "control"], "r", lazy.reload_config()),

    # Shutdown Qtile
    ([mod, "control"], "q", lazy.shutdown()),

    # ------------ App Configs ------------

    # Menu
    ([mod], "m", lazy.spawn("rofi -show drun")),

    # Window Nav
    ([mod, "shift"], "m", lazy.spawn("rofi -show window")),

    # Emoji
    ([mod, "shift"], "e", lazy.spawn("rofi -show emoji")),

    # Browsers
    ([mod], "w", lazy.spawn("brave")),
    ([mod], "g", lazy.spawn("chromium")),

    # Shutdown PC
    ([mod, "control"], "s", lazy.spawn("shutdown now")),

    # Database manager
    ([mod], "d", lazy.spawn("beekeeper-studio")),

    # Rest client
    ([mod], "p", lazy.spawn("postman")),

    # File Explorer
    ([mod], "e", lazy.spawn("pcmanfm")),

    # Terminal
    ([mod], "Return", lazy.spawn("wezterm")),

    # Redshift
    ([mod], "r", lazy.spawn("redshift -O 6000")),
    ([mod, "shift"], "r", lazy.spawn("redshift -x")),

    # Screenshot
    ([mod], "s", lazy.spawn("flameshot gui")),
    ([mod, "shift"], "s", lazy.spawn("scrot -u -d 3")),

    # ------------ hardware configs ------------

    # Volume
    ([], "XF86AudioLowerVolume", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ -2%"
    )),
    # ([mod], "o", lazy.spawn(
    #     "pactl set-sink-volume @DEFAULT_SINK@ -2%"
    # )),
    ([], "XF86AudioRaiseVolume", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ +2%"
    )),
    # ([mod], "p", lazy.spawn(
    #     "pactl set-sink-volume @DEFAULT_SINK@ +2%"
    # )),
    ([], "XF86AudioMute", lazy.spawn(
        "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    )),

    # Brightness
    ([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +2%")),
    ([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 2%-")),
]]
