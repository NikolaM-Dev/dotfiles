#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Open with nvim and launch telescope with smart open
# ------------------------------------------------------------------------------
function _open_with_nvim() {
  nvim -c ':Telescope smart_open theme=dropdown previewer=false'
}

zle -N _open_with_nvim
bindkey '^V' _open_with_nvim
# ------------------------------------------------------------------------------
