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
	[SchemeNorm] = { "#717171", "#1b1b1b", "#1b1b1b" },
	[SchemeSel]  = { "#717171", "#1b1b1b", "#717171"  },
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
	{ "#bb7c72", "#1b1b1b" },
	{ "#6d956f", "#1b1b1b" },
	{ "#9f8a51", "#1b1b1b" },
	{ "#758fc1", "#1b1b1b" },
	{ "#6196a0", "#1b1b1b" },
	{ "#a185b6", "#1b1b1b" },
	{ "#bb7c72", "#1b1b1b" },
	{ "#6d956f", "#1b1b1b" },
	{ "#9f8a51", "#1b1b1b" },
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
	{ "Zotero",        "Zotero",        NULL,  0,         1,          -1 },
	{ "ticktick",      "ticktick",      NULL,  0,         0,          -1 },
  { "StayFree",      "stayfree",      NULL,  1 << 7,    0,          -1 },
  { "feh",           "feh",           NULL,  0,         1,          -1 },
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

static const char *browser[]   = { "zen-browser", NULL };
static const char *emojis[]    = { "rofi",        "-show", "emoji", NULL };
static const char *flameshot[] = { "flameshot",   "gui",   NULL };
static const char *menu[]      = { "rofi",        "-show", NULL };
static const char *obsidian[]  = { "obsidian",    NULL };
static const char *ticktick[]  = { "ticktick",    NULL };
static const char *zotero[]    = { "zotero",      NULL };
static const char *term[]  = { "ghostty",      NULL };
static const char *term_tmux[]  = { "ghostty", "-e", "n-start-tmux",      NULL };

Autostarttag autostarttaglist[] = {
	{.cmd = NULL,        .tags = 0 },
};

static const Key keys[] = {
	/* modifier,           key,                      function,       argument */
	{ MODKEY,              XK_m,                     spawn,          {.v = menucmd } },
	{ MODKEY,              XK_Return,                spawn,          {.v = termcmd } },
	{ MODKEY,              XK_Return,                spawn,          {.v = term_tmux} },
	{ MODKEY|ShiftMask,    XK_Return,                spawn,          {.v = term} },
	{ MODKEY|ShiftMask,    XK_u,                     setlayout,      {.v = &layouts[1]} },
	{ MODKEY,              XK_f,                     setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ControlMask,  XK_q,                     quit,           {0} },
	{ MODKEY|ControlMask,  XK_r,                     spawn,          SHCMD("n-dwm-recompile") },
	{ MODKEY|ShiftMask,              XK_b,                     togglebar,      {0} },
	{ MODKEY,              XK_b,                     spawn, SHCMD("n-dm-bookmarks")       },
	{ MODKEY,              XK_q,                     killclient,     {0} },
	{ MODKEY,              XK_c,                     spawn,          SHCMD("qalculate-gtk") },
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
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = term } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

