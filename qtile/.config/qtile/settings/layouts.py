from libqtile.config import Match
from libqtile import layout
from settings.theme import colors

# Layouts and layout rules


layout_conf = {
    'border_focus': colors['focus'][0],
    'border_width': 1,
    'margin': 0
}

layouts = [
    layout.Max(),
    layout.MonadTall(**layout_conf),
    layout.Matrix(columns=2, **layout_conf),
    # layout.Bsp(**layout_conf),
    # layout.Columns(),
    # layout.MonadWide(**layout_conf),
    # layout.RatioTile(**layout_conf),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

floating_layout = layout.Floating(
    # float_rules=[
    #     {'wmclass': 'confirm'},
    #     {'wmclass': 'dialog'},
    #     {'wmclass': 'download'},
    #     {'wmclass': 'error'},
    #     {'wmclass': 'file_progress'},
    #     {'wmclass': 'notification'},
    #     {'wmclass': 'splash'},
    #     {'wmclass': 'toolbar'},
    #     {'wmclass': 'confirmreset'},
    #     {'wmclass': 'makebranch'},
    #     {'wmclass': 'maketag'},
    #     {'wname': 'branchdialog'},
    #     {'wname': 'pinentry'},
    #     {'wmclass': 'ssh-askpass'},
    # ],
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class='confirmreset'),
        Match(wm_class='makebranch'),
        Match(wm_class='maketag'),
        Match(wm_class='ssh-askpass'),
        Match(title='branchdialog'),
        Match(title='pinentry'),
    ],
    border_focus=colors["color5"][0]
)
