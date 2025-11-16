/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 1;                    /* -c option; centers dmenu on screen */
static int min_width = 500;                    /* minimum width when centered */
static const float menu_height_ratio = 2.0f;  /* This is the ratio used in the original calculation */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
  "Maple Mono NF:size=12",
	"Symbols Nerd Font Mono:size=11",
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*      	 fg,        bg        */
	[SchemeNorm] = { "#d4be98", "#282828" }, /* SchemeNorm → default item colors. */
	[SchemeOut]  = { "#d4be98", "#45403d" }, /* SchemeOut → marked item colors (multi-selection mode). */
	[SchemeSel]  = { "#d4be98", "#45403d" }, /* SchemeSel → active/selected item colors. */
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
