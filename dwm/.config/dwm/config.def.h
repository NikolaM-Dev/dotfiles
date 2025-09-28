/* See LICENSE file for copyright and license details. */

/* appearance */
static const int showbar           = 1;    /* 0 means no bar */
static const int topbar            = 1;    /* 0 means bottom bar */
static const unsigned int borderpx = 1;    /* border pixel of windows */
static const unsigned int snap     = 32;   /* snap pixel */

static const int horizpadbar = 2;   /* horizontal padding for statusbar */
static const int vertpadbar  = 8;   /* vertical padding for statusbar */

static const char *fonts[]    = { "JetBrains Mono:size=10:weight=medium", "Symbols Nerd Font Mono:size=10" };

static const char *colors[][3] = {
	/*               fg,        bg,        border */
	[SchemeNorm] = { "#6e6a86", "#232136", "#2a283e" },
	[SchemeSel]  = { "#e0def4", "#232136", "#56526e"  },
};

/* Systray */
static const int showsystray             = 1;   /* 0 means no systray */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */


/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const int ulineall              = 0;   /* 1 to show underline on all tags, 0 for just the active ones */
static const unsigned int ulinepad     = 5;   /* horizontal padding between the underline and tag */
static const unsigned int ulinestroke  = 2;   /* thickness / height of the underline */
static const unsigned int ulinevoffset = 0;   /* how far above the bottom of the bar the line should appear */

static const char *tagsel[][2] = {
	/* fg,       bg */
	{ "#eb6f92", "#232136" },
	{ "#f6c177", "#232136" },
	{ "#c4a7e7", "#232136" },
	{ "#9ccfd8", "#232136" },
	{ "#ea9a97", "#232136" },
	{ "#95b1ac", "#232136" },
	{ "#3e8fb0", "#232136" },
	{ "#eb6f92", "#232136" },
	{ "#f6c177", "#232136" },
};

static const Rule rules[] = {
	/* DOCS: [DWM Rules](https://dwm.suckless.org/customisation/rules) */

	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 *
	 * Use `n-dwm-xprop` instead
	 */

	/* class,          instance,        title, tags mask, isfloating, monitor */
	{ "Pcmanfm",       "pcmanfm",       NULL,  0,         1,          -1 },
	{ "Qalculate-gtk", "qalculate-gtk", NULL,  0,         1,          -1 },
	{ "Zotero",        "Zotero",        NULL,  1 << 1,    1,          -1 },
	{ "ticktick",      "ticktick",      NULL,  1 << 1,    1,          -1 },
};

/* layout(s) */
static const float mfact        = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol, arrange function */
	{ "[M]",   monocle },
	{ "[]=",   tile },    /* first entry is default */
	{ "><>",   NULL },    /* no layout function means floating behavior */
};

/* key definitions */
#include <X11/XF86keysym.h>
#include "movestack.c"

#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2]       = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon,  NULL };

static const char *browsercmd[]    = { "zen-browser",                    NULL };
static const char *emojiscmd[]     = { "rofi",                           "-show", "emoji",        NULL };
static const char *flameshotcmd[]  = { "flameshot",                      "gui",   NULL };
static const char *menucmd[]       = { "rofi",                           "-show", NULL };
static const char *modrinth[]      = { "modrinth-app",                   NULL };
static const char *obsidian[]      = { "obsidian",                       NULL };
static const char *rofi_calc_cmd[] = { "rofi",                           "-show", "calc",         "-modi", "calc", "-no-show-match", "-no-sort", "-no-sort", "echo '{result}' | xsel -b", NULL };
static const char *termcmd[]       = { "ghostty",                        "-e",    "n-start-tmux", NULL };
static const char *ticktick[]      = { "ticktick",                       NULL };
static const char *zotero[]        = { "zotero",                         NULL };
static const char *stayfreecmd[]   = { "/opt/StayFree/stayfree-desktop", NULL };

Autostarttag autostarttaglist[] = {
	{.cmd = NULL,        .tags = 0 },
	{.cmd = browsercmd,  .tags = 1 << 0 },
	{.cmd = ticktick,    .tags = 1 << 1 },
	{.cmd = obsidian,    .tags = 1 << 1 },
	{.cmd = termcmd,     .tags = 1 << 2 },
	{.cmd = zotero,      .tags = 1 << 3 },
	{.cmd = stayfreecmd, .tags = 1 << 5 },
};

