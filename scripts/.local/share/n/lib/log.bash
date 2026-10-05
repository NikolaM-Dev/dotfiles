#!/usr/bin/env bash
# log.bash — shared logging lib for n-* scripts
# XDG: ~/.local/share/n/lib/log.bash
# Usage:
#   source "${XDG_DATA_HOME:-$HOME/.local/share}/n/lib/log.bash"
# Provides: log_info, log_warn, log_error, log_step
# shellcheck disable=SC2034

# guard: prevent double-sourcing
[[ -n "${_N_LOG_BASH:-}" ]] && return 0; _N_LOG_BASH=1

# --- logging ---
if [[ -n "${NO_COLOR:-}" ]]; then
  RED=""; YELLOW=""; GREEN=""; CYAN=""; RESET=""
elif [[ -n "${N_LOG_FORCE_COLOR:-}" ]] || { [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; }; then
  RED=$(tput setaf 1)
  YELLOW=$(tput setaf 3)
  GREEN=$(tput setaf 2)
  CYAN=$(tput setaf 6)
  RESET=$(tput sgr0)
else
  RED=""; YELLOW=""; GREEN=""; CYAN=""; RESET=""
fi

log_info()  { echo -e "${GREEN}[INFO]${RESET} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${RESET} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${RESET} $*" >&2; }
log_step()  { echo -e "${CYAN}[INFO]${RESET} $*"; }
