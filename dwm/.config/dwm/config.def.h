/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 1;        /* border pixel of windows */
static const unsigned int snap     = 32;       /* snap pixel */
static const int showbar           = 1;        /* 0 means no bar */
static const int topbar            = 1;        /* 0 means bottom bar */
static const char *fonts[]         = { "Maple Mono NF:size=10" };
static const char dmenufont[]      = "Maple Mono NF:size=10";
static const char col_gray1[]      = "#222222";
static const char col_gray2[]      = "#444444";
static const char col_gray3[]      = "#bbbbbb";
static const char col_gray4[]      = "#eeeeee";
static const char col_cyan[]       = "#005577";
static const char *colors[][3]     = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title

	   	xprop | awk '
	  		/^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/, "\nclass:"); print}
          	        /^WM_NAME/{sub(/.* =/, "title:"); print}'

	 */

	/* class      instance    title       tags mask     isfloating   monitor */
	{ "obsidian", "obsidian",  NULL, 1 << 1, 0, -1 },
	{ "ticktick", "ticktick",  NULL, 1 << 1, 0, -1 },
};

/* layout(s) */
static const float mfact        = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster        = 1;    /* number of clients in master area */
static const int resizehints    = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[M]",      monocle },
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]   = { "dmenu_run",   "-m",    dmenumon,       "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *browsercmd[] = { "zen-browser", NULL };
static const char *emojiscmd[]  = { "rofi",       "-show", "emoji",        NULL };
static const char *menucmd[]    = { "rofi",        "-show", NULL };
static const char *termcmd[]    = { "ghostty",     "-e",    "n-start-tmux", NULL };

static const Key keys[] = {
	// modifier,          key,       function,        argument,
	// Term + n-start-tmux
	{ MODKEY,             XK_Return, spawn,      {.v = term } },

	// [Q]uit window
	{ MODKEY,             XK_q,      killclient, {0} },

	// [Q]uit DWM
	{ MODKEY|ControlMask, XK_q,      quit,       {0} },

	// [R]estart DWM
	{ MODKEY|ControlMask, XK_r,      quit,       {1} },

	// Toggle [B]ar
	{ MODKEY,             XK_b,      togglebar,  {0} },

	// Next Window
	{ MODKEY,             XK_j,      focusstack, {.i = +1 } },
	// Previous Window
	{ MODKEY,             XK_k,      focusstack, {.i = -1 } },

	{ MODKEY,             XK_h,      setmfact,   {.f = -0.05 } },
    	{ MODKEY,             XK_l,      setmfact,   {.f = +0.05 } },

	// Rofi [M]enu
	{ MODKEY,             XK_m,      spawn,      {.v = menu } },
	// [O]bsidian
	{ MODKEY,             XK_o,      spawn,      SHCMD("obsidian") },
	// [T]ickTick
	{ MODKEY,             XK_t,      spawn,      SHCMD("ticktick") },
	// [Z]en Broser
	{ MODKEY,             XK_z,      spawn,      SHCMD("zen-browser") },
	// [R]edshift
	{ MODKEY,             XK_r,      spawn,      SHCMD("redshift -O 3500") },
	// [R]estart Redshift
    	{ MODKEY|ShiftMask,   XK_r,      spawn,      SHCMD("redshift -x") },
	// File [E]xplorer
    	{ MODKEY,             XK_e,      spawn,      SHCMD("pcmanfm") },
	// Rofi [E]moji
    	{ MODKEY|ControlMask, XK_e,      spawn,      {.v = emojis} },
	// Use Layout 1
	{ MODKEY,             XK_u,      setlayout,  {.v = &layouts[0] } },       // doubledeck
	// Use Layout 2
    	{ MODKEY | ShiftMask, XK_u,      setlayout,  {.v = &layouts[1] } },       // monocle

	// Cycle layouts
	// { MODKEY, 			XK_Tab,    cyclelayout,    {.i = +1} },
	// { MODKEY|ShiftMask, 		XK_Tab,    cyclelayout,    {.i = -1} },



	// { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	// { MODKEY,                       XK_b,      togglebar,      {0} },
	// { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	// { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	// { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	// { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	// { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	// { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	// { MODKEY|ShiftMask,		XK_Return, zoom,           {0} },
	// { MODKEY,                       XK_Tab,    view,           {0} },
	// { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	// { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	// { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	// { MODKEY,                       XK_space,  setlayout,      {0} },
	// { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	// { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	// { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	// { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	// { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	// { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	// { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

	// Go to [n] tag
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = term } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

