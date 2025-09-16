/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"JetBrains Mono:size=11:weight=medium",
	"Symbols Nerd Font Mono:size=11",
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*      	 fg,        bg        */
	[SchemeNorm] = { "#e0def4", "#232136" }, /* SchemeNorm → default item colors. */
	[SchemeOut]  = { "#232136", "#9ccfd8" }, /* SchemeOut → marked item colors (multi-selection mode). */
	[SchemeSel]  = { "#2a283e", "#9ccfd8" }, /* SchemeSel → active/selected item colors. */
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
