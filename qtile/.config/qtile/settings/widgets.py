import socket
import subprocess
from libqtile.config import KeyChord, Key, Screen, Group, Drag, Click
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from typing import List  # noqa: F401
from libqtile import widget
from settings.theme import colors

myTerm = "wezterm"

base = lambda fg="text", bg="dark": {"foreground": colors[fg], "background": colors[bg]}

separator = lambda: widget.Sep(**base(), linewidth=0, padding=5)

icon = lambda fg="text", bg="dark", fontsize=16, text="?": widget.TextBox(
    **base(fg, bg), fontsize=fontsize, text=text, padding=3
)

powerline = lambda fg="light", bg="dark": widget.TextBox(
    **base(fg, bg), text="", fontsize=37, padding=-2  # Icon: nf-oct-triangle_left
)

powerline2 = lambda fg="light", bg="dark": widget.TextBox(
    **base(fg, bg), text="", fontsize=37, padding=-2  # Icon: nf-oct-triangle_left
)

workspaces = lambda: [
    widget.GroupBox(
        **base(fg="light"),
        font="Maple Mono NF",
        fontsize=19,
        margin_y=3,
        margin_x=0,
        padding_y=8,
        padding_x=5,
        borderwidth=1,
        active=colors["active"],
        inactive=colors["inactive"],
        rounded=False,
        highlight_method = "line",
        urgent_alert_method="block",
        urgent_border=colors["urgent"],
        this_current_screen_border=colors["gradient"],
        this_screen_border=colors["grey"],
        other_current_screen_border=colors["dark"],
        other_screen_border=colors["dark"],
        disable_drag=True,
    ),
    separator(),
]

primary_widgets = [
    *workspaces(),
    separator(),
    widget.CurrentLayoutIcon(**base(bg="focus", fg="active"), scale=0.65),
    widget.CurrentLayout(**base(bg="focus", fg="dark") ),
    separator(),
    widget.WindowName(fmt=''),
    widget.GenPollText(
        fmt=" {} ",
        update_interval=3,
        font="Maple Mono NF",
        func=lambda: subprocess.check_output("/home/nikola/.local/bin/volume")
        .decode("utf-8")
        .replace("\n", ""),
    ),
    widget.TextBox(text='󰥔 ', font='Symbols Nerd Font Mono'),
    widget.Clock(format="%H:%M:%S ╷ %d.%m.%Y | %a ", font='Maple Mono NF'),
    widget.Systray(),
    separator(),
]

secondary_widgets = [
    icon(bg="dark", fontsize=17, text="  ", fg="haskell"),
    *workspaces(),
    separator(),
    icon(fg="color1", text=" "),  # Icon: nf-fa-download
    widget.CheckUpdates(
        colour_have_updates=colors["color1"],
        colour_no_updates=colors["color1"],
        no_update_string="0",
        display_format="{updates}",
        update_interval=1800,
    ),
    widget.CheckUpdates(
        colour_no_updates=colors["color1"],
        colour_have_updates=colors["color1"],
        update_interval=1800,
        distro="Arch_checkupdates",
        no_update_string="0",
        display_format="{updates}",
    ),
    icon(text=" ", fg="color2"),
    widget.CPU(
        format="({load_percent}%)",
        **base(fg="color2"),
        font="UbuntuMono Nerd Font",
        fontsize=17,
        update_interval=1.5,
    ),
    icon(text="  ", fg="color3"),
    widget.Memory(
        font="UbuntuMono Nerd Font",
        **base(fg="color3"),
        format='{MemUsed}M/{MemTotal}M',
        fontsize=17),
    widget.Net(**base(fg="color4"),
               interface="enp2s0",
               format="  {up}  {down}",
               update_interval=3),
    widget.GenPollText(
        **base(fg="color5"),
        update_interval=60,
        fmt=" {}",
        font="UbuntuMono Nerd Font",
        fontsize=17,
        func=lambda: subprocess.check_output("/home/nikola/.local/bin/battery")
        .decode("utf-8")
        .replace("\n", ""),
    ),
    widget.GenPollText(
        **base(fg="color6"),
        update_interval=3,
        fmt=" {}",
        font="UbuntuMono Nerd Font",
        fontsize=17,
        func=lambda: subprocess.check_output("/home/nikola/.local/bin/brightness")
        .decode("utf-8")
        .replace("\n", ""),
    ),
    widget.GenPollText(
        **base(fg="color4"),
        fmt=" {}",
        update_interval=3,
        font="UbuntuMono Nerd Font",
        fontsize=17,
        func=lambda: subprocess.check_output("/home/nikola/.local/bin/volume")
        .decode("utf-8")
        .replace("\n", ""),
    ),
    icon(fg="color1", fontsize=17, text="  "),  # Icon: nf-mdi-calendar_clock
    widget.Clock(**base(fg="color1"), format="%a %d %b %Y %H:%M "),
    powerline2("focus", "dark"),
    widget.CurrentLayoutIcon(**base(bg="focus", fg="active"), scale=0.65),
    widget.CurrentLayout(**base(bg="focus", fg="dark"), padding=5),
]

widget_defaults = {
    "font": "Maple Mono NF",
    "fontsize": 14,
    "padding": 2,
}
extension_defaults = widget_defaults.copy()