static const Key keys[] = {
	/* modifier,           key,                      function,       argument */
	{ MODKEY,              XK_m,                     spawn,          {.v = menucmd } },
	{ MODKEY,              XK_Return,                spawn,          {.v = termcmd } },
	{ MODKEY,              XK_u,                     setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,    XK_u,                     setlayout,      {.v = &layouts[1]} },
	{ MODKEY,              XK_f,                     setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ControlMask,  XK_q,                     quit,           {0} },
	{ MODKEY|ControlMask,  XK_r,                     spawn,          SHCMD("n-dwm-recompile") },
	{ MODKEY|ShiftMask,              XK_b,                     togglebar,      {0} },
	{ MODKEY,              XK_b,                     spawn, SHCMD("n-dm-bookmarks")       },
	{ MODKEY,              XK_q,                     killclient,     {0} },
	{ MODKEY,              XK_c,                     spawn,          {.v = rofi_calc_cmd } },
	{ MODKEY,              XK_o,                     spawn,          {.v = obsidian } },
	{ MODKEY,              XK_s,                     spawn,          {.v = flameshotcmd } },
	{ MODKEY,              XK_t,                     spawn,          {.v = ticktick } },
	{ MODKEY,              XK_z,                     spawn,          {.v = browsercmd } },
	{ MODKEY|ControlMask,  XK_z,                     spawn,          {.v = zotero } },
	{ MODKEY|ShiftMask,    XK_e,                     spawn,          {.v = emojiscmd } },

	{ MODKEY,              XK_r,                     spawn,          SHCMD("redshift -O 3500") },
	{ MODKEY,              XK_e,                     spawn,          SHCMD("pcmanfm") },
	{ MODKEY|ShiftMask,    XK_r,                     spawn,          SHCMD("redshift -x") },
	{ MODKEY|ShiftMask,    XK_s,                     spawn,          SHCMD("scrot -d 3") },

	// Volume
	{ 0,                   XF86XK_AudioLowerVolume,  spawn,          SHCMD("pactl set-sink-volume @DEFAULT_SINK@ -2%") },
	{ 0,                   XF86XK_AudioMute,         spawn,          SHCMD("pactl set-sink-mute @DEFAULT_SINK@ toggle") },
    	{ 0,                   XF86XK_AudioRaiseVolume,  spawn,          SHCMD("pactl set-sink-volume @DEFAULT_SINK@ +2%") },

	// Brightness
	{ 0,                   XF86XK_MonBrightnessDown, spawn,          SHCMD("brightnessctl set 2%-") },
	{ 0,                   XF86XK_MonBrightnessUp,   spawn,          SHCMD("brightnessctl set +2%") },

	// Print
	{ 0,                   XK_Print,                 spawn,          {.v = flameshotcmd } },

	TAGKEYS(XK_1,          0)
	TAGKEYS(XK_2,          1)
	TAGKEYS(XK_3,          2)
	TAGKEYS(XK_4,          3)
	TAGKEYS(XK_5,          4)
	TAGKEYS(XK_6,          5)
	TAGKEYS(XK_7,          6)
	TAGKEYS(XK_8,          7)
	TAGKEYS(XK_9,          8)

	{ MODKEY,              XK_j,                     focusstack,     {.i = +1 } },
	{ MODKEY,              XK_k,                     focusstack,     {.i = -1 } },
	{ MODKEY,              XK_i,                     incnmaster,     {.i = +1 } },
	{ MODKEY,              XK_d,                     incnmaster,     {.i = -1 } },
	{ MODKEY,              XK_h,                     setmfact,       {.f = -0.05} },
	{ MODKEY,              XK_l,                     setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,    XK_j,                     movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,    XK_k,                     movestack,      {.i = -1 } },
	// { MODKEY,           XK_Return,                zoom,           {0} },
	{ MODKEY,              XK_Tab,                   view,           {0} },
	// { MODKEY,           XK_t,                     setlayout,      {.v = &layouts[0]} },
	// { MODKEY|ShiftMask, XK_t,                     setlayout,      {.v = &layouts[1]} },
	// { MODKEY,           XK_m,                     setlayout,      {.v = &layouts[2]} },
	// { MODKEY,           XK_f,                     setlayout,      {.v = &layouts[2]} },
	{ MODKEY,              XK_space,                 setlayout,      {0} },
	{ MODKEY|ShiftMask,    XK_space,                 togglefloating, {0} },
	{ MODKEY,              XK_0,                     view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,    XK_0,                     tag,            {.ui = ~0 } },
	{ MODKEY,              XK_comma,                 focusmon,       {.i = -1 } },
	{ MODKEY,              XK_period,                focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,    XK_comma,                 tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,    XK_period,                tagmon,         {.i = +1 } },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

